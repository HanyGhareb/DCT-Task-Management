-- =============================================================================
-- Task Management Module (App 207) -- Cycle / Visibility / Exec ORDS endpoints
-- File    : 14_tm_cycle_ords.sql
-- Schema  : registered under ADMIN (the only REST-routable schema on ADB)
-- Base URL: /ords/admin/tm/   (ADDS handlers to the existing tm.rest module --
--           does NOT delete it, so 06_tm_ords.sql must run first)
-- Run     : sql -name prod_mcp @14_tm_cycle_ords.sql   (FRESH session -- synonym
--           rule: do NOT run after ALTER SESSION SET CURRENT_SCHEMA=PROD)
-- Notes   : Thin handlers over DCT_TM_CYCLE_PKG / DCT_TM_VIS_PKG + the cycle views.
--           validate_session on every route; error map -20401->401 -20403->403
--           -20404->404 -20001/-20090->400 else 500.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

-- ADMIN synonyms for the new PROD objects
CREATE OR REPLACE SYNONYM dct_tm_cycle_pkg         FOR prod.dct_tm_cycle_pkg;
CREATE OR REPLACE SYNONYM dct_tm_vis_pkg           FOR prod.dct_tm_vis_pkg;
CREATE OR REPLACE SYNONYM dct_tm_cycle_config_v    FOR prod.dct_tm_cycle_config_v;
CREATE OR REPLACE SYNONYM dct_tm_period_v          FOR prod.dct_tm_period_v;
CREATE OR REPLACE SYNONYM dct_tm_submission_v      FOR prod.dct_tm_submission_v;
CREATE OR REPLACE SYNONYM dct_tm_visibility_grant_v FOR prod.dct_tm_visibility_grant_v;
CREATE OR REPLACE SYNONYM dct_tm_exec_team_v       FOR prod.dct_tm_exec_team_v;
CREATE OR REPLACE SYNONYM dct_tm_team_tree_v       FOR prod.dct_tm_team_tree_v;
CREATE OR REPLACE SYNONYM dct_tm_periods           FOR prod.dct_tm_periods;
CREATE OR REPLACE SYNONYM dct_tm_submissions       FOR prod.dct_tm_submissions;
CREATE OR REPLACE SYNONYM dct_tm_ai_pkg            FOR prod.dct_tm_ai_pkg;

CREATE OR REPLACE PROCEDURE setup_tm_cycle_ords_tmp AS

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

BEGIN

    -- =========================================================================
    -- CYCLE CONFIG
    -- =========================================================================
    def_template('cycle-config');
    def_handler('cycle-config', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
  l_team NUMBER := TO_NUMBER([COLON]teamId DEFAULT NULL ON CONVERSION ERROR); l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  IF dct_tm_vis_pkg.can_view_team(l_uid, l_team) <> 'Y' THEN dct_rest.err(403,'Not permitted'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  FOR r IN (SELECT * FROM dct_tm_cycle_config_v WHERE team_id=l_team AND is_active='Y') LOOP
    l_found := 1;
    APEX_JSON.write('cycleConfigId', r.cycle_config_id); APEX_JSON.write('teamId', r.team_id);
    APEX_JSON.write('cadence', r.cadence); APEX_JSON.write('customDays', r.custom_days);
    APEX_JSON.write('anchorDate', TO_CHAR( dct_to_local(r.anchor_date),'YYYY-MM-DD'));
    APEX_JSON.write('leadDays', r.submission_lead_days); APEX_JSON.write('deadlineOffset', r.deadline_offset_days);
    APEX_JSON.write('reminderDays', r.reminder_days_before); APEX_JSON.write('escalateAfter', r.escalate_after_days);
    APEX_JSON.write('submitterScope', r.submitter_scope); APEX_JSON.write('autoClose', r.auto_close);
  END LOOP;
  APEX_JSON.write('exists', l_found);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('cycle-config', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_cycle_pkg.save_cycle_config(
    p_actor_id => l_uid, p_team_id => APEX_JSON.get_number(p_path=>'teamId'),
    p_cadence => APEX_JSON.get_varchar2(p_path=>'cadence'), p_custom_days => APEX_JSON.get_number(p_path=>'customDays'),
    p_anchor => TO_DATE(APEX_JSON.get_varchar2(p_path=>'anchorDate'),'YYYY-MM-DD'),
    p_lead_days => NVL(APEX_JSON.get_number(p_path=>'leadDays'),3),
    p_deadline_offset => NVL(APEX_JSON.get_number(p_path=>'deadlineOffset'),0),
    p_reminder_days => NVL(APEX_JSON.get_varchar2(p_path=>'reminderDays'),'3,1'),
    p_escalate_after => NVL(APEX_JSON.get_number(p_path=>'escalateAfter'),1),
    p_submitter_scope => NVL(APEX_JSON.get_varchar2(p_path=>'submitterScope'),'ALL_MEMBERS'),
    p_auto_close => NVL(APEX_JSON.get_varchar2(p_path=>'autoClose'),'Y'));
  -- pre-generate the upcoming periods immediately so the team sees its schedule
  DECLARE v NUMBER; BEGIN v := dct_tm_cycle_pkg.generate_periods(APEX_JSON.get_number(p_path=>'teamId')); END;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- PERIODS
    -- =========================================================================
    def_template('periods');
    def_handler('periods', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
  l_team NUMBER := TO_NUMBER([COLON]teamId DEFAULT NULL ON CONVERSION ERROR); l_status VARCHAR2(20) := UPPER([COLON]status);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_period_v
            WHERE (l_team IS NULL OR team_id=l_team) AND (l_status IS NULL OR status=l_status)
              AND team_id IN (SELECT column_value FROM TABLE(dct_tm_vis_pkg.visible_teams(l_uid)))
            ORDER BY period_start DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('periodId', r.period_id); APEX_JSON.write('teamId', r.team_id); APEX_JSON.write('teamName', NVL(r.team_name_en,''));
    APEX_JSON.write('label', r.period_label); APEX_JSON.write('periodStart', TO_CHAR( dct_to_local(r.period_start),'YYYY-MM-DD'));
    APEX_JSON.write('periodEnd', TO_CHAR( dct_to_local(r.period_end),'YYYY-MM-DD')); APEX_JSON.write('dueDate', TO_CHAR( dct_to_local(r.due_date),'YYYY-MM-DD'));
    APEX_JSON.write('status', r.status); APEX_JSON.write('hasSnapshot', r.has_snapshot); APEX_JSON.write('hasAiSummary', r.has_ai_summary);
    APEX_JSON.write('submitterCount', r.submitter_count); APEX_JSON.write('submittedCount', r.submitted_count);
    APEX_JSON.write('lateCount', r.late_count); APEX_JSON.write('pendingCount', r.pending_count);
    APEX_JSON.write('signoffRag', NVL(r.signoff_rag,'')); APEX_JSON.write('signoffBy', NVL(r.signoff_by,''));
    APEX_JSON.write('closedAt', TO_CHAR( dct_to_local(r.closed_at),'YYYY-MM-DD HH24:MI'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('periods/generate');
    def_handler('periods/generate', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_team NUMBER; l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  l_team := APEX_JSON.get_number(p_path=>'teamId');
  IF dct_tm_pkg.tm_can(l_uid, l_team, 'PERIOD', 'UPDATE') <> 'Y' THEN dct_rest.err(403,'Permission denied'); RETURN; END IF;
  l_n := dct_tm_cycle_pkg.generate_periods(l_team);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('generated', l_n); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('periods/close');
    def_handler('periods/close', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_cycle_pkg.close_period(l_uid, APEX_JSON.get_number(p_path=>'periodId'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('periods/lock');
    def_handler('periods/lock', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_cycle_pkg.lock_period(l_uid, APEX_JSON.get_number(p_path=>'periodId'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('periods/signoff');
    def_handler('periods/signoff', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_cycle_pkg.leader_signoff(l_uid, APEX_JSON.get_number(p_path=>'periodId'),
    APEX_JSON.get_varchar2(p_path=>'summary'), APEX_JSON.get_varchar2(p_path=>'teamRag'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- period snapshot (executive immutable view of a closed period)
    def_template('periods/[COLON]id/snapshot');
    def_handler('periods/[COLON]id/snapshot', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_team NUMBER; l_snap CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  BEGIN
    SELECT team_id, snapshot_json INTO l_team, l_snap FROM dct_tm_periods WHERE period_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Period not found'); RETURN; END;
  IF dct_tm_vis_pkg.can_view_team(l_uid, l_team) <> 'Y' THEN dct_rest.err(403,'Not permitted'); RETURN; END IF;
  IF l_snap IS NULL THEN
    dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('snapshot', 'null'); APEX_JSON.close_object;
  ELSE
    OWA_UTIL.mime_header('application/json', TRUE); HTP.prn(l_snap);
  END IF;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- AI executive summary for a period (generate via POST; read stored via GET)
    def_template('periods/[COLON]id/ai-summary');
    def_handler('periods/[COLON]id/ai-summary', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_sum CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  l_sum := dct_tm_ai_pkg.summarize_period(l_uid, TO_NUMBER([COLON]id));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('summary', l_sum); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');
    def_handler('periods/[COLON]id/ai-summary', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_team NUMBER; l_sum CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  BEGIN SELECT team_id, ai_summary INTO l_team, l_sum FROM dct_tm_periods WHERE period_id = TO_NUMBER([COLON]id);
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Period not found'); RETURN; END;
  IF dct_tm_vis_pkg.can_view_team(l_uid, l_team) <> 'Y' THEN dct_rest.err(403,'Not permitted'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('summary', NVL(l_sum,'')); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- SUBMISSIONS (member check-in)
    -- =========================================================================
    -- roster for a period (leader / viewer)
    def_template('period-status');
    def_handler('period-status', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_pid NUMBER := TO_NUMBER([COLON]periodId DEFAULT NULL ON CONVERSION ERROR); l_team NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  BEGIN SELECT team_id INTO l_team FROM dct_tm_periods WHERE period_id=l_pid;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Period not found'); RETURN; END;
  IF dct_tm_vis_pkg.can_view_team(l_uid, l_team) <> 'Y' THEN dct_rest.err(403,'Not permitted'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_submission_v WHERE period_id=l_pid ORDER BY member_name) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('submissionId', r.submission_id); APEX_JSON.write('userId', r.user_id); APEX_JSON.write('name', NVL(r.member_name,''));
    APEX_JSON.write('status', r.status); APEX_JSON.write('isOnTime', NVL(r.is_on_time,''));
    APEX_JSON.write('accomplishments', NVL(r.accomplishments,'')); APEX_JSON.write('inProgress', NVL(r.in_progress,''));
    APEX_JSON.write('pending', NVL(r.pending,'')); APEX_JSON.write('blockers', NVL(r.blockers,'')); APEX_JSON.write('highlights', NVL(r.highlights,''));
    APEX_JSON.write('tasksDone', r.tasks_done); APEX_JSON.write('tasksOnTrack', r.tasks_on_track); APEX_JSON.write('tasksLate', r.tasks_late);
    APEX_JSON.write('tasksOpen', r.tasks_open); APEX_JSON.write('tasksOverdue', r.tasks_overdue);
    APEX_JSON.write('objectiveProgress', NVL(r.objective_progress,0)); APEX_JSON.write('deliverablesDone', r.deliverables_done);
    APEX_JSON.write('newRaid', r.new_raid_count); APEX_JSON.write('submittedAt', TO_CHAR( dct_to_local(r.submitted_at),'YYYY-MM-DD HH24:MI'));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- my own submissions across all teams (current/open periods first)
    def_template('my-submissions');
    def_handler('my-submissions', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_submission_v WHERE user_id=l_uid ORDER BY
              CASE period_status WHEN 'OPEN' THEN 0 WHEN 'DUE' THEN 1 ELSE 2 END, due_date DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('submissionId', r.submission_id); APEX_JSON.write('periodId', r.period_id);
    APEX_JSON.write('teamId', r.team_id); APEX_JSON.write('teamName', NVL(r.team_name_en,''));
    APEX_JSON.write('label', r.period_label); APEX_JSON.write('periodStatus', r.period_status);
    APEX_JSON.write('dueDate', TO_CHAR( dct_to_local(r.due_date),'YYYY-MM-DD')); APEX_JSON.write('status', r.status);
    APEX_JSON.write('tasksDone', r.tasks_done); APEX_JSON.write('tasksOpen', r.tasks_open); APEX_JSON.write('tasksOverdue', r.tasks_overdue);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- my submission for a period (returns existing row or a NOT_STARTED default)
    def_template('submissions');
    def_handler('submissions', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_pid NUMBER := TO_NUMBER([COLON]periodId DEFAULT NULL ON CONVERSION ERROR); l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  FOR r IN (SELECT * FROM dct_tm_submission_v WHERE period_id=l_pid AND user_id=l_uid) LOOP
    l_found := 1;
    APEX_JSON.write('submissionId', r.submission_id); APEX_JSON.write('periodId', r.period_id); APEX_JSON.write('status', r.status);
    APEX_JSON.write('periodStatus', r.period_status); APEX_JSON.write('label', r.period_label); APEX_JSON.write('dueDate', TO_CHAR( dct_to_local(r.due_date),'YYYY-MM-DD'));
    APEX_JSON.write('accomplishments', NVL(r.accomplishments,'')); APEX_JSON.write('inProgress', NVL(r.in_progress,''));
    APEX_JSON.write('pending', NVL(r.pending,'')); APEX_JSON.write('blockers', NVL(r.blockers,'')); APEX_JSON.write('highlights', NVL(r.highlights,''));
    APEX_JSON.write('tasksDone', r.tasks_done); APEX_JSON.write('tasksOnTrack', r.tasks_on_track); APEX_JSON.write('tasksLate', r.tasks_late);
    APEX_JSON.write('tasksOpen', r.tasks_open); APEX_JSON.write('tasksOverdue', r.tasks_overdue);
    APEX_JSON.write('objectiveProgress', NVL(r.objective_progress,0)); APEX_JSON.write('deliverablesDone', r.deliverables_done); APEX_JSON.write('newRaid', r.new_raid_count);
  END LOOP;
  APEX_JSON.write('exists', l_found);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('submissions/save');
    def_handler('submissions/save', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  l_id := dct_tm_cycle_pkg.save_submission(l_uid, APEX_JSON.get_number(p_path=>'periodId'),
    APEX_JSON.get_varchar2(p_path=>'accomplishments'), APEX_JSON.get_varchar2(p_path=>'inProgress'),
    APEX_JSON.get_varchar2(p_path=>'pending'), APEX_JSON.get_varchar2(p_path=>'blockers'),
    APEX_JSON.get_varchar2(p_path=>'highlights'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('submissionId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('submissions/submit');
    def_handler('submissions/submit', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_cycle_pkg.submit_submission(l_uid, APEX_JSON.get_number(p_path=>'periodId'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    -- =========================================================================
    -- VISIBILITY GRANTS (TM_ADMIN only)
    -- =========================================================================
    def_template('visibility-grants');
    def_handler('visibility-grants', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
  l_grantee NUMBER := TO_NUMBER([COLON]granteeUserId DEFAULT NULL ON CONVERSION ERROR); l_status VARCHAR2(20) := UPPER([COLON]status);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  IF dct_tm_pkg.is_tm_admin(l_uid) <> 'Y' THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_visibility_grant_v
            WHERE (l_grantee IS NULL OR grantee_user_id=l_grantee) AND (l_status IS NULL OR status=l_status)
            ORDER BY created_at DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('grantId', r.grant_id); APEX_JSON.write('granteeUserId', r.grantee_user_id); APEX_JSON.write('granteeName', NVL(r.grantee_name,''));
    APEX_JSON.write('scope', r.scope); APEX_JSON.write('teamId', r.team_id); APEX_JSON.write('teamName', NVL(r.team_name,''));
    APEX_JSON.write('orgId', r.org_id); APEX_JSON.write('orgName', NVL(r.org_name,''));
    APEX_JSON.write('accessLevel', r.access_level); APEX_JSON.write('grantedByName', NVL(r.granted_by_name,''));
    APEX_JSON.write('startDate', TO_CHAR( dct_to_local(r.start_date),'YYYY-MM-DD')); APEX_JSON.write('endDate', TO_CHAR( dct_to_local(r.end_date),'YYYY-MM-DD'));
    APEX_JSON.write('status', r.status); APEX_JSON.write('reason', NVL(r.reason,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_handler('visibility-grants', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  l_id := dct_tm_vis_pkg.create_grant(
    p_actor_id => l_uid, p_grantee_id => APEX_JSON.get_number(p_path=>'granteeUserId'),
    p_scope => APEX_JSON.get_varchar2(p_path=>'scope'), p_team_id => APEX_JSON.get_number(p_path=>'teamId'),
    p_org_id => APEX_JSON.get_number(p_path=>'orgId'), p_access_level => NVL(APEX_JSON.get_varchar2(p_path=>'accessLevel'),'VIEWER'),
    p_end_date => TO_DATE(APEX_JSON.get_varchar2(p_path=>'endDate'),'YYYY-MM-DD'), p_reason => APEX_JSON.get_varchar2(p_path=>'reason'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('grantId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20401 THEN dct_rest.err(401,SQLERRM); ELSIF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('visibility-grants/revoke');
    def_handler('visibility-grants/revoke', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_vis_pkg.revoke_grant(l_uid, APEX_JSON.get_number(p_path=>'grantId'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('my-visibility');
    def_handler('my-visibility', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_n NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  SELECT COUNT(*) INTO l_n FROM TABLE(dct_tm_vis_pkg.visible_teams(l_uid));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('canViewAll', dct_tm_vis_pkg.can_view_all(l_uid));
  APEX_JSON.write('isTmAdmin', dct_tm_pkg.is_tm_admin(l_uid));
  APEX_JSON.write('visibleTeamCount', l_n);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- TEAM HIERARCHY (parent set + tree)
    -- =========================================================================
    def_template('teams/parent');
    def_handler('teams/parent', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user); dct_rest.parse_body([COLON]body);
  dct_tm_vis_pkg.set_team_parent(l_uid, APEX_JSON.get_number(p_path=>'teamId'), APEX_JSON.get_number(p_path=>'parentTeamId'));
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE=-20403 THEN dct_rest.err(403,SQLERRM); ELSIF SQLCODE=-20404 THEN dct_rest.err(404,SQLERRM);
  ELSIF SQLCODE IN (-20001,-20090) THEN dct_rest.err(400,SQLERRM); ELSE dct_rest.err(500,SQLERRM); END IF;
END;
!');

    def_template('team-tree');
    def_handler('team-tree', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_team_tree_v
            WHERE team_id IN (SELECT column_value FROM TABLE(dct_tm_vis_pkg.visible_teams(l_uid)))
            ORDER BY name_path) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('teamId', r.team_id); APEX_JSON.write('parentTeamId', r.parent_team_id);
    APEX_JSON.write('teamCode', r.team_code); APEX_JSON.write('nameEn', r.team_name_en);
    APEX_JSON.write('depth', r.depth); APEX_JSON.write('rootTeamId', r.root_team_id);
    APEX_JSON.write('health', NVL(r.health_rag,'GREEN')); APEX_JSON.write('status', r.status);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- EXECUTIVE ROLL-UP (manager+; data scoped by visible_teams)
    -- =========================================================================
    def_template('exec/teams');
    def_handler('exec/teams', 'GET', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER;
  l_org NUMBER := TO_NUMBER([COLON]orgId DEFAULT NULL ON CONVERSION ERROR);
  l_parent NUMBER := TO_NUMBER([COLON]parentTeamId DEFAULT NULL ON CONVERSION ERROR);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.open_array('items');
  FOR r IN (SELECT * FROM dct_tm_exec_team_v
            WHERE team_id IN (SELECT column_value FROM TABLE(dct_tm_vis_pkg.visible_teams(l_uid)))
              AND (l_org IS NULL OR org_id=l_org)
              AND (l_parent IS NULL OR parent_team_id=l_parent)
            ORDER BY NVL(on_time_rate,-1), overdue_tasks DESC) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('teamId', r.team_id); APEX_JSON.write('teamCode', r.team_code); APEX_JSON.write('teamName', r.team_name_en);
    APEX_JSON.write('parentTeamId', r.parent_team_id); APEX_JSON.write('class', NVL(r.team_class,'')); APEX_JSON.write('status', r.status);
    APEX_JSON.write('health', NVL(r.health_rag,'GREEN')); APEX_JSON.write('orgId', r.org_id); APEX_JSON.write('orgName', NVL(r.org_name,''));
    APEX_JSON.write('leaderName', NVL(r.leader_name,'')); APEX_JSON.write('memberCount', r.member_count);
    APEX_JSON.write('openTasks', r.open_tasks); APEX_JSON.write('doneTasks', r.done_tasks); APEX_JSON.write('overdueTasks', r.overdue_tasks);
    APEX_JSON.write('highRisks', r.high_risks); APEX_JSON.write('objectiveProgress', NVL(r.objective_progress,0));
    APEX_JSON.write('onTimeRate', r.on_time_rate); APEX_JSON.write('latestPeriod', NVL(r.latest_period,''));
    APEX_JSON.write('latestPeriodStatus', NVL(r.latest_period_status,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array; APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- CUSTOM TEAM ROLES (TM_ADMIN only) -- create / update / retire + template perms
    -- =========================================================================
    def_template('roles');
    def_handler('roles', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_id NUMBER; l_code VARCHAR2(30);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  IF dct_tm_pkg.is_tm_admin(l_uid) <> 'Y' THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_code := UPPER(TRIM(APEX_JSON.get_varchar2(p_path=>'roleCode')));
  IF l_code IS NULL THEN dct_rest.err(400,'roleCode is required'); RETURN; END IF;
  MERGE INTO dct_tm_roles t
  USING (SELECT l_code AS rc FROM dual) s ON (t.role_code = s.rc)
  WHEN MATCHED THEN UPDATE SET role_name_en=APEX_JSON.get_varchar2(p_path=>'nameEn'),
    role_name_ar=APEX_JSON.get_varchar2(p_path=>'nameAr'), description_en=APEX_JSON.get_varchar2(p_path=>'descriptionEn'),
    is_leader_role=NVL(APEX_JSON.get_varchar2(p_path=>'isLeader'),'N'),
    display_order=NVL(APEX_JSON.get_number(p_path=>'displayOrder'),100), is_active='Y'
  WHEN NOT MATCHED THEN INSERT (role_code, role_name_en, role_name_ar, description_en, is_system, is_leader_role, display_order, created_by)
    VALUES (l_code, APEX_JSON.get_varchar2(p_path=>'nameEn'), APEX_JSON.get_varchar2(p_path=>'nameAr'),
            APEX_JSON.get_varchar2(p_path=>'descriptionEn'), 'N', NVL(APEX_JSON.get_varchar2(p_path=>'isLeader'),'N'),
            NVL(APEX_JSON.get_number(p_path=>'displayOrder'),100), l_user);
  SELECT tm_role_id INTO l_id FROM dct_tm_roles WHERE role_code = l_code;
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('tmRoleId', l_id); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('roles/retire');
    def_handler('roles/retire', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_sys VARCHAR2(1); l_rid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  IF dct_tm_pkg.is_tm_admin(l_uid) <> 'Y' THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_rid := APEX_JSON.get_number(p_path=>'tmRoleId');
  BEGIN SELECT is_system INTO l_sys FROM dct_tm_roles WHERE tm_role_id=l_rid;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Role not found'); RETURN; END;
  IF l_sys = 'Y' THEN dct_rest.err(400,'Built-in roles cannot be retired (their matrix is still editable).'); RETURN; END IF;
  UPDATE dct_tm_roles SET is_active='N' WHERE tm_role_id=l_rid; COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- upsert a TEMPLATE-default permission row (team_id NULL) for a role+artifact
    def_template('role-template-perm');
    def_handler('role-template-perm', 'POST', q'!
DECLARE l_user VARCHAR2(100) := dct_rest.validate_session; l_uid NUMBER; l_rid NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  IF dct_tm_pkg.is_tm_admin(l_uid) <> 'Y' THEN dct_rest.err(403,'Admin only'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  SELECT tm_role_id INTO l_rid FROM dct_tm_roles WHERE role_code = UPPER(APEX_JSON.get_varchar2(p_path=>'roleCode'));
  MERGE INTO dct_tm_role_perms t
  USING (SELECT l_rid AS rid, APEX_JSON.get_varchar2(p_path=>'artifact') AS art FROM dual) s
  ON (t.tm_role_id=s.rid AND NVL(t.team_id,-1)=-1 AND t.artifact_type=s.art)
  WHEN MATCHED THEN UPDATE SET can_create=NVL(APEX_JSON.get_varchar2(p_path=>'canCreate'),'N'),
    can_read=NVL(APEX_JSON.get_varchar2(p_path=>'canRead'),'Y'), can_update=NVL(APEX_JSON.get_varchar2(p_path=>'canUpdate'),'N'),
    can_delete=NVL(APEX_JSON.get_varchar2(p_path=>'canDelete'),'N')
  WHEN NOT MATCHED THEN INSERT (tm_role_id, team_id, artifact_type, can_create, can_read, can_update, can_delete, created_by)
    VALUES (l_rid, NULL, APEX_JSON.get_varchar2(p_path=>'artifact'), NVL(APEX_JSON.get_varchar2(p_path=>'canCreate'),'N'),
            NVL(APEX_JSON.get_varchar2(p_path=>'canRead'),'Y'), NVL(APEX_JSON.get_varchar2(p_path=>'canUpdate'),'N'),
            NVL(APEX_JSON.get_varchar2(p_path=>'canDelete'),'N'), l_user);
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object; APEX_JSON.write('ok',1); APEX_JSON.close_object;
EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Role not found');
WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END;
/

BEGIN
    setup_tm_cycle_ords_tmp;
END;
/

DROP PROCEDURE setup_tm_cycle_ords_tmp;

PROMPT
PROMPT === 14_tm_cycle_ords.sql complete -- cycle/visibility/exec routes added to tm.rest ===
