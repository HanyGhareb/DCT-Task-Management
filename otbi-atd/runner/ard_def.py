"""AR Invoice Distribution Details - ALL : chunked-extract definition.

Replaces the single-shot personal-account run of the saljaaidi analysis, which
carried `FETCH FIRST 500001 ROWS ONLY` *inside the analysis* — every load was
silently truncated to 500,000 rows of a ~575,000-row space (probed 2026-08-16:
NULL dim-month 101,075 + Dec-2025 170,059 + 2026 monthly <=58,302 + tiny 2027+
tail). Columns re-authored 1:1 from the analysis' own Advanced-tab logical SQL
(29 mapped columns, exact colmap-key headings; 'Document Currency' =
DESCRIPTOR_IDOF of the currency name; the DESCRIPTOR_IDOF(Account Type Code)
sort helper dropped). No analysis filter existed, so chunks alone partition the
space by construction: dim accounting-date NULL x class (Revenue/Unearned
34,008 each, Tax 33,059) + past guard + Dec-2025 x class (Receivable 50,142 /
Revenue 56,049 / Tax 50,375 / Unearned 13,493) + null-safe catch-alls + 12
monthly 2026 ranges + an open >= 2027 tail. min_rows 520,000 proves every run
beats the old 500k cap. Service account (source_ref is a non-catalog token, so
the db/62 path-owner rule no longer selects the personal credential).

Lives on the SEPARATE job 'AR Invoice Distribution Details - V2' (db/71) --
Projects Budget Full - V2 pattern: the original '- ALL' job keeps its catalog
source_ref and stays DISABLED as the fallback.
"""
SA = '"Receivables - Transactions Real Time"'
D = f'{SA}."- Distribution Accounting Date"."Accounting Date"'
C = f'{SA}."- Transaction Distribution Details"."Accounting Class"'

# (formula-without-SA-prefix, colmap heading) — order = CSV position #2..#30
_COLS = [
    ('"- General Information"."Transaction ID"',                     "Transaction ID"),
    ('"- General Information"."Transaction Number"',                 "Transaction Number"),
    ('"- Line Information"."Transaction Line Number"',               "Transaction Line Number"),
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
    ('"- Distribution Combination"."Alternate Code Combination"',    "Alternate Code Combination"),
    ('"- Distribution Combination"."Account Type Code"',             "Account Type Code"),
    ('"- Transaction Distributions"."Distribution Entered Amount"',  "Distribution Entered Amount"),
    ('"- Transaction Distributions"."Distribution Accounted Amount"', "Distribution Accounted Amount"),
    ('"- Transaction Distributions"."Ledger Currency"',              "Ledger Currency"),
    ('"- Transaction Distributions"."Document Currency Name"',       "Document Currency Name"),
    ('IDOF:"- Transaction Distributions"."Document Currency Name"',  "Document Currency"),
    ('"- Reference Information"."Last Update Date"',                 "Invoice Last Update Date"),
    ('"- Reference Information"."Last Updated By"',                  "Last Updated By"),
    ('"- Reference Information"."Last Updated By User Name"',        "Last Updated By User Name"),
    ('"- Reference Information"."Created By User Name"',             "Created By User Name"),
    ('"- Reference Information"."Creation Date"',                    "Creation Date"),
    ('"- Reference Information"."Created By"',                       "Created By"),
    ('"- Distribution Cost Center Segment Value"."Distribution Cost Center Description"',
     "Distribution Cost Center Description"),
    ('"- Distribution Cost Center Segment Value"."Distribution Cost Center Code"',
     "Distribution Cost Center Code"),
    ('"- Distribution Natural Account Segment Value"."Distribution Natural Account Description"',
     "Distribution Natural Account Description"),
    ('"- Distribution Natural Account Segment Value"."Distribution Natural Account Code"',
     "Distribution Natural Account Code"),
]


def _expr(col):
    if col.startswith("IDOF:"):
        return f"DESCRIPTOR_IDOF({SA}.{col[5:]})"
    return f"{SA}.{col}"


def build_sql_template():
    sel = ", ".join(f"{_expr(col)} s_{i+1}" for i, (col, _) in enumerate(_COLS))
    return ("SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1'; "
            f"SELECT 0 s_0, {sel} FROM {SA} WHERE ({{chunk}})")


def build_headers():
    # position 1 = the literal '0' column; mapped columns start at 2
    return {f"#{i+2}": name for i, (_, name) in enumerate(_COLS)}


def build_chunks():
    REV, UNE, TAX, RCV = "'Revenue'", "'Unearned Revenue'", "'Tax'", "'Receivable'"
    null3 = f"({C} NOT IN ({REV}, {UNE}, {TAX}) OR {C} IS NULL)"
    dec4 = f"({C} NOT IN ({REV}, {RCV}, {TAX}, {UNE}) OR {C} IS NULL)"
    dec = f"{D} >= date '2025-12-01' AND {D} < date '2026-01-01'"
    chunks = [
        f"{D} IS NULL AND {C} = {REV}",
        f"{D} IS NULL AND {C} = {UNE}",
        f"{D} IS NULL AND {C} = {TAX}",
        f"{D} IS NULL AND {null3}",
        f"{D} < date '2025-12-01'",
        f"{dec} AND {C} = {REV}",
        f"{dec} AND {C} = {RCV}",
        f"{dec} AND {C} = {TAX}",
        f"{dec} AND {C} = {UNE}",
        f"{dec} AND {dec4}",
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
        "min_rows": 520000,
        "retries": 1,
        "parallel": 4}}


if __name__ == "__main__":
    import json
    p = build_params()
    print("chunks:", len(p["_atd_sql_chunks"]["chunks"]))
    print(json.dumps(p)[:300])
