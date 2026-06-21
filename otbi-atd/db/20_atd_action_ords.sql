-- =============================================================================
-- ATD Loader (App 208) -- ORDS for Fusion write-back ACTIONS  (additive)
-- File    : 20_atd_action_ords.sql
-- Base URL: /ords/admin/atd/   (adds to the EXISTING 'atd.rest' module)
-- Run     : sql -name prod_mcp @20_atd_action_ords.sql   (FRESH session - synonym
--           rule: must NOT follow ALTER SESSION SET CURRENT_SCHEMA=PROD)
-- =============================================================================
-- Adds Actions endpoints to the atd.rest module WITHOUT DELETE_MODULE/DEFINE_MODULE
-- (purely DEFINE_TEMPLATE/DEFINE_HANDLER), so the live extract API is untouched.
-- Admin-only (SYS_ADMIN). [COLON] -> ':' at define time (SQLcl bind-scan guard).
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- ADMIN synonyms for the new PROD objects the handlers touch
CREATE OR REPLACE SYNONYM atd_action_request FOR prod.atd_action_request;
CREATE OR REPLACE SYNONYM atd_action_pkg     FOR prod.atd_action_pkg;

CREATE OR REPLACE PROCEDURE setup_atd_action_ords_tmp AS
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
    -- GET /actions  -- list (paginated, filter by status/type/search)
    -- =========================================================================
    def_template('actions');
    def_handler('actions', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_type   VARCHAR2(30)  := UPPER([COLON]type);
  l_search VARCHAR2(200) := [COLON]search;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 100), 500);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM atd_action_request a
   WHERE (l_status IS NULL OR a.run_status = l_status)
     AND (l_type   IS NULL OR a.action_type = l_type)
     AND (l_search IS NULL OR UPPER(a.source_ref||' '||a.idem_key||' '||a.fusion_invoice_id)
          LIKE '%'||UPPER(l_search)||'%');
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT a.action_id, a.action_type, a.env_name, a.source_module, a.source_type,
           a.source_ref, a.idem_key, a.run_status, a.priority, a.attempts, a.max_attempts,
           a.claimed_by, a.fusion_invoice_id,
           NVL(DBMS_LOB.SUBSTR(a.last_error,300,1),'') AS last_err,
           TO_CHAR( dct_to_local(a.claimed_at),'YYYY-MM-DD HH:MI AM') AS claimed_s,
           TO_CHAR( dct_to_local(a.created_at),'YYYY-MM-DD HH:MI AM') AS created_s,
           TO_CHAR( dct_to_local(a.updated_at),'YYYY-MM-DD HH:MI AM') AS updated_s
    FROM atd_action_request a
    WHERE (l_status IS NULL OR a.run_status = l_status)
      AND (l_type   IS NULL OR a.action_type = l_type)
      AND (l_search IS NULL OR UPPER(a.source_ref||' '||a.idem_key||' '||a.fusion_invoice_id)
           LIKE '%'||UPPER(l_search)||'%')
    ORDER BY a.action_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('actionId', r.action_id);
    APEX_JSON.write('actionType', r.action_type);
    APEX_JSON.write('envName', NVL(r.env_name,''));
    APEX_JSON.write('sourceModule', NVL(r.source_module,''));
    APEX_JSON.write('sourceType', NVL(r.source_type,''));
    APEX_JSON.write('sourceRef', NVL(r.source_ref,''));
    APEX_JSON.write('idemKey', r.idem_key);
    APEX_JSON.write('runStatus', r.run_status);
    APEX_JSON.write('priority', r.priority);
    APEX_JSON.write('attempts', r.attempts);
    APEX_JSON.write('maxAttempts', r.max_attempts);
    APEX_JSON.write('claimedBy', NVL(r.claimed_by,''));
    APEX_JSON.write('claimedAt', NVL(r.claimed_s,''));
    APEX_JSON.write('fusionInvoiceId', NVL(r.fusion_invoice_id,''));
    APEX_JSON.write('lastError', r.last_err);
    APEX_JSON.write('createdAt', NVL(r.created_s,''));
    APEX_JSON.write('updatedAt', NVL(r.updated_s,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GET /actions/stats  -- queue health tile for the dashboard
    -- =========================================================================
    def_template('actions/stats');
    def_handler('actions/stats', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_ready NUMBER; l_claimed NUMBER; l_done NUMBER; l_failed NUMBER; l_cancelled NUMBER; l_total NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*),
         COUNT(CASE WHEN run_status='READY'     THEN 1 END),
         COUNT(CASE WHEN run_status='CLAIMED'   THEN 1 END),
         COUNT(CASE WHEN run_status='DONE'      THEN 1 END),
         COUNT(CASE WHEN run_status='FAILED'    THEN 1 END),
         COUNT(CASE WHEN run_status='CANCELLED' THEN 1 END)
    INTO l_total, l_ready, l_claimed, l_done, l_failed, l_cancelled FROM atd_action_request;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total);
  APEX_JSON.write('ready', l_ready);     APEX_JSON.write('claimed', l_claimed);
  APEX_JSON.write('done', l_done);       APEX_JSON.write('failed', l_failed);
  APEX_JSON.write('cancelled', l_cancelled);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GET /actions/:id  -- detail (payload + error + source status history)
    -- =========================================================================
    def_template('actions/[COLON]id');
    def_handler('actions/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Invalid action id'); RETURN; END IF;
  SELECT COUNT(*) INTO l_found FROM atd_action_request WHERE action_id = l_id;
  IF l_found = 0 THEN dct_rest.err(404,'Action not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM atd_action_request WHERE action_id = l_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('actionId', r.action_id);
    APEX_JSON.write('actionType', r.action_type);
    APEX_JSON.write('envName', NVL(r.env_name,''));
    APEX_JSON.write('sourceModule', NVL(r.source_module,''));
    APEX_JSON.write('sourceType', NVL(r.source_type,''));
    APEX_JSON.write('sourceId', r.source_id);
    APEX_JSON.write('sourceRef', NVL(r.source_ref,''));
    APEX_JSON.write('idemKey', r.idem_key);
    APEX_JSON.write('runStatus', r.run_status);
    APEX_JSON.write('priority', r.priority);
    APEX_JSON.write('attempts', r.attempts);
    APEX_JSON.write('maxAttempts', r.max_attempts);
    APEX_JSON.write('claimedBy', NVL(r.claimed_by,''));
    APEX_JSON.write('claimedAt', TO_CHAR( dct_to_local(r.claimed_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('fusionInvoiceId', NVL(r.fusion_invoice_id,''));
    APEX_JSON.write('fusionRef', NVL(r.fusion_ref,''));
    APEX_JSON.write('lastError', NVL(DBMS_LOB.SUBSTR(r.last_error,3900,1),''));
    APEX_JSON.write('payloadJson', NVL(DBMS_LOB.SUBSTR(r.payload_json,32000,1),''));
    APEX_JSON.write('createdAt', TO_CHAR( dct_to_local(r.created_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.write('updatedAt', TO_CHAR( dct_to_local(r.updated_at),'YYYY-MM-DD HH:MI AM'));
    APEX_JSON.open_array('history');
    FOR h IN (SELECT new_status, old_status, comments,
                     TO_CHAR( dct_to_local(changed_at),'YYYY-MM-DD HH:MI AM') AS changed_s
              FROM dct_request_status_history
              WHERE source_module = r.source_module
                AND source_type   = r.source_type
                AND source_id     = r.source_id
              ORDER BY hist_id DESC) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('newStatus', NVL(h.new_status,''));
      APEX_JSON.write('oldStatus', NVL(h.old_status,''));
      APEX_JSON.write('comments', NVL(h.comments,''));
      APEX_JSON.write('changedAt', NVL(h.changed_s,''));
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- POST /actions/:id/retry  -- re-arm a FAILED/CANCELLED action (-> READY)
    -- =========================================================================
    def_template('actions/[COLON]id/retry');
    def_handler('actions/[COLON]id/retry', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Invalid action id'); RETURN; END IF;
  UPDATE atd_action_request
     SET run_status='READY', claimed_by=NULL, claimed_at=NULL, attempts=0,
         last_error=NULL, updated_at=SYSTIMESTAMP
   WHERE action_id = l_id AND run_status IN ('FAILED','CANCELLED');
  l_n := SQL%ROWCOUNT;
  COMMIT;
  IF l_n = 0 THEN dct_rest.err(404,'Action not found or not retryable'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- POST /actions/:id/cancel  -- cancel anything not already DONE
    -- =========================================================================
    def_template('actions/[COLON]id/cancel');
    def_handler('actions/[COLON]id/cancel', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id NUMBER := TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  l_st VARCHAR2(12);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  IF l_id IS NULL THEN dct_rest.err(400,'Invalid action id'); RETURN; END IF;
  BEGIN SELECT run_status INTO l_st FROM atd_action_request WHERE action_id = l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Action not found'); RETURN; END;
  IF l_st = 'DONE' THEN dct_rest.err(400,'Action already DONE'); RETURN; END IF;
  atd_action_pkg.cancel_action(l_id);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_atd_action_ords_tmp;
/

BEGIN
  setup_atd_action_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE setup_atd_action_ords_tmp;

PROMPT otbi-atd 20 action ORDS : done
