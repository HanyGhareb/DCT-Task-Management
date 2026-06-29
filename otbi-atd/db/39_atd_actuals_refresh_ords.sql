-- =============================================================================
-- ATD Loader (App 208) -- "Refresh Actuals" ORDS (additive on atd.rest)
-- File : 39_atd_actuals_refresh_ords.sql
-- Endpoint (module atd.rest, base /ords/admin/atd/):
--   POST actuals/refresh   rebuild prod.dct_gl_coa_snap (the COA snapshot the
--                          actuals reporting layer reads). Same proc the GL app
--                          and the hourly job (db/v2/35) call.
-- Run : sql -name prod_mcp @39_atd_actuals_refresh_ords.sql  (FRESH session;
--       additive, no DELETE_MODULE -- safe after 13_atd_ords.sql). Idempotent.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- ADMIN synonym for the PROD refresh proc (handlers run as ADMIN)
CREATE OR REPLACE SYNONYM dct_actuals_refresh FOR prod.dct_actuals_refresh;

CREATE OR REPLACE PROCEDURE admin.setup_atd_actuals_refresh_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30) := 'atd.rest';
  PROCEDURE def_template(p_pattern VARCHAR2) IS
  BEGIN
    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern,'[COLON]',CHR(58)));
  END;
  PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
  BEGIN
    ORDS.DEFINE_HANDLER(p_module_name => c_mod,
      p_pattern => REPLACE(p_pattern,'[COLON]',CHR(58)),
      p_method => p_method, p_source_type => ORDS.source_type_plsql,
      p_source => REPLACE(p_source,'[COLON]',CHR(58)));
  END;
BEGIN
  def_template('actuals/refresh');
  def_handler('actuals/refresh', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_actuals_refresh;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('ok', 1);
  APEX_JSON.write('refreshedAt', TO_CHAR(dct_to_local(SYSTIMESTAMP),'YYYY-MM-DD HH:MI AM'));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
  COMMIT;
END;
/
SHOW ERRORS PROCEDURE admin.setup_atd_actuals_refresh_ords_tmp

BEGIN
  admin.setup_atd_actuals_refresh_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE admin.setup_atd_actuals_refresh_ords_tmp;

PROMPT 39_atd_actuals_refresh_ords : done (POST /ords/admin/atd/actuals/refresh)
