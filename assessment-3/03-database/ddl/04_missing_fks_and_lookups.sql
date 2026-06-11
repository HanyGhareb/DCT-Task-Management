-- ============================================================================
-- DRAFT — NOT DEPLOYED — assessment-3 proposal only. Do NOT run against PROD.
-- (A) Adds missing FKs from free-text reference columns to existing masters.
-- (B) Migrates hard-coded CHECK-constraint enums into dct_lookup_values,
--     following the proven HR grade-category pattern
--     (final apps/HR/db/_archive/patch_grade_category_lookup.sql).
-- All FKs added ENABLE NOVALIDATE first (existing-data orphans reported and
-- fixed before VALIDATE) — same approach as db/v2/12_dct_master_data.sql.
-- ============================================================================
SET DEFINE OFF

-- ----------------------------------------------------------------------------
-- (A) Missing foreign keys
-- NOTE: interim step if the unified dct_budget_coding_lines table (script 02)
-- is not adopted immediately. Prefer script 02; these are the minimum-change
-- alternative on the EXISTING tables.
-- ----------------------------------------------------------------------------

-- Orphan check examples to run BEFORE each constraint:
--   SELECT DISTINCT l.project_number FROM prod.dct_pc_budget_lines l
--   WHERE l.project_number IS NOT NULL
--   AND NOT EXISTS (SELECT 1 FROM prod.dct_projects p
--                   WHERE p.project_number = l.project_number);

ALTER TABLE prod.dct_pc_budget_lines ADD CONSTRAINT fk_pcbl_project
  FOREIGN KEY (project_number) REFERENCES prod.dct_projects (project_number)
  ENABLE NOVALIDATE;

ALTER TABLE prod.dct_pc_budget_lines ADD CONSTRAINT fk_pcbl_exptype
  FOREIGN KEY (expenditure_type) REFERENCES prod.dct_expenditure_types (exp_type_code)
  ENABLE NOVALIDATE;

-- (repeat the same pair for dct_pc_reimb_budget_lines, dct_pc_clear_budget_lines,
--  dct_cc_reimb_lines, and the inline columns on dt_requests / dct_fl_contracts)

-- FL bank accounts: free-text bank_name although dct_bank_codes master exists
ALTER TABLE prod.dct_fl_bank_accounts ADD (bank_code VARCHAR2(20));
ALTER TABLE prod.dct_fl_bank_accounts ADD CONSTRAINT fk_flba_bank
  FOREIGN KEY (bank_code) REFERENCES prod.dct_bank_codes (bank_code)
  ENABLE NOVALIDATE;
-- backfill: UPDATE ... SET bank_code = (match on UPPER(bank_name)), then
-- deprecate bank_name once backfilled.

-- ----------------------------------------------------------------------------
-- (B) CHECK-constraint enums -> lookups
-- Candidates (business-changeable values only; pure technical states stay as CHECKs):
--   PC_TYPE          : TEMPORARY | PERMANENT          (dct_petty_cash.pc_type)
--   DT_MISSION_TYPE  : BUSINESS_MISSION | TRAINING    (dt_requests.mission_type)
--   DT_TRIP_TYPE     : INTERNAL | EXTERNAL            (dt_requests.trip_type)
--   CC_REPLACE_REASON: DAMAGED|LOST|EXPIRING|OTHER    (dct_cc_requests.replacement_reason)
--   FL_BILLING_METHOD: (values per dct_fl_contracts.billing_method)
-- Pattern per enum (shown once for DT_MISSION_TYPE):

-- 1. Seed category + values (individual INSERTs — INSERT ALL + IDENTITY = ORA-00001)
INSERT INTO prod.dct_lookup_categories (category_code, category_name_en, is_system)
  VALUES ('DT_MISSION_TYPE', 'Duty Travel Mission Type', 'Y');
INSERT INTO prod.dct_lookup_values (category_id, value_code, value_name_en, display_order)
  SELECT category_id, 'BUSINESS_MISSION', 'Business Mission', 10
  FROM prod.dct_lookup_categories WHERE category_code = 'DT_MISSION_TYPE';
INSERT INTO prod.dct_lookup_values (category_id, value_code, value_name_en, display_order)
  SELECT category_id, 'TRAINING', 'Training', 20
  FROM prod.dct_lookup_categories WHERE category_code = 'DT_MISSION_TYPE';

-- 2. Replace the CHECK with a lookup-validating trigger or keep the CHECK as a
--    safety net and have UI LOVs read the lookup (recommended: LOV from lookup,
--    drop CHECK only when business confirms values will change at runtime).
-- ALTER TABLE prod.dt_requests DROP CONSTRAINT ck_dt_req_mission_type;

COMMIT;

-- ----------------------------------------------------------------------------
-- (C) Compatibility synonyms for the naming convention (proposal §7):
-- ----------------------------------------------------------------------------
-- CREATE OR REPLACE SYNONYM prod.dct_dt_requests FOR prod.dt_requests;
-- CREATE OR REPLACE SYNONYM prod.dct_hr_positions FOR prod.hr_positions;
-- (etc. — generate from user_tables where table_name LIKE 'DT\_%' ESCAPE '\')
