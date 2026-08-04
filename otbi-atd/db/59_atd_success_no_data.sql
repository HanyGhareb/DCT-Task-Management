-- Reclassify only the historical false failures produced by the known sequence:
-- profiler identifies a valid zero-row OTBI export, then loader rejects its
-- placeholder header. Genuine zero-row failures remain FAILED.
SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
ALTER SESSION DISABLE PARALLEL DML;

DECLARE
  l_runs PLS_INTEGER;
  l_jobs PLS_INTEGER;
BEGIN
  UPDATE prod.atd_load_run_log
     SET status = 'SUCCESS',
         message = 'analysis returned no data this run (0 rows) - nothing loaded'
   WHERE status = 'FAILED'
     AND NVL(row_count, 0) = 0
     AND LOWER(DBMS_LOB.SUBSTR(message, 200, 1)) LIKE
           'analysis returned no data this run (0 rows) - nothing loaded;%'
     AND LOWER(DBMS_LOB.SUBSTR(message, 1000, 1)) LIKE
           '%no column_map header matched the csv%';
  l_runs := SQL%ROWCOUNT;

  UPDATE prod.atd_otbi_jobs j
     SET run_status = 'DONE',
         claimed_by = NULL,
         claimed_at = NULL,
         updated_at = SYSTIMESTAMP
   WHERE j.run_status = 'FAILED'
     AND EXISTS (
       SELECT 1
         FROM prod.atd_load_run_log l
        WHERE l.job_name = j.job_name
          AND l.run_id = (SELECT MAX(x.run_id)
                            FROM prod.atd_load_run_log x
                           WHERE x.job_name = j.job_name)
          AND l.status = 'SUCCESS'
          AND NVL(l.row_count, 0) = 0
          AND LOWER(DBMS_LOB.SUBSTR(l.message, 100, 1)) LIKE
                'analysis returned no data this run%');
  l_jobs := SQL%ROWCOUNT;

  COMMIT;
  dbms_output.put_line('Historical false failures corrected: ' || l_runs);
  dbms_output.put_line('Current job states corrected: ' || l_jobs);
END;
/

EXIT
