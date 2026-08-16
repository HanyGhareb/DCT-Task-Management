-- ===========================================================================
-- otbi-atd db/67 : job set PROJECTS_DATA -- the Project Budget Utilization
-- source-data family, hourly
--
-- User request 2026-08-13: one set holding Projects Full + Tasks Full +
-- Projects Budget Full - V2, runnable on demand from the GL Project Budget
-- Utilization page (GL/db/19 bridge calls atd_set_pkg.run_now). Scheduled
-- HOURLY with NO daily window: the budget extract was already hourly, and
-- moving the project/task masters to the same cadence closes the master-lag
-- gap (a task created in Fusion mid-day left its budget line hidden by the
-- butil view's missing-master exclusion until the next 09:00 run -- seen
-- live with project 4511000339). A job belongs to ONE set (PK job_name), so
-- Projects Full + Tasks Full MOVE out of PROJECTS_DAILY, which now holds
-- only the disabled legacy Projects Budget Full. Rerunnable.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM prod.atd_job_set WHERE set_code = 'PROJECTS_DATA';
  IF l_n = 0 THEN
    INSERT INTO prod.atd_job_set
      (set_code, name_en, name_ar, comments, active, paused, frequency_minutes,
       notify_on_failure, created_by)
    VALUES
      ('PROJECTS_DATA', 'Projects Data',
       UNISTR('\0628\064A\0627\0646\0627\062A \0627\0644\0645\0634\0627\0631\064A\0639'),
       'Projects + Tasks masters and the chunked Projects Budget V2 extract; hourly, no window; runnable from the GL Project Budget Utilization page',
       'Y', 'N', 60, 'N', 'ADMIN');
  ELSE
    UPDATE prod.atd_job_set
       SET frequency_minutes = 60, daily_start = NULL, daily_end = NULL,
           active = 'Y', paused = 'N'
     WHERE set_code = 'PROJECTS_DATA';
  END IF;

  UPDATE prod.atd_job_set_member
     SET set_code = 'PROJECTS_DATA', member_order = 10
   WHERE job_name = 'Projects Full';
  UPDATE prod.atd_job_set_member
     SET set_code = 'PROJECTS_DATA', member_order = 20
   WHERE job_name = 'Tasks Full';

  SELECT COUNT(*) INTO l_n FROM prod.atd_job_set_member
   WHERE job_name = 'Projects Budget Full - V2';
  IF l_n = 0 THEN
    INSERT INTO prod.atd_job_set_member
      (job_name, set_code, enabled_in_set, member_order, added_by)
    VALUES ('Projects Budget Full - V2', 'PROJECTS_DATA', 'Y', 30, 'ADMIN');
  ELSE
    UPDATE prod.atd_job_set_member
       SET set_code = 'PROJECTS_DATA', enabled_in_set = 'Y', member_order = 30
     WHERE job_name = 'Projects Budget Full - V2';
  END IF;
END;
/

COMMIT;

SELECT m.set_code, m.job_name, m.member_order, j.enabled, s.frequency_minutes set_freq,
       s.daily_start, s.daily_end
  FROM prod.atd_job_set_member m
  JOIN prod.atd_job_set s ON s.set_code = m.set_code
  JOIN prod.atd_otbi_jobs j ON j.job_name = m.job_name
 WHERE m.set_code IN ('PROJECTS_DATA','PROJECTS_DAILY')
 ORDER BY m.set_code, m.member_order;
