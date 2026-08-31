-- ===========================================================================
-- otbi-atd db/70 : job set AR_MORNING -- off-peak window for AR_INVOICE_LINES
--
-- 2026-08-14: the chunked AR_INVOICE_LINES extract (db/69) is code-complete
-- and piecewise-proven, but the pod's cost for this query class swings ~8x
-- within hours (the SAME 18k-row chunk: 77s at midday, killed at ~570s by
-- late afternoon -- WITH or WITHOUT the Project dim join, so it is server
-- state, not SQL shape; afternoon attempts also triggered 502 cascades).
-- Instead of hammering PROD, the job gets a daily EARLY-MORNING Dubai window
-- (05:00-07:00) where the pod is quiet; requeue/session triage handles the
-- rest. Once it completes (auto-prepares the table + map), the window can be
-- widened or the set dropped. Rerunnable.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM prod.atd_job_set WHERE set_code = 'AR_MORNING';
  IF l_n = 0 THEN
    INSERT INTO prod.atd_job_set
      (set_code, name_en, name_ar, comments, active, paused, frequency_minutes,
       daily_start, daily_end, notify_on_failure, created_by)
    VALUES
      ('AR_MORNING', 'AR Heavy Extracts - Morning',
       UNISTR('\0645\0633\062A\062E\0644\0635\0627\062A \0627\0644\0630\0645\0645 - \0635\0628\0627\062D\0627'),
       'Off-peak window for heavy AR extracts the pod cannot serve during the day',
       'Y', 'N', 1440, '05:00', '07:00', 'N', 'ADMIN');
  END IF;
  SELECT COUNT(*) INTO l_n FROM prod.atd_job_set_member
   WHERE job_name = 'AR_INVOICE_LINES';
  IF l_n = 0 THEN
    INSERT INTO prod.atd_job_set_member
      (job_name, set_code, enabled_in_set, member_order, added_by)
    VALUES ('AR_INVOICE_LINES', 'AR_MORNING', 'Y', 10, 'ADMIN');
  ELSE
    UPDATE prod.atd_job_set_member
       SET set_code = 'AR_MORNING', enabled_in_set = 'Y'
     WHERE job_name = 'AR_INVOICE_LINES';
  END IF;
END;
/

UPDATE prod.atd_otbi_jobs SET frequency_minutes = 1440, run_status = 'READY'
 WHERE job_name = 'AR_INVOICE_LINES';

COMMIT;

SELECT m.set_code, m.job_name, s.daily_start, s.daily_end, j.frequency_minutes, j.run_status
  FROM prod.atd_job_set_member m
  JOIN prod.atd_job_set s ON s.set_code = m.set_code
  JOIN prod.atd_otbi_jobs j ON j.job_name = m.job_name
 WHERE m.set_code = 'AR_MORNING';
