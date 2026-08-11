-- ============================================================================
-- PAY Phase 3.1b -- Change Control enhancements (user-approved rounds 1..6)
--   1  hard gate on Calculate  (CHG_GATE_MODE OFF|WARN|BLOCK -- gate itself
--      lives in 16_pay_phase3_pkg.sql calculate_run; the settings live here)
--   2  auto-capture on payroll cutoff day + reminder notifications (job)
--   3  DWP sign-off (submit_signoff + hooks; process seed = 22_pay_chg_wf.sql)
--   5  justification note + evidence per change (note column + requirement)
--   6  variance guardrail flags (GROSS_JUMP / BANK_W_RAISE / REPEAT_3M)
-- Run as ADMIN (sql -name prod_mcp). Requires 19. Rerunnable.
-- ============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT --- [1/4] columns ---

DECLARE
  PROCEDURE add_col(p_table VARCHAR2, p_col VARCHAR2, p_ddl VARCHAR2) IS l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n FROM all_tab_columns
     WHERE owner='PROD' AND table_name=UPPER(p_table) AND column_name=UPPER(p_col);
    IF l_n=0 THEN EXECUTE IMMEDIATE 'ALTER TABLE prod.'||p_table||' ADD ('||p_ddl||')'; END IF;
  END;
BEGIN
  add_col('DCT_PAY_CHG_ITEM','NOTE','note VARCHAR2(1000)');
  add_col('DCT_PAY_CHG_ITEM','FLAGS','flags VARCHAR2(200)');
  add_col('DCT_PAY_CHG_REGISTER','WF_INSTANCE_ID','wf_instance_id NUMBER');
  add_col('DCT_PAY_CHG_REGISTER','LAST_NOTIFIED_AT','last_notified_at DATE');
END;
/

PROMPT --- [2/4] module settings + status vocabulary ---

DECLARE
  v_module_id NUMBER;
  v_cat NUMBER;
  PROCEDURE put_setting (p_key VARCHAR2, p_val VARCHAR2, p_label VARCHAR2, p_desc VARCHAR2,
                         p_type VARCHAR2, p_allow VARCHAR2, p_def VARCHAR2) IS
  BEGIN
    UPDATE prod.dct_module_settings
       SET setting_label = p_label, setting_description = p_desc,
           value_type = p_type, allowed_values = p_allow, default_value = p_def
     WHERE module_id = v_module_id AND setting_key = p_key;
    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO prod.dct_module_settings
             (module_id, setting_key, setting_value, setting_label, setting_description,
              value_type, allowed_values, default_value, effective_date)
      VALUES (v_module_id, p_key, p_val, p_label, p_desc, p_type, p_allow, p_def, SYSDATE);
    END IF;
  END;
BEGIN
  SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'PAY';

  put_setting('CHG_GATE_MODE', 'WARN', 'Change Register Gate',
    'Pre-payroll gate on Calculate: OFF = no check, WARN = the run console warns when the period''s change register is not confirmed, BLOCK = calculation refuses until it is confirmed.',
    'SELECT', 'OFF,WARN,BLOCK', 'WARN');
  put_setting('CHG_SIGNOFF_MODE', 'WORKFLOW', 'Change Sign-off Mode',
    'How the register attestation is collected: INLINE = HR / Payroll sign-off buttons on the page, WORKFLOW = a DCT Workflow Platform approval (process PAY_CHG_APPROVAL, HR then Payroll tasks in the worklist).',
    'SELECT', 'INLINE,WORKFLOW', 'WORKFLOW');
  put_setting('CHG_AUTO_CAPTURE', 'Y', 'Auto-capture Changes',
    'Capture each payroll''s change register automatically on its cutoff day (daily job) and notify the HR team of the pending confirmations.',
    'BOOLEAN', NULL, 'Y');
  put_setting('CHG_REMIND_DAYS', '3', 'Change Reminder Throttle (days)',
    'Minimum days between reminder notifications for a register that is still awaiting HR or Payroll confirmation.',
    'NUMBER', NULL, '3');
  put_setting('CHG_VARIANCE_PCT', '20', 'Variance Flag Threshold (%)',
    'Flag a salary or entry change as GROSS_JUMP when the change is at least this percentage of the previous value.',
    'NUMBER', NULL, '20');
  put_setting('CHG_BANK_NOTE_REQ', 'Y', 'Bank Change Needs Note',
    'Require a justification note before HR can confirm a bank-detail change.',
    'BOOLEAN', NULL, 'Y');
  put_setting('CHG_FLAG_NOTE_REQ', 'N', 'Flagged Change Needs Note',
    'Require a justification note before HR can confirm a variance-flagged change.',
    'BOOLEAN', NULL, 'N');
  put_setting('CHG_NOTE_MIN_AED', '0', 'Note Threshold (AED)',
    'Require a justification note when the absolute financial impact of a change is at least this amount (0 = off).',
    'NUMBER', NULL, '0');
  put_setting('CHG_REPORT_AUTO', 'Y', 'Auto Change Report',
    'Generate the PAY_CHG_REGISTER briefing report automatically when a register reaches CONFIRMED.',
    'BOOLEAN', NULL, 'Y');

  SELECT category_id INTO v_cat FROM prod.dct_lookup_categories
  WHERE category_code = 'PAY_CHG_REG_STATUS';
  UPDATE prod.dct_lookup_values
     SET value_name_en = 'In Approval', display_order = 35
   WHERE category_id = v_cat AND value_code = 'IN_APPROVAL';
  IF SQL%ROWCOUNT = 0 THEN
    INSERT INTO prod.dct_lookup_values
           (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
    VALUES (v_cat, 'IN_APPROVAL', 'In Approval',
            UNISTR('\0642\064A\062F \0627\0644\0627\0639\062A\0645\0627\062F'), 35, 'N', 'Y');
  END IF;

  COMMIT;
  DBMS_OUTPUT.put_line('change-control settings + IN_APPROVAL status seeded');
END;
/

PROMPT --- [3/4] package DCT_PAY_CHG_PKG v2 ---

CREATE OR REPLACE PACKAGE prod.dct_pay_chg_pkg AS
  -- Employee Change Control Register engine (v2).
  -- v2 adds: variance guardrail flags, justification notes with a
  -- confirmation requirement, DWP sign-off (PAY_CHG_APPROVAL), the daily
  -- auto-capture / reminder sweep and the auto briefing report.
  FUNCTION can_hr   (p_user VARCHAR2) RETURN BOOLEAN;
  FUNCTION can_pay  (p_user VARCHAR2) RETURN BOOLEAN;
  FUNCTION can_view (p_user VARCHAR2) RETURN BOOLEAN;
  FUNCTION get_setting (p_key VARCHAR2, p_default VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

  PROCEDURE capture (p_payroll_id  NUMBER,
                     p_period_id   NUMBER,
                     p_user        VARCHAR2,
                     o_register_id OUT NUMBER);

  -- p_side HR|PAY, p_action CONFIRM|UNCONFIRM, p_items 'ALL' or 'id|id|id'
  PROCEDURE confirm_items (p_register_id NUMBER,
                           p_side        VARCHAR2,
                           p_action      VARCHAR2,
                           p_items       VARCHAR2,
                           p_user        VARCHAR2,
                           o_count       OUT NUMBER);

  -- register-level attestation, INLINE mode only
  PROCEDURE sign_off (p_register_id NUMBER,
                      p_side        VARCHAR2,
                      p_action      VARCHAR2,
                      p_user        VARCHAR2);

  PROCEDURE set_note (p_register_id NUMBER,
                      p_item_id     NUMBER,
                      p_note        VARCHAR2,
                      p_user        VARCHAR2);

  -- WORKFLOW mode: start the PAY_CHG_APPROVAL chain (HR task, then Payroll)
  PROCEDURE submit_signoff (p_register_id NUMBER,
                            p_user        VARCHAR2,
                            o_instance_id OUT NUMBER);

  -- DWP hooks (action registry, CTX signature)
  PROCEDURE wf_on_complete (p_instance_id NUMBER, p_source_module VARCHAR2,
                            p_source_record_id NUMBER, p_user_id NUMBER);
  PROCEDURE wf_on_reject   (p_instance_id NUMBER, p_source_module VARCHAR2,
                            p_source_record_id NUMBER, p_user_id NUMBER);

  -- daily job body: cutoff-day auto-capture + pending-confirmation reminders
  PROCEDURE auto_sweep;
END dct_pay_chg_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_pay_chg_pkg AS

  c_module CONSTANT VARCHAR2(10) := 'PAY';

  FUNCTION can_hr (p_user VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN prod.dct_auth.has_role(p_user, 'PAY_HR_ENTRY')
        OR prod.dct_auth.has_role(p_user, 'PAY_ADMIN')
        OR prod.dct_auth.has_role(p_user, 'SYS_ADMIN');
  END;

  FUNCTION can_pay (p_user VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN prod.dct_auth.has_role(p_user, 'PAY_PAYROLL_ENTRY')
        OR prod.dct_auth.has_role(p_user, 'PAY_ADMIN')
        OR prod.dct_auth.has_role(p_user, 'SYS_ADMIN');
  END;

  FUNCTION can_view (p_user VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN can_hr(p_user) OR can_pay(p_user)
        OR prod.dct_auth.has_role(p_user, 'PAY_USER');
  END;

  FUNCTION is_admin (p_user VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN prod.dct_auth.has_role(p_user, 'PAY_ADMIN')
        OR prod.dct_auth.has_role(p_user, 'SYS_ADMIN');
  END;

  FUNCTION get_setting (p_key VARCHAR2, p_default VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
    l_val VARCHAR2(4000);
  BEGIN
    SELECT ms.setting_value INTO l_val
    FROM prod.dct_module_settings ms
    JOIN prod.dct_modules m ON m.module_id = ms.module_id
    WHERE m.module_code = c_module AND ms.setting_key = p_key;
    RETURN NVL(l_val, p_default);
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN p_default;
  END;

  FUNCTION uid_of (p_user VARCHAR2) RETURN NUMBER IS
    l_id NUMBER;
  BEGIN
    SELECT user_id INTO l_id FROM prod.dct_users
    WHERE UPPER(username) = UPPER(p_user);
    RETURN l_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
  END;

  FUNCTION uname_of (p_uid NUMBER) RETURN VARCHAR2 IS
    l_n VARCHAR2(100);
  BEGIN
    SELECT username INTO l_n FROM prod.dct_users WHERE user_id = p_uid;
    RETURN l_n;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 'WORKFLOW';
  END;

  FUNCTION num_setting (p_key VARCHAR2, p_def NUMBER) RETURN NUMBER IS
    l_v NUMBER;
  BEGIN
    SELECT TO_NUMBER(prod.dct_pay_chg_pkg.get_setting(p_key) DEFAULT NULL ON CONVERSION ERROR)
      INTO l_v FROM dual;
    RETURN NVL(l_v, p_def);
  EXCEPTION WHEN OTHERS THEN RETURN p_def;
  END;

  PROCEDURE notify_role (p_role VARCHAR2, p_type VARCHAR2,
                         p_title_en VARCHAR2, p_body_en VARCHAR2,
                         p_title_ar VARCHAR2, p_body_ar VARCHAR2) IS
  BEGIN
    FOR u IN (SELECT DISTINCT ur.user_id
              FROM prod.dct_user_roles ur
              JOIN prod.dct_roles r ON r.role_id = ur.role_id
              WHERE r.role_code = p_role
                AND (ur.end_date IS NULL OR ur.end_date >= SYSDATE)) LOOP
      prod.dct_notify.send(
        p_recipient_user_id => u.user_id,
        p_notification_type => p_type,
        p_title_en          => p_title_en,
        p_body_en           => p_body_en,
        p_title_ar          => p_title_ar,
        p_body_ar           => p_body_ar,
        p_module_code       => c_module,
        p_link_url          => '#payChanges');
    END LOOP;
  END;

  PROCEDURE enqueue_report (p_register_id NUMBER, p_user VARCHAR2) IS
    l_run NUMBER;
  BEGIN
    IF NVL(get_setting('CHG_REPORT_AUTO', 'Y'), 'Y') <> 'Y' THEN RETURN; END IF;
    l_run := prod.dct_rpt_pkg.enqueue(
               p_report_code  => 'PAY_CHG_REGISTER',
               p_params       => '{"registerid":"' || p_register_id || '"}',
               p_trigger      => 'ONDEMAND',
               p_requested_by => p_user,
               p_formats      => 'PDF,XLSX');
  EXCEPTION WHEN OTHERS THEN NULL;  -- reporting must never break a sign-off
  END;

  -- keep register status + sign-offs consistent with the item states;
  -- a sign-off silently drops the moment a pending item (re)appears.
  -- IN_APPROVAL is owned by the workflow hooks and is left alone here.
  PROCEDURE recompute_status (p_register_id NUMBER) IS
    l_prior    NUMBER;
    l_status   VARCHAR2(20);
    l_pend_hr  NUMBER;
    l_pend_pay NUMBER;
  BEGIN
    SELECT prior_register_id, status INTO l_prior, l_status
    FROM prod.dct_pay_chg_register WHERE register_id = p_register_id;

    IF l_status = 'IN_APPROVAL' THEN RETURN; END IF;

    IF l_prior IS NULL THEN
      UPDATE prod.dct_pay_chg_register
         SET status = 'BASELINE',
             hr_done_by = NULL, hr_done_at = NULL,
             pay_done_by = NULL, pay_done_at = NULL
       WHERE register_id = p_register_id;
      RETURN;
    END IF;

    SELECT COUNT(CASE WHEN hr_status  = 'N' THEN 1 END),
           COUNT(CASE WHEN pay_status = 'N' THEN 1 END)
      INTO l_pend_hr, l_pend_pay
    FROM prod.dct_pay_chg_item WHERE register_id = p_register_id;

    IF l_pend_hr > 0 THEN
      UPDATE prod.dct_pay_chg_register
         SET hr_done_by = NULL, hr_done_at = NULL,
             pay_done_by = NULL, pay_done_at = NULL, status = 'OPEN'
       WHERE register_id = p_register_id;
    ELSIF l_pend_pay > 0 THEN
      UPDATE prod.dct_pay_chg_register
         SET pay_done_by = NULL, pay_done_at = NULL,
             status = CASE WHEN hr_done_at IS NOT NULL THEN 'HR_CONFIRMED' ELSE 'OPEN' END
       WHERE register_id = p_register_id;
    ELSE
      UPDATE prod.dct_pay_chg_register
         SET status = CASE WHEN pay_done_at IS NOT NULL THEN 'CONFIRMED'
                           WHEN hr_done_at  IS NOT NULL THEN 'HR_CONFIRMED'
                           ELSE 'OPEN' END
       WHERE register_id = p_register_id;
    END IF;
  END;

  -- variance guardrails (enhancement 6): stamped fresh on every capture
  PROCEDURE compute_flags (p_register_id NUMBER, p_prior NUMBER) IS
    l_pct    NUMBER := num_setting('CHG_VARIANCE_PCT', 20);
    l_prior2 NUMBER;
  BEGIN
    UPDATE prod.dct_pay_chg_item SET flags = NULL WHERE register_id = p_register_id;

    -- GROSS_JUMP: the change is >= pct of the previous numeric value
    UPDATE prod.dct_pay_chg_item
       SET flags = 'GROSS_JUMP'
     WHERE register_id = p_register_id
       AND change_kind = 'CHANGE'
       AND attr_group IN ('SALARY', 'ENTRY')
       AND delta IS NOT NULL
       AND NVL(TO_NUMBER(old_value DEFAULT NULL ON CONVERSION ERROR), 0) > 0
       AND ABS(delta) >= l_pct / 100 * TO_NUMBER(old_value DEFAULT NULL ON CONVERSION ERROR);

    -- BANK_W_RAISE: bank details changed in the same month as a pay increase
    UPDATE prod.dct_pay_chg_item i
       SET i.flags = CASE WHEN i.flags IS NULL THEN 'BANK_W_RAISE'
                          ELSE i.flags || ',BANK_W_RAISE' END
     WHERE i.register_id = p_register_id
       AND i.attr_group = 'BANK'
       AND i.change_kind = 'CHANGE'
       AND EXISTS (SELECT 1 FROM prod.dct_pay_chg_item s
                   WHERE s.register_id = i.register_id
                     AND s.person_id = i.person_id
                     AND s.attr_group IN ('SALARY', 'ENTRY')
                     AND NVL(s.delta, 0) > 0);

    -- REPEAT_3M: the person also had changes in the two previous registers
    IF p_prior IS NOT NULL THEN
      SELECT prior_register_id INTO l_prior2
      FROM prod.dct_pay_chg_register WHERE register_id = p_prior;
      IF l_prior2 IS NOT NULL THEN
        UPDATE prod.dct_pay_chg_item i
           SET i.flags = CASE WHEN i.flags IS NULL THEN 'REPEAT_3M'
                              ELSE i.flags || ',REPEAT_3M' END
         WHERE i.register_id = p_register_id
           AND i.change_kind = 'CHANGE'
           AND EXISTS (SELECT 1 FROM prod.dct_pay_chg_item a
                       WHERE a.register_id = p_prior
                         AND a.person_id = i.person_id AND a.change_kind = 'CHANGE')
           AND EXISTS (SELECT 1 FROM prod.dct_pay_chg_item b
                       WHERE b.register_id = l_prior2
                         AND b.person_id = i.person_id AND b.change_kind = 'CHANGE');
      END IF;
    END IF;
  END;

  PROCEDURE capture (p_payroll_id  NUMBER,
                     p_period_id   NUMBER,
                     p_user        VARCHAR2,
                     o_register_id OUT NUMBER) IS
    l_pay    prod.dct_pay_payroll%ROWTYPE;
    l_per    prod.dct_pay_period%ROWTYPE;
    l_reg_id NUMBER;
    l_status VARCHAR2(20);
    l_prior  NUMBER;
    l_emp    NUMBER := 0;
    l_chg    NUMBER;

    TYPE t_keep IS RECORD (
      person_id  NUMBER,        attr_code VARCHAR2(60),
      old_value  VARCHAR2(400), new_value VARCHAR2(400),
      note       VARCHAR2(1000),
      hr_status  CHAR(1), hr_by  VARCHAR2(100), hr_at  DATE,
      pay_status CHAR(1), pay_by VARCHAR2(100), pay_at DATE);
    TYPE t_keep_tab IS TABLE OF t_keep;
    l_keep t_keep_tab;

    PROCEDURE put (p_person NUMBER, p_empno VARCHAR2, p_name VARCHAR2,
                   p_group VARCHAR2, p_attr VARCHAR2,
                   p_value VARCHAR2, p_num NUMBER DEFAULT NULL) IS
    BEGIN
      INSERT INTO prod.dct_pay_chg_snap
             (register_id, person_id, employee_number, full_name,
              attr_group, attr_code, attr_value, attr_num)
      VALUES (l_reg_id, p_person, p_empno, p_name,
              p_group, p_attr, SUBSTR(p_value, 1, 400), p_num);
    END;
  BEGIN
    IF NOT (can_hr(p_user) OR can_pay(p_user)) THEN
      RAISE_APPLICATION_ERROR(-20403, 'Not allowed to capture the change register');
    END IF;

    BEGIN
      SELECT * INTO l_pay FROM prod.dct_pay_payroll WHERE payroll_id = p_payroll_id;
      SELECT * INTO l_per FROM prod.dct_pay_period
       WHERE period_id = p_period_id AND payroll_id = p_payroll_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Payroll or period not found');
    END;

    BEGIN
      SELECT register_id, status INTO l_reg_id, l_status
      FROM prod.dct_pay_chg_register
      WHERE payroll_id = p_payroll_id AND period_id = p_period_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      INSERT INTO prod.dct_pay_chg_register
             (payroll_id, period_id, status, created_by, updated_by)
      VALUES (p_payroll_id, p_period_id, 'OPEN', p_user, p_user)
      RETURNING register_id INTO l_reg_id;
      l_status := 'OPEN';
    END;

    IF l_status = 'IN_APPROVAL' THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Register is in the approval workflow - act on the tasks (approve, return or reject) before recapturing');
    END IF;
    IF l_status = 'CONFIRMED' AND NOT is_admin(p_user) THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Register is already confirmed - only a Pay Admin can recapture it');
    END IF;

    SELECT MAX(r.register_id) KEEP (DENSE_RANK LAST ORDER BY pe.date_from)
      INTO l_prior
    FROM prod.dct_pay_chg_register r
    JOIN prod.dct_pay_period pe ON pe.period_id = r.period_id
    WHERE r.payroll_id = p_payroll_id
      AND pe.date_from < l_per.date_from;

    -- stash confirmations + notes so an unchanged finding survives recapture
    SELECT person_id, attr_code, old_value, new_value, note,
           hr_status, hr_by, hr_at, pay_status, pay_by, pay_at
    BULK COLLECT INTO l_keep
    FROM prod.dct_pay_chg_item
    WHERE register_id = l_reg_id
      AND (hr_status = 'Y' OR pay_status = 'Y' OR note IS NOT NULL);

    DELETE FROM prod.dct_pay_chg_snap WHERE register_id = l_reg_id;

    -- profile + assignment + contractual salary attributes; one row per
    -- person = the latest in-scope assignment (same scope as load_run)
    FOR a IN (
      SELECT * FROM (
        SELECT a.person_id, a.job_title, a.grade_code, a.department_name,
               a.sector_name, a.cost_center_code, a.bu_code, a.company_ref,
               a.effective_from, a.effective_to,
               a.basic_salary, a.allowance_amount, a.gross_salary,
               e.employee_number, e.full_name_en, e.email,
               ROW_NUMBER() OVER (PARTITION BY a.person_id
                                  ORDER BY a.effective_from DESC, a.assignment_id DESC) rn
        FROM prod.dct_pay_assignment a
        JOIN prod.dct_employees e ON e.person_id = a.person_id
        WHERE a.payroll_code = l_pay.payroll_code
          AND a.assignment_type = 'PRIMARY'
          AND a.status = 'ACTIVE'
          AND a.effective_from <= l_per.date_to
          AND NVL(a.effective_to, l_per.date_to) >= l_per.date_from
      ) WHERE rn = 1
    ) LOOP
      l_emp := l_emp + 1;
      put(a.person_id, a.employee_number, a.full_name_en, 'PROFILE',    'NAME',         a.full_name_en);
      put(a.person_id, a.employee_number, a.full_name_en, 'PROFILE',    'EMAIL',        a.email);
      put(a.person_id, a.employee_number, a.full_name_en, 'ASSIGNMENT', 'JOB_TITLE',    a.job_title);
      put(a.person_id, a.employee_number, a.full_name_en, 'ASSIGNMENT', 'GRADE',        a.grade_code);
      put(a.person_id, a.employee_number, a.full_name_en, 'ASSIGNMENT', 'DEPARTMENT',   a.department_name);
      put(a.person_id, a.employee_number, a.full_name_en, 'ASSIGNMENT', 'SECTOR',       a.sector_name);
      put(a.person_id, a.employee_number, a.full_name_en, 'ASSIGNMENT', 'COST_CENTER',  a.cost_center_code);
      put(a.person_id, a.employee_number, a.full_name_en, 'ASSIGNMENT', 'BUSINESS_UNIT',a.bu_code);
      put(a.person_id, a.employee_number, a.full_name_en, 'ASSIGNMENT', 'COMPANY_REF',  a.company_ref);
      put(a.person_id, a.employee_number, a.full_name_en, 'ASSIGNMENT', 'ASG_START',    TO_CHAR(a.effective_from,'YYYY-MM-DD'));
      put(a.person_id, a.employee_number, a.full_name_en, 'ASSIGNMENT', 'ASG_END',      TO_CHAR(a.effective_to,'YYYY-MM-DD'));
      put(a.person_id, a.employee_number, a.full_name_en, 'SALARY',     'BASIC',        TO_CHAR(a.basic_salary),     a.basic_salary);
      put(a.person_id, a.employee_number, a.full_name_en, 'SALARY',     'ALLOWANCE',    TO_CHAR(a.allowance_amount), a.allowance_amount);
      put(a.person_id, a.employee_number, a.full_name_en, 'SALARY',     'GROSS',        TO_CHAR(a.gross_salary),     a.gross_salary);
    END LOOP;

    -- element entries in force for the period: recurring = the value at
    -- period end (latest split wins), one-time = the sum inside the period
    INSERT INTO prod.dct_pay_chg_snap
           (register_id, person_id, employee_number, full_name,
            attr_group, attr_code, attr_value, attr_num)
    SELECT l_reg_id, x.person_id, x.employee_number, x.full_name,
           'ENTRY', x.attr_code, TO_CHAR(x.val), x.val
    FROM (
      SELECT s.person_id, s.employee_number, s.full_name,
             'ENTRY_' || y.element_code AS attr_code,
             SUM(CASE WHEN y.entry_type = 'RECURRING' AND y.rn = 1 THEN y.v
                      WHEN y.entry_type <> 'RECURRING'             THEN y.v END) val
      FROM (SELECT DISTINCT person_id, employee_number, full_name
            FROM prod.dct_pay_chg_snap WHERE register_id = l_reg_id) s
      JOIN (
        SELECT en.person_id, el.element_code, en.entry_type,
               NVL(en.amount, NVL(en.qty,0) * NVL(en.rate,0)) v,
               ROW_NUMBER() OVER (PARTITION BY en.person_id, en.element_id, en.entry_type
                                  ORDER BY en.effective_from DESC, en.entry_id DESC) rn
        FROM prod.dct_pay_element_entry en
        JOIN prod.dct_pay_element el ON el.element_id = en.element_id AND el.is_active = 'Y'
        WHERE en.is_active = 'Y'
          AND ((en.entry_type = 'RECURRING'
                AND en.effective_from <= l_per.date_to
                AND NVL(en.effective_to, l_per.date_to) >= l_per.date_from)
            OR (en.entry_type <> 'RECURRING'
                AND en.effective_from BETWEEN l_per.date_from AND l_per.date_to))
      ) y ON y.person_id = s.person_id
      GROUP BY s.person_id, s.employee_number, s.full_name, y.element_code
      HAVING SUM(CASE WHEN y.entry_type = 'RECURRING' AND y.rn = 1 THEN y.v
                      WHEN y.entry_type <> 'RECURRING'             THEN y.v END) IS NOT NULL
    ) x;

    -- reference bank details (best active row: primary first, then latest)
    INSERT INTO prod.dct_pay_chg_snap
           (register_id, person_id, employee_number, full_name,
            attr_group, attr_code, attr_value, attr_num)
    SELECT l_reg_id, s.person_id, s.employee_number, s.full_name,
           'BANK', k.attr_code,
           SUBSTR(CASE k.attr_code WHEN 'BANK_NAME' THEN b.bank_name
                                   ELSE NVL(b.iban, b.account_number) END, 1, 400),
           NULL
    FROM (SELECT DISTINCT person_id, employee_number, full_name
          FROM prod.dct_pay_chg_snap WHERE register_id = l_reg_id) s
    JOIN (SELECT bb.*,
                 ROW_NUMBER() OVER (PARTITION BY bb.person_id
                                    ORDER BY bb.is_primary DESC, bb.effective_from DESC, bb.emp_bank_id DESC) rn
          FROM prod.dct_pay_emp_bank bb WHERE bb.is_active = 'Y') b
      ON b.person_id = s.person_id AND b.rn = 1
    CROSS JOIN (SELECT 'BANK_NAME' attr_code FROM dual UNION ALL SELECT 'BANK_IBAN' FROM dual) k
    WHERE CASE k.attr_code WHEN 'BANK_NAME' THEN b.bank_name
                           ELSE NVL(b.iban, b.account_number) END IS NOT NULL;

    DELETE FROM prod.dct_pay_chg_item WHERE register_id = l_reg_id;

    IF l_prior IS NULL THEN
      UPDATE prod.dct_pay_chg_register
         SET prior_register_id = NULL, status = 'BASELINE',
             captured_at = SYSDATE, captured_by = p_user,
             emp_count = l_emp, change_count = 0,
             hr_done_by = NULL, hr_done_at = NULL,
             pay_done_by = NULL, pay_done_at = NULL,
             updated_by = p_user, updated_at = SYSDATE
       WHERE register_id = l_reg_id;
      o_register_id := l_reg_id;
      RETURN;
    END IF;

    -- attribute-level differences for people present in both registers
    INSERT INTO prod.dct_pay_chg_item
           (register_id, person_id, employee_number, full_name, change_kind,
            attr_group, attr_code, old_value, new_value, delta)
    SELECT l_reg_id,
           NVL(c.person_id, p.person_id),
           NVL(c.employee_number, p.employee_number),
           NVL(c.full_name, p.full_name),
           'CHANGE',
           NVL(c.attr_group, p.attr_group),
           NVL(c.attr_code, p.attr_code),
           p.attr_value, c.attr_value,
           CASE WHEN c.attr_num IS NOT NULL OR p.attr_num IS NOT NULL
                THEN NVL(c.attr_num, 0) - NVL(p.attr_num, 0) END
    FROM (SELECT * FROM prod.dct_pay_chg_snap
          WHERE register_id = l_reg_id
            AND person_id IN (SELECT person_id FROM prod.dct_pay_chg_snap
                              WHERE register_id = l_prior)) c
    FULL OUTER JOIN
         (SELECT * FROM prod.dct_pay_chg_snap
          WHERE register_id = l_prior
            AND person_id IN (SELECT person_id FROM prod.dct_pay_chg_snap
                              WHERE register_id = l_reg_id)) p
      ON p.person_id = c.person_id AND p.attr_code = c.attr_code
    WHERE DECODE(c.attr_value, p.attr_value, 1, 0) = 0;

    -- one item per joiner (gross carried as the financial impact)
    INSERT INTO prod.dct_pay_chg_item
           (register_id, person_id, employee_number, full_name, change_kind,
            attr_group, attr_code, old_value, new_value, delta)
    SELECT l_reg_id, s.person_id, s.employee_number, s.full_name,
           'NEW_HIRE', 'EMPLOYEE', 'EMPLOYEE', NULL, g.attr_value, g.attr_num
    FROM (SELECT DISTINCT person_id, employee_number, full_name
          FROM prod.dct_pay_chg_snap WHERE register_id = l_reg_id) s
    LEFT JOIN prod.dct_pay_chg_snap g
      ON g.register_id = l_reg_id AND g.person_id = s.person_id AND g.attr_code = 'GROSS'
    WHERE s.person_id NOT IN (SELECT person_id FROM prod.dct_pay_chg_snap
                              WHERE register_id = l_prior);

    -- one item per leaver (negative gross impact)
    INSERT INTO prod.dct_pay_chg_item
           (register_id, person_id, employee_number, full_name, change_kind,
            attr_group, attr_code, old_value, new_value, delta)
    SELECT l_reg_id, s.person_id, s.employee_number, s.full_name,
           'EXIT', 'EMPLOYEE', 'EMPLOYEE', g.attr_value, NULL, 0 - NVL(g.attr_num, 0)
    FROM (SELECT DISTINCT person_id, employee_number, full_name
          FROM prod.dct_pay_chg_snap WHERE register_id = l_prior) s
    LEFT JOIN prod.dct_pay_chg_snap g
      ON g.register_id = l_prior AND g.person_id = s.person_id AND g.attr_code = 'GROSS'
    WHERE s.person_id NOT IN (SELECT person_id FROM prod.dct_pay_chg_snap
                              WHERE register_id = l_reg_id);

    -- restore confirmations + notes for findings that came back identical
    IF l_keep IS NOT NULL THEN
      FOR i IN 1 .. l_keep.COUNT LOOP
        UPDATE prod.dct_pay_chg_item
           SET hr_status = l_keep(i).hr_status, hr_by = l_keep(i).hr_by, hr_at = l_keep(i).hr_at,
               pay_status = l_keep(i).pay_status, pay_by = l_keep(i).pay_by, pay_at = l_keep(i).pay_at,
               note = l_keep(i).note
         WHERE register_id = l_reg_id
           AND person_id = l_keep(i).person_id
           AND attr_code = l_keep(i).attr_code
           AND DECODE(old_value, l_keep(i).old_value, 1, 0) = 1
           AND DECODE(new_value, l_keep(i).new_value, 1, 0) = 1;
      END LOOP;
    END IF;

    compute_flags(l_reg_id, l_prior);

    SELECT COUNT(*) INTO l_chg FROM prod.dct_pay_chg_item WHERE register_id = l_reg_id;

    UPDATE prod.dct_pay_chg_register
       SET prior_register_id = l_prior,
           captured_at = SYSDATE, captured_by = p_user,
           emp_count = l_emp, change_count = l_chg,
           updated_by = p_user, updated_at = SYSDATE
     WHERE register_id = l_reg_id;

    recompute_status(l_reg_id);
    o_register_id := l_reg_id;
  END capture;

  PROCEDURE confirm_items (p_register_id NUMBER,
                           p_side        VARCHAR2,
                           p_action      VARCHAR2,
                           p_items       VARCHAR2,
                           p_user        VARCHAR2,
                           o_count       OUT NUMBER) IS
    l_status VARCHAR2(20);
    l_ids    apex_t_number := apex_t_number();
    l_all    BOOLEAN := UPPER(NVL(p_items,'ALL')) = 'ALL';
    l_yes    BOOLEAN := UPPER(p_action) = 'CONFIRM';
    l_need   NUMBER;
    l_bank_req BOOLEAN := NVL(get_setting('CHG_BANK_NOTE_REQ','Y'),'Y') = 'Y';
    l_flag_req BOOLEAN := NVL(get_setting('CHG_FLAG_NOTE_REQ','N'),'N') = 'Y';
    l_min      NUMBER  := num_setting('CHG_NOTE_MIN_AED', 0);
  BEGIN
    IF p_side = 'HR' AND NOT can_hr(p_user) THEN
      RAISE_APPLICATION_ERROR(-20403, 'HR confirmation requires the PAY HR ENTRY role');
    ELSIF p_side = 'PAY' AND NOT can_pay(p_user) THEN
      RAISE_APPLICATION_ERROR(-20403, 'Payroll confirmation requires the PAY PAYROLL ENTRY role');
    ELSIF p_side NOT IN ('HR','PAY') THEN
      RAISE_APPLICATION_ERROR(-20001, 'side must be HR or PAY');
    END IF;
    IF UPPER(p_action) NOT IN ('CONFIRM','UNCONFIRM') THEN
      RAISE_APPLICATION_ERROR(-20001, 'action must be CONFIRM or UNCONFIRM');
    END IF;

    BEGIN
      SELECT status INTO l_status FROM prod.dct_pay_chg_register
      WHERE register_id = p_register_id FOR UPDATE;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Register not found');
    END;
    IF l_status = 'IN_APPROVAL' THEN
      RAISE_APPLICATION_ERROR(-20001, 'Register is in the approval workflow and locked');
    END IF;
    IF l_status = 'CONFIRMED' AND NOT is_admin(p_user) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Register is confirmed and locked');
    END IF;

    IF NOT l_all THEN
      FOR t IN (SELECT column_value cv FROM TABLE(apex_string.split(p_items, '|'))) LOOP
        IF TRIM(t.cv) IS NOT NULL THEN
          l_ids.EXTEND; l_ids(l_ids.COUNT) := TO_NUMBER(TRIM(t.cv));
        END IF;
      END LOOP;
    END IF;

    IF p_side = 'HR' THEN
      IF l_yes THEN
        -- enhancement 5: some changes need a justification note first
        SELECT COUNT(*) INTO l_need FROM prod.dct_pay_chg_item
        WHERE register_id = p_register_id AND hr_status = 'N' AND note IS NULL
          AND (l_all OR item_id IN (SELECT column_value FROM TABLE(l_ids)))
          AND ((l_bank_req AND attr_group = 'BANK' AND change_kind = 'CHANGE')
            OR (l_flag_req AND flags IS NOT NULL)
            OR (l_min > 0 AND ABS(NVL(delta, 0)) >= l_min));
        IF l_need > 0 THEN
          RAISE_APPLICATION_ERROR(-20001,
            l_need || ' change(s) need a justification note before HR confirmation');
        END IF;
        UPDATE prod.dct_pay_chg_item
           SET hr_status = 'Y', hr_by = p_user, hr_at = SYSDATE
         WHERE register_id = p_register_id AND hr_status = 'N'
           AND (l_all OR item_id IN (SELECT column_value FROM TABLE(l_ids)));
      ELSE
        -- the payroll confirmation freezes the HR one
        UPDATE prod.dct_pay_chg_item
           SET hr_status = 'N', hr_by = NULL, hr_at = NULL
         WHERE register_id = p_register_id AND hr_status = 'Y' AND pay_status = 'N'
           AND (l_all OR item_id IN (SELECT column_value FROM TABLE(l_ids)));
      END IF;
    ELSE
      IF l_yes THEN
        -- payroll can only confirm what HR already confirmed
        UPDATE prod.dct_pay_chg_item
           SET pay_status = 'Y', pay_by = p_user, pay_at = SYSDATE
         WHERE register_id = p_register_id AND pay_status = 'N' AND hr_status = 'Y'
           AND (l_all OR item_id IN (SELECT column_value FROM TABLE(l_ids)));
      ELSE
        UPDATE prod.dct_pay_chg_item
           SET pay_status = 'N', pay_by = NULL, pay_at = NULL
         WHERE register_id = p_register_id AND pay_status = 'Y'
           AND (l_all OR item_id IN (SELECT column_value FROM TABLE(l_ids)));
      END IF;
    END IF;
    o_count := SQL%ROWCOUNT;

    recompute_status(p_register_id);
    UPDATE prod.dct_pay_chg_register
       SET updated_by = p_user, updated_at = SYSDATE
     WHERE register_id = p_register_id;
  END confirm_items;

  PROCEDURE set_note (p_register_id NUMBER,
                      p_item_id     NUMBER,
                      p_note        VARCHAR2,
                      p_user        VARCHAR2) IS
    l_status VARCHAR2(20);
  BEGIN
    IF NOT (can_hr(p_user) OR can_pay(p_user)) THEN
      RAISE_APPLICATION_ERROR(-20403, 'Not allowed');
    END IF;
    BEGIN
      SELECT status INTO l_status FROM prod.dct_pay_chg_register
      WHERE register_id = p_register_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Register not found');
    END;
    IF l_status IN ('CONFIRMED','IN_APPROVAL') AND NOT is_admin(p_user) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Register is locked');
    END IF;
    UPDATE prod.dct_pay_chg_item
       SET note = SUBSTR(p_note, 1, 1000)
     WHERE register_id = p_register_id AND item_id = p_item_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20404, 'Change item not found');
    END IF;
  END;

  PROCEDURE sign_off (p_register_id NUMBER,
                      p_side        VARCHAR2,
                      p_action      VARCHAR2,
                      p_user        VARCHAR2) IS
    l_reg  prod.dct_pay_chg_register%ROWTYPE;
    l_pend NUMBER;
  BEGIN
    IF NVL(get_setting('CHG_SIGNOFF_MODE','INLINE'),'INLINE') = 'WORKFLOW' THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Sign-off runs through the approval workflow - submit the register instead');
    END IF;
    IF p_side = 'HR' AND NOT can_hr(p_user) THEN
      RAISE_APPLICATION_ERROR(-20403, 'HR sign-off requires the PAY HR ENTRY role');
    ELSIF p_side = 'PAY' AND NOT can_pay(p_user) THEN
      RAISE_APPLICATION_ERROR(-20403, 'Payroll sign-off requires the PAY PAYROLL ENTRY role');
    ELSIF p_side NOT IN ('HR','PAY') THEN
      RAISE_APPLICATION_ERROR(-20001, 'side must be HR or PAY');
    END IF;
    IF UPPER(p_action) NOT IN ('SIGN','UNSIGN') THEN
      RAISE_APPLICATION_ERROR(-20001, 'action must be SIGN or UNSIGN');
    END IF;

    BEGIN
      SELECT * INTO l_reg FROM prod.dct_pay_chg_register
      WHERE register_id = p_register_id FOR UPDATE;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Register not found');
    END;
    IF l_reg.prior_register_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'A baseline register has nothing to sign off');
    END IF;
    IF l_reg.status = 'IN_APPROVAL' THEN
      RAISE_APPLICATION_ERROR(-20001, 'Register is in the approval workflow');
    END IF;

    IF UPPER(p_action) = 'SIGN' THEN
      IF p_side = 'HR' THEN
        SELECT COUNT(*) INTO l_pend FROM prod.dct_pay_chg_item
        WHERE register_id = p_register_id AND hr_status = 'N';
        IF l_pend > 0 THEN
          RAISE_APPLICATION_ERROR(-20001,
            l_pend || ' change(s) still pending HR confirmation');
        END IF;
        UPDATE prod.dct_pay_chg_register
           SET hr_done_by = p_user, hr_done_at = SYSDATE,
               updated_by = p_user, updated_at = SYSDATE
         WHERE register_id = p_register_id;
      ELSE
        IF l_reg.hr_done_at IS NULL THEN
          RAISE_APPLICATION_ERROR(-20001, 'HR must sign off first');
        END IF;
        SELECT COUNT(*) INTO l_pend FROM prod.dct_pay_chg_item
        WHERE register_id = p_register_id AND pay_status = 'N';
        IF l_pend > 0 THEN
          RAISE_APPLICATION_ERROR(-20001,
            l_pend || ' change(s) still pending Payroll confirmation');
        END IF;
        UPDATE prod.dct_pay_chg_register
           SET pay_done_by = p_user, pay_done_at = SYSDATE,
               updated_by = p_user, updated_at = SYSDATE
         WHERE register_id = p_register_id;
      END IF;
    ELSE
      IF p_side = 'HR' THEN
        IF l_reg.pay_done_at IS NOT NULL AND NOT is_admin(p_user) THEN
          RAISE_APPLICATION_ERROR(-20001,
            'Payroll already signed off - a Pay Admin must unsign first');
        END IF;
        -- reaching here: payroll not signed, or the caller is an admin
        UPDATE prod.dct_pay_chg_register
           SET hr_done_by = NULL, hr_done_at = NULL,
               pay_done_by = NULL, pay_done_at = NULL,
               updated_by = p_user, updated_at = SYSDATE
         WHERE register_id = p_register_id;
      ELSE
        UPDATE prod.dct_pay_chg_register
           SET pay_done_by = NULL, pay_done_at = NULL,
               updated_by = p_user, updated_at = SYSDATE
         WHERE register_id = p_register_id;
      END IF;
    END IF;

    recompute_status(p_register_id);
    IF UPPER(p_action) = 'SIGN' AND p_side = 'PAY' THEN
      enqueue_report(p_register_id, p_user);
    END IF;
  END sign_off;

  PROCEDURE submit_signoff (p_register_id NUMBER,
                            p_user        VARCHAR2,
                            o_instance_id OUT NUMBER) IS
    l_reg   prod.dct_pay_chg_register%ROWTYPE;
    l_pend  NUMBER;
    l_ref   VARCHAR2(200);
    l_uid   NUMBER := uid_of(p_user);
  BEGIN
    IF NVL(get_setting('CHG_SIGNOFF_MODE','INLINE'),'INLINE') <> 'WORKFLOW' THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Workflow sign-off is not enabled - use the inline sign-off buttons');
    END IF;
    IF NOT (can_hr(p_user) OR can_pay(p_user)) THEN
      RAISE_APPLICATION_ERROR(-20403, 'Not allowed to submit the register');
    END IF;
    BEGIN
      SELECT * INTO l_reg FROM prod.dct_pay_chg_register
      WHERE register_id = p_register_id FOR UPDATE;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Register not found');
    END;
    IF l_reg.prior_register_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'A baseline register has nothing to sign off');
    END IF;
    IF l_reg.status = 'IN_APPROVAL' THEN
      RAISE_APPLICATION_ERROR(-20001, 'Register is already in approval');
    END IF;
    IF l_reg.status = 'CONFIRMED' THEN
      RAISE_APPLICATION_ERROR(-20001, 'Register is already confirmed');
    END IF;
    SELECT COUNT(CASE WHEN hr_status = 'N' THEN 1 END)
         + COUNT(CASE WHEN pay_status = 'N' THEN 1 END) INTO l_pend
    FROM prod.dct_pay_chg_item WHERE register_id = p_register_id;
    IF l_pend > 0 THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Every change must be confirmed by HR and Payroll before submission (' ||
        l_pend || ' pending)');
    END IF;

    SELECT p.payroll_code || ' ' || pe.period_code || ' changes (' ||
           NVL(l_reg.change_count, 0) || ')'
      INTO l_ref
    FROM prod.dct_pay_payroll p, prod.dct_pay_period pe
    WHERE p.payroll_id = l_reg.payroll_id AND pe.period_id = l_reg.period_id;

    o_instance_id := prod.dct_wf_engine.start_process(
                       p_process_code      => 'PAY_CHG_APPROVAL',
                       p_source_record_id  => p_register_id,
                       p_initiator_user_id => l_uid,
                       p_source_record_ref => l_ref);

    UPDATE prod.dct_pay_chg_register
       SET status = 'IN_APPROVAL', wf_instance_id = o_instance_id,
           updated_by = p_user, updated_at = SYSDATE
     WHERE register_id = p_register_id;
  END submit_signoff;

  PROCEDURE wf_on_complete (p_instance_id NUMBER, p_source_module VARCHAR2,
                            p_source_record_id NUMBER, p_user_id NUMBER) IS
    l_status  VARCHAR2(20);
    l_hr_by   NUMBER;
    l_hr_at   DATE;
    l_pay_by  NUMBER;
    l_pay_at  DATE;
    l_capby   VARCHAR2(100);
    l_hr_nm   VARCHAR2(100);
    l_pay_nm  VARCHAR2(100);
  BEGIN
    SELECT status, captured_by INTO l_status, l_capby
    FROM prod.dct_pay_chg_register WHERE register_id = p_source_record_id;
    IF l_status <> 'IN_APPROVAL' THEN RETURN; END IF;

    -- the actual actors of the two chain steps become the sign-off stamps
    SELECT MIN(outcome_by) KEEP (DENSE_RANK FIRST ORDER BY outcome_at),
           MIN(CAST(outcome_at AS DATE)) ,
           MIN(outcome_by) KEEP (DENSE_RANK LAST ORDER BY outcome_at),
           MAX(CAST(outcome_at AS DATE))
      INTO l_hr_by, l_hr_at, l_pay_by, l_pay_at
    FROM prod.dct_wf_task
    WHERE instance_id = p_instance_id AND outcome_code IS NOT NULL;

    -- package-private functions are invisible to SQL: resolve names first
    l_hr_nm  := uname_of(NVL(l_hr_by, p_user_id));
    l_pay_nm := uname_of(NVL(l_pay_by, p_user_id));

    UPDATE prod.dct_pay_chg_register
       SET status = 'CONFIRMED',
           hr_done_by  = l_hr_nm,
           hr_done_at  = NVL(l_hr_at, SYSDATE),
           pay_done_by = l_pay_nm,
           pay_done_at = NVL(l_pay_at, SYSDATE),
           updated_by = 'WORKFLOW', updated_at = SYSDATE
     WHERE register_id = p_source_record_id;

    enqueue_report(p_source_record_id, NVL(uname_of(p_user_id), NVL(l_capby, 'SYSTEM')));
  END wf_on_complete;

  PROCEDURE wf_on_reject (p_instance_id NUMBER, p_source_module VARCHAR2,
                          p_source_record_id NUMBER, p_user_id NUMBER) IS
    l_status VARCHAR2(20);
    l_capby  VARCHAR2(100);
    l_uid    NUMBER;
  BEGIN
    SELECT status, captured_by INTO l_status, l_capby
    FROM prod.dct_pay_chg_register WHERE register_id = p_source_record_id;
    IF l_status <> 'IN_APPROVAL' THEN RETURN; END IF;

    UPDATE prod.dct_pay_chg_register
       SET status = 'OPEN', wf_instance_id = NULL,
           hr_done_by = NULL, hr_done_at = NULL,
           pay_done_by = NULL, pay_done_at = NULL,
           updated_by = 'WORKFLOW', updated_at = SYSDATE
     WHERE register_id = p_source_record_id;

    l_uid := uid_of(l_capby);
    IF l_uid IS NOT NULL THEN
      prod.dct_notify.send(
        p_recipient_user_id => l_uid,
        p_notification_type => 'PAY_CHG_RETURNED',
        p_title_en          => 'Change register returned',
        p_body_en           => 'Change register #' || p_source_record_id ||
                               ' was returned by the approval chain - review and resubmit.',
        p_title_ar          => UNISTR('\0623\0639\064A\062F \0633\062C\0644 \0627\0644\062A\063A\064A\064A\0631\0627\062A'),
        p_body_ar           => UNISTR('\0623\0639\064A\062F \0633\062C\0644 \0627\0644\062A\063A\064A\064A\0631\0627\062A \0631\0642\0645 ') ||
                               p_source_record_id ||
                               UNISTR(' \0645\0646 \0633\0644\0633\0644\0629 \0627\0644\0627\0639\062A\0645\0627\062F - \0631\0627\062C\0639 \0648\0623\0639\062F \0627\0644\0625\0631\0633\0627\0644.'),
        p_module_code       => c_module,
        p_link_url          => '#payChanges');
    END IF;
  END wf_on_reject;

  PROCEDURE auto_sweep IS
    l_reg_id  NUMBER;
    l_auto    BOOLEAN := NVL(get_setting('CHG_AUTO_CAPTURE','Y'),'Y') = 'Y';
    l_days    NUMBER  := num_setting('CHG_REMIND_DAYS', 3);
    l_chg     NUMBER;
  BEGIN
    -- cutoff-day auto-capture: current period, register not yet captured
    IF l_auto THEN
      FOR p IN (SELECT pay.payroll_id, pay.payroll_code, pay.cutoff_day,
                       pe.period_id, pe.period_code
                FROM prod.dct_pay_payroll pay
                JOIN prod.dct_pay_period pe
                  ON pe.payroll_id = pay.payroll_id
                 AND TRUNC(SYSDATE) BETWEEN pe.date_from AND pe.date_to
                WHERE pay.is_active = 'Y'
                  AND pay.cutoff_day IS NOT NULL
                  AND EXTRACT(DAY FROM SYSDATE) >= pay.cutoff_day
                  AND NOT EXISTS (SELECT 1 FROM prod.dct_pay_chg_register r
                                  WHERE r.payroll_id = pay.payroll_id
                                    AND r.period_id = pe.period_id)) LOOP
        BEGIN
          capture(p.payroll_id, p.period_id, 'SYSTEM', l_reg_id);
          SELECT change_count INTO l_chg FROM prod.dct_pay_chg_register
          WHERE register_id = l_reg_id;
          UPDATE prod.dct_pay_chg_register SET last_notified_at = SYSDATE
          WHERE register_id = l_reg_id;
          notify_role('PAY_HR_ENTRY', 'PAY_CHG_CAPTURED',
            'Employee changes captured - ' || p.payroll_code || ' ' || p.period_code,
            NVL(l_chg, 0) || ' change(s) await HR confirmation for payroll ' ||
              p.payroll_code || ', period ' || p.period_code || '.',
            UNISTR('\062A\0645 \0627\0644\062A\0642\0627\0637 \062A\063A\064A\064A\0631\0627\062A \0627\0644\0645\0648\0638\0641\064A\0646'),
            NVL(l_chg, 0) || UNISTR(' \062A\063A\064A\064A\0631 \0628\0627\0646\062A\0638\0627\0631 \0627\0639\062A\0645\0627\062F \0627\0644\0645\0648\0627\0631\062F \0627\0644\0628\0634\0631\064A\0629 \0644\0644\0641\062A\0631\0629 ') ||
              p.period_code);
        EXCEPTION WHEN OTHERS THEN NULL;  -- an odd payroll must not kill the sweep
        END;
      END LOOP;
    END IF;

    -- reminders: registers still awaiting a side, throttled per register
    FOR r IN (SELECT r.register_id, r.status, pay.payroll_code, pe.period_code,
                     (SELECT COUNT(*) FROM prod.dct_pay_chg_item i
                      WHERE i.register_id = r.register_id AND i.hr_status = 'N') pend_hr,
                     (SELECT COUNT(*) FROM prod.dct_pay_chg_item i
                      WHERE i.register_id = r.register_id AND i.pay_status = 'N') pend_pay
              FROM prod.dct_pay_chg_register r
              JOIN prod.dct_pay_payroll pay ON pay.payroll_id = r.payroll_id
              JOIN prod.dct_pay_period pe ON pe.period_id = r.period_id
              WHERE r.status IN ('OPEN', 'HR_CONFIRMED')
                AND pe.date_to >= SYSDATE - 45
                AND (r.last_notified_at IS NULL OR r.last_notified_at < SYSDATE - l_days)) LOOP
      IF r.pend_hr > 0 THEN
        notify_role('PAY_HR_ENTRY', 'PAY_CHG_REMIND',
          'Employee changes pending HR - ' || r.payroll_code || ' ' || r.period_code,
          r.pend_hr || ' change(s) still need HR confirmation before payroll can run.',
          UNISTR('\062A\063A\064A\064A\0631\0627\062A \0628\0627\0646\062A\0638\0627\0631 \0627\0644\0645\0648\0627\0631\062F \0627\0644\0628\0634\0631\064A\0629'),
          r.pend_hr || UNISTR(' \062A\063A\064A\064A\0631 \0628\0627\0646\062A\0638\0627\0631 \0627\0644\0627\0639\062A\0645\0627\062F \0644\0644\0641\062A\0631\0629 ') || r.period_code);
      ELSIF r.pend_pay > 0 OR r.status = 'HR_CONFIRMED' THEN
        notify_role('PAY_PAYROLL_ENTRY', 'PAY_CHG_REMIND',
          'Employee changes pending Payroll - ' || r.payroll_code || ' ' || r.period_code,
          r.pend_pay || ' change(s) await Payroll confirmation and sign-off.',
          UNISTR('\062A\063A\064A\064A\0631\0627\062A \0628\0627\0646\062A\0638\0627\0631 \0641\0631\064A\0642 \0627\0644\0631\0648\0627\062A\0628'),
          r.pend_pay || UNISTR(' \062A\063A\064A\064A\0631 \0628\0627\0646\062A\0638\0627\0631 \0627\0639\062A\0645\0627\062F \0641\0631\064A\0642 \0627\0644\0631\0648\0627\062A\0628 \0644\0644\0641\062A\0631\0629 ') || r.period_code);
      END IF;
      UPDATE prod.dct_pay_chg_register SET last_notified_at = SYSDATE
      WHERE register_id = r.register_id;
    END LOOP;

    COMMIT;
  END auto_sweep;

END dct_pay_chg_pkg;
/

SHOW ERRORS PACKAGE prod.dct_pay_chg_pkg
SHOW ERRORS PACKAGE BODY prod.dct_pay_chg_pkg

PROMPT --- [4/4] daily job ---

DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM all_scheduler_jobs
  WHERE owner = 'PROD' AND job_name = 'DCT_PAY_CHG_JOB';
  IF l_n > 0 THEN
    DBMS_SCHEDULER.DROP_JOB('PROD.DCT_PAY_CHG_JOB');
  END IF;
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'PROD.DCT_PAY_CHG_JOB',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN prod.dct_pay_chg_pkg.auto_sweep; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=DAILY;BYHOUR=7;BYMINUTE=30',
    enabled         => TRUE,
    comments        => 'PAY change control: cutoff-day auto-capture + pending-confirmation reminders');
  DBMS_OUTPUT.put_line('DCT_PAY_CHG_JOB scheduled daily 07:30 UTC');
END;
/

SELECT object_name, object_type, status FROM all_objects
WHERE owner = 'PROD' AND object_name = 'DCT_PAY_CHG_PKG';

EXIT
