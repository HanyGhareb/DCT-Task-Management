-- =============================================================================
-- Petty Cash Module — Master Install Script
-- File    : install.sql
-- Module  : PETTY_CASH (f101)
-- =============================================================================
-- Prerequisites:
--   The shared V2 framework must be installed first:
--     cd db/v2 && sqlcl -name prod_mcp @install.sql
--
-- Run this from SQLcl as the PROD schema owner:
--   cd db/petty-cash
--   sqlcl -name prod_mcp @install.sql
--
-- To reinstall clean:
--   Uncomment the DROP sections at the top of 01_pc_ddl.sql, then re-run.
-- =============================================================================

SET ECHO ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT ============================================================
PROMPT  Step 1/5 — DDL: Tables, indexes, triggers
PROMPT  (petty cash transaction tables; DCT_GL_CODE_COMBINATIONS is
PROMPT   in the V2 Admin module — db/v2/01_dct_ddl.sql)
PROMPT ============================================================
@@01_pc_ddl.sql

PROMPT ============================================================
PROMPT  Step 2/5 — Views: Project budget + summary + admin views
PROMPT  NOTE: DCT_PROJECT_BUDGET_V requires PROJECTS, PROJECT_TASKS,
PROMPT        PROJECT_EXPENDITURE_TYPES, PROJECT_BALANCES to exist.
PROMPT        If they are missing, comment out that view in 02_pc_views.sql.
PROMPT ============================================================
@@02_pc_views.sql

PROMPT ============================================================
PROMPT  Step 3/5 — Seed: Module registration, roles, permissions,
PROMPT  module settings defaults, approval workflow templates + steps
PROMPT ============================================================
@@03_pc_seed.sql

PROMPT ============================================================
PROMPT  Step 4/5 — Package: DCT_PC_PKG + scheduler jobs
PROMPT ============================================================
@@04_pc_pkg.sql

PROMPT ============================================================
PROMPT  Step 5/5 — Alter: disbursed_by column + new module settings
PROMPT  (idempotent — safe to re-run on existing install)
PROMPT ============================================================
@@05_pc_alter.sql

PROMPT ============================================================
PROMPT  Petty Cash module install complete.
PROMPT
PROMPT  NEXT STEPS:
PROMPT    1. Load DCT_GL_CODE_COMBINATIONS data via App 200 (GL Management)
PROMPT    2. Verify DCT_PROJECT_BUDGET_V resolves against your project tables
PROMPT    3. In APEX Builder, create App 201 pages using the APEX_SETUP.md guide
PROMPT    4. Assign AP_PETTY_CASH_ADMIN role to AP team users via App 200
PROMPT    5. Review and adjust approval workflow steps via the Admin UI
PROMPT    6. Review module settings via the Module Settings admin page
PROMPT ============================================================

EXIT 0
