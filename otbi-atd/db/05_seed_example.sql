-- ===========================================================================
-- otbi-atd : 05 seed EXAMPLE (template - edit with real values, then run)
-- Shows how to register an environment, a target, a secret and a job. Uses the
-- example staging/final tables from script 01. NOT part of install.sql.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

-- 1) Source environment (the OTBI pod + which account/auth)
MERGE INTO prod.atd_otbi_env t
USING (SELECT 'FUSION_PROD' env_name FROM dual) s ON (t.env_name = s.env_name)
WHEN NOT MATCHED THEN INSERT (env_name, description, analytics_base_url,
       xmlpserver_base_url, auth_type, credential_ref, extract_track, enabled)
  VALUES ('FUSION_PROD', 'Fusion OTBI production',
          'https://iaaibv.fa.ocs.oraclecloud29.com/analytics',
          'https://iaaibv.fa.ocs.oraclecloud29.com/xmlpserver',
          'WSS', 'FUSION_SVC', 'API', 'Y');

-- 2) Target database (where the data lands) - local ATP, PROD schema
MERGE INTO prod.atd_target_db t
USING (SELECT 'ATD_LOCAL' target_name FROM dual) s ON (t.target_name = s.target_name)
WHEN NOT MATCHED THEN INSERT (target_name, description, db_kind, schema_name, enabled)
  VALUES ('ATD_LOCAL', 'This ATP, PROD schema', 'LOCAL_ATP', 'PROD', 'Y');

-- 3) Secret for the service account (replace with OCI Vault in production)
MERGE INTO prod.atd_secret t
USING (SELECT 'FUSION_SVC' credential_ref FROM dual) s ON (t.credential_ref = s.credential_ref)
WHEN MATCHED THEN UPDATE SET username = 'REPLACE_ME', secret_value = 'REPLACE_ME'
WHEN NOT MATCHED THEN INSERT (credential_ref, username, secret_value)
  VALUES ('FUSION_SVC', 'REPLACE_ME', 'REPLACE_ME');

-- 4) A job: BIP report path -> example staging/final, mapped by header
MERGE INTO prod.atd_otbi_jobs t
USING (SELECT 'EXAMPLE_AP' job_name FROM dual) s ON (t.job_name = s.job_name)
WHEN NOT MATCHED THEN INSERT (job_name, env_name, target_name, source_ref,
       output_format, params_json, stage_table, final_table, load_mode,
       key_columns, column_map_json, schedule, enabled)
  VALUES ('EXAMPLE_AP', 'FUSION_PROD', 'ATD_LOCAL',
          '/Custom/Finance/AP Invoices Report.xdo',  -- the BIP report (wraps the analysis)
          'csv',
          NULL,                                      -- or {"P_PERIOD":"2026-05"}
          'PROD.ATD_STG_EXAMPLE', 'PROD.ATD_EXAMPLE', 'MERGE',
          'INVOICE_ID',
          '{"Invoice Num":"INVOICE_ID","Amt":"AMOUNT"}',
          'FREQ=DAILY;BYHOUR=6;BYMINUTE=0', 'Y');

COMMIT;
PROMPT otbi-atd 05 seed example : done  (edit REPLACE_ME secret + report path first)
