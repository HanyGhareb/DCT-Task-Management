# OTBI Column-Heading Review Worksheet

Generated 2026-08-16 from `PROD.ATD_OTBI_JOBS` (column maps), `ALL_TAB_COLUMNS`, and the last 14 days of run-log drift / row warnings.

## The rule (why headings matter)

The runner exports each analysis as CSV. **The CSV header row = the displayed *Column Heading* in the analysis — never the formula.** `column_map_json` maps that heading text to the DB column. If Fusion (or an editor) changes a heading, the drift engine adds a NEW DB column for the new heading and loads NULL into the old one.

**Prevention: on every analysis, tick *Custom Headings* and pin the heading to exactly the text in the 'OTBI Column Heading (required)' column below.** Pinned custom headings survive Fusion patches.

A Full analysis and its `_UH24` incremental copy are separate catalog objects — **both must carry identical headings**. After fixing a Full analysis, the UH24 copy can be regenerated with `copy_analysis.py` instead of editing it by hand.

## Priority findings (fix these first)

| # | Family | Problem | Data impact (verified 2026-08-16) |
|---|---|---|---|
| 1 | **PO Headers** (Full + UH24) | Heading `Supplier Name` → `Supplier` (Fusion default heading changed) | `ATD_PO_HEADERS.SUPPLIER_NAME` **0 / 4,412 populated** — GL butil books/registers, PO_HEADER_V/PO_LINES_V print blank suppliers |
| 2 | **PR Lines** (Full + UH24) | Same `Supplier Name` → `Supplier` rename | `ATD_PR_LINES.SUPPLIER_NAME` **0 / 9,784** (new `SUPPLIER` col 6,499 populated) |
| 3 | **AP Invoices** | Full has OLD headings, UH24 copy has NEW ones (`GL Date`→`Invoice Accounting Date`, `Cancelled Date`→`Invoice Canceled Date`, `Inter Company Flag`→`Intercompany Invoice Indicator`, `Pay Alone Flag`→`Pay alone`, `Party Site Name`→`Supplier or Party Site`, `Header Batch Name` dropped) | Every UH24 merge NULLs those columns on the rows it touches; the nightly Full repairs them → **intraday holes** in GL Date / Cancelled Date / Party Site on recently-updated invoices (AP dashboards read all of these). `HEADER_BATCH_NAME` now 0-populated |
| 4 | **Suppliers** (Full + UH24) | `Legal Name` → `DataFox Legal Name` | Both columns 0-populated (cosmetic today, pin anyway) |
| 5 | **PR Headers** (Full + UH24) | `SECTOR` / `SECTOR_DESCRIPTION` typed **DATE** in the table (bad profile guess) | Sector attributes never usable from this extract |
| 6 | Junk/stray table columns | `THE_QUERY_RESULTED_IN_NO_R` in ATD_PO_HEADERS + ATD_AP_INVOICE_LINES (an error-page export became a "column"); orphan `_2` pairs (AR `UOM_CODE`, `PAYMENT_DATE`, `LEGAL_ADDRESS`, `BUSINESS_UNIT`, …) | Clutter; drop after headings are stabilised |
| 7 | Text-typed dates/amounts | PO Headers: `ORDERED_AMOUNT`, `RATE`, `SUBMIT_DATE` as VARCHAR2; PR Headers: `LAST_UPDATED_DATE`, `CANCEL_DATE` as VARCHAR2; PR Lines: `APPROVED_DATE`, `ACCOUNTING_DATE` as VARCHAR2 | Sorting/filtering on these is string-based; optional type-correction round |
| 8 | **AR analyses** (owner saljaaidi) | Not in the haghareb catalog; AR Distributions hits the 500,000-row export cap; both AR jobs default to 15-min frequency | Separate decision — see questions |

**Fix pattern per family:** open the FULL analysis → each flagged column → gear → Edit Column Formula → tick *Custom Headings* → set the heading to the exact required text below → Save. Then regenerate the `_UH24` copy (or apply the identical edit there). The next Full run repopulates the dead column across all rows automatically (TRUNCATE_INSERT / full MERGE).

## Review checklist by table

---

### ATD_AP_INVOICES

**Job: AP Invoices Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/AP/prod/AP Invoices/AP_INVOICES_F`

**Job: AP Invoices Incremental** — enabled=Y, mode=MERGE, keys: `INVOICE_ID`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/AP/prod/AP Invoices/AP_INVOICES_UH24`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Invoice ID` | INVOICE_ID | NUMBER |
| `Invoice Number` | INVOICE_NUMBER | VARCHAR2(100) |
| `Invoice Type` | INVOICE_TYPE | VARCHAR2(30) |
| `Invoice Date` | INVOICE_DATE | DATE |
| `Invoice Description` | INVOICE_DESCRIPTION | VARCHAR2(400) |
| `Entered Date` | ENTERED_DATE | DATE |
| `Invoice Received Date` | INVOICE_RECEIVED_DATE | DATE |
| `PO Number` | PO_NUMBER | NUMBER |
| `Payment Terms` | PAYMENT_TERMS | VARCHAR2(20) |
| `Terms Date` | TERMS_DATE | DATE |
| `Supplier Name` | SUPPLIER_NAME | VARCHAR2(150) |
| `Supplier Number` | SUPPLIER_NUMBER | NUMBER |
| `BENEFICIARY_NAME` | BENEFICIARY_NAME | VARCHAR2(150) |
| `LIAB_CHECK_DFF` | LIAB_CHECK_DFF | VARCHAR2(10) |
| `DOCUMENT_TYPE_DFF` | DOCUMENT_TYPE_DFF | VARCHAR2(20) |
| `GROUP_ID_DFF` | GROUP_ID_DFF | VARCHAR2(60) |
| `Budget Date` | BUDGET_DATE | DATE |
| `Funds Status` | FUNDS_STATUS | VARCHAR2(30) |
| `GL Date` | GL_DATE | DATE |
| `Header Batch ID` | HEADER_BATCH_ID | NUMBER |
| `Header Batch Name` | HEADER_BATCH_NAME | VARCHAR2(30) |
| `Inter Company Flag` | INTER_COMPANY_FLAG | VARCHAR2(10) |
| `Intercompany Invoice` | INTERCOMPANY_INVOICE | VARCHAR2(10) |
| `Cancelled Date` | CANCELLED_DATE | DATE |
| `Cancelled By` | CANCELLED_BY | VARCHAR2(40) |
| `Cancelled By Username` | CANCELLED_BY_USERNAME | VARCHAR2(60) |
| `Created By Username` | CREATED_BY_USERNAME | VARCHAR2(100) |
| `Created By` | CREATED_BY | VARCHAR2(40) |
| `Created Date` | CREATED_DATE | DATE |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(40) |
| `Last Updated By Username` | LAST_UPDATED_BY_USERNAME | VARCHAR2(60) |
| `Last Updated Date` | LAST_UPDATED_DATE | DATE |
| `Pay Alone Flag` | PAY_ALONE_FLAG | VARCHAR2(10) |
| `Party Site Name` | PARTY_SITE_NAME | VARCHAR2(100) |
| `Site` | SITE | VARCHAR2(100) |
| `Email` | EMAIL | VARCHAR2(40) |
| `Invoice Source` | INVOICE_SOURCE | VARCHAR2(40) |
| `Voucher Num` | VOUCHER_NUM | NUMBER |
| `Validation Status` | VALIDATION_STATUS | VARCHAR2(30) |
| `Invoice Currency` | INVOICE_CURRENCY | VARCHAR2(10) |
| `Invoice Amount` | INVOICE_AMOUNT | NUMBER |
| `Invoice Amount Paid` | INVOICE_AMOUNT_PAID | NUMBER |
| `Invoice Amount Functional` | INVOICE_AMOUNT_FUNCTIONAL | NUMBER |
| `Total Tax Charged` | TOTAL_TAX_CHARGED | NUMBER |
| `Paid Amount` | PAID_AMOUNT | NUMBER |
| `Party Site Number` | PARTY_SITE_NUMBER | NUMBER |
| `Party Site Country` | PARTY_SITE_COUNTRY | VARCHAR2(10) |
| `Party Site City` | PARTY_SITE_CITY | VARCHAR2(100) |
| `Pay Group` | PAY_GROUP | VARCHAR2(30) |
| `Payment Currency` | PAYMENT_CURRENCY | VARCHAR2(10) |
| `Payment Method` | PAYMENT_METHOD | VARCHAR2(20) |
| `Conversion Rate` | CONVERSION_RATE | NUMBER |
| `Conversion Date` | CONVERSION_DATE | DATE |
| `Conversion Rate Type` | CONVERSION_RATE_TYPE | VARCHAR2(20) |
| `Accounting Status` | ACCOUNTING_STATUS | VARCHAR2(40) |
| `Requester` | REQUESTER | VARCHAR2(40) |
| `Approval Status` | APPROVAL_STATUS | VARCHAR2(40) |
| `Business Unit Name` | BUSINESS_UNIT_NAME | VARCHAR2(60) |
| `Invoice Accounting Date` | INVOICE_ACCOUNTING_DATE | DATE |
| `Invoice Group` | INVOICE_GROUP | NUMBER |
| `Intercompany Invoice Indicator` | INTERCOMPANY_INVOICE_INDIC | VARCHAR2(10) |
| `Invoice Canceled Date` | INVOICE_CANCELED_DATE | DATE |
| `Pay alone` | PAY_ALONE | VARCHAR2(10) |
| `Supplier or Party Site` | SUPPLIER_OR_PARTY_SITE | VARCHAR2(100) |

Recent warnings (14 days):

- DRIFT: column 'Cancelled Date' no longer in the analysis - loading NULL
- DRIFT: column 'GL Date' no longer in the analysis - loading NULL
- DRIFT: column 'Header Batch Name' no longer in the analysis - loading NULL
- DRIFT: column 'Inter Company Flag' no longer in the analysis - loading NULL
- DRIFT: column 'Intercompany Invoice Indicator' no longer in the analysis - loading NULL
- DRIFT: column 'Invoice Accounting Date' no longer in the analysis - loading NULL
- DRIFT: column 'Invoice Canceled Date' no longer in the analysis - loading NULL
- DRIFT: column 'Party Site Name' no longer in the analysis - loading NULL
- DRIFT: column 'Pay Alone Flag' no longer in the analysis - loading NULL
- DRIFT: column 'Pay alone' no longer in the analysis - loading NULL
- ROWWARN: INVOICE_GROUP:INVALID_NUMBER x6
- DRIFT: analysis returned no data this run (0 rows) - nothing loaded
- DRIFT: new column 'Intercompany Invoice Indicator' added as INTERCOMPANY_INVOICE_INDIC VARCHAR2(10)
- DRIFT: new column 'Invoice Accounting Date' added as INVOICE_ACCOUNTING_DATE DATE
- DRIFT: new column 'Invoice Canceled Date' added as INVOICE_CANCELED_DATE DATE

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_AP_INVOICE_DISTRIBUTIONS

**Job: AP Distributions Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/AP/prod/AP Invoice Distributions/AP_INVOICE_DISTRIBUTIONS_F`

**Job: AP Distributions Incremental** — enabled=Y, mode=MERGE, keys: `INVOICE_ID,LINE_NUMBER,DISTRIBUTION_LINE_NUMBER`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/AP/prod/AP Invoice Distributions/AP_INVOICE_DISTRIBUTIONS_UH24`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Invoice ID` | INVOICE_ID | NUMBER |
| `Line Number` | LINE_NUMBER | NUMBER |
| `Distribution Line Number` | DISTRIBUTION_LINE_NUMBER | NUMBER |
| `Fund Status` | FUND_STATUS | VARCHAR2(60) |
| `Distribution Type` | DISTRIBUTION_TYPE | VARCHAR2(40) |
| `Accounting Date` | ACCOUNTING_DATE | DATE |
| `Created By` | CREATED_BY | VARCHAR2(40) |
| `Created By Username` | CREATED_BY_USERNAME | VARCHAR2(100) |
| `Creation Date` | CREATION_DATE | DATE |
| `Distribution Description` | DISTRIBUTION_DESCRIPTION | VARCHAR2(400) |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(40) |
| `Last Updated By Username` | LAST_UPDATED_BY_USERNAME | VARCHAR2(100) |
| `Last Updated Date` | LAST_UPDATED_DATE | DATE |
| `Period Name` | PERIOD_NAME | VARCHAR2(20) |
| `Posted Indicator` | POSTED_INDICATOR | VARCHAR2(10) |
| `Posting Status` | POSTING_STATUS | VARCHAR2(10) |
| `Reversal Indicator` | REVERSAL_INDICATOR | VARCHAR2(10) |
| `Reversal Status` | REVERSAL_STATUS | VARCHAR2(10) |
| `PO Number` | PO_NUMBER | NUMBER |
| `PO Line` | PO_LINE | NUMBER |
| `PO Schedule` | PO_SCHEDULE | NUMBER |
| `PO Distribution Line` | PO_DISTRIBUTION_LINE | NUMBER |
| `Match Type` | MATCH_TYPE | VARCHAR2(40) |
| `Requisition` | REQUISITION | NUMBER |
| `Receipt Number` | RECEIPT_NUMBER | NUMBER |
| `Distribution Amount` | DISTRIBUTION_AMOUNT | NUMBER |
| `Distribution Amount Functional` | DISTRIBUTION_AMOUNT_FUNCTI | NUMBER |
| `Distribution Retained Amount Remaining` | DISTRIBUTION_RETAINED_AMOU | NUMBER |
| `AP_CC_ID` | AP_CC_ID | NUMBER |
| `CC_ID` | CC_ID | NUMBER |
| `Project ID` | PROJECT_ID | NUMBER |
| `Task ID` | TASK_ID | NUMBER |
| `Expenditure Type` | EXPENDITURE_TYPE | VARCHAR2(150) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_AP_INVOICE_INSTALLMENTS

**Job: AP Installments Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/AP/prod/AP Invoice Installments/AP_INVOICE_INSTALLMENTS`

**Job: AP Installments Incremental** — enabled=Y, mode=MERGE, keys: `INVOICE_ID,INSTALLMENT_NUMBER`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/AP/prod/AP Invoice Installments/AP_INVOICE_INSTALLMENTS_UH24`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Invoice ID` | INVOICE_ID | NUMBER |
| `Installment Number` | INSTALLMENT_NUMBER | NUMBER |
| `Due Date` | DUE_DATE | DATE |
| `Payment Priority` | PAYMENT_PRIORITY | NUMBER |
| `Payment Method` | PAYMENT_METHOD | VARCHAR2(30) |
| `Bank Account Number` | BANK_ACCOUNT_NUMBER | VARCHAR2(60) |
| `Last Updated` | LAST_UPDATED | VARCHAR2(100) |
| `Last Updated Date` | LAST_UPDATED_DATE | TIMESTAMP(6) |
| `Payment Status` | PAYMENT_STATUS | VARCHAR2(10) |
| `Installment on Hold` | INSTALLMENT_ON_HOLD | VARCHAR2(10) |
| `Gross Amount` | GROSS_AMOUNT | NUMBER |
| `Unpaid Amount` | UNPAID_AMOUNT | NUMBER |
| `Unpaid amount in Base Currency` | UNPAID_AMOUNT_IN_BASE_CURR | NUMBER |
| `Invoice Currency` | INVOICE_CURRENCY | VARCHAR2(10) |
| `Pay Group` | PAY_GROUP | VARCHAR2(30) |
| `Payment Currency` | PAYMENT_CURRENCY | VARCHAR2(10) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_AP_INVOICE_LINES

**Job: AP Invoice Lines Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/AP/prod/AP Invoice Lines/AP_INVOICE_LINES_F`

**Job: AP Invoice Lines Incremental** — enabled=Y, mode=MERGE, keys: `INVOICE_ID,INVOICE_LINE_NUMBER`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/AP/prod/AP Invoice Lines/AP_INVOICE_LINES_UH24`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Invoice ID` | INVOICE_ID | NUMBER |
| `Invoice Line Number` | INVOICE_LINE_NUMBER | NUMBER |
| `Invoice Line Type` | INVOICE_LINE_TYPE | VARCHAR2(30) |
| `Line Description` | LINE_DESCRIPTION | VARCHAR2(400) |
| `Budget Date` | BUDGET_DATE | DATE |
| `Fund Status` | FUND_STATUS | VARCHAR2(60) |
| `Created By` | CREATED_BY | VARCHAR2(40) |
| `Created By Username` | CREATED_BY_USERNAME | VARCHAR2(100) |
| `Creation Date` | CREATION_DATE | DATE |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(40) |
| `Updated By Username` | UPDATED_BY_USERNAME | VARCHAR2(100) |
| `Last Updated Date` | LAST_UPDATED_DATE | DATE |
| `Period Name` | PERIOD_NAME | VARCHAR2(20) |
| `Completion Flag` | COMPLETION_FLAG | VARCHAR2(10) |
| `Asset` | ASSET | VARCHAR2(10) |
| `PO Number` | PO_NUMBER | NUMBER |
| `PO Line Number` | PO_LINE_NUMBER | NUMBER |
| `PO Schedule` | PO_SCHEDULE | NUMBER |
| `PO Distribution` | PO_DISTRIBUTION | NUMBER |
| `Receipt Number` | RECEIPT_NUMBER | NUMBER |
| `Receipt Schedule Line Number` | RECEIPT_SCHEDULE_LINE_NUMB | NUMBER |
| `Receipt Date` | RECEIPT_DATE | DATE |
| `Project Number` | PROJECT_NUMBER | NUMBER |
| `Task Number` | TASK_NUMBER | VARCHAR2(40) |
| `Expenditure Type` | EXPENDITURE_TYPE | VARCHAR2(150) |
| `Expenditure Item Date` | EXPENDITURE_ITEM_DATE | DATE |
| `Expenditure Organization` | EXPENDITURE_ORGANIZATION | VARCHAR2(100) |
| `Line Amount` | LINE_AMOUNT | NUMBER |
| `Line Amount Functional` | LINE_AMOUNT_FUNCTIONAL | NUMBER |
| `Total # of Active Holds` | TOTAL_OF_ACTIVE_HOLDS | NUMBER |
| `Included Tax Amount` | INCLUDED_TAX_AMOUNT | NUMBER |
| `Invoice Line Retained Amount` | INVOICE_LINE_RETAINED_AMOU | NUMBER |

Table columns with **no feeding heading** (orphans/strays): THE_QUERY_RESULTED_IN_NO_R

Recent warnings (14 days):

- DRIFT: analysis returned no data this run (0 rows) - nothing loaded
- DRIFT: widened INVOICE_LINE_TYPE -> VARCHAR2(30)

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_AR_INVOICE_LINES

**Job: AR INVOICE LINES - ALL** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/saljaaidi@dctabudhabi.ae/Data/AR/Prod/AR_INVOICE_LINES`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Transaction ID` | TRANSACTION_ID | NUMBER |
| `Memo Line Name` | MEMO_LINE_NAME | VARCHAR2(100) |
| `Number of Periods` | NUMBER_OF_PERIODS | NUMBER |
| `Invoice Reference Number` | INVOICE_REFERENCE_NUMBER | VARCHAR2(40) |
| `Memo Line Description` | MEMO_LINE_DESCRIPTION | VARCHAR2(100) |
| `Project` | PROJECT | NUMBER |
| `Task` | TASK | VARCHAR2(60) |
| `Transaction Line Amount Includes Tax` | TRANSACTION_LINE_AMOUNT_IN | VARCHAR2(30) |
| `Transaction Line Amount Includes Tax Indicator` | TRANSACTION_LINE_AMOUNT_IN_2 | VARCHAR2(10) |
| `UOM Code` | UOM_CODE_2 | VARCHAR2(10) |
| `Unit of Measure` | UNIT_OF_MEASURE_2 | VARCHAR2(20) |
| `Transaction Line Number` | TRANSACTION_LINE_NUMBER | NUMBER |
| `Export Date` | EXPORT_DATE | DATE |
| `Revenue Scheduling Rule` | REVENUE_SCHEDULING_RULE | VARCHAR2(40) |
| `Revenue Scheduling Rule End Date` | REVENUE_SCHEDULING_RULE_EN | DATE |
| `Revenue Scheduling Rule Start Date` | REVENUE_SCHEDULING_RULE_ST | DATE |
| `Service Description` | SERVICE_DESCRIPTION_2 | VARCHAR2(300) |
| `Transaction Line Description` | TRANSACTION_LINE_DESCRIPTI | VARCHAR2(150) |
| `Transaction Line Deferral Exclusion Indicator` | TRANSACTION_LINE_DEFERRAL_ | VARCHAR2(10) |
| `Transaction Line Type` | TRANSACTION_LINE_TYPE | VARCHAR2(10) |
| `Unit Selling Price` | UNIT_SELLING_PRICE | NUMBER |
| `Line Amount` | LINE_AMOUNT | NUMBER |
| `Transaction Line Quantity Invoiced` | TRANSACTION_LINE_QUANTITY_ | NUMBER |
| `Created By User Name` | CREATED_BY_USER_NAME | VARCHAR2(60) |
| `Last Updated By` | LAST_UPDATED_BY_2 | VARCHAR2(40) |
| `Last Updated By User Name` | LAST_UPDATED_BY_USER_NAME_2 | VARCHAR2(60) |
| `Created By` | CREATED_BY | VARCHAR2(40) |
| `Invoice Last Update Date` | INVOICE_LAST_UPDATE_DATE | DATE |
| `Creation Date` | CREATION_DATE | DATE |
| `Tax Classification Code` | TAX_CLASSIFICATION_CODE | VARCHAR2(40) |

Table columns with **no feeding heading** (orphans/strays): LAST_UPDATED_BY, LAST_UPDATED_BY_USER_NAME, SERVICE_DESCRIPTION, UNIT_OF_MEASURE, UOM_CODE

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_AR_INVOICE_DISTRIBUTION_DETAILS

**Job: AR Invoice Distribution Details - ALL** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/saljaaidi@dctabudhabi.ae/Data/AR/Prod/AR_Invoice_Distribution`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Transaction ID` | TRANSACTION_ID | NUMBER |
| `Transaction Number` | TRANSACTION_NUMBER | VARCHAR2(40) |
| `Transaction Line Number` | TRANSACTION_LINE_NUMBER | NUMBER |
| `Accounted` | ACCOUNTED_2 | VARCHAR2(10) |
| `Accounting Class` | ACCOUNTING_CLASS | VARCHAR2(30) |
| `Distribution Percentage` | DISTRIBUTION_PERCENTAGE | NUMBER |
| `Accounting Date` | ACCOUNTING_DATE_2 | DATE |
| `Distribution Comments` | DISTRIBUTION_COMMENTS_2 | VARCHAR2(100) |
| `Posting Control Identifier` | POSTING_CONTROL_IDENTIFIER | NUMBER |
| `Posted Date` | POSTED_DATE | DATE |
| `Receivables  Code Combination Description` | RECEIVABLES_CODE_COMBINATI | VARCHAR2(400) |
| `Receivables Concatenated Segments` | RECEIVABLES_CONCATENATED_S | VARCHAR2(100) |
| `Alternate Code Combination` | ALTERNATE_CODE_COMBINATION | VARCHAR2(40) |
| `Account Type Code` | ACCOUNT_TYPE_CODE | VARCHAR2(20) |
| `Distribution Entered Amount` | DISTRIBUTION_ENTERED_AMOUN | NUMBER |
| `Distribution Accounted Amount` | DISTRIBUTION_ACCOUNTED_AMO | NUMBER |
| `Ledger Currency` | LEDGER_CURRENCY | VARCHAR2(10) |
| `Document Currency Name` | DOCUMENT_CURRENCY_NAME | VARCHAR2(20) |
| `Document Currency` | DOCUMENT_CURRENCY | VARCHAR2(10) |
| `Invoice Last Update Date` | INVOICE_LAST_UPDATE_DATE | DATE |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(40) |
| `Last Updated By User Name` | LAST_UPDATED_BY_USER_NAME | VARCHAR2(60) |
| `Created By User Name` | CREATED_BY_USER_NAME | VARCHAR2(60) |
| `Creation Date` | CREATION_DATE | DATE |
| `Created By` | CREATED_BY | VARCHAR2(40) |
| `Distribution Cost Center Description` | DISTRIBUTION_COST_CENTER_D | VARCHAR2(100) |
| `Distribution Cost Center Code` | DISTRIBUTION_COST_CENTER_C | NUMBER |
| `Distribution Natural Account Description` | DISTRIBUTION_NATURAL_ACCOU | VARCHAR2(150) |
| `Distribution Natural Account Code` | DISTRIBUTION_NATURAL_ACCOU_2 | NUMBER |

Table columns with **no feeding heading** (orphans/strays): ACCOUNTED, ACCOUNTING_DATE, DISTRIBUTION_COMMENTS

Recent warnings (14 days):

- DRIFT: WARNING: loaded 500000 rows — equals a common OTBI export cap

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GL_ACCOUNTS_COMBINATIONS

**Job: GL_ACCOUNTS_COMBINATIONS** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/GL/prod/GL Accounts Combinations`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Entity Code` | ENTITY_CODE | NUMBER |
| `Cost Center` | COST_CENTER | NUMBER |
| `GL Account` | GL_ACCOUNT | NUMBER |
| `Appropriation` | APPROPRIATION | NUMBER |
| `Budget Group` | BUDGET_GROUP | NUMBER |
| `Entity Specific` | ENTITY_SPECIFIC | NUMBER |
| `Future 1` | FUTURE_1 | NUMBER |
| `Future 2` | FUTURE_2 | NUMBER |
| `Intercompany` | INTERCOMPANY | NUMBER |
| `Program code` | PROGRAM_CODE | NUMBER |
| `CC ID` | CC_ID | NUMBER |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GL_ACCOUNT_LIST

**Job: GL_ACCOUNT_LIST** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/GL/prod/GL Account List`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Account Code` | ACCOUNT_CODE | NUMBER |
| `Account Description` | ACCOUNT_DESCRIPTION | VARCHAR2(200) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GL_APPROPRIATION_LIST

**Job: GL_APPROPRIATION_LIST** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/GL/prod/GL Appropriation List`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Appropriation Code` | APPROPRIATION_CODE | NUMBER |
| `Appropriation Description` | APPROPRIATION_DESCRIPTION | VARCHAR2(400) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GL_BALANCES

**Job: GL Balances** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/GL/prod/Balances/GL_BALANCES`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Ledger Name` | LEDGER_NAME | VARCHAR2(20) |
| `Concatenated Segments` | CONCATENATED_SEGMENTS | VARCHAR2(300) |
| `Status` | STATUS | VARCHAR2(10) |
| `Enabled` | ENABLED | VARCHAR2(10) |
| `Initial Budget` | INITIAL_BUDGET | NUMBER |
| `Budget Adjustments` | BUDGET_ADJUSTMENTS | NUMBER |
| `Total Budget` | TOTAL_BUDGET | NUMBER |
| `Unreleased Budget` | UNRELEASED_BUDGET | NUMBER |
| `Funds Available Amount` | FUNDS_AVAILABLE_AMOUNT | NUMBER |
| `Commitments` | COMMITMENTS | NUMBER |
| `Obligations` | OBLIGATIONS | NUMBER |
| `Expenditures` | EXPENDITURES | NUMBER |
| `Other Encumbrances` | OTHER_ENCUMBRANCES | NUMBER |
| `Payables Expenditures` | PAYABLES_EXPENDITURES | NUMBER |
| `Project Expenditures` | PROJECT_EXPENDITURES | NUMBER |
| `Receipt Expenditures` | RECEIPT_EXPENDITURES | NUMBER |
| `Reserved Commitments` | RESERVED_COMMITMENTS | NUMBER |
| `Reserved Obligations` | RESERVED_OBLIGATIONS | NUMBER |
| `Miscellaneous Expenditures` | MISCELLANEOUS_EXPENDITURES | NUMBER |
| `Period Name` | PERIOD_NAME | VARCHAR2(20) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GL_BUDGET_GROUP_LIST

**Job: GL_BUDGET_GROUP_LIST** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/GL/prod/GL Budget Group List`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Budget Group` | BUDGET_GROUP | NUMBER |
| `Budget Group Description` | BUDGET_GROUP_DESCRIPTION | VARCHAR2(60) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GL_COST_CENTERS_LIST

**Job: GL_COST_CENTERS_LIST** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/GL/prod/GL Cost Centers List`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Cost Center` | COST_CENTER | NUMBER |
| `Cost Center Description` | COST_CENTER_DESCRIPTION | VARCHAR2(300) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GL_COST_ENTITY_SPECIFIC_LI

**Job: GL_COST_ENTITY_SPECIFIC_LI** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/GL/prod/GL Cost Entity Specific List`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Entity Specific` | ENTITY_SPECIFIC | NUMBER |
| `Entity Specific Description` | ENTITY_SPECIFIC_DESCRIPTIO | VARCHAR2(300) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GL_ENTITY_CODES_LIST

**Job: GL_ENTITY_CODES_LIST** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/GL/prod/GL Entity Codes List`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Value` | VALUE | NUMBER |
| `Description` | DESCRIPTION | VARCHAR2(150) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GL_FUTURE1_LIST

**Job: GL_FUTURE1_LIST** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/GL/prod/GL Future1 List`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Future 1` | FUTURE_1 | NUMBER |
| `Future 1 Description` | FUTURE_1_DESCRIPTION | VARCHAR2(20) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GL_FUTURE2_LIST

**Job: GL_FUTURE2_LIST** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/GL/prod/GL Future2 List`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Future 2` | FUTURE_2 | NUMBER |
| `Future 2 Description` | FUTURE_2_DESCRIPTION | VARCHAR2(20) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GL_INTERCOMPANY_LIST

**Job: GL_INTERCOMPANY_LIST** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/GL/prod/GL Intercompany List`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Intercompany` | INTERCOMPANY | NUMBER |
| `Intercompany Description` | INTERCOMPANY_DESCRIPTION | VARCHAR2(100) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GL_PROGRAM_LIST

**Job: GL_PROGRAM_LIST** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/GL/prod/GL Program List`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Program Code` | PROGRAM_CODE | NUMBER |
| `Program Description` | PROGRAM_DESCRIPTION | VARCHAR2(150) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GRADES

**Job: HR Grades** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/HR/prod/01-Grades`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Grade ID` | GRADE_ID | NUMBER |
| `Grade Name` | GRADE_NAME | VARCHAR2(10) |
| `Grade Code` | GRADE_CODE | VARCHAR2(10) |
| `Effective Start Date` | EFFECTIVE_START_DATE | DATE |
| `Effective End Date` | EFFECTIVE_END_DATE | DATE |
| `Grade Active Status` | GRADE_ACTIVE_STATUS | VARCHAR2(20) |
| `Grade Set Name` | GRADE_SET_NAME | VARCHAR2(30) |
| `Grade Last Updated By` | GRADE_LAST_UPDATED_BY | VARCHAR2(60) |
| `Grade Last Update Date` | GRADE_LAST_UPDATE_DATE | TIMESTAMP(6) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_GRN_ALL_V2

**Job: GRN Temporary Job** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/GRN/prod/final/GRN_ALL_V4`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Receipt Number` | RECEIPT_NUMBER | NUMBER |
| `Receipt Line Number` | RECEIPT_LINE_NUMBER | NUMBER |
| `Transaction Date` | TRANSACTION_DATE | DATE |
| `PO Header Id` | PO_HEADER_ID | NUMBER |
| `PO Line Id` | PO_LINE_ID | NUMBER |
| `PO Distribution Id` | PO_DISTRIBUTION_ID | NUMBER |
| `Invoice Id` | INVOICE_ID | VARCHAR2(40) |
| `Project ID` | PROJECT_ID | NUMBER |
| `Task ID` | TASK_ID | NUMBER |
| `Expenditure Type` | EXPENDITURE_TYPE | VARCHAR2(150) |
| `Expenditure Organization` | EXPENDITURE_ORGANIZATION | VARCHAR2(100) |
| `Created By` | CREATED_BY | VARCHAR2(60) |
| `Creation Date` | CREATION_DATE | DATE |
| `Last Update Date` | LAST_UPDATE_DATE | DATE |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(60) |
| `Transaction Amount` | TRANSACTION_AMOUNT | NUMBER |
| `Transaction Quantity` | TRANSACTION_QUANTITY | NUMBER |
| `Destination Type Meaning` | DESTINATION_TYPE_MEANING | VARCHAR2(20) |
| `Shipment Line Number` | SHIPMENT_LINE_NUMBER | NUMBER |
| `Transaction Type` | TRANSACTION_TYPE | VARCHAR2(60) |
| `Posted Flag` | POSTED_FLAG_2 | VARCHAR2(10) |
| `Receipt Routing Code` | RECEIPT_ROUTING_CODE | NUMBER |
| `Currency Code` | CURRENCY_CODE | VARCHAR2(10) |
| `Conversion Rate` | CONVERSION_RATE | NUMBER |
| `SLA Ledger Amount` | SLA_LEDGER_AMOUNT | NUMBER |
| `Ledger Amount` | LEDGER_AMOUNT | NUMBER |
| `Accounted Date` | ACCOUNTED_DATE | DATE |
| `Business Unit Name` | BUSINESS_UNIT_NAME | VARCHAR2(60) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_PAYMENTS

**Job: Payments All** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/AP/prod/Payments`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Check ID` | CHECK_ID | NUMBER |
| `Check Number` | CHECK_NUMBER | NUMBER |
| `Payment Date` | PAYMENT_DATE_2 | DATE |
| `Payment Status` | PAYMENT_STATUS | VARCHAR2(20) |
| `Payment Type` | PAYMENT_TYPE | VARCHAR2(40) |
| `Payment Voucher Number` | PAYMENT_VOUCHER_NUMBER | NUMBER |
| `Remit-to Bank Account` | REMIT_TO_BANK_ACCOUNT | VARCHAR2(150) |
| `Remit-to Bank Account Number` | REMIT_TO_BANK_ACCOUNT_NUMB | VARCHAR2(60) |
| `Remit-to Bank Account Type` | REMIT_TO_BANK_ACCOUNT_TYPE | VARCHAR2(20) |
| `Void Date` | VOID_DATE | DATE |
| `Payment Cleared Date` | PAYMENT_CLEARED_DATE | DATE |
| `Created By` | CREATED_BY | VARCHAR2(40) |
| `Creation Date` | CREATION_DATE | DATE |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(60) |
| `Last Updated Date` | LAST_UPDATED_DATE | DATE |
| `Currency` | CURRENCY | VARCHAR2(10) |
| `Business Unit Name` | BUSINESS_UNIT_NAME | VARCHAR2(60) |
| `Bank Account Name` | BANK_ACCOUNT_NAME | VARCHAR2(100) |
| `Account Number` | ACCOUNT_NUMBER | VARCHAR2(30) |
| `Remit-to Bank Account IBAN` | REMIT_TO_BANK_ACCOUNT_IBAN | VARCHAR2(60) |
| `Payee Site` | PAYEE_SITE | VARCHAR2(100) |
| `Payee` | PAYEE | VARCHAR2(150) |
| `Payment Document` | PAYMENT_DOCUMENT | VARCHAR2(30) |
| `Account For Payment` | ACCOUNT_FOR_PAYMENT | VARCHAR2(60) |
| `Conversion Date` | CONVERSION_DATE | DATE |
| `Conversion Rate Type` | CONVERSION_RATE_TYPE | VARCHAR2(20) |
| `Document Sequence` | DOCUMENT_SEQUENCE | NUMBER |
| `Payment Conversion Rate` | PAYMENT_CONVERSION_RATE | NUMBER |
| `Reconciliation Status` | RECONCILIATION_STATUS | VARCHAR2(10) |
| `Payment Method` | PAYMENT_METHOD | VARCHAR2(20) |
| `Payment History Transaction Base Amount` | PAYMENT_HISTORY_TRANSACTIO | NUMBER |
| `Payment History Transaction Payment Amount` | PAYMENT_HISTORY_TRANSACTIO_2 | NUMBER |
| `Payment History Transaction Amount` | PAYMENT_HISTORY_TRANSACTIO_3 | NUMBER |

Table columns with **no feeding heading** (orphans/strays): PAYMENT_DATE

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_PERSONS

**Job: Persons** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/HR/prod/01-PERSONS`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Person ID` | PERSON_ID | NUMBER |
| `Person Number` | PERSON_NUMBER | NUMBER |
| `Title` | TITLE | VARCHAR2(60) |
| `First Name` | FIRST_NAME | VARCHAR2(60) |
| `Last Name` | LAST_NAME | VARCHAR2(60) |
| `Full Name` | FULL_NAME | VARCHAR2(400) |
| `Effective Start Date` | EFFECTIVE_START_DATE | DATE |
| `Effective End Date` | EFFECTIVE_END_DATE | DATE |
| `Last Update Date` | LAST_UPDATE_DATE | DATE |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(60) |
| `Nationality` | NATIONALITY | VARCHAR2(100) |
| `Mother Name` | MOTHER_NAME | VARCHAR2(100) |
| `Mother Name Ar` | MOTHER_NAME_AR | VARCHAR2(100) |
| `Date of Birth` | DATE_OF_BIRTH | DATE |
| `Emirates ID` | EMIRATES_ID | VARCHAR2(30) |
| `Issue Date` | ISSUE_DATE | DATE |
| `Expiration Date` | EXPIRATION_DATE | DATE |
| `Email` | EMAIL | VARCHAR2(100) |
| `Full Name Ar` | FULL_NAME_AR | VARCHAR2(400) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_PERSON_PHONES

**Job: Person Phones** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/HR/prod/01-PERSON_PHONES`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Person ID` | PERSON_ID | NUMBER |
| `Phone` | PHONE | VARCHAR2(30) |
| `Phone Type` | PHONE_TYPE | VARCHAR2(40) |
| `Primary Flag` | PRIMARY_FLAG | VARCHAR2(10) |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(60) |
| `Last Update Date` | LAST_UPDATE_DATE | TIMESTAMP(6) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_PO_DISTRIBUTIONS

**Job: PO Distributions Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PO/prod/PO Distributions/PO Distributions`

**Job: PO Distributions Incremental** — enabled=Y, mode=MERGE, keys: `PO_DISTRIBUTION_ID`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PO/prod/PO Distributions/PO_DISTRIBUTIONS_UH24`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `PO Header Id` | PO_HEADER_ID | NUMBER |
| `PO Line Id` | PO_LINE_ID | NUMBER |
| `PO Distribution Id` | PO_DISTRIBUTION_ID | NUMBER |
| `Budget Date` | BUDGET_DATE | DATE |
| `Distribution Number` | DISTRIBUTION_NUMBER | NUMBER |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(60) |
| `Last Updated Date` | LAST_UPDATED_DATE | DATE |
| `Funds Status` | FUNDS_STATUS | VARCHAR2(40) |
| `Distribution Amount` | DISTRIBUTION_AMOUNT | NUMBER |
| `Rate` | RATE | NUMBER |
| `Rate Date` | RATE_DATE | DATE |
| `Received Amount` | RECEIVED_AMOUNT | NUMBER |
| `Received Quantity` | RECEIVED_QUANTITY | NUMBER |
| `Schedule` | SCHEDULE | NUMBER |
| `Schedule Unbilled Amount` | SCHEDULE_UNBILLED_AMOUNT | NUMBER |
| `Status` | STATUS | VARCHAR2(30) |
| `PR Distribution Id` | PR_DISTRIBUTION_ID | NUMBER |
| `PR Description` | PR_DESCRIPTION | VARCHAR2(400) |
| `PR Number` | PR_NUMBER | NUMBER |
| `PR Line` | PR_LINE | NUMBER |
| `Requestor Email` | REQUESTOR_EMAIL | VARCHAR2(150) |
| `Requestor Name` | REQUESTOR_NAME | VARCHAR2(100) |
| `Charge Account` | CHARGE_ACCOUNT | VARCHAR2(100) |
| `Destination Type` | DESTINATION_TYPE | VARCHAR2(20) |
| `Location Name` | LOCATION_NAME | VARCHAR2(100) |
| `Project ID` | PROJECT_ID | NUMBER |
| `Task ID` | TASK_ID | NUMBER |
| `Expenditure Type Name` | EXPENDITURE_TYPE_NAME | VARCHAR2(150) |
| `Expenditure Organization` | EXPENDITURE_ORGANIZATION | VARCHAR2(100) |

Recent warnings (14 days):

- DRIFT: widened LOCATION_NAME -> VARCHAR2(100)
- DRIFT: widened REQUESTOR_EMAIL -> VARCHAR2(150)
- ROWWARN: PROJECT_ID:INVALID_NUMBER x3
- ROWWARN: PR_LINE:INVALID_NUMBER x3
- ROWWARN: PR_NUMBER:INVALID_NUMBER x4
- ROWWARN: TASK_ID:INVALID_NUMBER x4

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_PO_HEADERS

**Job: PO Headers Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PO/prod/PO Headers/PO_HEADERS_F`

**Job: PO Headers Incremental** — enabled=Y, mode=MERGE, keys: `PO_HEADER_ID`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PO/prod/PO Headers/PO_HEADERS_UH24`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `PO Header Id` | PO_HEADER_ID | NUMBER |
| `Order Number` | ORDER_NUMBER | NUMBER |
| `Order Type` | ORDER_TYPE | VARCHAR2(100) |
| `Order Description` | ORDER_DESCRIPTION | VARCHAR2(400) |
| `Currency` | CURRENCY | VARCHAR2(150) |
| `Ordered Amount` | ORDERED_AMOUNT | VARCHAR2(40) |
| `Funds Status` | FUNDS_STATUS | VARCHAR2(150) |
| `Performance Bond` | PERFORMANCE_BOND | VARCHAR2(20) |
| `Creation Date` | CREATION_DATE | DATE |
| `Updated By` | UPDATED_BY | VARCHAR2(60) |
| `Updated Date` | UPDATED_DATE | DATE |
| `Cancelled By` | CANCELLED_BY | VARCHAR2(60) |
| `Rate` | RATE | VARCHAR2(20) |
| `Rate Date` | RATE_DATE | DATE |
| `Procurement Contract Administrator` | PROCUREMENT_CONTRACT_ADMIN | VARCHAR2(30) |
| `Reference Number` | REFERENCE_NUMBER | VARCHAR2(40) |
| `Close Release Amount` | CLOSE_RELEASE_AMOUNT | NUMBER |
| `Actual End Date` | ACTUAL_END_DATE | DATE |
| `Actual Start Date` | ACTUAL_START_DATE | DATE |
| `Vendor Quote Reference` | VENDOR_QUOTE_REFERENCE | VARCHAR2(100) |
| `PO Type` | PO_TYPE | VARCHAR2(100) |
| `Savings Amount` | SAVINGS_AMOUNT | NUMBER |
| `Savings Reason` | SAVINGS_REASON | VARCHAR2(60) |
| `Cost Center` | COST_CENTER | VARCHAR2(100) |
| `Change Type` | CHANGE_TYPE | VARCHAR2(40) |
| `Context Segment` | CONTEXT_SEGMENT | VARCHAR2(40) |
| `Status` | STATUS | VARCHAR2(60) |
| `Document Style` | DOCUMENT_STYLE | VARCHAR2(30) |
| `Approved Date` | APPROVED_DATE | DATE |
| `Closed Date` | CLOSED_DATE | DATE |
| `Procurement BU` | PROCUREMENT_BU | VARCHAR2(60) |
| `Requisitioning BU` | REQUISITIONING_BU | VARCHAR2(60) |
| `Buyer` | BUYER | VARCHAR2(60) |
| `Supplier Number` | SUPPLIER_NUMBER | NUMBER |
| `Supplier Name` | SUPPLIER_NAME | VARCHAR2(300) |
| `Supplier Site` | SUPPLIER_SITE | VARCHAR2(100) |
| `Payment Terms` | PAYMENT_TERMS | VARCHAR2(40) |
| `Cancelled Date` | CANCELLED_DATE | DATE |
| `Submit Date` | SUBMIT_DATE | VARCHAR2(150) |
| `Supplier` | SUPPLIER | VARCHAR2(300) |

Table columns with **no feeding heading** (orphans/strays): THE_QUERY_RESULTED_IN_NO_R

Recent warnings (14 days):

- DRIFT: column 'Supplier Name' no longer in the analysis - loading NULL
- DRIFT: new column 'Supplier' added as SUPPLIER VARCHAR2(300)
- DRIFT: widened ORDER_TYPE -> VARCHAR2(100)
- DRIFT: widened PO_TYPE -> VARCHAR2(100)
- DRIFT: widened SUPPLIER -> VARCHAR2(300)
- ROWWARN: CANCELLED_DATE:INVALID_DATE x20
- ROWWARN: CREATION_DATE:INVALID_DATE x20
- ROWWARN: RATE_DATE:INVALID_DATE x20
- ROWWARN: UPDATED_DATE:INVALID_DATE x10
- DRIFT: column 'Supplier' no longer in the analysis - loading NULL
- DRIFT: new column 'Supplier' added as SUPPLIER VARCHAR2(150)
- DRIFT: widened SUPPLIER -> VARCHAR2(150)
- DRIFT: widened SUPPLIER_SITE -> VARCHAR2(100)

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_PO_LINES

**Job: PO Lines Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PO/prod/PO Lines/PO_LINES_F`

**Job: PO Lines Incremental** — enabled=Y, mode=MERGE, keys: `PO_LINE_ID`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PO/prod/PO Lines/PO_LINES_UH24`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Order Number` | ORDER_NUMBER | NUMBER |
| `PO Header Id` | PO_HEADER_ID | NUMBER |
| `PO Line Id` | PO_LINE_ID | NUMBER |
| `Line Amount` | LINE_AMOUNT | NUMBER |
| `Advance Amount` | ADVANCE_AMOUNT | VARCHAR2(40) |
| `Advance Amount %` | ADVANCE_AMOUNT_2 | VARCHAR2(40) |
| `Line Type` | LINE_TYPE | VARCHAR2(40) |
| `Line` | LINE | NUMBER |
| `Category Name` | CATEGORY_NAME | VARCHAR2(200) |
| `Category Description` | CATEGORY_DESCRIPTION | VARCHAR2(200) |
| `Item Name` | ITEM_NAME | VARCHAR2(600) |
| `Item Description` | ITEM_DESCRIPTION | VARCHAR2(400) |
| `Line Status` | LINE_STATUS | VARCHAR2(40) |
| `Funds Status` | FUNDS_STATUS | VARCHAR2(40) |
| `Currency Code` | CURRENCY_CODE | VARCHAR2(10) |
| `Base Price` | BASE_PRICE | NUMBER |
| `Pricing UOM` | PRICING_UOM | VARCHAR2(10) |
| `Revision` | REVISION | VARCHAR2(40) |
| `Supplier Item` | SUPPLIER_ITEM | VARCHAR2(40) |
| `UOM` | UOM | VARCHAR2(10) |
| `Cancellation Reason` | CANCELLATION_REASON | VARCHAR2(400) |
| `Line Cancelled By` | LINE_CANCELLED_BY | VARCHAR2(60) |
| `Cancelled Date` | CANCELLED_DATE | DATE |
| `Line Status Code` | LINE_STATUS_CODE | VARCHAR2(40) |
| `Price` | PRICE | NUMBER |
| `Update By` | UPDATE_BY | VARCHAR2(60) |
| `Creation Date` | CREATION_DATE | DATE |
| `Updated on` | UPDATED_ON | DATE |
| `Approved Date` | APPROVED_DATE | DATE |
| `Close Date` | CLOSE_DATE | DATE |
| `Open Date` | OPEN_DATE | DATE |
| `Submit Date` | SUBMIT_DATE | DATE |
| `Document Status Lookup Code` | DOCUMENT_STATUS_LOOKUP_COD | VARCHAR2(40) |
| `Document Status Meaning` | DOCUMENT_STATUS_MEANING | VARCHAR2(60) |
| `Document Status Description` | DOCUMENT_STATUS_DESCRIPTIO | VARCHAR2(200) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_PO_SCHEDULES

**Job: PO Schedules Incremental** — enabled=Y, mode=MERGE, keys: `LINE_LOCATION_ID`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PO/prod/PO Schedules/PO_SCHEDULES_UH24`

**Job: PO Schedules Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PO/prod/PO Schedules/PO Schedules`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Business Unit` | BUSINESS_UNIT_2 | VARCHAR2(60) |
| `PO Header Id` | PO_HEADER_ID | NUMBER |
| `PO Line Id` | PO_LINE_ID | NUMBER |
| `Line Location Id` | LINE_LOCATION_ID | NUMBER |
| `Schedule` | SCHEDULE | NUMBER |
| `Schedule Status` | SCHEDULE_STATUS | VARCHAR2(40) |
| `Schedule Type` | SCHEDULE_TYPE | VARCHAR2(40) |
| `Canceled Date` | CANCELED_DATE | DATE |
| `Schedule Description` | SCHEDULE_DESCRIPTION | VARCHAR2(40) |
| `Schedule Last Updated By` | SCHEDULE_LAST_UPDATED_BY | VARCHAR2(60) |
| `Schedule Last Updated Date` | SCHEDULE_LAST_UPDATED_DATE | DATE |
| `Shipment Type` | SHIPMENT_TYPE | VARCHAR2(20) |
| `Unbilled Amount` | UNBILLED_AMOUNT | NUMBER |
| `Received Amount` | RECEIVED_AMOUNT | NUMBER |
| `Billed Amount` | BILLED_AMOUNT | NUMBER |
| `Retainage Amount` | RETAINAGE_AMOUNT | NUMBER |
| `Retainage Released Amount` | RETAINAGE_RELEASED_AMOUNT | NUMBER |
| `Schedule Quantity` | SCHEDULE_QUANTITY | NUMBER |
| `Accepted Quantity` | ACCEPTED_QUANTITY | NUMBER |
| `Invoice Match Option` | INVOICE_MATCH_OPTION | VARCHAR2(20) |
| `Tax Classification Code` | TAX_CLASSIFICATION_CODE | VARCHAR2(60) |
| `Destination Lookup Code` | DESTINATION_LOOKUP_CODE | VARCHAR2(20) |
| `Organization Name` | ORGANIZATION_NAME | VARCHAR2(60) |
| `Location Name` | LOCATION_NAME | VARCHAR2(100) |
| `Closed for Invoicing Date` | CLOSED_FOR_INVOICING_DATE | DATE |
| `Closed for Receiving Date` | CLOSED_FOR_RECEIVING_DATE | DATE |
| `Shipment Closed Date` | SHIPMENT_CLOSED_DATE | DATE |
| `Last Acceptable Delivery Date` | LAST_ACCEPTABLE_DELIVERY_D | DATE |
| `Original Promised Delivery Date` | ORIGINAL_PROMISED_DELIVERY | DATE |
| `Promised Delivery Date` | PROMISED_DELIVERY_DATE | DATE |
| `Requested Delivery Date` | REQUESTED_DELIVERY_DATE | DATE |

Table columns with **no feeding heading** (orphans/strays): BUSINESS_UNIT

Recent warnings (14 days):

- DRIFT: widened LOCATION_NAME -> VARCHAR2(100)
- DRIFT: widened ORGANIZATION_NAME -> VARCHAR2(60)

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_PROJECTS

**Job: Projects Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/Projects/prod/Projects/PROJECTS_F2`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Project ID` | PROJECT_ID | NUMBER |
| `Business Unit Name` | BUSINESS_UNIT_NAME | VARCHAR2(60) |
| `Project Unit Name` | PROJECT_UNIT_NAME | VARCHAR2(100) |
| `Project Number` | PROJECT_NUMBER | VARCHAR2(20) |
| `Project Name` | PROJECT_NAME | VARCHAR2(100) |
| `Project Manager` | PROJECT_MANAGER | VARCHAR2(60) |
| `Project Status` | PROJECT_STATUS | VARCHAR2(30) |
| `Appropriation` | APPROPRIATION | VARCHAR2(40) |
| `Appropriation (Description)` | APPROPRIATION_DESCRIPTION | VARCHAR2(40) |
| `Project Finish Date` | PROJECT_FINISH_DATE | DATE |
| `Project Closed Date` | PROJECT_CLOSED_DATE | DATE |
| `Project Start Date` | PROJECT_START_DATE | DATE |
| `Project Creation Date` | PROJECT_CREATION_DATE | DATE |
| `Project Last Updated By` | PROJECT_LAST_UPDATED_BY | VARCHAR2(60) |
| `Project Last Update Date` | PROJECT_LAST_UPDATE_DATE | DATE |
| `Project Created By` | PROJECT_CREATED_BY | VARCHAR2(60) |
| `Liability Project Type` | LIABILITY_PROJECT_TYPE | VARCHAR2(10) |
| `Budget Group` | BUDGET_GROUP | NUMBER |
| `Budget Group (Description)` | BUDGET_GROUP_DESCRIPTION | VARCHAR2(30) |
| `Project Type` | PROJECT_TYPE | VARCHAR2(40) |

Recent warnings (14 days):

- DRIFT: widened PROJECT_STATUS -> VARCHAR2(30)

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_PROJECTS_BUDGET

**Job: Projects Budget Full** — enabled=N, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/Projects/prod/Projects/PROJECTS_BUDGET_PERIODS`

**Job: Projects Budget Full - V2** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/Projects/prod/Projects/PROJECTS_BUDGET_PERIODS`

**Job: Projects Budget Incremental** — enabled=N, mode=MERGE, keys: `PROJECT_ID,TASK_ID,EXPENDITURE_TYPE,ACCOUNTING_PERIOD`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/Projects/prod/Projects/PROJECTS_BUDGET_PERIODS_UH24`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Project ID` | PROJECT_ID | NUMBER |
| `Task ID` | TASK_ID | NUMBER |
| `Expenditure Type` | EXPENDITURE_TYPE | VARCHAR2(150) |
| `Budget` | BUDGET | NUMBER |
| `Budget Year` | BUDGET_YEAR | NUMBER |
| `Accounting Period` | ACCOUNTING_PERIOD | VARCHAR2(20) |
| `Update Date` | UPDATE_DATE | TIMESTAMP(6) |
| `Updated By` | UPDATED_BY | VARCHAR2(40) |

Recent warnings (14 days):

- DRIFT: analysis returned no data this run (0 rows) - nothing loaded

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_PR_DISTRIBUTIONS

**Job: PR Distributions Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PR/prod/03_PR_DISTRIBUTIONS/01_PR_DISTRIBUTIONS_F`

**Job: PR Distributions Incremental** — enabled=Y, mode=MERGE, keys: `DISTRIBUTION_ID`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PR/prod/03_PR_DISTRIBUTIONS/01_PR_DISTRIBUTIONS_UH24`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Business Unit` | BUSINESS_UNIT | VARCHAR2(60) |
| `PR Header Id` | PR_HEADER_ID | NUMBER |
| `Requisition` | REQUISITION | NUMBER |
| `PR Line Id` | PR_LINE_ID | NUMBER |
| `Distribution Id` | DISTRIBUTION_ID | NUMBER |
| `Lookup Code` | LOOKUP_CODE | VARCHAR2(20) |
| `Budget Date` | BUDGET_DATE | DATE |
| `Currency Code` | CURRENCY_CODE | VARCHAR2(10) |
| `Distribution` | DISTRIBUTION | NUMBER |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(100) |
| `Last Updated Date` | LAST_UPDATED_DATE | DATE |
| `Funds Status` | FUNDS_STATUS | VARCHAR2(20) |
| `Percentage` | PERCENTAGE | NUMBER |
| `Distribution Amount` | DISTRIBUTION_AMOUNT | NUMBER |
| `UOM Code` | UOM_CODE | VARCHAR2(10) |
| `UOM Name` | UOM_NAME | VARCHAR2(20) |
| `Tax Amount` | TAX_AMOUNT | NUMBER |
| `Charge Account` | CHARGE_ACCOUNT | VARCHAR2(100) |
| `Project ID` | PROJECT_ID | NUMBER |
| `Task ID` | TASK_ID | NUMBER |
| `Expenditure Type` | EXPENDITURE_TYPE | VARCHAR2(150) |
| `Expenditure Organization` | EXPENDITURE_ORGANIZATION | VARCHAR2(100) |
| `Preparer` | PREPARER | VARCHAR2(60) |
| `Requester` | REQUESTER | VARCHAR2(60) |
| `Line Status` | LINE_STATUS | VARCHAR2(30) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_PR_HEADERS

**Job: PR Headers Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PR/prod/01_PR_HEADERS/01_PR_HEADERS_F`

**Job: PR Headers Incremental** — enabled=Y, mode=MERGE, keys: `PR_HEADER_ID`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PR/prod/01_PR_HEADERS/01_PR_HEADERS_UH24`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Business Unit ID` | BUSINESS_UNIT_ID | NUMBER |
| `PR Header Id` | PR_HEADER_ID | NUMBER |
| `PR Number` | PR_NUMBER | NUMBER |
| `PR Amount` | PR_AMOUNT | NUMBER |
| `Justification` | JUSTIFICATION | VARCHAR2(2000) |
| `Description` | DESCRIPTION | VARCHAR2(400) |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(150) |
| `Last Updated Date` | LAST_UPDATED_DATE | VARCHAR2(150) |
| `Cancelled By` | CANCELLED_BY | VARCHAR2(200) |
| `Cancel Date` | CANCEL_DATE | VARCHAR2(300) |
| `Cancel Reason` | CANCEL_REASON | VARCHAR2(400) |
| `Funds Status` | FUNDS_STATUS | VARCHAR2(100) |
| `Approved Date` | APPROVED_DATE | DATE |
| `Sector` | SECTOR | DATE |
| `Attribute Value` | ATTRIBUTE_VALUE | VARCHAR2(60) |
| `Budgetary Control Enabled` | BUDGETARY_CONTROL_ENABLED | VARCHAR2(40) |
| `Contract Administrator` | CONTRACT_ADMINISTRATOR | VARCHAR2(200) |
| `Contract Duration (months)` | CONTRACT_DURATION_MONTHS | VARCHAR2(20) |
| `Sector (Description)` | SECTOR_DESCRIPTION | DATE |
| `Document Status Lookup Code` | DOCUMENT_STATUS_LOOKUP_COD | VARCHAR2(30) |
| `Preparer Name` | PREPARER_NAME | VARCHAR2(100) |
| `Preparer User Name` | PREPARER_USER_NAME | VARCHAR2(60) |
| `Preparer Email` | PREPARER_EMAIL | VARCHAR2(60) |
| `Preparer Supervisor Name` | PREPARER_SUPERVISOR_NAME | VARCHAR2(60) |
| `Business Unit Name` | BUSINESS_UNIT_NAME | VARCHAR2(60) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_PR_LINES

**Job: PR Lines All** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PR/prod/02_PR_LINES/01_PR_LINES_F`

**Job: PR Lines Incremental** — enabled=Y, mode=MERGE, keys: `PR_LINE_ID`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/PR/prod/02_PR_LINES/01_PR_LINES_UH24`

*Columns for PR Lines All:*

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Business Unit ID` | BUSINESS_UNIT_ID | NUMBER |
| `PR Header Id` | PR_HEADER_ID | NUMBER |
| `PR Line Id` | PR_LINE_ID | NUMBER |
| `Line Amount` | LINE_AMOUNT | NUMBER |
| `PR Line` | PR_LINE | NUMBER |
| `Line Status` | LINE_STATUS | VARCHAR2(30) |
| `Cancel Date` | CANCEL_DATE | DATE |
| `Cancel Reason` | CANCEL_REASON | VARCHAR2(400) |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(100) |
| `Last Updated Date` | LAST_UPDATED_DATE | DATE |
| `Line Processed Flag` | LINE_PROCESSED_FLAG | VARCHAR2(10) |
| `PO Approved Date` | PO_APPROVED_DATE | DATE |
| `PO Cancel Reason` | PO_CANCEL_REASON | VARCHAR2(400) |
| `PO Hold Reason` | PO_HOLD_REASON | VARCHAR2(10) |
| `PO Line Creation Date` | PO_LINE_CREATION_DATE | DATE |
| `PO Line` | PO_LINE | NUMBER |
| `PO Line Status` | PO_LINE_STATUS | VARCHAR2(40) |
| `PO Need By Date` | PO_NEED_BY_DATE | DATE |
| `PO Number` | PO_NUMBER | NUMBER |
| `PO Promised Date` | PO_PROMISED_DATE | DATE |
| `PO Revision Number` | PO_REVISION_NUMBER | NUMBER |
| `PO Status` | PO_STATUS | VARCHAR2(60) |
| `Received Amount` | RECEIVED_AMOUNT | NUMBER |
| `PR Line Cancel Flag` | PR_LINE_CANCEL_FLAG | VARCHAR2(10) |
| `Unprocessed PR Line Flag` | UNPROCESSED_PR_LINE_FLAG | VARCHAR2(10) |
| `Unprocessed PR Lines-Order in draft Flag` | UNPROCESSED_PR_LINES_ORDER | VARCHAR2(10) |
| `Unprocessed PR Lines-Pending PO Approval` | UNPROCESSED_PR_LINES_PENDI | VARCHAR2(10) |
| `Requisition Line Approval Time in Days` | REQUISITION_LINE_APPROVAL_ | VARCHAR2(10) |
| `Requisition Line Fulfilled Days` | REQUISITION_LINE_FULFILLED | VARCHAR2(30) |
| `Requisition Line Processing Days` | REQUISITION_LINE_PROCESSIN | VARCHAR2(10) |
| `Requisition Line Tax Amount` | REQUISITION_LINE_TAX_AMOUN | NUMBER |
| `Unprocessed Days` | UNPROCESSED_DAYS | NUMBER |
| `Currency Code` | CURRENCY_CODE | VARCHAR2(10) |
| `Agreement Number` | AGREEMENT_NUMBER | NUMBER |
| `Agreement Line Number` | AGREEMENT_LINE_NUMBER | NUMBER |
| `Agreement Reference` | AGREEMENT_REFERENCE | VARCHAR2(10) |
| `Agreement Type` | AGREEMENT_TYPE | VARCHAR2(20) |
| `Deliver-to Location Type` | DELIVER_TO_LOCATION_TYPE | VARCHAR2(20) |
| `Funds Status` | FUNDS_STATUS | VARCHAR2(20) |
| `Item Description` | ITEM_DESCRIPTION | VARCHAR2(400) |
| `Constant Dollar Conversion Rate` | CONSTANT_DOLLAR_CONVERSION | VARCHAR2(20) |
| `Requisition` | REQUISITION | VARCHAR2(20) |
| `Buyer` | BUYER | VARCHAR2(100) |
| `Location Name` | LOCATION_NAME | VARCHAR2(100) |
| `Supplier Name` | SUPPLIER_NAME | VARCHAR2(300) |
| `Supplier Number` | SUPPLIER_NUMBER | VARCHAR2(60) |
| `Requester Name` | REQUESTER_NAME | VARCHAR2(100) |
| `Requester User Name` | REQUESTER_USER_NAME | VARCHAR2(150) |
| `Requester Supervisor` | REQUESTER_SUPERVISOR | VARCHAR2(60) |
| `Delivery Date` | DELIVERY_DATE | DATE |
| `Approved Date` | APPROVED_DATE | VARCHAR2(150) |
| `Accounting Date` | ACCOUNTING_DATE | VARCHAR2(150) |
| `Submit Date` | SUBMIT_DATE | DATE |
| `Supplier` | SUPPLIER | VARCHAR2(300) |

*Columns for PR Lines Incremental:*

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Business Unit ID` | BUSINESS_UNIT_ID | NUMBER |
| `PR Header Id` | PR_HEADER_ID | NUMBER |
| `PR Line Id` | PR_LINE_ID | NUMBER |
| `Line Amount` | LINE_AMOUNT | NUMBER |
| `PR Line` | PR_LINE | NUMBER |
| `Line Status` | LINE_STATUS | VARCHAR2(30) |
| `Item Description` | ITEM_DESCRIPTION | VARCHAR2(400) |
| `Cancel Date` | CANCEL_DATE | DATE |
| `Cancel Reason` | CANCEL_REASON | VARCHAR2(400) |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(100) |
| `Last Updated Date` | LAST_UPDATED_DATE | DATE |
| `Line Processed Flag` | LINE_PROCESSED_FLAG | VARCHAR2(10) |
| `PO Approved Date` | PO_APPROVED_DATE | DATE |
| `PO Cancel Reason` | PO_CANCEL_REASON | VARCHAR2(400) |
| `PO Hold Reason` | PO_HOLD_REASON | VARCHAR2(10) |
| `PO Line Creation Date` | PO_LINE_CREATION_DATE | DATE |
| `PO Line` | PO_LINE | NUMBER |
| `PO Line Status` | PO_LINE_STATUS | VARCHAR2(40) |
| `PO Need By Date` | PO_NEED_BY_DATE | DATE |
| `PO Number` | PO_NUMBER | NUMBER |
| `PO Promised Date` | PO_PROMISED_DATE | DATE |
| `PO Revision Number` | PO_REVISION_NUMBER | NUMBER |
| `PO Status` | PO_STATUS | VARCHAR2(60) |
| `Received Amount` | RECEIVED_AMOUNT | NUMBER |
| `PR Line Cancel Flag` | PR_LINE_CANCEL_FLAG | VARCHAR2(10) |
| `Unprocessed Days` | UNPROCESSED_DAYS | NUMBER |
| `Unprocessed PR Line Flag` | UNPROCESSED_PR_LINE_FLAG | VARCHAR2(10) |
| `Unprocessed PR Lines-Order in draft Flag` | UNPROCESSED_PR_LINES_ORDER | VARCHAR2(10) |
| `Unprocessed PR Lines-Pending PO Approval` | UNPROCESSED_PR_LINES_PENDI | VARCHAR2(10) |
| `Requisition Line Approval Time in Days` | REQUISITION_LINE_APPROVAL_ | VARCHAR2(10) |
| `Requisition Line Fulfilled Days` | REQUISITION_LINE_FULFILLED | VARCHAR2(30) |
| `Requisition Line Processing Days` | REQUISITION_LINE_PROCESSIN | VARCHAR2(10) |
| `Requisition Line Tax Amount` | REQUISITION_LINE_TAX_AMOUN | NUMBER |
| `Currency Code` | CURRENCY_CODE | VARCHAR2(10) |
| `Agreement Number` | AGREEMENT_NUMBER | NUMBER |
| `Agreement Line Number` | AGREEMENT_LINE_NUMBER | NUMBER |
| `Agreement Reference` | AGREEMENT_REFERENCE | VARCHAR2(10) |
| `Agreement Type` | AGREEMENT_TYPE | VARCHAR2(20) |
| `Deliver-to Location Type` | DELIVER_TO_LOCATION_TYPE | VARCHAR2(20) |
| `Funds Status` | FUNDS_STATUS | VARCHAR2(20) |
| `Constant Dollar Conversion Rate` | CONSTANT_DOLLAR_CONVERSION | VARCHAR2(20) |
| `Requisition` | REQUISITION | VARCHAR2(20) |
| `Buyer` | BUYER | VARCHAR2(100) |
| `Location Name` | LOCATION_NAME | VARCHAR2(100) |
| `Supplier Name` | SUPPLIER_NAME | VARCHAR2(300) |
| `Supplier Number` | SUPPLIER_NUMBER | VARCHAR2(60) |
| `Requester Name` | REQUESTER_NAME | VARCHAR2(100) |
| `Requester User Name` | REQUESTER_USER_NAME | VARCHAR2(150) |
| `Requester Supervisor` | REQUESTER_SUPERVISOR | VARCHAR2(60) |
| `Delivery Date` | DELIVERY_DATE | DATE |
| `Approved Date` | APPROVED_DATE | VARCHAR2(150) |
| `Accounting Date` | ACCOUNTING_DATE | VARCHAR2(150) |
| `Submit Date` | SUBMIT_DATE | DATE |
| `Supplier` | SUPPLIER | VARCHAR2(300) |

Recent warnings (14 days):

- DRIFT: column 'Supplier Name' no longer in the analysis - loading NULL
- DRIFT: column 'Supplier' no longer in the analysis - loading NULL
- DRIFT: new column 'Supplier' added as SUPPLIER VARCHAR2(300)
- DRIFT: new column 'Supplier' added as SUPPLIER VARCHAR2(100)
- DRIFT: widened SUPPLIER -> VARCHAR2(150)
- DRIFT: widened SUPPLIER -> VARCHAR2(300)

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_PR_PO_PENDING_APPROVAL

**Job: PR PO Pending Approval** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/Custom/ADGE Procurement Reports/Purchasing/ADG Document Status Report.xdo`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Business Unit` | BUSINESS_UNIT | VARCHAR2(240) |
| `Document Type` | DOCUMENT_TYPE | VARCHAR2(80) |
| `Document Number` | DOCUMENT_NUMBER | VARCHAR2(80) |
| `Status` | STATUS | VARCHAR2(100) |
| `Preparer/Buyer` | PREPARER_BUYER | VARCHAR2(240) |
| `Submitted for Approval Date` | SUBMITTED_FOR_APPROVAL_DATE | VARCHAR2(20) |
| `Pending with Last Approver` | PENDING_WITH_LAST_APPROVER | VARCHAR2(1000) |
| `Pending Approval Days` | PENDING_APPROVAL_DAYS | NUMBER |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_SUPPLIERS

**Job: Suppliers Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/Suppliers/prod/01-Suppliers`

**Job: Suppliers Incremental** — enabled=Y, mode=MERGE, keys: `REGISTRY_ID`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/Suppliers/prod/SUPPLIERS_UH24`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Registry ID` | REGISTRY_ID | NUMBER |
| `Created By` | CREATED_BY | VARCHAR2(60) |
| `Creation Date` | CREATION_DATE | DATE |
| `Last Updated` | LAST_UPDATED | DATE |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(100) |
| `Supplier Start Active Date` | SUPPLIER_START_ACTIVE_DATE | DATE |
| `Supplier Number` | SUPPLIER_NUMBER | NUMBER |
| `Supplier Name` | SUPPLIER_NAME | VARCHAR2(300) |
| `Supplier Type` | SUPPLIER_TYPE | VARCHAR2(40) |
| `Tax Organization Type` | TAX_ORGANIZATION_TYPE | VARCHAR2(60) |
| `Legal Name` | LEGAL_NAME | VARCHAR2(40) |
| `Creation Source` | CREATION_SOURCE | VARCHAR2(20) |
| `Inactive Date` | INACTIVE_DATE | DATE |
| `Status` | STATUS | VARCHAR2(20) |
| `DED_LICENSE_STATUS` | DED_LICENSE_STATUS | VARCHAR2(20) |
| `DataFox Legal Name` | DATAFOX_LEGAL_NAME | VARCHAR2(40) |

Table columns with **no feeding heading** (orphans/strays): ACCOUNT_NAME, BANK_ACCOUNT_NUMBER, BANK_BRANCH_NAME, BANK_NAME, CURRENCY, FROM_ASSIGNMENT_DATE, IBAN, PRIMARY_FLAG, SITE_PAY_GROUP, SUPPLIER_SITE_STATUS, TO_DT

Recent warnings (14 days):

- DRIFT: column 'Legal Name' no longer in the analysis - loading NULL
- DRIFT: new column 'DataFox Legal Name' added as DATAFOX_LEGAL_NAME VARCHAR2(40)

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_SUPPLIER_BANK_ACCOUNTS

**Job: Supplier Bank Accounts Full** — enabled=N, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/Suppliers/prod/01-Supplier_Bank_Accounts`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Registry ID` | REGISTRY_ID | NUMBER |
| `Account Name` | ACCOUNT_NAME | VARCHAR2(150) |
| `Account Type` | ACCOUNT_TYPE | VARCHAR2(20) |
| `Assignment Inactive On` | ASSIGNMENT_INACTIVE_ON | DATE |
| `Bank Name` | BANK_NAME | VARCHAR2(200) |
| `Bank Number` | BANK_NUMBER | VARCHAR2(20) |
| `Bank Branch Name` | BANK_BRANCH_NAME | VARCHAR2(200) |
| `Branch Number` | BRANCH_NUMBER | VARCHAR2(20) |
| `IBAN` | IBAN | VARCHAR2(60) |
| `Primary Flag` | PRIMARY_FLAG | VARCHAR2(10) |
| `Remittance E-Mail` | REMITTANCE_E_MAIL | VARCHAR2(40) |
| `Created` | CREATED | DATE |
| `Created By` | CREATED_BY | VARCHAR2(100) |
| `Last Updated` | LAST_UPDATED | DATE |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(100) |
| `To Date` | TO_DATE | DATE |
| `BIC` | BIC | VARCHAR2(20) |
| `Bank Account Number` | BANK_ACCOUNT_NUMBER | VARCHAR2(100) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_SUPPLIER_SITES

**Job: Supplier Sites Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/Suppliers/prod/02-Supplier_Sites`

**Job: Supplier Sites Incremental** — enabled=Y, mode=MERGE, keys: `REGISTRY_ID,SITE,BUSINESS_UNIT,CREATED`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/Suppliers/prod/SUPPLIER_SITES_UH24`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Registry ID` | REGISTRY_ID | NUMBER |
| `Site` | SITE | VARCHAR2(200) |
| `Purchasing Flag` | PURCHASING_FLAG | VARCHAR2(10) |
| `Primary Pay Flag` | PRIMARY_PAY_FLAG | VARCHAR2(40) |
| `Postal Code` | POSTAL_CODE | VARCHAR2(40) |
| `Pay Flag` | PAY_FLAG | VARCHAR2(10) |
| `Organization Type` | ORGANIZATION_TYPE | VARCHAR2(40) |
| `Legal Address` | LEGAL_ADDRESS_2 | VARCHAR2(40) |
| `Inactive Date` | INACTIVE_DATE | DATE |
| `County` | COUNTY | VARCHAR2(40) |
| `Country Of Origin` | COUNTRY_OF_ORIGIN | VARCHAR2(40) |
| `City` | CITY | VARCHAR2(100) |
| `Address Line 1` | ADDRESS_LINE_1 | VARCHAR2(400) |
| `Address Line 2` | ADDRESS_LINE_2 | VARCHAR2(200) |
| `Address Name` | ADDRESS_NAME | VARCHAR2(300) |
| `Supplier Name` | SUPPLIER_NAME | VARCHAR2(300) |
| `Created By` | CREATED_BY | VARCHAR2(60) |
| `Last Updated` | LAST_UPDATED | DATE |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(60) |
| `Site Pay Group` | SITE_PAY_GROUP | VARCHAR2(40) |
| `Income Tax Reporting Site Flag` | INCOME_TAX_REPORTING_SITE_ | VARCHAR2(40) |
| `Created` | CREATED | DATE |
| `Business Unit` | BUSINESS_UNIT | VARCHAR2(60) |

Table columns with **no feeding heading** (orphans/strays): LEGAL_ADDRESS

Recent warnings (14 days):

- DRIFT: widened ADDRESS_LINE_1 -> VARCHAR2(400)
- DRIFT: widened ADDRESS_LINE_2 -> VARCHAR2(200)
- DRIFT: widened ADDRESS_NAME -> VARCHAR2(300)
- DRIFT: widened CITY -> VARCHAR2(100)
- DRIFT: widened CREATED_BY -> VARCHAR2(60)
- DRIFT: widened LAST_UPDATED_BY -> VARCHAR2(60)
- DRIFT: widened SITE -> VARCHAR2(200)
- DRIFT: widened SITE_PAY_GROUP -> VARCHAR2(40)
- DRIFT: widened SUPPLIER_NAME -> VARCHAR2(300)
- DRIFT: analysis returned no data this run (0 rows) - nothing loaded

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_SUPPLIER_SITES_BANK_ACCOUNTS

**Job: Supplier Sites Bank Accounts Full** — enabled=N, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/Suppliers/prod/02-Supplier_Sites_Bank_Accounts`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Registry ID` | REGISTRY_ID | NUMBER |
| `Site` | SITE | VARCHAR2(20) |
| `Business Unit` | BUSINESS_UNIT | VARCHAR2(60) |
| `Account Name` | ACCOUNT_NAME | VARCHAR2(40) |
| `Account Type` | ACCOUNT_TYPE | VARCHAR2(40) |
| `Assignment Inactive On` | ASSIGNMENT_INACTIVE_ON | VARCHAR2(40) |
| `BIC` | BIC | VARCHAR2(40) |
| `Bank Account Number` | BANK_ACCOUNT_NUMBER | VARCHAR2(40) |
| `Bank Branch Name` | BANK_BRANCH_NAME | VARCHAR2(40) |
| `Bank Name` | BANK_NAME | VARCHAR2(40) |
| `IBAN` | IBAN | VARCHAR2(40) |
| `Primary Flag` | PRIMARY_FLAG | VARCHAR2(10) |
| `Remittance Email` | REMITTANCE_EMAIL | VARCHAR2(40) |
| `From Date` | FROM_DATE | DATE |
| `To Date` | TO_DATE | DATE |
| `Created` | CREATED | VARCHAR2(40) |
| `Created By` | CREATED_BY | VARCHAR2(40) |
| `Last Updated` | LAST_UPDATED | VARCHAR2(40) |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(40) |

- [ ] Headings verified & pinned (Custom Headings ON)

---

### ATD_TASKS

**Job: Tasks Full** — enabled=Y, mode=TRUNCATE_INSERT, keys: `None`

Analysis: `/users/haghareb@dctabudhabi.ae/Data/Projects/prod/tasks/TASKS_F_new`

| OTBI Column Heading (required) | DB column | Type |
|---|---|---|
| `Task ID` | TASK_ID | NUMBER |
| `Task Number` | TASK_NUMBER | VARCHAR2(60) |
| `Task Name` | TASK_NAME | VARCHAR2(100) |
| `Task Description` | TASK_DESCRIPTION | VARCHAR2(60) |
| `Planned Start Date` | PLANNED_START_DATE | DATE |
| `Planned Finish Date` | PLANNED_FINISH_DATE | DATE |
| `Actual Start Date` | ACTUAL_START_DATE | DATE |
| `Actual Finish Date` | ACTUAL_FINISH_DATE | DATE |
| `Work Type` | WORK_TYPE | VARCHAR2(30) |
| `Appropriation` | APPROPRIATION | NUMBER |
| `Entity Specific` | ENTITY_SPECIFIC | NUMBER |
| `Program` | PROGRAM | NUMBER |
| `Task Organization` | TASK_ORGANIZATION | VARCHAR2(100) |
| `Service Type` | SERVICE_TYPE | VARCHAR2(20) |
| `Task Source Reference` | TASK_SOURCE_REFERENCE | VARCHAR2(40) |
| `Element Type` | ELEMENT_TYPE | VARCHAR2(20) |
| `Transaction Control Inclusive` | TRANSACTION_CONTROL_INCLUS | VARCHAR2(10) |
| `Chargeable Task` | CHARGEABLE_TASK | VARCHAR2(10) |
| `Creation Date` | CREATION_DATE | DATE |
| `Last Update Date` | LAST_UPDATE_DATE | DATE |
| `Last Updated By` | LAST_UPDATED_BY | VARCHAR2(60) |
| `Created By` | CREATED_BY | VARCHAR2(60) |
| `Organization Reference` | ORGANIZATION_REFERENCE | VARCHAR2(100) |
| `Cost Center` | COST_CENTER | NUMBER |
| `Project ID` | PROJECT_ID | NUMBER |

- [ ] Headings verified & pinned (Custom Headings ON)

