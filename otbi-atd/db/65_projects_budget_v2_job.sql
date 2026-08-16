-- ===========================================================================
-- otbi-atd db/65 : Projects Budget Full - V2 -- on-demand fast-extract job
--
-- User-requested twin of Projects Budget Full for manual runs from the ATD
-- Jobs page (Enqueue button). Same chunked+parallel methodology (db/61+64):
-- 12 accounting-period logical-SQL chunks, 3-BU scope incl. AFH -- but with
-- "parallel": 6 (two waves of six instead of three of four, the best shot at
-- a seconds-class run when the BI Server serves the fast plan). It is NOT in
-- any job set and its frequency is one year, so the 15-min enqueue sweep will
-- effectively never fire it on its own -- the daily refresh stays owned by
-- the original job. Both jobs TRUNCATE_INSERT the same target; avoid running
-- the two at the exact same moment. Rerunnable: count-then-insert.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM prod.atd_otbi_jobs
   WHERE job_name = 'Projects Budget Full - V2';
  IF l_n = 0 THEN
    INSERT INTO prod.atd_otbi_jobs
      (job_name, env_name, target_name, source_ref, output_format, params_json,
       stage_table, final_table, load_mode, key_columns, column_map_json,
       schedule, enabled, priority, run_order, run_status, frequency_minutes,
       schema_reviewed)
    SELECT 'Projects Budget Full - V2', env_name, target_name, source_ref,
           output_format,
           REPLACE(params_json, '"parallel":4', '"parallel":6'),
           stage_table, final_table, load_mode, key_columns, column_map_json,
           schedule, 'Y', priority, run_order + 1, 'DONE', 525600,
           schema_reviewed
      FROM prod.atd_otbi_jobs
     WHERE job_name = 'Projects Budget Full';
  ELSE
    UPDATE prod.atd_otbi_jobs v2
       SET (params_json, source_ref, column_map_json) =
           (SELECT REPLACE(params_json, '"parallel":4', '"parallel":6'),
                   source_ref, column_map_json
              FROM prod.atd_otbi_jobs WHERE job_name = 'Projects Budget Full')
     WHERE v2.job_name = 'Projects Budget Full - V2';
  END IF;
END;
/

COMMIT;

SELECT job_name, enabled, frequency_minutes,
       CASE WHEN params_json LIKE '%"parallel":6%' THEN 'PARALLEL-6'
            WHEN params_json LIKE '%"parallel":4%' THEN 'PARALLEL-4'
            ELSE 'OTHER' END mode_flag
  FROM prod.atd_otbi_jobs WHERE job_name LIKE 'Projects Budget Full%';
