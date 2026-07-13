-- =============================================================================
-- otbi-atd : Action telemetry -- worker VM + start/end/duration + submitted-by
-- File    : 46_atd_action_telemetry.sql   (rerunnable)
-- Run     : sql -name prod_mcp @46_atd_action_telemetry.sql  (FRESH session)
-- =============================================================================
-- The queue clears claimed_by/claimed_at when an action finishes, so the UI
-- could not show WHICH worker ran an action or how long it took. This adds
-- PERSISTENT telemetry columns to ATD_ACTION_REQUEST:
--   worker_host  -- the VM that (last) ran the action (claim overwrites)
--   started_at   -- when that claim happened (finished_at cleared on re-claim)
--   finished_at  -- when the action reached DONE / FAILED-retry / CANCELLED
-- plus the package writes them and GET /atd/actions returns workerVm /
-- startedAt / finishedAt / durationSecs / submittedBy.
-- SOURCE SYNC: the same package body lives in 19_atd_action_queue.sql and the
-- same GET /actions handler in 20_atd_action_ords.sql -- keep all three equal.
-- (Post-13 ORDS re-run list stays 20/38/41/42/44/45 -- 20 carries the handler.)
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- 1) telemetry columns (idempotent adds)
DECLARE
  PROCEDURE add_col(p_col VARCHAR2, p_ddl VARCHAR2) IS
    n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO n FROM all_tab_columns
     WHERE owner = 'PROD' AND table_name = 'ATD_ACTION_REQUEST' AND column_name = p_col;
    IF n = 0 THEN
      EXECUTE IMMEDIATE p_ddl;
      DBMS_OUTPUT.put_line('added ' || p_col);
    ELSE
      DBMS_OUTPUT.put_line(p_col || ' already present');
    END IF;
  END;
BEGIN
  add_col('WORKER_HOST', 'ALTER TABLE prod.atd_action_request ADD (worker_host VARCHAR2(120))');
  add_col('STARTED_AT',  'ALTER TABLE prod.atd_action_request ADD (started_at TIMESTAMP)');
  add_col('FINISHED_AT', 'ALTER TABLE prod.atd_action_request ADD (finished_at TIMESTAMP)');
END;
/

-- 2) package body: write the telemetry (spec unchanged; body synced with 19)
CREATE OR REPLACE PACKAGE BODY prod.atd_action_pkg AS

  FUNCTION enqueue_action(
    p_action_type   VARCHAR2,
    p_source_module VARCHAR2,
    p_source_type   VARCHAR2,
    p_source_id     NUMBER,
    p_source_ref    VARCHAR2,
    p_idem_key      VARCHAR2,
    p_payload       CLOB,
    p_env_name      VARCHAR2 DEFAULT NULL,
    p_created_by    VARCHAR2 DEFAULT NULL
  ) RETURN NUMBER IS
    v_id NUMBER;
  BEGIN
    MERGE INTO prod.atd_action_request t
    USING (SELECT p_idem_key AS idem_key FROM dual) s
    ON (t.idem_key = s.idem_key)
    WHEN MATCHED THEN
      UPDATE SET payload_json  = p_payload,
                 source_ref    = p_source_ref,
                 env_name      = NVL(p_env_name, t.env_name),
                 last_error    = NULL,
                 claimed_by    = NULL,
                 claimed_at    = NULL,
                 worker_host   = NULL,
                 started_at    = NULL,
                 finished_at   = NULL,
                 attempts      = 0,
                 run_status    = CASE WHEN t.run_status IN ('FAILED','CANCELLED')
                                      THEN 'READY' ELSE t.run_status END,
                 updated_at    = SYSTIMESTAMP
      WHERE  t.run_status <> 'DONE'
    WHEN NOT MATCHED THEN
      INSERT (action_type, env_name, source_module, source_type, source_id,
              source_ref, idem_key, payload_json, run_status, created_by)
      VALUES (p_action_type, p_env_name, p_source_module, p_source_type, p_source_id,
              p_source_ref, p_idem_key, p_payload, 'READY', p_created_by);

    SELECT action_id INTO v_id FROM prod.atd_action_request WHERE idem_key = p_idem_key;
    COMMIT;
    RETURN v_id;
  END enqueue_action;

  FUNCTION claim_next_action(p_host VARCHAR2) RETURN NUMBER IS
    CURSOR c IS
      SELECT action_id FROM prod.atd_action_request
       WHERE run_status = 'READY'
       ORDER BY priority, action_id
       FOR UPDATE SKIP LOCKED;
    v_id prod.atd_action_request.action_id%TYPE;
  BEGIN
    OPEN c;
    FETCH c INTO v_id;
    IF c%FOUND THEN
      UPDATE prod.atd_action_request
         SET run_status = 'CLAIMED', claimed_by = p_host,
             claimed_at = CAST(SYSTIMESTAMP AS TIMESTAMP),
             worker_host = p_host,
             started_at  = CAST(SYSTIMESTAMP AS TIMESTAMP),
             finished_at = NULL,
             attempts   = attempts + 1,
             updated_at = SYSTIMESTAMP
       WHERE action_id = v_id;
    END IF;
    CLOSE c;
    COMMIT;                 -- releases the row lock; CLAIMED now owns it
    RETURN v_id;           -- NULL when the queue is empty
  END claim_next_action;

  FUNCTION reap_stale_actions(p_lease_minutes NUMBER DEFAULT 30) RETURN NUMBER IS
    n NUMBER;
  BEGIN
    UPDATE prod.atd_action_request
       SET run_status = 'READY', claimed_by = NULL, claimed_at = NULL,
           updated_at = SYSTIMESTAMP
     WHERE run_status = 'CLAIMED'
       AND claimed_at < CAST(SYSTIMESTAMP AS TIMESTAMP)
                        - NUMTODSINTERVAL(NVL(p_lease_minutes,30), 'MINUTE');
    n := SQL%ROWCOUNT;
    COMMIT;
    RETURN n;
  END reap_stale_actions;

  PROCEDURE mark_action_done(p_id NUMBER, p_invoice_id VARCHAR2, p_ref VARCHAR2 DEFAULT NULL) IS
  BEGIN
    UPDATE prod.atd_action_request
       SET run_status        = 'DONE',
           fusion_invoice_id = p_invoice_id,
           fusion_ref        = NVL(p_ref, fusion_ref),
           last_error        = NULL,
           claimed_by        = NULL,
           claimed_at        = NULL,
           finished_at       = CAST(SYSTIMESTAMP AS TIMESTAMP),
           updated_at        = SYSTIMESTAMP
     WHERE action_id = p_id;
    COMMIT;
  END mark_action_done;

  PROCEDURE mark_action_failed(p_id NUMBER, p_err VARCHAR2) IS
  BEGIN
    UPDATE prod.atd_action_request
       SET run_status = CASE WHEN attempts < max_attempts THEN 'READY' ELSE 'FAILED' END,
           last_error = SUBSTR(p_err, 1, 4000),
           claimed_by = NULL,
           claimed_at = NULL,
           finished_at = CAST(SYSTIMESTAMP AS TIMESTAMP),
           updated_at = SYSTIMESTAMP
     WHERE action_id = p_id;
    COMMIT;
  END mark_action_failed;

  PROCEDURE cancel_action(p_id NUMBER) IS
  BEGIN
    UPDATE prod.atd_action_request
       SET run_status = 'CANCELLED',
           claimed_by = NULL,
           claimed_at = NULL,
           finished_at = CAST(SYSTIMESTAMP AS TIMESTAMP),
           updated_at = SYSTIMESTAMP
     WHERE action_id = p_id AND run_status <> 'DONE';
    COMMIT;
  END cancel_action;

END atd_action_pkg;
/

-- 3) ORDS: GET /atd/actions gains workerVm / startedAt / finishedAt /
--    durationSecs / submittedBy (DEFINE_HANDLER only -- template exists in 20;
--    the SAME source is synced into 20 so a post-13 re-run keeps it)
DECLARE
  PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
  BEGIN
    ORDS.DEFINE_HANDLER(
      p_module_name => 'atd.rest',
      p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
      p_method      => p_method,
      p_source_type => ORDS.source_type_plsql,
      p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
  END;
BEGIN
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
           a.claimed_by, a.fusion_invoice_id, a.created_by, a.worker_host,
           NVL(DBMS_LOB.SUBSTR(a.last_error,300,1),'') AS last_err,
           TO_CHAR( dct_to_local(a.claimed_at),'YYYY-MM-DD HH:MI AM') AS claimed_s,
           TO_CHAR( dct_to_local(a.created_at),'YYYY-MM-DD HH:MI AM') AS created_s,
           TO_CHAR( dct_to_local(a.updated_at),'YYYY-MM-DD HH:MI AM') AS updated_s,
           TO_CHAR( dct_to_local(a.started_at),'YYYY-MM-DD HH:MI AM') AS started_s,
           TO_CHAR( dct_to_local(a.finished_at),'YYYY-MM-DD HH:MI AM') AS finished_s,
           CASE WHEN a.started_at IS NOT NULL THEN
             ROUND((CAST(NVL(a.finished_at, CAST(SYSTIMESTAMP AS TIMESTAMP)) AS DATE)
                    - CAST(a.started_at AS DATE)) * 86400)
           END AS dur_secs
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
    APEX_JSON.write('workerVm', NVL(r.worker_host,''));
    APEX_JSON.write('startedAt', NVL(r.started_s,''));
    APEX_JSON.write('finishedAt', NVL(r.finished_s,''));
    IF r.dur_secs IS NOT NULL THEN APEX_JSON.write('durationSecs', r.dur_secs); END IF;
    APEX_JSON.write('submittedBy', NVL(r.created_by,''));
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
  COMMIT;
END;
/

SELECT object_name, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') last_ddl
  FROM all_objects WHERE owner='PROD' AND object_name='ATD_ACTION_PKG';

PROMPT otbi-atd 46 action telemetry : done
