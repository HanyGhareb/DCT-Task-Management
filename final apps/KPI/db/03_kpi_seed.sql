-- =============================================================================
-- Finance KPI Management Module (App 213) -- Seed Data
-- File    : 03_kpi_seed.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @03_kpi_seed.sql   (after 01 + 02)
-- Safe    : Idempotent -- update-first upserts everywhere (no merge statements;
--           Linux SQLcl silently swallows them). Re-run refreshes seed text but
--           preserves admin-changed setting values and never deletes rows that
--           results may reference.
-- Seeds   : lookup sets, module row (App 213), roles + permissions, module
--           settings, evidence document type, auto-source registry, and the
--           full DOF circular content: 4 KPI definitions, score bands,
--           weighted criteria + maturity levels, yearly targets (EN + AR).
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. LOOKUP CATEGORIES + VALUES  (lookup-first vocabularies)
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
    up_cat('KPI_TYPE', 'KPI Type', 'نوع المؤشر', v_cat);
    up_val(v_cat, 'STRATEGIC',   'Strategic',   'استراتيجي', 10, 'Y');
    up_val(v_cat, 'OPERATIONAL', 'Operational', 'تشغيلي',    20);

    up_cat('KPI_POLARITY', 'KPI Polarity', 'اتجاه المؤشر', v_cat);
    up_val(v_cat, 'ASCENDING',  'Ascending (higher is better)',  'تصاعدي (الأعلى أفضل)',  10, 'Y');
    up_val(v_cat, 'DESCENDING', 'Descending (lower is better)',  'تنازلي (الأدنى أفضل)',  20);

    up_cat('KPI_FREQUENCY', 'KPI Measurement Frequency', 'دورية قياس المؤشر', v_cat);
    up_val(v_cat, 'ANNUAL',    'Annually',  'سنوي',  10, 'Y');
    up_val(v_cat, 'QUARTERLY', 'Quarterly', 'ربع سنوي', 20);
    up_val(v_cat, 'MIXED',     'Mixed',     'مختلط', 30);

    up_cat('KPI_CALC_METHOD', 'KPI Calculation Method', 'طريقة احتساب المؤشر', v_cat);
    up_val(v_cat, 'RATIO_A_OVER_B',    'Ratio (A over B) x 100',        'نسبة (أ على ب) × 100',       10);
    up_val(v_cat, 'ABS_VARIANCE',      'Absolute variance from plan',   'الانحراف المطلق عن الخطة',   20);
    up_val(v_cat, 'WEIGHTED_CRITERIA', 'Weighted assessment criteria',  'معايير تقييم موزونة',        30);

    up_cat('KPI_BAND_OP', 'KPI Score Band Operator', 'معامل نطاق الدرجة', v_cat);
    up_val(v_cat, 'LT',      'Less than',             'أقل من',            10);
    up_val(v_cat, 'LE',      'Less than or equal',    'أقل من أو يساوي',   20);
    up_val(v_cat, 'EQ',      'Equal to',              'يساوي',             30);
    up_val(v_cat, 'GE',      'Greater than or equal', 'أكبر من أو يساوي',  40);
    up_val(v_cat, 'GT',      'Greater than',          'أكبر من',           50);
    up_val(v_cat, 'BETWEEN', 'Between (inclusive)',   'بين (شامل)',        60);

    up_cat('KPI_CRIT_ENTRY', 'KPI Criterion Entry Type', 'نوع إدخال المعيار', v_cat);
    up_val(v_cat, 'MATURITY_1_5',  'Maturity level 1 to 5', 'مستوى نضج من 1 إلى 5', 10);
    up_val(v_cat, 'PERCENT_0_100', 'Achievement percentage', 'نسبة إنجاز مئوية',    20);

    up_cat('KPI_VALUE_SOURCE', 'KPI Figure Source', 'مصدر قيمة المؤشر', v_cat);
    up_val(v_cat, 'AUTO',   'System computed', 'محتسب آليًا', 10);
    up_val(v_cat, 'MANUAL', 'Manually entered', 'مدخل يدويًا', 20, 'Y');

    up_cat('KPI_RESULT_STATUS', 'KPI Result Status', 'حالة نتيجة المؤشر', v_cat);
    up_val(v_cat, 'DRAFT',     'Draft',              'مسودة',          10, 'Y');
    up_val(v_cat, 'SUBMITTED', 'Submitted',          'مقدم للاعتماد',  20);
    up_val(v_cat, 'APPROVED',  'Approved',           'معتمد',          30);
    up_val(v_cat, 'RETURNED',  'Returned for rework', 'معاد للتعديل',  40);

    up_cat('KPI_PERIOD_TYPE', 'KPI Period Type', 'نوع الفترة', v_cat);
    up_val(v_cat, 'ANNUAL',  'Annual',  'سنوي',     10, 'Y');
    up_val(v_cat, 'QUARTER', 'Quarter', 'ربع سنة',  20);

    up_cat('KPI_PERIOD_STATUS', 'KPI Period Status', 'حالة الفترة', v_cat);
    up_val(v_cat, 'OPEN',   'Open',   'مفتوحة', 10, 'Y');
    up_val(v_cat, 'CLOSED', 'Closed', 'مغلقة',  20);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookup sets seeded: 10 KPI_* categories');
END;
/

-- =============================================================================
-- 2. MODULE REGISTRATION -- DCT_MODULES (App 213)
-- =============================================================================
DECLARE
    v_n NUMBER;
BEGIN
    UPDATE prod.dct_modules
       SET module_name_en = 'Finance KPIs',
           module_name_ar = 'مؤشرات الأداء المالية',
           apex_app_id    = 213,
           icon_class     = 'fa-gauge-high',
           icon_color     = '#8C6D1F',
           bg_color       = '#F5EFDF',
           description_en = 'Manage the DOF unified financial KPIs: definitions, periodic results, evidence, approvals, scorecard and reports.',
           description_ar = 'إدارة مؤشرات الأداء المالية الموحدة لدائرة المالية: التعريفات والنتائج الدورية والمستندات والاعتمادات ولوحة النتائج والتقارير.',
           category       = 'FINANCE',
           is_active      = 'Y'
     WHERE module_code = 'KPI_MGMT';
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO prod.dct_modules
               (module_code, module_name_en, module_name_ar, module_type, apex_app_id,
                apex_page_id, icon_class, icon_color, bg_color,
                description_en, description_ar, category, display_order,
                is_active, is_new_tab, is_admin_only)
        VALUES ('KPI_MGMT', 'Finance KPIs', 'مؤشرات الأداء المالية', 'APEX_APP', 213,
                1, 'fa-gauge-high', '#8C6D1F', '#F5EFDF',
                'Manage the DOF unified financial KPIs: definitions, periodic results, evidence, approvals, scorecard and reports.',
                'إدارة مؤشرات الأداء المالية الموحدة لدائرة المالية: التعريفات والنتائج الدورية والمستندات والاعتمادات ولوحة النتائج والتقارير.',
                'FINANCE', 75, 'Y', 'N', 'N');
    END IF;
    SELECT COUNT(*) INTO v_n FROM prod.dct_modules WHERE module_code = 'KPI_MGMT';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Module registered: KPI_MGMT (App 213), rows=' || v_n);
END;
/

-- =============================================================================
-- 3. SYSTEM ROLES + PERMISSIONS -- KPI_ADMIN, KPI_USER, KPI_FIN_DIRECTOR
-- =============================================================================
DECLARE
    v_module_id  prod.dct_modules.module_id%TYPE;
    v_admin_role NUMBER;
    v_user_role  NUMBER;
    v_dir_role   NUMBER;

    PROCEDURE up_role (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_desc VARCHAR2,
                       p_ord NUMBER, o_id OUT NUMBER) IS
    BEGIN
        UPDATE prod.dct_roles
           SET role_name_en = p_en, role_name_ar = p_ar,
               description_en = p_desc, is_active = 'Y'
         WHERE role_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_roles
                   (role_code, role_name_en, role_name_ar, role_type, module_id,
                    description_en, is_active, is_system_role, display_order)
            VALUES (p_code, p_en, p_ar, 'MODULE', v_module_id, p_desc, 'Y', 'N', p_ord);
        END IF;
        SELECT role_id INTO o_id FROM prod.dct_roles WHERE role_code = p_code;
    END;

    PROCEDURE grant_perm (p_role_id NUMBER, p_code VARCHAR2, p_name VARCHAR2, p_action VARCHAR2) IS
        l_perm_id NUMBER;
    BEGIN
        UPDATE prod.dct_permissions
           SET permission_name = p_name, action_type = p_action
         WHERE permission_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_permissions
                   (permission_code, permission_name, module_id, action_type, is_active)
            VALUES (p_code, p_name, v_module_id, p_action, 'Y');
        END IF;
        SELECT permission_id INTO l_perm_id FROM prod.dct_permissions WHERE permission_code = p_code;
        BEGIN
            INSERT INTO prod.dct_role_permissions (role_id, permission_id, granted_by)
            VALUES (p_role_id, l_perm_id, 'SEED');
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'KPI_MGMT';

    up_role('KPI_ADMIN', 'Finance KPI Admin', 'مسؤول مؤشرات الأداء المالية',
            'Configure KPI definitions, score bands, criteria, targets and sources; manage periods and view all results.', 10, v_admin_role);
    up_role('KPI_USER', 'Finance KPI User', 'مستخدم مؤشرات الأداء المالية',
            'Access the Finance KPI module; prepare and submit KPI results with evidence.', 20, v_user_role);
    up_role('KPI_FIN_DIRECTOR', 'Finance Director (KPI Approver)', 'مدير المالية (معتمد المؤشرات)',
            'Final approver of KPI results in the KPI approval workflow.', 30, v_dir_role);

    grant_perm(v_admin_role, 'KPI.MANAGE_DEFS',   'Manage KPI definitions and scoring', 'CONFIGURE');
    grant_perm(v_admin_role, 'KPI.MANAGE_PERIODS','Manage KPI measurement periods',     'CONFIGURE');
    grant_perm(v_admin_role, 'KPI.VIEW_ALL',      'View all KPI results and dashboards','VIEW');
    grant_perm(v_admin_role, 'KPI.RUN_REPORTS',   'Run KPI briefing book reports',      'VIEW');
    grant_perm(v_user_role,  'KPI.ACCESS',        'View the Finance KPI module',        'VIEW');
    grant_perm(v_user_role,  'KPI.PREPARE',       'Edit and submit KPI results',        'EDIT');
    grant_perm(v_dir_role,   'KPI.APPROVE',       'Approve KPI results',                'APPROVE');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('System roles seeded: KPI_ADMIN, KPI_USER, KPI_FIN_DIRECTOR (+7 permissions)');
END;
/

-- =============================================================================
-- 4. MODULE SETTINGS -- upload cap for evidence files
-- =============================================================================
DECLARE
    v_module_id prod.dct_modules.module_id%TYPE;

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
    SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'KPI_MGMT';

    put_setting('MAX_UPLOAD_MB', '10', 'Max Evidence Upload (MB)',
        'Maximum size in megabytes of a single KPI evidence file upload.', 'NUMBER', NULL, '10');
    put_setting('SCORECARD_BASE_YEAR', TO_CHAR(EXTRACT(YEAR FROM SYSDATE)), 'Scorecard Default Year',
        'Default budget year preselected on the KPI scorecard dashboard.', 'NUMBER', NULL, TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Module settings seeded');
END;
/

-- =============================================================================
-- 5. EVIDENCE DOCUMENT TYPE -- DCT_DOCUMENT_TYPES
-- =============================================================================
DECLARE
BEGIN
    UPDATE prod.dct_document_types
       SET applies_to_modules = 'KPI'
     WHERE doc_type_code = 'KPI_EVIDENCE';
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO prod.dct_document_types
               (doc_type_code, doc_type_name_en, doc_type_name_ar, doc_category,
                applies_to_modules, has_expiry, expiry_alert_days, display_order)
        VALUES ('KPI_EVIDENCE', 'KPI Evidence Document', 'مستند إثبات مؤشر أداء', 'OTHER',
                'KPI', 'N', 0, 300);
    END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Document type seeded: KPI_EVIDENCE');
END;
/

-- =============================================================================
-- 6. AUTO-FIGURE SOURCE REGISTRY -- DCT_KPI_SOURCES
-- =============================================================================
DECLARE
    PROCEDURE up_src (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_desc VARCHAR2, p_active VARCHAR2) IS
    BEGIN
        UPDATE prod.dct_kpi_sources
           SET name_en = p_en, name_ar = p_ar, description_en = p_desc,
               is_active = p_active, updated_by = 'SEED', updated_at = SYSDATE
         WHERE source_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_kpi_sources
                   (source_code, name_en, name_ar, description_en, is_active, created_by)
            VALUES (p_code, p_en, p_ar, p_desc, p_active, 'SEED');
        END IF;
    END;
BEGIN
    up_src('GL_REVENUE_ACTUAL_YEAR',
           'GL revenue actuals - measurement year', 'إيرادات دفتر الأستاذ - سنة القياس',
           'Full-year revenue actuals from the Fusion-loaded GL balances for the period year. Account scope is configured on this row; when no scope is set the suggestion is empty and the figure is entered manually.', 'Y');
    up_src('GL_REVENUE_ACTUAL_PRIOR_YEAR',
           'GL revenue actuals - prior year', 'إيرادات دفتر الأستاذ - السنة السابقة',
           'Full-year revenue actuals from the Fusion-loaded GL balances for the year before the period year.', 'Y');
    up_src('FUSION_ACTUAL_QTR',
           'Fusion actual expenditure - quarter', 'المصروفات الفعلية من فيوجن - ربع السنة',
           'Quarterly actual operating expenditure (chapters excluding capital projects) from the platform actuals fact.', 'Y');
    up_src('EPM_FORECAST_QTR',
           'EPM forecasted cash flow - quarter', 'التدفق النقدي المتوقع من نظام التخطيط - ربع السنة',
           'Quarterly forecasted cash flow from EPM. No EPM feed exists in the platform yet, so this source returns no suggestion and the figure is entered manually.', 'N');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Auto-figure sources seeded: 4');
END;
/

-- =============================================================================
-- 7. THE FOUR DOF CIRCULAR KPIS -- definitions, bands, criteria, levels, targets
-- =============================================================================
DECLARE
    v_kpi  NUMBER;
    v_crit NUMBER;

    PROCEDURE up_kpi (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                      p_desc_en VARCHAR2, p_desc_ar VARCHAR2,
                      p_polarity VARCHAR2, p_unit_en VARCHAR2, p_unit_ar VARCHAR2,
                      p_freq VARCHAR2, p_method VARCHAR2,
                      p_calc_en VARCHAR2, p_calc_ar VARCHAR2,
                      p_srcdata_en VARCHAR2, p_srcdata_ar VARCHAR2,
                      p_note_en VARCHAR2, p_note_ar VARCHAR2,
                      p_src_a VARCHAR2, p_src_b VARCHAR2,
                      p_fa_en VARCHAR2, p_fa_ar VARCHAR2,
                      p_fb_en VARCHAR2, p_fb_ar VARCHAR2,
                      p_evidence VARCHAR2, p_ord NUMBER, o_id OUT NUMBER) IS
    BEGIN
        UPDATE prod.dct_kpi_definitions
           SET name_en = p_en, name_ar = p_ar,
               description_en = p_desc_en, description_ar = p_desc_ar,
               kpi_type = 'STRATEGIC', polarity = p_polarity,
               unit_en = p_unit_en, unit_ar = p_unit_ar,
               frequency = p_freq, calc_method = p_method,
               calc_desc_en = p_calc_en, calc_desc_ar = p_calc_ar,
               source_of_data_en = p_srcdata_en, source_of_data_ar = p_srcdata_ar,
               kpi_owner_en = 'Department of Finance', kpi_owner_ar = 'دائرة المالية',
               note_en = p_note_en, note_ar = p_note_ar,
               source_code_a = p_src_a, source_code_b = p_src_b,
               figure_a_label_en = p_fa_en, figure_a_label_ar = p_fa_ar,
               figure_b_label_en = p_fb_en, figure_b_label_ar = p_fb_ar,
               requires_evidence = p_evidence, display_order = p_ord,
               is_active = 'Y', updated_by = 'SEED', updated_at = SYSDATE
         WHERE kpi_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_kpi_definitions
                   (kpi_code, name_en, name_ar, description_en, description_ar,
                    kpi_type, polarity, unit_en, unit_ar, frequency, calc_method,
                    calc_desc_en, calc_desc_ar, source_of_data_en, source_of_data_ar,
                    kpi_owner_en, kpi_owner_ar, note_en, note_ar,
                    source_code_a, source_code_b,
                    figure_a_label_en, figure_a_label_ar, figure_b_label_en, figure_b_label_ar,
                    requires_evidence, display_order, created_by)
            VALUES (p_code, p_en, p_ar, p_desc_en, p_desc_ar,
                    'STRATEGIC', p_polarity, p_unit_en, p_unit_ar, p_freq, p_method,
                    p_calc_en, p_calc_ar, p_srcdata_en, p_srcdata_ar,
                    'Department of Finance', 'دائرة المالية', p_note_en, p_note_ar,
                    p_src_a, p_src_b,
                    p_fa_en, p_fa_ar, p_fb_en, p_fb_ar,
                    p_evidence, p_ord, 'SEED');
        END IF;
        SELECT kpi_id INTO o_id FROM prod.dct_kpi_definitions WHERE kpi_code = p_code;
    END;

    PROCEDURE up_band (p_kpi NUMBER, p_score NUMBER, p_op VARCHAR2,
                       p_t1 NUMBER, p_t2 NUMBER, p_en VARCHAR2, p_ar VARCHAR2) IS
    BEGIN
        UPDATE prod.dct_kpi_score_bands
           SET operator = p_op, threshold_1 = p_t1, threshold_2 = p_t2,
               label_en = p_en, label_ar = p_ar
         WHERE kpi_id = p_kpi AND band_score = p_score;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_kpi_score_bands
                   (kpi_id, band_score, operator, threshold_1, threshold_2, label_en, label_ar, created_by)
            VALUES (p_kpi, p_score, p_op, p_t1, p_t2, p_en, p_ar, 'SEED');
        END IF;
    END;

    PROCEDURE up_crit (p_kpi NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                       p_desc_en VARCHAR2, p_desc_ar VARCHAR2,
                       p_weight NUMBER, p_entry VARCHAR2,
                       p_fnote_en VARCHAR2, p_fnote_ar VARCHAR2,
                       p_ord NUMBER, o_id OUT NUMBER) IS
    BEGIN
        UPDATE prod.dct_kpi_criteria
           SET name_en = p_en, name_ar = p_ar,
               description_en = p_desc_en, description_ar = p_desc_ar,
               weight_pct = p_weight, entry_type = p_entry,
               frequency_note_en = p_fnote_en, frequency_note_ar = p_fnote_ar,
               display_order = p_ord, is_active = 'Y',
               updated_by = 'SEED', updated_at = SYSDATE
         WHERE kpi_id = p_kpi AND criterion_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_kpi_criteria
                   (kpi_id, criterion_code, name_en, name_ar, description_en, description_ar,
                    weight_pct, entry_type, frequency_note_en, frequency_note_ar,
                    display_order, created_by)
            VALUES (p_kpi, p_code, p_en, p_ar, p_desc_en, p_desc_ar,
                    p_weight, p_entry, p_fnote_en, p_fnote_ar, p_ord, 'SEED');
        END IF;
        SELECT criterion_id INTO o_id FROM prod.dct_kpi_criteria
         WHERE kpi_id = p_kpi AND criterion_code = p_code;
    END;

    PROCEDURE up_lvl (p_crit NUMBER, p_no NUMBER, p_title_en VARCHAR2, p_title_ar VARCHAR2,
                      p_desc_en VARCHAR2, p_desc_ar VARCHAR2) IS
    BEGIN
        UPDATE prod.dct_kpi_criteria_levels
           SET title_en = p_title_en, title_ar = p_title_ar,
               description_en = p_desc_en, description_ar = p_desc_ar
         WHERE criterion_id = p_crit AND level_no = p_no;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_kpi_criteria_levels
                   (criterion_id, level_no, title_en, title_ar, description_en, description_ar)
            VALUES (p_crit, p_no, p_title_en, p_title_ar, p_desc_en, p_desc_ar);
        END IF;
    END;

    PROCEDURE up_tgt (p_kpi NUMBER, p_year NUMBER, p_val NUMBER, p_en VARCHAR2, p_ar VARCHAR2) IS
    BEGIN
        UPDATE prod.dct_kpi_targets
           SET target_value = p_val, label_en = p_en, label_ar = p_ar
         WHERE kpi_id = p_kpi AND target_year = p_year;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_kpi_targets
                   (kpi_id, target_year, target_value, label_en, label_ar, created_by)
            VALUES (p_kpi, p_year, p_val, p_en, p_ar, 'SEED');
        END IF;
    END;
BEGIN
    -- -------------------------------------------------------------------------
    -- KPI 1 -- Revenue Growth
    -- -------------------------------------------------------------------------
    up_kpi('REV_GROWTH',
           'Revenue Growth', 'نمو الإيرادات',
           'This indicator aims to grow revenues through improving collection efficiency and optimal utilization of government assets.',
           'يهدف هذا المؤشر إلى تنمية الإيرادات من خلال تحسين كفاءة التحصيل والاستخدام الأمثل للأصول الحكومية.',
           'ASCENDING', 'Percentage', 'نسبة مئوية', 'ANNUAL', 'RATIO_A_OVER_B',
           '(Actual revenue current year / Actual revenue previous year) x 100',
           '(الإيرادات الفعلية للسنة الحالية / الإيرادات الفعلية للسنة السابقة) × 100',
           'ADERP / Fusion', 'نظام ADERP / فيوجن',
           'Sustainable growth of revenue should be cost efficient.',
           'يجب أن يكون النمو المستدام للإيرادات فعالًا من حيث التكلفة.',
           'GL_REVENUE_ACTUAL_YEAR', 'GL_REVENUE_ACTUAL_PRIOR_YEAR',
           'Actual revenue - current year (B)', 'الإيرادات الفعلية - السنة الحالية (ب)',
           'Actual revenue - previous year (A)', 'الإيرادات الفعلية - السنة السابقة (أ)',
           'N', 10, v_kpi);
    up_band(v_kpi, 5, 'GE', 108, NULL, '>= 108%', '108% فأكثر');
    up_band(v_kpi, 4, 'GT', 100, NULL, '> 100%',  'أكثر من 100%');
    up_band(v_kpi, 3, 'EQ', 100, NULL, '100%',    '100%');
    up_band(v_kpi, 2, 'GE', 90,  NULL, '>= 90%',  '90% فأكثر');
    up_band(v_kpi, 1, 'LT', 90,  NULL, '< 90%',   'أقل من 90%');
    up_tgt(v_kpi, 2025, 107, '107%', '107%');
    up_tgt(v_kpi, 2026, 108, '108%', '108%');
    up_tgt(v_kpi, 2027, 109, '109%', '109%');

    -- -------------------------------------------------------------------------
    -- KPI 2 -- Optimization Plan (Chapters 1, 2 and 3)
    -- -------------------------------------------------------------------------
    up_kpi('OPT_PLAN',
           'Optimization Plan (Chapters 1, 2 and 3)', 'خطة التحسين (الأبواب 1 و2 و3)',
           'Entities are required to provide a clearly defined and leadership-approved cost optimization plan with evidence of its implementation and the results achieved in the previous year, which should be at minimum equal to the communicated ED.',
           'يتعين على الجهات تقديم خطة واضحة ومعتمدة من القيادة لتحسين التكاليف مع إثبات تنفيذها والنتائج المحققة في السنة السابقة، على أن تكون كحد أدنى مساوية للمستهدف المبلغ.',
           'ASCENDING', 'Percentage', 'نسبة مئوية', 'ANNUAL', 'WEIGHTED_CRITERIA',
           'Well defined criteria based on four areas: data quality, approval status, execution plan and results achieved.',
           'معايير محددة تستند إلى أربعة مجالات: جودة البيانات وحالة الاعتماد وخطة التنفيذ والنتائج المحققة.',
           'An approved well defined plan submitted by entities on a yearly basis.',
           'خطة معتمدة ومحددة بوضوح تقدمها الجهات سنويًا.',
           NULL, NULL,
           NULL, NULL,
           NULL, NULL, NULL, NULL,
           'Y', 20, v_kpi);
    up_band(v_kpi, 5, 'GE', 80, NULL, '>= 80%', '80% فأكثر');
    up_band(v_kpi, 4, 'GE', 60, NULL, '>= 60%', '60% فأكثر');
    up_band(v_kpi, 3, 'GE', 40, NULL, '>= 40%', '40% فأكثر');
    up_band(v_kpi, 2, 'GE', 20, NULL, '>= 20%', '20% فأكثر');
    up_band(v_kpi, 1, 'GT', 0,  NULL, '> 0%',   'أكثر من 0%');
    up_tgt(v_kpi, 2025, 75, '75%', '75%');
    up_tgt(v_kpi, 2026, 80, '80%', '80%');
    up_tgt(v_kpi, 2027, 90, '90%', '90%');

    up_crit(v_kpi, 'DATA_QUALITY', 'Data Quality', 'جودة البيانات',
            'Quality of the savings calculation: sources, cost drivers, assumptions and impact assessment.',
            'جودة احتساب الوفورات: المصادر ومحركات التكلفة والافتراضات وتقييم الأثر.',
            20, 'MATURITY_1_5', NULL, NULL, 10, v_crit);
    up_lvl(v_crit, 1, 'Not available', 'غير متوفر',
           'Basic calculation with no source references or cost driver analysis.',
           'احتساب أساسي دون مراجع للمصادر أو تحليل لمحركات التكلفة.');
    up_lvl(v_crit, 2, 'Developing', 'قيد التطوير',
           'Detailed calculation of savings potential and assumptions with explanations.',
           'احتساب تفصيلي للوفورات المحتملة والافتراضات مع الشروحات.');
    up_lvl(v_crit, 3, 'Defined', 'محدد',
           'Detailed calculation of savings potential including data sources and assumptions with explanations.',
           'احتساب تفصيلي للوفورات المحتملة يشمل مصادر البيانات والافتراضات مع الشروحات.');
    up_lvl(v_crit, 4, 'Managed', 'مُدار',
           'Detailed calculation of savings potential including data sources, assumptions with explanations and relevant cost drivers.',
           'احتساب تفصيلي للوفورات المحتملة يشمل مصادر البيانات والافتراضات مع الشروحات ومحركات التكلفة ذات الصلة.');
    up_lvl(v_crit, 5, 'Optimized', 'مُحسَّن',
           'Detailed calculation of savings potential including data sources, cost drivers, assumptions with explanations, along with an impact assessment of the optimization.',
           'احتساب تفصيلي للوفورات المحتملة يشمل مصادر البيانات ومحركات التكلفة والافتراضات مع الشروحات، إلى جانب تقييم أثر التحسين.');

    up_crit(v_kpi, 'APPROVAL_STATUS', 'Approval Status', 'حالة الاعتماد',
            'Level of leadership approval obtained for the optimization plan.',
            'مستوى اعتماد القيادة الذي حصلت عليه خطة التحسين.',
            10, 'MATURITY_1_5', NULL, NULL, 20, v_crit);
    up_lvl(v_crit, 1, 'Not available', 'غير متوفر',
           'Approved by Department Manager.', 'معتمدة من مدير الإدارة.');
    up_lvl(v_crit, 2, 'Developing', 'قيد التطوير',
           'Approved by Department Director.', 'معتمدة من مدير الدائرة.');
    up_lvl(v_crit, 3, 'Defined', 'محدد',
           'Approved by Sector ED.', 'معتمدة من المدير التنفيذي للقطاع.');
    up_lvl(v_crit, 4, 'Managed', 'مُدار',
           'Approved by Sector ED and Finance ED.', 'معتمدة من المدير التنفيذي للقطاع والمدير التنفيذي للمالية.');
    up_lvl(v_crit, 5, 'Optimized', 'مُحسَّن',
           'Approved by Top Management.', 'معتمدة من الإدارة العليا.');

    up_crit(v_kpi, 'EXECUTION_PLAN', 'Execution Plan', 'خطة التنفيذ',
            'Completeness of the execution plan: stakeholders, roles, milestones, timelines, risks and mitigation.',
            'اكتمال خطة التنفيذ: أصحاب المصلحة والأدوار والمراحل والجداول الزمنية والمخاطر وخطط معالجتها.',
            20, 'MATURITY_1_5', NULL, NULL, 30, v_crit);
    up_lvl(v_crit, 1, 'Not available', 'غير متوفر',
           'Poor or incomplete submission with no clear execution plan or implementation steps.',
           'تقديم ضعيف أو غير مكتمل دون خطة تنفيذ أو خطوات تطبيق واضحة.');
    up_lvl(v_crit, 2, 'Developing', 'قيد التطوير',
           'High-level execution plan with limited implementation steps, minimal detail, and undefined ownership and timelines.',
           'خطة تنفيذ عامة بخطوات تطبيق محدودة وتفاصيل قليلة دون تحديد للمسؤوليات أو الجداول الزمنية.');
    up_lvl(v_crit, 3, 'Defined', 'محدد',
           'Detailed execution plan with clearly defined stakeholders, roles, milestones, and implementation steps.',
           'خطة تنفيذ تفصيلية بأصحاب مصلحة وأدوار ومراحل وخطوات تطبيق محددة بوضوح.');
    up_lvl(v_crit, 4, 'Managed', 'مُدار',
           'Comprehensive execution plan with clearly defined stakeholders, roles, milestones, implementation steps, predefined timelines, and identified risks.',
           'خطة تنفيذ شاملة بأصحاب مصلحة وأدوار ومراحل وخطوات تطبيق وجداول زمنية محددة مسبقًا ومخاطر معرفة.');
    up_lvl(v_crit, 5, 'Optimized', 'مُحسَّن',
           'Comprehensive execution plan with clearly defined stakeholders, roles, milestones, implementation steps, predefined timelines, identified risks, and a clear risk mitigation plan.',
           'خطة تنفيذ شاملة بأصحاب مصلحة وأدوار ومراحل وخطوات تطبيق وجداول زمنية محددة مسبقًا ومخاطر معرفة وخطة واضحة لمعالجتها.');

    up_crit(v_kpi, 'RESULTS_ACHIEVED', 'Results Achieved', 'النتائج المحققة',
            'Savings achieved versus the committed optimization plan.',
            'الوفورات المحققة مقارنة بخطة التحسين الملتزم بها.',
            50, 'MATURITY_1_5', NULL, NULL, 40, v_crit);
    up_lvl(v_crit, 1, 'Not available', 'غير متوفر',
           'Savings achieved below 80%.', 'وفورات محققة أقل من 80%.');
    up_lvl(v_crit, 2, 'Developing', 'قيد التطوير',
           'Savings achieved 80% or more.', 'وفورات محققة 80% فأكثر.');
    up_lvl(v_crit, 3, 'Defined', 'محدد',
           'Savings achieved 90% or more.', 'وفورات محققة 90% فأكثر.');
    up_lvl(v_crit, 4, 'Managed', 'مُدار',
           'Savings achieved 95% or more.', 'وفورات محققة 95% فأكثر.');
    up_lvl(v_crit, 5, 'Optimized', 'مُحسَّن',
           'Savings achieved 100% or more.', 'وفورات محققة 100% فأكثر.');

    -- -------------------------------------------------------------------------
    -- KPI 3 -- Cash Management and Financial Planning (excluding Capital Projects)
    -- -------------------------------------------------------------------------
    up_kpi('CASH_MGMT',
           'Cash Management and Financial Planning (excluding Capital Projects)',
           'إدارة النقد والتخطيط المالي (باستثناء المشاريع الرأسمالية)',
           'This indicator evaluates the entity ability to align financial resources with operational priorities through effective cash management and accurate financial planning. It reflects the entity capacity to control spending, deliver committed objectives, improve forecast accuracy, and maximize the efficient utilization of public funds.',
           'يقيّم هذا المؤشر قدرة الجهة على مواءمة الموارد المالية مع الأولويات التشغيلية من خلال إدارة نقد فعالة وتخطيط مالي دقيق، ويعكس قدرتها على ضبط الإنفاق وتحقيق الأهداف الملتزم بها وتحسين دقة التوقعات وتعظيم كفاءة استخدام المال العام.',
           'DESCENDING', 'Percentage', 'نسبة مئوية', 'QUARTERLY', 'ABS_VARIANCE',
           'Abs(1 - Actual expenditure / Forecasted cash flow) x 100, per quarter, non-cumulative, all chapters excluding capital projects.',
           'القيمة المطلقة لـ (1 - المصروفات الفعلية / التدفق النقدي المتوقع) × 100 لكل ربع سنة بشكل غير تراكمي لجميع الأبواب باستثناء المشاريع الرأسمالية.',
           'EPM; ADERP / Fusion', 'نظام التخطيط EPM؛ ونظام ADERP / فيوجن',
           'Consider splitting the KPI into two distinct metrics: one dedicated to operational cashflow (Ch 1, 2 and 3) and another for subsidies, grants and aids (Ch 4 and 5).',
           'يمكن النظر في تقسيم المؤشر إلى مقياسين منفصلين: أحدهما للتدفق النقدي التشغيلي (الأبواب 1 و2 و3) والآخر للإعانات والمنح والمساعدات (البابان 4 و5).',
           'FUSION_ACTUAL_QTR', 'EPM_FORECAST_QTR',
           'Actual expenditure - quarter (B)', 'المصروفات الفعلية - ربع السنة (ب)',
           'Forecasted cash flow - quarter (A)', 'التدفق النقدي المتوقع - ربع السنة (أ)',
           'N', 30, v_kpi);
    up_band(v_kpi, 5, 'LE', 5,    NULL, '+/- <= 5%',    'انحراف 5% أو أقل');
    up_band(v_kpi, 4, 'LE', 7.5,  NULL, '+/- <= 7.5%',  'انحراف 7.5% أو أقل');
    up_band(v_kpi, 3, 'LE', 10,   NULL, '+/- <= 10%',   'انحراف 10% أو أقل');
    up_band(v_kpi, 2, 'LE', 12.5, NULL, '+/- <= 12.5%', 'انحراف 12.5% أو أقل');
    up_band(v_kpi, 1, 'GT', 12.5, NULL, '+/- > 12.5%',  'انحراف أكثر من 12.5%');
    up_tgt(v_kpi, 2025, 5, '+/- 5%', '± 5%');
    up_tgt(v_kpi, 2026, 5, '+/- 5%', '± 5%');
    up_tgt(v_kpi, 2027, 5, '+/- 5%', '± 5%');

    -- -------------------------------------------------------------------------
    -- KPI 4 -- Compliance with Financial Law, Resolutions and Circulars
    -- -------------------------------------------------------------------------
    up_kpi('FIN_LAW_COMP',
           'Compliance with Financial Law, Resolutions and Circulars',
           'الامتثال للقانون المالي والقرارات والتعاميم',
           'This indicator measures the entity adherence to financial laws, resolutions, and circulars to strengthen governance, accountability, and compliance with financial regulations.',
           'يقيس هذا المؤشر التزام الجهة بالقوانين المالية والقرارات والتعاميم بما يعزز الحوكمة والمساءلة والامتثال للأنظمة المالية.',
           'ASCENDING', 'Percentage', 'نسبة مئوية', 'ANNUAL', 'WEIGHTED_CRITERIA',
           'Weighted checklist of eight compliance dimensions; each dimension is assessed as an achievement percentage and weighted per the circular.',
           'قائمة تحقق موزونة من ثمانية أبعاد للامتثال؛ يقيّم كل بعد كنسبة إنجاز مئوية ويوزن وفق التعميم.',
           'ADERP / Fusion; EPM; entity report submissions', 'نظام ADERP / فيوجن؛ ونظام EPM؛ وتقارير الجهة المقدمة دوريًا',
           'The KPI is calculated during the year as per the deadline of each dimension per the DOF circular.',
           'يُحتسب المؤشر خلال السنة وفق الموعد النهائي لكل بعد حسب تعميم دائرة المالية.',
           NULL, NULL,
           NULL, NULL, NULL, NULL,
           'Y', 40, v_kpi);
    up_band(v_kpi, 5, 'GE', 90, NULL, '>= 90%', '90% فأكثر');
    up_band(v_kpi, 4, 'GE', 80, NULL, '>= 80%', '80% فأكثر');
    up_band(v_kpi, 3, 'GE', 70, NULL, '>= 70%', '70% فأكثر');
    up_band(v_kpi, 2, 'GE', 60, NULL, '>= 60%', '60% فأكثر');
    up_band(v_kpi, 1, 'LT', 60, NULL, '< 60%',  'أقل من 60%');
    up_tgt(v_kpi, 2025, 100, '100%', '100%');
    up_tgt(v_kpi, 2026, 100, '100%', '100%');
    up_tgt(v_kpi, 2027, 100, '100%', '100%');

    up_crit(v_kpi, 'BUDGET_PREP', 'Adherence to budget preparation instructions', 'الالتزام بتعليمات إعداد الموازنة',
            NULL, NULL, 20, 'PERCENT_0_100', 'Annually', 'سنويًا', 10, v_crit);
    up_crit(v_kpi, 'BUDGET_EXEC', 'Adherence to budget execution instructions', 'الالتزام بتعليمات تنفيذ الموازنة',
            NULL, NULL, 20, 'PERCENT_0_100', 'During the year', 'خلال السنة', 20, v_crit);
    up_crit(v_kpi, 'MONTHLY_CLOSE', 'Monthly closure of the accounts', 'الإقفال الشهري للحسابات',
            NULL, NULL, 10, 'PERCENT_0_100', 'Monthly', 'شهريًا', 30, v_crit);
    up_crit(v_kpi, 'PAYMENT_POLICY', 'Meeting ADG Payment Policy of 30 days', 'الالتزام بسياسة الدفع الحكومية خلال 30 يومًا',
            NULL, NULL, 10, 'PERCENT_0_100', 'Quarterly', 'ربع سنوي', 40, v_crit);
    up_crit(v_kpi, 'DIRECT_INV', 'Percentage of direct invoice versus 3-way matching concept', 'نسبة الفواتير المباشرة مقابل مبدأ المطابقة الثلاثية',
            NULL, NULL, 10, 'PERCENT_0_100', 'Quarterly', 'ربع سنوي', 50, v_crit);
    up_crit(v_kpi, 'AUDITED_FS', 'Submission of annual audited financial statements', 'تقديم البيانات المالية السنوية المدققة',
            NULL, NULL, 5, 'PERCENT_0_100', 'Annually', 'سنويًا', 60, v_crit);
    up_crit(v_kpi, 'SEMI_ANNUAL_FS', 'Submission of semi-annual unaudited financials', 'تقديم البيانات المالية نصف السنوية غير المدققة',
            NULL, NULL, 5, 'PERCENT_0_100', 'Semi-annually', 'نصف سنوي', 70, v_crit);
    up_crit(v_kpi, 'TAX_REPORTS', 'Submission of tax reports', 'تقديم التقارير الضريبية',
            NULL, NULL, 20, 'PERCENT_0_100', 'Per tax calendar', 'وفق التقويم الضريبي', 80, v_crit);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('DOF circular content seeded: 4 KPIs, 20 bands, 12 criteria, 20 maturity levels, 12 targets');
END;
/

PROMPT === 03_kpi_seed.sql complete ===
