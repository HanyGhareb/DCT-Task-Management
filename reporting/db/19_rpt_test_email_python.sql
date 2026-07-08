-- =============================================================================
-- i-Finance Reporting -- route "Send Test Email" through the PYTHON worker
-- File    : 19_rpt_test_email_python.sql
-- Run     : sql -name prod_mcp "@19_rpt_test_email_python.sql"  (any session;
--           replaces ONE handler in rpt.rest, no module rebuild, no synonyms.)
--           **Re-run after any 04_rpt_ords.sql re-run** (replaces 11's handler;
--           canonical post-04 list is now 08b, 09a, 10, 12b, 19).
-- Why     : the in-DB APEX_MAIL channel hands mail to OCI Email Delivery but
--           messages never arrive (2026-07-07; no suppression, spam checked) --
--           the Python worker channel (smtplib from the VM, gmail app pwd) is
--           the one that is verified end-to-end. This script makes the BI
--           "Send Test Email" button exercise THAT channel: it seeds a tiny
--           EMAIL_TEST report (engine PYTHON, one-row SQL, XLSX) and re-points
--           POST config/test-email to upsert the recipient + enqueue a run.
--           A worker must be alive (BI Workers page) and EMAIL_ENABLED = Y.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT ==== 1. seed EMAIL_TEST definition + placeholder recipient ====
BEGIN
    UPDATE prod.dct_rpt_definition
       SET name_en         = 'Email Channel Test',
           name_ar         = NULL,
           description     = 'One-row test report used by the BI Settings Send Test Email button. Delivered by the Python worker channel.',
           category        = 'SYSTEM',
           source_type     = 'SQL',
           source_ref      = q'[SELECT 'OK' AS channel_status, 'PYTHON worker (smtplib)' AS sent_via, TO_CHAR(SYSTIMESTAMP,'YYYY-MM-DD HH24.MI.SS') AS generated_at_utc FROM dual]',
           engine          = 'PYTHON',
           default_formats = 'XLSX',
           enabled         = 'Y',
           updated_by      = 'SCRIPT19',
           updated_at      = SYSTIMESTAMP
     WHERE report_code = 'EMAIL_TEST';
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO prod.dct_rpt_definition
            (report_code, name_en, description, category, source_type, source_ref,
             engine, default_formats, enabled, created_by)
        VALUES
            ('EMAIL_TEST', 'Email Channel Test',
             'One-row test report used by the BI Settings Send Test Email button. Delivered by the Python worker channel.',
             'SYSTEM', 'SQL',
             q'[SELECT 'OK' AS channel_status, 'PYTHON worker (smtplib)' AS sent_via, TO_CHAR(SYSTIMESTAMP,'YYYY-MM-DD HH24.MI.SS') AS generated_at_utc FROM dual]',
             'PYTHON', 'XLSX', 'Y', 'SCRIPT19');
    END IF;

    UPDATE prod.dct_rpt_recipient
       SET enabled = 'Y', updated_by = 'SCRIPT19', updated_at = SYSTIMESTAMP
     WHERE report_code = 'EMAIL_TEST' AND recipient_type = 'EMAIL' AND channel = 'EMAIL';
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO prod.dct_rpt_recipient
            (report_code, recipient_type, recipient_ref, channel, enabled, created_by)
        VALUES
            ('EMAIL_TEST', 'EMAIL', 'hany.uipath@gmail.com', 'EMAIL', 'Y', 'SCRIPT19');
    END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('EMAIL_TEST definition + recipient ready.');
END;
/

PROMPT ==== 2. re-point POST config/test-email at the Python queue ====
BEGIN
    ORDS.DEFINE_HANDLER(
        p_module_name => 'rpt.rest',
        p_pattern     => 'config/test-email',
        p_method      => 'POST',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'[
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_to      VARCHAR2(320);
  l_enabled VARCHAR2(1);
  l_run     NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403,'SYS_ADMIN role required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_to := TRIM(APEX_JSON.get_varchar2(p_path => 'to'));
  IF l_to IS NULL
     OR NOT REGEXP_LIKE(l_to, '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$') THEN
    dct_rest.err(400,'A valid recipient email is required.'); RETURN;
  END IF;
  l_enabled := UPPER(NVL(prod.dct_rpt_pkg.cfg('EMAIL_ENABLED','N'),'N'));
  IF l_enabled <> 'Y' THEN
    dct_rest.err(400,'EMAIL_ENABLED is N - enable it in Settings first, then retry.'); RETURN;
  END IF;

  UPDATE prod.dct_rpt_recipient
     SET recipient_ref = l_to, enabled = 'Y',
         updated_by = l_user, updated_at = SYSTIMESTAMP
   WHERE report_code = 'EMAIL_TEST' AND recipient_type = 'EMAIL' AND channel = 'EMAIL';
  IF SQL%ROWCOUNT = 0 THEN
    INSERT INTO prod.dct_rpt_recipient
        (report_code, recipient_type, recipient_ref, channel, enabled, created_by)
    VALUES ('EMAIL_TEST', 'EMAIL', l_to, 'EMAIL', 'Y', l_user);
  END IF;

  l_run := prod.dct_rpt_pkg.enqueue(
             p_report_code  => 'EMAIL_TEST',
             p_trigger      => 'ONDEMAND',
             p_requested_by => l_user,
             p_formats      => 'XLSX');
  COMMIT;

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok',           TRUE);
  APEX_JSON.write('runId',        l_run);
  APEX_JSON.write('to',           l_to);
  APEX_JSON.write('engine',       'PYTHON');
  APEX_JSON.write('emailEnabled', l_enabled);
  APEX_JSON.write('note',         'Queued for the Python worker; track it on Run History.');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(500, 'Test email enqueue failed: ' || SQLERRM);
END;
]', '[COLON]', CHR(58)));
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Handler config/test-email now enqueues a PYTHON run.');
END;
/

PROMPT === 19_rpt_test_email_python.sql complete ===
PROMPT === Needs a live Python worker (BI Workers page) and EMAIL_ENABLED=Y ===
EXIT
