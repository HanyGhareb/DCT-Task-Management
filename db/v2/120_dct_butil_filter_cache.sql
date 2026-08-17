-- =============================================================================
-- i-Finance — Budget Utilization filter cache
-- Eliminates eight repeated scans of DCT_BUDGET_UTILIZATION_V on every
-- GET /gl/butil/filters request.  The cache is tiny and refreshed every 6 hours.
-- Deploy before re-running final apps/GL/db/07_gl_budget_util_ords.sql.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE TABLE IF NOT EXISTS prod.dct_butil_filter_cache (
  filter_type  VARCHAR2(30)  NOT NULL,
  filter_value VARCHAR2(400) NOT NULL,
  refreshed_at TIMESTAMP WITH TIME ZONE NOT NULL,
  CONSTRAINT pk_dct_butil_filter_cache PRIMARY KEY(filter_type,filter_value)
);

CREATE TABLE IF NOT EXISTS prod.dct_butil_key_cache AS
SELECT budget_year,project_type,sector,department,cost_centre,project_number,
       project_name,business_unit,task_number,appropriation,chapter,program,
       expenditure_type
  FROM prod.dct_budget_utilization_v WHERE 1=0;

CREATE INDEX IF NOT EXISTS prod.ix_dct_butil_key_year
  ON prod.dct_butil_key_cache(budget_year);

CREATE OR REPLACE PROCEDURE prod.dct_butil_filter_cache_refresh AUTHID DEFINER AS
BEGIN
  DELETE FROM prod.dct_butil_key_cache;
  INSERT INTO prod.dct_butil_key_cache(
    budget_year,project_type,sector,department,cost_centre,project_number,
    project_name,business_unit,task_number,appropriation,chapter,program,
    expenditure_type)
  SELECT budget_year,project_type,sector,department,cost_centre,project_number,
         project_name,business_unit,task_number,appropriation,chapter,program,
         expenditure_type
    FROM prod.dct_budget_utilization_v;

  DELETE FROM prod.dct_butil_filter_cache;
  INSERT INTO prod.dct_butil_filter_cache(filter_type,filter_value,refreshed_at)
  WITH base AS (
    SELECT budget_year,project_type,sector,chapter,
           business_unit,appropriation,program
      FROM prod.dct_butil_key_cache
  ), values_to_cache(filter_type,filter_value) AS (
    SELECT 'YEAR',TO_CHAR(budget_year,'FM9999') FROM base WHERE budget_year IS NOT NULL UNION ALL
    SELECT 'PROJECT_TYPE',project_type FROM base WHERE project_type IS NOT NULL UNION ALL
    SELECT 'SECTOR',sector FROM base WHERE sector IS NOT NULL UNION ALL
    SELECT 'CHAPTER',chapter FROM base WHERE chapter IS NOT NULL UNION ALL
    SELECT 'BUSINESS_UNIT',business_unit FROM base WHERE business_unit IS NOT NULL UNION ALL
    SELECT 'APPROPRIATION',appropriation FROM base WHERE appropriation IS NOT NULL UNION ALL
    SELECT 'PROGRAM',program FROM base WHERE program IS NOT NULL
  )
  SELECT filter_type,filter_value,SYSTIMESTAMP
    FROM values_to_cache
   GROUP BY filter_type,filter_value;
  COMMIT;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  RAISE;
END;
/

BEGIN
  prod.dct_butil_filter_cache_refresh;
END;
/

DECLARE l_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_exists FROM dba_scheduler_jobs
   WHERE owner='PROD' AND job_name='DCT_BUTIL_FILTER_CACHE_JOB';
  IF l_exists=0 THEN
    DBMS_SCHEDULER.CREATE_JOB(
      job_name=>'PROD.DCT_BUTIL_FILTER_CACHE_JOB',job_type=>'STORED_PROCEDURE',
      job_action=>'PROD.DCT_BUTIL_FILTER_CACHE_REFRESH',start_date=>SYSTIMESTAMP,
      repeat_interval=>'FREQ=HOURLY;INTERVAL=6',enabled=>TRUE,auto_drop=>FALSE,
      comments=>'Refresh cached GL Budget Utilization filter values');
  ELSE
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_BUTIL_FILTER_CACHE_JOB','job_action',
                                 'PROD.DCT_BUTIL_FILTER_CACHE_REFRESH');
    DBMS_SCHEDULER.SET_ATTRIBUTE('PROD.DCT_BUTIL_FILTER_CACHE_JOB','repeat_interval',
                                 'FREQ=HOURLY;INTERVAL=6');
    DBMS_SCHEDULER.ENABLE('PROD.DCT_BUTIL_FILTER_CACHE_JOB');
  END IF;
END;
/

CREATE OR REPLACE PROCEDURE prod.grant_dct_butil_filter_cache_tmp AUTHID DEFINER AS
BEGIN
  EXECUTE IMMEDIATE 'GRANT SELECT ON prod.dct_butil_filter_cache TO admin';
  EXECUTE IMMEDIATE 'GRANT SELECT ON prod.dct_butil_key_cache TO admin';
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON prod.dct_butil_filter_cache_refresh TO admin';
END;
/
BEGIN prod.grant_dct_butil_filter_cache_tmp; END;
/
DROP PROCEDURE prod.grant_dct_butil_filter_cache_tmp;

SELECT filter_type,COUNT(*) value_count,MAX(refreshed_at) refreshed_at
  FROM prod.dct_butil_filter_cache GROUP BY filter_type ORDER BY filter_type;
EXIT
