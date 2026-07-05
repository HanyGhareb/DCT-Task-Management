SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- ============================================================
--  FL FULL WIPE - registrations + freelancers + downstream
-- ============================================================
--  Clears ALL Freelancers (App 203) transactional data so a
--  fresh registration test can start from an empty slate.
--
--  KEEPS all config/reference data: doc requirements, module
--  settings, lookups, approval templates, DCT users. Only FL
--  transactional rows (and FL-scoped rows in the shared tables)
--  are removed.
--
--  Run with:
--    $env:JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"
--    & "C:\claude\tools\sqlcl\sqlcl\bin\sql.exe" -name prod_mcp `
--      "@final apps\FL\Scripts\fl_full_wipe.sql"
-- ============================================================

-- Force serial DML: some FL tables have a parallel degree, and we modify
-- dct_fl_contracts twice (UPDATE self-ref then DELETE) in one transaction,
-- which raises ORA-12839 under parallel DML.
ALTER SESSION DISABLE PARALLEL DML;

PROMPT ============================================================
PROMPT  FL FULL WIPE - registrations + freelancers + downstream
PROMPT ============================================================

DECLARE
  PROCEDURE del(p_sql IN VARCHAR2, p_label IN VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE p_sql;
    DBMS_OUTPUT.PUT_LINE(RPAD(p_label,42)||' rows: '||SQL%ROWCOUNT);
  END;
BEGIN
  -- 1) break circular + self-referential FKs so parents become deletable
  EXECUTE IMMEDIATE 'UPDATE prod.dct_fl_payment_schedule SET voucher_id = NULL';
  DBMS_OUTPUT.PUT_LINE('nulled payment_schedule.voucher_id          rows: '||SQL%ROWCOUNT);
  EXECUTE IMMEDIATE 'UPDATE prod.dct_fl_contracts SET renewed_from_contract_id = NULL';
  DBMS_OUTPUT.PUT_LINE('nulled contracts.renewed_from_contract_id   rows: '||SQL%ROWCOUNT);

  -- 2) FL children -> parents
  del('DELETE FROM prod.dct_fl_contract_amendments',      'del contract_amendments');
  del('DELETE FROM prod.dct_fl_contract_renewals',        'del contract_renewals');
  del('DELETE FROM prod.dct_fl_deliverables',             'del deliverables');
  del('DELETE FROM prod.dct_fl_payment_vouchers',         'del payment_vouchers');
  del('DELETE FROM prod.dct_fl_payment_schedule',         'del payment_schedule');
  del('DELETE FROM prod.dct_fl_portal_invites',           'del portal_invites');
  del('DELETE FROM prod.dct_fl_portal_sessions',          'del portal_sessions');
  del('DELETE FROM prod.dct_fl_profile_change_requests',  'del profile_change_requests');
  del('DELETE FROM prod.dct_fl_bank_accounts',            'del bank_accounts');
  del('DELETE FROM prod.dct_fl_contracts',                'del contracts');
  del('DELETE FROM prod.dct_fl_freelancers',              'del freelancers');
  del('DELETE FROM prod.dct_fl_registrations',            'del registrations');
  del('DELETE FROM prod.dct_fl_doc_extracts',             'del doc_extracts');
  del('DELETE FROM prod.dct_fl_reg_otp',                  'del reg_otp');

  -- 3) shared tables, FL-scoped only
  del('DELETE FROM prod.dct_doc_expiry_alerts a WHERE EXISTS '||
      '(SELECT 1 FROM prod.dct_documents d WHERE d.doc_id=a.doc_id AND d.source_module=''FL'')',
      'del doc_expiry_alerts (FL)');
  del('DELETE FROM prod.dct_documents WHERE source_module=''FL''',
      'del documents (FL)');
  del('DELETE FROM prod.dct_budget_coding_lines WHERE source_module=''FL''',
      'del budget_coding_lines (FL)');
  del('DELETE FROM prod.dct_request_status_history WHERE source_module=''FL''',
      'del request_status_history (FL)');
  del('DELETE FROM prod.dct_approval_actions WHERE instance_id IN '||
      '(SELECT instance_id FROM prod.dct_approval_instances WHERE source_module LIKE ''FL\_%'' ESCAPE ''\'')',
      'del approval_actions (FL)');
  del('DELETE FROM prod.dct_approval_instances WHERE source_module LIKE ''FL\_%'' ESCAPE ''\''',
      'del approval_instances (FL)');

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('=== COMMIT OK - FL data wiped ===');
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE('!!! ROLLED BACK: '||SQLERRM);
  RAISE;
END;
/

PROMPT === post-wipe verification (all should be 0 / FL rows gone) ===
SELECT 'registrations' t, COUNT(*) n FROM prod.dct_fl_registrations
UNION ALL SELECT 'freelancers', COUNT(*) FROM prod.dct_fl_freelancers
UNION ALL SELECT 'contracts', COUNT(*) FROM prod.dct_fl_contracts
UNION ALL SELECT 'payment_vouchers', COUNT(*) FROM prod.dct_fl_payment_vouchers
UNION ALL SELECT 'payment_schedule', COUNT(*) FROM prod.dct_fl_payment_schedule
UNION ALL SELECT 'deliverables', COUNT(*) FROM prod.dct_fl_deliverables
UNION ALL SELECT 'doc_extracts', COUNT(*) FROM prod.dct_fl_doc_extracts
UNION ALL SELECT 'reg_otp', COUNT(*) FROM prod.dct_fl_reg_otp
UNION ALL SELECT 'documents(FL)', COUNT(*) FROM prod.dct_documents WHERE source_module='FL'
UNION ALL SELECT 'coding_lines(FL)', COUNT(*) FROM prod.dct_budget_coding_lines WHERE source_module='FL'
UNION ALL SELECT 'status_history(FL)', COUNT(*) FROM prod.dct_request_status_history WHERE source_module='FL'
UNION ALL SELECT 'approval_instances(FL)', COUNT(*) FROM prod.dct_approval_instances WHERE source_module LIKE 'FL\_%' ESCAPE '\'
ORDER BY 1;

PROMPT === config preserved (should be unchanged) ===
SELECT 'doc_requirements(FL REGISTRATION)' t, COUNT(*) n FROM prod.dct_doc_requirements WHERE source_module='FL' AND context_code='REGISTRATION';

EXIT
