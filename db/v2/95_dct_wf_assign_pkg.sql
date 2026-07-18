SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
-- db/v2/95_dct_wf_assign_pkg.sql
-- DWP Dynamic Role Assignments, part 2 of 3: DCT_WF_ASSIGN.
-- CRUD plus LOV plus preview over dct_wf_role_assignment. Resolution at
-- runtime stays inside DCT_WF_ENGINE (assigned_holders); resolve_preview here
-- exists for the admin UI and for tests that pin the two together.
-- History discipline: identity columns are immutable; changes are end-date,
-- replace, or void. No COMMIT in this package; the caller owns the txn.
-- Deploy after 94. Companion: 96 ORDS API.

CREATE OR REPLACE PACKAGE prod.dct_wf_assign AS

    -- canonical key form, same rule the engine applies at resolve time:
    -- trim, and numeric-keyed types lose leading zeros
    FUNCTION canon (p_type IN VARCHAR2, p_key IN VARCHAR2) RETURN VARCHAR2;

    -- display label for an object, from its registry LOV view
    FUNCTION get_label (p_type IN VARCHAR2, p_key IN VARCHAR2,
                        p_key2 IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

    FUNCTION create_assignment (p_actor   IN VARCHAR2,
                                p_type    IN VARCHAR2,
                                p_key     IN VARCHAR2,
                                p_key2    IN VARCHAR2,
                                p_role    IN VARCHAR2,
                                p_user_id IN NUMBER,
                                p_start   IN DATE,
                                p_end     IN DATE,
                                p_notes   IN VARCHAR2) RETURN NUMBER;

    PROCEDURE end_assignment (p_actor IN VARCHAR2,
                              p_id    IN NUMBER,
                              p_end   IN DATE,
                              p_note  IN VARCHAR2 DEFAULT NULL);

    FUNCTION replace_assignment (p_actor       IN VARCHAR2,
                                 p_id          IN NUMBER,
                                 p_new_user_id IN NUMBER,
                                 p_effective   IN DATE) RETURN NUMBER;

    -- entered-in-error only; requires SYS_ADMIN
    PROCEDURE void_assignment (p_actor  IN VARCHAR2,
                               p_id     IN NUMBER,
                               p_reason IN VARCHAR2);

    -- notes and end_date only; identity is immutable
    PROCEDURE update_assignment (p_actor IN VARCHAR2,
                                 p_id    IN NUMBER,
                                 p_notes IN VARCHAR2,
                                 p_end   IN DATE,
                                 p_clear_end IN VARCHAR2 DEFAULT 'N');

    -- object picker rows: k, l, parent, xtra. Two-part types list the
    -- second key filtered by p_parent. ORG kinds also return parent and
    -- org type so the UI can indent a tree.
    PROCEDURE lov (p_type   IN VARCHAR2,
                   p_search IN VARCHAR2,
                   p_parent IN VARCHAR2,
                   p_limit  IN NUMBER DEFAULT 200,
                   o_cur    OUT SYS_REFCURSOR);

    -- who holds the role on the object as of a date. Mirrors the engine's
    -- assigned_holders (tests assert the two agree).
    FUNCTION resolve_preview (p_type IN VARCHAR2,
                              p_key  IN VARCHAR2,
                              p_key2 IN VARCHAR2,
                              p_role IN VARCHAR2,
                              p_asof IN DATE DEFAULT NULL) RETURN sys.odcinumberlist;

END dct_wf_assign;
/

SHOW ERRORS

CREATE OR REPLACE PACKAGE BODY prod.dct_wf_assign AS

    DATE_MAX CONSTANT DATE := DATE '9999-12-31';

    FUNCTION reg (p_type IN VARCHAR2) RETURN prod.dct_wf_object_type%ROWTYPE IS
        r prod.dct_wf_object_type%ROWTYPE;
    BEGIN
        SELECT * INTO r FROM prod.dct_wf_object_type
         WHERE object_type_code = p_type AND is_active = 'Y';
        RETURN r;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Unknown or inactive object type ' || p_type);
    END;

    -- identifier-safe piece of dynamic LOV SQL: must be a real column of the
    -- registered view. Everything dynamic passes through here or DBMS_ASSERT.
    PROCEDURE assert_col (p_view IN VARCHAR2, p_col IN VARCHAR2) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM all_tab_columns
         WHERE owner = 'PROD' AND table_name = UPPER(p_view)
           AND column_name = UPPER(p_col);
        IF v = 0 THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Registry column ' || p_col || ' not found on ' || p_view);
        END IF;
    END;

    FUNCTION canon (p_type IN VARCHAR2, p_key IN VARCHAR2) RETURN VARCHAR2 IS
        r prod.dct_wf_object_type%ROWTYPE;
        v VARCHAR2(100);
    BEGIN
        IF p_key IS NULL THEN RETURN NULL; END IF;
        r := reg(p_type);
        v := TRIM(p_key);
        IF r.key_is_numeric = 'Y' THEN
            BEGIN
                v := TO_CHAR(TO_NUMBER(v));
            EXCEPTION WHEN OTHERS THEN NULL;
            END;
        END IF;
        RETURN v;
    END;

    FUNCTION get_label (p_type IN VARCHAR2, p_key IN VARCHAR2,
                        p_key2 IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
        r     prod.dct_wf_object_type%ROWTYPE;
        v_sql VARCHAR2(1000);
        v_lbl VARCHAR2(300);
    BEGIN
        r := reg(p_type);
        assert_col(r.lov_view, r.lov_key_col);
        assert_col(r.lov_view, r.lov_label_col);
        v_sql := 'SELECT MAX(' || DBMS_ASSERT.simple_sql_name(r.lov_label_col)
              || ') FROM prod.' || DBMS_ASSERT.simple_sql_name(r.lov_view)
              || ' WHERE TRIM(TO_CHAR(' || DBMS_ASSERT.simple_sql_name(r.lov_key_col)
              || ')) = :k';
        IF r.lov_key2_col IS NOT NULL AND p_key2 IS NOT NULL THEN
            assert_col(r.lov_view, r.lov_key2_col);
            v_sql := v_sql || ' AND TRIM(TO_CHAR('
                  || DBMS_ASSERT.simple_sql_name(r.lov_key2_col) || ')) = :k2';
            EXECUTE IMMEDIATE v_sql INTO v_lbl USING canon(p_type, p_key), TRIM(p_key2);
        ELSE
            EXECUTE IMMEDIATE v_sql INTO v_lbl USING canon(p_type, p_key);
        END IF;
        RETURN v_lbl;
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
    END;

    FUNCTION row_json (p_id IN NUMBER) RETURN CLOB IS
        v CLOB;
    BEGIN
        SELECT JSON_OBJECT(
                 'assignmentId'   VALUE a.assignment_id,
                 'objectType'     VALUE a.object_type_code,
                 'objectKey'      VALUE a.object_key,
                 'objectKey2'     VALUE a.object_key2,
                 'objectLabel'    VALUE a.object_label,
                 'roleCode'       VALUE a.role_code,
                 'userId'         VALUE a.user_id,
                 'startDate'      VALUE TO_CHAR(a.start_date, 'YYYY-MM-DD'),
                 'endDate'        VALUE TO_CHAR(a.end_date, 'YYYY-MM-DD'),
                 'isActive'       VALUE a.is_active,
                 'notes'          VALUE a.notes
                 ABSENT ON NULL RETURNING CLOB)
          INTO v
          FROM prod.dct_wf_role_assignment a
         WHERE a.assignment_id = p_id;
        RETURN v;
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
    END;

    PROCEDURE audit (p_actor IN VARCHAR2, p_action IN VARCHAR2,
                     p_id IN NUMBER, p_old IN CLOB, p_new IN CLOB) IS
    BEGIN
        prod.dct_audit_pkg.log(
            p_username    => p_actor,
            p_action      => p_action,
            p_object_type => 'WF_ROLE_ASSIGNMENT',
            p_object_id   => TO_CHAR(p_id),
            p_module_code => 'ADMIN',
            p_old         => p_old,
            p_new         => p_new);
    END;

    FUNCTION locked_row (p_id IN NUMBER) RETURN prod.dct_wf_role_assignment%ROWTYPE IS
        a prod.dct_wf_role_assignment%ROWTYPE;
    BEGIN
        SELECT * INTO a FROM prod.dct_wf_role_assignment
         WHERE assignment_id = p_id FOR UPDATE;
        RETURN a;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Assignment ' || p_id || ' not found');
    END;

    FUNCTION create_assignment (p_actor   IN VARCHAR2,
                                p_type    IN VARCHAR2,
                                p_key     IN VARCHAR2,
                                p_key2    IN VARCHAR2,
                                p_role    IN VARCHAR2,
                                p_user_id IN NUMBER,
                                p_start   IN DATE,
                                p_end     IN DATE,
                                p_notes   IN VARCHAR2) RETURN NUMBER IS
        r        prod.dct_wf_object_type%ROWTYPE;
        v_key    VARCHAR2(100);
        v_key2   VARCHAR2(100);
        v_start  DATE := NVL(TRUNC(p_start), TRUNC(SYSDATE));
        v_end    DATE := TRUNC(p_end);
        v_single VARCHAR2(1);
        v_cnt    NUMBER;
        v_lbl    VARCHAR2(300);
        v_id     NUMBER;
        v_sql    VARCHAR2(1000);
        v_who    VARCHAR2(300);
    BEGIN
        r := reg(p_type);
        v_key  := canon(p_type, p_key);
        v_key2 := TRIM(p_key2);
        IF v_key IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Object key is required');
        END IF;
        IF r.lov_key2_col IS NOT NULL AND v_key2 IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001,
                p_type || ' needs a second key (' || NVL(r.key2_label_en, 'part 2') || ')');
        END IF;
        IF r.lov_key2_col IS NULL THEN
            v_key2 := NULL;
        END IF;
        IF v_end IS NOT NULL AND v_end < v_start THEN
            RAISE_APPLICATION_ERROR(-20001, 'End date is before the start date');
        END IF;

        SELECT COUNT(*) INTO v_cnt FROM prod.dct_roles
         WHERE role_code = p_role AND is_active = 'Y';
        IF v_cnt = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Unknown or inactive role ' || p_role);
        END IF;

        SELECT COUNT(*) INTO v_cnt FROM prod.dct_users
         WHERE user_id = p_user_id AND is_active = 'Y';
        IF v_cnt = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'User ' || p_user_id || ' not found or inactive');
        END IF;

        IF r.validate_key = 'Y' THEN
            assert_col(r.lov_view, r.lov_key_col);
            v_sql := 'SELECT COUNT(*) FROM prod.'
                  || DBMS_ASSERT.simple_sql_name(r.lov_view)
                  || ' WHERE TRIM(TO_CHAR(' || DBMS_ASSERT.simple_sql_name(r.lov_key_col)
                  || ')) = :k';
            IF r.lov_key2_col IS NOT NULL THEN
                assert_col(r.lov_view, r.lov_key2_col);
                v_sql := v_sql || ' AND TRIM(TO_CHAR('
                      || DBMS_ASSERT.simple_sql_name(r.lov_key2_col) || ')) = :k2';
                EXECUTE IMMEDIATE v_sql INTO v_cnt USING v_key, v_key2;
            ELSE
                EXECUTE IMMEDIATE v_sql INTO v_cnt USING v_key;
            END IF;
            IF v_cnt = 0 THEN
                RAISE_APPLICATION_ERROR(-20001,
                    p_type || ' ' || v_key
                    || CASE WHEN v_key2 IS NOT NULL THEN ' / ' || v_key2 END
                    || ' does not exist');
            END IF;
        END IF;

        -- single-assignee roles: the policy row is the serialization lock,
        -- making check-then-insert race-safe
        BEGIN
            SELECT single_assignee INTO v_single
              FROM prod.dct_wf_role_policy
             WHERE role_code = p_role
               FOR UPDATE;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            v_single := 'N';
        END;

        IF v_single = 'Y' THEN
            BEGIN
                SELECT u.display_name || ' (' || TO_CHAR(a.start_date, 'YYYY-MM-DD')
                       || ' - ' || NVL(TO_CHAR(a.end_date, 'YYYY-MM-DD'), 'open') || ')'
                  INTO v_who
                  FROM prod.dct_wf_role_assignment a
                  JOIN prod.dct_users u ON u.user_id = a.user_id
                 WHERE a.object_type_code = p_type
                   AND a.object_key = v_key
                   AND NVL(a.object_key2, '#') = NVL(v_key2, '#')
                   AND a.role_code = p_role
                   AND a.is_active = 'Y'
                   AND a.start_date <= NVL(v_end, DATE_MAX)
                   AND NVL(a.end_date, DATE_MAX) >= v_start
                   AND ROWNUM = 1;
                RAISE_APPLICATION_ERROR(-20001,
                    p_role || ' is single-assignee and overlaps an existing assignment: '
                    || v_who || '. End or replace it first.');
            EXCEPTION WHEN NO_DATA_FOUND THEN
                NULL;
            END;
        END IF;

        v_lbl := get_label(p_type, v_key, v_key2);

        INSERT INTO prod.dct_wf_role_assignment
            (object_type_code, object_key, object_key2, object_label,
             role_code, user_id, start_date, end_date, notes, created_by)
        VALUES (p_type, v_key, v_key2, v_lbl,
             p_role, p_user_id, v_start, v_end, p_notes, p_actor)
        RETURNING assignment_id INTO v_id;

        audit(p_actor, 'ASSIGN_CREATE', v_id, NULL, row_json(v_id));
        RETURN v_id;
    END;

    PROCEDURE end_assignment (p_actor IN VARCHAR2,
                              p_id    IN NUMBER,
                              p_end   IN DATE,
                              p_note  IN VARCHAR2 DEFAULT NULL) IS
        a     prod.dct_wf_role_assignment%ROWTYPE;
        v_end DATE := NVL(TRUNC(p_end), TRUNC(SYSDATE));
        v_old CLOB;
    BEGIN
        a := locked_row(p_id);
        IF a.is_active = 'N' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Assignment ' || p_id || ' is voided');
        END IF;
        IF a.end_date IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Assignment ' || p_id || ' is already ended');
        END IF;
        IF v_end < a.start_date THEN
            RAISE_APPLICATION_ERROR(-20001, 'End date is before the start date');
        END IF;
        v_old := row_json(p_id);
        UPDATE prod.dct_wf_role_assignment
           SET end_date = v_end,
               ended_by = p_actor,
               ended_at = SYSTIMESTAMP,
               notes    = CASE WHEN p_note IS NOT NULL THEN p_note ELSE notes END
         WHERE assignment_id = p_id;
        audit(p_actor, 'ASSIGN_END', p_id, v_old, row_json(p_id));
    END;

    FUNCTION replace_assignment (p_actor       IN VARCHAR2,
                                 p_id          IN NUMBER,
                                 p_new_user_id IN NUMBER,
                                 p_effective   IN DATE) RETURN NUMBER IS
        a     prod.dct_wf_role_assignment%ROWTYPE;
        v_eff DATE := NVL(TRUNC(p_effective), TRUNC(SYSDATE));
        v_old CLOB;
        v_new NUMBER;
    BEGIN
        a := locked_row(p_id);
        IF a.is_active = 'N' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Assignment ' || p_id || ' is voided');
        END IF;
        IF a.end_date IS NOT NULL AND a.end_date < v_eff THEN
            RAISE_APPLICATION_ERROR(-20001, 'Assignment ' || p_id || ' already ended before that date');
        END IF;

        v_old := row_json(p_id);
        -- the old holder's last day is the day BEFORE the new holder starts;
        -- a same-day replace of a same-day assignment voids the old row
        IF v_eff - 1 >= a.start_date THEN
            UPDATE prod.dct_wf_role_assignment
               SET end_date = v_eff - 1, ended_by = p_actor, ended_at = SYSTIMESTAMP
             WHERE assignment_id = p_id;
        ELSE
            UPDATE prod.dct_wf_role_assignment
               SET is_active = 'N', ended_by = p_actor, ended_at = SYSTIMESTAMP
             WHERE assignment_id = p_id;
        END IF;

        v_new := create_assignment(p_actor, a.object_type_code, a.object_key,
                                   a.object_key2, a.role_code, p_new_user_id,
                                   v_eff, NULL, 'Replaces assignment ' || p_id);

        UPDATE prod.dct_wf_role_assignment
           SET replaced_by_id = v_new
         WHERE assignment_id = p_id;

        audit(p_actor, 'ASSIGN_REPLACE', p_id, v_old, row_json(v_new));
        RETURN v_new;
    END;

    PROCEDURE void_assignment (p_actor  IN VARCHAR2,
                               p_id     IN NUMBER,
                               p_reason IN VARCHAR2) IS
        a     prod.dct_wf_role_assignment%ROWTYPE;
        v_old CLOB;
    BEGIN
        IF NOT prod.dct_auth.has_role(p_actor, 'SYS_ADMIN') THEN
            RAISE_APPLICATION_ERROR(-20403, 'Voiding an assignment needs SYS_ADMIN');
        END IF;
        IF p_reason IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'A void reason is required');
        END IF;
        a := locked_row(p_id);
        IF a.is_active = 'N' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Assignment ' || p_id || ' is already voided');
        END IF;
        v_old := row_json(p_id);
        UPDATE prod.dct_wf_role_assignment
           SET is_active = 'N',
               ended_by  = p_actor,
               ended_at  = SYSTIMESTAMP,
               notes     = SUBSTR('VOID: ' || p_reason, 1, 500)
         WHERE assignment_id = p_id;
        audit(p_actor, 'ASSIGN_VOID', p_id, v_old, row_json(p_id));
    END;

    PROCEDURE update_assignment (p_actor IN VARCHAR2,
                                 p_id    IN NUMBER,
                                 p_notes IN VARCHAR2,
                                 p_end   IN DATE,
                                 p_clear_end IN VARCHAR2 DEFAULT 'N') IS
        a     prod.dct_wf_role_assignment%ROWTYPE;
        v_old CLOB;
        v_end DATE := TRUNC(p_end);
    BEGIN
        a := locked_row(p_id);
        IF a.is_active = 'N' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Assignment ' || p_id || ' is voided');
        END IF;
        IF v_end IS NOT NULL AND v_end < a.start_date THEN
            RAISE_APPLICATION_ERROR(-20001, 'End date is before the start date');
        END IF;
        v_old := row_json(p_id);
        UPDATE prod.dct_wf_role_assignment
           SET notes    = NVL(p_notes, notes),
               end_date = CASE WHEN p_clear_end = 'Y' THEN NULL
                               WHEN v_end IS NOT NULL THEN v_end
                               ELSE end_date END,
               ended_by = CASE WHEN p_clear_end = 'Y' THEN NULL
                               WHEN v_end IS NOT NULL THEN p_actor
                               ELSE ended_by END,
               ended_at = CASE WHEN p_clear_end = 'Y' THEN NULL
                               WHEN v_end IS NOT NULL THEN SYSTIMESTAMP
                               ELSE ended_at END
         WHERE assignment_id = p_id;
        audit(p_actor, 'ASSIGN_UPDATE', p_id, v_old, row_json(p_id));
    END;

    PROCEDURE lov (p_type   IN VARCHAR2,
                   p_search IN VARCHAR2,
                   p_parent IN VARCHAR2,
                   p_limit  IN NUMBER DEFAULT 200,
                   o_cur    OUT SYS_REFCURSOR) IS
        r     prod.dct_wf_object_type%ROWTYPE;
        v_sql VARCHAR2(2000);
        v_s   VARCHAR2(120) := UPPER(TRIM(p_search));
        v_lim NUMBER := LEAST(NVL(p_limit, 200), 500);
    BEGIN
        r := reg(p_type);
        assert_col(r.lov_view, r.lov_key_col);
        assert_col(r.lov_view, r.lov_label_col);

        IF r.lov_key2_col IS NOT NULL THEN
            -- two-part type: list the SECOND key within the chosen parent
            IF p_parent IS NULL THEN
                RAISE_APPLICATION_ERROR(-20001,
                    p_type || ' needs parent= (the first key) for its list');
            END IF;
            assert_col(r.lov_view, r.lov_key2_col);
            assert_col(r.lov_view, r.lov_parent_col);
            v_sql := 'SELECT TO_CHAR(' || DBMS_ASSERT.simple_sql_name(r.lov_key2_col)
                  || ') AS k, ' || DBMS_ASSERT.simple_sql_name(r.lov_label_col)
                  || ' AS l, NULL AS parent, NULL AS xtra FROM prod.'
                  || DBMS_ASSERT.simple_sql_name(r.lov_view)
                  || ' WHERE TRIM(TO_CHAR(' || DBMS_ASSERT.simple_sql_name(r.lov_parent_col)
                  || ')) = :p AND (:s IS NULL OR UPPER(TO_CHAR('
                  || DBMS_ASSERT.simple_sql_name(r.lov_key2_col)
                  || ')) LIKE ''%'' || :s || ''%'' OR UPPER('
                  || DBMS_ASSERT.simple_sql_name(r.lov_label_col)
                  || ') LIKE ''%'' || :s || ''%'') ORDER BY 1 FETCH FIRST '
                  || v_lim || ' ROWS ONLY';
            OPEN o_cur FOR v_sql USING TRIM(p_parent), v_s, v_s, v_s;
        ELSIF r.hierarchy_kind = 'ORG' THEN
            -- org kinds ship the tree columns so the picker can indent
            v_sql := 'SELECT TO_CHAR(org_id) AS k, org_name_en AS l,'
                  || ' TO_CHAR(parent_org_id) AS parent, org_type AS xtra FROM prod.'
                  || DBMS_ASSERT.simple_sql_name(r.lov_view)
                  || ' WHERE (:s IS NULL OR UPPER(org_name_en) LIKE ''%'' || :s || ''%'''
                  || ' OR UPPER(org_code) LIKE ''%'' || :s || ''%'')'
                  || ' ORDER BY parent_org_id NULLS FIRST, org_id FETCH FIRST '
                  || v_lim || ' ROWS ONLY';
            OPEN o_cur FOR v_sql USING v_s, v_s, v_s;
        ELSE
            v_sql := 'SELECT TO_CHAR(' || DBMS_ASSERT.simple_sql_name(r.lov_key_col)
                  || ') AS k, ' || DBMS_ASSERT.simple_sql_name(r.lov_label_col)
                  || ' AS l, NULL AS parent, NULL AS xtra FROM prod.'
                  || DBMS_ASSERT.simple_sql_name(r.lov_view)
                  || ' WHERE (:s IS NULL OR UPPER(TO_CHAR('
                  || DBMS_ASSERT.simple_sql_name(r.lov_key_col)
                  || ')) LIKE ''%'' || :s || ''%'' OR UPPER('
                  || DBMS_ASSERT.simple_sql_name(r.lov_label_col)
                  || ') LIKE ''%'' || :s || ''%'') ORDER BY 1 FETCH FIRST '
                  || v_lim || ' ROWS ONLY';
            OPEN o_cur FOR v_sql USING v_s, v_s, v_s;
        END IF;
    END;

    FUNCTION resolve_preview (p_type IN VARCHAR2,
                              p_key  IN VARCHAR2,
                              p_key2 IN VARCHAR2,
                              p_role IN VARCHAR2,
                              p_asof IN DATE DEFAULT NULL) RETURN sys.odcinumberlist IS
        r      prod.dct_wf_object_type%ROWTYPE;
        v_key  VARCHAR2(100);
        v_key2 VARCHAR2(100);
        v_asof DATE := NVL(TRUNC(p_asof), TRUNC(SYSDATE));
        v_org  NUMBER;
        v_lvl  NUMBER;
        v_out  sys.odcinumberlist := sys.odcinumberlist();
    BEGIN
        r := reg(p_type);
        v_key  := canon(p_type, p_key);
        v_key2 := TRIM(p_key2);
        IF v_key IS NULL THEN RETURN v_out; END IF;

        IF r.hierarchy_kind = 'ORG' THEN
            BEGIN
                v_org := TO_NUMBER(v_key);
            EXCEPTION WHEN OTHERS THEN RETURN v_out;
            END;
            SELECT MIN(o.lvl) INTO v_lvl
              FROM (SELECT org_id, LEVEL AS lvl
                      FROM prod.dct_organizations
                     START WITH org_id = v_org
                   CONNECT BY PRIOR parent_org_id = org_id) o
              JOIN prod.dct_wf_role_assignment ra ON ra.object_key = TO_CHAR(o.org_id)
             WHERE ra.object_type_code = p_type
               AND ra.role_code = p_role AND ra.is_active = 'Y'
               AND ra.start_date <= v_asof
               AND (ra.end_date IS NULL OR ra.end_date >= v_asof);
            IF v_lvl IS NULL THEN RETURN v_out; END IF;
            SELECT ra.user_id BULK COLLECT INTO v_out
              FROM (SELECT org_id, LEVEL AS lvl
                      FROM prod.dct_organizations
                     START WITH org_id = v_org
                   CONNECT BY PRIOR parent_org_id = org_id) o
              JOIN prod.dct_wf_role_assignment ra ON ra.object_key = TO_CHAR(o.org_id)
             WHERE ra.object_type_code = p_type
               AND ra.role_code = p_role AND ra.is_active = 'Y'
               AND o.lvl = v_lvl
               AND ra.start_date <= v_asof
               AND (ra.end_date IS NULL OR ra.end_date >= v_asof);
        ELSE
            SELECT ra.user_id BULK COLLECT INTO v_out
              FROM prod.dct_wf_role_assignment ra
             WHERE ra.object_type_code = p_type
               AND ra.object_key = v_key
               AND NVL(ra.object_key2, '#') = NVL(v_key2, '#')
               AND ra.role_code = p_role AND ra.is_active = 'Y'
               AND ra.start_date <= v_asof
               AND (ra.end_date IS NULL OR ra.end_date >= v_asof);
        END IF;
        RETURN v_out;
    END;

END dct_wf_assign;
/

SHOW ERRORS

SELECT object_name, object_type, status
  FROM all_objects
 WHERE owner = 'PROD' AND object_name = 'DCT_WF_ASSIGN';

EXIT
