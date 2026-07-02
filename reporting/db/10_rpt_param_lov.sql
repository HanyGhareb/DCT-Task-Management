-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 10 run-parameter spec + LOV endpoint
-- File   : reporting/db/10_rpt_param_lov.sql
-- Adds to: rpt.rest (ADDITIVE -- does NOT delete/redefine the module)
-- Run as : sql -name prod_mcp   (fresh session). If 04_rpt_ords.sql is ever
--          re-run, re-run THIS script after it (04 DELETE_MODULEs rpt.rest).
-- What it does:
--   1. New column PROD.DCT_RPT_DEFINITION.PARAM_SPEC_JSON -- optional UI
--      metadata per run parameter (kept SEPARATE from PARAMS_JSON so the
--      runtime defaults stay a flat object the runner binds directly):
--        { "<param>": { "label", "label_ar", "hint", "hint_ar",
--                       "required": true|false, "lov_sql": "SELECT one_col ..." } }
--      lov_sql runs as ADMIN -- reference PROD objects with the prod. prefix.
--   2. GET /rpt/reports/:code/params -- returns the param list with labels,
--      hints, required flags and LOV values (each lov_sql executed, max 500
--      rows) for the Run Parameters drawer.
--   3. Seeds the spec for BUDGET_UTIL_SECTOR (LOVs from DCT_BUTIL_SCOPE_V).
-- Zero blank lines inside statements; each statement kept small (SQLcl 26.1
-- swallows ~10KB blocks). CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. PARAM_SPEC_JSON column (additive, rerunnable) ===
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_rpt_definition ADD (param_spec_json CLOB)';
  DBMS_OUTPUT.PUT_LINE('column added');
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = -1430 THEN DBMS_OUTPUT.PUT_LINE('column already exists');
    ELSE RAISE; END IF;
END;
/

PROMPT === 2. GET /rpt/reports/:code/params ===
BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name => 'rpt.rest',
                       p_pattern     => 'reports/' || CHR(58) || 'code/params');
  ORDS.DEFINE_HANDLER(
    p_module_name => 'rpt.rest',
    p_pattern     => 'reports/' || CHR(58) || 'code/params',
    p_method      => 'GET',
    p_source_type => ORDS.source_type_plsql,
    p_source      => REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_code VARCHAR2(80) := UPPER([COLON]code);
  l_defaults CLOB; l_spec CLOB;
  l_def JSON_OBJECT_T; l_sp JSON_OBJECT_T; l_m JSON_OBJECT_T;
  l_keys JSON_KEY_LIST;
  l_cur SYS_REFCURSOR; l_v VARCHAR2(4000); l_n PLS_INTEGER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  BEGIN
    SELECT params_json, param_spec_json INTO l_defaults, l_spec
      FROM dct_rpt_definition WHERE report_code = l_code;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Report not found'); RETURN;
  END;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('params');
  IF l_defaults IS NOT NULL THEN
    l_def := JSON_OBJECT_T.parse(l_defaults);
    IF l_spec IS NOT NULL THEN l_sp := JSON_OBJECT_T.parse(l_spec);
    ELSE l_sp := JSON_OBJECT_T(); END IF;
    l_keys := l_def.get_keys;
    FOR i IN 1 .. l_keys.COUNT LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('name', l_keys(i));
      IF l_sp.has(l_keys(i)) AND l_sp.get(l_keys(i)).is_object THEN
        l_m := TREAT(l_sp.get(l_keys(i)) AS JSON_OBJECT_T);
        APEX_JSON.write('label',   NVL(l_m.get_string('label'), l_keys(i)));
        APEX_JSON.write('labelAr', NVL(l_m.get_string('label_ar'), ''));
        APEX_JSON.write('hint',    NVL(l_m.get_string('hint'), ''));
        APEX_JSON.write('hintAr',  NVL(l_m.get_string('hint_ar'), ''));
        APEX_JSON.write('required', NVL(l_m.get_boolean('required'), FALSE));
        IF l_m.get_string('lov_sql') IS NOT NULL THEN
          APEX_JSON.open_array('lov');
          l_n := 0;
          OPEN l_cur FOR l_m.get_string('lov_sql');
          LOOP
            FETCH l_cur INTO l_v;
            EXIT WHEN l_cur%NOTFOUND OR l_n >= 500;
            APEX_JSON.write(l_v);
            l_n := l_n + 1;
          END LOOP;
          CLOSE l_cur;
          APEX_JSON.close_array;
        END IF;
      ELSE
        APEX_JSON.write('label', l_keys(i));
        APEX_JSON.write('required', FALSE);
      END IF;
      APEX_JSON.close_object;
    END LOOP;
  END IF;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    IF l_cur%ISOPEN THEN CLOSE l_cur; END IF;
    dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));
  COMMIT;
END;
/

PROMPT === 3. BUDGET_UTIL_SECTOR parameter spec (labels + hints + LOVs) ===
UPDATE prod.dct_rpt_definition
   SET param_spec_json =
       '{"year":{"label":"Budget Year","label_ar":"'
    || UNISTR('\0633\0646\0629\0020\0627\0644\0645\064A\0632\0627\0646\064A\0629')
    || '","hint":"Required. The budget year the report covers (e.g. 2026).","hint_ar":"'
    || UNISTR('\0625\0644\0632\0627\0645\064A\0020\2014\0020\0633\0646\0629\0020\0627\0644\0645\064A\0632\0627\0646\064A\0629\0020\0627\0644\062A\064A\0020\064A\063A\0637\064A\0647\0627\0020\0627\0644\062A\0642\0631\064A\0631\0020\0028\0645\062B\0627\0644\0020\0032\0030\0032\0036\0029\002E')
    || '","required":true,"lov_sql":"SELECT DISTINCT TO_CHAR(budget_year) FROM prod.dct_butil_scope_v WHERE budget_year IS NOT NULL ORDER BY 1 DESC"},'
    || '"sector":{"label":"Sector","label_ar":"'
    || UNISTR('\0627\0644\0642\0637\0627\0639')
    || '","hint":"Required. The sector the report is generated for.","hint_ar":"'
    || UNISTR('\0625\0644\0632\0627\0645\064A\0020\2014\0020\0627\0644\0642\0637\0627\0639\0020\0627\0644\0630\064A\0020\064A\064F\0639\062F\0020\0627\0644\062A\0642\0631\064A\0631\0020\0644\0647\002E')
    || '","required":true,"lov_sql":"SELECT DISTINCT sector FROM prod.dct_butil_scope_v WHERE sector IS NOT NULL ORDER BY 1"},'
    || '"projecttype":{"label":"Project Type","label_ar":"'
    || UNISTR('\0646\0648\0639\0020\0627\0644\0645\0634\0631\0648\0639')
    || '","hint":"Optional. Filter to one project type; leave empty to include all types.","hint_ar":"'
    || UNISTR('\0627\062E\062A\064A\0627\0631\064A\0020\2014\0020\062A\0635\0641\064A\0629\0020\062D\0633\0628\0020\0646\0648\0639\0020\0627\0644\0645\0634\0631\0648\0639\061B\0020\0627\062A\0631\0643\0647\0020\0641\0627\0631\063A\0627\064B\0020\0644\062A\0636\0645\064A\0646\0020\062C\0645\064A\0639\0020\0627\0644\0623\0646\0648\0627\0639\002E')
    || '","required":false,"lov_sql":"SELECT DISTINCT project_type FROM prod.dct_butil_scope_v WHERE project_type IS NOT NULL ORDER BY 1"},'
    || '"costcenter":{"label":"Cost Center","label_ar":"'
    || UNISTR('\0645\0631\0643\0632\0020\0627\0644\062A\0643\0644\0641\0629')
    || '","hint":"Optional. Filter to one cost center; leave empty to include all cost centers.","hint_ar":"'
    || UNISTR('\0627\062E\062A\064A\0627\0631\064A\0020\2014\0020\062A\0635\0641\064A\0629\0020\062D\0633\0628\0020\0645\0631\0643\0632\0020\0627\0644\062A\0643\0644\0641\0629\061B\0020\0627\062A\0631\0643\0647\0020\0641\0627\0631\063A\0627\064B\0020\0644\062A\0636\0645\064A\0646\0020\062C\0645\064A\0639\0020\0627\0644\0645\0631\0627\0643\0632\002E')
    || '","required":false,"lov_sql":"SELECT DISTINCT cost_centre FROM prod.dct_butil_scope_v WHERE cost_centre IS NOT NULL ORDER BY 1"}}'
 WHERE report_code = 'BUDGET_UTIL_SECTOR';

COMMIT;

PROMPT === 4. verify ===
SELECT report_code,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok,
       DBMS_LOB.GETLENGTH(param_spec_json) AS spec_len
  FROM prod.dct_rpt_definition
 WHERE report_code = 'BUDGET_UTIL_SECTOR';

PROMPT 10_rpt_param_lov.sql complete.
