SET DEFINE OFF
SET SQLBLANKLINES ON
ALTER SESSION DISABLE PARALLEL DML;
ALTER TABLE prod.atd_otbi_jobs NOPARALLEL;
MERGE INTO prod.atd_otbi_jobs t USING (SELECT 'SUPPLIERS' job_name FROM dual) s
  ON (t.job_name = s.job_name)
WHEN MATCHED THEN UPDATE SET
  env_name='FUSION_ADGOV', target_name='ATD_LOCAL',
  source_ref='/users/haghareb@dctabudhabi.ae/Hany/Suppliers/Suppliers', stage_table='PROD.ATD_SUPPLIERS',
  load_mode='TRUNCATE_INSERT', key_columns=NULL, enabled='Y'
WHEN NOT MATCHED THEN INSERT (job_name, env_name, target_name, source_ref,
  output_format, stage_table, load_mode, key_columns, column_map_json, enabled)
  VALUES ('SUPPLIERS','FUSION_ADGOV','ATD_LOCAL','/users/haghareb@dctabudhabi.ae/Hany/Suppliers/Suppliers','csv',
          'PROD.ATD_SUPPLIERS','TRUNCATE_INSERT',NULL,
          '{"Supplier Number": "SUPPLIER_NUMBER", "Supplier Name": "SUPPLIER_NAME", "Supplier Site Status": "SUPPLIER_SITE_STATUS", "Inactive Date": "INACTIVE_DATE", "Bank Name": "BANK_NAME", "Bank Branch Name": "BANK_BRANCH_NAME", "Currency": "CURRENCY", "Account Name": "ACCOUNT_NAME", "IBAN": "IBAN", "From Assignment Date": "FROM_ASSIGNMENT_DATE", "Primary Flag": "PRIMARY_FLAG", "To Date": "TO_DATE", "Bank Account Number": "BANK_ACCOUNT_NUMBER", "Last Updated": "LAST_UPDATED", "Site Pay Group": "SITE_PAY_GROUP"}','Y');
COMMIT;
PROMPT SUPPLIERS seed : done
