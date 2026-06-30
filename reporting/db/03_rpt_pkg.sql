-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 03 DCT_RPT_PKG (control-plane logic)
-- File   : reporting/db/03_rpt_pkg.sql
-- Run as : sql -name prod_mcp
-- Purpose: the shared engine-agnostic operations both the Python worker and the
--          (Phase 3) native package call: enqueue a run, claim the next queued
--          PYTHON run (SKIP LOCKED), record outputs/deliveries, resolve a
--          report's recipients to concrete addresses, read UI config, reclaim
--          stuck runs. Status/enum writes validate via DCT_LOOKUP_PKG.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. Pipelined recipient row/table types (guarded -- types have dependents) ===
BEGIN
  EXECUTE IMMEDIATE q'[CREATE TYPE prod.rpt_recipient_row AS OBJECT (recipient VARCHAR2(320), channel VARCHAR2(20))]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/
BEGIN
  EXECUTE IMMEDIATE q'[CREATE TYPE prod.rpt_recipient_tab AS TABLE OF prod.rpt_recipient_row]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 2. DCT_RPT_PKG spec ===
CREATE OR REPLACE PACKAGE prod.dct_rpt_pkg AS

  -- read a UI-managed config value (DCT_RPT_CONFIG), with fallback.
  FUNCTION cfg (p_key VARCHAR2, p_default VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

  -- create a QUEUED run for p_report_code; returns the new run_id.
  -- raises -20404 if the report is unknown / disabled.
  FUNCTION enqueue (p_report_code  VARCHAR2,
                    p_params       CLOB     DEFAULT NULL,
                    p_trigger      VARCHAR2 DEFAULT 'ONDEMAND',
                    p_requested_by VARCHAR2 DEFAULT NULL,
                    p_formats      VARCHAR2 DEFAULT NULL) RETURN NUMBER;

  -- claim the oldest QUEUED PYTHON run (FOR UPDATE SKIP LOCKED); marks it RUNNING.
  -- o_run_id is NULL when the queue is empty.
  PROCEDURE claim_next (p_worker_id   IN  VARCHAR2,
                        o_run_id      OUT NUMBER,
                        o_report_code OUT VARCHAR2,
                        o_engine      OUT VARCHAR2,
                        o_source_type OUT VARCHAR2,
                        o_source_ref  OUT CLOB,
                        o_params      OUT CLOB,
                        o_formats     OUT VARCHAR2,
                        o_requested_by OUT VARCHAR2);

  -- update a run's terminal/interim status (+ row count / error).
  PROCEDURE mark_status (p_run_id    NUMBER,
                         p_status    VARCHAR2,
                         p_row_count NUMBER   DEFAULT NULL,
                         p_error     VARCHAR2 DEFAULT NULL);

  -- store a generated artifact BLOB for a run; returns output_id.
  FUNCTION record_output (p_run_id    NUMBER,
                          p_format    VARCHAR2,
                          p_file_name VARCHAR2,
                          p_mime      VARCHAR2,
                          p_blob      BLOB,
                          p_sha256    VARCHAR2 DEFAULT NULL) RETURN NUMBER;

  -- record a per-recipient delivery outcome.
  PROCEDURE record_delivery (p_run_id    NUMBER,
                             p_recipient VARCHAR2,
                             p_channel   VARCHAR2,
                             p_status    VARCHAR2,
                             p_error     VARCHAR2 DEFAULT NULL);

  -- expand a report's recipient rules into concrete (address, channel) pairs.
  FUNCTION resolve_recipients (p_report_code  VARCHAR2,
                               p_requested_by VARCHAR2 DEFAULT NULL)
    RETURN prod.rpt_recipient_tab PIPELINED;

  -- requeue RUNNING runs that have exceeded the lease (crashed worker recovery).
  PROCEDURE reclaim_stuck;

END dct_rpt_pkg;
/
SHOW ERRORS PACKAGE prod.dct_rpt_pkg

PROMPT === 3. DCT_RPT_PKG body ===
CREATE OR REPLACE PACKAGE BODY prod.dct_rpt_pkg AS

  FUNCTION cfg (p_key VARCHAR2, p_default VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
    l_val prod.dct_rpt_config.config_value%TYPE;
  BEGIN
    SELECT config_value INTO l_val FROM prod.dct_rpt_config WHERE config_key = p_key;
    RETURN NVL(l_val, p_default);
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN p_default;
  END cfg;

  FUNCTION enqueue (p_report_code  VARCHAR2,
                    p_params       CLOB     DEFAULT NULL,
                    p_trigger      VARCHAR2 DEFAULT 'ONDEMAND',
                    p_requested_by VARCHAR2 DEFAULT NULL,
                    p_formats      VARCHAR2 DEFAULT NULL) RETURN NUMBER IS
    l_engine  prod.dct_rpt_definition.engine%TYPE;
    l_formats prod.dct_rpt_definition.default_formats%TYPE;
    l_params  prod.dct_rpt_definition.params_json%TYPE;
    l_run_id  NUMBER;
  BEGIN
    BEGIN
      SELECT engine, default_formats, params_json
        INTO l_engine, l_formats, l_params
        FROM prod.dct_rpt_definition
       WHERE report_code = p_report_code AND enabled = 'Y';
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Report "'||p_report_code||'" not found or disabled');
    END;
    prod.dct_lookup_pkg.validate_lookup('RPT_TRIGGER', p_trigger);
    INSERT INTO prod.dct_rpt_run
      (report_code, trigger_source, engine, status, params_json, formats, requested_by)
    VALUES
      (p_report_code, p_trigger, l_engine, 'QUEUED',
       NVL(p_params, l_params), NVL(p_formats, l_formats), p_requested_by)
    RETURNING run_id INTO l_run_id;
    RETURN l_run_id;
  END enqueue;

  PROCEDURE claim_next (p_worker_id   IN  VARCHAR2,
                        o_run_id      OUT NUMBER,
                        o_report_code OUT VARCHAR2,
                        o_engine      OUT VARCHAR2,
                        o_source_type OUT VARCHAR2,
                        o_source_ref  OUT CLOB,
                        o_params      OUT CLOB,
                        o_formats     OUT VARCHAR2,
                        o_requested_by OUT VARCHAR2) IS
    CURSOR c_next IS
      SELECT run_id FROM prod.dct_rpt_run
       WHERE status = 'QUEUED' AND engine = 'PYTHON'
       ORDER BY run_id
       FOR UPDATE SKIP LOCKED;
    l_run NUMBER;
  BEGIN
    o_run_id := NULL;
    OPEN c_next;
    FETCH c_next INTO l_run;
    IF c_next%NOTFOUND THEN
      CLOSE c_next;
      RETURN;
    END IF;
    UPDATE prod.dct_rpt_run
       SET status = 'RUNNING', worker_id = p_worker_id,
           started_at = SYSTIMESTAMP, attempts = attempts + 1
     WHERE run_id = l_run;
    CLOSE c_next;

    SELECT r.run_id, r.report_code, r.engine, r.params_json, r.formats, r.requested_by,
           d.source_type, d.source_ref
      INTO o_run_id, o_report_code, o_engine, o_params, o_formats, o_requested_by,
           o_source_type, o_source_ref
      FROM prod.dct_rpt_run r
      JOIN prod.dct_rpt_definition d ON d.report_code = r.report_code
     WHERE r.run_id = l_run;
    COMMIT;
  END claim_next;

  PROCEDURE mark_status (p_run_id    NUMBER,
                         p_status    VARCHAR2,
                         p_row_count NUMBER   DEFAULT NULL,
                         p_error     VARCHAR2 DEFAULT NULL) IS
  BEGIN
    prod.dct_lookup_pkg.validate_lookup('RPT_RUN_STATUS', p_status);
    UPDATE prod.dct_rpt_run
       SET status     = p_status,
           row_count  = NVL(p_row_count, row_count),
           error_msg  = p_error,
           finished_at = CASE WHEN p_status IN ('SUCCESS','FAILED') THEN SYSTIMESTAMP ELSE finished_at END
     WHERE run_id = p_run_id;
    COMMIT;
  END mark_status;

  FUNCTION record_output (p_run_id    NUMBER,
                          p_format    VARCHAR2,
                          p_file_name VARCHAR2,
                          p_mime      VARCHAR2,
                          p_blob      BLOB,
                          p_sha256    VARCHAR2 DEFAULT NULL) RETURN NUMBER IS
    l_id NUMBER;
  BEGIN
    prod.dct_lookup_pkg.validate_lookup('RPT_FORMAT', p_format);
    INSERT INTO prod.dct_rpt_output (run_id, format, file_name, mime_type, file_bytes, sha256, file_blob)
    VALUES (p_run_id, p_format, p_file_name, p_mime,
            CASE WHEN p_blob IS NULL THEN 0 ELSE DBMS_LOB.GETLENGTH(p_blob) END, p_sha256, p_blob)
    RETURNING output_id INTO l_id;
    COMMIT;
    RETURN l_id;
  END record_output;

  PROCEDURE record_delivery (p_run_id    NUMBER,
                             p_recipient VARCHAR2,
                             p_channel   VARCHAR2,
                             p_status    VARCHAR2,
                             p_error     VARCHAR2 DEFAULT NULL) IS
  BEGIN
    prod.dct_lookup_pkg.validate_lookup('RPT_DELIVERY_STATUS', p_status);
    INSERT INTO prod.dct_rpt_delivery (run_id, recipient, channel, status, sent_at, error_msg)
    VALUES (p_run_id, p_recipient, p_channel, p_status,
            CASE WHEN p_status = 'SENT' THEN SYSTIMESTAMP END, p_error);
    COMMIT;
  END record_delivery;

  FUNCTION resolve_recipients (p_report_code  VARCHAR2,
                               p_requested_by VARCHAR2 DEFAULT NULL)
    RETURN prod.rpt_recipient_tab PIPELINED IS
  BEGIN
    FOR rc IN (SELECT recipient_type, recipient_ref, channel
                 FROM prod.dct_rpt_recipient
                WHERE report_code = p_report_code AND enabled = 'Y') LOOP
      IF rc.recipient_type = 'EMAIL' THEN
        IF rc.recipient_ref IS NOT NULL THEN
          PIPE ROW (prod.rpt_recipient_row(rc.recipient_ref, rc.channel));
        END IF;

      ELSIF rc.recipient_type = 'SELF' THEN
        FOR u IN (SELECT email FROM prod.dct_users
                   WHERE UPPER(username) = UPPER(p_requested_by) AND is_active = 'Y') LOOP
          PIPE ROW (prod.rpt_recipient_row(u.email, rc.channel));
        END LOOP;

      ELSIF rc.recipient_type = 'USER' THEN
        FOR u IN (SELECT email FROM prod.dct_users
                   WHERE user_id = TO_NUMBER(rc.recipient_ref DEFAULT NULL ON CONVERSION ERROR)
                     AND is_active = 'Y') LOOP
          PIPE ROW (prod.rpt_recipient_row(u.email, rc.channel));
        END LOOP;

      ELSIF rc.recipient_type = 'ORG' THEN
        FOR u IN (SELECT email FROM prod.dct_users
                   WHERE org_id = TO_NUMBER(rc.recipient_ref DEFAULT NULL ON CONVERSION ERROR)
                     AND is_active = 'Y') LOOP
          PIPE ROW (prod.rpt_recipient_row(u.email, rc.channel));
        END LOOP;

      ELSIF rc.recipient_type = 'ROLE' THEN
        FOR u IN (SELECT DISTINCT us.email
                    FROM prod.dct_user_roles ur
                    JOIN prod.dct_roles r  ON r.role_id = ur.role_id
                    JOIN prod.dct_users us ON us.user_id = ur.user_id
                   WHERE r.role_code = rc.recipient_ref
                     AND ur.is_active = 'Y'
                     AND (ur.end_date IS NULL OR ur.end_date >= SYSDATE)
                     AND us.is_active = 'Y') LOOP
          PIPE ROW (prod.rpt_recipient_row(u.email, rc.channel));
        END LOOP;
      END IF;
    END LOOP;
    RETURN;
  END resolve_recipients;

  PROCEDURE reclaim_stuck IS
    l_lease NUMBER := TO_NUMBER(NVL(cfg('LEASE_MINUTES','20'),'20'));
    l_max   NUMBER := TO_NUMBER(NVL(cfg('MAX_ATTEMPTS','3'),'3'));
  BEGIN
    -- runs RUNNING past the lease: requeue if attempts remain, else fail.
    UPDATE prod.dct_rpt_run
       SET status     = CASE WHEN attempts >= l_max THEN 'FAILED' ELSE 'QUEUED' END,
           worker_id  = NULL,
           error_msg  = CASE WHEN attempts >= l_max
                             THEN TO_CLOB('Lease expired after '||attempts||' attempt(s)') ELSE error_msg END,
           finished_at = CASE WHEN attempts >= l_max THEN SYSTIMESTAMP ELSE finished_at END
     WHERE status = 'RUNNING'
       AND started_at < SYSTIMESTAMP - NUMTODSINTERVAL(l_lease, 'MINUTE');
    COMMIT;
  END reclaim_stuck;

END dct_rpt_pkg;
/
SHOW ERRORS PACKAGE BODY prod.dct_rpt_pkg

PROMPT === 4. ADMIN synonyms ===
CREATE OR REPLACE SYNONYM rpt_recipient_row FOR prod.rpt_recipient_row;
CREATE OR REPLACE SYNONYM rpt_recipient_tab FOR prod.rpt_recipient_tab;
CREATE OR REPLACE SYNONYM dct_rpt_pkg       FOR prod.dct_rpt_pkg;

PROMPT 03_rpt_pkg.sql complete.
