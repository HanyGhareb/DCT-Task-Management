-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 14 parameter-LOV convergence
-- File   : reporting/db/14_rpt_lov_converge.sql
-- Schema : PROD (data migration on dct_rpt_definition)
-- Run as : sql -name prod_mcp   (fresh session)
-- Purpose: ONE parameter-metadata column. The 2026-07-03 merge left two:
--            PARAM_SPEC_JSON  (10_rpt_param_lov.sql) -- per-param UI metadata
--              { "<param>": { "label","label_ar","hint","hint_ar",
--                             "required": true|false, "lov_sql": "SELECT ..." } }
--            PARAMS_LOV_JSON  (retired 13_rpt_ir_lov.sql) -- { "<param>": "SELECT ..." }
--          This script folds every PARAMS_LOV_JSON query into the matching
--          PARAM_SPEC_JSON entry's lov_sql (only where lov_sql is absent --
--          admin edits win), seeds the GL_BUDGET_ACTUAL period entry for
--          fresh installs, guards the column with IS JSON, then DROPS
--          PARAMS_LOV_JSON. After this script the admin Run drawer AND the
--          Interactive Report viewer both read PARAM_SPEC_JSON only.
-- Order  : run AFTER 10_rpt_param_lov.sql and BEFORE re-running 12a/12b
--          (12a's run_lov reads param_spec_json).
-- Idempotent: rerunnable; the merge step no-ops once the column is gone.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. fold legacy PARAMS_LOV_JSON queries into PARAM_SPEC_JSON.lov_sql ===
DECLARE
  l_has     NUMBER;
  l_cur     SYS_REFCURSOR;
  l_code    VARCHAR2(80);
  l_lov     CLOB;
  l_spec    CLOB;
  l_lov_o   JSON_OBJECT_T;
  l_spec_o  JSON_OBJECT_T;
  l_entry   JSON_OBJECT_T;
  l_keys    JSON_KEY_LIST;
  l_sk      JSON_KEY_LIST;
  l_match   VARCHAR2(128);
  l_changed BOOLEAN;
  l_out     CLOB;
  l_n       PLS_INTEGER := 0;
BEGIN
  SELECT COUNT(*) INTO l_has FROM all_tab_columns
   WHERE owner = 'PROD' AND table_name = 'DCT_RPT_DEFINITION'
     AND column_name = 'PARAMS_LOV_JSON';
  IF l_has = 0 THEN
    DBMS_OUTPUT.PUT_LINE('params_lov_json column absent -- nothing to fold');
  ELSE
    OPEN l_cur FOR 'SELECT report_code, params_lov_json, param_spec_json FROM prod.dct_rpt_definition WHERE params_lov_json IS NOT NULL';
    LOOP
      FETCH l_cur INTO l_code, l_lov, l_spec;
      EXIT WHEN l_cur%NOTFOUND;
      BEGIN
        l_lov_o := JSON_OBJECT_T.parse(l_lov);
      EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(l_code || ': legacy LOV json invalid -- skipped');
        CONTINUE;
      END;
      IF l_spec IS NULL THEN
        l_spec_o := JSON_OBJECT_T();
      ELSE
        BEGIN
          l_spec_o := JSON_OBJECT_T.parse(l_spec);
        EXCEPTION WHEN OTHERS THEN
          l_spec_o := JSON_OBJECT_T();
        END;
      END IF;
      l_changed := FALSE;
      l_keys := l_lov_o.get_keys;
      FOR i IN 1 .. l_keys.COUNT LOOP
        l_match := NULL;
        l_sk := l_spec_o.get_keys;
        FOR j IN 1 .. l_sk.COUNT LOOP
          IF LOWER(l_sk(j)) = LOWER(l_keys(i)) THEN
            l_match := l_sk(j);
            EXIT;
          END IF;
        END LOOP;
        IF l_match IS NULL THEN
          l_entry := JSON_OBJECT_T();
          l_entry.put('lov_sql', l_lov_o.get_string(l_keys(i)));
          l_spec_o.put(LOWER(l_keys(i)), l_entry);
          l_changed := TRUE;
        ELSIF l_spec_o.get(l_match).is_object THEN
          l_entry := TREAT(l_spec_o.get(l_match) AS JSON_OBJECT_T);
          IF l_entry.get_string('lov_sql') IS NULL THEN
            l_entry.put('lov_sql', l_lov_o.get_string(l_keys(i)));
            l_changed := TRUE;
          END IF;
        END IF;
      END LOOP;
      IF l_changed THEN
        l_out := l_spec_o.to_string;
        UPDATE prod.dct_rpt_definition
           SET param_spec_json = l_out
         WHERE report_code = l_code;
        l_n := l_n + 1;
        DBMS_OUTPUT.PUT_LINE(l_code || ': lov queries folded into param_spec_json');
      ELSE
        DBMS_OUTPUT.PUT_LINE(l_code || ': spec already carries every lov_sql -- untouched');
      END IF;
    END LOOP;
    CLOSE l_cur;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('folded definitions: ' || l_n);
  END IF;
END;
/

PROMPT === 2. fresh-install seed: GL_BUDGET_ACTUAL period entry (only if absent) ===
DECLARE
  l_spec   CLOB;
  l_spec_o JSON_OBJECT_T;
  l_entry  JSON_OBJECT_T;
  l_sk     JSON_KEY_LIST;
  l_match  VARCHAR2(128);
  l_out    CLOB;
BEGIN
  BEGIN
    SELECT param_spec_json INTO l_spec
      FROM prod.dct_rpt_definition WHERE report_code = 'GL_BUDGET_ACTUAL';
  EXCEPTION WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('GL_BUDGET_ACTUAL not seeded on this DB -- skipped');
    RETURN;
  END;
  IF l_spec IS NULL THEN
    l_spec_o := JSON_OBJECT_T();
  ELSE
    l_spec_o := JSON_OBJECT_T.parse(l_spec);
  END IF;
  l_match := NULL;
  l_sk := l_spec_o.get_keys;
  FOR j IN 1 .. l_sk.COUNT LOOP
    IF LOWER(l_sk(j)) = 'period' THEN
      l_match := l_sk(j);
      EXIT;
    END IF;
  END LOOP;
  IF l_match IS NULL THEN
    l_entry := JSON_OBJECT_T();
  ELSIF l_spec_o.get(l_match).is_object THEN
    l_entry := TREAT(l_spec_o.get(l_match) AS JSON_OBJECT_T);
  ELSE
    l_entry := JSON_OBJECT_T();
    l_match := NULL;
  END IF;
  IF l_entry.get_string('label') IS NULL THEN
    l_entry.put('label', 'Period');
    l_entry.put('label_ar', UNISTR('\0627\0644\0641\062A\0631\0629'));
  END IF;
  IF l_entry.get_string('lov_sql') IS NULL THEN
    l_entry.put('lov_sql', 'SELECT period_name FROM prod.dct_budget_actual_period_v GROUP BY period_name ORDER BY MAX(period_date) DESC');
  END IF;
  IF l_match IS NULL THEN
    l_spec_o.put('period', l_entry);
  END IF;
  l_out := l_spec_o.to_string;
  UPDATE prod.dct_rpt_definition
     SET param_spec_json = l_out
   WHERE report_code = 'GL_BUDGET_ACTUAL';
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('GL_BUDGET_ACTUAL period spec ensured');
END;
/

PROMPT === 3. IS JSON guard on param_spec_json (additive, rerunnable) ===
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_rpt_definition ADD CONSTRAINT ck_dct_rpt_def_pspec CHECK (param_spec_json IS NULL OR param_spec_json IS JSON)';
  DBMS_OUTPUT.PUT_LINE('ck_dct_rpt_def_pspec added');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE IN (-2264, -2260, -2261, -2275) THEN
    DBMS_OUTPUT.PUT_LINE('ck_dct_rpt_def_pspec already present');
  ELSE
    RAISE;
  END IF;
END;
/

PROMPT === 4. drop the legacy PARAMS_LOV_JSON column ===
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_rpt_definition DROP COLUMN params_lov_json';
  DBMS_OUTPUT.PUT_LINE('params_lov_json dropped');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -904 THEN
    DBMS_OUTPUT.PUT_LINE('params_lov_json already gone');
  ELSE
    RAISE;
  END IF;
END;
/

PROMPT === 5. verify ===
SELECT report_code,
       CASE WHEN param_spec_json IS JSON THEN 'SPEC OK' ELSE 'SPEC BAD' END AS spec_ok,
       DBMS_LOB.GETLENGTH(param_spec_json) AS spec_len
  FROM prod.dct_rpt_definition
 WHERE param_spec_json IS NOT NULL
 ORDER BY report_code;

PROMPT ============================================================
PROMPT  14_rpt_lov_converge.sql complete.
PROMPT  PARAM_SPEC_JSON is now the single parameter-metadata column.
PROMPT  Now re-run 12a (run_lov reads the spec) and 12b (catalog etc).
PROMPT ============================================================
