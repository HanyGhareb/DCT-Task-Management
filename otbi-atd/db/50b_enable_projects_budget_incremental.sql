-- ===========================================================================
-- 50b_enable_projects_budget_incremental.sql
-- Run AFTER the variant analysis PROJECTS_BUDGET_PERIODS_UH24 exists and a delta
-- download is confirmed. Points the incremental job at the filtered variant and
-- enables it. The full -> daily flip (STEP 2) runs only after one clean delta run.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

-- --- STEP 1 : point the incremental job at the baked 24h variant + enable -----
UPDATE prod.atd_otbi_jobs
SET    source_ref = '/users/haghareb@dctabudhabi.ae/Data/Projects/prod/Projects/PROJECTS_BUDGET_PERIODS_UH24',
       params_json = NULL,                 -- filter is baked in the analysis (Option B); no runner directive needed
       enabled = 'Y'
WHERE  job_name = 'Projects Budget Incremental';
COMMIT;

PROMPT ===== jobs after enable =====
SELECT job_name, enabled, load_mode, source_ref, frequency_minutes
FROM   prod.atd_otbi_jobs
WHERE  job_name IN ('Projects Budget Full','Projects Budget Incremental')
ORDER  BY job_name;

-- --- STEP 2 : (RUN LAST) flip the full baseline to daily ----------------------
-- Only after a clean incremental delta run is confirmed in ATD_LOAD_RUN_LOG.
--   UPDATE prod.atd_otbi_jobs SET frequency_minutes = 1440
--   WHERE job_name = 'Projects Budget Full';
--   COMMIT;

EXIT
