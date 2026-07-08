-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 20a template endpoints (ADDITIVE)
-- File   : reporting/db/20a_rpt_templates_ords.sql
-- Adds to: rpt.rest (does NOT redefine the module). Needs 20_rpt_templates.sql.
-- Run as : sql -name prod_mcp   (fresh session). If 04_rpt_ords.sql is ever
--          re-run, re-run THIS script after it (04 rebuilds rpt.rest from
--          scratch). Canonical post-04 list: 08b, 09a, 10, 12b, 19, 20a.
-- Endpoints (SYS_ADMIN only):
--   GET    templates/        list -- name, kind, size, usedBy count
--   GET    templates/:name   authed download of the template file
--   PUT    templates/:name   raw-binary upload/replace (body = file bytes;
--                            mime + descr in the query string; TEMPLATE_MAX_MB
--                            guard -> 413; name must end .docx or .j2)
--   DELETE templates/:name   remove; 409 while any definition references it
-- Zero blank lines inside statements; each handler kept small.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. GET templates/ ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest', p_pattern => 'templates/');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'templates/', p_method => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR c IN (
    SELECT t.template_name, t.description, t.mime_type, t.file_size, t.enabled,
           t.updated_by, t.updated_at,
           CASE WHEN LOWER(t.template_name) LIKE '%.docx' THEN 'DOCX' ELSE 'HTML' END AS kind,
           (SELECT COUNT(*) FROM dct_rpt_definition d
             WHERE d.pdf_template = t.template_name) AS used_by
      FROM dct_rpt_template t
     ORDER BY t.template_name
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('name', c.template_name);
    APEX_JSON.write('description', NVL(c.description,''));
    APEX_JSON.write('kind', c.kind);
    APEX_JSON.write('mimeType', NVL(c.mime_type,''));
    APEX_JSON.write('fileSize', c.file_size);
    APEX_JSON.write('enabled', c.enabled);
    APEX_JSON.write('usedBy', c.used_by);
    APEX_JSON.write('updatedBy', NVL(c.updated_by,''));
    APEX_JSON.write('updatedAt', NVL(TO_CHAR(dct_to_local(c.updated_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT === 2. GET templates/:name (download) ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest', p_pattern => REPLACE('templates/[COLON]name','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => REPLACE('templates/[COLON]name','[COLON]',CHR(58)), p_method => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_blob BLOB; l_mime VARCHAR2(120);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  BEGIN
    SELECT content, mime_type INTO l_blob, l_mime
      FROM dct_rpt_template WHERE template_name = [COLON]name;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Template not found'); RETURN; END;
  OWA_UTIL.mime_header(NVL(l_mime,'application/octet-stream'), FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="'||[COLON]name||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT === 3. PUT templates/:name (raw-binary upload) ===
BEGIN
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => REPLACE('templates/[COLON]name','[COLON]',CHR(58)), p_method => 'PUT',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100);
  l_blob BLOB;
  l_name VARCHAR2(200);
  l_mime VARCHAR2(120);
  l_max  NUMBER;
  l_len  NUMBER;
  l_new  BOOLEAN := FALSE;
BEGIN
  l_blob := [COLON]body;
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  l_name := [COLON]name;
  IF l_name IS NULL
     OR NOT (LOWER(l_name) LIKE '%.docx' OR LOWER(l_name) LIKE '%.j2') THEN
    dct_rest.err(400,'Template name must end in .docx or .j2'); RETURN;
  END IF;
  IF l_blob IS NULL OR DBMS_LOB.GETLENGTH(l_blob) = 0 THEN
    dct_rest.err(400,'Request body (template file bytes) is required'); RETURN;
  END IF;
  l_len := DBMS_LOB.GETLENGTH(l_blob);
  BEGIN
    SELECT TO_NUMBER(config_value DEFAULT NULL ON CONVERSION ERROR) INTO l_max
      FROM dct_rpt_config WHERE config_key = 'TEMPLATE_MAX_MB';
  EXCEPTION WHEN NO_DATA_FOUND THEN l_max := NULL; END;
  l_max := NVL(l_max, 10);
  IF l_len > l_max * 1024 * 1024 THEN
    dct_rest.err(413,'File exceeds the '||l_max||' MB limit'); RETURN;
  END IF;
  l_mime := NVL([COLON]mime, CASE WHEN LOWER(l_name) LIKE '%.docx'
    THEN 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    ELSE 'text/html' END);
  UPDATE dct_rpt_template
     SET content = l_blob, mime_type = l_mime, file_size = l_len,
         description = NVL([COLON]descr, description),
         updated_by = l_user, updated_at = SYSTIMESTAMP
   WHERE template_name = l_name;
  IF SQL%ROWCOUNT = 0 THEN
    l_new := TRUE;
    INSERT INTO dct_rpt_template
      (template_name, description, mime_type, content, file_size, created_by, updated_by)
    VALUES (l_name, [COLON]descr, l_mime, l_blob, l_len, l_user, l_user);
  END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('name', l_name);
  APEX_JSON.write('created', l_new);
  APEX_JSON.write('fileSize', l_len);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT === 4. DELETE templates/:name ===
BEGIN
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => REPLACE('templates/[COLON]name','[COLON]',CHR(58)), p_method => 'DELETE',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_used NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  SELECT COUNT(*) INTO l_used
    FROM dct_rpt_definition WHERE pdf_template = [COLON]name;
  IF l_used > 0 THEN
    dct_rest.err(409,'Template is used by '||l_used||' report definition(s)'); RETURN;
  END IF;
  DELETE FROM dct_rpt_template WHERE template_name = [COLON]name;
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Template not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT === 5. Verify ===
SELECT uri_template, method
FROM user_ords_handlers h
JOIN user_ords_templates t ON t.id = h.template_id
WHERE t.uri_template LIKE 'templates%'
ORDER BY uri_template, method;

PROMPT ============================================================
PROMPT  20a_rpt_templates_ords.sql complete (4 template endpoints).
PROMPT ============================================================
