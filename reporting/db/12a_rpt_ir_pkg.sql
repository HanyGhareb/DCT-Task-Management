-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 12a Interactive Report executor pkg
-- File   : reporting/db/12a_rpt_ir_pkg.sql
-- Schema : PROD package + ADMIN synonym
-- Run as : sql -name prod_mcp   (FRESH session -- synonym rule, ORA-01471)
--          Requires 13_rpt_ir_lov.sql FIRST (run_lov reads params_lov_json).
-- Purpose: runs a report definition's stored source one time with ONLY its
--          declared bind parameters bound (never any user-supplied SQL) and
--          streams the whole JSON envelope the browser grid works on:
--          {reportCode, section?, columns:[{key,label,type}], items:[],
--           total, truncated, maxRows}
-- Rules  : mirror of runner/datasource.py --
--            VIEW  -> source_ref is an object name (asserted), star-query it
--            SQL   -> source_ref text as-is; binds discovered by scan
--            MULTI -> source_ref JSON spec; one section per call; the spec's
--                     required[] names must arrive non-blank (same failure
--                     text as the Python engine)
--          Literals + comments are blanked before the bind scan so formats
--          like 'HH24:MI' never produce phantom binds. First keyword must be
--          a query keyword. Scan copy capped at 32K characters.
--          Domain DATE/TIMESTAMP values are emitted as literal ISO text --
--          deliberately NOT dct_to_local (that helper is for audit stamps).
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. Package spec ===
CREATE OR REPLACE PACKAGE prod.dct_rpt_ir_pkg AS

  PROCEDURE run_report(
    p_report_code IN VARCHAR2,
    p_section     IN VARCHAR2 DEFAULT NULL,
    p_params_json IN CLOB     DEFAULT NULL,
    p_max_rows    IN NUMBER   DEFAULT 10000);

  PROCEDURE run_lov(
    p_report_code IN VARCHAR2,
    p_param       IN VARCHAR2,
    p_max_rows    IN NUMBER   DEFAULT 500);

END dct_rpt_ir_pkg;
/

PROMPT === 2. Package body ===
CREATE OR REPLACE PACKAGE BODY prod.dct_rpt_ir_pkg AS

  TYPE t_names IS TABLE OF VARCHAR2(128);
  TYPE t_kinds IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;

  ------------------------------------------------------------------
  -- scan copy: blank out string literals ('' escapes honoured) and
  -- both comment styles; used ONLY for bind discovery and the
  -- first-keyword guard. The untouched SQL goes to the parser.
  ------------------------------------------------------------------
  FUNCTION scrub(p_sql IN CLOB) RETURN VARCHAR2 IS
    l_len PLS_INTEGER;
    l_src VARCHAR2(32767);
    l_out VARCHAR2(32767);
    i     PLS_INTEGER := 1;
    c     VARCHAR2(1 CHAR);
    n     VARCHAR2(1 CHAR);
    st    PLS_INTEGER := 0;   -- 0 normal, 1 literal, 2 line comment, 3 block comment
  BEGIN
    l_len := NVL(DBMS_LOB.GETLENGTH(p_sql), 0);
    IF l_len = 0 THEN
      RETURN NULL;
    END IF;
    IF l_len > 32767 THEN
      RAISE_APPLICATION_ERROR(-20001, 'report SQL exceeds 32K characters; not supported by the interactive viewer');
    END IF;
    l_src := DBMS_LOB.SUBSTR(p_sql, 32767, 1);
    WHILE i <= l_len LOOP
      c := SUBSTR(l_src, i, 1);
      n := SUBSTR(l_src, i + 1, 1);
      IF st = 0 THEN
        IF c = CHR(39) THEN
          st := 1; l_out := l_out || ' '; i := i + 1;
        ELSIF c = '-' AND n = '-' THEN
          st := 2; l_out := l_out || '  '; i := i + 2;
        ELSIF c = '/' AND n = '*' THEN
          st := 3; l_out := l_out || '  '; i := i + 2;
        ELSE
          l_out := l_out || c; i := i + 1;
        END IF;
      ELSIF st = 1 THEN
        IF c = CHR(39) AND n = CHR(39) THEN
          l_out := l_out || '  '; i := i + 2;
        ELSIF c = CHR(39) THEN
          st := 0; l_out := l_out || ' '; i := i + 1;
        ELSE
          l_out := l_out || ' '; i := i + 1;
        END IF;
      ELSIF st = 2 THEN
        IF c = CHR(10) THEN st := 0; l_out := l_out || c; ELSE l_out := l_out || ' '; END IF;
        i := i + 1;
      ELSE
        IF c = '*' AND n = '/' THEN
          st := 0; l_out := l_out || '  '; i := i + 2;
        ELSE
          l_out := l_out || ' '; i := i + 1;
        END IF;
      END IF;
    END LOOP;
    RETURN l_out;
  END scrub;

  ------------------------------------------------------------------
  -- distinct lower-cased bind names found in the scan copy
  ------------------------------------------------------------------
  FUNCTION bind_names(p_scan IN VARCHAR2) RETURN t_names IS
    l_list t_names := t_names();
    l_nm   VARCHAR2(128);
    l_hit  BOOLEAN;
    l_cnt  PLS_INTEGER;
  BEGIN
    IF p_scan IS NULL THEN
      RETURN l_list;
    END IF;
    l_cnt := REGEXP_COUNT(p_scan, ':[A-Za-z_][A-Za-z0-9_]*');
    FOR k IN 1 .. l_cnt LOOP
      l_nm := LOWER(REGEXP_SUBSTR(p_scan, ':([A-Za-z_][A-Za-z0-9_]*)', 1, k, NULL, 1));
      l_hit := FALSE;
      FOR j IN 1 .. l_list.COUNT LOOP
        IF l_list(j) = l_nm THEN l_hit := TRUE; EXIT; END IF;
      END LOOP;
      IF NOT l_hit THEN
        l_list.EXTEND;
        l_list(l_list.COUNT) := l_nm;
      END IF;
    END LOOP;
    RETURN l_list;
  END bind_names;

  ------------------------------------------------------------------
  -- definition defaults overlaid by request params, keys lower-cased
  ------------------------------------------------------------------
  FUNCTION merge_params(p_defaults IN CLOB, p_request IN CLOB) RETURN JSON_OBJECT_T IS
    l_m JSON_OBJECT_T := JSON_OBJECT_T();
    PROCEDURE put_all(p_json IN CLOB) IS
      l_o JSON_OBJECT_T;
      l_k JSON_KEY_LIST;
    BEGIN
      IF p_json IS NULL OR DBMS_LOB.GETLENGTH(p_json) < 3 THEN
        RETURN;
      END IF;
      l_o := JSON_OBJECT_T.parse(p_json);
      l_k := l_o.get_keys;
      FOR i IN 1 .. l_k.COUNT LOOP
        l_m.put(LOWER(l_k(i)), l_o.get(l_k(i)));
      END LOOP;
    EXCEPTION WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20001, 'run parameters must be a JSON object');
    END put_all;
  BEGIN
    put_all(p_defaults);
    put_all(p_request);
    RETURN l_m;
  END merge_params;

  ------------------------------------------------------------------
  -- MULTI spec: enforce required[] then pick the requested section
  ------------------------------------------------------------------
  FUNCTION resolve_multi(p_ref     IN CLOB,
                         p_section IN VARCHAR2,
                         p_params  IN JSON_OBJECT_T) RETURN CLOB IS
    l_spec    JSON_OBJECT_T;
    l_secs    JSON_ARRAY_T;
    l_sec     JSON_OBJECT_T;
    l_req     JSON_ARRAY_T;
    l_el      JSON_ELEMENT_T;
    l_nm      VARCHAR2(128);
    l_missing VARCHAR2(2000);
    l_keys    VARCHAR2(2000);
    l_sql     CLOB;
  BEGIN
    BEGIN
      l_spec := JSON_OBJECT_T.parse(p_ref);
    EXCEPTION WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20001, 'report source spec is not valid JSON');
    END;
    l_req := l_spec.get_array('required');
    IF l_req IS NOT NULL THEN
      FOR i IN 0 .. l_req.get_size - 1 LOOP
        l_nm := LOWER(l_req.get_string(i));
        l_el := p_params.get(l_nm);
        IF l_el IS NULL OR l_el.is_null
           OR (l_el.is_string AND TRIM(p_params.get_string(l_nm)) IS NULL) THEN
          l_missing := l_missing || CASE WHEN l_missing IS NOT NULL THEN ', ' END || l_nm;
        END IF;
      END LOOP;
      IF l_missing IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'missing required run parameter(s): ' || l_missing);
      END IF;
    END IF;
    l_secs := l_spec.get_array('sections');
    IF l_secs IS NULL OR l_secs.get_size = 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'report spec has no sections');
    END IF;
    FOR i IN 0 .. l_secs.get_size - 1 LOOP
      l_sec  := TREAT(l_secs.get(i) AS JSON_OBJECT_T);
      l_keys := l_keys || CASE WHEN l_keys IS NOT NULL THEN ', ' END || l_sec.get_string('key');
      IF LOWER(l_sec.get_string('key')) = LOWER(p_section) THEN
        l_sql := l_sec.get_clob('sql');
      END IF;
    END LOOP;
    IF l_sql IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'section is required for this report; valid sections: ' || l_keys);
    END IF;
    RETURN l_sql;
  END resolve_multi;

  ------------------------------------------------------------------
  -- the one public entry point
  ------------------------------------------------------------------
  PROCEDURE run_report(
    p_report_code IN VARCHAR2,
    p_section     IN VARCHAR2 DEFAULT NULL,
    p_params_json IN CLOB     DEFAULT NULL,
    p_max_rows    IN NUMBER   DEFAULT 10000) IS

    l_type     dct_rpt_definition.source_type%TYPE;
    l_ref      CLOB;
    l_defaults CLOB;
    l_enabled  CHAR(1);
    l_sql      CLOB;
    l_scan     VARCHAR2(32767);
    l_kw       VARCHAR2(30);
    l_params   JSON_OBJECT_T;
    l_binds    t_names;
    l_el       JSON_ELEMENT_T;
    l_cur      INTEGER;
    l_cnt      INTEGER;
    l_desc     DBMS_SQL.DESC_TAB2;
    l_kind     t_kinds;
    l_ign      INTEGER;
    l_vc       VARCHAR2(4000);
    l_num      NUMBER;
    l_dt       DATE;
    l_ts       TIMESTAMP;
    l_cl       CLOB;
    l_rows     PLS_INTEGER := 0;
    l_trunc    BOOLEAN := FALSE;
    l_max      NUMBER := GREATEST(NVL(p_max_rows, 10000), 1);
  BEGIN
    BEGIN
      SELECT source_type, source_ref, params_json, enabled
        INTO l_type, l_ref, l_defaults, l_enabled
        FROM dct_rpt_definition
       WHERE report_code = p_report_code;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Report not found');
    END;
    IF l_enabled <> 'Y' THEN
      RAISE_APPLICATION_ERROR(-20404, 'Report not found');
    END IF;

    l_params := merge_params(l_defaults, p_params_json);
    l_type   := UPPER(TRIM(l_type));

    IF l_type = 'VIEW' THEN
      BEGIN
        l_sql := 'SELECT * FROM ' || DBMS_ASSERT.SQL_OBJECT_NAME(TRIM(DBMS_LOB.SUBSTR(l_ref, 4000, 1)));
      EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'report source is not a valid view reference');
      END;
    ELSIF l_type = 'SQL' THEN
      l_sql := l_ref;
    ELSIF l_type = 'MULTI' THEN
      l_sql := resolve_multi(l_ref, p_section, l_params);
    ELSE
      RAISE_APPLICATION_ERROR(-20001, 'source type ' || l_type || ' is not supported by the interactive viewer');
    END IF;

    l_scan := scrub(l_sql);
    l_kw   := UPPER(REGEXP_SUBSTR(l_scan, '[A-Za-z]+', 1, 1));
    IF l_kw IS NULL OR l_kw NOT IN ('SELECT', 'WITH') THEN
      RAISE_APPLICATION_ERROR(-20001, 'only query statements can be viewed interactively');
    END IF;
    l_binds := bind_names(l_scan);

    l_cur := DBMS_SQL.OPEN_CURSOR;
    BEGIN
      DBMS_SQL.PARSE(l_cur, l_sql, DBMS_SQL.NATIVE);

      FOR i IN 1 .. l_binds.COUNT LOOP
        l_el := l_params.get(l_binds(i));
        IF l_el IS NULL OR l_el.is_null THEN
          DBMS_SQL.BIND_VARIABLE(l_cur, l_binds(i), TO_CHAR(NULL));
        ELSIF l_el.is_number THEN
          DBMS_SQL.BIND_VARIABLE(l_cur, l_binds(i), l_params.get_number(l_binds(i)));
        ELSE
          DBMS_SQL.BIND_VARIABLE(l_cur, l_binds(i), l_params.get_string(l_binds(i)));
        END IF;
      END LOOP;

      DBMS_SQL.DESCRIBE_COLUMNS2(l_cur, l_cnt, l_desc);
      FOR i IN 1 .. l_cnt LOOP
        IF l_desc(i).col_type IN (2, 100, 101) THEN
          l_kind(i) := 2; DBMS_SQL.DEFINE_COLUMN(l_cur, i, l_num);
        ELSIF l_desc(i).col_type = 12 THEN
          l_kind(i) := 3; DBMS_SQL.DEFINE_COLUMN(l_cur, i, l_dt);
        ELSIF l_desc(i).col_type IN (180, 181, 231) THEN
          l_kind(i) := 4; DBMS_SQL.DEFINE_COLUMN(l_cur, i, l_ts);
        ELSIF l_desc(i).col_type = 112 THEN
          l_kind(i) := 5; DBMS_SQL.DEFINE_COLUMN(l_cur, i, l_cl);
        ELSE
          l_kind(i) := 1; DBMS_SQL.DEFINE_COLUMN(l_cur, i, l_vc, 4000);
        END IF;
      END LOOP;

      l_ign := DBMS_SQL.EXECUTE(l_cur);

      dct_rest.json_header;
      APEX_JSON.initialize_output;
      APEX_JSON.open_object;
      APEX_JSON.write('reportCode', p_report_code);
      IF p_section IS NOT NULL THEN
        APEX_JSON.write('section', p_section);
      END IF;
      APEX_JSON.open_array('columns');
      FOR i IN 1 .. l_cnt LOOP
        APEX_JSON.open_object;
        APEX_JSON.write('key', l_desc(i).col_name);
        APEX_JSON.write('label', INITCAP(REPLACE(l_desc(i).col_name, '_', ' ')));
        APEX_JSON.write('type',
          CASE l_kind(i)
            WHEN 2 THEN
              CASE WHEN REGEXP_LIKE(l_desc(i).col_name,
                        '(AMOUNT|AMT|BUDGET|ACTUAL|BALANCE|TOTAL|COST|PRICE|VALUE|YTD|AED)', 'i')
                   THEN 'money' ELSE 'num' END
            WHEN 3 THEN 'date'
            WHEN 4 THEN 'date'
            ELSE 'text'
          END);
        APEX_JSON.close_object;
      END LOOP;
      APEX_JSON.close_array;

      APEX_JSON.open_array('items');
      WHILE DBMS_SQL.FETCH_ROWS(l_cur) > 0 LOOP
        IF l_rows >= l_max THEN
          l_trunc := TRUE;
          EXIT;
        END IF;
        APEX_JSON.open_object;
        FOR i IN 1 .. l_cnt LOOP
          CASE l_kind(i)
            WHEN 2 THEN
              DBMS_SQL.COLUMN_VALUE(l_cur, i, l_num);
              IF l_num IS NOT NULL THEN APEX_JSON.write(l_desc(i).col_name, l_num); END IF;
            WHEN 3 THEN
              DBMS_SQL.COLUMN_VALUE(l_cur, i, l_dt);
              IF l_dt IS NOT NULL THEN
                APEX_JSON.write(l_desc(i).col_name, TO_CHAR(l_dt, 'YYYY-MM-DD"T"HH24:MI:SS'));
              END IF;
            WHEN 4 THEN
              DBMS_SQL.COLUMN_VALUE(l_cur, i, l_ts);
              IF l_ts IS NOT NULL THEN
                APEX_JSON.write(l_desc(i).col_name, TO_CHAR(l_ts, 'YYYY-MM-DD"T"HH24:MI:SS'));
              END IF;
            WHEN 5 THEN
              DBMS_SQL.COLUMN_VALUE(l_cur, i, l_cl);
              IF l_cl IS NOT NULL THEN
                APEX_JSON.write(l_desc(i).col_name, DBMS_LOB.SUBSTR(l_cl, 4000, 1));
              END IF;
            ELSE
              DBMS_SQL.COLUMN_VALUE(l_cur, i, l_vc);
              IF l_vc IS NOT NULL THEN APEX_JSON.write(l_desc(i).col_name, l_vc); END IF;
          END CASE;
        END LOOP;
        APEX_JSON.close_object;
        l_rows := l_rows + 1;
      END LOOP;
      APEX_JSON.close_array;

      APEX_JSON.write('total', l_rows);
      APEX_JSON.write('truncated', l_trunc);
      APEX_JSON.write('maxRows', l_max);
      APEX_JSON.close_object;
      DBMS_SQL.CLOSE_CURSOR(l_cur);
    EXCEPTION WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(l_cur) THEN
        DBMS_SQL.CLOSE_CURSOR(l_cur);
      END IF;
      RAISE;
    END;
  END run_report;

  ------------------------------------------------------------------
  -- parameter list of values: run the definition's PARAMS_LOV_JSON
  -- entry for one parameter (bind-free query; col 1 = value, optional
  -- col 2 = label) and stream {param, items:[{value,label}], total}
  ------------------------------------------------------------------
  PROCEDURE run_lov(
    p_report_code IN VARCHAR2,
    p_param       IN VARCHAR2,
    p_max_rows    IN NUMBER DEFAULT 500) IS

    l_lov     CLOB;
    l_enabled CHAR(1);
    l_spec    JSON_OBJECT_T;
    l_keys    JSON_KEY_LIST;
    l_sql     CLOB;
    l_scan    VARCHAR2(32767);
    l_kw      VARCHAR2(30);
    l_binds   t_names;
    l_cur     INTEGER;
    l_cnt     INTEGER;
    l_desc    DBMS_SQL.DESC_TAB2;
    l_ign     INTEGER;
    l_v1      VARCHAR2(4000);
    l_v2      VARCHAR2(4000);
    l_rows    PLS_INTEGER := 0;
    l_max     NUMBER := GREATEST(NVL(p_max_rows, 500), 1);
  BEGIN
    IF p_param IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'param is required');
    END IF;
    BEGIN
      SELECT params_lov_json, enabled
        INTO l_lov, l_enabled
        FROM dct_rpt_definition
       WHERE report_code = p_report_code;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Report not found');
    END;
    IF l_enabled <> 'Y' THEN
      RAISE_APPLICATION_ERROR(-20404, 'Report not found');
    END IF;
    IF l_lov IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'no lists of values defined for this report');
    END IF;
    BEGIN
      l_spec := JSON_OBJECT_T.parse(l_lov);
    EXCEPTION WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20001, 'report LOV spec is not valid JSON');
    END;
    l_keys := l_spec.get_keys;
    FOR i IN 1 .. l_keys.COUNT LOOP
      IF LOWER(l_keys(i)) = LOWER(p_param) THEN
        l_sql := l_spec.get_clob(l_keys(i));
      END IF;
    END LOOP;
    IF l_sql IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'no list of values for parameter ' || p_param);
    END IF;
    l_scan := scrub(l_sql);
    l_kw   := UPPER(REGEXP_SUBSTR(l_scan, '[A-Za-z]+', 1, 1));
    IF l_kw IS NULL OR l_kw NOT IN ('SELECT', 'WITH') THEN
      RAISE_APPLICATION_ERROR(-20001, 'LOV must be a query');
    END IF;
    l_binds := bind_names(l_scan);
    IF l_binds.COUNT > 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'LOV queries must be bind-free');
    END IF;

    l_cur := DBMS_SQL.OPEN_CURSOR;
    BEGIN
      DBMS_SQL.PARSE(l_cur, l_sql, DBMS_SQL.NATIVE);
      DBMS_SQL.DESCRIBE_COLUMNS2(l_cur, l_cnt, l_desc);
      DBMS_SQL.DEFINE_COLUMN(l_cur, 1, l_v1, 4000);
      IF l_cnt >= 2 THEN
        DBMS_SQL.DEFINE_COLUMN(l_cur, 2, l_v2, 4000);
      END IF;
      l_ign := DBMS_SQL.EXECUTE(l_cur);

      dct_rest.json_header;
      APEX_JSON.initialize_output;
      APEX_JSON.open_object;
      APEX_JSON.write('param', LOWER(p_param));
      APEX_JSON.open_array('items');
      WHILE DBMS_SQL.FETCH_ROWS(l_cur) > 0 AND l_rows < l_max LOOP
        DBMS_SQL.COLUMN_VALUE(l_cur, 1, l_v1);
        IF l_cnt >= 2 THEN
          DBMS_SQL.COLUMN_VALUE(l_cur, 2, l_v2);
        ELSE
          l_v2 := NULL;
        END IF;
        APEX_JSON.open_object;
        APEX_JSON.write('value', NVL(l_v1, ''));
        APEX_JSON.write('label', NVL(l_v2, NVL(l_v1, '')));
        APEX_JSON.close_object;
        l_rows := l_rows + 1;
      END LOOP;
      APEX_JSON.close_array;
      APEX_JSON.write('total', l_rows);
      APEX_JSON.close_object;
      DBMS_SQL.CLOSE_CURSOR(l_cur);
    EXCEPTION WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(l_cur) THEN
        DBMS_SQL.CLOSE_CURSOR(l_cur);
      END IF;
      RAISE;
    END;
  END run_lov;

END dct_rpt_ir_pkg;
/

SHOW ERRORS PACKAGE BODY prod.dct_rpt_ir_pkg

PROMPT === 3. ADMIN synonym (fresh-session rule applies) ===
CREATE OR REPLACE SYNONYM dct_rpt_ir_pkg FOR prod.dct_rpt_ir_pkg;

PROMPT ============================================================
PROMPT  12a_rpt_ir_pkg.sql complete (dct_rpt_ir_pkg).
PROMPT ============================================================
