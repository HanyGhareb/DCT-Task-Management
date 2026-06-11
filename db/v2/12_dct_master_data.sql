-- =============================================================================
-- i-Finance V2 — Master / Reference Data Tables
-- File    : 12_dct_master_data.sql
-- Schema  : PROD
-- DB      : Oracle 23ai
-- Sprint  : 2 — Foundation Reference Data
-- =============================================================================
-- Phase 0 (critical blockers):
--   DCT_EMPLOYEE_GRADES       — grade codes referenced by DT_PER_DIEM_RATES
--   DCT_GL_CODE_COMBINATIONS  — 9-segment GL coding referenced by all modules (DT, PC, FL, CC)
--   DCT_COUNTRIES             — ISO country master (DT destinations, FL nationalities)
--   DCT_NATIONALITY           — nationality reference (FL registrations / freelancers)
--   DCT_EMPLOYEES             — employee master (DT grade lookup, user-person link)
--
-- Phase 1 (important gaps):
--   DCT_PROJECTS              — project master for PROJECT budget coding
--   DCT_PROJECT_TASKS         — task codes within projects
--   DCT_EXPENDITURE_TYPES     — expenditure type reference (all budget lines)
--   DCT_DOCUMENT_TYPES        — document type master (DT, FL doc requirements)
--   DCT_CURRENCY_CODES        — ISO currency reference (FL contracts, bank accounts)
--   DCT_BANK_CODES            — UAE bank reference (FL bank accounts)
-- =============================================================================
-- Run order: AFTER install.sql (01 → 06), BEFORE module DDL scripts
-- Prerequisites: dct_organizations, dct_users, dct_modules must exist
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
             'DCT_PROJECT_TASKS',
             'DCT_PROJECTS',
             'DCT_EMPLOYEES',
             'DCT_EMPLOYEE_GRADES',
             'DCT_GL_CODE_COMBINATIONS',
             'DCT_NATIONALITY',
             'DCT_COUNTRIES',
             'DCT_EXPENDITURE_TYPES',
             'DCT_DOCUMENT_TYPES',
             'DCT_CURRENCY_CODES',
             'DCT_BANK_CODES'
           )
  ) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE prod.' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
    DBMS_OUTPUT.PUT_LINE('Dropped: ' || t.table_name);
  END LOOP;
END;
/

-- =============================================================================
-- 1. DCT_EMPLOYEE_GRADES
--    Created first — referenced by DCT_EMPLOYEES and DT_PER_DIEM_RATES.
-- =============================================================================
CREATE TABLE dct_employee_grades (
    grade_code        VARCHAR2(20)    PRIMARY KEY,              -- E1, E2, P1, T1 …
    grade_name_en     VARCHAR2(200)   NOT NULL,
    grade_name_ar     VARCHAR2(200),
    grade_category    VARCHAR2(20)    NOT NULL,                 -- EXECUTIVE | PROFESSIONAL | TECHNICAL | SUPPORT
    grade_level       NUMBER          NOT NULL,                 -- 1 = lowest
    salary_band_min   NUMBER(15,2),                            -- monthly AED
    salary_band_max   NUMBER(15,2),
    is_active         VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    display_order     NUMBER          DEFAULT 0,
    created_by        VARCHAR2(100),
    created_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by        VARCHAR2(100),
    updated_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_grade_active   CHECK (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_grade_cat      CHECK (grade_category IN ('EXECUTIVE','PROFESSIONAL','TECHNICAL','SUPPORT')),
    CONSTRAINT chk_dct_grade_salary   CHECK (salary_band_max IS NULL OR salary_band_max >= salary_band_min)
);
CREATE INDEX ix_dct_grade_active ON dct_employee_grades(is_active);

-- =============================================================================
-- 2. DCT_GL_CODE_COMBINATIONS
--    9-segment chart-of-accounts coding table.
--    cc_code is a VIRTUAL column derived from all 9 segment codes:
--      S1.S2.S3.S4.S5.S6.S7.S8.S9
--    Segment widths: 3.6.7.1.6.7.6.6.6
--    All budget-coding modules (DT, PC, FL, CC) FK to cc_id here.
-- =============================================================================
CREATE TABLE dct_gl_code_combinations (
    cc_id                  NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    -- Seg 1 — Entity Code (3)
    entity_code            VARCHAR2(3)     NOT NULL,
    entity_desc            VARCHAR2(255),

    -- Seg 2 — Program (6)
    program_code           VARCHAR2(6)     NOT NULL,
    program_desc           VARCHAR2(255),

    -- Seg 3 — Cost Center (7)
    cost_center_code       VARCHAR2(7)     NOT NULL,
    cost_center_desc       VARCHAR2(255),

    -- Seg 4 — Budget Group Code (1)
    budget_group_code      VARCHAR2(1)     NOT NULL,
    budget_group_desc      VARCHAR2(255),

    -- Seg 5 — Account (6)
    account_code           VARCHAR2(6)     NOT NULL,
    account_desc           VARCHAR2(255),

    -- Seg 6 — Entity Specific (7)
    entity_specific_code   VARCHAR2(7)     DEFAULT '0000000' NOT NULL,
    entity_specific_desc   VARCHAR2(255),

    -- Seg 7 — Appropriation (6)
    appropriation_code     VARCHAR2(6)     NOT NULL,
    appropriation_desc     VARCHAR2(255),

    -- Seg 8 — Future 1 (6)
    future1_code           VARCHAR2(6)     DEFAULT '000000' NOT NULL,
    future1_desc           VARCHAR2(255),

    -- Seg 9 — Future 2 (6)
    future2_code           VARCHAR2(6)     DEFAULT '000000' NOT NULL,
    future2_desc           VARCHAR2(255),

    -- Full combination code — derived virtual column
    cc_code                VARCHAR2(200)   GENERATED ALWAYS AS (
                               entity_code           || '.' ||
                               program_code          || '.' ||
                               cost_center_code      || '.' ||
                               budget_group_code     || '.' ||
                               account_code          || '.' ||
                               entity_specific_code  || '.' ||
                               appropriation_code    || '.' ||
                               future1_code          || '.' ||
                               future2_code
                           ) VIRTUAL,

    -- Optional summary description for the full combination
    description_en         VARCHAR2(500),
    description_ar         VARCHAR2(500),

    account_type           VARCHAR2(20),                        -- EXPENSE | REVENUE | ASSET | LIABILITY | EQUITY
    org_id                 NUMBER,
    is_active              VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    effective_from         DATE            DEFAULT TRUNC(SYSDATE),
    effective_to           DATE,
    created_by             VARCHAR2(100),
    created_at             TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by             VARCHAR2(100),
    updated_at             TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_gl_segments   UNIQUE (entity_code, program_code, cost_center_code,
                                            budget_group_code, account_code, entity_specific_code,
                                            appropriation_code, future1_code, future2_code),
    CONSTRAINT chk_dct_gl_active    CHECK  (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_gl_acct_type CHECK  (account_type IN ('EXPENSE','REVENUE','ASSET','LIABILITY','EQUITY') OR account_type IS NULL),
    CONSTRAINT chk_dct_gl_dates     CHECK  (effective_to IS NULL OR effective_to >= effective_from),
    CONSTRAINT fk_dct_gl_org        FOREIGN KEY (org_id) REFERENCES dct_organizations(org_id)
);
CREATE INDEX ix_dct_gl_org    ON dct_gl_code_combinations(org_id);
CREATE INDEX ix_dct_gl_active ON dct_gl_code_combinations(is_active, effective_from, effective_to);
CREATE INDEX ix_dct_gl_acct   ON dct_gl_code_combinations(account_type);
CREATE INDEX ix_dct_gl_seg1   ON dct_gl_code_combinations(entity_code);
CREATE INDEX ix_dct_gl_seg3   ON dct_gl_code_combinations(cost_center_code);
CREATE INDEX ix_dct_gl_seg5   ON dct_gl_code_combinations(account_code);

-- =============================================================================
-- 3. DCT_COUNTRIES
--    ISO 3166-1 alpha-2 country master. Used by DT_DESTINATIONS, DT_COUNTRY_GROUPS,
--    and as the base for DCT_NATIONALITY.
-- =============================================================================
CREATE TABLE dct_countries (
    country_code      VARCHAR2(3)     PRIMARY KEY,              -- ISO 3166-1 alpha-2 (AE, GB …)
    country_name_en   VARCHAR2(200)   NOT NULL,
    country_name_ar   VARCHAR2(200),
    region_code       VARCHAR2(30),                             -- GCC | ARAB | EUROPE | ASIA | AMERICAS | AFRICA | OCEANIA
    sub_region        VARCHAR2(50),
    dial_code         VARCHAR2(10),                             -- +971
    currency_code     VARCHAR2(3),                              -- default ISO currency code
    is_active         VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    display_order     NUMBER          DEFAULT 0,
    created_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_ctry_active CHECK (is_active IN ('Y','N'))
);
CREATE INDEX ix_dct_ctry_region ON dct_countries(region_code, is_active);

-- =============================================================================
-- 4. DCT_NATIONALITY
--    Nationality lookup. FL_REGISTRATIONS and FL_FREELANCERS FK here.
--    nationality_code mirrors country_code convention (ISO alpha-2).
-- =============================================================================
CREATE TABLE dct_nationality (
    nationality_code  VARCHAR2(3)     PRIMARY KEY,              -- mirrors ISO country code
    nationality_en    VARCHAR2(200)   NOT NULL,                 -- 'Emirati', 'British' …
    nationality_ar    VARCHAR2(200),
    country_code      VARCHAR2(3),                              -- FK dct_countries (optional link)
    is_active         VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    display_order     NUMBER          DEFAULT 0,
    created_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_nat_active  CHECK (is_active IN ('Y','N')),
    CONSTRAINT fk_dct_nat_country  FOREIGN KEY (country_code) REFERENCES dct_countries(country_code)
);
CREATE INDEX ix_dct_nat_ctry ON dct_nationality(country_code);

-- =============================================================================
-- 5. DCT_EMPLOYEES
--    HR employee master. Linked to DCT_USERS via person_id.
--    DT module reads grade_code from here for per-diem rate lookup.
--    Populated via HR system sync or manual entry.
-- =============================================================================
CREATE TABLE dct_employees (
    person_id           NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_number     VARCHAR2(50)    NOT NULL,
    first_name_en       VARCHAR2(100)   NOT NULL,
    last_name_en        VARCHAR2(100)   NOT NULL,
    full_name_en        VARCHAR2(201)   GENERATED ALWAYS AS (first_name_en || ' ' || last_name_en) VIRTUAL,
    first_name_ar       VARCHAR2(100),
    last_name_ar        VARCHAR2(100),
    full_name_ar        VARCHAR2(201),
    date_of_birth       DATE,
    gender              VARCHAR2(1),                            -- M | F
    nationality_code    VARCHAR2(3),                            -- FK dct_nationality
    national_id         VARCHAR2(50),
    passport_number     VARCHAR2(50),
    email               VARCHAR2(255)   NOT NULL,
    mobile              VARCHAR2(20),
    grade_code          VARCHAR2(20),                           -- FK dct_employee_grades
    job_title_en        VARCHAR2(200),
    job_title_ar        VARCHAR2(200),
    org_id              NUMBER,                                 -- primary org, FK dct_organizations
    manager_person_id   NUMBER,                                 -- direct manager (self-ref)
    hire_date           DATE,
    end_date            DATE,
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    sync_source         VARCHAR2(50),                           -- HR_SYSTEM | MANUAL | API
    sync_date           TIMESTAMP,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_emp_number   UNIQUE      (employee_number),
    CONSTRAINT uq_dct_emp_email    UNIQUE      (email),
    CONSTRAINT chk_dct_emp_active  CHECK       (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_emp_gender  CHECK       (gender IN ('M','F') OR gender IS NULL),
    CONSTRAINT fk_dct_emp_grade    FOREIGN KEY (grade_code)        REFERENCES dct_employee_grades(grade_code),
    CONSTRAINT fk_dct_emp_org      FOREIGN KEY (org_id)            REFERENCES dct_organizations(org_id),
    CONSTRAINT fk_dct_emp_mgr      FOREIGN KEY (manager_person_id) REFERENCES dct_employees(person_id),
    CONSTRAINT fk_dct_emp_nat      FOREIGN KEY (nationality_code)  REFERENCES dct_nationality(nationality_code)
);
CREATE UNIQUE INDEX uix_dct_emp_number ON dct_employees(UPPER(employee_number));
CREATE INDEX        ix_dct_emp_grade   ON dct_employees(grade_code);
CREATE INDEX        ix_dct_emp_org     ON dct_employees(org_id);
CREATE INDEX        ix_dct_emp_mgr     ON dct_employees(manager_person_id);
CREATE INDEX        ix_dct_emp_active  ON dct_employees(is_active, end_date);

-- =============================================================================
-- 6. DCT_PROJECTS
--    Project master for PROJECT budget coding across all modules.
--    project_number (free-text in all modules) should FK here.
--
--    *** SUPERSEDED 2026-06-11 (Phase 2): sections 6, 7 and 8 (dct_projects,
--    *** dct_project_tasks, dct_expenditure_types) are replaced by NATURAL-KEY
--    *** masters in 15_dct_unified_structures.sql (project_number VARCHAR2(12)
--    *** PK; dct_tasks (project_number, task_number) PK; expenditure_type
--    *** VARCHAR2(255) PK). On a fresh install this script still runs first;
--    *** 15 then drops and recreates them on the new shape.
-- =============================================================================
CREATE TABLE dct_projects (
    project_id          NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_number      VARCHAR2(50)    NOT NULL,
    project_name_en     VARCHAR2(500)   NOT NULL,
    project_name_ar     VARCHAR2(500),
    project_type        VARCHAR2(30),                           -- CAPITAL | OPERATIONAL | GRANT | INTERNAL
    org_id              NUMBER,                                 -- owning org
    project_manager_id  NUMBER,                                 -- FK dct_users
    start_date          DATE,
    end_date            DATE,
    budget_amount       NUMBER(18,2),
    currency_code       VARCHAR2(3)     DEFAULT 'AED',
    status              VARCHAR2(20)    DEFAULT 'ACTIVE',       -- ACTIVE | COMPLETED | ON_HOLD | CANCELLED
    description_en      VARCHAR2(2000),
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_proj_number  UNIQUE      (project_number),
    CONSTRAINT chk_dct_proj_active CHECK       (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_proj_status CHECK       (status IN ('ACTIVE','COMPLETED','ON_HOLD','CANCELLED')),
    CONSTRAINT chk_dct_proj_type   CHECK       (project_type IN ('CAPITAL','OPERATIONAL','GRANT','INTERNAL') OR project_type IS NULL),
    CONSTRAINT chk_dct_proj_dates  CHECK       (end_date IS NULL OR end_date >= start_date),
    CONSTRAINT fk_dct_proj_org     FOREIGN KEY (org_id)            REFERENCES dct_organizations(org_id),
    CONSTRAINT fk_dct_proj_mgr     FOREIGN KEY (project_manager_id) REFERENCES dct_users(user_id)
);
CREATE INDEX ix_dct_proj_org    ON dct_projects(org_id);
CREATE INDEX ix_dct_proj_status ON dct_projects(status, is_active);
CREATE INDEX ix_dct_proj_mgr    ON dct_projects(project_manager_id);

-- =============================================================================
-- 7. DCT_PROJECT_TASKS
--    Task / work package codes within a project.
--    task_number (free-text in all modules) should reference these.
-- =============================================================================
CREATE TABLE dct_project_tasks (
    task_id             NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_id          NUMBER          NOT NULL,
    task_number         VARCHAR2(50)    NOT NULL,
    task_name_en        VARCHAR2(500)   NOT NULL,
    task_name_ar        VARCHAR2(500),
    parent_task_id      NUMBER,                                 -- for WBS hierarchy
    task_level          NUMBER          DEFAULT 1,
    start_date          DATE,
    end_date            DATE,
    budget_amount       NUMBER(18,2),
    is_chargeable       VARCHAR2(1)     DEFAULT 'Y' NOT NULL,  -- allows cost allocation
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    display_order       NUMBER          DEFAULT 0,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_task_number    UNIQUE      (project_id, task_number),
    CONSTRAINT chk_dct_task_active   CHECK       (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_task_charge   CHECK       (is_chargeable IN ('Y','N')),
    CONSTRAINT fk_dct_task_project   FOREIGN KEY (project_id)     REFERENCES dct_projects(project_id) ON DELETE CASCADE,
    CONSTRAINT fk_dct_task_parent    FOREIGN KEY (parent_task_id) REFERENCES dct_project_tasks(task_id)
);
CREATE INDEX ix_dct_task_project ON dct_project_tasks(project_id);
CREATE INDEX ix_dct_task_parent  ON dct_project_tasks(parent_task_id);
CREATE INDEX ix_dct_task_active  ON dct_project_tasks(is_active);

-- =============================================================================
-- 8. DCT_EXPENDITURE_TYPES
--    Expenditure categories used in all budget-coded modules.
--    expenditure_type (free-text VARCHAR2 in all modules) should reference here.
-- =============================================================================
CREATE TABLE dct_expenditure_types (
    exp_type_id         NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    exp_type_code       VARCHAR2(100)   NOT NULL,
    exp_type_name_en    VARCHAR2(300)   NOT NULL,
    exp_type_name_ar    VARCHAR2(300),
    exp_category        VARCHAR2(30)    NOT NULL,               -- PERSONNEL | TRAVEL | SERVICES | SUPPLIES | EQUIPMENT | OTHER
    applies_to_gl       VARCHAR2(1)     DEFAULT 'Y' NOT NULL,  -- valid for GL coding
    applies_to_project  VARCHAR2(1)     DEFAULT 'Y' NOT NULL,  -- valid for PROJECT coding
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    display_order       NUMBER          DEFAULT 0,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_exp_code       UNIQUE (exp_type_code),
    CONSTRAINT chk_dct_exp_active    CHECK  (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_exp_gl        CHECK  (applies_to_gl IN ('Y','N')),
    CONSTRAINT chk_dct_exp_proj      CHECK  (applies_to_project IN ('Y','N')),
    CONSTRAINT chk_dct_exp_category  CHECK  (exp_category IN ('PERSONNEL','TRAVEL','SERVICES','SUPPLIES','EQUIPMENT','OTHER'))
);
CREATE INDEX ix_dct_exp_cat    ON dct_expenditure_types(exp_category, is_active);
CREATE INDEX ix_dct_exp_active ON dct_expenditure_types(is_active);

-- =============================================================================
-- 9. DCT_DOCUMENT_TYPES
--    Master list of document types used in DT, FL, PC, CC modules.
--    document_type_id (NUMBER FK) in DT_DOC_REQUIREMENTS and DT_DOCUMENTS
--    references this table.
-- =============================================================================
CREATE TABLE dct_document_types (
    doc_type_id         NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    doc_type_code       VARCHAR2(100)   NOT NULL,
    doc_type_name_en    VARCHAR2(300)   NOT NULL,
    doc_type_name_ar    VARCHAR2(300),
    doc_category        VARCHAR2(30)    NOT NULL,               -- IDENTITY | TRAVEL | FINANCIAL | LEGAL | MEDICAL | OTHER
    applies_to_modules  VARCHAR2(200),                          -- pipe-sep: DT|FL|PC|CC
    has_expiry          VARCHAR2(1)     DEFAULT 'N' NOT NULL,  -- Y = has an expiry date
    expiry_alert_days   NUMBER          DEFAULT 30,            -- alert this many days before expiry
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    display_order       NUMBER          DEFAULT 0,
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_doctype_code   UNIQUE (doc_type_code),
    CONSTRAINT chk_dct_doctype_act   CHECK  (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_doctype_exp   CHECK  (has_expiry IN ('Y','N')),
    CONSTRAINT chk_dct_doctype_cat   CHECK  (doc_category IN ('IDENTITY','TRAVEL','FINANCIAL','LEGAL','MEDICAL','OTHER'))
);
CREATE INDEX ix_dct_doctype_cat ON dct_document_types(doc_category, is_active);

-- =============================================================================
-- 10. DCT_CURRENCY_CODES
--     ISO 4217 currency master. FL contracts reference currency_code.
--     exchange_rate_to_aed updated periodically (manual or API sync).
-- =============================================================================
CREATE TABLE dct_currency_codes (
    currency_code       VARCHAR2(3)     PRIMARY KEY,            -- ISO 4217 alpha-3: AED, USD …
    currency_name_en    VARCHAR2(200)   NOT NULL,
    currency_name_ar    VARCHAR2(200),
    currency_symbol     VARCHAR2(10),
    exchange_rate_to_aed NUMBER(18,6)   DEFAULT 1,              -- 1 unit of this CCY = N AED
    rate_date           DATE,                                   -- date the rate was last updated
    decimal_places      NUMBER          DEFAULT 2,
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    display_order       NUMBER          DEFAULT 0,
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_ccy_active CHECK (is_active IN ('Y','N'))
);

-- =============================================================================
-- 11. DCT_BANK_CODES
--     Bank reference master. FL bank accounts use bank_name (free-text today);
--     migrate to bank_code FK after this table is populated.
-- =============================================================================
CREATE TABLE dct_bank_codes (
    bank_code           VARCHAR2(20)    PRIMARY KEY,            -- local code or SWIFT BIC
    bank_name_en        VARCHAR2(300)   NOT NULL,
    bank_name_ar        VARCHAR2(300),
    swift_code          VARCHAR2(11),                           -- BIC-8 or BIC-11
    country_code        VARCHAR2(3),                            -- FK dct_countries
    bank_type           VARCHAR2(20)    DEFAULT 'CONVENTIONAL', -- CONVENTIONAL | ISLAMIC
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    display_order       NUMBER          DEFAULT 0,
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_bank_active CHECK (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_bank_type   CHECK (bank_type IN ('CONVENTIONAL','ISLAMIC')),
    CONSTRAINT fk_dct_bank_country FOREIGN KEY (country_code) REFERENCES dct_countries(country_code)
);
CREATE INDEX ix_dct_bank_country ON dct_bank_codes(country_code);
CREATE INDEX ix_dct_bank_active  ON dct_bank_codes(is_active);

-- =============================================================================
-- FK WIRES — Add FKs to existing tables that reference the new masters
-- =============================================================================

-- Wire dct_users.person_id → dct_employees.person_id
-- (person_id was always intended to be this FK; column exists, constraint was deferred)
ALTER TABLE dct_users
    ADD CONSTRAINT fk_dct_user_person
    FOREIGN KEY (person_id) REFERENCES dct_employees(person_id);

-- Wire dct_fl_registrations.nationality_code → dct_nationality
-- (column exists but FK was never created — added NOVALIDATE to protect existing data)
ALTER TABLE dct_fl_registrations
    ADD CONSTRAINT fk_dct_flreg_nat
    FOREIGN KEY (nationality_code) REFERENCES dct_nationality(nationality_code)
    ENABLE NOVALIDATE;

ALTER TABLE dct_fl_freelancers
    ADD CONSTRAINT fk_dct_flfreelancer_nat
    FOREIGN KEY (nationality_code) REFERENCES dct_nationality(nationality_code)
    ENABLE NOVALIDATE;

-- Wire dt_country_groups.country_code → dct_countries
ALTER TABLE dt_country_groups
    ADD CONSTRAINT fk_dt_cg_country
    FOREIGN KEY (country_code) REFERENCES dct_countries(country_code)
    ENABLE NOVALIDATE;

-- Wire dt_destinations.country_code → dct_countries
ALTER TABLE dt_destinations
    ADD CONSTRAINT fk_dt_dest_country
    FOREIGN KEY (country_code) REFERENCES dct_countries(country_code)
    ENABLE NOVALIDATE;

-- Wire dt_requests.cc_id_gl → dct_gl_code_combinations
ALTER TABLE dt_requests
    ADD CONSTRAINT fk_dt_req_gl
    FOREIGN KEY (cc_id_gl) REFERENCES dct_gl_code_combinations(cc_id)
    ENABLE NOVALIDATE;

-- Wire dt_doc_requirements.document_type_id → dct_document_types
ALTER TABLE dt_doc_requirements
    ADD CONSTRAINT fk_dt_docreq_type
    FOREIGN KEY (document_type_id) REFERENCES dct_document_types(doc_type_id)
    ENABLE NOVALIDATE;

ALTER TABLE dt_documents
    ADD CONSTRAINT fk_dt_doc_type
    FOREIGN KEY (document_type_id) REFERENCES dct_document_types(doc_type_id)
    ENABLE NOVALIDATE;

-- =============================================================================
-- UPDATED_AT TRIGGERS
-- =============================================================================
CREATE OR REPLACE TRIGGER trg_dct_grade_upd
    BEFORE UPDATE ON dct_employee_grades FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
CREATE OR REPLACE TRIGGER trg_dct_gl_upd
    BEFORE UPDATE ON dct_gl_code_combinations FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
CREATE OR REPLACE TRIGGER trg_dct_emp_upd
    BEFORE UPDATE ON dct_employees FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
CREATE OR REPLACE TRIGGER trg_dct_proj_upd
    BEFORE UPDATE ON dct_projects FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
CREATE OR REPLACE TRIGGER trg_dct_task_upd
    BEFORE UPDATE ON dct_project_tasks FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
CREATE OR REPLACE TRIGGER trg_dct_exp_upd
    BEFORE UPDATE ON dct_expenditure_types FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
CREATE OR REPLACE TRIGGER trg_dct_doctype_upd
    BEFORE UPDATE ON dct_document_types FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
CREATE OR REPLACE TRIGGER trg_dct_ccy_upd
    BEFORE UPDATE ON dct_currency_codes FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;
/

-- =============================================================================
-- SEED DATA
-- =============================================================================

-- ---------------------------------------------------------------------------
-- DCT_EMPLOYEE_GRADES — DCT grade structure
-- ---------------------------------------------------------------------------
INSERT ALL
  INTO dct_employee_grades (grade_code, grade_name_en, grade_name_ar, grade_category, grade_level, salary_band_min, salary_band_max, display_order)
       VALUES ('E1', 'Executive Grade 1 — Director General', 'الدرجة التنفيذية 1 — مدير عام', 'EXECUTIVE', 10, 60000, 120000, 10)
  INTO dct_employee_grades (grade_code, grade_name_en, grade_name_ar, grade_category, grade_level, salary_band_min, salary_band_max, display_order)
       VALUES ('E2', 'Executive Grade 2 — Director', 'الدرجة التنفيذية 2 — مدير', 'EXECUTIVE', 9, 45000, 80000, 20)
  INTO dct_employee_grades (grade_code, grade_name_en, grade_name_ar, grade_category, grade_level, salary_band_min, salary_band_max, display_order)
       VALUES ('E3', 'Executive Grade 3 — Senior Manager', 'الدرجة التنفيذية 3 — مدير أول', 'EXECUTIVE', 8, 30000, 55000, 30)
  INTO dct_employee_grades (grade_code, grade_name_en, grade_name_ar, grade_category, grade_level, salary_band_min, salary_band_max, display_order)
       VALUES ('E4', 'Executive Grade 4 — Manager', 'الدرجة التنفيذية 4 — مدير', 'EXECUTIVE', 7, 20000, 38000, 40)
  INTO dct_employee_grades (grade_code, grade_name_en, grade_name_ar, grade_category, grade_level, salary_band_min, salary_band_max, display_order)
       VALUES ('P1', 'Professional Grade 1 — Senior Specialist', 'الدرجة المهنية 1 — متخصص أول', 'PROFESSIONAL', 6, 15000, 28000, 50)
  INTO dct_employee_grades (grade_code, grade_name_en, grade_name_ar, grade_category, grade_level, salary_band_min, salary_band_max, display_order)
       VALUES ('P2', 'Professional Grade 2 — Specialist', 'الدرجة المهنية 2 — متخصص', 'PROFESSIONAL', 5, 10000, 20000, 60)
  INTO dct_employee_grades (grade_code, grade_name_en, grade_name_ar, grade_category, grade_level, salary_band_min, salary_band_max, display_order)
       VALUES ('P3', 'Professional Grade 3 — Senior Officer', 'الدرجة المهنية 3 — ضابط أول', 'PROFESSIONAL', 4, 7000, 14000, 70)
  INTO dct_employee_grades (grade_code, grade_name_en, grade_name_ar, grade_category, grade_level, salary_band_min, salary_band_max, display_order)
       VALUES ('T1', 'Technical Grade 1 — Senior Technician', 'الدرجة التقنية 1 — فني أول', 'TECHNICAL', 3, 5000, 10000, 80)
  INTO dct_employee_grades (grade_code, grade_name_en, grade_name_ar, grade_category, grade_level, salary_band_min, salary_band_max, display_order)
       VALUES ('T2', 'Technical Grade 2 — Technician', 'الدرجة التقنية 2 — فني', 'TECHNICAL', 2, 3500, 7000, 90)
  INTO dct_employee_grades (grade_code, grade_name_en, grade_name_ar, grade_category, grade_level, salary_band_min, salary_band_max, display_order)
       VALUES ('S1', 'Support Grade 1 — Senior Support', 'الدرجة الإدارية 1 — مساعد إداري أول', 'SUPPORT', 2, 3000, 6000, 100)
  INTO dct_employee_grades (grade_code, grade_name_en, grade_name_ar, grade_category, grade_level, salary_band_min, salary_band_max, display_order)
       VALUES ('S2', 'Support Grade 2 — Support Officer', 'الدرجة الإدارية 2 — مساعد إداري', 'SUPPORT', 1, 2000, 4500, 110)
SELECT 1 FROM dual;

-- ---------------------------------------------------------------------------
-- DCT_COUNTRIES — ISO 3166-1 country master
-- ---------------------------------------------------------------------------
INSERT ALL
  -- GCC
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('AE','United Arab Emirates','الإمارات العربية المتحدة','GCC','Gulf','+971','AED','Y',10)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('SA','Saudi Arabia','المملكة العربية السعودية','GCC','Gulf','+966','SAR','Y',20)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('KW','Kuwait','الكويت','GCC','Gulf','+965','KWD','Y',30)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('QA','Qatar','قطر','GCC','Gulf','+974','QAR','Y',40)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('BH','Bahrain','البحرين','GCC','Gulf','+973','BHD','Y',50)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('OM','Oman','عُمان','GCC','Gulf','+968','OMR','Y',60)
  -- Arab League (non-GCC)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('EG','Egypt','مصر','ARAB','North Africa','+20','EGP','Y',70)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('JO','Jordan','الأردن','ARAB','Levant','+962','JOD','Y',80)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('LB','Lebanon','لبنان','ARAB','Levant','+961','LBP','Y',90)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('SY','Syria','سوريا','ARAB','Levant','+963','SYP','Y',100)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('IQ','Iraq','العراق','ARAB','Middle East','+964','IQD','Y',110)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('YE','Yemen','اليمن','ARAB','Middle East','+967','YER','Y',120)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('MA','Morocco','المملكة المغربية','ARAB','North Africa','+212','MAD','Y',130)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('DZ','Algeria','الجزائر','ARAB','North Africa','+213','DZD','Y',140)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('TN','Tunisia','تونس','ARAB','North Africa','+216','TND','Y',150)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('LY','Libya','ليبيا','ARAB','North Africa','+218','LYD','Y',160)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('SD','Sudan','السودان','ARAB','North Africa','+249','SDG','Y',170)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('SO','Somalia','الصومال','ARAB','East Africa','+252','SOS','Y',180)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('DJ','Djibouti','جيبوتي','ARAB','East Africa','+253','DJF','Y',190)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('KM','Comoros','جزر القمر','ARAB','East Africa','+269','KMF','Y',200)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('MR','Mauritania','موريتانيا','ARAB','West Africa','+222','MRO','Y',210)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('PS','Palestine','فلسطين','ARAB','Levant','+970','ILS','Y',220)
  -- Europe
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('GB','United Kingdom','المملكة المتحدة','EUROPE','Northern Europe','+44','GBP','Y',300)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('DE','Germany','ألمانيا','EUROPE','Western Europe','+49','EUR','Y',310)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('FR','France','فرنسا','EUROPE','Western Europe','+33','EUR','Y',320)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('IT','Italy','إيطاليا','EUROPE','Southern Europe','+39','EUR','Y',330)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('ES','Spain','إسبانيا','EUROPE','Southern Europe','+34','EUR','Y',340)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('NL','Netherlands','هولندا','EUROPE','Western Europe','+31','EUR','Y',350)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('BE','Belgium','بلجيكا','EUROPE','Western Europe','+32','EUR','Y',360)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('CH','Switzerland','سويسرا','EUROPE','Western Europe','+41','CHF','Y',370)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('AT','Austria','النمسا','EUROPE','Western Europe','+43','EUR','Y',380)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('SE','Sweden','السويد','EUROPE','Northern Europe','+46','SEK','Y',390)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('NO','Norway','النرويج','EUROPE','Northern Europe','+47','NOK','Y',400)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('DK','Denmark','الدنمارك','EUROPE','Northern Europe','+45','DKK','Y',410)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('FI','Finland','فنلندا','EUROPE','Northern Europe','+358','EUR','Y',420)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('PT','Portugal','البرتغال','EUROPE','Southern Europe','+351','EUR','Y',430)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('GR','Greece','اليونان','EUROPE','Southern Europe','+30','EUR','Y',440)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('IE','Ireland','أيرلندا','EUROPE','Northern Europe','+353','EUR','Y',450)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('PL','Poland','بولندا','EUROPE','Eastern Europe','+48','PLN','Y',460)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('CZ','Czech Republic','جمهورية التشيك','EUROPE','Eastern Europe','+420','CZK','Y',470)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('HU','Hungary','المجر','EUROPE','Eastern Europe','+36','HUF','Y',480)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('RO','Romania','رومانيا','EUROPE','Eastern Europe','+40','RON','Y',490)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('TR','Turkey','تركيا','EUROPE','Southeast Europe','+90','TRY','Y',500)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('RU','Russia','روسيا','EUROPE','Eastern Europe','+7','RUB','Y',510)
  -- Asia-Pacific
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('IN','India','الهند','ASIA','South Asia','+91','INR','Y',600)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('CN','China','الصين','ASIA','East Asia','+86','CNY','Y',610)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('JP','Japan','اليابان','ASIA','East Asia','+81','JPY','Y',620)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('KR','South Korea','كوريا الجنوبية','ASIA','East Asia','+82','KRW','Y',630)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('SG','Singapore','سنغافورة','ASIA','Southeast Asia','+65','SGD','Y',640)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('MY','Malaysia','ماليزيا','ASIA','Southeast Asia','+60','MYR','Y',650)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('TH','Thailand','تايلاند','ASIA','Southeast Asia','+66','THB','Y',660)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('ID','Indonesia','إندونيسيا','ASIA','Southeast Asia','+62','IDR','Y',670)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('PH','Philippines','الفلبين','ASIA','Southeast Asia','+63','PHP','Y',680)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('PK','Pakistan','باكستان','ASIA','South Asia','+92','PKR','Y',690)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('BD','Bangladesh','بنغلاديش','ASIA','South Asia','+880','BDT','Y',700)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('LK','Sri Lanka','سريلانكا','ASIA','South Asia','+94','LKR','Y',710)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('NP','Nepal','نيبال','ASIA','South Asia','+977','NPR','Y',720)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('VN','Vietnam','فيتنام','ASIA','Southeast Asia','+84','VND','Y',730)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('AU','Australia','أستراليا','OCEANIA','Oceania','+61','AUD','Y',800)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('NZ','New Zealand','نيوزيلندا','OCEANIA','Oceania','+64','NZD','Y',810)
  -- Americas
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('US','United States','الولايات المتحدة الأمريكية','AMERICAS','North America','+1','USD','Y',900)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('CA','Canada','كندا','AMERICAS','North America','+1','CAD','Y',910)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('MX','Mexico','المكسيك','AMERICAS','North America','+52','MXN','Y',920)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('BR','Brazil','البرازيل','AMERICAS','South America','+55','BRL','Y',930)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('AR','Argentina','الأرجنتين','AMERICAS','South America','+54','ARS','Y',940)
  -- Africa
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('ZA','South Africa','جنوب أفريقيا','AFRICA','Southern Africa','+27','ZAR','Y',1000)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('NG','Nigeria','نيجيريا','AFRICA','West Africa','+234','NGN','Y',1010)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('KE','Kenya','كينيا','AFRICA','East Africa','+254','KES','Y',1020)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('ET','Ethiopia','إثيوبيا','AFRICA','East Africa','+251','ETB','Y',1030)
  INTO dct_countries (country_code, country_name_en, country_name_ar, region_code, sub_region, dial_code, currency_code, is_active, display_order) VALUES ('GH','Ghana','غانا','AFRICA','West Africa','+233','GHS','Y',1040)
SELECT 1 FROM dual;

-- ---------------------------------------------------------------------------
-- DCT_NATIONALITY — nationalities matching key countries
-- ---------------------------------------------------------------------------
INSERT ALL
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('AE','Emirati','إماراتي/إماراتية','AE','Y',10)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('SA','Saudi','سعودي/سعودية','SA','Y',20)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('KW','Kuwaiti','كويتي/كويتية','KW','Y',30)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('QA','Qatari','قطري/قطرية','QA','Y',40)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('BH','Bahraini','بحريني/بحرينية','BH','Y',50)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('OM','Omani','عُماني/عُمانية','OM','Y',60)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('EG','Egyptian','مصري/مصرية','EG','Y',70)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('JO','Jordanian','أردني/أردنية','JO','Y',80)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('LB','Lebanese','لبناني/لبنانية','LB','Y',90)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('SY','Syrian','سوري/سورية','SY','Y',100)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('IQ','Iraqi','عراقي/عراقية','IQ','Y',110)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('YE','Yemeni','يمني/يمنية','YE','Y',120)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('MA','Moroccan','مغربي/مغربية','MA','Y',130)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('DZ','Algerian','جزائري/جزائرية','DZ','Y',140)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('TN','Tunisian','تونسي/تونسية','TN','Y',150)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('LY','Libyan','ليبي/ليبية','LY','Y',160)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('SD','Sudanese','سوداني/سودانية','SD','Y',170)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('PS','Palestinian','فلسطيني/فلسطينية','PS','Y',180)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('IN','Indian','هندي/هندية','IN','Y',200)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('PK','Pakistani','باكستاني/باكستانية','PK','Y',210)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('BD','Bangladeshi','بنغلاديشي/بنغلاديشية','BD','Y',220)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('LK','Sri Lankan','سريلانكي/سريلانكية','LK','Y',230)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('NP','Nepali','نيبالي/نيبالية','NP','Y',240)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('PH','Filipino','فلبيني/فلبينية','PH','Y',250)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('ID','Indonesian','إندونيسي/إندونيسية','ID','Y',260)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('GB','British','بريطاني/بريطانية','GB','Y',300)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('US','American','أمريكي/أمريكية','US','Y',310)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('CA','Canadian','كندي/كندية','CA','Y',320)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('AU','Australian','أسترالي/أسترالية','AU','Y',330)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('DE','German','ألماني/ألمانية','DE','Y',340)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('FR','French','فرنسي/فرنسية','FR','Y',350)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('CN','Chinese','صيني/صينية','CN','Y',360)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('JP','Japanese','ياباني/يابانية','JP','Y',370)
  INTO dct_nationality (nationality_code, nationality_en, nationality_ar, country_code, is_active, display_order) VALUES ('KR','South Korean','كوري/كورية','KR','Y',380)
SELECT 1 FROM dual;

-- ---------------------------------------------------------------------------
-- DCT_CURRENCY_CODES — key currencies with AED exchange rates (indicative)
-- ---------------------------------------------------------------------------
INSERT ALL
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('AED','UAE Dirham','درهم إماراتي','د.إ',1.000000,TRUNC(SYSDATE),2,'Y',10)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('USD','US Dollar','دولار أمريكي','$',3.672000,TRUNC(SYSDATE),2,'Y',20)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('GBP','British Pound Sterling','جنيه إسترليني','£',4.660000,TRUNC(SYSDATE),2,'Y',30)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('EUR','Euro','يورو','€',3.970000,TRUNC(SYSDATE),2,'Y',40)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('SAR','Saudi Riyal','ريال سعودي','ر.س',0.979000,TRUNC(SYSDATE),2,'Y',50)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('KWD','Kuwaiti Dinar','دينار كويتي','د.ك',11.970000,TRUNC(SYSDATE),3,'Y',60)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('QAR','Qatari Riyal','ريال قطري','ر.ق',1.009000,TRUNC(SYSDATE),2,'Y',70)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('BHD','Bahraini Dinar','دينار بحريني','د.ب',9.740000,TRUNC(SYSDATE),3,'Y',80)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('OMR','Omani Rial','ريال عُماني','ر.ع',9.540000,TRUNC(SYSDATE),3,'Y',90)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('EGP','Egyptian Pound','جنيه مصري','ج.م',0.073000,TRUNC(SYSDATE),2,'Y',100)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('JOD','Jordanian Dinar','دينار أردني','د.أ',5.180000,TRUNC(SYSDATE),3,'Y',110)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('INR','Indian Rupee','روبية هندية','₹',0.044000,TRUNC(SYSDATE),2,'Y',120)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('PKR','Pakistani Rupee','روبية باكستانية','₨',0.013000,TRUNC(SYSDATE),2,'Y',130)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('CHF','Swiss Franc','فرنك سويسري','Fr',4.160000,TRUNC(SYSDATE),2,'Y',140)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('JPY','Japanese Yen','ين ياباني','¥',0.024000,TRUNC(SYSDATE),0,'Y',150)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('CNY','Chinese Renminbi','يوان صيني','¥',0.505000,TRUNC(SYSDATE),2,'Y',160)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('CAD','Canadian Dollar','دولار كندي','CA$',2.680000,TRUNC(SYSDATE),2,'Y',170)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('AUD','Australian Dollar','دولار أسترالي','A$',2.350000,TRUNC(SYSDATE),2,'Y',180)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('SGD','Singapore Dollar','دولار سنغافوري','S$',2.730000,TRUNC(SYSDATE),2,'Y',190)
  INTO dct_currency_codes (currency_code, currency_name_en, currency_name_ar, currency_symbol, exchange_rate_to_aed, rate_date, decimal_places, is_active, display_order) VALUES ('MYR','Malaysian Ringgit','رينغيت ماليزي','RM',0.840000,TRUNC(SYSDATE),2,'Y',200)
SELECT 1 FROM dual;

-- ---------------------------------------------------------------------------
-- DCT_BANK_CODES — UAE banks (primary) + key international
-- ---------------------------------------------------------------------------
INSERT ALL
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('FAB',  'First Abu Dhabi Bank','بنك أبوظبي الأول','NBADAEAA','AE','CONVENTIONAL','Y',10)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('ADCB', 'Abu Dhabi Commercial Bank','بنك أبوظبي التجاري','ADCBAEAA','AE','CONVENTIONAL','Y',20)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('ENBD', 'Emirates NBD','الإمارات NBD','EBILAEAD','AE','CONVENTIONAL','Y',30)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('ADIB', 'Abu Dhabi Islamic Bank','مصرف أبوظبي الإسلامي','ADIBAEAA','AE','ISLAMIC','Y',40)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('DIB',  'Dubai Islamic Bank','مصرف دبي الإسلامي','DUIBAEAD','AE','ISLAMIC','Y',50)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('MASHREQ','Mashreq Bank','بنك المشرق','BOMLAEAD','AE','CONVENTIONAL','Y',60)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('RAKBANK','RAK Bank','بنك رأس الخيمة الوطني','NRAKAEAK','AE','CONVENTIONAL','Y',70)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('CBD',  'Commercial Bank of Dubai','بنك دبي التجاري','CBDUAEAD','AE','CONVENTIONAL','Y',80)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('SIB',  'Sharjah Islamic Bank','مصرف الشارقة الإسلامي','SHBKAEAD','AE','ISLAMIC','Y',90)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('AJMAN','Ajman Bank','بنك عجمان','AJBKAEAD','AE','ISLAMIC','Y',100)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('NBF',  'National Bank of Fujairah','البنك الوطني للفجيرة','NBFUAEAK','AE','CONVENTIONAL','Y',110)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('HSBC', 'HSBC Bank Middle East','إتش إس بي سي','BBMEAEAD','AE','CONVENTIONAL','Y',120)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('SCBL', 'Standard Chartered Bank UAE','ستاندرد تشارترد','SCBLAEAD','AE','CONVENTIONAL','Y',130)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('CITI', 'Citibank UAE','سيتي بنك','CITIAEAD','AE','CONVENTIONAL','Y',140)
  INTO dct_bank_codes (bank_code, bank_name_en, bank_name_ar, swift_code, country_code, bank_type, is_active, display_order) VALUES ('EIB',  'Emirates Investment Bank','بنك الإمارات للاستثمار','EIBAAEAA','AE','CONVENTIONAL','Y',150)
SELECT 1 FROM dual;

-- ---------------------------------------------------------------------------
-- DCT_EXPENDITURE_TYPES — government expenditure categories
-- Note: individual INSERTs required — INSERT ALL conflicts with GENERATED ALWAYS AS IDENTITY
-- ---------------------------------------------------------------------------
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('SALARIES',       'Salaries and Wages',              'الرواتب والأجور',               'PERSONNEL', 'Y', 'N', 10);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('OVERTIME',       'Overtime and Allowances',         'العمل الإضافي والبدلات',        'PERSONNEL', 'Y', 'N', 20);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('TRAVEL_INTL',    'International Travel',            'السفر الدولي',                  'TRAVEL',    'Y', 'Y', 30);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('TRAVEL_LOCAL',   'Local Travel and Transportation', 'التنقل المحلي والمواصلات',      'TRAVEL',    'Y', 'Y', 40);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('TRAINING',       'Training and Development',        'التدريب والتطوير',              'TRAVEL',    'Y', 'Y', 50);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('CONSULTANCY',    'Consultancy Services',            'خدمات الاستشارات',              'SERVICES',  'Y', 'Y', 60);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('PROFESSIONAL',   'Professional Services',           'الخدمات المهنية',               'SERVICES',  'Y', 'Y', 70);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('IT_SERVICES',    'IT and Digital Services',         'خدمات تقنية المعلومات',         'SERVICES',  'Y', 'Y', 80);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('MAINTENANCE',    'Maintenance and Repairs',         'الصيانة والإصلاح',              'SERVICES',  'Y', 'Y', 90);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('UTILITIES',      'Utilities (Electricity, Water)',   'الخدمات (الكهرباء والماء)',      'SERVICES',  'Y', 'N', 100);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('RENT',           'Rent and Leasing',                'الإيجار والتأجير',              'SERVICES',  'Y', 'N', 110);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('OFFICE_SUPPLIES', 'Office and Administrative Supplies','مستلزمات المكتب والإدارة',     'SUPPLIES',  'Y', 'Y', 120);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('PRINTING',       'Printing and Publications',        'الطباعة والمطبوعات',            'SUPPLIES',  'Y', 'Y', 130);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('SUBSCRIPTIONS',  'Subscriptions and Memberships',   'الاشتراكات والعضويات',          'SUPPLIES',  'Y', 'Y', 140);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('IT_EQUIPMENT',   'IT Equipment and Hardware',        'أجهزة وأدوات تقنية المعلومات', 'EQUIPMENT', 'Y', 'Y', 150);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('IT_SOFTWARE',    'Software Licenses',               'تراخيص البرامج',                'EQUIPMENT', 'Y', 'Y', 160);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('VEHICLES',       'Vehicles and Transport Equipment', 'المركبات ومعدات النقل',         'EQUIPMENT', 'Y', 'Y', 170);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('HOSPITALITY',    'Hospitality and Events',          'الضيافة والفعاليات',            'OTHER',     'Y', 'Y', 180);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('MEDICAL',        'Medical and Healthcare',           'الرعاية الطبية والصحية',        'OTHER',     'Y', 'N', 190);
INSERT INTO dct_expenditure_types (exp_type_code, exp_type_name_en, exp_type_name_ar, exp_category, applies_to_gl, applies_to_project, display_order) VALUES ('OTHER_DIRECT',   'Other Direct Expenses',           'مصاريف مباشرة أخرى',           'OTHER',     'Y', 'Y', 200);

-- ---------------------------------------------------------------------------
-- DCT_DOCUMENT_TYPES — document type master
-- Note: individual INSERTs required — INSERT ALL conflicts with GENERATED ALWAYS AS IDENTITY
-- ---------------------------------------------------------------------------
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('PASSPORT',        'Passport',                         'جواز السفر',                  'IDENTITY',  'DT|FL',      'Y', 90,  10);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('EMIRATES_ID',     'Emirates ID',                      'الهوية الإماراتية',           'IDENTITY',  'FL',         'Y', 60,  20);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('RESIDENCE_VISA',  'UAE Residence Visa',               'تأشيرة الإقامة',              'IDENTITY',  'FL',         'Y', 60,  30);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('BUSINESS_VISA',   'Business / Entry Visa',            'تأشيرة عمل / دخول',          'TRAVEL',    'DT',         'Y', 30,  40);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('AIR_TICKET',      'Air Ticket / Boarding Pass',       'تذكرة طيران / بطاقة الصعود', 'TRAVEL',    'DT',         'N', 0,   50);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('HOTEL_INVOICE',   'Hotel Invoice / Receipt',          'فاتورة / إيصال الفندق',       'FINANCIAL', 'DT',         'N', 0,   60);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('TRANSPORT_RCPT',  'Local Transport Receipt',          'إيصال نقل محلي',              'FINANCIAL', 'DT',         'N', 0,   70);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('MEAL_RECEIPT',    'Meal / Subsistence Receipt',       'إيصال وجبات / معيشة',        'FINANCIAL', 'DT',         'N', 0,   80);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('CONF_INVITE',     'Conference / Training Invitation', 'دعوة مؤتمر / تدريب',         'TRAVEL',    'DT',         'N', 0,   90);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('INVOICE',         'Supplier Invoice',                 'فاتورة مورد',                 'FINANCIAL', 'PC|FL|CC',   'N', 0,   100);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('RECEIPT',         'Payment Receipt',                  'إيصال دفع',                   'FINANCIAL', 'PC|CC',      'N', 0,   110);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('CONTRACT',        'Contract / Agreement',             'عقد / اتفاقية',               'LEGAL',     'FL',         'Y', 30,  120);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('BANK_LETTER',     'Bank Account Letter / IBAN',       'خطاب حساب بنكي / IBAN',      'FINANCIAL', 'FL',         'N', 0,   130);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('SALARY_CERT',     'Salary Certificate',               'شهادة راتب',                  'FINANCIAL', 'CC',         'N', 0,   140);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('CC_STATEMENT',    'Credit Card Statement',            'كشف حساب بطاقة ائتمانية',    'FINANCIAL', 'CC',         'N', 0,   150);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('APPROVAL_LETTER', 'Approval Letter / Memo',           'خطاب موافقة / مذكرة',        'LEGAL',     'DT|PC|FL',   'N', 0,   160);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('MEDICAL_REPORT',  'Medical Report / Certificate',     'تقرير / شهادة طبية',         'MEDICAL',   'FL',         'Y', 90,  170);
INSERT INTO dct_document_types (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category, applies_to_modules, has_expiry, expiry_alert_days, display_order) VALUES ('OTHER',           'Other Supporting Document',        'مستند داعم آخر',              'OTHER',     'DT|PC|FL|CC','N', 0,   999);

-- ---------------------------------------------------------------------------
-- DCT_GL_CODE_COMBINATIONS — Finance Division sample combinations
-- Format: S1(3).S2(6).S3(7).S4(1).S5(6).S6(7).S7(6).S8(6).S9(6)
--   S1 Entity Code | S2 Program | S3 Cost Center | S4 Budget Group
--   S5 Account     | S6 Entity Specific | S7 Appropriation | S8 Future1 | S9 Future2
-- Adjust segment values to match your organisation's chart of accounts.
-- ---------------------------------------------------------------------------
-- Note: individual INSERTs required — INSERT ALL conflicts with GENERATED ALWAYS AS IDENTITY
-- ── Duty Travel (DT module) ─────────────────────────────────────────────────
INSERT INTO dct_gl_code_combinations (entity_code, entity_desc, program_code, program_desc, cost_center_code, cost_center_desc, budget_group_code, budget_group_desc, account_code, account_desc, entity_specific_code, entity_specific_desc, appropriation_code, appropriation_desc, future1_code, future2_code, description_en, description_ar, account_type, is_active)
VALUES ('001','Department of Culture & Tourism — Abu Dhabi','100000','Administration & Support Program','1010001','Finance Operations Section','2','Operating Expenditure','520100','Duty Travel & Mission Expenses','0000000','General','202600','FY2026 Approved Appropriation','000000','000000','DT — Duty Travel: Finance Operations (FY2026)','مصاريف السفر الوظيفي — قسم العمليات المالية','EXPENSE','Y');
INSERT INTO dct_gl_code_combinations (entity_code, entity_desc, program_code, program_desc, cost_center_code, cost_center_desc, budget_group_code, budget_group_desc, account_code, account_desc, entity_specific_code, entity_specific_desc, appropriation_code, appropriation_desc, future1_code, future2_code, description_en, description_ar, account_type, is_active)
VALUES ('001','Department of Culture & Tourism — Abu Dhabi','100000','Administration & Support Program','1010002','Payables Operations Section','2','Operating Expenditure','520100','Duty Travel & Mission Expenses','0000000','General','202600','FY2026 Approved Appropriation','000000','000000','DT — Duty Travel: Payables Operations (FY2026)','مصاريف السفر الوظيفي — قسم العمليات المدينة','EXPENSE','Y');
INSERT INTO dct_gl_code_combinations (entity_code, entity_desc, program_code, program_desc, cost_center_code, cost_center_desc, budget_group_code, budget_group_desc, account_code, account_desc, entity_specific_code, entity_specific_desc, appropriation_code, appropriation_desc, future1_code, future2_code, description_en, description_ar, account_type, is_active)
VALUES ('001','Department of Culture & Tourism — Abu Dhabi','100000','Administration & Support Program','1010003','Financial Planning & Budgeting Section','2','Operating Expenditure','520100','Duty Travel & Mission Expenses','0000000','General','202600','FY2026 Approved Appropriation','000000','000000','DT — Duty Travel: Financial Planning (FY2026)','مصاريف السفر الوظيفي — قسم التخطيط المالي','EXPENSE','Y');
INSERT INTO dct_gl_code_combinations (entity_code, entity_desc, program_code, program_desc, cost_center_code, cost_center_desc, budget_group_code, budget_group_desc, account_code, account_desc, entity_specific_code, entity_specific_desc, appropriation_code, appropriation_desc, future1_code, future2_code, description_en, description_ar, account_type, is_active)
VALUES ('001','Department of Culture & Tourism — Abu Dhabi','200000','Tourism Sector Program','2010001','Tourism Promotion Section','2','Operating Expenditure','520100','Duty Travel & Mission Expenses','0000000','General','202600','FY2026 Approved Appropriation','000000','000000','DT — Duty Travel: Tourism Promotion (FY2026)','مصاريف السفر الوظيفي — قطاع السياحة','EXPENSE','Y');
INSERT INTO dct_gl_code_combinations (entity_code, entity_desc, program_code, program_desc, cost_center_code, cost_center_desc, budget_group_code, budget_group_desc, account_code, account_desc, entity_specific_code, entity_specific_desc, appropriation_code, appropriation_desc, future1_code, future2_code, description_en, description_ar, account_type, is_active)
VALUES ('001','Department of Culture & Tourism — Abu Dhabi','300000','Culture Sector Program','3010001','Culture & Heritage Section','2','Operating Expenditure','520100','Duty Travel & Mission Expenses','0000000','General','202600','FY2026 Approved Appropriation','000000','000000','DT — Duty Travel: Culture & Heritage (FY2026)','مصاريف السفر الوظيفي — قطاع الثقافة','EXPENSE','Y');
-- ── Petty Cash (PC module) ───────────────────────────────────────────────────
INSERT INTO dct_gl_code_combinations (entity_code, entity_desc, program_code, program_desc, cost_center_code, cost_center_desc, budget_group_code, budget_group_desc, account_code, account_desc, entity_specific_code, entity_specific_desc, appropriation_code, appropriation_desc, future1_code, future2_code, description_en, description_ar, account_type, is_active)
VALUES ('001','Department of Culture & Tourism — Abu Dhabi','100000','Administration & Support Program','1010001','Finance Operations Section','2','Operating Expenditure','530100','Office & Administrative Supplies','0000000','General','202600','FY2026 Approved Appropriation','000000','000000','PC — Office Supplies: Finance Operations (FY2026)','المستلزمات المكتبية — قسم العمليات المالية','EXPENSE','Y');
INSERT INTO dct_gl_code_combinations (entity_code, entity_desc, program_code, program_desc, cost_center_code, cost_center_desc, budget_group_code, budget_group_desc, account_code, account_desc, entity_specific_code, entity_specific_desc, appropriation_code, appropriation_desc, future1_code, future2_code, description_en, description_ar, account_type, is_active)
VALUES ('001','Department of Culture & Tourism — Abu Dhabi','100000','Administration & Support Program','1010001','Finance Operations Section','2','Operating Expenditure','540100','Local Transportation & Accommodation','0000000','General','202600','FY2026 Approved Appropriation','000000','000000','PC — Local Transport: Finance Operations (FY2026)','مصاريف التنقل المحلي — قسم العمليات المالية','EXPENSE','Y');
-- ── Freelancers (FL module) ──────────────────────────────────────────────────
INSERT INTO dct_gl_code_combinations (entity_code, entity_desc, program_code, program_desc, cost_center_code, cost_center_desc, budget_group_code, budget_group_desc, account_code, account_desc, entity_specific_code, entity_specific_desc, appropriation_code, appropriation_desc, future1_code, future2_code, description_en, description_ar, account_type, is_active)
VALUES ('001','Department of Culture & Tourism — Abu Dhabi','100000','Administration & Support Program','1010001','Finance Operations Section','2','Operating Expenditure','550100','Consultancy & Professional Services','0000000','General','202600','FY2026 Approved Appropriation','000000','000000','FL — Consultancy Services: Finance Operations (FY2026)','خدمات الاستشارات — قسم العمليات المالية','EXPENSE','Y');
INSERT INTO dct_gl_code_combinations (entity_code, entity_desc, program_code, program_desc, cost_center_code, cost_center_desc, budget_group_code, budget_group_desc, account_code, account_desc, entity_specific_code, entity_specific_desc, appropriation_code, appropriation_desc, future1_code, future2_code, description_en, description_ar, account_type, is_active)
VALUES ('001','Department of Culture & Tourism — Abu Dhabi','200000','Tourism Sector Program','2010001','Tourism Promotion Section','2','Operating Expenditure','550100','Consultancy & Professional Services','0000000','General','202600','FY2026 Approved Appropriation','000000','000000','FL — Consultancy Services: Tourism Promotion (FY2026)','خدمات الاستشارات — قطاع السياحة','EXPENSE','Y');
-- ── Credit Cards (CC module) ─────────────────────────────────────────────────
INSERT INTO dct_gl_code_combinations (entity_code, entity_desc, program_code, program_desc, cost_center_code, cost_center_desc, budget_group_code, budget_group_desc, account_code, account_desc, entity_specific_code, entity_specific_desc, appropriation_code, appropriation_desc, future1_code, future2_code, description_en, description_ar, account_type, is_active)
VALUES ('001','Department of Culture & Tourism — Abu Dhabi','100000','Administration & Support Program','1010001','Finance Operations Section','2','Operating Expenditure','560100','Credit Card & Corporate Card Expenses','0000000','General','202600','FY2026 Approved Appropriation','000000','000000','CC — Corporate Card Expenses: Finance Operations (FY2026)','مصاريف البطاقة الائتمانية — قسم العمليات المالية','EXPENSE','Y');
-- ── Capital / Project coding ─────────────────────────────────────────────────
INSERT INTO dct_gl_code_combinations (entity_code, entity_desc, program_code, program_desc, cost_center_code, cost_center_desc, budget_group_code, budget_group_desc, account_code, account_desc, entity_specific_code, entity_specific_desc, appropriation_code, appropriation_desc, future1_code, future2_code, description_en, description_ar, account_type, is_active)
VALUES ('001','Department of Culture & Tourism — Abu Dhabi','400000','IT & Digital Transformation Program','4010001','IT Infrastructure Section','3','Capital Expenditure','610100','IT Equipment & Hardware','0000000','General','202600','FY2026 Approved Appropriation','000000','000000','CAPEX — IT Equipment: Digital Transformation (FY2026)','مصاريف رأسمالية — معدات تقنية المعلومات','EXPENSE','Y');
INSERT INTO dct_gl_code_combinations (entity_code, entity_desc, program_code, program_desc, cost_center_code, cost_center_desc, budget_group_code, budget_group_desc, account_code, account_desc, entity_specific_code, entity_specific_desc, appropriation_code, appropriation_desc, future1_code, future2_code, description_en, description_ar, account_type, is_active)
VALUES ('001','Department of Culture & Tourism — Abu Dhabi','400000','IT & Digital Transformation Program','4010001','IT Infrastructure Section','3','Capital Expenditure','610200','Software Licenses & Subscriptions','0000000','General','202600','FY2026 Approved Appropriation','000000','000000','CAPEX — Software Licenses: Digital Transformation (FY2026)','مصاريف رأسمالية — تراخيص البرامج','EXPENSE','Y');

COMMIT;
-- =============================================================================
-- END OF SCRIPT
-- =============================================================================

COMMIT;

PROMPT ===========================================================
PROMPT 12_dct_master_data.sql — completed successfully
PROMPT Tables: DCT_EMPLOYEE_GRADES, DCT_GL_CODE_COMBINATIONS,
PROMPT         DCT_COUNTRIES, DCT_NATIONALITY, DCT_EMPLOYEES,
PROMPT         DCT_PROJECTS, DCT_PROJECT_TASKS,
PROMPT         DCT_EXPENDITURE_TYPES, DCT_DOCUMENT_TYPES,
PROMPT         DCT_CURRENCY_CODES, DCT_BANK_CODES
PROMPT ===========================================================
