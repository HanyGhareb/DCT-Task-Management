-- =============================================================================
-- i-Finance V2 -- User profile photo storage (patch)
-- File    : 17_dct_user_photo.sql
-- Date    : 2026-06-11
-- Run as  : ADMIN (sql -name prod_mcp) -- standalone, like 15/16
-- =============================================================================
-- Adds photo_blob / photo_mime_type to DCT_USERS (photo_url existed since v1).
-- Served by the dct.admin ORDS handlers users/:id/photo (PUT base64 / GET media)
-- defined in 11_dct_ords.sql. Fresh installs get the columns from 01_dct_ddl.sql;
-- the ALTERs below are exception-guarded so this script stays idempotent.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON

BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_users ADD (photo_blob BLOB)';
    DBMS_OUTPUT.PUT_LINE('photo_blob added');
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE = -1430 THEN DBMS_OUTPUT.PUT_LINE('photo_blob already exists');
    ELSE RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_users ADD (photo_mime_type VARCHAR2(100))';
    DBMS_OUTPUT.PUT_LINE('photo_mime_type added');
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE = -1430 THEN DBMS_OUTPUT.PUT_LINE('photo_mime_type already exists');
    ELSE RAISE; END IF;
END;
/
