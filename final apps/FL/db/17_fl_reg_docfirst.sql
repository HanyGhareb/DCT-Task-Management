-- =============================================================================
-- Freelancers Module (App 203) -- Phase 1 -- Documents-first intake support
-- File    : 17_fl_reg_docfirst.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @17_fl_reg_docfirst.sql  (any session)
-- Purpose : The public self-registration wizard now lets an applicant upload
--           the Passport / Emirates ID / Bank Letter FIRST (AI auto-fills the
--           form) before the detail fields are typed. A document upload needs a
--           registration_id, so an empty DRAFT must be creatable straight after
--           OTP -- which requires the four identity columns to allow NULL while
--           the row is still a DRAFT. Required-field enforcement is unchanged:
--           the detail PUT and DCT_FL_PKG.SUBMIT_REGISTRATION both still reject
--           an incomplete row, so a row can never reach approval with nulls.
-- Idempotent: only relaxes a column that is still NOT NULL.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

DECLARE
    PROCEDURE relax (p_col IN VARCHAR2) IS
        v_nullable VARCHAR2(1);
    BEGIN
        SELECT nullable INTO v_nullable
        FROM   all_tab_columns
        WHERE  owner = 'PROD' AND table_name = 'DCT_FL_REGISTRATIONS'
        AND    column_name = p_col;
        IF v_nullable = 'N' THEN
            EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_fl_registrations MODIFY ('
                              || p_col || ' NULL)';
            DBMS_OUTPUT.PUT_LINE(p_col || ' -> NULL');
        ELSE
            DBMS_OUTPUT.PUT_LINE(p_col || ' already nullable');
        END IF;
    END relax;
BEGIN
    relax('FIRST_NAME_EN');
    relax('LAST_NAME_EN');
    relax('DATE_OF_BIRTH');
    relax('NATIONALITY_CODE');
END;
/

PROMPT === 17_fl_reg_docfirst.sql complete ===
