SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

-- =============================================================================
-- 26_fl_contract_phase2_seed.sql
-- Freelancers Module (App 203) -- Contract Phase 2 -- seed data
-- Schema  : PROD (run as ADMIN). Idempotent (MERGE everywhere). Arabic via
--           UNISTR (encoding-independent). Run after 25_fl_contract_phase2_ddl.
-- Seeds   : endorsement chain roles, contract-type + FTE-conversion lookups,
--           attachment document types + FL/CONTRACT requirements matrix,
--           7-step approval chains (contract, amendment, renewal).
-- =============================================================================

PROMPT === [1/5] Endorsement chain roles ===

DECLARE
    v_fl_module_id dct_modules.module_id%TYPE;

    PROCEDURE upsert_role (
        p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
        p_mod  NUMBER,   p_desc VARCHAR2, p_ord NUMBER
    ) IS
    BEGIN
        MERGE INTO prod.dct_roles tgt
        USING (SELECT p_code AS role_code FROM dual) src
        ON    (tgt.role_code = src.role_code)
        WHEN NOT MATCHED THEN
            INSERT (role_code, role_name_en, role_name_ar, role_type, module_id,
                    description_en, is_active, is_system_role, display_order)
            VALUES (p_code, p_en, p_ar, 'MODULE', p_mod,
                    p_desc, 'Y', 'N', p_ord)
        WHEN MATCHED THEN
            UPDATE SET role_name_en = p_en, role_name_ar = p_ar, display_order = p_ord;
    END;
BEGIN
    SELECT module_id INTO v_fl_module_id FROM prod.dct_modules WHERE module_code = 'FREELANCERS';

    upsert_role('FL_FIN_BP', 'Finance Business Partner', UNISTR('\0634\0631\064A\0643 \0627\0644\0623\0639\0645\0627\0644 \0627\0644\0645\0627\0644\064A'),
        v_fl_module_id,
        'Endorses freelancer contracts for their department or sector (scoped via the FL approver map).', 50);
    upsert_role('FL_AP_OPS_MGR', 'AP Operations Manager', UNISTR('\0645\062F\064A\0631 \0639\0645\0644\064A\0627\062A \0627\0644\062D\0633\0627\0628\0627\062A \0627\0644\062F\0627\0626\0646\0629'),
        v_fl_module_id,
        'Accounts Payable Operations Manager -- endorses freelancer contracts.', 60);
    upsert_role('FIN_DIRECTOR', 'Finance Director', UNISTR('\0645\062F\064A\0631 \0625\062F\0627\0631\0629 \0627\0644\0645\0627\0644\064A\0629'),
        NULL,
        'Finance Director -- endorses freelancer contracts. Platform-wide role.', 70);
    upsert_role('ORG_DEV_HEAD', 'Organization Development Head', UNISTR('\0631\0626\064A\0633 \0627\0644\062A\0637\0648\064A\0631 \0627\0644\0645\0624\0633\0633\064A'),
        NULL,
        'Organization Development Head -- endorses freelancer contracts of six months or longer. Platform-wide role.', 80);
    upsert_role('TA_MANAGER', 'Talent Acquisition Manager', UNISTR('\0645\062F\064A\0631 \0627\0633\062A\0642\0637\0627\0628 \0627\0644\0645\0648\0627\0647\0628'),
        NULL,
        'Talent Acquisition Manager -- endorses freelancer contracts and receives submission notifications. Platform-wide role.', 90);
    upsert_role('HR_DIRECTOR', 'HR Director', UNISTR('\0645\062F\064A\0631 \0625\062F\0627\0631\0629 \0627\0644\0645\0648\0627\0631\062F \0627\0644\0628\0634\0631\064A\0629'),
        NULL,
        'HR Director -- final approver of freelancer contracts. Platform-wide role.', 100);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Roles seeded: FL_FIN_BP, FL_AP_OPS_MGR, FIN_DIRECTOR, ORG_DEV_HEAD, TA_MANAGER, HR_DIRECTOR');
END;
/

PROMPT === [2/5] Lookups: contract type + FTE conversion ===

DECLARE
    v_module_id dct_modules.module_id%TYPE;
    v_cat_ctype NUMBER;
    v_cat_fte   NUMBER;

    PROCEDURE upsert_category (
        p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
        p_mod  NUMBER,   p_id OUT NUMBER
    ) IS
    BEGIN
        MERGE INTO prod.dct_lookup_categories tgt
        USING (SELECT p_code AS category_code FROM dual) src
        ON    (tgt.category_code = src.category_code)
        WHEN NOT MATCHED THEN
            INSERT (category_code, category_name_en, category_name_ar,
                    module_id, is_system, is_active)
            VALUES (p_code, p_en, p_ar, p_mod, 'N', 'Y')
        WHEN MATCHED THEN
            UPDATE SET category_name_en = p_en, category_name_ar = p_ar;
        SELECT category_id INTO p_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
    END;

    PROCEDURE upsert_value (
        p_cat_id NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
        p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N'
    ) IS
    BEGIN
        MERGE INTO prod.dct_lookup_values tgt
        USING (SELECT p_cat_id AS category_id, p_code AS value_code FROM dual) src
        ON    (tgt.category_id = src.category_id AND tgt.value_code = src.value_code)
        WHEN NOT MATCHED THEN
            INSERT (category_id, value_code, value_name_en, value_name_ar,
                    display_order, is_default, is_active)
            VALUES (p_cat_id, p_code, p_en, p_ar, p_ord, p_default, 'Y')
        WHEN MATCHED THEN
            UPDATE SET value_name_en = p_en, value_name_ar = p_ar, display_order = p_ord;
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'FREELANCERS';

    upsert_category('FL_CONTRACT_TYPE', 'Freelancer Contract Types', UNISTR('\0623\0646\0648\0627\0639 \0639\0642\0648\062F \0627\0644\0645\062A\0639\0627\0642\062F\064A\0646'),
                    v_module_id, v_cat_ctype);
    upsert_value(v_cat_ctype, 'CONTRACTOR', 'Contractor', UNISTR('\0645\0642\0627\0648\0644'), 10);
    upsert_value(v_cat_ctype, 'CONSULTANT', 'Consultant', UNISTR('\0627\0633\062A\0634\0627\0631\064A'), 20, 'Y');
    upsert_value(v_cat_ctype, 'SUPPLIER',   'Supplier',   UNISTR('\0645\0648\0631\062F'),   30);
    upsert_value(v_cat_ctype, 'OTHER',      'Other',      UNISTR('\0623\062E\0631\0649'),      40);

    upsert_category('FL_FTE_CONVERSION', 'Freelancer FTE Conversion', UNISTR('\0627\0644\062A\062D\0648\064A\0644 \0625\0644\0649 \0648\0638\064A\0641\0629 \062F\0627\0626\0645\0629'),
                    v_module_id, v_cat_fte);
    upsert_value(v_cat_fte, 'DIRECT_HIRE', 'Yes -- to a direct hire',       UNISTR('\0646\0639\0645 \2014 \062A\0639\064A\064A\0646 \0645\0628\0627\0634\0631'), 10);
    upsert_value(v_cat_fte, 'OUTSOURCED',  'Yes -- to an outsourced role',  UNISTR('\0646\0639\0645 \2014 \0639\0628\0631 \0627\0644\062A\0639\0647\064A\062F'),  20);
    upsert_value(v_cat_fte, 'NO',          'No -- will not occupy a box',   UNISTR('\0644\0627 \2014 \0644\0646 \064A\0634\063A\0644 \0648\0638\064A\0641\0629'),          30, 'Y');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookups seeded: FL_CONTRACT_TYPE (4), FL_FTE_CONVERSION (3)');
END;
/

PROMPT === [3/5] Document types (termsheet attachments) ===

DECLARE
    PROCEDURE upsert_doctype (
        p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
        p_cat  VARCHAR2, p_expiry VARCHAR2, p_ord NUMBER
    ) IS
    BEGIN
        MERGE INTO prod.dct_document_types tgt
        USING (SELECT p_code AS doc_type_code FROM dual) src
        ON    (tgt.doc_type_code = src.doc_type_code)
        WHEN NOT MATCHED THEN
            INSERT (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category,
                    applies_to_modules, has_expiry, expiry_alert_days, display_order)
            VALUES (p_code, p_en, p_ar, p_cat, 'FL', p_expiry, 30, p_ord)
        WHEN MATCHED THEN
            UPDATE SET doc_type_name_en = p_en, doc_type_name_ar = p_ar,
                       applies_to_modules =
                           CASE WHEN INSTR(NVL(tgt.applies_to_modules,''), 'FL') = 0
                                THEN SUBSTR(NVL2(tgt.applies_to_modules, tgt.applies_to_modules || '|', '') || 'FL', 1, 200)
                                ELSE tgt.applies_to_modules END;
    END;
BEGIN
    upsert_doctype('PASSPORT_PHOTO',      'Passport-size Photo',  UNISTR('\0635\0648\0631\0629 \0634\062E\0635\064A\0629 \0628\062D\062C\0645 \062C\0648\0627\0632 \0627\0644\0633\0641\0631'),      'IDENTITY', 'N', 210);
    upsert_doctype('FAMILY_BOOK',         'Family Book',          UNISTR('\062E\0644\0627\0635\0629 \0627\0644\0642\064A\062F'),         'IDENTITY', 'N', 220);
    upsert_doctype('CERTIFICATE',         'Certificate',          UNISTR('\0634\0647\0627\062F\0629'),         'OTHER',    'N', 230);
    upsert_doctype('IDENTIFICATION_FORM', 'Identification Form',  UNISTR('\0646\0645\0648\0630\062C \062A\062D\062F\064A\062F \0627\0644\0647\0648\064A\0629'), 'OTHER',    'N', 240);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Document types seeded: PASSPORT_PHOTO, FAMILY_BOOK, CERTIFICATE, IDENTIFICATION_FORM');
END;
/

PROMPT === [4/5] Contract document requirements matrix (FL / CONTRACT) ===

DECLARE
    PROCEDURE req (p_doc_code VARCHAR2, p_seq NUMBER) IS
        v_type_id NUMBER;
    BEGIN
        SELECT doc_type_id INTO v_type_id
        FROM   prod.dct_document_types WHERE doc_type_code = p_doc_code;
        MERGE INTO prod.dct_doc_requirements tgt
        USING (SELECT 'FL' AS source_module, 'CONTRACT' AS context_code,
                      v_type_id AS doc_type_id FROM dual) src
        ON    (tgt.source_module = src.source_module
               AND tgt.context_code = src.context_code
               AND tgt.doc_type_id = src.doc_type_id)
        WHEN NOT MATCHED THEN
            INSERT (source_module, context_code, doc_type_id, is_mandatory, display_seq, is_active)
            VALUES ('FL', 'CONTRACT', v_type_id, 'Y', p_seq, 'Y')
        WHEN MATCHED THEN
            UPDATE SET is_mandatory = 'Y', display_seq = p_seq, is_active = 'Y';
    END;
BEGIN
    req('PASSPORT_PHOTO',      10);
    req('PASSPORT',            20);
    req('FAMILY_BOOK',         30);
    req('EMIRATES_ID',         40);
    req('CERTIFICATE',         50);
    req('IDENTIFICATION_FORM', 60);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Doc requirements FL/CONTRACT seeded: 6 mandatory types');
END;
/

PROMPT === [5/5] Approval chains: contract, amendment, renewal (7 steps) ===

DECLARE
    v_module_id  dct_modules.module_id%TYPE;
    v_tmpl_id    NUMBER;
    v_r_finbp    NUMBER;
    v_r_apops    NUMBER;
    v_r_findir   NUMBER;
    v_r_odh      NUMBER;
    v_r_tam      NUMBER;
    v_r_hrd      NUMBER;

    PROCEDURE upsert_template (
        p_code VARCHAR2, p_name VARCHAR2, p_req_type VARCHAR2,
        p_desc VARCHAR2, p_id OUT NUMBER
    ) IS
    BEGIN
        MERGE INTO prod.dct_approval_templates tgt
        USING (SELECT p_code AS template_code FROM dual) src
        ON    (tgt.template_code = src.template_code)
        WHEN NOT MATCHED THEN
            INSERT (template_code, template_name, module_id, request_type,
                    description_en, is_sequential, auto_approve_days, is_active)
            VALUES (p_code, p_name, v_module_id, p_req_type, p_desc, 'Y', 0, 'Y')
        WHEN MATCHED THEN
            UPDATE SET template_name = p_name, description_en = p_desc, is_active = 'Y';
        SELECT template_id INTO p_id FROM prod.dct_approval_templates WHERE template_code = p_code;
    END;

    PROCEDURE guard_no_pending (p_tmpl_id NUMBER) IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n
        FROM   prod.dct_approval_instances
        WHERE  template_id = p_tmpl_id AND overall_status = 'PENDING';
        IF v_n > 0 THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Template ' || p_tmpl_id || ' has ' || v_n ||
                ' PENDING instance(s) -- finish or cancel them before rebuilding the chain.');
        END IF;
    END;

    -- steps are MERGEd by (template_id, step_seq) -- never deleted, because
    -- historical dct_approval_actions rows reference step_id
    PROCEDURE add_step (
        p_tmpl_id NUMBER, p_seq NUMBER, p_name VARCHAR2, p_name_ar VARCHAR2,
        p_type VARCHAR2, p_role_id NUMBER,
        p_cond VARCHAR2 DEFAULT 'ALWAYS', p_custom VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        MERGE INTO prod.dct_approval_steps s
        USING (SELECT p_tmpl_id AS template_id, p_seq AS step_seq FROM dual) src
        ON    (s.template_id = src.template_id AND s.step_seq = src.step_seq)
        WHEN NOT MATCHED THEN
            INSERT (template_id, step_seq, step_name, step_name_ar, step_type,
                    required_role_id, specific_user_id, escalation_days,
                    is_mandatory, allow_skip, condition_type,
                    amount_operator, amount_threshold, custom_condition)
            VALUES (p_tmpl_id, p_seq, p_name, p_name_ar, p_type,
                    p_role_id, NULL, 3,
                    'Y', 'N', p_cond,
                    NULL, NULL, p_custom)
        WHEN MATCHED THEN
            UPDATE SET step_name        = p_name,
                       step_name_ar     = p_name_ar,
                       step_type        = p_type,
                       required_role_id = p_role_id,
                       specific_user_id = NULL,
                       condition_type   = p_cond,
                       amount_operator  = NULL,
                       amount_threshold = NULL,
                       custom_condition = p_custom,
                       is_mandatory     = 'Y',
                       allow_skip       = 'N';
    END;

    PROCEDURE build_chain (p_tmpl_id NUMBER) IS
    BEGIN
        guard_no_pending(p_tmpl_id);
        add_step(p_tmpl_id, 10, 'Line Manager Endorsement', UNISTR('\0627\0639\062A\0645\0627\062F \0627\0644\0645\062F\064A\0631 \0627\0644\0645\0628\0627\0634\0631'),
                 'USER_SPECIFIC', NULL);
        add_step(p_tmpl_id, 20, 'Finance Business Partner Endorsement', UNISTR('\0627\0639\062A\0645\0627\062F \0634\0631\064A\0643 \0627\0644\0623\0639\0645\0627\0644 \0627\0644\0645\0627\0644\064A'),
                 'USER_SPECIFIC', v_r_finbp);
        add_step(p_tmpl_id, 30, 'AP Operations Manager Endorsement', UNISTR('\0627\0639\062A\0645\0627\062F \0645\062F\064A\0631 \0639\0645\0644\064A\0627\062A \0627\0644\062D\0633\0627\0628\0627\062A \0627\0644\062F\0627\0626\0646\0629'),
                 'ROLE_BASED', v_r_apops);
        add_step(p_tmpl_id, 40, 'Finance Director Endorsement', UNISTR('\0627\0639\062A\0645\0627\062F \0645\062F\064A\0631 \0625\062F\0627\0631\0629 \0627\0644\0645\0627\0644\064A\0629'),
                 'ROLE_BASED', v_r_findir);
        add_step(p_tmpl_id, 50, 'Organization Development Head Endorsement', UNISTR('\0627\0639\062A\0645\0627\062F \0631\0626\064A\0633 \0627\0644\062A\0637\0648\064A\0631 \0627\0644\0645\0624\0633\0633\064A'),
                 'ROLE_BASED', v_r_odh, 'CUSTOM', 'FL_DURATION_GE_6M');
        add_step(p_tmpl_id, 60, 'TA Manager Endorsement', UNISTR('\0627\0639\062A\0645\0627\062F \0645\062F\064A\0631 \0627\0633\062A\0642\0637\0627\0628 \0627\0644\0645\0648\0627\0647\0628'),
                 'ROLE_BASED', v_r_tam);
        add_step(p_tmpl_id, 70, 'HR Director Approval', UNISTR('\0645\0648\0627\0641\0642\0629 \0645\062F\064A\0631 \0625\062F\0627\0631\0629 \0627\0644\0645\0648\0627\0631\062F \0627\0644\0628\0634\0631\064A\0629'),
                 'ROLE_BASED', v_r_hrd);
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'FREELANCERS';
    SELECT role_id INTO v_r_finbp  FROM prod.dct_roles WHERE role_code = 'FL_FIN_BP';
    SELECT role_id INTO v_r_apops  FROM prod.dct_roles WHERE role_code = 'FL_AP_OPS_MGR';
    SELECT role_id INTO v_r_findir FROM prod.dct_roles WHERE role_code = 'FIN_DIRECTOR';
    SELECT role_id INTO v_r_odh    FROM prod.dct_roles WHERE role_code = 'ORG_DEV_HEAD';
    SELECT role_id INTO v_r_tam    FROM prod.dct_roles WHERE role_code = 'TA_MANAGER';
    SELECT role_id INTO v_r_hrd    FROM prod.dct_roles WHERE role_code = 'HR_DIRECTOR';

    upsert_template('FL_CONTRACT_APPROVAL', 'Freelancer Contract Approval', 'CONTRACT',
        'Legal Affairs termsheet chain: LM, FBP (scoped), AP Ops, Finance Director, Org Dev Head (6 months or longer), TA Manager, HR Director.',
        v_tmpl_id);
    build_chain(v_tmpl_id);

    upsert_template('FL_AMENDMENT_APPROVAL', 'Contract Amendment Approval', 'AMENDMENT',
        'Same termsheet chain as contracts (Phase 2, D7).', v_tmpl_id);
    build_chain(v_tmpl_id);

    upsert_template('FL_RENEWAL_APPROVAL', 'Contract Renewal Approval', 'RENEWAL',
        'Same termsheet chain as contracts (Phase 2, D7).', v_tmpl_id);
    build_chain(v_tmpl_id);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Approval chains rebuilt: FL_CONTRACT_APPROVAL, FL_AMENDMENT_APPROVAL, FL_RENEWAL_APPROVAL (7 steps each)');
END;
/

PROMPT === 26_fl_contract_phase2_seed.sql complete ===
