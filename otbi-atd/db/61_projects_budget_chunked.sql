-- ===========================================================================
-- otbi-atd db/61 : Projects Budget Full -- period-chunked extraction
--
-- Since ~2026-08-09 the BI Server takes a catastrophic plan for the
-- PROJECTS_BUDGET_PERIODS analysis on any multi-project predicate (the full
-- scope is killed by the web tier at ~570s). A single Fiscal Period equality
-- keeps plan pushdown (165s worst chunk), so the Full job now extracts via
-- 12 raw logical-SQL requests -- one per accounting period -- concatenated by
-- the runner (runner/sqlchunks.py, routed on the _atd_sql_chunks directive).
-- The Incremental variant stays off: the daily chunked Full refresh covers it.
-- Rollover note: the fiscal year (2026) is baked into the sql text AND the
-- chunks list -- edit both when the extract must move to a new budget year.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

UPDATE prod.atd_otbi_jobs
   SET params_json = q'[{"_atd_sql_chunks":{"sql":"SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1'; SELECT 0 s_0, \"Project\".\"Project Key\" s_1, \"Task\".\"Task Key\" s_2, \"Fiscal Calendar\".\"Fiscal Period\" s_3, \"Resource\".\"Resource Type Name\" s_4, \"Projects Calendar\".\"Fiscal Year\" s_5, \"- Budget Version Record Information\".\"Budget Version Last Update Date\" s_6, \"- Budget Version Record Information\".\"Budget Version Last Updated By\" s_7, \"- Budget Cost Measures\".\"Current Budget Cost\" s_8 FROM \"Project Control - Budgets Real Time\" WHERE (DESCRIPTOR_IDOF(\"- Business Unit\".\"Business Unit Name\") IN (300000002427529, 300000324906601)) AND (\"Projects Calendar\".\"Fiscal Year\" = 2026) AND (\"Fiscal Calendar\".\"Fiscal Period\" = '{chunk}')","chunks":["01-2026","02-2026","03-2026","04-2026","05-2026","06-2026","07-2026","08-2026","09-2026","10-2026","11-2026","12-2026"],"headers":{"Project ID":"Project ID","Task ID":"Task ID","Expenditure Type":"Expenditure Type","Current Budget Cost":"Budget","Accounting Year":"Budget Year","Accounting Period Name":"Accounting Period","Last Update Date":"Update Date","Budget Version Last Updated By":"Updated By"},"min_rows":1000,"retries":1}}]',
       enabled = 'Y'
 WHERE job_name = 'Projects Budget Full';

UPDATE prod.atd_otbi_jobs
   SET enabled = 'N'
 WHERE job_name = 'Projects Budget Incremental';

COMMIT;

SELECT job_name, enabled, LENGTH(params_json) params_len,
       CASE WHEN params_json IS JSON THEN 'VALID' ELSE 'BAD' END js
  FROM prod.atd_otbi_jobs
 WHERE job_name LIKE 'Projects Budget%';
