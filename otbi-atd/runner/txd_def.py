"""Transaction Distribution - All : chunked-extract definition (single source
of truth for the probe AND the params_json generator).

Clean re-authoring of the saved analysis' logical SQL: exactly the 30 mapped
columns (the saved criteria carried redundant duplicates), positional headers
map (#N) because two logical columns both export as 'Accounting Date'.
Chunks partition the whole space by construction: dim-date IS NULL + a past
guard + Dec-2025 split 4 ways by Accounting Class (null-safe catch-all) +
12 monthly 2026 ranges + an open >= 2027 tail.
"""
SA = '"Receivables - Transactions Real Time"'
D = f'{SA}."- Distribution Accounting Date"."Accounting Date"'
C = f'{SA}."- Transaction Distribution Details"."Accounting Class"'

_COLS = [
    ('"- General Information"."Transaction ID"',                     "Transaction ID"),
    ('"- General Information"."Transaction Number"',                 "Transaction Number"),
    ('"- Line Information"."Unit Of Measure Code"',                  "UOM Code"),
    ('"- Transaction Distribution Details"."Accounted"',             "Accounted"),
    ('"- Transaction Distribution Details"."Accounting Class"',      "Accounting Class"),
    ('"- Transaction Distribution Details"."Distribution Percentage"', "Distribution Percentage"),
    ('"- Transaction Distribution Details"."Accounting Date"',       "Accounting Date"),
    ('"- Transaction Distribution Details"."Distribution Comments"', "Distribution Comments"),
    ('"- Transaction Distribution Details"."GL Posted Date"',        "Posted Date"),
    ('"- Transaction Distribution Details"."Posting Control Id"',    "Posting Control Identifier"),
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
    ('"- Transaction Distributions"."Document Currency"',            "Document Currency"),
    ('"- Distribution Accounting Date"."Month"',                     "Calendar Month"),
    ('"- Reference Information"."Last Updated By"',                  "Last Updated By"),
    ('"- Reference Information"."Last Updated By User Name"',        "Last Updated By User Name"),
    ('"- Reference Information"."Last Update Date"',                 "Invoice Last Update Date"),
    ('"- Reference Information"."Created By"',                       "Created By"),
    ('"- Reference Information"."Created By User Name"',             "Created By User Name"),
    ('"- Reference Information"."Creation Date"',                    "Creation Date"),
    ('"- Distribution Cost Center Segment Value"."Distribution Cost Center Description"',
     "Distribution Cost Center Description"),
    ('"- Distribution Cost Center Segment Value"."Distribution Cost Center Code"',
     "Distribution Cost Center Code"),
    ('"- Distribution Natural Account Segment Value"."Distribution Natural Account Description"',
     "Distribution Natural Account Description"),
    ('"- Distribution Natural Account Segment Value"."Distribution Natural Account Code"',
     "Distribution Natural Account Code"),
]


def build_sql_template():
    sel = ", ".join(f'{SA}.{col} s_{i+1}' for i, (col, _) in enumerate(_COLS))
    return ("SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1'; "
            f"SELECT 0 s_0, {sel} FROM {SA} WHERE ({{chunk}})")


def build_headers():
    # position 1 = the literal '0' column; mapped columns start at 2
    return {f"#{i+2}": map_key for i, (_, map_key) in enumerate(_COLS)}


def build_chunks():
    chunks = [f"{D} IS NULL",
              f"{D} < date '2025-12-01'"]
    for cls in ("Revenue", "Receivable", "Tax"):
        chunks.append(f"{D} >= date '2025-12-01' AND {D} < date '2026-01-01' "
                      f"AND {C} = '{cls}'")
    chunks.append(f"{D} >= date '2025-12-01' AND {D} < date '2026-01-01' "
                  f"AND ({C} NOT IN ('Revenue', 'Receivable', 'Tax') OR {C} IS NULL)")
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
        "min_rows": 300000,
        "retries": 1,
        "parallel": 6}}


if __name__ == "__main__":
    import json
    p = build_params()
    print("chunks:", len(p["_atd_sql_chunks"]["chunks"]))
    print(json.dumps(p)[:400])
