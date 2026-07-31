-- 113_dct_wf_cascade_api.sql
-- Additive wf.rest routes for the approval-matrix cascade (db/v2/112).
--   GET  assign/priority   WF_ADMIN   default + per-role level orders + types
--   PUT  assign/priority   WF_ADMIN   replace one scope's ordered list
--   POST assign/import     WF_ADMIN   matrix rows: mode=dryrun|apply
-- Re-run after any 67 re-run, after 96/97/98.
-- Deploy in a FRESH ADMIN SQLcl session (sql -name prod_mcp).
SET DEFINE OFF
SET SQLBLANKLINES ON

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>'assign/priority');
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/priority',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql, p_items_per_page=>0, p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_last VARCHAR2(100) := '#none#';
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('defaultLevels');
  FOR r IN (SELECT cl.object_type_code FROM dct_wf_cascade_level cl
             WHERE cl.role_code IS NULL AND cl.is_active = 'Y'
             ORDER BY cl.seq) LOOP
    APEX_JSON.write(r.object_type_code);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('overrides');
  FOR r IN (SELECT cl.role_code, cl.object_type_code, cl.seq
              FROM dct_wf_cascade_level cl
             WHERE cl.role_code IS NOT NULL AND cl.is_active = 'Y'
             ORDER BY cl.role_code, cl.seq) LOOP
    IF r.role_code <> l_last THEN
      IF l_last <> '#none#' THEN
        APEX_JSON.close_array; APEX_JSON.close_object;
      END IF;
      APEX_JSON.open_object;
      APEX_JSON.write('roleCode', r.role_code);
      APEX_JSON.open_array('levels');
      l_last := r.role_code;
    END IF;
    APEX_JSON.write(r.object_type_code);
  END LOOP;
  IF l_last <> '#none#' THEN
    APEX_JSON.close_array; APEX_JSON.close_object;
  END IF;
  APEX_JSON.close_array;
  APEX_JSON.open_array('types');
  FOR r IN (SELECT object_type_code, name_en, name_ar, default_fact_path
              FROM dct_wf_object_type WHERE is_active = 'Y'
             ORDER BY display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.object_type_code);
    APEX_JSON.write('nameEn', r.name_en);
    APEX_JSON.write('nameAr', r.name_ar);
    APEX_JSON.write('factPath', r.default_fact_path);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  dct_rest.err(500, SQLERRM);
END;!');
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/priority',
    p_method=>'PUT', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767);
  l_role VARCHAR2(100); l_levels VARCHAR2(1000); l_n PLS_INTEGER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_role := APEX_JSON.get_varchar2(p_path=>'roleCode');
  l_n := NVL(APEX_JSON.get_count(p_path=>'levels'), 0);
  FOR i IN 1 .. l_n LOOP
    l_levels := l_levels || CASE WHEN i > 1 THEN ',' END
                || APEX_JSON.get_varchar2(p_path=>'levels[%d]', p0=>i);
  END LOOP;
  dct_wf_assign.set_priority(l_user, l_role, l_levels);
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('scope', NVL(l_role, 'DEFAULT'));
  APEX_JSON.write('levels', NVL(l_levels, ''));
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
  ELSIF SQLCODE = -20001 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM); END IF;
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>'assign/import');
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'assign/import',
    p_method=>'POST', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_clob CLOB; l_doff INTEGER := 1; l_soff INTEGER := 1;
  l_lang INTEGER := DBMS_LOB.default_lang_ctx; l_warn INTEGER;
  l_mode VARCHAR2(10); l_eff DATE; l_n PLS_INTEGER;
  l_cc VARCHAR2(100); l_role VARCHAR2(100); l_email VARCHAR2(200);
  l_lbl VARCHAR2(300); l_uid NUMBER; l_uname VARCHAR2(200);
  l_status VARCHAR2(20); l_detail VARCHAR2(400); l_cnt NUMBER;
  l_created NUMBER := 0; l_replaced NUMBER := 0; l_skipped NUMBER := 0; l_errors NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  DBMS_LOB.createtemporary(l_clob, TRUE);
  DBMS_LOB.converttoclob(l_clob, [COLON]body, DBMS_LOB.lobmaxsize,
                         l_doff, l_soff, DBMS_LOB.default_csid, l_lang, l_warn);
  APEX_JSON.parse(l_clob);
  l_mode := LOWER(NVL(APEX_JSON.get_varchar2(p_path=>'mode'), 'dryrun'));
  IF l_mode NOT IN ('dryrun','apply') THEN
    dct_rest.err(400,'mode must be dryrun or apply'); RETURN;
  END IF;
  BEGIN
    l_eff := NVL(TO_DATE(APEX_JSON.get_varchar2(p_path=>'effectiveDate'),'YYYY-MM-DD'),
                 TRUNC(SYSDATE));
  EXCEPTION WHEN OTHERS THEN
    dct_rest.err(400,'effectiveDate must be YYYY-MM-DD'); RETURN;
  END;
  l_n := NVL(APEX_JSON.get_count(p_path=>'entries'), 0);
  IF l_n = 0 THEN dct_rest.err(400,'entries is required'); RETURN; END IF;
  IF l_n > 300 THEN dct_rest.err(400,'max 300 entries per request'); RETURN; END IF;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('mode', l_mode);
  APEX_JSON.open_array('results');
  FOR i IN 1 .. l_n LOOP
    l_cc    := TRIM(APEX_JSON.get_varchar2(p_path=>'entries[%d].cc', p0=>i));
    l_role  := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'entries[%d].role', p0=>i)));
    l_email := LOWER(TRIM(APEX_JSON.get_varchar2(p_path=>'entries[%d].email', p0=>i)));
    l_status := NULL; l_detail := NULL; l_uid := NULL; l_uname := NULL; l_lbl := NULL;

    IF l_cc IS NULL OR l_role IS NULL OR l_email IS NULL THEN
      l_status := 'ERROR'; l_detail := 'cc, role and email are all required';
    END IF;

    IF l_status IS NULL THEN
      SELECT COUNT(*) INTO l_cnt FROM dct_roles
       WHERE role_code = l_role AND role_type = 'DATA' AND is_active = 'Y';
      IF l_cnt = 0 THEN
        l_status := 'ERROR'; l_detail := 'unknown or inactive DATA role ' || l_role;
      END IF;
    END IF;

    IF l_status IS NULL THEN
      l_lbl := dct_wf_assign.get_label('COST_CENTER', l_cc);
      IF l_lbl IS NULL THEN
        l_status := 'ERROR'; l_detail := 'cost centre ' || l_cc || ' not found in the chart';
      END IF;
    END IF;

    IF l_status IS NULL THEN
      BEGIN
        SELECT MIN(user_id) INTO l_uid FROM dct_users
         WHERE LOWER(email) = l_email AND is_active = 'Y';
      EXCEPTION WHEN OTHERS THEN l_uid := NULL;
      END;
      IF l_uid IS NULL THEN
        -- W0 decision: unmatched people are REPORTED, never auto-created
        l_status := 'NO_USER'; l_detail := 'no active user with email ' || l_email;
      ELSE
        SELECT display_name INTO l_uname FROM dct_users WHERE user_id = l_uid;
      END IF;
    END IF;

    IF l_status IS NULL THEN
      IF l_mode = 'apply' THEN
        BEGIN
          l_status := dct_wf_assign.matrix_apply(l_user, l_cc, l_role, l_uid, l_eff);
        EXCEPTION WHEN OTHERS THEN
          l_status := 'ERROR'; l_detail := SUBSTR(SQLERRM, 1, 350);
        END;
      ELSE
        -- dry run: predict what apply would do
        SELECT COUNT(*) INTO l_cnt FROM dct_wf_role_assignment
         WHERE object_type_code = 'COST_CENTER'
           AND object_key = dct_wf_assign.canon('COST_CENTER', l_cc)
           AND role_code = l_role AND user_id = l_uid AND is_active = 'Y'
           AND start_date <= l_eff AND (end_date IS NULL OR end_date >= l_eff);
        IF l_cnt > 0 THEN l_status := 'SKIPPED';
        ELSE
          SELECT COUNT(*) INTO l_cnt FROM dct_wf_role_assignment
           WHERE object_type_code = 'COST_CENTER'
             AND object_key = dct_wf_assign.canon('COST_CENTER', l_cc)
             AND role_code = l_role AND user_id <> l_uid AND is_active = 'Y'
             AND start_date <= l_eff AND (end_date IS NULL OR end_date >= l_eff);
          l_status := CASE WHEN l_cnt > 0 THEN 'REPLACED' ELSE 'CREATED' END;
        END IF;
      END IF;
    END IF;

    IF    l_status = 'CREATED'  THEN l_created  := l_created + 1;
    ELSIF l_status = 'REPLACED' THEN l_replaced := l_replaced + 1;
    ELSIF l_status = 'SKIPPED'  THEN l_skipped  := l_skipped + 1;
    ELSE l_errors := l_errors + 1; END IF;

    APEX_JSON.open_object;
    APEX_JSON.write('row',    NVL(APEX_JSON.get_number(p_path=>'entries[%d].row', p0=>i), i));
    APEX_JSON.write('cc',     l_cc);
    APEX_JSON.write('ccLabel', l_lbl);
    APEX_JSON.write('role',   l_role);
    APEX_JSON.write('email',  l_email);
    APEX_JSON.write('userName', l_uname);
    APEX_JSON.write('status', l_status);
    APEX_JSON.write('detail', l_detail);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  IF l_mode = 'apply' THEN COMMIT; END IF;
  APEX_JSON.write('created',  l_created);
  APEX_JSON.write('replaced', l_replaced);
  APEX_JSON.write('skipped',  l_skipped);
  APEX_JSON.write('errors',   l_errors);
  APEX_JSON.close_object;
  DBMS_LOB.freetemporary(l_clob);
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(500, SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

SELECT t.uri_template, h.method
  FROM user_ords_templates t
  JOIN user_ords_handlers h ON h.template_id = t.id
  JOIN user_ords_modules m ON m.id = t.module_id
 WHERE m.name = 'wf.rest'
   AND (t.uri_template LIKE 'assign/priority%' OR t.uri_template LIKE 'assign/import%')
 ORDER BY t.uri_template, h.method;

EXIT
