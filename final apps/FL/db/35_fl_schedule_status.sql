-- =============================================================================
-- Freelancers Module (App 203) -- Payment-schedule status follows the voucher
-- File    : 35_fl_schedule_status.sql
-- Schema  : lookups in PROD; ORDS handlers under ADMIN (fl.rest).
-- Run     : sql -name prod_mcp @35_fl_schedule_status.sql   (ANY session -- adds
--           lookup values and REDEFINES two handlers on fl.rest; no synonyms, no
--           module rebuild. Safe to re-run. Re-run after any 08 re-run.)
-- Purpose : A schedule row stayed PENDING after its voucher was generated, and
--           only flipped to VOUCHER_GENERATED once the voucher was APPROVED --
--           so the list never showed where a payment actually was. The schedule
--           row now mirrors the voucher's own lifecycle:
--
--             PENDING            no voucher yet
--             VOUCHER_GENERATED  voucher created (DRAFT/SUBMITTED)   -> "Generated"
--             VOUCHER_APPROVED   voucher approved, awaiting payment  -> "Approved"
--             PAID               payment confirmed (Fusion callback or mark-paid)
--             SKIPPED            deliberately not paid
--
--           A rejected / cancelled voucher releases its schedule row back to
--           PENDING so a new voucher can be raised (DCT_FL_PKG, 07).
--   This script: (1) seeds the new VOUCHER_APPROVED lookup value and renames
--   VOUCHER_GENERATED to the plain "Generated"; (2) makes voucher creation
--   (single + bulk) stamp the schedule row VOUCHER_GENERATED immediately.
--   The APPROVED / PAID / released-on-reject transitions live in DCT_FL_PKG
--   (07_fl_pkg_workflow.sql -- re-run it alongside this script).
-- Source  : handlers synced into 08_fl_ords.sql.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- -----------------------------------------------------------------------------
-- 1. Lookup values (FL_SCHEDULE_STATUS)
-- -----------------------------------------------------------------------------
DECLARE
    v_cat NUMBER;
    v_cnt NUMBER;
BEGIN
    SELECT category_id INTO v_cat FROM prod.dct_lookup_categories
    WHERE  category_code = 'FL_SCHEDULE_STATUS';

    UPDATE prod.dct_lookup_values
    SET    value_name_en = 'Generated',
           value_name_ar = UNISTR('\062A\0645 \0625\0646\0634\0627\0624\0647')
    WHERE  category_id = v_cat AND value_code = 'VOUCHER_GENERATED';

    SELECT COUNT(*) INTO v_cnt FROM prod.dct_lookup_values
    WHERE  category_id = v_cat AND value_code = 'VOUCHER_APPROVED';
    IF v_cnt = 0 THEN
        INSERT INTO prod.dct_lookup_values
               (category_id, value_code, value_name_en, value_name_ar,
                display_order, is_default, is_active, created_by)
        VALUES (v_cat, 'VOUCHER_APPROVED', 'Approved',
                UNISTR('\0645\0639\062A\0645\062F'), 25, 'N', 'Y', 'SYSTEM');
    END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('FL_SCHEDULE_STATUS: Generated + Approved ready');
END;
/

-- -----------------------------------------------------------------------------
-- 1b. Backfill: rows whose voucher was raised BEFORE this change stayed PENDING
--     with a NULL voucher_id. Re-point them at their open voucher and set the
--     status the voucher's own state implies. Re-runnable (idempotent).
-- -----------------------------------------------------------------------------
DECLARE
    v_n NUMBER := 0;
BEGIN
    FOR r IN (
        SELECT s.schedule_id, v.voucher_id, v.status, v.payment_status
        FROM   prod.dct_fl_payment_schedule s
        JOIN   prod.dct_fl_payment_vouchers v ON v.schedule_id = s.schedule_id
        WHERE  v.status NOT IN ('REJECTED','CANCELLED')
        AND    s.status = 'PENDING'
    ) LOOP
        UPDATE prod.dct_fl_payment_schedule
        SET    voucher_id = r.voucher_id,
               status     = CASE
                              WHEN r.payment_status = 'PAID' THEN 'PAID'
                              WHEN r.status = 'APPROVED'     THEN 'VOUCHER_APPROVED'
                              ELSE 'VOUCHER_GENERATED'
                            END,
               updated_at = SYSTIMESTAMP
        WHERE  schedule_id = r.schedule_id;
        v_n := v_n + 1;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('backfilled schedule rows: ' || v_n);
END;
/

-- -----------------------------------------------------------------------------
-- 2. Voucher creation stamps the schedule row (single + bulk)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE setup_fl_sched_status_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'fl.rest';

    PROCEDURE defh(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    defh('vouchers/', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_id     NUMBER;
  l_num    VARCHAR2(50);
  l_sched  NUMBER;
  l_s      dct_fl_payment_schedule%ROWTYPE;
  l_con    dct_fl_contracts%ROWTYPE;
  l_open   NUMBER;
  l_desc   VARCHAR2(1000);
  l_new    CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_rest.parse_body([COLON]body);
  l_sched := APEX_JSON.get_number(p_path => 'scheduleId');
  IF l_sched IS NULL THEN
    dct_rest.err(400,'scheduleId is required (vouchers are generated from payment schedule rows)'); RETURN;
  END IF;
  SELECT * INTO l_s FROM dct_fl_payment_schedule WHERE schedule_id = l_sched;
  IF l_s.status != 'PENDING' THEN
    dct_rest.err(400,'Schedule row is not PENDING (status: ' || l_s.status || ')'); RETURN;
  END IF;
  SELECT COUNT(*) INTO l_open FROM dct_fl_payment_vouchers
  WHERE schedule_id = l_sched AND status NOT IN ('REJECTED','CANCELLED');
  IF l_open > 0 THEN
    dct_rest.err(400,'A voucher already exists for this payment period'); RETURN;
  END IF;
  SELECT * INTO l_con FROM dct_fl_contracts WHERE contract_id = l_s.contract_id;
  l_num  := 'FL-VCH-' || TO_CHAR(seq_fl_voucher_number.NEXTVAL, 'FM000000');
  l_desc := NVL(dct_fl_pkg.get_setting('VOUCHER_DEFAULT_DESCRIPTION'),
                'Freelancer Payment - {CONTRACT_NUMBER} - {PERIOD_LABEL}');
  l_desc := REPLACE(REPLACE(l_desc, '{CONTRACT_NUMBER}', l_con.contract_number),
                    '{PERIOD_LABEL}', l_s.period_label);
  INSERT INTO dct_fl_payment_vouchers (
    voucher_number, contract_id, freelancer_id, schedule_id,
    period_label, due_date, amount,
    invoice_number, invoice_date,
    payment_method, pay_group, description,
    coding_type, cc_id_gl, project_number, task_number, expenditure_type,
    post_to_fusion, status, payment_status, created_by, updated_by
  ) VALUES (
    l_num, l_con.contract_id, l_con.freelancer_id, l_sched,
    l_s.period_label, l_s.due_date, l_s.amount,
    APEX_JSON.get_varchar2(p_path => 'invoiceNumber'),
    TO_DATE(APEX_JSON.get_varchar2(p_path => 'invoiceDate'), 'YYYY-MM-DD'),
    NVL(APEX_JSON.get_varchar2(p_path => 'paymentMethod'),
        NVL(dct_fl_pkg.get_setting('DEFAULT_PAYMENT_METHOD'), 'BANK_TRANSFER')),
    NVL(APEX_JSON.get_varchar2(p_path => 'payGroup'),
        NVL(dct_fl_pkg.get_setting('DEFAULT_PAY_GROUP'), 'FREELANCER')),
    l_desc,
    l_con.coding_type, l_con.cc_id_gl, l_con.project_number, l_con.task_number, l_con.expenditure_type,
    'N', 'DRAFT', 'PENDING', l_user, l_user
  ) RETURNING voucher_id INTO l_id;
  -- the schedule row now carries the voucher: PENDING -> VOUCHER_GENERATED
  UPDATE dct_fl_payment_schedule
  SET    status = 'VOUCHER_GENERATED', voucher_id = l_id, updated_at = SYSTIMESTAMP
  WHERE  schedule_id = l_sched;
  COMMIT;
  l_new := dct_audit_pkg.snap('DCT_FL_PAYMENT_VOUCHERS','voucher_id', TO_CHAR(l_id));
  dct_audit_pkg.log(l_user,'CREATE','DCT_FL_PAYMENT_VOUCHERS', TO_CHAR(l_id), 'FL',
                    p_object_ref=>l_num, p_new=>l_new);
  OWA_UTIL.status_line(201, NULL, FALSE);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('voucherId', l_id);
  APEX_JSON.write('voucherNumber', l_num);
  APEX_JSON.write('scheduleStatus', 'VOUCHER_GENERATED');
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

    defh('schedule/bulk-generate', 'POST', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_dstr    VARCHAR2(20);
  l_due     DATE;
  l_tpl     VARCHAR2(1000);
  l_desc    VARCHAR2(1000);
  l_pay     VARCHAR2(30);
  l_grp     VARCHAR2(30);
  l_num     VARCHAR2(50);
  l_id      NUMBER;
  l_ids     APEX_T_NUMBER   := APEX_T_NUMBER();
  l_nums    APEX_T_VARCHAR2 := APEX_T_VARCHAR2();
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF NVL(dct_fl_pkg.get_setting('ALLOW_BULK_VOUCHER_GENERATION'),'N') != 'Y' THEN
    dct_rest.err(403,'Bulk voucher generation is disabled (ALLOW_BULK_VOUCHER_GENERATION)'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_dstr := APEX_JSON.get_varchar2(p_path => 'dueBefore');
  IF l_dstr IS NOT NULL THEN
    l_due := TO_DATE(l_dstr DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
  END IF;
  l_tpl := NVL(dct_fl_pkg.get_setting('VOUCHER_DEFAULT_DESCRIPTION'),
               'Freelancer Payment - {CONTRACT_NUMBER} - {PERIOD_LABEL}');
  l_pay := NVL(dct_fl_pkg.get_setting('DEFAULT_PAYMENT_METHOD'), 'BANK_TRANSFER');
  l_grp := NVL(dct_fl_pkg.get_setting('DEFAULT_PAY_GROUP'), 'FREELANCER');
  FOR s IN (
    SELECT s.schedule_id, s.contract_id, s.period_label, s.due_date, s.amount,
           c.contract_number, c.freelancer_id,
           c.coding_type, c.cc_id_gl, c.project_number, c.task_number, c.expenditure_type
    FROM dct_fl_payment_schedule s
    JOIN dct_fl_contracts c ON c.contract_id = s.contract_id
    WHERE s.status = 'PENDING'
      AND (l_due IS NULL OR s.due_date <= l_due)
      AND NOT EXISTS (SELECT 1 FROM dct_fl_payment_vouchers v
                      WHERE v.schedule_id = s.schedule_id
                        AND v.status NOT IN ('REJECTED','CANCELLED'))
    ORDER BY s.due_date
  ) LOOP
    l_num  := 'FL-VCH-' || TO_CHAR(seq_fl_voucher_number.NEXTVAL, 'FM000000');
    l_desc := REPLACE(REPLACE(l_tpl, '{CONTRACT_NUMBER}', s.contract_number),
                      '{PERIOD_LABEL}', s.period_label);
    INSERT INTO dct_fl_payment_vouchers (
      voucher_number, contract_id, freelancer_id, schedule_id,
      period_label, due_date, amount, payment_method, pay_group, description,
      coding_type, cc_id_gl, project_number, task_number, expenditure_type,
      post_to_fusion, status, payment_status, created_by, updated_by
    ) VALUES (
      l_num, s.contract_id, s.freelancer_id, s.schedule_id,
      s.period_label, s.due_date, s.amount, l_pay, l_grp, l_desc,
      s.coding_type, s.cc_id_gl, s.project_number, s.task_number, s.expenditure_type,
      'N', 'DRAFT', 'PENDING', l_user, l_user
    ) RETURNING voucher_id INTO l_id;
    UPDATE dct_fl_payment_schedule
    SET    status = 'VOUCHER_GENERATED', voucher_id = l_id, updated_at = SYSTIMESTAMP
    WHERE  schedule_id = s.schedule_id;
    l_ids.EXTEND;  l_ids(l_ids.COUNT)  := l_id;
    l_nums.EXTEND; l_nums(l_nums.COUNT) := l_num;
  END LOOP;
  COMMIT;
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('created', l_ids.COUNT);
  APEX_JSON.open_array('vouchers');
  FOR i IN 1 .. l_nums.COUNT LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('voucherId', l_ids(i));
    APEX_JSON.write('voucherNumber', l_nums(i));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

END setup_fl_sched_status_tmp;
/

BEGIN
    setup_fl_sched_status_tmp;
    COMMIT;
END;
/

DROP PROCEDURE setup_fl_sched_status_tmp;

PROMPT === 35_fl_schedule_status.sql complete ===
