-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 06 NATIVE engine (Oracle-native)
-- File   : reporting/db/06_rpt_native_pkg.sql
-- Run as : sql -name prod_mcp
-- Purpose: the in-DB report engine (Solution 1) that plugs into the SAME control
--          plane as the Python engine. A definition with engine='NATIVE' is
--          enqueued exactly like a PYTHON one (DCT_RPT_PKG.enqueue / schedules /
--          /rpt ORDS); the DCT_RPT_NATIVE_JOB sweep claims QUEUED NATIVE runs
--          (SKIP LOCKED) and processes them entirely in the database:
--            APEX_DATA_EXPORT.EXPORT (PDF + XLSX, no print server)
--              -> DCT_RPT_OUTPUT (BLOB)   [archive]
--            APEX_MAIL.SEND + ADD_ATTACHMENT (when EMAIL_ENABLED='Y')
--              -> DCT_RPT_DELIVERY         [deliver]
--          Same run-log / outputs / downloads / retry / UI as the Python engine.
--
-- NATIVE source SQL must be SELF-CONTAINED (no :binds) -- binds are a Python-engine
-- convenience; resolve period etc. inline (e.g. via a sub-select). Email-body /
-- subject placeholders use {{ name }} tokens, substituted here.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. DCT_RPT_NATIVE_PKG spec ===
CREATE OR REPLACE PACKAGE prod.dct_rpt_native_pkg AS
  -- process ONE run (already created, any status) entirely in-DB. Marks SUCCESS/FAILED.
  PROCEDURE process_run (p_run_id NUMBER);
  -- claim + process all QUEUED NATIVE runs (SKIP LOCKED). Driven by DCT_RPT_NATIVE_JOB.
  PROCEDURE process_queued;
END dct_rpt_native_pkg;
/
SHOW ERRORS PACKAGE prod.dct_rpt_native_pkg

PROMPT === 2. DCT_RPT_NATIVE_PKG body ===
CREATE OR REPLACE PACKAGE BODY prod.dct_rpt_native_pkg AS

  -- APEX_MAIL / APEX_DATA_EXPORT / APEX_EXEC need a real APEX session context when
  -- run from a background job (no UI session); set_security_group_id alone yields
  -- ORA-20987. Create a headless session in App 200's workspace.
  PROCEDURE set_apex_context IS
  BEGIN
    apex_session.create_session(p_app_id => 200, p_page_id => 1, p_username => 'ADMIN');
  EXCEPTION WHEN OTHERS THEN NULL;
  END set_apex_context;

  FUNCTION subst (p_text CLOB, p_report VARCHAR2, p_rowcnt NUMBER, p_recipient VARCHAR2) RETURN CLOB IS
    l CLOB := p_text;
  BEGIN
    IF l IS NULL THEN RETURN NULL; END IF;
    l := REPLACE(l, '{{ report_name }}',   p_report);
    l := REPLACE(l, '{{ row_count }}',      TO_CHAR(p_rowcnt));
    l := REPLACE(l, '{{ generated_at }}',   TO_CHAR(prod.dct_to_local(SYSTIMESTAMP), 'YYYY-MM-DD HH:MI AM'));
    l := REPLACE(l, '{{ recipient_name }}', NVL(p_recipient, 'Colleague'));
    l := REPLACE(l, '{{ period }}',         '');   -- native SQL is bind-free; period not templated
    RETURN l;
  END subst;

  -- run one APEX_DATA_EXPORT pass for a format; returns the content blob.
  FUNCTION export_blob (p_sql CLOB, p_format VARCHAR2, p_file VARCHAR2,
                        o_mime OUT VARCHAR2, o_name OUT VARCHAR2) RETURN BLOB IS
    l_ctx    apex_exec.t_context;
    l_export apex_data_export.t_export;
    l_fmt    VARCHAR2(10);
    l_pc     apex_data_export.t_print_config;
  BEGIN
    l_fmt := CASE UPPER(p_format)
               WHEN 'PDF'  THEN apex_data_export.c_format_pdf
               WHEN 'XLSX' THEN apex_data_export.c_format_xlsx
               ELSE apex_data_export.c_format_csv END;
    -- same look & feel as the BI app + Python engine: #1F6F8B header fill, white bold text
    l_pc := apex_data_export.get_print_config(
              p_header_bg_color    => '#1F6F8B',
              p_header_font_color  => '#FFFFFF',
              p_header_font_weight => 'bold',
              p_border_color       => '#D9D9D9');
    l_ctx := apex_exec.open_query_context(
               p_location => apex_exec.c_location_local_db,
               p_sql_query => TO_CHAR(p_sql));
    l_export := apex_data_export.export(p_context => l_ctx, p_format => l_fmt,
                  p_file_name => p_file, p_print_config => l_pc);
    apex_exec.close(l_ctx);
    o_mime := l_export.mime_type;
    o_name := l_export.file_name;
    RETURN l_export.content_blob;
  EXCEPTION WHEN OTHERS THEN
    BEGIN apex_exec.close(l_ctx); EXCEPTION WHEN OTHERS THEN NULL; END;
    RAISE;
  END export_blob;

  PROCEDURE process_run (p_run_id NUMBER) IS
    l_code    prod.dct_rpt_definition.report_code%TYPE;
    l_name    prod.dct_rpt_definition.name_en%TYPE;
    l_sql     prod.dct_rpt_definition.source_ref%TYPE;
    l_stype   prod.dct_rpt_definition.source_type%TYPE;
    l_formats prod.dct_rpt_run.formats%TYPE;
    l_subj    prod.dct_rpt_definition.email_subject_tpl%TYPE;
    l_body    prod.dct_rpt_definition.email_body_tpl%TYPE;
    l_rowcnt  NUMBER := 0;
    l_stamp   VARCHAR2(20) := TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD_HH24MI');
    l_blob    BLOB; l_mime VARCHAR2(120); l_fname VARCHAR2(260); l_oid NUMBER;
    l_email_on BOOLEAN;
  BEGIN
    SELECT d.report_code, d.name_en, d.source_ref, d.source_type, r.formats,
           d.email_subject_tpl, d.email_body_tpl
      INTO l_code, l_name, l_sql, l_stype, l_formats, l_subj, l_body
      FROM prod.dct_rpt_run r JOIN prod.dct_rpt_definition d ON d.report_code = r.report_code
     WHERE r.run_id = p_run_id;

    set_apex_context;
    IF UPPER(NVL(l_stype, 'SQL')) = 'VIEW' THEN l_sql := 'SELECT * FROM ' || l_sql; END IF;

    -- row count (best-effort)
    BEGIN
      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM (' || l_sql || ')' INTO l_rowcnt;
    EXCEPTION WHEN OTHERS THEN l_rowcnt := NULL; END;

    -- generate each requested format
    DECLARE
      l_list VARCHAR2(40) := UPPER(NVL(l_formats, 'PDF,XLSX')) || ',';
      l_one  VARCHAR2(10); l_p NUMBER;
    BEGIN
      WHILE INSTR(l_list, ',') > 0 LOOP
        l_one := TRIM(SUBSTR(l_list, 1, INSTR(l_list, ',') - 1));
        l_list := SUBSTR(l_list, INSTR(l_list, ',') + 1);
        IF l_one IN ('PDF', 'XLSX', 'CSV') THEN
          l_fname := l_code || '_' || l_stamp || '.' || LOWER(l_one);
          l_blob := export_blob(l_sql, l_one, l_fname, l_mime, l_fname);
          l_oid := prod.dct_rpt_pkg.record_output(
                     p_run_id, l_one, l_fname,
                     NVL(l_mime, CASE l_one WHEN 'PDF' THEN 'application/pdf'
                          WHEN 'XLSX' THEN 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                          ELSE 'text/csv' END),
                     l_blob);
        END IF;
      END LOOP;
    END;

    -- deliver (best-effort; only when email is switched on)
    l_email_on := UPPER(NVL(prod.dct_rpt_pkg.cfg('EMAIL_ENABLED', 'N'), 'N')) = 'Y';
    IF l_email_on THEN
      DECLARE
        l_from VARCHAR2(320) := prod.dct_rpt_pkg.cfg('SMTP_FROM', 'no-reply@dct.gov.ae');
        l_reqby prod.dct_rpt_run.requested_by%TYPE;
        l_mailid NUMBER;
      BEGIN
        SELECT requested_by INTO l_reqby FROM prod.dct_rpt_run WHERE run_id = p_run_id;
        FOR rcpt IN (SELECT recipient, channel
                       FROM TABLE(prod.dct_rpt_pkg.resolve_recipients(l_code, l_reqby))
                      WHERE channel = 'EMAIL' AND recipient IS NOT NULL) LOOP
          BEGIN
            l_mailid := apex_mail.send(
              p_to   => rcpt.recipient,
              p_from => l_from,
              p_subj => TO_CHAR(subst(NVL(l_subj, l_name), l_name, l_rowcnt, rcpt.recipient)),
              p_body => TO_CHAR(subst(NVL(l_body, l_name), l_name, l_rowcnt, rcpt.recipient)),
              p_body_html => TO_CHAR(subst(NVL(l_body, l_name), l_name, l_rowcnt, rcpt.recipient)));
            FOR o IN (SELECT format, file_name, mime_type, file_blob
                        FROM prod.dct_rpt_output WHERE run_id = p_run_id) LOOP
              apex_mail.add_attachment(p_mail_id => l_mailid, p_attachment => o.file_blob,
                                       p_filename => o.file_name, p_mime_type => o.mime_type);
            END LOOP;
            prod.dct_rpt_pkg.record_delivery(p_run_id, rcpt.recipient, 'EMAIL', 'SENT');
          EXCEPTION WHEN OTHERS THEN
            prod.dct_rpt_pkg.record_delivery(p_run_id, rcpt.recipient, 'EMAIL', 'FAILED', SUBSTR(SQLERRM, 1, 1900));
          END;
        END LOOP;
        apex_mail.push_queue;
      EXCEPTION WHEN OTHERS THEN NULL;   -- delivery failure must not fail the run
      END;
    END IF;

    prod.dct_rpt_pkg.mark_status(p_run_id, 'SUCCESS', p_row_count => l_rowcnt);
  EXCEPTION WHEN OTHERS THEN
    prod.dct_rpt_pkg.mark_status(p_run_id, 'FAILED', p_error => SUBSTR(SQLERRM, 1, 3900));
  END process_run;

  PROCEDURE process_queued IS
    CURSOR c IS
      SELECT run_id FROM prod.dct_rpt_run
       WHERE status = 'QUEUED' AND engine = 'NATIVE'
       ORDER BY run_id FOR UPDATE SKIP LOCKED;
    l_run NUMBER;
  BEGIN
    LOOP
      OPEN c;
      FETCH c INTO l_run;
      IF c%NOTFOUND THEN CLOSE c; EXIT; END IF;
      UPDATE prod.dct_rpt_run
         SET status = 'RUNNING', worker_id = 'NATIVE/db', started_at = SYSTIMESTAMP, attempts = attempts + 1
       WHERE run_id = l_run;
      CLOSE c;
      COMMIT;                 -- release the lock; the row is now RUNNING
      process_run(l_run);     -- commits SUCCESS/FAILED via mark_status
    END LOOP;
  END process_queued;

END dct_rpt_native_pkg;
/
SHOW ERRORS PACKAGE BODY prod.dct_rpt_native_pkg

PROMPT === 3. ADMIN synonym ===
CREATE OR REPLACE SYNONYM dct_rpt_native_pkg FOR prod.dct_rpt_native_pkg;

PROMPT === 4. Sweep job (every 5 min) ===
BEGIN
  BEGIN DBMS_SCHEDULER.DROP_JOB('DCT_RPT_NATIVE_JOB', force => TRUE);
  EXCEPTION WHEN OTHERS THEN NULL; END;
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'DCT_RPT_NATIVE_JOB',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN prod.dct_rpt_native_pkg.process_queued; END;',
    start_date      => SYSTIMESTAMP AT TIME ZONE 'Asia/Dubai',
    repeat_interval => 'FREQ=MINUTELY;INTERVAL=5',
    enabled         => TRUE,
    comments        => 'i-Finance reporting NATIVE engine sweep (APEX_DATA_EXPORT + APEX_MAIL)');
END;
/

PROMPT === 5. NATIVE pilot definition (self-contained SQL, no binds) ===
DECLARE
  l_src CLOB;
BEGIN
  l_src :=
    'SELECT period_name, sector_name, program_name, account_code, account_desc, '||
    '       budget_ytd, gl_actual_ytd, ap_direct_actual_ytd, grn_actual_ytd, '||
    '       funds_available_ytd, variance_ytd '||
    'FROM prod.dct_budget_actual_period_v '||
    'WHERE period_name = (SELECT MAX(period_name) FROM prod.dct_budget_actual_period_v) '||
    'ORDER BY sector_name, program_name, account_code';
  MERGE INTO prod.dct_rpt_definition t
  USING (SELECT 'GL_BUDGET_ACTUAL_NATIVE' AS c FROM dual) s ON (t.report_code = s.c)
  WHEN NOT MATCHED THEN INSERT
    (report_code, name_en, name_ar, description, category, source_type, source_ref, engine,
     default_formats, email_subject_tpl, email_body_tpl, enabled, created_by, updated_by)
  VALUES
    ('GL_BUDGET_ACTUAL_NATIVE', 'Budget vs Actual (YTD) — Native', 'الموازنة مقابل الفعلي — أصلي',
     'In-database APEX_DATA_EXPORT version of the Budget vs Actual report (latest period).',
     'General Ledger', 'SQL', l_src, 'NATIVE', 'PDF,XLSX',
     'Budget vs Actual (Native)',
     '<p>Dear {{ recipient_name }},</p><p>The <b>{{ report_name }}</b> report is attached ({{ row_count }} rows). Generated {{ generated_at }}.</p>',
     'Y', 'SETUP', 'SETUP');
  COMMIT;
END;
/

PROMPT ============================================================
PROMPT  06_rpt_native_pkg.sql complete -- DCT_RPT_NATIVE_PKG + sweep job + pilot.
PROMPT ============================================================
