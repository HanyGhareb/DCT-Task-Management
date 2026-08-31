-- Copy to the next numbered file, for example 48_atd_job_quality.sql.
-- Production migrations must preserve existing data and be safe to rerun.
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- Example: safely add a column.
-- BEGIN
--   EXECUTE IMMEDIATE
--     'ALTER TABLE prod.atd_otbi_jobs ADD (new_column VARCHAR2(100))';
-- EXCEPTION
--   WHEN OTHERS THEN
--     IF SQLCODE != -1430 THEN RAISE; END IF; -- column already exists
-- END;
-- /

-- Column retirement policy:
-- Release 1: stop all code from reading/writing the old column.
-- Release 2: rename it to UNUSED_<name> after dependency checks and backup.
-- Later:     drop it only after the agreed recovery period.

COMMIT;
WHENEVER SQLERROR CONTINUE
