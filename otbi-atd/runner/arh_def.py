"""AR Invoice Header - all : chunked-extract definition (v2, 2026-08-17).

v2 re-authored after the OWNER REDESIGNED the saved analysis (~2026-08-17):
dropped Customer Transaction Reference / Paying Customer / Bill-to Site /
Ship-to Customer / Transfer + Accounting Status / Account Contact Status /
Accounting Date / the Customer-Notes Creation-Date helper and Tax Calculation;
added "- General Information" Payment Terms Name + Description and
"- Payment" Receipt Method + Term Due Date (heading 'Due Date'). The rebuilt
'- all' job re-prepared ATD_AR_INVOICE_HEADER_DETAILS to the new 26-col shape
(the old orphan columns are gone; 'Creation Date' now maps to CREATION_DATE).
Verified against a live CSV sample 2026-08-17: 24 CSV columns, 103,030 rows.
NOTE the '- all' colmap keeps a STALE 'Transaction Type Tax Calculation
Meaning' entry — harmless (headers match by name) but that heading no longer
exists in the source.

Analysis facts (Advanced-tab dump): 27 select items — 24 visible = the CSV,
3 ORDER-BY-only sort IDOFs dropped here (Payment Terms Description / BU Name /
Status); 'Transaction Complete Indicator' = DESCRIPTOR_IDOF(Transaction
Complete); filter ("Transaction Entered Amount" <> 0) kept in every chunk;
the analysis still carries FETCH FIRST 500001 (harmless at this volume, a
silent cap if the space ever grows past it — the chunked path has no cap).

Chunks partition on the header-grain "- Reference Information"."Creation
Date" (Jan-2026 migration lump split half-month; NULL + past + >= 2027 guards
keep the partition total by construction). min_rows 95,000. Service account
(non-catalog source_ref keeps the db/62 path-owner rule out of the way).

Lives on the SEPARATE job 'AR Invoice Header - V2' (db/73) -- Projects Budget
Full - V2 pattern: the original 'AR Invoice Header - all' job keeps its
catalog source_ref as the fallback.
"""
SA = '"Receivables - Transactions Real Time"'
CR = f'{SA}."- Reference Information"."Creation Date"'
AMT = f'{SA}."- Transaction Amounts"."Transaction Entered Amount" <> 0'

# (formula-without-SA-prefix, colmap heading) — order = CSV position #2..#25
_COLS = [
    ('"- General Information"."Transaction ID"',                    "Transaction ID"),
    ('"- General Information"."Transaction Number"',                "Transaction Number"),
    ('"- General Information"."Transaction Source Name"',           "Transaction Source"),
    ('"- General Information"."Transaction Type"',                  "Transaction Type Name"),
    ('"- General Information"."Transaction Date"',                  "Transaction Date"),
    ('"- General Information"."Payment Terms Name"',                "Payment Terms Name"),
    ('"- General Information"."Payment Terms Description"',         "Payment Terms Description"),
    ('"- Transaction Amounts"."Transaction Accounted Amount"',      "Transaction Accounted Amount"),
    ('"- Transaction Amounts"."Transaction Entered Amount"',        "Transaction Entered Amount"),
    ('"- Bill-to Customer Details"."Bill-to Customer Number"',      "Bill-to Customer Number"),
    ('"- Bill-to Customer Details"."Bill-to Customer Name"',        "Bill-to Customer Name"),
    ('"- Bill-to Customer Details"."Bill-to Customer Type"',        "Bill-to Customer Type"),
    ('"Business Unit"."Business Unit Name"',                        "Business Unit Name"),
    ('"Business Unit"."Status"',                                    "Status"),
    ('IDOF:"- Reference Information"."Transaction Complete"',       "Transaction Complete Indicator"),
    ('"- Reference Information"."Transaction Complete"',            "Transaction Complete"),
    ('"- Reference Information"."Last Update Date"',                "Invoice Last Update Date"),
    ('"- Reference Information"."Last Updated By"',                 "Last Updated By"),
    ('"- Reference Information"."Last Updated By User Name"',       "Last Updated By User Name"),
    ('"- Reference Information"."Creation Date"',                   "Creation Date"),
    ('"- Reference Information"."Created By"',                      "Created By"),
    ('"- Reference Information"."Created By User Name"',            "Created By User Name"),
    ('"- Payment"."Term Due Date"',                                 "Due Date"),
    ('"- Payment"."Receipt Method"',                                "Receipt Method"),
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
