-- =============================================================================
-- Credit Cards Module (App 202) — Phase 2.2 Unified-Structure Adoption
-- File    : 08_cc_unified_adoption.sql
-- Schema  : PROD (all objects fully prefixed — do NOT run under
--           ALTER SESSION SET CURRENT_SCHEMA=PROD)
-- Run     : after db/v2/15_dct_unified_structures.sql
--           then re-run 02_cc_views.sql and 04_cc_pkg.sql
--
-- What this does (assessment-3/phase2/00-phase2-plan.md §2.2):
--   1. Lookup-first: drops every status/type CHECK constraint on CC tables
--      (all CC transactional tables verified EMPTY) and seeds the value sets
--      as CC_* lookup categories manageable from Admin > Lookups.
--   2. Card status model simplifies to ACTIVE | INACTIVE | CLOSED
--      (default INACTIVE). The *_IN_PROGRESS pseudo-statuses are retired —
--      "pending operation" is derived from open dct_cc_requests in DCT_CC_CARD_V.
--   3. Drops the empty superseded tables replaced by the unified structures:
--        dct_cc_attachments      → dct_documents
--        dct_cc_reimb_lines      → dct_budget_coding_lines (source_type CC_REPL)
--        dct_cc_doc_requirements → dct_doc_requirements    (source_module CC)
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON

PROMPT === [1/4] Drop status/type CHECK constraints (lookup-first rule) ===

DECLARE
    PROCEDURE drop_check (p_table VARCHAR2, p_constraint VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE prod.' || p_table || ' DROP CONSTRAINT ' || p_constraint;
        DBMS_OUTPUT.PUT_LINE('Dropped ' || p_table || '.' || p_constraint);
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE NOT IN (-2443, -942) THEN RAISE; END IF;  -- already gone / no table
    END;
BEGIN
    drop_check('dct_credit_cards',          'chk_dct_cc_status');
    drop_check('dct_cc_requests',           'chk_dct_ccr_status');
    drop_check('dct_cc_requests',           'chk_dct_ccr_type');
    drop_check('dct_cc_requests',           'chk_dct_ccr_repl_rsn');
    drop_check('dct_cc_replenishments',     'chk_dct_ccreimb_status');
    drop_check('dct_cc_replenishments',     'chk_dct_ccreimb_coding');
    drop_check('dct_cc_card_limit_history', 'chk_dct_cclh_type');
END;
/

ALTER TABLE prod.dct_credit_cards MODIFY (status DEFAULT 'INACTIVE');

PROMPT === [2/4] Seed CC lookup categories (Admin > Lookups manageable) ===

DECLARE
    v_module_id NUMBER;
    v_cat       NUMBER;

    PROCEDURE upsert_category (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
    BEGIN
        MERGE INTO prod.dct_lookup_categories t
        USING (SELECT p_code AS category_code FROM dual) s
        ON (t.category_code = s.category_code)
        WHEN NOT MATCHED THEN
            INSERT (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
            VALUES (p_code, p_en, p_ar, v_module_id, 'Y', 'Y')
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
    SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'CREDIT_CARDS';

    upsert_category('CC_CARD_STATUS', 'Credit Card Status', 'حالة البطاقة', v_cat);
    upsert_value(v_cat, 'ACTIVE',   'Active',   'نشطة',  10);
    upsert_value(v_cat, 'INACTIVE', 'Inactive', 'غير نشطة', 20, 'Y');
    upsert_value(v_cat, 'CLOSED',   'Closed',   'مغلقة', 30);

    upsert_category('CC_REQUEST_STATUS', 'Card Request Status', 'حالة طلب البطاقة', v_cat);
    upsert_value(v_cat, 'DRAFT',        'Draft',                   'مسودة',        10, 'Y');
    upsert_value(v_cat, 'SUBMITTED',    'Submitted',               'مقدم',         20);
    upsert_value(v_cat, 'UNDER_REVIEW', 'Under Review',            'قيد المراجعة', 30);
    upsert_value(v_cat, 'RETURNED',     'Returned for Correction', 'معاد للتصحيح', 40);
    upsert_value(v_cat, 'APPROVED',     'Approved',                'معتمد',        50);
    upsert_value(v_cat, 'REJECTED',     'Rejected',                'مرفوض',        60);
    upsert_value(v_cat, 'WITHDRAWN',    'Withdrawn',               'مسحوب',        70);

    upsert_category('CC_REPL_STATUS', 'Replenishment Status', 'حالة التغذية الشهرية', v_cat);
    upsert_value(v_cat, 'DRAFT',        'Draft',                   'مسودة',        10, 'Y');
    upsert_value(v_cat, 'SUBMITTED',    'Submitted',               'مقدم',         20);
    upsert_value(v_cat, 'UNDER_REVIEW', 'Under Review',            'قيد المراجعة', 30);
    upsert_value(v_cat, 'RETURNED',     'Returned for Correction', 'معاد للتصحيح', 40);
    upsert_value(v_cat, 'APPROVED',     'Approved',                'معتمد',        50);
    upsert_value(v_cat, 'REJECTED',     'Rejected',                'مرفوض',        60);

    upsert_category('CC_REQUEST_TYPE', 'Card Request Type', 'نوع طلب البطاقة', v_cat);
    upsert_value(v_cat, 'NEW_CARD',       'New Card',       'بطاقة جديدة',   10);
    upsert_value(v_cat, 'INCREASE_LIMIT', 'Increase Limit', 'زيادة الحد',    20);
    upsert_value(v_cat, 'DECREASE_LIMIT', 'Decrease Limit', 'تخفيض الحد',    30);
    upsert_value(v_cat, 'CLOSE_CARD',     'Close Card',     'إغلاق البطاقة', 40);
    upsert_value(v_cat, 'REPLACEMENT',    'Replacement',    'استبدال',       50);

    upsert_category('CC_REPLACEMENT_REASON', 'Card Replacement Reason', 'سبب استبدال البطاقة', v_cat);
    upsert_value(v_cat, 'DAMAGED',  'Damaged',  'تالفة',            10);
    upsert_value(v_cat, 'LOST',     'Lost',     'مفقودة',           20);
    upsert_value(v_cat, 'EXPIRING', 'Expiring', 'قاربت على الانتهاء', 30);
    upsert_value(v_cat, 'OTHER',    'Other',    'أخرى',             90);

    upsert_category('CC_LIMIT_CHANGE_TYPE', 'Card Limit Change Type', 'نوع تغيير الحد', v_cat);
    upsert_value(v_cat, 'INITIAL',  'Initial Limit', 'الحد الأولي', 10);
    upsert_value(v_cat, 'INCREASE', 'Increase',      'زيادة',       20);
    upsert_value(v_cat, 'DECREASE', 'Decrease',      'تخفيض',       30);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('CC lookup categories seeded: CC_CARD_STATUS, CC_REQUEST_STATUS, CC_REPL_STATUS, CC_REQUEST_TYPE, CC_REPLACEMENT_REASON, CC_LIMIT_CHANGE_TYPE');
END;
/

PROMPT === [3/4] Drop empty superseded tables ===

DECLARE
    PROCEDURE drop_if_empty (p_name VARCHAR2) IS
        v_n NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM prod.' || p_name INTO v_n;
        IF v_n > 0 THEN
            RAISE_APPLICATION_ERROR(-20151,
                'ABORT: ' || p_name || ' contains ' || v_n || ' row(s) — drop assumed empty table.');
        END IF;
        EXECUTE IMMEDIATE 'DROP TABLE prod.' || p_name || ' CASCADE CONSTRAINTS PURGE';
        DBMS_OUTPUT.PUT_LINE('Dropped ' || p_name);
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE != -942 THEN RAISE; END IF;
    END;

    PROCEDURE drop_synonym (p_name VARCHAR2) IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n FROM user_synonyms WHERE synonym_name = UPPER(p_name);
        IF v_n > 0 THEN
            EXECUTE IMMEDIATE 'DROP SYNONYM ' || p_name;
            DBMS_OUTPUT.PUT_LINE('Dropped dangling synonym ' || p_name);
        END IF;
    END;
    -- dct_cc_doc_requirements holds 11 SEED rows (config, not transactions).
    -- Safe to drop once the unified table carries at least as many CC rows.
    PROCEDURE drop_if_migrated (p_name VARCHAR2) IS
        v_old NUMBER;
        v_new NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM prod.' || p_name INTO v_old;
        SELECT COUNT(*) INTO v_new FROM prod.dct_doc_requirements WHERE source_module = 'CC';
        IF v_new < v_old THEN
            RAISE_APPLICATION_ERROR(-20152,
                'ABORT: unified dct_doc_requirements has ' || v_new ||
                ' CC rows but ' || p_name || ' has ' || v_old || ' — migrate first.');
        END IF;
        EXECUTE IMMEDIATE 'DROP TABLE prod.' || p_name || ' CASCADE CONSTRAINTS PURGE';
        DBMS_OUTPUT.PUT_LINE('Dropped ' || p_name || ' (' || v_old || ' seed rows superseded by unified table)');
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE != -942 THEN RAISE; END IF;
    END;
BEGIN
    drop_if_empty('dct_cc_attachments');          -- → dct_documents
    drop_if_empty('dct_cc_reimb_lines');          -- → dct_budget_coding_lines
    drop_if_migrated('dct_cc_doc_requirements');  -- → dct_doc_requirements (seed rows re-seeded there)
    drop_synonym('dct_cc_attachments');
    drop_synonym('dct_cc_reimb_lines');
    drop_synonym('dct_cc_doc_requirements');
END;
/

PROMPT === [4/4] ADMIN synonyms for remaining CC tables (future CC ORDS module) ===

CREATE OR REPLACE SYNONYM dct_credit_cards          FOR prod.dct_credit_cards;
CREATE OR REPLACE SYNONYM dct_cc_requests           FOR prod.dct_cc_requests;
CREATE OR REPLACE SYNONYM dct_cc_replenishments     FOR prod.dct_cc_replenishments;
CREATE OR REPLACE SYNONYM dct_cc_proxies            FOR prod.dct_cc_proxies;
CREATE OR REPLACE SYNONYM dct_cc_card_limit_history FOR prod.dct_cc_card_limit_history;
CREATE OR REPLACE SYNONYM dct_cc_pkg                FOR prod.dct_cc_pkg;

PROMPT
PROMPT === 08_cc_unified_adoption.sql complete ===
PROMPT - Status/type CHECKs dropped; 6 CC_* lookup categories seeded
PROMPT - Card status model: ACTIVE | INACTIVE | CLOSED (default INACTIVE)
PROMPT - Dropped: DCT_CC_ATTACHMENTS, DCT_CC_REIMB_LINES, DCT_CC_DOC_REQUIREMENTS
PROMPT Next: re-run 02_cc_views.sql then 04_cc_pkg.sql
