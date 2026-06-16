-- ===========================================================================
-- otbi-atd : 02 network ACL
-- Lets the PROD schema make the outbound HTTPS call to the Fusion/OTBI pod via
-- APEX_WEB_SERVICE / UTL_HTTP. Edit l_host to the pod host before running.
-- On ADB, public-CA TLS uses the Oracle-managed wallet, so no wallet is set.
-- Rerunnable. CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

DECLARE
  l_host      VARCHAR2(200) := 'iaaibv.fa.ocs.oraclecloud29.com';  -- the pod host
  l_principal VARCHAR2(30)  := 'PROD';                              -- schema that runs the job
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
    host => l_host,
    ace  => xs$ace_type(
              privilege_list => xs$name_list('connect','resolve'),
              principal_name => l_principal,
              principal_type => xs_acl.ptype_db));
  DBMS_OUTPUT.PUT_LINE('ACE appended for '||l_principal||' -> '||l_host);
END;
/

-- Confirm the ACE is in place
SELECT host, lower_port, upper_port, principal, privilege, grant_type
  FROM dba_host_aces
 WHERE host = 'iaaibv.fa.ocs.oraclecloud29.com'
 ORDER BY principal, privilege;

SET ECHO OFF
PROMPT otbi-atd 02 network ACL : done
