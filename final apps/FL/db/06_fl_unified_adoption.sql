-- =============================================================================
-- Freelancers Module (App 203) — Phase 2.3 Unified-Structure Adoption
-- File    : 06_fl_unified_adoption.sql
-- Schema  : PROD (all objects fully prefixed — do NOT run under
--           ALTER SESSION SET CURRENT_SCHEMA=PROD)
-- Run     : after db/v2/15_dct_unified_structures.sql
--           then re-run 02_fl_views.sql and 04_fl_pkg.sql
--
-- What this does (assessment-3/phase2/00-phase2-plan.md §2.3):
--   1. Extends the DOC_SOURCE_TYPE lookup with the FL-specific contexts
--      (REGISTRATION, DELIVERABLE, VOUCHER).
--   2. Deactivates the FL_DOCUMENT_TYPE lookup category — FL document types
--      now live in DCT_DOCUMENT_TYPES (TRADE_LICENSE / QUALIFICATION /
--      DELIVERABLE_DOC added there by db/v2/15; VISA→RESIDENCE_VISA,
--      CONTRACT_COPY→CONTRACT map to existing types).
--   3. Drops the EMPTY superseded tables:
--        dct_fl_doc_expiry_alerts → dct_doc_expiry_alerts
--        dct_fl_documents         → dct_documents (source_module='FL',
--                                   reference_id = freelancer_id)
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON

PROMPT === [1/3] Extend DOC_SOURCE_TYPE lookup with FL contexts ===

DECLARE
    v_cat NUMBER;

    PROCEDURE upsert_value (p_code VARCHAR2, p_en VARCHAR2, p_ord NUMBER) IS
    BEGIN
        MERGE INTO prod.dct_lookup_values t
        USING (SELECT v_cat AS category_id, p_code AS value_code FROM dual) s
        ON (t.category_id = s.category_id AND t.value_code = s.value_code)
        WHEN NOT MATCHED THEN
            INSERT (category_id, value_code, value_name_en, display_order, is_active)
            VALUES (v_cat, p_code, p_en, p_ord, 'Y');
    END;
BEGIN
    SELECT category_id INTO v_cat
    FROM   prod.dct_lookup_categories WHERE category_code = 'DOC_SOURCE_TYPE';

    upsert_value('REGISTRATION', 'Registration',  45);
    upsert_value('DELIVERABLE',  'Deliverable',   55);
    upsert_value('VOUCHER',      'Payment Voucher', 65);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('DOC_SOURCE_TYPE extended: REGISTRATION, DELIVERABLE, VOUCHER');
END;
/

PROMPT === [2/3] Deactivate FL_DOCUMENT_TYPE lookup (superseded by DCT_DOCUMENT_TYPES) ===

UPDATE prod.dct_lookup_categories
SET    is_active = 'N',
       updated_at = SYSTIMESTAMP
WHERE  category_code = 'FL_DOCUMENT_TYPE';
COMMIT;

PROMPT === [3/3] Drop empty superseded tables ===

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
BEGIN
    drop_if_empty('dct_fl_doc_expiry_alerts');  -- → dct_doc_expiry_alerts (FK child first)
    drop_if_empty('dct_fl_documents');          -- → dct_documents
    drop_synonym('dct_fl_doc_expiry_alerts');
    drop_synonym('dct_fl_documents');
END;
/

PROMPT
PROMPT === 06_fl_unified_adoption.sql complete ===
PROMPT - DOC_SOURCE_TYPE lookup extended with FL contexts
PROMPT - FL_DOCUMENT_TYPE lookup deactivated (use DCT_DOCUMENT_TYPES)
PROMPT - Dropped: DCT_FL_DOC_EXPIRY_ALERTS, DCT_FL_DOCUMENTS
PROMPT Next: re-run 02_fl_views.sql then 04_fl_pkg.sql
