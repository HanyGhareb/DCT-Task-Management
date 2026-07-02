-- =============================================================================
-- General Ledger (App 210) -- Rebuild-views ORDS endpoint (ADDITIVE)
-- File    : 08_gl_views_rebuild_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @08_gl_views_rebuild_ords.sql  (FRESH session --
--           creates a synonym; never after ALTER SESSION SET CURRENT_SCHEMA)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07 AND this script right after it.
-- Endpoint:
--   POST /gl/actuals/rebuild -> runs prod.dct_views_rebuild (db/v2/38):
--     re-creates the SELECT * base pass-through views over the ATD_* tables
--     (picks up structural changes from a reload), then refreshes the snapshot
--     + recompiles INVALID views. Returns {ok, rebuilt, invalidRemaining,
--     refreshedAt}. invalidRemaining non-empty = a view references a renamed/
--     dropped column and needs a script edit (db/v2/32/34/36/37).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE SYNONYM dct_views_rebuild FOR prod.dct_views_rebuild;

CREATE OR REPLACE PROCEDURE setup_gl_rebuild_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';

BEGIN

    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => 'actuals/rebuild');

    ORDS.DEFINE_HANDLER(
        p_module_name => c_mod,
        p_pattern     => 'actuals/rebuild',
        p_method      => 'POST',
        p_source_type => ORDS.source_type_plsql,
        p_source      => q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_rebuilt NUMBER;
  l_invalid VARCHAR2(4000);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_views_rebuild(l_rebuilt, l_invalid);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('ok', 1);
  APEX_JSON.write('rebuilt', l_rebuilt);
  APEX_JSON.write('invalidRemaining', NVL(l_invalid,''));
  APEX_JSON.write('refreshedAt', TO_CHAR(dct_to_local(SYSTIMESTAMP),'YYYY-MM-DD HH:MI AM'));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_gl_rebuild_ords_tmp;
/

SHOW ERRORS

EXECUTE setup_gl_rebuild_ords_tmp
DROP PROCEDURE setup_gl_rebuild_ords_tmp;

PROMPT gl.rest rebuild endpoint published (POST /gl/actuals/rebuild).
EXIT
