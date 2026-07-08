-- =============================================================================
-- i-Finance Reporting -- SMTP network ACL fix for in-DB email (APEX_MAIL)
-- File    : 17_smtp_acl_fix.sql
-- Run     : sql -name prod_mcp "@17_smtp_acl_fix.sql"   (fresh ADMIN session)
-- Why     : Root cause of "Send Test Email accepted but never received"
--           (diagnosed 2026-07-07): dba_host_aces has NO entry for
--           smtp.gmail.com -- the ACL block in 16_apex_instance_mail.sql
--           silently failed (its exception handler swallows errors; the
--           PowerShell here-doc ate xs$name_list -> PLS-00201). UTL_SMTP from
--           ADMIN fails with ORA-24247, and the ORACLE_APEX_MAIL_QUEUE job
--           "SUCCEEDS" every 5 min while never attempting the queued rows
--           (apex_mail_queue mail_send_count stays 0, no mail_send_error).
--           Grants connect/resolve on smtp.gmail.com:587 to ADMIN and to the
--           APEX engine schema (the mail-queue job runs as APEX_2xxxxx, so it
--           needs its own ACE), verifies connectivity, then pushes the queue.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET PAGESIZE 100
SET LINESIZE 220

PROMPT ==== add ACEs (ADMIN + every APEX_2 percent engine schema) ====
DECLARE
    PROCEDURE ace(p_principal VARCHAR2) IS
    BEGIN
        DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
            host       => 'smtp.gmail.com',
            lower_port => 587,
            upper_port => 587,
            ace        => xs$ace_type(
                            privilege_list => xs$name_list('connect','resolve'),
                            principal_name => p_principal,
                            principal_type => xs_acl.ptype_db));
        DBMS_OUTPUT.PUT_LINE('ACE added for '||p_principal);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ACE for '||p_principal||' FAILED: '||SQLERRM);
    END;
BEGIN
    ace('ADMIN');
    FOR r IN (SELECT username FROM all_users WHERE username LIKE 'APEX_2%') LOOP
        ace(r.username);
    END LOOP;
    COMMIT;
END;
/

PROMPT ==== verify ACEs actually exist (must list rows -- do NOT trust silence) ====
COLUMN host FORMAT A25
COLUMN principal FORMAT A20
COLUMN privilege FORMAT A12
SELECT host, lower_port, upper_port, principal, privilege
FROM dba_host_aces WHERE LOWER(host) = 'smtp.gmail.com'
ORDER BY principal, privilege;

PROMPT ==== connectivity re-test (expect CONNECTED ok; timeout means ADB egress ====
PROMPT ==== to non-OCI SMTP is blocked -> switch to OCI Email Delivery)        ====
DECLARE
    c utl_smtp.connection;
BEGIN
    c := utl_smtp.open_connection('smtp.gmail.com', 587, tx_timeout => 25);
    DBMS_OUTPUT.PUT_LINE('CONNECTED ok');
    utl_smtp.quit(c);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('CONNECT FAILED: '||SQLERRM);
END;
/

PROMPT ==== drain the stuck queue now (job also runs every 5 min) ====
BEGIN
    apex_session.create_session(p_app_id => 200, p_page_id => 1, p_username => 'ADMIN');
    apex_mail.push_queue;
    DBMS_OUTPUT.PUT_LINE('push_queue requested');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('push_queue error: '||SQLERRM);
END;
/

PROMPT ==== queue after push: rows should disappear, or show mail_send_error ====
COLUMN mail_to FORMAT A32
COLUMN mail_send_error FORMAT A90
SELECT id, mail_to, mail_send_count, SUBSTR(mail_send_error,1,90) mail_send_error
FROM apex_mail_queue ORDER BY id DESC FETCH FIRST 10 ROWS ONLY;

PROMPT === 17_smtp_acl_fix.sql complete ===
EXIT
