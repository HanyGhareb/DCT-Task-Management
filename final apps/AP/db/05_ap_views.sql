-- =============================================================================
-- Accounts Payable (App 212) -- source views over the Fusion-loaded AP tables
-- File    : 05_ap_views.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @05_ap_views.sql
-- Notes   : source of truth for AP_INVOICES_HEADER_V / AP_INVOICE_LINES_V /
--           AP_INVOICE_DISTRIBUTIONS_V (originally built directly in the DB;
--           captured here 2026-07-13 when the OTBI analysis dropped the
--           Attachment Flag column from ATD_AP_INVOICES and the views went
--           INVALID). has_attachment / attachment_flag are GONE -- do not
--           re-add them. After any STRUCTURAL ATD_AP_* reload run
--           prod.dct_views_rebuild first (pass-throughs + GL layer), then
--           re-run this script, then recompile prod.dct_ap_pkg.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON

CREATE OR REPLACE FORCE EDITIONABLE VIEW "PROD"."AP_INVOICES_HEADER_V" ("INVOICE_ID", "INVOICE_NUMBER", "INVOICE_TYPE", "INVOICE_DATE", "INVOICE_DESCRIPTION", "INVOICE_STATUS", "SUPPLIER_NUMBER", "SUPPLIER_NAME", "BENEFICIARY_NAME", "SUPPLIER_SITE", "PARTY_SITE_NAME", "PARTY_SITE_CITY", "PARTY_SITE_COUNTRY", "SUPPLIER_EMAIL", "INVOICE_CURRENCY", "INVOICE_AMOUNT", "TOTAL_TAX_CHARGED", "INVOICE_AMOUNT_AED", "CONVERSION_RATE", "CONVERSION_RATE_TYPE", "CONVERSION_DATE", "AMOUNT_PAID", "BALANCE_DUE", "PAYMENT_STATUS", "VALIDATION_STATUS", "ACCOUNTING_STATUS", "FUNDS_STATUS", "PAYMENT_TERMS", "TERMS_DATE", "PAYMENT_METHOD", "PAY_GROUP", "PAYMENT_CURRENCY", "PAY_ALONE_FLAG", "HEADER_PO_NUMBER", "VOUCHER_NUM", "INVOICE_SOURCE", "BATCH_NAME", "REQUESTER", "INTERCOMPANY_INVOICE", "BUDGET_DATE", "GL_DATE", "ENTERED_DATE", "INVOICE_RECEIVED_DATE", "CREATED_BY", "CREATED_DATE", "LAST_UPDATED_BY", "LAST_UPDATED_DATE", "CANCELLED_DATE", "CANCELLED_BY", "LINE_COUNT", "ITEM_LINE_COUNT", "TAX_LINE_COUNT", "DISTRIBUTION_COUNT", "PROJECT_COUNT", "TASK_COUNT", "PO_COUNT", "PR_COUNT", "RECEIPT_COUNT", "PO_NUMBERS", "PR_NUMBERS", "DISTRIBUTED_AMOUNT_AED") DEFAULT COLLATION "USING_NLS_COMP"  AS
  WITH line_agg AS (
  SELECT invoice_id,
         COUNT(*)                                              AS line_count,
         COUNT(CASE WHEN invoice_line_type = 'Item' THEN 1 END) AS item_line_count,
         COUNT(CASE WHEN invoice_line_type = 'Tax'  THEN 1 END) AS tax_line_count
  FROM prod.ap_invoice_lines
  GROUP BY invoice_id
),
dist_agg AS (
  SELECT invoice_id,
         COUNT(*)                        AS distribution_count,
         COUNT(DISTINCT project_id)      AS project_count,
         COUNT(DISTINCT task_id)         AS task_count,
         COUNT(DISTINCT po_number)       AS po_count,
         COUNT(DISTINCT requisition)     AS pr_count,
         COUNT(DISTINCT receipt_number)  AS receipt_count,
         SUM(CASE WHEN NVL(reversal_indicator,'N') <> 'Y'
                  THEN NVL(distribution_amount_functi, distribution_amount) END) AS distributed_amount_aed,
         LISTAGG(DISTINCT TO_CHAR(po_number),   ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY TO_CHAR(po_number))   AS po_numbers,
         LISTAGG(DISTINCT TO_CHAR(requisition), ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY TO_CHAR(requisition)) AS pr_numbers
  FROM prod.ap_invoice_distributions
  GROUP BY invoice_id
)
SELECT
  i.invoice_id,
  i.invoice_number,
  i.invoice_type,
  i.invoice_date,
  i.invoice_description,
  CASE WHEN i.cancelled_date IS NOT NULL
         OR i.validation_status = 'Canceled' THEN 'Cancelled'
       ELSE i.validation_status END                            AS invoice_status,
  -- supplier ------------------------------------------------------------
  i.supplier_number,
  i.supplier_name,
  i.beneficiary_name,
  i.site                                                       AS supplier_site,
  i.party_site_name,
  i.party_site_city,
  i.party_site_country,
  i.email                                                      AS supplier_email,
  -- amounts --------------------------------------------------------------
  NVL(i.invoice_currency,'AED')                                AS invoice_currency,
  i.invoice_amount,
  i.total_tax_charged,
  NVL(i.invoice_amount_functional, i.invoice_amount)           AS invoice_amount_aed,
  i.conversion_rate,
  i.conversion_rate_type,
  i.conversion_date,
  NVL(i.invoice_amount_paid,0)                                 AS amount_paid,
  NVL(i.invoice_amount,0) - NVL(i.invoice_amount_paid,0)       AS balance_due,
  CASE WHEN NVL(i.invoice_amount,0) = 0 THEN 'Unpaid'
       WHEN ABS(NVL(i.invoice_amount_paid,0)) >= ABS(NVL(i.invoice_amount,0)) - 0.005 THEN 'Paid'
       WHEN NVL(i.invoice_amount_paid,0) <> 0 THEN 'Partially Paid'
       ELSE 'Unpaid' END                                       AS payment_status,
  -- statuses ---------------------------------------------------------------
  i.validation_status,
  i.accounting_status,
  i.funds_status,
  -- payment terms ------------------------------------------------------------
  i.payment_terms,
  i.terms_date,
  i.payment_method,
  i.pay_group,
  i.payment_currency,
  i.pay_alone_flag,
  -- references ------------------------------------------------------------
  i.po_number                                                  AS header_po_number,
  i.voucher_num,
  i.invoice_source,
  i.header_batch_name                                          AS batch_name,
  i.requester,
  i.intercompany_invoice,
  -- dates and people ---------------------------------------------------------
  i.budget_date,
  i.gl_date,
  i.entered_date,
  i.invoice_received_date,
  i.created_by_username                                        AS created_by,
  i.created_date,
  i.last_updated_by_username                                   AS last_updated_by,
  i.last_updated_date,
  i.cancelled_date,
  i.cancelled_by_username                                      AS cancelled_by,
  -- statistics from lines and distributions -----------------------------------
  NVL(la.line_count,0)                                         AS line_count,
  NVL(la.item_line_count,0)                                    AS item_line_count,
  NVL(la.tax_line_count,0)                                     AS tax_line_count,
  NVL(da.distribution_count,0)                                 AS distribution_count,
  NVL(da.project_count,0)                                      AS project_count,
  NVL(da.task_count,0)                                         AS task_count,
  NVL(da.po_count,0)                                           AS po_count,
  NVL(da.pr_count,0)                                           AS pr_count,
  NVL(da.receipt_count,0)                                      AS receipt_count,
  da.po_numbers,
  da.pr_numbers,
  NVL(da.distributed_amount_aed,0)                             AS distributed_amount_aed
FROM prod.ap_invoices i
LEFT JOIN line_agg la ON la.invoice_id = i.invoice_id
LEFT JOIN dist_agg da ON da.invoice_id = i.invoice_id;

CREATE OR REPLACE FORCE EDITIONABLE VIEW "PROD"."AP_INVOICE_LINES_V" ("INVOICE_ID", "INVOICE_NUMBER", "SUPPLIER_NAME", "INVOICE_DATE", "INVOICE_TYPE", "INVOICE_STATUS", "VALIDATION_STATUS", "ACCOUNTING_STATUS", "INVOICE_FUNDS_STATUS", "PAYMENT_STATUS", "CANCELLED_DATE", "INVOICE_LINE_NUMBER", "INVOICE_LINE_TYPE", "LINE_DESCRIPTION", "INVOICE_CURRENCY", "LINE_AMOUNT", "INCLUDED_TAX_AMOUNT", "LINE_AMOUNT_AED", "RETAINED_AMOUNT", "ACTIVE_HOLDS", "FUND_STATUS", "COMPLETION_FLAG", "ASSET_FLAG", "BUDGET_DATE", "PERIOD_NAME", "PO_NUMBER", "PO_LINE_NUMBER", "PO_SCHEDULE", "PO_DISTRIBUTION_LINE", "PO_DESCRIPTION", "PO_STATUS", "RECEIPT_NUMBER", "RECEIPT_LINE", "RECEIPT_DATE", "PROJECT_NUMBER", "PROJECT_NAME", "TASK_NUMBER", "TASK_NAME", "EXPENDITURE_TYPE", "EXPENDITURE_ITEM_DATE", "EXPENDITURE_ORGANIZATION", "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATED_DATE", "DISTRIBUTION_COUNT", "DISTRIBUTED_AMOUNT_AED") DEFAULT COLLATION "USING_NLS_COMP"  AS
  WITH proj_by_num AS (
  SELECT project_number, MAX(project_name) AS project_name
  FROM prod.projects
  GROUP BY project_number
),
task_by_num AS (
  SELECT task_number, MAX(task_name) AS task_name
  FROM prod.tasks
  GROUP BY task_number
),
po_hdr AS (
  SELECT order_number,
         MAX(order_description) AS po_description,
         MAX(status)            AS po_status
  FROM prod.po_headers
  GROUP BY order_number
),
dist_agg AS (
  SELECT invoice_id, line_number,
         COUNT(*) AS distribution_count,
         SUM(CASE WHEN NVL(reversal_indicator,'N') <> 'Y'
                  THEN NVL(distribution_amount_functi, distribution_amount) END) AS distributed_amount_aed
  FROM prod.ap_invoice_distributions
  GROUP BY invoice_id, line_number
)
SELECT
  l.invoice_id,
  i.invoice_number,
  i.supplier_name,
  i.invoice_date,
  i.invoice_type,
  -- invoice-level statuses (from the invoice header) -----------------------
  CASE WHEN i.cancelled_date IS NOT NULL
         OR i.validation_status = 'Canceled' THEN 'Cancelled'
       ELSE i.validation_status END                            AS invoice_status,
  i.validation_status,
  i.accounting_status,
  i.funds_status                                               AS invoice_funds_status,
  CASE WHEN NVL(i.invoice_amount,0) = 0 THEN 'Unpaid'
       WHEN ABS(NVL(i.invoice_amount_paid,0)) >= ABS(NVL(i.invoice_amount,0)) - 0.005 THEN 'Paid'
       WHEN NVL(i.invoice_amount_paid,0) <> 0 THEN 'Partially Paid'
       ELSE 'Unpaid' END                                       AS payment_status,
  i.cancelled_date,
  l.invoice_line_number,
  l.invoice_line_type,
  l.line_description,
  -- amounts --------------------------------------------------------------
  NVL(i.invoice_currency,'AED')                                AS invoice_currency,
  l.line_amount,
  l.included_tax_amount,
  NVL(l.line_amount_functional, l.line_amount)                 AS line_amount_aed,
  l.invoice_line_retained_amou                                 AS retained_amount,
  l.total_of_active_holds                                      AS active_holds,
  -- status ---------------------------------------------------------------
  l.fund_status,
  l.completion_flag,
  l.asset                                                      AS asset_flag,
  l.budget_date,
  l.period_name,
  -- purchase order reference ------------------------------------------------
  l.po_number,
  l.po_line_number,
  l.po_schedule,
  l.po_distribution                                            AS po_distribution_line,
  ph.po_description,
  ph.po_status,
  -- receipt reference ---------------------------------------------------------
  l.receipt_number,
  l.receipt_schedule_line_numb                                 AS receipt_line,
  l.receipt_date,
  -- project costing ------------------------------------------------------------
  TO_CHAR(l.project_number)                                    AS project_number,
  pj.project_name,
  l.task_number,
  tk.task_name,
  l.expenditure_type,
  l.expenditure_item_date,
  l.expenditure_organization,
  -- audit -------------------------------------------------------------------
  l.created_by_username                                        AS created_by,
  l.creation_date,
  l.updated_by_username                                        AS last_updated_by,
  l.last_updated_date,
  -- distribution statistics ---------------------------------------------------
  NVL(da.distribution_count,0)                                 AS distribution_count,
  NVL(da.distributed_amount_aed,0)                             AS distributed_amount_aed
FROM prod.ap_invoice_lines l
LEFT JOIN prod.ap_invoices i  ON i.invoice_id = l.invoice_id
LEFT JOIN proj_by_num pj      ON TO_CHAR(pj.project_number) = TO_CHAR(l.project_number)
LEFT JOIN task_by_num tk      ON tk.task_number = l.task_number
LEFT JOIN po_hdr ph           ON ph.order_number = l.po_number
LEFT JOIN dist_agg da         ON da.invoice_id = l.invoice_id
                             AND da.line_number = l.invoice_line_number;

CREATE OR REPLACE FORCE EDITIONABLE VIEW "PROD"."AP_INVOICE_DISTRIBUTIONS_V" ("INVOICE_ID", "INVOICE_NUMBER", "SUPPLIER_NAME", "INVOICE_DATE", "INVOICE_TYPE", "INVOICE_STATUS", "VALIDATION_STATUS", "ACCOUNTING_STATUS", "INVOICE_FUNDS_STATUS", "PAYMENT_STATUS", "CANCELLED_DATE", "INVOICE_LINE_NUMBER", "DISTRIBUTION_LINE_NUMBER", "DISTRIBUTION_TYPE", "DISTRIBUTION_DESCRIPTION", "INVOICE_CURRENCY", "DISTRIBUTION_AMOUNT", "DISTRIBUTION_AMOUNT_AED", "RETAINED_AMOUNT", "DISTRIBUTION_STATUS", "IS_REVERSED", "POSTING_STATUS", "FUND_STATUS", "ACCOUNTING_DATE", "PERIOD_NAME", "MATCH_TYPE", "PO_NUMBER", "PO_LINE", "PO_SCHEDULE", "PO_DISTRIBUTION_LINE", "PO_DESCRIPTION", "PO_STATUS", "PR_NUMBER", "PR_DESCRIPTION", "PR_PREPARER", "PR_APPROVED_DATE", "RECEIPT_NUMBER", "PROJECT_NUMBER", "PROJECT_NAME", "TASK_NUMBER", "TASK_NAME", "EXPENDITURE_TYPE", "CHARGE_ACCOUNT", "ACCOUNT_CODE", "ACCOUNT_DESC", "COST_CENTER_CODE", "COST_CENTER_DESC", "APPROPRIATION_CODE", "APPROPRIATION_DESC", "ENTITY_SPECIFIC_CODE", "ENTITY_SPECIFIC_DESC", "SECTOR_NAME", "CHAPTER_NAME", "PROGRAM_NAME", "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATED_DATE") DEFAULT COLLATION "USING_NLS_COMP"  AS
  WITH ap_po_match AS (
  SELECT ph.order_number AS po_number, pl.line AS po_line,
         pod.distribution_number AS po_dist_line,
         prod.dct_cc_canon(MAX(pod.charge_account)) AS charge_account
  FROM prod.po_distributions pod
  JOIN prod.po_lines   pl ON pl.po_header_id = pod.po_header_id AND pl.po_line_id = pod.po_line_id
  JOIN prod.po_headers ph ON ph.po_header_id = pod.po_header_id
  GROUP BY ph.order_number, pl.line, pod.distribution_number
),
po_hdr AS (
  SELECT order_number,
         MAX(order_description) AS po_description,
         MAX(status)            AS po_status
  FROM prod.po_headers
  GROUP BY order_number
),
pr_hdr AS (
  SELECT pr_number,
         MAX(description)   AS pr_description,
         MAX(preparer_name) AS pr_preparer,
         MAX(approved_date) AS pr_approved_date
  FROM prod.pr_headers
  GROUP BY pr_number
),
proj_by_id AS (
  SELECT project_id, MAX(project_number) AS project_number, MAX(project_name) AS project_name
  FROM prod.projects
  GROUP BY project_id
),
task_by_id AS (
  SELECT task_id, MAX(task_number) AS task_number, MAX(task_name) AS task_name
  FROM prod.tasks
  GROUP BY task_id
)
SELECT
  d.invoice_id,
  i.invoice_number,
  i.supplier_name,
  i.invoice_date,
  i.invoice_type,
  -- invoice-level statuses (from the invoice header) -----------------------
  CASE WHEN i.cancelled_date IS NOT NULL
         OR i.validation_status = 'Canceled' THEN 'Cancelled'
       ELSE i.validation_status END                            AS invoice_status,
  i.validation_status,
  i.accounting_status,
  i.funds_status                                               AS invoice_funds_status,
  CASE WHEN NVL(i.invoice_amount,0) = 0 THEN 'Unpaid'
       WHEN ABS(NVL(i.invoice_amount_paid,0)) >= ABS(NVL(i.invoice_amount,0)) - 0.005 THEN 'Paid'
       WHEN NVL(i.invoice_amount_paid,0) <> 0 THEN 'Partially Paid'
       ELSE 'Unpaid' END                                       AS payment_status,
  i.cancelled_date,
  d.line_number                                                AS invoice_line_number,
  d.distribution_line_number,
  d.distribution_type,
  d.distribution_description,
  -- amounts --------------------------------------------------------------
  NVL(i.invoice_currency,'AED')                                AS invoice_currency,
  d.distribution_amount,
  NVL(d.distribution_amount_functi, d.distribution_amount)     AS distribution_amount_aed,
  d.distribution_retained_amou                                 AS retained_amount,
  -- status ---------------------------------------------------------------
  CASE WHEN NVL(d.reversal_indicator,'N') = 'Y' THEN 'Reversed'
       WHEN d.posted_indicator = 'Y'            THEN 'Posted'
       ELSE 'Unposted' END                                     AS distribution_status,
  NVL(d.reversal_indicator,'N')                                AS is_reversed,
  d.posting_status,
  d.fund_status,
  d.accounting_date,
  d.period_name,
  d.match_type,
  -- purchase order reference ------------------------------------------------
  d.po_number,
  d.po_line,
  d.po_schedule,
  d.po_distribution_line,
  ph.po_description,
  ph.po_status,
  -- purchase requisition reference (from the distribution) ----------------------
  d.requisition                                                AS pr_number,
  prh.pr_description,
  prh.pr_preparer,
  prh.pr_approved_date,
  -- receipt reference ---------------------------------------------------------
  d.receipt_number,
  -- project costing ------------------------------------------------------------
  TO_CHAR(pj.project_number)                                   AS project_number,
  pj.project_name,
  tk.task_number,
  tk.task_name,
  d.expenditure_type,
  -- effective charge account (PO charge account when matched, else own) ---------
  COALESCE(pm.charge_account, cid.cc_string)                   AS charge_account,
  coa.account_code,
  coa.account_desc,
  coa.cost_center_code,
  coa.cost_center_desc,
  coa.appropriation_code,
  coa.appropriation_desc,
  coa.entity_specific_code,
  coa.entity_specific_desc,
  coa.sector_name,
  coa.chapter_name,
  coa.program_name,
  -- audit -------------------------------------------------------------------
  d.created_by_username                                        AS created_by,
  d.creation_date,
  d.last_updated_by_username                                   AS last_updated_by,
  d.last_updated_date
FROM prod.ap_invoice_distributions d
LEFT JOIN prod.ap_invoices i   ON i.invoice_id = d.invoice_id
LEFT JOIN ap_po_match pm       ON pm.po_number    = d.po_number
                              AND pm.po_line      = d.po_line
                              AND pm.po_dist_line = d.po_distribution_line
LEFT JOIN prod.dct_gl_coa_snap cid ON cid.cc_id = d.cc_id
LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = COALESCE(pm.charge_account, cid.cc_string)
LEFT JOIN po_hdr ph            ON ph.order_number = d.po_number
LEFT JOIN pr_hdr prh           ON prh.pr_number = d.requisition
LEFT JOIN proj_by_id pj        ON pj.project_id = d.project_id
LEFT JOIN task_by_id tk        ON tk.task_id    = d.task_id;

ALTER PACKAGE prod.dct_ap_pkg COMPILE BODY;

PROMPT === verification -- expect zero INVALID rows ===
SELECT object_name, object_type, status FROM all_objects
 WHERE owner = 'PROD' AND status = 'INVALID'
   AND (object_name LIKE 'AP_INVOICE%' OR object_name = 'DCT_AP_PKG');
