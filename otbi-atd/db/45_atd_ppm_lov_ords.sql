-- =============================================================================
-- ATD Loader (App 208) -- ORDS for Manage Projects Org LOVs  (additive)
-- File    : 45_atd_ppm_lov_ords.sql
-- Base URL: /ords/admin/atd/   (adds to the EXISTING 'atd.rest' module)
-- Run     : sql -name prod_mcp @45_atd_ppm_lov_ords.sql   (FRESH session - synonym
--           rule: must NOT follow ALTER SESSION SET CURRENT_SCHEMA=PROD)
-- =============================================================================
-- Adds ONE endpoint: GET /atd/actions/ppmlov?type=project|task|cc[&search=][&project=]  (NOT q= - reserved by ORDS)
-- Type-ahead suggestion lists for the Manage Projects Org page, sourced from the
-- Fusion-loaded extract tables (PROD schema, prod. prefix -- no new synonyms):
--   project -> prod.atd_projects  (number + name + status; ~800 rows)
--   task    -> prod.atd_tasks     (task number + name for ONE project)
--   cc      -> prod.dct_gl_coa_v  (distinct cost centre code + description)
-- SUGGESTIONS ONLY -- the extract is a snapshot, so the UI must keep the inputs
-- free-text (a task created in Fusion today may not be in the extract yet).
-- Purely additive on a NEW template; db/20+44 handlers untouched.
-- WARNING: 13_atd_ords.sql rebuilds atd.rest from scratch -- after ANY re-run of
-- 13 you must re-run 20, 38, 41, 42, 44 AND this 45.
-- Admin-only (SYS_ADMIN). [COLON] -> ':' at define time (SQLcl bind-scan guard).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE PROCEDURE setup_atd_ppm_lov_tmp AS
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
    -- GET /actions/ppmlov -- suggestion lists (items:[{code,name}])
    --   type=project        all projects (optional q contains number OR name)
    --   type=task&project=N tasks of that project number
    --   type=cc             distinct cost centres (code + description)
    -- =========================================================================
    def_template('actions/ppmlov');
    def_handler('actions/ppmlov', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_type VARCHAR2(20)  := LOWER(NVL(TRIM([COLON]type), 'project'));
  l_q    VARCHAR2(200) := LOWER(TRIM([COLON]search));
  l_proj VARCHAR2(60)  := TRIM([COLON]project);
  l_n    NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user,'SYS_ADMIN') THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  IF l_type NOT IN ('project','task','cc') THEN
    dct_rest.err(400,'type must be project, task or cc'); RETURN;
  END IF;
  IF l_type = 'task' AND l_proj IS NULL THEN
    dct_rest.err(400,'project parameter is required for type=task'); RETURN;
  END IF;
  dct_rest.json_header;
  APEX_JSON.open_object;
  APEX_JSON.write('type', l_type);
  APEX_JSON.open_array('items');
  IF l_type = 'project' THEN
    FOR r IN (
      SELECT project_number code, project_name name, project_status st
        FROM prod.atd_projects
       WHERE l_q IS NULL
          OR LOWER(project_number) LIKE '%'||l_q||'%'
          OR LOWER(project_name)   LIKE '%'||l_q||'%'
       ORDER BY project_number
       FETCH FIRST 1000 ROWS ONLY)
    LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('code', r.code);
      APEX_JSON.write('name', NVL(r.name,''));
      APEX_JSON.write('status', NVL(r.st,''));
      APEX_JSON.close_object;
      l_n := l_n + 1;
    END LOOP;
  ELSIF l_type = 'task' THEN
    FOR r IN (

      SELECT DISTINCT t.task_number code, t.task_name name
        FROM prod.atd_tasks t
        JOIN prod.atd_projects p ON p.project_id = t.project_id
       WHERE p.project_number = l_proj
         AND (l_q IS NULL
              OR LOWER(t.task_number) LIKE '%'||l_q||'%'
              OR LOWER(t.task_name)   LIKE '%'||l_q||'%')
       ORDER BY 1
       FETCH FIRST 500 ROWS ONLY)
    LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('code', r.code);
      APEX_JSON.write('name', NVL(r.name,''));
      APEX_JSON.close_object;
      l_n := l_n + 1;
    END LOOP;
  ELSIF l_type = 'cc' THEN
    FOR r IN (
      SELECT DISTINCT cost_center_code code, cost_center_desc name
        FROM prod.dct_gl_coa_v
       WHERE cost_center_code IS NOT NULL
         AND (l_q IS NULL
              OR LOWER(cost_center_code) LIKE '%'||l_q||'%'
              OR LOWER(cost_center_desc) LIKE '%'||l_q||'%')
       ORDER BY 1
       FETCH FIRST 500 ROWS ONLY)
    LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('code', r.code);
      APEX_JSON.write('name', NVL(r.name,''));
      APEX_JSON.close_object;
      l_n := l_n + 1;
    END LOOP;
  END IF;
  APEX_JSON.close_array;
  APEX_JSON.write('count', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_atd_ppm_lov_tmp;
/

BEGIN
  setup_atd_ppm_lov_tmp;
  COMMIT;
END;
/
DROP PROCEDURE setup_atd_ppm_lov_tmp;

PROMPT otbi-atd 45 Manage Projects Org LOV ORDS : done
