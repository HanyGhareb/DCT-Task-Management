-- =============================================================================
-- Outsource Payroll Module (App 215) -- Phase 3 -- Calculation Engine
-- File    : 16_pay_phase3_pkg.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp
-- Notes   : DCT_PAY_CALC_PKG - payroll setup writes + the run engine
--           (load / validate / calculate / review / reopen). Errors:
--           -20001 validation (400), -20403 forbidden, -20404 not found.
--           Charge preview only - margin/VAT rows never touch employee net,
--           and nothing here pays anyone: payments stay DCT -> company.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

WHENEVER SQLERROR CONTINUE

CREATE OR REPLACE PACKAGE prod.dct_pay_calc_pkg AS

  FUNCTION can_setup (p_user VARCHAR2) RETURN BOOLEAN;
  FUNCTION can_run   (p_user VARCHAR2) RETURN BOOLEAN;

  -- published so the load snapshot SQL can call it (PLS-00231 otherwise)
  FUNCTION factor (p_af DATE, p_at DATE, p_pf DATE, p_pt DATE,
                   p_basis VARCHAR2, p_div NUMBER) RETURN NUMBER;

  PROCEDURE save_payroll (
    p_id              IN OUT NUMBER,
    p_code            IN VARCHAR2,
    p_name_en         IN VARCHAR2,
    p_name_ar         IN VARCHAR2,
    p_company_id      IN NUMBER,
    p_proration_basis IN VARCHAR2,
    p_divisor         IN NUMBER,
    p_pension_base    IN VARCHAR2,
    p_cutoff_day      IN NUMBER,
    p_pay_day         IN NUMBER,
    p_is_active       IN VARCHAR2,
    p_notes           IN VARCHAR2,
    p_user            IN VARCHAR2);

  PROCEDURE gen_periods (p_payroll_id IN NUMBER, p_year IN NUMBER, p_user IN VARCHAR2);

  PROCEDURE save_element (
    p_id            IN OUT NUMBER,
    p_code          IN VARCHAR2,
    p_name_en       IN VARCHAR2,
    p_name_ar       IN VARCHAR2,
    p_company_id    IN NUMBER,
    p_class         IN VARCHAR2,
    p_rule          IN VARCHAR2,
    p_base          IN VARCHAR2,
    p_percent       IN NUMBER,
    p_rate_table_id IN NUMBER,
    p_priority      IN NUMBER,
    p_prorate       IN VARCHAR2,
    p_recurring     IN VARCHAR2,
    p_visible       IN VARCHAR2,
    p_is_active     IN VARCHAR2,
    p_notes         IN VARCHAR2,
    p_user          IN VARCHAR2);

  PROCEDURE save_link (
    p_id         IN OUT NUMBER,
    p_element_id IN NUMBER,
    p_link_type  IN VARCHAR2,
    p_link_value IN VARCHAR2,
    p_is_active  IN VARCHAR2,
    p_user       IN VARCHAR2);

  PROCEDURE save_entry (
    p_id            IN OUT NUMBER,
    p_element_id    IN NUMBER,
    p_person_id     IN NUMBER,
    p_assignment_id IN NUMBER,
    p_entry_type    IN VARCHAR2,
    p_amount        IN NUMBER,
    p_qty           IN NUMBER,
    p_rate          IN NUMBER,
    p_from          IN DATE,
    p_to            IN DATE,
    p_notes         IN VARCHAR2,
    p_is_active     IN VARCHAR2,
    p_user          IN VARCHAR2);

  PROCEDURE save_rate_row (
    p_id            IN OUT NUMBER,
    p_rate_table_id IN NUMBER,
    p_key_value     IN VARCHAR2,
    p_ee_rate       IN NUMBER,
    p_er_rate       IN NUMBER,
    p_amount        IN NUMBER,
    p_is_active     IN VARCHAR2,
    p_user          IN VARCHAR2);

  -- group_code is a NUMBER; short_code is the mnemonic; membership basis is
  -- the cost-center map plus per-employee INCLUDE / EXCLUDE overrides
  PROCEDURE save_invoice_group (
    p_id            IN OUT NUMBER,
    p_company_id    IN NUMBER,
    p_group_code    IN NUMBER,
    p_short_code    IN VARCHAR2,
    p_name_en       IN VARCHAR2,
    p_name_ar       IN VARCHAR2,
    p_display_order IN NUMBER,
    p_is_default    IN VARCHAR2,
    p_is_active     IN VARCHAR2,
    p_ccs           IN VARCHAR2,
    p_user          IN VARCHAR2);

  -- p_mode: INCLUDE forces the employee into the group, EXCLUDE keeps them
  -- out of it, CLEAR removes the override (back to the cost-center map)
  PROCEDURE set_group_emp (
    p_group_id  IN NUMBER,
    p_person_id IN NUMBER,
    p_mode      IN VARCHAR2,
    p_user      IN VARCHAR2);

  -- Pay Admin moves one employee of an open run to another invoice group;
  -- persists as an INCLUDE override and re-prices charges when calculated
  PROCEDURE set_run_emp_group (
    p_run_emp_id IN NUMBER,
    p_group_code IN NUMBER,
    p_user       IN VARCHAR2);

  PROCEDURE create_run (
    p_payroll_id  IN NUMBER,
    p_period_code IN VARCHAR2,
    p_run_type    IN VARCHAR2,
    p_user        IN VARCHAR2,
    o_run_id      OUT NUMBER);

  PROCEDURE act (p_run_id IN NUMBER, p_action IN VARCHAR2, p_user IN VARCHAR2);

END dct_pay_calc_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_pay_calc_pkg AS

  FUNCTION can_setup (p_user VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN prod.dct_auth.has_role(p_user, 'PAY_ADMIN')
        OR prod.dct_auth.has_role(p_user, 'SYS_ADMIN');
  END;

  FUNCTION can_run (p_user VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN can_setup(p_user)
        OR prod.dct_auth.has_role(p_user, 'PAY_PAYROLL_ENTRY');
  END;

  PROCEDURE need_setup (p_user VARCHAR2) IS
  BEGIN
    IF NOT can_setup(p_user) THEN
      RAISE_APPLICATION_ERROR(-20403, 'Payroll setup requires PAY_ADMIN');
    END IF;
  END;

  PROCEDURE need_run (p_user VARCHAR2) IS
  BEGIN
    IF NOT can_run(p_user) THEN
      RAISE_APPLICATION_ERROR(-20403, 'Payroll runs require PAY_PAYROLL_ENTRY or PAY_ADMIN');
    END IF;
  END;

  FUNCTION weekdays_between (p_from DATE, p_to DATE) RETURN NUMBER IS
    n NUMBER := 0;
  BEGIN
    FOR i IN 0 .. GREATEST(p_to - p_from, 0) LOOP
      IF TO_CHAR(p_from + i, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') NOT IN ('SAT', 'SUN') THEN
        n := n + 1;
      END IF;
    END LOOP;
    RETURN n;
  END;

  -- proration factor for an assignment window inside a period
  FUNCTION factor (p_af DATE, p_at DATE, p_pf DATE, p_pt DATE,
                   p_basis VARCHAR2, p_div NUMBER) RETURN NUMBER IS
    l_of DATE := GREATEST(p_af, p_pf);
    l_ot DATE := LEAST(NVL(p_at, p_pt), p_pt);
  BEGIN
    IF l_of > l_ot THEN RETURN 0; END IF;
    IF p_af <= p_pf AND NVL(p_at, p_pt) >= p_pt THEN RETURN 1; END IF;
    IF p_basis = 'CALENDAR_DAYS' THEN
      RETURN ROUND((l_ot - l_of + 1) / (p_pt - p_pf + 1), 6);
    ELSIF p_basis = 'WORKING_DAYS' THEN
      RETURN ROUND(weekdays_between(l_of, l_ot) / GREATEST(weekdays_between(p_pf, p_pt), 1), 6);
    END IF;
    RETURN LEAST(1, ROUND((l_ot - l_of + 1) / NVL(p_div, 30), 6));
  END;

  PROCEDURE save_payroll (
    p_id IN OUT NUMBER, p_code IN VARCHAR2, p_name_en IN VARCHAR2, p_name_ar IN VARCHAR2,
    p_company_id IN NUMBER, p_proration_basis IN VARCHAR2, p_divisor IN NUMBER,
    p_pension_base IN VARCHAR2, p_cutoff_day IN NUMBER, p_pay_day IN NUMBER,
    p_is_active IN VARCHAR2, p_notes IN VARCHAR2, p_user IN VARCHAR2) IS
    n NUMBER;
  BEGIN
    need_setup(p_user);
    IF p_code IS NULL OR p_name_en IS NULL OR p_company_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Code, name and company are required');
    END IF;
    IF p_proration_basis IS NOT NULL THEN
      prod.dct_lookup_pkg.validate_lookup('PAY_PRORATION_BASIS', p_proration_basis);
    END IF;
    SELECT COUNT(*) INTO n FROM prod.dct_pay_company WHERE company_id = p_company_id;
    IF n = 0 THEN RAISE_APPLICATION_ERROR(-20404, 'Company not found'); END IF;
    IF p_id IS NULL THEN
      SELECT COUNT(*) INTO n FROM prod.dct_pay_payroll WHERE payroll_code = UPPER(p_code);
      IF n > 0 THEN RAISE_APPLICATION_ERROR(-20001, 'Payroll code already exists'); END IF;
      INSERT INTO prod.dct_pay_payroll
             (payroll_code, name_en, name_ar, company_id, proration_basis, proration_divisor,
              pension_base, cutoff_day, pay_day, is_active, notes, created_by, updated_by)
      VALUES (UPPER(p_code), p_name_en, p_name_ar, p_company_id,
              NVL(p_proration_basis, 'FIXED_30'), NVL(p_divisor, 30),
              NVL(p_pension_base, 'GROSS'), p_cutoff_day, p_pay_day,
              NVL(p_is_active, 'Y'), p_notes, p_user, p_user)
      RETURNING payroll_id INTO p_id;
    ELSE
      UPDATE prod.dct_pay_payroll
         SET name_en = NVL(p_name_en, name_en),
             name_ar = NVL(p_name_ar, name_ar),
             proration_basis = NVL(p_proration_basis, proration_basis),
             proration_divisor = NVL(p_divisor, proration_divisor),
             pension_base = NVL(p_pension_base, pension_base),
             cutoff_day = NVL(p_cutoff_day, cutoff_day),
             pay_day = NVL(p_pay_day, pay_day),
             is_active = NVL(p_is_active, is_active),
             notes = NVL(p_notes, notes),
             row_version = row_version + 1,
             updated_by = p_user, updated_at = SYSDATE
       WHERE payroll_id = p_id;
      IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20404, 'Payroll not found'); END IF;
    END IF;
  END;

  PROCEDURE gen_periods (p_payroll_id IN NUMBER, p_year IN NUMBER, p_user IN VARCHAR2) IS
    l_from DATE;
    n NUMBER;
  BEGIN
    need_setup(p_user);
    IF p_year IS NULL OR p_year < 2020 OR p_year > 2100 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Invalid year');
    END IF;
    SELECT COUNT(*) INTO n FROM prod.dct_pay_payroll WHERE payroll_id = p_payroll_id;
    IF n = 0 THEN RAISE_APPLICATION_ERROR(-20404, 'Payroll not found'); END IF;
    FOR m IN 1..12 LOOP
      l_from := TO_DATE(LPAD(m, 2, '0') || '-' || p_year, 'MM-YYYY');
      SELECT COUNT(*) INTO n FROM prod.dct_pay_period
      WHERE payroll_id = p_payroll_id AND period_code = TO_CHAR(l_from, 'MM-YYYY');
      IF n = 0 THEN
        INSERT INTO prod.dct_pay_period
               (payroll_id, period_code, date_from, date_to, cutoff_date, pay_date, created_by, updated_by)
        VALUES (p_payroll_id, TO_CHAR(l_from, 'MM-YYYY'), l_from, LAST_DAY(l_from),
                l_from + 19, LEAST(l_from + 27, LAST_DAY(l_from)), p_user, p_user);
      END IF;
    END LOOP;
  END;

  PROCEDURE save_element (
    p_id IN OUT NUMBER, p_code IN VARCHAR2, p_name_en IN VARCHAR2, p_name_ar IN VARCHAR2,
    p_company_id IN NUMBER, p_class IN VARCHAR2, p_rule IN VARCHAR2, p_base IN VARCHAR2,
    p_percent IN NUMBER, p_rate_table_id IN NUMBER, p_priority IN NUMBER,
    p_prorate IN VARCHAR2, p_recurring IN VARCHAR2, p_visible IN VARCHAR2,
    p_is_active IN VARCHAR2, p_notes IN VARCHAR2, p_user IN VARCHAR2) IS
    n NUMBER;
  BEGIN
    need_setup(p_user);
    IF p_id IS NULL AND (p_code IS NULL OR p_name_en IS NULL OR p_class IS NULL OR p_rule IS NULL) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Code, name, class and rule are required');
    END IF;
    IF p_class IS NOT NULL THEN prod.dct_lookup_pkg.validate_lookup('PAY_ELEMENT_CLASS', p_class); END IF;
    IF p_rule IS NOT NULL THEN
      prod.dct_lookup_pkg.validate_lookup('PAY_CALC_RULE', p_rule);
      IF p_rule = 'FORMULA' THEN
        RAISE_APPLICATION_ERROR(-20001, 'FORMULA elements are not enabled in Phase 3');
      END IF;
      IF p_rule = 'PERCENT' AND p_percent IS NULL AND p_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'PERCENT elements need a percent value');
      END IF;
      IF p_rule = 'RATE_TABLE' AND p_rate_table_id IS NULL AND p_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'RATE_TABLE elements need a rate table');
      END IF;
    END IF;
    IF p_base IS NOT NULL THEN prod.dct_lookup_pkg.validate_lookup('PAY_CALC_BASE', p_base); END IF;
    IF p_id IS NULL THEN
      SELECT COUNT(*) INTO n FROM prod.dct_pay_element WHERE element_code = UPPER(p_code);
      IF n > 0 THEN RAISE_APPLICATION_ERROR(-20001, 'Element code already exists'); END IF;
      INSERT INTO prod.dct_pay_element
             (element_code, name_en, name_ar, company_id, element_class, calc_rule, calc_base,
              percent_value, rate_table_id, priority, prorate, recurring, payslip_visible,
              is_active, notes, created_by, updated_by)
      VALUES (UPPER(p_code), p_name_en, p_name_ar, p_company_id, p_class, p_rule, p_base,
              p_percent, p_rate_table_id, NVL(p_priority, 100), NVL(p_prorate, 'Y'),
              NVL(p_recurring, 'Y'), NVL(p_visible, 'Y'), NVL(p_is_active, 'Y'),
              p_notes, p_user, p_user)
      RETURNING element_id INTO p_id;
    ELSE
      UPDATE prod.dct_pay_element
         SET name_en = NVL(p_name_en, name_en),
             name_ar = NVL(p_name_ar, name_ar),
             element_class = NVL(p_class, element_class),
             calc_rule = NVL(p_rule, calc_rule),
             calc_base = NVL(p_base, calc_base),
             percent_value = NVL(p_percent, percent_value),
             rate_table_id = NVL(p_rate_table_id, rate_table_id),
             priority = NVL(p_priority, priority),
             prorate = NVL(p_prorate, prorate),
             recurring = NVL(p_recurring, recurring),
             payslip_visible = NVL(p_visible, payslip_visible),
             is_active = NVL(p_is_active, is_active),
             notes = NVL(p_notes, notes),
             updated_by = p_user, updated_at = SYSDATE
       WHERE element_id = p_id;
      IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20404, 'Element not found'); END IF;
    END IF;
  END;

  PROCEDURE save_link (
    p_id IN OUT NUMBER, p_element_id IN NUMBER, p_link_type IN VARCHAR2,
    p_link_value IN VARCHAR2, p_is_active IN VARCHAR2, p_user IN VARCHAR2) IS
    n NUMBER;
  BEGIN
    need_setup(p_user);
    IF p_id IS NULL THEN
      IF p_element_id IS NULL OR p_link_type IS NULL OR p_link_value IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Element, link type and value are required');
      END IF;
      prod.dct_lookup_pkg.validate_lookup('PAY_LINK_TYPE', p_link_type);
      SELECT COUNT(*) INTO n FROM prod.dct_pay_element WHERE element_id = p_element_id;
      IF n = 0 THEN RAISE_APPLICATION_ERROR(-20404, 'Element not found'); END IF;
      INSERT INTO prod.dct_pay_element_link (element_id, link_type, link_value, created_by, updated_by)
      VALUES (p_element_id, p_link_type, p_link_value, p_user, p_user)
      RETURNING link_id INTO p_id;
    ELSE
      UPDATE prod.dct_pay_element_link
         SET link_type = NVL(p_link_type, link_type),
             link_value = NVL(p_link_value, link_value),
             is_active = NVL(p_is_active, is_active),
             updated_by = p_user, updated_at = SYSDATE
       WHERE link_id = p_id;
      IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20404, 'Link not found'); END IF;
    END IF;
  END;

  PROCEDURE save_entry (
    p_id IN OUT NUMBER, p_element_id IN NUMBER, p_person_id IN NUMBER,
    p_assignment_id IN NUMBER, p_entry_type IN VARCHAR2, p_amount IN NUMBER,
    p_qty IN NUMBER, p_rate IN NUMBER, p_from IN DATE, p_to IN DATE,
    p_notes IN VARCHAR2, p_is_active IN VARCHAR2, p_user IN VARCHAR2) IS
    n NUMBER;
  BEGIN
    need_run(p_user);
    IF p_id IS NULL THEN
      IF p_element_id IS NULL OR p_person_id IS NULL OR p_from IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Element, employee and effective date are required');
      END IF;
      IF p_entry_type IS NOT NULL THEN
        prod.dct_lookup_pkg.validate_lookup('PAY_ENTRY_TYPE', p_entry_type);
      END IF;
      SELECT COUNT(*) INTO n FROM prod.dct_employees
      WHERE person_id = p_person_id AND employee_type = 'OUTSOURCE';
      IF n = 0 THEN RAISE_APPLICATION_ERROR(-20404, 'Outsourced employee not found'); END IF;
      IF p_amount IS NULL AND (p_qty IS NULL OR p_rate IS NULL) THEN
        RAISE_APPLICATION_ERROR(-20001, 'An amount, or quantity and rate, is required');
      END IF;
      INSERT INTO prod.dct_pay_element_entry
             (element_id, person_id, assignment_id, entry_type, amount, qty, rate,
              effective_from, effective_to, notes, created_by, updated_by)
      VALUES (p_element_id, p_person_id, p_assignment_id, NVL(p_entry_type, 'RECURRING'),
              p_amount, p_qty, p_rate, p_from, p_to, p_notes, p_user, p_user)
      RETURNING entry_id INTO p_id;
    ELSE
      UPDATE prod.dct_pay_element_entry
         SET amount = NVL(p_amount, amount),
             qty = NVL(p_qty, qty),
             rate = NVL(p_rate, rate),
             effective_from = NVL(p_from, effective_from),
             effective_to = NVL(p_to, effective_to),
             notes = NVL(p_notes, notes),
             is_active = NVL(p_is_active, is_active),
             updated_by = p_user, updated_at = SYSDATE
       WHERE entry_id = p_id;
      IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20404, 'Entry not found'); END IF;
    END IF;
  END;

  PROCEDURE save_rate_row (
    p_id IN OUT NUMBER, p_rate_table_id IN NUMBER, p_key_value IN VARCHAR2,
    p_ee_rate IN NUMBER, p_er_rate IN NUMBER, p_amount IN NUMBER,
    p_is_active IN VARCHAR2, p_user IN VARCHAR2) IS
    n NUMBER;
  BEGIN
    need_setup(p_user);
    IF p_id IS NULL THEN
      IF p_rate_table_id IS NULL OR p_key_value IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Rate table and key are required');
      END IF;
      SELECT COUNT(*) INTO n FROM prod.dct_pay_rate_table WHERE rate_table_id = p_rate_table_id;
      IF n = 0 THEN RAISE_APPLICATION_ERROR(-20404, 'Rate table not found'); END IF;
      INSERT INTO prod.dct_pay_rate_row
             (rate_table_id, key_value, ee_rate, er_rate, amount, created_by, updated_by)
      VALUES (p_rate_table_id, UPPER(p_key_value), p_ee_rate, p_er_rate, p_amount, p_user, p_user)
      RETURNING row_id INTO p_id;
    ELSE
      UPDATE prod.dct_pay_rate_row
         SET ee_rate = p_ee_rate,
             er_rate = p_er_rate,
             amount = NVL(p_amount, amount),
             is_active = NVL(p_is_active, is_active),
             updated_by = p_user, updated_at = SYSDATE
       WHERE row_id = p_id;
      IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20404, 'Rate row not found'); END IF;
    END IF;
  END;

  PROCEDURE save_invoice_group (
    p_id IN OUT NUMBER, p_company_id IN NUMBER, p_group_code IN NUMBER,
    p_short_code IN VARCHAR2, p_name_en IN VARCHAR2, p_name_ar IN VARCHAR2,
    p_display_order IN NUMBER, p_is_default IN VARCHAR2, p_is_active IN VARCHAR2,
    p_ccs IN VARCHAR2, p_user IN VARCHAR2) IS
    n NUMBER;
    l_company NUMBER;
    l_other VARCHAR2(30);
  BEGIN
    need_setup(p_user);
    IF p_id IS NULL THEN
      IF p_company_id IS NULL OR p_group_code IS NULL OR p_short_code IS NULL OR p_name_en IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Company, group code, short code and name are required');
      END IF;
      SELECT COUNT(*) INTO n FROM prod.dct_pay_invoice_group
      WHERE company_id = p_company_id AND group_code = p_group_code;
      IF n > 0 THEN RAISE_APPLICATION_ERROR(-20001, 'Group code already used for this company'); END IF;
      SELECT COUNT(*) INTO n FROM prod.dct_pay_invoice_group
      WHERE company_id = p_company_id AND short_code = UPPER(p_short_code);
      IF n > 0 THEN RAISE_APPLICATION_ERROR(-20001, 'Short code already used for this company'); END IF;
      INSERT INTO prod.dct_pay_invoice_group
             (company_id, group_code, short_code, name_en, name_ar, display_order, is_default, created_by, updated_by)
      VALUES (p_company_id, p_group_code, UPPER(p_short_code), p_name_en, p_name_ar,
              NVL(p_display_order, 10), NVL(p_is_default, 'N'), p_user, p_user)
      RETURNING group_id INTO p_id;
      l_company := p_company_id;
    ELSE
      BEGIN
        SELECT company_id INTO l_company FROM prod.dct_pay_invoice_group WHERE group_id = p_id;
      EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'Invoice group not found');
      END;
      IF p_group_code IS NOT NULL THEN
        SELECT COUNT(*) INTO n FROM prod.dct_pay_invoice_group
        WHERE company_id = l_company AND group_code = p_group_code AND group_id <> p_id;
        IF n > 0 THEN RAISE_APPLICATION_ERROR(-20001, 'Group code already used for this company'); END IF;
      END IF;
      IF p_short_code IS NOT NULL THEN
        SELECT COUNT(*) INTO n FROM prod.dct_pay_invoice_group
        WHERE company_id = l_company AND short_code = UPPER(p_short_code) AND group_id <> p_id;
        IF n > 0 THEN RAISE_APPLICATION_ERROR(-20001, 'Short code already used for this company'); END IF;
      END IF;
      UPDATE prod.dct_pay_invoice_group
         SET group_code = NVL(p_group_code, group_code),
             short_code = NVL(UPPER(p_short_code), short_code),
             name_en = NVL(p_name_en, name_en),
             name_ar = NVL(p_name_ar, name_ar),
             display_order = NVL(p_display_order, display_order),
             is_default = NVL(p_is_default, is_default),
             is_active = NVL(p_is_active, is_active),
             updated_by = p_user, updated_at = SYSDATE
       WHERE group_id = p_id;
    END IF;
    IF NVL(p_is_default, 'N') = 'Y' THEN
      UPDATE prod.dct_pay_invoice_group
         SET is_default = 'N', updated_by = p_user, updated_at = SYSDATE
       WHERE company_id = l_company AND group_id <> p_id AND is_default = 'Y';
    END IF;
    -- cost-center map: pipe-delimited replace set; a single dash clears it
    IF p_ccs IS NOT NULL THEN
      DELETE FROM prod.dct_pay_invoice_group_cc WHERE group_id = p_id;
      IF TRIM(p_ccs) <> '-' THEN
        FOR s IN (SELECT TRIM(REGEXP_SUBSTR(p_ccs, '[^|]+', 1, LEVEL)) cc
                  FROM dual CONNECT BY LEVEL <= REGEXP_COUNT(p_ccs, '[^|]+')) LOOP
          IF s.cc IS NOT NULL THEN
            BEGIN
              SELECT g.short_code INTO l_other
              FROM prod.dct_pay_invoice_group_cc c
              JOIN prod.dct_pay_invoice_group g ON g.group_id = c.group_id
              WHERE g.company_id = l_company AND g.group_id <> p_id AND g.is_active = 'Y'
                AND c.cost_center_code = s.cc
              FETCH FIRST 1 ROWS ONLY;
              RAISE_APPLICATION_ERROR(-20001,
                'Cost center ' || s.cc || ' is already mapped to group ' || l_other);
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;
            SELECT COUNT(*) INTO n FROM prod.dct_pay_invoice_group_cc
            WHERE group_id = p_id AND cost_center_code = s.cc;
            IF n = 0 THEN
              INSERT INTO prod.dct_pay_invoice_group_cc (group_id, cost_center_code, created_by)
              VALUES (p_id, s.cc, p_user);
            END IF;
          END IF;
        END LOOP;
      END IF;
    END IF;
  END;

  PROCEDURE set_group_emp (
    p_group_id IN NUMBER, p_person_id IN NUMBER, p_mode IN VARCHAR2, p_user IN VARCHAR2) IS
    l_company NUMBER;
    n NUMBER;
  BEGIN
    need_setup(p_user);
    IF p_mode NOT IN ('INCLUDE', 'EXCLUDE', 'CLEAR') THEN
      RAISE_APPLICATION_ERROR(-20001, 'Mode must be INCLUDE, EXCLUDE or CLEAR');
    END IF;
    BEGIN
      SELECT company_id INTO l_company FROM prod.dct_pay_invoice_group WHERE group_id = p_group_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Invoice group not found');
    END;
    IF p_mode = 'CLEAR' THEN
      DELETE FROM prod.dct_pay_invoice_group_emp
      WHERE group_id = p_group_id AND person_id = p_person_id;
      RETURN;
    END IF;
    SELECT COUNT(*) INTO n
    FROM prod.dct_pay_assignment a
    JOIN prod.dct_pay_payroll p ON p.payroll_code = a.payroll_code
    WHERE a.person_id = p_person_id AND p.company_id = l_company
      AND a.assignment_type = 'PRIMARY' AND a.status = 'ACTIVE';
    IF n = 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Employee has no active assignment with this company');
    END IF;
    IF p_mode = 'INCLUDE' THEN
      DELETE FROM prod.dct_pay_invoice_group_emp o
      WHERE o.person_id = p_person_id
        AND o.group_id IN (SELECT group_id FROM prod.dct_pay_invoice_group
                           WHERE company_id = l_company);
    ELSE
      DELETE FROM prod.dct_pay_invoice_group_emp
      WHERE group_id = p_group_id AND person_id = p_person_id;
    END IF;
    INSERT INTO prod.dct_pay_invoice_group_emp (group_id, person_id, ovr_mode, created_by)
    VALUES (p_group_id, p_person_id, p_mode, p_user);
  END;

  PROCEDURE create_run (
    p_payroll_id IN NUMBER, p_period_code IN VARCHAR2, p_run_type IN VARCHAR2,
    p_user IN VARCHAR2, o_run_id OUT NUMBER) IS
    l_period_id NUMBER;
    l_status    VARCHAR2(20);
    n NUMBER;
  BEGIN
    need_run(p_user);
    IF NVL(p_run_type, 'REGULAR') <> 'REGULAR' THEN
      RAISE_APPLICATION_ERROR(-20001, 'Only REGULAR runs are enabled in Phase 3');
    END IF;
    BEGIN
      SELECT period_id, status INTO l_period_id, l_status
      FROM prod.dct_pay_period
      WHERE payroll_id = p_payroll_id AND period_code = p_period_code;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Period not found for this payroll');
    END;
    IF l_status <> 'OPEN' THEN
      RAISE_APPLICATION_ERROR(-20001, 'Period ' || p_period_code || ' is closed');
    END IF;
    SELECT COUNT(*) INTO n FROM prod.dct_pay_run
    WHERE payroll_id = p_payroll_id AND period_id = l_period_id AND run_type = 'REGULAR';
    IF n > 0 THEN
      SELECT run_id INTO o_run_id FROM prod.dct_pay_run
      WHERE payroll_id = p_payroll_id AND period_id = l_period_id AND run_type = 'REGULAR';
      RETURN;
    END IF;
    INSERT INTO prod.dct_pay_run (payroll_id, period_id, run_type, created_by, updated_by)
    VALUES (p_payroll_id, l_period_id, 'REGULAR', p_user, p_user)
    RETURNING run_id INTO o_run_id;
  END;

  PROCEDURE load_run (p_run_id NUMBER, p_user VARCHAR2) IS
    l_pay  prod.dct_pay_payroll%ROWTYPE;
    l_per  prod.dct_pay_period%ROWTYPE;
    l_grp_default NUMBER;
    l_n NUMBER;
  BEGIN
    SELECT p.* INTO l_pay FROM prod.dct_pay_payroll p
    JOIN prod.dct_pay_run r ON r.payroll_id = p.payroll_id WHERE r.run_id = p_run_id;
    SELECT pe.* INTO l_per FROM prod.dct_pay_period pe
    JOIN prod.dct_pay_run r ON r.period_id = pe.period_id WHERE r.run_id = p_run_id;

    BEGIN
      SELECT group_code INTO l_grp_default FROM prod.dct_pay_invoice_group
      WHERE company_id = l_pay.company_id AND is_default = 'Y' AND is_active = 'Y'
      FETCH FIRST 1 ROWS ONLY;
    EXCEPTION WHEN NO_DATA_FOUND THEN l_grp_default := NULL;
    END;

    DELETE FROM prod.dct_pay_run_charge WHERE run_id = p_run_id;
    DELETE FROM prod.dct_pay_run_emp WHERE run_id = p_run_id;

    INSERT INTO prod.dct_pay_run_emp
           (run_id, person_id, assignment_id, employee_number, full_name, company_ref,
            sector_name, department_name, grade_code, cost_center_code, nationality_code,
            invoice_group_code, days_factor)
    SELECT p_run_id, a.person_id, a.assignment_id, e.employee_number, e.full_name_en,
           a.company_ref, a.sector_name, a.department_name, a.grade_code, a.cost_center_code,
           e.nationality_code,
           COALESCE(
             (SELECT g.group_code
              FROM prod.dct_pay_invoice_group g
              JOIN prod.dct_pay_invoice_group_emp o ON o.group_id = g.group_id
              WHERE g.company_id = a.company_id AND g.is_active = 'Y'
                AND o.person_id = a.person_id AND o.ovr_mode = 'INCLUDE'
              FETCH FIRST 1 ROWS ONLY),
             (SELECT g.group_code
              FROM prod.dct_pay_invoice_group g
              JOIN prod.dct_pay_invoice_group_cc c ON c.group_id = g.group_id
              WHERE g.company_id = a.company_id AND g.is_active = 'Y'
                AND c.cost_center_code = a.cost_center_code
                AND NOT EXISTS (SELECT 1 FROM prod.dct_pay_invoice_group_emp x
                                WHERE x.group_id = g.group_id
                                  AND x.person_id = a.person_id
                                  AND x.ovr_mode = 'EXCLUDE')
              FETCH FIRST 1 ROWS ONLY),
             l_grp_default),
           factor(a.effective_from, a.effective_to, l_per.date_from, l_per.date_to,
                  l_pay.proration_basis, l_pay.proration_divisor)
    FROM prod.dct_pay_assignment a
    JOIN prod.dct_employees e ON e.person_id = a.person_id
    WHERE a.payroll_code = l_pay.payroll_code
      AND a.assignment_type = 'PRIMARY'
      AND a.status = 'ACTIVE'
      AND a.effective_from <= l_per.date_to
      AND NVL(a.effective_to, l_per.date_to) >= l_per.date_from;
    l_n := SQL%ROWCOUNT;

    UPDATE prod.dct_pay_run
       SET status = 'LOADED', emp_count = l_n, exception_count = NULL,
           total_gross = NULL, total_deductions = NULL, total_net = NULL,
           total_employer_cost = NULL, total_charges = NULL,
           loaded_at = SYSDATE, loaded_by = p_user,
           validated_at = NULL, validated_by = NULL,
           calculated_at = NULL, calculated_by = NULL,
           reviewed_at = NULL, reviewed_by = NULL,
           updated_by = p_user, updated_at = SYSDATE
     WHERE run_id = p_run_id;
  END;

  PROCEDURE validate_run (p_run_id NUMBER, p_user VARCHAR2) IS
    l_per prod.dct_pay_period%ROWTYPE;
    l_exc NUMBER := 0;
    l_flags VARCHAR2(1000);
    l_n NUMBER;
  BEGIN
    SELECT pe.* INTO l_per FROM prod.dct_pay_period pe
    JOIN prod.dct_pay_run r ON r.period_id = pe.period_id WHERE r.run_id = p_run_id;

    FOR ce IN (SELECT run_emp_id, person_id, days_factor
               FROM prod.dct_pay_run_emp WHERE run_id = p_run_id) LOOP
      l_flags := NULL;
      SELECT COUNT(*) INTO l_n
      FROM prod.dct_pay_element_entry en
      JOIN prod.dct_pay_element el ON el.element_id = en.element_id
      WHERE en.person_id = ce.person_id AND en.is_active = 'Y'
        AND el.element_class = 'EARNING'
        AND ((en.entry_type = 'RECURRING'
              AND en.effective_from <= l_per.date_to
              AND NVL(en.effective_to, l_per.date_to) >= l_per.date_from)
          OR (en.entry_type = 'ONETIME'
              AND en.effective_from BETWEEN l_per.date_from AND l_per.date_to));
      IF l_n = 0 THEN l_flags := 'NO_SALARY_ENTRY'; END IF;
      IF NVL(ce.days_factor, 0) = 0 THEN
        l_flags := SUBSTR(l_flags || CASE WHEN l_flags IS NOT NULL THEN ',' END || 'NO_DAYS', 1, 1000);
      END IF;
      SELECT COUNT(*) INTO l_n FROM prod.dct_pay_emp_bank
      WHERE person_id = ce.person_id AND is_active = 'Y';
      IF l_n = 0 THEN
        l_flags := SUBSTR(l_flags || CASE WHEN l_flags IS NOT NULL THEN ',' END || 'NO_BANK', 1, 1000);
      END IF;
      IF l_flags IS NOT NULL AND l_flags <> 'NO_BANK' THEN
        l_exc := l_exc + 1;
        UPDATE prod.dct_pay_run_emp SET status = 'EXCEPTION', exceptions = l_flags
        WHERE run_emp_id = ce.run_emp_id;
      ELSE
        UPDATE prod.dct_pay_run_emp SET status = 'OK', exceptions = l_flags
        WHERE run_emp_id = ce.run_emp_id;
      END IF;
    END LOOP;

    UPDATE prod.dct_pay_run
       SET status = 'VALIDATED', exception_count = l_exc,
           validated_at = SYSDATE, validated_by = p_user,
           updated_by = p_user, updated_at = SYSDATE
     WHERE run_id = p_run_id;
  END;

  -- charge preview per invoice group; runs after calculation and again when
  -- an admin moves an employee between groups on an already-calculated run
  PROCEDURE compute_charges (p_run_id NUMBER, p_user VARCHAR2) IS
    l_pay prod.dct_pay_payroll%ROWTYPE;
    l_per prod.dct_pay_period%ROWTYPE;
    l_contract_id NUMBER;
    l_contract_status VARCHAR2(20);
    l_vat_rate NUMBER;
    l_service_fee NUMBER;
    l_amt NUMBER;
    l_tot_charges NUMBER := 0;
    l_has_rule BOOLEAN := FALSE;
    l_note VARCHAR2(400);
    l_default_grp NUMBER;
  BEGIN
    SELECT p.* INTO l_pay FROM prod.dct_pay_payroll p
    JOIN prod.dct_pay_run r ON r.payroll_id = p.payroll_id WHERE r.run_id = p_run_id;
    SELECT pe.* INTO l_per FROM prod.dct_pay_period pe
    JOIN prod.dct_pay_run r ON r.period_id = pe.period_id WHERE r.run_id = p_run_id;

    DELETE FROM prod.dct_pay_run_charge WHERE run_id = p_run_id;

    BEGIN
      SELECT contract_id, status, NVL(vat_rate, 5), service_fee_amount
      INTO l_contract_id, l_contract_status, l_vat_rate, l_service_fee
      FROM (SELECT c.* FROM prod.dct_pay_contract c
            WHERE c.company_id = l_pay.company_id AND c.is_active = 'Y'
            ORDER BY CASE c.status WHEN 'ACTIVE' THEN 0 WHEN 'DRAFT' THEN 1 ELSE 2 END,
                     c.version_no DESC, c.contract_id DESC)
      WHERE ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      l_contract_id := NULL; l_vat_rate := 5; l_service_fee := NULL;
    END;

    l_note := CASE WHEN l_contract_status = 'DRAFT'
                   THEN ' (contract DRAFT - terms pending approval)' END;

    BEGIN
      SELECT MIN(group_code) INTO l_default_grp FROM prod.dct_pay_invoice_group
      WHERE company_id = l_pay.company_id AND is_default = 'Y' AND is_active = 'Y';
    EXCEPTION WHEN NO_DATA_FOUND THEN l_default_grp := NULL;
    END;

    FOR g IN (SELECT re.invoice_group_code grp, COUNT(*) cnt,
                     NVL(SUM(re.days_factor), 0) fct,
                     NVL(SUM(re.gross), 0) gross, NVL(SUM(re.net), 0) net,
                     NVL(SUM((SELECT SUM(l.amount) FROM prod.dct_pay_run_line l
                              WHERE l.run_emp_id = re.run_emp_id
                                AND l.element_code IN ('BASIC', 'GROSS_SALARY'))), 0) basic
              FROM prod.dct_pay_run_emp re
              WHERE re.run_id = p_run_id
              GROUP BY re.invoice_group_code) LOOP
      DECLARE
        l_grp_margin NUMBER := 0;
        l_vat_on CHAR(1) := 'N';
      BEGIN
        IF l_contract_id IS NOT NULL THEN
          FOR mr IN (SELECT * FROM prod.dct_pay_margin_rule
                     WHERE contract_id = l_contract_id AND is_active = 'Y'
                       AND effective_from <= l_per.date_to
                       AND NVL(effective_to, l_per.date_to) >= l_per.date_from
                       AND payment_scope IN ('ALL', 'MONTHLY')) LOOP
            l_has_rule := TRUE;
            IF mr.vat_applicable = 'Y' THEN l_vat_on := 'Y'; END IF;
            l_amt := 0;
            IF mr.method = 'PER_EMPLOYEE' THEN
              l_amt := ROUND(mr.rate_value * g.fct, 2);
            ELSIF mr.method = 'PERCENT' THEN
              l_amt := ROUND(CASE mr.basis WHEN 'BASIC' THEN g.basic
                                           WHEN 'NET' THEN g.net
                                           ELSE g.gross END * mr.rate_value / 100, 2);
            ELSIF mr.method = 'FLAT' THEN
              l_amt := CASE WHEN g.grp = NVL(l_default_grp, g.grp)
                            THEN mr.rate_value ELSE 0 END;
            END IF;
            IF l_amt <> 0 THEN
              INSERT INTO prod.dct_pay_run_charge
                     (run_id, invoice_group_code, charge_type, description, emp_count, amount)
              VALUES (p_run_id, g.grp, 'MARGIN',
                      mr.method || ' ' || mr.rate_value ||
                      CASE WHEN mr.method = 'PER_EMPLOYEE' THEN ' x ' || ROUND(g.fct, 2) || ' prorated headcount' END
                      || l_note,
                      g.cnt, l_amt);
              l_grp_margin := l_grp_margin + l_amt;
              l_tot_charges := l_tot_charges + l_amt;
            END IF;
          END LOOP;
        END IF;
        IF l_vat_on = 'Y' THEN
          l_amt := ROUND((g.gross + l_grp_margin) * l_vat_rate / 100, 2);
          IF l_amt <> 0 THEN
            INSERT INTO prod.dct_pay_run_charge
                   (run_id, invoice_group_code, charge_type, description, emp_count, amount)
            VALUES (p_run_id, g.grp, 'VAT',
                    l_vat_rate || ' pct on salaries + margin (preview)', g.cnt, l_amt);
            l_tot_charges := l_tot_charges + l_amt;
          END IF;
        END IF;
      END;
    END LOOP;

    IF NOT l_has_rule THEN
      INSERT INTO prod.dct_pay_run_charge
             (run_id, invoice_group_code, charge_type, description, emp_count, amount)
      VALUES (p_run_id, NULL, 'MARGIN',
              'No margin rule configured for this company - contract terms pending', NULL, 0);
    END IF;

    UPDATE prod.dct_pay_run
       SET total_charges = l_tot_charges, updated_by = p_user, updated_at = SYSDATE
     WHERE run_id = p_run_id;
  END;

  PROCEDURE calculate_run (p_run_id NUMBER, p_user VARCHAR2) IS
    l_pay  prod.dct_pay_payroll%ROWTYPE;
    l_per  prod.dct_pay_period%ROWTYPE;
    l_comp prod.dct_pay_company%ROWTYPE;
    l_basic NUMBER; l_gross NUMBER; l_ded NUMBER; l_er NUMBER;
    l_amt NUMBER; l_base NUMBER; l_rate NUMBER; l_ee NUMBER; l_err NUMBER;
  BEGIN
    SELECT p.* INTO l_pay FROM prod.dct_pay_payroll p
    JOIN prod.dct_pay_run r ON r.payroll_id = p.payroll_id WHERE r.run_id = p_run_id;
    SELECT pe.* INTO l_per FROM prod.dct_pay_period pe
    JOIN prod.dct_pay_run r ON r.period_id = pe.period_id WHERE r.run_id = p_run_id;
    SELECT c.* INTO l_comp FROM prod.dct_pay_company c WHERE c.company_id = l_pay.company_id;

    DELETE FROM prod.dct_pay_run_line
    WHERE run_emp_id IN (SELECT run_emp_id FROM prod.dct_pay_run_emp WHERE run_id = p_run_id);

    FOR ce IN (SELECT re.run_emp_id, re.person_id, re.days_factor, re.grade_code,
                      re.nationality_code, a.people_group
               FROM prod.dct_pay_run_emp re
               LEFT JOIN prod.dct_pay_assignment a ON a.assignment_id = re.assignment_id
               WHERE re.run_id = p_run_id) LOOP
      l_basic := 0; l_gross := 0; l_ded := 0; l_er := 0;

      FOR el IN (SELECT e.* FROM prod.dct_pay_element e
                 WHERE e.is_active = 'Y'
                   AND e.calc_rule <> 'FORMULA'
                   AND (e.company_id IS NULL OR e.company_id = l_pay.company_id)
                   AND (e.effective_from IS NULL OR e.effective_from <= l_per.date_to)
                   AND (e.effective_to IS NULL OR e.effective_to >= l_per.date_from)
                   AND (NOT EXISTS (SELECT 1 FROM prod.dct_pay_element_link k
                                    WHERE k.element_id = e.element_id AND k.is_active = 'Y')
                        OR EXISTS (SELECT 1 FROM prod.dct_pay_element_link k
                                   WHERE k.element_id = e.element_id AND k.is_active = 'Y'
                                     AND ((k.link_type = 'PAYROLL' AND k.link_value = l_pay.payroll_code)
                                       OR (k.link_type = 'COMPANY' AND k.link_value = l_comp.company_code)
                                       OR (k.link_type = 'GRADE' AND k.link_value = ce.grade_code)
                                       OR (k.link_type = 'PEOPLE_GROUP' AND k.link_value = ce.people_group)
                                       OR (k.link_type = 'EMPLOYEE' AND k.link_value = TO_CHAR(ce.person_id)))))
                 ORDER BY e.priority, e.element_id) LOOP
        l_amt := NULL; l_base := NULL; l_rate := NULL;

        IF el.calc_rule IN ('FLAT', 'QTY_RATE') THEN
          SELECT NVL(SUM(CASE WHEN el.calc_rule = 'FLAT' THEN NVL(en.amount, 0)
                              ELSE NVL(en.qty, 0) * NVL(en.rate, 0) END), 0)
          INTO l_amt
          FROM prod.dct_pay_element_entry en
          WHERE en.element_id = el.element_id AND en.person_id = ce.person_id
            AND en.is_active = 'Y'
            AND ((en.entry_type = 'RECURRING'
                  AND en.effective_from <= l_per.date_to
                  AND NVL(en.effective_to, l_per.date_to) >= l_per.date_from)
              OR (en.entry_type = 'ONETIME'
                  AND en.effective_from BETWEEN l_per.date_from AND l_per.date_to));
          IF el.prorate = 'Y' THEN
            l_amt := ROUND(l_amt * NVL(ce.days_factor, 0), 2);
          END IF;
        ELSIF el.calc_rule = 'PERCENT' THEN
          l_base := CASE NVL(el.calc_base, 'GROSS')
                      WHEN 'BASIC' THEN l_basic
                      WHEN 'NET' THEN l_gross - l_ded
                      ELSE l_gross END;
          l_rate := el.percent_value;
          l_amt := ROUND(l_base * NVL(l_rate, 0) / 100, 2);
        ELSIF el.calc_rule = 'RATE_TABLE' THEN
          BEGIN
            SELECT rr.ee_rate, rr.er_rate INTO l_ee, l_err
            FROM prod.dct_pay_rate_row rr
            WHERE rr.rate_table_id = el.rate_table_id
              AND rr.key_value = ce.nationality_code
              AND rr.is_active = 'Y'
              AND (rr.effective_from IS NULL OR rr.effective_from <= l_per.date_to)
              AND (rr.effective_to IS NULL OR rr.effective_to >= l_per.date_from)
            FETCH FIRST 1 ROWS ONLY;
          EXCEPTION WHEN NO_DATA_FOUND THEN l_ee := NULL; l_err := NULL;
          END;
          l_rate := CASE WHEN el.element_class = 'EMPLOYER_COST' THEN l_err ELSE l_ee END;
          IF l_rate IS NULL THEN
            l_amt := NULL;
          ELSE
            l_base := CASE NVL(el.calc_base, NVL(l_pay.pension_base, 'GROSS'))
                        WHEN 'BASIC' THEN l_basic
                        WHEN 'NET' THEN l_gross - l_ded
                        ELSE l_gross END;
            l_amt := ROUND(l_base * l_rate / 100, 2);
          END IF;
        END IF;

        IF l_amt IS NOT NULL AND l_amt <> 0 THEN
          INSERT INTO prod.dct_pay_run_line
                 (run_emp_id, element_id, element_code, element_class,
                  base_amount, rate_used, prorated, amount)
          VALUES (ce.run_emp_id, el.element_id, el.element_code, el.element_class,
                  l_base, l_rate, el.prorate, l_amt);
          IF el.element_class = 'EARNING' THEN
            l_gross := l_gross + l_amt;
            IF el.element_code IN ('BASIC', 'GROSS_SALARY') THEN
              l_basic := l_basic + l_amt;
            END IF;
          ELSIF el.element_class = 'DEDUCTION' THEN
            l_ded := l_ded + l_amt;
          ELSIF el.element_class = 'EMPLOYER_COST' THEN
            l_er := l_er + l_amt;
          END IF;
        END IF;
      END LOOP;

      UPDATE prod.dct_pay_run_emp
         SET gross = l_gross, deductions = l_ded, net = l_gross - l_ded, employer_cost = l_er
       WHERE run_emp_id = ce.run_emp_id;
    END LOOP;

    UPDATE prod.dct_pay_run r
       SET (total_gross, total_deductions, total_net, total_employer_cost) =
           (SELECT NVL(SUM(gross), 0), NVL(SUM(deductions), 0), NVL(SUM(net), 0),
                   NVL(SUM(employer_cost), 0)
            FROM prod.dct_pay_run_emp WHERE run_id = p_run_id),
           status = 'CALCULATED',
           calculated_at = SYSDATE, calculated_by = p_user,
           reviewed_at = NULL, reviewed_by = NULL,
           updated_by = p_user, updated_at = SYSDATE
     WHERE r.run_id = p_run_id;

    compute_charges(p_run_id, p_user);
  END;

  PROCEDURE set_run_emp_group (
    p_run_emp_id IN NUMBER, p_group_code IN NUMBER, p_user IN VARCHAR2) IS
    l_run_id NUMBER;
    l_person NUMBER;
    l_status VARCHAR2(20);
    l_company NUMBER;
    l_group_id NUMBER;
  BEGIN
    need_setup(p_user);
    IF p_group_code IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Group code is required');
    END IF;
    BEGIN
      SELECT re.run_id, re.person_id, r.status, p.company_id
      INTO l_run_id, l_person, l_status, l_company
      FROM prod.dct_pay_run_emp re
      JOIN prod.dct_pay_run r ON r.run_id = re.run_id
      JOIN prod.dct_pay_payroll p ON p.payroll_id = r.payroll_id
      WHERE re.run_emp_id = p_run_emp_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Run employee not found');
    END;
    IF l_status NOT IN ('LOADED', 'VALIDATED', 'CALCULATED') THEN
      RAISE_APPLICATION_ERROR(-20001, 'The invoice group can only change on a loaded, validated or calculated run');
    END IF;
    BEGIN
      SELECT group_id INTO l_group_id FROM prod.dct_pay_invoice_group
      WHERE company_id = l_company AND group_code = p_group_code AND is_active = 'Y';
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Invoice group not found for this company');
    END;
    UPDATE prod.dct_pay_run_emp
       SET invoice_group_code = p_group_code
     WHERE run_emp_id = p_run_emp_id;
    -- persist as an INCLUDE override so the next Load keeps the placement
    set_group_emp(l_group_id, l_person, 'INCLUDE', p_user);
    IF l_status = 'CALCULATED' THEN
      compute_charges(l_run_id, p_user);
    END IF;
  END;

  PROCEDURE act (p_run_id IN NUMBER, p_action IN VARCHAR2, p_user IN VARCHAR2) IS
    l_status VARCHAR2(20);
    l_period_status VARCHAR2(20);
  BEGIN
    need_run(p_user);
    BEGIN
      SELECT r.status, pe.status INTO l_status, l_period_status
      FROM prod.dct_pay_run r
      JOIN prod.dct_pay_period pe ON pe.period_id = r.period_id
      WHERE r.run_id = p_run_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20404, 'Run not found');
    END;
    IF l_period_status <> 'OPEN' THEN
      RAISE_APPLICATION_ERROR(-20001, 'The period of this run is closed');
    END IF;

    IF p_action = 'LOAD' THEN
      IF l_status = 'REVIEWED' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Reopen the run before reloading');
      END IF;
      load_run(p_run_id, p_user);
    ELSIF p_action = 'VALIDATE' THEN
      IF l_status NOT IN ('LOADED', 'VALIDATED', 'CALCULATED') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Load the run before validating');
      END IF;
      validate_run(p_run_id, p_user);
    ELSIF p_action = 'CALCULATE' THEN
      IF l_status NOT IN ('LOADED', 'VALIDATED', 'CALCULATED') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Load the run before calculating');
      END IF;
      calculate_run(p_run_id, p_user);
    ELSIF p_action = 'REVIEW' THEN
      IF l_status <> 'CALCULATED' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Only a calculated run can be reviewed');
      END IF;
      UPDATE prod.dct_pay_run
         SET status = 'REVIEWED', reviewed_at = SYSDATE, reviewed_by = p_user,
             updated_by = p_user, updated_at = SYSDATE
       WHERE run_id = p_run_id;
    ELSIF p_action = 'REOPEN' THEN
      DELETE FROM prod.dct_pay_run_charge WHERE run_id = p_run_id;
      DELETE FROM prod.dct_pay_run_emp WHERE run_id = p_run_id;
      UPDATE prod.dct_pay_run
         SET status = 'OPEN', emp_count = NULL, exception_count = NULL,
             total_gross = NULL, total_deductions = NULL, total_net = NULL,
             total_employer_cost = NULL, total_charges = NULL,
             loaded_at = NULL, loaded_by = NULL, validated_at = NULL, validated_by = NULL,
             calculated_at = NULL, calculated_by = NULL, reviewed_at = NULL, reviewed_by = NULL,
             updated_by = p_user, updated_at = SYSDATE
       WHERE run_id = p_run_id;
    ELSE
      RAISE_APPLICATION_ERROR(-20001, 'Unknown action: ' || p_action);
    END IF;
  END;

END dct_pay_calc_pkg;
/

SHOW ERRORS PACKAGE prod.dct_pay_calc_pkg
SHOW ERRORS PACKAGE BODY prod.dct_pay_calc_pkg

SELECT object_name, object_type, status FROM all_objects
WHERE owner = 'PROD' AND object_name = 'DCT_PAY_CALC_PKG';
