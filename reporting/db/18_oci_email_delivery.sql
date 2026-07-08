-- =============================================================================
-- i-Finance Reporting -- switch the in-DB email channel (APEX_MAIL: BI "Send
-- Test Email" button + NATIVE engine) to OCI Email Delivery.
-- File    : 18_oci_email_delivery.sql
-- Run     : sql -name prod_mcp "@18_oci_email_delivery.sql"   (quote the @arg
--           in PowerShell; fresh ADMIN session). Prompts (HIDDEN) for the OCI
--           SMTP credential password -- it is NOT stored in this file.
-- Why     : 2026-07-07 diagnosis -- ADB network policy HARD-BLOCKS outbound
--           SMTP to anything but OCI Email Delivery endpoints. An ACL for
--           smtp.gmail.com port 587 cannot even be created (ORA-24244), so the
--           gmail instance params set by 16 never delivered a single mail:
--           ORACLE_APEX_MAIL_QUEUE "SUCCEEDS" every 5 min while the rows sit
--           in apex_mail_queue untouched (mail_send_count=0, no error).
-- Prereqs (OCI Console, region me-abudhabi-1, done 2026-07-07):
--           1) IAM user > SMTP credentials generated (username below);
--           2) Email Delivery > Approved Sender = hany.uipath@gmail.com
--              (pilot; prod sender needs IT SPF/DKIM on dctabudhabi.ae).
-- The Python engine channel is UNTOUCHED (smtplib from the VM, env.ps1);
-- do NOT change the SMTP_* rows in DCT_RPT_CONFIG -- those drive Python.
-- =============================================================================

SET DEFINE ON
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
SET PAGESIZE 100
SET LINESIZE 220
WHENEVER SQLERROR CONTINUE

ACCEPT app_pwd CHAR PROMPT 'Enter OCI SMTP credential password (hidden): ' HIDE

PROMPT ==== 1. network ACL to the OCI Email Delivery endpoint ====
DECLARE
    PROCEDURE ace(p_principal VARCHAR2) IS
    BEGIN
        DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
            host       => 'smtp.email.me-abudhabi-1.oci.oraclecloud.com',
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

PROMPT ==== 2. verify ACEs exist (must list rows -- do NOT trust silence) ====
COLUMN host FORMAT A50
COLUMN principal FORMAT A20
COLUMN privilege FORMAT A12
SELECT host, lower_port, upper_port, principal, privilege
FROM dba_host_aces
WHERE LOWER(host) = 'smtp.email.me-abudhabi-1.oci.oraclecloud.com'
ORDER BY principal, privilege;

PROMPT ==== 3. APEX instance mail params -> OCI Email Delivery ====
BEGIN
  APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_HOST_ADDRESS','smtp.email.me-abudhabi-1.oci.oraclecloud.com');
  APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_HOST_PORT','587');
  APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_USERNAME','ocid1.user.oc1..aaaaaaaaxj3c6g7nkjlfczijyjiwph5xj4jm2sz3hrqu3a6tsmqkdwrfpuza@ocid1.tenancy.oc1..aaaaaaaalai2kk436tjj2d2j4lcj6js7ck64qssdtzrhfxciyvlea4mrgnpq.t4.com');
  APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_PASSWORD','&app_pwd');
  APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_TLS_MODE','STARTTLS');
  APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_FROM','hany.uipath@gmail.com');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('APEX instance SMTP params -> OCI Email Delivery.');
END;
/

PROMPT ==== 4. verify params (password shown only as SET / NOT SET) ====
BEGIN
  DBMS_OUTPUT.PUT_LINE('HOST = '||APEX_INSTANCE_ADMIN.GET_PARAMETER('SMTP_HOST_ADDRESS'));
  DBMS_OUTPUT.PUT_LINE('PORT = '||APEX_INSTANCE_ADMIN.GET_PARAMETER('SMTP_HOST_PORT'));
  DBMS_OUTPUT.PUT_LINE('USER = '||APEX_INSTANCE_ADMIN.GET_PARAMETER('SMTP_USERNAME'));
  DBMS_OUTPUT.PUT_LINE('FROM = '||APEX_INSTANCE_ADMIN.GET_PARAMETER('SMTP_FROM'));
  DBMS_OUTPUT.PUT_LINE('TLS  = '||APEX_INSTANCE_ADMIN.GET_PARAMETER('SMTP_TLS_MODE'));
  DBMS_OUTPUT.PUT_LINE('PWD  = '||CASE WHEN APEX_INSTANCE_ADMIN.GET_PARAMETER('SMTP_PASSWORD') IS NULL THEN 'NOT SET' ELSE 'SET' END);
END;
/

PROMPT ==== 5. connectivity test (expect CONNECTED ok + 220 banner) ====
DECLARE
    c utl_smtp.connection;
BEGIN
    c := utl_smtp.open_connection('smtp.email.me-abudhabi-1.oci.oraclecloud.com', 587, tx_timeout => 25);
    DBMS_OUTPUT.PUT_LINE('CONNECTED ok');
    utl_smtp.quit(c);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('CONNECT FAILED: '||SQLERRM);
END;
/

PROMPT ==== 6. drain the stuck queue (4 pending test mails, from = approved ====
PROMPT ==== sender, so they should now deliver; job also runs every 5 min) ====
BEGIN
    apex_session.create_session(p_app_id => 200, p_page_id => 1, p_username => 'ADMIN');
    apex_mail.push_queue;
    DBMS_OUTPUT.PUT_LINE('push_queue requested');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('push_queue error: '||SQLERRM);
END;
/

PROMPT ==== 7. queue after push: rows gone = sent; else read mail_send_error ====
COLUMN mail_to FORMAT A32
COLUMN mail_send_error FORMAT A90
SELECT id, mail_to, mail_send_count, SUBSTR(mail_send_error,1,90) mail_send_error
FROM apex_mail_queue ORDER BY id DESC FETCH FIRST 10 ROWS ONLY;

UNDEFINE app_pwd
PROMPT === 18_oci_email_delivery.sql complete -- re-test from BI Settings > Send Test Email ===
EXIT
