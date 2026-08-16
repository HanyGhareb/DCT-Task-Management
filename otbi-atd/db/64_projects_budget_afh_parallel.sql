-- ===========================================================================
-- otbi-atd db/64 : Projects Budget Full -- AFH scope + parallel chunks
--
-- Two user-approved changes to the db/61 chunked-extract directive:
--   1. The Business-Unit filter gains Abrahamic Family House (descriptor id
--      300000034874765, discovered 2026-08-13) alongside DCT + MSS -- the 9
--      AFH projects present in the 2026-08-11 manual load were excluded by
--      the saved analysis' 2-BU filter, not lost by the extract. A 3-BU IN
--      was probed at 11.3s on a period chunk -- it does NOT take the
--      catastrophic plan that multi-project/multi-period INs do.
--   2. "parallel": 4 -- runner fetches chunks 4 at a time (probed: 4
--      concurrent requests each 188-195s vs ~180s solo), cutting the job
--      from ~35 min to ~10 min wall. Needs the 2026-08-13 sqlchunks.py on
--      every worker BEFORE this runs (deploy + systemctl restart atd-worker).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

UPDATE prod.atd_otbi_jobs
   SET params_json = q'[{"_atd_sql_chunks":{"sql":"SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1'; SELECT 0 s_0, \"Project\".\"Project Key\" s_1, \"Task\".\"Task Key\" s_2, \"Fiscal Calendar\".\"Fiscal Period\" s_3, \"Resource\".\"Resource Type Name\" s_4, \"Projects Calendar\".\"Fiscal Year\" s_5, \"- Budget Version Record Information\".\"Budget Version Last Update Date\" s_6, \"- Budget Version Record Information\".\"Budget Version Last Updated By\" s_7, \"- Budget Cost Measures\".\"Current Budget Cost\" s_8 FROM \"Project Control - Budgets Real Time\" WHERE (DESCRIPTOR_IDOF(\"- Business Unit\".\"Business Unit Name\") IN (300000002427529, 300000324906601, 300000034874765)) AND (\"Projects Calendar\".\"Fiscal Year\" = 2026) AND (\"Fiscal Calendar\".\"Fiscal Period\" = '{chunk}')","chunks":["01-2026","02-2026","03-2026","04-2026","05-2026","06-2026","07-2026","08-2026","09-2026","10-2026","11-2026","12-2026"],"headers":{"Project ID":"Project ID","Task ID":"Task ID","Expenditure Type":"Expenditure Type","Current Budget Cost":"Budget","Accounting Year":"Budget Year","Accounting Period Name":"Accounting Period","Last Update Date":"Update Date","Budget Version Last Updated By":"Updated By"},"min_rows":1000,"retries":1,"parallel":4}}]'
 WHERE job_name = 'Projects Budget Full';

COMMIT;

SELECT job_name, enabled, LENGTH(params_json) params_len,
       CASE WHEN params_json IS JSON THEN 'VALID' ELSE 'BAD' END js
  FROM prod.atd_otbi_jobs
 WHERE job_name = 'Projects Budget Full';
