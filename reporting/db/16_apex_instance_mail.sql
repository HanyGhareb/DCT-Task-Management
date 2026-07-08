-- =============================================================================
-- i-Finance Reporting -- enable in-DB email (APEX_MAIL): BI "Send Test Email"
-- button + the NATIVE report engine. The Python runner uses its own smtplib
-- transport (env.ps1) and does NOT need this.
-- Run:  sql -name prod_mcp @16_apex_instance_mail.sql
--       Prompts (HIDDEN) for the Gmail App Password -- it is NOT stored in this file.
-- =============================================================================
SET DEFINE ON
SET SERVEROUTPUT ON
SET VERIFY OFF
WHENEVER SQLERROR CONTINUE

ACCEPT app_pwd CHAR PROMPT 'Enter Gmail App Password for hany.uipath@gmail.com (hidden): ' HIDE

BEGIN
  APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_HOST_ADDRESS','smtp.gmail.com');
  APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_HOST_PORT','587');
  APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_USERNAME','hany.uipath@gmail.com');
  APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_PASSWORD','&app_pwd');
  APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_TLS_MODE','STARTTLS');
  APEX_INSTANCE_ADMIN.SET_PARAMETER('SMTP_FROM','hany.uipath@gmail.com');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('APEX instance SMTP params set.');
END;
/

-- SUPERSEDED 2026-07-07 -- this script's gmail config NEVER delivered: ADB
-- network policy blocks outbound SMTP to non-OCI hosts, and the ACL below
-- cannot even be created (ORA-24244 invalid host/port). The earlier "works
-- without ACL" note was wrong (only the Python/VM channel had been verified).
-- The working in-DB config is 18_oci_email_delivery.sql (OCI Email Delivery).
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
    host       => 'smtp.gmail.com',
    lower_port => 587,
    upper_port => 587,
    ace        => xs$ace_type(
                    privilege_list => xs$name_list('connect','resolve'),
                    principal_name => 'ADMIN',
                    principal_type => xs_acl.ptype_db));
  DBMS_OUTPUT.PUT_LINE('Network ACL appended: ADMIN -> smtp.gmail.com:587');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ACL note: '||SQLERRM);
END;
/

PROMPT ==== verify (password shown only as SET / NOT SET) ====
BEGIN
  DBMS_OUTPUT.PUT_LINE('HOST = '||APEX_INSTANCE_ADMIN.GET_PARAMETER('SMTP_HOST_ADDRESS'));
  DBMS_OUTPUT.PUT_LINE('PORT = '||APEX_INSTANCE_ADMIN.GET_PARAMETER('SMTP_HOST_PORT'));
  DBMS_OUTPUT.PUT_LINE('USER = '||APEX_INSTANCE_ADMIN.GET_PARAMETER('SMTP_USERNAME'));
  DBMS_OUTPUT.PUT_LINE('FROM = '||APEX_INSTANCE_ADMIN.GET_PARAMETER('SMTP_FROM'));
  DBMS_OUTPUT.PUT_LINE('TLS  = '||APEX_INSTANCE_ADMIN.GET_PARAMETER('SMTP_TLS_MODE'));
  DBMS_OUTPUT.PUT_LINE('PWD  = '||CASE WHEN APEX_INSTANCE_ADMIN.GET_PARAMETER('SMTP_PASSWORD') IS NULL THEN 'NOT SET' ELSE 'SET' END);
END;
/

PROMPT ==== ACL ====
SELECT host, lower_port, upper_port, principal, privilege
FROM dba_host_aces WHERE LOWER(host)='smtp.gmail.com' ORDER BY principal, privilege;

UNDEFINE app_pwd
PROMPT ==== done -- now click Send Test Email in BI Settings ====
EXIT
