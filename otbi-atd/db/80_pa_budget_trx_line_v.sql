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
-- No combination is NORMAL: an Estimated-Cost line is not required to carry a
--           code combination (user-confirmed 2026-08-17) and 5,546 of them do
--           not. So the segment codes fall back to the line's own TASK
--           attributes -- the platform's task-first attribution, same source
--           and same LPAD widths as DCT_BUDGET_UTILIZATION_V -- which supplies
--           appropriation and program for 5,071 of those 5,546. Without that,
--           a Chapter / Program / Appropriation filter would silently drop
--           every Estimated-Cost transaction: not because it sits in another
--           chapter, but because the row could not say which one.
--           Cost centre needs no such help -- it comes from the combination's
--           3rd segment, else the trailing digits of the COST_CENTER label
--           ("AFHC Education and Dialogue-6170200" -> 6170200) -- 100% covered.
--           DIM_SOURCE says which path a row took: COMBINATION or TASK.
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
), tsk AS (
    -- task-level segment attributes, the platform's task-first attribution
    -- (same source and the same LPAD widths as DCT_BUDGET_UTILIZATION_V).
    -- Grouped by project AND task: task numbers repeat across projects, so a
    -- bare GROUP BY task_number picks an arbitrary project's attributes.
    SELECT TO_CHAR(pj.project_number) AS project_key, t.task_number AS task_key,
           MAX(CASE WHEN t.appropriation IS NOT NULL THEN LPAD(TO_CHAR(t.appropriation),6,'0') END) AS appropriation_code,
           MAX(CASE WHEN t.program       IS NOT NULL THEN LPAD(TO_CHAR(t.program),6,'0')       END) AS program_code,
           MAX(CASE WHEN t.cost_center   IS NOT NULL THEN LPAD(TO_CHAR(t.cost_center),7,'0')   END) AS cost_center_code
      FROM prod.tasks t
      JOIN prod.projects pj ON pj.project_id = t.project_id
     GROUP BY TO_CHAR(pj.project_number), t.task_number
), seg AS (
    -- Segment codes come from the combination when there IS one, and fall back
    -- to the line's own task otherwise. **An Estimated-Cost line legitimately
    -- has no code combination -- it is not mandatory for that budget type**
    -- (user-confirmed 2026-08-17), and 5,546 of them carry none. Without the
    -- fallback, filtering by Chapter, Program or Appropriation would silently
    -- exclude every Estimated-Cost transaction: not because it belongs to
    -- another chapter, but because the row could not say which. The task
    -- attributes answer that for 5,071 of the 5,546.
    SELECT l.*,
           COALESCE(REGEXP_SUBSTR(l.code_combination, '[^.]+', 1, 2),
                    k.program_code)                              AS program_code,
           COALESCE(REGEXP_SUBSTR(l.code_combination, '[^.]+', 1, 3),
                    REGEXP_SUBSTR(l.cost_center, '[0-9]+$'),
                    k.cost_center_code)                          AS cost_center_code,
           REGEXP_SUBSTR(l.code_combination, '[^.]+', 1, 5)      AS account_code,
           COALESCE(REGEXP_SUBSTR(l.code_combination, '[^.]+', 1, 7),
                    k.appropriation_code)                        AS appropriation_code,
           -- so a consumer can tell a derived dimension from a posted one
           CASE WHEN l.code_combination IS NULL THEN 'TASK' ELSE 'COMBINATION' END AS dim_source
      FROM ln l
      LEFT JOIN tsk k ON k.project_key = l.project_num
                     AND k.task_key    = l.task_num
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
       acc.nm AS account_name,
       s.dim_source
  FROM seg s
  LEFT JOIN cc  ON cc.cost_center_code   = s.cost_center_code
  LEFT JOIN ap  ON ap.appropriation_code = s.appropriation_code
  LEFT JOIN pg  ON pg.program_code       = s.program_code
  LEFT JOIN acc ON acc.account_code      = s.account_code;

-- ORDS handlers run as ADMIN: without this synonym every route over the view
-- returns an uncatchable 555.
CREATE OR REPLACE SYNONYM v_pa_budget_trx_line FOR prod.v_pa_budget_trx_line;

PROMPT ATD 80 V_PA_BUDGET_TRX_LINE : done
