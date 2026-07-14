-- =============================================================================
-- Freelancers Module (App 203) -- Payment-method lookup + admin-editable voucher
-- File    : 37_fl_payment_methods.sql
-- Schema  : lookups/settings in PROD; ORDS handler under ADMIN (fl.rest).
-- Run     : sql -name prod_mcp @37_fl_payment_methods.sql   (FRESH session.
--           Additive + re-runnable. Run AFTER 36; re-run after any 08 re-run.)
-- Purpose :
--   1. PAYMENT METHOD lookup (FL_PAYMENT_METHOD) is now  EFT / RATABI / TRUST.
--      The legacy BANK_TRANSFER / CHEQUE / CASH values are DE-ACTIVATED, not
--      deleted -- vouchers already raised against them keep their recorded
--      method (the voucher form re-injects an inactive stored value as its own
--      option, per the KO options rule). EFT is the default; the
--      DEFAULT_PAYMENT_METHOD module setting is re-pointed at it.
--   2. A GENERATED voucher stays EDITABLE BY AN FL ADMIN -- due date, amount,
--      period label, description and pay group, on top of the fields any user
--      may edit while the voucher is a draft. Admin-only fields are rejected
--      (403) for everyone else, and an admin may still edit a voucher that has
--      been SUBMITTED for approval (nobody may edit one that is APPROVED,
--      REJECTED, PAID or CANCELLED).
--      Changing the amount or due date also re-syncs the payment-schedule row
--      the voucher was generated from, so the schedule and the voucher can
--      never disagree.
-- Source  : handler synced into 08_fl_ords.sql.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- -----------------------------------------------------------------------------
-- 1. FL_PAYMENT_METHOD lookup values (Arabic via UNISTR -- keeps this file ASCII
--    so SQLcl cannot mangle it)
-- -----------------------------------------------------------------------------
DECLARE
    v_cat NUMBER;
    v_cnt NUMBER;

    PROCEDURE upsert_value(p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2,
                           p_ar VARCHAR2, p_ord NUMBER, p_def VARCHAR2 DEFAULT 'N') IS
        v_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_n FROM prod.dct_lookup_values
        WHERE  category_id = p_cat AND value_code = p_code;
        IF v_n = 0 THEN
            INSERT INTO prod.dct_lookup_values
                   (category_id, value_code, value_name_en, value_name_ar,
                    display_order, is_default, is_active)
            VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_def, 'Y');
        ELSE
            UPDATE prod.dct_lookup_values
            SET    value_name_en = p_en, value_name_ar = p_ar,
                   display_order = p_ord, is_default = p_def, is_active = 'Y'
            WHERE  category_id = p_cat AND value_code = p_code;
        END IF;
    END;
BEGIN
    SELECT category_id INTO v_cat FROM prod.dct_lookup_categories
    WHERE  category_code = 'FL_PAYMENT_METHOD';

    -- the new set
    upsert_value(v_cat, 'EFT',    'EFT',
                 UNISTR('\062A\062D\0648\064A\0644 \0625\0644\0643\062A\0631\0648\0646\064A'), 10, 'Y');
    upsert_value(v_cat, 'RATABI', 'Ratabi',
                 UNISTR('\0631\0648\0627\062A\0628\064A'), 20);
    upsert_value(v_cat, 'TRUST',  'Trust',
                 UNISTR('\062A\0631\0633\062A'), 30);

    -- retire the legacy set (kept for the vouchers that already carry them)
    UPDATE prod.dct_lookup_values
    SET    is_active = 'N', is_default = 'N'
    WHERE  category_id = v_cat
    AND    value_code IN ('BANK_TRANSFER', 'CHEQUE', 'CASH');
    v_cnt := SQL%ROWCOUNT;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('FL_PAYMENT_METHOD: EFT / RATABI / TRUST active; '
                         || v_cnt || ' legacy value(s) de-activated.');
END;
/

-- -----------------------------------------------------------------------------
-- 2. DEFAULT_PAYMENT_METHOD module setting follows the lookup
-- -----------------------------------------------------------------------------
DECLARE
    v_mod NUMBER;
BEGIN
    SELECT module_id INTO v_mod FROM prod.dct_modules WHERE module_code = 'FREELANCERS';

    UPDATE prod.dct_module_settings
    SET    setting_value  = CASE WHEN setting_value IN ('EFT','RATABI','TRUST')
                                 THEN setting_value ELSE 'EFT' END,
           allowed_values = 'EFT|RATABI|TRUST',
           default_value  = 'EFT',
           setting_description = 'Default value for payment_method on new vouchers. '
                              || 'Must match FL_PAYMENT_METHOD lookup codes.',
           updated_by     = 'SYSTEM',
           updated_at     = SYSTIMESTAMP
    WHERE  module_id = v_mod
    AND    setting_key = 'DEFAULT_PAYMENT_METHOD';

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('DEFAULT_PAYMENT_METHOD re-pointed at EFT|RATABI|TRUST.');
END;
/

-- -----------------------------------------------------------------------------
-- 3. ORDS: PUT /fl/vouchers/:id -- admin-editable generated voucher
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE setup_fl_voucher_edit_tmp AS
    c_mod CONSTANT VARCHAR2(30) := 'fl.rest';

    PROCEDURE defh(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method => p_method, p_source_type => ORDS.source_type_plsql,
            p_source => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN
    defh('vouchers/[COLON]id', 'PUT', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_status VARCHAR2(20);
  l_pstat  VARCHAR2(20);
  l_sched  NUMBER;
  l_admin  BOOLEAN;
  l_privd  BOOLEAN;
  l_amt    NUMBER;
  l_due    DATE;
  l_old    CLOB;
  l_new    CLOB;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;

  BEGIN
    SELECT status, payment_status, schedule_id
      INTO l_status, l_pstat, l_sched
      FROM dct_fl_payment_vouchers WHERE voucher_id = [COLON]id;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'Voucher not found'); RETURN;
  END;

  l_admin := dct_auth.has_role(l_user,'FL_ADMIN') OR dct_auth.has_role(l_user,'SYS_ADMIN');

  dct_rest.parse_body([COLON]body);

  -- due date / amount / period label are the admin-only fields
  l_privd := APEX_JSON.does_exist(p_path => 'amount')
          OR APEX_JSON.does_exist(p_path => 'dueDate')
          OR APEX_JSON.does_exist(p_path => 'periodLabel');
  IF l_privd AND NOT l_admin THEN
    dct_rest.err(403,'Only an FL administrator can change the amount, due date or period of a voucher');
    RETURN;
  END IF;

  -- who may edit, and when
  IF l_status = 'DRAFT' THEN
    NULL;                                   -- a draft is editable by its owner
  ELSIF l_status = 'SUBMITTED' AND l_admin THEN
    NULL;                                   -- an admin may still correct one in flight
  ELSE
    dct_rest.err(400,'This voucher can no longer be edited (status ' || l_status || ')');
    RETURN;
  END IF;
  IF l_pstat = 'PAID' THEN
    dct_rest.err(400,'A paid voucher cannot be edited'); RETURN;
  END IF;

  IF APEX_JSON.does_exist(p_path => 'amount') THEN
    l_amt := APEX_JSON.get_number(p_path => 'amount');
    IF l_amt IS NULL OR l_amt <= 0 THEN
      dct_rest.err(400,'Amount must be greater than zero'); RETURN;
    END IF;
  END IF;
  IF APEX_JSON.does_exist(p_path => 'dueDate') THEN
    BEGIN
      l_due := TO_DATE(APEX_JSON.get_varchar2(p_path => 'dueDate'),'YYYY-MM-DD');
    EXCEPTION WHEN OTHERS THEN
      dct_rest.err(400,'Due date must be a valid date (YYYY-MM-DD)'); RETURN;
    END;
    IF l_due IS NULL THEN dct_rest.err(400,'Due date is required'); RETURN; END IF;
  END IF;

  l_old := dct_audit_pkg.snap('DCT_FL_PAYMENT_VOUCHERS','voucher_id', TO_CHAR([COLON]id));

  UPDATE dct_fl_payment_vouchers SET
    amount         = CASE WHEN APEX_JSON.does_exist(p_path => 'amount')
                          THEN l_amt ELSE amount END,
    due_date       = CASE WHEN APEX_JSON.does_exist(p_path => 'dueDate')
                          THEN l_due ELSE due_date END,
    period_label   = CASE WHEN APEX_JSON.does_exist(p_path => 'periodLabel')
                          THEN APEX_JSON.get_varchar2(p_path => 'periodLabel') ELSE period_label END,
    invoice_number = CASE WHEN APEX_JSON.does_exist(p_path => 'invoiceNumber')
                          THEN APEX_JSON.get_varchar2(p_path => 'invoiceNumber') ELSE invoice_number END,
    invoice_date   = CASE WHEN APEX_JSON.does_exist(p_path => 'invoiceDate')
                          THEN TO_DATE(APEX_JSON.get_varchar2(p_path => 'invoiceDate'),'YYYY-MM-DD') ELSE invoice_date END,
    payment_method = NVL(APEX_JSON.get_varchar2(p_path => 'paymentMethod'), payment_method),
    pay_group      = NVL(APEX_JSON.get_varchar2(p_path => 'payGroup'), pay_group),
    description    = CASE WHEN APEX_JSON.does_exist(p_path => 'description')
                          THEN APEX_JSON.get_varchar2(p_path => 'description') ELSE description END,
    post_to_fusion = NVL(APEX_JSON.get_varchar2(p_path => 'postToFusion'), post_to_fusion),
    notes          = CASE WHEN APEX_JSON.does_exist(p_path => 'notes')
                          THEN APEX_JSON.get_varchar2(p_path => 'notes') ELSE notes END,
    updated_by     = l_user, updated_at = SYSTIMESTAMP
  WHERE voucher_id = [COLON]id;

  -- the schedule row the voucher was generated from must not drift away from it
  IF l_sched IS NOT NULL AND l_privd THEN
    UPDATE dct_fl_payment_schedule SET
      amount       = CASE WHEN APEX_JSON.does_exist(p_path => 'amount')
                          THEN l_amt ELSE amount END,
      due_date     = CASE WHEN APEX_JSON.does_exist(p_path => 'dueDate')
                          THEN l_due ELSE due_date END,
      period_label = CASE WHEN APEX_JSON.does_exist(p_path => 'periodLabel')
                          THEN APEX_JSON.get_varchar2(p_path => 'periodLabel') ELSE period_label END,
      updated_at   = SYSTIMESTAMP
    WHERE schedule_id = l_sched;
  END IF;

  COMMIT;

  l_new := dct_audit_pkg.snap('DCT_FL_PAYMENT_VOUCHERS','voucher_id', TO_CHAR([COLON]id));
  dct_audit_pkg.log(l_user,'UPDATE','DCT_FL_PAYMENT_VOUCHERS', TO_CHAR([COLON]id), 'FL',
                    p_old=>l_old, p_new=>l_new);

  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.write('scheduleSynced', CASE WHEN l_sched IS NOT NULL AND l_privd THEN 'Y' ELSE 'N' END);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN ROLLBACK; dct_rest.err(500, SQLERRM);
END;
!');

END setup_fl_voucher_edit_tmp;
/

BEGIN
    setup_fl_voucher_edit_tmp;
    COMMIT;
END;
/

DROP PROCEDURE setup_fl_voucher_edit_tmp;

PROMPT === 37_fl_payment_methods.sql complete ===
