-- ===========================================================================
-- otbi-atd : 79 Project Budget Transactions - the SCHEDULED sync
--
--   PROD.PA_PBT_SYNC_PKG.enqueue_sync  -> puts ONE PA_BUDGET_TRX action on the
--   queue; the fleet's idle drain runs it. Nothing about the extract itself
--   lives here - the job only decides WHEN and in WHICH MODE.
--
--   TWO SPEEDS, because the master call is cheap and the child calls are not:
--     SYNC_SHALLOW  hourly  - re-reads details only where a transaction's
--                             row_hash changed (~30s when nothing moved)
--     SYNC_DEEP     nightly - re-reads every detail line and approval trail
--                             (~8 min for all three types)
--   The deep pass is NOT redundant: the source header carries no
--   last_updated_date, so a LINE edited without touching its header is
--   invisible to the hash diff. That blind spot is the whole reason it exists.
--
--   THROTTLING IS FREE: idem_key is bucketed to the hour/day, and
--   atd_action_request has a UNIQUE constraint on it - so a tick that fires
--   while the fleet is still busy cannot pile up a second copy.
--
--   SWITCHED OFF ON PURPOSE: PBT_SYNC_ENABLED ships 'N' (db/77). Turn it on
--   only after a manual full run reconciles against the source's own counts.
--
-- Rerunnable. Schema-qualified PROD. CRLF / UTF-8 no BOM. No MERGE.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON
SET SERVEROUTPUT ON

CREATE OR REPLACE PACKAGE prod.pa_pbt_sync_pkg AS
  -- p_mode: SYNC_SHALLOW | SYNC_DEEP. Returns the action_id, or NULL when the
  -- run was skipped (disabled, or an identical bucket is already queued).
  FUNCTION enqueue_sync(p_mode VARCHAR2) RETURN NUMBER;

  -- Called by PA_PBT_SYNC_JOB every hour: picks DEEP at the configured hour
  -- (PBT_DEEP_HOUR, Asia/Dubai) and SHALLOW otherwise.
  PROCEDURE run_scheduled;
END pa_pbt_sync_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.pa_pbt_sync_pkg AS

  FUNCTION cfg(p_key VARCHAR2, p_default VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
    v VARCHAR2(2000);
  BEGIN
    SELECT config_value INTO v FROM prod.atd_runner_config WHERE config_key = p_key;
    RETURN NVL(v, p_default);
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN p_default;
  END;

  -- CSV -> JSON array text, so the payload carries real arrays
  FUNCTION csv_to_json(p_csv VARCHAR2) RETURN VARCHAR2 IS
    v VARCHAR2(4000);
  BEGIN
    IF p_csv IS NULL THEN RETURN NULL; END IF;
    SELECT LISTAGG('"' || REPLACE(TRIM(COLUMN_VALUE), '"', '\"') || '"', ',')
             WITHIN GROUP (ORDER BY ROWNUM)
      INTO v
      FROM TABLE(apex_string.split(p_csv, ','));
    RETURN '[' || v || ']';
  END;

  FUNCTION enqueue_sync(p_mode VARCHAR2) RETURN NUMBER IS
    v_mode    VARCHAR2(20) := UPPER(p_mode);
    v_payload CLOB;
    v_key     VARCHAR2(200);
    v_id      NUMBER;
    v_local   TIMESTAMP;
  BEGIN
    IF v_mode NOT IN ('SYNC_SHALLOW','SYNC_DEEP') THEN
      RAISE_APPLICATION_ERROR(-20001, 'mode must be SYNC_SHALLOW or SYNC_DEEP');
    END IF;
    IF NVL(cfg('PBT_SYNC_ENABLED','N'),'N') != 'Y' THEN
      RETURN NULL;                      -- switched off: a silent, cheap no-op
    END IF;

    v_local := CAST(prod.dct_to_local(SYSTIMESTAMP) AS TIMESTAMP);

    -- bucketed key = the throttle. SHALLOW buckets per hour, DEEP per day.
    v_key := 'PBT[SYNC]' || v_mode || ':' ||
             TO_CHAR(v_local, CASE WHEN v_mode = 'SYNC_DEEP'
                                   THEN 'YYYYMMDD' ELSE 'YYYYMMDDHH24' END);
    v_key := REPLACE(v_key, '[SYNC]', ':SYNC:');

    v_payload := '{"mode":"' || v_mode || '"' ||
                 ',"transactionTypes":' ||
                     NVL(csv_to_json(cfg('PBT_SYNC_TYPES')), 'null') ||
                 ',"businessUnits":' ||
                     NVL(csv_to_json(cfg('PBT_SYNC_BUS')), 'null') ||
                 ',"includeApprovals":' ||
                     CASE WHEN NVL(cfg('PBT_SYNC_APPROVALS','Y'),'Y') = 'Y'
                          THEN 'true' ELSE 'false' END ||
                 ',"purgeMissing":false}';

    BEGIN
      v_id := prod.atd_action_pkg.enqueue_action(
                p_action_type   => 'PA_BUDGET_TRX',
                p_source_module => 'ATD',
                p_source_type   => 'SCHEDULE',
                p_source_id     => NULL,
                p_source_ref    => v_mode || ' (scheduled)',
                p_idem_key      => v_key,
                p_payload       => v_payload,
                p_env_name      => NULL,
                p_created_by    => 'PA_PBT_SYNC_JOB');
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
      -- this bucket is already queued or running: skip, never stack up
      RETURN NULL;
    END;
    RETURN v_id;
  END enqueue_sync;

  PROCEDURE run_scheduled IS
    v_hour NUMBER;
    v_deep NUMBER := TO_NUMBER(NVL(REGEXP_SUBSTR(cfg('PBT_DEEP_HOUR','1'), '^\d+$'), '1'));
    v_id   NUMBER;
  BEGIN
    -- LOCAL hour: the DB is UTC and the fleet's quiet window is Dubai time
    v_hour := TO_NUMBER(TO_CHAR(prod.dct_to_local(SYSTIMESTAMP), 'HH24'));
    v_id := enqueue_sync(CASE WHEN v_hour = v_deep THEN 'SYNC_DEEP'
                              ELSE 'SYNC_SHALLOW' END);
    IF v_id IS NOT NULL THEN
      DBMS_OUTPUT.put_line('PBT sync enqueued as action ' || v_id);
    END IF;
  END run_scheduled;

END pa_pbt_sync_pkg;
/

SHOW ERRORS

-- ---------------------------------------------------------------------------
-- The hourly job. It ALWAYS runs; enqueue_sync is the thing that respects
-- PBT_SYNC_ENABLED - so switching the feature on/off is a settings change,
-- never a scheduler change.
-- ---------------------------------------------------------------------------
BEGIN
  BEGIN
    DBMS_SCHEDULER.drop_job('PROD.PA_PBT_SYNC_JOB', force => TRUE);
  EXCEPTION WHEN OTHERS THEN NULL;
  END;

  DBMS_SCHEDULER.create_job(
    job_name        => 'PROD.PA_PBT_SYNC_JOB',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN prod.pa_pbt_sync_pkg.run_scheduled; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=HOURLY;INTERVAL=1;BYMINUTE=35;BYSECOND=0',
    enabled         => TRUE,
    comments        => 'Project Budget Transactions sync: SHALLOW hourly, DEEP at PBT_DEEP_HOUR (local). Gated by PBT_SYNC_ENABLED.');
END;
/

-- ---------------------------------------------------------------------------
-- Verify
-- ---------------------------------------------------------------------------
SELECT object_name, object_type, status FROM all_objects
 WHERE owner = 'PROD' AND object_name = 'PA_PBT_SYNC_PKG';

SELECT job_name, enabled, repeat_interval,
       TO_CHAR(next_run_date, 'YYYY-MM-DD HH24:MI') next_run
  FROM all_scheduler_jobs
 WHERE owner = 'PROD' AND job_name = 'PA_PBT_SYNC_JOB';

SELECT config_key, config_value FROM prod.atd_runner_config
 WHERE config_key LIKE 'PBT\_%' ESCAPE '\' ORDER BY display_order;
