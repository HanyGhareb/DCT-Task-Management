-- ===========================================================================
-- DCT Actuals Reporting - base-view rebuild proc (db/v2/38)
-- ---------------------------------------------------------------------------
-- prod.dct_views_rebuild : the "structural reload" recovery button.
--
-- WHY: the base reporting views (db/v2/32 + 36) are SELECT * pass-throughs
-- over the Fusion-loaded ATD_* tables. A SELECT * view freezes its column
-- list at CREATE time, so when a reload CHANGES a table's structure (new /
-- renamed columns - e.g. BUDGET_YEAR appearing on ATD_PROJECTS_BUDGET),
-- recompiling is NOT enough: the view must be re-CREATEd to expose the new
-- columns. That used to mean manually re-running db/v2/32 and 36.
--
-- WHAT IT DOES (in order):
--   1. Re-creates every pass-through view from its ATD_ base table
--      (CREATE OR REPLACE VIEW prod.X AS SELECT * FROM prod.ATD_X).
--      A missing base table (mid-reload) is skipped, not an error.
--   2. Calls prod.dct_actuals_refresh - rebuilds DCT_GL_COA_SNAP and
--      recompiles every INVALID PROD view (2 passes for dependency chains).
--   3. Reports how many views were rebuilt + any views STILL invalid
--      (those reference a column that was renamed/dropped and need a real
--      script edit - db/v2/32/34/36/37).
--
-- KEEP THE LIST IN SYNC with the pass-through sections of db/v2/32 and 36.
-- Exposed to the GL app as POST /gl/actuals/rebuild (final apps/GL/db/08).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

-- The proc creates views in its own schema at runtime; definer-rights PL/SQL
-- ignores role grants, so PROD needs the system privilege directly.
GRANT CREATE VIEW TO PROD;

CREATE OR REPLACE PROCEDURE prod.dct_views_rebuild (
  p_rebuilt OUT NUMBER,
  p_invalid OUT VARCHAR2
) AS
  TYPE t_names IS TABLE OF VARCHAR2(40);
  -- every view here is prod.<name> = SELECT * FROM prod.ATD_<name>
  l_v t_names := t_names(
    'AP_INVOICES', 'AP_INVOICE_HEADER', 'AP_INVOICE_LINES', 'AP_INVOICE_DISTRIBUTIONS',
    'PO_HEADERS', 'PO_LINES', 'PO_DISTRIBUTIONS', 'PO_SCHEDULES',
    'GRN_ALL_V2', 'GL_BALANCES',
    'PROJECTS', 'TASKS', 'PROJECTS_BUDGET',
    'PR_HEADERS', 'PR_LINES', 'PR_DISTRIBUTIONS');
BEGIN
  p_rebuilt := 0;
  FOR i IN 1 .. l_v.COUNT LOOP
    BEGIN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW prod.' || l_v(i)
                     || ' AS SELECT * FROM prod.ATD_' || l_v(i);
      p_rebuilt := p_rebuilt + 1;
    EXCEPTION WHEN OTHERS THEN NULL;   -- base table absent mid-reload: skip
    END;
  END LOOP;

  prod.dct_actuals_refresh;            -- snapshot + recompile INVALIDs

  SELECT LISTAGG(object_name, ', ') WITHIN GROUP (ORDER BY object_name)
    INTO p_invalid
    FROM user_objects
   WHERE object_type = 'VIEW' AND status = 'INVALID';
END;
/

SHOW ERRORS

PROMPT prod.dct_views_rebuild created (structural-reload recovery).
