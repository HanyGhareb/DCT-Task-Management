-- ===========================================================================
-- otbi-atd db/66 : Projects Budget V2 becomes THE scheduled budget extract
--
-- User decision 2026-08-13: the original Projects Budget Full (daily, window
-- 09:00-10:00 via PROJECTS_DAILY) is DISABLED and kept as rollback; the
-- Incremental variant stays disabled; Projects Budget Full - V2 (chunked,
-- 3-BU, parallel 6) is scheduled hourly. Recommended 60 over the requested 10:
-- the enqueue sweep fires every 15 min (10 is unachievable) and each run is
-- 12 heavy OTBI queries -- hourly is near-real-time for budget-version data
-- at a quarter of the Fusion load. On-demand refresh any time = Jobs page
-- Enqueue (~20s warm). Rerunnable.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

UPDATE prod.atd_otbi_jobs SET enabled = 'N'
 WHERE job_name IN ('Projects Budget Full', 'Projects Budget Incremental');

UPDATE prod.atd_otbi_jobs SET frequency_minutes = 60
 WHERE job_name = 'Projects Budget Full - V2';

COMMIT;

SELECT job_name, enabled, frequency_minutes FROM prod.atd_otbi_jobs
 WHERE job_name LIKE 'Projects Budget%' ORDER BY job_name;
