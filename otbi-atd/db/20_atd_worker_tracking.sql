-- ===========================================================================
-- otbi-atd : 20 worker tracking (per-VM visibility for the parallel fleet)
--   * host_id on ATD_LOAD_RUN_LOG  -> every run shows which VM ran it
--   * ATD_WORKER_HEARTBEAT          -> live per-worker health for the UI panel
-- Rerunnable (ADD guarded against ORA-01430, CREATE against ORA-00955).
-- Schema-qualified PROD. CRLF / UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

-- which VM produced each run-log row (NULL for legacy / single-host rows)
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_load_run_log ADD (host_id VARCHAR2(120))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

-- one row per worker (worker_id = VM hostname); upserted by the --forever loop
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.atd_worker_heartbeat (
      worker_id    VARCHAR2(120) PRIMARY KEY,
      last_seen    TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
      status       VARCHAR2(20),            -- IDLE | BUSY | DOWN
      current_job  VARCHAR2(256),
      started_at   TIMESTAMP DEFAULT SYSTIMESTAMP
    )
  ]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

SET ECHO OFF
PROMPT otbi-atd 20 worker tracking : done
