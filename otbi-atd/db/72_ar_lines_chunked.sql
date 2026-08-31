-- ===========================================================================
-- otbi-atd db/72 : AR INVOICE LINES - V2 -- chunked + service account
--
-- The saved saljaaidi analysis is pure LINE grain (122,615 rows, filter
-- IDOF(Transaction Line Type) <> 'TAX'); its single-shot personal-account
-- runs worked but suffered constant session churn/requeues + MFA dependency.
-- The chunked logical-SQL extract (runner/arl_def.py) lives on a SEPARATE V2
-- job, mirroring Projects Budget Full - V2 (db/65+66): the original job
-- keeps its catalog source_ref and is DISABLED, the V2 twin TRUNCATE_INSERTs
-- the same target hourly. 16 chunks on the LINE-grain Creation Date (never a
-- distribution-dim date -- a line whose distributions straddle two ranges
-- would duplicate): NULL + past guards + Jan-2026 split half-month (53,895
-- migration lump) + Feb..Dec 2026 monthly + >= 2027 tail; positional #N
-- headers = the job's EXACT colmap headings; min_rows 110,000; parallel 4;
-- service account via non-catalog source_ref (db/62 path-owner rule).
-- NOTE: supersedes the never-deployed db/69 aril_def (that def was MIXED
-- grain -- distribution columns fanned lines out to 320,750). First applied
-- in place 2026-08-16, split to the V2 job the same day via python-oracledb
-- (vm180); this script is the rerunnable record.
-- ===========================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON

-- seed the V2 row from the original job's static attrs when it is missing
INSERT INTO prod.atd_otbi_jobs
  (job_name, env_name, target_name, source_ref, output_format,
   stage_table, final_table, load_mode, key_columns, column_map_json,
   schedule, enabled, priority, run_order, run_status, frequency_minutes,
   schema_reviewed)
SELECT 'AR INVOICE LINES - V2', env_name, target_name,
       source_ref, output_format,
       stage_table, final_table, load_mode, key_columns, column_map_json,
       schedule, 'Y', priority, run_order, 'DONE', 60, schema_reviewed
  FROM prod.atd_otbi_jobs src
 WHERE src.job_name = 'AR INVOICE LINES - ALL'
   AND NOT EXISTS (SELECT 1 FROM prod.atd_otbi_jobs v2
                    WHERE v2.job_name = 'AR INVOICE LINES - V2');

UPDATE prod.atd_otbi_jobs
   SET params_json = q'[{"_atd_sql_chunks": {"sql": "SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1'; SELECT 0 s_0, \"Receivables - Transactions Real Time\".\"- General Information\".\"Transaction ID\" s_1, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Memo Line Name\" s_2, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Accounting Rule Duration\" s_3, \"Receivables - Transactions Real Time\".\"- Line Information\".\"JG_RA_CUSTOMER_TRX_LINES_INVCRFRNCNBR_\" s_4, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Memo Line Description\" s_5, \"Receivables - Transactions Real Time\".\"- Line Information\".\"RA_CUSTOMER_TRX_LINES_PROJECT_NUMBER_v\" s_6, \"Receivables - Transactions Real Time\".\"- Line Information\".\"RA_CUSTOMER_TRX_LINES_TASK_NAME_\" s_7, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Transaction Line Amount Includes Tax\" s_8, DESCRIPTOR_IDOF(\"Receivables - Transactions Real Time\".\"- Line Information\".\"Transaction Line Amount Includes Tax\") s_9, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Unit Of Measure Code\" s_10, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Unit Of Measure\" s_11, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Transaction Line Number\" s_12, \"Receivables - Transactions Real Time\".\"- Line Information\".\"JG_RA_CUSTOMER_TRX_LINES_EXPORT_DATE_\" s_13, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Revenue Scheduling Rule\" s_14, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Rule End Date\" s_15, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Rule Start Date\" s_16, \"Receivables - Transactions Real Time\".\"- Line Information\".\"RA_CUSTOMER_TRX_LINES_SERVICE_DESCRIPTION_\" s_17, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Line Description\" s_18, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Deferral Exclusion Flag\" s_19, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Transaction Line Type\" s_20, \"Receivables - Transactions Real Time\".\"- Line Information\".\"Unit Selling Price\" s_21, \"Receivables - Transactions Real Time\".\"- Line Amounts\".\"Line Amount\" s_22, \"Receivables - Transactions Real Time\".\"- Line Amounts\".\"Quantity Invoiced\" s_23, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Created By User Name\" s_24, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Last Updated By\" s_25, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Last Updated By User Name\" s_26, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Created By\" s_27, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Last Update Date\" s_28, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" s_29, \"Receivables - Transactions Real Time\".\"- Tax Details\".\"Tax Classification Code\" s_30 FROM \"Receivables - Transactions Real Time\" WHERE (DESCRIPTOR_IDOF(\"Receivables - Transactions Real Time\".\"- Line Information\".\"Transaction Line Type\") <> 'TAX') AND ({chunk})", "chunks": ["\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" IS NULL", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-01-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-01-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-01-16'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-01-16' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-02-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-02-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-03-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-03-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-04-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-04-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-05-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-05-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-06-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-06-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-07-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-07-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-08-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-08-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-09-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-09-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-10-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-10-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-11-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-11-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-12-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-12-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2027-01-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2027-01-01'"], "headers": {"#2": "Transaction ID", "#3": "Memo Line Name", "#4": "Number of Periods", "#5": "Invoice Reference Number", "#6": "Memo Line Description", "#7": "Project", "#8": "Task", "#9": "Transaction Line Amount Includes Tax", "#10": "Transaction Line Amount Includes Tax Indicator", "#11": "UOM Code", "#12": "Unit of Measure", "#13": "Transaction Line Number", "#14": "Export Date", "#15": "Revenue Scheduling Rule", "#16": "Revenue Scheduling Rule End Date", "#17": "Revenue Scheduling Rule Start Date", "#18": "Service Description", "#19": "Transaction Line Description", "#20": "Transaction Line Deferral Exclusion Indicator", "#21": "Transaction Line Type", "#22": "Unit Selling Price", "#23": "Line Amount", "#24": "Transaction Line Quantity Invoiced", "#25": "Created By User Name", "#26": "Last Updated By", "#27": "Last Updated By User Name", "#28": "Created By", "#29": "Invoice Last Update Date", "#30": "Creation Date", "#31": "Tax Classification Code"}, "min_rows": 110000, "retries": 1, "parallel": 4}}]',
       source_ref = 'chunked-sql: Receivables - Transactions Real Time (AR lines, 16 chunks)',
       frequency_minutes = 60,
       enabled = 'Y',
       requested_by = NULL
 WHERE job_name = 'AR INVOICE LINES - V2';

-- the original personal-account job: catalog source_ref restored, DISABLED
UPDATE prod.atd_otbi_jobs
   SET source_ref = '/users/saljaaidi@dctabudhabi.ae/Data/AR/Prod/AR_INVOICE_LINES',
       params_json = NULL,
       enabled = 'N',
       frequency_minutes = 30,
       requested_by = NULL
 WHERE job_name = 'AR INVOICE LINES - ALL';

COMMIT;

SELECT job_name, enabled, frequency_minutes, requested_by,
       CASE WHEN params_json IS NULL THEN 'NONE'
            WHEN params_json IS JSON THEN 'VALID' ELSE 'BAD' END js
  FROM prod.atd_otbi_jobs
 WHERE job_name LIKE 'AR INVOICE LINES%';
