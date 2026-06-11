-- =============================================================================
-- Credit Cards Module (App 202) — Master Install Script
-- File    : install.sql
-- Run     : Via SQLcl connected as ADMIN (prod_mcp)
--           cmd /c "C:\claude\tools\sqlcl\sqlcl\bin\sql.exe -name prod_mcp < install.sql 2>&1"
-- Requires: V2 shared framework installed (db/v2/install.sql + 01b_dct_ddl_alterations.sql)
--           (DCT_GL_CODE_COMBINATIONS is part of the V2 framework — no PC module dependency)
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF

PROMPT ============================================================
PROMPT  Credit Cards Module — Install
PROMPT  Date: 2026-05-13
PROMPT ============================================================

-- Step 1: DDL — tables, indexes, triggers
PROMPT
PROMPT [Step 1] Running 01_cc_ddl.sql ...
@01_cc_ddl.sql

-- Step 2: Views
PROMPT
PROMPT [Step 2] Running 02_cc_views.sql ...
@02_cc_views.sql

-- Step 3: Seed data
PROMPT
PROMPT [Step 3] Running 03_cc_seed.sql ...
@03_cc_seed.sql

-- Step 4: Migrate audit columns (created_by/updated_by: NUMBER → VARCHAR2(100))
--         Run once after initial DDL install; idempotent — safe to re-run.
PROMPT
PROMPT [Step 4] Running 05_cc_alter_audit_cols.sql ...
@05_cc_alter_audit_cols.sql

-- Step 5: Add DCT_CC_CARD_LIMIT_HISTORY — immutable credit limit change log
--         Idempotent — safe to re-run on existing install.
PROMPT
PROMPT [Step 5] Running 06_cc_card_limit_history.sql ...
@06_cc_card_limit_history.sql

-- Step 6: Consolidate DCT_CC_DELEGATION → V2 DCT_DELEGATIONS
--         Drops the module-local table; creates DCT_CC_DELEGATION_V view.
--         Idempotent — safe to re-run on existing install.
PROMPT
PROMPT [Step 6] Running 07_cc_consolidate_delegation.sql ...
@07_cc_consolidate_delegation.sql

-- Step 7: Phase 2 unified-structure adoption (REQUIRES db/v2/15 first).
--         Drops dct_cc_attachments / dct_cc_reimb_lines / dct_cc_doc_requirements
--         (superseded by DCT_DOCUMENTS / DCT_BUDGET_CODING_LINES /
--         DCT_DOC_REQUIREMENTS), removes status CHECKs (lookup-first), and
--         simplifies card statuses to ACTIVE|INACTIVE|CLOSED.
--         MUST run in a fresh ADMIN session (it creates ADMIN synonyms) —
--         then re-run 02_cc_views.sql and 04_cc_pkg.sql.
PROMPT
PROMPT [Step 7] Running 08_cc_unified_adoption.sql ...
@08_cc_unified_adoption.sql
@02_cc_views.sql

-- Step 8: Business-logic package (after adoption so it compiles against
--         the unified tables)
PROMPT
PROMPT [Step 8] Running 04_cc_pkg.sql ...
@04_cc_pkg.sql

PROMPT
PROMPT ============================================================
PROMPT  Credit Cards Module install complete.
PROMPT  Next: Run app/01_sequences.sql, then build App 202 in APEX.
PROMPT  See: final apps/CC/docs/APEX_SETUP.md
PROMPT ============================================================
