-- =============================================================================
-- Task Management Module (App 207) -- ORDS REST API (tm.rest)
-- File    : 06_tm_ords.sql
-- Schema  : registered under ADMIN (the only REST-routable schema on ADB)
-- Base URL: /ords/admin/tm/
-- Run     : sql -name prod_mcp @06_tm_ords.sql   (FRESH session -- synonym rule:
--           do NOT run after ALTER SESSION SET CURRENT_SCHEMA=PROD or the ADMIN
--           synonyms self-reference, ORA-01471)
-- Notes   : Thin handlers over DCT_TM_PKG + dct_tm_*_v views. validate_session
--           on every route. Pagination envelope {items,total,limit,offset}.
--           Package error codes map to HTTP: -20401->401 -20403->403 -20404->404
--           -20001/-20090->400 else 500. Upsert via POST (id optional in body).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

-- =============================================================================
-- 1. ADMIN synonyms for every PROD object the handlers touch
-- =============================================================================
CREATE OR REPLACE SYNONYM dct_tm_pkg            FOR prod.dct_tm_pkg;
CREATE OR REPLACE SYNONYM dct_tm_reminder_pkg   FOR prod.dct_tm_reminder_pkg;
CREATE OR REPLACE SYNONYM dct_tm_teams          FOR prod.dct_tm_teams;
CREATE OR REPLACE SYNONYM dct_tm_roles          FOR prod.dct_tm_roles;
CREATE OR REPLACE SYNONYM dct_tm_role_perms     FOR prod.dct_tm_role_perms;
CREATE OR REPLACE SYNONYM dct_tm_members        FOR prod.dct_tm_members;
CREATE OR REPLACE SYNONYM dct_tm_objectives     FOR prod.dct_tm_objectives;
CREATE OR REPLACE SYNONYM dct_tm_key_results    FOR prod.dct_tm_key_results;
CREATE OR REPLACE SYNONYM dct_tm_tasks          FOR prod.dct_tm_tasks;
CREATE OR REPLACE SYNONYM dct_tm_deliverables   FOR prod.dct_tm_deliverables;
CREATE OR REPLACE SYNONYM dct_tm_log_items      FOR prod.dct_tm_log_items;
CREATE OR REPLACE SYNONYM dct_tm_milestones     FOR prod.dct_tm_milestones;
CREATE OR REPLACE SYNONYM dct_tm_meetings       FOR prod.dct_tm_meetings;
CREATE OR REPLACE SYNONYM dct_tm_reminder_prefs FOR prod.dct_tm_reminder_prefs;
CREATE OR REPLACE SYNONYM dct_tm_team_v         FOR prod.dct_tm_team_v;
CREATE OR REPLACE SYNONYM dct_tm_member_v       FOR prod.dct_tm_member_v;
CREATE OR REPLACE SYNONYM dct_tm_objective_v    FOR prod.dct_tm_objective_v;
CREATE OR REPLACE SYNONYM dct_tm_key_result_v   FOR prod.dct_tm_key_result_v;
CREATE OR REPLACE SYNONYM dct_tm_task_v         FOR prod.dct_tm_task_v;
CREATE OR REPLACE SYNONYM dct_tm_my_task_v      FOR prod.dct_tm_my_task_v;
CREATE OR REPLACE SYNONYM dct_tm_deliverable_v  FOR prod.dct_tm_deliverable_v;
CREATE OR REPLACE SYNONYM dct_tm_log_v          FOR prod.dct_tm_log_v;
CREATE OR REPLACE SYNONYM dct_tm_milestone_v    FOR prod.dct_tm_milestone_v;
CREATE OR REPLACE SYNONYM dct_tm_meeting_v      FOR prod.dct_tm_meeting_v;
CREATE OR REPLACE SYNONYM dct_tm_task_update_v  FOR prod.dct_tm_task_update_v;
CREATE OR REPLACE SYNONYM dct_tm_role_perm_v    FOR prod.dct_tm_role_perm_v;
CREATE OR REPLACE SYNONYM dct_tm_document_v     FOR prod.dct_tm_document_v;
CREATE OR REPLACE SYNONYM dct_tm_task_assignees FOR prod.dct_tm_task_assignees;
CREATE OR REPLACE SYNONYM dct_users             FOR prod.dct_users;
CREATE OR REPLACE SYNONYM dct_document_types     FOR prod.dct_document_types;
-- shared objects (dct_rest, dct_auth, dct_lookup_categories/values, dct_users,
-- dct_documents, dct_document_types) already have ADMIN synonyms from earlier phases.

-- =============================================================================
-- 2. Module + handlers (wrapped in DDL so SQLcl skips bind scanning)
-- =============================================================================
CREATE OR REPLACE PROCEDURE setup_tm_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'tm.rest';

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

    PROCEDURE def_media(p_pattern VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => 'GET',
            p_source_type => ORDS.source_type_media,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

BEGIN

    BEGIN
        ORDS.DELETE_MODULE(p_module_name => c_mod);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    ORDS.DEFINE_MODULE(
        p_module_name    => c_mod,
        p_base_path      => '/tm/',
        p_items_per_page => 100,
        p_status         => 'PUBLISHED',
        p_comments       => 'i-Finance -- Task Management REST API (App 207)');

    -- =========================================================================
    -- BOOT / REFERENCE -- lookups + team-role templates for UI dropdowns
    -- =========================================================================
    def_template('boot');
    def_handler('boot', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('userId', l_uid);
  APEX_JSON.write('isTmAdmin', dct_tm_pkg.is_tm_admin(l_uid));
  APEX_JSON.open_array('lookups');
  FOR r IN (
    SELECT c.category_code, v.value_code, v.value_name_en, v.value_name_ar, v.display_order
    FROM dct_lookup_values v JOIN dct_lookup_categories c ON c.category_id = v.category_id
    WHERE c.category_code LIKE 'TM\_%' ESCAPE '\' AND v.is_active = 'Y'
    ORDER BY c.category_code, v.display_order
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('category', r.category_code);
    APEX_JSON.write('code',     r.value_code);
    APEX_JSON.write('nameEn',   r.value_name_en);
    APEX_JSON.write('nameAr',   NVL(r.value_name_ar,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('roles');
  FOR r IN (SELECT role_code, role_name_en, role_name_ar, is_leader_role FROM dct_tm_roles WHERE is_active='Y' ORDER BY display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.role_code);
    APEX_JSON.write('nameEn', r.role_name_en);
    APEX_JSON.write('nameAr', NVL(r.role_name_ar,''));
    APEX_JSON.write('isLeader', r.is_leader_role);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('docTypes');
  FOR r IN (SELECT doc_type_id, doc_type_code, doc_type_name_en FROM dct_document_types
            WHERE is_active='Y' ORDER BY display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.doc_type_id);
    APEX_JSON.write('code', r.doc_type_code);
    APEX_JSON.write('nameEn', r.doc_type_name_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DASHBOARD
    -- =========================================================================
    def_template('dashboard');
    def_handler('dashboard', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_teams NUMBER; l_my_open NUMBER; l_my_overdue NUMBER; l_risks NUMBER; l_deliv_due NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT COUNT(DISTINCT m.team_id) INTO l_teams FROM dct_tm_members m WHERE m.user_id=l_uid AND m.is_active='Y';
  SELECT COUNT(*) INTO l_my_open FROM dct_tm_my_task_v WHERE user_id=l_uid AND status NOT IN ('DONE','CANCELLED');
  SELECT COUNT(*) INTO l_my_overdue FROM dct_tm_my_task_v WHERE user_id=l_uid AND is_overdue='Y';
  SELECT COUNT(*) INTO l_risks FROM dct_tm_log_v WHERE item_type IN ('ISSUE','RISK') AND status='OPEN';
  SELECT COUNT(*) INTO l_deliv_due FROM dct_tm_deliverable_v WHERE status NOT IN ('ACCEPTED') AND due_date IS NOT NULL AND due_date <= TRUNC(SYSDATE)+14;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('myTeams', l_teams);
  APEX_JSON.write('myOpenTasks', l_my_open);
  APEX_JSON.write('myOverdue', l_my_overdue);
  APEX_JSON.write('openRisks', l_risks);
  APEX_JSON.write('deliverablesDue', l_deliv_due);
  -- teams RAG breakdown
  APEX_JSON.open_array('teamsByHealth');
  FOR r IN (SELECT NVL(health_rag,'GREEN') rag, COUNT(*) n FROM dct_tm_team_v WHERE is_active='Y' GROUP BY NVL(health_rag,'GREEN')) LOOP
    APEX_JSON.open_object; APEX_JSON.write('rag', r.rag); APEX_JSON.write('count', r.n); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  -- teams by class
  APEX_JSON.open_array('teamsByClass');
  FOR r IN (SELECT team_class, COUNT(*) n FROM dct_tm_team_v WHERE is_active='Y' GROUP BY team_class) LOOP
    APEX_JSON.open_object; APEX_JSON.write('cls', r.team_class); APEX_JSON.write('count', r.n); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- TEAMS
    -- =========================================================================
    def_template('teams');
    def_handler('teams', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
  l_type   VARCHAR2(30)  := UPPER([COLON]type);
  l_class  VARCHAR2(30)  := UPPER([COLON]class);
  l_cat    VARCHAR2(50)  := [COLON]category;
  l_status VARCHAR2(30)  := UPPER([COLON]status);
  l_search VARCHAR2(200) := [COLON]search;
  l_mine   VARCHAR2(1)   := UPPER([COLON]mine);
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT COUNT(*) INTO l_total FROM dct_tm_team_v t
  WHERE (l_type IS NULL OR t.team_type=l_type) AND (l_class IS NULL OR t.team_class=l_class)
    AND (l_cat IS NULL OR t.team_category=l_cat) AND (l_status IS NULL OR t.status=l_status)
    AND (l_search IS NULL OR UPPER(t.team_name_en||' '||t.team_code) LIKE '%'||UPPER(l_search)||'%')
    AND (l_mine != 'Y' OR EXISTS (SELECT 1 FROM dct_tm_members m WHERE m.team_id=t.team_id AND m.user_id=l_uid AND m.is_active='Y'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_tm_team_v t
    WHERE (l_type IS NULL OR t.team_type=l_type) AND (l_class IS NULL OR t.team_class=l_class)
      AND (l_cat IS NULL OR t.team_category=l_cat) AND (l_status IS NULL OR t.status=l_status)
      AND (l_search IS NULL OR UPPER(t.team_name_en||' '||t.team_code) LIKE '%'||UPPER(l_search)||'%')
      AND (l_mine != 'Y' OR EXISTS (SELECT 1 FROM dct_tm_members m WHERE m.team_id=t.team_id AND m.user_id=l_uid AND m.is_active='Y'))
    ORDER BY t.team_id DESC OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('teamId', r.team_id); APEX_JSON.write('teamCode', r.team_code);
    APEX_JSON.write('nameEn', r.team_name_en); APEX_JSON.write('nameAr', NVL(r.team_name_ar,''));
    APEX_JSON.write('type', r.team_type); APEX_JSON.write('class', r.team_class);
    APEX_JSON.write('category', NVL(r.team_category,'')); APEX_JSON.write('status', r.status);
    APEX_JSON.write('health', NVL(r.health_rag,'GREEN'));
    APEX_JSON.write('leaderName', NVL(r.leader_name,'')); APEX_JSON.write('orgName', NVL(r.org_name,''));
    APEX_JSON.write('memberCount', r.member_count); APEX_JSON.write('objectiveCount', r.objective_count);
    APEX_JSON.write('taskCount', r.task_count); APEX_JSON.write('taskDone', r.task_done_count);
    APEX_JSON.write('taskOverdue', r.task_overdue_count); APEX_JSON.write('deliverableCount', r.deliverable_count);
    APEX_JSON.write('openRisks', r.open_risk_count);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('teams', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_id := dct_tm_pkg.create_team(
    p_actor_id => l_uid,
    p_name_en  => APEX_JSON.get_varchar2(p_path=>'nameEn'),
    p_type     => APEX_JSON.get_varchar2(p_path=>'type'),
    p_class    => APEX_JSON.get_varchar2(p_path=>'class'),
    p_leader_id=> NVL(APEX_JSON.get_number(p_path=>'leaderId'), l_uid),
    p_category => APEX_JSON.get_varchar2(p_path=>'category'),
    p_name_ar  => APEX_JSON.get_varchar2(p_path=>'nameAr'),
    p_objective=> APEX_JSON.get_varchar2(p_path=>'objective'),
    p_purpose  => APEX_JSON.get_varchar2(p_path=>'purpose'),
    p_org_id   => APEX_JSON.get_number(p_path=>'orgId'));
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('teamId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('teams/[COLON]id');
    def_handler('teams/[COLON]id', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM dct_tm_team_v WHERE team_id = [COLON]id) LOOP
    l_found := 1;
    APEX_JSON.open_object;
    APEX_JSON.write('teamId', r.team_id); APEX_JSON.write('teamCode', r.team_code);
    APEX_JSON.write('nameEn', r.team_name_en); APEX_JSON.write('nameAr', NVL(r.team_name_ar,''));
    APEX_JSON.write('objective', NVL(r.objective,'')); APEX_JSON.write('purpose', NVL(r.purpose,''));
    APEX_JSON.write('type', r.team_type); APEX_JSON.write('class', r.team_class);
    APEX_JSON.write('category', NVL(r.team_category,'')); APEX_JSON.write('status', r.status);
    APEX_JSON.write('health', NVL(r.health_rag,'GREEN'));
    APEX_JSON.write('leaderUserId', r.leader_user_id); APEX_JSON.write('leaderName', NVL(r.leader_name,''));
    APEX_JSON.write('orgId', r.org_id); APEX_JSON.write('orgName', NVL(r.org_name,''));
    APEX_JSON.write('startDate', TO_CHAR(r.start_date,'YYYY-MM-DD')); APEX_JSON.write('endDate', TO_CHAR(r.end_date,'YYYY-MM-DD'));
    APEX_JSON.write('memberCount', r.member_count); APEX_JSON.write('objectiveCount', r.objective_count);
    APEX_JSON.write('taskCount', r.task_count); APEX_JSON.write('taskDone', r.task_done_count);
    APEX_JSON.write('taskOverdue', r.task_overdue_count); APEX_JSON.write('deliverableCount', r.deliverable_count);
    APEX_JSON.write('openRisks', r.open_risk_count);
    APEX_JSON.close_object;
  END LOOP;
  IF l_found = 0 THEN dct_rest.err(404,'Team not found'); END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('teams/[COLON]id', 'PUT', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_pkg.update_team(
    p_actor_id => l_uid, p_team_id => [COLON]id,
    p_name_en => APEX_JSON.get_varchar2(p_path=>'nameEn'), p_name_ar => APEX_JSON.get_varchar2(p_path=>'nameAr'),
    p_type => APEX_JSON.get_varchar2(p_path=>'type'), p_class => APEX_JSON.get_varchar2(p_path=>'class'),
    p_category => APEX_JSON.get_varchar2(p_path=>'category'), p_objective => APEX_JSON.get_varchar2(p_path=>'objective'),
    p_purpose => APEX_JSON.get_varchar2(p_path=>'purpose'), p_status => APEX_JSON.get_varchar2(p_path=>'status'),
    p_leader_id => APEX_JSON.get_number(p_path=>'leaderId'), p_org_id => APEX_JSON.get_number(p_path=>'orgId'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok', 1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- MEMBERS  (list by ?teamId= ; add/role/remove via POST actions)
    -- =========================================================================
    def_template('members');
    def_handler('members', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_team NUMBER := TO_NUMBER([COLON]teamId DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_member_v WHERE team_id=l_team AND is_active='Y' ORDER BY is_leader_role DESC, member_name) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('memberId', r.member_id); APEX_JSON.write('userId', r.user_id);
    APEX_JSON.write('name', NVL(r.member_name,'')); APEX_JSON.write('email', NVL(r.member_email,''));
    APEX_JSON.write('roleCode', r.role_code); APEX_JSON.write('roleName', r.role_name);
    APEX_JSON.write('isLeader', r.is_leader_role); APEX_JSON.write('title', NVL(r.title,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('members/add');
    def_handler('members/add', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_pkg.add_member(l_uid, APEX_JSON.get_number(p_path=>'teamId'), APEX_JSON.get_number(p_path=>'userId'),
    APEX_JSON.get_varchar2(p_path=>'roleCode'), APEX_JSON.get_varchar2(p_path=>'title'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('members/role');
    def_handler('members/role', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_pkg.set_member_role(l_uid, APEX_JSON.get_number(p_path=>'teamId'), APEX_JSON.get_number(p_path=>'userId'), APEX_JSON.get_varchar2(p_path=>'roleCode'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('members/remove');
    def_handler('members/remove', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_pkg.remove_member(l_uid, APEX_JSON.get_number(p_path=>'teamId'), APEX_JSON.get_number(p_path=>'userId'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('members/update');
    def_handler('members/update', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_pkg.update_member(l_uid, APEX_JSON.get_number(p_path=>'teamId'), APEX_JSON.get_number(p_path=>'userId'),
    APEX_JSON.get_varchar2(p_path=>'roleCode'), APEX_JSON.get_varchar2(p_path=>'title'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- USERS  (active-user picker for member / assignee selection)
    -- =========================================================================
    def_template('users');
    def_handler('users', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session;
  l_search VARCHAR2(200) := [COLON]search;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (
    SELECT user_id, display_name, email FROM dct_users
    WHERE is_active = 'Y' AND NVL(is_external,'N') = 'N'
      AND (l_search IS NULL OR UPPER(display_name) LIKE '%'||UPPER(l_search)||'%'
           OR UPPER(email) LIKE '%'||UPPER(l_search)||'%')
    ORDER BY display_name FETCH FIRST 200 ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('userId', r.user_id);
    APEX_JSON.write('name', NVL(r.display_name,''));
    APEX_JSON.write('email', NVL(r.email,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- PERMISSIONS  (effective matrix by ?teamId=&roleCode= ; override via POST)
    -- =========================================================================
    def_template('perms');
    def_handler('perms', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session;
  l_team NUMBER := TO_NUMBER([COLON]teamId DEFAULT NULL ON CONVERSION ERROR);
  l_role VARCHAR2(30) := [COLON]roleCode;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  -- effective: per-team override if present else template default
  FOR r IN (
    SELECT rp.artifact_type,
           MAX(CASE WHEN NVL(rp.team_id,-1)=NVL(l_team,-1) THEN 1 ELSE 0 END) has_override,
           rp.can_create, rp.can_read, rp.can_update, rp.can_delete, rp.team_id
    FROM dct_tm_role_perm_v rp JOIN dct_tm_roles ro ON ro.tm_role_id=rp.tm_role_id
    WHERE ro.role_code=l_role AND NVL(rp.team_id,-1) IN (-1, NVL(l_team,-1))
    GROUP BY rp.artifact_type, rp.can_create, rp.can_read, rp.can_update, rp.can_delete, rp.team_id
  ) LOOP
    NULL; -- placeholder; effective resolution done below
  END LOOP;
  -- simpler effective query: pick override row first
  FOR r IN (
    SELECT art, can_create, can_read, can_update, can_delete FROM (
      SELECT rp.artifact_type art, rp.can_create, rp.can_read, rp.can_update, rp.can_delete,
             ROW_NUMBER() OVER (PARTITION BY rp.artifact_type ORDER BY NVL(rp.team_id,-1) DESC) rn
      FROM dct_tm_role_perm_v rp JOIN dct_tm_roles ro ON ro.tm_role_id=rp.tm_role_id
      WHERE ro.role_code=l_role AND NVL(rp.team_id,-1) IN (-1, NVL(l_team,-1))
    ) WHERE rn=1 ORDER BY art
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('artifact', r.art); APEX_JSON.write('canCreate', r.can_create);
    APEX_JSON.write('canRead', r.can_read); APEX_JSON.write('canUpdate', r.can_update);
    APEX_JSON.write('canDelete', r.can_delete);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('perms', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_pkg.set_team_role_perm(l_uid, APEX_JSON.get_number(p_path=>'teamId'), APEX_JSON.get_varchar2(p_path=>'roleCode'),
    APEX_JSON.get_varchar2(p_path=>'artifact'), APEX_JSON.get_varchar2(p_path=>'canCreate'),
    APEX_JSON.get_varchar2(p_path=>'canRead'), APEX_JSON.get_varchar2(p_path=>'canUpdate'), APEX_JSON.get_varchar2(p_path=>'canDelete'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- OBJECTIVES  (GET ?teamId= ; POST upsert)
    -- =========================================================================
    def_template('objectives');
    def_handler('objectives', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_team NUMBER := TO_NUMBER([COLON]teamId DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_objective_v WHERE team_id=l_team ORDER BY display_order, objective_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('objectiveId', r.objective_id); APEX_JSON.write('titleEn', r.title_en);
    APEX_JSON.write('titleAr', NVL(r.title_ar,'')); APEX_JSON.write('description', NVL(r.description,''));
    APEX_JSON.write('ownerId', r.owner_user_id); APEX_JSON.write('ownerName', NVL(r.owner_name,''));
    APEX_JSON.write('weight', r.weight); APEX_JSON.write('progress', r.progress_pct);
    APEX_JSON.write('progressMode', NVL(r.progress_mode,'AUTO'));
    APEX_JSON.write('targetDate', TO_CHAR(r.target_date,'YYYY-MM-DD')); APEX_JSON.write('status', r.status);
    APEX_JSON.write('taskCount', r.task_count); APEX_JSON.write('taskDone', r.task_done_count);
    APEX_JSON.write('krCount', r.kr_count); APEX_JSON.write('krAchieved', r.kr_achieved_count);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('objectives', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  l_id := dct_tm_pkg.upsert_objective(l_uid, APEX_JSON.get_number(p_path=>'teamId'), APEX_JSON.get_varchar2(p_path=>'titleEn'),
    APEX_JSON.get_number(p_path=>'objectiveId'), APEX_JSON.get_varchar2(p_path=>'titleAr'), APEX_JSON.get_varchar2(p_path=>'description'),
    APEX_JSON.get_number(p_path=>'ownerId'), NVL(APEX_JSON.get_number(p_path=>'weight'),1), APEX_JSON.get_number(p_path=>'progress'),
    TO_DATE(APEX_JSON.get_varchar2(p_path=>'targetDate'),'YYYY-MM-DD'), NVL(APEX_JSON.get_varchar2(p_path=>'status'),'NOT_STARTED'),
    APEX_JSON.get_varchar2(p_path=>'progressMode'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('objectiveId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- DELETE /objectives/:id  (removes the objective and cascades its key results)
    def_template('objectives/[COLON]id');
    def_handler('objectives/[COLON]id', 'DELETE', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_tm_pkg.delete_objective(l_uid, TO_NUMBER([COLON]id));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- KEY RESULTS  (measurable targets per objective)
    -- =========================================================================
    def_template('key-results');
    def_handler('key-results', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_obj NUMBER := TO_NUMBER([COLON]objectiveId DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_key_result_v WHERE objective_id=l_obj ORDER BY display_order, kr_id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('krId', r.kr_id); APEX_JSON.write('objectiveId', r.objective_id);
    APEX_JSON.write('titleEn', r.title_en); APEX_JSON.write('titleAr', NVL(r.title_ar,''));
    APEX_JSON.write('unit', NVL(r.unit,'')); APEX_JSON.write('direction', r.direction);
    APEX_JSON.write('baseline', r.baseline_value); APEX_JSON.write('target', r.target_value);
    APEX_JSON.write('current', r.current_value); APEX_JSON.write('weight', r.weight);
    APEX_JSON.write('progress', r.progress_pct);
    APEX_JSON.write('targetDate', TO_CHAR(r.target_date,'YYYY-MM-DD')); APEX_JSON.write('status', r.status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('key-results', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  l_id := dct_tm_pkg.upsert_key_result(l_uid, APEX_JSON.get_number(p_path=>'objectiveId'), APEX_JSON.get_varchar2(p_path=>'titleEn'),
    APEX_JSON.get_number(p_path=>'krId'), APEX_JSON.get_varchar2(p_path=>'titleAr'), APEX_JSON.get_varchar2(p_path=>'unit'),
    NVL(APEX_JSON.get_varchar2(p_path=>'direction'),'INCREASE'), APEX_JSON.get_number(p_path=>'baseline'),
    APEX_JSON.get_number(p_path=>'target'), APEX_JSON.get_number(p_path=>'current'), NVL(APEX_JSON.get_number(p_path=>'weight'),1),
    TO_DATE(APEX_JSON.get_varchar2(p_path=>'targetDate'),'YYYY-MM-DD'), NVL(APEX_JSON.get_varchar2(p_path=>'status'),'NOT_STARTED'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('krId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- POST /key-results/value  (quick "update measurement" -- sets current_value)
    def_template('key-results/value');
    def_handler('key-results/value', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_pkg.record_kr_value(l_uid, APEX_JSON.get_number(p_path=>'krId'), APEX_JSON.get_number(p_path=>'current'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- DELETE /key-results/:id
    def_template('key-results/[COLON]id');
    def_handler('key-results/[COLON]id', 'DELETE', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_tm_pkg.delete_key_result(l_uid, TO_NUMBER([COLON]id));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- TASKS
    -- =========================================================================
    def_template('tasks');
    def_handler('tasks', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session;
  l_team NUMBER := TO_NUMBER([COLON]teamId DEFAULT NULL ON CONVERSION ERROR);
  l_status VARCHAR2(20) := UPPER([COLON]status); l_search VARCHAR2(200) := [COLON]search;
  l_limit NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR),100),200);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR),0),0);
  l_total NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_tm_task_v t
  WHERE (l_team IS NULL OR t.team_id=l_team) AND (l_status IS NULL OR t.status=l_status)
    AND (l_search IS NULL OR UPPER(t.title) LIKE '%'||UPPER(l_search)||'%');
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total',l_total); APEX_JSON.write('limit',l_limit); APEX_JSON.write('offset',l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_tm_task_v t
    WHERE (l_team IS NULL OR t.team_id=l_team) AND (l_status IS NULL OR t.status=l_status)
      AND (l_search IS NULL OR UPPER(t.title) LIKE '%'||UPPER(l_search)||'%')
    ORDER BY t.task_id DESC OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('taskId', r.task_id); APEX_JSON.write('taskCode', r.task_code);
    APEX_JSON.write('teamId', r.team_id); APEX_JSON.write('teamName', NVL(r.team_name,''));
    APEX_JSON.write('objectiveId', r.objective_id); APEX_JSON.write('objectiveTitle', NVL(r.objective_title,''));
    APEX_JSON.write('title', r.title); APEX_JSON.write('description', NVL(r.description,''));
    APEX_JSON.write('priority', r.priority); APEX_JSON.write('status', r.status);
    APEX_JSON.write('progress', r.progress_pct);
    APEX_JSON.write('startDate', TO_CHAR(r.start_date,'YYYY-MM-DD')); APEX_JSON.write('dueDate', TO_CHAR(r.due_date,'YYYY-MM-DD'));
    APEX_JSON.write('isOverdue', r.is_overdue); APEX_JSON.write('assignees', NVL(r.assignees,''));
    APEX_JSON.write('subtaskCount', r.subtask_count);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('tasks', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  l_id := dct_tm_pkg.upsert_task(l_uid, APEX_JSON.get_number(p_path=>'teamId'), APEX_JSON.get_varchar2(p_path=>'title'),
    APEX_JSON.get_number(p_path=>'taskId'), APEX_JSON.get_number(p_path=>'objectiveId'), APEX_JSON.get_number(p_path=>'parentId'),
    APEX_JSON.get_varchar2(p_path=>'description'), NVL(APEX_JSON.get_varchar2(p_path=>'priority'),'MEDIUM'),
    NVL(APEX_JSON.get_varchar2(p_path=>'status'),'TODO'), APEX_JSON.get_number(p_path=>'progress'),
    TO_DATE(APEX_JSON.get_varchar2(p_path=>'startDate'),'YYYY-MM-DD'), TO_DATE(APEX_JSON.get_varchar2(p_path=>'dueDate'),'YYYY-MM-DD'),
    APEX_JSON.get_number(p_path=>'estHours'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('taskId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('tasks/status');
    def_handler('tasks/status', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_pkg.set_task_status(l_uid, APEX_JSON.get_number(p_path=>'taskId'), APEX_JSON.get_varchar2(p_path=>'status'),
    APEX_JSON.get_number(p_path=>'progress'), APEX_JSON.get_varchar2(p_path=>'comment'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('tasks/assign');
    def_handler('tasks/assign', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  IF NVL(APEX_JSON.get_varchar2(p_path=>'remove'),'N')='Y' THEN
    dct_tm_pkg.unassign_task(l_uid, APEX_JSON.get_number(p_path=>'taskId'), APEX_JSON.get_number(p_path=>'userId'));
  ELSE
    dct_tm_pkg.assign_task(l_uid, APEX_JSON.get_number(p_path=>'taskId'), APEX_JSON.get_number(p_path=>'userId'), NVL(APEX_JSON.get_varchar2(p_path=>'primary'),'N'));
  END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('tasks/assignees');
    def_handler('tasks/assignees', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_task NUMBER := TO_NUMBER([COLON]taskId DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (
    SELECT a.user_id, u.display_name AS name, a.is_primary, a.assigned_by, a.assigned_at
    FROM dct_tm_task_assignees a JOIN dct_users u ON u.user_id = a.user_id
    WHERE a.task_id = l_task
    ORDER BY a.is_primary DESC, u.display_name
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('userId', r.user_id); APEX_JSON.write('name', NVL(r.name,''));
    APEX_JSON.write('isPrimary', r.is_primary); APEX_JSON.write('assignedBy', NVL(r.assigned_by,''));
    APEX_JSON.write('assignedAt', TO_CHAR(r.assigned_at,'YYYY-MM-DD HH24:MI'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('tasks/updates');
    def_handler('tasks/updates', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_task NUMBER := TO_NUMBER([COLON]taskId DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_task_update_v WHERE task_id=l_task ORDER BY created_at DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('updateId', r.update_id); APEX_JSON.write('type', r.update_type);
    APEX_JSON.write('body', NVL(r.body,'')); APEX_JSON.write('oldStatus', NVL(r.old_status,''));
    APEX_JSON.write('newStatus', NVL(r.new_status,'')); APEX_JSON.write('author', NVL(r.author_name,''));
    APEX_JSON.write('createdAt', TO_CHAR(r.created_at,'YYYY-MM-DD HH24:MI'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('tasks/update');
    def_handler('tasks/update', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  l_id := dct_tm_pkg.add_task_update(l_uid, APEX_JSON.get_number(p_path=>'taskId'), APEX_JSON.get_varchar2(p_path=>'body'),
    NVL(APEX_JSON.get_varchar2(p_path=>'type'),'COMMENT'), APEX_JSON.get_varchar2(p_path=>'mentions'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('updateId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('my-tasks');
    def_handler('my-tasks', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_status VARCHAR2(20) := UPPER([COLON]status);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_my_task_v WHERE user_id=l_uid AND (l_status IS NULL OR status=l_status) ORDER BY is_overdue DESC, due_date NULLS LAST) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('taskId', r.task_id); APEX_JSON.write('taskCode', r.task_code);
    APEX_JSON.write('teamId', r.team_id); APEX_JSON.write('teamName', NVL(r.team_name,''));
    APEX_JSON.write('title', r.title); APEX_JSON.write('priority', r.priority); APEX_JSON.write('status', r.status);
    APEX_JSON.write('progress', r.progress_pct); APEX_JSON.write('dueDate', TO_CHAR(r.due_date,'YYYY-MM-DD'));
    APEX_JSON.write('isOverdue', r.is_overdue); APEX_JSON.write('objectiveTitle', NVL(r.objective_title,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- DELIVERABLES
    -- =========================================================================
    def_template('deliverables');
    def_handler('deliverables', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_team NUMBER := TO_NUMBER([COLON]teamId DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_deliverable_v WHERE (l_team IS NULL OR team_id=l_team) ORDER BY deliverable_id DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('deliverableId', r.deliverable_id); APEX_JSON.write('code', r.deliverable_code);
    APEX_JSON.write('teamId', r.team_id); APEX_JSON.write('teamName', NVL(r.team_name,''));
    APEX_JSON.write('titleEn', r.title_en); APEX_JSON.write('titleAr', NVL(r.title_ar,''));
    APEX_JSON.write('type', NVL(r.deliverable_type,'')); APEX_JSON.write('status', r.status);
    APEX_JSON.write('progress', r.progress_pct); APEX_JSON.write('ownerName', NVL(r.owner_name,''));
    APEX_JSON.write('dueDate', TO_CHAR(r.due_date,'YYYY-MM-DD')); APEX_JSON.write('isOverdue', r.is_overdue);
    APEX_JSON.write('acceptanceCriteria', NVL(r.acceptance_criteria,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('deliverables', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  l_id := dct_tm_pkg.upsert_deliverable(l_uid, APEX_JSON.get_number(p_path=>'teamId'), APEX_JSON.get_varchar2(p_path=>'titleEn'),
    APEX_JSON.get_number(p_path=>'deliverableId'), APEX_JSON.get_varchar2(p_path=>'titleAr'), APEX_JSON.get_number(p_path=>'objectiveId'),
    APEX_JSON.get_number(p_path=>'milestoneId'), APEX_JSON.get_varchar2(p_path=>'description'), APEX_JSON.get_number(p_path=>'ownerId'),
    APEX_JSON.get_varchar2(p_path=>'type'), NVL(APEX_JSON.get_varchar2(p_path=>'status'),'NOT_STARTED'),
    APEX_JSON.get_number(p_path=>'progress'), TO_DATE(APEX_JSON.get_varchar2(p_path=>'dueDate'),'YYYY-MM-DD'), APEX_JSON.get_varchar2(p_path=>'criteria'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('deliverableId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('deliverables/status');
    def_handler('deliverables/status', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_pkg.set_deliverable_status(l_uid, APEX_JSON.get_number(p_path=>'deliverableId'), APEX_JSON.get_varchar2(p_path=>'status'), APEX_JSON.get_varchar2(p_path=>'reason'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- RAID / MILESTONES / MEETINGS
    -- =========================================================================
    def_template('raid');
    def_handler('raid', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session;
  l_team NUMBER := TO_NUMBER([COLON]teamId DEFAULT NULL ON CONVERSION ERROR); l_type VARCHAR2(20) := UPPER([COLON]type);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_log_v WHERE (l_team IS NULL OR team_id=l_team) AND (l_type IS NULL OR item_type=l_type) ORDER BY log_id DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('logId', r.log_id); APEX_JSON.write('code', r.log_code); APEX_JSON.write('teamId', r.team_id);
    APEX_JSON.write('teamName', NVL(r.team_name,'')); APEX_JSON.write('type', r.item_type); APEX_JSON.write('title', r.title);
    APEX_JSON.write('description', NVL(r.description,'')); APEX_JSON.write('ownerName', NVL(r.owner_name,''));
    APEX_JSON.write('severity', NVL(r.severity,'')); APEX_JSON.write('likelihood', NVL(r.likelihood,''));
    APEX_JSON.write('impact', NVL(r.impact,'')); APEX_JSON.write('status', r.status);
    APEX_JSON.write('mitigation', NVL(r.mitigation,'')); APEX_JSON.write('dueDate', TO_CHAR(r.due_date,'YYYY-MM-DD'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('raid', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  l_id := dct_tm_pkg.upsert_log_item(l_uid, APEX_JSON.get_number(p_path=>'teamId'), APEX_JSON.get_varchar2(p_path=>'type'), APEX_JSON.get_varchar2(p_path=>'title'),
    APEX_JSON.get_number(p_path=>'logId'), APEX_JSON.get_varchar2(p_path=>'description'), APEX_JSON.get_number(p_path=>'objectiveId'),
    APEX_JSON.get_number(p_path=>'taskId'), APEX_JSON.get_number(p_path=>'ownerId'), APEX_JSON.get_varchar2(p_path=>'severity'),
    APEX_JSON.get_varchar2(p_path=>'likelihood'), APEX_JSON.get_varchar2(p_path=>'impact'), NVL(APEX_JSON.get_varchar2(p_path=>'status'),'OPEN'),
    APEX_JSON.get_varchar2(p_path=>'mitigation'), TO_DATE(APEX_JSON.get_varchar2(p_path=>'dueDate'),'YYYY-MM-DD'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('logId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('milestones');
    def_handler('milestones', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_team NUMBER := TO_NUMBER([COLON]teamId DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_milestone_v WHERE (l_team IS NULL OR team_id=l_team) ORDER BY due_date) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('milestoneId', r.milestone_id); APEX_JSON.write('teamId', r.team_id);
    APEX_JSON.write('titleEn', r.title_en); APEX_JSON.write('titleAr', NVL(r.title_ar,''));
    APEX_JSON.write('objectiveTitle', NVL(r.objective_title,'')); APEX_JSON.write('status', r.status);
    APEX_JSON.write('dueDate', TO_CHAR(r.due_date,'YYYY-MM-DD')); APEX_JSON.write('achievedDate', TO_CHAR(r.achieved_date,'YYYY-MM-DD'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('milestones', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  l_id := dct_tm_pkg.upsert_milestone(l_uid, APEX_JSON.get_number(p_path=>'teamId'), APEX_JSON.get_varchar2(p_path=>'titleEn'),
    TO_DATE(APEX_JSON.get_varchar2(p_path=>'dueDate'),'YYYY-MM-DD'), APEX_JSON.get_number(p_path=>'milestoneId'),
    APEX_JSON.get_varchar2(p_path=>'titleAr'), APEX_JSON.get_number(p_path=>'objectiveId'), APEX_JSON.get_varchar2(p_path=>'description'),
    NVL(APEX_JSON.get_varchar2(p_path=>'status'),'PENDING'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('milestoneId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('meetings');
    def_handler('meetings', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_team NUMBER := TO_NUMBER([COLON]teamId DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_meeting_v WHERE (l_team IS NULL OR team_id=l_team) ORDER BY meeting_date DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('meetingId', r.meeting_id); APEX_JSON.write('code', r.meeting_code); APEX_JSON.write('teamId', r.team_id);
    APEX_JSON.write('title', r.title); APEX_JSON.write('meetingDate', TO_CHAR(r.meeting_date,'YYYY-MM-DD'));
    APEX_JSON.write('location', NVL(r.location,'')); APEX_JSON.write('agenda', NVL(r.agenda,''));
    APEX_JSON.write('minutes', NVL(r.minutes,'')); APEX_JSON.write('attendees', NVL(r.attendees,''));
    APEX_JSON.write('status', r.status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('meetings', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  l_id := dct_tm_pkg.upsert_meeting(l_uid, APEX_JSON.get_number(p_path=>'teamId'), APEX_JSON.get_varchar2(p_path=>'title'),
    TO_DATE(APEX_JSON.get_varchar2(p_path=>'meetingDate'),'YYYY-MM-DD'), APEX_JSON.get_number(p_path=>'meetingId'),
    APEX_JSON.get_varchar2(p_path=>'location'), APEX_JSON.get_varchar2(p_path=>'agenda'), APEX_JSON.get_varchar2(p_path=>'minutes'),
    APEX_JSON.get_varchar2(p_path=>'attendees'), NVL(APEX_JSON.get_varchar2(p_path=>'status'),'PLANNED'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('meetingId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- DOCUMENTS LIBRARY (read of unified DCT_DOCUMENTS, TM slice)
    -- =========================================================================
    def_template('documents');
    def_handler('documents', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session;
  l_src VARCHAR2(30) := UPPER([COLON]sourceType); l_sid NUMBER := TO_NUMBER([COLON]sourceId DEFAULT NULL ON CONVERSION ERROR);
  l_search VARCHAR2(200) := [COLON]search;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_document_v
            WHERE (l_src IS NULL OR source_type=l_src) AND (l_sid IS NULL OR source_id=l_sid)
              AND (l_search IS NULL OR UPPER(file_name) LIKE '%'||UPPER(l_search)||'%')
            ORDER BY created_at DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docId', r.doc_id); APEX_JSON.write('sourceType', r.source_type); APEX_JSON.write('sourceId', r.source_id);
    APEX_JSON.write('docTypeCode', NVL(r.doc_type_code,'OTHER')); APEX_JSON.write('docTypeName', NVL(r.doc_type_name,'')); APEX_JSON.write('fileName', r.file_name);
    APEX_JSON.write('mimeType', NVL(r.mime_type,'')); APEX_JSON.write('fileSize', NVL(r.file_size_bytes,0)); APEX_JSON.write('notes', NVL(r.notes,''));
    APEX_JSON.write('uploadedBy', NVL(r.uploaded_by_name,'')); APEX_JSON.write('createdAt', TO_CHAR(r.created_at,'YYYY-MM-DD HH24:MI'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('documents', 'POST', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
  v_blob  BLOB; v_raw RAW(32767);
  v_b64   VARCHAR2(32767); v_len NUMBER; v_pos NUMBER := 1; v_chunk NUMBER := 32764;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  v_b64 := APEX_JSON.get_varchar2(p_path=>'fileB64');
  IF v_b64 IS NOT NULL THEN
    DBMS_LOB.CREATETEMPORARY(v_blob, TRUE); v_len := LENGTH(v_b64);
    WHILE v_pos <= v_len LOOP
      v_raw := UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(SUBSTR(v_b64, v_pos, v_chunk)));
      DBMS_LOB.WRITEAPPEND(v_blob, UTL_RAW.LENGTH(v_raw), v_raw);
      v_pos := v_pos + v_chunk;
    END LOOP;
  END IF;
  l_id := dct_tm_pkg.add_document(
    p_actor_id => l_uid, p_team_id => APEX_JSON.get_number(p_path=>'teamId'),
    p_source_type => NVL(APEX_JSON.get_varchar2(p_path=>'sourceType'),'TEAM'),
    p_source_id => APEX_JSON.get_number(p_path=>'sourceId'),
    p_file_name => APEX_JSON.get_varchar2(p_path=>'fileName'),
    p_doc_type_code => NVL(APEX_JSON.get_varchar2(p_path=>'docTypeCode'),'OTHER'),
    p_mime => APEX_JSON.get_varchar2(p_path=>'mimeType'),
    p_size => APEX_JSON.get_number(p_path=>'fileSize'),
    p_blob => v_blob, p_notes => APEX_JSON.get_varchar2(p_path=>'notes'),
    p_expiry => TO_DATE(APEX_JSON.get_varchar2(p_path=>'expiryDate'),'YYYY-MM-DD'));
  IF v_blob IS NOT NULL THEN DBMS_LOB.FREETEMPORARY(v_blob); END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('docId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('documents/update');
    def_handler('documents/update', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_pkg.update_document(l_uid, APEX_JSON.get_number(p_path=>'docId'), APEX_JSON.get_varchar2(p_path=>'fileName'),
    NVL(APEX_JSON.get_varchar2(p_path=>'docTypeCode'),'OTHER'), APEX_JSON.get_varchar2(p_path=>'notes'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- Raw-binary file upload / download for a TM document (created via POST
    -- documents with no fileB64). File bytes ARE the request body (no base64,
    -- no ~32 KB cap). Per the AR note, :body may be dereferenced only ONCE.
    def_template('documents/[COLON]id/file');
    def_handler('documents/[COLON]id/file', 'PUT', q'!
DECLARE
  l_user  VARCHAR2(100);
  l_uid   NUMBER;
  v_blob  BLOB;
  v_len   NUMBER;
  v_max   NUMBER;
BEGIN
  v_blob := [COLON]body;
  l_user := dct_rest.validate_session;
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF v_blob IS NULL OR DBMS_LOB.GETLENGTH(v_blob) = 0 THEN
    dct_rest.err(400,'Request body (file bytes) is required'); RETURN;
  END IF;
  v_len := DBMS_LOB.GETLENGTH(v_blob);
  BEGIN
    SELECT TO_NUMBER(ms.setting_value DEFAULT NULL ON CONVERSION ERROR)
    INTO   v_max
    FROM   dct_module_settings ms JOIN dct_modules m ON m.module_id = ms.module_id
    WHERE  m.module_code = 'TASK_MGMT' AND ms.setting_key = 'MAX_UPLOAD_MB';
  EXCEPTION WHEN NO_DATA_FOUND THEN v_max := NULL; END;
  v_max := NVL(v_max, 10);
  IF v_len > v_max * 1024 * 1024 THEN
    dct_rest.err(413,'File exceeds the maximum upload size of '||v_max||' MB'); RETURN;
  END IF;
  l_uid := dct_auth.get_user_id(l_user);
  UPDATE dct_documents SET
    file_blob       = v_blob,
    file_name       = NVL([COLON]file_name, file_name),
    mime_type       = NVL([COLON]mime_type, mime_type),
    file_size_bytes = v_len,
    updated_by      = l_uid, updated_at = SYSTIMESTAMP
  WHERE doc_id = [COLON]id AND source_module = 'TM';
  IF SQL%ROWCOUNT = 0 THEN ROLLBACK; dct_rest.err(404,'Document not found'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.write('fileSize', v_len);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');
    def_media('documents/[COLON]id/file',
      q'!SELECT mime_type, file_blob FROM dct_documents WHERE doc_id = [COLON]id AND source_module = 'TM'!');

    -- =========================================================================
    -- REMINDER PREFERENCES
    -- =========================================================================
    def_template('prefs');
    def_handler('prefs', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  FOR r IN (SELECT * FROM dct_tm_reminder_prefs WHERE user_id=l_uid) LOOP
    l_found := 1;
    APEX_JSON.write('leadDays', r.lead_days); APEX_JSON.write('remindOverdue', r.remind_overdue);
    APEX_JSON.write('channelInapp', r.channel_inapp); APEX_JSON.write('channelEmail', r.channel_email);
    APEX_JSON.write('dailyDigest', r.daily_digest); APEX_JSON.write('digestHour', r.digest_hour);
  END LOOP;
  IF l_found=0 THEN
    APEX_JSON.write('leadDays', 2); APEX_JSON.write('remindOverdue','Y'); APEX_JSON.write('channelInapp','Y');
    APEX_JSON.write('channelEmail','N'); APEX_JSON.write('dailyDigest','N'); APEX_JSON.write('digestHour',7);
  END IF;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('prefs', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_pkg.save_reminder_pref(l_uid, APEX_JSON.get_number(p_path=>'leadDays'), APEX_JSON.get_varchar2(p_path=>'remindOverdue'),
    APEX_JSON.get_varchar2(p_path=>'channelInapp'), APEX_JSON.get_varchar2(p_path=>'channelEmail'),
    APEX_JSON.get_varchar2(p_path=>'dailyDigest'), APEX_JSON.get_number(p_path=>'digestHour'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    COMMIT;
END;
/

BEGIN
    setup_tm_ords_tmp;
END;
/

DROP PROCEDURE setup_tm_ords_tmp;

PROMPT
PROMPT === 06_tm_ords.sql complete -- tm.rest published at /ords/admin/tm/ ===
