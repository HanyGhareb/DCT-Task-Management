-- =============================================================================
-- General Ledger (App 210) -- Terms and Key definitions ORDS (ADDITIVE)
-- File    : 51_gl_terms_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @51_gl_terms_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run this script with the rest of the post-05 list (07..51).
-- Purpose : CRUD for DCT_GL_REPORT_TERMS (db/v2/129) -- the rich-text
--           "Terms and Key definitions" documents shown as the FIRST content
--           section of the Sector Performance Report (reporting/db/42).
--           Managed from GL -> Settings -> Terms and Key definitions.
--           Reads = GL_VIEW_BUDGET_UTILIZATION (NULL legacy); writes =
--           GL_MANAGE_TERMS / SYS_ADMIN. Meta routes sit under a third
--           segment (terms/meta/*) so they can never collide with terms/:id.
--           content_html is CLOB end-to-end (APEX_JSON get_clob / write CLOB)
--           and is sanitised on save (script blocks, on* attributes,
--           javascript: URLs stripped).
-- Endpoints:
--   GET    /gl/terms               -> {items:[...], canManage}
--   POST   /gl/terms               -> create  {termId}
--   GET    /gl/terms/:id           -> detail incl. contentHtml
--   PUT    /gl/terms/:id           -> update  (absent keys keep stored values)
--   DELETE /gl/terms/:id           -> delete
--   GET    /gl/terms/meta/caps     -> {canManage}
--   GET    /gl/terms/meta/lookups  -> {appliedTo:[...], statuses:[...]}
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_terms_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

BEGIN

    def_template('terms');
    def_handler('terms', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_mgr  VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL access required'); RETURN;
  END IF;
  l_mgr := CASE WHEN prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_TERMS', 'SYS_ADMIN', 'GL') THEN 'Y' ELSE 'N' END;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('canManage', l_mgr);
  APEX_JSON.open_array('items');
  FOR c IN (SELECT t.term_id, t.title, t.applied_to,
                   NVL((SELECT v.value_name_en FROM prod.dct_lookup_values v
                          JOIN prod.dct_lookup_categories cc ON cc.category_id = v.category_id
                         WHERE cc.category_code = 'GL_TERMS_APPLIED_TO'
                           AND v.value_code = t.applied_to AND ROWNUM = 1), t.applied_to) AS applied_name,
                   TO_CHAR(t.start_date, 'YYYY-MM-DD') AS start_d,
                   TO_CHAR(t.end_date, 'YYYY-MM-DD')   AS end_d,
                   t.status,
                   NVL(t.updated_by, t.created_by) AS upd_by,
                   TO_CHAR(dct_to_local(NVL(t.updated_at, t.created_at)),'YYYY-MM-DD HH[COLON]MI AM') AS upd_at,
                   DBMS_LOB.GETLENGTH(t.content_html) AS html_len
              FROM dct_gl_report_terms t
             ORDER BY t.start_date DESC, t.term_id DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('termId', c.term_id);
    APEX_JSON.write('title', c.title);
    APEX_JSON.write('appliedTo', c.applied_to);
    APEX_JSON.write('appliedToName', c.applied_name);
    APEX_JSON.write('startDate', c.start_d);
    APEX_JSON.write('endDate', NVL(c.end_d, ''));
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('updatedBy', c.upd_by);
    APEX_JSON.write('updatedAt', c.upd_at);
    APEX_JSON.write('htmlLen', NVL(c.html_len, 0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('terms', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_title VARCHAR2(200); l_app VARCHAR2(50); l_status VARCHAR2(20);
  l_sd VARCHAR2(20); l_ed VARCHAR2(20); l_html CLOB; l_id NUMBER; v NUMBER;
  v_blob BLOB; l_json CLOB;
  l_do NUMBER := 1; l_so NUMBER := 1; l_lc NUMBER := DBMS_LOB.DEFAULT_LANG_CTX; l_w NUMBER;
  FUNCTION clean_html(p CLOB) RETURN CLOB IS
    l CLOB := p;
  BEGIN
    IF l IS NULL THEN RETURN NULL; END IF;
    l := REGEXP_REPLACE(l, '<script.*?</script[^>]*>', '', 1, 0, 'in');
    l := REGEXP_REPLACE(l, '\son[a-z]+\s*=\s*"[^"]*"', '', 1, 0, 'i');
    l := REGEXP_REPLACE(l, '\son[a-z]+\s*=\s*''[^'']*''', '', 1, 0, 'i');
    l := REGEXP_REPLACE(l, 'javascript[COLON]', '', 1, 0, 'i');
    RETURN l;
  END;
BEGIN
  v_blob := [COLON]body;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_TERMS', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_TERMS required'); RETURN;
  END IF;
  -- full-CLOB body parse: dct_rest.parse_body caps at 32,767 bytes and the
  -- rich-text content must never be length-limited (PAY bulk pattern)
  IF v_blob IS NULL OR DBMS_LOB.GETLENGTH(v_blob) = 0 THEN
    dct_rest.err(400,'Request body is required'); RETURN;
  END IF;
  DBMS_LOB.CREATETEMPORARY(l_json, TRUE);
  DBMS_LOB.CONVERTTOCLOB(l_json, v_blob, DBMS_LOB.LOBMAXSIZE, l_do, l_so, DBMS_LOB.DEFAULT_CSID, l_lc, l_w);
  APEX_JSON.parse(l_json);
  l_title  := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'title')), 1, 200);
  l_app    := APEX_JSON.get_varchar2(p_path=>'appliedTo');
  l_status := NVL(APEX_JSON.get_varchar2(p_path=>'status'), 'ACTIVE');
  l_sd     := APEX_JSON.get_varchar2(p_path=>'startDate');
  l_ed     := APEX_JSON.get_varchar2(p_path=>'endDate');
  l_html   := clean_html(APEX_JSON.get_clob(p_path=>'contentHtml'));
  IF l_title IS NULL THEN dct_rest.err(400,'title is required'); RETURN; END IF;
  IF l_sd IS NULL OR NOT REGEXP_LIKE(l_sd, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN
    dct_rest.err(400,'startDate is required (YYYY-MM-DD)'); RETURN;
  END IF;
  IF l_ed IS NOT NULL AND NOT REGEXP_LIKE(l_ed, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN
    dct_rest.err(400,'endDate must be YYYY-MM-DD'); RETURN;
  END IF;
  SELECT COUNT(*) INTO v FROM prod.dct_lookup_values lv
    JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id
   WHERE lc.category_code = 'GL_TERMS_APPLIED_TO' AND lv.value_code = l_app AND lv.is_active = 'Y';
  IF v = 0 THEN dct_rest.err(400,'appliedTo is not a valid GL_TERMS_APPLIED_TO lookup value'); RETURN; END IF;
  SELECT COUNT(*) INTO v FROM prod.dct_lookup_values lv
    JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id
   WHERE lc.category_code = 'GL_TERMS_STATUS' AND lv.value_code = l_status AND lv.is_active = 'Y';
  IF v = 0 THEN dct_rest.err(400,'status is not a valid GL_TERMS_STATUS lookup value'); RETURN; END IF;
  IF l_ed IS NOT NULL AND TO_DATE(l_ed,'YYYY-MM-DD') < TO_DATE(l_sd,'YYYY-MM-DD') THEN
    dct_rest.err(400,'endDate must be on or after startDate'); RETURN;
  END IF;
  INSERT INTO dct_gl_report_terms
    (title, applied_to, content_html, start_date, end_date, status, created_by)
  VALUES
    (l_title, l_app, l_html, TO_DATE(l_sd,'YYYY-MM-DD'),
     CASE WHEN l_ed IS NULL THEN NULL ELSE TO_DATE(l_ed,'YYYY-MM-DD') END,
     l_status, l_user)
  RETURNING term_id INTO l_id;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('termId', l_id);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('terms/[COLON]id');
    def_handler('terms/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL access required'); RETURN;
  END IF;
  FOR c IN (SELECT t.term_id, t.title, t.applied_to, t.content_html,
                   TO_CHAR(t.start_date, 'YYYY-MM-DD') AS start_d,
                   TO_CHAR(t.end_date, 'YYYY-MM-DD')   AS end_d,
                   t.status, t.created_by,
                   TO_CHAR(dct_to_local(t.created_at),'YYYY-MM-DD HH[COLON]MI AM') AS created_d,
                   t.updated_by,
                   TO_CHAR(dct_to_local(t.updated_at),'YYYY-MM-DD HH[COLON]MI AM') AS updated_d
              FROM dct_gl_report_terms t
             WHERE t.term_id = [COLON]id) LOOP
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('termId', c.term_id);
    APEX_JSON.write('title', c.title);
    APEX_JSON.write('appliedTo', c.applied_to);
    APEX_JSON.write('startDate', c.start_d);
    APEX_JSON.write('endDate', NVL(c.end_d, ''));
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('contentHtml', c.content_html);
    APEX_JSON.write('createdBy', c.created_by);
    APEX_JSON.write('createdAt', NVL(c.created_d, ''));
    APEX_JSON.write('updatedBy', NVL(c.updated_by, ''));
    APEX_JSON.write('updatedAt', NVL(c.updated_d, ''));
    APEX_JSON.close_object;
    RETURN;
  END LOOP;
  dct_rest.err(404,'Term document not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('terms/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_title VARCHAR2(200); l_app VARCHAR2(50); l_status VARCHAR2(20);
  l_sd VARCHAR2(20); l_ed VARCHAR2(20); l_html CLOB; v NUMBER;
  l_hh VARCHAR2(1) := 'N';
  v_blob BLOB; l_json CLOB;
  l_do NUMBER := 1; l_so NUMBER := 1; l_lc NUMBER := DBMS_LOB.DEFAULT_LANG_CTX; l_w NUMBER;
  l_cur dct_gl_report_terms%ROWTYPE;
  FUNCTION clean_html(p CLOB) RETURN CLOB IS
    l CLOB := p;
  BEGIN
    IF l IS NULL THEN RETURN NULL; END IF;
    l := REGEXP_REPLACE(l, '<script.*?</script[^>]*>', '', 1, 0, 'in');
    l := REGEXP_REPLACE(l, '\son[a-z]+\s*=\s*"[^"]*"', '', 1, 0, 'i');
    l := REGEXP_REPLACE(l, '\son[a-z]+\s*=\s*''[^'']*''', '', 1, 0, 'i');
    l := REGEXP_REPLACE(l, 'javascript[COLON]', '', 1, 0, 'i');
    RETURN l;
  END;
BEGIN
  v_blob := [COLON]body;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_TERMS', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_TERMS required'); RETURN;
  END IF;
  BEGIN
    SELECT * INTO l_cur FROM dct_gl_report_terms WHERE term_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Term document not found'); RETURN; END;
  -- full-CLOB body parse: dct_rest.parse_body caps at 32,767 bytes and the
  -- rich-text content must never be length-limited (PAY bulk pattern)
  IF v_blob IS NULL OR DBMS_LOB.GETLENGTH(v_blob) = 0 THEN
    dct_rest.err(400,'Request body is required'); RETURN;
  END IF;
  DBMS_LOB.CREATETEMPORARY(l_json, TRUE);
  DBMS_LOB.CONVERTTOCLOB(l_json, v_blob, DBMS_LOB.LOBMAXSIZE, l_do, l_so, DBMS_LOB.DEFAULT_CSID, l_lc, l_w);
  APEX_JSON.parse(l_json);
  l_title  := CASE WHEN APEX_JSON.does_exist(p_path=>'title')
                   THEN SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'title')), 1, 200)
                   ELSE l_cur.title END;
  l_app    := CASE WHEN APEX_JSON.does_exist(p_path=>'appliedTo')
                   THEN APEX_JSON.get_varchar2(p_path=>'appliedTo') ELSE l_cur.applied_to END;
  l_status := CASE WHEN APEX_JSON.does_exist(p_path=>'status')
                   THEN APEX_JSON.get_varchar2(p_path=>'status') ELSE l_cur.status END;
  l_sd     := CASE WHEN APEX_JSON.does_exist(p_path=>'startDate')
                   THEN APEX_JSON.get_varchar2(p_path=>'startDate')
                   ELSE TO_CHAR(l_cur.start_date,'YYYY-MM-DD') END;
  l_ed     := CASE WHEN APEX_JSON.does_exist(p_path=>'endDate')
                   THEN APEX_JSON.get_varchar2(p_path=>'endDate')
                   ELSE TO_CHAR(l_cur.end_date,'YYYY-MM-DD') END;
  IF l_title IS NULL THEN dct_rest.err(400,'title is required'); RETURN; END IF;
  IF l_sd IS NULL OR NOT REGEXP_LIKE(l_sd, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN
    dct_rest.err(400,'startDate is required (YYYY-MM-DD)'); RETURN;
  END IF;
  IF l_ed IS NOT NULL AND NOT REGEXP_LIKE(l_ed, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN
    dct_rest.err(400,'endDate must be YYYY-MM-DD'); RETURN;
  END IF;
  SELECT COUNT(*) INTO v FROM prod.dct_lookup_values lv
    JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id
   WHERE lc.category_code = 'GL_TERMS_APPLIED_TO' AND lv.value_code = l_app AND lv.is_active = 'Y';
  IF v = 0 THEN dct_rest.err(400,'appliedTo is not a valid GL_TERMS_APPLIED_TO lookup value'); RETURN; END IF;
  SELECT COUNT(*) INTO v FROM prod.dct_lookup_values lv
    JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id
   WHERE lc.category_code = 'GL_TERMS_STATUS' AND lv.value_code = l_status AND lv.is_active = 'Y';
  IF v = 0 THEN dct_rest.err(400,'status is not a valid GL_TERMS_STATUS lookup value'); RETURN; END IF;
  IF l_ed IS NOT NULL AND TO_DATE(l_ed,'YYYY-MM-DD') < TO_DATE(l_sd,'YYYY-MM-DD') THEN
    dct_rest.err(400,'endDate must be on or after startDate'); RETURN;
  END IF;
  -- content is resolved in PL/SQL: a block-local function (clean_html) inside
  -- the SQL UPDATE is invisible to SQL DML = compile error = uncatchable 555
  IF APEX_JSON.does_exist(p_path=>'contentHtml') THEN
    l_hh := 'Y';
    l_html := clean_html(APEX_JSON.get_clob(p_path=>'contentHtml'));
  END IF;
  UPDATE dct_gl_report_terms
     SET title        = l_title,
         applied_to   = l_app,
         status       = l_status,
         start_date   = TO_DATE(l_sd,'YYYY-MM-DD'),
         end_date     = CASE WHEN l_ed IS NULL THEN NULL ELSE TO_DATE(l_ed,'YYYY-MM-DD') END,
         content_html = CASE WHEN l_hh = 'Y' THEN l_html ELSE content_html END,
         updated_by   = l_user,
         updated_at   = SYSTIMESTAMP
   WHERE term_id = [COLON]id;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('termId', TO_NUMBER([COLON]id));
  APEX_JSON.write('updated', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('terms/[COLON]id', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_TERMS', 'SYS_ADMIN', 'GL') = FALSE THEN
    dct_rest.err(403,'GL_MANAGE_TERMS required'); RETURN;
  END IF;
  DELETE FROM dct_gl_report_terms WHERE term_id = [COLON]id;
  IF SQL%ROWCOUNT = 0 THEN ROLLBACK; dct_rest.err(404,'Term document not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('deleted', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('terms/meta/caps');
    def_handler('terms/meta/caps', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('canManage',
    CASE WHEN prod.dct_sec.has_priv_or_role(l_user, 'GL_MANAGE_TERMS', 'SYS_ADMIN', 'GL') THEN 'Y' ELSE 'N' END);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('terms/meta/lookups');
    def_handler('terms/meta/lookups', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL access required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('appliedTo');
  FOR c IN (SELECT lv.value_code, lv.value_name_en, lv.value_name_ar
              FROM prod.dct_lookup_values lv
              JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id
             WHERE lc.category_code = 'GL_TERMS_APPLIED_TO' AND lv.is_active = 'Y'
             ORDER BY lv.display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', c.value_code);
    APEX_JSON.write('name', c.value_name_en);
    APEX_JSON.write('nameAr', NVL(c.value_name_ar, c.value_name_en));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('statuses');
  FOR c IN (SELECT lv.value_code, lv.value_name_en, lv.value_name_ar
              FROM prod.dct_lookup_values lv
              JOIN prod.dct_lookup_categories lc ON lc.category_id = lv.category_id
             WHERE lc.category_code = 'GL_TERMS_STATUS' AND lv.is_active = 'Y'
             ORDER BY lv.display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', c.value_code);
    APEX_JSON.write('name', c.value_name_en);
    APEX_JSON.write('nameAr', NVL(c.value_name_ar, c.value_name_en));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END;
/

BEGIN
    setup_gl_terms_ords_tmp;
    COMMIT;
END;
/
DROP PROCEDURE setup_gl_terms_ords_tmp;

PROMPT === verify ===
SELECT t.uri_template, h.method
FROM user_ords_handlers h
JOIN user_ords_templates t ON t.id = h.template_id
JOIN user_ords_modules m  ON m.id = t.module_id
WHERE m.name = 'gl.rest'
  AND t.uri_template LIKE 'terms%'
ORDER BY t.uri_template, h.method;

PROMPT gl.rest Terms and Key definitions routes published (/gl/terms).
