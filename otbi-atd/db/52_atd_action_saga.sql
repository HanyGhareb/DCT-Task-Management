-- ===========================================================================
-- otbi-atd : 52 action saga checkpoints (multi-stage Fusion write-back)
-- File    : 52_atd_action_saga.sql   (rerunnable)
-- Run     : FRESH session. Contains PL/SQL + DDL -- prefer python-oracledb on
--           a worker VM over Linux SQLcl (which silently swallows mixed blocks).
-- ===========================================================================
-- WHY
-- ATD_ACTION_REQUEST models ONE write per action: a single idem_key, a single
-- fusion_invoice_id read back at the end. That is enough for AP_INVOICE and
-- PPM_TASK_ADDL_INFO, which are single, naturally idempotent writes.
--
-- AR_INVOICE_REBILL is not. It is a NINE-stage saga that CREATES two objects
-- and COMPLETES them (credit memo, then a duplicated invoice), and a completed
-- credit memo cannot be un-completed in Fusion -- only reversed. A retry after
-- a mid-saga crash must therefore RESUME, never restart, or it raises a second
-- credit memo against a live customer invoice.
--
-- ATD_ACTION_STEP is that checkpoint: one row per (action, stage), updated in
-- place across attempts. It doubles as the per-request AUDIT TRAIL the AR page
-- shows -- the credit-memo document number lands on the CM_CAPTURE row and the
-- new invoice document number on the DUP_CAPTURE row.
--
-- DELIBERATELY a SEPARATE package: ATD_ACTION_PKG's body is duplicated in
-- 19_atd_action_queue.sql and 46_atd_action_telemetry.sql with a "keep all
-- three equal" warning. Nothing here touches it, so that trap does not widen.
-- No MERGE anywhere (update-then-insert instead) so the script stays safe to
-- run through any client.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO ON

-- ---------------------------------------------------------------------------
-- Table : ATD_ACTION_STEP
-- ---------------------------------------------------------------------------
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM all_tables
   WHERE owner = 'PROD' AND table_name = 'ATD_ACTION_STEP';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.atd_action_step (
        step_id      NUMBER GENERATED ALWAYS AS IDENTITY,
        action_id    NUMBER        NOT NULL,
        stage_no     NUMBER        NOT NULL,
        stage_code   VARCHAR2(30)  NOT NULL,
        status       VARCHAR2(12)  DEFAULT 'RUNNING' NOT NULL,
        fusion_ref   VARCHAR2(200),
        note         VARCHAR2(400),
        attempt_no   NUMBER,
        worker_host  VARCHAR2(120),
        started_at   TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
        finished_at  TIMESTAMP,
        last_error   VARCHAR2(4000),
        CONSTRAINT pk_atd_action_step PRIMARY KEY (step_id),
        CONSTRAINT uq_atd_action_step UNIQUE (action_id, stage_code),
        CONSTRAINT fk_atd_step_action FOREIGN KEY (action_id)
          REFERENCES prod.atd_action_request (action_id) ON DELETE CASCADE,
        CONSTRAINT ck_atd_step_status CHECK (status IN ('RUNNING','DONE','SKIPPED','FAILED'))
      )]';
    DBMS_OUTPUT.put_line('created ATD_ACTION_STEP');
  ELSE
    DBMS_OUTPUT.put_line('ATD_ACTION_STEP already present');
  END IF;
END;
/

DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM all_indexes
   WHERE owner = 'PROD' AND index_name = 'IX_ATD_STEP_ACTION';
  IF n = 0 THEN
    EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_atd_step_action ON prod.atd_action_step (action_id, stage_no)';
    DBMS_OUTPUT.put_line('created IX_ATD_STEP_ACTION');
  END IF;
END;
/

-- ---------------------------------------------------------------------------
-- Package : ATD_ACTION_SAGA_PKG
-- ---------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE prod.atd_action_saga_pkg AS

  -- Open (or re-open, on a retry) a stage. Idempotent: an existing row for the
  -- same (action, stage) is reset to RUNNING and re-stamped.
  PROCEDURE begin_stage(
    p_action_id  NUMBER,
    p_stage_no   NUMBER,
    p_stage_code VARCHAR2,
    p_host       VARCHAR2 DEFAULT NULL,
    p_attempt    NUMBER   DEFAULT NULL
  );

  -- Close a stage. p_status DONE (did the work) or SKIPPED (idempotency probe
  -- said it was already there, or the stage does not apply to this request).
  -- p_ref is what the stage captured -- a document number, a transaction number.
  PROCEDURE end_stage(
    p_action_id  NUMBER,
    p_stage_code VARCHAR2,
    p_status     VARCHAR2 DEFAULT 'DONE',
    p_ref        VARCHAR2 DEFAULT NULL,
    p_note       VARCHAR2 DEFAULT NULL
  );

  -- Close a stage as FAILED, recording the error.
  PROCEDURE fail_stage(p_action_id NUMBER, p_stage_code VARCHAR2, p_err VARCHAR2);

  -- The stage_no to resume at: one past the highest CONTIGUOUS completed stage.
  -- 1 when nothing has completed. Contiguity matters -- a later stage must never
  -- be treated as done because an earlier one is missing.
  FUNCTION resume_from(p_action_id NUMBER) RETURN NUMBER;

  -- Read back what a stage captured (so a resumed run still knows the credit
  -- memo document number captured by the attempt that crashed).
  FUNCTION stage_ref(p_action_id NUMBER, p_stage_code VARCHAR2) RETURN VARCHAR2;

  -- Has this stage already completed (DONE or SKIPPED)?
  FUNCTION stage_done(p_action_id NUMBER, p_stage_code VARCHAR2) RETURN VARCHAR2;

  -- Operator escape hatch: clear the saga so the action re-runs from stage 1.
  -- Use ONLY when Fusion has been manually cleaned up -- otherwise the
  -- idempotency probes are what stop a duplicate, not this.
  PROCEDURE reset_stages(p_action_id NUMBER);

END atd_action_saga_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.atd_action_saga_pkg AS

  PROCEDURE begin_stage(
    p_action_id  NUMBER,
    p_stage_no   NUMBER,
    p_stage_code VARCHAR2,
    p_host       VARCHAR2 DEFAULT NULL,
    p_attempt    NUMBER   DEFAULT NULL
  ) IS
  BEGIN
    UPDATE prod.atd_action_step
       SET stage_no    = p_stage_no,
           status      = 'RUNNING',
           worker_host = NVL(p_host, worker_host),
           attempt_no  = NVL(p_attempt, attempt_no),
           started_at  = SYSTIMESTAMP,
           finished_at = NULL,
           last_error  = NULL
     WHERE action_id = p_action_id
       AND stage_code = p_stage_code;

    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO prod.atd_action_step
             (action_id, stage_no, stage_code, status, worker_host, attempt_no)
      VALUES (p_action_id, p_stage_no, p_stage_code, 'RUNNING', p_host, p_attempt);
    END IF;
    COMMIT;
  END begin_stage;

  PROCEDURE end_stage(
    p_action_id  NUMBER,
    p_stage_code VARCHAR2,
    p_status     VARCHAR2 DEFAULT 'DONE',
    p_ref        VARCHAR2 DEFAULT NULL,
    p_note       VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    UPDATE prod.atd_action_step
       SET status      = p_status,
           fusion_ref  = NVL(p_ref, fusion_ref),
           note        = NVL(SUBSTR(p_note, 1, 400), note),
           finished_at = SYSTIMESTAMP,
           last_error  = NULL
     WHERE action_id = p_action_id
       AND stage_code = p_stage_code;
    COMMIT;
  END end_stage;

  PROCEDURE fail_stage(p_action_id NUMBER, p_stage_code VARCHAR2, p_err VARCHAR2) IS
  BEGIN
    UPDATE prod.atd_action_step
       SET status      = 'FAILED',
           last_error  = SUBSTR(p_err, 1, 4000),
           finished_at = SYSTIMESTAMP
     WHERE action_id = p_action_id
       AND stage_code = p_stage_code;
    COMMIT;
  END fail_stage;

  FUNCTION resume_from(p_action_id NUMBER) RETURN NUMBER IS
    v_next NUMBER := 1;
  BEGIN
    -- walk completed stages in order; stop at the first gap
    FOR r IN (SELECT stage_no
                FROM prod.atd_action_step
               WHERE action_id = p_action_id
                 AND status IN ('DONE','SKIPPED')
               ORDER BY stage_no) LOOP
      IF r.stage_no = v_next THEN
        v_next := v_next + 1;
      ELSE
        EXIT;
      END IF;
    END LOOP;
    RETURN v_next;
  END resume_from;

  FUNCTION stage_ref(p_action_id NUMBER, p_stage_code VARCHAR2) RETURN VARCHAR2 IS
    v VARCHAR2(200);
  BEGIN
    SELECT fusion_ref INTO v
      FROM prod.atd_action_step
     WHERE action_id = p_action_id AND stage_code = p_stage_code;
    RETURN v;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
  END stage_ref;

  FUNCTION stage_done(p_action_id NUMBER, p_stage_code VARCHAR2) RETURN VARCHAR2 IS
    v VARCHAR2(12);
  BEGIN
    SELECT status INTO v
      FROM prod.atd_action_step
     WHERE action_id = p_action_id AND stage_code = p_stage_code;
    RETURN CASE WHEN v IN ('DONE','SKIPPED') THEN 'Y' ELSE 'N' END;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 'N';
  END stage_done;

  PROCEDURE reset_stages(p_action_id NUMBER) IS
  BEGIN
    DELETE FROM prod.atd_action_step WHERE action_id = p_action_id;
    COMMIT;
  END reset_stages;

END atd_action_saga_pkg;
/

-- ---------------------------------------------------------------------------
-- View : V_ATD_AR_REBILL_REQUEST
-- One row per rebill request, with the two captured document numbers pivoted
-- out of the step rows. The AR register endpoint reads this, so the handler
-- carries no pivot logic of its own.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW prod.v_atd_ar_rebill_request AS
SELECT a.action_id,
       a.idem_key,
       a.source_ref                          AS invoice_number,
       a.env_name,
       a.run_status,
       a.attempts,
       a.max_attempts,
       a.priority,
       a.worker_host,
       a.created_by                          AS submitted_by,
       a.created_at                          AS submitted_at,
       a.started_at,
       a.finished_at,
       CASE WHEN a.started_at IS NOT NULL THEN
         ROUND((CAST(NVL(a.finished_at, CAST(SYSTIMESTAMP AS TIMESTAMP)) AS DATE)
                - CAST(a.started_at AS DATE)) * 86400)
       END                                   AS duration_secs,
       a.last_error,
       cmc.fusion_ref                        AS cm_document_number,
       cmr.fusion_ref                        AS cm_transaction_number,
       dup.fusion_ref                        AS new_invoice_number,
       (SELECT s.stage_code
          FROM prod.atd_action_step s
         WHERE s.action_id = a.action_id
           AND s.stage_no = (SELECT MAX(s2.stage_no)
                               FROM prod.atd_action_step s2
                              WHERE s2.action_id = a.action_id)) AS current_stage,
       (SELECT COUNT(*) FROM prod.atd_action_step s
         WHERE s.action_id = a.action_id
           AND s.status IN ('DONE','SKIPPED'))                   AS stages_done
  FROM prod.atd_action_request a
  LEFT JOIN prod.atd_action_step cmc
         ON cmc.action_id = a.action_id AND cmc.stage_code = 'CM_CAPTURE'
  LEFT JOIN prod.atd_action_step cmr
         ON cmr.action_id = a.action_id AND cmr.stage_code = 'CM_CREATE'
  LEFT JOIN prod.atd_action_step dup
         ON dup.action_id = a.action_id AND dup.stage_code = 'DUP_CAPTURE'
 WHERE a.action_type = 'AR_INVOICE_REBILL';

-- ---------------------------------------------------------------------------
-- ADMIN to PROD synonyms. Safe here: this script never ALTERs CURRENT_SCHEMA.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SYNONYM atd_action_step        FOR prod.atd_action_step;
CREATE OR REPLACE SYNONYM atd_action_saga_pkg    FOR prod.atd_action_saga_pkg;
CREATE OR REPLACE SYNONYM v_atd_ar_rebill_request FOR prod.v_atd_ar_rebill_request;

SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') last_ddl
  FROM all_objects
 WHERE owner = 'PROD'
   AND object_name IN ('ATD_ACTION_STEP','ATD_ACTION_SAGA_PKG','V_ATD_AR_REBILL_REQUEST')
 ORDER BY object_name, object_type;

SET ECHO OFF
PROMPT otbi-atd 52 action saga : done
