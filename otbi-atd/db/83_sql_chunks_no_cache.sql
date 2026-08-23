-- ===========================================================================
-- otbi-atd db/83 : chunked '&SQL=' extracts -- bypass the OTBI result cache
--
-- Found 2026-08-19: a chunked job sends byte-identical request text on every
-- run, so the BI Server served a CACHED result set and the extract kept
-- re-loading a frozen snapshot (Projects Budget: project 4514000087's 10:46
-- change never landed, row_count stuck at 1908 across four runs). The cache
-- key is NOT the literal text -- a whitespace edit still hit it -- and adding
-- a predicate MISSES it, which is why checking one project by hand in OTBI
-- always looks right while the extract is stale. Only DISABLE_CACHE_HIT=1
-- returns live rows (0.2s cached vs 6.4s live on the 06-2026 chunk).
--
-- Applies to EVERY job carrying the _atd_sql_chunks directive (user rule
-- 2026-08-19). Re-runnable: the REPLACE is inert once applied. Any NEW
-- chunked job must ship the flag in its sql.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

UPDATE prod.atd_otbi_jobs
   SET params_json = REPLACE(params_json,
         'SET VARIABLE ',
         'SET VARIABLE DISABLE_CACHE_HIT=1, ')
 WHERE params_json LIKE '%_atd_sql_chunks%'
   AND params_json LIKE '%SET VARIABLE %'
   AND params_json NOT LIKE '%DISABLE_CACHE_HIT%';

COMMIT;

SELECT job_name, enabled,
       CASE WHEN params_json LIKE '%DISABLE_CACHE_HIT=1%' THEN 'NO-CACHE'
            ELSE 'STILL CACHED - fix by hand' END cache_flag,
       CASE WHEN params_json IS JSON THEN 'VALID' ELSE 'BAD' END js
  FROM prod.atd_otbi_jobs
 WHERE params_json LIKE '%_atd_sql_chunks%'
 ORDER BY job_name;
