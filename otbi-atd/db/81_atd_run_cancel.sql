-- =============================================================================
-- ATD (App 208) -- cancel a stuck run from the Run Logs page (ADDITIVE)
-- File    : 81_atd_run_cancel.sql
-- Adds to : atd.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @81_atd_run_cancel.sql   (fresh session)
-- IMPORTANT: 13_atd_ords.sql rebuilds atd.rest from scratch -- re-run THIS
--            script after any 13 re-run (post-13 list: 20, 38, 41, 42, 44, 45,
--            63, 78, 81).
--
-- Why : a worker that dies mid-run (VM reboot, systemctl restart during a
--       handler upgrade, kernel panic) leaves ATD_LOAD_RUN_LOG.status =
--       'RUNNING' for ever, and any ATD_ACTION_REQUEST row it had claimed stays
--       CLAIMED. Both then read as "still running" on every page. Until now the
--       only fix was an UPDATE by hand.
--
-- WHAT THIS DOES AND DOES NOT DO:
--   It closes the CONTROL-PLANE rows. It cannot kill a worker process -- there
--   is no command channel to the ATD fleet (the reporting workers have one,
--   these do not). If the process is somehow still alive it will finish and
--   write its own terminal status over this one, which is the correct outcome.
--   The button is therefore for runs whose worker is GONE.
--
-- Endpoint:
--   POST /atd/runs/:id/cancel   -> {ok, runId, actionsCancelled}
--                                  409 when the run already finished
-- [COLON] -> ':' at define time (SQLcl bind-scan guard).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_atd_run_cancel_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'atd.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
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

    def_template('runs/[COLON]id/cancel');
    def_handler('runs/[COLON]id/cancel', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_id     NUMBER;
  l_status VARCHAR2(40);
  l_job    VARCHAR2(200);
  l_acts   NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;

  BEGIN
    l_id := TO_NUMBER(REGEXP_SUBSTR([COLON]id,'^\d+$'));
  EXCEPTION WHEN OTHERS THEN l_id := NULL; END;
  IF l_id IS NULL THEN dct_rest.err(400,'run id must be numeric'); RETURN; END IF;

  -- decide the outcome BEFORE json_header: once the header is written the
  -- status line cannot be changed
  BEGIN
    SELECT status, job_name INTO l_status, l_job
      FROM prod.atd_load_run_log WHERE run_id = l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(404,'Run not found'); RETURN;
  END;
  IF l_status <> 'RUNNING' THEN
    dct_rest.err(409,'Run already finished ('||l_status||')'); RETURN;
  END IF;

  UPDATE prod.atd_load_run_log
     SET status   = 'CANCELLED',
         finished = SYSTIMESTAMP,
         message  = SUBSTR('Cancelled by '||l_user||' from Run Logs'
                           ||CASE WHEN message IS NULL THEN NULL ELSE ' | '||message END, 1, 3900)
   WHERE run_id = l_id AND status = 'RUNNING';

  -- the action that spawned this run (if any) would otherwise stay CLAIMED and
  -- keep its idempotency key locked, blocking the next run of the same bucket
  UPDATE prod.atd_action_request
     SET run_status  = 'CANCELLED',
         finished_at = SYSTIMESTAMP,
         last_error  = SUBSTR('Cancelled with run '||l_id||' by '||l_user, 1, 3900)
   WHERE last_run_id = l_id AND run_status IN ('READY','CLAIMED');
  l_acts := SQL%ROWCOUNT;

  COMMIT;

  dct_rest.json_header;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('runId', l_id);
  APEX_JSON.write('jobName', NVL(l_job,''));
  APEX_JSON.write('actionsCancelled', l_acts);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(500, SQLERRM);
END;
!');

END setup_atd_run_cancel_tmp;
/

BEGIN
  setup_atd_run_cancel_tmp;
  COMMIT;
END;
/
DROP PROCEDURE setup_atd_run_cancel_tmp;

PROMPT ATD 81 run cancel : done
