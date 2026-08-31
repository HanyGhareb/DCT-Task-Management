"""AR_INVOICE_LINES : chunked-extract definition (probe + params generator).

Clean re-authoring of the saved analysis (private saljaaidi catalog; the
single-shot personal run dies at the ~570s web-tier kill): 38 data columns
(the 3 DESCRIPTOR_IDOF sort helpers dropped), the analysis' one filter
(Transaction Line Type <> 'TAX') kept in every chunk, chunked on the SAME
dim accounting date as the distributions job. No column map exists yet -
prepare auto-creates the table from the emitted headers, so headers are
positional -> clean unique presentation names.
"""
SA = '"Receivables - Transactions Real Time"'
D = f'{SA}."- Distribution Accounting Date"."Accounting Date"'
C = f'{SA}."- Transaction Distribution Details"."Accounting Class"'
NOTAX = (f'DESCRIPTOR_IDOF({SA}."- Line Information"."Transaction Line Type") '
         f"<> 'TAX'")

_COLS = [
    ('"- Additional Line Information"."Line Transaction Interface Flexfield Segment 1"',
     "Line Flexfield Segment 1"),
    ('"- Additional Line Information"."Line Transaction Interface Flexfield Segment 2"',
     "Line Flexfield Segment 2"),
    ('"- Freight Details"."Ship To Customer Account Name"', "Ship To Customer Account Name"),
    ('"- General Information"."Transaction ID"',            "Transaction ID"),
    ('"- Line Information"."Accounting Rule Duration"',     "Accounting Rule Duration"),
    ('"- Line Information"."Deferral Exclusion Flag"',      "Deferral Exclusion Flag"),
    ('"- Line Information"."JG_RA_CUSTOMER_TRX_LINES_EXPORT_DATE_"', "Export Date"),
    ('"- Line Information"."JG_RA_CUSTOMER_TRX_LINES_INVCRFRNCNBR_"', "Invoice Reference Number"),
    ('"- Line Information"."Line Description"',             "Line Description"),
    ('"- Line Information"."Memo Line Description"',        "Memo Line Description"),
    ('"- Line Information"."Memo Line Name"',               "Memo Line Name"),
    ('"- Line Information"."RA_CUSTOMER_TRX_LINES_PROJECT_NUMBER_v"', "Project Number"),
    ('"- Line Information"."RA_CUSTOMER_TRX_LINES_SERVICE_DESCRIPTION_"', "Service Description"),
    ('"- Line Information"."RA_CUSTOMER_TRX_LINES_TASK_NAME_"', "Task Name"),
    ('"- Line Information"."Revenue Scheduling Rule"',      "Revenue Scheduling Rule"),
    ('"- Line Information"."Rule End Date"',                "Rule End Date"),
    ('"- Line Information"."Rule Start Date"',              "Rule Start Date"),
    ('"- Line Information"."Transaction Line Amount Includes Tax"', "Line Amount Includes Tax"),
    ('"- Line Information"."Transaction Line Number"',      "Transaction Line Number"),
    ('"- Line Information"."Transaction Line Type"',        "Transaction Line Type"),
    ('"- Line Information"."Unit Of Measure Code"',         "UOM Code"),
    ('"- Line Information"."Unit Of Measure"',              "Unit Of Measure"),
    ('"- Line Information"."Unit Selling Price"',           "Unit Selling Price"),
    ('"- Reference Information"."Created By User Name"',    "Created By User Name"),
    ('"- Reference Information"."Created By"',              "Created By"),
    ('"- Reference Information"."Creation Date"',           "Creation Date"),
    ('"- Reference Information"."Last Update Date"',        "Last Update Date"),
    ('"- Reference Information"."Last Updated By User Name"', "Last Updated By User Name"),
    ('"- Reference Information"."Last Updated By"',         "Last Updated By"),
    ('"- Tax Details"."Tax Classification Code"',           "Tax Classification Code"),
    ('"- Transaction Distribution Details"."Account Set Indicator"', "Account Set Indicator"),
    ('"- Transaction Distribution Details"."Accounted"',    "Accounted"),
    ('"- Transaction Distribution Details"."Accounting Class"', "Accounting Class"),
    ('"- Transaction Distribution Details"."Accounting Date"', "Accounting Date"),
    ('"- Transaction Distribution Details"."Distribution Percentage"', "Distribution Percentage"),
    ('"Project"."Project Name"',                            "Project Name"),
    ('"- Line Amounts"."Line Amount"',                      "Line Amount"),
    ('"- Line Amounts"."Quantity Invoiced"',                "Quantity Invoiced"),
]


def build_sql_template():
    sel = ", ".join(f'{SA}.{col} s_{i+1}' for i, (col, _) in enumerate(_COLS))
    return ("SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1'; "
            f"SELECT 0 s_0, {sel} FROM {SA} WHERE ({NOTAX}) AND ({{chunk}})")


def build_headers():
    return {f"#{i+2}": name for i, (_, name) in enumerate(_COLS)}


def spread_sql():
    """Aggregate probe: rows per dim accounting month under the job's filter."""
    return ("SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1'; "
            f'SELECT 0 s_0, {SA}."- Distribution Accounting Date"."Month" s_1, '
            f'COUNT({SA}."- General Information"."Transaction ID") s_2 '
            f"FROM {SA} WHERE ({NOTAX}) "
            f'GROUP BY {SA}."- Distribution Accounting Date"."Month"')


def build_chunks():
    """26 chunks partitioning the space by construction. Sizes from the probed
    month x class aggregates (total 320,750 on 2026-08-14); biggest chunk =
    2025-12-31 Revenue 48,297 (~205-405s at the calibrated 4.2-8.4 ms/row -
    the migration lump has no finer natural split). Classes at this grain are
    only Revenue/Unearned Revenue; catch-alls keep any third value covered."""
    REV, UNE = "'Revenue'", "'Unearned Revenue'"
    other = f"({C} NOT IN ({REV}, {UNE}) OR {C} IS NULL)"
    chunks = [
        f"{D} IS NULL AND {C} = {REV}",
        f"{D} IS NULL AND {C} = {UNE}",
        f"{D} IS NULL AND {other}",
        f"{D} < date '2025-12-01'",
        f"{D} = date '2025-12-31' AND {C} = {REV}",
        f"{D} >= date '2025-12-01' AND {D} < date '2025-12-31' AND {C} = {REV}",
        f"{D} >= date '2025-12-01' AND {D} < date '2026-01-01' AND {C} = {UNE}",
        f"{D} >= date '2025-12-01' AND {D} < date '2026-01-01' AND {other}",
    ]
    months = [f"2026-{m:02d}-01" for m in range(1, 10)]
    for a, b in zip(months, months[1:]):                      # Jan..Aug 2026
        chunks.append(f"{D} >= date '{a}' AND {D} < date '{b}' AND {C} = {REV}")
        chunks.append(f"{D} >= date '{a}' AND {D} < date '{b}' AND {C} = {UNE}")
    chunks.append(f"{D} >= date '2026-01-01' AND {D} < date '2026-09-01' AND {other}")
    chunks.append(f"{D} >= date '2026-09-01' AND {D} < date '2027-01-01'")
    chunks.append(f"{D} >= date '2027-01-01'")
    return chunks


def build_params(min_rows=250000):
    return {"_atd_sql_chunks": {
        "sql": build_sql_template(),
        "chunks": build_chunks(),
        "headers": build_headers(),
        "min_rows": min_rows,
        "retries": 1,
        "parallel": 1}}
