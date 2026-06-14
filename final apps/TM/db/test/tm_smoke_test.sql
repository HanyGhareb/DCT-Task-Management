-- =============================================================================
-- Task Management Module (App 207) -- DCT_TM_PKG functional test harness
-- File    : db/test/tm_smoke_test.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @test/tm_smoke_test.sql
-- Notes   : Self-contained PL/SQL assertion suite (utPLSQL is not installed on
--           this ADB). Exercises the package end-to-end then ROLLS BACK -- it
--           writes no permanent data. Covers Happy / Edge / Error / Boundary.
--           Picks three real active users from DCT_USERS as actor/member/outsider.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

DECLARE
    g_pass    NUMBER := 0;
    g_fail    NUMBER := 0;
    v_leader  NUMBER;
    v_member  NUMBER;
    v_outsider NUMBER;
    v_team    NUMBER;
    v_task    NUMBER;
    v_deliv   NUMBER;
    v_n       NUMBER;
    v_status  VARCHAR2(20);
    v_pct     NUMBER;
    v_role    VARCHAR2(30);
    v_done    DATE;

    PROCEDURE ok (p_cond BOOLEAN, p_msg VARCHAR2) IS
    BEGIN
        IF p_cond THEN
            g_pass := g_pass + 1;
            DBMS_OUTPUT.PUT_LINE('  PASS  ' || p_msg);
        ELSE
            g_fail := g_fail + 1;
            DBMS_OUTPUT.PUT_LINE('  FAIL  ' || p_msg);
        END IF;
    END ok;
BEGIN
    SELECT MIN(user_id) INTO v_leader FROM prod.dct_users WHERE is_active = 'Y';
    SELECT MIN(user_id) INTO v_member FROM prod.dct_users WHERE is_active = 'Y' AND user_id > v_leader;
    SELECT MIN(user_id) INTO v_outsider FROM prod.dct_users WHERE is_active = 'Y' AND user_id NOT IN (v_leader, v_member);
    DBMS_OUTPUT.PUT_LINE('Actors: leader=' || v_leader || ' member=' || v_member || ' outsider=' || v_outsider);

    -- 1. HAPPY: create a team with valid lookups
    v_team := prod.dct_tm_pkg.create_team(
                p_actor_id => v_leader, p_name_en => 'QA Strategic Team',
                p_type => 'INTERNAL', p_class => 'STRATEGIC', p_leader_id => v_leader,
                p_category => 'PROJECT');
    ok(v_team > 0, 'create_team returns a team id');

    -- leader auto-enrolled as LEADER member
    SELECT r.role_code INTO v_role
    FROM prod.dct_tm_members m JOIN prod.dct_tm_roles r ON r.tm_role_id = m.tm_role_id
    WHERE m.team_id = v_team AND m.user_id = v_leader AND m.is_active = 'Y';
    ok(v_role = 'LEADER', 'team creator auto-enrolled with LEADER role');

    -- 2. PERMISSION: leader can CREATE TASK; outsider cannot
    ok(prod.dct_tm_pkg.tm_can(v_leader, v_team, 'TASK', 'CREATE') = 'Y', 'leader can CREATE task');
    ok(prod.dct_tm_pkg.tm_can(v_outsider, v_team, 'TASK', 'CREATE') = 'N', 'non-member cannot CREATE task');

    -- 3. ERROR: invalid team_type lookup -> -20090
    BEGIN
        v_n := prod.dct_tm_pkg.create_team(v_leader, 'Bad', 'BOGUS', 'STRATEGIC', v_leader);
        ok(FALSE, 'invalid team_type should raise');
    EXCEPTION WHEN OTHERS THEN ok(SQLCODE = -20090, 'invalid team_type -> -20090 (got ' || SQLCODE || ')'); END;

    -- 4. BOUNDARY: 201-char name -> -20001
    BEGIN
        v_n := prod.dct_tm_pkg.create_team(v_leader, RPAD('X',201,'X'), 'INTERNAL', 'STRATEGIC', v_leader);
        ok(FALSE, '201-char name should raise');
    EXCEPTION WHEN OTHERS THEN ok(SQLCODE = -20001, '201-char team name -> -20001 (got ' || SQLCODE || ')'); END;

    -- 5. EDGE: null category is allowed (optional open lookup)
    BEGIN
        v_n := prod.dct_tm_pkg.create_team(v_leader, 'No Category Team', 'INTERNAL', 'OPERATIONAL', v_leader, p_category => NULL);
        ok(v_n > 0, 'null team_category accepted');
    EXCEPTION WHEN OTHERS THEN ok(FALSE, 'null category should be allowed (got ' || SQLERRM || ')'); END;

    -- 6. HAPPY: create a task
    v_task := prod.dct_tm_pkg.upsert_task(p_actor_id => v_leader, p_team_id => v_team, p_title => 'Kickoff', p_due => TRUNC(SYSDATE) + 5);
    ok(v_task > 0, 'upsert_task creates a task');

    -- 7. BOUNDARY: progress 101 -> -20001
    BEGIN
        v_n := prod.dct_tm_pkg.upsert_task(v_leader, v_team, 'OverPct', p_progress => 101);
        ok(FALSE, 'progress 101 should raise');
    EXCEPTION WHEN OTHERS THEN ok(SQLCODE = -20001, 'progress_pct 101 -> -20001 (got ' || SQLCODE || ')'); END;

    -- 8. HAPPY: move task to DONE -> pct 100 + completed_date set
    prod.dct_tm_pkg.set_task_status(v_leader, v_task, 'DONE');
    SELECT status, progress_pct, completed_date INTO v_status, v_pct, v_done FROM prod.dct_tm_tasks WHERE task_id = v_task;
    ok(v_status = 'DONE' AND v_pct = 100 AND v_done IS NOT NULL, 'set_task_status DONE -> 100% + completed_date');

    -- 9. status history row written
    SELECT COUNT(*) INTO v_n FROM prod.dct_request_status_history
     WHERE source_module = 'TM' AND source_type = 'TASK' AND source_id = v_task AND new_status = 'DONE';
    ok(v_n = 1, 'status transition logged to dct_request_status_history');

    -- 10. PERMISSION: a MEMBER may not edit team roles -> -20403
    prod.dct_tm_pkg.add_member(v_leader, v_team, v_member, 'MEMBER');
    BEGIN
        prod.dct_tm_pkg.set_member_role(p_actor_id => v_member, p_team_id => v_team, p_user_id => v_member, p_role_code => 'LEADER');
        ok(FALSE, 'MEMBER editing roles should be denied');
    EXCEPTION WHEN OTHERS THEN ok(SQLCODE = -20403, 'MEMBER edit role -> -20403 (got ' || SQLCODE || ')'); END;

    -- 11. EDGE: duplicate active member -> -20001
    BEGIN
        prod.dct_tm_pkg.add_member(v_leader, v_team, v_member, 'MEMBER');
        ok(FALSE, 'duplicate active member should raise');
    EXCEPTION WHEN OTHERS THEN ok(SQLCODE = -20001, 'duplicate active member -> -20001 (got ' || SQLCODE || ')'); END;

    -- 12. ERROR: deliverable rejected without reason -> -20001
    v_deliv := prod.dct_tm_pkg.upsert_deliverable(v_leader, v_team, 'Spec Doc', p_type => 'DOCUMENT');
    BEGIN
        prod.dct_tm_pkg.set_deliverable_status(v_leader, v_deliv, 'REJECTED');
        ok(FALSE, 'reject without reason should raise');
    EXCEPTION WHEN OTHERS THEN ok(SQLCODE = -20001, 'deliverable REJECTED w/o reason -> -20001 (got ' || SQLCODE || ')'); END;

    -- 13. BOUNDARY: reminder lead_days -1 -> -20001
    BEGIN
        prod.dct_tm_pkg.save_reminder_pref(p_user_id => v_member, p_lead_days => -1);
        ok(FALSE, 'negative lead_days should raise');
    EXCEPTION WHEN OTHERS THEN ok(SQLCODE = -20001, 'lead_days -1 -> -20001 (got ' || SQLCODE || ')'); END;

    -- 14. HAPPY: valid reminder pref persists
    prod.dct_tm_pkg.save_reminder_pref(p_user_id => v_member, p_lead_days => 3);
    SELECT lead_days INTO v_n FROM prod.dct_tm_reminder_prefs WHERE user_id = v_member;
    ok(v_n = 3, 'save_reminder_pref persists lead_days=3');

    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('RESULT: ' || g_pass || ' passed, ' || g_fail || ' failed (all changes rolled back)');
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('HARNESS ABORTED: ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/
exit
