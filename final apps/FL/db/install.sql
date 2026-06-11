-- =============================================================================
-- Freelancers Module (App 203) — Master Install Script
-- File    : install.sql
-- Run     : Via SQLcl — execute each script individually with full path
--           sql -name prod_mcp < "final apps/FL/db/01_fl_ddl.sql"
--           sql -name prod_mcp < "final apps/FL/db/02_fl_views.sql"
--           sql -name prod_mcp < "final apps/FL/db/03_fl_seed.sql"
--           sql -name prod_mcp < "final apps/FL/db/04_fl_pkg.sql"
-- =============================================================================
-- Prerequisites:
--   1. db/v2/install.sql complete (provides DCT_GL_CODE_COMBINATIONS and approval tables)
--   2. DCT_APPROVAL_TEMPLATES, DCT_APPROVAL_STEPS tables exist (part of V2 install)
-- =============================================================================

PROMPT
PROMPT === Freelancers Module Install ===
PROMPT Run each script individually via SQLcl with full path.
PROMPT
PROMPT Step 1/7 — DDL  : sql -name prod_mcp < "final apps/FL/db/01_fl_ddl.sql"
PROMPT Step 2/7 — Views: sql -name prod_mcp < "final apps/FL/db/02_fl_views.sql"
PROMPT Step 3/7 — Seed : sql -name prod_mcp < "final apps/FL/db/03_fl_seed.sql"
PROMPT Step 4/7 — Pkg   : sql -name prod_mcp < "final apps/FL/db/04_fl_pkg.sql"
PROMPT Step 5/7 — Alter : sql -name prod_mcp < "final apps/FL/db/05_fl_alter_audit_cols.sql"
PROMPT Step 6/7 — Phase 2 adoption (REQUIRES db/v2/15 first; fresh ADMIN session):
PROMPT             sql -name prod_mcp < "final apps/FL/db/06_fl_unified_adoption.sql"
PROMPT             (drops dct_fl_documents / dct_fl_doc_expiry_alerts — superseded
PROMPT              by unified DCT_DOCUMENTS / DCT_DOC_EXPIRY_ALERTS)
PROMPT Step 7/7 — Re-run 02_fl_views.sql then 04_fl_pkg.sql after step 6.
PROMPT
PROMPT See APEX_SETUP.md for APEX App 203 build instructions.
PROMPT
