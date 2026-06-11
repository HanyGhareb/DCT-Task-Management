-- =============================================================================
-- 16_dct_missing_fks.sql
-- Phase 2.4 (assessment-3/phase2/00-phase2-plan.md) — referential integrity to
-- the natural-key masters + full lookup-first migration for PC / DT / FL.
--
--   (A) FKs from every project_number / task_number / expenditure_type column
--       to DCT_PROJECTS / DCT_TASKS / DCT_EXPENDITURE_TYPES — added ENABLE
--       NOVALIDATE, orphans reported, then VALIDATEd when clean.
--       (DT_REQUESTS inline columns deferred until DT adopts — plan §2.4.1.)
--   (B) DCT_FL_BANK_ACCOUNTS.bank_code + FK to DCT_BANK_CODES.
--   (C) Lookup categories for every remaining status/type enum (PC, DT, FL —
--       CC was seeded by 08_cc_unified_adoption.sql). Values match the live
--       CHECK constraints exactly.
--   (D) CHECK-drop policy: FL tables are EMPTY and adopted this phase → their
--       status/type CHECKs drop now. PC and DT hold live data → their CHECKs
--       stay as safety nets until those modules adopt; their UIs can switch to
--       lookup-driven LOVs immediately. Y/N boolean CHECKs always stay.
--
-- Run as ADMIN via SQLcl. All objects fully prefixed with PROD.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON

PROMPT === [A1] Add natural-key FKs (ENABLE NOVALIDATE) ===

DECLARE
    PROCEDURE add_fk (p_name VARCHAR2, p_sql VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE p_sql;
        DBMS_OUTPUT.PUT_LINE('Added ' || p_name);
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE != -2275 THEN RAISE; END IF;   -- already exists
    END;
BEGIN
    -- PC advance lines
    add_fk('fk_pcbl_project', 'ALTER TABLE prod.dct_pc_budget_lines ADD CONSTRAINT fk_pcbl_project FOREIGN KEY (project_number) REFERENCES prod.dct_projects(project_number) ENABLE NOVALIDATE');
    add_fk('fk_pcbl_task',    'ALTER TABLE prod.dct_pc_budget_lines ADD CONSTRAINT fk_pcbl_task FOREIGN KEY (project_number, task_number) REFERENCES prod.dct_tasks(project_number, task_number) ENABLE NOVALIDATE');
    add_fk('fk_pcbl_exptype', 'ALTER TABLE prod.dct_pc_budget_lines ADD CONSTRAINT fk_pcbl_exptype FOREIGN KEY (expenditure_type) REFERENCES prod.dct_expenditure_types(expenditure_type) ENABLE NOVALIDATE');
    -- PC reimbursement lines
    add_fk('fk_pcrbl_project', 'ALTER TABLE prod.dct_pc_reimb_budget_lines ADD CONSTRAINT fk_pcrbl_project FOREIGN KEY (project_number) REFERENCES prod.dct_projects(project_number) ENABLE NOVALIDATE');
    add_fk('fk_pcrbl_task',    'ALTER TABLE prod.dct_pc_reimb_budget_lines ADD CONSTRAINT fk_pcrbl_task FOREIGN KEY (project_number, task_number) REFERENCES prod.dct_tasks(project_number, task_number) ENABLE NOVALIDATE');
    add_fk('fk_pcrbl_exptype', 'ALTER TABLE prod.dct_pc_reimb_budget_lines ADD CONSTRAINT fk_pcrbl_exptype FOREIGN KEY (expenditure_type) REFERENCES prod.dct_expenditure_types(expenditure_type) ENABLE NOVALIDATE');
    -- PC clearing lines
    add_fk('fk_pccbl_project', 'ALTER TABLE prod.dct_pc_clear_budget_lines ADD CONSTRAINT fk_pccbl_project FOREIGN KEY (project_number) REFERENCES prod.dct_projects(project_number) ENABLE NOVALIDATE');
    add_fk('fk_pccbl_task',    'ALTER TABLE prod.dct_pc_clear_budget_lines ADD CONSTRAINT fk_pccbl_task FOREIGN KEY (project_number, task_number) REFERENCES prod.dct_tasks(project_number, task_number) ENABLE NOVALIDATE');
    add_fk('fk_pccbl_exptype', 'ALTER TABLE prod.dct_pc_clear_budget_lines ADD CONSTRAINT fk_pccbl_exptype FOREIGN KEY (expenditure_type) REFERENCES prod.dct_expenditure_types(expenditure_type) ENABLE NOVALIDATE');
    -- FL contracts
    add_fk('fk_flcon_project', 'ALTER TABLE prod.dct_fl_contracts ADD CONSTRAINT fk_flcon_project FOREIGN KEY (project_number) REFERENCES prod.dct_projects(project_number) ENABLE NOVALIDATE');
    add_fk('fk_flcon_task',    'ALTER TABLE prod.dct_fl_contracts ADD CONSTRAINT fk_flcon_task FOREIGN KEY (project_number, task_number) REFERENCES prod.dct_tasks(project_number, task_number) ENABLE NOVALIDATE');
    add_fk('fk_flcon_exptype', 'ALTER TABLE prod.dct_fl_contracts ADD CONSTRAINT fk_flcon_exptype FOREIGN KEY (expenditure_type) REFERENCES prod.dct_expenditure_types(expenditure_type) ENABLE NOVALIDATE');
    -- FL contract renewals
    add_fk('fk_flrnl_project', 'ALTER TABLE prod.dct_fl_contract_renewals ADD CONSTRAINT fk_flrnl_project FOREIGN KEY (project_number) REFERENCES prod.dct_projects(project_number) ENABLE NOVALIDATE');
    add_fk('fk_flrnl_task',    'ALTER TABLE prod.dct_fl_contract_renewals ADD CONSTRAINT fk_flrnl_task FOREIGN KEY (project_number, task_number) REFERENCES prod.dct_tasks(project_number, task_number) ENABLE NOVALIDATE');
    add_fk('fk_flrnl_exptype', 'ALTER TABLE prod.dct_fl_contract_renewals ADD CONSTRAINT fk_flrnl_exptype FOREIGN KEY (expenditure_type) REFERENCES prod.dct_expenditure_types(expenditure_type) ENABLE NOVALIDATE');
    -- FL payment vouchers
    add_fk('fk_flvch_project', 'ALTER TABLE prod.dct_fl_payment_vouchers ADD CONSTRAINT fk_flvch_project FOREIGN KEY (project_number) REFERENCES prod.dct_projects(project_number) ENABLE NOVALIDATE');
    add_fk('fk_flvch_task',    'ALTER TABLE prod.dct_fl_payment_vouchers ADD CONSTRAINT fk_flvch_task FOREIGN KEY (project_number, task_number) REFERENCES prod.dct_tasks(project_number, task_number) ENABLE NOVALIDATE');
    add_fk('fk_flvch_exptype', 'ALTER TABLE prod.dct_fl_payment_vouchers ADD CONSTRAINT fk_flvch_exptype FOREIGN KEY (expenditure_type) REFERENCES prod.dct_expenditure_types(expenditure_type) ENABLE NOVALIDATE');
    -- CC replenishment header default coding
    add_fk('fk_ccrpl_project', 'ALTER TABLE prod.dct_cc_replenishments ADD CONSTRAINT fk_ccrpl_project FOREIGN KEY (project_number) REFERENCES prod.dct_projects(project_number) ENABLE NOVALIDATE');
    add_fk('fk_ccrpl_task',    'ALTER TABLE prod.dct_cc_replenishments ADD CONSTRAINT fk_ccrpl_task FOREIGN KEY (project_number, task_number) REFERENCES prod.dct_tasks(project_number, task_number) ENABLE NOVALIDATE');
    add_fk('fk_ccrpl_exptype', 'ALTER TABLE prod.dct_cc_replenishments ADD CONSTRAINT fk_ccrpl_exptype FOREIGN KEY (expenditure_type) REFERENCES prod.dct_expenditure_types(expenditure_type) ENABLE NOVALIDATE');
END;
/

PROMPT === [B] DCT_FL_BANK_ACCOUNTS.bank_code + FK to DCT_BANK_CODES ===

DECLARE
    e_col_exists EXCEPTION; PRAGMA EXCEPTION_INIT(e_col_exists, -1430);
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_fl_bank_accounts ADD (bank_code VARCHAR2(20))';
    DBMS_OUTPUT.PUT_LINE('Added column dct_fl_bank_accounts.bank_code');
EXCEPTION WHEN e_col_exists THEN NULL;
END;
/
DECLARE
    e_fk_exists EXCEPTION; PRAGMA EXCEPTION_INIT(e_fk_exists, -2275);
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_fl_bank_accounts ADD CONSTRAINT fk_flba_bank FOREIGN KEY (bank_code) REFERENCES prod.dct_bank_codes(bank_code) ENABLE NOVALIDATE';
    DBMS_OUTPUT.PUT_LINE('Added fk_flba_bank');
EXCEPTION WHEN e_fk_exists THEN NULL;
END;
/
COMMENT ON COLUMN prod.dct_fl_bank_accounts.bank_code IS
  'FK to DCT_BANK_CODES — replaces free-text bank_name as the authoritative bank reference';

PROMPT === [A2] Orphan report (expected: all zero) then VALIDATE ===

DECLARE
    v_total_orphans NUMBER := 0;

    PROCEDURE orphan_check (p_table VARCHAR2, p_predicate VARCHAR2, p_label VARCHAR2) IS
        v_n NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM prod.' || p_table || ' t WHERE ' || p_predicate INTO v_n;
        IF v_n > 0 THEN
            v_total_orphans := v_total_orphans + v_n;
            DBMS_OUTPUT.PUT_LINE('ORPHANS: ' || p_label || ' = ' || v_n);
        END IF;
    END;

    PROCEDURE validate_fk (p_table VARCHAR2, p_constraint VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE prod.' || p_table || ' MODIFY CONSTRAINT ' || p_constraint || ' VALIDATE';
        DBMS_OUTPUT.PUT_LINE('Validated ' || p_constraint);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('COULD NOT VALIDATE ' || p_constraint || ': ' || SQLERRM);
    END;
BEGIN
    FOR t IN (
        SELECT 'DCT_PC_BUDGET_LINES' tn FROM dual UNION ALL
        SELECT 'DCT_PC_REIMB_BUDGET_LINES' FROM dual UNION ALL
        SELECT 'DCT_PC_CLEAR_BUDGET_LINES' FROM dual UNION ALL
        SELECT 'DCT_FL_CONTRACTS' FROM dual UNION ALL
        SELECT 'DCT_FL_CONTRACT_RENEWALS' FROM dual UNION ALL
        SELECT 'DCT_FL_PAYMENT_VOUCHERS' FROM dual UNION ALL
        SELECT 'DCT_CC_REPLENISHMENTS' FROM dual
    ) LOOP
        orphan_check(t.tn,
            't.project_number IS NOT NULL AND NOT EXISTS (SELECT 1 FROM prod.dct_projects p WHERE p.project_number = t.project_number)',
            t.tn || '.project_number');
        orphan_check(t.tn,
            't.project_number IS NOT NULL AND t.task_number IS NOT NULL AND NOT EXISTS (SELECT 1 FROM prod.dct_tasks k WHERE k.project_number = t.project_number AND k.task_number = t.task_number)',
            t.tn || '.task_number');
        orphan_check(t.tn,
            't.expenditure_type IS NOT NULL AND NOT EXISTS (SELECT 1 FROM prod.dct_expenditure_types e WHERE e.expenditure_type = t.expenditure_type)',
            t.tn || '.expenditure_type');
    END LOOP;

    IF v_total_orphans = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Orphan report CLEAN — validating all natural-key FKs');
        validate_fk('dct_pc_budget_lines',       'fk_pcbl_project');
        validate_fk('dct_pc_budget_lines',       'fk_pcbl_task');
        validate_fk('dct_pc_budget_lines',       'fk_pcbl_exptype');
        validate_fk('dct_pc_reimb_budget_lines', 'fk_pcrbl_project');
        validate_fk('dct_pc_reimb_budget_lines', 'fk_pcrbl_task');
        validate_fk('dct_pc_reimb_budget_lines', 'fk_pcrbl_exptype');
        validate_fk('dct_pc_clear_budget_lines', 'fk_pccbl_project');
        validate_fk('dct_pc_clear_budget_lines', 'fk_pccbl_task');
        validate_fk('dct_pc_clear_budget_lines', 'fk_pccbl_exptype');
        validate_fk('dct_fl_contracts',          'fk_flcon_project');
        validate_fk('dct_fl_contracts',          'fk_flcon_task');
        validate_fk('dct_fl_contracts',          'fk_flcon_exptype');
        validate_fk('dct_fl_contract_renewals',  'fk_flrnl_project');
        validate_fk('dct_fl_contract_renewals',  'fk_flrnl_task');
        validate_fk('dct_fl_contract_renewals',  'fk_flrnl_exptype');
        validate_fk('dct_fl_payment_vouchers',   'fk_flvch_project');
        validate_fk('dct_fl_payment_vouchers',   'fk_flvch_task');
        validate_fk('dct_fl_payment_vouchers',   'fk_flvch_exptype');
        validate_fk('dct_cc_replenishments',     'fk_ccrpl_project');
        validate_fk('dct_cc_replenishments',     'fk_ccrpl_task');
        validate_fk('dct_cc_replenishments',     'fk_ccrpl_exptype');
        validate_fk('dct_fl_bank_accounts',      'fk_flba_bank');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ORPHANS FOUND (' || v_total_orphans || ') — FKs stay NOVALIDATE; clean data then re-run.');
    END IF;
END;
/

PROMPT === [C] Lookup categories for all remaining PC / DT / FL status families ===

DECLARE
    v_pc  NUMBER;
    v_dt  NUMBER;
    v_fl  NUMBER;
    v_cat NUMBER;

    PROCEDURE upsert_category (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                               p_module_id NUMBER, o_id OUT NUMBER) IS
    BEGIN
        MERGE INTO prod.dct_lookup_categories t
        USING (SELECT p_code AS category_code FROM dual) s
        ON (t.category_code = s.category_code)
        WHEN NOT MATCHED THEN
            INSERT (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
            VALUES (p_code, p_en, p_ar, p_module_id, 'Y', 'Y')
        WHEN MATCHED THEN
            UPDATE SET t.category_name_en = p_en, t.category_name_ar = p_ar;
        SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
    END;

    PROCEDURE v (p_code VARCHAR2, p_en VARCHAR2, p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N') IS
    BEGIN
        MERGE INTO prod.dct_lookup_values t
        USING (SELECT v_cat AS category_id, p_code AS value_code FROM dual) s
        ON (t.category_id = s.category_id AND t.value_code = s.value_code)
        WHEN NOT MATCHED THEN
            INSERT (category_id, value_code, value_name_en, display_order, is_default, is_active)
            VALUES (v_cat, p_code, p_en, p_ord, p_default, 'Y')
        WHEN MATCHED THEN
            UPDATE SET t.value_name_en = p_en, t.display_order = p_ord;
    END;
BEGIN
    SELECT module_id INTO v_pc FROM prod.dct_modules WHERE module_code = 'PETTY_CASH';
    SELECT module_id INTO v_dt FROM prod.dct_modules WHERE module_code = 'DUTY_TRAVEL';
    SELECT module_id INTO v_fl FROM prod.dct_modules WHERE module_code = 'FREELANCERS';

    -- ----- Petty Cash -----
    upsert_category('PC_TYPE', 'Petty Cash Type', 'نوع السلفة', v_pc, v_cat);
    v('TEMPORARY', 'Temporary', 10, 'Y'); v('PERMANENT', 'Permanent', 20);

    upsert_category('PC_STATUS', 'Petty Cash Status', 'حالة السلفة', v_pc, v_cat);
    v('DRAFT','Draft',10,'Y'); v('SUBMITTED','Submitted',20); v('PENDING_APPROVAL','Pending Approval',30);
    v('ACTIVE','Active',40); v('CLOSED','Closed',50); v('REJECTED','Rejected',60); v('CANCELLED','Cancelled',70);

    upsert_category('PC_REIMB_STATUS', 'Reimbursement Status', 'حالة الاسترداد', v_pc, v_cat);
    v('DRAFT','Draft',10,'Y'); v('SUBMITTED','Submitted',20); v('PENDING_APPROVAL','Pending Approval',30);
    v('APPROVED','Approved',40); v('REJECTED','Rejected',50); v('CANCELLED','Cancelled',60);

    upsert_category('PC_CLEARING_STATUS', 'Clearing Status', 'حالة التسوية', v_pc, v_cat);
    v('DRAFT','Draft',10,'Y'); v('SUBMITTED','Submitted',20); v('PENDING_APPROVAL','Pending Approval',30);
    v('APPROVED','Approved',40); v('REJECTED','Rejected',50); v('CANCELLED','Cancelled',60);

    upsert_category('PC_ATTACH_REQUEST_TYPE', 'PC Attachment Request Type', 'نوع مرفق السلفة', v_pc, v_cat);
    v('PC','Petty Cash Advance',10); v('REIMB','Reimbursement',20); v('CLEAR','Clearing',30);

    upsert_category('PC_VALIDATION_STATUS', 'AI Line Validation Status', 'حالة التحقق من السطر', v_pc, v_cat);
    v('PENDING','Pending',10,'Y'); v('VALID','Valid',20); v('INVALID','Invalid',30); v('NEEDS_REVIEW','Needs Review',40);

    -- ----- Duty Travel -----
    upsert_category('DT_MISSION_TYPE', 'Duty Travel Mission Type', 'نوع المهمة', v_dt, v_cat);
    v('BUSINESS_MISSION','Business Mission',10,'Y'); v('TRAINING','Training',20);

    upsert_category('DT_TRIP_TYPE', 'Duty Travel Trip Type', 'نوع الرحلة', v_dt, v_cat);
    v('INTERNAL','Internal',10); v('EXTERNAL','External',20);

    upsert_category('DT_REQUEST_STATUS', 'Travel Request Status', 'حالة طلب السفر', v_dt, v_cat);
    v('DRAFT','Draft',10,'Y'); v('SUBMITTED','Submitted',20); v('APPROVED','Approved',30);
    v('ADVANCE_PAID','Advance Paid',40); v('TRAVELLED','Travelled',50); v('CLOSED','Closed',60);
    v('REJECTED','Rejected',70); v('RETURNED','Returned',80); v('CANCELLED','Cancelled',90);

    upsert_category('DT_SETTLEMENT_STATUS', 'Settlement Status', 'حالة تسوية السفر', v_dt, v_cat);
    v('DRAFT','Draft',10,'Y'); v('SUBMITTED','Submitted',20); v('APPROVED','Approved',30);
    v('REJECTED','Rejected',40); v('RETURNED','Returned',50);

    upsert_category('DT_EXPENSE_CATEGORY', 'Settlement Expense Category', 'فئة مصروف التسوية', v_dt, v_cat);
    v('PER_DIEM','Per Diem',10); v('ACCOMMODATION','Accommodation',20); v('TICKET','Ticket',30);
    v('VISA','Visa',40); v('LOCAL_TRANSPORT','Local Transport',50); v('OTHER','Other',90);

    -- ----- Freelancers -----
    upsert_category('FL_REGISTRATION_STATUS', 'Registration Status', 'حالة التسجيل', v_fl, v_cat);
    v('DRAFT','Draft',10,'Y'); v('SUBMITTED','Submitted',20); v('APPROVED','Approved',30);
    v('REJECTED','Rejected',40); v('RETURNED','Returned',50);

    upsert_category('FL_FREELANCER_STATUS', 'Freelancer Status', 'حالة المتعاقد', v_fl, v_cat);
    v('ACTIVE','Active',10,'Y'); v('INACTIVE','Inactive',20); v('BLACKLISTED','Blacklisted',30);

    upsert_category('FL_CONTRACT_STATUS', 'Contract Status', 'حالة العقد', v_fl, v_cat);
    v('DRAFT','Draft',10,'Y'); v('SUBMITTED','Submitted',20); v('APPROVED','Approved',30);
    v('ACTIVE','Active',40); v('COMPLETED','Completed',50); v('CANCELLED','Cancelled',60);

    upsert_category('FL_AMENDMENT_STATUS', 'Contract Amendment Status', 'حالة تعديل العقد', v_fl, v_cat);
    v('DRAFT','Draft',10,'Y'); v('SUBMITTED','Submitted',20); v('APPROVED','Approved',30);
    v('REJECTED','Rejected',40); v('CANCELLED','Cancelled',50);

    upsert_category('FL_RENEWAL_STATUS', 'Contract Renewal Status', 'حالة تجديد العقد', v_fl, v_cat);
    v('DRAFT','Draft',10,'Y'); v('SUBMITTED','Submitted',20); v('APPROVED','Approved',30);
    v('REJECTED','Rejected',40); v('CANCELLED','Cancelled',50);

    upsert_category('FL_DELIVERABLE_STATUS', 'Deliverable Status', 'حالة المخرج', v_fl, v_cat);
    v('SUBMITTED','Submitted',10,'Y'); v('ACCEPTED','Accepted',20); v('REJECTED','Rejected',30);

    upsert_category('FL_SCHEDULE_STATUS', 'Payment Schedule Status', 'حالة جدول الدفع', v_fl, v_cat);
    v('PENDING','Pending',10,'Y'); v('VOUCHER_GENERATED','Voucher Generated',20);
    v('PAID','Paid',30); v('SKIPPED','Skipped',40);

    upsert_category('FL_VOUCHER_STATUS', 'Payment Voucher Status', 'حالة سند الدفع', v_fl, v_cat);
    v('DRAFT','Draft',10,'Y'); v('SUBMITTED','Submitted',20); v('APPROVED','Approved',30);
    v('REJECTED','Rejected',40); v('CANCELLED','Cancelled',50);

    upsert_category('FL_PAYMENT_STATUS', 'Voucher Payment Status', 'حالة الدفع', v_fl, v_cat);
    v('PENDING','Pending',10,'Y'); v('PAID','Paid',20); v('CANCELLED','Cancelled',30);

    upsert_category('FL_BILLING_METHOD', 'Contract Billing Method', 'طريقة الفوترة', v_fl, v_cat);
    v('WEEKLY','Weekly',10); v('MONTHLY','Monthly',20,'Y'); v('PER_COUNT','Per Count / Deliverable',30);

    upsert_category('FL_SUBMITTED_BY', 'Registration Submitted By', 'مقدم الطلب', v_fl, v_cat);
    v('SELF','Self (External)',10); v('STAFF','DCT Staff',20,'Y');

    upsert_category('FL_CHANGE_TYPE', 'Profile Change Type', 'نوع تغيير الملف', v_fl, v_cat);
    v('BANK_ACCOUNT','Bank Account',10); v('EMAIL','Email',20); v('PHONE','Phone',30); v('OTHER','Other',90);

    upsert_category('FL_PROFILE_CHANGE_STATUS', 'Profile Change Status', 'حالة طلب التغيير', v_fl, v_cat);
    v('DRAFT','Draft',10,'Y'); v('SUBMITTED','Submitted',20); v('APPROVED','Approved',30); v('REJECTED','Rejected',40);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookup categories seeded: 6 PC + 5 DT + 12 FL families');
END;
/

PROMPT === [D] Drop status/type CHECKs on EMPTY FL tables (lookup-first) ===
PROMPT     (PC and DT CHECKs stay as safety nets until those modules adopt)

DECLARE
    PROCEDURE drop_check (p_table VARCHAR2, p_constraint VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE prod.' || p_table || ' DROP CONSTRAINT ' || p_constraint;
        DBMS_OUTPUT.PUT_LINE('Dropped ' || p_table || '.' || p_constraint);
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE NOT IN (-2443, -942) THEN RAISE; END IF;
    END;
BEGIN
    drop_check('dct_fl_registrations',           'chk_dct_fl_reg_status');
    drop_check('dct_fl_registrations',           'chk_dct_fl_reg_subby');
    drop_check('dct_fl_freelancers',             'chk_dct_fl_frl_status');
    drop_check('dct_fl_contracts',               'chk_dct_fl_con_status');
    drop_check('dct_fl_contracts',               'chk_dct_fl_con_bill');
    drop_check('dct_fl_contracts',               'chk_dct_fl_con_coding');
    drop_check('dct_fl_contract_amendments',     'chk_dct_fl_amend_stat');
    drop_check('dct_fl_contract_renewals',       'chk_dct_fl_rnl_stat');
    drop_check('dct_fl_contract_renewals',       'chk_dct_fl_rnl_bill');
    drop_check('dct_fl_contract_renewals',       'chk_dct_fl_rnl_coding');
    drop_check('dct_fl_deliverables',            'chk_dct_fl_deliv_stat');
    drop_check('dct_fl_payment_schedule',        'chk_dct_fl_sched_stat');
    drop_check('dct_fl_payment_vouchers',        'chk_dct_fl_vchr_status');
    drop_check('dct_fl_payment_vouchers',        'chk_dct_fl_vchr_pstat');
    drop_check('dct_fl_payment_vouchers',        'chk_dct_fl_vchr_coding');
    drop_check('dct_fl_profile_change_requests', 'chk_dct_fl_pcr_status');
    drop_check('dct_fl_profile_change_requests', 'chk_dct_fl_pcr_type');
END;
/

PROMPT
PROMPT === 16_dct_missing_fks.sql complete ===
PROMPT (A) 21 natural-key FKs + (B) fl bank_code FK — NOVALIDATE then VALIDATEd when orphan report clean
PROMPT (C) 23 lookup categories seeded (PC 6, DT 5, FL 12)
PROMPT (D) FL status/type CHECKs dropped (empty tables); PC/DT CHECKs retained as safety nets
