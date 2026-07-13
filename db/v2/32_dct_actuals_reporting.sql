-- ===========================================================================
-- DCT Actuals Reporting Layer (db/v2/32)
-- ---------------------------------------------------------------------------
-- 1. Base pass-through views (ATD_ prefix stripped) - the reporting layer
--    references ONLY these, insulated from the physical ATD_* table names.
-- 2. DCT_ACTUAL_V        unified transaction fact across AP / PO / GRN / GL,
--                        COA-classified (Sector/Chapter/DCT-Program) + project/
--                        task names + currency -> AED conversion.
-- 3. DCT_BUDGET_ACTUAL_V budget-vs-actual summary per GL combination (all AED).
--
-- COA classification is sourced from prod.dct_gl_coa_snap (db/v2/33), the
-- indexed current-effective snapshot of DCT_GL_COA_V (for performance).
--
-- Join model (verified against live data 2026-06-30):
--   AP distributions  -> if matched to a PO, the charge account comes from the
--                        PO distribution (CHARGE_ACCOUNT); otherwise it uses the
--                        AP distribution's own CC_ID (the charge/expense account).
--                        (AP_CC_ID is the AP liability control account - NOT used
--                        for expense classification.) PO side pre-collapsed to a
--                        unique (order,line,distribution) key so AP stays 1:1.
--   PO distributions  -> COA via CHARGE_ACCOUNT      = CC_STRING
--   GRN               -> no GL account; inherits its PO distribution's charge acct
--   GL balances       -> COA via GL_BALANCES_CC.cc_string (canonical segment
--                        re-order of CONCATENATED_SEGMENTS - see section 1b;
--                        period-activity grained; SUM over periods = YTD.)
--
-- Currency -> AED (the org's functional/ledger currency):
--   AP  : amount_aed = NVL(DISTRIBUTION_AMOUNT_FUNCTI, DISTRIBUTION_AMOUNT).
--         FUNCTI is the booked AED equivalent and is populated ONLY for non-AED
--         invoices; AED invoices have FUNCTI NULL so the entered amount is AED.
--   PO  : amount_aed = DISTRIBUTION_AMOUNT * NVL(PO_DISTRIBUTIONS.RATE,1)
--         (its own transaction-time FX-to-AED rate; AED rows = 1).
--   GRN : amount_aed = LEDGER_AMOUNT (already AED). The extract's
--         TRANSACTION_AMOUNT is ALSO already AED-converted (doc amount x rate
--         at source), so multiplying by CONVERSION_RATE double-converted FX
--         receipts (EUR x4.26, USD x3.67) - fixed 2026-07-10. Never multiply
--         GRN amounts by CONVERSION_RATE; SLA_LEDGER_AMOUNT is unusable (3x).
--   GL  : already AED (ledger currency); amount_aed = amount, rate = 1.
--   (All rates are each source's own transaction-time FX-to-AED rate.)
--
-- Cancellations / reversals:
--   AP  : reversed distributions (REVERSAL_INDICATOR='Y') are EXCLUDED - they
--         net to zero so totals are unchanged; the fact just drops the voided
--         rows (4,840 rows). Cancelled invoices are reversed, so they are covered.
--   GRN : corrections ("Correction To Deliver") are NEGATIVE rows KEPT in place
--         so they net the received actual down correctly.
--   PO  : cancelled POs/lines already carry distribution_amount 0 (no inflation).
--
-- These are VIEWS (not synonyms); run with the prod. prefix (do NOT ALTER
-- SESSION CURRENT_SCHEMA). DEPLOY 33 (snapshot) BEFORE this script.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

-- ---------------------------------------------------------------------------
-- 1. Base pass-through views (ATD_ prefix stripped)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW prod.ap_invoices              AS SELECT * FROM prod.atd_ap_invoices;
CREATE OR REPLACE VIEW prod.ap_invoice_lines         AS SELECT * FROM prod.atd_ap_invoice_lines;
CREATE OR REPLACE VIEW prod.ap_invoice_distributions AS SELECT * FROM prod.atd_ap_invoice_distributions;
CREATE OR REPLACE VIEW prod.po_headers               AS SELECT * FROM prod.atd_po_headers;
CREATE OR REPLACE VIEW prod.po_lines                 AS SELECT * FROM prod.atd_po_lines;
CREATE OR REPLACE VIEW prod.po_distributions         AS SELECT * FROM prod.atd_po_distributions;
CREATE OR REPLACE VIEW prod.po_schedules             AS SELECT * FROM prod.atd_po_schedules;
CREATE OR REPLACE VIEW prod.grn_all_v2               AS SELECT * FROM prod.atd_grn_all_v2;
CREATE OR REPLACE VIEW prod.gl_balances              AS SELECT * FROM prod.atd_gl_balances;
CREATE OR REPLACE VIEW prod.projects                 AS SELECT * FROM prod.atd_projects;
CREATE OR REPLACE VIEW prod.tasks                    AS SELECT * FROM prod.atd_tasks;
CREATE OR REPLACE VIEW prod.projects_budget          AS SELECT * FROM prod.atd_projects_budget;

PROMPT Base pass-through views created (AP_*/PO_*/GRN_ALL_V2/GL_BALANCES/PROJECTS/TASKS/PROJECTS_BUDGET).

-- ---------------------------------------------------------------------------
-- 1b. GL_BALANCES_CC - balances + CANONICAL combination string (cc_string).
--     Since 2026-07-13 the platform canonical IS the Fusion segment sequence
--       entity.program.cost_center.budget_group.account.entity_specific.
--       appropriation.intercompany.future1.future2
--     which is exactly how the balances feed delivers CONCATENATED_SEGMENTS -
--     so the current feed passes through unchanged. The CASE still self-heals
--     the two legacy formats: a dash-separated value and a dot value with a
--     7-digit token#2 are the OLD canonical order (entity.cc.account.appr.bg.
--     es.f1.f2.ic.program) and get re-ordered to Fusion. ALL gl_balances<->COA
--     joins go through this view (dct_actual_v / dct_budget_actual_v here,
--     db/v2/34); keep in lock-step with prod.dct_cc_canon (db/v2/40) and
--     DCT_GL_COA_V.cc_string (GL/db/04).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW prod.gl_balances_cc AS
SELECT
  b.ledger_name, b.concatenated_segments, b.status, b.enabled,
  b.initial_budget, b.budget_adjustments, b.total_budget, b.unreleased_budget,
  b.funds_available_amount, b.commitments, b.obligations, b.expenditures,
  b.other_encumbrances, b.payables_expenditures, b.project_expenditures,
  b.receipt_expenditures, b.reserved_commitments, b.reserved_obligations,
  b.miscellaneous_expenditures, b.load_ts, b.period_name,
  CASE
    WHEN b.concatenated_segments IS NULL THEN NULL
    WHEN INSTR(b.concatenated_segments,'-') > 0 OR LENGTH(b.s2) = 7
      THEN b.s1||'.'||b.s10||'.'||b.s2||'.'||b.s5||'.'||b.s3||'.'||b.s6||'.'
         ||b.s4||'.'||b.s9||'.'||b.s7||'.'||b.s8
    ELSE b.concatenated_segments
  END AS cc_string
FROM (
  SELECT g.*,
         REGEXP_SUBSTR(g.concatenated_segments,'[^.-]+',1,1)  AS s1,
         REGEXP_SUBSTR(g.concatenated_segments,'[^.-]+',1,2)  AS s2,
         REGEXP_SUBSTR(g.concatenated_segments,'[^.-]+',1,3)  AS s3,
         REGEXP_SUBSTR(g.concatenated_segments,'[^.-]+',1,4)  AS s4,
         REGEXP_SUBSTR(g.concatenated_segments,'[^.-]+',1,5)  AS s5,
         REGEXP_SUBSTR(g.concatenated_segments,'[^.-]+',1,6)  AS s6,
         REGEXP_SUBSTR(g.concatenated_segments,'[^.-]+',1,7)  AS s7,
         REGEXP_SUBSTR(g.concatenated_segments,'[^.-]+',1,8)  AS s8,
         REGEXP_SUBSTR(g.concatenated_segments,'[^.-]+',1,9)  AS s9,
         REGEXP_SUBSTR(g.concatenated_segments,'[^.-]+',1,10) AS s10
  FROM prod.gl_balances g
) b;

PROMPT GL_BALANCES_CC created (canonical combination string).

-- ---------------------------------------------------------------------------
-- 2. DCT_ACTUAL_V - unified transaction fact (AP branch first sets the types)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW prod.dct_actual_v AS
WITH ap_po_match AS (
  SELECT ph.order_number AS po_number, pl.line AS po_line,
         pod.distribution_number AS po_dist_line, prod.dct_cc_canon(MAX(pod.charge_account)) AS charge_account
  FROM prod.po_distributions pod
  JOIN prod.po_lines   pl ON pl.po_header_id = pod.po_header_id AND pl.po_line_id = pod.po_line_id
  JOIN prod.po_headers ph ON ph.po_header_id = pod.po_header_id
  GROUP BY ph.order_number, pl.line, pod.distribution_number
),
proj AS (
  SELECT project_id, project_number, MAX(project_name) AS project_name
  FROM prod.projects GROUP BY project_id, project_number
),
task_num AS (
  SELECT task_number, MAX(task_name) AS task_name
  FROM prod.tasks GROUP BY task_number
)
-- ---- AP: invoiced actual (grain = invoice distribution) --------------------
SELECT
  'AP'                                                                   AS txn_source,
  'INV '||d.invoice_id||'-'||d.line_number||'-'||d.distribution_line_number AS txn_key,
  COALESCE(coa.cc_id, d.cc_id)                                          AS cc_id,
  coa.cc_string                                                         AS cc_string,
  coa.account_code, coa.account_desc,
  coa.cost_center_code, coa.cost_center_desc,
  coa.sector_code, coa.sector_name,
  coa.chapter_code, coa.chapter_name,
  coa.program_code, coa.program_class_code, coa.program_name,
  d.distribution_amount                                                 AS amount,
  CAST(CASE WHEN d.distribution_amount_functi IS NULL THEN 'AED' END AS VARCHAR2(15)) AS currency,
  ROUND(NVL(d.distribution_amount_functi, d.distribution_amount)/NULLIF(d.distribution_amount,0),6) AS fx_rate,
  NVL(d.distribution_amount_functi, d.distribution_amount)              AS amount_aed,
  d.accounting_date                                                     AS txn_date,
  d.period_name                                                         AS period_name,
  i.supplier_number                                                     AS supplier_number,
  i.supplier_name                                                       AS supplier_name,
  i.po_number                                                           AS order_number,
  pjn.project_id                                                        AS project_id,
  TO_CHAR(l.project_number)                                             AS project_number,
  pjn.project_name                                                      AS project_name,
  CAST(NULL AS NUMBER)                                                  AS task_id,
  l.task_number                                                         AS task_number,
  tkn.task_name                                                         AS task_name,
  l.expenditure_type                                                    AS expenditure_type,
  d.distribution_description                                            AS description
FROM prod.ap_invoice_distributions d
LEFT JOIN ap_po_match           pm  ON pm.po_number = d.po_number
                                   AND pm.po_line   = d.po_line
                                   AND pm.po_dist_line = d.po_distribution_line
LEFT JOIN prod.dct_gl_coa_snap  cid ON cid.cc_id = d.cc_id
LEFT JOIN prod.dct_gl_coa_snap  coa ON coa.cc_string = COALESCE(pm.charge_account, cid.cc_string)
LEFT JOIN prod.ap_invoices      i   ON i.invoice_id = d.invoice_id
LEFT JOIN prod.ap_invoice_lines l   ON l.invoice_id = d.invoice_id
                                   AND l.invoice_line_number = d.line_number
LEFT JOIN proj                  pjn ON TO_CHAR(pjn.project_number) = TO_CHAR(l.project_number)
LEFT JOIN task_num              tkn ON tkn.task_number   = l.task_number
WHERE NVL(d.reversal_indicator,'N') <> 'Y'   -- exclude reversed/voided AP distributions
UNION ALL
-- ---- PO: committed / ordered amount (grain = PO distribution) --------------
SELECT
  'PO',
  'PO '||pd.po_header_id||'-'||pd.po_line_id||'-'||pd.po_distribution_id,
  coa.cc_id,
  coa.cc_string,
  coa.account_code, coa.account_desc,
  coa.cost_center_code, coa.cost_center_desc,
  coa.sector_code, coa.sector_name,
  coa.chapter_code, coa.chapter_name,
  coa.program_code, coa.program_class_code, coa.program_name,
  pd.distribution_amount,
  h.currency,
  NVL(pd.rate,1),
  pd.distribution_amount * NVL(pd.rate,1),
  pd.budget_date,
  CAST(NULL AS VARCHAR2(20)),
  h.supplier_number,
  h.supplier_name,
  h.order_number,
  pd.project_id,
  pj.project_number,
  pj.project_name,
  pd.task_id,
  tk.task_number,
  tk.task_name,
  pd.expenditure_type_name,
  pd.pr_description
FROM prod.po_distributions pd
LEFT JOIN prod.dct_gl_coa_snap   coa ON coa.cc_string = prod.dct_cc_canon(pd.charge_account)
LEFT JOIN prod.po_headers        h   ON h.po_header_id = pd.po_header_id
LEFT JOIN proj                   pj  ON pj.project_id = pd.project_id
LEFT JOIN prod.tasks             tk  ON tk.task_id    = pd.task_id
UNION ALL
-- ---- GRN: received amount (grain = receipt line; COA via PO distribution) --
SELECT
  'GRN',
  'RCV '||g.receipt_number||'-'||g.receipt_line_number,
  coa.cc_id,
  coa.cc_string,
  coa.account_code, coa.account_desc,
  coa.cost_center_code, coa.cost_center_desc,
  coa.sector_code, coa.sector_name,
  coa.chapter_code, coa.chapter_name,
  coa.program_code, coa.program_class_code, coa.program_name,
  g.transaction_amount,
  g.currency_code,
  NVL(g.conversion_rate,1),
  g.ledger_amount,
  g.transaction_date,
  CAST(NULL AS VARCHAR2(20)),
  h.supplier_number,
  h.supplier_name,
  h.order_number,
  g.project_id,
  pj.project_number,
  pj.project_name,
  g.task_id,
  tk.task_number,
  tk.task_name,
  g.expenditure_type,
  g.transaction_type
FROM prod.grn_all_v2 g
LEFT JOIN prod.po_distributions  pod ON pod.po_distribution_id = g.po_distribution_id
LEFT JOIN prod.dct_gl_coa_snap   coa ON coa.cc_string = prod.dct_cc_canon(pod.charge_account)
LEFT JOIN prod.po_headers        h   ON h.po_header_id = g.po_header_id
LEFT JOIN proj                   pj  ON pj.project_id = g.project_id
LEFT JOIN prod.tasks             tk  ON tk.task_id    = g.task_id
UNION ALL
-- ---- GL: actual expenditure figure (grain = balances row; already AED) -----
SELECT
  'GL',
  'GLBAL '||g.ledger_name||'-'||g.period_name,
  coa.cc_id,
  coa.cc_string,
  coa.account_code, coa.account_desc,
  coa.cost_center_code, coa.cost_center_desc,
  coa.sector_code, coa.sector_name,
  coa.chapter_code, coa.chapter_name,
  coa.program_code, coa.program_class_code, coa.program_name,
  g.expenditures,
  CAST('AED' AS VARCHAR2(15)),
  CAST(1 AS NUMBER),
  g.expenditures,
  CAST(NULL AS DATE),
  g.period_name,
  CAST(NULL AS NUMBER),            -- supplier_number
  CAST(NULL AS VARCHAR2(150)),     -- supplier_name
  CAST(NULL AS NUMBER),            -- order_number
  CAST(NULL AS NUMBER),            -- project_id
  CAST(NULL AS VARCHAR2(30)),      -- project_number
  CAST(NULL AS VARCHAR2(100)),     -- project_name
  CAST(NULL AS NUMBER),            -- task_id
  CAST(NULL AS VARCHAR2(60)),      -- task_number
  CAST(NULL AS VARCHAR2(60)),      -- task_name
  CAST(NULL AS VARCHAR2(150)),     -- expenditure_type
  g.ledger_name
FROM prod.gl_balances_cc g
LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = g.cc_string;

PROMPT DCT_ACTUAL_V created (unified AP/PO/GRN/GL fact, AED-converted).

-- ---------------------------------------------------------------------------
-- 3. DCT_BUDGET_ACTUAL_V - budget-vs-actual summary per GL combination (AED)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW prod.dct_budget_actual_v AS
WITH ap_po_match AS (
  SELECT ph.order_number AS po_number, pl.line AS po_line,
         pod.distribution_number AS po_dist_line, prod.dct_cc_canon(MAX(pod.charge_account)) AS charge_account
  FROM prod.po_distributions pod
  JOIN prod.po_lines   pl ON pl.po_header_id = pod.po_header_id AND pl.po_line_id = pod.po_line_id
  JOIN prod.po_headers ph ON ph.po_header_id = pod.po_header_id
  GROUP BY ph.order_number, pl.line, pod.distribution_number
),
ap_eff AS (
  -- AP invoiced re-pointed to its effective expense combination (PO charge acct
  -- when matched, else the AP distribution's own CC_ID) and converted to AED.
  SELECT COALESCE(pm.charge_account, cid.cc_string) AS cc_string,
         NVL(d.distribution_amount_functi, d.distribution_amount) AS amount
  FROM prod.ap_invoice_distributions d
  LEFT JOIN ap_po_match pm  ON pm.po_number = d.po_number
                           AND pm.po_line   = d.po_line
                           AND pm.po_dist_line = d.po_distribution_line
  LEFT JOIN prod.dct_gl_coa_snap cid ON cid.cc_id = d.cc_id
  WHERE NVL(d.reversal_indicator,'N') <> 'Y'   -- exclude reversed/voided AP distributions
),
spine AS (
  SELECT cc_string
    FROM prod.gl_balances_cc WHERE cc_string IS NOT NULL
  UNION
  SELECT prod.dct_cc_canon(charge_account) FROM prod.po_distributions WHERE charge_account IS NOT NULL
  UNION
  SELECT cc_string FROM ap_eff WHERE cc_string IS NOT NULL
),
gl_agg AS (
  SELECT cc_string,
         SUM(initial_budget)         AS initial_budget,
         SUM(budget_adjustments)     AS budget_adjustments,
         SUM(total_budget)           AS total_budget,
         SUM(funds_available_amount) AS funds_available,
         SUM(commitments)            AS gl_commitments,
         SUM(obligations)            AS gl_obligations,
         SUM(expenditures)           AS gl_expenditures,
         SUM(other_encumbrances)     AS gl_other_encumbrances
    FROM prod.gl_balances_cc
   WHERE cc_string IS NOT NULL
   GROUP BY cc_string
),
po_agg AS (
  SELECT prod.dct_cc_canon(pd.charge_account) AS cc_string,
         SUM(pd.distribution_amount * NVL(pd.rate,1)) AS po_committed
    FROM prod.po_distributions pd
   GROUP BY prod.dct_cc_canon(pd.charge_account)
),
grn_agg AS (
  SELECT prod.dct_cc_canon(pod.charge_account) AS cc_string,
         SUM(g.ledger_amount) AS grn_received
    FROM prod.grn_all_v2 g
    JOIN prod.po_distributions pod ON pod.po_distribution_id = g.po_distribution_id
   GROUP BY prod.dct_cc_canon(pod.charge_account)
),
ap_agg AS (
  SELECT cc_string, SUM(amount) AS ap_invoiced
    FROM ap_eff
   GROUP BY cc_string
)
SELECT
  s.cc_string,
  coa.cc_id,
  coa.account_code, coa.account_desc,
  coa.cost_center_code, coa.cost_center_desc,
  coa.sector_code, coa.sector_name,
  coa.chapter_code, coa.chapter_name,
  coa.program_code, coa.program_class_code, coa.program_name,
  NVL(gl.initial_budget,0)        AS initial_budget,
  NVL(gl.budget_adjustments,0)    AS budget_adjustments,
  NVL(gl.total_budget,0)          AS total_budget,
  NVL(gl.funds_available,0)       AS funds_available,
  NVL(gl.gl_commitments,0)        AS gl_commitments,
  NVL(gl.gl_obligations,0)        AS gl_obligations,
  NVL(gl.gl_expenditures,0)       AS gl_expenditures,
  NVL(gl.gl_other_encumbrances,0) AS gl_other_encumbrances,
  NVL(gl.gl_commitments,0)+NVL(gl.gl_obligations,0)+NVL(gl.gl_other_encumbrances,0) AS total_encumbrance,
  NVL(po.po_committed,0)          AS po_committed,
  NVL(grn.grn_received,0)         AS grn_received,
  NVL(ap.ap_invoiced,0)           AS ap_invoiced,
  NVL(gl.total_budget,0) - NVL(gl.gl_expenditures,0) AS variance_budget_vs_actual
FROM spine s
LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = s.cc_string
LEFT JOIN gl_agg  gl  ON gl.cc_string  = s.cc_string
LEFT JOIN po_agg  po  ON po.cc_string  = s.cc_string
LEFT JOIN grn_agg grn ON grn.cc_string = s.cc_string
LEFT JOIN ap_agg  ap  ON ap.cc_string  = s.cc_string;

PROMPT DCT_BUDGET_ACTUAL_V created (AED; budget vs encumbrance vs committed vs received vs invoiced).
