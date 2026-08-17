SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
-- =============================================================================
-- Procash at the Budget Utilization grain
-- File   : 13_procash_butil_view.sql        App 212 / AP        2026-08-17
-- Schema : PROD
-- Run    : own SQLcl session; consumed by GL/db/21 (the /gl/butil handler)
-- -----------------------------------------------------------------------------
-- Procash records money that has ALREADY left the bank but has not reached
-- Fusion as a payable invoice, so it is invisible to every AP/GRN/PR/PO figure
-- on Budget Utilization. This view exposes it at the butil key
-- (budget year x project x task x expenditure type) so the page can show it and,
-- when the user ticks "Include Procash", fold it into Actual and Fund Available.
--
-- WHAT COUNTS (user decision 2026-08-17): every LIVE procash transaction whose
-- Fusion invoice has not been linked yet -- draft, submitted, in approval,
-- approved and processed alike. The moment the invoice is linked the row leaves
-- this view, because the AP actual then carries the same spend: that is what
-- stops it being counted twice. Cancelled and rejected never count.
--
-- GRAIN: only PROJECT-coded lines can be placed on a budget line. GL-coded
-- procash carries no project key, so it cannot map -- dct_ap_procash_unmapped_v
-- reports that residue separately rather than silently dropping it.
--
-- YTD: honours GL_CTX.BUTIL_END (stored 'YYYY-MM-DD' by dct_gl_class_pkg) the
-- same way the fact CTEs of DCT_BUDGET_UTILIZATION_V do, so a period-filtered
-- page and the procash figure always cover the same window.
--
-- AED: line amounts are in the header currency; the header's exchange rate
-- converts them, exactly as the procash register and report do.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

PROMPT --- [1/2] procash on the budget line ---

CREATE OR REPLACE VIEW prod.dct_ap_procash_butil_v AS
SELECT TO_NUMBER(TO_CHAR(p.payment_date, 'YYYY'))        AS budget_year,
       l.project_number,
       l.task_number,
       l.expenditure_type,
       ROUND(SUM(l.amount * NVL(p.exchange_rate, 1)), 2) AS procash_aed,
       COUNT(DISTINCT p.procash_id)                      AS procash_count
  FROM prod.dct_ap_procash      p
  JOIN prod.dct_ap_procash_line l ON l.procash_id = p.procash_id
 WHERE p.status NOT IN ('INVOICED', 'CANCELLED', 'REJECTED')
   AND l.coding_basis  = 'PROJECT'
   AND l.project_number IS NOT NULL
   AND l.task_number    IS NOT NULL
   AND l.expenditure_type IS NOT NULL
   AND (SYS_CONTEXT('GL_CTX', 'BUTIL_END') IS NULL
        OR p.payment_date <= TO_DATE(SYS_CONTEXT('GL_CTX', 'BUTIL_END'), 'YYYY-MM-DD'))
 GROUP BY TO_NUMBER(TO_CHAR(p.payment_date, 'YYYY')),
          l.project_number, l.task_number, l.expenditure_type;

PROMPT --- [2/2] the procash that cannot sit on a budget line ---

CREATE OR REPLACE VIEW prod.dct_ap_procash_unmapped_v AS
SELECT TO_NUMBER(TO_CHAR(p.payment_date, 'YYYY'))        AS budget_year,
       p.business_unit,
       ROUND(SUM(l.amount * NVL(p.exchange_rate, 1)), 2) AS procash_aed,
       COUNT(DISTINCT p.procash_id)                      AS procash_count
  FROM prod.dct_ap_procash      p
  JOIN prod.dct_ap_procash_line l ON l.procash_id = p.procash_id
 WHERE p.status NOT IN ('INVOICED', 'CANCELLED', 'REJECTED')
   AND (l.coding_basis <> 'PROJECT'
        OR l.project_number IS NULL OR l.task_number IS NULL OR l.expenditure_type IS NULL)
   AND (SYS_CONTEXT('GL_CTX', 'BUTIL_END') IS NULL
        OR p.payment_date <= TO_DATE(SYS_CONTEXT('GL_CTX', 'BUTIL_END'), 'YYYY-MM-DD'))
 GROUP BY TO_NUMBER(TO_CHAR(p.payment_date, 'YYYY')), p.business_unit;

PROMPT === verification ===

SELECT object_name, status FROM all_objects
 WHERE owner = 'PROD' AND object_name IN ('DCT_AP_PROCASH_BUTIL_V', 'DCT_AP_PROCASH_UNMAPPED_V');

SELECT 'mapped rows'   AS what, COUNT(*) AS rows_now FROM prod.dct_ap_procash_butil_v
UNION ALL
SELECT 'unmapped rows', COUNT(*) FROM prod.dct_ap_procash_unmapped_v;
