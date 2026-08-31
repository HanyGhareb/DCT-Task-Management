-- =============================================================================
-- Project cashflow PLAN at the butil line grain (BUTIL_END aware)
-- File   : 126_project_cf_butil_view.sql                          2026-08-26
-- Run    : sql -name prod_mcp @126_project_cf_butil_view.sql  (fresh session,
--          as ADMIN -- the synonym block must NOT follow a CURRENT_SCHEMA=PROD)
--
-- WHY: the user-uploaded expenditure plan (DCT_PROJECT_CASHFLOW, db/v2/111 --
-- the Fusion budget is NOT cashflow phased, so the phasing is uploaded on the
-- GL Cashflow tab) must show as Annual Plan / YTD Plan balances on the Budget
-- Utilization page, the Project Portfolio / Project 360 dashboards and the
-- BUDGET_UTIL_BOOK / BUDGET_UTIL_REGISTER reports.
--
-- This view aggregates the plan to the SAME grain as DCT_BUDGET_UTILIZATION_V
-- (budget year x project x task x expenditure type) so the join in the
-- handlers is 1:1 and can never fan rows out. APPROVED and REVISED are kept
-- as SEPARATE column pairs (user decision 2026-08-26) -- today only APPROVED
-- rows exist, revised uploads simply start populating their pair.
--
-- YTD rule (same convention as the Sector Performance report): the *_YTD
-- column sums plan months whose period is on or before GL_CTX.BUTIL_END; when
-- no period cut is set (full-year run) YTD equals Annual. period_date is
-- populated on every row by the upload handlers; the NVL fallback derives it
-- from the MM-YYYY accounting_period defensively.
--
-- DCT_BUDGET_UTILIZATION_V itself is deliberately untouched (procash / cost
-- adjustment precedent): the join lives in the consumers.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

PROMPT === 126.1 view DCT_PROJECT_CF_BUTIL_V ===

CREATE OR REPLACE VIEW prod.dct_project_cf_butil_v AS
SELECT f.budget_year,
       f.project_number,
       f.task_number,
       f.expenditure_type,
       SUM(CASE WHEN f.cf_type = 'APPROVED' THEN f.cf_amount ELSE 0 END)
           AS plan_appr_annual,
       SUM(CASE WHEN f.cf_type = 'APPROVED'
                 AND (SYS_CONTEXT('GL_CTX', 'BUTIL_END') IS NULL
                      OR NVL(f.period_date,
                             TO_DATE('01-' || f.accounting_period, 'DD-MM-YYYY'))
                         <= TO_DATE(SYS_CONTEXT('GL_CTX', 'BUTIL_END'), 'YYYY-MM-DD'))
                THEN f.cf_amount ELSE 0 END)
           AS plan_appr_ytd,
       SUM(CASE WHEN f.cf_type = 'REVISED' THEN f.cf_amount ELSE 0 END)
           AS plan_rev_annual,
       SUM(CASE WHEN f.cf_type = 'REVISED'
                 AND (SYS_CONTEXT('GL_CTX', 'BUTIL_END') IS NULL
                      OR NVL(f.period_date,
                             TO_DATE('01-' || f.accounting_period, 'DD-MM-YYYY'))
                         <= TO_DATE(SYS_CONTEXT('GL_CTX', 'BUTIL_END'), 'YYYY-MM-DD'))
                THEN f.cf_amount ELSE 0 END)
           AS plan_rev_ytd,
       COUNT(*) AS cf_rows
  FROM prod.dct_project_cashflow f
 GROUP BY f.budget_year, f.project_number, f.task_number, f.expenditure_type;

PROMPT === 126.2 ADMIN synonym (ORDS handlers execute as ADMIN) ===

CREATE OR REPLACE SYNONYM dct_project_cf_butil_v FOR prod.dct_project_cf_butil_v;

PROMPT === 126.3 verification ===

SELECT COUNT(*) AS plan_lines,
       ROUND(SUM(plan_appr_annual) / 1e6, 1) AS appr_annual_m,
       ROUND(SUM(plan_rev_annual) / 1e6, 1)  AS rev_annual_m
  FROM prod.dct_project_cf_butil_v
 WHERE budget_year = 2026;

SELECT object_name, status FROM all_objects
 WHERE owner = 'PROD' AND object_name = 'DCT_PROJECT_CF_BUTIL_V';
