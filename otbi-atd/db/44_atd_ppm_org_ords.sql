-- =============================================================================
-- ATD Loader (App 208) -- ORDS for Manage Projects Org  (additive)
-- File    : 44_atd_ppm_org_ords.sql
-- Base URL: /ords/admin/atd/   (adds to the EXISTING 'atd.rest' module)
-- Run     : sql -name prod_mcp @44_atd_ppm_org_ords.sql   (FRESH session - synonym
--           rule: must NOT follow ALTER SESSION SET CURRENT_SCHEMA=PROD)
-- =============================================================================
-- Adds ONE endpoint: POST /atd/actions/enqueue -- bulk-enqueue PPM_TASK_ADDL_INFO
-- actions (update a financial-plan task's Organization Reference) from the new
-- "Manage Projects Org" page. Purely additive on a NEW template, so the live
-- extract API and the db/20 /actions handlers are untouched.
-- WARNING: 13_atd_ords.sql rebuilds atd.rest from scratch -- after ANY re-run of
-- 13 you must re-run 20, 38, 41, 42 AND this 44.
-- Admin-only (SYS_ADMIN). [COLON] -> ':' at define time (SQLcl bind-scan guard).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE PROCEDURE setup_atd_ppm_org_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'atd.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)));
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

    -- =========================================================================
    -- POST /actions/enqueue  -- bulk-enqueue PPM_TASK_ADDL_INFO actions
    -- body: {"rows":[{"projectNumber","taskNumber","orgReference",
    --                 optional "entitySpecific"/"appropriation"/"program"/
    --                 "bgOverride"/"revenueAccountOverride"}]}
    -- Per row: idem_key = PPM-ORGREF:<project>:<task>:<cc>; a DONE key is never
    -- re-armed (reported back as status DONE); FAILED/CANCELLED keys re-arm.
    -- =========================================================================
    def_template('actions/enqueue');
    def_handler('actions/enqueue', 'POST', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_cnt   NUMBER;
  TYPE t_row IS RECORD (
    proj VARCHAR2(60),  task VARCHAR2(240), org VARCHAR2(60),
    ent  VARCHAR2(120), appr VARCHAR2(120), prog VARCHAR2(120),
    bg   VARCHAR2(120), rev  VARCHAR2(120),
    aid  NUMBER, key VARCHAR2(400), stat VARCHAR2(20), emsg VARCHAR2(200));
  TYPE t_tab IS TABLE OF t_row INDEX BY PLS_INTEGER;
  l_rows    t_tab;
  l_payload CLOB;
  l_ok      NUMBER := 0;
  l_bad     NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_cnt := NVL(APEX_JSON.get_count(p_path=>'rows'), 0);
  IF l_cnt = 0 THEN dct_rest.err(400,'rows[] is required'); RETURN; END IF;
  IF l_cnt > 500 THEN dct_rest.err(400,'Maximum 500 rows per request'); RETURN; END IF;

  FOR i IN 1..l_cnt LOOP
    l_rows(i).proj := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].projectNumber', p0=>i)), 1, 60);
    l_rows(i).task := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].taskNumber',    p0=>i)), 1, 240);
    l_rows(i).org  := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].orgReference',  p0=>i)), 1, 60);
    l_rows(i).ent  := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].entitySpecific',         p0=>i)), 1, 120);
    l_rows(i).appr := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].appropriation',          p0=>i)), 1, 120);
    l_rows(i).prog := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].program',                p0=>i)), 1, 120);
    l_rows(i).bg   := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].bgOverride',             p0=>i)), 1, 120);
    l_rows(i).rev  := SUBSTR(TRIM(APEX_JSON.get_varchar2(p_path=>'rows[%d].revenueAccountOverride', p0=>i)), 1, 120);
  END LOOP;

  FOR i IN 1..l_cnt LOOP
    IF l_rows(i).proj IS NULL OR l_rows(i).task IS NULL OR l_rows(i).org IS NULL THEN
      l_rows(i).stat := 'ERROR';
      l_rows(i).emsg := 'projectNumber, taskNumber and orgReference are required';
      l_bad := l_bad + 1;
    ELSE
      BEGIN
        SELECT JSON_OBJECT(
          'projectNumber'          VALUE l_rows(i).proj,
          'taskNumber'             VALUE l_rows(i).task,
          'orgReference'           VALUE l_rows(i).org,
          'entitySpecific'         VALUE l_rows(i).ent,
          'appropriation'          VALUE l_rows(i).appr,
          'program'                VALUE l_rows(i).prog,
          'bgOverride'             VALUE l_rows(i).bg,
          'revenueAccountOverride' VALUE l_rows(i).rev
          ABSENT ON NULL RETURNING CLOB)
          INTO l_payload FROM dual;
        l_rows(i).key := SUBSTR('PPM-ORGREF[COLON]'||l_rows(i).proj||'[COLON]'||l_rows(i).task
                                ||'[COLON]'||l_rows(i).org, 1, 200);
        l_rows(i).aid := atd_action_pkg.enqueue_action(
          p_action_type   => 'PPM_TASK_ADDL_INFO',
          p_source_module => 'ATD',
          p_source_type   => 'UI',
          p_source_id     => NULL,
          p_source_ref    => SUBSTR(l_rows(i).task||' @ '||l_rows(i).proj, 1, 200),
          p_idem_key      => l_rows(i).key,
          p_payload       => l_payload,
          p_env_name      => NULL,
          p_created_by    => l_user);
        SELECT run_status INTO l_rows(i).stat
          FROM atd_action_request WHERE action_id = l_rows(i).aid;
        l_ok := l_ok + 1;
      EXCEPTION WHEN OTHERS THEN
        l_rows(i).stat := 'ERROR';
        l_rows(i).emsg := SUBSTR(SQLERRM, 1, 200);
        l_bad := l_bad + 1;
      END;
    END IF;
  END LOOP;

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_cnt);
  APEX_JSON.write('enqueued', l_ok);
  APEX_JSON.write('errors', l_bad);
  APEX_JSON.open_array('items');
  FOR i IN 1..l_cnt LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('row', i);
    APEX_JSON.write('projectNumber', NVL(l_rows(i).proj,''));
    APEX_JSON.write('taskNumber',    NVL(l_rows(i).task,''));
    APEX_JSON.write('orgReference',  NVL(l_rows(i).org,''));
    IF l_rows(i).aid IS NOT NULL THEN APEX_JSON.write('actionId', l_rows(i).aid); END IF;
    APEX_JSON.write('idemKey', NVL(l_rows(i).key,''));
    APEX_JSON.write('status',  l_rows(i).stat);
    APEX_JSON.write('error',   NVL(l_rows(i).emsg,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_atd_ppm_org_tmp;
/

BEGIN
  setup_atd_ppm_org_tmp;
  COMMIT;
END;
/
DROP PROCEDURE setup_atd_ppm_org_tmp;

PROMPT otbi-atd 44 Manage Projects Org ORDS : done
