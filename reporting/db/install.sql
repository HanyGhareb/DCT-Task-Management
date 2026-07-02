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
-- (08/08a/08b Budget-Util-by-Sector pack and 09/09a workers layer run
--  separately: 08 needs the db/v2/39 data views deployed first)
@@10_rpt_param_lov.sql
@@12_rpt_ir.sql
@@14_rpt_lov_converge.sql
@@12a_rpt_ir_pkg.sql
@@12b_rpt_ir_ords.sql
-- (15_bi_user_rollout.sql is optional -- edit its username list, then run
--  it whenever business users need the BI_USER role)
PROMPT ============================================================
PROMPT  Reporting Platform install complete (incl. Interactive Report).
PROMPT  Next: EXEC prod.dct_rpt_sched_sync; to build schedule jobs.
PROMPT  If 04 is ever re-run, re-run 08b + 09a + 10 + 12b after it.
PROMPT ============================================================
