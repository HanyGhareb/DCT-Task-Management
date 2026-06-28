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
import re

_DEFAULT_CAPS = "25000,50000,65000,75000,100000,250000,500000"

# --- secret scrubbing for stored error text -------------------------------
# A failed Go-URL download raises a Playwright error that dumps the WHOLE request,
# including the `cookie:` header with live Fusion session tokens (JSESSIONID,
# ORA_OCIS_CG_SESSION, _WL_AUTHCOOKIE…). Those are replayable while valid, so scrub
# them out of any message before it is written to ATD_LOAD_RUN_LOG / shown in the UI.
_SCRUB = [
    # a whole "cookie:"/"set-cookie:"/"authorization:" header line value -> [redacted]
    (re.compile(r'((?:^|\n)[ \t-]*(?:cookie|set-cookie|authorization)[ \t]*:[ \t]*)[^\n\r]*',
                re.IGNORECASE), r'\1[redacted]'),
    # individual session-token name=value pairs anywhere (e.g. embedded in a URL)
    (re.compile(r'\b(JSESSIONID|ORA_[A-Z0-9_]+|_WL_AUTHCOOKIE[A-Za-z0-9_]*|idcs-[A-Za-z0-9_]+)='
                r'[^;,&\s"\']+', re.IGNORECASE), r'\1=[redacted]'),
    # bearer tokens
    (re.compile(r'(Bearer[ \t]+)[A-Za-z0-9._\-]+', re.IGNORECASE), r'\1[redacted]'),
]


def scrub(text):
    """Redact session cookies / auth tokens from an error message before storing it."""
    if not text:
        return text
    s = str(text)
    for rx, rep in _SCRUB:
        s = rx.sub(rep, s)
    return s


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
