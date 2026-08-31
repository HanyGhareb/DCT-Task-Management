-- ===========================================================================
-- 51_atd_ap_pr_po_incremental.sql
-- Incremental delta-load companions for six slow full-refresh extracts, mirroring
-- 50_atd_projects_budget_incremental.sql. Each pairs a daily full baseline
-- (unchanged, TRUNCATE_INSERT) with an hourly 24h delta MERGE keyed on the row's
-- natural key (all six verified UNIQUE — 0 dup groups):
--
--   Full job              -> target table                    key (MERGE)
--   AP Invoices Full        ATD_AP_INVOICES                   INVOICE_ID
--   AP Invoice Lines Full   ATD_AP_INVOICE_LINES              INVOICE_ID, INVOICE_LINE_NUMBER
--   AP Distributions Full   ATD_AP_INVOICE_DISTRIBUTIONS      INVOICE_ID, LINE_NUMBER, DISTRIBUTION_LINE_NUMBER
--   PR Headers Full         ATD_PR_HEADERS                    PR_HEADER_ID
--   PR Lines All            ATD_PR_LINES                      PR_LINE_ID
--   PO Headers Full         ATD_PO_HEADERS                    PO_HEADER_ID
--
-- Re-runnable and INERT: each incremental job is registered DISABLED (enabled='N').
-- Enable + point at its _UH24 variant analysis via 51b once the variants exist.
-- The full jobs already run daily (frequency_minutes=1440) so no cadence flip is
-- needed here.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

DECLARE
  TYPE t_spec IS RECORD (
    jn      VARCHAR2(60),
    full_jn VARCHAR2(60),
    stg     VARCHAR2(80),
    fin     VARCHAR2(80),
    keys    VARCHAR2(200));
  TYPE t_specs IS TABLE OF t_spec;
  specs t_specs := t_specs(
    t_spec('AP Invoices Incremental',      'AP Invoices Full',      'PROD.ATD_AP_INVOICES_STG',              'PROD.ATD_AP_INVOICES',              'INVOICE_ID'),
    t_spec('AP Invoice Lines Incremental', 'AP Invoice Lines Full', 'PROD.ATD_AP_INVOICE_LINES_STG',         'PROD.ATD_AP_INVOICE_LINES',         'INVOICE_ID,INVOICE_LINE_NUMBER'),
    t_spec('AP Distributions Incremental', 'AP Distributions Full', 'PROD.ATD_AP_INVOICE_DISTRIBUTIONS_STG', 'PROD.ATD_AP_INVOICE_DISTRIBUTIONS', 'INVOICE_ID,LINE_NUMBER,DISTRIBUTION_LINE_NUMBER'),
    t_spec('PR Headers Incremental',       'PR Headers Full',       'PROD.ATD_PR_HEADERS_STG',               'PROD.ATD_PR_HEADERS',               'PR_HEADER_ID'),
    t_spec('PR Lines Incremental',         'PR Lines All',          'PROD.ATD_PR_LINES_STG',                 'PROD.ATD_PR_LINES',                 'PR_LINE_ID'),
    t_spec('PO Headers Incremental',       'PO Headers Full',       'PROD.ATD_PO_HEADERS_STG',               'PROD.ATD_PO_HEADERS',               'PO_HEADER_ID'));
BEGIN
  FOR i IN 1 .. specs.COUNT LOOP
    -- staging table: exact column/type clone of the final table
    BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE ' || specs(i).stg || ' PURGE';
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE != -942 THEN RAISE; END IF;
    END;
    EXECUTE IMMEDIATE 'CREATE TABLE ' || specs(i).stg ||
                      ' AS SELECT * FROM ' || specs(i).fin || ' WHERE 1=0';

    -- register the incremental MERGE job (DISABLED), cloning env/target/source/map
    DELETE FROM prod.atd_otbi_jobs WHERE job_name = specs(i).jn;
    INSERT INTO prod.atd_otbi_jobs (
      job_name, env_name, target_name, source_ref, output_format, params_json,
      stage_table, final_table, load_mode, key_columns, column_map_json,
      frequency_minutes, enabled, run_status, priority, run_order)
    SELECT specs(i).jn, f.env_name, f.target_name, f.source_ref, 'csv', NULL,
           specs(i).stg, specs(i).fin, 'MERGE', specs(i).keys, f.column_map_json,
           60, 'N', 'DONE', f.priority, f.run_order
    FROM   prod.atd_otbi_jobs f
    WHERE  f.job_name = specs(i).full_jn;

    DBMS_OUTPUT.PUT_LINE('registered ' || specs(i).jn || ' -> ' || specs(i).stg);
  END LOOP;
  COMMIT;
END;
/

PROMPT ===== verify: 6 incremental jobs (disabled) =====
SET PAGESIZE 50 LINESIZE 220
COL job_name FORMAT A30
COL stage_table FORMAT A34
COL key_columns FORMAT A48
SELECT job_name, enabled, stage_table, key_columns
FROM   prod.atd_otbi_jobs
WHERE  job_name LIKE '%Incremental%'
  AND  job_name IN ('AP Invoices Incremental','AP Invoice Lines Incremental',
                    'AP Distributions Incremental','PR Headers Incremental',
                    'PR Lines Incremental','PO Headers Incremental')
ORDER  BY job_name;

EXIT
