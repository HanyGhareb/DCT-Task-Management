-- ===========================================================================
-- 51b_enable_ap_pr_po_incremental.sql
-- Point each incremental job at its baked _UH24 24h-delta variant + enable it.
-- The full jobs already run daily; no cadence change needed.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

BEGIN
  UPDATE prod.atd_otbi_jobs SET source_ref='/users/haghareb@dctabudhabi.ae/Data/AP/prod/AP Invoices/AP_INVOICES_UH24',                              enabled='Y' WHERE job_name='AP Invoices Incremental';
  UPDATE prod.atd_otbi_jobs SET source_ref='/users/haghareb@dctabudhabi.ae/Data/AP/prod/AP Invoice Lines/AP_INVOICE_LINES_UH24',                    enabled='Y' WHERE job_name='AP Invoice Lines Incremental';
  UPDATE prod.atd_otbi_jobs SET source_ref='/users/haghareb@dctabudhabi.ae/Data/AP/prod/AP Invoice Distributions/AP_INVOICE_DISTRIBUTIONS_UH24',    enabled='Y' WHERE job_name='AP Distributions Incremental';
  UPDATE prod.atd_otbi_jobs SET source_ref='/users/haghareb@dctabudhabi.ae/Data/PR/prod/01_PR_HEADERS/01_PR_HEADERS_UH24',                          enabled='Y' WHERE job_name='PR Headers Incremental';
  UPDATE prod.atd_otbi_jobs SET source_ref='/users/haghareb@dctabudhabi.ae/Data/PR/prod/02_PR_LINES/01_PR_LINES_UH24',                              enabled='Y' WHERE job_name='PR Lines Incremental';
  UPDATE prod.atd_otbi_jobs SET source_ref='/users/haghareb@dctabudhabi.ae/Data/PO/prod/PO Headers/PO_HEADERS_UH24',                                enabled='Y' WHERE job_name='PO Headers Incremental';
  COMMIT;
END;
/

PROMPT ===== enabled incremental jobs =====
SET PAGESIZE 50 LINESIZE 220
COL job_name FORMAT A30
COL source_ref FORMAT A62
SELECT job_name, enabled, load_mode, frequency_minutes AS freq, source_ref
FROM   prod.atd_otbi_jobs
WHERE  job_name IN ('AP Invoices Incremental','AP Invoice Lines Incremental',
                    'AP Distributions Incremental','PR Headers Incremental',
                    'PR Lines Incremental','PO Headers Incremental')
ORDER  BY job_name;

EXIT
