-- =============================================================================
-- i-Finance V2 — HR Module DDL
-- File    : 01_hr_ddl.sql
-- Schema  : PROD
-- DB      : Oracle 23ai
-- Prefix  : HR_
-- Module  : Human Resources (App 205)
-- =============================================================================
-- Tables (in dependency order):
--   1.  HR_LOCATIONS
--   2.  HR_JOB_FAMILIES
--   3.  HR_JOBS
--   4.  HR_POSITIONS
--   5.  HR_EMPLOYEE_ASSIGNMENTS
--   6.  HR_EMPLOYMENT_CONTRACTS
--   7.  HR_SALARY_HISTORY
--   8.  HR_EMPLOYEE_DOCUMENTS
-- =============================================================================
-- Prerequisites:
--   DCT_ORGANIZATIONS, DCT_EMPLOYEES, DCT_EMPLOYEE_GRADES,
--   DCT_DOCUMENT_TYPES, DCT_LOOKUP_VALUES, DCT_CURRENCY_CODES,
--   DCT_COUNTRIES, DCT_USERS  — all must exist (run install.sql first)
-- Run: AFTER db/v2/install.sql and db/v2/12_dct_master_data.sql
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
                 'HR_EMPLOYEE_DOCUMENTS',
                 'HR_SALARY_HISTORY',
                 'HR_EMPLOYMENT_CONTRACTS',
                 'HR_EMPLOYEE_ASSIGNMENTS',
                 'HR_POSITIONS',
                 'HR_JOBS',
                 'HR_JOB_FAMILIES',
                 'HR_LOCATIONS'
               )
    ) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE prod.' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
        DBMS_OUTPUT.PUT_LINE('Dropped: ' || t.table_name);
    END LOOP;
END;
/

-- =============================================================================
-- 1. HR_LOCATIONS
--    Physical offices and sites. Referenced by DCT_ORGANIZATIONS (via alteration)
--    and by HR_POSITIONS and HR_EMPLOYEE_ASSIGNMENTS.
-- =============================================================================
CREATE TABLE hr_locations (
    location_id       NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    location_code     VARCHAR2(50)    NOT NULL,
    location_name_en  VARCHAR2(200)   NOT NULL,
    location_name_ar  VARCHAR2(200),
    location_type_id  NUMBER,                                 -- FK → DCT_LOOKUP_VALUES (HR_LOCATION_TYPE)
    org_id            NUMBER,                                 -- FK → DCT_ORGANIZATIONS (owning org)
    country_code      VARCHAR2(3),                            -- FK → DCT_COUNTRIES
    emirate           VARCHAR2(50),                           -- Abu Dhabi | Dubai | Sharjah …
    city              VARCHAR2(100),
    area              VARCHAR2(100),                          -- District / neighbourhood
    building_name     VARCHAR2(200),
    floor_no          VARCHAR2(20),
    po_box            VARCHAR2(20),
    zip_code          VARCHAR2(20),
    google_maps_url   VARCHAR2(1000),
    is_active         VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    display_order     NUMBER          DEFAULT 0,
    created_by        VARCHAR2(100),
    created_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by        VARCHAR2(100),
    updated_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_hr_loc_code    UNIQUE      (location_code),
    CONSTRAINT chk_hr_loc_active CHECK       (is_active IN ('Y','N')),
    CONSTRAINT fk_hr_loc_type    FOREIGN KEY (location_type_id) REFERENCES dct_lookup_values(value_id),
    CONSTRAINT fk_hr_loc_org     FOREIGN KEY (org_id)           REFERENCES dct_organizations(org_id),
    CONSTRAINT fk_hr_loc_country FOREIGN KEY (country_code)     REFERENCES dct_countries(country_code)
);

CREATE INDEX ix_hr_loc_org     ON hr_locations(org_id);
CREATE INDEX ix_hr_loc_country ON hr_locations(country_code);
CREATE INDEX ix_hr_loc_active  ON hr_locations(is_active);

-- =============================================================================
-- 2. HR_JOB_FAMILIES
--    Groups related jobs into a family (Finance, IT, HR, Legal, Operations …).
--    No external FKs — purely a classification hierarchy.
-- =============================================================================
CREATE TABLE hr_job_families (
    job_family_id     NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    family_code       VARCHAR2(50)    NOT NULL,
    family_name_en    VARCHAR2(200)   NOT NULL,
    family_name_ar    VARCHAR2(200),
    description_en    VARCHAR2(500),
    is_active         VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    display_order     NUMBER          DEFAULT 0,
    created_by        VARCHAR2(100),
    created_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by        VARCHAR2(100),
    updated_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_hr_jf_code    UNIQUE (family_code),
    CONSTRAINT chk_hr_jf_active CHECK  (is_active IN ('Y','N'))
);

CREATE INDEX ix_hr_jf_active ON hr_job_families(is_active);

-- =============================================================================
-- 3. HR_JOBS
--    Generic job definitions — not tied to any specific org unit.
--    One job (e.g. "Financial Analyst") can fill many positions.
--    Grade range (min/max) defines the span allowed for this job.
-- =============================================================================
CREATE TABLE hr_jobs (
    job_id                      NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    job_code                    VARCHAR2(50)    NOT NULL,
    job_name_en                 VARCHAR2(200)   NOT NULL,
    job_name_ar                 VARCHAR2(200),
    job_family_id               NUMBER,                      -- FK → HR_JOB_FAMILIES
    min_grade_code              VARCHAR2(20),                -- FK → DCT_EMPLOYEE_GRADES (lowest grade for this job)
    max_grade_code              VARCHAR2(20),                -- FK → DCT_EMPLOYEE_GRADES (highest grade for this job)
    description_en              VARCHAR2(2000),
    description_ar              VARCHAR2(2000),
    key_responsibilities        CLOB,                        -- Free text or JSON bullet points
    min_experience_years        NUMBER,
    required_qualification_id   NUMBER,                      -- FK → DCT_LOOKUP_VALUES (HR_QUALIFICATION)
    is_active                   VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    effective_from              DATE,
    effective_to                DATE,
    created_by                  VARCHAR2(100),
    created_at                  TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by                  VARCHAR2(100),
    updated_at                  TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_hr_job_code      UNIQUE      (job_code),
    CONSTRAINT chk_hr_job_active   CHECK       (is_active IN ('Y','N')),
    CONSTRAINT chk_hr_job_dates    CHECK       (effective_to IS NULL OR effective_to >= effective_from),
    CONSTRAINT fk_hr_job_family    FOREIGN KEY (job_family_id)           REFERENCES hr_job_families(job_family_id),
    CONSTRAINT fk_hr_job_mingrade  FOREIGN KEY (min_grade_code)          REFERENCES dct_employee_grades(grade_code),
    CONSTRAINT fk_hr_job_maxgrade  FOREIGN KEY (max_grade_code)          REFERENCES dct_employee_grades(grade_code),
    CONSTRAINT fk_hr_job_qual      FOREIGN KEY (required_qualification_id) REFERENCES dct_lookup_values(value_id)
);

CREATE INDEX ix_hr_job_family ON hr_jobs(job_family_id);
CREATE INDEX ix_hr_job_active ON hr_jobs(is_active, effective_from, effective_to);

-- =============================================================================
-- 4. HR_POSITIONS
--    Budgeted headcount slots: one org unit + one job + one grade + one location.
--    approved_headcount > filled count = vacancy (computed in V_HR_HEADCOUNT view).
--    position_code is auto-assigned by the application layer (POS-YYYY-NNNNN).
-- =============================================================================
CREATE TABLE hr_positions (
    position_id         NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    position_code       VARCHAR2(50)    NOT NULL,
    position_name_en    VARCHAR2(300)   NOT NULL,
    position_name_ar    VARCHAR2(300),
    job_id              NUMBER          NOT NULL,             -- FK → HR_JOBS
    org_id              NUMBER          NOT NULL,             -- FK → DCT_ORGANIZATIONS
    location_id         NUMBER,                              -- FK → HR_LOCATIONS (NULL = inherits from org)
    grade_code          VARCHAR2(20),                        -- FK → DCT_EMPLOYEE_GRADES (approved grade)
    approved_headcount  NUMBER          DEFAULT 1   NOT NULL,
    position_type_id    NUMBER,                              -- FK → DCT_LOOKUP_VALUES (HR_POSITION_TYPE)
    is_active           VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    effective_from      DATE            NOT NULL,
    effective_to        DATE,
    description_en      VARCHAR2(500),
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_hr_pos_code    UNIQUE      (position_code),
    CONSTRAINT chk_hr_pos_active CHECK       (is_active IN ('Y','N')),
    CONSTRAINT chk_hr_pos_hc     CHECK       (approved_headcount > 0),
    CONSTRAINT chk_hr_pos_dates  CHECK       (effective_to IS NULL OR effective_to >= effective_from),
    CONSTRAINT fk_hr_pos_job     FOREIGN KEY (job_id)           REFERENCES hr_jobs(job_id),
    CONSTRAINT fk_hr_pos_org     FOREIGN KEY (org_id)           REFERENCES dct_organizations(org_id),
    CONSTRAINT fk_hr_pos_loc     FOREIGN KEY (location_id)      REFERENCES hr_locations(location_id),
    CONSTRAINT fk_hr_pos_grade   FOREIGN KEY (grade_code)       REFERENCES dct_employee_grades(grade_code),
    CONSTRAINT fk_hr_pos_type    FOREIGN KEY (position_type_id) REFERENCES dct_lookup_values(value_id)
);

CREATE INDEX ix_hr_pos_job    ON hr_positions(job_id);
CREATE INDEX ix_hr_pos_org    ON hr_positions(org_id);
CREATE INDEX ix_hr_pos_grade  ON hr_positions(grade_code);
CREATE INDEX ix_hr_pos_active ON hr_positions(is_active, effective_from, effective_to);

-- =============================================================================
-- 5. HR_EMPLOYEE_ASSIGNMENTS
--    Core assignment: employee → position → org → grade → location at a point
--    in time. All history is kept; end_date marks the end of an assignment.
--
--    Constraint: only one ACTIVE PRIMARY assignment per person_id at a time.
--    Enforced by function-based unique index on (person_id) WHERE end_date IS NULL
--    AND is_primary = 'Y' AND assignment_status = 'ACTIVE'.
--    Oracle does not support partial indexes natively — enforced via trigger below.
-- =============================================================================
CREATE TABLE hr_employee_assignments (
    assignment_id       NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    assignment_number   VARCHAR2(30)    NOT NULL,
    person_id           NUMBER          NOT NULL,            -- FK → DCT_EMPLOYEES
    position_id         NUMBER,                              -- FK → HR_POSITIONS (NULL for acting/legacy)
    job_id              NUMBER,                              -- FK → HR_JOBS (snapped at assignment time)
    org_id              NUMBER          NOT NULL,            -- FK → DCT_ORGANIZATIONS
    grade_code          VARCHAR2(20),                        -- FK → DCT_EMPLOYEE_GRADES (effective grade)
    location_id         NUMBER,                              -- FK → HR_LOCATIONS
    assignment_type_id  NUMBER,                              -- FK → DCT_LOOKUP_VALUES (HR_ASSIGNMENT_TYPE)
    assignment_status   VARCHAR2(20)    DEFAULT 'ACTIVE' NOT NULL,
    start_date          DATE            NOT NULL,
    end_date            DATE,
    end_reason_id       NUMBER,                              -- FK → DCT_LOOKUP_VALUES (HR_END_REASON)
    is_primary          VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    probation_end_date  DATE,
    manager_person_id   NUMBER,                              -- FK → DCT_EMPLOYEES (direct manager at time)
    remarks             VARCHAR2(1000),
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_hr_asgn_number  UNIQUE      (assignment_number),
    CONSTRAINT chk_hr_asgn_status CHECK       (assignment_status IN ('ACTIVE','ENDED','SUSPENDED')),
    CONSTRAINT chk_hr_asgn_prim   CHECK       (is_primary IN ('Y','N')),
    CONSTRAINT chk_hr_asgn_dates  CHECK       (end_date IS NULL OR end_date >= start_date),
    CONSTRAINT fk_hr_asgn_person  FOREIGN KEY (person_id)          REFERENCES dct_employees(person_id),
    CONSTRAINT fk_hr_asgn_pos     FOREIGN KEY (position_id)        REFERENCES hr_positions(position_id),
    CONSTRAINT fk_hr_asgn_job     FOREIGN KEY (job_id)             REFERENCES hr_jobs(job_id),
    CONSTRAINT fk_hr_asgn_org     FOREIGN KEY (org_id)             REFERENCES dct_organizations(org_id),
    CONSTRAINT fk_hr_asgn_grade   FOREIGN KEY (grade_code)         REFERENCES dct_employee_grades(grade_code),
    CONSTRAINT fk_hr_asgn_loc     FOREIGN KEY (location_id)        REFERENCES hr_locations(location_id),
    CONSTRAINT fk_hr_asgn_type    FOREIGN KEY (assignment_type_id) REFERENCES dct_lookup_values(value_id),
    CONSTRAINT fk_hr_asgn_reason  FOREIGN KEY (end_reason_id)      REFERENCES dct_lookup_values(value_id),
    CONSTRAINT fk_hr_asgn_mgr     FOREIGN KEY (manager_person_id)  REFERENCES dct_employees(person_id)
);

CREATE INDEX ix_hr_asgn_person ON hr_employee_assignments(person_id);
CREATE INDEX ix_hr_asgn_pos    ON hr_employee_assignments(position_id);
CREATE INDEX ix_hr_asgn_org    ON hr_employee_assignments(org_id);
CREATE INDEX ix_hr_asgn_status ON hr_employee_assignments(assignment_status, is_primary, end_date);
CREATE INDEX ix_hr_asgn_dates  ON hr_employee_assignments(start_date, end_date);

-- Trigger: enforce only one active primary assignment per person
CREATE OR REPLACE TRIGGER trg_hr_asgn_one_primary
    BEFORE INSERT OR UPDATE ON hr_employee_assignments
    FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    IF :NEW.is_primary = 'Y' AND :NEW.assignment_status = 'ACTIVE' AND :NEW.end_date IS NULL THEN
        SELECT COUNT(*)
        INTO   v_count
        FROM   hr_employee_assignments
        WHERE  person_id          = :NEW.person_id
        AND    is_primary         = 'Y'
        AND    assignment_status  = 'ACTIVE'
        AND    end_date           IS NULL
        AND    assignment_id     != NVL(:NEW.assignment_id, -1);

        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20100,
                'Employee ' || :NEW.person_id || ' already has an active primary assignment.');
        END IF;
    END IF;
END;
/

-- =============================================================================
-- 6. HR_EMPLOYMENT_CONTRACTS
--    One row per contract period. Multiple contracts over time are allowed
--    (renewal creates a new row; previous row gets contract_status = EXPIRED).
--    contract_number is assigned by HR and must be unique.
-- =============================================================================
CREATE TABLE hr_employment_contracts (
    contract_id         NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    contract_number     VARCHAR2(50)    NOT NULL,
    person_id           NUMBER          NOT NULL,            -- FK → DCT_EMPLOYEES
    contract_type_id    NUMBER          NOT NULL,            -- FK → DCT_LOOKUP_VALUES (HR_CONTRACT_TYPE)
    start_date          DATE            NOT NULL,
    end_date            DATE,                                -- NULL for permanent / indefinite
    probation_months    NUMBER          DEFAULT 3,
    probation_end_date  DATE,                                -- set by package on insert
    notice_period_days  NUMBER          DEFAULT 30,
    contract_status_id  NUMBER,                              -- FK → DCT_LOOKUP_VALUES (HR_CONTRACT_STATUS)
    signed_date         DATE,
    file_url            VARCHAR2(1000),                      -- link to scanned contract document
    remarks             VARCHAR2(1000),
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_hr_contract_number UNIQUE      (contract_number),
    CONSTRAINT chk_hr_contract_dates CHECK       (end_date IS NULL OR end_date >= start_date),
    CONSTRAINT chk_hr_contract_prob  CHECK       (probation_months IS NULL OR probation_months >= 0),
    CONSTRAINT chk_hr_contract_ntc   CHECK       (notice_period_days IS NULL OR notice_period_days >= 0),
    CONSTRAINT fk_hr_contract_person FOREIGN KEY (person_id)          REFERENCES dct_employees(person_id),
    CONSTRAINT fk_hr_contract_type   FOREIGN KEY (contract_type_id)   REFERENCES dct_lookup_values(value_id),
    CONSTRAINT fk_hr_contract_status FOREIGN KEY (contract_status_id) REFERENCES dct_lookup_values(value_id)
);

CREATE INDEX ix_hr_contract_person ON hr_employment_contracts(person_id);
CREATE INDEX ix_hr_contract_status ON hr_employment_contracts(contract_status_id, end_date);
CREATE INDEX ix_hr_contract_dates  ON hr_employment_contracts(start_date, end_date);

-- =============================================================================
-- 7. HR_SALARY_HISTORY
--    One row per salary change event (hire, promotion, annual increment …).
--    The most recent row per person_id is the current salary — see V_HR_SALARY_CURRENT.
--    previous_basic and change_percentage are snapped at insert time by the package.
-- =============================================================================
CREATE TABLE hr_salary_history (
    salary_id           NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    person_id           NUMBER          NOT NULL,            -- FK → DCT_EMPLOYEES
    effective_date      DATE            NOT NULL,
    basic_salary        NUMBER(15,2)    NOT NULL,
    currency_code       VARCHAR2(3)     DEFAULT 'AED' NOT NULL, -- FK → DCT_CURRENCY_CODES
    change_reason_id    NUMBER,                              -- FK → DCT_LOOKUP_VALUES (HR_SALARY_REASON)
    previous_basic      NUMBER(15,2),                        -- snapped from prior row
    change_percentage   NUMBER(6,2),                         -- ((new - old) / old) * 100
    approved_by         NUMBER,                              -- FK → DCT_USERS
    remarks             VARCHAR2(500),
    created_by          VARCHAR2(100),
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          VARCHAR2(100),
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_hr_sal_amount  CHECK       (basic_salary > 0),
    CONSTRAINT fk_hr_sal_person   FOREIGN KEY (person_id)        REFERENCES dct_employees(person_id),
    CONSTRAINT fk_hr_sal_ccy      FOREIGN KEY (currency_code)    REFERENCES dct_currency_codes(currency_code),
    CONSTRAINT fk_hr_sal_reason   FOREIGN KEY (change_reason_id) REFERENCES dct_lookup_values(value_id),
    CONSTRAINT fk_hr_sal_approver FOREIGN KEY (approved_by)      REFERENCES dct_users(user_id)
);

CREATE INDEX ix_hr_sal_person ON hr_salary_history(person_id, effective_date DESC);
CREATE INDEX ix_hr_sal_date   ON hr_salary_history(effective_date);

-- =============================================================================
-- 8. HR_EMPLOYEE_DOCUMENTS
--    Official personal documents per employee (passport, Emirates ID, visa, NOC …).
--    Links to DCT_DOCUMENT_TYPES for the type master.
--    Expiry tracking is done via V_HR_EXPIRING_DOCS view.
--    file_blob stores the scan; file_name / file_mime_type support download.
-- =============================================================================
CREATE TABLE hr_employee_documents (
    doc_id               NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    person_id            NUMBER          NOT NULL,           -- FK → DCT_EMPLOYEES
    doc_type_id          NUMBER          NOT NULL,           -- FK → DCT_DOCUMENT_TYPES
    doc_number           VARCHAR2(100),                      -- Passport no., Emirates ID no. …
    issue_date           DATE,
    expiry_date          DATE,
    issuing_authority    VARCHAR2(200),
    issuing_country_code VARCHAR2(3),                        -- FK → DCT_COUNTRIES
    doc_status_id        NUMBER,                             -- FK → DCT_LOOKUP_VALUES (HR_DOC_STATUS)
    file_blob            BLOB,
    file_name            VARCHAR2(500),
    file_mime_type       VARCHAR2(100),
    notes                VARCHAR2(500),
    created_by           VARCHAR2(100),
    created_at           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by           VARCHAR2(100),
    updated_at           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_hr_doc_dates  CHECK       (expiry_date IS NULL OR expiry_date >= issue_date),
    CONSTRAINT fk_hr_doc_person  FOREIGN KEY (person_id)            REFERENCES dct_employees(person_id),
    CONSTRAINT fk_hr_doc_type    FOREIGN KEY (doc_type_id)          REFERENCES dct_document_types(doc_type_id),
    CONSTRAINT fk_hr_doc_country FOREIGN KEY (issuing_country_code) REFERENCES dct_countries(country_code),
    CONSTRAINT fk_hr_doc_status  FOREIGN KEY (doc_status_id)        REFERENCES dct_lookup_values(value_id)
);

CREATE INDEX ix_hr_doc_person  ON hr_employee_documents(person_id);
CREATE INDEX ix_hr_doc_type    ON hr_employee_documents(doc_type_id);
CREATE INDEX ix_hr_doc_expiry  ON hr_employee_documents(person_id, doc_type_id, expiry_date);
CREATE INDEX ix_hr_doc_status  ON hr_employee_documents(doc_status_id);

-- =============================================================================
-- UPDATED_AT TRIGGERS
-- =============================================================================
CREATE OR REPLACE TRIGGER trg_hr_loc_upd
    BEFORE UPDATE ON hr_locations FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_hr_jf_upd
    BEFORE UPDATE ON hr_job_families FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_hr_job_upd
    BEFORE UPDATE ON hr_jobs FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_hr_pos_upd
    BEFORE UPDATE ON hr_positions FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_hr_asgn_upd
    BEFORE UPDATE ON hr_employee_assignments FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_hr_contract_upd
    BEFORE UPDATE ON hr_employment_contracts FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_hr_sal_upd
    BEFORE UPDATE ON hr_salary_history FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

CREATE OR REPLACE TRIGGER trg_hr_doc_upd
    BEFORE UPDATE ON hr_employee_documents FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

COMMIT;
PROMPT HR DDL complete — 8 tables, indexes, and triggers created.
