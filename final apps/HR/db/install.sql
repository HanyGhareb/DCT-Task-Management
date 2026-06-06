-- =============================================================================
-- i-Finance V2 — HR Module: Master Install Script
-- File    : install.sql
-- =============================================================================
-- Run order (strict — each file depends on the previous):
--
--   01_hr_ddl.sql             — 8 HR_ tables, indexes, triggers
--   02_hr_dct_alterations.sql — ALTER DCT_ORGANIZATIONS + DCT_EMPLOYEES
--   03_hr_views.sql           — 6 analytical views
--   04_hr_seed.sql            — lookup categories, values, sample data
--   05_hr_pkg.sql             — DCT_HR PL/SQL package (spec + body)
--   06_hr_ords.sql            — ORDS module + all endpoints
--
-- Prerequisites (must already be installed and committed):
--   db/v2/install.sql                  (platform tables: orgs, users, modules …)
--   db/v2/12_dct_master_data.sql       (employees, grades, countries, GL codes …)
--
-- How to run (SQLcl):
--   sql -name prod_mcp
--   @"c:\claude\DCT-task-management\DCT-Task-Management\final apps\HR\db\install.sql"
-- =============================================================================

PROMPT ============================================================
PROMPT  i-Finance V2 — HR Module Install
PROMPT  $(TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'))
PROMPT ============================================================

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT
PROMPT [1/6] HR tables, indexes, triggers ...
@@01_hr_ddl.sql

PROMPT
PROMPT [2/6] Platform table alterations (DCT_ORGANIZATIONS, DCT_EMPLOYEES) ...
@@02_hr_dct_alterations.sql

PROMPT
PROMPT [3/6] Analytical views ...
@@03_hr_views.sql

PROMPT
PROMPT [4/6] Seed data (lookups, locations, jobs) ...
@@04_hr_seed.sql

PROMPT
PROMPT [5/6] DCT_HR PL/SQL package ...
@@05_hr_pkg.sql

PROMPT
PROMPT [6/6] ORDS endpoints ...
@@06_hr_ords.sql

PROMPT
PROMPT ============================================================
PROMPT  HR Module install COMPLETE
PROMPT ============================================================
PROMPT  Tables   : HR_LOCATIONS, HR_JOB_FAMILIES, HR_JOBS,
PROMPT             HR_POSITIONS, HR_EMPLOYEE_ASSIGNMENTS,
PROMPT             HR_EMPLOYMENT_CONTRACTS, HR_SALARY_HISTORY,
PROMPT             HR_EMPLOYEE_DOCUMENTS
PROMPT  Altered  : DCT_ORGANIZATIONS, DCT_EMPLOYEES
PROMPT  Views    : V_HR_ORG_TREE, V_HR_HEADCOUNT, V_HR_EMPLOYEE_FULL,
PROMPT             V_HR_EXPIRING_DOCS, V_HR_ACTIVE_CONTRACTS,
PROMPT             V_HR_SALARY_CURRENT
PROMPT  Package  : DCT_HR (spec + body)
PROMPT  ORDS     : /ords/admin/dct/hr/* (20 endpoints)
PROMPT ============================================================
