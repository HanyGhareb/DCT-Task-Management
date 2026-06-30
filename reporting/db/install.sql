-- =============================================================================
-- i-Finance V2 -- Reporting Platform : master install (Phase 0 control plane)
-- Run as : sql -name prod_mcp   (FRESH session -- do NOT follow an ALTER SESSION
--          SET CURRENT_SCHEMA=PROD run; the ORDS/synonym scripts self-reference
--          ORA-01471 otherwise). Ensure UTF-8: set JAVA_TOOL_OPTIONS to
--          -Dfile.encoding=UTF-8 before launching so Arabic seeds store cleanly.
-- Order matters: DDL -> lookups -> package -> ORDS -> scheduler -> seed.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
@@01_rpt_ddl.sql
@@02_rpt_lookups.sql
@@03_rpt_pkg.sql
@@04_rpt_ords.sql
@@05_rpt_sched_sync.sql
@@06_rpt_native_pkg.sql
@@07_rpt_seed.sql
PROMPT ============================================================
PROMPT  Reporting Platform Phase 0 install complete.
PROMPT  Next: EXEC prod.dct_rpt_sched_sync; to build schedule jobs.
PROMPT ============================================================
