-- ===========================================================================
-- otbi-atd : 07 seed the GRN All job (Track B / BROWSER)
-- Registers the Fusion environment, the local ATD target, and the GRN All job
-- that the Python runner executes. Idempotent (MERGE). Run after 01.
-- The browser runner reads Fusion creds from env vars (OTBI_USER/OTBI_PWD),
-- so no atd_secret row is needed for the BROWSER track.
-- CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

-- ADB defaults can push MERGE into parallel DML -> ORA-12860 sibling-row deadlock
ALTER SESSION DISABLE PARALLEL DML;
ALTER TABLE prod.atd_otbi_env  NOPARALLEL;
ALTER TABLE prod.atd_target_db NOPARALLEL;
ALTER TABLE prod.atd_otbi_jobs NOPARALLEL;

MERGE INTO prod.atd_otbi_env t
USING (SELECT 'FUSION_ADGOV' env_name FROM dual) s ON (t.env_name = s.env_name)
WHEN MATCHED THEN UPDATE SET analytics_base_url='https://iaaibv.fa.ocs.oraclecloud29.com/analytics',
       xmlpserver_base_url='https://iaaibv.fa.ocs.oraclecloud29.com/xmlpserver',
       auth_type='SESSION', credential_ref='FUSION_ADGOV', extract_track='BROWSER', enabled='Y'
WHEN NOT MATCHED THEN INSERT (env_name, description, analytics_base_url, xmlpserver_base_url,
       auth_type, credential_ref, extract_track, enabled)
  VALUES ('FUSION_ADGOV', 'Fusion OTBI via ADGOV/Entra SSO (browser, MFA)',
          'https://iaaibv.fa.ocs.oraclecloud29.com/analytics',
          'https://iaaibv.fa.ocs.oraclecloud29.com/xmlpserver',
          'SESSION', 'FUSION_ADGOV', 'BROWSER', 'Y');

MERGE INTO prod.atd_target_db t
USING (SELECT 'ATD_LOCAL' target_name FROM dual) s ON (t.target_name = s.target_name)
WHEN NOT MATCHED THEN INSERT (target_name, description, db_kind, schema_name, enabled)
  VALUES ('ATD_LOCAL', 'This ATP, PROD schema', 'LOCAL_ATP', 'PROD', 'Y');

MERGE INTO prod.atd_otbi_jobs t
USING (SELECT 'GRN_ALL' job_name FROM dual) s ON (t.job_name = s.job_name)
WHEN MATCHED THEN UPDATE SET env_name='FUSION_ADGOV', target_name='ATD_LOCAL',
       source_ref='/users/haghareb@dctabudhabi.ae/MG/GRN All',
       stage_table='PROD.ATD_GRN_ALL', final_table=NULL, load_mode='TRUNCATE_INSERT',
       enabled='Y'
WHEN NOT MATCHED THEN INSERT (job_name, env_name, target_name, source_ref, output_format,
       params_json, stage_table, final_table, load_mode, key_columns, column_map_json,
       schedule, enabled)
  VALUES ('GRN_ALL', 'FUSION_ADGOV', 'ATD_LOCAL',
          '/users/haghareb@dctabudhabi.ae/MG/GRN All', 'csv', NULL,
          'PROD.ATD_GRN_ALL', NULL, 'TRUNCATE_INSERT', NULL,
          '{"Receipt Number":"RECEIPT_NUMBER","Receipt Line Number":"RECEIPT_LINE_NUMBER","Transaction Date":"TRANSACTION_DATE","Transaction Type":"TRANSACTION_TYPE","US Dollar Conversion Rate":"USD_CONVERSION_RATE","Posted Flag":"POSTED_FLAG","Transaction Amount":"TRANSACTION_AMOUNT","Rate":"RATE","Currency Code":"CURRENCY_CODE","Order":"ORDER_NUMBER","Line":"LINE_NUM","Project Name":"PROJECT_NAME","Project Number":"PROJECT_NUMBER","Task Number":"TASK_NUMBER","Task Name":"TASK_NAME","Expenditure Type":"EXPENDITURE_TYPE"}',
          NULL, 'Y');

COMMIT;
PROMPT otbi-atd 07 seed GRN All : done
