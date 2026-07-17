"""Non-blocking invalid-date warning test; no database required."""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import load  # noqa: E402


class Cursor:
    def __init__(self):
        self.warning_rows = []
    def execute(self, sql, **kwargs):
        self.last_sql = sql
    def fetchall(self):
        return [("DOC_ID", "VARCHAR2"), ("DOC_DATE", "DATE")]
    def executemany(self, sql, rows):
        if "atd_load_row_warning" in sql.lower():
            self.warning_rows.extend(rows)


class Conn:
    def __init__(self):
        self.cur = Cursor()
        self.commits = 0
    def cursor(self):
        return self.cur
    def commit(self):
        self.commits += 1


def main():
    conn = Conn()
    state = {"total": 0, "items": []}
    csv_text = "ID,Date\nA,2026-07-18\nB,31/15/2026\nC,\n"
    n = load.load(conn, csv_text, "PROD.T_DATE", None, "TRUNCATE_INSERT", None,
                  json.dumps({"ID": "DOC_ID", "Date": "DOC_DATE"}),
                  run_id=77, job_name="DATE TEST", warning_state=state)
    assert n == 3
    assert state["total"] == 1 and len(state["items"]) == 1
    warning = state["items"][0]
    assert warning["row_number"] == 3
    assert warning["column_name"] == "DOC_DATE"
    assert warning["raw_value"] == "31/15/2026"
    assert len(conn.cur.warning_rows) == 1
    assert conn.commits == 1
    print("LOAD WARNING TEST PASSED")


if __name__ == "__main__":
    main()
