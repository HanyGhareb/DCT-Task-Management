-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 12b Interactive Report ORDS (ADDITIVE)
-- File   : reporting/db/12b_rpt_ir_ords.sql
-- Adds to: rpt.rest (does NOT delete/redefine the module)
-- Run as : sql -name prod_mcp   (fresh session). If 04_rpt_ords.sql is ever
--          re-run, re-run THIS script after it (04 DELETE_MODULEs rpt.rest),
--          together with 08b, 09a, 10 and 13a.
-- Gate   : BI_USER or SYS_ADMIN on every endpoint (business-user surface).
-- Endpoints:
--   GET    ir/catalog                 runnable definitions for the viewer
--                                     (enabled only; + MULTI sections + required)
--   POST   ir/reports/:code/data     one-shot capped data fetch (body:
--                                     {section?, params?}) via dct_rpt_ir_pkg
--   GET    ir/reports/:code/layouts  own + shared saved layouts
--   POST   ir/layouts                save a layout (name unique per owner+report)
--   PUT    ir/layouts/:id            rename / re-share / set default / new json
--   DELETE ir/layouts/:id            owner or admin only
-- Zero blank lines inside statements; each statement kept small.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. GET ir/catalog ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest', p_pattern => 'ir/catalog');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'ir/catalog', p_method => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'BI_USER') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'BI access required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR c IN (
    SELECT report_code, name_en, name_ar, category, description, source_type, params_json
      FROM dct_rpt_definition
     WHERE enabled = 'Y'
     ORDER BY category, name_en
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('reportCode', c.report_code);
    APEX_JSON.write('nameEn', c.name_en);
    APEX_JSON.write('nameAr', NVL(c.name_ar,''));
    APEX_JSON.write('category', NVL(c.category,''));
    APEX_JSON.write('description', NVL(c.description,''));
    APEX_JSON.write('sourceType', c.source_type);
    IF c.params_json IS NOT NULL THEN
      APEX_JSON.write('paramsJson', c.params_json);
    END IF;
    IF c.source_type = 'MULTI' THEN
      BEGIN
        APEX_JSON.open_array('sections');
        FOR s IN (
          SELECT jt.skey, jt.stitle
            FROM dct_rpt_definition d,
                 JSON_TABLE(d.source_ref, '$.sections[*]'
                   COLUMNS (skey VARCHAR2(60) PATH '$.key',
                            stitle VARCHAR2(200) PATH '$.title')) jt
           WHERE d.report_code = c.report_code
        ) LOOP
          APEX_JSON.open_object;
          APEX_JSON.write('key', s.skey);
          APEX_JSON.write('title', NVL(s.stitle, s.skey));
          APEX_JSON.close_object;
        END LOOP;
        APEX_JSON.close_array;
        APEX_JSON.open_array('requiredParams');
        FOR r IN (
          SELECT jt.rname
            FROM dct_rpt_definition d,
                 JSON_TABLE(d.source_ref, '$.required[*]'
                   COLUMNS (rname VARCHAR2(128) PATH '$')) jt
           WHERE d.report_code = c.report_code
        ) LOOP
          APEX_JSON.write(r.rname);
        END LOOP;
        APEX_JSON.close_array;
      EXCEPTION WHEN OTHERS THEN NULL;
      END;
    END IF;
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

PROMPT === 2. POST ir/reports/:code/data ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest', p_pattern => 'ir/reports/' || CHR(58) || 'code/data');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'ir/reports/' || CHR(58) || 'code/data', p_method => 'POST',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_body    BLOB := [COLON]body;
  l_json    CLOB;
  l_ok      NUMBER;
  l_section VARCHAR2(60);
  l_params  CLOB;
  l_max     NUMBER;
  l_doff    INTEGER := 1; l_soff INTEGER := 1; l_lang INTEGER := 0; l_warn INTEGER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'BI_USER') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'BI access required'); RETURN;
  END IF;
  IF l_body IS NOT NULL AND DBMS_LOB.GETLENGTH(l_body) > 2 THEN
    DBMS_LOB.CREATETEMPORARY(l_json, TRUE);
    DBMS_LOB.CONVERTTOCLOB(l_json, l_body, DBMS_LOB.LOBMAXSIZE, l_doff, l_soff,
                           DBMS_LOB.DEFAULT_CSID, l_lang, l_warn);
    SELECT COUNT(*) INTO l_ok FROM dual WHERE l_json IS JSON;
    IF l_ok = 0 THEN dct_rest.err(400,'Body must be a JSON object'); RETURN; END IF;
    l_section := JSON_VALUE(l_json, '$.section');
    l_params  := JSON_QUERY(l_json, '$.params');
  END IF;
  BEGIN
    SELECT TO_NUMBER(config_value DEFAULT NULL ON CONVERSION ERROR)
      INTO l_max FROM dct_rpt_config WHERE config_key = 'IR_MAX_ROWS';
  EXCEPTION WHEN NO_DATA_FOUND THEN l_max := NULL;
  END;
  dct_rpt_ir_pkg.run_report(
    p_report_code => [COLON]code,
    p_section     => l_section,
    p_params_json => l_params,
    p_max_rows    => NVL(l_max, 10000));
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = -20404 THEN dct_rest.err(404, 'Report not found');
    ELSIF SQLCODE IN (-20001, -20090) THEN dct_rest.err(400, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM);
    END IF;
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT === 3. GET ir/reports/:code/layouts ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest', p_pattern => 'ir/reports/' || CHR(58) || 'code/layouts');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'ir/reports/' || CHR(58) || 'code/layouts', p_method => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'BI_USER') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'BI access required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR c IN (
    SELECT layout_id, layout_name, owner_username, is_shared, is_default, layout_json, updated_at
      FROM dct_rpt_ir_layout
     WHERE report_code = [COLON]code
       AND (owner_username = l_user OR is_shared = 'Y')
     ORDER BY CASE WHEN owner_username = l_user THEN 0 ELSE 1 END, LOWER(layout_name)
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('layoutId', c.layout_id);
    APEX_JSON.write('layoutName', c.layout_name);
    APEX_JSON.write('owner', c.owner_username);
    APEX_JSON.write('isMine', CASE WHEN c.owner_username = l_user THEN 'Y' ELSE 'N' END);
    APEX_JSON.write('isShared', c.is_shared);
    APEX_JSON.write('isDefault', c.is_default);
    APEX_JSON.write('layoutJson', c.layout_json);
    APEX_JSON.write('updatedAt', TO_CHAR(dct_to_local(c.updated_at),'YYYY-MM-DD HH:MI AM'));
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

PROMPT === 4. POST ir/layouts ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest', p_pattern => 'ir/layouts');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'ir/layouts', p_method => 'POST',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_code    VARCHAR2(60);
  l_name    VARCHAR2(120);
  l_shared  VARCHAR2(1);
  l_default VARCHAR2(1);
  l_json    CLOB;
  l_ok      NUMBER;
  l_id      NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'BI_USER') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'BI access required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_code    := APEX_JSON.get_varchar2(p_path=>'reportCode');
  l_name    := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'layoutName')),1,120);
  l_shared  := NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'isShared')),'N');
  l_default := NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'isDefault')),'N');
  l_json    := APEX_JSON.get_clob(p_path=>'layoutJson');
  IF l_code IS NULL OR l_name IS NULL OR l_json IS NULL THEN
    dct_rest.err(400,'reportCode, layoutName and layoutJson are required'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_ok FROM dct_rpt_definition WHERE report_code = l_code;
  IF l_ok = 0 THEN dct_rest.err(404,'Report not found'); RETURN; END IF;
  SELECT COUNT(*) INTO l_ok FROM dual WHERE l_json IS JSON;
  IF l_ok = 0 THEN dct_rest.err(400,'layoutJson must be valid JSON'); RETURN; END IF;
  IF l_shared NOT IN ('Y','N') OR l_default NOT IN ('Y','N') THEN
    dct_rest.err(400,'isShared and isDefault must be Y or N'); RETURN;
  END IF;
  IF l_shared = 'Y' AND NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN
    dct_rest.err(403,'Only administrators can share layouts'); RETURN;
  END IF;
  IF l_default = 'Y' THEN
    UPDATE dct_rpt_ir_layout SET is_default = 'N', updated_by = l_user, updated_at = SYSTIMESTAMP
     WHERE report_code = l_code AND owner_username = l_user AND is_default = 'Y';
  END IF;
  INSERT INTO dct_rpt_ir_layout
    (report_code, layout_name, owner_username, is_shared, is_default, layout_json, created_by, updated_by)
  VALUES (l_code, l_name, l_user, l_shared, l_default, l_json, l_user, l_user)
  RETURNING layout_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('layoutId', l_id); APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(409,'A layout with this name already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT === 5. PUT + DELETE ir/layouts/:id ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest', p_pattern => 'ir/layouts/' || CHR(58) || 'id');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'ir/layouts/' || CHR(58) || 'id', p_method => 'PUT',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_row   dct_rpt_ir_layout%ROWTYPE;
  l_adm   BOOLEAN;
  l_val   VARCHAR2(120);
  l_json  CLOB;
  l_ok    NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'BI_USER') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'BI access required'); RETURN;
  END IF;
  l_adm := dct_auth.has_role(l_user,'SYS_ADMIN');
  BEGIN
    SELECT * INTO l_row FROM dct_rpt_ir_layout WHERE layout_id = TO_NUMBER([COLON]id);
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Layout not found'); RETURN;
  END;
  IF l_row.owner_username <> l_user AND NOT l_adm THEN
    dct_rest.err(404,'Layout not found'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  IF APEX_JSON.does_exist(p_path=>'layoutName') THEN
    l_val := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'layoutName')),1,120);
    IF l_val IS NULL THEN dct_rest.err(400,'layoutName cannot be empty'); RETURN; END IF;
    l_row.layout_name := l_val;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'isShared') THEN
    l_val := NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'isShared')),'N');
    IF l_val NOT IN ('Y','N') THEN dct_rest.err(400,'isShared must be Y or N'); RETURN; END IF;
    IF l_val = 'Y' AND NOT l_adm THEN dct_rest.err(403,'Only administrators can share layouts'); RETURN; END IF;
    l_row.is_shared := l_val;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'isDefault') THEN
    l_val := NVL(UPPER(APEX_JSON.get_varchar2(p_path=>'isDefault')),'N');
    IF l_val NOT IN ('Y','N') THEN dct_rest.err(400,'isDefault must be Y or N'); RETURN; END IF;
    l_row.is_default := l_val;
  END IF;
  IF APEX_JSON.does_exist(p_path=>'layoutJson') THEN
    l_json := APEX_JSON.get_clob(p_path=>'layoutJson');
    SELECT COUNT(*) INTO l_ok FROM dual WHERE l_json IS JSON;
    IF l_ok = 0 THEN dct_rest.err(400,'layoutJson must be valid JSON'); RETURN; END IF;
    l_row.layout_json := l_json;
  END IF;
  IF l_row.is_default = 'Y' THEN
    UPDATE dct_rpt_ir_layout SET is_default = 'N', updated_by = l_user, updated_at = SYSTIMESTAMP
     WHERE report_code = l_row.report_code AND owner_username = l_row.owner_username
       AND is_default = 'Y' AND layout_id <> l_row.layout_id;
  END IF;
  UPDATE dct_rpt_ir_layout
     SET layout_name = l_row.layout_name,
         is_shared   = l_row.is_shared,
         is_default  = l_row.is_default,
         layout_json = l_row.layout_json,
         updated_by  = l_user,
         updated_at  = SYSTIMESTAMP
   WHERE layout_id = l_row.layout_id;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK; dct_rest.err(409,'A layout with this name already exists');
  WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'ir/layouts/' || CHR(58) || 'id', p_method => 'DELETE',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_adm  BOOLEAN;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'BI_USER') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'BI access required'); RETURN;
  END IF;
  l_adm := dct_auth.has_role(l_user,'SYS_ADMIN');
  IF l_adm THEN
    DELETE FROM dct_rpt_ir_layout WHERE layout_id = TO_NUMBER([COLON]id);
  ELSE
    DELETE FROM dct_rpt_ir_layout WHERE layout_id = TO_NUMBER([COLON]id) AND owner_username = l_user;
  END IF;
  IF SQL%ROWCOUNT = 0 THEN dct_rest.err(404,'Layout not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT ============================================================
PROMPT  12b_rpt_ir_ords.sql complete (6 ir/* handlers).
PROMPT ============================================================
