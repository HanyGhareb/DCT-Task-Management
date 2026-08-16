"""AR Invoice Header - all : chunked-extract definition.

Replaces the single-shot personal-account run of the saljaaidi analysis
(102,277 rows today; the analysis ALSO carries FETCH FIRST 500001 ROWS ONLY --
harmless at this volume but a silent cap the moment the space grows). Columns
re-authored 1:1 from the analysis' own Advanced-tab logical SQL: 35 select
items, of which 30 are visible = the job's colmap headings and 5 are
ORDER-BY-only helpers dropped here (the 4 sort IDOFs + the Customer-Notes
Creation Date -- the table's all-NULL CREATION_DATE orphan is that retired
duplicate; the mapped 'Creation Date' = CREATION_DATE_2 = Reference
Information). 'Transaction Complete Indicator' = DESCRIPTOR_IDOF of
Transaction Complete (the lines-def Includes-Tax pattern). The analysis
filter ("Transaction Entered Amount" <> 0) is kept in every chunk.

Chunks partition on the header-grain "- Reference Information"."Creation
Date". Loaded spread (all 2026, no NULLs): Jan 50,495 (migration lump, split
half-month like the lines def) / Feb 168 / Mar 208 / Apr 20,701 / May 8,315 /
Jun 7,494 / Jul 10,513 / Aug 4,383. NULL + past + >= 2027 guards keep the
partition total by construction. min_rows 95,000. Service account
(non-catalog source_ref so the db/62 path-owner rule stays out of the way).

Lives on the SEPARATE job 'AR Invoice Header - V2' (db/73) -- Projects Budget
Full - V2 pattern: the original 'AR Invoice Header - all' job keeps its
catalog source_ref and stays DISABLED as the fallback.
"""
SA = '"Receivables - Transactions Real Time"'
CR = f'{SA}."- Reference Information"."Creation Date"'
AMT = f'{SA}."- Transaction Amounts"."Transaction Entered Amount" <> 0'

# (formula-without-SA-prefix, colmap heading) — order = CSV position #2..#31
_COLS = [
    ('"- General Information"."Transaction ID"',                    "Transaction ID"),
    ('"- General Information"."Transaction Number"',                "Transaction Number"),
    ('"- General Information"."Transaction Source Name"',           "Transaction Source"),
    ('"- General Information"."Transaction Type"',                  "Transaction Type Name"),
    ('"- General Information"."Transaction Type Tax Calculation"',  "Transaction Type Tax Calculation Meaning"),
    ('"- General Information"."Transaction Date"',                  "Transaction Date"),
    ('"- Additional Header Information"."Customer Transaction Reference"',
     "Customer Transaction Reference"),
    ('"- Customer Additional Information"."Paying Customer Name"',  "Paying Customer Name"),
    ('"- Transaction Amounts"."Transaction Accounted Amount"',      "Transaction Accounted Amount"),
    ('"- Transaction Amounts"."Transaction Entered Amount"',        "Transaction Entered Amount"),
    ('"- Bill-to Customer Details"."Bill-to Customer Number"',      "Bill-to Customer Number"),
    ('"- Bill-to Customer Details"."Bill-to Customer Name"',        "Bill-to Customer Name"),
    ('"- Bill-to Customer Details"."Bill-to Customer Type"',        "Bill-to Customer Type"),
    ('"Bill-to Customer Site"."Bill-to Site Name"',                 "Bill-to Site Name"),
    ('"Business Unit"."Business Unit Name"',                        "Business Unit Name"),
    ('"Business Unit"."Status"',                                    "Status"),
    ('"- Freight Details"."Ship-to Customer Name"',                 "Ship-to Customer Name"),
    ('"- Subledger Accounting Journals Details"."Transfer Status"', "Transfer Status"),
    ('"- Subledger Accounting Journals Details"."Accounting Status Code"',
     "Accounting Status Code"),
    ('"- Subledger Accounting Journals Details"."Accounting Status"',
     "Accounting Status"),
    ('"- Bill-to Customer Contacts"."Account Contact Status Meaning"',
     "Account Contact Status Meaning"),
    ('IDOF:"- Reference Information"."Transaction Complete"',       "Transaction Complete Indicator"),
    ('"- Reference Information"."Transaction Complete"',            "Transaction Complete"),
    ('"- Reference Information"."Last Update Date"',                "Invoice Last Update Date"),
    ('"- Reference Information"."Last Updated By"',                 "Last Updated By"),
    ('"- Reference Information"."Last Updated By User Name"',       "Last Updated By User Name"),
    ('"- Reference Information"."Creation Date"',                   "Creation Date"),
    ('"- Reference Information"."Created By"',                      "Created By"),
    ('"- Reference Information"."Created By User Name"',            "Created By User Name"),
    ('"- GL Accounting Date"."Accounting Date"',                    "Accounting Date"),
]


def _expr(col):
    if col.startswith("IDOF:"):
        return f"DESCRIPTOR_IDOF({SA}.{col[5:]})"
    return f"{SA}.{col}"


def build_sql_template():
    sel = ", ".join(f"{_expr(col)} s_{i+1}" for i, (col, _) in enumerate(_COLS))
    return ("SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1'; "
            f"SELECT 0 s_0, {sel} FROM {SA} WHERE ({AMT}) AND ({{chunk}})")


def build_headers():
    return {f"#{i+2}": name for i, (_, name) in enumerate(_COLS)}


def build_chunks():
    chunks = [
        f"{CR} IS NULL",
        f"{CR} < date '2026-01-01'",
        f"{CR} >= date '2026-01-01' AND {CR} < date '2026-01-16'",
        f"{CR} >= date '2026-01-16' AND {CR} < date '2026-02-01'",
    ]
    months = [f"2026-{m:02d}-01" for m in range(2, 13)] + ["2027-01-01"]
    for a, b in zip(months, months[1:]):
        chunks.append(f"{CR} >= date '{a}' AND {CR} < date '{b}'")
    chunks.append(f"{CR} >= date '2027-01-01'")
    return chunks


def build_params():
    return {"_atd_sql_chunks": {
        "sql": build_sql_template(),
        "chunks": build_chunks(),
        "headers": build_headers(),
        "min_rows": 95000,
        "retries": 1,
        "parallel": 4}}


if __name__ == "__main__":
    import json
    p = build_params()
    print("chunks:", len(p["_atd_sql_chunks"]["chunks"]))
    print(json.dumps(p)[:300])
