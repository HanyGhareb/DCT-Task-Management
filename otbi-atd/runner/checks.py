"""otbi-atd : data sanity checks.

OTBI/BI Publisher caps the analytics CSV download server-side, so a large
analysis can come back SILENTLY TRUNCATED (a round number of rows, no error).
truncation_note() flags a loaded count that equals a common export cap so the
runner can warn (and notify) instead of quietly storing partial data.

Config:
  ATD_TRUNCATION_CAPS  comma list of suspicious caps
                       (default 25000,50000,65000,75000,100000,250000,500000)
  ATD_EXPECTED_MIN     optional: warn if a load comes back below this many rows
"""
import os

_DEFAULT_CAPS = "25000,50000,65000,75000,100000,250000,500000"


def truncation_note(n):
    """Return a warning string if n looks truncated/capped, else ''."""
    caps = {int(x) for x in os.environ.get("ATD_TRUNCATION_CAPS", _DEFAULT_CAPS).split(",")
            if x.strip().isdigit()}
    if n in caps:
        return (f"WARNING: loaded {n} rows — equals a common OTBI export cap; the analysis "
                "download may be truncated. Raise the OTBI download row limit or verify the "
                "source row count.")
    exp = os.environ.get("ATD_EXPECTED_MIN")
    if exp and exp.isdigit() and n < int(exp):
        return f"WARNING: loaded {n} rows — below expected minimum {exp}; check the source/extract."
    return ""
