-- =============================================================================
-- Finance KPIs V2 (App 213) -- Phase 1 lookup seeds
-- File   : 01_kpi2_lookup_seed.sql
-- Schema : PROD rows (run as ADMIN; tables prefixed prod.)
-- Needs  : db/v2/109_lookup_value_dates.sql deployed first (description EN/AR
--          plus start/end date columns on prod.dct_lookup_values).
-- Seeds  : 14 KPI2_* lookup categories in the shared platform lookup store,
--          owned by module KPI_MGMT with is_system = N so the KPI-V2 Settings
--          Manage Lookups page can manage them. Category codes are KPI2_* on
--          purpose: v1's /kpi/boot matches LIKE 'KPI\_%' ESCAPE '\', so these
--          rows never leak into the v1 app.
-- Rerun  : safe -- update-first upserts; re-run refreshes seed names and never
--          deletes rows or touches admin-entered descriptions/dates.
-- Deploy : UTF-8 Arabic content -- run SQLcl with -Dfile.encoding=UTF-8.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

DECLARE
    v_mod NUMBER;
    v_cat NUMBER;

    PROCEDURE up_cat (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
    BEGIN
        UPDATE prod.dct_lookup_categories
           SET category_name_en = p_en, category_name_ar = p_ar,
               module_id = v_mod, updated_by = 'KPI2_SEED', updated_at = SYSTIMESTAMP
         WHERE category_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_lookup_categories
                   (category_code, category_name_en, category_name_ar,
                    module_id, is_system, is_active, created_by, updated_by)
            VALUES (p_code, p_en, p_ar, v_mod, 'N', 'Y', 'KPI2_SEED', 'KPI2_SEED');
        END IF;
        SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
    END;

    PROCEDURE up_val (p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                      p_ord NUMBER,
                      p_desc_en VARCHAR2 DEFAULT NULL, p_desc_ar VARCHAR2 DEFAULT NULL) IS
    BEGIN
        UPDATE prod.dct_lookup_values
           SET value_name_en = p_en, value_name_ar = p_ar, display_order = p_ord,
               description_en = NVL(description_en, p_desc_en),
               description_ar = NVL(description_ar, p_desc_ar),
               updated_by = 'KPI2_SEED', updated_at = SYSTIMESTAMP
         WHERE category_id = p_cat AND value_code = p_code;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_lookup_values
                   (category_id, value_code, value_name_en, value_name_ar,
                    description_en, description_ar, display_order,
                    is_default, is_active, created_by, updated_by)
            VALUES (p_cat, p_code, p_en, p_ar, p_desc_en, p_desc_ar, p_ord,
                    'N', 'Y', 'KPI2_SEED', 'KPI2_SEED');
        END IF;
    END;

    PROCEDURE seed_freq (p_cat NUMBER) IS
    BEGIN
        up_val(p_cat, 'YEARLY',    'Yearly',      'سنوي',        10);
        up_val(p_cat, 'HALF_YEAR', 'Half-yearly', 'نصف سنوي',    20);
        up_val(p_cat, 'QUARTERLY', 'Quarterly',   'ربع سنوي',    30);
        up_val(p_cat, 'MONTHLY',   'Monthly',     'شهري',        40);
        up_val(p_cat, 'BIWEEKLY',  'Bi-weekly',   'كل أسبوعين',  50);
        up_val(p_cat, 'WEEKLY',    'Weekly',      'أسبوعي',      60);
        up_val(p_cat, 'DAILY',     'Daily',       'يومي',        70);
    END;
BEGIN
    SELECT module_id INTO v_mod FROM prod.dct_modules WHERE module_code = 'KPI_MGMT';

    up_cat('KPI2_REPORTING_FREQ', 'KPI Reporting Frequency', 'دورية إعداد تقارير المؤشر', v_cat);
    seed_freq(v_cat);

    up_cat('KPI2_UPDATING_FREQ', 'KPI Updating Frequency', 'دورية تحديث المؤشر', v_cat);
    seed_freq(v_cat);

    up_cat('KPI2_POLARITY', 'KPI Polarity', 'اتجاه المؤشر', v_cat);
    up_val(v_cat, 'ASCENDING',  'Ascending (higher is better)', 'تصاعدي (الأعلى أفضل)', 10,
           'A rising value means better performance.', 'ارتفاع القيمة يعني أداء أفضل.');
    up_val(v_cat, 'DESCENDING', 'Descending (lower is better)', 'تنازلي (الأدنى أفضل)', 20,
           'A falling value means better performance.', 'انخفاض القيمة يعني أداء أفضل.');

    up_cat('KPI2_UOM', 'KPI Unit of Measure', 'وحدة قياس المؤشر', v_cat);
    up_val(v_cat, 'PERCENTAGE', 'Percentage', 'نسبة مئوية', 10);
    up_val(v_cat, 'AMOUNT',     'Amount',     'مبلغ',       20);

    up_cat('KPI2_DATA_SOURCE', 'Data Source', 'مصدر البيانات', v_cat);
    up_val(v_cat, 'FUSION', 'Fusion', 'فيوجن', 10, 'Oracle Fusion Cloud.',       'أوراكل فيوجن السحابي.');
    up_val(v_cat, 'EBS',    'EBS',    'EBS',   20, 'Oracle E-Business Suite.',   'حزمة أوراكل للأعمال.');
    up_val(v_cat, 'EPM',    'EPM',    'EPM',   30, 'Oracle Enterprise Performance Management.', 'إدارة الأداء المؤسسي من أوراكل.');

    up_cat('KPI2_CALC_METHOD', 'KPI Calculation Method', 'طريقة احتساب المؤشر', v_cat);
    up_val(v_cat, 'RATIO_A_OVER_B',    'Ratio (A over B) x 100',       'نسبة (أ على ب) × 100',     10,
           'Score derived from the ratio of figure A over figure B times 100.',
           'تحتسب النتيجة من نسبة الرقم أ على الرقم ب مضروبة في 100.');
    up_val(v_cat, 'ABS_VARIANCE',      'Absolute variance from plan',  'الانحراف المطلق عن الخطة', 20,
           'Score derived from the absolute variance between actual and plan.',
           'تحتسب النتيجة من الانحراف المطلق بين الفعلي والخطة.');
    up_val(v_cat, 'WEIGHTED_CRITERIA', 'Weighted assessment criteria', 'معايير تقييم موزونة',      30,
           'Score derived from weighted assessment criteria.',
           'تحتسب النتيجة من معايير تقييم موزونة.');

    up_cat('KPI2_YES_NO', 'Yes/No', 'نعم/لا', v_cat);
    up_val(v_cat, 'YES', 'Yes', 'نعم', 10);
    up_val(v_cat, 'NO',  'No',  'لا',  20);

    up_cat('KPI2_SOURCE_FIGURE', 'KPI Source Figures', 'أرقام مصدر المؤشر', v_cat);
    up_val(v_cat, 'ACT_YTD_GL_REVENUE', 'Actual YTD GL Revenue', 'إيرادات دفتر الأستاذ الفعلية منذ بداية السنة', 10,
           'Actual year-to-date revenue from the General Ledger.',
           'الإيرادات الفعلية منذ بداية السنة من دفتر الأستاذ العام.');
    up_val(v_cat, 'ACT_YTD_GL_EXPENSE', 'Actual YTD GL Expense', 'مصروفات دفتر الأستاذ الفعلية منذ بداية السنة', 20,
           'Actual year-to-date expense from the General Ledger.',
           'المصروفات الفعلية منذ بداية السنة من دفتر الأستاذ العام.');

    up_cat('KPI2_CATEGORY', 'KPI Category', 'فئة المؤشر', v_cat);
    up_val(v_cat, 'STRATEGIC',  'Strategic',  'استراتيجي', 10);
    up_val(v_cat, 'OPERATIONS', 'Operations', 'تشغيلي',    20);

    up_cat('KPI2_KPI_TYPE', 'KPI Type', 'نوع المؤشر', v_cat);
    up_val(v_cat, 'STRATEGIC',   'Strategic',   'استراتيجي', 10);
    up_val(v_cat, 'OPERATIONAL', 'Operational', 'تشغيلي',    20);

    up_cat('KPI2_KPI_STATUS', 'KPI Status', 'حالة المؤشر', v_cat);
    up_val(v_cat, 'DRAFT',     'Draft',               'مسودة',         10);
    up_val(v_cat, 'SUBMITTED', 'Submitted',           'مقدم للاعتماد', 20);
    up_val(v_cat, 'APPROVED',  'Approved',            'معتمد',         30);
    up_val(v_cat, 'RETURNED',  'Returned for rework', 'معاد للتعديل',  40);

    up_cat('KPI2_PERIOD_STATUS', 'KPI Period Status', 'حالة فترة المؤشر', v_cat);
    up_val(v_cat, 'OPEN',   'Open',   'مفتوحة', 10);
    up_val(v_cat, 'CLOSED', 'Closed', 'مغلقة',  20);

    up_cat('KPI2_PLAN_TYPE', 'Plan Type', 'نوع الخطة', v_cat);
    up_val(v_cat, 'STRATEGIC',   'Strategic',   'استراتيجية', 10);
    up_val(v_cat, 'OPERATIONAL', 'Operational', 'تشغيلية',    20);
    up_val(v_cat, 'SECTOR',      'Sector',      'قطاعية',     30);
    up_val(v_cat, 'DEPARTMENT',  'Department',  'إدارية',     40);

    up_cat('KPI2_PLAN_OWNER', 'Plan Owner', 'الجهة المالكة للخطة', v_cat);
    up_val(v_cat, 'DOF', 'Department of Finance',    'دائرة المالية',          10);
    up_val(v_cat, 'DOE', 'Department of Enablement', 'دائرة التمكين',          20);
    up_val(v_cat, 'SSS', 'Support Service Sector',   'قطاع الخدمات المساندة',  30);

    up_cat('KPI2_PLAN_STATUS', 'Plan Status', 'حالة الخطة', v_cat);
    up_val(v_cat, 'DRAFT',  'Draft',  'مسودة', 10);
    up_val(v_cat, 'ACTIVE', 'Active', 'نشطة',  20);
    up_val(v_cat, 'CLOSED', 'Closed', 'مغلقة', 30);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('KPI2 lookup seeds done: 14 categories under module ' || v_mod);
END;
/

PROMPT == verification ==
SELECT c.category_code, c.category_name_en,
       (SELECT COUNT(*) FROM prod.dct_lookup_values v WHERE v.category_id = c.category_id) AS n_values
  FROM prod.dct_lookup_categories c
 WHERE c.category_code LIKE 'KPI2%'
 ORDER BY c.category_code;
