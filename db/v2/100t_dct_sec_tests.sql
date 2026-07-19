SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
-- 100t: Security Console foundation tests (99 DDL + 100 pkg).
-- Self-cleaning: every block ends with ROLLBACK; the final block restores the
-- committed closure with refresh_flat. Uses real master rows read-only.

PROMPT === part 1: closure, hierarchy guards, exclusions, copy ===

DECLARE
    pass NUMBER := 0; fail NUMBER := 0;
    n NUMBER;
    p1 NUMBER; p2 NUMBER; p3 NUMBER; p4 NUMBER;
    d1 NUMBER; d2 NUMBER; d3 NUMBER; j1 NUMBER; j2 NUMBER;
    g1 NUMBER; cp NUMBER;
    tu NUMBER;
    PROCEDURE ck (b BOOLEAN, m VARCHAR2) IS
    BEGIN
        IF b THEN pass := pass + 1; DBMS_OUTPUT.PUT_LINE('  pass  ' || m);
        ELSE fail := fail + 1; DBMS_OUTPUT.PUT_LINE('  FAIL  ' || m); END IF;
    END;
    FUNCTION mkperm (p_code VARCHAR2) RETURN NUMBER IS
        v NUMBER;
    BEGIN
        INSERT INTO prod.dct_permissions
            (permission_code, permission_name, action_type, verb, created_by)
        VALUES (p_code, 'Test ' || p_code, 'VIEW', 'VIEW', 'TEST')
        RETURNING permission_id INTO v;
        RETURN v;
    END;
    FUNCTION mkrole (p_code VARCHAR2, p_cat VARCHAR2) RETURN NUMBER IS
        v NUMBER;
    BEGIN
        INSERT INTO prod.dct_roles
            (role_code, role_name_en, role_type, role_category, created_by)
        VALUES (p_code, 'Test ' || p_code, 'MODULE', p_cat, 'TEST')
        RETURNING role_id INTO v;
        RETURN v;
    END;
    FUNCTION flat_has (p_role NUMBER, p_perm NUMBER) RETURN BOOLEAN IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_sec_role_priv_flat
         WHERE role_id = p_role AND permission_id = p_perm;
        RETURN v > 0;
    END;
BEGIN
    p1 := mkperm('TSEC_VIEW_ONE');
    p2 := mkperm('TSEC_VIEW_TWO');
    p3 := mkperm('TSEC_VIEW_THREE');
    p4 := mkperm('TSEC_VIEW_FOUR');
    d1 := mkrole('TSEC_DUTY_1', 'DUTY');
    d2 := mkrole('TSEC_DUTY_2', 'DUTY');
    d3 := mkrole('TSEC_DUTY_3', 'DUTY');
    j1 := mkrole('TSEC_JOB_1', 'JOB');
    j2 := mkrole('TSEC_JOB_2', 'JOB');

    INSERT INTO prod.dct_role_permissions (role_id, permission_id, granted_by)
    VALUES (d1, p1, 'TEST');

    INSERT INTO prod.dct_sec_priv_group (group_code, name_en, created_by)
    VALUES ('TSEC_GROUP_1', 'Test group', 'TEST')
    RETURNING group_id INTO g1;
    INSERT INTO prod.dct_sec_priv_group_item (group_id, permission_id, added_by)
    VALUES (g1, p2, 'TEST');
    INSERT INTO prod.dct_sec_priv_group_item (group_id, permission_id, added_by)
    VALUES (g1, p3, 'TEST');
    INSERT INTO prod.dct_sec_role_priv_group (role_id, group_id, granted_by)
    VALUES (d2, g1, 'TEST');

    prod.dct_sec.add_hierarchy(j1, d1, 'TEST');
    prod.dct_sec.add_hierarchy(j1, d2, 'TEST');
    prod.dct_sec.add_hierarchy(j2, d2, 'TEST');

    ck(flat_has(j1, p1), 'closure: direct perm of nested duty reaches job');
    ck(flat_has(j1, p2) AND flat_has(j1, p3), 'closure: group perms of nested duty reach job');
    ck(NOT flat_has(j1, p4), 'closure: ungranted perm absent');
    ck(flat_has(d2, p2), 'closure: duty role itself carries its group perms');

    -- role-scope exclusion applies to the excluding role only
    INSERT INTO prod.dct_sec_exclusion
        (scope_type, role_id, permission_id, reason, created_by)
    VALUES ('ROLE', j1, p2, 'test exclusion', 'TEST');
    prod.dct_sec.refresh_flat;
    ck(NOT flat_has(j1, p2), 'role exclusion removes perm from that job');
    ck(flat_has(j2, p2), 'role exclusion does not touch a sibling job');
    ck(flat_has(d2, p2), 'role exclusion does not touch the duty itself');

    -- hierarchy guards
    BEGIN
        prod.dct_sec.add_hierarchy(j1, j2, 'TEST');
        ck(FALSE, 'non-duty child rejected');
    EXCEPTION WHEN OTHERS THEN
        ck(SQLCODE = -20001, 'non-duty child rejected (' || SQLCODE || ')');
    END;
    prod.dct_sec.add_hierarchy(d1, d3, 'TEST');
    BEGIN
        prod.dct_sec.add_hierarchy(d3, d1, 'TEST');
        ck(FALSE, 'cycle rejected');
    EXCEPTION WHEN OTHERS THEN
        ck(SQLCODE = -20001 AND INSTR(SQLERRM, 'cycle') > 0,
           'cycle rejected (' || SQLCODE || ')');
    END;
    BEGIN
        prod.dct_sec.add_hierarchy(j1, d1, 'TEST');
        ck(FALSE, 'duplicate nesting rejected');
    EXCEPTION WHEN OTHERS THEN
        ck(SQLCODE = -20001, 'duplicate nesting rejected (' || SQLCODE || ')');
    END;

    -- copy: definition travels, assignments do not
    cp := prod.dct_sec.copy_role(j1, 'TSEC_JOB_1_COPY', 'Copy of job 1', NULL, 'TEST');
    SELECT COUNT(*) INTO n FROM prod.dct_sec_role_hierarchy WHERE parent_role_id = cp;
    ck(n = 2, 'copy carries child duty links (' || n || ')');
    SELECT COUNT(*) INTO n FROM prod.dct_sec_exclusion
     WHERE scope_type = 'ROLE' AND role_id = cp AND is_active = 'Y';
    ck(n = 1, 'copy carries role exclusions');
    SELECT COUNT(*) INTO n FROM prod.dct_roles
     WHERE role_id = cp AND created_from_role_id = j1 AND is_system_role = 'N';
    ck(n = 1, 'copy provenance recorded, never a system role');
    ck(NOT flat_has(cp, p2), 'copied closure honours copied exclusion');
    ck(flat_has(cp, p1), 'copied closure carries inherited perms');

    -- duty roles are never user-assignable
    SELECT MIN(user_id) INTO tu FROM prod.dct_users WHERE is_active = 'Y';
    BEGIN
        INSERT INTO prod.dct_user_roles (user_id, role_id, assigned_by)
        VALUES (tu, d1, 'TEST');
        ck(FALSE, 'duty assignment to user rejected');
    EXCEPTION WHEN OTHERS THEN
        ck(SQLCODE = -20001, 'duty assignment to user rejected (' || SQLCODE || ')');
    END;

    DBMS_OUTPUT.PUT_LINE('part 1: ' || pass || ' pass, ' || fail || ' fail');
    ROLLBACK;
END;
/

PROMPT === part 2: user effective privileges, has_priv, profiles ===

DECLARE
    pass NUMBER := 0; fail NUMBER := 0;
    n NUMBER;
    p1 NUMBER; p2 NUMBER;
    d1 NUMBER; j1 NUMBER;
    tu NUMBER; tuname VARCHAR2(100);
    pf NUMBER;
    v_sect VARCHAR2(100);
    v_parent NUMBER; v_child NUMBER;
    PROCEDURE ck (b BOOLEAN, m VARCHAR2) IS
    BEGIN
        IF b THEN pass := pass + 1; DBMS_OUTPUT.PUT_LINE('  pass  ' || m);
        ELSE fail := fail + 1; DBMS_OUTPUT.PUT_LINE('  FAIL  ' || m); END IF;
    END;
BEGIN
    INSERT INTO prod.dct_users (username, email, display_name, auth_method, is_active, created_by)
    VALUES ('tsec.user1', 'tsec.user1@test.local', 'Sec Test User', 'DB', 'Y', 'TEST')
    RETURNING user_id INTO tu;
    tuname := 'tsec.user1';

    INSERT INTO prod.dct_permissions
        (permission_code, permission_name, action_type, verb, created_by)
    VALUES ('TSEC_P_ALPHA', 'Alpha', 'VIEW', 'VIEW', 'TEST')
    RETURNING permission_id INTO p1;
    INSERT INTO prod.dct_permissions
        (permission_code, permission_name, action_type, verb, created_by)
    VALUES ('TSEC_P_BETA', 'Beta', 'VIEW', 'VIEW', 'TEST')
    RETURNING permission_id INTO p2;

    INSERT INTO prod.dct_roles (role_code, role_name_en, role_type, role_category, created_by)
    VALUES ('TSEC_D_A', 'Duty A', 'MODULE', 'DUTY', 'TEST')
    RETURNING role_id INTO d1;
    INSERT INTO prod.dct_roles (role_code, role_name_en, role_type, role_category, created_by)
    VALUES ('TSEC_J_A', 'Job A', 'MODULE', 'JOB', 'TEST')
    RETURNING role_id INTO j1;

    INSERT INTO prod.dct_role_permissions (role_id, permission_id, granted_by)
    VALUES (d1, p1, 'TEST');
    INSERT INTO prod.dct_role_permissions (role_id, permission_id, granted_by)
    VALUES (j1, p2, 'TEST');
    prod.dct_sec.add_hierarchy(j1, d1, 'TEST');

    INSERT INTO prod.dct_user_roles (user_id, role_id, assigned_by)
    VALUES (tu, j1, 'TEST');
    prod.dct_sec.bump_version;

    SELECT COUNT(*) INTO n FROM prod.v_dct_user_privs_eff
     WHERE user_id = tu AND permission_code = 'TSEC_P_ALPHA';
    ck(n > 0, 'eff view: inherited duty perm present');
    ck(prod.dct_sec.has_priv(tuname, 'TSEC_P_ALPHA'), 'has_priv: inherited perm true');
    ck(prod.dct_sec.has_priv(tuname, 'TSEC_P_BETA'), 'has_priv: direct job perm true');
    ck(NOT prod.dct_sec.has_priv(tuname, 'NO_SUCH_PRIV'), 'has_priv: unknown perm false');

    -- user-scope exclusion
    INSERT INTO prod.dct_sec_exclusion
        (scope_type, user_id, permission_id, reason, created_by)
    VALUES ('USER', tu, p1, 'test', 'TEST');
    prod.dct_sec.bump_version;
    ck(NOT prod.dct_sec.has_priv(tuname, 'TSEC_P_ALPHA'), 'user exclusion removes perm');
    ck(prod.dct_sec.has_priv(tuname, 'TSEC_P_BETA'), 'user exclusion leaves others');

    -- has_priv_or_role fallback (no enforce setting seeded => fallback active)
    ck(prod.dct_sec.has_priv_or_role(tuname, 'NO_SUCH_PRIV', 'TSEC_J_A', 'TSEC'),
       'or_role: legacy role satisfies while enforcement off');
    ck(NOT prod.dct_sec.has_priv_or_role(tuname, 'NO_SUCH_PRIV', 'NO_SUCH_ROLE', 'TSEC'),
       'or_role: no priv, no role => false');

    -- security profile scoping
    SELECT MIN(value_code) INTO v_sect FROM prod.v_dct_wf_obj_sector;
    ck(prod.dct_sec_data.is_unrestricted(tu, 'SECTOR') = 1, 'no profile => unrestricted');

    INSERT INTO prod.dct_sec_profile (profile_code, name_en, created_by)
    VALUES ('TSEC_PROF_1', 'Test profile', 'TEST')
    RETURNING profile_id INTO pf;
    INSERT INTO prod.dct_sec_profile_scope
        (profile_id, object_type_code, object_key, created_by)
    VALUES (pf, 'SECTOR', v_sect, 'TEST');
    INSERT INTO prod.dct_sec_user_profile (user_id, profile_id, assigned_by)
    VALUES (tu, pf, 'TEST');

    ck(prod.dct_sec_data.is_unrestricted(tu, 'SECTOR') = 0, 'sector scope => restricted');
    ck(prod.dct_sec_data.is_unrestricted(tu, 'CHAPTER') = 1, 'other dim stays unrestricted');
    SELECT COUNT(*) INTO n FROM prod.v_dct_sec_user_scope
     WHERE user_id = tu AND object_type_code = 'SECTOR' AND object_key = v_sect;
    ck(n = 1, 'scope view carries the key');

    -- org hierarchy expansion
    SELECT MIN(org_id) INTO v_child FROM prod.dct_organizations
     WHERE parent_org_id IS NOT NULL AND is_active = 'Y';
    SELECT parent_org_id INTO v_parent FROM prod.dct_organizations WHERE org_id = v_child;
    INSERT INTO prod.dct_sec_profile_scope
        (profile_id, object_type_code, object_key, include_children, created_by)
    VALUES (pf, 'DEPARTMENT', TO_CHAR(v_parent), 'Y', 'TEST');
    SELECT COUNT(*) INTO n FROM prod.v_dct_sec_user_scope
     WHERE user_id = tu AND object_type_code = 'DEPARTMENT'
       AND object_key = TO_CHAR(v_child);
    ck(n = 1, 'org include_children expands to descendants');

    -- date-bounded assignment
    UPDATE prod.dct_sec_user_profile
       SET start_date = TRUNC(SYSDATE) - 10, end_date = TRUNC(SYSDATE) - 1, is_active = 'Y'
     WHERE user_id = tu AND profile_id = pf;
    ck(prod.dct_sec_data.is_unrestricted(tu, 'SECTOR') = 1, 'expired profile ignored');

    DBMS_OUTPUT.PUT_LINE('part 2: ' || pass || ' pass, ' || fail || ' fail');
    ROLLBACK;
END;
/

PROMPT === part 3: equivalence invariant (new engine == legacy reality) ===

DECLARE
    pass NUMBER := 0; fail NUMBER := 0;
    n1 NUMBER; n2 NUMBER;
    PROCEDURE ck (b BOOLEAN, m VARCHAR2) IS
    BEGIN
        IF b THEN pass := pass + 1; DBMS_OUTPUT.PUT_LINE('  pass  ' || m);
        ELSE fail := fail + 1; DBMS_OUTPUT.PUT_LINE('  FAIL  ' || m); END IF;
    END;
BEGIN
    prod.dct_sec.refresh_flat;

    SELECT COUNT(*) INTO n1 FROM (
        SELECT user_id, permission_code FROM prod.v_dct_user_permissions
        MINUS
        SELECT user_id, permission_code FROM prod.v_dct_user_privs_eff);
    ck(n1 = 0, 'no legacy permission lost (' || n1 || ' missing)');

    SELECT COUNT(*) INTO n2 FROM (
        SELECT user_id, permission_code FROM prod.v_dct_user_privs_eff
        MINUS
        SELECT user_id, permission_code FROM prod.v_dct_user_permissions);
    ck(n2 = 0, 'no permission invented (' || n2 || ' extra)');

    DBMS_OUTPUT.PUT_LINE('part 3: ' || pass || ' pass, ' || fail || ' fail');
    ROLLBACK;
END;
/

PROMPT === restore committed closure ===
BEGIN
    prod.dct_sec.refresh_flat;
    COMMIT;
END;
/

EXIT
