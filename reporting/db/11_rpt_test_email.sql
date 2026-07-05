-- =============================================================================
-- i-Finance Reporting -- "Send Test Email" endpoint (additive to rpt.rest)
-- File    : 11_rpt_test_email.sql
-- Schema  : registered under ADMIN. Base /ords/admin/rpt/.
-- Run     : sql -name prod_mcp @11_rpt_test_email.sql   (ANY session -- adds ONE
--           new template/handler to rpt.rest; no module rebuild, no synonyms.)
--           **Re-run after any 04_rpt_ords.sql re-run** (04 DELETE_MODULEs
--           rpt.rest and would drop this handler).
-- Purpose : POST config/test-email  {to}
--           SYS_ADMIN only. Sends a small branded test message via APEX_MAIL
--           (the in-DB / NATIVE-engine mail path) to confirm outbound email
--           works, and returns the mail id (or the SMTP error). Uses the sender
--           (SMTP_FROM) from DCT_RPT_CONFIG; the actual transport is the APEX
--           instance email settings (host/port/username/password) -- so a
--           successful send also requires the APEX instance SMTP to be set:
--             APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_HOST_ADDRESS','smtp.gmail.com');
--             ... SMTP_HOST_PORT / SMTP_USERNAME / SMTP_PASSWORD / SMTP_TLS_MODE.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE PROCEDURE setup_rpt_testmail_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'rpt.rest';

    PROCEDURE deft(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    PROCEDURE defh(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    deft('config/test-email');
    defh('config/test-email', 'POST', q'[
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_to      VARCHAR2(320);
  l_from    VARCHAR2(320);
  l_enabled VARCHAR2(1);
  l_mailid  NUMBER;
  l_when    VARCHAR2(40);
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
  l_from    := prod.dct_rpt_pkg.cfg('SMTP_FROM','no-reply@dct.gov.ae');
  l_when    := TO_CHAR(dct_to_local(SYSTIMESTAMP),'YYYY-MM-DD HH:MI AM');

  -- APEX_MAIL needs an APEX session context from a bare DB / ORDS call.
  BEGIN
    apex_session.create_session(p_app_id => 200, p_page_id => 1, p_username => 'ADMIN');
  EXCEPTION WHEN OTHERS THEN NULL; END;

  l_mailid := apex_mail.send(
    p_to        => l_to,
    p_from      => l_from,
    p_subj      => 'i-Finance Reporting - test email',
    p_body      => 'This is a test email from the i-Finance Reporting platform (BI app).'
                   || CHR(10) || 'If you received it, outbound email is working.'
                   || CHR(10) || 'Sent ' || l_when || ' (Asia/Dubai).',
    p_body_html => '<div style="font-family:Segoe UI,Arial,sans-serif;color:#1f2d3d">'
                   || '<h2 style="color:#1F6F8B;margin:0 0 8px">i-Finance Reporting</h2>'
                   || '<p>This is a <b>test email</b> from the Reporting platform (BI app).</p>'
                   || '<p>If you received it, outbound email is working. &#9989;</p>'
                   || '<p style="color:#8a94a6;font-size:12px">Sent ' || l_when
                   || ' (Asia/Dubai).</p></div>');
  apex_mail.push_queue;

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok',           TRUE);
  APEX_JSON.write('mailId',       l_mailid);
  APEX_JSON.write('to',           l_to);
  APEX_JSON.write('sentFrom',     l_from);
  APEX_JSON.write('emailEnabled', l_enabled);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(500, 'Test email failed: ' || SQLERRM);
END;
]');

END setup_rpt_testmail_tmp;
/

BEGIN
    setup_rpt_testmail_tmp;
    COMMIT;
END;
/

DROP PROCEDURE setup_rpt_testmail_tmp;

PROMPT === 11_rpt_test_email.sql complete ===
