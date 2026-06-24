-- ===========================================================================
-- otbi-atd : 26 operator-triggered worker re-login ("Refresh")
--   * refresh_req column on ATD_WORKER_HEARTBEAT  -> a pending re-login request
--     for a worker (set by the UI button or the Telegram "refresh <vm>" command;
--     the --forever worker loop clears it and forces a fresh Fusion login/MFA)
--   * additive ORDS: POST /atd/workers/:id/refresh   (id = worker_id, or 'all')
-- Additive only (DEFINE_TEMPLATE/DEFINE_HANDLER) -> the live atd.rest module and
-- its actions endpoints are untouched (no DELETE_MODULE). Run in a FRESH session
-- (synonym rule: must NOT follow ALTER SESSION SET CURRENT_SCHEMA=PROD).
-- Rerunnable. Schema-qualified PROD. CRLF / UTF-8 no BOM. [COLON] -> ':' at define.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO ON

-- pending operator re-login request for a worker (NULL = none)
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_worker_heartbeat ADD (refresh_req TIMESTAMP)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

-- ADMIN synonym for the object the handler touches
CREATE OR REPLACE SYNONYM atd_worker_heartbeat FOR prod.atd_worker_heartbeat;

CREATE OR REPLACE PROCEDURE setup_atd_refresh_ords_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'atd.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    -- =========================================================================
    -- POST /workers/:id/refresh  -- ask a worker (or 'all') to re-login (MFA)
    -- =========================================================================
    def_template('workers/[COLON]id/refresh');
    def_handler('workers/[COLON]id/refresh', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   VARCHAR2(120) := [COLON]id;
  l_n    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Worker id required'); RETURN; END IF;
  IF LOWER(l_id) = 'all' THEN
    UPDATE atd_worker_heartbeat SET refresh_req = SYSTIMESTAMP;
  ELSE
    UPDATE atd_worker_heartbeat SET refresh_req = SYSTIMESTAMP WHERE worker_id = l_id;
  END IF;
  l_n := SQL%ROWCOUNT;
  COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Worker not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('requested', l_id);
  APEX_JSON.write('count', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

END setup_atd_refresh_ords_tmp;
/

BEGIN
  setup_atd_refresh_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE setup_atd_refresh_ords_tmp;

SET ECHO OFF
PROMPT otbi-atd 26 worker refresh : done
