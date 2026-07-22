-- ===========================================================================
-- DCT GL Reconciliation views (db/v2/105)
-- ---------------------------------------------------------------------------
-- Data-integrity reconciliation of the two GL dashboards:
--   Actuals  (DCT_BUDGET_ACTUAL_PERIOD_V, grain = GL combination x period) vs
--   Budget Utilization (DCT_BUDGET_UTILIZATION_V, grain = year x project x
--                       task x expenditure-type).
--
-- TWO views:
--
-- 1. DCT_GL_RECON_FACT_V -- the CONSUMPTION bridge fact. ONE tagged fact for
--    AP / GRN / PR / PO built from the SAME source tables both dashboards read,
--    carrying BOTH sides at once via classification flags so the difference
--    always decomposes with ZERO unexplained residual:
--      has_project   : the transaction carries a project (Butil requires it).
--      ap_valid      : AP invoice validation_status IN (Validated,Unpaid,
--                      Available) (Butil requires it; 'Y' for non-AP).
--      on_budget_line: the (year, project, task, etype) exists in
--                      PROJECTS_BUDGET with budget>0 (Butil's HAVING drops the
--                      rest -- "orphan consumption").
--      in_actuals = 'Y' for every row (the Actuals side counts by GL
--                   combination, no project/validation/budget filter).
--      in_butil   = has_project AND ap_valid AND on_budget_line.
--    => Actuals side  = SUM(amt)                 (in_actuals='Y' = all)
--       Butil side    = SUM(amt) WHERE in_butil='Y'
--       Difference    = SUM(amt) WHERE in_butil='N', partitioned EXACTLY into:
--         no_project      (has_project='N')
--         ap_validation   (has_project='Y' AND ap_valid='N')
--         no_budget_line  (has_project='Y' AND ap_valid='Y' AND on_budget_line='N')
--    The three buckets are mutually exclusive and cover in_butil='N' with no
--    remainder, so the bridge is closed by construction; the ACTIONABLE signal
--    is the SIZE of each bucket (esp. no_budget_line = spend on un-budgeted
--    project lines).
--
--    PERIOD ALIGNMENT: honours SYS_CONTEXT('GL_CTX','BUTIL_END') (the same
--    prod.dct_gl_class_pkg.set_butil_end context Budget Utilization uses) on
--    every fact date, so the /gl/recon handler reconciles Actuals@period vs
--    Butil@period -- the period-window difference cancels out. NOTE this makes
--    the Actuals side of PR/PO YEAR-scoped (EXTRACT(YEAR)=budget_year), i.e. a
--    like-for-like against Butil, NOT the standalone Actuals dashboard's
--    cumulative-across-years open figure (that divergence is documented as a
--    latent basis difference; recon deliberately aligns them).
--    GRN uses NVL(accounted_date,transaction_date) on BOTH sides (accounting
--    basis) -- the Actuals dashboard uses transaction_date; currently equal.
--
-- 2. DCT_GL_RECON_GLBUDGET_V -- GL budget (GL_BALANCES ledger) per
--    (period x GL combination) enriched with COA dims + account_type +
--    chapter_code, so the /gl/recon handler can scope it to Expense + a
--    selectable chapter set (default CH2..CH5) and sum YTD to the selected
--    period. This is the ONLY comparable GL budget basis vs the PPM project
--    budget -- the two budgets live in DIFFERENT Fusion ledgers with no shared
--    key, so budget reconciles only in aggregate / by dimension, never line to
--    line (PPM budget side is aggregated from DCT_BUDGET_UTILIZATION_V).
--
-- Requires prod.dct_gl_coa_snap (db/v2/33), prod.dct_cc_canon (db/v2/40),
-- prod.gl_balances_cc (db/v2/32), base fact views (db/v2/32+36),
-- prod.projects_budget / projects / tasks. DEPLOY: run after 37 (fresh session
-- or as ADMIN); re-run 32 first after any ATD reload so the SELECT * base views
-- expose current columns. Feeds GL/db/14 (/gl/recon ORDS).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

-- ---------------------------------------------------------------------------
-- 1. Consumption bridge fact
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW prod.dct_gl_recon_fact_v AS
WITH
proj AS (SELECT project_id, MAX(project_number) AS project_number FROM prod.projects GROUP BY project_id),
tsk  AS (SELECT task_id, MAX(task_number) AS task_number FROM prod.tasks GROUP BY task_id),
bl AS (  -- budget-line existence set: (year,project,task,etype) with budget>0
  SELECT b.budget_year,
         COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(b.project_id)) AS project_key,
         COALESCE(tk.task_number,'#'||TO_CHAR(b.task_id))                AS task_key,
         b.expenditure_type
  FROM prod.projects_budget b
  LEFT JOIN proj pj ON pj.project_id = b.project_id
  LEFT JOIN tsk  tk ON tk.task_id    = b.task_id
  GROUP BY b.budget_year,
           COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(b.project_id)),
           COALESCE(tk.task_number,'#'||TO_CHAR(b.task_id)), b.expenditure_type
  HAVING SUM(b.budget) > 0
),
po_dist AS (  -- one row per PO distribution (collapse physical dups)
  SELECT po_distribution_id,
         prod.dct_cc_canon(MAX(charge_account)) AS charge_account,
         MAX(po_header_id)                      AS po_header_id,
         MAX(project_id)                        AS project_id,
         MAX(task_id)                           AS task_id,
         MAX(expenditure_type_name)             AS expenditure_type,
         MAX(budget_date)                       AS budget_date,
         MAX(distribution_amount * NVL(rate,1)) AS amt_aed,
         MAX(funds_status)                      AS funds_status
  FROM prod.po_distributions
  GROUP BY po_distribution_id
),
po_hdr_status AS (
  SELECT po_header_id, MAX(status) AS po_status FROM prod.po_headers GROUP BY po_header_id
),
grn_per_dist AS (  -- total GRN per distribution (Open Obligation netting), period-aware
  SELECT po_distribution_id, SUM(ledger_amount) AS grn_aed
  FROM prod.grn_all_v2
  WHERE (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
         OR NVL(accounted_date, transaction_date)
            < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
  GROUP BY po_distribution_id
),
f_raw AS (
  -- AP Direct (no-PO AP distributions)
  SELECT 'AP' AS measure,
         EXTRACT(YEAR FROM d.accounting_date) AS budget_year,
         cid.cc_string,
         COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(d.project_id)) AS project_key,
         COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END) AS task_key,
         d.expenditure_type,
         CASE WHEN d.project_id IS NOT NULL THEN 'Y' ELSE 'N' END AS has_project,
         CASE WHEN i.validation_status IN ('Validated','Unpaid','Available') THEN 'Y' ELSE 'N' END AS ap_valid,
         NVL(d.distribution_amount_functi, d.distribution_amount) AS amt
  FROM prod.ap_invoice_distributions d
  JOIN prod.ap_invoices i ON i.invoice_id = d.invoice_id
  JOIN prod.dct_gl_coa_snap cid ON cid.cc_id = d.cc_id
  LEFT JOIN proj pj ON pj.project_id = d.project_id
  LEFT JOIN tsk  tk ON tk.task_id    = d.task_id
  WHERE d.po_number IS NULL
    AND NVL(d.reversal_indicator,'N') <> 'Y'
    AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
         OR d.accounting_date < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
  UNION ALL
  -- GRN (receipts) -- charge account via the PO distribution
  SELECT 'GRN' AS measure,
         EXTRACT(YEAR FROM NVL(g.accounted_date, g.transaction_date)) AS budget_year,
         pod.charge_account AS cc_string,
         COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(g.project_id)) AS project_key,
         COALESCE(tk.task_number, CASE WHEN g.task_id IS NOT NULL THEN '#'||TO_CHAR(g.task_id) END) AS task_key,
         g.expenditure_type,
         CASE WHEN g.project_id IS NOT NULL THEN 'Y' ELSE 'N' END AS has_project,
         'Y' AS ap_valid,
         g.ledger_amount AS amt
  FROM prod.grn_all_v2 g
  JOIN po_dist pod ON pod.po_distribution_id = g.po_distribution_id
  LEFT JOIN proj pj ON pj.project_id = g.project_id
  LEFT JOIN tsk  tk ON tk.task_id    = g.task_id
  WHERE pod.charge_account IS NOT NULL
    AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
         OR NVL(g.accounted_date, g.transaction_date)
            < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
  UNION ALL
  -- PR Open Commitment (Reserved requisition distributions)
  SELECT 'PR' AS measure,
         EXTRACT(YEAR FROM d.budget_date) AS budget_year,
         prod.dct_cc_canon(d.charge_account) AS cc_string,
         COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(d.project_id)) AS project_key,
         COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END) AS task_key,
         d.expenditure_type,
         CASE WHEN d.project_id IS NOT NULL THEN 'Y' ELSE 'N' END AS has_project,
         'Y' AS ap_valid,
         d.distribution_amount * NVL(cc.exchange_rate_to_aed,1) AS amt
  FROM prod.pr_distributions d
  LEFT JOIN prod.dct_currency_codes cc ON cc.currency_code = d.currency_code
  LEFT JOIN proj pj ON pj.project_id = d.project_id
  LEFT JOIN tsk  tk ON tk.task_id    = d.task_id
  WHERE d.funds_status = 'Reserved'
    AND d.charge_account IS NOT NULL
    AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
         OR d.budget_date < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
  UNION ALL
  -- PO Open Obligation (Reserved/Partial, not Finally Closed, GRN-netted)
  SELECT 'PO' AS measure,
         EXTRACT(YEAR FROM b.budget_date) AS budget_year,
         b.charge_account AS cc_string,
         COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(b.project_id)) AS project_key,
         COALESCE(tk.task_number, CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END) AS task_key,
         b.expenditure_type,
         CASE WHEN b.project_id IS NOT NULL THEN 'Y' ELSE 'N' END AS has_project,
         'Y' AS ap_valid,
         GREATEST(b.amt_aed - NVL(g.grn_aed,0), 0) AS amt
  FROM po_dist b
  LEFT JOIN grn_per_dist g ON g.po_distribution_id = b.po_distribution_id
  LEFT JOIN po_hdr_status hs ON hs.po_header_id = b.po_header_id
  LEFT JOIN proj pj ON pj.project_id = b.project_id
  LEFT JOIN tsk  tk ON tk.task_id    = b.task_id
  WHERE b.funds_status IN ('Reserved','Partially Liquidated')
    AND NVL(hs.po_status,'x') <> 'Finally Closed'
    AND b.charge_account IS NOT NULL
    AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
         OR b.budget_date < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
),
agg AS (
  SELECT measure, budget_year, cc_string, project_key, task_key, expenditure_type,
         has_project, ap_valid, SUM(amt) AS amt
  FROM f_raw
  GROUP BY measure, budget_year, cc_string, project_key, task_key, expenditure_type, has_project, ap_valid
)
SELECT
  a.measure, a.budget_year, a.cc_string,
  coa.account_code, coa.account_desc, coa.account_type,
  coa.cost_center_code, coa.cost_center_desc,
  coa.appropriation_code, coa.appropriation_desc,
  coa.program_code, coa.program_name, coa.program_class_code,
  coa.sector_code, coa.sector_name,
  coa.chapter_code, coa.chapter_name,
  a.project_key, a.task_key, a.expenditure_type,
  a.has_project, a.ap_valid,
  CASE WHEN bl.project_key IS NOT NULL THEN 'Y' ELSE 'N' END AS on_budget_line,
  'Y' AS in_actuals,
  CASE WHEN a.has_project='Y' AND a.ap_valid='Y' AND bl.project_key IS NOT NULL
       THEN 'Y' ELSE 'N' END AS in_butil,
  CASE WHEN a.has_project='N' THEN 'no_project'
       WHEN a.ap_valid='N' THEN 'ap_validation'
       WHEN bl.project_key IS NULL THEN 'no_budget_line'
       ELSE 'matched' END AS bucket,
  a.amt AS amount_aed
FROM agg a
LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = a.cc_string
LEFT JOIN bl ON bl.budget_year = a.budget_year
            AND bl.project_key = a.project_key
            AND NVL(bl.task_key,'~')         = NVL(a.task_key,'~')
            AND NVL(bl.expenditure_type,'~') = NVL(a.expenditure_type,'~');

PROMPT DCT_GL_RECON_FACT_V created (AP/GRN/PR/PO bridge fact with side/bucket flags).

-- ---------------------------------------------------------------------------
-- 2. GL budget (GL_BALANCES ledger) per period x combination + COA dims
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW prod.dct_gl_recon_glbudget_v AS
SELECT
  g.period_name,
  TO_NUMBER(SUBSTR(g.period_name,4,4)) AS budget_year,
  g.cc_string,
  coa.account_code, coa.account_desc, coa.account_type,
  coa.cost_center_code, coa.cost_center_desc,
  coa.appropriation_code, coa.appropriation_desc,
  coa.program_code, coa.program_name, coa.program_class_code,
  coa.sector_code, coa.sector_name,
  coa.chapter_code, coa.chapter_name,
  g.total_budget
FROM prod.gl_balances_cc g
JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = g.cc_string
WHERE g.cc_string IS NOT NULL
  AND g.period_name IS NOT NULL;

PROMPT DCT_GL_RECON_GLBUDGET_V created (GL budget per period x combination + dims/account_type/chapter).
