-- ===========================================================================
-- otbi-atd db/87 : AR Revenue Types daily BIP/XLSX snapshot
--
-- Report: ADG AR Oracle Cloud AR Activities and Memo Lines Report.xdo
-- Schedule: daily from 06:00 Dubai time (30-minute enqueue window)
-- Target: PROD.ATD_AR_REVENUE_TYPES (transactional full replacement)
-- SERVICE_KEY is derived by Oracle as NVL(SERVICE_CODE, MEMO_LINE_NAME).
-- Rerunnable: guarded DDL + MERGE seeds; never queues an immediate first run.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

ALTER SESSION DISABLE PARALLEL DML;

BEGIN
  EXECUTE IMMEDIATE q'[CREATE TABLE prod.atd_ar_revenue_types (
    business_unit                  VARCHAR2(240),
    revenue_type                   VARCHAR2(240),
    service_code                   VARCHAR2(240),
    service_name                   VARCHAR2(500),
    activity_type                  VARCHAR2(240),
    memo_line_name                 VARCHAR2(500),
    full_service_name              VARCHAR2(1000),
    tax_classification             VARCHAR2(240),
    liability_tax_code             VARCHAR2(240),
    asset_tax_code                 VARCHAR2(240),
    tax_rate_code_source           VARCHAR2(240),
    account                        VARCHAR2(240),
    account_description            VARCHAR2(1000),
    account_type                   VARCHAR2(240),
    cost_center                    VARCHAR2(240),
    cost_center_description        VARCHAR2(1000),
    revenue_account                VARCHAR2(240),
    status                         VARCHAR2(100),
    service_key VARCHAR2(500) GENERATED ALWAYS AS
      (NVL(service_code, memo_line_name)) VIRTUAL,
    load_ts                        TIMESTAMP DEFAULT SYSTIMESTAMP
  )]';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- Compatibility for the first deployed revision: the BIP columns are two
-- independent fields.  STATUS is the Revenue Type status; REVENUE_ACCOUNT is
-- its GL revenue combination.  Rename preserves the data already extracted.
DECLARE
  l_old NUMBER;
  l_new NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_old FROM all_tab_columns
   WHERE owner='PROD' AND table_name='ATD_AR_REVENUE_TYPES'
     AND column_name='REVENUE_ACCOUNT_STATUS';
  SELECT COUNT(*) INTO l_new FROM all_tab_columns
   WHERE owner='PROD' AND table_name='ATD_AR_REVENUE_TYPES'
     AND column_name='STATUS';
  IF l_old=1 AND l_new=0 THEN
    EXECUTE IMMEDIATE
      'ALTER TABLE prod.atd_ar_revenue_types RENAME COLUMN revenue_account_status TO status';
  END IF;
END;
/

-- Additive compatibility for a deployment created from the first revision,
-- before the live XLSX confirmed Revenue Account and Status are separate.
BEGIN
  EXECUTE IMMEDIATE
    'ALTER TABLE prod.atd_ar_revenue_types ADD (revenue_account VARCHAR2(240))';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE
    'CREATE INDEX prod.ix_atd_ar_revenue_types_key ON prod.atd_ar_revenue_types(service_key)';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

MERGE INTO prod.atd_otbi_jobs t
USING (SELECT 'AR Revenue types All' job_name FROM dual) s
   ON (t.job_name=s.job_name)
WHEN MATCHED THEN UPDATE SET
  env_name='FUSION_ADGOV',
  target_name='ATD_LOCAL',
  source_ref='/Custom/ADG Custom/Reports/Financials/AR/Report/ADG AR Oracle Cloud AR Activities and Memo Lines Report.xdo',
  output_format='xlsx',
  params_json='{}',
  stage_table='PROD.ATD_AR_REVENUE_TYPES',
  final_table=NULL,
  load_mode='TRUNCATE_INSERT',
  key_columns='SERVICE_KEY',
  column_map_json='{"Business Unit":"BUSINESS_UNIT","Revenue Type":"REVENUE_TYPE","Service Code":"SERVICE_CODE","Service Name":"SERVICE_NAME","Activity Type":"ACTIVITY_TYPE","Memo Line Name":"MEMO_LINE_NAME","Full Service Name":"FULL_SERVICE_NAME","Tax Classification":"TAX_CLASSIFICATION","Liability Tax Code":"LIABILITY_TAX_CODE","Asset Tax Code":"ASSET_TAX_CODE","Tax Rate Code Source":"TAX_RATE_CODE_SOURCE","Account":"ACCOUNT","Account Description":"ACCOUNT_DESCRIPTION","Account Type":"ACCOUNT_TYPE","Cost Center":"COST_CENTER","Cost Center Description":"COST_CENTER_DESCRIPTION","Revenue Account":"REVENUE_ACCOUNT","Status":"STATUS"}',
  frequency_minutes=1440,
  schema_reviewed='Y',
  enabled='Y',
  updated_at=SYSTIMESTAMP
WHEN NOT MATCHED THEN INSERT
  (job_name,env_name,target_name,source_ref,output_format,params_json,
   stage_table,final_table,load_mode,key_columns,column_map_json,schedule,
   frequency_minutes,schema_reviewed,enabled,run_status)
VALUES
  ('AR Revenue types All','FUSION_ADGOV','ATD_LOCAL',
   '/Custom/ADG Custom/Reports/Financials/AR/Report/ADG AR Oracle Cloud AR Activities and Memo Lines Report.xdo',
   'xlsx','{}','PROD.ATD_AR_REVENUE_TYPES',NULL,'TRUNCATE_INSERT','SERVICE_KEY',
   '{"Business Unit":"BUSINESS_UNIT","Revenue Type":"REVENUE_TYPE","Service Code":"SERVICE_CODE","Service Name":"SERVICE_NAME","Activity Type":"ACTIVITY_TYPE","Memo Line Name":"MEMO_LINE_NAME","Full Service Name":"FULL_SERVICE_NAME","Tax Classification":"TAX_CLASSIFICATION","Liability Tax Code":"LIABILITY_TAX_CODE","Asset Tax Code":"ASSET_TAX_CODE","Tax Rate Code Source":"TAX_RATE_CODE_SOURCE","Account":"ACCOUNT","Account Description":"ACCOUNT_DESCRIPTION","Account Type":"ACCOUNT_TYPE","Cost Center":"COST_CENTER","Cost Center Description":"COST_CENTER_DESCRIPTION","Revenue Account":"REVENUE_ACCOUNT","Status":"STATUS"}',
   NULL,1440,'Y','Y','DONE');

MERGE INTO prod.atd_job_set t
USING (SELECT 'AR_REVENUE_DAILY' set_code FROM dual) s
   ON (t.set_code=s.set_code)
WHEN MATCHED THEN UPDATE SET
  name_en='AR Revenue Types Daily',
  comments='Daily 06:00 Dubai full snapshot from the AR Revenue Types BIP report.',
  active='Y',paused='N',interval_preset='DAILY',frequency_minutes=1440,
  daily_start='06:00',daily_end='06:30',updated_at=SYSTIMESTAMP
WHEN NOT MATCHED THEN INSERT
  (set_code,name_en,comments,active,paused,interval_preset,frequency_minutes,
   daily_start,daily_end,notify_on_failure,created_by)
VALUES
  ('AR_REVENUE_DAILY','AR Revenue Types Daily',
   'Daily 06:00 Dubai full snapshot from the AR Revenue Types BIP report.',
   'Y','N','DAILY',1440,'06:00','06:30','Y','ADMIN');

MERGE INTO prod.atd_job_set_member t
USING (SELECT 'AR Revenue types All' job_name FROM dual) s
   ON (t.job_name=s.job_name)
WHEN MATCHED THEN UPDATE SET
  set_code='AR_REVENUE_DAILY',enabled_in_set='Y',member_order=10
WHEN NOT MATCHED THEN INSERT
  (job_name,set_code,enabled_in_set,member_order,added_by)
VALUES
  ('AR Revenue types All','AR_REVENUE_DAILY','Y',10,'ADMIN');

MERGE INTO prod.atd_job_category_map t
USING (SELECT 'AR Revenue types All' job_name,'AR' category_code FROM dual) s
   ON (t.job_name=s.job_name AND t.category_code=s.category_code)
WHEN NOT MATCHED THEN INSERT (job_name,category_code)
VALUES ('AR Revenue types All','AR');

COMMIT;

PROMPT otbi-atd 87 AR Revenue Types BIP job : done
