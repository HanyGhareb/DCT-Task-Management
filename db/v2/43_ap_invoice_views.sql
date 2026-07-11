-- ===========================================================================
-- AP Invoice end-user reporting views (db/v2/43)
-- ---------------------------------------------------------------------------
-- Three user-friendly views over the Fusion-loaded AP invoice data, one per
-- document level. Every internal surrogate id (project_id, task_id, cc_id,
-- po_header_id ...) is resolved to its business number / name; the only id
-- kept is INVOICE_ID, the technical key that links the three levels together
-- (invoice_number alone is not guaranteed unique across suppliers).
--
--   AP_INVOICES_HEADER_V       : one row per invoice (source ATD_AP_INVOICES
--                                via the ap_invoices pass-through; the orphan
--                                ATD_AP_INVOICE_HEADER table was empty and
--                                was dropped 2026-07-11, db/v2/44). All
--                                header attributes + derived invoice /
--                                payment status + statistics: line count,
--                                distribution count, project / task counts,
--                                PO count, PR count (PRs read from the
--                                distributions' REQUISITION column), receipt
--                                count, and the distinct PO / PR number lists.
--   AP_INVOICE_LINES_V         : one row per invoice line, with PO context
--                                (number, line, description, status), receipt
--                                info, project / task names, expenditure
--                                info, AED amounts and per-line distribution
--                                statistics.
--   AP_INVOICE_DISTRIBUTIONS_V : one row per invoice distribution, with the
--                                matched PO reference, the related PR
--                                (REQUISITION -> pr_headers: number,
--                                description, preparer, approved date),
--                                project / task names, the effective charge
--                                account (PO charge account when matched,
--                                else the distribution's own combination,
--                                per the db/v2/32 join model) + its COA
--                                descriptions (account, cost center, sector,
--                                chapter, program), AED amounts and a
--                                friendly distribution status.
--
-- Conventions inherited from the actuals reporting layer (db/v2/32 + 36):
--   * sources are the base pass-through views (ap_invoices, ap_invoice_lines,
--     ap_invoice_distributions, po_headers, pr_headers, projects, tasks,
--     dct_gl_coa_snap) - never the physical ATD_* tables;
--   * AP AED amount = NVL(amount_functional, amount) - FUNCTIONAL is only
--     populated for non-AED invoices;
--   * PO charge accounts are canonicalized through prod.dct_cc_canon;
--   * reversed distributions stay VISIBLE here (flagged IS_REVERSED = 'Y',
--     status 'Reversed') because these are document-inquiry views, not
--     actuals facts; only DISTRIBUTED_AMOUNT_AED at header / line level
--     excludes them so it reconciles to booked actuals. Header statistic
--     counts cover ALL rows the child views show.
--
-- Dates are Fusion business dates (loaded, not SYSDATE-written) - exposed
-- as-is, no dct_to_local conversion. All views owned by PROD; run with the
-- prod. prefix, no ALTER SESSION. Re-run AFTER db/v2/32 + 36 whenever the
-- pass-through views are rebuilt (dct_views_rebuild recompiles these
-- automatically).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

PROMPT === 1. AP_INVOICES_HEADER_V ===
CREATE OR REPLACE VIEW prod.ap_invoices_header_v AS
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
  i.attachment_flag                                            AS has_attachment,
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

PROMPT === 2. AP_INVOICE_LINES_V ===
CREATE OR REPLACE VIEW prod.ap_invoice_lines_v AS
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

PROMPT === 3. AP_INVOICE_DISTRIBUTIONS_V ===
CREATE OR REPLACE VIEW prod.ap_invoice_distributions_v AS
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

PROMPT ============================================================
PROMPT  43_ap_invoice_views.sql complete.
PROMPT  3 views: AP_INVOICES_HEADER_V, AP_INVOICE_LINES_V,
PROMPT  AP_INVOICE_DISTRIBUTIONS_V.
PROMPT ============================================================
