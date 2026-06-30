-- ===========================================================================
-- DCT Actuals Reporting - period YTD view (db/v2/34)
-- ---------------------------------------------------------------------------
-- DCT_BUDGET_ACTUAL_PERIOD_V : one row per (GL combination x fiscal period) with
-- YEAR-TO-DATE-through-that-period measures. Filter by PERIOD_NAME to answer
-- "for period NN-YYYY (YTD) give budget / encumbrance / GL actual / funds
-- available / GRN actual / AP-direct actual per GL combination".
--
--   Budget / Encumbrance / GL Actual / Funds Available : from GL_BALANCES,
--     cumulative = SUM of all periods of the SAME YEAR up to & incl. the period
--     (GL_BALANCES is period-activity grained, so the running sum = YTD).
--   GRN Actual      : received (AED via CONVERSION_RATE) with TRANSACTION_DATE
--                     in [year-start, period-end].
--   AP-direct Actual: AP not matched to a PO (classified by its CC_ID charge
--                     account), AED via FUNCTI, reversed rows excluded, with
--                     ACCOUNTING_DATE in [year-start, period-end].
--   Encumbrance = commitments + obligations + other_encumbrances.
--   Commitment (PRs): AED value of PO distribution lines that originated from a
--                     purchase requisition (PR_NUMBER present), cumulative to the
--                     period (BUDGET_DATE < period-end). De-duped per PO dist key.
--   Obligation (POs): AED value of ALL PO distribution lines (whether or not
--                     PR-backed), cumulative to the period. Commitment is the
--                     PR-backed subset of Obligation. (gl_balances.OBLIGATIONS is
--                     0 in this Fusion config -- all encumbrance lands in
--                     OTHER_ENCUMBRANCES -- so POs are read from po_distributions.)
--   Open Obligation : the still-unliquidated subset of Obligation -- PO lines
--                     whose budget is still encumbered (FUNDS_STATUS is Reserved
--                     or Partially Liquidated), i.e. not yet fully turned into
--                     actual expenditure. Open Commitment is its PR-backed subset.
--
-- Assumes fiscal year = calendar year and PERIOD_NAME = 'MM-YYYY' (monthly).
-- Reconciles: Budget_ytd - Encumbrance_ytd - GL_Actual_ytd = Funds_Available_ytd.
-- COA classification via the indexed prod.dct_gl_coa_snap (db/v2/33).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

CREATE OR REPLACE VIEW prod.dct_budget_actual_period_v AS
WITH periods AS (
  SELECT period_name,
         TO_DATE(period_name,'MM-YYYY')                AS p_start,
         ADD_MONTHS(TO_DATE(period_name,'MM-YYYY'),1)  AS p_next,
         TRUNC(TO_DATE(period_name,'MM-YYYY'),'YEAR')  AS yr_start
  FROM (SELECT DISTINCT period_name FROM prod.gl_balances WHERE period_name IS NOT NULL)
),
ap_po_match AS (
  SELECT ph.order_number AS po_number, pl.line AS po_line,
         pod.distribution_number AS po_dist_line, MAX(pod.charge_account) AS charge_account
  FROM prod.po_distributions pod
  JOIN prod.po_lines   pl ON pl.po_header_id = pod.po_header_id AND pl.po_line_id = pod.po_line_id
  JOIN prod.po_headers ph ON ph.po_header_id = pod.po_header_id
  GROUP BY ph.order_number, pl.line, pod.distribution_number
),
gl_ytd AS (
  SELECT REPLACE(g.concatenated_segments,'-','.') AS cc_string, p.period_name,
         SUM(g.total_budget)                                                   AS budget,
         SUM(NVL(g.commitments,0)+NVL(g.obligations,0)+NVL(g.other_encumbrances,0)) AS encumbrance,
         SUM(g.expenditures)                                                   AS gl_actual,
         SUM(g.funds_available_amount)                                         AS funds_available
  FROM prod.gl_balances g
  JOIN periods p ON TO_DATE(g.period_name,'MM-YYYY') BETWEEN p.yr_start AND p.p_start
  WHERE g.concatenated_segments IS NOT NULL
  GROUP BY REPLACE(g.concatenated_segments,'-','.'), p.period_name
),
grn_ytd AS (
  SELECT pod.charge_account AS cc_string, p.period_name,
         SUM(g.transaction_amount * NVL(g.conversion_rate,1)) AS grn_actual
  FROM prod.grn_all_v2 g
  JOIN prod.po_distributions pod ON pod.po_distribution_id = g.po_distribution_id
  JOIN periods p ON g.transaction_date >= p.yr_start AND g.transaction_date < p.p_next
  GROUP BY pod.charge_account, p.period_name
),
ap_ytd AS (
  SELECT cid.cc_string, p.period_name,
         SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS ap_actual
  FROM prod.ap_invoice_distributions d
  LEFT JOIN ap_po_match pm ON pm.po_number = d.po_number
                          AND pm.po_line   = d.po_line
                          AND pm.po_dist_line = d.po_distribution_line
  JOIN prod.dct_gl_coa_snap cid ON cid.cc_id = d.cc_id
  JOIN periods p ON d.accounting_date >= p.yr_start AND d.accounting_date < p.p_next
  WHERE pm.charge_account IS NULL
    AND NVL(d.reversal_indicator,'N') <> 'Y'
  GROUP BY cid.cc_string, p.period_name
),
po_base AS (  -- collapse duplicate physical distribution rows to one per natural key
  SELECT charge_account,
         MAX(budget_date)                          AS budget_date,
         MAX(distribution_amount * NVL(rate,1))    AS amt_aed,
         MAX(CASE WHEN pr_number IS NOT NULL
                  THEN distribution_amount * NVL(rate,1) END) AS pr_amt_aed,
         MAX(CASE WHEN funds_status IN ('Reserved','Partially Liquidated')
                  THEN distribution_amount * NVL(rate,1) END) AS open_amt_aed,
         MAX(CASE WHEN funds_status IN ('Reserved','Partially Liquidated') AND pr_number IS NOT NULL
                  THEN distribution_amount * NVL(rate,1) END) AS open_pr_amt_aed
  FROM prod.po_distributions
  WHERE charge_account IS NOT NULL
  GROUP BY po_header_id, po_line_id, distribution_number, charge_account
),
po_ytd AS (  -- PO obligations / PR commitments (+ open subsets) cumulative to each period
  SELECT b.charge_account AS cc_string, p.period_name,
         SUM(b.amt_aed)                  AS obligation,
         SUM(NVL(b.pr_amt_aed,0))        AS commitment,
         SUM(NVL(b.open_amt_aed,0))      AS open_obligation,
         SUM(NVL(b.open_pr_amt_aed,0))   AS open_commitment
  FROM po_base b
  JOIN periods p ON (b.budget_date IS NULL OR b.budget_date < p.p_next)
  GROUP BY b.charge_account, p.period_name
),
keys AS (
  SELECT cc_string, period_name FROM gl_ytd
  UNION SELECT cc_string, period_name FROM grn_ytd
  UNION SELECT cc_string, period_name FROM ap_ytd
  UNION SELECT cc_string, period_name FROM po_ytd
)
SELECT
  k.period_name,
  TO_DATE(k.period_name,'MM-YYYY')   AS period_date,
  k.cc_string,
  coa.cc_id,
  coa.account_code, coa.account_desc,
  coa.cost_center_code, coa.cost_center_desc,
  coa.appropriation_code, coa.appropriation_desc,
  coa.sector_code, coa.sector_name,
  coa.chapter_code, coa.chapter_name,
  coa.program_code, coa.program_class_code, coa.program_name,
  NVL(gl.budget,0)          AS budget_ytd,
  NVL(gl.encumbrance,0)     AS encumbrance_ytd,
  NVL(po.commitment,0)      AS commitment_ytd,
  NVL(po.obligation,0)      AS obligation_ytd,
  NVL(po.open_commitment,0) AS open_commitment_ytd,
  NVL(po.open_obligation,0) AS open_obligation_ytd,
  NVL(gl.gl_actual,0)       AS gl_actual_ytd,
  NVL(gl.funds_available,0) AS funds_available_ytd,
  NVL(grn.grn_actual,0)     AS grn_actual_ytd,
  NVL(ap.ap_actual,0)       AS ap_direct_actual_ytd,
  NVL(gl.budget,0) - NVL(gl.gl_actual,0) AS variance_ytd
FROM keys k
LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = k.cc_string
LEFT JOIN gl_ytd  gl  ON gl.cc_string  = k.cc_string AND gl.period_name  = k.period_name
LEFT JOIN grn_ytd grn ON grn.cc_string = k.cc_string AND grn.period_name = k.period_name
LEFT JOIN ap_ytd  ap  ON ap.cc_string  = k.cc_string AND ap.period_name  = k.period_name
LEFT JOIN po_ytd  po  ON po.cc_string  = k.cc_string AND po.period_name  = k.period_name;

PROMPT DCT_BUDGET_ACTUAL_PERIOD_V created (per GL combination x period, YTD measures).
