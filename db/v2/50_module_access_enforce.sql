-- =============================================================================
-- i-Finance V2 -- Server-side module access enforcement (follows 49)
-- File    : 50_module_access_enforce.sql
-- Schema  : PROD package body (DCT_REST)
-- Run as  : sql -name prod_mcp   (fresh session)
-- Purpose : enforce DCT_MODULE_ROLES at the API layer so a denied user is
--           blocked even when opening an app by direct URL. The gate lives in
--           DCT_REST.VALIDATE_SESSION -- the one call every protected handler
--           in every module already makes -- and works off the ORDS request
--           path (CGI env X-APEX-PATH, first segment = ORDS module base).
--           Semantics mirror 49: module with zero DCT_MODULE_ROLES rows is
--           open to all; rows present = caller needs a mapped active role;
--           SYS_ADMIN is always allowed. The shared /dct/ platform module
--           (auth, boot, notifications, profile, approvals inbox) is EXEMPT.
--           Deny response: HTTP 403 {"error": "Module access denied"}.
--           Fail-open: any error inside the gate allows the request -- the
--           per-handler role checks remain the deepest security layer.
-- NOTE    : a NEW module app must add its ORDS segment to the CASE map below.
--           After running this, source is synced into 11_dct_ords.sql.
-- Verified: last_ddl_time + VALID checks at the end (SQLcl swallow guard).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE PACKAGE BODY prod.dct_rest AS

    -- One-shot suppression flag for the module-access deny path. When the
    -- gate writes its 403 and returns NULL, the calling handler still runs
    -- its standard err(401) -- this flag makes that follow-up call a no-op
    -- so the response body stays a single clean JSON object. Armed ONLY by
    -- the deny path, consumed by the next err() call, and reset at every
    -- validate_session entry (pooled DB sessions carry package state
    -- across HTTP requests).
    g_deny_sent BOOLEAN := FALSE;

    -- module-access gate (db/v2/50): 1 = deny. Fail-open on any error.
    FUNCTION module_denied (p_username IN VARCHAR2) RETURN NUMBER IS
        l_path VARCHAR2(400);
        l_seg  VARCHAR2(30);
        l_mod  VARCHAR2(40);
        l_n    NUMBER;
    BEGIN
        l_path := OWA_UTIL.get_cgi_env('X-APEX-PATH');
        IF l_path IS NULL OR INSTR(l_path, '/') = 0 THEN RETURN 0; END IF;
        l_seg := LOWER(SUBSTR(l_path, 1, INSTR(l_path, '/') - 1));
        l_mod := CASE l_seg
                   WHEN 'pc'  THEN 'PETTY_CASH'
                   WHEN 'dt'  THEN 'DUTY_TRAVEL'
                   WHEN 'hr'  THEN 'HR'
                   WHEN 'fl'  THEN 'FREELANCERS'
                   WHEN 'cc'  THEN 'CREDIT_CARDS'
                   WHEN 'ar'  THEN 'AR'
                   WHEN 'tm'  THEN 'TASK_MGMT'
                   WHEN 'atd' THEN 'ATD'
                   WHEN 'gl'  THEN 'GL'
                   WHEN 'rpt' THEN 'REPORTING'
                   WHEN 'ap'  THEN 'AP'
                   ELSE NULL   -- 'dct' shared platform + unknown segments: exempt
                 END;
        IF l_mod IS NULL THEN RETURN 0; END IF;

        SELECT COUNT(*) INTO l_n
        FROM   dct_module_roles mr
        JOIN   dct_modules      m ON m.module_id = mr.module_id
        WHERE  m.module_code = l_mod;
        IF l_n = 0 THEN RETURN 0; END IF;   -- unrestricted module

        SELECT COUNT(*) INTO l_n
        FROM   dct_user_roles ur
        JOIN   dct_users      u  ON u.user_id  = ur.user_id
        JOIN   dct_roles      ro ON ro.role_id = ur.role_id
        WHERE  UPPER(u.username) = UPPER(p_username)
          AND  ur.is_active = 'Y'
          AND  ro.is_active = 'Y'
          AND  TRUNC(SYSDATE) >= TRUNC(ur.start_date)
          AND  (ur.end_date IS NULL OR TRUNC(SYSDATE) <= TRUNC(ur.end_date))
          AND  (ro.role_code = 'SYS_ADMIN'
                OR ro.role_id IN (SELECT mr.role_id
                                  FROM   dct_module_roles mr
                                  JOIN   dct_modules m ON m.module_id = mr.module_id
                                  WHERE  m.module_code = l_mod));
        RETURN CASE WHEN l_n = 0 THEN 1 ELSE 0 END;
    EXCEPTION WHEN OTHERS THEN RETURN 0;
    END module_denied;

    FUNCTION validate_session RETURN VARCHAR2 IS
        l_hdr     VARCHAR2(4000);
        l_token    VARCHAR2(200);
        l_username VARCHAR2(100);
    BEGIN
        g_deny_sent := FALSE;
        -- ADB managed ORDS uses 'AUTHORIZATION' (no HTTP_ prefix); fall back to HTTP_ for on-prem
        l_hdr := OWA_UTIL.get_cgi_env('AUTHORIZATION');
        IF l_hdr IS NULL THEN
            l_hdr := OWA_UTIL.get_cgi_env('HTTP_AUTHORIZATION');
        END IF;
        IF l_hdr LIKE 'Bearer %' THEN
            l_token := TRIM(SUBSTR(l_hdr, 8));
        END IF;
        IF l_token IS NULL THEN RETURN NULL; END IF;

        -- Wave 3 (db/v2/19): sessions expire after SESSION_TIMEOUT_MINS of
        -- inactivity (default 480); successful calls touch last_activity_at.
        SELECT s.username INTO l_username
        FROM   dct_sessions s
        JOIN   dct_users    u ON s.user_id = u.user_id
        WHERE  s.session_id = l_token
          AND  s.is_active  = 'Y'
          AND  u.is_active  = 'Y'
          AND  s.last_activity_at > SYSTIMESTAMP - NUMTODSINTERVAL(
                 NVL((SELECT TO_NUMBER(setting_value)
                      FROM dct_system_settings
                      WHERE setting_key = 'SESSION_TIMEOUT_MINS'), 480), 'MINUTE')
          AND  ROWNUM = 1;

        dct_auth.touch_session(l_token);

        -- module-access gate (db/v2/50): valid session but the target ORDS
        -- module is restricted to roles this user does not hold. Writes the
        -- 403 itself and returns NULL; the handler's follow-up err(401) lands
        -- harmlessly after the closed 403 header block.
        IF module_denied(l_username) = 1 THEN
            err(403, 'Module access denied');
            g_deny_sent := TRUE;
            RETURN NULL;
        END IF;

        RETURN l_username;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END validate_session;

    PROCEDURE json_header IS
        c_col CONSTANT VARCHAR2(1) := CHR(58);
    BEGIN
        OWA_UTIL.mime_header('application/json', FALSE);
        HTP.p('Access-Control-Allow-Origin'  || c_col || ' *');
        HTP.p('Access-Control-Allow-Headers' || c_col || ' Authorization, Content-Type');
        HTP.p('Access-Control-Allow-Methods' || c_col || ' GET, POST, PUT, DELETE, OPTIONS');
        OWA_UTIL.http_header_close;
    END json_header;

    PROCEDURE err(p_status PLS_INTEGER, p_msg VARCHAR2) IS
        c_col CONSTANT VARCHAR2(1) := CHR(58);
    BEGIN
        -- Module-access deny already wrote the 403 -- swallow the handler's
        -- follow-up err(401) so the body stays one clean JSON object.
        IF g_deny_sent THEN
            g_deny_sent := FALSE;
            RETURN;
        END IF;
        -- Do NOT use APEX_JSON here: initialize_output resets the HTP buffer
        -- and silently wipes the status line (every error returned HTTP 200
        -- until this was fixed -- discovered in the Phase 1 smoke test).
        OWA_UTIL.status_line(p_status, NULL, FALSE);
        OWA_UTIL.mime_header('application/json', FALSE);
        HTP.p('Access-Control-Allow-Origin'  || c_col || ' *');
        HTP.p('Access-Control-Allow-Headers' || c_col || ' Authorization, Content-Type');
        HTP.p('Access-Control-Allow-Methods' || c_col || ' GET, POST, PUT, DELETE, OPTIONS');
        OWA_UTIL.http_header_close;
        HTP.p('{"error"' || c_col || ' "' ||
              REPLACE(REPLACE(p_msg, '\', '\\'), '"', '\"') || '"}');
    END err;

    PROCEDURE parse_body(p_body IN BLOB) IS
        l_raw  RAW(32767);
        l_body VARCHAR2(32767);
    BEGIN
        l_raw  := DBMS_LOB.SUBSTR(p_body, 32767, 1);
        l_body := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
        APEX_JSON.parse(l_body);
    EXCEPTION WHEN OTHERS THEN
        APEX_JSON.parse('{}');
    END parse_body;

END dct_rest;
/

PROMPT === Verify (SQLcl swallow guard) ===
SELECT object_name, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
FROM   all_objects
WHERE  owner = 'PROD' AND object_name = 'DCT_REST' AND object_type = 'PACKAGE BODY';

SELECT COUNT(*) AS gate_in_source
FROM   all_source
WHERE  owner = 'PROD' AND name = 'DCT_REST' AND type = 'PACKAGE BODY'
  AND  UPPER(text) LIKE '%MODULE_DENIED%';

EXIT
