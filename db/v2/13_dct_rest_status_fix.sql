-- =============================================================================
-- DCT_REST — error status fix (patch)
-- File    : 13_dct_rest_status_fix.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @13_dct_rest_status_fix.sql
-- =============================================================================
-- BUG: dct_rest.err() called APEX_JSON.initialize_output, which resets the
-- HTP buffer and silently discards the OWA_UTIL.status_line — so every error
-- (including 401 Unauthorized) was returned with HTTP 200. The JET api.js
-- 401→login redirect therefore never fired in any module.
-- Discovered by the Phase 1 smoke test (assessment-3/phase1/).
-- FIX: err() now writes status + CORS headers + JSON body via OWA/HTP only.
-- The same fix is applied in the source of truth db/v2/11_dct_ords.sql.
-- =============================================================================
SET DEFINE OFF

CREATE OR REPLACE PACKAGE BODY prod.dct_rest AS

    FUNCTION validate_session RETURN VARCHAR2 IS
        l_hdr     VARCHAR2(4000);
        l_token    VARCHAR2(200);
        l_username VARCHAR2(100);
    BEGIN
        -- ADB managed ORDS uses 'AUTHORIZATION' (no HTTP_ prefix); fall back to HTTP_ for on-prem
        l_hdr := OWA_UTIL.get_cgi_env('AUTHORIZATION');
        IF l_hdr IS NULL THEN
            l_hdr := OWA_UTIL.get_cgi_env('HTTP_AUTHORIZATION');
        END IF;
        IF l_hdr LIKE 'Bearer %' THEN
            l_token := TRIM(SUBSTR(l_hdr, 8));
        END IF;
        IF l_token IS NULL THEN RETURN NULL; END IF;

        SELECT s.username INTO l_username
        FROM   dct_sessions s
        JOIN   dct_users    u ON s.user_id = u.user_id
        WHERE  s.session_id = l_token
          AND  s.is_active  = 'Y'
          AND  u.is_active  = 'Y'
          AND  ROWNUM = 1;

        dct_auth.touch_session(l_token);
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
        -- No APEX_JSON here: initialize_output resets the HTP buffer and
        -- wipes the status line (the original bug).
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

SHOW ERRORS PACKAGE BODY prod.dct_rest

PROMPT === 13_dct_rest_status_fix.sql complete — dct_rest.err now sets real HTTP status ===
