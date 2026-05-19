-- =================================================================
-- Phase 1: AI-Assisted Clearing & Reimbursement — Database Schema
-- App: f101 Petty Cash
-- Run as ADMIN; all objects in PROD schema
-- =================================================================

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

-- -----------------------------------------------------------------
-- 1. Extend DCT_PC_CLEAR_BUDGET_LINES with AI expense detail fields
--    (existing columns: LINE_ID, CLEARING_ID, LINE_NUM, AMOUNT,
--     CC_ID, PROJECT_NUMBER, TASK_NUMBER, EXPENDITURE_TYPE, DESCRIPTION)
-- -----------------------------------------------------------------
ALTER TABLE PROD.DCT_PC_CLEAR_BUDGET_LINES ADD (
    ITEM_NAME          VARCHAR2(500),
    CATEGORY           VARCHAR2(100),
    EXPENSE_DATE       DATE,
    VENDOR_NAME        VARCHAR2(500),
    REFERENCE_NUMBER   VARCHAR2(200),
    CURRENCY           VARCHAR2(10)   DEFAULT 'AED',
    VALIDATION_STATUS  VARCHAR2(20)   DEFAULT 'PENDING',
    VALIDATION_ERRORS  VARCHAR2(1000),
    IS_AI_EXTRACTED    VARCHAR2(1)    DEFAULT 'N',
    IS_INCLUDED        VARCHAR2(1)    DEFAULT 'Y',
    AI_CONFIDENCE      NUMBER(3)
);

ALTER TABLE PROD.DCT_PC_CLEAR_BUDGET_LINES ADD CONSTRAINT chk_clr_val_status
    CHECK (VALIDATION_STATUS IN ('PENDING','VALID','INVALID','NEEDS_REVIEW'));

ALTER TABLE PROD.DCT_PC_CLEAR_BUDGET_LINES ADD CONSTRAINT chk_clr_ai_extracted
    CHECK (IS_AI_EXTRACTED IN ('Y','N'));

ALTER TABLE PROD.DCT_PC_CLEAR_BUDGET_LINES ADD CONSTRAINT chk_clr_is_included
    CHECK (IS_INCLUDED IN ('Y','N'));

-- -----------------------------------------------------------------
-- 2. Extend DCT_PC_REIMB_BUDGET_LINES with the same fields
--    (existing columns: LINE_ID, REIMB_ID, LINE_NUM, AMOUNT,
--     CC_ID, PROJECT_NUMBER, TASK_NUMBER, EXPENDITURE_TYPE, DESCRIPTION)
-- -----------------------------------------------------------------
ALTER TABLE PROD.DCT_PC_REIMB_BUDGET_LINES ADD (
    ITEM_NAME          VARCHAR2(500),
    CATEGORY           VARCHAR2(100),
    EXPENSE_DATE       DATE,
    VENDOR_NAME        VARCHAR2(500),
    REFERENCE_NUMBER   VARCHAR2(200),
    CURRENCY           VARCHAR2(10)   DEFAULT 'AED',
    VALIDATION_STATUS  VARCHAR2(20)   DEFAULT 'PENDING',
    VALIDATION_ERRORS  VARCHAR2(1000),
    IS_AI_EXTRACTED    VARCHAR2(1)    DEFAULT 'N',
    IS_INCLUDED        VARCHAR2(1)    DEFAULT 'Y',
    AI_CONFIDENCE      NUMBER(3)
);

ALTER TABLE PROD.DCT_PC_REIMB_BUDGET_LINES ADD CONSTRAINT chk_reimb_val_status
    CHECK (VALIDATION_STATUS IN ('PENDING','VALID','INVALID','NEEDS_REVIEW'));

ALTER TABLE PROD.DCT_PC_REIMB_BUDGET_LINES ADD CONSTRAINT chk_reimb_ai_extracted
    CHECK (IS_AI_EXTRACTED IN ('Y','N'));

ALTER TABLE PROD.DCT_PC_REIMB_BUDGET_LINES ADD CONSTRAINT chk_reimb_is_included
    CHECK (IS_INCLUDED IN ('Y','N'));

-- -----------------------------------------------------------------
-- 3. Reference number registry — company-wide deduplication
--    Stores (reference_number, vendor_name) of every accepted line.
--    Function-based unique index handles NULL vendor_name safely
--    since Oracle treats NULLs as non-equal in standard UNIQUE.
-- -----------------------------------------------------------------
CREATE TABLE PROD.DCT_PC_USED_REFERENCES (
    REF_ID            NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    REFERENCE_NUMBER  VARCHAR2(200)  NOT NULL,
    VENDOR_NAME       VARCHAR2(500),
    REQUEST_TYPE      VARCHAR2(10)   NOT NULL,
    REQUEST_ID        NUMBER         NOT NULL,
    LINE_ID           NUMBER,
    EMPLOYEE_NUM      VARCHAR2(50),
    REGISTERED_AT     TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT chk_ref_req_type CHECK (REQUEST_TYPE IN ('CLEARING','REIMB'))
);

CREATE UNIQUE INDEX PROD.uq_pch_ref_vendor
    ON PROD.DCT_PC_USED_REFERENCES (REFERENCE_NUMBER, NVL(VENDOR_NAME,'~~NULL~~'));

CREATE INDEX PROD.idx_pch_used_refs_num
    ON PROD.DCT_PC_USED_REFERENCES (REFERENCE_NUMBER);

-- -----------------------------------------------------------------
-- 4. AI extraction audit log
--    One row per uploaded file per extraction attempt.
--    Full Anthropic API response stored for compliance/debugging.
-- -----------------------------------------------------------------
CREATE TABLE PROD.DCT_PC_AI_EXTRACT_LOG (
    LOG_ID            NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    REQUEST_TYPE      VARCHAR2(10),
    REQUEST_ID        NUMBER,
    FILE_NAME         VARCHAR2(500),
    MIME_TYPE         VARCHAR2(100),
    LINES_EXTRACTED   NUMBER         DEFAULT 0,
    LINES_VALID       NUMBER         DEFAULT 0,
    LINES_INVALID     NUMBER         DEFAULT 0,
    AI_MODEL          VARCHAR2(100),
    AI_RAW_RESPONSE   CLOB,
    ERROR_MESSAGE     VARCHAR2(4000),
    EXTRACTED_BY      VARCHAR2(100),
    EXTRACTED_AT      TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT chk_log_req_type CHECK (REQUEST_TYPE IN ('CLEARING','REIMB'))
);

-- -----------------------------------------------------------------
-- 5. Add AI summary columns to request header tables
--    Gives the header a quick view of extraction state
-- -----------------------------------------------------------------
ALTER TABLE PROD.DCT_PC_CLEARING ADD (
    AI_LAST_EXTRACTED_AT  TIMESTAMP,
    AI_TOTAL_LINES        NUMBER  DEFAULT 0,
    AI_VALID_LINES        NUMBER  DEFAULT 0
);

ALTER TABLE PROD.DCT_PC_REIMBURSEMENTS ADD (
    AI_LAST_EXTRACTED_AT  TIMESTAMP,
    AI_TOTAL_LINES        NUMBER  DEFAULT 0,
    AI_VALID_LINES        NUMBER  DEFAULT 0
);

COMMIT;

PROMPT Phase 1 complete.
