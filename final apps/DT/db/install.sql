-- =============================================================================
-- Duty Travel Module (App 204) — Master Install Script
-- File    : install.sql
-- Schema  : PROD
-- Prereq  : db/v2/install.sql must already be complete
-- Run via : SQLcl connected as ADMIN (sql -name prod_mcp)
-- =============================================================================

PROMPT
PROMPT ============================================================
PROMPT  Duty Travel Module (App 204) — Install
PROMPT ============================================================
PROMPT

@01_dt_ddl.sql
@02_dt_seed.sql
@03_dt_views.sql
@04_dct_dt_pkg.sql

PROMPT
PROMPT ============================================================
PROMPT  Duty Travel Module install complete.
PROMPT  Next steps:
PROMPT    1. Create App 204 in APEX Builder (schema = PROD, alias = DT)
PROMPT    2. Subscribe to App 200 authentication scheme (DCT Auth)
PROMPT    3. Create standard app items and SET_APP_ITEMS process
PROMPT    4. Create module-specific app items: APP_IS_DT_ADMIN,
PROMPT       APP_IS_DT_FINANCE, APP_IS_DT_MANAGER
PROMPT    5. Subscribe to common LOVs from App 200
PROMPT    6. Build pages per BRD section 10
PROMPT  See: final apps/DT/docs/BRD.md
PROMPT ============================================================
