-- ===========================================================================
-- otbi-atd : 47 PR/PO Pending Approval extract (BIP xmlpserver, Track B)
--   * prod.atd_pr_po_pending_approval -> snapshot target (full refresh each run)
--   * job 'PR PO Pending Approval'    -> the FIRST .xdo (BI Publisher) job: the
--     runner detects the .xdo suffix on source_ref and fetches the report via
--     the xmlpserver direct-export URL (_xpt=1) with the warm session cookies,
--     then converts the XLSX to CSV keeping ONLY the 8 mapped columns and
--     dropping rows without a Document Number (params_json _atd_require).
--   * job set PRPO_PENDING            -> daily morning window 06:30-08:30 local
--   * category tag PO (Purchasing)
-- Rerunnable (guarded CREATE + MERGE seeds; never drops data). Schema-qualified
-- PROD. CRLF / UTF-8 no BOM.
-- DEPLOY NOTE: MERGE-bearing -> deploy via python-oracledb on a worker VM
-- (Linux SQLcl 26.1 silently swallows MERGE blocks), or Windows SQLcl.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

-- ADB defaults can push MERGE into parallel DML -> ORA-12860 sibling-row deadlock
ALTER SESSION DISABLE PARALLEL DML;

-- ---- snapshot target (guarded CREATE; sizing generous over the live export) ----
-- submitted_for_approval_date is TEXT by user decision 2026-07-16: the BIP
-- template exports it as a 'DD-MM-YYYY' string and the user chose to keep it
-- verbatim rather than convert to DATE (the runner CAN parse it since the
-- %d-%m-%Y format was added to load.DATE_FORMATS the same day).
BEGIN
  EXECUTE IMMEDIATE q'[CREATE TABLE prod.atd_pr_po_pending_approval (
    business_unit               VARCHAR2(240),
    document_type               VARCHAR2(80),
    document_number             VARCHAR2(80),
    status                      VARCHAR2(100),
    preparer_buyer              VARCHAR2(240),
    submitted_for_approval_date VARCHAR2(20),
    pending_with_last_approver  VARCHAR2(1000),
    pending_approval_days       NUMBER,
    load_ts                     TIMESTAMP DEFAULT SYSTIMESTAMP
  )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- ---- the job (MERGE = rerunnable; env/target seeded by 07) ----
MERGE INTO prod.atd_otbi_jobs t
USING (SELECT 'PR PO Pending Approval' job_name FROM dual) s ON (t.job_name = s.job_name)
WHEN MATCHED THEN UPDATE SET
       env_name='FUSION_ADGOV', target_name='ATD_LOCAL',
       source_ref='/Custom/ADGE Procurement Reports/Purchasing/ADG Document Status Report.xdo',
       output_format='xlsx',
       params_json='{"_xt":"ADG Document Status Report","_paramsP_BU":"*","_paramsP_DOCTYPE":["REQUISITION","STANDARD"],"_paramsP_STATUS":"PENDING APPROVAL","_atd_require":"Document Number"}',
       stage_table='PROD.ATD_PR_PO_PENDING_APPROVAL', final_table=NULL,
       load_mode='TRUNCATE_INSERT',
       column_map_json='{"Business Unit":"BUSINESS_UNIT","Document Type":"DOCUMENT_TYPE","Document Number":"DOCUMENT_NUMBER","Status":"STATUS","Preparer/Buyer":"PREPARER_BUYER","Submitted for Approval Date":"SUBMITTED_FOR_APPROVAL_DATE","Pending with Last Approver":"PENDING_WITH_LAST_APPROVER","Pending Approval Days":"PENDING_APPROVAL_DAYS"}',
       frequency_minutes=1440, schema_reviewed='Y', enabled='Y', updated_at=SYSTIMESTAMP
WHEN NOT MATCHED THEN INSERT (job_name, env_name, target_name, source_ref, output_format,
       params_json, stage_table, final_table, load_mode, key_columns, column_map_json,
       schedule, frequency_minutes, schema_reviewed, enabled)
  VALUES ('PR PO Pending Approval', 'FUSION_ADGOV', 'ATD_LOCAL',
          '/Custom/ADGE Procurement Reports/Purchasing/ADG Document Status Report.xdo', 'xlsx',
          '{"_xt":"ADG Document Status Report","_paramsP_BU":"*","_paramsP_DOCTYPE":["REQUISITION","STANDARD"],"_paramsP_STATUS":"PENDING APPROVAL","_atd_require":"Document Number"}',
          'PROD.ATD_PR_PO_PENDING_APPROVAL', NULL, 'TRUNCATE_INSERT', NULL,
          '{"Business Unit":"BUSINESS_UNIT","Document Type":"DOCUMENT_TYPE","Document Number":"DOCUMENT_NUMBER","Status":"STATUS","Preparer/Buyer":"PREPARER_BUYER","Submitted for Approval Date":"SUBMITTED_FOR_APPROVAL_DATE","Pending with Last Approver":"PENDING_WITH_LAST_APPROVER","Pending Approval Days":"PENDING_APPROVAL_DAYS"}',
          NULL, 1440, 'Y', 'Y');

-- ---- daily-morning job set + membership (window is LOCAL Asia/Dubai) ----
MERGE INTO prod.atd_job_set t
USING (SELECT 'PRPO_PENDING' set_code FROM dual) s ON (t.set_code = s.set_code)
WHEN NOT MATCHED THEN INSERT (set_code, name_en, comments, active, paused,
       interval_preset, frequency_minutes, daily_start, daily_end, dow_mask)
  VALUES ('PRPO_PENDING', 'PR-PO Pending Daily Morning',
          'Daily early-morning refresh of the PR/PO pending-approval snapshot (BIP export).',
          'Y', 'N', 'DAILY', 1440, '06:30', '08:30', NULL);

MERGE INTO prod.atd_job_set_member t
USING (SELECT 'PR PO Pending Approval' job_name FROM dual) s ON (t.job_name = s.job_name)
WHEN NOT MATCHED THEN INSERT (job_name, set_code, enabled_in_set, member_order)
  VALUES ('PR PO Pending Approval', 'PRPO_PENDING', 'Y', 100);

-- ---- category tag: Purchasing ----
MERGE INTO prod.atd_job_category_map t
USING (SELECT 'PR PO Pending Approval' job_name, 'PO' category_code FROM dual) s
   ON (t.job_name = s.job_name AND t.category_code = s.category_code)
WHEN NOT MATCHED THEN INSERT (job_name, category_code)
  VALUES ('PR PO Pending Approval', 'PO');

COMMIT;

SET ECHO OFF
PROMPT otbi-atd 47 PR/PO pending approval : done
