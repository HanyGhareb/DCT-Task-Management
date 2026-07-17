-- ===========================================================================
-- otbi-atd : FIRST-TIME install only (Track A, in-ATP)
-- Runs 01 -> 04 in order. Connect first:  sql -name prod_mcp
-- Then:  @install.sql   (from this db/ folder)
-- Review 02 (set the pod host) and seed prod.atd_secret before scheduling.
-- SAFETY: this script stops if an OTBI Loader installation already exists.
-- Existing environments must use upgrade.sql / numbered additive scripts.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT ============ safety check =================
DECLARE
  l_existing PLS_INTEGER;
BEGIN
  SELECT COUNT(*)
    INTO l_existing
    FROM all_tables
   WHERE owner = 'PROD'
     AND table_name IN ('ATD_OTBI_ENV', 'ATD_TARGET_DB',
                        'ATD_OTBI_JOBS', 'ATD_LOAD_RUN_LOG');

  IF l_existing > 0 THEN
    RAISE_APPLICATION_ERROR(
      -20001,
      'STOPPED: OTBI Loader is already installed (' || l_existing ||
      ' control table(s) found). Use upgrade.sql or a numbered additive script; ' ||
      'install.sql is for an empty environment only.');
  END IF;
END;
/

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
WHENEVER SQLERROR CONTINUE
