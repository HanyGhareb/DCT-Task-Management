-- =============================================================================
-- Petty Cash Module — Fusion AP write-back hooks (Reimbursement / Advance / Clearing)
-- File    : 07_pc_fusion.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @07_pc_fusion.sql   (after 04_pc_pkg.sql,
--           otbi-atd/db/19_atd_action_queue.sql, 21_emp_supplier_map.sql,
--           23_fusion_doctype_map.sql)
-- Provides:
--   * Fusion tracking columns on DCT_PC_REIMBURSEMENTS / DCT_PETTY_CASH / DCT_PC_CLEARING
--   * settings : FUSION_POST_REIMB / FUSION_POST_ADVANCE / FUSION_POST_CLEARING (Y/N gates)
--               + FUSION_ENV_NAME (target env)
--   * DCT_PC_FUSION_PKG : payload builders + enqueue + generic result callback for all
--     three PC documents. Invoice TYPE is configurable (DCT_FUSION_DOCTYPE_MAP):
--       Reimbursement -> Standard,  Clearing -> Standard,  Advance -> Prepayment.
-- Generalizes the FL push_to_fusion / receive_fusion_callback pattern.
-- No ALTER SESSION here (prod.-qualified) so the trailing synonym is safe.
-- Rerunnable. CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO ON

-- ---------------------------------------------------------------------------
-- 1. Tracking columns (guarded for rerun) on all three PC document tables
-- ---------------------------------------------------------------------------
DECLARE
  PROCEDURE add_col(p_tab VARCHAR2, p_col VARCHAR2, p_def VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE prod.' || p_tab || ' ADD (' || p_col || ' ' || p_def || ')';
  EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;  -- already exists
  END;
BEGIN
  FOR t IN (SELECT column_value tab FROM TABLE(sys.odcivarchar2list(
              'dct_pc_reimbursements','dct_petty_cash','dct_pc_clearing'))) LOOP
    add_col(t.tab, 'post_to_fusion',    q'[CHAR(1) DEFAULT 'N' NOT NULL]');
    add_col(t.tab, 'fusion_status',     'VARCHAR2(20)');
    add_col(t.tab, 'fusion_invoice_id', 'VARCHAR2(60)');
    add_col(t.tab, 'fusion_pushed_at',  'TIMESTAMP');
  END LOOP;
END;
/

-- ---------------------------------------------------------------------------
-- 2. Module settings (Y/N gates per document + target env). Values preserved on re-seed.
-- ---------------------------------------------------------------------------
DECLARE
  v_module_id prod.dct_modules.module_id%TYPE;
  PROCEDURE seed_setting(p_key VARCHAR2, p_val VARCHAR2, p_label VARCHAR2,
                         p_desc VARCHAR2, p_type VARCHAR2, p_allow VARCHAR2) IS
  BEGIN
    MERGE INTO prod.dct_module_settings s
    USING (SELECT v_module_id AS module_id, p_key AS setting_key FROM dual) src
    ON    (s.module_id = src.module_id AND s.setting_key = src.setting_key)
    WHEN NOT MATCHED THEN
      INSERT (module_id, setting_key, setting_value, setting_label,
              setting_description, value_type, allowed_values, default_value, effective_date)
      VALUES (v_module_id, p_key, p_val, p_label, p_desc, p_type, p_allow, p_val, SYSDATE)
    WHEN MATCHED THEN
      UPDATE SET setting_label = p_label, setting_description = p_desc,
                 value_type = p_type, allowed_values = p_allow, default_value = p_val;
  END;
BEGIN
  SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'PETTY_CASH';
  seed_setting('FUSION_POST_REIMB', 'N', 'Post Reimbursements to Fusion AP',
    'When Y, an approved reimbursement is queued as a Fusion AP invoice action.', 'BOOLEAN', 'Y,N');
  seed_setting('FUSION_POST_ADVANCE', 'N', 'Post Advances to Fusion AP',
    'When Y, a disbursed petty cash advance is queued as a Fusion AP prepayment action.', 'BOOLEAN', 'Y,N');
  seed_setting('FUSION_POST_CLEARING', 'N', 'Post Clearings to Fusion AP',
    'When Y, an approved clearing is queued as a Fusion AP invoice action.', 'BOOLEAN', 'Y,N');
  seed_setting('FUSION_ENV_NAME', NULL, 'Fusion Environment (action target)',
    'ATD_OTBI_ENV name the action robot acts in (blank = runner default).', 'TEXT', NULL);
  COMMIT;
END;
/

-- ---------------------------------------------------------------------------
-- 3. Package
-- ---------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE prod.dct_pc_fusion_pkg AS
  -- Payload builders (also usable for preview).
  FUNCTION build_ap_invoice_payload(p_reimb_id NUMBER) RETURN CLOB;   -- reimbursement
  FUNCTION build_advance_payload   (p_pc_id NUMBER)    RETURN CLOB;   -- advance (prepayment)
  FUNCTION build_clearing_payload  (p_clearing_id NUMBER) RETURN CLOB;-- clearing

  -- Enqueue one action (no-op unless the matching FUSION_POST_* gate = Y, or the
  -- row's post_to_fusion = 'Y'). Safe to call unconditionally from approval/disburse hooks.
  PROCEDURE enqueue_fusion_action  (p_reimb_id NUMBER);     -- reimbursement (APPROVED)
  PROCEDURE enqueue_advance_action (p_pc_id NUMBER);        -- advance (disbursed -> ACTIVE)
  PROCEDURE enqueue_clearing_action(p_clearing_id NUMBER);  -- clearing (APPROVED)

  -- Generic runner callback after the document is created in Fusion.
  PROCEDURE receive_fusion_result(p_source_type VARCHAR2, p_source_id NUMBER,
                                  p_invoice_id VARCHAR2, p_ref VARCHAR2 DEFAULT NULL);
END dct_pc_fusion_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_pc_fusion_pkg AS

  -- configurable invoice type for a PC source document (default Standard)
  FUNCTION doctype(p_type VARCHAR2) RETURN VARCHAR2 IS
    v VARCHAR2(40);
  BEGIN
    SELECT invoice_type INTO v FROM prod.dct_fusion_doctype_map
     WHERE source_module = 'PC' AND source_type = p_type;
    RETURN v;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 'Standard';
  END doctype;

  FUNCTION build_ap_invoice_payload(p_reimb_id NUMBER) RETURN CLOB IS
    v_payload CLOB; v_type VARCHAR2(40) := doctype('PC_REIMB');
  BEGIN
    SELECT JSON_OBJECT(
             'action' VALUE 'AP_INVOICE', 'invoiceType' VALUE v_type,
             'invoiceNumber' VALUE r.reimb_number,
             'invoiceAmount' VALUE r.amount,
             'invoiceDate'   VALUE TO_CHAR(NVL(r.submitted_at, r.created_at), 'YYYY-MM-DD'),
             'currency'      VALUE NVL(m.currency_code, 'AED'),
             'description'   VALUE r.purpose,
             'businessUnit'  VALUE NVL(m.business_unit, o.org_name_en),
             'codingType'    VALUE r.coding_type,
             'supplier'      VALUE JSON_OBJECT(
                                'number' VALUE m.supplier_number, 'name' VALUE m.supplier_name,
                                'site' VALUE m.supplier_site, 'paymentMethod' VALUE m.payment_method,
                                'payGroup' VALUE m.pay_group, 'paymentTerms' VALUE m.payment_terms
                                ABSENT ON NULL),
             'payee'         VALUE JSON_OBJECT(
                                'employeeNumber' VALUE pc.employee_num, 'name' VALUE u.display_name,
                                'pettyCashNumber' VALUE pc.pc_number ABSENT ON NULL),
             'lines'         VALUE (
                 SELECT JSON_ARRAYAGG(JSON_OBJECT(
                          'lineNumber' VALUE bl.line_num, 'amount' VALUE bl.amount,
                          'glAccount' VALUE gl.cc_code, 'projectNumber' VALUE bl.project_number,
                          'taskNumber' VALUE bl.task_number, 'expenditureType' VALUE bl.expenditure_type,
                          'description' VALUE bl.description ABSENT ON NULL)
                          ORDER BY bl.line_num RETURNING CLOB)
                 FROM prod.dct_pc_reimb_budget_lines bl
                 LEFT JOIN prod.dct_gl_code_combinations gl ON gl.cc_id = bl.cc_id
                 WHERE bl.reimb_id = r.reimb_id)
             ABSENT ON NULL RETURNING CLOB)
    INTO v_payload
    FROM prod.dct_pc_reimbursements r
    JOIN prod.dct_petty_cash pc ON pc.pc_id = r.pc_id
    LEFT JOIN prod.dct_users u ON u.user_id = pc.user_id
    LEFT JOIN prod.dct_organizations o ON o.org_id = pc.org_id
    LEFT JOIN prod.dct_emp_supplier_map m
           ON m.source_module = 'PC' AND m.party_key = pc.employee_num AND m.is_active = 'Y'
    WHERE r.reimb_id = p_reimb_id;
    RETURN v_payload;
  END build_ap_invoice_payload;

  FUNCTION build_advance_payload(p_pc_id NUMBER) RETURN CLOB IS
    v_payload CLOB; v_type VARCHAR2(40) := doctype('PC_ADVANCE');
  BEGIN
    SELECT JSON_OBJECT(
             'action' VALUE 'AP_INVOICE', 'invoiceType' VALUE v_type,
             'invoiceNumber' VALUE pc.pc_number,
             'invoiceAmount' VALUE pc.amount,
             'invoiceDate'   VALUE TO_CHAR(NVL(pc.disbursed_date, NVL(pc.submitted_at, pc.created_at)), 'YYYY-MM-DD'),
             'currency'      VALUE NVL(m.currency_code, 'AED'),
             'description'   VALUE pc.purpose,
             'businessUnit'  VALUE NVL(m.business_unit, o.org_name_en),
             'codingType'    VALUE pc.coding_type,
             'supplier'      VALUE JSON_OBJECT(
                                'number' VALUE m.supplier_number, 'name' VALUE m.supplier_name,
                                'site' VALUE m.supplier_site, 'paymentMethod' VALUE m.payment_method,
                                'payGroup' VALUE m.pay_group, 'paymentTerms' VALUE m.payment_terms
                                ABSENT ON NULL),
             'payee'         VALUE JSON_OBJECT(
                                'employeeNumber' VALUE pc.employee_num, 'name' VALUE u.display_name,
                                'pettyCashNumber' VALUE pc.pc_number ABSENT ON NULL),
             'lines'         VALUE (
                 SELECT JSON_ARRAYAGG(JSON_OBJECT(
                          'lineNumber' VALUE bl.line_num, 'amount' VALUE bl.amount,
                          'glAccount' VALUE gl.cc_code, 'projectNumber' VALUE bl.project_number,
                          'taskNumber' VALUE bl.task_number, 'expenditureType' VALUE bl.expenditure_type,
                          'description' VALUE bl.description ABSENT ON NULL)
                          ORDER BY bl.line_num RETURNING CLOB)
                 FROM prod.dct_pc_budget_lines bl
                 LEFT JOIN prod.dct_gl_code_combinations gl ON gl.cc_id = bl.cc_id
                 WHERE bl.pc_id = pc.pc_id)
             ABSENT ON NULL RETURNING CLOB)
    INTO v_payload
    FROM prod.dct_petty_cash pc
    LEFT JOIN prod.dct_users u ON u.user_id = pc.user_id
    LEFT JOIN prod.dct_organizations o ON o.org_id = pc.org_id
    LEFT JOIN prod.dct_emp_supplier_map m
           ON m.source_module = 'PC' AND m.party_key = pc.employee_num AND m.is_active = 'Y'
    WHERE pc.pc_id = p_pc_id;
    RETURN v_payload;
  END build_advance_payload;

  FUNCTION build_clearing_payload(p_clearing_id NUMBER) RETURN CLOB IS
    v_payload CLOB; v_type VARCHAR2(40) := doctype('PC_CLEAR');
  BEGIN
    SELECT JSON_OBJECT(
             'action' VALUE 'AP_INVOICE', 'invoiceType' VALUE v_type,
             'invoiceNumber' VALUE c.clearing_number,
             'invoiceAmount' VALUE c.amount_spent,
             'invoiceDate'   VALUE TO_CHAR(NVL(c.submitted_at, c.created_at), 'YYYY-MM-DD'),
             'currency'      VALUE NVL(m.currency_code, 'AED'),
             'description'   VALUE 'Clearing for ' || pc.pc_number,
             'businessUnit'  VALUE NVL(m.business_unit, o.org_name_en),
             'codingType'    VALUE c.coding_type,
             'supplier'      VALUE JSON_OBJECT(
                                'number' VALUE m.supplier_number, 'name' VALUE m.supplier_name,
                                'site' VALUE m.supplier_site, 'paymentMethod' VALUE m.payment_method,
                                'payGroup' VALUE m.pay_group, 'paymentTerms' VALUE m.payment_terms
                                ABSENT ON NULL),
             'payee'         VALUE JSON_OBJECT(
                                'employeeNumber' VALUE pc.employee_num, 'name' VALUE u.display_name,
                                'pettyCashNumber' VALUE pc.pc_number ABSENT ON NULL),
             'lines'         VALUE (
                 SELECT JSON_ARRAYAGG(JSON_OBJECT(
                          'lineNumber' VALUE bl.line_num, 'amount' VALUE bl.amount,
                          'glAccount' VALUE gl.cc_code, 'projectNumber' VALUE bl.project_number,
                          'taskNumber' VALUE bl.task_number, 'expenditureType' VALUE bl.expenditure_type,
                          'description' VALUE bl.description ABSENT ON NULL)
                          ORDER BY bl.line_num RETURNING CLOB)
                 FROM prod.dct_pc_clear_budget_lines bl
                 LEFT JOIN prod.dct_gl_code_combinations gl ON gl.cc_id = bl.cc_id
                 WHERE bl.clearing_id = c.clearing_id)
             ABSENT ON NULL RETURNING CLOB)
    INTO v_payload
    FROM prod.dct_pc_clearing c
    JOIN prod.dct_petty_cash pc ON pc.pc_id = c.pc_id
    LEFT JOIN prod.dct_users u ON u.user_id = pc.user_id
    LEFT JOIN prod.dct_organizations o ON o.org_id = pc.org_id
    LEFT JOIN prod.dct_emp_supplier_map m
           ON m.source_module = 'PC' AND m.party_key = pc.employee_num AND m.is_active = 'Y'
    WHERE c.clearing_id = p_clearing_id;
    RETURN v_payload;
  END build_clearing_payload;

  -- shared enqueue core: gate already checked by caller; writes the action + trail
  PROCEDURE enqueue_core(p_source_type VARCHAR2, p_source_id NUMBER, p_idem VARCHAR2,
                         p_old_status VARCHAR2, p_payload CLOB, p_uid NUMBER, p_actor VARCHAR2,
                         p_obj_table VARCHAR2) IS
    v_env VARCHAR2(60); v_id NUMBER;
  BEGIN
    v_env := prod.dct_pc_pkg.get_setting('FUSION_ENV_NAME');
    v_id := prod.atd_action_pkg.enqueue_action(
              p_action_type => 'AP_INVOICE', p_source_module => 'PC',
              p_source_type => p_source_type, p_source_id => p_source_id,
              p_source_ref => p_idem, p_idem_key => p_idem, p_payload => p_payload,
              p_env_name => v_env, p_created_by => p_actor);
    INSERT INTO prod.dct_request_status_history (
      source_module, source_type, source_id, old_status, new_status, changed_by, comments)
    VALUES ('PC', p_source_type, p_source_id, p_old_status, 'FUSION_QUEUED', p_uid,
            'Queued as Fusion AP action #' || v_id);
    prod.dct_audit.log(
      p_action => 'PC_QUEUED_FOR_FUSION', p_object_type => p_obj_table,
      p_object_id => TO_CHAR(p_source_id), p_object_ref => p_idem, p_module_code => 'PETTY_CASH');
  END enqueue_core;

  PROCEDURE enqueue_fusion_action(p_reimb_id NUMBER) IS
    v_r prod.dct_pc_reimbursements%ROWTYPE; v_uid NUMBER; v_gate VARCHAR2(10);
  BEGIN
    SELECT * INTO v_r FROM prod.dct_pc_reimbursements WHERE reimb_id = p_reimb_id;
    IF v_r.status <> 'APPROVED' THEN RETURN; END IF;
    v_gate := prod.dct_pc_pkg.get_setting('FUSION_POST_REIMB');
    IF NVL(v_gate,'N') <> 'Y' AND NVL(v_r.post_to_fusion,'N') <> 'Y' THEN RETURN; END IF;
    SELECT user_id INTO v_uid FROM prod.dct_petty_cash WHERE pc_id = v_r.pc_id;
    enqueue_core('PC_REIMB', p_reimb_id, v_r.reimb_number, v_r.status,
                 build_ap_invoice_payload(p_reimb_id), v_uid,
                 NVL(v_r.updated_by, v_r.created_by), 'DCT_PC_REIMBURSEMENTS');
    UPDATE prod.dct_pc_reimbursements
       SET fusion_status='QUEUED', fusion_pushed_at=SYSTIMESTAMP, updated_at=SYSTIMESTAMP
     WHERE reimb_id = p_reimb_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END enqueue_fusion_action;

  PROCEDURE enqueue_advance_action(p_pc_id NUMBER) IS
    v_pc prod.dct_petty_cash%ROWTYPE; v_gate VARCHAR2(10);
  BEGIN
    SELECT * INTO v_pc FROM prod.dct_petty_cash WHERE pc_id = p_pc_id;
    IF v_pc.status <> 'ACTIVE' THEN RETURN; END IF;   -- prepayment created on disbursement
    v_gate := prod.dct_pc_pkg.get_setting('FUSION_POST_ADVANCE');
    IF NVL(v_gate,'N') <> 'Y' AND NVL(v_pc.post_to_fusion,'N') <> 'Y' THEN RETURN; END IF;
    enqueue_core('PC_ADVANCE', p_pc_id, v_pc.pc_number, v_pc.status,
                 build_advance_payload(p_pc_id), v_pc.user_id,
                 NVL(v_pc.disbursed_by, v_pc.updated_by), 'DCT_PETTY_CASH');
    UPDATE prod.dct_petty_cash
       SET fusion_status='QUEUED', fusion_pushed_at=SYSTIMESTAMP, updated_at=SYSTIMESTAMP
     WHERE pc_id = p_pc_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END enqueue_advance_action;

  PROCEDURE enqueue_clearing_action(p_clearing_id NUMBER) IS
    v_c prod.dct_pc_clearing%ROWTYPE; v_uid NUMBER; v_gate VARCHAR2(10);
  BEGIN
    SELECT * INTO v_c FROM prod.dct_pc_clearing WHERE clearing_id = p_clearing_id;
    IF v_c.status <> 'APPROVED' THEN RETURN; END IF;
    v_gate := prod.dct_pc_pkg.get_setting('FUSION_POST_CLEARING');
    IF NVL(v_gate,'N') <> 'Y' AND NVL(v_c.post_to_fusion,'N') <> 'Y' THEN RETURN; END IF;
    SELECT user_id INTO v_uid FROM prod.dct_petty_cash WHERE pc_id = v_c.pc_id;
    enqueue_core('PC_CLEAR', p_clearing_id, v_c.clearing_number, v_c.status,
                 build_clearing_payload(p_clearing_id), v_uid,
                 NVL(v_c.updated_by, v_c.created_by), 'DCT_PC_CLEARING');
    UPDATE prod.dct_pc_clearing
       SET fusion_status='QUEUED', fusion_pushed_at=SYSTIMESTAMP, updated_at=SYSTIMESTAMP
     WHERE clearing_id = p_clearing_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END enqueue_clearing_action;

  PROCEDURE receive_fusion_result(p_source_type VARCHAR2, p_source_id NUMBER,
                                  p_invoice_id VARCHAR2, p_ref VARCHAR2 DEFAULT NULL) IS
    v_uid NUMBER; v_ref VARCHAR2(40); v_obj VARCHAR2(40); v_n NUMBER;
  BEGIN
    IF p_source_type = 'PC_REIMB' THEN
      v_obj := 'DCT_PC_REIMBURSEMENTS';
      UPDATE prod.dct_pc_reimbursements SET fusion_status='POSTED', fusion_invoice_id=p_invoice_id,
             updated_at=SYSTIMESTAMP WHERE reimb_id=p_source_id RETURNING reimb_number INTO v_ref;
      v_n := SQL%ROWCOUNT;
      SELECT pc.user_id INTO v_uid FROM prod.dct_pc_reimbursements r
        JOIN prod.dct_petty_cash pc ON pc.pc_id=r.pc_id WHERE r.reimb_id=p_source_id;
    ELSIF p_source_type = 'PC_ADVANCE' THEN
      v_obj := 'DCT_PETTY_CASH';
      UPDATE prod.dct_petty_cash SET fusion_status='POSTED', fusion_invoice_id=p_invoice_id,
             updated_at=SYSTIMESTAMP WHERE pc_id=p_source_id
        RETURNING pc_number, user_id INTO v_ref, v_uid;
      v_n := SQL%ROWCOUNT;
    ELSIF p_source_type = 'PC_CLEAR' THEN
      v_obj := 'DCT_PC_CLEARING';
      UPDATE prod.dct_pc_clearing SET fusion_status='POSTED', fusion_invoice_id=p_invoice_id,
             updated_at=SYSTIMESTAMP WHERE clearing_id=p_source_id RETURNING clearing_number INTO v_ref;
      v_n := SQL%ROWCOUNT;
      SELECT pc.user_id INTO v_uid FROM prod.dct_pc_clearing c
        JOIN prod.dct_petty_cash pc ON pc.pc_id=c.pc_id WHERE c.clearing_id=p_source_id;
    ELSE
      RAISE_APPLICATION_ERROR(-20012, 'DCT_PC_FUSION_PKG: unknown source_type ' || p_source_type);
    END IF;

    IF v_n = 0 THEN
      RAISE_APPLICATION_ERROR(-20011, 'DCT_PC_FUSION_PKG: ' || p_source_type || ' ' || p_source_id || ' not found.');
    END IF;

    INSERT INTO prod.dct_request_status_history (
      source_module, source_type, source_id, old_status, new_status, changed_by, comments)
    VALUES ('PC', p_source_type, p_source_id, 'FUSION_QUEUED', 'FUSION_POSTED', v_uid,
            'Fusion AP ' || p_invoice_id || NVL2(p_ref, ' / ' || p_ref, NULL));
    prod.dct_audit.log(
      p_action => 'FUSION_INVOICE_CREATED', p_object_type => v_obj,
      p_object_id => TO_CHAR(p_source_id), p_object_ref => v_ref, p_module_code => 'PETTY_CASH');
    -- No COMMIT: the runner commits after this callback.
  END receive_fusion_result;

END dct_pc_fusion_pkg;
/

-- ---------------------------------------------------------------------------
-- 4. ADMIN -> PROD synonym (ORDS / runner execute as ADMIN).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SYNONYM dct_pc_fusion_pkg FOR prod.dct_pc_fusion_pkg;

SET ECHO OFF
PROMPT PC 07 fusion write-back : done
