-- ===========================================================================
-- otbi-atd db/73 : AR Invoice Header - V2 -- chunked + service account
--
-- The saved saljaaidi analysis (102,277 header rows, filter Transaction
-- Entered Amount <> 0) ran every ~30 min under the personal c-saljaaidi
-- account via the db/62 path-owner rule, with session churn/requeues + MFA
-- dependency -- and it TOO carries FETCH FIRST 500001 ROWS ONLY (harmless at
-- this volume, a silent cap once the space grows). The chunked logical-SQL
-- extract (runner/arh_def.py = the generator / single source of truth) lives
-- on a SEPARATE V2 job, mirroring db/71+72: the original job keeps its
-- catalog source_ref and is DISABLED, the V2 twin TRUNCATE_INSERTs the same
-- target hourly. 16 chunks on the header-grain Reference-Information
-- Creation Date (NULL + past guards + Jan-2026 half-month split [50,495
-- migration lump] + Feb..Dec monthly + >= 2027 tail); 30 mapped columns =
-- the analysis' visible items (its 5 ORDER-BY-only helpers dropped: 4 sort
-- IDOFs + the Customer-Notes Creation Date, whose retired duplicate is the
-- table's all-NULL CREATION_DATE orphan; the live 'Creation Date' colmap
-- entry is CREATION_DATE_2); min_rows 95,000; parallel 4; service account
-- via non-catalog source_ref. Deployed 2026-08-16 via python-oracledb
-- (vm180); this script is the rerunnable record. Rollover: extend the 2026
-- monthly ranges when 2027 volume grows.
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
   SET params_json = q'[{"_atd_sql_chunks": {"sql": "SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1'; SELECT 0 s_0, \"Receivables - Transactions Real Time\".\"- General Information\".\"Transaction ID\" s_1, \"Receivables - Transactions Real Time\".\"- General Information\".\"Transaction Number\" s_2, \"Receivables - Transactions Real Time\".\"- General Information\".\"Transaction Source Name\" s_3, \"Receivables - Transactions Real Time\".\"- General Information\".\"Transaction Type\" s_4, \"Receivables - Transactions Real Time\".\"- General Information\".\"Transaction Type Tax Calculation\" s_5, \"Receivables - Transactions Real Time\".\"- General Information\".\"Transaction Date\" s_6, \"Receivables - Transactions Real Time\".\"- Additional Header Information\".\"Customer Transaction Reference\" s_7, \"Receivables - Transactions Real Time\".\"- Customer Additional Information\".\"Paying Customer Name\" s_8, \"Receivables - Transactions Real Time\".\"- Transaction Amounts\".\"Transaction Accounted Amount\" s_9, \"Receivables - Transactions Real Time\".\"- Transaction Amounts\".\"Transaction Entered Amount\" s_10, \"Receivables - Transactions Real Time\".\"- Bill-to Customer Details\".\"Bill-to Customer Number\" s_11, \"Receivables - Transactions Real Time\".\"- Bill-to Customer Details\".\"Bill-to Customer Name\" s_12, \"Receivables - Transactions Real Time\".\"- Bill-to Customer Details\".\"Bill-to Customer Type\" s_13, \"Receivables - Transactions Real Time\".\"Bill-to Customer Site\".\"Bill-to Site Name\" s_14, \"Receivables - Transactions Real Time\".\"Business Unit\".\"Business Unit Name\" s_15, \"Receivables - Transactions Real Time\".\"Business Unit\".\"Status\" s_16, \"Receivables - Transactions Real Time\".\"- Freight Details\".\"Ship-to Customer Name\" s_17, \"Receivables - Transactions Real Time\".\"- Subledger Accounting Journals Details\".\"Transfer Status\" s_18, \"Receivables - Transactions Real Time\".\"- Subledger Accounting Journals Details\".\"Accounting Status Code\" s_19, \"Receivables - Transactions Real Time\".\"- Subledger Accounting Journals Details\".\"Accounting Status\" s_20, \"Receivables - Transactions Real Time\".\"- Bill-to Customer Contacts\".\"Account Contact Status Meaning\" s_21, DESCRIPTOR_IDOF(\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Transaction Complete\") s_22, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Transaction Complete\" s_23, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Last Update Date\" s_24, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Last Updated By\" s_25, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Last Updated By User Name\" s_26, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" s_27, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Created By\" s_28, \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Created By User Name\" s_29, \"Receivables - Transactions Real Time\".\"- GL Accounting Date\".\"Accounting Date\" s_30 FROM \"Receivables - Transactions Real Time\" WHERE (\"Receivables - Transactions Real Time\".\"- Transaction Amounts\".\"Transaction Entered Amount\" <> 0) AND ({chunk})", "chunks": ["\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" IS NULL", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-01-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-01-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-01-16'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-01-16' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-02-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-02-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-03-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-03-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-04-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-04-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-05-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-05-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-06-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-06-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-07-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-07-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-08-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-08-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-09-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-09-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-10-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-10-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-11-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-11-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2026-12-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2026-12-01' AND \"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" < date '2027-01-01'", "\"Receivables - Transactions Real Time\".\"- Reference Information\".\"Creation Date\" >= date '2027-01-01'"], "headers": {"#2": "Transaction ID", "#3": "Transaction Number", "#4": "Transaction Source", "#5": "Transaction Type Name", "#6": "Transaction Type Tax Calculation Meaning", "#7": "Transaction Date", "#8": "Customer Transaction Reference", "#9": "Paying Customer Name", "#10": "Transaction Accounted Amount", "#11": "Transaction Entered Amount", "#12": "Bill-to Customer Number", "#13": "Bill-to Customer Name", "#14": "Bill-to Customer Type", "#15": "Bill-to Site Name", "#16": "Business Unit Name", "#17": "Status", "#18": "Ship-to Customer Name", "#19": "Transfer Status", "#20": "Accounting Status Code", "#21": "Accounting Status", "#22": "Account Contact Status Meaning", "#23": "Transaction Complete Indicator", "#24": "Transaction Complete", "#25": "Invoice Last Update Date", "#26": "Last Updated By", "#27": "Last Updated By User Name", "#28": "Creation Date", "#29": "Created By", "#30": "Created By User Name", "#31": "Accounting Date"}, "min_rows": 95000, "retries": 1, "parallel": 4}}]',
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
