-- =============================================================================
-- i-Finance V2 -- Raw-binary profile-photo upload for DCT users
-- File    : 29_user_photo_binary.sql
-- Schema  : ADMIN (ORDS handler on the dct.admin module; reads PROD via synonyms)
-- Run as  : sql -name prod_mcp  (FRESH session)
-- Purpose : the mobile app (ifinance-mobile) and any modern client upload the
--           profile photo as RAW BYTES (api.putBinary) -- no base64, no ~24 KB
--           cap. The legacy PUT /dct/users/:id/photo stays base64 (web Admin);
--           this adds PUT /dct/users/:id/photobin that reads :body as a BLOB.
--           GET /dct/users/:id/photo (media) already serves photo_blob for both.
-- Idempotent: re-running just redefines the handler.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE PROCEDURE admin.setup_dct_userphoto_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30) := 'dct.admin';
  PROCEDURE def_template(p_pattern VARCHAR2) IS
  BEGIN
    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern,'[COLON]',CHR(58)));
  END;
  PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
  BEGIN
    ORDS.DEFINE_HANDLER(
      p_module_name => c_mod,
      p_pattern     => REPLACE(p_pattern,'[COLON]',CHR(58)),
      p_method      => p_method,
      p_source_type => ORDS.source_type_plsql,
      p_source      => REPLACE(p_source,'[COLON]',CHR(58)));
  END;
BEGIN
  def_template('users/[COLON]id/photobin');
  def_handler('users/[COLON]id/photobin', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100);
  l_blob BLOB;
  l_max  NUMBER;
BEGIN
  l_blob := [COLON]body;                 -- deref :body exactly ONCE, FIRST in BEGIN
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF l_blob IS NULL OR DBMS_LOB.GETLENGTH(l_blob) = 0 THEN
    dct_rest.err(400,'Request body (image bytes) is required'); RETURN;
  END IF;
  BEGIN
    SELECT TO_NUMBER(setting_value DEFAULT NULL ON CONVERSION ERROR) INTO l_max
    FROM dct_system_settings WHERE setting_key = 'MAX_UPLOAD_MB';
  EXCEPTION WHEN NO_DATA_FOUND THEN l_max := NULL; END;
  l_max := NVL(l_max, 10);
  IF DBMS_LOB.GETLENGTH(l_blob) > l_max * 1024 * 1024 THEN
    dct_rest.err(413, 'File exceeds the ' || l_max || ' MB limit'); RETURN;
  END IF;
  UPDATE dct_users SET
    photo_blob      = l_blob,
    photo_mime_type = NVL([COLON]mime, 'image/jpeg'),
    photo_url       = '/ords/admin/dct/users/' || [COLON]id || '/photo',
    updated_by      = l_user,
    updated_at      = SYSTIMESTAMP
  WHERE user_id = [COLON]id;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('photoUrl', '/ords/admin/dct/users/' || [COLON]id || '/photo');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');
END;
/

BEGIN
  admin.setup_dct_userphoto_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE admin.setup_dct_userphoto_ords_tmp;

PROMPT === 29_user_photo_binary.sql complete ===
