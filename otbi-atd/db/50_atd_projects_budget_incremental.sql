-- ===========================================================================
-- 50_atd_projects_budget_incremental.sql
-- Incremental delta-load companion for the "Projects Budget Full" extract.
--
-- The full extract (analysis PROJECTS_BUDGET_PERIODS -> ATD_PROJECTS_BUDGET)
-- takes 4+ minutes and was running hourly. This splits the schedule into:
--   * "Projects Budget Full"        : daily TRUNCATE_INSERT baseline (authoritative;
--                                     the only path that reflects deletes / closed
--                                     lines / removed rows -- a delta MERGE cannot).
--   * "Projects Budget Incremental" : frequent (default hourly) MERGE of the rows
--                                     changed in the last N hours (source-side
--                                     "Update Date >= now - N h" filter) into the
--                                     SAME target table, keyed on the natural grain.
--
-- Row key (verified unique, 0 duplicate groups over 1,836 rows):
--   PROJECT_ID, TASK_ID, EXPENDITURE_TYPE, ACCOUNTING_PERIOD
--
-- This script is re-runnable and INERT: the incremental job is registered
-- DISABLED (enabled='N'). Enable it only after the source-side filter mechanism
-- is verified on the pod, and flip the full job to daily (STEP 4) LAST so data
-- freshness never regresses in the gap.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

-- --- STEP 1 : staging table (exact column/type match to the final table) -----
-- CTAS WHERE 1=0 clones every column + type of ATD_PROJECTS_BUDGET so the MERGE
-- (which reads column types from the STAGE table) binds cleanly. Re-runnable.
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_project_budget_stg PURGE';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;   -- -942 = table did not exist
END;
/

CREATE TABLE prod.atd_project_budget_stg
AS SELECT * FROM prod.atd_projects_budget WHERE 1 = 0;

-- --- STEP 2 : register the incremental MERGE job (DISABLED) -------------------
-- Cloned from "Projects Budget Full" for env/target/source/column-map, then the
-- delta-specific fields overridden. params_json carries the look-back window as a
-- job-level runner directive (_atd_since_hours) so the window is configurable per
-- job without code changes. enabled='N' until the source-side filter is verified.
DELETE FROM prod.atd_otbi_jobs WHERE job_name = 'Projects Budget Incremental';

INSERT INTO prod.atd_otbi_jobs (
  job_name, env_name, target_name, source_ref, output_format, params_json,
  stage_table, final_table, load_mode, key_columns, column_map_json,
  frequency_minutes, enabled, run_status, priority, run_order)
SELECT
  'Projects Budget Incremental',
  f.env_name,
  f.target_name,
  f.source_ref,                                   -- same analysis (Option A: runner filters via Go-URL)
  'csv',
  '{"_atd_since_hours": 24}',                      -- look-back window (hours); configurable per job
  'PROD.ATD_PROJECT_BUDGET_STG',
  'PROD.ATD_PROJECTS_BUDGET',
  'MERGE',
  'PROJECT_ID,TASK_ID,EXPENDITURE_TYPE,ACCOUNTING_PERIOD',
  f.column_map_json,                               -- identical grain/headers -> reuse the map
  60,                                              -- cadence (minutes); configurable per job
  'N',                                             -- DISABLED until the filter is verified on the pod
  'DONE',
  f.priority,
  f.run_order
FROM prod.atd_otbi_jobs f
WHERE f.job_name = 'Projects Budget Full';

COMMIT;

-- --- STEP 3 : verify ---------------------------------------------------------
PROMPT ===== staging table columns =====
SELECT column_name, data_type, data_length
FROM   user_tab_columns
WHERE  table_name = 'ATD_PROJECT_BUDGET_STG'
ORDER  BY column_id;

PROMPT ===== registered jobs (full + incremental) =====
SELECT job_name, enabled, load_mode, stage_table, final_table,
       key_columns, frequency_minutes, params_json
FROM   prod.atd_otbi_jobs
WHERE  job_name IN ('Projects Budget Full', 'Projects Budget Incremental')
ORDER  BY job_name;

-- --- STEP 4 : (RUN LAST, AFTER the incremental job is enabled & verified) -----
-- Flip the full baseline from hourly to daily. Kept commented so freshness does
-- not drop before the incremental is carrying the hourly deltas.
--   UPDATE prod.atd_otbi_jobs SET frequency_minutes = 1440
--   WHERE job_name = 'Projects Budget Full';
--   COMMIT;

EXIT
