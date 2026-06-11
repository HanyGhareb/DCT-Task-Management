-- =============================================================================
-- 15_dct_unified_structures.sql
-- Phase 2 (assessment-3/phase2/00-phase2-plan.md) — unified shared structures.
--
--   2.1a  Natural-key project-costing masters (user directive 2026-06-11):
--           DCT_PROJECTS          project_number VARCHAR2(12) PK (no project_id)
--           DCT_TASKS             (project_number, task_number VARCHAR2(30)) PK
--                                 — replaces DCT_PROJECT_TASKS
--           DCT_EXPENDITURE_TYPES expenditure_type VARCHAR2(255) PK
--         All three verified EMPTY of business data before drop (the 20
--         expenditure-type seed rows are re-seeded below on the new shape).
--
--   2.1   Unified tables:
--           DCT_DOC_REQUIREMENTS      (replaces dct_cc_doc_requirements; DT later)
--           DCT_DOCUMENTS             (replaces dct_pc_attachments, dct_cc_attachments,
--                                      dct_fl_documents; DT/HR adopt later)
--           DCT_DOC_EXPIRY_ALERTS     (replaces dct_fl_doc_expiry_alerts)
--           DCT_BUDGET_CODING_LINES   (natural-key PROJECT branch + nullable
--                                      expense_date for CC)
--           DCT_REQUEST_STATUS_HISTORY
--
--   Lookup-first rule (user directive): NO status CHECK constraints on new
--   tables. Status families live in DCT_LOOKUP_VALUES, validated at write time
--   via DCT_LOOKUP_PKG.validate_lookup, manageable from Admin lookups.html.
--   Y/N flag CHECKs are kept (booleans, not statuses).
--
--   Run as ADMIN via SQLcl. All objects fully prefixed with PROD. — this script
--   must NOT run after an ALTER SESSION SET CURRENT_SCHEMA=PROD (the trailing
--   ADMIN synonyms would self-reference, ORA-01471).
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON

PROMPT === [1/9] Safety guard + drop superseded masters ===

DECLARE
    v_cnt NUMBER := 0;
    v_n   NUMBER;

    PROCEDURE drop_table (p_name VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE prod.' || p_name || ' CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Dropped table ' || p_name);
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE != -942 THEN RAISE; END IF;
    END;

    FUNCTION row_count (p_name VARCHAR2) RETURN NUMBER IS
        v NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM prod.' || p_name INTO v;
        RETURN v;
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE = -942 THEN RETURN 0; END IF;
        RAISE;
    END;
BEGIN
    -- Guard: the masters being restructured must hold no business data.
    v_cnt := row_count('dct_projects') + row_count('dct_project_tasks');
    IF v_cnt > 0 THEN
        RAISE_APPLICATION_ERROR(-20150,
            'ABORT: dct_projects/dct_project_tasks contain ' || v_cnt ||
            ' row(s) — natural-key restructure assumed empty masters.');
    END IF;

    -- Re-runnable: drop dependents first.
    drop_table('dct_request_status_history');
    drop_table('dct_budget_coding_lines');
    drop_table('dct_doc_expiry_alerts');
    drop_table('dct_documents');
    drop_table('dct_doc_requirements');
    drop_table('dct_tasks');
    drop_table('dct_project_tasks');
    drop_table('dct_projects');
    drop_table('dct_expenditure_types');
END;
/

PROMPT === [2/9] Natural-key masters ===

CREATE TABLE prod.dct_projects (
    project_number      VARCHAR2(12)    NOT NULL,
    project_name_en     VARCHAR2(500)   NOT NULL,
    project_name_ar     VARCHAR2(500),
    project_type        VARCHAR2(30),                  -- lookup PROJECT_TYPE
    org_id              NUMBER,
    project_manager_id  NUMBER,
    start_date          DATE,
    end_date            DATE,
    budget_amount       NUMBER(18,2),
    currency_code       VARCHAR2(3)     DEFAULT 'AED',
    status              VARCHAR2(20)    DEFAULT 'ACTIVE' NOT NULL,  -- lookup PROJECT_STATUS
    description_en      VARCHAR2(2000),
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT pk_dct_projects     PRIMARY KEY (project_number),
    CONSTRAINT chk_dct_proj_active CHECK       (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_proj_dates  CHECK       (end_date IS NULL OR end_date >= start_date),
    CONSTRAINT fk_dct_proj_org     FOREIGN KEY (org_id)             REFERENCES prod.dct_organizations(org_id),
    CONSTRAINT fk_dct_proj_mgr     FOREIGN KEY (project_manager_id) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dct_proj_ccy     FOREIGN KEY (currency_code)      REFERENCES prod.dct_currency_codes(currency_code)
);
CREATE INDEX prod.ix_dct_proj_org    ON prod.dct_projects(org_id);
CREATE INDEX prod.ix_dct_proj_status ON prod.dct_projects(status, is_active);
CREATE INDEX prod.ix_dct_proj_mgr    ON prod.dct_projects(project_manager_id);

COMMENT ON TABLE prod.dct_projects IS
  'Project master keyed by natural PROJECT_NUMBER (Oracle Fusion style). Module tables FK their project_number columns directly here.';

CREATE TABLE prod.dct_tasks (
    project_number      VARCHAR2(12)    NOT NULL,
    task_number         VARCHAR2(30)    NOT NULL,
    task_name_en        VARCHAR2(500)   NOT NULL,
    task_name_ar        VARCHAR2(500),
    parent_task_number  VARCHAR2(30),                  -- WBS parent within same project
    task_level          NUMBER          DEFAULT 1,
    start_date          DATE,
    end_date            DATE,
    budget_amount       NUMBER(18,2),
    is_chargeable       VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    display_order       NUMBER          DEFAULT 0,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT pk_dct_tasks          PRIMARY KEY (project_number, task_number),
    CONSTRAINT chk_dct_task_active   CHECK       (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_task_charge   CHECK       (is_chargeable IN ('Y','N')),
    CONSTRAINT fk_dct_task_project   FOREIGN KEY (project_number) REFERENCES prod.dct_projects(project_number) ON DELETE CASCADE,
    CONSTRAINT fk_dct_task_parent    FOREIGN KEY (project_number, parent_task_number)
                                     REFERENCES  prod.dct_tasks(project_number, task_number)
);
CREATE INDEX prod.ix_dct_task_parent ON prod.dct_tasks(project_number, parent_task_number);
CREATE INDEX prod.ix_dct_task_active ON prod.dct_tasks(is_active);

COMMENT ON TABLE prod.dct_tasks IS
  'Task / work-package master keyed by natural (PROJECT_NUMBER, TASK_NUMBER). Replaces DCT_PROJECT_TASKS.';

CREATE TABLE prod.dct_expenditure_types (
    expenditure_type    VARCHAR2(255)   NOT NULL,
    exp_type_name_en    VARCHAR2(300)   NOT NULL,
    exp_type_name_ar    VARCHAR2(300),
    exp_category        VARCHAR2(30)    NOT NULL,      -- lookup EXP_CATEGORY
    applies_to_gl       VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    applies_to_project  VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    display_order       NUMBER          DEFAULT 0,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT pk_dct_exp_types      PRIMARY KEY (expenditure_type),
    CONSTRAINT chk_dct_exp_active    CHECK  (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_exp_gl        CHECK  (applies_to_gl IN ('Y','N')),
    CONSTRAINT chk_dct_exp_proj      CHECK  (applies_to_project IN ('Y','N'))
);
CREATE INDEX prod.ix_dct_exp_cat ON prod.dct_expenditure_types(exp_category, is_active);

COMMENT ON TABLE prod.dct_expenditure_types IS
  'Expenditure-type master keyed by natural EXPENDITURE_TYPE code (up to 255 chars). Module free-text columns FK directly here.';

-- updated_at maintenance triggers (same pattern as 12_dct_master_data.sql)
CREATE OR REPLACE TRIGGER prod.trg_dct_projects_upd
    BEFORE UPDATE ON prod.dct_projects FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_tasks_upd
    BEFORE UPDATE ON prod.dct_tasks FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/
CREATE OR REPLACE TRIGGER prod.trg_dct_exp_types_upd
    BEFORE UPDATE ON prod.dct_expenditure_types FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

PROMPT === [3/9] Re-seed the 20 expenditure types onto the natural-key shape ===

INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('SALARIES',        'Salaries and Wages',                'الرواتب والأجور',                'PERSONNEL', 'Y', 'N', 10);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('OVERTIME',        'Overtime and Allowances',           'العمل الإضافي والبدلات',         'PERSONNEL', 'Y', 'N', 20);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('TRAVEL_INTL',     'International Travel',              'السفر الدولي',                   'TRAVEL',    'Y', 'Y', 30);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('TRAVEL_LOCAL',    'Local Travel and Transportation',   'التنقل المحلي والمواصلات',       'TRAVEL',    'Y', 'Y', 40);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('TRAINING',        'Training and Development',          'التدريب والتطوير',               'TRAVEL',    'Y', 'Y', 50);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('CONSULTANCY',     'Consultancy Services',              'خدمات الاستشارات',               'SERVICES',  'Y', 'Y', 60);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('PROFESSIONAL',    'Professional Services',             'الخدمات المهنية',                'SERVICES',  'Y', 'Y', 70);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('IT_SERVICES',     'IT and Digital Services',           'خدمات تقنية المعلومات',          'SERVICES',  'Y', 'Y', 80);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('MAINTENANCE',     'Maintenance and Repairs',           'الصيانة والإصلاح',               'SERVICES',  'Y', 'Y', 90);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('UTILITIES',       'Utilities (Electricity, Water)',    'الخدمات (الكهرباء والماء)',       'SERVICES',  'Y', 'N', 100);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('RENT',            'Rent and Leasing',                  'الإيجار والتأجير',               'SERVICES',  'Y', 'N', 110);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('OFFICE_SUPPLIES', 'Office and Administrative Supplies','مستلزمات المكتب والإدارة',       'SUPPLIES',  'Y', 'Y', 120);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('PRINTING',        'Printing and Publications',         'الطباعة والمطبوعات',             'SUPPLIES',  'Y', 'Y', 130);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('SUBSCRIPTIONS',   'Subscriptions and Memberships',     'الاشتراكات والعضويات',           'SUPPLIES',  'Y', 'Y', 140);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('IT_EQUIPMENT',    'IT Equipment and Hardware',         'أجهزة وأدوات تقنية المعلومات',  'EQUIPMENT', 'Y', 'Y', 150);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('IT_SOFTWARE',     'Software Licenses',                 'تراخيص البرامج',                 'EQUIPMENT', 'Y', 'Y', 160);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('VEHICLES',        'Vehicles and Transport Equipment',  'المركبات ومعدات النقل',          'EQUIPMENT', 'Y', 'Y', 170);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('HOSPITALITY',     'Hospitality and Events',            'الضيافة والفعاليات',             'OTHER',     'Y', 'Y', 180);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('MEDICAL',         'Medical and Healthcare',            'الرعاية الطبية والصحية',         'OTHER',     'Y', 'N', 190);
INSERT INTO prod.dct_expenditure_types (expenditure_type, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('OTHER_DIRECT',    'Other Direct Expenses',             'مصاريف مباشرة أخرى',            'OTHER',     'Y', 'Y', 200);
COMMIT;

PROMPT === [4/9] Document-type master: add CC/FL types, extend applies_to_modules ===

DECLARE
    PROCEDURE upsert_doc_type (
        p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_cat VARCHAR2,
        p_modules VARCHAR2, p_has_expiry VARCHAR2, p_alert_days NUMBER, p_ord NUMBER
    ) IS
    BEGIN
        MERGE INTO prod.dct_document_types t
        USING (SELECT p_code AS doc_type_code FROM dual) s
        ON (t.doc_type_code = s.doc_type_code)
        WHEN NOT MATCHED THEN
            INSERT (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category,
                    applies_to_modules, has_expiry, expiry_alert_days, display_order)
            VALUES (p_code, p_en, p_ar, p_cat, p_modules, p_has_expiry, p_alert_days, p_ord)
        WHEN MATCHED THEN
            UPDATE SET t.applies_to_modules = p_modules;
    END;
BEGIN
    -- New types required by the CC document requirements
    upsert_doc_type('HR_AUTH_LETTER',  'HR Authorisation Letter',        'خطاب تفويض الموارد البشرية', 'LEGAL',  'CC',          'N', 0,  200);
    upsert_doc_type('JUSTIFICATION',   'Justification Letter',           'خطاب تبرير',                 'LEGAL',  'CC',          'N', 0,  210);
    upsert_doc_type('CLEARANCE_LTR',   'Clearance Letter',               'خطاب إخلاء طرف',             'LEGAL',  'CC',          'N', 0,  220);
    upsert_doc_type('POLICE_REPORT',   'Police Report (Lost Card)',      'تقرير شرطة',                 'LEGAL',  'CC',          'N', 0,  230);
    upsert_doc_type('DAMAGED_CARD',    'Damaged Card Evidence',          'دليل البطاقة التالفة',       'OTHER',  'CC',          'N', 0,  240);
    -- New types required by the FL lookup-based document types
    upsert_doc_type('TRADE_LICENSE',   'Trade License',                  'رخصة تجارية',                'LEGAL',  'FL',          'Y', 30, 250);
    upsert_doc_type('QUALIFICATION',   'Qualification Certificate',      'شهادة مؤهل',                 'OTHER',  'FL',          'N', 0,  260);
    upsert_doc_type('DELIVERABLE_DOC', 'Deliverable Document',           'وثيقة المخرج',               'OTHER',  'FL',          'N', 0,  270);
    -- Existing types now also used by CC
    upsert_doc_type('EMIRATES_ID',     'Emirates ID',                    'الهوية الإماراتية',          'IDENTITY','FL|CC',      'Y', 60, 20);
    upsert_doc_type('PASSPORT',        'Passport',                       'جواز السفر',                 'IDENTITY','DT|FL|CC',   'Y', 90, 10);
    upsert_doc_type('BANK_LETTER',     'Bank Account Letter / IBAN',     'خطاب حساب بنكي / IBAN',     'FINANCIAL','FL|CC',     'N', 0,  130);
    upsert_doc_type('APPROVAL_LETTER', 'Approval Letter / Memo',         'خطاب موافقة / مذكرة',       'LEGAL',  'DT|PC|FL|CC', 'N', 0,  160);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Document types upserted: 8 new + 4 module extensions');
END;
/

PROMPT === [5/9] DCT_LOOKUP_PKG — lookup-first validation helper ===

CREATE OR REPLACE PACKAGE prod.dct_lookup_pkg AS
    -- 'Y' when p_code is an active value of the active category p_category.
    -- NULL p_code returns 'Y' (nullable columns validate only when present).
    FUNCTION is_valid (p_category VARCHAR2, p_code VARCHAR2) RETURN VARCHAR2;

    -- Raises -20090 when the code is not a valid active lookup value.
    -- Call at the top of any package/handler write that sets a status-like column.
    PROCEDURE validate_lookup (p_category VARCHAR2, p_code VARCHAR2);
END dct_lookup_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_lookup_pkg AS

    FUNCTION is_valid (p_category VARCHAR2, p_code VARCHAR2) RETURN VARCHAR2 IS
        v_n NUMBER;
    BEGIN
        IF p_code IS NULL THEN
            RETURN 'Y';
        END IF;
        SELECT COUNT(*) INTO v_n
        FROM   prod.dct_lookup_values     lv
        JOIN   prod.dct_lookup_categories lc ON lc.category_id = lv.category_id
        WHERE  lc.category_code = p_category
        AND    lc.is_active     = 'Y'
        AND    lv.value_code    = p_code
        AND    lv.is_active     = 'Y';
        RETURN CASE WHEN v_n > 0 THEN 'Y' ELSE 'N' END;
    END is_valid;

    PROCEDURE validate_lookup (p_category VARCHAR2, p_code VARCHAR2) IS
    BEGIN
        IF is_valid(p_category, p_code) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20090,
                '"' || p_code || '" is not a valid active value of lookup category ' ||
                p_category || '. Manage values in Admin > Lookups.');
        END IF;
    END validate_lookup;

END dct_lookup_pkg;
/

PROMPT === [6/9] Lookup categories + values for all new status families ===

DECLARE
    v_cat NUMBER;

    PROCEDURE upsert_category (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
    BEGIN
        MERGE INTO prod.dct_lookup_categories t
        USING (SELECT p_code AS category_code FROM dual) s
        ON (t.category_code = s.category_code)
        WHEN NOT MATCHED THEN
            INSERT (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
            VALUES (p_code, p_en, p_ar, NULL, 'Y', 'Y')
        WHEN MATCHED THEN
            UPDATE SET t.category_name_en = p_en, t.category_name_ar = p_ar;
        SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
    END;

    PROCEDURE upsert_value (p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                            p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N') IS
    BEGIN
        MERGE INTO prod.dct_lookup_values t
        USING (SELECT p_cat AS category_id, p_code AS value_code FROM dual) s
        ON (t.category_id = s.category_id AND t.value_code = s.value_code)
        WHEN NOT MATCHED THEN
            INSERT (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
            VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_default, 'Y')
        WHEN MATCHED THEN
            UPDATE SET t.value_name_en = p_en, t.value_name_ar = p_ar, t.display_order = p_ord;
    END;
BEGIN
    -- Standard cross-module request status vocabulary
    upsert_category('REQUEST_STATUS', 'Request Status (Cross-Module)', 'حالة الطلب', v_cat);
    upsert_value(v_cat, 'DRAFT',            'Draft',                   'مسودة',            10, 'Y');
    upsert_value(v_cat, 'SUBMITTED',        'Submitted',               'مقدم',             20);
    upsert_value(v_cat, 'UNDER_REVIEW',     'Under Review',            'قيد المراجعة',     30);
    upsert_value(v_cat, 'PENDING_APPROVAL', 'Pending Approval',        'بانتظار الاعتماد', 40);
    upsert_value(v_cat, 'RETURNED',         'Returned for Correction', 'معاد للتصحيح',     50);
    upsert_value(v_cat, 'APPROVED',         'Approved',                'معتمد',            60);
    upsert_value(v_cat, 'REJECTED',         'Rejected',                'مرفوض',            70);
    upsert_value(v_cat, 'WITHDRAWN',        'Withdrawn',               'مسحوب',            80);
    upsert_value(v_cat, 'IN_PROGRESS',      'In Progress',             'قيد التنفيذ',      90);
    upsert_value(v_cat, 'ACTIVE',           'Active',                  'نشط',             100);
    upsert_value(v_cat, 'CLOSED',           'Closed',                  'مغلق',            110);
    upsert_value(v_cat, 'CANCELLED',        'Cancelled',               'ملغى',            120);

    -- Document lifecycle
    upsert_category('DOC_STATUS', 'Document Status', 'حالة المستند', v_cat);
    upsert_value(v_cat, 'ACTIVE',     'Active',     'نشط',  10, 'Y');
    upsert_value(v_cat, 'SUPERSEDED', 'Superseded', 'ملغى بنسخة أحدث', 20);

    upsert_category('DOC_ALERT_TYPE', 'Document Expiry Alert Type', 'نوع تنبيه انتهاء المستند', v_cat);
    upsert_value(v_cat, 'EXPIRING_SOON', 'Expiring Soon', 'قارب على الانتهاء', 10);
    upsert_value(v_cat, 'EXPIRED',       'Expired',       'منتهي',             20);

    -- Coding
    upsert_category('CODING_TYPE', 'Budget Coding Type', 'نوع الترميز', v_cat);
    upsert_value(v_cat, 'GL',      'GL Account',  'حساب الأستاذ العام', 10, 'Y');
    upsert_value(v_cat, 'PROJECT', 'Project',     'مشروع',              20);

    upsert_category('BCL_SOURCE_TYPE', 'Budget Coding Line Source Type', 'نوع مصدر سطر الترميز', v_cat);
    upsert_value(v_cat, 'PC',          'Petty Cash Advance',        NULL, 10);
    upsert_value(v_cat, 'PC_REIMB',    'Petty Cash Reimbursement',  NULL, 20);
    upsert_value(v_cat, 'PC_CLEAR',    'Petty Cash Clearing',       NULL, 30);
    upsert_value(v_cat, 'CC_REPL',     'Credit Card Replenishment', NULL, 40);
    upsert_value(v_cat, 'DT_REQ',      'Duty Travel Request',       NULL, 50);
    upsert_value(v_cat, 'DT_STL',      'Duty Travel Settlement',    NULL, 60);
    upsert_value(v_cat, 'FL_CONTRACT', 'Freelancer Contract',       NULL, 70);

    -- Source discriminators
    upsert_category('SOURCE_MODULE', 'Source Module', 'الوحدة المصدر', v_cat);
    upsert_value(v_cat, 'PC',    'Petty Cash',   'السلفة النقدية',     10);
    upsert_value(v_cat, 'DT',    'Duty Travel',  'السفر الرسمي',       20);
    upsert_value(v_cat, 'HR',    'HR',           'الموارد البشرية',    30);
    upsert_value(v_cat, 'FL',    'Freelancers',  'المتعاقدون',         40);
    upsert_value(v_cat, 'CC',    'Credit Cards', 'البطاقات الائتمانية', 50);
    upsert_value(v_cat, 'ADMIN', 'Admin',        'الإدارة',            60);

    upsert_category('DOC_SOURCE_TYPE', 'Document Source Type', 'نوع مصدر المستند', v_cat);
    upsert_value(v_cat, 'REQUEST',    'Request',           NULL, 10);
    upsert_value(v_cat, 'REIMB',      'Reimbursement',     NULL, 20);
    upsert_value(v_cat, 'CLEARING',   'Clearing',          NULL, 30);
    upsert_value(v_cat, 'SETTLEMENT', 'Settlement',        NULL, 40);
    upsert_value(v_cat, 'CONTRACT',   'Contract',          NULL, 50);
    upsert_value(v_cat, 'RENEWAL',    'Contract Renewal',  NULL, 60);
    upsert_value(v_cat, 'EMPLOYEE',   'Employee',          NULL, 70);
    upsert_value(v_cat, 'FREELANCER', 'Freelancer',        NULL, 80);
    upsert_value(v_cat, 'CARD',       'Card',              NULL, 90);
    upsert_value(v_cat, 'OTHER',      'Other',             NULL, 99);

    -- Project master vocabularies (CHECK constraints removed per lookup-first rule)
    upsert_category('PROJECT_STATUS', 'Project Status', 'حالة المشروع', v_cat);
    upsert_value(v_cat, 'ACTIVE',    'Active',    'نشط',      10, 'Y');
    upsert_value(v_cat, 'COMPLETED', 'Completed', 'مكتمل',    20);
    upsert_value(v_cat, 'ON_HOLD',   'On Hold',   'معلق',     30);
    upsert_value(v_cat, 'CANCELLED', 'Cancelled', 'ملغى',     40);

    upsert_category('PROJECT_TYPE', 'Project Type', 'نوع المشروع', v_cat);
    upsert_value(v_cat, 'CAPITAL',     'Capital',     'رأسمالي', 10);
    upsert_value(v_cat, 'OPERATIONAL', 'Operational', 'تشغيلي',  20);
    upsert_value(v_cat, 'GRANT',       'Grant',       'منحة',    30);
    upsert_value(v_cat, 'INTERNAL',    'Internal',    'داخلي',   40);

    upsert_category('EXP_CATEGORY', 'Expenditure Category', 'فئة الإنفاق', v_cat);
    upsert_value(v_cat, 'PERSONNEL', 'Personnel', 'الموظفون',  10);
    upsert_value(v_cat, 'TRAVEL',    'Travel',    'السفر',     20);
    upsert_value(v_cat, 'SERVICES',  'Services',  'الخدمات',   30);
    upsert_value(v_cat, 'SUPPLIES',  'Supplies',  'المستلزمات',40);
    upsert_value(v_cat, 'EQUIPMENT', 'Equipment', 'المعدات',   50);
    upsert_value(v_cat, 'OTHER',     'Other',     'أخرى',      90);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookup categories seeded: REQUEST_STATUS, DOC_STATUS, DOC_ALERT_TYPE, CODING_TYPE, BCL_SOURCE_TYPE, SOURCE_MODULE, DOC_SOURCE_TYPE, PROJECT_STATUS, PROJECT_TYPE, EXP_CATEGORY');
END;
/

PROMPT === [7/9] Unified tables ===

-- Requirements first: dct_documents.doc_req_id references it.
CREATE TABLE prod.dct_doc_requirements (
    doc_req_id      NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_module   VARCHAR2(10)   NOT NULL,            -- lookup SOURCE_MODULE
    context_code    VARCHAR2(50)   NOT NULL,            -- e.g. CC:NEW_CARD -> 'NEW_CARD'
    doc_type_id     NUMBER         NOT NULL,
    is_mandatory    VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    display_seq     NUMBER         DEFAULT 10,
    is_active       VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    created_by      NUMBER,
    created_at      TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by      NUMBER,
    updated_at      TIMESTAMP,
    --
    CONSTRAINT uq_dct_doc_req       UNIQUE (source_module, context_code, doc_type_id),
    CONSTRAINT chk_dct_docreq_mand  CHECK  (is_mandatory IN ('Y','N')),
    CONSTRAINT chk_dct_docreq_act   CHECK  (is_active IN ('Y','N')),
    CONSTRAINT fk_dct_docreq_type   FOREIGN KEY (doc_type_id) REFERENCES prod.dct_document_types(doc_type_id)
);

COMMENT ON TABLE prod.dct_doc_requirements IS
  'Unified per-context document requirements (replaces dct_cc_doc_requirements; DT doc requirements adopt later).';

CREATE TABLE prod.dct_documents (
    doc_id            NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_module     VARCHAR2(10)   NOT NULL,           -- lookup SOURCE_MODULE
    source_type       VARCHAR2(30)   NOT NULL,           -- lookup DOC_SOURCE_TYPE
    source_id         NUMBER         NOT NULL,           -- PK of the owning module row
    reference_id      NUMBER,                            -- optional line-level anchor
    doc_type_id       NUMBER         NOT NULL,
    doc_req_id        NUMBER,                            -- satisfied requirement, when applicable
    file_name         VARCHAR2(255)  NOT NULL,
    mime_type         VARCHAR2(100),
    file_size_bytes   NUMBER,
    file_blob         BLOB,
    expiry_date       DATE,
    alert_days_before NUMBER,
    status            VARCHAR2(20)   DEFAULT 'ACTIVE' NOT NULL,  -- lookup DOC_STATUS
    is_required       VARCHAR2(1)    DEFAULT 'N' NOT NULL,
    notes             VARCHAR2(1000),
    is_active         VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    created_by        NUMBER         NOT NULL,           -- dct_users.user_id of uploader
    created_at        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by        NUMBER,
    updated_at        TIMESTAMP,
    --
    CONSTRAINT chk_dct_docs_req    CHECK (is_required IN ('Y','N')),
    CONSTRAINT chk_dct_docs_act    CHECK (is_active IN ('Y','N')),
    CONSTRAINT fk_dct_docs_type    FOREIGN KEY (doc_type_id) REFERENCES prod.dct_document_types(doc_type_id),
    CONSTRAINT fk_dct_docs_docreq  FOREIGN KEY (doc_req_id)  REFERENCES prod.dct_doc_requirements(doc_req_id),
    CONSTRAINT fk_dct_docs_creator FOREIGN KEY (created_by)  REFERENCES prod.dct_users(user_id)
);

CREATE INDEX prod.ix_dct_docs_source ON prod.dct_documents (source_module, source_type, source_id);
CREATE INDEX prod.ix_dct_docs_expiry ON prod.dct_documents (expiry_date);
CREATE INDEX prod.ix_dct_docs_type   ON prod.dct_documents (doc_type_id);

COMMENT ON TABLE prod.dct_documents IS
  'Unified document/attachment store for all modules, discriminated by (source_module, source_type, source_id).';

CREATE TABLE prod.dct_doc_expiry_alerts (
    alert_id          NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    doc_id            NUMBER        NOT NULL,
    alert_type        VARCHAR2(20)  NOT NULL,            -- lookup DOC_ALERT_TYPE
    days_remaining    NUMBER,
    notified_user_id  NUMBER,
    sent_at           TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT fk_dct_docalert_doc FOREIGN KEY (doc_id)           REFERENCES prod.dct_documents(doc_id),
    CONSTRAINT fk_dct_docalert_usr FOREIGN KEY (notified_user_id) REFERENCES prod.dct_users(user_id)
);

CREATE INDEX prod.ix_dct_docalert_doc ON prod.dct_doc_expiry_alerts (doc_id, alert_type, sent_at);

COMMENT ON TABLE prod.dct_doc_expiry_alerts IS
  'Sent document-expiry notifications (duplicate suppression via NOT EXISTS per doc/type/user/day). Replaces dct_fl_doc_expiry_alerts.';

CREATE TABLE prod.dct_budget_coding_lines (
    line_id          NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_module    VARCHAR2(10)  NOT NULL,             -- lookup SOURCE_MODULE
    source_type      VARCHAR2(30)  NOT NULL,             -- lookup BCL_SOURCE_TYPE
    source_id        NUMBER        NOT NULL,
    line_num         NUMBER        NOT NULL,
    coding_type      VARCHAR2(10)  NOT NULL,             -- GL | PROJECT (structural CHECK below)

    -- GL branch
    cc_id            NUMBER,

    -- PROJECT branch: natural keys, no surrogate IDs (user directive)
    project_number   VARCHAR2(12),
    task_number      VARCHAR2(30),
    expenditure_type VARCHAR2(255),

    amount           NUMBER(15,2)  NOT NULL,
    currency_code    VARCHAR2(3)   DEFAULT 'AED',
    description      VARCHAR2(500),
    expense_date     DATE,                               -- CC replenishment lines; NULL elsewhere

    -- CC-only extension columns (nullable for all other modules)
    merchant_name    VARCHAR2(200),
    receipt_attached VARCHAR2(1),

    created_by       NUMBER        NOT NULL,
    created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       NUMBER,
    updated_at       TIMESTAMP,

    CONSTRAINT uq_dct_bcl UNIQUE (source_module, source_type, source_id, line_num),

    -- GL/PROJECT exclusivity: structural rule, enforced once in the schema
    CONSTRAINT ck_dct_bcl_coding CHECK (
         (coding_type = 'GL'      AND cc_id IS NOT NULL AND project_number IS NULL
                                  AND task_number IS NULL AND expenditure_type IS NULL)
      OR (coding_type = 'PROJECT' AND project_number IS NOT NULL AND cc_id IS NULL)
    ),
    CONSTRAINT chk_dct_bcl_rcpt CHECK (receipt_attached IN ('Y','N') OR receipt_attached IS NULL),

    CONSTRAINT fk_dct_bcl_cc      FOREIGN KEY (cc_id)            REFERENCES prod.dct_gl_code_combinations(cc_id),
    CONSTRAINT fk_dct_bcl_project FOREIGN KEY (project_number)   REFERENCES prod.dct_projects(project_number),
    CONSTRAINT fk_dct_bcl_task    FOREIGN KEY (project_number, task_number)
                                  REFERENCES  prod.dct_tasks(project_number, task_number),
    CONSTRAINT fk_dct_bcl_exptype FOREIGN KEY (expenditure_type) REFERENCES prod.dct_expenditure_types(expenditure_type),
    CONSTRAINT fk_dct_bcl_ccy     FOREIGN KEY (currency_code)    REFERENCES prod.dct_currency_codes(currency_code),
    CONSTRAINT fk_dct_bcl_creator FOREIGN KEY (created_by)       REFERENCES prod.dct_users(user_id)
);

CREATE INDEX prod.ix_dct_bcl_source  ON prod.dct_budget_coding_lines (source_module, source_type, source_id);
CREATE INDEX prod.ix_dct_bcl_cc      ON prod.dct_budget_coding_lines (cc_id);
CREATE INDEX prod.ix_dct_bcl_project ON prod.dct_budget_coding_lines (project_number, task_number);

COMMENT ON TABLE prod.dct_budget_coding_lines IS
  'Unified GL/PROJECT coding lines for all spend modules; PROJECT branch FKs natural keys (project_number, task_number, expenditure_type). One read path for cross-module spend reporting.';

CREATE TABLE prod.dct_request_status_history (
    hist_id        NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_module  VARCHAR2(10)   NOT NULL,              -- lookup SOURCE_MODULE
    source_type    VARCHAR2(30)   NOT NULL,
    source_id      NUMBER         NOT NULL,
    old_status     VARCHAR2(30),                         -- NULL on creation
    new_status     VARCHAR2(30)   NOT NULL,              -- module status; std vocab in REQUEST_STATUS
    changed_by     NUMBER         NOT NULL,
    changed_at     TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    comments       VARCHAR2(1000),
    --
    CONSTRAINT fk_dct_rsh_user FOREIGN KEY (changed_by) REFERENCES prod.dct_users(user_id)
);

CREATE INDEX prod.ix_dct_rsh_source  ON prod.dct_request_status_history (source_module, source_type, source_id);
CREATE INDEX prod.ix_dct_rsh_changed ON prod.dct_request_status_history (changed_at);

COMMENT ON TABLE prod.dct_request_status_history IS
  'Append-only status-transition log for every request-like row in every module. Fed by module packages and ORDS handlers.';

PROMPT === [8/9] Re-seed CC document requirements onto unified table ===

DECLARE
    v_admin_id NUMBER;

    PROCEDURE add_req (p_context VARCHAR2, p_type_code VARCHAR2, p_mand CHAR, p_seq NUMBER) IS
        v_type_id NUMBER;
    BEGIN
        SELECT doc_type_id INTO v_type_id
        FROM   prod.dct_document_types WHERE doc_type_code = p_type_code;

        MERGE INTO prod.dct_doc_requirements t
        USING (SELECT 'CC' AS source_module, p_context AS context_code, v_type_id AS doc_type_id FROM dual) s
        ON (t.source_module = s.source_module AND t.context_code = s.context_code AND t.doc_type_id = s.doc_type_id)
        WHEN NOT MATCHED THEN
            INSERT (source_module, context_code, doc_type_id, is_mandatory, display_seq, is_active, created_by)
            VALUES ('CC', p_context, v_type_id, p_mand, p_seq, 'Y', v_admin_id)
        WHEN MATCHED THEN
            UPDATE SET t.is_mandatory = p_mand, t.display_seq = p_seq;
    END;
BEGIN
    BEGIN
        SELECT user_id INTO v_admin_id FROM prod.dct_users WHERE username = 'ADMIN' AND ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        SELECT user_id INTO v_admin_id FROM prod.dct_users WHERE ROWNUM = 1;
    END;

    add_req('NEW_CARD',       'EMIRATES_ID',     'Y', 10);
    add_req('NEW_CARD',       'PASSPORT',        'Y', 20);
    add_req('NEW_CARD',       'HR_AUTH_LETTER',  'Y', 30);
    add_req('NEW_CARD',       'BANK_LETTER',     'N', 40);

    add_req('INCREASE_LIMIT', 'JUSTIFICATION',   'Y', 10);
    add_req('INCREASE_LIMIT', 'APPROVAL_LETTER', 'Y', 20);

    add_req('DECREASE_LIMIT', 'JUSTIFICATION',   'N', 10);

    add_req('CLOSE_CARD',     'CLEARANCE_LTR',   'Y', 10);
    add_req('CLOSE_CARD',     'CC_STATEMENT',    'Y', 20);

    add_req('REPLACEMENT',    'POLICE_REPORT',   'N', 10);
    add_req('REPLACEMENT',    'DAMAGED_CARD',    'N', 20);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('CC document requirements re-seeded: 11 rows across 5 contexts');
END;
/

PROMPT === [9/9] ADMIN synonyms for ORDS handlers ===

CREATE OR REPLACE SYNONYM dct_projects               FOR prod.dct_projects;
CREATE OR REPLACE SYNONYM dct_tasks                  FOR prod.dct_tasks;
CREATE OR REPLACE SYNONYM dct_expenditure_types      FOR prod.dct_expenditure_types;
CREATE OR REPLACE SYNONYM dct_documents              FOR prod.dct_documents;
CREATE OR REPLACE SYNONYM dct_doc_requirements       FOR prod.dct_doc_requirements;
CREATE OR REPLACE SYNONYM dct_doc_expiry_alerts      FOR prod.dct_doc_expiry_alerts;
CREATE OR REPLACE SYNONYM dct_budget_coding_lines    FOR prod.dct_budget_coding_lines;
CREATE OR REPLACE SYNONYM dct_request_status_history FOR prod.dct_request_status_history;
CREATE OR REPLACE SYNONYM dct_lookup_pkg             FOR prod.dct_lookup_pkg;

-- Drop the dangling synonym for the removed dct_project_tasks table
DECLARE
    v_n NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_n FROM user_synonyms WHERE synonym_name = 'DCT_PROJECT_TASKS';
    IF v_n > 0 THEN
        EXECUTE IMMEDIATE 'DROP SYNONYM dct_project_tasks';
        DBMS_OUTPUT.PUT_LINE('Dropped dangling synonym dct_project_tasks');
    END IF;
END;
/

PROMPT
PROMPT === 15_dct_unified_structures.sql complete ===
PROMPT Masters  : DCT_PROJECTS (project_number PK), DCT_TASKS (project_number+task_number PK),
PROMPT            DCT_EXPENDITURE_TYPES (expenditure_type PK) + 20 seed rows
PROMPT Unified  : DCT_DOC_REQUIREMENTS (11 CC rows), DCT_DOCUMENTS, DCT_DOC_EXPIRY_ALERTS,
PROMPT            DCT_BUDGET_CODING_LINES, DCT_REQUEST_STATUS_HISTORY
PROMPT Lookups  : 10 categories (REQUEST_STATUS, DOC_*, CODING_TYPE, BCL_SOURCE_TYPE,
PROMPT            SOURCE_MODULE, PROJECT_*, EXP_CATEGORY) + DCT_LOOKUP_PKG validator
PROMPT ===
