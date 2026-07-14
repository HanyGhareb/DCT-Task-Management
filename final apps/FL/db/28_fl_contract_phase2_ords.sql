-- =============================================================================
-- Freelancers Module (App 203) -- Contract Phase 2 -- ORDS layer
-- File    : 28_fl_contract_phase2_ords.sql
-- Schema  : registered under ADMIN. Base /ords/admin/fl/.
-- Run     : sql -name prod_mcp @28_fl_contract_phase2_ords.sql  (FRESH session,
--           never after ALTER SESSION SET CURRENT_SCHEMA -- synonym rule).
--           Re-run after any 08_fl_ords.sql re-run (08 rebuilds fl.rest).
--           Requires 25 + 26 (structures/seed) and the Phase 2 build of 07.
-- Purpose : contract termsheet over the wire + chain surfaces:
--             * dct_fl_contract_v rebuilt with the termsheet columns + names
--             * contracts/ GET+POST, contracts/:id GET+PUT redefined (all new
--               fields, does_exist guards on the PUT)
--             * contracts/:id/submit, amendments/:id/submit,
--               renewals/:id/submit redefined -- -20160..-20131 band maps 400
--             * NEW GET contracts/:id/requirements (doc checklist state:
--               CONTRACT / PROFILE / missing per required type)
--             * NEW GET contracts/:id/approval-history (per-step named
--               approvers from dct_fl_instance_approvers)
--             * NEW POST contracts/:id/force-approve (FL_ADMIN valve, mirrors
--               registrations/:id/force-approve)
--             * NEW approver-map/ GET+POST and approver-map/:id PUT+DELETE
--               (scoped endorser assignments; mutations FL_ADMIN/SYS_ADMIN)
--           Existing templates get DEFINE_HANDLER only (a DEFINE_TEMPLATE on
--           an existing template drops its other handlers). New templates are
--           created only when absent (user_ords_templates check).
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === [1/3] ADMIN synonyms ===

CREATE OR REPLACE SYNONYM dct_fl_approver_map FOR prod.dct_fl_approver_map;

CREATE OR REPLACE SYNONYM dct_fl_instance_approvers FOR prod.dct_fl_instance_approvers;

CREATE OR REPLACE SYNONYM dct_doc_requirements FOR prod.dct_doc_requirements;

CREATE OR REPLACE SYNONYM dct_document_types FOR prod.dct_document_types;

PROMPT === [2/3] dct_fl_contract_v rebuild (termsheet columns) ===

CREATE OR REPLACE VIEW prod.dct_fl_contract_v AS
SELECT
  c.contract_id,
  c.contract_number,
  c.version_number,
  c.freelancer_id,
  f.first_name_en || ' ' || f.last_name_en    AS freelancer_name,
  f.vendor_number,
  c.renewed_from_contract_id,
  c.title,
  c.start_date,
  c.end_date,
  c.total_amount,
  c.currency_code,
  c.billing_method,
  c.billing_unit_id,
  lv.value_name_en                            AS billing_unit_name,
  c.billing_unit_amount,
  c.org_id,
  o.org_name_en                               AS org_name,
  c.coding_type,
  c.cc_id_gl,
  c.project_number,
  c.task_number,
  c.expenditure_type,
  c.status,
  c.approval_instance_id,
  c.notes,
  c.created_by,
  cb.display_name                             AS created_by_name,
  c.created_at,
  c.updated_at,
  -- Contract Phase 2 termsheet columns
  c.contract_type,
  ctv.value_name_en                           AS contract_type_name,
  c.initiative,
  c.contract_manager_user_id,
  cm.display_name                             AS contract_manager_name,
  c.description,
  c.payment_terms,
  c.advance_payment,
  c.retention_terms,
  c.performance_bond,
  c.parent_co_guarantee,
  c.insurance_details,
  c.procurement_involved,
  c.procurement_why,
  c.fte_conversion,
  ftv.value_name_en                           AS fte_conversion_name,
  c.services_summary,
  c.termsheet_ref,
  c.line_manager_email,
  c.line_manager_name,
  c.line_manager_user_id,
  c.memo_from_user_id,
  mf.display_name                             AS memo_from_name,
  c.memo_to_user_id,
  mt.display_name                             AS memo_to_name,
  -- Payment totals
  (SELECT NVL(SUM(s.amount), 0)
   FROM prod.dct_fl_payment_schedule s
   WHERE s.contract_id = c.contract_id)       AS scheduled_total,
  (SELECT NVL(SUM(s.amount), 0)
   FROM prod.dct_fl_payment_schedule s
   WHERE s.contract_id = c.contract_id
   AND   s.status      = 'PAID')              AS paid_total,
  -- Billing status derived from schedule
  CASE
    WHEN (SELECT COUNT(*) FROM prod.dct_fl_payment_schedule s
          WHERE s.contract_id = c.contract_id) = 0
      THEN 'NOT_PAID'
    WHEN (SELECT COUNT(*) FROM prod.dct_fl_payment_schedule s
          WHERE s.contract_id = c.contract_id
          AND   s.status     != 'PAID') = 0
      THEN 'FULLY_PAID'
    WHEN (SELECT COUNT(*) FROM prod.dct_fl_payment_schedule s
          WHERE s.contract_id = c.contract_id
          AND   s.status      = 'PAID') > 0
      THEN 'PARTIALLY_PAID'
    ELSE 'NOT_PAID'
  END                                         AS contract_bill_status
FROM prod.dct_fl_contracts      c
JOIN  prod.dct_fl_freelancers   f   ON f.freelancer_id = c.freelancer_id
JOIN  prod.dct_organizations    o   ON o.org_id        = c.org_id
LEFT JOIN prod.dct_lookup_values lv ON lv.value_id     = c.billing_unit_id
LEFT JOIN prod.dct_users         cb ON cb.username     = c.created_by
LEFT JOIN prod.dct_users         cm ON cm.user_id      = c.contract_manager_user_id
LEFT JOIN prod.dct_users         mf ON mf.user_id      = c.memo_from_user_id
LEFT JOIN prod.dct_users         mt ON mt.user_id      = c.memo_to_user_id
LEFT JOIN (SELECT v.value_code, v.value_name_en
           FROM prod.dct_lookup_values v
           JOIN prod.dct_lookup_categories cc ON cc.category_id = v.category_id
           WHERE cc.category_code = 'FL_CONTRACT_TYPE') ctv
       ON ctv.value_code = c.contract_type
LEFT JOIN (SELECT v.value_code, v.value_name_en
           FROM prod.dct_lookup_values v
           JOIN prod.dct_lookup_categories cc ON cc.category_id = v.category_id
           WHERE cc.category_code = 'FL_FTE_CONVERSION') ftv
       ON ftv.value_code = c.fte_conversion;

PROMPT === [3/3] fl.rest handlers ===

DECLARE
    c_mod CONSTANT VARCHAR2(30) := 'fl.rest';

    PROCEDURE deft(p_pattern VARCHAR2) IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n
        FROM   user_ords_templates t
        JOIN   user_ords_modules  m ON m.id = t.module_id
        WHERE  m.name = c_mod
        AND    t.uri_template = REPLACE(p_pattern, '[COLON]', CHR(58));
        IF v_n = 0 THEN
            ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
                p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
        END IF;
    END;

    PROCEDURE defh(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    -- ======================= contracts list =================================
    defh('contracts/', 'GET', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_limit  NUMBER        := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 50), 200);
  l_offset NUMBER        := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_search VARCHAR2(200) := [COLON]search;
  l_status VARCHAR2(20)  := UPPER([COLON]status);
  l_frl    NUMBER        := TO_NUMBER([COLON]freelancerId DEFAULT NULL ON CONVERSION ERROR);
  l_total  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_total FROM dct_fl_contract_v c
  WHERE (l_status IS NULL OR c.status = l_status)
    AND (l_frl IS NULL OR c.freelancer_id = l_frl)
    AND (l_search IS NULL OR UPPER(c.contract_number || ' ' || c.title || ' ' || c.freelancer_name
         || ' ' || NVL(c.termsheet_ref,'')) LIKE '%' || UPPER(l_search) || '%');
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('total', l_total); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT * FROM dct_fl_contract_v c
    WHERE (l_status IS NULL OR c.status = l_status)
      AND (l_frl IS NULL OR c.freelancer_id = l_frl)
      AND (l_search IS NULL OR UPPER(c.contract_number || ' ' || c.title || ' ' || c.freelancer_name
           || ' ' || NVL(c.termsheet_ref,'')) LIKE '%' || UPPER(l_search) || '%')
    ORDER BY c.contract_id DESC
    OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('contractId',     r.contract_id);
    APEX_JSON.write('contractNumber', r.contract_number);
    APEX_JSON.write('termsheetRef',   NVL(r.termsheet_ref, ''));
    APEX_JSON.write('contractType',   NVL(r.contract_type, ''));
    APEX_JSON.write('contractTypeName', NVL(r.contract_type_name, ''));
    APEX_JSON.write('freelancerId',   r.freelancer_id);
    APEX_JSON.write('freelancerName', r.freelancer_name);
    APEX_JSON.write('title',          r.title);
    APEX_JSON.write('startDate',      TO_CHAR( dct_to_local(r.start_date), 'YYYY-MM-DD'));
    APEX_JSON.write('endDate',        TO_CHAR( dct_to_local(r.end_date), 'YYYY-MM-DD'));
    APEX_JSON.write('totalAmount',    r.total_amount);
    APEX_JSON.write('billingMethod',  r.billing_method);
    APEX_JSON.write('orgName',        r.org_name);
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('billStatus',     r.contract_bill_status);
    APEX_JSON.write('paidTotal',      r.paid_total);
    APEX_JSON.write('approvalInstanceId', r.approval_instance_id);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    defh('contracts/', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
  l_num  VARCHAR2(50);
  l_new  CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_num := 'FL-CON-' || TO_CHAR(seq_fl_contract_number.NEXTVAL, 'FM000000');
  INSERT INTO dct_fl_contracts (
    contract_number, freelancer_id, title, start_date, end_date,
    total_amount, currency_code, billing_method, billing_unit_id, billing_unit_amount,
    org_id, coding_type, cc_id_gl, project_number, task_number, expenditure_type,
    status, notes,
    contract_type, initiative, contract_manager_user_id, description,
    payment_terms, advance_payment, retention_terms, performance_bond,
    parent_co_guarantee, insurance_details, procurement_involved, procurement_why,
    fte_conversion, services_summary,
    line_manager_email, line_manager_name, memo_from_user_id, memo_to_user_id,
    created_by, updated_by
  ) VALUES (
    l_num,
    APEX_JSON.get_number(p_path   => 'freelancerId'),
    APEX_JSON.get_varchar2(p_path => 'title'),
    TO_DATE(NULLIF(APEX_JSON.get_varchar2(p_path => 'startDate'),''), 'YYYY-MM-DD'),
    TO_DATE(NULLIF(APEX_JSON.get_varchar2(p_path => 'endDate'),''),   'YYYY-MM-DD'),
    APEX_JSON.get_number(p_path   => 'totalAmount'),
    NVL(APEX_JSON.get_varchar2(p_path => 'currencyCode'), 'AED'),
    APEX_JSON.get_varchar2(p_path => 'billingMethod'),
    APEX_JSON.get_number(p_path   => 'billingUnitId'),
    APEX_JSON.get_number(p_path   => 'billingUnitAmount'),
    APEX_JSON.get_number(p_path   => 'orgId'),
    NVL(APEX_JSON.get_varchar2(p_path => 'codingType'), 'GL'),
    APEX_JSON.get_number(p_path   => 'ccIdGl'),
    APEX_JSON.get_varchar2(p_path => 'projectNumber'),
    APEX_JSON.get_varchar2(p_path => 'taskNumber'),
    APEX_JSON.get_varchar2(p_path => 'expenditureType'),
    'DRAFT',
    APEX_JSON.get_varchar2(p_path => 'notes'),
    APEX_JSON.get_varchar2(p_path => 'contractType'),
    APEX_JSON.get_varchar2(p_path => 'initiative'),
    APEX_JSON.get_number(p_path   => 'contractManagerUserId'),
    APEX_JSON.get_varchar2(p_path => 'description'),
    APEX_JSON.get_varchar2(p_path => 'paymentTerms'),
    APEX_JSON.get_varchar2(p_path => 'advancePayment'),
    APEX_JSON.get_varchar2(p_path => 'retentionTerms'),
    APEX_JSON.get_varchar2(p_path => 'performanceBond'),
    APEX_JSON.get_varchar2(p_path => 'parentCoGuarantee'),
    APEX_JSON.get_varchar2(p_path => 'insuranceDetails'),
    APEX_JSON.get_varchar2(p_path => 'procurementInvolved'),
    APEX_JSON.get_varchar2(p_path => 'procurementWhy'),
    APEX_JSON.get_varchar2(p_path => 'fteConversion'),
    APEX_JSON.get_varchar2(p_path => 'servicesSummary'),
    APEX_JSON.get_varchar2(p_path => 'lineManagerEmail'),
    APEX_JSON.get_varchar2(p_path => 'lineManagerName'),
    APEX_JSON.get_number(p_path   => 'memoFromUserId'),
    APEX_JSON.get_number(p_path   => 'memoToUserId'),
    l_user, l_user
  ) RETURNING contract_id INTO l_id;
  COMMIT;
  l_new := dct_audit_pkg.snap('DCT_FL_CONTRACTS','contract_id', TO_CHAR(l_id));
  dct_audit_pkg.log(l_user,'CREATE','DCT_FL_CONTRACTS', TO_CHAR(l_id), 'FL',
                    p_object_ref=>l_num, p_new=>l_new);
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('contractId', l_id);
  APEX_JSON.write('contractNumber', l_num);
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE IN (-20001, -20090) OR SQLCODE BETWEEN -20160 AND -20131 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM);
  END IF;
END;
!');

    -- ======================= contract detail ================================
    defh('contracts/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  FOR r IN (SELECT * FROM dct_fl_contract_v WHERE contract_id = [COLON]id) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('contractId',     r.contract_id);
    APEX_JSON.write('contractNumber', r.contract_number);
    APEX_JSON.write('versionNumber',  r.version_number);
    APEX_JSON.write('freelancerId',   r.freelancer_id);
    APEX_JSON.write('freelancerName', r.freelancer_name);
    APEX_JSON.write('vendorNumber',   NVL(r.vendor_number, '-'));
    APEX_JSON.write('renewedFromId',  r.renewed_from_contract_id);
    APEX_JSON.write('title',          r.title);
    APEX_JSON.write('startDate',      TO_CHAR( dct_to_local(r.start_date), 'YYYY-MM-DD'));
    APEX_JSON.write('endDate',        TO_CHAR( dct_to_local(r.end_date), 'YYYY-MM-DD'));
    APEX_JSON.write('totalAmount',    r.total_amount);
    APEX_JSON.write('currencyCode',   r.currency_code);
    APEX_JSON.write('billingMethod',  r.billing_method);
    APEX_JSON.write('billingUnitId',  r.billing_unit_id);
    APEX_JSON.write('billingUnitName',NVL(r.billing_unit_name, ''));
    APEX_JSON.write('billingUnitAmount', r.billing_unit_amount);
    APEX_JSON.write('orgId',          r.org_id);
    APEX_JSON.write('orgName',        r.org_name);
    APEX_JSON.write('codingType',     r.coding_type);
    APEX_JSON.write('ccIdGl',         r.cc_id_gl);
    APEX_JSON.write('projectNumber',  NVL(r.project_number, ''));
    APEX_JSON.write('taskNumber',     NVL(r.task_number, ''));
    APEX_JSON.write('expenditureType',NVL(r.expenditure_type, ''));
    APEX_JSON.write('status',         r.status);
    APEX_JSON.write('billStatus',     r.contract_bill_status);
    APEX_JSON.write('scheduledTotal', r.scheduled_total);
    APEX_JSON.write('paidTotal',      r.paid_total);
    APEX_JSON.write('approvalInstanceId', r.approval_instance_id);
    APEX_JSON.write('notes',          NVL(r.notes, ''));
    APEX_JSON.write('contractType',       NVL(r.contract_type, ''));
    APEX_JSON.write('contractTypeName',   NVL(r.contract_type_name, ''));
    APEX_JSON.write('initiative',         NVL(r.initiative, ''));
    APEX_JSON.write('contractManagerUserId', r.contract_manager_user_id);
    APEX_JSON.write('contractManagerName',   NVL(r.contract_manager_name, ''));
    APEX_JSON.write('description',        NVL(r.description, ''));
    APEX_JSON.write('paymentTerms',       NVL(r.payment_terms, ''));
    APEX_JSON.write('advancePayment',     NVL(r.advance_payment, ''));
    APEX_JSON.write('retentionTerms',     NVL(r.retention_terms, ''));
    APEX_JSON.write('performanceBond',    NVL(r.performance_bond, ''));
    APEX_JSON.write('parentCoGuarantee',  NVL(r.parent_co_guarantee, ''));
    APEX_JSON.write('insuranceDetails',   NVL(r.insurance_details, ''));
    APEX_JSON.write('procurementInvolved',NVL(r.procurement_involved, ''));
    APEX_JSON.write('procurementWhy',     NVL(r.procurement_why, ''));
    APEX_JSON.write('fteConversion',      NVL(r.fte_conversion, ''));
    APEX_JSON.write('fteConversionName',  NVL(r.fte_conversion_name, ''));
    APEX_JSON.write('servicesSummary',    NVL(r.services_summary, ''));
    APEX_JSON.write('termsheetRef',       NVL(r.termsheet_ref, ''));
    APEX_JSON.write('lineManagerEmail',   NVL(r.line_manager_email, ''));
    APEX_JSON.write('lineManagerName',    NVL(r.line_manager_name, ''));
    APEX_JSON.write('lineManagerUserId',  r.line_manager_user_id);
    APEX_JSON.write('memoFromUserId',     r.memo_from_user_id);
    APEX_JSON.write('memoFromName',       NVL(r.memo_from_name, ''));
    APEX_JSON.write('memoToUserId',       r.memo_to_user_id);
    APEX_JSON.write('memoToName',         NVL(r.memo_to_name, ''));
    APEX_JSON.write('createdBy',      r.created_by);
    APEX_JSON.write('createdAt',      TO_CHAR( dct_to_local(r.created_at),'DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.write('updatedAt',      TO_CHAR( dct_to_local(r.updated_at),'DD-Mon-YYYY HH:MI AM'));
    APEX_JSON.close_object;
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    defh('contracts/[COLON]id', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20);
  l_old    CLOB;
  l_new    CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT status INTO l_status FROM dct_fl_contracts WHERE contract_id = [COLON]id;
  IF l_status != 'DRAFT' THEN
    dct_rest.err(400,'Contract can only be edited in DRAFT status (use an amendment after approval)'); RETURN;
  END IF;
  l_old := dct_audit_pkg.snap('DCT_FL_CONTRACTS','contract_id', TO_CHAR([COLON]id));
  dct_rest.parse_body([COLON]body);
  UPDATE dct_fl_contracts SET
    title          = NVL(APEX_JSON.get_varchar2(p_path => 'title'), title),
    start_date     = NVL(TO_DATE(NULLIF(APEX_JSON.get_varchar2(p_path => 'startDate'),''),'YYYY-MM-DD'), start_date),
    end_date       = CASE WHEN APEX_JSON.does_exist(p_path => 'endDate')
                          THEN TO_DATE(NULLIF(APEX_JSON.get_varchar2(p_path => 'endDate'),''),'YYYY-MM-DD') ELSE end_date END,
    total_amount   = NVL(APEX_JSON.get_number(p_path => 'totalAmount'), total_amount),
    billing_method = NVL(APEX_JSON.get_varchar2(p_path => 'billingMethod'), billing_method),
    billing_unit_id     = CASE WHEN APEX_JSON.does_exist(p_path => 'billingUnitId')
                               THEN APEX_JSON.get_number(p_path => 'billingUnitId') ELSE billing_unit_id END,
    billing_unit_amount = CASE WHEN APEX_JSON.does_exist(p_path => 'billingUnitAmount')
                               THEN APEX_JSON.get_number(p_path => 'billingUnitAmount') ELSE billing_unit_amount END,
    org_id         = NVL(APEX_JSON.get_number(p_path => 'orgId'), org_id),
    coding_type    = NVL(APEX_JSON.get_varchar2(p_path => 'codingType'), coding_type),
    cc_id_gl       = CASE WHEN APEX_JSON.does_exist(p_path => 'ccIdGl')
                          THEN APEX_JSON.get_number(p_path => 'ccIdGl') ELSE cc_id_gl END,
    project_number = CASE WHEN APEX_JSON.does_exist(p_path => 'projectNumber')
                          THEN APEX_JSON.get_varchar2(p_path => 'projectNumber') ELSE project_number END,
    task_number    = CASE WHEN APEX_JSON.does_exist(p_path => 'taskNumber')
                          THEN APEX_JSON.get_varchar2(p_path => 'taskNumber') ELSE task_number END,
    expenditure_type = CASE WHEN APEX_JSON.does_exist(p_path => 'expenditureType')
                            THEN APEX_JSON.get_varchar2(p_path => 'expenditureType') ELSE expenditure_type END,
    notes          = CASE WHEN APEX_JSON.does_exist(p_path => 'notes')
                          THEN APEX_JSON.get_varchar2(p_path => 'notes') ELSE notes END,
    contract_type  = CASE WHEN APEX_JSON.does_exist(p_path => 'contractType')
                          THEN APEX_JSON.get_varchar2(p_path => 'contractType') ELSE contract_type END,
    initiative     = CASE WHEN APEX_JSON.does_exist(p_path => 'initiative')
                          THEN APEX_JSON.get_varchar2(p_path => 'initiative') ELSE initiative END,
    contract_manager_user_id = CASE WHEN APEX_JSON.does_exist(p_path => 'contractManagerUserId')
                          THEN APEX_JSON.get_number(p_path => 'contractManagerUserId') ELSE contract_manager_user_id END,
    description    = CASE WHEN APEX_JSON.does_exist(p_path => 'description')
                          THEN APEX_JSON.get_varchar2(p_path => 'description') ELSE description END,
    payment_terms  = CASE WHEN APEX_JSON.does_exist(p_path => 'paymentTerms')
                          THEN APEX_JSON.get_varchar2(p_path => 'paymentTerms') ELSE payment_terms END,
    advance_payment = CASE WHEN APEX_JSON.does_exist(p_path => 'advancePayment')
                          THEN APEX_JSON.get_varchar2(p_path => 'advancePayment') ELSE advance_payment END,
    retention_terms = CASE WHEN APEX_JSON.does_exist(p_path => 'retentionTerms')
                          THEN APEX_JSON.get_varchar2(p_path => 'retentionTerms') ELSE retention_terms END,
    performance_bond = CASE WHEN APEX_JSON.does_exist(p_path => 'performanceBond')
                          THEN APEX_JSON.get_varchar2(p_path => 'performanceBond') ELSE performance_bond END,
    parent_co_guarantee = CASE WHEN APEX_JSON.does_exist(p_path => 'parentCoGuarantee')
                          THEN APEX_JSON.get_varchar2(p_path => 'parentCoGuarantee') ELSE parent_co_guarantee END,
    insurance_details = CASE WHEN APEX_JSON.does_exist(p_path => 'insuranceDetails')
                          THEN APEX_JSON.get_varchar2(p_path => 'insuranceDetails') ELSE insurance_details END,
    procurement_involved = CASE WHEN APEX_JSON.does_exist(p_path => 'procurementInvolved')
                          THEN APEX_JSON.get_varchar2(p_path => 'procurementInvolved') ELSE procurement_involved END,
    procurement_why = CASE WHEN APEX_JSON.does_exist(p_path => 'procurementWhy')
                          THEN APEX_JSON.get_varchar2(p_path => 'procurementWhy') ELSE procurement_why END,
    fte_conversion = CASE WHEN APEX_JSON.does_exist(p_path => 'fteConversion')
                          THEN APEX_JSON.get_varchar2(p_path => 'fteConversion') ELSE fte_conversion END,
    services_summary = CASE WHEN APEX_JSON.does_exist(p_path => 'servicesSummary')
                          THEN APEX_JSON.get_varchar2(p_path => 'servicesSummary') ELSE services_summary END,
    line_manager_email = CASE WHEN APEX_JSON.does_exist(p_path => 'lineManagerEmail')
                          THEN APEX_JSON.get_varchar2(p_path => 'lineManagerEmail') ELSE line_manager_email END,
    line_manager_name = CASE WHEN APEX_JSON.does_exist(p_path => 'lineManagerName')
                          THEN APEX_JSON.get_varchar2(p_path => 'lineManagerName') ELSE line_manager_name END,
    line_manager_user_id = CASE WHEN APEX_JSON.does_exist(p_path => 'lineManagerEmail')
                          THEN NULL ELSE line_manager_user_id END,
    memo_from_user_id = CASE WHEN APEX_JSON.does_exist(p_path => 'memoFromUserId')
                          THEN APEX_JSON.get_number(p_path => 'memoFromUserId') ELSE memo_from_user_id END,
    memo_to_user_id = CASE WHEN APEX_JSON.does_exist(p_path => 'memoToUserId')
                          THEN APEX_JSON.get_number(p_path => 'memoToUserId') ELSE memo_to_user_id END,
    updated_by     = l_user, updated_at = SYSTIMESTAMP
  WHERE contract_id = [COLON]id;
  COMMIT;
  l_new := dct_audit_pkg.snap('DCT_FL_CONTRACTS','contract_id', TO_CHAR([COLON]id));
  dct_audit_pkg.log(l_user,'UPDATE','DCT_FL_CONTRACTS', TO_CHAR([COLON]id), 'FL',
                    p_old=>l_old, p_new=>l_new);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE IN (-20001, -20090) OR SQLCODE BETWEEN -20160 AND -20131 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM);
  END IF;
END;
!');

    -- ======================= submits (400 band) =============================
    defh('contracts/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_fl_pkg.submit_contract([COLON]id, dct_auth.get_user_id(l_user));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE IN (-20001, -20090) OR SQLCODE BETWEEN -20160 AND -20131 THEN dct_rest.err(400, SQLERRM);
  ELSIF SQLCODE = -20401 THEN dct_rest.err(401, SQLERRM);
  ELSIF SQLCODE = -20403 THEN dct_rest.err(403, SQLERRM);
  ELSIF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM);
  END IF;
END;
!');

    defh('amendments/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_fl_pkg.submit_amendment([COLON]id, dct_auth.get_user_id(l_user));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE IN (-20001, -20090) OR SQLCODE BETWEEN -20160 AND -20131 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM);
  END IF;
END;
!');

    defh('renewals/[COLON]id/submit', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_fl_pkg.submit_renewal([COLON]id, dct_auth.get_user_id(l_user));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE); APEX_JSON.write('status', 'SUBMITTED');
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE IN (-20001, -20090) OR SQLCODE BETWEEN -20160 AND -20131 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM);
  END IF;
END;
!');

    -- =================== NEW: document requirements checklist ===============
    deft('contracts/[COLON]id/requirements');
    defh('contracts/[COLON]id/requirements', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_frl  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  BEGIN
    SELECT freelancer_id INTO l_frl FROM dct_fl_contracts WHERE contract_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Contract not found'); RETURN; END;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT dr.doc_type_id, dt.doc_type_code, dt.doc_type_name_en, dt.doc_type_name_ar,
           dr.is_mandatory, dr.display_seq,
           (SELECT MAX(d.doc_id) FROM dct_documents d
            WHERE d.source_module = 'FL' AND d.source_type = 'CONTRACT'
              AND d.source_id = [COLON]id AND d.doc_type_id = dr.doc_type_id
              AND d.is_active = 'Y' AND d.status = 'ACTIVE'
              AND d.file_blob IS NOT NULL) AS con_doc,
           (SELECT MAX(d.doc_id) FROM dct_documents d
            WHERE d.source_module = 'FL' AND d.reference_id = l_frl
              AND d.doc_type_id = dr.doc_type_id
              AND d.is_active = 'Y' AND d.status = 'ACTIVE'
              AND d.file_blob IS NOT NULL
              AND (d.expiry_date IS NULL OR d.expiry_date >= SYSDATE)) AS prof_doc
    FROM   dct_doc_requirements dr
    JOIN   dct_document_types   dt ON dt.doc_type_id = dr.doc_type_id
    WHERE  dr.source_module = 'FL' AND dr.context_code = 'CONTRACT'
    AND    dr.is_active = 'Y'
    ORDER BY dr.display_seq
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docTypeId', r.doc_type_id);
    APEX_JSON.write('code',      r.doc_type_code);
    APEX_JSON.write('name',      r.doc_type_name_en);
    APEX_JSON.write('nameAr',    NVL(r.doc_type_name_ar, r.doc_type_name_en));
    APEX_JSON.write('mandatory', r.is_mandatory);
    APEX_JSON.write('satisfiedBy',
      CASE WHEN r.con_doc IS NOT NULL THEN 'CONTRACT'
           WHEN r.prof_doc IS NOT NULL THEN 'PROFILE'
           ELSE '' END);
    APEX_JSON.write('docId', NVL(r.con_doc, r.prof_doc));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =================== NEW: contract approval history ======================
    deft('contracts/[COLON]id/approval-history');
    defh('contracts/[COLON]id/approval-history', 'GET', q'!
DECLARE
  l_user      VARCHAR2(100) := dct_rest.validate_session;
  l_inst      NUMBER;
  l_tmpl      NUMBER;
  l_cur       NUMBER;
  l_overall   VARCHAR2(30);
  l_sub_at    TIMESTAMP;
  l_sub_by    VARCHAR2(200);
  l_dyn       NUMBER;
  l_dyn_name  VARCHAR2(200);
  l_completed TIMESTAMP;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  BEGIN
    SELECT ai.instance_id, ai.template_id, ai.current_step_seq, ai.overall_status,
           ai.submitted_at, su.display_name, ai.dynamic_approver_user_id, ai.completed_at
      INTO l_inst, l_tmpl, l_cur, l_overall, l_sub_at, l_sub_by, l_dyn, l_completed
    FROM   dct_fl_contracts c
    JOIN   prod.dct_approval_instances ai ON ai.instance_id = c.approval_instance_id
    LEFT JOIN prod.dct_users su ON su.user_id = ai.submitted_by
    WHERE  c.contract_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('hasInstance', FALSE);
    APEX_JSON.open_array('steps'); APEX_JSON.close_array;
    APEX_JSON.close_object;
    RETURN;
  END;

  IF l_dyn IS NOT NULL THEN
    BEGIN
      SELECT display_name INTO l_dyn_name FROM prod.dct_users WHERE user_id = l_dyn;
    EXCEPTION WHEN NO_DATA_FOUND THEN l_dyn_name := NULL; END;
  END IF;

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('hasInstance',     TRUE);
  APEX_JSON.write('instanceId',      l_inst);
  APEX_JSON.write('overallStatus',   l_overall);
  APEX_JSON.write('submittedByName', NVL(l_sub_by, '-'));
  APEX_JSON.write('submittedAt',     TO_CHAR(dct_to_local(l_sub_at), 'YYYY-MM-DD HH:MI AM'));
  IF l_completed IS NOT NULL THEN
    APEX_JSON.write('completedAt', TO_CHAR(dct_to_local(l_completed), 'YYYY-MM-DD HH:MI AM'));
  END IF;

  APEX_JSON.open_array('steps');
  FOR s IN (
    SELECT st.step_seq, st.step_name, st.step_name_ar, st.step_type,
           st.condition_type, st.custom_condition,
           ro.role_name_en                       AS role_name,
           nu.display_name                       AS named_approver,
           a.action, a.comments, a.actioned_at,
           ua.display_name                       AS actioned_by_name,
           ROW_NUMBER() OVER (ORDER BY st.step_seq)       AS rn,
           LAG(a.actioned_at) OVER (ORDER BY st.step_seq) AS prev_actioned_at
    FROM   prod.dct_approval_steps st
    LEFT JOIN prod.dct_roles ro ON ro.role_id = st.required_role_id
    LEFT JOIN dct_fl_instance_approvers fia
           ON fia.instance_id = l_inst AND fia.step_seq = st.step_seq
    LEFT JOIN prod.dct_users nu ON nu.user_id = fia.user_id
    LEFT JOIN (
        SELECT aa.step_id, aa.action, aa.comments, aa.actioned_at, aa.actioned_by,
               ROW_NUMBER() OVER (PARTITION BY aa.step_id
                                  ORDER BY aa.actioned_at DESC, aa.action_id DESC) rn
        FROM   prod.dct_approval_actions aa
        WHERE  aa.instance_id = l_inst
    ) a ON a.step_id = st.step_id AND a.rn = 1
    LEFT JOIN prod.dct_users ua ON ua.user_id = a.actioned_by
    WHERE  st.template_id = l_tmpl
    ORDER BY st.step_seq
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('seq',      s.step_seq);
    APEX_JSON.write('stepName', NVL(s.step_name, 'Step ' || s.step_seq));
    APEX_JSON.write('stepNameAr', NVL(s.step_name_ar, NVL(s.step_name, '-')));
    APEX_JSON.write('conditional',
      CASE WHEN s.condition_type = 'ALWAYS' THEN 'N' ELSE 'Y' END);
    APEX_JSON.write('approver',
      CASE WHEN s.named_approver IS NOT NULL THEN s.named_approver
           WHEN s.step_type = 'USER_SPECIFIC' THEN NVL(l_dyn_name, 'Line Manager')
           ELSE NVL(s.role_name, '-') END);
    APEX_JSON.write('status',
      CASE WHEN s.action IS NOT NULL                                     THEN s.action
           WHEN l_overall = 'PENDING' AND s.step_seq = l_cur             THEN 'PENDING'
           WHEN l_overall = 'PENDING' AND s.step_seq > l_cur             THEN 'WAITING'
           WHEN l_overall IN ('REJECTED','RETURNED')
                AND s.step_seq >= NVL(l_cur, 0)                          THEN 'WAITING'
           ELSE 'DONE' END);
    APEX_JSON.write('isCurrent',
      CASE WHEN l_overall = 'PENDING' AND s.step_seq = l_cur THEN 'Y' ELSE 'N' END);
    IF s.rn = 1 THEN
      APEX_JSON.write('receivedAt', TO_CHAR(dct_to_local(l_sub_at), 'YYYY-MM-DD HH:MI AM'));
    ELSIF s.prev_actioned_at IS NOT NULL THEN
      APEX_JSON.write('receivedAt', TO_CHAR(dct_to_local(s.prev_actioned_at), 'YYYY-MM-DD HH:MI AM'));
    END IF;
    IF s.actioned_by_name IS NOT NULL THEN
      APEX_JSON.write('actionedBy', s.actioned_by_name);
    END IF;
    IF s.actioned_at IS NOT NULL THEN
      APEX_JSON.write('actionedAt', TO_CHAR(dct_to_local(s.actioned_at), 'YYYY-MM-DD HH:MI AM'));
    END IF;
    IF s.comments IS NOT NULL THEN
      APEX_JSON.write('comments', s.comments);
    END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =================== NEW: FL_ADMIN force-approve =========================
    deft('contracts/[COLON]id/force-approve');
    defh('contracts/[COLON]id/force-approve', 'POST', q'!
DECLARE
  l_user       VARCHAR2(100) := dct_rest.validate_session;
  l_uid        NUMBER;
  l_inst       NUMBER;
  l_con_status VARCHAR2(30);
  l_overall    VARCHAR2(30);
  l_note       VARCHAR2(2000);
  l_guard      NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'FL_ADMIN')
     AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403, 'Only an FL Administrator can force an approval.'); RETURN;
  END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  l_note := '[FORCE APPROVAL] '
            || NVL(APEX_JSON.get_varchar2(p_path => 'comments'),
                   'Approved by FL Administrator (approval workflow overridden).');

  BEGIN
    SELECT approval_instance_id, status INTO l_inst, l_con_status
    FROM   dct_fl_contracts WHERE contract_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    dct_rest.err(404, 'Contract not found.'); RETURN;
  END;

  IF l_inst IS NULL THEN
    dct_rest.err(400, 'This contract has no approval in progress to force.'); RETURN;
  END IF;
  IF l_con_status != 'SUBMITTED' THEN
    dct_rest.err(400, 'Only a submitted contract can be force-approved (current status: '
                       || l_con_status || ').'); RETURN;
  END IF;

  LOOP
    SELECT overall_status INTO l_overall
    FROM   prod.dct_approval_instances WHERE instance_id = l_inst;
    EXIT WHEN l_overall != 'PENDING';
    dct_fl_pkg.act_on_approval(l_inst, l_uid, 'APPROVED', l_note);
    l_guard := l_guard + 1;
    EXIT WHEN l_guard > 25;
  END LOOP;

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('overallStatus', l_overall);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
  IF SQLCODE IN (-20001, -20090) OR SQLCODE BETWEEN -20160 AND -20131 THEN dct_rest.err(400, SQLERRM);
  ELSE dct_rest.err(500, SQLERRM);
  END IF;
END;
!');

    -- =================== NEW: scoped approver assignments ====================
    deft('approver-map/');
    defh('approver-map/', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT m.map_id, m.role_code, ro.role_name_en, m.org_id,
           o.org_name_en, o.org_type, m.user_id, u.display_name, u.email,
           m.is_active, m.notes
    FROM   dct_fl_approver_map m
    JOIN   prod.dct_roles ro ON ro.role_code = m.role_code
    JOIN   prod.dct_organizations o ON o.org_id = m.org_id
    JOIN   prod.dct_users u ON u.user_id = m.user_id
    ORDER BY m.role_code, o.org_name_en
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('mapId',    r.map_id);
    APEX_JSON.write('roleCode', r.role_code);
    APEX_JSON.write('roleName', r.role_name_en);
    APEX_JSON.write('orgId',    r.org_id);
    APEX_JSON.write('orgName',  r.org_name_en);
    APEX_JSON.write('orgType',  NVL(r.org_type, ''));
    APEX_JSON.write('userId',   r.user_id);
    APEX_JSON.write('userName', r.display_name);
    APEX_JSON.write('userEmail',NVL(r.email, ''));
    APEX_JSON.write('isActive', r.is_active);
    APEX_JSON.write('notes',    NVL(r.notes, ''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('roles');
  FOR r IN (
    SELECT DISTINCT ro.role_code, ro.role_name_en
    FROM   prod.dct_approval_steps s
    JOIN   prod.dct_approval_templates t ON t.template_id = s.template_id
    JOIN   prod.dct_modules mo ON mo.module_id = t.module_id
    JOIN   prod.dct_roles ro ON ro.role_id = s.required_role_id
    WHERE  mo.module_code = 'FREELANCERS'
    AND    s.step_type = 'USER_SPECIFIC'
    ORDER BY 1
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('roleCode', r.role_code);
    APEX_JSON.write('roleName', r.role_name_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('orgs');
  FOR r IN (
    SELECT org_id, org_name_en, org_type, parent_org_id
    FROM   prod.dct_organizations
    WHERE  is_active = 'Y'
    ORDER BY NVL(parent_org_id, 0), display_order, org_name_en
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('orgId',    r.org_id);
    APEX_JSON.write('orgName',  r.org_name_en);
    APEX_JSON.write('orgType',  NVL(r.org_type, ''));
    APEX_JSON.write('parentOrgId', r.parent_org_id);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    defh('approver-map/', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_id   NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'FL_ADMIN')
     AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403, 'Only an FL Administrator can manage approver assignments.'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  INSERT INTO dct_fl_approver_map (role_code, org_id, user_id, notes, created_by, updated_by)
  VALUES (APEX_JSON.get_varchar2(p_path => 'roleCode'),
          APEX_JSON.get_number(p_path   => 'orgId'),
          APEX_JSON.get_number(p_path   => 'userId'),
          APEX_JSON.get_varchar2(p_path => 'notes'),
          l_user, l_user)
  RETURNING map_id INTO l_id;
  COMMIT;
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('mapId', l_id); APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN ROLLBACK;
    dct_rest.err(409, 'An assignment for this role and org unit already exists -- edit it instead.');
  WHEN OTHERS THEN ROLLBACK;
    IF SQLCODE = -2291 THEN dct_rest.err(400, 'Unknown role, org unit or user.');
    ELSE dct_rest.err(500, SQLERRM);
    END IF;
END;
!');

    deft('approver-map/[COLON]id');
    defh('approver-map/[COLON]id', 'PUT', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'FL_ADMIN')
     AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403, 'Only an FL Administrator can manage approver assignments.'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  UPDATE dct_fl_approver_map SET
    user_id   = NVL(APEX_JSON.get_number(p_path => 'userId'), user_id),
    is_active = NVL(APEX_JSON.get_varchar2(p_path => 'isActive'), is_active),
    notes     = CASE WHEN APEX_JSON.does_exist(p_path => 'notes')
                     THEN APEX_JSON.get_varchar2(p_path => 'notes') ELSE notes END,
    updated_by = l_user, updated_at = SYSTIMESTAMP
  WHERE map_id = [COLON]id;
  IF SQL%ROWCOUNT = 0 THEN ROLLBACK; dct_rest.err(404, 'Assignment not found.'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    defh('approver-map/[COLON]id', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NOT dct_auth.has_role(l_user, 'FL_ADMIN')
     AND NOT dct_auth.has_role(l_user, 'SYS_ADMIN') THEN
    dct_rest.err(403, 'Only an FL Administrator can manage approver assignments.'); RETURN;
  END IF;
  DELETE FROM dct_fl_approver_map WHERE map_id = [COLON]id;
  IF SQL%ROWCOUNT = 0 THEN ROLLBACK; dct_rest.err(404, 'Assignment not found.'); RETURN; END IF;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object; APEX_JSON.write('ok', TRUE); APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    -- ============ lookups: + contract types / FTE conversion =================
    defh('lookups', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  PROCEDURE emit_cat(p_json IN VARCHAR2, p_cat IN VARCHAR2) IS
  BEGIN
    APEX_JSON.open_array(p_json);
    FOR r IN (SELECT lv.value_id, lv.value_code, lv.value_name_en
              FROM dct_lookup_values lv
              JOIN dct_lookup_categories lc ON lc.category_id = lv.category_id
              WHERE lc.category_code = p_cat AND lv.is_active = 'Y'
              ORDER BY lv.display_order, lv.value_name_en) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('valueId', r.value_id);
      APEX_JSON.write('code',    r.value_code);
      APEX_JSON.write('name',    r.value_name_en);
      APEX_JSON.close_object;
    END LOOP;
    APEX_JSON.close_array;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  emit_cat('billingUnits',   'FL_BILLING_UNIT');
  emit_cat('paymentMethods', 'FL_PAYMENT_METHOD');
  emit_cat('payGroups',      'FL_PAY_GROUP');
  emit_cat('contractTypes',  'FL_CONTRACT_TYPE');
  emit_cat('fteConversion',  'FL_FTE_CONVERSION');
  APEX_JSON.open_array('nationalities');
  FOR r IN (SELECT nationality_code, nationality_en FROM dct_nationality ORDER BY nationality_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.nationality_code);
    APEX_JSON.write('name', r.nationality_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('orgs');
  FOR r IN (SELECT org_id, org_name_en FROM dct_organizations
            WHERE is_active = 'Y' ORDER BY org_name_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('orgId', r.org_id);
    APEX_JSON.write('name',  r.org_name_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('docTypes');
  FOR r IN (SELECT doc_type_id, doc_type_code, doc_type_name_en FROM dct_document_types
            ORDER BY doc_type_name_en) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('docTypeId', r.doc_type_id);
    APEX_JSON.write('code',      r.doc_type_code);
    APEX_JSON.write('name',      r.doc_type_name_en);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('fl.rest Contract Phase 2 handlers defined.');
END;
/

PROMPT === 28_fl_contract_phase2_ords.sql complete ===
