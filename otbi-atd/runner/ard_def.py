"""AR Invoice Distribution Details : chunked-extract definition (v2, 2026-08-17).

v2 re-authored after the OWNER REDESIGNED the saved analysis (user request
2026-08-17). The analysis now:
- FILTERS the space: Accounting Class IN ('Revenue','Tax') AND Distribution
  Entered Amount IS NOT NULL AND <> 0 AND Natural Account Code NOT IN
  ('120123','120151') -- kept verbatim in EVERY chunk (space shrank from
  ~575k mixed-class rows to the Revenue/Tax non-zero slice).
- REPLACED the old "- Distribution Cost Center / Natural Account Segment
  Value" code+description columns with "- Cost Center Segment Value"."Cost
  Center Description" / "- Natural Account Segment Value"."Account
  Description" and their DESCRIPTOR_IDOFs. PROBED LIVE: IDOF(description) IS
  the segment CODE (4510124 / 324319), so the pairs keep their OLD colmap
  headings/table columns -- downstream consumers see no rename.
- ADDED the GL Account combination (Account Code Combination Description +
  Concatenated Segments), Transaction Line Type, and the 4 Transaction
  Accounting amounts (Accounted/Entered x CR/DR; NOTE the source formula
  "Accounted  Amount CR" carries a DOUBLE SPACE -- verbatim). These 7 are new
  headings: the runner's drift engine ALTER TABLE ADDs their columns and
  extends the colmap on first run.
- DROPPED Alternate Code Combination (stale key cleaned from the colmap) and
  the 2 ORDER-BY-only sort IDOFs (Account Type Code / Line Type).

Chunks partition on the distribution-dim Accounting Date exactly as v1 (NULL
x class + past guard + Dec-2025 x class + null-safe catch-alls + 12 monthly
2026 + >= 2027 tail) but the class splits carry only Revenue/Tax now -- the
filter empties everything else (catch-alls stay as 0-row safety nets).
min_rows 150,000 (re-tighten after the first runs establish the new normal).
Service account (non-catalog source_ref, db/62 path-owner rule bypassed).

Lives on the SEPARATE job 'AR Invoice Distribution Details - V2' (db/71) --
the original '- ALL' job keeps its catalog source_ref, DISABLED, as fallback
(NOT rebuilt for the redesign; rebuild it via the Jobs page before re-use).
"""
SA = '"Receivables - Transactions Real Time"'
# CHUNK ON THE DIM, NEVER THE DETAIL ATTR: chunk predicates on
# "- Transaction Distribution Details"."Accounting Date" (the select-list
# attribute) hang the BI server on the IS NULL / past-guard chunks (two 60-min
# reaped runs 2026-08-18 with ZERO chunks completed); the dimension column
# gets the fast pushdown plan (0-2s/chunk) exactly as in v1.
D = f'{SA}."- Distribution Accounting Date"."Accounting Date"'
C = f'{SA}."- Transaction Distribution Details"."Accounting Class"'
FILT = (f"{C} IN ('Revenue', 'Tax') "
        f'AND {SA}."- Transaction Distributions"."Distribution Entered Amount" IS NOT NULL '
        f'AND {SA}."- Transaction Distributions"."Distribution Entered Amount" <> 0 '
        f'AND {SA}."- Natural Account Segment Value"."Account Code" '
        f"NOT IN ('120123', '120151')")

# (formula-without-SA-prefix, colmap heading) — order = CSV position #2..#36
_COLS = [
    ('"- General Information"."Transaction ID"',                     "Transaction ID"),
    ('"- General Information"."Transaction Number"',                 "Transaction Number"),
    ('"- Line Information"."Transaction Line Number"',               "Transaction Line Number"),
    ('"- Line Information"."Transaction Line Type"',                 "Transaction Line Type"),
    ('"- Transaction Distribution Details"."Accounted"',             "Accounted"),
    ('"- Transaction Distribution Details"."Accounting Class"',      "Accounting Class"),
    ('"- Transaction Distribution Details"."Distribution Percentage"', "Distribution Percentage"),
    ('"- Transaction Distribution Details"."Accounting Date"',       "Accounting Date"),
    ('"- Transaction Distribution Details"."Distribution Comments"', "Distribution Comments"),
    ('"- Transaction Distribution Details"."Posting Control Id"',    "Posting Control Identifier"),
    ('"- Transaction Distribution Details"."GL Posted Date"',        "Posted Date"),
    ('"- Distribution Combination"."Receivables  Code Combination Description"',
     "Receivables  Code Combination Description"),
    ('"- Distribution Combination"."Receivables Concatenated Segments"',
     "Receivables Concatenated Segments"),
    ('"- Distribution Combination"."Account Type Code"',             "Account Type Code"),
    ('"- GL Account"."Account Code Combination Description"',        "GL Account Combination Description"),
    ('"- GL Account"."Concatenated Segments"',                       "GL Concatenated Segments"),
    ('"- Transaction Distributions"."Distribution Entered Amount"',  "Distribution Entered Amount"),
    ('"- Transaction Distributions"."Distribution Accounted Amount"', "Distribution Accounted Amount"),
    ('"- Transaction Accounting"."Accounted  Amount CR"',            "Accounted Amount CR"),
    ('"- Transaction Accounting"."Accounted Amount DR"',             "Accounted Amount DR"),
    ('"- Transaction Accounting"."Entered Amount CR"',               "Entered Amount CR"),
    ('"- Transaction Accounting"."Entered Amount DR"',               "Entered Amount DR"),
    ('"- Transaction Distributions"."Ledger Currency"',              "Ledger Currency"),
    ('"- Transaction Distributions"."Document Currency Name"',       "Document Currency Name"),
    ('IDOF:"- Transaction Distributions"."Document Currency Name"',  "Document Currency"),
    ('"- Reference Information"."Last Update Date"',                 "Invoice Last Update Date"),
    ('"- Reference Information"."Last Updated By"',                  "Last Updated By"),
    ('"- Reference Information"."Last Updated By User Name"',        "Last Updated By User Name"),
    ('"- Reference Information"."Created By User Name"',             "Created By User Name"),
    ('"- Reference Information"."Creation Date"',                    "Creation Date"),
    ('"- Reference Information"."Created By"',                       "Created By"),
    ('IDOF:"- Cost Center Segment Value"."Cost Center Description"', "Distribution Cost Center Code"),
    ('"- Cost Center Segment Value"."Cost Center Description"',      "Distribution Cost Center Description"),
    ('IDOF:"- Natural Account Segment Value"."Account Description"', "Distribution Natural Account Code"),
    ('"- Natural Account Segment Value"."Account Description"',      "Distribution Natural Account Description"),
]


def _expr(col):
    if col.startswith("IDOF:"):
        return f"DESCRIPTOR_IDOF({SA}.{col[5:]})"
    return f"{SA}.{col}"


def build_sql_template():
    sel = ", ".join(f"{_expr(col)} s_{i+1}" for i, (col, _) in enumerate(_COLS))
    return ("SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1'; "
            f"SELECT 0 s_0, {sel} FROM {SA} WHERE ({FILT}) AND ({{chunk}})")


def build_headers():
    # position 1 = the literal '0' column; mapped columns start at 2
    return {f"#{i+2}": name for i, (_, name) in enumerate(_COLS)}


def build_chunks():
    # PLAN-SHAPE LAWS (probed live 2026-08-18, new joins in the SELECT):
    # bounded date-RANGE chunks on the dim get the fast plan (54k rows in 42s);
    # IS NULL and any pre-Dec-2025-reaching range HANG the BI server >100s even
    # when the slice is EMPTY. Both guards are dropped as verified-dead space:
    # the fact has ZERO rows before 2025-12-01 (min(date) = 2025-12-01 exactly)
    # and every NULL-date row fails the analysis' Entered-Amount filter (probe:
    # 0 rows). The class splits are exhaustive by construction -- the embedded
    # filter pins Accounting Class IN (Revenue, Tax). The >= 2027 open tail is
    # fast and covers the future-dated rows (max seen 2028-05-19). min_rows is
    # the safety net if any of these invariants ever breaks.
    REV, TAX = "'Revenue'", "'Tax'"
    dec = f"{D} >= date '2025-12-01' AND {D} < date '2026-01-01'"
    chunks = [
        f"{dec} AND {C} = {REV}",
        f"{dec} AND {C} = {TAX}",
    ]
    months = [f"2026-{m:02d}-01" for m in range(1, 13)] + ["2027-01-01"]
    for a, b in zip(months, months[1:]):
        chunks.append(f"{D} >= date '{a}' AND {D} < date '{b}'")
    chunks.append(f"{D} >= date '2027-01-01'")
    return chunks


def build_params():
    return {"_atd_sql_chunks": {
        "sql": build_sql_template(),
        "chunks": build_chunks(),
        "headers": build_headers(),
        "min_rows": 150000,
        "retries": 1,
        "parallel": 4}}


if __name__ == "__main__":
    import json
    p = build_params()
    print("chunks:", len(p["_atd_sql_chunks"]["chunks"]))
    print(json.dumps(p)[:300])
