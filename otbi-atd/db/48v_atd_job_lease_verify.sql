SET PAGESIZE 100
SET LINESIZE 220
SET FEEDBACK ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT === Lease columns ===
SELECT column_name, data_type, data_length
  FROM all_tab_columns
 WHERE owner='PROD' AND table_name='ATD_OTBI_JOBS'
   AND column_name IN ('CLAIM_TOKEN','LEASE_EXPIRES_AT')
 ORDER BY column_name;

PROMPT === Queue package ===
SELECT object_name, object_type, status
  FROM all_objects
 WHERE owner='PROD' AND object_name='ATD_QUEUE_PKG'
 ORDER BY object_type;

PROMPT === Worker heartbeat ===
SELECT worker_id, status, current_job,
       ROUND((CAST(SYSTIMESTAMP AS DATE)-CAST(last_seen AS DATE))*86400) age_seconds
  FROM prod.atd_worker_heartbeat
 ORDER BY worker_id;

EXIT
