-- ===========================================================================
-- otbi-atd db/73 : AR Invoice Header - V2 -- chunked + service account (v2)
--
-- v2 2026-08-17: the OWNER REDESIGNED the saved analysis (dropped Customer
-- Reference / Paying Customer / Bill-to Site / Ship-to / Transfer+Accounting
-- Status / Account Contact Status / Accounting Date / Tax Calculation; added
-- Payment Terms Name+Description, Receipt Method, Term Due Date) and the
-- rebuilt '- all' job re-prepared the table to the new 26-col shape -- the V2
-- job then failed ORA-00904 ACCOUNTING_DATE on its stale colmap. This script
-- now stamps BOTH the re-authored 24-column chunked params (generator
-- runner/arh_def.py, verified against a live CSV sample: 24 headers, 103,030
-- rows) AND copies column_map_json from the '- all' row (kept current by the
-- drift engine; its stale 'Transaction Type Tax Calculation Meaning' key is
-- harmless). Original v1 story in git history. 16 chunks on the header-grain
-- Reference Creation Date; filter Entered Amount <> 0 in every chunk;
-- min_rows 95,000; parallel 4; hourly; service account via non-catalog
-- source_ref. Rerunnable.
-- ===========================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON

-- seed the V2 row from the original job's static attrs when it is missing
INSERT INTO prod.atd_otbi_jobs
  (job_name, env_name, target_name, source_ref, output_format,
   stage_table, final_table, load_mode, key_columns, column_map_json,
   schedule, enabled, priority, run_order, run_status, frequency_minutes,
   schema_reviewed)
SELECT 'AR Invoice Header - V2', env_name, target_name,
       source_ref, output_format,
       stage_table, final_table, load_mode, key_columns, column_map_json,
       schedule, 'Y', priority, run_order, 'DONE', 60, schema_reviewed
  FROM prod.atd_otbi_jobs src
 WHERE src.job_name = 'AR Invoice Header - all'
   AND NOT EXISTS (SELECT 1 FROM prod.atd_otbi_jobs v2
                    WHERE v2.job_name = 'AR Invoice Header - V2');

UPDATE prod.atd_otbi_jobs
   SET params_json = q'[{"_atd_sql_chunks": {"sql": "SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1'; SELECT 0 s_0, \"Receivables - Transactions Real Time\".\"- General Information\".\"Transaction ID\" s_1, \"Receivables - Transactions Real Time\".\"- General Information\".\"Transaction Number\" s_2, \"Receivables - Transactions Real Time\".\"- General Information\".\"Transaction Source Name\" s_3, \"Receivables - Transactions Real Time\".\"- General Information\".\"Transaction Type\" s_4, \"Receivables - Transactions Real Time\".\"- General Information\".\"Transaction Date\" s_5, \"Receivables - Transactions Real Time\".\"- General Information\".\"Payment Terms Name\" s_6, \"Receivables - Transactions Real Time\".\"- General Information\".\"Payment Terms Description\" s_7, \"Receivables - Transactions Real Time\".\"- Transaction Amounts\".\"Transaction Accounted Amount\" s_8, \"Receivables - Transactions Real Time\".\"- Transaction Amounts\".\"Transaction Entered Amount\" s_9, \"Receivables - Transactions Real Time\".\"- Bill-to Customer Details\".\"Bill-to Customer Number\" s_10, \"Receivables - Transactions Real Time\".\"- Bill-to Customer Details\".\"Bill-to Customer Name\" s_11, \"Receivables - Transactions Real Time\".\"- Bill-to Customer Details\".\"Bill-to Customer Type\" s_12, \"Receivables - Transactions Real Time\".\"Business Unit\".\"Business Unit Name\" s_13, \"Receivables - Transactions Real Time\".\"Business Unit\".\"Status\" s_14, DESCRIPTOR_IDOF(\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Transaction Complete\") s_15, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Transaction Complete\" s_16, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Last Update Date\" s_17, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Last Updated By\" s_18, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Last Updated By User Name\" s_19, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" s_20, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Created By\" s_21, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Created By User Name\" s_22, \"Receivables - Transactions Real Time\".\"- Payment\".\"Term Due Date\" s_23, \"Receivables - Transactions Real Time\".\"- Payment\".\"Receipt Method\" s_24 FROM \"Receivables - Transactions Real Time\" WHERE (\"Receivables - Transactions Real Time\".\"- Transaction Amounts\".\"Transaction Entered Amount\" <> 0) AND ({chunk})", "chunks": ["\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" IS NULL", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-01-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-01-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-01-16'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-01-16' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-02-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-02-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-03-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-03-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-04-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-04-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-05-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-05-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-06-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-06-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-07-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-07-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-08-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-08-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-09-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-09-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-10-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-10-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-11-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-11-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-12-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-12-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2027-01-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2027-01-01'"], "headers": {"#2": "Transaction ID", "#3": "Transaction Number", "#4": "Transaction Source", "#5": "Transaction Type Name", "#6": "Transaction Date", "#7": "Payment Terms Name", "#8": "Payment Terms Description", "#9": "Transaction Accounted Amount", "#10": "Transaction Entered Amount", "#11": "Bill-to Customer Number", "#12": "Bill-to Customer Name", "#13": "Bill-to Customer Type", "#14": "Business Unit Name", "#15": "Status", "#16": "Transaction Complete Indicator", "#17": "Transaction Complete", "#18": "Invoice Last Update Date", "#19": "Last Updated By", "#20": "Last Updated By User Name", "#21": "Creation Date", "#22": "Created By", "#23": "Created By User Name", "#24": "Due Date", "#25": "Receipt Method"}, "min_rows": 95000, "retries": 1, "parallel": 4}}]',
       column_map_json = (SELECT column_map_json FROM prod.atd_otbi_jobs
                           WHERE job_name = 'AR Invoice Header - all'),
       source_ref = 'chunked-sql: Receivables - Transactions Real Time (AR headers, 16 chunks)',
       frequency_minutes = 60,
       enabled = 'Y',
       requested_by = NULL
 WHERE job_name = 'AR Invoice Header - V2';

-- the original personal-account job keeps its catalog source_ref, DISABLED
UPDATE prod.atd_otbi_jobs
   SET enabled = 'N',
       requested_by = NULL
 WHERE job_name = 'AR Invoice Header - all';

COMMIT;

SELECT job_name, enabled, frequency_minutes, requested_by,
       CASE WHEN params_json IS NULL THEN 'NONE'
            WHEN params_json IS JSON THEN 'VALID' ELSE 'BAD' END js
  FROM prod.atd_otbi_jobs
 WHERE job_name LIKE 'AR Invoice Header%';
