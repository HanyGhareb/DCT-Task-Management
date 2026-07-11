-- ===========================================================================
-- DCT Actuals Reporting - period YTD view (db/v2/34)
-- ---------------------------------------------------------------------------
-- DCT_BUDGET_ACTUAL_PERIOD_V : one row per (GL combination x fiscal period) with
-- YEAR-TO-DATE-through-that-period measures.
--
--   Budget / GL Actual / Funds Available (GL) / encumbrance_ytd : from GL_BALANCES,
--     cumulative = SUM of same-year periods up to & incl. the period.
--   GRN Actual      : received (AED via CONVERSION_RATE), TRANSACTION_DATE in
--                     [year-start, period-end].
--   AP-direct Actual: AP distribution lines with NO PO reference (PO_NUMBER IS
--                     NULL), classified by CC_ID, AED via FUNCTI, reversed excluded.
--
--   COMMITMENT (PR) -- 3 figures, from DCT_PR_COMMITMENT_PERIOD_V (db/v2/36, real
--     requisitions, AED via DCT_CURRENCY_CODES snapshot; user model 2026-07-02):
--       pr_total_ytd            = FUNDS_STATUS IN ('Reserved','Liquidated').
--       open_commitment_ytd     = FUNDS_STATUS = 'Reserved'.
--       commitment_pipeline_ytd = FUNDS_STATUS = 'Not reserved' (draft/pending).
--   OBLIGATION (PO) -- 3 figures, from po_distributions (de-dup by po_distribution_id):
--       total_po_ytd            = all FUNDS_STATUS EXCEPT 'Failed','Passed'.
--       open_obligation_ytd     = (Reserved + Partially Liquidated) NETTED by GRN:
--                                 per distribution GREATEST(amt_AED - GRN_received, 0)
--                                 (GRN via grn_all_v2.po_distribution_id) -- the
--                                 unreceived balance of still-encumbered POs.
--                                 EXCLUDES POs whose header STATUS = 'Finally Closed'
--                                 (2026-07-11): Fusion releases the reserved funds on
--                                 final close, but the distributions keep their old
--                                 funds_status, so the un-received remainder must not
--                                 count as open obligation.
--       po_pipeline_ytd         = FUNDS_STATUS IN ('Failed','Passed').
--   OPEN ENCUMBRANCE = open_commitment_ytd + open_obligation_ytd.
--   Funds Available (calc)      = Budget - Open PO - Open PR - GRN - AP Direct
--     (Open PO is GRN-netted, so this does not double-count receipts).
--   PO_COUNT / PR_COUNT: distinct PO headers (Total-PO basis) / PR headers.
--
-- Cumulative to period via BUDGET_DATE < period-end. Open figures use a current
-- funds-status snapshot netted by all GRN for the distribution.
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
gl_ytd AS (
  -- canonical cc_string via GL_BALANCES_CC (db/v2/32) -- the reloaded feed's
  -- CONCATENATED_SEGMENTS carries a different segment order than the COA string
  SELECT g.cc_string, p.period_name,
         SUM(g.total_budget)                                                   AS budget,
         SUM(NVL(g.commitments,0)+NVL(g.obligations,0)+NVL(g.other_encumbrances,0)) AS encumbrance,
         SUM(g.expenditures)                                                   AS gl_actual,
         SUM(g.funds_available_amount)                                         AS funds_available
  FROM prod.gl_balances_cc g
  JOIN periods p ON TO_DATE(g.period_name,'MM-YYYY') BETWEEN p.yr_start AND p.p_start
  WHERE g.cc_string IS NOT NULL
  GROUP BY g.cc_string, p.period_name
),
grn_ytd AS (
  -- charge_account canonicalized via prod.dct_cc_canon (db/v2/40, re-ordered feed)
  SELECT prod.dct_cc_canon(pod.charge_account) AS cc_string, p.period_name,
         SUM(g.ledger_amount) AS grn_actual
  FROM prod.grn_all_v2 g
  JOIN prod.po_distributions pod ON pod.po_distribution_id = g.po_distribution_id
  JOIN periods p ON g.transaction_date >= p.yr_start AND g.transaction_date < p.p_next
  GROUP BY prod.dct_cc_canon(pod.charge_account), p.period_name
),
ap_ytd AS (  -- AP Direct = AP distribution lines with NO PO reference (po_number IS NULL)
  SELECT cid.cc_string, p.period_name,
         SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS ap_actual
  FROM prod.ap_invoice_distributions d
  JOIN prod.dct_gl_coa_snap cid ON cid.cc_id = d.cc_id
  JOIN periods p ON d.accounting_date >= p.yr_start AND d.accounting_date < p.p_next
  WHERE d.po_number IS NULL
    AND NVL(d.reversal_indicator,'N') <> 'Y'
  GROUP BY cid.cc_string, p.period_name
),
grn_per_dist AS (  -- total GRN received per PO distribution (for Open Obligation netting)
  SELECT po_distribution_id, SUM(ledger_amount) AS grn_aed
  FROM prod.grn_all_v2
  GROUP BY po_distribution_id
),
po_base AS (  -- one row per PO distribution (collapse physical dups by po_distribution_id)
  SELECT po_distribution_id,
         prod.dct_cc_canon(MAX(charge_account)) AS charge_account,
         MAX(po_header_id)                      AS po_header_id,
         MAX(budget_date)                       AS budget_date,
         MAX(distribution_amount * NVL(rate,1)) AS amt_aed,
         MAX(funds_status)                      AS funds_status
  FROM prod.po_distributions
  WHERE charge_account IS NOT NULL
  GROUP BY po_distribution_id
),
po_hdr_status AS (  -- header STATUS: 'Finally Closed' releases the un-received remainder
  SELECT po_header_id, MAX(status) AS po_status
  FROM prod.po_headers
  GROUP BY po_header_id
),
po_ytd AS (  -- PO obligation 3-figure buckets cumulative to each period
  SELECT b.charge_account AS cc_string, p.period_name,
         SUM(CASE WHEN NVL(b.funds_status,'x') NOT IN ('Failed','Passed')
                  THEN b.amt_aed END)                                              AS total_po,
         SUM(CASE WHEN b.funds_status IN ('Reserved','Partially Liquidated')
                   AND NVL(hs.po_status,'x') <> 'Finally Closed'
                  THEN GREATEST(b.amt_aed - NVL(g.grn_aed,0), 0) END)              AS open_obligation,
         SUM(CASE WHEN b.funds_status IN ('Failed','Passed')
                  THEN b.amt_aed END)                                              AS po_pipeline,
         COUNT(DISTINCT CASE WHEN NVL(b.funds_status,'x') NOT IN ('Failed','Passed')
                             THEN b.po_header_id END)                              AS po_count
  FROM po_base b
  LEFT JOIN grn_per_dist g ON g.po_distribution_id = b.po_distribution_id
  LEFT JOIN po_hdr_status hs ON hs.po_header_id = b.po_header_id
  JOIN periods p ON (b.budget_date IS NULL OR b.budget_date < p.p_next)
  GROUP BY b.charge_account, p.period_name
),
keys AS (
  SELECT cc_string, period_name FROM gl_ytd
  UNION SELECT cc_string, period_name FROM grn_ytd
  UNION SELECT cc_string, period_name FROM ap_ytd
  UNION SELECT cc_string, period_name FROM po_ytd
  UNION SELECT cc_string, period_name FROM prod.dct_pr_commitment_period_v
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
  NVL(gl.budget,0)              AS budget_ytd,
  NVL(gl.encumbrance,0)         AS encumbrance_ytd,          -- GL-balance encumbrance (reference)
  -- Commitment (PR) group  -- real requisitions (db/v2/36)
  NVL(pr.pr_total_ytd,0)            AS pr_total_ytd,
  NVL(pr.pr_open_commitment_ytd,0)  AS open_commitment_ytd,
  NVL(pr.pr_pipeline_ytd,0)         AS commitment_pipeline_ytd,
  NVL(pr.pr_count,0)                AS pr_count,
  -- Obligation (PO) group
  NVL(po.total_po,0)                AS total_po_ytd,
  NVL(po.open_obligation,0)         AS open_obligation_ytd,   -- GRN-netted
  NVL(po.po_pipeline,0)             AS po_pipeline_ytd,
  NVL(po.po_count,0)                AS po_count,
  -- derived
  NVL(pr.pr_open_commitment_ytd,0) + NVL(po.open_obligation,0) AS open_encumbrance_ytd,
  NVL(gl.gl_actual,0)           AS gl_actual_ytd,
  NVL(gl.funds_available,0)     AS funds_available_ytd,       -- GL-balance funds available
  NVL(grn.grn_actual,0)         AS grn_actual_ytd,
  NVL(ap.ap_actual,0)           AS ap_direct_actual_ytd,
  NVL(gl.budget,0) - NVL(po.open_obligation,0) - NVL(pr.pr_open_commitment_ytd,0)
                   - NVL(grn.grn_actual,0) - NVL(ap.ap_actual,0) AS funds_available_calc_ytd,
  NVL(gl.budget,0) - NVL(gl.gl_actual,0) AS variance_ytd
FROM keys k
LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = k.cc_string
LEFT JOIN gl_ytd  gl  ON gl.cc_string  = k.cc_string AND gl.period_name  = k.period_name
LEFT JOIN grn_ytd grn ON grn.cc_string = k.cc_string AND grn.period_name = k.period_name
LEFT JOIN ap_ytd  ap  ON ap.cc_string  = k.cc_string AND ap.period_name  = k.period_name
LEFT JOIN po_ytd  po  ON po.cc_string  = k.cc_string AND po.period_name  = k.period_name
LEFT JOIN prod.dct_pr_commitment_period_v pr ON pr.cc_string = k.cc_string AND pr.period_name = k.period_name;

PROMPT DCT_BUDGET_ACTUAL_PERIOD_V created (3-figure Commitment/Obligation + Open Encumbrance + Funds calc).
