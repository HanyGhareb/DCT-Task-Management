SET DEFINE OFF
SET SERVEROUTPUT ON
SET PAGESIZE 200
SET LINESIZE 180
PROMPT ============ PHASE 2 VERIFICATION (read-only) ============

PROMPT === 1. New unified objects exist ===
SELECT table_name FROM all_tables WHERE owner='PROD' AND table_name IN
('DCT_PROJECTS','DCT_TASKS','DCT_EXPENDITURE_TYPES','DCT_DOCUMENTS','DCT_DOC_REQUIREMENTS',
 'DCT_DOC_EXPIRY_ALERTS','DCT_BUDGET_CODING_LINES','DCT_REQUEST_STATUS_HISTORY')
ORDER BY table_name;

PROMPT === 2. Superseded tables are gone (expect: no rows) ===
SELECT table_name FROM all_tables WHERE owner='PROD' AND table_name IN
('DCT_PROJECT_TASKS','DCT_CC_ATTACHMENTS','DCT_CC_REIMB_LINES','DCT_CC_DOC_REQUIREMENTS',
 'DCT_FL_DOCUMENTS','DCT_FL_DOC_EXPIRY_ALERTS');

PROMPT === 3. No INVALID objects in PROD (expect: no rows) ===
SELECT object_name, object_type FROM all_objects
WHERE owner='PROD' AND status='INVALID' ORDER BY object_name;

PROMPT === 4. Key packages VALID ===
SELECT object_name, object_type, status FROM all_objects
WHERE owner='PROD' AND object_type IN ('PACKAGE','PACKAGE BODY')
AND object_name IN ('DCT_CC_PKG','DCT_FL_PKG','DCT_DT_PKG','DCT_LOOKUP_PKG','DCT_REST','DCT_AUTH','DCT_NOTIFY','DCT_APPROVAL_PKG','DCT_PC_AI_PKG')
ORDER BY object_name, object_type;

PROMPT === 5. Natural-key FKs all VALIDATED (expect 22 rows, VALIDATED) ===
SELECT COUNT(*) AS total,
       SUM(CASE WHEN validated='VALIDATED' THEN 1 ELSE 0 END) AS validated_cnt
FROM all_constraints WHERE owner='PROD' AND constraint_name IN
('FK_PCBL_PROJECT','FK_PCBL_TASK','FK_PCBL_EXPTYPE','FK_PCRBL_PROJECT','FK_PCRBL_TASK','FK_PCRBL_EXPTYPE',
 'FK_PCCBL_PROJECT','FK_PCCBL_TASK','FK_PCCBL_EXPTYPE','FK_FLCON_PROJECT','FK_FLCON_TASK','FK_FLCON_EXPTYPE',
 'FK_FLRNL_PROJECT','FK_FLRNL_TASK','FK_FLRNL_EXPTYPE','FK_FLVCH_PROJECT','FK_FLVCH_TASK','FK_FLVCH_EXPTYPE',
 'FK_CCRPL_PROJECT','FK_CCRPL_TASK','FK_CCRPL_EXPTYPE','FK_FLBA_BANK');

PROMPT === 6. Lookup categories (expect 34 = 10 platform + 6 CC + 6 PC + 5 DT + 12 FL + FL_DOCUMENT_TYPE inactive not counted) ===
SELECT COUNT(*) AS phase2_categories FROM prod.dct_lookup_categories WHERE is_active='Y' AND category_code IN
('REQUEST_STATUS','DOC_STATUS','DOC_ALERT_TYPE','CODING_TYPE','BCL_SOURCE_TYPE','SOURCE_MODULE','DOC_SOURCE_TYPE',
 'PROJECT_STATUS','PROJECT_TYPE','EXP_CATEGORY',
 'CC_CARD_STATUS','CC_REQUEST_STATUS','CC_REPL_STATUS','CC_REQUEST_TYPE','CC_REPLACEMENT_REASON','CC_LIMIT_CHANGE_TYPE',
 'PC_TYPE','PC_STATUS','PC_REIMB_STATUS','PC_CLEARING_STATUS','PC_ATTACH_REQUEST_TYPE','PC_VALIDATION_STATUS',
 'DT_MISSION_TYPE','DT_TRIP_TYPE','DT_REQUEST_STATUS','DT_SETTLEMENT_STATUS','DT_EXPENSE_CATEGORY',
 'FL_REGISTRATION_STATUS','FL_FREELANCER_STATUS','FL_CONTRACT_STATUS','FL_AMENDMENT_STATUS','FL_RENEWAL_STATUS',
 'FL_DELIVERABLE_STATUS','FL_SCHEDULE_STATUS','FL_VOUCHER_STATUS','FL_PAYMENT_STATUS','FL_BILLING_METHOD',
 'FL_SUBMITTED_BY','FL_CHANGE_TYPE','FL_PROFILE_CHANGE_STATUS');

PROMPT === 7. No status/type CHECKs remain on CC + FL tables (expect: no rows) ===
COLUMN search_condition_vc FORMAT A90
SELECT table_name, constraint_name, search_condition_vc
FROM   all_constraints
WHERE  owner='PROD' AND constraint_type='C'
AND    (table_name LIKE 'DCT_CC%' OR table_name LIKE 'DCT_FL%' OR table_name='DCT_CREDIT_CARDS')
AND    search_condition_vc LIKE '%status%IN%(%';

PROMPT === 8. Seeds intact ===
SELECT 'exp_types' k, COUNT(*) n FROM prod.dct_expenditure_types
UNION ALL SELECT 'cc_doc_reqs', COUNT(*) FROM prod.dct_doc_requirements WHERE source_module='CC'
UNION ALL SELECT 'doc_types', COUNT(*) FROM prod.dct_document_types
UNION ALL SELECT 'card status default', COUNT(*) FROM all_tab_columns
  WHERE owner='PROD' AND table_name='DCT_CREDIT_CARDS' AND column_name='STATUS' AND data_default LIKE '%INACTIVE%';

PROMPT === 9. ORDS modules ===
SELECT name, uri_prefix, status FROM user_ords_modules ORDER BY name;

PROMPT === 10. DCT_LOOKUP_PKG sanity (expect Y then N) ===
SELECT prod.dct_lookup_pkg.is_valid('CC_CARD_STATUS','ACTIVE') AS should_be_y,
       prod.dct_lookup_pkg.is_valid('CC_CARD_STATUS','BOGUS') AS should_be_n
FROM dual;

PROMPT === 11. Scheduler jobs ===
SELECT job_name, enabled, state FROM all_scheduler_jobs WHERE owner='PROD'
AND job_name IN ('JOB_CC_REPL_REMINDER','JOB_DCT_APPROVAL_SWEEP','FL_DOC_EXPIRY_ALERTS_JOB',
'JOB_DT_SET_TRAVELLED','JOB_DT_AUTO_CLOSE','JOB_DT_STL_ALERTS') ORDER BY job_name;
exit
