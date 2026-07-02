-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 13a Interactive Report LOV ORDS (ADDITIVE)
-- File   : reporting/db/13a_rpt_ir_lov_ords.sql
-- Adds to: rpt.rest (does NOT delete/redefine the module)
-- Run as : sql -name prod_mcp   (fresh session). If 04_rpt_ords.sql is ever
--          re-run, re-run 08b + 09a + 10 + 12b + THIS script after it (this
--          one AFTER 12b -- it redefines the ir/catalog handler from 12b).
-- Gate   : BI_USER or SYS_ADMIN (matches the other ir/* handlers).
-- Endpoints:
--   GET ir/catalog                    REDEFINED: adds lovParams[] per definition
--                                     (keys of PARAMS_LOV_JSON, lower-cased)
--   GET ir/reports/:code/lov?param=x  dropdown values for one run parameter
--                                     via dct_rpt_ir_pkg.run_lov (bind-free
--                                     query, capped 500 rows)
-- Zero blank lines inside statements; each statement kept small.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. GET ir/catalog (redefined: + lovParams) ===
BEGIN
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'ir/catalog', p_method => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_spec JSON_OBJECT_T;
  l_keys JSON_KEY_LIST;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'BI_USER') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'BI access required'); RETURN;
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR c IN (
    SELECT report_code, name_en, name_ar, category, description, source_type,
           params_json, params_lov_json
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
    IF c.params_lov_json IS NOT NULL THEN
      BEGIN
        l_spec := JSON_OBJECT_T.parse(c.params_lov_json);
        l_keys := l_spec.get_keys;
        APEX_JSON.open_array('lovParams');
        FOR i IN 1 .. l_keys.COUNT LOOP
          APEX_JSON.write(LOWER(l_keys(i)));
        END LOOP;
        APEX_JSON.close_array;
      EXCEPTION WHEN OTHERS THEN NULL;
      END;
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

PROMPT === 2. GET ir/reports/:code/lov ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest', p_pattern => 'ir/reports/' || CHR(58) || 'code/lov');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest', p_pattern => 'ir/reports/' || CHR(58) || 'code/lov', p_method => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT (dct_auth.has_role(l_user,'BI_USER') OR dct_auth.has_role(l_user,'SYS_ADMIN')) THEN
    dct_rest.err(403,'BI access required'); RETURN;
  END IF;
  dct_rpt_ir_pkg.run_lov(
    p_report_code => [COLON]code,
    p_param       => [COLON]param,
    p_max_rows    => 500);
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

PROMPT ============================================================
PROMPT  13a_rpt_ir_lov_ords.sql complete (catalog + lov handler).
PROMPT ============================================================
