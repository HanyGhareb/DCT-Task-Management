SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

-- =============================================================================
-- 25_fl_contract_phase2_ddl.sql
-- Freelancers Module (App 203) -- Contract Phase 2 -- structures
-- Schema  : PROD (run as ADMIN with schema-qualified names)
-- Purpose : Termsheet columns on dct_fl_contracts (Legal Affairs form parity),
--           scoped approver assignment map, per-instance per-step approvers.
--           Idempotent -- guards use all_tab_columns / all_tables owner=PROD.
-- Plan    : final apps/FL/FL_CONTRACT_PHASE2_PLAN.md (approved 2026-07-14)
-- =============================================================================

PROMPT === [1/4] dct_fl_contracts -- termsheet columns ===

DECLARE
    PROCEDURE add_col(p_name IN VARCHAR2, p_spec IN VARCHAR2) IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n FROM all_tab_columns
        WHERE  owner = 'PROD' AND table_name = 'DCT_FL_CONTRACTS'
        AND    column_name = p_name;
        IF v_n = 0 THEN
            EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_fl_contracts ADD (' || p_spec || ')';
            DBMS_OUTPUT.PUT_LINE('  added ' || p_name);
        ELSE
            DBMS_OUTPUT.PUT_LINE('  exists ' || p_name);
        END IF;
    END;
BEGIN
    add_col('CONTRACT_TYPE',            'contract_type VARCHAR2(30)');
    add_col('INITIATIVE',               'initiative VARCHAR2(400)');
    add_col('CONTRACT_MANAGER_USER_ID', 'contract_manager_user_id NUMBER');
    add_col('DESCRIPTION',              'description VARCHAR2(2000)');
    add_col('PAYMENT_TERMS',            'payment_terms VARCHAR2(1000)');
    add_col('ADVANCE_PAYMENT',          'advance_payment VARCHAR2(400)');
    add_col('RETENTION_TERMS',          'retention_terms VARCHAR2(400)');
    add_col('PERFORMANCE_BOND',         'performance_bond VARCHAR2(400)');
    add_col('PARENT_CO_GUARANTEE',      'parent_co_guarantee VARCHAR2(400)');
    add_col('INSURANCE_DETAILS',        'insurance_details VARCHAR2(1000)');
    add_col('PROCUREMENT_INVOLVED',     'procurement_involved VARCHAR2(1)');
    add_col('PROCUREMENT_WHY',          'procurement_why VARCHAR2(1000)');
    add_col('FTE_CONVERSION',           'fte_conversion VARCHAR2(30)');
    add_col('SERVICES_SUMMARY',         'services_summary VARCHAR2(2000)');
    add_col('TERMSHEET_REF',            'termsheet_ref VARCHAR2(50)');
    add_col('LINE_MANAGER_EMAIL',       'line_manager_email VARCHAR2(200)');
    add_col('LINE_MANAGER_NAME',        'line_manager_name VARCHAR2(200)');
    add_col('LINE_MANAGER_USER_ID',     'line_manager_user_id NUMBER');
    add_col('MEMO_FROM_USER_ID',        'memo_from_user_id NUMBER');
    add_col('MEMO_TO_USER_ID',          'memo_to_user_id NUMBER');
END;
/

PROMPT === [2/4] dct_fl_contracts -- foreign keys ===

DECLARE
    PROCEDURE add_con(p_name IN VARCHAR2, p_ddl IN VARCHAR2) IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n FROM all_constraints
        WHERE  owner = 'PROD' AND constraint_name = p_name;
        IF v_n = 0 THEN
            EXECUTE IMMEDIATE p_ddl;
            DBMS_OUTPUT.PUT_LINE('  added ' || p_name);
        ELSE
            DBMS_OUTPUT.PUT_LINE('  exists ' || p_name);
        END IF;
    END;
BEGIN
    add_con('FK_DCT_FL_CON_CMGR',
        'ALTER TABLE prod.dct_fl_contracts ADD CONSTRAINT fk_dct_fl_con_cmgr '
        || 'FOREIGN KEY (contract_manager_user_id) REFERENCES prod.dct_users(user_id)');
    add_con('FK_DCT_FL_CON_LM',
        'ALTER TABLE prod.dct_fl_contracts ADD CONSTRAINT fk_dct_fl_con_lm '
        || 'FOREIGN KEY (line_manager_user_id) REFERENCES prod.dct_users(user_id)');
    add_con('FK_DCT_FL_CON_MEMOFROM',
        'ALTER TABLE prod.dct_fl_contracts ADD CONSTRAINT fk_dct_fl_con_memofrom '
        || 'FOREIGN KEY (memo_from_user_id) REFERENCES prod.dct_users(user_id)');
    add_con('FK_DCT_FL_CON_MEMOTO',
        'ALTER TABLE prod.dct_fl_contracts ADD CONSTRAINT fk_dct_fl_con_memoto '
        || 'FOREIGN KEY (memo_to_user_id) REFERENCES prod.dct_users(user_id)');
END;
/

PROMPT === [3/4] dct_fl_approver_map -- scoped approver assignments ===

DECLARE
    v_n NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_n FROM all_tables
    WHERE owner = 'PROD' AND table_name = 'DCT_FL_APPROVER_MAP';
    IF v_n = 0 THEN
        EXECUTE IMMEDIATE q'[
CREATE TABLE prod.dct_fl_approver_map (
    map_id       NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    role_code    VARCHAR2(100) NOT NULL,
    org_id       NUMBER        NOT NULL,
    user_id      NUMBER        NOT NULL,
    is_active    VARCHAR2(1)   DEFAULT 'Y' NOT NULL,
    notes        VARCHAR2(400),
    created_by   VARCHAR2(100),
    created_at   TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by   VARCHAR2(100),
    updated_at   TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT uq_dct_fl_apmap       UNIQUE (role_code, org_id),
    CONSTRAINT chk_dct_fl_apmap_act  CHECK  (is_active IN ('Y','N')),
    CONSTRAINT fk_dct_fl_apmap_role  FOREIGN KEY (role_code) REFERENCES prod.dct_roles(role_code),
    CONSTRAINT fk_dct_fl_apmap_org   FOREIGN KEY (org_id)    REFERENCES prod.dct_organizations(org_id),
    CONSTRAINT fk_dct_fl_apmap_user  FOREIGN KEY (user_id)   REFERENCES prod.dct_users(user_id)
)]';
        EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_fl_apmap_org ON prod.dct_fl_approver_map(org_id, is_active)';
        EXECUTE IMMEDIATE q'[COMMENT ON TABLE prod.dct_fl_approver_map IS
'FL scoped approver assignments -- who endorses per role per org unit. Resolution walks the contract org up its parents; nearest mapped active row wins; fallback = any role holder']';
        DBMS_OUTPUT.PUT_LINE('  created DCT_FL_APPROVER_MAP');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  exists DCT_FL_APPROVER_MAP');
    END IF;
END;
/

PROMPT === [4/4] dct_fl_instance_approvers -- per-instance per-step resolved approvers ===

DECLARE
    v_n NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_n FROM all_tables
    WHERE owner = 'PROD' AND table_name = 'DCT_FL_INSTANCE_APPROVERS';
    IF v_n = 0 THEN
        EXECUTE IMMEDIATE q'[
CREATE TABLE prod.dct_fl_instance_approvers (
    inst_appr_id NUMBER    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    instance_id  NUMBER    NOT NULL,
    step_seq     NUMBER    NOT NULL,
    user_id      NUMBER    NOT NULL,
    created_at   TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT uq_dct_fl_instappr      UNIQUE (instance_id, step_seq),
    CONSTRAINT fk_dct_fl_instappr_inst FOREIGN KEY (instance_id) REFERENCES prod.dct_approval_instances(instance_id),
    CONSTRAINT fk_dct_fl_instappr_usr  FOREIGN KEY (user_id)     REFERENCES prod.dct_users(user_id)
)]';
        EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_fl_instappr_usr ON prod.dct_fl_instance_approvers(user_id)';
        EXECUTE IMMEDIATE q'[COMMENT ON TABLE prod.dct_fl_instance_approvers IS
'Resolved named approver per USER_SPECIFIC step of an FL approval instance (line manager, scoped Finance Business Partner). Written at submit by DCT_FL_PKG']';
        DBMS_OUTPUT.PUT_LINE('  created DCT_FL_INSTANCE_APPROVERS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  exists DCT_FL_INSTANCE_APPROVERS');
    END IF;
END;
/

PROMPT === 25_fl_contract_phase2_ddl.sql complete ===
