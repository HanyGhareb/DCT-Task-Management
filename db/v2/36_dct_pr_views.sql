-- ===========================================================================
-- DCT Actuals Reporting - Purchase Requisition (PR) views (db/v2/36)
-- ---------------------------------------------------------------------------
-- Base pass-through views over the Fusion-loaded ATD_PR_* tables (mirrors the
-- AP_/PO_/GRN_/GL base views in db/v2/32) + a per-(GL combination x fiscal
-- period) PR commitment aggregate for the GL Actuals report (Batch B: real
-- Commitment / Open Commitment sourced from requisitions).
--
--   pr_headers / pr_lines / pr_distributions : SELECT * pass-throughs.
--
--   DCT_PR_COMMITMENT_PERIOD_V : one row per (charge_account = cc_string x period)
--     with YEAR-TO-DATE-through-that-period measures, AED-converted via the
--     DCT_CURRENCY_CODES snapshot rate (the PR tables carry NO transaction rate,
--     so this dated snapshot is the only source; AED = 1). Three funds-status
--     buckets (user-defined, 2026-07-02):
--       pr_total_ytd          = requisitions that reserved budget
--                               (FUNDS_STATUS IN ('Reserved','Liquidated')).
--       pr_open_commitment_ytd= OPEN commitment = still reserved
--                               (FUNDS_STATUS = 'Reserved').
--       pr_pipeline_ytd       = commitment pipeline = draft/pending, never
--                               encumbered (FUNDS_STATUS = 'Not reserved').
--       pr_count              = distinct PR headers behind pr_total_ytd.
--   Cumulative to period via BUDGET_DATE < period-end. Natural key
--   (pr_header_id,pr_line_id,distribution_id) is unique -- no de-dup needed.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

CREATE OR REPLACE VIEW prod.pr_headers       AS SELECT * FROM prod.atd_pr_headers;
CREATE OR REPLACE VIEW prod.pr_lines         AS SELECT * FROM prod.atd_pr_lines;
CREATE OR REPLACE VIEW prod.pr_distributions AS SELECT * FROM prod.atd_pr_distributions;

CREATE OR REPLACE VIEW prod.dct_pr_commitment_period_v AS
WITH periods AS (
  SELECT period_name,
         ADD_MONTHS(TO_DATE(period_name,'MM-YYYY'),1) AS p_next
  FROM (SELECT DISTINCT period_name FROM prod.gl_balances WHERE period_name IS NOT NULL)
),
pr_base AS (
  -- charge_account canonicalized via prod.dct_cc_canon (db/v2/40) - the
  -- 2026-07-05 reload flipped the feed to the re-ordered segment format
  SELECT prod.dct_cc_canon(d.charge_account)                   AS cc_string,
         d.budget_date,
         d.distribution_amount * NVL(cc.exchange_rate_to_aed,1) AS amt_aed,
         d.funds_status,
         d.pr_header_id
  FROM prod.pr_distributions d
  LEFT JOIN prod.dct_currency_codes cc ON cc.currency_code = d.currency_code
  WHERE d.charge_account IS NOT NULL
)
SELECT b.cc_string, p.period_name,
       SUM(CASE WHEN b.funds_status IN ('Reserved','Liquidated') THEN b.amt_aed END)                 AS pr_total_ytd,
       SUM(CASE WHEN b.funds_status = 'Reserved'                 THEN b.amt_aed END)                  AS pr_open_commitment_ytd,
       SUM(CASE WHEN b.funds_status = 'Not reserved'             THEN b.amt_aed END)                  AS pr_pipeline_ytd,
       COUNT(DISTINCT CASE WHEN b.funds_status IN ('Reserved','Liquidated') THEN b.pr_header_id END)  AS pr_count
FROM pr_base b
JOIN periods p ON (b.budget_date IS NULL OR b.budget_date < p.p_next)
GROUP BY b.cc_string, p.period_name;

PROMPT PR views created (pr_headers/pr_lines/pr_distributions + DCT_PR_COMMITMENT_PERIOD_V, 3-figure model).
