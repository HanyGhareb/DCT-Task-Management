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
PROMPT Step 1/4 — DDL  : sql -name prod_mcp < "final apps/FL/db/01_fl_ddl.sql"
PROMPT Step 2/4 — Views: sql -name prod_mcp < "final apps/FL/db/02_fl_views.sql"
PROMPT Step 3/4 — Seed : sql -name prod_mcp < "final apps/FL/db/03_fl_seed.sql"
PROMPT Step 4/4 — Pkg  : sql -name prod_mcp < "final apps/FL/db/04_fl_pkg.sql"
PROMPT
PROMPT See APEX_SETUP.md for APEX App 203 build instructions.
PROMPT
