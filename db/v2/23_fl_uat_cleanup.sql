-- =============================================================================
-- 22_fl_uat_cleanup.sql - FL UAT artifact housekeeping (rerunnable)
-- =============================================================================
-- Removes Freelancers business records accumulated by the automated UAT
-- runner (uat_run_fl.py) plus the dangling DRAFT voucher FL-VCH-000002
-- on the seeded sample contract FL-CON-000001.
--
-- Seeded sample data (titles starting with 'UAT seed') is preserved.
-- Runner-made records are identified by:
--   registrations / freelancers : specialization = 'UAT automation'
--   contracts                   : title 'UAT Retainer %' / 'UAT large retainer %'
--                                 or owned by a runner-made freelancer
--   deliverables                : title 'UAT Deliverable %'
--   documents                   : file_name 'uat-expiring-%' or owned by scope
--
-- Run as ADMIN via SQLcl (sql -name prod_mcp). Rerunnable - second run is a no-op.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE

ALTER SESSION DISABLE PARALLEL DML;
ALTER SESSION DISABLE PARALLEL QUERY;

DECLARE
  l_frl  SYS.ODCINUMBERLIST;   -- runner-made freelancers
  l_reg  SYS.ODCINUMBERLIST;   -- runner-made registrations
  l_con  SYS.ODCINUMBERLIST;   -- runner-made contracts (incl. renewal children)
  l_vch  SYS.ODCINUMBERLIST;   -- vouchers in scope (incl. dangling FL-VCH-000002)
  l_amd  SYS.ODCINUMBERLIST;
  l_rnl  SYS.ODCINUMBERLIST;
  l_pcr  SYS.ODCINUMBERLIST;
  l_doc  SYS.ODCINUMBERLIST;
  l_n    NUMBER;

  PROCEDURE say (p_what VARCHAR2, p_n NUMBER) IS
  BEGIN
    DBMS_OUTPUT.put_line(RPAD(p_what, 44) || p_n);
  END;
BEGIN
  SELECT freelancer_id BULK COLLECT INTO l_frl
  FROM prod.dct_fl_freelancers WHERE specialization = 'UAT automation';

  SELECT registration_id BULK COLLECT INTO l_reg
  FROM prod.dct_fl_registrations WHERE specialization = 'UAT automation';

  -- contracts: runner titles or runner freelancers; renewal children join via
  -- renewed_from; seeded samples ('UAT seed %') stay out of scope
  SELECT contract_id BULK COLLECT INTO l_con
  FROM prod.dct_fl_contracts
  WHERE title NOT LIKE 'UAT seed%'
    AND (   title LIKE 'UAT Retainer%'
         OR title LIKE 'UAT large retainer%'
         OR freelancer_id IN (SELECT COLUMN_VALUE FROM TABLE(l_frl))
         OR renewed_from_contract_id IN (
              SELECT contract_id FROM prod.dct_fl_contracts
              WHERE title LIKE 'UAT Retainer%' OR title LIKE 'UAT large retainer%'));

  -- vouchers on runner contracts, plus invoice-less DRAFT debris that runner
  -- passes / the bulk-generation UAT case left on the two seeded SAMPLE
  -- contracts (FL-VCH-000002 was the original instance). Scoped by the seeded
  -- titles only - drafts on any other contract are never touched.
  SELECT voucher_id BULK COLLECT INTO l_vch
  FROM prod.dct_fl_payment_vouchers v
  WHERE v.contract_id IN (SELECT COLUMN_VALUE FROM TABLE(l_con))
     OR (v.status = 'DRAFT' AND v.invoice_number IS NULL
         AND v.contract_id IN (
               SELECT contract_id FROM prod.dct_fl_contracts
               WHERE title LIKE 'UAT seed%'
                  OR title = 'Production Services Retainer (large)'));

  SELECT amendment_id BULK COLLECT INTO l_amd
  FROM prod.dct_fl_contract_amendments
  WHERE contract_id IN (SELECT COLUMN_VALUE FROM TABLE(l_con));

  SELECT renewal_id BULK COLLECT INTO l_rnl
  FROM prod.dct_fl_contract_renewals
  WHERE original_contract_id IN (SELECT COLUMN_VALUE FROM TABLE(l_con))
     OR new_contract_id      IN (SELECT COLUMN_VALUE FROM TABLE(l_con));

  SELECT change_request_id BULK COLLECT INTO l_pcr
  FROM prod.dct_fl_profile_change_requests
  WHERE freelancer_id IN (SELECT COLUMN_VALUE FROM TABLE(l_frl));

  SELECT doc_id BULK COLLECT INTO l_doc
  FROM prod.dct_documents
  WHERE source_module = 'FL'
    AND (   file_name LIKE 'uat-expiring-%'
         OR source_id    IN (SELECT COLUMN_VALUE FROM TABLE(l_frl))
         OR reference_id IN (SELECT COLUMN_VALUE FROM TABLE(l_frl)));

  say('freelancers in scope',  l_frl.COUNT);
  say('registrations in scope', l_reg.COUNT);
  say('contracts in scope',    l_con.COUNT);
  say('vouchers in scope',     l_vch.COUNT);

  -- approval actions + instances for everything in scope
  DELETE FROM prod.dct_approval_actions
  WHERE instance_id IN (
    SELECT instance_id FROM prod.dct_approval_instances
    WHERE (source_module = 'FL_REGISTRATION'   AND source_record_id IN (SELECT COLUMN_VALUE FROM TABLE(l_reg)))
       OR (source_module = 'FL_CONTRACT'       AND source_record_id IN (SELECT COLUMN_VALUE FROM TABLE(l_con)))
       OR (source_module = 'FL_AMENDMENT'      AND source_record_id IN (SELECT COLUMN_VALUE FROM TABLE(l_amd)))
       OR (source_module = 'FL_RENEWAL'        AND source_record_id IN (SELECT COLUMN_VALUE FROM TABLE(l_rnl)))
       OR (source_module = 'FL_VOUCHER'        AND source_record_id IN (SELECT COLUMN_VALUE FROM TABLE(l_vch)))
       OR (source_module = 'FL_PROFILE_CHANGE' AND source_record_id IN (SELECT COLUMN_VALUE FROM TABLE(l_pcr))));
  say('approval actions deleted', SQL%ROWCOUNT);

  DELETE FROM prod.dct_approval_instances
  WHERE (source_module = 'FL_REGISTRATION'   AND source_record_id IN (SELECT COLUMN_VALUE FROM TABLE(l_reg)))
     OR (source_module = 'FL_CONTRACT'       AND source_record_id IN (SELECT COLUMN_VALUE FROM TABLE(l_con)))
     OR (source_module = 'FL_AMENDMENT'      AND source_record_id IN (SELECT COLUMN_VALUE FROM TABLE(l_amd)))
     OR (source_module = 'FL_RENEWAL'        AND source_record_id IN (SELECT COLUMN_VALUE FROM TABLE(l_rnl)))
     OR (source_module = 'FL_VOUCHER'        AND source_record_id IN (SELECT COLUMN_VALUE FROM TABLE(l_vch)))
     OR (source_module = 'FL_PROFILE_CHANGE' AND source_record_id IN (SELECT COLUMN_VALUE FROM TABLE(l_pcr)));
  say('approval instances deleted', SQL%ROWCOUNT);

  -- unified status history (note: registrations log as FL_REG)
  DELETE FROM prod.dct_request_status_history
  WHERE source_module = 'FL'
    AND (   (source_type = 'FL_REG'       AND source_id IN (SELECT COLUMN_VALUE FROM TABLE(l_reg)))
         OR (source_type = 'FL_CONTRACT'  AND source_id IN (SELECT COLUMN_VALUE FROM TABLE(l_con)))
         OR (source_type = 'FL_AMENDMENT' AND source_id IN (SELECT COLUMN_VALUE FROM TABLE(l_amd)))
         OR (source_type = 'FL_RENEWAL'   AND source_id IN (SELECT COLUMN_VALUE FROM TABLE(l_rnl)))
         OR (source_type = 'FL_VOUCHER'   AND source_id IN (SELECT COLUMN_VALUE FROM TABLE(l_vch))));
  say('status history deleted', SQL%ROWCOUNT);

  -- unified coding lines (FL writes contract lines only)
  DELETE FROM prod.dct_budget_coding_lines
  WHERE source_module = 'FL' AND source_type = 'FL_CONTRACT'
    AND source_id IN (SELECT COLUMN_VALUE FROM TABLE(l_con));
  say('coding lines deleted', SQL%ROWCOUNT);

  -- unified documents + their expiry alerts
  DELETE FROM prod.dct_doc_expiry_alerts
  WHERE doc_id IN (SELECT COLUMN_VALUE FROM TABLE(l_doc));
  say('doc expiry alerts deleted', SQL%ROWCOUNT);

  DELETE FROM prod.dct_documents
  WHERE doc_id IN (SELECT COLUMN_VALUE FROM TABLE(l_doc));
  say('documents deleted', SQL%ROWCOUNT);

  -- deliverables (runner-titled, plus anything on scoped contracts)
  DELETE FROM prod.dct_fl_deliverables
  WHERE title LIKE 'UAT Deliverable %'
     OR contract_id IN (SELECT COLUMN_VALUE FROM TABLE(l_con));
  say('deliverables deleted', SQL%ROWCOUNT);

  -- vouchers: detach schedule rows first (FK both directions), restore PENDING
  UPDATE prod.dct_fl_payment_schedule
  SET voucher_id = NULL,
      status     = CASE WHEN status = 'VOUCHER_GENERATED' THEN 'PENDING' ELSE status END
  WHERE voucher_id IN (SELECT COLUMN_VALUE FROM TABLE(l_vch));
  say('schedule rows detached/reset', SQL%ROWCOUNT);

  DELETE FROM prod.dct_fl_payment_vouchers
  WHERE voucher_id IN (SELECT COLUMN_VALUE FROM TABLE(l_vch));
  say('vouchers deleted', SQL%ROWCOUNT);

  DELETE FROM prod.dct_fl_payment_schedule
  WHERE contract_id IN (SELECT COLUMN_VALUE FROM TABLE(l_con));
  say('schedule rows deleted', SQL%ROWCOUNT);

  DELETE FROM prod.dct_fl_contract_amendments
  WHERE amendment_id IN (SELECT COLUMN_VALUE FROM TABLE(l_amd));
  say('amendments deleted', SQL%ROWCOUNT);

  DELETE FROM prod.dct_fl_contract_renewals
  WHERE renewal_id IN (SELECT COLUMN_VALUE FROM TABLE(l_rnl));
  say('renewals deleted', SQL%ROWCOUNT);

  -- contracts: clear the self-FK inside the scope, children first not needed then
  UPDATE prod.dct_fl_contracts
  SET renewed_from_contract_id = NULL
  WHERE contract_id IN (SELECT COLUMN_VALUE FROM TABLE(l_con))
    AND renewed_from_contract_id IS NOT NULL;

  DELETE FROM prod.dct_fl_contracts
  WHERE contract_id IN (SELECT COLUMN_VALUE FROM TABLE(l_con));
  say('contracts deleted', SQL%ROWCOUNT);

  DELETE FROM prod.dct_fl_bank_accounts
  WHERE freelancer_id IN (SELECT COLUMN_VALUE FROM TABLE(l_frl));
  say('bank accounts deleted', SQL%ROWCOUNT);

  DELETE FROM prod.dct_fl_profile_change_requests
  WHERE change_request_id IN (SELECT COLUMN_VALUE FROM TABLE(l_pcr));
  say('profile change requests deleted', SQL%ROWCOUNT);

  DELETE FROM prod.dct_fl_freelancers
  WHERE freelancer_id IN (SELECT COLUMN_VALUE FROM TABLE(l_frl));
  say('freelancers deleted', SQL%ROWCOUNT);

  DELETE FROM prod.dct_fl_registrations
  WHERE registration_id IN (SELECT COLUMN_VALUE FROM TABLE(l_reg));
  say('registrations deleted', SQL%ROWCOUNT);

  COMMIT;
  DBMS_OUTPUT.put_line('FL UAT cleanup complete.');
END;
/

PROMPT Verifying - remaining UAT-flavoured FL rows (expect seeded samples only):
SELECT 'registrations' what, COUNT(*) n FROM prod.dct_fl_registrations WHERE specialization = 'UAT automation'
UNION ALL
SELECT 'freelancers', COUNT(*) FROM prod.dct_fl_freelancers WHERE specialization = 'UAT automation'
UNION ALL
SELECT 'runner contracts', COUNT(*) FROM prod.dct_fl_contracts
WHERE (title LIKE 'UAT Retainer%' OR title LIKE 'UAT large retainer%')
UNION ALL
SELECT 'dangling FL-VCH-000002', COUNT(*) FROM prod.dct_fl_payment_vouchers WHERE voucher_number = 'FL-VCH-000002';
