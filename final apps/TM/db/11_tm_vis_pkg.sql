-- =============================================================================
-- Task Management Module (App 207) -- Visibility package DCT_TM_VIS_PKG
-- File    : 11_tm_vis_pkg.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @11_tm_vis_pkg.sql   (after 09_tm_cycle_ddl.sql)
-- Purpose : Cross-team read scope. visible_teams() is the single source of truth for
--           "which teams may this user see"; list endpoints scope through it. Computed
--           from membership + leadership + visibility grants + org-head + team-tree.
-- Errors  : -20401 not authenticated, -20403 permission denied, -20090 invalid lookup.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PACKAGE prod.dct_tm_vis_pkg AS

    -- which teams may this user see (pipelined so list SQL can do
    --   WHERE team_id IN (SELECT column_value FROM TABLE(dct_tm_vis_pkg.visible_teams(:uid))) )
    FUNCTION visible_teams (p_user_id NUMBER) RETURN prod.dct_tm_id_tab PIPELINED;

    -- single-team / global fast-path guards
    FUNCTION can_view_team (p_user_id NUMBER, p_team_id NUMBER) RETURN VARCHAR2;
    FUNCTION can_view_all  (p_user_id NUMBER) RETURN VARCHAR2;

    -- visibility-grant administration (TM_ADMIN only)
    FUNCTION  create_grant (
        p_actor_id     NUMBER,
        p_grantee_id   NUMBER,
        p_scope        VARCHAR2,
        p_team_id      NUMBER   DEFAULT NULL,
        p_org_id       NUMBER   DEFAULT NULL,
        p_access_level VARCHAR2 DEFAULT 'VIEWER',
        p_end_date     DATE     DEFAULT NULL,
        p_reason       VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER;

    PROCEDURE revoke_grant (p_actor_id NUMBER, p_grant_id NUMBER);

    -- team hierarchy: set/clear a team's parent (cycle-guarded)
    PROCEDURE set_team_parent (p_actor_id NUMBER, p_team_id NUMBER, p_parent_id NUMBER DEFAULT NULL);

END dct_tm_vis_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_tm_vis_pkg AS

    FUNCTION can_view_all (p_user_id NUMBER) RETURN VARCHAR2 IS
        v_n NUMBER;
    BEGIN
        IF p_user_id IS NULL THEN RETURN 'N'; END IF;
        IF prod.dct_tm_pkg.is_tm_admin(p_user_id) = 'Y' THEN RETURN 'Y'; END IF;
        SELECT COUNT(*) INTO v_n
        FROM   prod.dct_tm_visibility_grant
        WHERE  grantee_user_id = p_user_id
        AND    scope = 'ALL'
        AND    status = 'ACTIVE'
        AND    start_date <= SYSDATE
        AND    (end_date IS NULL OR end_date >= TRUNC(SYSDATE));
        RETURN CASE WHEN v_n > 0 THEN 'Y' ELSE 'N' END;
    END can_view_all;

    FUNCTION visible_teams (p_user_id NUMBER) RETURN prod.dct_tm_id_tab PIPELINED IS
        TYPE t_set IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
        v_set t_set;
        i     PLS_INTEGER;
    BEGIN
        IF p_user_id IS NULL THEN RETURN; END IF;

        -- (e) admin or scope=ALL grant -> every team, short-circuit
        IF can_view_all(p_user_id) = 'Y' THEN
            FOR r IN (SELECT team_id FROM prod.dct_tm_teams) LOOP
                PIPE ROW (r.team_id);
            END LOOP;
            RETURN;
        END IF;

        -- (a) active membership
        FOR r IN (SELECT DISTINCT team_id FROM prod.dct_tm_members
                  WHERE user_id = p_user_id AND is_active = 'Y') LOOP
            v_set(r.team_id) := 1;
        END LOOP;

        -- (b) leadership
        FOR r IN (SELECT team_id FROM prod.dct_tm_teams
                  WHERE leader_user_id = p_user_id) LOOP
            v_set(r.team_id) := 1;
        END LOOP;

        -- (c) explicit single-team grants
        FOR r IN (SELECT team_id FROM prod.dct_tm_visibility_grant
                  WHERE grantee_user_id = p_user_id AND scope = 'TEAM' AND status = 'ACTIVE'
                  AND   team_id IS NOT NULL
                  AND   start_date <= SYSDATE AND (end_date IS NULL OR end_date >= TRUNC(SYSDATE))) LOOP
            v_set(r.team_id) := 1;
        END LOOP;

        -- (d) team-tree grants -> root team + all descendant sub-teams
        FOR root IN (SELECT team_id FROM prod.dct_tm_visibility_grant
                     WHERE grantee_user_id = p_user_id AND scope = 'TEAM_TREE' AND status = 'ACTIVE'
                     AND   team_id IS NOT NULL
                     AND   start_date <= SYSDATE AND (end_date IS NULL OR end_date >= TRUNC(SYSDATE))) LOOP
            FOR d IN (SELECT team_id FROM prod.dct_tm_teams
                      START WITH team_id = root.team_id
                      CONNECT BY NOCYCLE PRIOR team_id = parent_team_id) LOOP
                v_set(d.team_id) := 1;
            END LOOP;
        END LOOP;

        -- (f) org-scope: org-head OR active ORG grant -> all teams at/under that org node
        FOR org IN (
                SELECT org_id FROM prod.dct_organizations WHERE head_user_id = p_user_id
                UNION
                SELECT org_id FROM prod.dct_tm_visibility_grant
                WHERE grantee_user_id = p_user_id AND scope = 'ORG' AND status = 'ACTIVE'
                AND   org_id IS NOT NULL
                AND   start_date <= SYSDATE AND (end_date IS NULL OR end_date >= TRUNC(SYSDATE))
            ) LOOP
            FOR t IN (SELECT team_id FROM prod.dct_tm_teams
                      WHERE org_id IN (SELECT org_id FROM prod.dct_organizations
                                       START WITH org_id = org.org_id
                                       CONNECT BY NOCYCLE PRIOR org_id = parent_org_id)) LOOP
                v_set(t.team_id) := 1;
            END LOOP;
        END LOOP;

        i := v_set.FIRST;
        WHILE i IS NOT NULL LOOP
            PIPE ROW (i);
            i := v_set.NEXT(i);
        END LOOP;
        RETURN;
    END visible_teams;

    FUNCTION can_view_team (p_user_id NUMBER, p_team_id NUMBER) RETURN VARCHAR2 IS
        v_n NUMBER;
    BEGIN
        IF p_user_id IS NULL OR p_team_id IS NULL THEN RETURN 'N'; END IF;
        -- cheap common cases first
        IF can_view_all(p_user_id) = 'Y' THEN RETURN 'Y'; END IF;
        SELECT COUNT(*) INTO v_n FROM prod.dct_tm_members
        WHERE  team_id = p_team_id AND user_id = p_user_id AND is_active = 'Y';
        IF v_n > 0 THEN RETURN 'Y'; END IF;
        SELECT COUNT(*) INTO v_n FROM prod.dct_tm_teams
        WHERE  team_id = p_team_id AND leader_user_id = p_user_id;
        IF v_n > 0 THEN RETURN 'Y'; END IF;
        -- exception cases (team/team-tree/org grants): fall back to the resolved set
        SELECT COUNT(*) INTO v_n
        FROM   TABLE(prod.dct_tm_vis_pkg.visible_teams(p_user_id))
        WHERE  column_value = p_team_id;
        RETURN CASE WHEN v_n > 0 THEN 'Y' ELSE 'N' END;
    END can_view_team;

    FUNCTION create_grant (
        p_actor_id     NUMBER,
        p_grantee_id   NUMBER,
        p_scope        VARCHAR2,
        p_team_id      NUMBER   DEFAULT NULL,
        p_org_id       NUMBER   DEFAULT NULL,
        p_access_level VARCHAR2 DEFAULT 'VIEWER',
        p_end_date     DATE     DEFAULT NULL,
        p_reason       VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER IS
        v_id   NUMBER;
        v_name VARCHAR2(200);
    BEGIN
        IF p_actor_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20401, 'Not authenticated.');
        END IF;
        IF prod.dct_tm_pkg.is_tm_admin(p_actor_id) <> 'Y' THEN
            RAISE_APPLICATION_ERROR(-20403, 'Only a Task Management admin may grant cross-team visibility.');
        END IF;
        IF p_grantee_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Grantee is required.');
        END IF;
        prod.dct_lookup_pkg.validate_lookup('TM_VIS_SCOPE',  p_scope);
        prod.dct_lookup_pkg.validate_lookup('TM_VIS_LEVEL',  p_access_level);
        -- shape rules (mirror the table CHECK so we fail with a friendly 400)
        IF p_scope IN ('TEAM','TEAM_TREE') AND p_team_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'A team is required for a team-scoped grant.');
        END IF;
        IF p_scope = 'ORG' AND p_org_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'An organization unit is required for an org-scoped grant.');
        END IF;

        v_name := prod.dct_tm_pkg.actor_name(p_actor_id);
        INSERT INTO prod.dct_tm_visibility_grant
            (grantee_user_id, scope, team_id, org_id, access_level,
             granted_by, start_date, end_date, status, reason, created_by)
        VALUES
            (p_grantee_id, p_scope,
             CASE WHEN p_scope IN ('TEAM','TEAM_TREE') THEN p_team_id END,
             CASE WHEN p_scope = 'ORG' THEN p_org_id END,
             p_access_level, p_actor_id, SYSDATE, p_end_date, 'ACTIVE', p_reason, v_name)
        RETURNING grant_id INTO v_id;

        INSERT INTO prod.dct_request_status_history
            (source_module, source_type, source_id, old_status, new_status, changed_by, comments)
        VALUES ('TM', 'VIS_GRANT', v_id, NULL, 'ACTIVE', p_actor_id,
                'Visibility grant (' || p_scope || '/' || p_access_level || ')');
        RETURN v_id;
    END create_grant;

    PROCEDURE revoke_grant (p_actor_id NUMBER, p_grant_id NUMBER) IS
        v_n NUMBER;
    BEGIN
        IF p_actor_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20401, 'Not authenticated.');
        END IF;
        IF prod.dct_tm_pkg.is_tm_admin(p_actor_id) <> 'Y' THEN
            RAISE_APPLICATION_ERROR(-20403, 'Only a Task Management admin may revoke a visibility grant.');
        END IF;
        UPDATE prod.dct_tm_visibility_grant
        SET    status = 'REVOKED', updated_by = prod.dct_tm_pkg.actor_name(p_actor_id)
        WHERE  grant_id = p_grant_id AND status = 'ACTIVE';
        v_n := SQL%ROWCOUNT;
        IF v_n = 0 THEN
            RAISE_APPLICATION_ERROR(-20404, 'Active visibility grant not found.');
        END IF;
        INSERT INTO prod.dct_request_status_history
            (source_module, source_type, source_id, old_status, new_status, changed_by, comments)
        VALUES ('TM', 'VIS_GRANT', p_grant_id, 'ACTIVE', 'REVOKED', p_actor_id, 'Visibility grant revoked');
    END revoke_grant;

    PROCEDURE set_team_parent (p_actor_id NUMBER, p_team_id NUMBER, p_parent_id NUMBER DEFAULT NULL) IS
        v_cycle NUMBER;
    BEGIN
        prod.dct_tm_pkg.require_perm(p_actor_id, p_team_id, 'TEAM', 'UPDATE');
        IF p_parent_id IS NOT NULL THEN
            IF p_parent_id = p_team_id THEN
                RAISE_APPLICATION_ERROR(-20001, 'A team cannot be its own parent.');
            END IF;
            -- reject if the proposed parent is within this team's own subtree (would create a cycle)
            SELECT COUNT(*) INTO v_cycle
            FROM   prod.dct_tm_teams
            WHERE  team_id = p_parent_id
            START  WITH team_id = p_team_id
            CONNECT BY NOCYCLE PRIOR team_id = parent_team_id;
            IF v_cycle > 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'That team is a sub-team of this team; the link would create a cycle.');
            END IF;
        END IF;
        UPDATE prod.dct_tm_teams
        SET    parent_team_id = p_parent_id, updated_by = prod.dct_tm_pkg.actor_name(p_actor_id)
        WHERE  team_id = p_team_id;
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20404, 'Team not found.');
        END IF;
    END set_team_parent;

END dct_tm_vis_pkg;
/

SHOW ERRORS PACKAGE prod.dct_tm_vis_pkg
SHOW ERRORS PACKAGE BODY prod.dct_tm_vis_pkg

PROMPT
PROMPT === 11_tm_vis_pkg.sql complete ===
