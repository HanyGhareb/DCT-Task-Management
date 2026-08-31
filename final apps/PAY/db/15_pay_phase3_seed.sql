-- =============================================================================
-- Outsource Payroll Module (App 215) -- Seed -- Phase 3 Payroll Setup
-- File    : 15_pay_phase3_seed.sql
-- Schema  : PROD (data only)
-- Run     : sql -name prod_mcp (UTF-8: JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8)
-- Notes   : Re-runnable (update-else-insert, no MERGE). Seeds the Phase 3
--           vocabularies, the three company payrolls with 2025-2026 calendars,
--           the seed elements with the GCC pension rate rows, the per-company
--           invoice groups observed on the real invoices, and backfills
--           payroll codes plus salary element entries from the Phase 2.1
--           assignment snapshots.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. LOOKUP CATEGORIES + VALUES
-- =============================================================================
DECLARE
    v_cat NUMBER;

    PROCEDURE up_cat (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
    BEGIN
        UPDATE prod.dct_lookup_categories
           SET category_name_en = p_en, category_name_ar = p_ar
         WHERE category_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_lookup_categories
                   (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
            VALUES (p_code, p_en, p_ar, NULL, 'Y', 'Y');
        END IF;
        SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
    END;

    PROCEDURE up_val (p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                      p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N') IS
    BEGIN
        UPDATE prod.dct_lookup_values
           SET value_name_en = p_en, value_name_ar = p_ar, display_order = p_ord
         WHERE category_id = p_cat AND value_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_lookup_values
                   (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
            VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_default, 'Y');
        END IF;
    END;
BEGIN
    up_cat('PAY_FREQUENCY', 'Payroll Frequency', 'دورية الرواتب', v_cat);
    up_val(v_cat, 'MONTHLY', 'Monthly', 'شهري', 10, 'Y');

    up_cat('PAY_PRORATION_BASIS', 'Proration Basis', 'أساس احتساب الجزء النسبي', v_cat);
    up_val(v_cat, 'FIXED_30',      'Fixed 30 days',  'ثلاثون يوماً ثابتة', 10, 'Y');
    up_val(v_cat, 'CALENDAR_DAYS', 'Calendar days',  'أيام تقويمية',       20);
    up_val(v_cat, 'WORKING_DAYS',  'Working days',   'أيام عمل',           30);

    up_cat('PAY_ELEMENT_CLASS', 'Payroll Element Class', 'فئة عنصر الراتب', v_cat);
    up_val(v_cat, 'EARNING',       'Earning',       'استحقاق',      10, 'Y');
    up_val(v_cat, 'DEDUCTION',     'Deduction',     'استقطاع',      20);
    up_val(v_cat, 'EMPLOYER_COST', 'Employer Cost', 'تكلفة صاحب العمل', 30);
    up_val(v_cat, 'INFORMATION',   'Information',   'معلوماتي',     40);

    up_cat('PAY_CALC_RULE', 'Element Calculation Rule', 'قاعدة احتساب العنصر', v_cat);
    up_val(v_cat, 'FLAT',       'Flat amount (entry)',     'مبلغ ثابت (إدخال)',   10, 'Y');
    up_val(v_cat, 'PERCENT',    'Percentage of base',      'نسبة من الأساس',      20);
    up_val(v_cat, 'RATE_TABLE', 'Rate table',              'جدول معدلات',         30);
    up_val(v_cat, 'QTY_RATE',   'Quantity times rate',     'كمية في معدل',        40);
    up_val(v_cat, 'FORMULA',    'Formula (not enabled)',   'معادلة (غير مفعل)',   50);

    up_cat('PAY_CALC_BASE', 'Calculation Base', 'أساس الاحتساب', v_cat);
    up_val(v_cat, 'BASIC', 'Basic salary',   'الراتب الأساسي', 10);
    up_val(v_cat, 'GROSS', 'Gross earnings', 'إجمالي الراتب',  20, 'Y');
    up_val(v_cat, 'NET',   'Net pay',        'صافي الراتب',    30);

    up_cat('PAY_ENTRY_TYPE', 'Element Entry Type', 'نوع إدخال العنصر', v_cat);
    up_val(v_cat, 'RECURRING', 'Recurring', 'متكرر',      10, 'Y');
    up_val(v_cat, 'ONETIME',   'One time',  'لمرة واحدة', 20);

    up_cat('PAY_LINK_TYPE', 'Element Eligibility Link', 'رابط أهلية العنصر', v_cat);
    up_val(v_cat, 'COMPANY',      'Company',      'الشركة',          10);
    up_val(v_cat, 'PAYROLL',      'Payroll',      'كشف الرواتب',     20, 'Y');
    up_val(v_cat, 'GRADE',        'Grade',        'الدرجة',          30);
    up_val(v_cat, 'PEOPLE_GROUP', 'People group', 'مجموعة الموظفين', 40);
    up_val(v_cat, 'EMPLOYEE',     'Employee',     'الموظف',          50);

    up_cat('PAY_RUN_TYPE', 'Payroll Run Type', 'نوع تشغيل الرواتب', v_cat);
    up_val(v_cat, 'REGULAR',    'Regular',            'اعتيادي',  10, 'Y');
    up_val(v_cat, 'OFFCYCLE',   'Off-cycle (P6)',     'خارج الدورة (م6)', 20);
    up_val(v_cat, 'RETRO',      'Retroactive (P6)',   'بأثر رجعي (م6)',   30);
    up_val(v_cat, 'CORRECTION', 'Correction (P6)',    'تصحيح (م6)',       40);
    up_val(v_cat, 'REVERSAL',   'Reversal (P6)',      'عكس قيد (م6)',     50);

    up_cat('PAY_RUN_STATUS', 'Payroll Run Status', 'حالة تشغيل الرواتب', v_cat);
    up_val(v_cat, 'OPEN',       'Open',       'مفتوح',   10, 'Y');
    up_val(v_cat, 'LOADED',     'Loaded',     'محمّل',   20);
    up_val(v_cat, 'VALIDATED',  'Validated',  'مدقق',    30);
    up_val(v_cat, 'CALCULATED', 'Calculated', 'محتسب',   40);
    up_val(v_cat, 'REVIEWED',   'Reviewed',   'مراجع',   50);
    up_val(v_cat, 'ERROR',      'Error',      'خطأ',     60);

    up_cat('PAY_PERIOD_STATUS', 'Payroll Period Status', 'حالة الفترة', v_cat);
    up_val(v_cat, 'OPEN',   'Open',   'مفتوحة', 10, 'Y');
    up_val(v_cat, 'CLOSED', 'Closed', 'مغلقة',  20);

    up_cat('PAY_CHARGE_TYPE', 'Company Charge Type', 'نوع رسوم الشركة', v_cat);
    up_val(v_cat, 'MARGIN', 'Contract margin', 'هامش العقد',      10, 'Y');
    up_val(v_cat, 'FEE',    'Service fee',     'رسوم خدمة',       20);
    up_val(v_cat, 'VAT',    'VAT',             'ضريبة القيمة المضافة', 30);

    DBMS_OUTPUT.put_line('lookups seeded');
END;
/

-- =============================================================================
-- 2. PENSION RATE TABLE (employee rates from the Reach sheet; employer rates
--    stay NULL = contribute 0 until Finance confirms the split)
-- =============================================================================
DECLARE
    v_id NUMBER;
    n    NUMBER;

    PROCEDURE up_row (p_key VARCHAR2, p_ee NUMBER) IS
        m NUMBER;
    BEGIN
        SELECT COUNT(*) INTO m FROM prod.dct_pay_rate_row
        WHERE rate_table_id = v_id AND key_value = p_key;
        IF m = 0 THEN
            INSERT INTO prod.dct_pay_rate_row (rate_table_id, key_value, ee_rate, er_rate, created_by)
            VALUES (v_id, p_key, p_ee, NULL, 'PAY_P3_SEED');
        ELSE
            UPDATE prod.dct_pay_rate_row SET ee_rate = p_ee
            WHERE rate_table_id = v_id AND key_value = p_key;
        END IF;
    END;
BEGIN
    SELECT COUNT(*) INTO n FROM prod.dct_pay_rate_table WHERE table_code = 'PENSION_GCC';
    IF n = 0 THEN
        INSERT INTO prod.dct_pay_rate_table (table_code, name_en, name_ar, key_type, created_by)
        VALUES ('PENSION_GCC', 'GCC Pension Rates', 'معدلات التقاعد الخليجية', 'NATIONALITY', 'PAY_P3_SEED');
    END IF;
    SELECT rate_table_id INTO v_id FROM prod.dct_pay_rate_table WHERE table_code = 'PENSION_GCC';
    up_row('AE', 5);
    up_row('SA', 9);
    up_row('OM', 7.5);
    DBMS_OUTPUT.put_line('pension rate table seeded');
END;
/

-- =============================================================================
-- 3. PAYROLLS (one monthly AED payroll per company) + 2025-2026 CALENDARS
-- =============================================================================
DECLARE
    PROCEDURE up_payroll (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_company VARCHAR2) IS
        v_cid NUMBER;
        n     NUMBER;
    BEGIN
        SELECT company_id INTO v_cid FROM prod.dct_pay_company WHERE company_code = p_company;
        SELECT COUNT(*) INTO n FROM prod.dct_pay_payroll WHERE payroll_code = p_code;
        IF n = 0 THEN
            INSERT INTO prod.dct_pay_payroll
                   (payroll_code, name_en, name_ar, company_id, cutoff_day, pay_day, created_by)
            VALUES (p_code, p_en, p_ar, v_cid, 20, 28, 'PAY_P3_SEED');
        END IF;
    END;

    PROCEDURE gen_year (p_code VARCHAR2, p_year NUMBER) IS
        v_pid NUMBER;
        v_from DATE;
        n NUMBER;
    BEGIN
        SELECT payroll_id INTO v_pid FROM prod.dct_pay_payroll WHERE payroll_code = p_code;
        FOR m IN 1..12 LOOP
            v_from := TO_DATE(LPAD(m, 2, '0') || '-' || p_year, 'MM-YYYY');
            SELECT COUNT(*) INTO n FROM prod.dct_pay_period
            WHERE payroll_id = v_pid AND period_code = TO_CHAR(v_from, 'MM-YYYY');
            IF n = 0 THEN
                INSERT INTO prod.dct_pay_period
                       (payroll_id, period_code, date_from, date_to, cutoff_date, pay_date, created_by)
                VALUES (v_pid, TO_CHAR(v_from, 'MM-YYYY'), v_from, LAST_DAY(v_from),
                        v_from + 19, LEAST(v_from + 27, LAST_DAY(v_from)), 'PAY_P3_SEED');
            END IF;
        END LOOP;
    END;
BEGIN
    up_payroll('ALN_MONTHLY',    'Al Nahiya Monthly Payroll', 'رواتب الناهية الشهرية', 'ALN');
    up_payroll('DAYTON_MONTHLY', 'Dayton Monthly Payroll',    'رواتب دايتون الشهرية',  'DAYTON');
    up_payroll('REACH_MONTHLY',  'Reach Monthly Payroll',     'رواتب ريتش الشهرية',    'REACH');
    gen_year('ALN_MONTHLY', 2025);    gen_year('ALN_MONTHLY', 2026);
    gen_year('DAYTON_MONTHLY', 2025); gen_year('DAYTON_MONTHLY', 2026);
    gen_year('REACH_MONTHLY', 2025);  gen_year('REACH_MONTHLY', 2026);
    DBMS_OUTPUT.put_line('payrolls + calendars seeded');
END;
/

-- =============================================================================
-- 4. SEED ELEMENTS + ELIGIBILITY LINKS
-- =============================================================================
DECLARE
    v_rt NUMBER;

    PROCEDURE up_el (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_class VARCHAR2,
                     p_rule VARCHAR2, p_base VARCHAR2, p_prio NUMBER, p_prorate VARCHAR2,
                     p_recurring VARCHAR2 DEFAULT 'Y', p_rtid NUMBER DEFAULT NULL) IS
        n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO n FROM prod.dct_pay_element WHERE element_code = p_code;
        IF n = 0 THEN
            INSERT INTO prod.dct_pay_element
                   (element_code, name_en, name_ar, element_class, calc_rule, calc_base,
                    rate_table_id, priority, prorate, recurring, created_by)
            VALUES (p_code, p_en, p_ar, p_class, p_rule, p_base,
                    p_rtid, p_prio, p_prorate, p_recurring, 'PAY_P3_SEED');
        END IF;
    END;

    PROCEDURE up_link (p_el VARCHAR2, p_type VARCHAR2, p_value VARCHAR2) IS
        v_eid NUMBER;
        n NUMBER;
    BEGIN
        SELECT element_id INTO v_eid FROM prod.dct_pay_element WHERE element_code = p_el;
        SELECT COUNT(*) INTO n FROM prod.dct_pay_element_link
        WHERE element_id = v_eid AND link_type = p_type AND link_value = p_value;
        IF n = 0 THEN
            INSERT INTO prod.dct_pay_element_link (element_id, link_type, link_value, created_by)
            VALUES (v_eid, p_type, p_value, 'PAY_P3_SEED');
        END IF;
    END;
BEGIN
    SELECT rate_table_id INTO v_rt FROM prod.dct_pay_rate_table WHERE table_code = 'PENSION_GCC';

    up_el('BASIC',         'Basic Salary',            'الراتب الأساسي',        'EARNING',       'FLAT',       NULL,    10, 'Y');
    up_el('GROSS_SALARY',  'Gross Salary (lump)',     'إجمالي الراتب (مقطوع)', 'EARNING',       'FLAT',       NULL,    15, 'Y');
    up_el('ALLOWANCE',     'Other Allowance',         'بدلات أخرى',            'EARNING',       'FLAT',       NULL,    20, 'Y');
    up_el('ARREARS_ADJ',   'Arrears / Adjustment',    'فروقات / تسوية',        'EARNING',       'FLAT',       NULL,    30, 'N', 'N');
    up_el('PENSION_EE',    'Pension - Employee',      'التقاعد - حصة الموظف',  'DEDUCTION',     'RATE_TABLE', 'GROSS', 50, 'N', 'Y', v_rt);
    up_el('DEDUCTION_ADJ', 'Deduction / Recovery',    'استقطاع / استرداد',     'DEDUCTION',     'FLAT',       NULL,    55, 'N', 'N');
    up_el('PENSION_ER',    'Pension - Employer',      'التقاعد - حصة صاحب العمل', 'EMPLOYER_COST', 'RATE_TABLE', 'GROSS', 60, 'N', 'Y', v_rt);

    -- pension observed on the Reach payroll only; expand by adding links (data change)
    up_link('PENSION_EE', 'PAYROLL', 'REACH_MONTHLY');
    up_link('PENSION_ER', 'PAYROLL', 'REACH_MONTHLY');

    DBMS_OUTPUT.put_line('elements + links seeded');
END;
/

-- =============================================================================
-- 5. INVOICE GROUPS (from the real ALN December invoices 61302-61305;
--    Dayton and Reach invoice as a single group)
-- =============================================================================
DECLARE
    PROCEDURE up_grp (p_company VARCHAR2, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                      p_ord NUMBER, p_default VARCHAR2) IS
        v_cid NUMBER;
        n NUMBER;
    BEGIN
        SELECT company_id INTO v_cid FROM prod.dct_pay_company WHERE company_code = p_company;
        SELECT COUNT(*) INTO n FROM prod.dct_pay_invoice_group
        WHERE company_id = v_cid AND group_code = p_code;
        IF n = 0 THEN
            INSERT INTO prod.dct_pay_invoice_group
                   (company_id, group_code, name_en, name_ar, display_order, is_default, created_by)
            VALUES (v_cid, p_code, p_en, p_ar, p_ord, p_default, 'PAY_P3_SEED');
        END IF;
    END;

    PROCEDURE up_sec (p_company VARCHAR2, p_code VARCHAR2, p_sector VARCHAR2) IS
        v_gid NUMBER;
        n NUMBER;
    BEGIN
        SELECT g.group_id INTO v_gid
        FROM prod.dct_pay_invoice_group g
        JOIN prod.dct_pay_company c ON c.company_id = g.company_id
        WHERE c.company_code = p_company AND g.group_code = p_code;
        SELECT COUNT(*) INTO n FROM prod.dct_pay_invoice_group_sector
        WHERE group_id = v_gid AND sector_name = p_sector;
        IF n = 0 THEN
            INSERT INTO prod.dct_pay_invoice_group_sector (group_id, sector_name, created_by)
            VALUES (v_gid, p_sector, 'PAY_P3_SEED');
        END IF;
    END;
BEGIN
    up_grp('ALN', 'ADALC',      'Abu Dhabi Arabic Language Centre', 'مركز أبوظبي للغة العربية', 10, 'N');
    up_grp('ALN', 'CUL_OU_TOU', 'Culture, Undersecretary & Tourism', 'الثقافة والوكيل والسياحة', 20, 'N');
    up_grp('ALN', 'SA_SMC_SS',  'Strategic Affairs, Marketing & Support', 'الشؤون الاستراتيجية والتسويق والدعم', 30, 'Y');
    up_grp('ALN', 'GAMING',     'Gaming & Digital Development', 'الألعاب والتطوير الرقمي', 40, 'N');
    up_sec('ALN', 'ADALC',      'Abu Dhabi Arabic Language Centre');
    up_sec('ALN', 'CUL_OU_TOU', 'Culture');
    up_sec('ALN', 'CUL_OU_TOU', 'Office Of Undersecretary');
    up_sec('ALN', 'CUL_OU_TOU', 'Tourism');
    up_sec('ALN', 'SA_SMC_SS',  'Strategic Affairs');
    up_sec('ALN', 'SA_SMC_SS',  'Strategic Marketing & Communication');
    up_sec('ALN', 'SA_SMC_SS',  'Support Services');
    up_sec('ALN', 'SA_SMC_SS',  'Louvre Abu Dhabi');
    up_sec('ALN', 'SA_SMC_SS',  'Office of Chairman');
    up_sec('ALN', 'GAMING',     'Gaming & Digital Development');
    up_grp('DAYTON', 'MAIN', 'Dayton - All Sectors', 'دايتون - جميع القطاعات', 10, 'Y');
    up_grp('REACH',  'MAIN', 'Reach - All Sectors',  'ريتش - جميع القطاعات',  10, 'Y');
    DBMS_OUTPUT.put_line('invoice groups seeded');
END;
/

-- =============================================================================
-- 6. BACKFILL payroll_code ON ASSIGNMENTS + SALARY ELEMENT ENTRIES FROM THE
--    PHASE 2.1 SNAPSHOTS (idempotent; entries only where none exist yet)
-- =============================================================================
DECLARE
    v_n NUMBER := 0;

    PROCEDURE fill_payroll (p_company VARCHAR2, p_code VARCHAR2) IS
    BEGIN
        UPDATE prod.dct_pay_assignment a
           SET a.payroll_code = p_code
         WHERE a.payroll_code IS NULL
           AND a.company_id = (SELECT company_id FROM prod.dct_pay_company WHERE company_code = p_company);
        v_n := v_n + SQL%ROWCOUNT;
    END;
BEGIN
    fill_payroll('ALN',    'ALN_MONTHLY');
    fill_payroll('DAYTON', 'DAYTON_MONTHLY');
    fill_payroll('REACH',  'REACH_MONTHLY');
    DBMS_OUTPUT.put_line('payroll_code backfilled on ' || v_n || ' assignments');
END;
/

DECLARE
    v_basic NUMBER;
    v_allow NUMBER;
    v_gross NUMBER;
    v_cnt   NUMBER := 0;

    PROCEDURE add_entry (p_el NUMBER, p_person NUMBER, p_asg NUMBER, p_amt NUMBER, p_from DATE) IS
        n NUMBER;
    BEGIN
        IF p_amt IS NULL OR p_amt = 0 THEN RETURN; END IF;
        SELECT COUNT(*) INTO n FROM prod.dct_pay_element_entry
        WHERE element_id = p_el AND person_id = p_person AND is_active = 'Y';
        IF n = 0 THEN
            INSERT INTO prod.dct_pay_element_entry
                   (element_id, person_id, assignment_id, entry_type, amount, effective_from, created_by)
            VALUES (p_el, p_person, p_asg, 'RECURRING', p_amt, p_from, 'PAY_P3_SEED');
            v_cnt := v_cnt + 1;
        END IF;
    END;
BEGIN
    SELECT element_id INTO v_basic FROM prod.dct_pay_element WHERE element_code = 'BASIC';
    SELECT element_id INTO v_allow FROM prod.dct_pay_element WHERE element_code = 'ALLOWANCE';
    SELECT element_id INTO v_gross FROM prod.dct_pay_element WHERE element_code = 'GROSS_SALARY';

    FOR a IN (SELECT a.assignment_id, a.person_id, a.effective_from,
                     a.basic_salary, a.allowance_amount, a.gross_salary
              FROM prod.dct_pay_assignment a
              WHERE a.status = 'ACTIVE' AND a.assignment_type = 'PRIMARY') LOOP
        IF NVL(a.basic_salary, 0) > 0 THEN
            add_entry(v_basic, a.person_id, a.assignment_id, a.basic_salary, a.effective_from);
            add_entry(v_allow, a.person_id, a.assignment_id, a.allowance_amount, a.effective_from);
        ELSIF NVL(a.gross_salary, 0) > 0 THEN
            add_entry(v_gross, a.person_id, a.assignment_id, a.gross_salary, a.effective_from);
        END IF;
    END LOOP;
    DBMS_OUTPUT.put_line('salary entries backfilled: ' || v_cnt);
END;
/

COMMIT;

SELECT (SELECT COUNT(*) FROM prod.dct_pay_payroll)       AS payrolls,
       (SELECT COUNT(*) FROM prod.dct_pay_period)        AS periods,
       (SELECT COUNT(*) FROM prod.dct_pay_element)       AS elements,
       (SELECT COUNT(*) FROM prod.dct_pay_element_entry) AS entries,
       (SELECT COUNT(*) FROM prod.dct_pay_invoice_group) AS inv_groups,
       (SELECT COUNT(*) FROM prod.dct_pay_assignment WHERE payroll_code IS NOT NULL) AS asg_with_payroll
FROM dual;
