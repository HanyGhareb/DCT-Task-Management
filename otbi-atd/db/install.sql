-- ===========================================================================
-- otbi-atd : master install (Track A, in-ATP)
-- Runs 01 -> 04 in order. Connect first:  sql -name prod_mcp
-- Then:  @install.sql   (from this db/ folder)
-- Review 02 (set the pod host) and seed prod.atd_secret before scheduling.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON
SET SERVEROUTPUT ON

PROMPT ============ 01 control tables ============
@@01_atd_control_tables.sql
PROMPT ============ 02 network ACL ===============
@@02_atd_network_acl.sql
PROMPT ============ 03 ATD_OTBI_PKG ==============
@@03_atd_otbi_pkg.sql
PROMPT ============ 04 scheduler =================
@@04_atd_scheduler.sql

PROMPT
PROMPT otbi-atd install complete.
PROMPT Next: seed prod.atd_otbi_env / atd_target_db / atd_otbi_jobs / atd_secret,
PROMPT       then EXEC prod.atd_otbi_pkg.run_job('<job>') to test, then atd_sched_sync.
