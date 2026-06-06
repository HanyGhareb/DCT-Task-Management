-- =============================================================================
-- i-Finance V2 — HR Module: Platform Table Alterations
-- File    : 02_hr_dct_alterations.sql
-- Schema  : PROD
-- =============================================================================
-- Alters two existing platform tables to support the HR module:
--
--   A. DCT_ORGANIZATIONS
--      - Drop the hard-coded org_type CHECK constraint
--      - Add org_type_id FK → DCT_LOOKUP_VALUES (HR_ORG_TYPE lookup category)
--      - Add location_id FK → HR_LOCATIONS (primary site for this org unit)
--      - Add headcount_ceiling, effective_from, effective_to, description cols
--      - Add cost_center_code for budget mapping
--
--   B. DCT_EMPLOYEES
--      - Add position_id FK → HR_POSITIONS (current budgeted position)
--      - Add location_id FK → HR_LOCATIONS (primary work location)
--      - Add contract_id (soft ref to active contract — no FK to avoid circular)
--      - Add marital_status_id FK → DCT_LOOKUP_VALUES (HR_MARITAL_STATUS)
--      - Add personal_email, work_phone, photo_url (employee-owned, not user-owned)
--
-- Note on org_type VARCHAR2(30):
--   The existing varchar column is kept as a soft cache / display label for
--   backward compatibility with existing APEX apps that reference it directly.
--   New code should join via org_type_id → DCT_LOOKUP_VALUES.value_name_en.
--   A post-seed UPDATE in 04_hr_seed.sql populates org_type_id from the
--   existing org_type varchar values.
--
-- Note on DCT_EMPLOYEES.contract_id:
--   No FK constraint — HR_EMPLOYMENT_CONTRACTS → DCT_EMPLOYEES already exists,
--   making a reverse FK circular. Application layer maintains this pointer.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- A. DCT_ORGANIZATIONS
-- =============================================================================

-- A1. Drop the hard-coded CHECK — org type values now live in DCT_LOOKUP_VALUES
ALTER TABLE dct_organizations DROP CONSTRAINT chk_dct_org_type;

-- A2. Add org_type_id as the new FK-driven type column
ALTER TABLE dct_organizations ADD (
    org_type_id       NUMBER,                                -- FK → DCT_LOOKUP_VALUES (HR_ORG_TYPE)
    location_id       NUMBER,                                -- FK → HR_LOCATIONS (primary site)
    headcount_ceiling NUMBER,                                -- max approved FTEs for this unit
    effective_from    DATE,                                  -- org unit activation date
    effective_to      DATE,                                  -- org unit end date (NULL = active)
    description_en    VARCHAR2(500),
    description_ar    VARCHAR2(500),
    cost_center_code  VARCHAR2(20)                           -- soft link to GL cost center
);

-- A3. FK constraints for new columns
ALTER TABLE dct_organizations
    ADD CONSTRAINT fk_dct_org_type_lv
    FOREIGN KEY (org_type_id) REFERENCES dct_lookup_values(value_id);

-- FK to HR_LOCATIONS — HR_LOCATIONS was created in 01_hr_ddl.sql
ALTER TABLE dct_organizations
    ADD CONSTRAINT fk_dct_org_location
    FOREIGN KEY (location_id) REFERENCES hr_locations(location_id);

-- A4. Date consistency check
ALTER TABLE dct_organizations
    ADD CONSTRAINT chk_dct_org_eff_dates
    CHECK (effective_to IS NULL OR effective_to >= effective_from);

-- A5. Indexes for new FK columns
CREATE INDEX ix_dct_org_type_lv   ON dct_organizations(org_type_id);
CREATE INDEX ix_dct_org_location  ON dct_organizations(location_id);
CREATE INDEX ix_dct_org_eff       ON dct_organizations(effective_from, effective_to);

-- =============================================================================
-- B. DCT_EMPLOYEES
-- =============================================================================

-- B1. Add HR-module columns to the employee master
ALTER TABLE dct_employees ADD (
    position_id       NUMBER,                                -- FK → HR_POSITIONS (current position)
    location_id       NUMBER,                                -- FK → HR_LOCATIONS (primary work location)
    contract_id       NUMBER,                                -- soft ref to active HR_EMPLOYMENT_CONTRACTS row
    marital_status_id NUMBER,                                -- FK → DCT_LOOKUP_VALUES (HR_MARITAL_STATUS)
    personal_email    VARCHAR2(255),                         -- non-work email
    work_phone        VARCHAR2(20),                          -- office extension
    photo_url         VARCHAR2(500)                          -- profile photo URL (OCI Object Storage or APEX)
);

-- B2. FK constraints
ALTER TABLE dct_employees
    ADD CONSTRAINT fk_dct_emp_position
    FOREIGN KEY (position_id) REFERENCES hr_positions(position_id);

ALTER TABLE dct_employees
    ADD CONSTRAINT fk_dct_emp_location
    FOREIGN KEY (location_id) REFERENCES hr_locations(location_id);

ALTER TABLE dct_employees
    ADD CONSTRAINT fk_dct_emp_marital
    FOREIGN KEY (marital_status_id) REFERENCES dct_lookup_values(value_id);

-- B3. Indexes for new columns
CREATE INDEX ix_dct_emp_position ON dct_employees(position_id);
CREATE INDEX ix_dct_emp_location ON dct_employees(location_id);

COMMIT;
PROMPT DCT_ORGANIZATIONS and DCT_EMPLOYEES alterations complete.
