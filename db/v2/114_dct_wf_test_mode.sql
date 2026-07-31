SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
-- db/v2/114_dct_wf_test_mode.sql
-- DWP TESTING MODE: while a chain is under test, every workflow notification
-- is redirected to ONE configured account so real approvers are never
-- disturbed. Two scopes:
--   platform : DCT_SYSTEM_SETTINGS WF_TEST_MODE = Y  (all processes)
--   process  : DCT_WF_PROCESS.test_mode = Y          (just that process)
-- The redirect target = the active user whose email is WF_TEST_MODE's
-- companion setting WF_TEST_EMAIL (default haghareb@dctabudhabi.ae).
-- Task ROUTING is untouched -- resolution is the thing being tested; the
-- redirected notification is tagged [TEST] and names the original recipient.
-- Engine side lives in 63 (re-run 63 BEFORE this). This script: the process
-- column, the two settings, PUT processes/:code/test-mode, and the
-- processes GET redefined to ship testMode (source synced into 67 -- and a
-- 67 re-run DELETE_MODULEs wf.rest, so after any 67 re-run the additive
-- list is 96, 97, 98, 113, 114).
-- Deploy as ADMIN in a FRESH SQLcl session (sql -name prod_mcp).

PROMPT === process column plus settings ===

DECLARE
    v NUMBER;
BEGIN
    SELECT COUNT(*) INTO v FROM all_tab_columns
     WHERE owner = 'PROD' AND table_name = 'DCT_WF_PROCESS'
       AND column_name = 'TEST_MODE';
    IF v = 0 THEN
        EXECUTE IMMEDIATE q'[ALTER TABLE prod.dct_wf_process ADD
            (test_mode VARCHAR2(1) DEFAULT 'N' NOT NULL
             CONSTRAINT chk_wf_p_test CHECK (test_mode IN ('Y','N')))]';
        DBMS_OUTPUT.PUT_LINE('  test_mode column added');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  test_mode column already present');
    END IF;

    SELECT COUNT(*) INTO v FROM prod.dct_system_settings
     WHERE setting_key = 'WF_TEST_MODE';
    IF v = 0 THEN
        INSERT INTO prod.dct_system_settings
            (setting_key, setting_value, value_type, category,
             description_en, description_ar, is_system, created_by)
        VALUES ('WF_TEST_MODE', 'N', 'BOOLEAN', 'WORKFLOW',
            'Workflow testing mode: redirect EVERY workflow notification to the WF_TEST_EMAIL account (subjects tagged [TEST], original recipient named). Task routing is unaffected.',
            UNISTR('\0648\0636\0639 \0627\062E\062A\0628\0627\0631 \0633\064A\0631 \0627\0644\0639\0645\0644: \062A\062D\0648\064A\0644 \0643\0644 \0625\0634\0639\0627\0631\0627\062A \0633\064A\0631 \0627\0644\0639\0645\0644 \0625\0644\0649 \062D\0633\0627\0628 \0627\0644\0627\062E\062A\0628\0627\0631 \0627\0644\0645\062D\062F\062F'),
            'N', 'SEED');
        DBMS_OUTPUT.PUT_LINE('  WF_TEST_MODE seeded (N)');
    END IF;

    SELECT COUNT(*) INTO v FROM prod.dct_system_settings
     WHERE setting_key = 'WF_TEST_EMAIL';
    IF v = 0 THEN
        INSERT INTO prod.dct_system_settings
            (setting_key, setting_value, value_type, category,
             description_en, description_ar, is_system, created_by)
        VALUES ('WF_TEST_EMAIL', 'haghareb@dctabudhabi.ae', 'STRING', 'WORKFLOW',
            'The account (by email) that receives ALL workflow notifications while testing mode is on -- platform-wide via WF_TEST_MODE or per process via its Test-mode toggle.',
            UNISTR('\0627\0644\0628\0631\064A\062F \0627\0644\0630\064A \064A\0633\062A\0644\0645 \062C\0645\064A\0639 \0625\0634\0639\0627\0631\0627\062A \0633\064A\0631 \0627\0644\0639\0645\0644 \0623\062B\0646\0627\0621 \0648\0636\0639 \0627\0644\0627\062E\062A\0628\0627\0631'),
            'N', 'SEED');
        DBMS_OUTPUT.PUT_LINE('  WF_TEST_EMAIL seeded');
    END IF;
    COMMIT;
END;
/

PROMPT === route: PUT processes/[COLON]code/test-mode ===

BEGIN
  ORDS.DEFINE_TEMPLATE(p_module_name=>'wf.rest', p_pattern=>REPLACE('processes/[COLON]code/test-mode','[COLON]',CHR(58)));
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>REPLACE('processes/[COLON]code/test-mode','[COLON]',CHR(58)),
    p_method=>'PUT', p_source_type=>ORDS.source_type_plsql, p_source=>REPLACE(q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_raw RAW(32767); l_json VARCHAR2(32767);
  l_on VARCHAR2(1); l_cnt NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF dct_auth.has_role(l_user,'WF_ADMIN') = FALSE AND dct_auth.has_role(l_user,'SYS_ADMIN') = FALSE THEN
    dct_rest.err(403,'WF_ADMIN required'); RETURN;
  END IF;
  l_raw  := DBMS_LOB.SUBSTR([COLON]body, 32767, 1);
  l_json := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
  APEX_JSON.parse(l_json);
  l_on := UPPER(NVL(APEX_JSON.get_varchar2(p_path=>'testMode'), 'N'));
  IF l_on NOT IN ('Y','N') THEN dct_rest.err(400,'testMode must be Y or N'); RETURN; END IF;
  UPDATE dct_wf_process SET test_mode = l_on WHERE process_code = [COLON]code;
  l_cnt := SQL%ROWCOUNT;
  IF l_cnt = 0 THEN ROLLBACK; dct_rest.err(404,'Unknown process'); RETURN; END IF;
  COMMIT;
  dct_audit_pkg.log(
      p_username => l_user, p_action => 'WF_TEST_MODE',
      p_object_type => 'DCT_WF_PROCESS', p_object_id => [COLON]code,
      p_module_code => 'ADMIN',
      p_new => '{"testMode":"' || l_on || '"}');
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('processCode', [COLON]code);
  APEX_JSON.write('testMode', l_on);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dct_rest.err(500, SQLERRM);
END;!','[COLON]',CHR(58)));
  COMMIT;
END;
/

PROMPT === processes GET redefined with testMode (source synced into 67) ===

BEGIN
  ORDS.DEFINE_HANDLER(p_module_name=>'wf.rest', p_pattern=>'processes',
    p_method=>'GET', p_source_type=>ORDS.source_type_plsql, p_items_per_page=>0, p_source=>q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  -- every derived value is computed IN THE CURSOR. A scalar subquery used as an
  -- actual parameter to APEX_JSON.write parses as an ORDS 555 -- which is
  -- uncatchable, because it never reaches the EXCEPTION block.
  FOR p IN (SELECT p.process_id, p.process_code, p.source_module, p.name_en, p.name_ar,
                   p.is_active, p.requires_final_callback, p.test_mode,
                   v.version_no AS pub_ver,
                   v.version_id AS pub_vid,
                   r.engine     AS engine,
                   (SELECT COUNT(*) FROM dct_wf_step s
                     WHERE s.version_id = v.version_id) AS step_count
              FROM dct_wf_process p
              LEFT JOIN dct_wf_process_version v
                     ON v.process_id = p.process_id AND v.status = 'PUBLISHED'
              LEFT JOIN dct_wf_route r
                     ON r.source_module = p.source_module
             ORDER BY p.process_code) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('processId',   p.process_id);
    APEX_JSON.write('processCode', p.process_code);
    APEX_JSON.write('module',      p.source_module);
    APEX_JSON.write('nameEn',      p.name_en);
    APEX_JSON.write('nameAr',      p.name_ar);
    APEX_JSON.write('isActive',    p.is_active);
    APEX_JSON.write('publishedVersion', p.pub_ver);
    APEX_JSON.write('versionId',   p.pub_vid);
    APEX_JSON.write('routedTo',    NVL(p.engine, 'LEGACY'));
    APEX_JSON.write('steps',       NVL(p.step_count, 0));
    APEX_JSON.write('testMode',    NVL(p.test_mode, 'N'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
  COMMIT;
END;
/

PROMPT === recompile sweep (the ALTER invalidates dependent packages) ===
BEGIN
    FOR i IN 1 .. 2 LOOP
        FOR r IN (SELECT object_name, object_type FROM all_objects
                   WHERE owner = 'PROD' AND status = 'INVALID') LOOP
            BEGIN
                IF r.object_type = 'PACKAGE BODY' THEN
                    EXECUTE IMMEDIATE 'ALTER PACKAGE prod.' || r.object_name || ' COMPILE BODY';
                ELSIF r.object_type = 'VIEW' THEN
                    EXECUTE IMMEDIATE 'ALTER VIEW prod.' || r.object_name || ' COMPILE';
                ELSE
                    EXECUTE IMMEDIATE 'ALTER ' || r.object_type || ' prod.' || r.object_name || ' COMPILE';
                END IF;
            EXCEPTION WHEN OTHERS THEN NULL;
            END;
        END LOOP;
    END LOOP;
END;
/

SELECT setting_key, setting_value FROM prod.dct_system_settings
 WHERE setting_key LIKE 'WF_TEST%' ORDER BY 1;
SELECT COUNT(*) AS invalid_objects FROM all_objects WHERE owner = 'PROD' AND status = 'INVALID';
SELECT t.uri_template, h.method
  FROM user_ords_templates t
  JOIN user_ords_handlers h ON h.template_id = t.id
  JOIN user_ords_modules m ON m.id = t.module_id
 WHERE m.name = 'wf.rest' AND t.uri_template LIKE 'processes%test-mode%';

EXIT
