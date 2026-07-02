-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 13 Interactive Report parameter LOVs
-- File   : reporting/db/13_rpt_ir_lov.sql
-- Schema : PROD (column on dct_rpt_definition + pilot seeds)
-- Run as : sql -name prod_mcp   (fresh session)
-- Purpose: per-definition lists of values for run parameters. A definition may
--          carry PARAMS_LOV_JSON = { "<param>": "<bind-free query text>" } --
--          admin-authored, same trust level as source_ref. The viewer renders
--          a dropdown for any parameter present here (endpoint in 13a; the
--          query is executed by dct_rpt_ir_pkg.run_lov: first column = value,
--          optional second column = display label, capped at 500 rows).
-- Idempotent: guarded column add + plain re-runnable seed writes.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. params_lov_json column on dct_rpt_definition ===
BEGIN
  EXECUTE IMMEDIATE q'[
    ALTER TABLE prod.dct_rpt_definition ADD (
      params_lov_json CLOB,
      CONSTRAINT ck_dct_rpt_def_lov CHECK (params_lov_json IS NULL OR params_lov_json IS JSON)
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE NOT IN (-1430, -2264, -2260) THEN RAISE; END IF; END;
/

PROMPT === 2. Pilot seeds: BUDGET_UTIL_SECTOR + GL_BUDGET_ACTUAL ===
UPDATE prod.dct_rpt_definition
   SET params_lov_json = q'[{
  "year": "SELECT DISTINCT budget_year FROM prod.dct_budget_utilization_v ORDER BY budget_year DESC",
  "sector": "SELECT DISTINCT sector FROM prod.dct_butil_scope_v WHERE sector IS NOT NULL ORDER BY sector",
  "projecttype": "SELECT DISTINCT project_type FROM prod.dct_butil_scope_v WHERE project_type IS NOT NULL ORDER BY project_type",
  "costcenter": "SELECT DISTINCT cost_centre FROM prod.dct_butil_scope_v WHERE cost_centre IS NOT NULL ORDER BY cost_centre"
}]'
 WHERE report_code = 'BUDGET_UTIL_SECTOR';

UPDATE prod.dct_rpt_definition
   SET params_lov_json = q'[{
  "period": "SELECT period_name FROM prod.dct_budget_actual_period_v GROUP BY period_name ORDER BY MAX(period_date) DESC"
}]'
 WHERE report_code = 'GL_BUDGET_ACTUAL';

COMMIT;

PROMPT ============================================================
PROMPT  13_rpt_ir_lov.sql complete (column + 2 pilot LOV seeds).
PROMPT ============================================================
