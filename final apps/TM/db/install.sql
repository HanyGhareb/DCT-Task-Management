-- =============================================================================
-- Task Management Module (App 207) -- master install
-- Run     : sql -name prod_mcp @install.sql
-- Order   : DDL -> seed -> key results -> cycle DDL/seed -> views (+cycle views)
--           -> packages (core, vis, cycle, reminder) -> jobs.
--
-- IMPORTANT: the ORDS scripts (06_tm_ords.sql THEN 14_tm_cycle_ords.sql) are
-- intentionally NOT included here. The scripts below run
-- `ALTER SESSION SET CURRENT_SCHEMA = PROD`; the ORDS scripts create ADMIN
-- synonyms and MUST run in a SEPARATE fresh SQLcl session, or the synonyms
-- self-reference (ORA-01471). After this script completes, run (same fresh session):
--     sql -name prod_mcp @06_tm_ords.sql
--     @14_tm_cycle_ords.sql
-- ORDER MATTERS: 06 does ORDS.DELETE_MODULE('tm.rest') then recreates it; 14
-- ADDS the cycle/visibility/exec routes to that module. Running 06 alone wipes
-- 14's handlers -- always run 14 right after 06.
--
-- Pre-reqs: db/v2/install.sql (shared framework: DCT_USERS, DCT_ORGANIZATIONS,
-- DCT_DOCUMENTS, DCT_LOOKUP_*, DCT_NOTIFY, DCT_REST, DCT_AUTH) already deployed.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT ===== [1/11] 01_tm_ddl.sql =====
@@01_tm_ddl.sql
PROMPT ===== [2/11] 03_tm_seed.sql =====
@@03_tm_seed.sql
PROMPT ===== [3/11] 08_tm_key_results.sql =====
@@08_tm_key_results.sql
PROMPT ===== [4/11] 09_tm_cycle_ddl.sql =====
@@09_tm_cycle_ddl.sql
PROMPT ===== [5/11] 10_tm_cycle_seed.sql =====
@@10_tm_cycle_seed.sql
PROMPT ===== [6/11] 02_tm_views.sql =====
@@02_tm_views.sql
PROMPT ===== [7/11] 13_tm_cycle_views.sql =====
@@13_tm_cycle_views.sql
PROMPT ===== [8/11] 04_tm_pkg.sql =====
@@04_tm_pkg.sql
PROMPT ===== [9/11] 11_tm_vis_pkg.sql =====
@@11_tm_vis_pkg.sql
PROMPT ===== [10/11] 12_tm_cycle_pkg.sql =====
@@12_tm_cycle_pkg.sql
PROMPT ===== [11/12] 05_tm_reminder_pkg.sql =====
@@05_tm_reminder_pkg.sql
PROMPT ===== [12/12] 16_tm_ai_pkg.sql (AI period summariser; reuses AR ANTHROPIC key) =====
@@16_tm_ai_pkg.sql
PROMPT ===== jobs: 07_tm_jobs.sql + 15_tm_cycle_jobs.sql =====
@@07_tm_jobs.sql
@@15_tm_cycle_jobs.sql

PROMPT
PROMPT =============================================================
PROMPT TM schema install complete.
PROMPT NEXT (fresh session): sql -name prod_mcp @06_tm_ords.sql  then  @14_tm_cycle_ords.sql
PROMPT Smoke test (optional):  @test/tm_smoke_test.sql
PROMPT =============================================================
