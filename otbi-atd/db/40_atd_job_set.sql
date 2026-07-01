-- ===========================================================================
-- otbi-atd : 40 Job Sets  (grouped scheduling for App 208)
--   A "Job Set" groups existing jobs under ONE shared schedule so the operator
--   can schedule / pause / run a batch together instead of editing every job.
--     * ATD_JOB_SET         -> the set: name, comment, active/paused, run interval
--       (frequency_minutes), calendar window (start_at/end_at, LOCAL Asia/Dubai
--       wall-clock), optional daily time mask (daily_start/daily_end HH:MI) and
--       day-of-week mask (dow_mask e.g. MON,TUE,WED), notify_on_failure.
--     * ATD_JOB_SET_MEMBER  -> job <-> set. PK (job_name) enforces ONE set per job;
--       enabled_in_set toggles a member without removing it.
--   How it drives the LIVE browser track: the 15-min enqueue (db/12) only marks a
--   member READY while its set says "go now" (gate) and re-runs it on the set's
--   interval (eff_freq). A job in NO set is unaffected -> fully backward-compatible.
--     * prod.atd_set_gate_ok(job)      -> 'Y'/'N' schedulable-now gate (SQL-callable)
--     * prod.atd_set_eff_freq(job,jf)  -> effective run interval minutes (SQL-callable)
--     * prod.atd_set_next_run(job)     -> ~ next run TIMESTAMP for the UI preview
--     * prod.atd_set_pkg.run_now(set)  -> Run Set Now (top-priority enqueue members)
--     * prod.atd_set_pkg.notify_sweep  -> DCT_NOTIFY on member failures (5-min job)
--
-- IMPORTANT: apply AFTER db/12 (the enqueue edit references atd_set_gate_ok /
-- atd_set_eff_freq). Rerunnable. Schema-qualified PROD. CRLF / UTF-8 no BOM.
-- Run in a FRESH SQLcl session (creates synonyms; never after ALTER SESSION SET
-- CURRENT_SCHEMA=PROD, or the synonyms self-reference -> ORA-01471).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO ON

-- ---------------------------------------------------------------------------
-- Tables (guarded CREATE -> never drops existing data on rerun)
-- ---------------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE q'[CREATE TABLE prod.atd_job_set (
    set_code          VARCHAR2(30)  NOT NULL,
    name_en           VARCHAR2(100) NOT NULL,
    name_ar           VARCHAR2(200),
    comments          VARCHAR2(4000),
    active            CHAR(1)  DEFAULT 'Y' NOT NULL,
    paused            CHAR(1)  DEFAULT 'N' NOT NULL,
    interval_preset   VARCHAR2(20),
    frequency_minutes NUMBER,
    start_at          TIMESTAMP,
    end_at            TIMESTAMP,
    daily_start       VARCHAR2(5),
    daily_end         VARCHAR2(5),
    dow_mask          VARCHAR2(40),
    notify_on_failure CHAR(1)  DEFAULT 'N' NOT NULL,
    created_at        TIMESTAMP DEFAULT SYSTIMESTAMP,
    created_by        VARCHAR2(100),
    updated_at        TIMESTAMP,
    updated_by        VARCHAR2(100),
    CONSTRAINT pk_atd_job_set        PRIMARY KEY (set_code),
    CONSTRAINT ck_atd_set_active     CHECK (active IN ('Y','N')),
    CONSTRAINT ck_atd_set_paused     CHECK (paused IN ('Y','N')),
    CONSTRAINT ck_atd_set_notify     CHECK (notify_on_failure IN ('Y','N')),
    CONSTRAINT ck_atd_set_freq       CHECK (frequency_minutes IS NULL OR frequency_minutes > 0)
  )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;  -- already exists
END;
/

BEGIN
  EXECUTE IMMEDIATE q'[CREATE TABLE prod.atd_job_set_member (
    job_name        VARCHAR2(80) NOT NULL,
    set_code        VARCHAR2(30) NOT NULL,
    enabled_in_set  CHAR(1) DEFAULT 'Y' NOT NULL,
    member_order    NUMBER  DEFAULT 100,
    added_at        TIMESTAMP DEFAULT SYSTIMESTAMP,
    added_by        VARCHAR2(100),
    CONSTRAINT pk_atd_set_member  PRIMARY KEY (job_name),
    CONSTRAINT fk_atd_sm_set  FOREIGN KEY (set_code)
      REFERENCES prod.atd_job_set (set_code) ON DELETE CASCADE,
    CONSTRAINT fk_atd_sm_job  FOREIGN KEY (job_name)
      REFERENCES prod.atd_otbi_jobs (job_name) ON DELETE CASCADE,
    CONSTRAINT ck_atd_sm_enab CHECK (enabled_in_set IN ('Y','N'))
  )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_atd_sm_set ON prod.atd_job_set_member (set_code)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- ---------------------------------------------------------------------------
-- SQL-callable gate + effective-frequency helpers (referenced by db/12 enqueue).
-- Query ONLY the set tables (never atd_otbi_jobs) so they are safe to call from
-- the enqueue UPDATE on atd_otbi_jobs (no ORA-04091 mutating-table). Fail-OPEN so
-- a helper error never halts the whole fleet's scheduling.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION prod.atd_set_gate_ok (p_job VARCHAR2) RETURN VARCHAR2 IS
  l_active  VARCHAR2(1); l_paused VARCHAR2(1); l_enab VARCHAR2(1);
  l_start   TIMESTAMP;   l_end    TIMESTAMP;
  l_dstart  VARCHAR2(5); l_dend   VARCHAR2(5); l_dow VARCHAR2(40);
  l_now     TIMESTAMP;   l_hm     VARCHAR2(5); l_dy  VARCHAR2(3);
BEGIN
  BEGIN
    SELECT s.active, s.paused, m.enabled_in_set, s.start_at, s.end_at,
           s.daily_start, s.daily_end, s.dow_mask
      INTO l_active, l_paused, l_enab, l_start, l_end, l_dstart, l_dend, l_dow
      FROM prod.atd_job_set_member m
      JOIN prod.atd_job_set s ON s.set_code = m.set_code
     WHERE m.job_name = p_job;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN 'Y';   -- job is in no set -> unchanged behaviour
  END;
  IF l_active <> 'Y' OR l_paused = 'Y' OR NVL(l_enab,'Y') <> 'Y' THEN RETURN 'N'; END IF;
  l_now := CAST(prod.dct_to_local(SYSTIMESTAMP) AS TIMESTAMP);  -- local Asia/Dubai wall clock
  IF l_start IS NOT NULL AND l_now < l_start THEN RETURN 'N'; END IF;
  IF l_end   IS NOT NULL AND l_now > l_end   THEN RETURN 'N'; END IF;
  IF l_dstart IS NOT NULL AND l_dend IS NOT NULL THEN
    l_hm := TO_CHAR(l_now, 'HH24:MI');                 -- zero-padded, compares lexically
    IF l_dstart <= l_dend THEN                          -- same-day time window
      IF NOT (l_hm >= l_dstart AND l_hm < l_dend) THEN RETURN 'N'; END IF;
    ELSE                                                -- wraps past midnight
      IF NOT (l_hm >= l_dstart OR l_hm < l_dend) THEN RETURN 'N'; END IF;
    END IF;
  END IF;
  IF l_dow IS NOT NULL THEN
    l_dy := UPPER(TO_CHAR(l_now, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH'));
    IF INSTR(','||UPPER(REPLACE(l_dow,' ',''))||',', ','||l_dy||',') = 0 THEN RETURN 'N'; END IF;
  END IF;
  RETURN 'Y';
EXCEPTION WHEN OTHERS THEN RETURN 'Y';   -- fail-open: never block scheduling on a gate error
END atd_set_gate_ok;
/
SHOW ERRORS FUNCTION prod.atd_set_gate_ok

CREATE OR REPLACE FUNCTION prod.atd_set_eff_freq (p_job VARCHAR2, p_job_freq NUMBER)
  RETURN NUMBER IS
  l_setfreq NUMBER;
BEGIN
  BEGIN
    SELECT s.frequency_minutes INTO l_setfreq
      FROM prod.atd_job_set_member m
      JOIN prod.atd_job_set s ON s.set_code = m.set_code
     WHERE m.job_name = p_job;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN p_job_freq;   -- not in a set -> keep the job's own frequency
  END;
  RETURN NVL(l_setfreq, p_job_freq);   -- set with no interval -> fall back to the job's own
EXCEPTION WHEN OTHERS THEN RETURN p_job_freq;
END atd_set_eff_freq;
/
SHOW ERRORS FUNCTION prod.atd_set_eff_freq

-- ~ next-run estimate for the UI preview. NULL when the set is currently paused /
-- inactive / out-of-window (UI shows a "paused" hint). Returns UTC; callers wrap
-- dct_to_local for display. May query atd_otbi_jobs (never called from the enqueue).
CREATE OR REPLACE FUNCTION prod.atd_set_next_run (p_job VARCHAR2) RETURN TIMESTAMP IS
  l_jf   NUMBER; l_freq NUMBER; l_last TIMESTAMP; l_next TIMESTAMP;
BEGIN
  IF prod.atd_set_gate_ok(p_job) = 'N' THEN RETURN NULL; END IF;
  BEGIN
    SELECT frequency_minutes INTO l_jf FROM prod.atd_otbi_jobs WHERE job_name = p_job;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL; END;
  l_freq := NVL(prod.atd_set_eff_freq(p_job, l_jf), 15);
  SELECT MAX(finished) INTO l_last
    FROM prod.atd_load_run_log WHERE job_name = p_job AND status = 'SUCCESS';
  l_next := NVL(l_last, CAST(SYSTIMESTAMP AS TIMESTAMP)) + NUMTODSINTERVAL(l_freq, 'MINUTE');
  IF l_next < CAST(SYSTIMESTAMP AS TIMESTAMP) THEN l_next := CAST(SYSTIMESTAMP AS TIMESTAMP); END IF;
  RETURN l_next;
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END atd_set_next_run;
/
SHOW ERRORS FUNCTION prod.atd_set_next_run

-- ---------------------------------------------------------------------------
-- Operations package: Run Set Now + failure-notify sweep
-- ---------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE prod.atd_set_pkg AS
  -- Run every ENABLED member of a set now: top-priority READY (bump to front),
  -- an explicit operator override that bypasses the window (like /jobs/:name/run).
  -- Returns the number of members queued.
  FUNCTION run_now (p_set VARCHAR2) RETURN NUMBER;
  -- Failure-notify sweep (target of ATD_SET_NOTIFY_JOB): DCT_NOTIFY the SYS_ADMINs
  -- for newly-FAILED runs of members of sets with notify_on_failure='Y'. Watermarked
  -- by ATD_SET_NOTIFY_WATERMARK; gated by ATD_SET_NOTIFY_ENABLED. Never raises.
  PROCEDURE notify_sweep;
END atd_set_pkg;
/
SHOW ERRORS PACKAGE prod.atd_set_pkg

CREATE OR REPLACE PACKAGE BODY prod.atd_set_pkg AS

  FUNCTION run_now (p_set VARCHAR2) RETURN NUMBER IS
    n NUMBER;
  BEGIN
    UPDATE prod.atd_otbi_jobs
       SET priority = 1, run_order = 0,
           run_status = 'READY', claimed_by = NULL, claimed_at = NULL,
           updated_at = SYSTIMESTAMP
     WHERE enabled = 'Y'
       AND job_name IN (SELECT job_name FROM prod.atd_job_set_member
                         WHERE set_code = p_set AND enabled_in_set = 'Y');
    n := SQL%ROWCOUNT;
    COMMIT;
    RETURN n;
  END run_now;

  PROCEDURE notify_sweep IS
    l_enabled VARCHAR2(20); l_wm NUMBER; l_max NUMBER; l_roleid NUMBER;
    FUNCTION cfg(p_key VARCHAR2, p_def VARCHAR2) RETURN VARCHAR2 IS
      r VARCHAR2(400);
    BEGIN
      SELECT config_value INTO r FROM prod.atd_runner_config WHERE config_key = p_key;
      RETURN NVL(r, p_def);
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN p_def;
    END;
  BEGIN
    l_enabled := cfg('ATD_SET_NOTIFY_ENABLED', 'N');
    IF UPPER(NVL(l_enabled,'N')) NOT IN ('Y','1','TRUE','ON') THEN RETURN; END IF;
    BEGIN l_wm := TO_NUMBER(cfg('ATD_SET_NOTIFY_WATERMARK', '0'));
    EXCEPTION WHEN OTHERS THEN l_wm := 0; END;
    SELECT NVL(MAX(run_id), l_wm) INTO l_max FROM prod.atd_load_run_log;
    BEGIN SELECT role_id INTO l_roleid FROM prod.dct_roles WHERE role_code = 'SYS_ADMIN';
    EXCEPTION WHEN OTHERS THEN l_roleid := NULL; END;

    FOR r IN (
      SELECT l.run_id, l.job_name, s.name_en,
             NVL(DBMS_LOB.SUBSTR(l.message, 300, 1), '') AS msg
        FROM prod.atd_load_run_log l
        JOIN prod.atd_job_set_member m ON m.job_name = l.job_name
        JOIN prod.atd_job_set        s ON s.set_code = m.set_code
       WHERE l.run_id > NVL(l_wm, 0)
         AND l.status = 'FAILED'
         AND s.notify_on_failure = 'Y'
       ORDER BY l.run_id
    ) LOOP
      IF l_roleid IS NOT NULL THEN
        FOR u IN (SELECT ur.user_id FROM prod.dct_user_roles ur
                   WHERE ur.role_id = l_roleid AND ur.is_active = 'Y'
                     AND (ur.end_date IS NULL OR ur.end_date >= SYSDATE)) LOOP
          BEGIN
            prod.dct_notify.send(
              p_recipient_user_id => u.user_id,
              p_notification_type => 'ATD_JOB_FAILED',
              p_title_en          => 'Job Set "'||r.name_en||'" - job failed',
              p_body_en           => 'Job '||r.job_name||' failed. '||r.msg,
              p_module_code       => 'ATD');
          EXCEPTION WHEN OTHERS THEN NULL;   -- one bad recipient never stops the sweep
          END;
        END LOOP;
      END IF;
    END LOOP;

    UPDATE prod.atd_runner_config SET config_value = TO_CHAR(l_max)
     WHERE config_key = 'ATD_SET_NOTIFY_WATERMARK';
    COMMIT;
  EXCEPTION WHEN OTHERS THEN
    ROLLBACK;   -- a scheduled sweep must never error loudly
  END notify_sweep;

END atd_set_pkg;
/
SHOW ERRORS PACKAGE BODY prod.atd_set_pkg

-- ---------------------------------------------------------------------------
-- Runner-config keys (MERGE = never overwrite operator edits; auto-surface on
-- the Runner Settings page ordered by display_order)
-- ---------------------------------------------------------------------------
MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_SET_NOTIFY_ENABLED' AS config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_SET_NOTIFY_ENABLED', 'N', 'ENUM', 'Y,N',
          'Job Sets: when Y, DCT_NOTIFY the SYS_ADMINs whenever a member of a set with "notify on failure" has a FAILED run.',
          240);

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_SET_NOTIFY_WATERMARK' AS config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_SET_NOTIFY_WATERMARK', '0', 'NUMBER', NULL,
          'Internal: last atd_load_run_log run_id processed by the Job-Set failure-notify sweep.',
          241);
COMMIT;

-- ---------------------------------------------------------------------------
-- 5-minute failure-notify sweep job
-- ---------------------------------------------------------------------------
BEGIN
  BEGIN DBMS_SCHEDULER.DROP_JOB('ATD_SET_NOTIFY_JOB', force => TRUE);
  EXCEPTION WHEN OTHERS THEN NULL; END;
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'ATD_SET_NOTIFY_JOB',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN prod.atd_set_pkg.notify_sweep; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY;INTERVAL=5',
    enabled         => TRUE,
    comments        => 'otbi-atd Job-Set failure-notify sweep');
END;
/

-- ---------------------------------------------------------------------------
-- ADMIN synonyms (ORDS handlers run as ADMIN)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SYNONYM atd_job_set        FOR prod.atd_job_set;
CREATE OR REPLACE SYNONYM atd_job_set_member FOR prod.atd_job_set_member;
CREATE OR REPLACE SYNONYM atd_set_pkg        FOR prod.atd_set_pkg;
CREATE OR REPLACE SYNONYM atd_set_gate_ok    FOR prod.atd_set_gate_ok;
CREATE OR REPLACE SYNONYM atd_set_eff_freq   FOR prod.atd_set_eff_freq;
CREATE OR REPLACE SYNONYM atd_set_next_run   FOR prod.atd_set_next_run;

SET ECHO OFF
PROMPT otbi-atd 40 job set : done   (apply db/12 enqueue edit; then db/41 ORDS in a fresh session)
