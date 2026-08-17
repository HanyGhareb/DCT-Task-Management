-- =============================================================================
-- ATD (App 208) -- PBT extract: unified transaction-LINE view (ADDITIVE)
-- File    : 80_pa_budget_trx_line_v.sql
-- Run     : sql -name prod_mcp @80_pa_budget_trx_line_v.sql   (fresh session)
--
-- Purpose : ONE view over the three per-type line tables so any consumer can
--           filter transactions by their LINE attributes -- project, task,
--           expenditure type, cost centre, accounting period -- and by the GL
--           classification dimensions the Budget Utilization page filters on
--           (Sector, Chapter, DCT Program, Appropriation).
--
--           The three line tables genuinely differ in shape (34 / 21 / 38
--           source fields), which is why they are separate tables; this view
--           projects only the columns they have in COMMON, in one grain:
--           one row per transaction line.
--
-- Classification: resolved BY SEGMENT, not by the whole combination.
--           Joining the line's 10-segment CODE_COMBINATION to
--           DCT_GL_COA_SNAP.CC_STRING matches only 82-99% of lines depending on
--           the type (entity 617 / Abrahamic Family House combinations are not
--           all in the snapshot, and 5,546 Estimated-Cost lines carry NO
--           combination at all). Segment-level maps -- cost centre -> Sector,
--           appropriation -> Chapter, program -> DCT Program -- cover
--           everything the snapshot knows about, and each map is 1:1 in the
--           data (verified: zero cost centres with >1 sector, zero
--           appropriations with >1 chapter, zero programs with >1 name), so
--           the MAX() aggregates below pick a value, never one of several.
--
-- Cost centre code: the combination's 3rd segment when present, else the
--           trailing digits of the COST_CENTER label ("AFHC Education and
--           Dialogue-6170200" -> 6170200), which is the only source on the
--           Estimated-Cost lines that have no combination.
--
-- Period: MM-YYYY strings cannot be compared lexically ('02-2025' > '01-2026'),
--           so the view also emits sortable YYYYMM numbers -- guarded by a
--           format check so one malformed source value cannot ORA-01843 an
--           entire query.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE VIEW prod.v_pa_budget_trx_line AS
WITH ln AS (
    SELECT transaction_num, 'Additional' AS trx_type, project_num, project_name,
           task_num, task_name, expenditure_type, cost_center, code_combination,
           period_from, period_to
      FROM prod.pa_additional_fund_lines
    UNION ALL
    SELECT transaction_num, 'Estimated-Cost', project_num, project_name,
           task_num, task_name, expenditure_type, cost_center, code_combination,
           CAST(NULL AS VARCHAR2(20)), CAST(NULL AS VARCHAR2(20))
      FROM prod.pa_estimated_cost_lines
    UNION ALL
    SELECT transaction_num, 'Annual-Budget', project_num, project_name,
           task_num, task_name, expenditure_type, cost_center, code_combination,
           period_from, period_to
      FROM prod.pa_annual_budget_lines
), seg AS (
    SELECT l.*,
           REGEXP_SUBSTR(l.code_combination, '[^.]+', 1, 2) AS program_code,
           COALESCE(REGEXP_SUBSTR(l.code_combination, '[^.]+', 1, 3),
                    REGEXP_SUBSTR(l.cost_center, '[0-9]+$'))  AS cost_center_code,
           REGEXP_SUBSTR(l.code_combination, '[^.]+', 1, 5) AS account_code,
           REGEXP_SUBSTR(l.code_combination, '[^.]+', 1, 7) AS appropriation_code
      FROM ln l
), cc AS (
    SELECT cost_center_code, MAX(cost_center_desc) nm, MAX(sector_code) sc, MAX(sector_name) sn
      FROM prod.dct_gl_coa_snap WHERE cost_center_code IS NOT NULL GROUP BY cost_center_code
), ap AS (
    SELECT appropriation_code, MAX(appropriation_desc) nm, MAX(chapter_code) ch, MAX(chapter_name) cn
      FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL GROUP BY appropriation_code
), pg AS (
    SELECT program_code, MAX(program_desc) nm, MAX(program_name) cls
      FROM prod.dct_gl_coa_snap WHERE program_code IS NOT NULL GROUP BY program_code
), acc AS (
    SELECT account_code, MAX(account_desc) nm
      FROM prod.dct_gl_coa_snap WHERE account_code IS NOT NULL GROUP BY account_code
)
SELECT s.transaction_num,
       s.trx_type,
       s.project_num,
       s.project_name,
       s.task_num,
       s.task_name,
       s.expenditure_type,
       s.cost_center,
       s.code_combination,
       s.period_from,
       s.period_to,
       CASE WHEN REGEXP_LIKE(s.period_from, '^[0-9]{2}-[0-9]{4}$')
            THEN TO_NUMBER(SUBSTR(s.period_from, 4, 4) || SUBSTR(s.period_from, 1, 2)) END AS period_from_num,
       CASE WHEN REGEXP_LIKE(s.period_to,   '^[0-9]{2}-[0-9]{4}$')
            THEN TO_NUMBER(SUBSTR(s.period_to,   4, 4) || SUBSTR(s.period_to,   1, 2)) END AS period_to_num,
       s.cost_center_code,
       cc.nm  AS cost_center_name,
       cc.sc  AS sector_code,
       cc.sn  AS sector_name,
       s.appropriation_code,
       ap.nm  AS appropriation_name,
       ap.ch  AS chapter_code,
       ap.cn  AS chapter_name,
       s.program_code,
       pg.nm  AS program_desc,
       pg.cls AS program_name,
       s.account_code,
       acc.nm AS account_name
  FROM seg s
  LEFT JOIN cc  ON cc.cost_center_code   = s.cost_center_code
  LEFT JOIN ap  ON ap.appropriation_code = s.appropriation_code
  LEFT JOIN pg  ON pg.program_code       = s.program_code
  LEFT JOIN acc ON acc.account_code      = s.account_code;

-- ORDS handlers run as ADMIN: without this synonym every route over the view
-- returns an uncatchable 555.
CREATE OR REPLACE SYNONYM v_pa_budget_trx_line FOR prod.v_pa_budget_trx_line;

PROMPT ATD 80 V_PA_BUDGET_TRX_LINE : done
