#!/usr/bin/env python3
"""Execute a SQLcl-style seed script through python-oracledb.

Intended for the repository's MERGE-bearing report seeds that Linux SQLcl can
silently skip.  Supports PL/SQL blocks terminated by a lone slash and ordinary
SQL statements terminated by a semicolon. SQLcl SET/PROMPT/EXIT lines are
ignored. Connection settings come from the reporting worker environment.
"""
from pathlib import Path
import sys

from config import connect


def statements(text: str):
    buffer = []
    plsql = False
    for raw in text.splitlines():
        stripped = raw.strip()
        upper = stripped.upper()
        if not buffer and (
            not stripped
            or stripped.startswith("--")
            or upper.startswith(("SET ", "PROMPT", "EXIT"))
        ):
            continue
        if not buffer:
            plsql = upper == "DECLARE" or upper == "BEGIN" or upper.startswith("CREATE OR REPLACE")
        if plsql and stripped == "/":
            yield "\n".join(buffer)
            buffer = []
            plsql = False
            continue
        buffer.append(raw)
        if not plsql and stripped.endswith(";"):
            buffer[-1] = raw[: raw.rfind(";")]
            yield "\n".join(buffer)
            buffer = []
    if any(line.strip() for line in buffer):
        raise ValueError("unterminated SQL statement")


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: deploy_seed.py path/to/seed.sql")
    path = Path(sys.argv[1])
    chunks = list(statements(path.read_text(encoding="utf-8-sig")))
    with connect() as connection:
        with connection.cursor() as cursor:
            for number, sql in enumerate(chunks, 1):
                cursor.execute(sql)
                print(f"executed statement {number}/{len(chunks)}")
        connection.commit()


if __name__ == "__main__":
    main()
