-- ===========================================================================
-- otbi-atd : 10 seed Suppliers + Beneficiaries jobs (Track B / BROWSER)
-- Reuses env FUSION_ADGOV + target ATD_LOCAL from 07. Idempotent (MERGE).
-- Run after 01 + 07 + 08 + 09. CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

ALTER SESSION DISABLE PARALLEL DML;
ALTER TABLE prod.atd_otbi_jobs NOPARALLEL;

MERGE INTO prod.atd_otbi_jobs t
USING (SELECT 'SUPPLIERS' job_name FROM dual) s ON (t.job_name = s.job_name)
WHEN MATCHED THEN UPDATE SET env_name='FUSION_ADGOV', target_name='ATD_LOCAL',
       source_ref='/users/haghareb@dctabudhabi.ae/Hany/Suppliers/Suppliers',
       stage_table='PROD.ATD_SUPPLIERS', final_table=NULL, load_mode='TRUNCATE_INSERT', enabled='Y'
WHEN NOT MATCHED THEN INSERT (job_name, env_name, target_name, source_ref, output_format,
       params_json, stage_table, final_table, load_mode, key_columns, column_map_json,
       schedule, enabled)
  VALUES ('SUPPLIERS', 'FUSION_ADGOV', 'ATD_LOCAL',
          '/users/haghareb@dctabudhabi.ae/Hany/Suppliers/Suppliers', 'csv', NULL,
          'PROD.ATD_SUPPLIERS', NULL, 'TRUNCATE_INSERT', NULL,
          '{"Supplier Number":"SUPPLIER_NUMBER","Supplier Name":"SUPPLIER_NAME","Supplier Site Status":"SUPPLIER_SITE_STATUS","Inactive Date":"INACTIVE_DATE","Bank Name":"BANK_NAME","Bank Branch Name":"BANK_BRANCH_NAME","Currency":"CURRENCY","Account Name":"ACCOUNT_NAME","IBAN":"IBAN","From Assignment Date":"FROM_ASSIGNMENT_DATE","Primary Flag":"PRIMARY_FLAG","To Date":"TO_DT","Bank Account Number":"BANK_ACCOUNT_NUMBER","Last Updated":"LAST_UPDATED","Site Pay Group":"SITE_PAY_GROUP"}',
          NULL, 'Y');

MERGE INTO prod.atd_otbi_jobs t
USING (SELECT 'BENEFICIARIES' job_name FROM dual) s ON (t.job_name = s.job_name)
WHEN MATCHED THEN UPDATE SET env_name='FUSION_ADGOV', target_name='ATD_LOCAL',
       source_ref='/users/haghareb@dctabudhabi.ae/Hany/AP/Beneficiaries',
       stage_table='PROD.ATD_BENEFICIARIES', final_table=NULL, load_mode='TRUNCATE_INSERT', enabled='Y'
WHEN NOT MATCHED THEN INSERT (job_name, env_name, target_name, source_ref, output_format,
       params_json, stage_table, final_table, load_mode, key_columns, column_map_json,
       schedule, enabled)
  VALUES ('BENEFICIARIES', 'FUSION_ADGOV', 'ATD_LOCAL',
          '/users/haghareb@dctabudhabi.ae/Hany/AP/Beneficiaries', 'csv', NULL,
          'PROD.ATD_BENEFICIARIES', NULL, 'TRUNCATE_INSERT', NULL,
          '{"Supplier Name":"SUPPLIER_NAME","Supplier Number":"SUPPLIER_NUMBER","Site":"SITE","Invoice Date":"INVOICE_DATE","AP_INVOICES_BENEFICIARY_NAME_":"BENEFICIARY_NAME","Invoice Description":"INVOICE_DESCRIPTION","Invoice Number":"INVOICE_NUMBER","Invoice Amount Paid":"INVOICE_AMOUNT_PAID","Invoice Currency":"INVOICE_CURRENCY","Invoice Amount":"INVOICE_AMOUNT","Approver User Name":"APPROVER_USER_NAME","Approval Status":"APPROVAL_STATUS","Accounting Status":"ACCOUNTING_STATUS","Cancellation Status":"CANCELLATION_STATUS"}',
          NULL, 'Y');

COMMIT;
PROMPT otbi-atd 10 seed Suppliers + Beneficiaries : done
