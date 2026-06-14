-- =============================================================================
-- Task Management Module (App 207) -- master install
-- Run     : sql -name prod_mcp @install.sql
-- Order   : DDL -> seed -> views -> package -> reminder pkg -> jobs.
--
-- IMPORTANT: 06_tm_ords.sql is intentionally NOT included here. The scripts
-- below run `ALTER SESSION SET CURRENT_SCHEMA = PROD`; the ORDS script creates
-- ADMIN synonyms and MUST run in a SEPARATE fresh SQLcl session, or the
-- synonyms self-reference (ORA-01471). After this script completes, run:
--     sql -name prod_mcp @06_tm_ords.sql
--
-- Pre-reqs: db/v2/install.sql (shared framework: DCT_USERS, DCT_ORGANIZATIONS,
-- DCT_DOCUMENTS, DCT_LOOKUP_*, DCT_NOTIFY, DCT_REST, DCT_AUTH) already deployed.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT ===== [1/6] 01_tm_ddl.sql =====
@@01_tm_ddl.sql
PROMPT ===== [2/6] 03_tm_seed.sql =====
@@03_tm_seed.sql
PROMPT ===== [3/6] 02_tm_views.sql =====
@@02_tm_views.sql
PROMPT ===== [4/6] 04_tm_pkg.sql =====
@@04_tm_pkg.sql
PROMPT ===== [5/6] 05_tm_reminder_pkg.sql =====
@@05_tm_reminder_pkg.sql
PROMPT ===== [6/6] 07_tm_jobs.sql =====
@@07_tm_jobs.sql

PROMPT
PROMPT =============================================================
PROMPT TM schema install complete.
PROMPT NEXT (fresh session): sql -name prod_mcp @06_tm_ords.sql
PROMPT Smoke test (optional):  @test/tm_smoke_test.sql
PROMPT =============================================================
