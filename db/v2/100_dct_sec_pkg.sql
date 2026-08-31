SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
-- db/v2/100_dct_sec_pkg.sql
-- Security Console, part 2 of 3: resolution views plus packages.
--   V_DCT_USER_PRIVS_EFF   effective privileges per user (flat closure minus
--                          user exclusions), the one join has_priv reads.
--   V_DCT_SEC_USER_SCOPE   data-security scope keys per user, hierarchy dims
--                          pre-expanded (ORG descendants, CLASS descendants).
--   DCT_SEC                has_priv / has_priv_or_role / refresh_flat /
--                          copy_role / hierarchy guards. No COMMIT inside.
--   DCT_SEC_DATA           is_unrestricted -- the fail-open data-scope gate.
-- Depends on 99. Deploy with SQLcl in its own session; ADMIN synonyms in 101.

PROMPT --- effective privilege view ---

CREATE OR REPLACE VIEW prod.v_dct_user_privs_eff AS
SELECT DISTINCT
       u.user_id,
       u.username,
       p.permission_id,
       p.permission_code,
       p.action_type,
       p.module_id,
       f.role_id      AS root_role_id,
       f.via_role_id,
       f.via_group_id
FROM  prod.dct_user_roles        ur
JOIN  prod.dct_users             u  ON ur.user_id = u.user_id
JOIN  prod.dct_roles             r  ON ur.role_id = r.role_id
JOIN  prod.dct_sec_role_priv_flat f ON f.role_id  = r.role_id
JOIN  prod.dct_permissions       p  ON p.permission_id = f.permission_id
WHERE ur.is_active = 'Y'
  AND u.is_active  = 'Y'
  AND r.is_active  = 'Y'
  AND p.is_active  = 'Y'
  AND TRUNC(SYSDATE) >= TRUNC(ur.start_date)
  AND (ur.end_date IS NULL OR TRUNC(SYSDATE) <= TRUNC(ur.end_date))
  AND NOT EXISTS (
        SELECT 1 FROM prod.dct_sec_exclusion x
         WHERE x.scope_type    = 'USER'
           AND x.user_id       = u.user_id
           AND x.permission_id = f.permission_id
           AND x.is_active     = 'Y');

PROMPT --- data scope view (hierarchy dims pre-expanded) ---

CREATE OR REPLACE VIEW prod.v_dct_sec_user_scope AS
WITH act AS (
    SELECT up.user_id, ps.object_type_code, ps.object_key, ps.object_key2,
           ps.include_children, ot.hierarchy_kind
      FROM prod.dct_sec_user_profile  up
      JOIN prod.dct_sec_profile       pr ON pr.profile_id = up.profile_id
                                        AND pr.is_active = 'Y'
      JOIN prod.dct_sec_profile_scope ps ON ps.profile_id = up.profile_id
      JOIN prod.dct_wf_object_type    ot ON ot.object_type_code = ps.object_type_code
     WHERE up.is_active = 'Y'
       AND TRUNC(SYSDATE) >= TRUNC(up.start_date)
       AND (up.end_date IS NULL OR TRUNC(SYSDATE) <= TRUNC(up.end_date))
),
org_exp (user_id, object_type_code, org_id) AS (
    SELECT a.user_id, a.object_type_code, TO_NUMBER(a.object_key)
      FROM act a
     WHERE a.hierarchy_kind = 'ORG' AND a.include_children = 'Y'
    UNION ALL
    SELECT e.user_id, e.object_type_code, o.org_id
      FROM org_exp e
      JOIN prod.dct_organizations o ON o.parent_org_id = e.org_id
     WHERE o.is_active = 'Y'
),
cls_exp (user_id, object_type_code, class_value_id) AS (
    SELECT a.user_id, a.object_type_code, cv.class_value_id
      FROM act a
      JOIN prod.dct_gl_class_value cv
        ON cv.value_code = a.object_key AND cv.is_active = 'Y'
      JOIN prod.dct_wf_object_type ot
        ON ot.object_type_code = a.object_type_code
       AND cv.class_type_code = CASE ot.object_type_code
                                    WHEN 'DCT_PROGRAM' THEN 'DCT_PROGRAM'
                                    WHEN 'SECTOR'      THEN 'SECTOR'
                                    WHEN 'CHAPTER'     THEN 'CHAPTER'
                                END
     WHERE a.hierarchy_kind = 'CLASS' AND a.include_children = 'Y'
    UNION ALL
    SELECT e.user_id, e.object_type_code, cv.class_value_id
      FROM cls_exp e
      JOIN prod.dct_gl_class_value cv ON cv.parent_value_id = e.class_value_id
     WHERE cv.is_active = 'Y'
)
SELECT user_id, object_type_code, object_key, object_key2
  FROM act
UNION
SELECT e.user_id, e.object_type_code, TO_CHAR(e.org_id), NULL
  FROM org_exp e
UNION
SELECT e.user_id, e.object_type_code, cv.value_code, NULL
  FROM cls_exp e
  JOIN prod.dct_gl_class_value cv ON cv.class_value_id = e.class_value_id;

PROMPT --- DCT_SEC package ---

CREATE OR REPLACE PACKAGE prod.dct_sec AS
    -- Effective-privilege check. Mirrors DCT_AUTH.HAS_ROLE:
    -- VARCHAR2 username in, BOOLEAN out, delegation honoured, fail-closed.
    -- SYS_ADMIN always passes.
    FUNCTION has_priv (
        p_username  IN VARCHAR2,
        p_priv_code IN VARCHAR2
    ) RETURN BOOLEAN;

    -- Grandfathering helper for per-module migration.
    -- FEATURE_SEC_ENFORCE_<module> = 'Y'  -> privilege only.
    -- otherwise                          -> privilege OR legacy role; a NULL
    -- legacy role means the endpoint historically required only a valid
    -- session (GL-style), so everyone passes until the module's flag flips.
    FUNCTION has_priv_or_role (
        p_username    IN VARCHAR2,
        p_priv_code   IN VARCHAR2,
        p_legacy_role IN VARCHAR2,
        p_module      IN VARCHAR2
    ) RETURN BOOLEAN;

    -- Rebuilds DCT_SEC_ROLE_PRIV_FLAT (always the full closure -- a duty
    -- change ripples to every ancestor) and bumps the cache version.
    PROCEDURE refresh_flat (p_role_id IN NUMBER DEFAULT NULL);

    -- Bump the cache version without a rebuild (user-level mutations:
    -- role assignments, user exclusions, profile assignments).
    PROCEDURE bump_version;

    FUNCTION get_version RETURN NUMBER;

    -- Deep copy of a role definition. Copies: role row, direct privilege
    -- grants, privilege-group grants, ROLE-scope exclusions, child hierarchy
    -- links. Never copies: parent links, user assignments, module mappings.
    FUNCTION copy_role (
        p_role_id     IN NUMBER,
        p_new_code    IN VARCHAR2,
        p_new_name    IN VARCHAR2,
        p_new_name_ar IN VARCHAR2 DEFAULT NULL,
        p_by          IN VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER;

    -- Nest a duty role inside a parent role. Child must be category DUTY.
    -- Rejects self-reference, cycles and depth greater than 5.
    PROCEDURE add_hierarchy (
        p_parent_role_id IN NUMBER,
        p_child_role_id  IN NUMBER,
        p_by             IN VARCHAR2 DEFAULT NULL
    );

    PROCEDURE remove_hierarchy (
        p_parent_role_id IN NUMBER,
        p_child_role_id  IN NUMBER
    );
END dct_sec;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_sec AS

    TYPE t_priv_set IS TABLE OF BOOLEAN INDEX BY VARCHAR2(200);

    g_cache_user    VARCHAR2(100);
    g_cache_version NUMBER := -1;
    g_cache_admin   BOOLEAN := FALSE;
    g_cache_privs   t_priv_set;

    FUNCTION get_version RETURN NUMBER IS
        l_v NUMBER;
    BEGIN
        SELECT version INTO l_v FROM prod.dct_sec_version WHERE lock_id = 1;
        RETURN l_v;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 0;
    END get_version;

    PROCEDURE bump_version IS
    BEGIN
        UPDATE prod.dct_sec_version
           SET version = version + 1, updated_at = SYSTIMESTAMP
         WHERE lock_id = 1;
    END bump_version;

    -- -------------------------------------------------------------------------
    -- load_cache: effective privileges of the user PLUS (delegation) the
    -- privileges of the user they are actively acting for.
    -- -------------------------------------------------------------------------
    PROCEDURE load_cache (p_username IN VARCHAR2, p_version IN NUMBER) IS
        l_eff VARCHAR2(100);
        l_n   NUMBER;
    BEGIN
        g_cache_privs.DELETE;
        g_cache_admin := FALSE;

        FOR r IN (SELECT DISTINCT permission_code
                    FROM prod.v_dct_user_privs_eff
                   WHERE UPPER(username) = UPPER(p_username)) LOOP
            g_cache_privs(UPPER(r.permission_code)) := TRUE;
        END LOOP;

        l_eff := prod.dct_auth.get_effective_user(p_username);
        IF UPPER(l_eff) <> UPPER(p_username) THEN
            FOR r IN (SELECT DISTINCT permission_code
                        FROM prod.v_dct_user_privs_eff
                       WHERE UPPER(username) = UPPER(l_eff)) LOOP
                g_cache_privs(UPPER(r.permission_code)) := TRUE;
            END LOOP;
        END IF;

        SELECT COUNT(*) INTO l_n
          FROM prod.v_dct_user_active_roles
         WHERE UPPER(username) = UPPER(p_username)
           AND role_code = 'SYS_ADMIN';
        g_cache_admin := l_n > 0;

        g_cache_user    := UPPER(p_username);
        g_cache_version := p_version;
    END load_cache;

    FUNCTION has_priv (p_username IN VARCHAR2, p_priv_code IN VARCHAR2)
        RETURN BOOLEAN
    IS
        l_ver NUMBER;
    BEGIN
        IF p_username IS NULL OR p_priv_code IS NULL THEN
            RETURN FALSE;
        END IF;
        l_ver := get_version;
        IF g_cache_user IS NULL
           OR g_cache_user <> UPPER(p_username)
           OR g_cache_version <> l_ver THEN
            load_cache(p_username, l_ver);
        END IF;
        IF g_cache_admin THEN
            RETURN TRUE;
        END IF;
        RETURN g_cache_privs.EXISTS(UPPER(p_priv_code));
    EXCEPTION WHEN OTHERS THEN RETURN FALSE;
    END has_priv;

    FUNCTION has_priv_or_role (
        p_username    IN VARCHAR2,
        p_priv_code   IN VARCHAR2,
        p_legacy_role IN VARCHAR2,
        p_module      IN VARCHAR2
    ) RETURN BOOLEAN
    IS
        l_enforce VARCHAR2(10) := 'N';
    BEGIN
        IF has_priv(p_username, p_priv_code) THEN
            RETURN TRUE;
        END IF;
        BEGIN
            SELECT NVL(MAX(setting_value), 'N') INTO l_enforce
              FROM prod.dct_system_settings
             WHERE setting_key = 'FEATURE_SEC_ENFORCE_' || UPPER(p_module);
        EXCEPTION WHEN OTHERS THEN l_enforce := 'N';
        END;
        IF l_enforce = 'Y' THEN
            RETURN FALSE;
        END IF;
        IF p_legacy_role IS NULL THEN
            RETURN TRUE;
        END IF;
        RETURN prod.dct_auth.has_role(p_username, p_legacy_role);
    EXCEPTION WHEN OTHERS THEN RETURN FALSE;
    END has_priv_or_role;

    -- -------------------------------------------------------------------------
    -- refresh_flat: full closure rebuild. Cheap at platform scale and a duty
    -- edit invalidates every ancestor closure anyway.
    -- -------------------------------------------------------------------------
    PROCEDURE refresh_flat (p_role_id IN NUMBER DEFAULT NULL) IS
    BEGIN
        DELETE FROM prod.dct_sec_role_priv_flat;

        INSERT INTO prod.dct_sec_role_priv_flat
            (role_id, permission_id, via_role_id, via_group_id)
        WITH rh (root_id, node_id, lvl) AS (
            SELECT role_id, role_id, 0
              FROM prod.dct_roles
             WHERE is_active = 'Y'
            UNION ALL
            SELECT rh.root_id, h.child_role_id, rh.lvl + 1
              FROM rh
              JOIN prod.dct_sec_role_hierarchy h ON h.parent_role_id = rh.node_id
             WHERE rh.lvl < 5
        )
        CYCLE node_id SET is_cycle TO 'Y' DEFAULT 'N',
        grants AS (
            SELECT rh.root_id, rp.permission_id,
                   rh.node_id AS via_role_id,
                   CAST(NULL AS NUMBER) AS via_group_id
              FROM rh
              JOIN prod.dct_role_permissions rp ON rp.role_id = rh.node_id
             WHERE rh.is_cycle = 'N'
            UNION ALL
            SELECT rh.root_id, gi.permission_id, rh.node_id, g.group_id
              FROM rh
              JOIN prod.dct_sec_role_priv_group rpg ON rpg.role_id = rh.node_id
              JOIN prod.dct_sec_priv_group g
                ON g.group_id = rpg.group_id AND g.is_active = 'Y'
              JOIN prod.dct_sec_priv_group_item gi ON gi.group_id = g.group_id
             WHERE rh.is_cycle = 'N'
        )
        SELECT DISTINCT gr.root_id, gr.permission_id, gr.via_role_id, gr.via_group_id
          FROM grants gr
         WHERE NOT EXISTS (
                 SELECT 1 FROM prod.dct_sec_exclusion x
                  WHERE x.scope_type    = 'ROLE'
                    AND x.role_id       = gr.root_id
                    AND x.permission_id = gr.permission_id
                    AND x.is_active     = 'Y');

        bump_version;
    END refresh_flat;

    -- -------------------------------------------------------------------------
    -- copy_role
    -- -------------------------------------------------------------------------
    FUNCTION copy_role (
        p_role_id     IN NUMBER,
        p_new_code    IN VARCHAR2,
        p_new_name    IN VARCHAR2,
        p_new_name_ar IN VARCHAR2 DEFAULT NULL,
        p_by          IN VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER
    IS
        l_new_id NUMBER;
        l_n      NUMBER;
        l_src    prod.dct_roles%ROWTYPE;
    BEGIN
        BEGIN
            SELECT * INTO l_src FROM prod.dct_roles WHERE role_id = p_role_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'Source role not found');
        END;
        SELECT COUNT(*) INTO l_n FROM prod.dct_roles
         WHERE UPPER(role_code) = UPPER(p_new_code);
        IF l_n > 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Role code already exists: ' || p_new_code);
        END IF;

        INSERT INTO prod.dct_roles
            (role_code, role_name_en, role_name_ar, role_type, role_category,
             module_id, description_en, description_ar,
             is_system_role, is_active, display_order,
             created_from_role_id, created_by)
        VALUES (UPPER(p_new_code), p_new_name,
             NVL(p_new_name_ar, l_src.role_name_ar),
             l_src.role_type, l_src.role_category, l_src.module_id,
             l_src.description_en, l_src.description_ar,
             'N', 'Y', l_src.display_order,
             p_role_id, p_by)
        RETURNING role_id INTO l_new_id;

        INSERT INTO prod.dct_role_permissions (role_id, permission_id, granted_by)
        SELECT l_new_id, permission_id, p_by
          FROM prod.dct_role_permissions
         WHERE role_id = p_role_id;

        INSERT INTO prod.dct_sec_role_priv_group (role_id, group_id, granted_by)
        SELECT l_new_id, group_id, p_by
          FROM prod.dct_sec_role_priv_group
         WHERE role_id = p_role_id;

        INSERT INTO prod.dct_sec_exclusion
            (scope_type, role_id, permission_id, reason, created_by)
        SELECT 'ROLE', l_new_id, permission_id, reason, p_by
          FROM prod.dct_sec_exclusion
         WHERE scope_type = 'ROLE' AND role_id = p_role_id AND is_active = 'Y';

        INSERT INTO prod.dct_sec_role_hierarchy (parent_role_id, child_role_id, created_by)
        SELECT l_new_id, child_role_id, p_by
          FROM prod.dct_sec_role_hierarchy
         WHERE parent_role_id = p_role_id;

        refresh_flat;
        RETURN l_new_id;
    END copy_role;

    -- -------------------------------------------------------------------------
    -- add_hierarchy: child must be a DUTY role; no self-links, no cycles,
    -- resulting depth capped at 5.
    -- -------------------------------------------------------------------------
    PROCEDURE add_hierarchy (
        p_parent_role_id IN NUMBER,
        p_child_role_id  IN NUMBER,
        p_by             IN VARCHAR2 DEFAULT NULL
    ) IS
        l_cat   VARCHAR2(10);
        l_n     NUMBER;
        l_depth NUMBER;
    BEGIN
        IF p_parent_role_id = p_child_role_id THEN
            RAISE_APPLICATION_ERROR(-20001, 'A role cannot contain itself');
        END IF;
        BEGIN
            SELECT role_category INTO l_cat
              FROM prod.dct_roles WHERE role_id = p_child_role_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'Child role not found');
        END;
        IF l_cat <> 'DUTY' THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Only duty roles can be nested inside another role');
        END IF;

        -- cycle guard: the parent must not be reachable underneath the child
        WITH down (node_id, lvl) AS (
            SELECT p_child_role_id, 0 FROM dual
            UNION ALL
            SELECT h.child_role_id, d.lvl + 1
              FROM down d
              JOIN prod.dct_sec_role_hierarchy h ON h.parent_role_id = d.node_id
             WHERE d.lvl < 10
        )
        CYCLE node_id SET is_cycle TO 'Y' DEFAULT 'N'
        SELECT COUNT(*) INTO l_n FROM down WHERE node_id = p_parent_role_id;
        IF l_n > 0 THEN
            RAISE_APPLICATION_ERROR(-20001,
                'This nesting would create a cycle in the role hierarchy');
        END IF;

        -- depth guard: ancestors of parent + descendants of child must fit in 5
        WITH up (node_id, lvl) AS (
            SELECT p_parent_role_id, 0 FROM dual
            UNION ALL
            SELECT h.parent_role_id, u.lvl + 1
              FROM up u
              JOIN prod.dct_sec_role_hierarchy h ON h.child_role_id = u.node_id
             WHERE u.lvl < 10
        )
        CYCLE node_id SET is_cycle TO 'Y' DEFAULT 'N'
        SELECT NVL(MAX(lvl), 0) INTO l_depth FROM up;

        DECLARE
            l_down NUMBER;
        BEGIN
            WITH down (node_id, lvl) AS (
                SELECT p_child_role_id, 0 FROM dual
                UNION ALL
                SELECT h.child_role_id, d.lvl + 1
                  FROM down d
                  JOIN prod.dct_sec_role_hierarchy h ON h.parent_role_id = d.node_id
                 WHERE d.lvl < 10
            )
            CYCLE node_id SET is_cycle TO 'Y' DEFAULT 'N'
            SELECT NVL(MAX(lvl), 0) INTO l_down FROM down;
            IF l_depth + 1 + l_down > 5 THEN
                RAISE_APPLICATION_ERROR(-20001,
                    'Role hierarchy depth is limited to 5 levels');
            END IF;
        END;

        INSERT INTO prod.dct_sec_role_hierarchy
            (parent_role_id, child_role_id, created_by)
        VALUES (p_parent_role_id, p_child_role_id, p_by);

        refresh_flat;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20001, 'This duty is already nested in the role');
    END add_hierarchy;

    PROCEDURE remove_hierarchy (
        p_parent_role_id IN NUMBER,
        p_child_role_id  IN NUMBER
    ) IS
    BEGIN
        DELETE FROM prod.dct_sec_role_hierarchy
         WHERE parent_role_id = p_parent_role_id
           AND child_role_id  = p_child_role_id;
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20404, 'Hierarchy link not found');
        END IF;
        refresh_flat;
    END remove_hierarchy;

END dct_sec;
/

PROMPT --- DCT_SEC_DATA package ---

CREATE OR REPLACE PACKAGE prod.dct_sec_data AS
    -- Data-security gate for one dimension. Returns 1 (unrestricted) when the
    -- user is SYS_ADMIN, has no active security profile, or has no scope rows
    -- on this dimension. Returns 0 when scope rows exist -- the caller then
    -- filters with:  col IN (SELECT object_key FROM v_dct_sec_user_scope
    --                         WHERE user_id = :uid AND object_type_code = :dim)
    -- Fail-open (errors return 1), consistent with the module-access gate.
    FUNCTION is_unrestricted (
        p_user_id     IN NUMBER,
        p_object_type IN VARCHAR2
    ) RETURN NUMBER;
END dct_sec_data;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_sec_data AS

    FUNCTION is_unrestricted (
        p_user_id     IN NUMBER,
        p_object_type IN VARCHAR2
    ) RETURN NUMBER
    IS
        l_n NUMBER;
    BEGIN
        IF p_user_id IS NULL THEN
            RETURN 1;
        END IF;

        SELECT COUNT(*) INTO l_n
          FROM prod.v_dct_user_active_roles
         WHERE user_id = p_user_id AND role_code = 'SYS_ADMIN';
        IF l_n > 0 THEN
            RETURN 1;
        END IF;

        SELECT COUNT(*) INTO l_n
          FROM prod.dct_sec_user_profile  up
          JOIN prod.dct_sec_profile       pr ON pr.profile_id = up.profile_id
                                            AND pr.is_active = 'Y'
          JOIN prod.dct_sec_profile_scope ps ON ps.profile_id = up.profile_id
         WHERE up.user_id   = p_user_id
           AND up.is_active = 'Y'
           AND TRUNC(SYSDATE) >= TRUNC(up.start_date)
           AND (up.end_date IS NULL OR TRUNC(SYSDATE) <= TRUNC(up.end_date))
           AND ps.object_type_code = UPPER(p_object_type)
           AND ROWNUM = 1;
        RETURN CASE WHEN l_n > 0 THEN 0 ELSE 1 END;
    EXCEPTION WHEN OTHERS THEN RETURN 1;
    END is_unrestricted;

END dct_sec_data;
/

PROMPT --- initial closure build ---

BEGIN
    prod.dct_sec.refresh_flat;
    COMMIT;
END;
/

PROMPT --- recompile sweep ---

BEGIN
    FOR r IN (SELECT object_name, object_type FROM all_objects
               WHERE owner = 'PROD' AND status = 'INVALID') LOOP
        BEGIN
            IF r.object_type = 'PACKAGE BODY' THEN
                EXECUTE IMMEDIATE 'ALTER PACKAGE prod.' || r.object_name || ' COMPILE BODY';
            ELSIF r.object_type = 'PACKAGE' THEN
                EXECUTE IMMEDIATE 'ALTER PACKAGE prod.' || r.object_name || ' COMPILE';
            ELSIF r.object_type = 'VIEW' THEN
                EXECUTE IMMEDIATE 'ALTER VIEW prod.' || r.object_name || ' COMPILE';
            ELSE
                EXECUTE IMMEDIATE 'ALTER ' || r.object_type || ' prod.' || r.object_name || ' COMPILE';
            END IF;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;
END;
/

SELECT object_type, object_name, status
  FROM all_objects WHERE owner = 'PROD' AND status = 'INVALID';

EXIT
