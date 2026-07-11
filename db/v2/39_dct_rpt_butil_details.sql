-- ===========================================================================
-- DCT Budget Utilization detail views (db/v2/39)
-- ---------------------------------------------------------------------------
-- Line-level supporting views for the executive "Budget Utilization by
-- Sector" report (Reporting Platform / App 211, definition
-- BUDGET_UTIL_SECTOR in reporting/db/08). All five share the SAME row keys
-- as prod.dct_budget_utilization_v (db/v2/37): budget_year + project /
-- task keys built with the identical fallback pattern
-- (project_number else #project_id ; task_number else #task_id), so every
-- report part reconciles with the utilization figures.
--
--   DCT_BUTIL_SCOPE_V      : distinct sector / project-type / cost-centre
--                            attributes per budget_year x project x task --
--                            the report's sector filter joins through this.
--   DCT_UNPAID_INVOICES_V  : project-costed AP invoices with a computed
--                            payment status (Unpaid / Partially Paid / Paid,
--                            from invoice_amount_paid vs invoice_amount) at
--                            budget_year x invoice x project x task x
--                            expenditure-type grain. Includes PO-matched
--                            invoices (HAS_PO flag); the no-PO subset is what
--                            feeds the utilization Actual AP figure.
--   DCT_UNINVOICED_GRN_V   : per PO distribution -- received (GRN, AED)
--                            minus AP invoiced against that distribution
--                            (matched via order/line/distribution number);
--                            rows where the uninvoiced balance > 0.005.
--                            budget_year = PO distribution budget_date year.
--   DCT_OPEN_PO_LINES_V    : open-obligation PO distributions (funds_status
--                            Reserved / Partially Liquidated), GRN-netted
--                            open amount, same filters as the utilization
--                            obligation_po figure. Zero-open rows excluded.
--   DCT_RESERVED_PR_LINES_V: PR distributions with funds_status Reserved
--                            (the open-commitment lines), AED via the
--                            DCT_CURRENCY_CODES snapshot rate.
--
-- All amounts AED. Sources: base pass-through views (db/v2/32 + 36) +
-- prod.dct_budget_utilization_v (db/v2/37). Re-run AFTER 37 whenever 32/36
-- are re-run. Run with the prod. prefix in a fresh session; ADMIN synonyms
-- are NOT needed (the Python engine queries prod.* directly).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

PROMPT === 1. DCT_BUTIL_SCOPE_V ===
CREATE OR REPLACE VIEW prod.dct_butil_scope_v AS
SELECT DISTINCT
       budget_year,
       sector,
       project_type,
       cost_centre,
       department,
       project_number,
       project_name,
       task_number
FROM prod.dct_budget_utilization_v;

PROMPT === 2. DCT_UNPAID_INVOICES_V ===
CREATE OR REPLACE VIEW prod.dct_unpaid_invoices_v AS
WITH proj AS (
  SELECT project_id, MAX(project_number) AS project_number, MAX(project_name) AS project_name
  FROM prod.projects GROUP BY project_id
),
tsk AS (
  SELECT task_id, MAX(task_number) AS task_number FROM prod.tasks GROUP BY task_id
)
SELECT
  EXTRACT(YEAR FROM d.accounting_date)                                  AS budget_year,
  COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id))      AS project_number,
  MAX(pj.project_name)                                                  AS project_name,
  COALESCE(tk.task_number,
           CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END) AS task_number,
  d.expenditure_type,
  i.invoice_number,
  MAX(i.invoice_date)                                                   AS invoice_date,
  MAX(i.supplier_name)                                                  AS supplier_name,
  MAX(NVL(i.invoice_currency,'AED'))                                    AS invoice_currency,
  MAX(i.invoice_amount)                                                 AS invoice_amount,
  MAX(NVL(i.invoice_amount_paid,0))                                     AS invoice_amount_paid,
  MAX(NVL(i.invoice_amount,0)) - MAX(NVL(i.invoice_amount_paid,0))      AS balance_due,
  SUM(NVL(d.distribution_amount_functi, d.distribution_amount))         AS matched_aed,
  MAX(i.validation_status)                                              AS validation_status,
  MAX(CASE WHEN NVL(i.invoice_amount,0) = 0 THEN 'Unpaid'
           WHEN ABS(NVL(i.invoice_amount_paid,0)) >= ABS(NVL(i.invoice_amount,0)) - 0.005 THEN 'Paid'
           WHEN NVL(i.invoice_amount_paid,0) <> 0 THEN 'Partially Paid'
           ELSE 'Unpaid' END)                                           AS payment_status,
  MAX(CASE WHEN d.po_number IS NOT NULL THEN 'Y' ELSE 'N' END)          AS has_po
FROM prod.ap_invoice_distributions d
JOIN prod.ap_invoices i ON i.invoice_id = d.invoice_id
LEFT JOIN proj pj ON pj.project_id = d.project_id
LEFT JOIN tsk  tk ON tk.task_id    = d.task_id
WHERE NVL(d.reversal_indicator,'N') <> 'Y'
  AND d.project_id IS NOT NULL
  AND i.validation_status IN ('Validated','Unpaid','Available')
GROUP BY EXTRACT(YEAR FROM d.accounting_date),
         COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id)),
         COALESCE(tk.task_number,
                  CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END),
         d.expenditure_type,
         i.invoice_number;

PROMPT === 3. DCT_UNINVOICED_GRN_V ===
CREATE OR REPLACE VIEW prod.dct_uninvoiced_grn_v AS
WITH proj AS (
  SELECT project_id, MAX(project_number) AS project_number, MAX(project_name) AS project_name
  FROM prod.projects GROUP BY project_id
),
tsk AS (
  SELECT task_id, MAX(task_number) AS task_number FROM prod.tasks GROUP BY task_id
),
po_dist AS (
  SELECT po_distribution_id,
         MAX(po_header_id)                      AS po_header_id,
         MAX(po_line_id)                        AS po_line_id,
         MAX(charge_account)                    AS charge_account,
         MAX(project_id)                        AS project_id,
         MAX(task_id)                           AS task_id,
         MAX(expenditure_type_name)             AS expenditure_type,
         MAX(budget_date)                       AS budget_date
  FROM prod.po_distributions
  GROUP BY po_distribution_id
),
grn AS (
  SELECT po_distribution_id,
         SUM(ledger_amount) AS received_aed,
         MAX(transaction_date)                            AS last_receipt_date,
         COUNT(*)                                         AS receipt_lines
  FROM prod.grn_all_v2
  GROUP BY po_distribution_id
),
pod_key AS (
  SELECT ph.order_number AS po_number, pl.line AS po_line,
         pod.distribution_number AS po_dist_line,
         MAX(pod.po_distribution_id) AS po_distribution_id
  FROM prod.po_distributions pod
  JOIN prod.po_lines   pl ON pl.po_header_id = pod.po_header_id AND pl.po_line_id = pod.po_line_id
  JOIN prod.po_headers ph ON ph.po_header_id = pod.po_header_id
  GROUP BY ph.order_number, pl.line, pod.distribution_number
),
ap_per_dist AS (
  SELECT pk.po_distribution_id,
         SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS invoiced_aed
  FROM prod.ap_invoice_distributions d
  JOIN pod_key pk ON pk.po_number    = d.po_number
                 AND pk.po_line      = d.po_line
                 AND pk.po_dist_line = d.po_distribution_line
  WHERE NVL(d.reversal_indicator,'N') <> 'Y'
  GROUP BY pk.po_distribution_id
)
SELECT
  EXTRACT(YEAR FROM b.budget_date)                                      AS budget_year,
  COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(b.project_id))      AS project_number,
  pj.project_name,
  COALESCE(tk.task_number,
           CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END) AS task_number,
  b.expenditure_type,
  h.order_number                                                        AS po_number,
  pl.line                                                               AS po_line,
  h.supplier_name,
  g.last_receipt_date,
  g.receipt_lines,
  g.received_aed,
  NVL(a.invoiced_aed,0)                                                 AS invoiced_aed,
  g.received_aed - NVL(a.invoiced_aed,0)                                AS uninvoiced_aed
FROM po_dist b
JOIN grn g               ON g.po_distribution_id = b.po_distribution_id
LEFT JOIN ap_per_dist a  ON a.po_distribution_id = b.po_distribution_id
LEFT JOIN prod.po_headers h ON h.po_header_id = b.po_header_id
LEFT JOIN prod.po_lines  pl ON pl.po_header_id = b.po_header_id AND pl.po_line_id = b.po_line_id
LEFT JOIN proj pj ON pj.project_id = b.project_id
LEFT JOIN tsk  tk ON tk.task_id    = b.task_id
WHERE b.project_id IS NOT NULL
  AND b.charge_account IS NOT NULL
  AND g.received_aed - NVL(a.invoiced_aed,0) > 0.005;

PROMPT === 4. DCT_OPEN_PO_LINES_V ===
CREATE OR REPLACE VIEW prod.dct_open_po_lines_v AS
WITH proj AS (
  SELECT project_id, MAX(project_number) AS project_number, MAX(project_name) AS project_name
  FROM prod.projects GROUP BY project_id
),
tsk AS (
  SELECT task_id, MAX(task_number) AS task_number FROM prod.tasks GROUP BY task_id
),
po_dist AS (
  SELECT po_distribution_id,
         MAX(po_header_id)                      AS po_header_id,
         MAX(po_line_id)                        AS po_line_id,
         MAX(charge_account)                    AS charge_account,
         MAX(project_id)                        AS project_id,
         MAX(task_id)                           AS task_id,
         MAX(expenditure_type_name)             AS expenditure_type,
         MAX(budget_date)                       AS budget_date,
         MAX(distribution_amount * NVL(rate,1)) AS line_aed,
         MAX(funds_status)                      AS funds_status
  FROM prod.po_distributions
  GROUP BY po_distribution_id
),
grn_per_dist AS (
  SELECT po_distribution_id,
         SUM(ledger_amount) AS received_aed
  FROM prod.grn_all_v2
  GROUP BY po_distribution_id
)
SELECT
  EXTRACT(YEAR FROM b.budget_date)                                      AS budget_year,
  COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(b.project_id))      AS project_number,
  pj.project_name,
  COALESCE(tk.task_number,
           CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END) AS task_number,
  b.expenditure_type,
  h.order_number                                                        AS po_number,
  pl.line                                                               AS po_line,
  b.budget_date,
  h.supplier_name,
  b.funds_status,
  b.line_aed,
  NVL(g.received_aed,0)                                                 AS received_aed,
  GREATEST(b.line_aed - NVL(g.received_aed,0), 0)                       AS open_aed
FROM po_dist b
LEFT JOIN grn_per_dist g ON g.po_distribution_id = b.po_distribution_id
LEFT JOIN prod.po_headers h ON h.po_header_id = b.po_header_id
LEFT JOIN prod.po_lines  pl ON pl.po_header_id = b.po_header_id AND pl.po_line_id = b.po_line_id
LEFT JOIN proj pj ON pj.project_id = b.project_id
LEFT JOIN tsk  tk ON tk.task_id    = b.task_id
WHERE b.funds_status IN ('Reserved','Partially Liquidated')
  AND b.project_id IS NOT NULL
  AND b.charge_account IS NOT NULL
  AND GREATEST(b.line_aed - NVL(g.received_aed,0), 0) > 0.005;

PROMPT === 5. DCT_RESERVED_PR_LINES_V ===
CREATE OR REPLACE VIEW prod.dct_reserved_pr_lines_v AS
WITH proj AS (
  SELECT project_id, MAX(project_number) AS project_number, MAX(project_name) AS project_name
  FROM prod.projects GROUP BY project_id
),
tsk AS (
  SELECT task_id, MAX(task_number) AS task_number FROM prod.tasks GROUP BY task_id
)
SELECT
  EXTRACT(YEAR FROM d.budget_date)                                      AS budget_year,
  COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id))      AS project_number,
  pj.project_name,
  COALESCE(tk.task_number,
           CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END) AS task_number,
  d.expenditure_type,
  d.requisition                                                         AS pr_number,
  h.description,
  d.budget_date,
  NVL(d.currency_code,'AED')                                            AS currency_code,
  d.distribution_amount,
  d.distribution_amount * NVL(cc.exchange_rate_to_aed,1)                AS amount_aed,
  d.funds_status
FROM prod.pr_distributions d
LEFT JOIN prod.pr_headers h ON h.pr_header_id = d.pr_header_id
LEFT JOIN prod.dct_currency_codes cc ON cc.currency_code = d.currency_code
LEFT JOIN proj pj ON pj.project_id = d.project_id
LEFT JOIN tsk  tk ON tk.task_id    = d.task_id
WHERE d.funds_status = 'Reserved'
  AND d.project_id IS NOT NULL
  AND d.charge_account IS NOT NULL;

PROMPT ============================================================
PROMPT  38_dct_rpt_butil_details.sql complete.
PROMPT  5 views: butil scope, unpaid invoices, uninvoiced GRN,
PROMPT  open PO lines, reserved PR lines.
PROMPT ============================================================
