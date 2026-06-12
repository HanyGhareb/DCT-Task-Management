-- =============================================================================
-- i-Finance V2 — Accounts Receivable / Revenue Assurance Module DDL
-- File    : 01_ar_ddl.sql
-- Schema  : PROD
-- DB      : Oracle 23ai (ADB)
-- Prefix  : DCT_AR_
-- Module  : Accounts Receivable (App 206) — Event P&L Analysis
-- =============================================================================
-- Tables (in dependency order):
--   1.  DCT_AR_DOC_CATEGORIES   — admin-managed document categories + AI rules
--   2.  DCT_AR_PNL_CATEGORIES   — admin-managed P&L item categories
--   3.  DCT_AR_EVENTS           — event master
--   4.  DCT_AR_EVENT_FILES      — uploaded files (BLOB lives here, dedicated)
--   5.  DCT_AR_CATEGORY_MAP     — raw label → category learning map
--   6.  DCT_AR_PNL_LINES        — extracted/manual P&L fact lines
--   7.  DCT_AR_EVENT_FINDINGS   — audit observations / potential loss
--   8.  DCT_AR_EVENT_KPIS       — non-P&L event metrics (footfall, tickets …)
--   9.  DCT_AR_EXTRACT_LOG      — AI call audit
--   10. DCT_AR_SCENARIOS        — what-if scenarios
--   11. DCT_AR_SCENARIO_ADJ     — what-if adjustments
-- =============================================================================
-- Lookup-first: status/enum columns validated via DCT_LOOKUP_PKG (no CHECKs),
-- categories seeded in 02_ar_seed.sql:
--   AR_EVENT_TYPE, AR_EVENT_STATUS, AR_CLASS_STATUS, AR_EXTRACT_STATUS,
--   AR_LINE_TYPE, AR_PNL_BASIS, AR_REVIEW_STATUS, AR_CATEGORY_TYPE,
--   AR_ADJ_TYPE, AR_KPI_CODE
-- Prerequisites: DCT_ORGANIZATIONS, DCT_USERS, DCT_CURRENCY_CODES,
--   DCT_LOOKUP_VALUES (run db/v2/install.sql + 12 + 15 first)
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- SAFE DROP (reverse dependency order)
-- =============================================================================
BEGIN
    FOR t IN (
        SELECT table_name FROM all_tables
        WHERE  owner = 'PROD'
        AND    table_name IN (
                 'DCT_AR_SCENARIO_ADJ',
                 'DCT_AR_SCENARIOS',
                 'DCT_AR_EXTRACT_LOG',
                 'DCT_AR_EVENT_KPIS',
                 'DCT_AR_EVENT_FINDINGS',
                 'DCT_AR_PNL_LINES',
                 'DCT_AR_CATEGORY_MAP',
                 'DCT_AR_EVENT_FILES',
                 'DCT_AR_EVENTS',
                 'DCT_AR_PNL_CATEGORIES',
                 'DCT_AR_DOC_CATEGORIES'
               )
    ) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE prod.' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
        DBMS_OUTPUT.PUT_LINE('Dropped: ' || t.table_name);
    END LOOP;
END;
/

-- =============================================================================
-- 1. DCT_AR_DOC_CATEGORIES
--    Admin-managed document categories. description feeds the AI classification
--    prompt. Extraction-mode flags drive what extract_file() asks for.
-- =============================================================================
CREATE TABLE dct_ar_doc_categories (
    doc_cat_id          NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    doc_cat_code        VARCHAR2(50)    NOT NULL,
    doc_cat_name_en     VARCHAR2(200)   NOT NULL,
    doc_cat_name_ar     VARCHAR2(200),
    description         VARCHAR2(1000),                        -- fed to AI classify prompt
    is_pnl_source       VARCHAR2(1)     DEFAULT 'N' NOT NULL,  -- trusted P&L source (workbook Y/N)
    pnl_basis           VARCHAR2(20),                          -- lookup AR_PNL_BASIS (ACTUAL|BUDGET|FORECAST)
    extract_lines       VARCHAR2(1)     DEFAULT 'N' NOT NULL,  -- P&L line items
    extract_kpis        VARCHAR2(1)     DEFAULT 'N' NOT NULL,  -- event KPIs (post-event reports)
    extract_findings    VARCHAR2(1)     DEFAULT 'N' NOT NULL,  -- audit findings
    extract_event_meta  VARCHAR2(1)     DEFAULT 'N' NOT NULL,  -- event header prefill (contracts)
    extraction_hints    VARCHAR2(1000),                        -- appended to AI extract prompt
    required_for_event_types VARCHAR2(200),                    -- pipe-sep AR_EVENT_TYPE codes (completeness)
    display_order       NUMBER          DEFAULT 0,
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_ardc_code     UNIQUE (doc_cat_code),
    CONSTRAINT chk_dct_ardc_active  CHECK  (is_active        IN ('Y','N')),
    CONSTRAINT chk_dct_ardc_pnlsrc  CHECK  (is_pnl_source    IN ('Y','N')),
    CONSTRAINT chk_dct_ardc_exl     CHECK  (extract_lines    IN ('Y','N')),
    CONSTRAINT chk_dct_ardc_exk     CHECK  (extract_kpis     IN ('Y','N')),
    CONSTRAINT chk_dct_ardc_exf     CHECK  (extract_findings IN ('Y','N')),
    CONSTRAINT chk_dct_ardc_exm     CHECK  (extract_event_meta IN ('Y','N'))
);

CREATE INDEX ix_dct_ardc_active ON dct_ar_doc_categories(is_active, display_order);

-- =============================================================================
-- 2. DCT_AR_PNL_CATEGORIES
--    Admin-managed P&L item categories (name, type, description per user story).
--    description feeds the AI extraction prompt for item→category mapping.
-- =============================================================================
CREATE TABLE dct_ar_pnl_categories (
    category_id         NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_code       VARCHAR2(50)    NOT NULL,
    category_name_en    VARCHAR2(200)   NOT NULL,
    category_name_ar    VARCHAR2(200),
    category_type       VARCHAR2(20)    NOT NULL,              -- lookup AR_CATEGORY_TYPE (EXPENSE|REVENUE|BOTH)
    description         VARCHAR2(1000),                        -- fed to AI extract prompt
    display_order       NUMBER          DEFAULT 0,
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_arpc_code    UNIQUE (category_code),
    CONSTRAINT chk_dct_arpc_active CHECK  (is_active IN ('Y','N'))
);

CREATE INDEX ix_dct_arpc_type ON dct_ar_pnl_categories(category_type, is_active, display_order);

-- =============================================================================
-- 3. DCT_AR_EVENTS
--    Event master. Status transitions are logged to the shared
--    DCT_REQUEST_STATUS_HISTORY (source_module='AR', source_type='EVENT').
-- =============================================================================
CREATE TABLE dct_ar_events (
    event_id            NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_code          VARCHAR2(50)    NOT NULL,              -- EVT-2026-001
    event_name_en       VARCHAR2(300)   NOT NULL,
    event_name_ar       VARCHAR2(300),
    event_type          VARCHAR2(30),                          -- lookup AR_EVENT_TYPE
    venue               VARCHAR2(300),
    organizer_name      VARCHAR2(300),
    contract_number     VARCHAR2(100),
    start_date          DATE,
    end_date            DATE,
    expected_attendance NUMBER,
    actual_attendance   NUMBER,
    dct_revenue_share_pct NUMBER(5,2),                         -- ticket-revenue split % to DCT
    org_id              NUMBER,                                -- FK → DCT_ORGANIZATIONS
    owner_user_id       NUMBER,                                -- FK → DCT_USERS (responsible AR user)
    currency_code       VARCHAR2(3)     DEFAULT 'AED',         -- FK → DCT_CURRENCY_CODES
    status              VARCHAR2(30)    DEFAULT 'NEW' NOT NULL,-- lookup AR_EVENT_STATUS
    description         VARCHAR2(2000),
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_arev_code    UNIQUE (event_code),
    CONSTRAINT chk_dct_arev_active CHECK  (is_active IN ('Y','N')),
    CONSTRAINT fk_dct_arev_org     FOREIGN KEY (org_id)        REFERENCES dct_organizations(org_id),
    CONSTRAINT fk_dct_arev_owner   FOREIGN KEY (owner_user_id) REFERENCES dct_users(user_id),
    CONSTRAINT fk_dct_arev_curr    FOREIGN KEY (currency_code) REFERENCES dct_currency_codes(currency_code)
);

CREATE INDEX ix_dct_arev_status ON dct_ar_events(status, is_active);
CREATE INDEX ix_dct_arev_type   ON dct_ar_events(event_type);
CREATE INDEX ix_dct_arev_dates  ON dct_ar_events(start_date, end_date);
CREATE INDEX ix_dct_arev_owner  ON dct_ar_events(owner_user_id);

-- =============================================================================
-- 4. DCT_AR_EVENT_FILES
--    One row per uploaded file. The binary lives HERE (dedicated table — high
--    volume expected; deliberately not the shared DCT_DOCUMENTS).
--    content_text = client-extracted text rendition (XLSX/DOCX/EML/MSG/PPTX)
--    used as the AI input for formats Claude cannot ingest natively.
-- =============================================================================
CREATE TABLE dct_ar_event_files (
    file_id             NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id            NUMBER          NOT NULL,
    folder_path         VARCHAR2(1000),                        -- relative sub-folder ('' = root)
    original_file_name  VARCHAR2(500)   NOT NULL,
    alt_file_name       VARCHAR2(600),                         -- generated per ALT_FILE_NAME_FORMAT
    file_ext            VARCHAR2(20),
    mime_type           VARCHAR2(100),
    file_size_bytes     NUMBER,
    file_blob           BLOB,
    content_text        CLOB,
    file_hash           VARCHAR2(64),                          -- SHA-256 (duplicate detection)
    classification_status VARCHAR2(20)  DEFAULT 'PENDING' NOT NULL, -- lookup AR_CLASS_STATUS
    ai_doc_cat_id       NUMBER,                                -- AI suggestion
    ai_confidence       NUMBER(3),
    ai_reason           VARCHAR2(1000),
    doc_cat_id          NUMBER,                                -- confirmed category
    extraction_status   VARCHAR2(20)    DEFAULT 'NOT_APPLICABLE' NOT NULL, -- lookup AR_EXTRACT_STATUS
    lines_extracted     NUMBER          DEFAULT 0,
    error_message       VARCHAR2(2000),
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_arf_active CHECK (is_active IN ('Y','N')),
    CONSTRAINT fk_dct_arf_event   FOREIGN KEY (event_id)      REFERENCES dct_ar_events(event_id) ON DELETE CASCADE,
    CONSTRAINT fk_dct_arf_aicat   FOREIGN KEY (ai_doc_cat_id) REFERENCES dct_ar_doc_categories(doc_cat_id),
    CONSTRAINT fk_dct_arf_cat     FOREIGN KEY (doc_cat_id)    REFERENCES dct_ar_doc_categories(doc_cat_id)
) LOB (file_blob) STORE AS SECUREFILE (
    ENABLE STORAGE IN ROW
    COMPRESS MEDIUM
);

CREATE INDEX ix_dct_arf_event  ON dct_ar_event_files(event_id, is_active);
CREATE INDEX ix_dct_arf_class  ON dct_ar_event_files(classification_status);
CREATE INDEX ix_dct_arf_extr   ON dct_ar_event_files(extraction_status);
CREATE INDEX ix_dct_arf_hash   ON dct_ar_event_files(event_id, file_hash);
CREATE INDEX ix_dct_arf_cat    ON dct_ar_event_files(doc_cat_id);

-- =============================================================================
-- 5. DCT_AR_CATEGORY_MAP
--    Self-learning map: verbatim labels seen in documents → P&L category.
--    Populated from user corrections in the review screen (source=USER) and
--    high-confidence AI mappings (source=AI). Fed back into the AI prompt.
-- =============================================================================
CREATE TABLE dct_ar_category_map (
    map_id              NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    raw_text            VARCHAR2(500)   NOT NULL,              -- normalized UPPER(TRIM(..))
    line_type           VARCHAR2(20)    NOT NULL,              -- lookup AR_LINE_TYPE
    category_id         NUMBER          NOT NULL,
    source              VARCHAR2(10)    DEFAULT 'USER' NOT NULL, -- AI | USER
    hit_count           NUMBER          DEFAULT 1,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_armap_raw  UNIQUE (raw_text, line_type),
    CONSTRAINT chk_dct_armap_src CHECK  (source IN ('AI','USER')),
    CONSTRAINT fk_dct_armap_cat  FOREIGN KEY (category_id) REFERENCES dct_ar_pnl_categories(category_id)
);

-- =============================================================================
-- 6. DCT_AR_PNL_LINES
--    The core fact table. One row per expense/revenue item, AI-extracted or
--    manual. file_id + source_file_name give per-line source traceability.
--    amount may be NEGATIVE (VAT / ticketing-fee deduction lines).
--    reported_amount = organizer/budget figure when the doc shows both
--    (audit reports, organizer P&L detail sheets) → variance_amount virtual.
-- =============================================================================
CREATE TABLE dct_ar_pnl_lines (
    line_id             NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id            NUMBER          NOT NULL,
    file_id             NUMBER,                                -- NULL = manual line
    source_file_name    VARCHAR2(500),                         -- denormalized for display
    line_type           VARCHAR2(20)    NOT NULL,              -- lookup AR_LINE_TYPE (EXPENSE|REVENUE)
    basis               VARCHAR2(20)    DEFAULT 'ACTUAL' NOT NULL, -- lookup AR_PNL_BASIS
    item_name           VARCHAR2(500)   NOT NULL,
    category_id         NUMBER,                                -- NULL until reviewed/mapped
    raw_category        VARCHAR2(500),                         -- verbatim label from the document
    item_date           DATE,
    quantity            NUMBER,
    unit_cost           NUMBER(15,2),
    amount              NUMBER(15,2)    NOT NULL,              -- negative allowed (deductions)
    reported_amount     NUMBER(15,2),
    variance_amount     NUMBER(15,2)    GENERATED ALWAYS AS (amount - reported_amount) VIRTUAL,
    currency_code       VARCHAR2(3)     DEFAULT 'AED',
    exchange_rate       NUMBER(12,6)    DEFAULT 1 NOT NULL,
    base_amount         NUMBER(18,2)    GENERATED ALWAYS AS (ROUND(amount * exchange_rate, 2)) VIRTUAL,
    vendor_or_payer     VARCHAR2(500),
    reference_number    VARCHAR2(200),                         -- PO / invoice ref
    comments            VARCHAR2(1000),
    is_ai_extracted     VARCHAR2(1)     DEFAULT 'N' NOT NULL,
    ai_confidence       NUMBER(3),
    review_status       VARCHAR2(20)    DEFAULT 'DRAFT' NOT NULL, -- lookup AR_REVIEW_STATUS
    is_included         VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_arpl_ai   CHECK (is_ai_extracted IN ('Y','N')),
    CONSTRAINT chk_dct_arpl_inc  CHECK (is_included     IN ('Y','N')),
    CONSTRAINT fk_dct_arpl_event FOREIGN KEY (event_id)      REFERENCES dct_ar_events(event_id) ON DELETE CASCADE,
    CONSTRAINT fk_dct_arpl_file  FOREIGN KEY (file_id)       REFERENCES dct_ar_event_files(file_id) ON DELETE SET NULL,
    CONSTRAINT fk_dct_arpl_cat   FOREIGN KEY (category_id)   REFERENCES dct_ar_pnl_categories(category_id),
    CONSTRAINT fk_dct_arpl_curr  FOREIGN KEY (currency_code) REFERENCES dct_currency_codes(currency_code)
);

CREATE INDEX ix_dct_arpl_event  ON dct_ar_pnl_lines(event_id, line_type, basis);
CREATE INDEX ix_dct_arpl_cat    ON dct_ar_pnl_lines(category_id);
CREATE INDEX ix_dct_arpl_file   ON dct_ar_pnl_lines(file_id);
CREATE INDEX ix_dct_arpl_review ON dct_ar_pnl_lines(review_status, is_included);

-- =============================================================================
-- 7. DCT_AR_EVENT_FINDINGS
--    Audit observations: numbered findings + recommendation + quantified
--    potential revenue loss (per the DCT Revenue Assurance audit report format).
-- =============================================================================
CREATE TABLE dct_ar_event_findings (
    finding_id          NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id            NUMBER          NOT NULL,
    file_id             NUMBER,                                -- source document
    finding_seq         NUMBER          DEFAULT 1,
    title               VARCHAR2(500)   NOT NULL,
    observation         VARCHAR2(4000),
    recommendation      VARCHAR2(2000),
    potential_loss_amount NUMBER(15,2),
    is_ai_extracted     VARCHAR2(1)     DEFAULT 'N' NOT NULL,
    ai_confidence       NUMBER(3),
    review_status       VARCHAR2(20)    DEFAULT 'DRAFT' NOT NULL, -- lookup AR_REVIEW_STATUS
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_arfn_ai   CHECK (is_ai_extracted IN ('Y','N')),
    CONSTRAINT fk_dct_arfn_event FOREIGN KEY (event_id) REFERENCES dct_ar_events(event_id) ON DELETE CASCADE,
    CONSTRAINT fk_dct_arfn_file  FOREIGN KEY (file_id)  REFERENCES dct_ar_event_files(file_id) ON DELETE SET NULL
);

CREATE INDEX ix_dct_arfn_event ON dct_ar_event_findings(event_id, finding_seq);

-- =============================================================================
-- 8. DCT_AR_EVENT_KPIS
--    Non-P&L event metrics (post-event reports: tickets, footfall, satisfaction,
--    sponsor/vendor counts …). kpi_code is admin-extensible via AR_KPI_CODE.
-- =============================================================================
CREATE TABLE dct_ar_event_kpis (
    kpi_id              NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id            NUMBER          NOT NULL,
    file_id             NUMBER,                                -- NULL = manual entry
    kpi_code            VARCHAR2(50)    NOT NULL,              -- lookup AR_KPI_CODE
    kpi_name            VARCHAR2(200),                         -- free label when OTHER
    kpi_value           NUMBER,
    kpi_unit            VARCHAR2(30),
    kpi_text            VARCHAR2(500),                         -- non-numeric values
    is_ai_extracted     VARCHAR2(1)     DEFAULT 'N' NOT NULL,
    ai_confidence       NUMBER(3),
    review_status       VARCHAR2(20)    DEFAULT 'DRAFT' NOT NULL, -- lookup AR_REVIEW_STATUS
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_ark_ai   CHECK (is_ai_extracted IN ('Y','N')),
    CONSTRAINT fk_dct_ark_event FOREIGN KEY (event_id) REFERENCES dct_ar_events(event_id) ON DELETE CASCADE,
    CONSTRAINT fk_dct_ark_file  FOREIGN KEY (file_id)  REFERENCES dct_ar_event_files(file_id) ON DELETE SET NULL
);

CREATE INDEX ix_dct_ark_event ON dct_ar_event_kpis(event_id, kpi_code);

-- =============================================================================
-- 9. DCT_AR_EXTRACT_LOG
--    AI call audit (pattern from DCT_PC_AI_EXTRACT_LOG). Raw response retained
--    for compliance and debugging.
-- =============================================================================
CREATE TABLE dct_ar_extract_log (
    log_id              NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    file_id             NUMBER,
    action              VARCHAR2(20)    NOT NULL,              -- CLASSIFY | EXTRACT
    ai_model            VARCHAR2(100),
    ai_raw_response     CLOB,
    lines_extracted     NUMBER          DEFAULT 0,
    status              VARCHAR2(20),                          -- OK | ERROR | SKIPPED
    error_message       VARCHAR2(4000),
    duration_ms         NUMBER,
    extracted_by        VARCHAR2(100),
    extracted_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_arxl_act CHECK (action IN ('CLASSIFY','EXTRACT')),
    CONSTRAINT fk_dct_arxl_file FOREIGN KEY (file_id) REFERENCES dct_ar_event_files(file_id) ON DELETE SET NULL
);

CREATE INDEX ix_dct_arxl_file ON dct_ar_extract_log(file_id, extracted_at);

-- =============================================================================
-- 10. DCT_AR_SCENARIOS
--     Persisted what-if scenarios. event_id NULL = portfolio-level scenario.
-- =============================================================================
CREATE TABLE dct_ar_scenarios (
    scenario_id         NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id            NUMBER,
    scenario_name       VARCHAR2(200)   NOT NULL,
    description         VARCHAR2(1000),
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_arsc_active CHECK (is_active IN ('Y','N')),
    CONSTRAINT fk_dct_arsc_event   FOREIGN KEY (event_id) REFERENCES dct_ar_events(event_id) ON DELETE CASCADE
);

CREATE INDEX ix_dct_arsc_event ON dct_ar_scenarios(event_id, is_active);

-- =============================================================================
-- 11. DCT_AR_SCENARIO_ADJ
--     Scenario adjustments. category_id NULL = applies to all categories of
--     that line_type. adjustment_type: PCT (+/- %), AMOUNT (+/- abs), OVERRIDE.
-- =============================================================================
CREATE TABLE dct_ar_scenario_adj (
    adj_id              NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    scenario_id         NUMBER          NOT NULL,
    line_type           VARCHAR2(20)    NOT NULL,              -- lookup AR_LINE_TYPE
    category_id         NUMBER,                                -- NULL = all categories
    adjustment_type     VARCHAR2(20)    NOT NULL,              -- lookup AR_ADJ_TYPE
    adjustment_value    NUMBER(15,2)    NOT NULL,
    comments            VARCHAR2(500),
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT fk_dct_arsa_scen FOREIGN KEY (scenario_id) REFERENCES dct_ar_scenarios(scenario_id) ON DELETE CASCADE,
    CONSTRAINT fk_dct_arsa_cat  FOREIGN KEY (category_id) REFERENCES dct_ar_pnl_categories(category_id)
);

CREATE INDEX ix_dct_arsa_scen ON dct_ar_scenario_adj(scenario_id);

-- =============================================================================
-- UPDATE-AUDIT TRIGGERS
-- =============================================================================
CREATE OR REPLACE TRIGGER trg_dct_ardc_upd
    BEFORE UPDATE ON dct_ar_doc_categories FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_dct_arpc_upd
    BEFORE UPDATE ON dct_ar_pnl_categories FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_dct_arev_upd
    BEFORE UPDATE ON dct_ar_events FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_dct_arf_upd
    BEFORE UPDATE ON dct_ar_event_files FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_dct_armap_upd
    BEFORE UPDATE ON dct_ar_category_map FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_dct_arpl_upd
    BEFORE UPDATE ON dct_ar_pnl_lines FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_dct_arfn_upd
    BEFORE UPDATE ON dct_ar_event_findings FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_dct_ark_upd
    BEFORE UPDATE ON dct_ar_event_kpis FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_dct_arsc_upd
    BEFORE UPDATE ON dct_ar_scenarios FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_dct_arsa_upd
    BEFORE UPDATE ON dct_ar_scenario_adj FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

PROMPT === AR DDL complete: 11 tables + triggers ===
