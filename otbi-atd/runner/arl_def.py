"""AR INVOICE LINES - ALL : chunked-extract definition.

Replaces the single-shot personal-account run of the saljaaidi analysis (it also
carried FETCH FIRST 500001, but the filtered line-grain total is 122,615 so no
truncation yet). Columns re-authored 1:1 from the analysis' own Advanced-tab
logical SQL: pure LINE grain, 30 mapped columns under the exact colmap-key
headings ('Transaction Line Amount Includes Tax Indicator' = DESCRIPTOR_IDOF of
the includes-tax column; 'Transaction Line Type' = the DISPLAY column, stored
values are 'Line'; the IDOF sort helper is dropped), one filter kept in every
chunk: DESCRIPTOR_IDOF(Transaction Line Type) <> 'TAX'.

NOTE the old aril_def.py (db/69) was authored at MIXED grain — it selected
distribution-detail columns and probed 320,750 rows; the real analysis is line
grain (122,615). This def supersedes it for the live job.

Chunks partition on the LINE-grain "- Reference Information"."Creation Date"
(never a distribution-dim date: a line whose distributions straddle two ranges
would land in BOTH chunks and duplicate). Probed month spread (all 2026):
Jan 53,895 (migration lump, split half-month) / Feb 311 / Mar 726 / Apr 28,127 /
May 10,813 / Jun 9,928 / Jul 13,510 / Aug 5,305. NULL + past + >=2027 guards
keep the partition total by construction. Service account (non-catalog
source_ref so the db/62 path-owner rule stays out of the way).

Lives on the SEPARATE job 'AR INVOICE LINES - V2' (db/72) -- Projects Budget
Full - V2 pattern: the original '- ALL' job keeps its catalog source_ref and
stays DISABLED as the fallback.
"""
SA = '"Receivables - Transactions Real Time"'
CR = f'{SA}."- Reference Information"."Creation Date"'
NOTAX = (f'DESCRIPTOR_IDOF({SA}."- Line Information"."Transaction Line Type") '
         f"<> 'TAX'")

# (formula-without-SA-prefix, colmap heading) — order = CSV position #2..#31
_COLS = [
    ('"- General Information"."Transaction ID"',                    "Transaction ID"),
    ('"- Line Information"."Memo Line Name"',                       "Memo Line Name"),
    ('"- Line Information"."Accounting Rule Duration"',             "Number of Periods"),
    ('"- Line Information"."JG_RA_CUSTOMER_TRX_LINES_INVCRFRNCNBR_"', "Invoice Reference Number"),
    ('"- Line Information"."Memo Line Description"',                "Memo Line Description"),
    ('"- Line Information"."RA_CUSTOMER_TRX_LINES_PROJECT_NUMBER_v"', "Project"),
    ('"- Line Information"."RA_CUSTOMER_TRX_LINES_TASK_NAME_"',     "Task"),
    ('"- Line Information"."Transaction Line Amount Includes Tax"', "Transaction Line Amount Includes Tax"),
    ('IDOF:"- Line Information"."Transaction Line Amount Includes Tax"',
     "Transaction Line Amount Includes Tax Indicator"),
    ('"- Line Information"."Unit Of Measure Code"',                 "UOM Code"),
    ('"- Line Information"."Unit Of Measure"',                      "Unit of Measure"),
    ('"- Line Information"."Transaction Line Number"',              "Transaction Line Number"),
    ('"- Line Information"."JG_RA_CUSTOMER_TRX_LINES_EXPORT_DATE_"', "Export Date"),
    ('"- Line Information"."Revenue Scheduling Rule"',              "Revenue Scheduling Rule"),
    ('"- Line Information"."Rule End Date"',                        "Revenue Scheduling Rule End Date"),
    ('"- Line Information"."Rule Start Date"',                      "Revenue Scheduling Rule Start Date"),
    ('"- Line Information"."RA_CUSTOMER_TRX_LINES_SERVICE_DESCRIPTION_"', "Service Description"),
    ('"- Line Information"."Line Description"',                     "Transaction Line Description"),
    ('"- Line Information"."Deferral Exclusion Flag"',              "Transaction Line Deferral Exclusion Indicator"),
    ('"- Line Information"."Transaction Line Type"',                "Transaction Line Type"),
    ('"- Line Information"."Unit Selling Price"',                   "Unit Selling Price"),
    ('"- Line Amounts"."Line Amount"',                              "Line Amount"),
    ('"- Line Amounts"."Quantity Invoiced"',                        "Transaction Line Quantity Invoiced"),
    ('"- Reference Information"."Created By User Name"',            "Created By User Name"),
    ('"- Reference Information"."Last Updated By"',                 "Last Updated By"),
    ('"- Reference Information"."Last Updated By User Name"',       "Last Updated By User Name"),
    ('"- Reference Information"."Created By"',                      "Created By"),
    ('"- Reference Information"."Last Update Date"',                "Invoice Last Update Date"),
    ('"- Reference Information"."Creation Date"',                   "Creation Date"),
    ('"- Tax Details"."Tax Classification Code"',                   "Tax Classification Code"),
]


def _expr(col):
    if col.startswith("IDOF:"):
        return f"DESCRIPTOR_IDOF({SA}.{col[5:]})"
    return f"{SA}.{col}"


def build_sql_template():
    sel = ", ".join(f"{_expr(col)} s_{i+1}" for i, (col, _) in enumerate(_COLS))
    return ("SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1'; "
            f"SELECT 0 s_0, {sel} FROM {SA} WHERE ({NOTAX}) AND ({{chunk}})")


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
        "min_rows": 110000,
        "retries": 1,
        "parallel": 4}}


if __name__ == "__main__":
    import json
    p = build_params()
    print("chunks:", len(p["_atd_sql_chunks"]["chunks"]))
    print(json.dumps(p)[:300])
