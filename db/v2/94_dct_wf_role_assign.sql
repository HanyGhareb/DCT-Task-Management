SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON
-- db/v2/94_dct_wf_role_assign.sql
-- DWP Dynamic Role Assignments layer, part 1 of 3: DDL plus seeds.
-- Date-tracked assignment of users to workflow roles against business objects
-- (Sector, Department, HR Org, Cost Center, Project, Task, Appropriation, PO,
-- GL Account, Entity -- extensible via the registry, no engine change).
-- Also alters DCT_WF_PARTICIPANT_RULE for the new ASSIGNED_ROLE resolver.
-- Idempotent. Deploy BEFORE re-running 63. Companion scripts: 95 pkg, 96 API.

PROMPT --- tables ---

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
    mk(q'[CREATE TABLE prod.dct_wf_object_type (
        object_type_code VARCHAR2(30)  PRIMARY KEY,
        name_en          VARCHAR2(200) NOT NULL,
        name_ar          VARCHAR2(200),
        lov_view         VARCHAR2(128) NOT NULL,
        lov_key_col      VARCHAR2(60)  NOT NULL,
        lov_label_col    VARCHAR2(60)  NOT NULL,
        lov_key2_col     VARCHAR2(60),
        lov_parent_col   VARCHAR2(60),
        key2_label_en    VARCHAR2(100),
        key2_label_ar    VARCHAR2(100),
        key_is_numeric   VARCHAR2(1) DEFAULT 'N' NOT NULL,
        hierarchy_kind   VARCHAR2(10) DEFAULT 'NONE' NOT NULL,
        validate_key     VARCHAR2(1) DEFAULT 'Y' NOT NULL,
        is_active        VARCHAR2(1) DEFAULT 'Y' NOT NULL,
        display_order    NUMBER DEFAULT 10,
        created_by       VARCHAR2(100),
        created_at       TIMESTAMP DEFAULT SYSTIMESTAMP,
        CONSTRAINT chk_wf_ot_hk  CHECK (hierarchy_kind IN ('NONE','ORG')),
        CONSTRAINT chk_wf_ot_act CHECK (is_active IN ('Y','N')),
        CONSTRAINT chk_wf_ot_num CHECK (key_is_numeric IN ('Y','N')),
        CONSTRAINT chk_wf_ot_val CHECK (validate_key IN ('Y','N'))
    )]');

    mk(q'[CREATE TABLE prod.dct_wf_role_assignment (
        assignment_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        object_type_code VARCHAR2(30)  NOT NULL REFERENCES prod.dct_wf_object_type(object_type_code),
        object_key       VARCHAR2(100) NOT NULL,
        object_key2      VARCHAR2(100),
        object_label     VARCHAR2(300),
        role_code        VARCHAR2(100) NOT NULL,
        user_id          NUMBER NOT NULL REFERENCES prod.dct_users(user_id),
        start_date       DATE DEFAULT TRUNC(SYSDATE) NOT NULL,
        end_date         DATE,
        is_active        VARCHAR2(1) DEFAULT 'Y' NOT NULL,
        notes            VARCHAR2(500),
        replaced_by_id   NUMBER REFERENCES prod.dct_wf_role_assignment(assignment_id),
        created_by       VARCHAR2(100) NOT NULL,
        created_at       TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
        ended_by         VARCHAR2(100),
        ended_at         TIMESTAMP,
        CONSTRAINT chk_wf_ra_dates CHECK (end_date IS NULL OR end_date >= start_date),
        CONSTRAINT chk_wf_ra_act   CHECK (is_active IN ('Y','N')),
        CONSTRAINT chk_wf_ra_trim  CHECK (object_key = TRIM(object_key))
    )]');

    mk(q'[CREATE TABLE prod.dct_wf_role_policy (
        role_code       VARCHAR2(100) PRIMARY KEY,
        single_assignee VARCHAR2(1) DEFAULT 'N' NOT NULL,
        CONSTRAINT chk_wf_rp_sa CHECK (single_assignee IN ('Y','N'))
    )]');

    mk('CREATE INDEX prod.ix_wf_ra_lookup ON prod.dct_wf_role_assignment (object_type_code, object_key, role_code, start_date)');
    mk('CREATE INDEX prod.ix_wf_ra_user ON prod.dct_wf_role_assignment (user_id)');
    mk(q'[CREATE UNIQUE INDEX prod.uq_wf_ra_dup ON prod.dct_wf_role_assignment (
        CASE WHEN is_active='Y' THEN object_type_code END,
        CASE WHEN is_active='Y' THEN object_key END,
        CASE WHEN is_active='Y' THEN NVL(object_key2,'#') END,
        CASE WHEN is_active='Y' THEN role_code END,
        CASE WHEN is_active='Y' THEN user_id END,
        CASE WHEN is_active='Y' THEN start_date END)]');
END;
/

PROMPT --- identity guard trigger ---

CREATE OR REPLACE TRIGGER prod.trg_wf_ra_immutable
BEFORE UPDATE ON prod.dct_wf_role_assignment
FOR EACH ROW
BEGIN
    IF :NEW.object_type_code <> :OLD.object_type_code
       OR :NEW.object_key <> :OLD.object_key
       OR NVL(:NEW.object_key2,'#') <> NVL(:OLD.object_key2,'#')
       OR :NEW.role_code <> :OLD.role_code
       OR :NEW.user_id <> :OLD.user_id
       OR :NEW.start_date <> :OLD.start_date THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Assignment identity is immutable. End, replace or void it instead.');
    END IF;
END;
/

PROMPT --- LOV views ---

CREATE OR REPLACE VIEW prod.v_dct_wf_obj_sector AS
SELECT value_code, name_en, name_ar
  FROM prod.dct_gl_class_value
 WHERE class_type_code = 'SECTOR' AND is_active = 'Y';

CREATE OR REPLACE VIEW prod.v_dct_wf_obj_department AS
SELECT org_id, org_code, org_name_en, org_name_ar, org_type, parent_org_id
  FROM prod.dct_organizations
 WHERE is_active = 'Y';

CREATE OR REPLACE VIEW prod.v_dct_wf_obj_hr_org AS
SELECT org_id, org_code, org_name_en, org_name_ar, org_type, parent_org_id
  FROM prod.dct_organizations
 WHERE is_active = 'Y';

CREATE OR REPLACE VIEW prod.v_dct_wf_obj_cost_center AS
SELECT DISTINCT cost_center_code, cost_center_desc
  FROM prod.dct_gl_coa_snap
 WHERE cost_center_code IS NOT NULL;

CREATE OR REPLACE VIEW prod.v_dct_wf_obj_gl_account AS
SELECT DISTINCT account_code, account_desc
  FROM prod.dct_gl_coa_snap
 WHERE account_code IS NOT NULL;

CREATE OR REPLACE VIEW prod.v_dct_wf_obj_appropriation AS
SELECT DISTINCT appropriation_code, appropriation_desc
  FROM prod.dct_gl_coa_snap
 WHERE appropriation_code IS NOT NULL;

CREATE OR REPLACE VIEW prod.v_dct_wf_obj_entity AS
SELECT DISTINCT entity_code, entity_desc
  FROM prod.dct_gl_coa_snap
 WHERE entity_code IS NOT NULL;

CREATE OR REPLACE VIEW prod.v_dct_wf_obj_project AS
SELECT project_number, project_name_en, project_name_ar
  FROM prod.dct_projects;

CREATE OR REPLACE VIEW prod.v_dct_wf_obj_task AS
SELECT t.project_number, t.task_number, t.task_name_en, t.task_name_ar
  FROM prod.dct_tasks t;

CREATE OR REPLACE VIEW prod.v_dct_wf_obj_po AS
SELECT po_header_id,
       order_number || ' - ' || supplier_name AS po_label,
       order_number, supplier_name, po_status
  FROM prod.po_header_v;

PROMPT --- seeds ---

DECLARE
    PROCEDURE ins_ot (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                      p_view VARCHAR2, p_key VARCHAR2, p_label VARCHAR2,
                      p_key2 VARCHAR2, p_parent VARCHAR2,
                      p_k2en VARCHAR2, p_k2ar VARCHAR2,
                      p_num VARCHAR2, p_hier VARCHAR2, p_ord NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_wf_object_type WHERE object_type_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_wf_object_type
                (object_type_code, name_en, name_ar, lov_view, lov_key_col, lov_label_col,
                 lov_key2_col, lov_parent_col, key2_label_en, key2_label_ar,
                 key_is_numeric, hierarchy_kind, display_order, created_by)
            VALUES (p_code, p_en, p_ar, p_view, p_key, p_label,
                 p_key2, p_parent, p_k2en, p_k2ar, p_num, p_hier, p_ord, 'SEED');
        END IF;
    END;
    PROCEDURE ins_role (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_single VARCHAR2) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_roles WHERE role_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_roles
                (role_code, role_name_en, role_name_ar, role_type,
                 is_system_role, is_active, created_by)
            VALUES (p_code, p_en, p_ar, 'DATA', 'N', 'Y', 'SEED');
        END IF;
        SELECT COUNT(*) INTO v FROM prod.dct_wf_role_policy WHERE role_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_wf_role_policy (role_code, single_assignee)
            VALUES (p_code, p_single);
        END IF;
    END;
BEGIN
    ins_ot('SECTOR','Sector',UNISTR('\0627\0644\0642\0637\0627\0639'),'V_DCT_WF_OBJ_SECTOR','VALUE_CODE','NAME_EN',NULL,NULL,NULL,NULL,'N','NONE',10);
    ins_ot('DEPARTMENT','Department',UNISTR('\0627\0644\0625\062f\0627\0631\0629'),'V_DCT_WF_OBJ_DEPARTMENT','ORG_ID','ORG_NAME_EN',NULL,NULL,NULL,NULL,'Y','ORG',20);
    ins_ot('HR_ORG','HR Organization',UNISTR('\0627\0644\0648\062d\062f\0629\0020\0627\0644\062a\0646\0638\064a\0645\064a\0629'),'V_DCT_WF_OBJ_HR_ORG','ORG_ID','ORG_NAME_EN',NULL,NULL,NULL,NULL,'Y','ORG',30);
    ins_ot('COST_CENTER','Cost Center',UNISTR('\0645\0631\0643\0632\0020\0627\0644\062a\0643\0644\0641\0629'),'V_DCT_WF_OBJ_COST_CENTER','COST_CENTER_CODE','COST_CENTER_DESC',NULL,NULL,NULL,NULL,'N','NONE',40);
    ins_ot('PROJECT','Project',UNISTR('\0627\0644\0645\0634\0631\0648\0639'),'V_DCT_WF_OBJ_PROJECT','PROJECT_NUMBER','PROJECT_NAME_EN',NULL,NULL,NULL,NULL,'N','NONE',50);
    ins_ot('TASK','Task',UNISTR('\0627\0644\0645\0647\0645\0629'),'V_DCT_WF_OBJ_TASK','PROJECT_NUMBER','TASK_NAME_EN','TASK_NUMBER','PROJECT_NUMBER','Task number',UNISTR('\0631\0642\0645\0020\0627\0644\0645\0647\0645\0629'),'N','NONE',60);
    ins_ot('APPROPRIATION','Appropriation',UNISTR('\0627\0644\0627\0639\062a\0645\0627\062f'),'V_DCT_WF_OBJ_APPROPRIATION','APPROPRIATION_CODE','APPROPRIATION_DESC',NULL,NULL,NULL,NULL,'N','NONE',70);
    ins_ot('PO','Purchase Order',UNISTR('\0623\0645\0631\0020\0627\0644\0634\0631\0627\0621'),'V_DCT_WF_OBJ_PO','PO_HEADER_ID','PO_LABEL',NULL,NULL,NULL,NULL,'Y','NONE',80);
    ins_ot('GL_ACCOUNT','GL Account',UNISTR('\062d\0633\0627\0628\0020\0627\0644\0623\0633\062a\0627\0630\0020\0627\0644\0639\0627\0645'),'V_DCT_WF_OBJ_GL_ACCOUNT','ACCOUNT_CODE','ACCOUNT_DESC',NULL,NULL,NULL,NULL,'N','NONE',90);
    ins_ot('ENTITY','Entity',UNISTR('\0627\0644\0643\064a\0627\0646'),'V_DCT_WF_OBJ_ENTITY','ENTITY_CODE','ENTITY_DESC',NULL,NULL,NULL,NULL,'N','NONE',100);
    ins_role('WF_APPROVER','Approver',UNISTR('\0645\0639\062a\0645\062f'),'N');
    ins_role('WF_FBP','Finance Business Partner',UNISTR('\0634\0631\064a\0643\0020\0627\0644\0623\0639\0645\0627\0644\0020\0627\0644\0645\0627\0644\064a'),'Y');
    ins_role('WF_PBP','Procurement Business Partner',UNISTR('\0634\0631\064a\0643\0020\0623\0639\0645\0627\0644\0020\0627\0644\0645\0634\062a\0631\064a\0627\062a'),'Y');
    ins_role('WF_PLANNER','Planner',UNISTR('\0645\062e\0637\0637'),'Y');
    ins_role('WF_FYI_GROUP','FYI Group',UNISTR('\0645\062c\0645\0648\0639\0629\0020\0644\0644\0639\0644\0645'),'N');
    COMMIT;
END;
/

PROMPT --- participant rule columns plus resolver enum ---

DECLARE
    v NUMBER;
    v_txt VARCHAR2(500);
BEGIN
    SELECT COUNT(*) INTO v FROM all_tab_columns
     WHERE owner = 'PROD' AND table_name = 'DCT_WF_PARTICIPANT_RULE'
       AND column_name = 'OBJECT_TYPE_CODE';
    IF v = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_wf_participant_rule ADD (object_type_code VARCHAR2(30) REFERENCES prod.dct_wf_object_type(object_type_code), key2_fact_path VARCHAR2(200))';
        DBMS_OUTPUT.PUT_LINE('  rule columns added');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  rule columns already present');
    END IF;

    SELECT search_condition_vc INTO v_txt
      FROM all_constraints
     WHERE owner = 'PROD' AND constraint_name = 'CHK_WF_PR_RT';
    IF INSTR(v_txt, 'ASSIGNED_ROLE') = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_wf_participant_rule DROP CONSTRAINT chk_wf_pr_rt';
        EXECUTE IMMEDIATE q'[ALTER TABLE prod.dct_wf_participant_rule ADD CONSTRAINT chk_wf_pr_rt CHECK (resolver_type IN ('ROLE','ROLE_SCOPED_ORG','ORG_HEAD','LINE_MANAGER','FACT_LINE_MANAGER','FACT_USER','STATIC_USER','PREVIOUS_ACTOR','INITIATOR','ASSIGNED_ROLE'))]';
        DBMS_OUTPUT.PUT_LINE('  chk_wf_pr_rt: ASSIGNED_ROLE added');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  chk_wf_pr_rt: already allows ASSIGNED_ROLE');
    END IF;
END;
/

PROMPT --- recompile anything the rule alter invalidated ---

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
