SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
-- db/v2/99_dct_sec_ddl.sql
-- Security Console (Fusion-style RBAC), part 1 of 3: DDL plus seeds.
-- Privilege groups, role hierarchy (duty inside job or abstract), exclusions,
-- security profiles (data scoping by dimension), materialized privilege
-- closure, page and artifact registry for the Security Info drawer.
-- EXTENDS the existing DCT_ROLES / DCT_PERMISSIONS model -- nothing here
-- changes current behaviour; enforcement arrives per module via the
-- FEATURE_SEC_ENFORCE settings read by DCT_SEC.has_priv_or_role.
-- Idempotent. Companion scripts: 100 pkg, 101 API.

PROMPT --- column additions on existing tables ---

DECLARE
    v NUMBER;
    PROCEDURE addcol (p_table VARCHAR2, p_col VARCHAR2, p_ddl VARCHAR2) IS
        n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO n FROM all_tab_columns
         WHERE owner = 'PROD' AND table_name = p_table AND column_name = p_col;
        IF n = 0 THEN
            EXECUTE IMMEDIATE p_ddl;
            DBMS_OUTPUT.PUT_LINE('  ' || p_table || '.' || p_col || ' added');
        ELSE
            DBMS_OUTPUT.PUT_LINE('  ' || p_table || '.' || p_col || ' already present');
        END IF;
    END;
BEGIN
    addcol('DCT_ROLES', 'ROLE_CATEGORY',
        q'[ALTER TABLE prod.dct_roles ADD (role_category VARCHAR2(10) DEFAULT 'JOB' NOT NULL CONSTRAINT chk_dct_role_cat CHECK (role_category IN ('ABSTRACT','DUTY','JOB')))]');
    addcol('DCT_ROLES', 'CREATED_FROM_ROLE_ID',
        'ALTER TABLE prod.dct_roles ADD (created_from_role_id NUMBER REFERENCES prod.dct_roles(role_id))');
    addcol('DCT_PERMISSIONS', 'VERB',
        'ALTER TABLE prod.dct_permissions ADD (verb VARCHAR2(30))');
    addcol('DCT_WF_OBJECT_TYPE', 'USE_IN_SECURITY',
        q'[ALTER TABLE prod.dct_wf_object_type ADD (use_in_security VARCHAR2(1) DEFAULT 'N' NOT NULL CONSTRAINT chk_wf_ot_sec CHECK (use_in_security IN ('Y','N')))]');
    addcol('DCT_WF_OBJECT_TYPE', 'USE_IN_WF',
        q'[ALTER TABLE prod.dct_wf_object_type ADD (use_in_wf VARCHAR2(1) DEFAULT 'Y' NOT NULL CONSTRAINT chk_wf_ot_wf CHECK (use_in_wf IN ('Y','N')))]');

    -- hierarchy_kind gains CLASS (dct_gl_class_value parent tree) for DCT_PROGRAM
    SELECT COUNT(*) INTO v
      FROM all_constraints
     WHERE owner = 'PROD' AND constraint_name = 'CHK_WF_OT_HK'
       AND INSTR(search_condition_vc, 'CLASS') > 0;
    IF v = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_wf_object_type DROP CONSTRAINT chk_wf_ot_hk';
        EXECUTE IMMEDIATE q'[ALTER TABLE prod.dct_wf_object_type ADD CONSTRAINT chk_wf_ot_hk CHECK (hierarchy_kind IN ('NONE','ORG','CLASS'))]';
        DBMS_OUTPUT.PUT_LINE('  chk_wf_ot_hk: CLASS added');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  chk_wf_ot_hk: already allows CLASS');
    END IF;
END;
/

PROMPT --- new tables ---

DECLARE
    PROCEDURE mk (p_ddl IN VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE p_ddl;
        DBMS_OUTPUT.PUT_LINE('  created');
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE IN (-955, -1408, -1430, -2260, -2275, -1442) THEN
            DBMS_OUTPUT.PUT_LINE('  exists, skipped');
        ELSE RAISE; END IF;
    END;
BEGIN
    mk(q'[CREATE TABLE prod.dct_sec_priv_group (
        group_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        group_code     VARCHAR2(100) NOT NULL,
        name_en        VARCHAR2(200) NOT NULL,
        name_ar        VARCHAR2(200),
        module_id      NUMBER REFERENCES prod.dct_modules(module_id),
        description_en VARCHAR2(1000),
        description_ar VARCHAR2(1000),
        is_active      VARCHAR2(1) DEFAULT 'Y' NOT NULL,
        display_order  NUMBER DEFAULT 10,
        created_by     VARCHAR2(100),
        created_at     TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        updated_by     VARCHAR2(100),
        updated_at     TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT uq_sec_pg_code UNIQUE (group_code),
        CONSTRAINT chk_sec_pg_act CHECK (is_active IN ('Y','N'))
    )]');

    mk(q'[CREATE TABLE prod.dct_sec_priv_group_item (
        item_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        group_id      NUMBER NOT NULL REFERENCES prod.dct_sec_priv_group(group_id),
        permission_id NUMBER NOT NULL REFERENCES prod.dct_permissions(permission_id),
        added_by      VARCHAR2(100),
        added_at      TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT uq_sec_pgi UNIQUE (group_id, permission_id)
    )]');

    mk(q'[CREATE TABLE prod.dct_sec_role_hierarchy (
        rh_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        parent_role_id NUMBER NOT NULL REFERENCES prod.dct_roles(role_id),
        child_role_id  NUMBER NOT NULL REFERENCES prod.dct_roles(role_id),
        created_by     VARCHAR2(100),
        created_at     TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT uq_sec_rh UNIQUE (parent_role_id, child_role_id),
        CONSTRAINT chk_sec_rh_self CHECK (parent_role_id <> child_role_id)
    )]');

    mk(q'[CREATE TABLE prod.dct_sec_role_priv_group (
        rpg_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        role_id    NUMBER NOT NULL REFERENCES prod.dct_roles(role_id),
        group_id   NUMBER NOT NULL REFERENCES prod.dct_sec_priv_group(group_id),
        granted_by VARCHAR2(100),
        granted_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT uq_sec_rpg UNIQUE (role_id, group_id)
    )]');

    mk(q'[CREATE TABLE prod.dct_sec_exclusion (
        exclusion_id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        scope_type    VARCHAR2(10) NOT NULL,
        role_id       NUMBER REFERENCES prod.dct_roles(role_id),
        user_id       NUMBER REFERENCES prod.dct_users(user_id),
        permission_id NUMBER NOT NULL REFERENCES prod.dct_permissions(permission_id),
        reason        VARCHAR2(500),
        is_active     VARCHAR2(1) DEFAULT 'Y' NOT NULL,
        created_by    VARCHAR2(100),
        created_at    TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        ended_by      VARCHAR2(100),
        ended_at      TIMESTAMP,
        CONSTRAINT chk_sec_ex_scope CHECK (
            (scope_type = 'ROLE' AND role_id IS NOT NULL AND user_id IS NULL) OR
            (scope_type = 'USER' AND user_id IS NOT NULL AND role_id IS NULL)),
        CONSTRAINT chk_sec_ex_act CHECK (is_active IN ('Y','N'))
    )]');

    mk(q'[CREATE UNIQUE INDEX prod.uq_sec_ex_dup ON prod.dct_sec_exclusion (
        CASE WHEN is_active='Y' THEN scope_type END,
        CASE WHEN is_active='Y' THEN NVL(role_id,0) END,
        CASE WHEN is_active='Y' THEN NVL(user_id,0) END,
        CASE WHEN is_active='Y' THEN permission_id END)]');

    mk(q'[CREATE TABLE prod.dct_sec_profile (
        profile_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        profile_code   VARCHAR2(100) NOT NULL,
        name_en        VARCHAR2(200) NOT NULL,
        name_ar        VARCHAR2(200),
        description_en VARCHAR2(1000),
        description_ar VARCHAR2(1000),
        is_active      VARCHAR2(1) DEFAULT 'Y' NOT NULL,
        created_by     VARCHAR2(100),
        created_at     TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        updated_by     VARCHAR2(100),
        updated_at     TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT uq_sec_prof_code UNIQUE (profile_code),
        CONSTRAINT chk_sec_prof_act CHECK (is_active IN ('Y','N'))
    )]');

    mk(q'[CREATE TABLE prod.dct_sec_profile_scope (
        scope_id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        profile_id       NUMBER NOT NULL REFERENCES prod.dct_sec_profile(profile_id),
        object_type_code VARCHAR2(30) NOT NULL REFERENCES prod.dct_wf_object_type(object_type_code),
        object_key       VARCHAR2(100) NOT NULL,
        object_key2      VARCHAR2(100),
        object_label     VARCHAR2(300),
        include_children VARCHAR2(1) DEFAULT 'N' NOT NULL,
        created_by       VARCHAR2(100),
        created_at       TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT chk_sec_ps_ch   CHECK (include_children IN ('Y','N')),
        CONSTRAINT chk_sec_ps_trim CHECK (object_key = TRIM(object_key))
    )]');

    mk(q'[CREATE UNIQUE INDEX prod.uq_sec_ps ON prod.dct_sec_profile_scope
        (profile_id, object_type_code, object_key, NVL(object_key2,'#'))]');

    mk(q'[CREATE TABLE prod.dct_sec_user_profile (
        up_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        user_id     NUMBER NOT NULL REFERENCES prod.dct_users(user_id),
        profile_id  NUMBER NOT NULL REFERENCES prod.dct_sec_profile(profile_id),
        start_date  DATE DEFAULT TRUNC(SYSDATE) NOT NULL,
        end_date    DATE,
        is_active   VARCHAR2(1) DEFAULT 'Y' NOT NULL,
        assigned_by VARCHAR2(100),
        created_at  TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        ended_by    VARCHAR2(100),
        ended_at    TIMESTAMP,
        CONSTRAINT chk_sec_up_dates CHECK (end_date IS NULL OR end_date >= start_date),
        CONSTRAINT chk_sec_up_act   CHECK (is_active IN ('Y','N'))
    )]');

    mk('CREATE INDEX prod.ix_sec_up_user ON prod.dct_sec_user_profile (user_id, is_active)');

    mk(q'[CREATE TABLE prod.dct_sec_role_priv_flat (
        role_id       NUMBER NOT NULL,
        permission_id NUMBER NOT NULL,
        via_role_id   NUMBER,
        via_group_id  NUMBER
    )]');

    mk('CREATE INDEX prod.ix_sec_flat_role ON prod.dct_sec_role_priv_flat (role_id, permission_id)');
    mk('CREATE INDEX prod.ix_sec_flat_perm ON prod.dct_sec_role_priv_flat (permission_id)');

    mk(q'[CREATE TABLE prod.dct_sec_version (
        lock_id    NUMBER PRIMARY KEY,
        version    NUMBER DEFAULT 0 NOT NULL,
        updated_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT chk_sec_ver_one CHECK (lock_id = 1)
    )]');

    mk(q'[CREATE TABLE prod.dct_sec_page (
        page_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        module_code        VARCHAR2(30) NOT NULL,
        page_code          VARCHAR2(100) NOT NULL,
        name_en            VARCHAR2(200) NOT NULL,
        name_ar            VARCHAR2(200),
        view_permission_id NUMBER REFERENCES prod.dct_permissions(permission_id),
        nav_group          VARCHAR2(100),
        description_en     VARCHAR2(1000),
        is_active          VARCHAR2(1) DEFAULT 'Y' NOT NULL,
        display_order      NUMBER DEFAULT 10,
        created_by         VARCHAR2(100),
        created_at         TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        updated_by         VARCHAR2(100),
        updated_at         TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT uq_sec_page UNIQUE (module_code, page_code),
        CONSTRAINT chk_sec_page_act CHECK (is_active IN ('Y','N'))
    )]');

    mk(q'[CREATE TABLE prod.dct_sec_page_artifact (
        artifact_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        page_id       NUMBER NOT NULL REFERENCES prod.dct_sec_page(page_id),
        artifact_type VARCHAR2(15) NOT NULL,
        artifact_code VARCHAR2(150) NOT NULL,
        label_en      VARCHAR2(300),
        label_ar      VARCHAR2(300),
        permission_id NUMBER REFERENCES prod.dct_permissions(permission_id),
        notes         VARCHAR2(500),
        display_order NUMBER DEFAULT 10,
        is_active     VARCHAR2(1) DEFAULT 'Y' NOT NULL,
        CONSTRAINT uq_sec_pa UNIQUE (page_id, artifact_type, artifact_code),
        CONSTRAINT chk_sec_pa_type CHECK (artifact_type IN
            ('NAV_ITEM','BUTTON','FIELD','TAB','REPORT','ENDPOINT','ACTION')),
        CONSTRAINT chk_sec_pa_act CHECK (is_active IN ('Y','N'))
    )]');
END;
/

PROMPT --- duty roles are never user-assignable ---

CREATE OR REPLACE TRIGGER prod.trg_dct_ur_no_duty
BEFORE INSERT ON prod.dct_user_roles
FOR EACH ROW
DECLARE
    l_cat prod.dct_roles.role_category%TYPE;
BEGIN
    SELECT role_category INTO l_cat
      FROM prod.dct_roles WHERE role_id = :NEW.role_id;
    IF l_cat = 'DUTY' THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Duty roles cannot be assigned directly to users. Nest the duty inside a job or abstract role instead.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

PROMPT --- version row ---

DECLARE
    v NUMBER;
BEGIN
    SELECT COUNT(*) INTO v FROM prod.dct_sec_version WHERE lock_id = 1;
    IF v = 0 THEN
        INSERT INTO prod.dct_sec_version (lock_id, version) VALUES (1, 0);
    END IF;
    COMMIT;
END;
/

PROMPT --- security dimension flags plus new object types ---

CREATE OR REPLACE VIEW prod.v_dct_wf_obj_business_unit AS
SELECT business_unit_name AS bu_name
  FROM prod.projects
 WHERE business_unit_name IS NOT NULL
 GROUP BY business_unit_name
UNION
SELECT business_unit
  FROM prod.ap_invoices_header_v
 WHERE business_unit IS NOT NULL
 GROUP BY business_unit;

CREATE OR REPLACE VIEW prod.v_dct_wf_obj_dct_program AS
SELECT value_code, name_en, name_ar, parent_value_id, class_value_id
  FROM prod.dct_gl_class_value
 WHERE class_type_code = 'DCT_PROGRAM' AND is_active = 'Y';

CREATE OR REPLACE VIEW prod.v_dct_wf_obj_chapter AS
SELECT value_code, name_en, name_ar
  FROM prod.dct_gl_class_value
 WHERE class_type_code = 'CHAPTER' AND is_active = 'Y';

DECLARE
    PROCEDURE ins_ot (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                      p_view VARCHAR2, p_key VARCHAR2, p_label VARCHAR2,
                      p_num VARCHAR2, p_hier VARCHAR2, p_ord NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_wf_object_type WHERE object_type_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_wf_object_type
                (object_type_code, name_en, name_ar, lov_view, lov_key_col, lov_label_col,
                 key_is_numeric, hierarchy_kind, display_order, created_by,
                 use_in_security, use_in_wf)
            VALUES (p_code, p_en, p_ar, p_view, p_key, p_label,
                 p_num, p_hier, p_ord, 'SEED', 'Y', 'N');
        END IF;
    END;
BEGIN
    ins_ot('BUSINESS_UNIT', 'Business Unit',
        UNISTR('\0648\062d\062f\0629\0020\0627\0644\0623\0639\0645\0627\0644'),
        'V_DCT_WF_OBJ_BUSINESS_UNIT', 'BU_NAME', 'BU_NAME', 'N', 'NONE', 110);
    ins_ot('DCT_PROGRAM', 'DCT Program',
        UNISTR('\0628\0631\0646\0627\0645\062c\0020\062f\0627\0626\0631\0629\0020\0627\0644\062b\0642\0627\0641\0629\0020\0648\0627\0644\0633\064a\0627\062d\0629'),
        'V_DCT_WF_OBJ_DCT_PROGRAM', 'VALUE_CODE', 'NAME_EN', 'N', 'CLASS', 120);
    ins_ot('CHAPTER', 'Chapter',
        UNISTR('\0627\0644\0628\0627\0628'),
        'V_DCT_WF_OBJ_CHAPTER', 'VALUE_CODE', 'NAME_EN', 'N', 'NONE', 130);

    UPDATE prod.dct_wf_object_type
       SET use_in_security = 'Y'
     WHERE object_type_code IN ('SECTOR','DEPARTMENT','COST_CENTER','PROJECT',
                                'TASK','APPROPRIATION','GL_ACCOUNT',
                                'BUSINESS_UNIT','DCT_PROGRAM','CHAPTER');
    COMMIT;
END;
/

PROMPT --- abstract role seeds ---

DECLARE
    PROCEDURE ins_abs (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_ord NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_roles WHERE role_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_roles
                (role_code, role_name_en, role_name_ar, role_type, role_category,
                 is_system_role, is_active, display_order, created_by,
                 description_en)
            VALUES (p_code, p_en, p_ar, 'SYSTEM', 'ABSTRACT',
                 'Y', 'Y', p_ord, 'SEED',
                 'Abstract role: relationship of the user to the system.');
        ELSE
            UPDATE prod.dct_roles SET role_category = 'ABSTRACT'
             WHERE role_code = p_code AND role_category <> 'ABSTRACT';
        END IF;
    END;
BEGIN
    ins_abs('EMPLOYEE',   'Employee',   UNISTR('\0645\0648\0638\0641'), 910);
    ins_abs('MANAGER',    'Manager',    UNISTR('\0645\062f\064a\0631'), 920);
    ins_abs('SUPPLIER',   'Supplier',   UNISTR('\0645\0648\0631\062f'), 930);
    ins_abs('FREELANCER', 'Freelancer', UNISTR('\0645\0633\062a\0642\0644'), 940);
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
