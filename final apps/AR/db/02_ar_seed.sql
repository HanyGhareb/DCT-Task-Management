-- =============================================================================
-- Accounts Receivable Module (App 206) — Seed Data
-- File    : 02_ar_seed.sql
-- Schema  : PROD
-- Run     : After 01_ar_ddl.sql
-- Safe    : Idempotent — MERGE INTO throughout
-- Depends : db/v2 platform (dct_modules, dct_roles, dct_permissions,
--           dct_module_settings, dct_lookup_categories/values)
-- =============================================================================
-- Seeds:
--   1. DCT_MODULES row (ACCOUNTS_RECEIVABLE, App 206)
--   2. Roles AR_ADMIN / AR_USER + permissions
--   3. Module settings (AI, review gate, alt file name …)
--   4. Lookup categories AR_* + SOURCE_MODULE += AR
--   5. Document categories (from P&L Automation workbook Source sheet)
--   6. P&L categories (workbook "Enhanced" cost + revenue lists, verbatim)
-- =============================================================================

SET DEFINE OFF

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. MODULE REGISTRATION — DCT_MODULES
-- =============================================================================
MERGE INTO dct_modules tgt
USING (
    SELECT
        'ACCOUNTS_RECEIVABLE' AS module_code,
        'Accounts Receivable' AS module_name_en,
        'الحسابات المدينة'    AS module_name_ar,
        'APEX_APP'            AS module_type,
        206                   AS apex_app_id,
        1                     AS apex_page_id,
        'fa-file-invoice-dollar' AS icon_class,
        '#6C4AB6'             AS icon_color,
        '#F0EBFA'             AS bg_color,
        'Revenue Assurance event P&L analysis — AI document classification, expense/revenue extraction, audit findings, dashboards and what-if analysis.' AS description_en,
        'تحليل الأرباح والخسائر للفعاليات — تصنيف المستندات بالذكاء الاصطناعي واستخراج الإيرادات والمصروفات ولوحات التحليل.' AS description_ar,
        'FINANCE'             AS category,
        50                    AS display_order,
        'Y'                   AS is_active,
        'N'                   AS is_new_tab,
        'N'                   AS is_admin_only
    FROM dual
) src ON (tgt.module_code = src.module_code)
WHEN NOT MATCHED THEN
    INSERT (module_code, module_name_en, module_name_ar, module_type, apex_app_id,
            apex_page_id, icon_class, icon_color, bg_color,
            description_en, description_ar, category, display_order,
            is_active, is_new_tab, is_admin_only)
    VALUES (src.module_code, src.module_name_en, src.module_name_ar, src.module_type,
            src.apex_app_id, src.apex_page_id, src.icon_class, src.icon_color, src.bg_color,
            src.description_en, src.description_ar, src.category, src.display_order,
            src.is_active, src.is_new_tab, src.is_admin_only)
WHEN MATCHED THEN
    UPDATE SET module_name_en = src.module_name_en,
               apex_app_id    = src.apex_app_id,
               icon_class     = src.icon_class,
               category       = src.category,
               is_active      = src.is_active;

COMMIT;
PROMPT Module registered: ACCOUNTS_RECEIVABLE (App 206)

-- =============================================================================
-- 2. ROLES
-- =============================================================================
DECLARE
    v_module_id dct_modules.module_id%TYPE;

    PROCEDURE upsert_role (
        p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
        p_desc VARCHAR2, p_ord NUMBER
    ) IS
    BEGIN
        MERGE INTO dct_roles tgt
        USING (SELECT p_code AS role_code FROM dual) src
        ON    (tgt.role_code = src.role_code)
        WHEN NOT MATCHED THEN
            INSERT (role_code, role_name_en, role_name_ar, role_type, module_id,
                    description_en, is_active, is_system_role, display_order)
            VALUES (p_code, p_en, p_ar, 'MODULE', v_module_id,
                    p_desc, 'Y', 'N', p_ord)
        WHEN MATCHED THEN
            UPDATE SET role_name_en  = p_en,
                       role_name_ar  = p_ar,
                       display_order = p_ord;
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'ACCOUNTS_RECEIVABLE';

    upsert_role(
        'AR_ADMIN', 'AR Admin', 'مدير الحسابات المدينة',
        'Full access — events, files, P&L review, document/P&L category masters, scenarios, and module settings.',
        10);

    upsert_role(
        'AR_USER', 'AR Analyst', 'محلل الحسابات المدينة',
        'Creates events, uploads document folders, runs AI processing, reviews classifications and P&L lines, builds what-if scenarios.',
        20);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Roles seeded: AR_ADMIN, AR_USER');
END;
/

-- =============================================================================
-- 3. PERMISSIONS + ROLE-PERMISSION MAP
-- =============================================================================
DECLARE
    v_module_id dct_modules.module_id%TYPE;
    v_admin_rid dct_roles.role_id%TYPE;
    v_user_rid  dct_roles.role_id%TYPE;

    TYPE t_perm IS RECORD (
        code     VARCHAR2(100),
        name     VARCHAR2(200),
        action   VARCHAR2(30),
        admin_yn VARCHAR2(1),
        user_yn  VARCHAR2(1)
    );
    TYPE t_perm_list IS TABLE OF t_perm;

    v_perms t_perm_list := t_perm_list(
        t_perm('AR.VIEW_EVENTS',       'View events and P&L data',                'VIEW',      'Y','Y'),
        t_perm('AR.CREATE_EVENT',      'Create and edit events',                  'CREATE',    'Y','Y'),
        t_perm('AR.UPLOAD_FILES',      'Upload event document folders',           'CREATE',    'Y','Y'),
        t_perm('AR.RUN_AI',            'Run AI classification and extraction',    'EDIT',      'Y','Y'),
        t_perm('AR.REVIEW_PNL',        'Review and confirm P&L lines',            'APPROVE',   'Y','Y'),
        t_perm('AR.DELETE_LINES',      'Delete P&L lines',                        'DELETE',    'Y','N'),
        t_perm('AR.MANAGE_SCENARIOS',  'Create and manage what-if scenarios',     'EDIT',      'Y','Y'),
        t_perm('AR.EXPORT',            'Export P&L and report data',              'EXPORT',    'Y','Y'),
        t_perm('AR.MANAGE_CATEGORIES', 'Manage P&L item categories',              'CONFIGURE', 'Y','N'),
        t_perm('AR.MANAGE_DOC_CATS',   'Manage document categories',              'CONFIGURE', 'Y','N'),
        t_perm('AR.MODULE_SETTINGS',   'Configure module settings',               'CONFIGURE', 'Y','N')
    );

    v_perm_id dct_permissions.permission_id%TYPE;

    PROCEDURE grant_to_role(p_perm_id NUMBER, p_role_id NUMBER) IS
    BEGIN
        MERGE INTO dct_role_permissions rp
        USING (SELECT p_role_id AS role_id, p_perm_id AS permission_id FROM dual) src
        ON    (rp.role_id = src.role_id AND rp.permission_id = src.permission_id)
        WHEN NOT MATCHED THEN
            INSERT (role_id, permission_id, granted_by)
            VALUES (p_role_id, p_perm_id, 'archa2');
    END;
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'ACCOUNTS_RECEIVABLE';
    SELECT role_id   INTO v_admin_rid FROM dct_roles   WHERE role_code   = 'AR_ADMIN';
    SELECT role_id   INTO v_user_rid  FROM dct_roles   WHERE role_code   = 'AR_USER';

    FOR i IN 1 .. v_perms.COUNT LOOP
        MERGE INTO dct_permissions p
        USING (SELECT v_perms(i).code AS permission_code FROM dual) src
        ON    (p.permission_code = src.permission_code)
        WHEN NOT MATCHED THEN
            INSERT (permission_code, permission_name, module_id, action_type, is_active)
            VALUES (v_perms(i).code, v_perms(i).name, v_module_id, v_perms(i).action, 'Y')
        WHEN MATCHED THEN
            UPDATE SET permission_name = v_perms(i).name,
                       action_type     = v_perms(i).action;

        SELECT permission_id INTO v_perm_id
        FROM   dct_permissions WHERE permission_code = v_perms(i).code;

        IF v_perms(i).admin_yn = 'Y' THEN grant_to_role(v_perm_id, v_admin_rid); END IF;
        IF v_perms(i).user_yn  = 'Y' THEN grant_to_role(v_perm_id, v_user_rid);  END IF;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Permissions seeded: ' || v_perms.COUNT || ' AR.* permissions');
END;
/

-- =============================================================================
-- 4. MODULE SETTINGS
-- =============================================================================
DECLARE
    v_module_id dct_modules.module_id%TYPE;

    TYPE t_setting IS RECORD (
        s_key   VARCHAR2(100), s_val   VARCHAR2(1000),
        s_label VARCHAR2(200), s_desc  VARCHAR2(1000),
        s_type  VARCHAR2(20),  s_allow VARCHAR2(500),
        s_def   VARCHAR2(1000)
    );
    TYPE t_setting_list IS TABLE OF t_setting;

    v_settings t_setting_list := t_setting_list(
        t_setting('ANTHROPIC_API_KEY', NULL,
            'Anthropic API Key (AI Classification & Extraction)',
            'API key for the Claude API used by AI document classification and P&L extraction. Set by the administrator; never stored in source control.',
            'TEXT', NULL, NULL),
        t_setting('AI_MODEL', 'claude-haiku-4-5-20251001',
            'Anthropic Model',
            'Claude model used when AI Provider = ANTHROPIC. Switch to a Sonnet model for higher accuracy at higher cost.',
            'TEXT', NULL, 'claude-haiku-4-5-20251001'),
        t_setting('AI_PROVIDER', 'ANTHROPIC',
            'AI Provider',
            'ANTHROPIC = Claude (paid, highest accuracy). GEMINI = Google Gemini (free tier available via Google AI Studio — ~10-15 requests/min, 1,500/day). Each provider needs its own API key setting.',
            'SELECT', 'ANTHROPIC|GEMINI', 'ANTHROPIC'),
        t_setting('GEMINI_API_KEY', NULL,
            'Google Gemini API Key',
            'Free API key from Google AI Studio (aistudio.google.com/apikey) — only an API key is required, no credit card or username. Used when AI Provider = GEMINI. Never stored in source control.',
            'TEXT', NULL, NULL),
        t_setting('GEMINI_MODEL', 'gemini-flash-latest',
            'Gemini Model',
            'Gemini model used when AI Provider = GEMINI. gemini-flash-latest always points to the newest free-tier Flash model; a pinned ID (e.g. gemini-2.5-flash) may also be used.',
            'TEXT', NULL, 'gemini-flash-latest'),
        t_setting('AUTO_CLASSIFY_ON_UPLOAD', 'Y',
            'Auto-Run AI After Upload',
            'Y = AI classification starts automatically when a folder upload completes; N = user triggers processing manually.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('REQUIRE_HUMAN_REVIEW', 'Y',
            'Require Human Review',
            'Y = AI classifications and extracted P&L lines/KPIs/findings are created as DRAFT and must be confirmed by a user; N = AI results are auto-confirmed and flow directly to reports and dashboards.',
            'BOOLEAN', 'Y|N', 'Y'),
        t_setting('MIN_CONFIDENCE_AUTOCONFIRM', '85',
            'Auto-Confirm Confidence Threshold (%)',
            'When REQUIRE_HUMAN_REVIEW = Y, classifications with AI confidence >= this percentage are auto-confirmed (still editable). 0-100.',
            'NUMBER', NULL, '85'),
        t_setting('ENABLE_ALT_FILE_NAME', 'N',
            'Enable Alternative File Name',
            'Y = a standardized alternative file name is generated for each classified file using ALT_FILE_NAME_FORMAT and used when downloading.',
            'BOOLEAN', 'Y|N', 'N'),
        t_setting('ALT_FILE_NAME_FORMAT', '{EVENT_NAME}-{CATEGORY}-{ORIGINAL_NAME}',
            'Alternative File Name Format',
            'Template for the alternative file name. Tokens: {EVENT_NAME}, {EVENT_CODE}, {CATEGORY}, {ORIGINAL_NAME}.',
            'TEXT', NULL, '{EVENT_NAME}-{CATEGORY}-{ORIGINAL_NAME}'),
        t_setting('DEFAULT_CURRENCY', 'AED',
            'Default Currency',
            'Default currency for events and extracted P&L lines when the document does not state one.',
            'TEXT', NULL, 'AED'),
        t_setting('MAX_FILE_SIZE_MB', '25',
            'Maximum Upload File Size (MB)',
            'Client-side limit per file. Files larger than ~20 MB cannot be processed by the AI document API and will require manual entry.',
            'NUMBER', NULL, '25'),
        t_setting('EVENT_CODE_PREFIX', 'EVT',
            'Event Code Prefix',
            'Prefix for auto-generated event codes. Generated format: {PREFIX}-{YYYY}-{0001}.',
            'TEXT', NULL, 'EVT'),
        t_setting('THEME_BRAND_COLOR', '#6C4AB6',
            'Brand Colour',
            'Primary brand colour for the AR JET app shell.',
            'TEXT', NULL, '#6C4AB6')
    );
BEGIN
    SELECT module_id INTO v_module_id FROM dct_modules WHERE module_code = 'ACCOUNTS_RECEIVABLE';

    FOR i IN 1 .. v_settings.COUNT LOOP
        MERGE INTO dct_module_settings s
        USING (SELECT v_module_id         AS module_id,
                      v_settings(i).s_key AS setting_key FROM dual) src
        ON    (s.module_id = src.module_id AND s.setting_key = src.setting_key)
        WHEN NOT MATCHED THEN
            INSERT (module_id, setting_key, setting_value, setting_label,
                    setting_description, value_type, allowed_values, default_value,
                    effective_date)
            VALUES (v_module_id, v_settings(i).s_key, v_settings(i).s_val,
                    v_settings(i).s_label, v_settings(i).s_desc,
                    v_settings(i).s_type,  v_settings(i).s_allow, v_settings(i).s_def,
                    SYSDATE)
        WHEN MATCHED THEN
            UPDATE SET setting_label       = v_settings(i).s_label,
                       setting_description = v_settings(i).s_desc,
                       value_type          = v_settings(i).s_type,
                       allowed_values      = v_settings(i).s_allow,
                       default_value       = v_settings(i).s_def;
            -- setting_value intentionally NOT updated on re-seed (preserves admin edits)
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Module settings seeded: ' || v_settings.COUNT || ' ACCOUNTS_RECEIVABLE settings');
END;
/

-- =============================================================================
-- 5. LOOKUP CATEGORIES AND VALUES
-- =============================================================================
DECLARE
    v_cat NUMBER;

    PROCEDURE upsert_category (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
    BEGIN
        MERGE INTO dct_lookup_categories t
        USING (SELECT p_code AS category_code FROM dual) s
        ON (t.category_code = s.category_code)
        WHEN NOT MATCHED THEN
            INSERT (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
            VALUES (p_code, p_en, p_ar, NULL, 'Y', 'Y')
        WHEN MATCHED THEN
            UPDATE SET t.category_name_en = p_en, t.category_name_ar = p_ar;
        SELECT category_id INTO o_id FROM dct_lookup_categories WHERE category_code = p_code;
    END;

    PROCEDURE upsert_value (p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                            p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N') IS
    BEGIN
        MERGE INTO dct_lookup_values t
        USING (SELECT p_cat AS category_id, p_code AS value_code FROM dual) s
        ON (t.category_id = s.category_id AND t.value_code = s.value_code)
        WHEN NOT MATCHED THEN
            INSERT (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
            VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_default, 'Y')
        WHEN MATCHED THEN
            UPDATE SET t.value_name_en = p_en, t.value_name_ar = p_ar, t.display_order = p_ord;
    END;
BEGIN
    -- SOURCE_MODULE += AR (shared category from db/v2/15)
    upsert_category('SOURCE_MODULE', 'Source Module', 'الوحدة المصدر', v_cat);
    upsert_value(v_cat, 'AR', 'Accounts Receivable', 'الحسابات المدينة', 70);

    upsert_category('AR_EVENT_TYPE', 'AR Event Type', 'نوع الفعالية', v_cat);
    upsert_value(v_cat, 'CONCERT',    'Concert / Show',     'حفلة موسيقية',   10);
    upsert_value(v_cat, 'FESTIVAL',   'Festival',           'مهرجان',         20);
    upsert_value(v_cat, 'EXHIBITION', 'Exhibition',         'معرض',           30);
    upsert_value(v_cat, 'CONFERENCE', 'Conference / Forum', 'مؤتمر',          40);
    upsert_value(v_cat, 'SPORT',      'Sporting Event',     'فعالية رياضية',  50);
    upsert_value(v_cat, 'CULTURAL',   'Cultural Event',     'فعالية ثقافية',  60);
    upsert_value(v_cat, 'OTHER',      'Other',              'أخرى',           99, 'Y');

    upsert_category('AR_EVENT_STATUS', 'AR Event Status', 'حالة الفعالية', v_cat);
    upsert_value(v_cat, 'NEW',            'New',             'جديد',            10, 'Y');
    upsert_value(v_cat, 'FILES_UPLOADED', 'Files Uploaded',  'تم رفع الملفات',  20);
    upsert_value(v_cat, 'AI_PROCESSING',  'AI Processing',   'قيد المعالجة',    30);
    upsert_value(v_cat, 'UNDER_REVIEW',   'Under Review',    'قيد المراجعة',    40);
    upsert_value(v_cat, 'CONFIRMED',      'Confirmed',       'مؤكد',            50);
    upsert_value(v_cat, 'CLOSED',         'Closed',          'مغلق',            60);

    upsert_category('AR_CLASS_STATUS', 'AR File Classification Status', 'حالة تصنيف الملف', v_cat);
    upsert_value(v_cat, 'PENDING',       'Pending',        'قيد الانتظار',   10, 'Y');
    upsert_value(v_cat, 'AI_CLASSIFIED', 'AI Classified',  'مصنف آليًا',     20);
    upsert_value(v_cat, 'CONFIRMED',     'Confirmed',      'مؤكد',           30);
    upsert_value(v_cat, 'FAILED',        'Failed',         'فشل',            40);
    upsert_value(v_cat, 'SKIPPED',       'Skipped',        'تم التخطي',      50);

    upsert_category('AR_EXTRACT_STATUS', 'AR File Extraction Status', 'حالة استخراج الملف', v_cat);
    upsert_value(v_cat, 'NOT_APPLICABLE', 'Not Applicable', 'لا ينطبق',      10, 'Y');
    upsert_value(v_cat, 'PENDING',        'Pending',        'قيد الانتظار',  20);
    upsert_value(v_cat, 'EXTRACTED',      'Extracted',      'تم الاستخراج',  30);
    upsert_value(v_cat, 'CONFIRMED',      'Confirmed',      'مؤكد',          40);
    upsert_value(v_cat, 'FAILED',         'Failed',         'فشل',           50);

    upsert_category('AR_LINE_TYPE', 'AR P&L Line Type', 'نوع سطر الأرباح والخسائر', v_cat);
    upsert_value(v_cat, 'EXPENSE', 'Expense', 'مصروف', 10, 'Y');
    upsert_value(v_cat, 'REVENUE', 'Revenue', 'إيراد', 20);

    upsert_category('AR_PNL_BASIS', 'AR P&L Basis', 'أساس الأرباح والخسائر', v_cat);
    upsert_value(v_cat, 'ACTUAL',   'Actual',   'فعلي',   10, 'Y');
    upsert_value(v_cat, 'BUDGET',   'Budget',   'موازنة', 20);
    upsert_value(v_cat, 'FORECAST', 'Forecast', 'توقع',   30);

    upsert_category('AR_REVIEW_STATUS', 'AR Review Status', 'حالة المراجعة', v_cat);
    upsert_value(v_cat, 'DRAFT',     'Draft',     'مسودة', 10, 'Y');
    upsert_value(v_cat, 'CONFIRMED', 'Confirmed', 'مؤكد',  20);
    upsert_value(v_cat, 'REJECTED',  'Rejected',  'مرفوض', 30);

    upsert_category('AR_CATEGORY_TYPE', 'AR P&L Category Type', 'نوع فئة الأرباح والخسائر', v_cat);
    upsert_value(v_cat, 'EXPENSE', 'Expense', 'مصروف', 10);
    upsert_value(v_cat, 'REVENUE', 'Revenue', 'إيراد', 20);
    upsert_value(v_cat, 'BOTH',    'Both',    'كلاهما', 30);

    upsert_category('AR_ADJ_TYPE', 'AR Scenario Adjustment Type', 'نوع تعديل السيناريو', v_cat);
    upsert_value(v_cat, 'PCT',      'Percentage (+/-)',    'نسبة مئوية',  10, 'Y');
    upsert_value(v_cat, 'AMOUNT',   'Fixed Amount (+/-)',  'مبلغ ثابت',   20);
    upsert_value(v_cat, 'OVERRIDE', 'Override Total',      'استبدال',     30);

    upsert_category('AR_KPI_CODE', 'AR Event KPI Code', 'مؤشر أداء الفعالية', v_cat);
    upsert_value(v_cat, 'TICKETS_SOLD',            'Tickets Sold',                'التذاكر المباعة',         10);
    upsert_value(v_cat, 'COMP_TICKETS',            'Complimentary Tickets',       'التذاكر المجانية',        20);
    upsert_value(v_cat, 'TOTAL_TICKETS_ISSUED',    'Total Tickets Issued',        'إجمالي التذاكر',          30);
    upsert_value(v_cat, 'VISITOR_FOOTFALL',        'Visitor Footfall',            'عدد الزوار',              40);
    upsert_value(v_cat, 'ACCREDITED_FOOTFALL',     'Accredited Footfall',         'الحضور المعتمد',          50);
    upsert_value(v_cat, 'TOTAL_FOOTFALL',          'Total Footfall',              'إجمالي الحضور',           60);
    upsert_value(v_cat, 'GROSS_REVENUE',           'Gross Revenue',               'إجمالي الإيرادات',        70);
    upsert_value(v_cat, 'ORGANIZER_REVENUE_SHARE', 'Organizer Revenue Share',     'حصة المنظم من الإيرادات', 80);
    upsert_value(v_cat, 'INTL_VISITATION_PCT',     'International Visitation %',  'نسبة الزوار الدوليين',    90);
    upsert_value(v_cat, 'GUEST_SATISFACTION',      'Guest Satisfaction Score',    'رضا الزوار',              100);
    upsert_value(v_cat, 'SPONSORS_COUNT',          'Sponsors Count',              'عدد الرعاة',              110);
    upsert_value(v_cat, 'VENDORS_COUNT',           'Vendors Count',               'عدد الموردين',            120);
    upsert_value(v_cat, 'OTHER',                   'Other KPI',                   'مؤشر آخر',                999);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookup categories seeded: AR_EVENT_TYPE, AR_EVENT_STATUS, AR_CLASS_STATUS, AR_EXTRACT_STATUS, AR_LINE_TYPE, AR_PNL_BASIS, AR_REVIEW_STATUS, AR_CATEGORY_TYPE, AR_ADJ_TYPE, AR_KPI_CODE (+SOURCE_MODULE.AR)');
END;
/

-- =============================================================================
-- 6. DOCUMENT CATEGORIES
--    From the P&L Automation workbook "Source" sheet. The Y/N column maps to
--    is_pnl_source. Extraction-mode flags derived from real sample documents.
-- =============================================================================
DECLARE
    PROCEDURE upsert_doc_cat (
        p_code  VARCHAR2, p_en    VARCHAR2, p_ar    VARCHAR2, p_desc VARCHAR2,
        p_pnl   VARCHAR2, p_basis VARCHAR2,
        p_lines VARCHAR2, p_kpis  VARCHAR2, p_find  VARCHAR2, p_meta VARCHAR2,
        p_hints VARCHAR2, p_ord   NUMBER
    ) IS
    BEGIN
        MERGE INTO dct_ar_doc_categories t
        USING (SELECT p_code AS doc_cat_code FROM dual) s
        ON (t.doc_cat_code = s.doc_cat_code)
        WHEN NOT MATCHED THEN
            INSERT (doc_cat_code, doc_cat_name_en, doc_cat_name_ar, description,
                    is_pnl_source, pnl_basis, extract_lines, extract_kpis,
                    extract_findings, extract_event_meta, extraction_hints,
                    display_order, is_active, created_by)
            VALUES (p_code, p_en, p_ar, p_desc,
                    p_pnl, p_basis, p_lines, p_kpis,
                    p_find, p_meta, p_hints,
                    p_ord, 'Y', 'SEED')
        WHEN MATCHED THEN
            UPDATE SET doc_cat_name_en  = p_en,
                       description      = p_desc,
                       is_pnl_source    = p_pnl,
                       pnl_basis        = p_basis,
                       extract_lines    = p_lines,
                       extract_kpis     = p_kpis,
                       extract_findings = p_find,
                       extract_event_meta = p_meta,
                       extraction_hints = p_hints,
                       display_order    = p_ord;
    END;
BEGIN
    upsert_doc_cat('AUDIT_REPORT_FINAL', 'Audit Report (Final)', 'تقرير التدقيق النهائي',
        'Signed/final DCT Revenue Assurance audit report. Contains the audited P&L calculation with organizer-reported vs DCT-calculated figures and variance, a contract brief with budget breakdown, review findings with recommendations, and potential revenue loss amounts.',
        'Y', 'ACTUAL', 'Y', 'Y', 'Y', 'Y',
        'P&L tables show two figure columns: the organizer figure goes to reported_amount and the DCT-calculated figure to amount. Deductions like VAT appear in parentheses and must be negative amounts.',
        10);

    upsert_doc_cat('AUDIT_REPORT_DRAFT', 'Audit Report (Draft)', 'مسودة تقرير التدقيق',
        'Draft (unsigned) revenue audit report. Same structure as the final audit report but not yet endorsed — not a trusted P&L source.',
        'N', NULL, 'N', 'N', 'N', 'N', NULL, 20);

    upsert_doc_cat('ORGANIZER_PNL', 'Organizer P&L', 'الأرباح والخسائر من المنظم',
        'Show budget profit & loss statement prepared by the event organizer or promoter. Contains box-office settlement by ticket tier (quantity x price), revenue summary, expenses by category, artist deal terms, and profit allocation. Often dual currency AED and USD with an FX rate, and may include a detail sheet with budget vs final cost, supplier names, and PO/invoice references.',
        'Y', 'ACTUAL', 'Y', 'N', 'N', 'Y',
        'Use AED as the primary currency when both AED and USD are shown. The final/actual cost column goes to amount and the budget column to reported_amount. VAT and ticketing-fee deductions are negative amounts. Capture supplier as vendor_or_payer and PO/invoice references as reference_number.',
        30);

    upsert_doc_cat('POST_EVENT_REPORT', 'Post Event Report', 'تقرير ما بعد الفعالية',
        'Post-event summary report or presentation from the organizer. Contains commercial summary (gross revenue, organizer revenue share, revenue streams such as F&B, retail, activations), ticket sales breakdown, visitor footfall, attendee demographics, vendor and sponsor counts, achievements and challenges.',
        'Y', 'ACTUAL', 'Y', 'Y', 'N', 'Y',
        'Revenue stream totals (ticketing, F&B, retail, activations, sponsorship) become REVENUE lines. Footfall, ticket counts, satisfaction scores, and vendor/sponsor counts become KPIs, not P&L lines.',
        40);

    upsert_doc_cat('EVENT_CONTRACT', 'Contract / Agreement', 'العقد / الاتفاقية',
        'Signed agreement between DCT and the event organizer (turnkey services agreement, service agreement, or amendment). Long legal document whose key data is the parties, event name and dates, total contract fee, payment schedule, revenue share terms, and KPIs.',
        'Y', 'BUDGET', 'Y', 'N', 'N', 'Y',
        'Extract the total contract fee and any budget breakdown table as BUDGET expense lines. Do not extract legal clauses as line items. Capture the contract reference number, organizer name, event dates, and any ticket revenue split percentage.',
        50);

    upsert_doc_cat('BOQ', 'BOQ / Bill of Quantities', 'جدول الكميات',
        'Bill of quantities or itemized cost sheet: numbered sections and sub-items with quantity, days/hours, unit cost, and total, plus agency fee and VAT.',
        'Y', 'BUDGET', 'Y', 'N', 'N', 'N',
        'Each numbered sub-item is one line with quantity, unit_cost, and amount (the row total). Use the section heading as raw_category. Agency fee and VAT are separate expense lines.',
        60);

    upsert_doc_cat('BUSINESS_CASE', 'Business Case', 'دراسة الجدوى',
        'Business case or investment justification for the event with projected revenues, costs, and expected outcomes.',
        'Y', 'BUDGET', 'Y', 'N', 'N', 'N', NULL, 70);

    upsert_doc_cat('COMMERCIAL_BUDGET', 'Commercial Budget / Proposal', 'الموازنة التجارية',
        'Commercial budget or commercial proposal from an agency or organizer: project budget with itemized costs, fees, and VAT for delivering the event.',
        'Y', 'BUDGET', 'Y', 'N', 'N', 'N',
        'Each budget item is one line with quantity, unit_cost, and amount. Use section headings as raw_category. Agency fee and VAT are separate expense lines.',
        80);

    upsert_doc_cat('BUDGET', 'Budget', 'الموازنة',
        'Approved or final event budget with planned expense and revenue amounts by category.',
        'Y', 'BUDGET', 'Y', 'N', 'N', 'N', NULL, 90);

    upsert_doc_cat('SPONSORSHIP_FILE', 'Sponsorship File', 'ملف الرعاية',
        'Sponsorship agreements, sponsor decks, or sponsorship revenue summaries. Reference material — not a trusted P&L source.',
        'N', NULL, 'N', 'N', 'N', 'N', NULL, 100);

    upsert_doc_cat('INVOICE', 'Invoice', 'فاتورة',
        'Supplier or organizer invoice for event-related goods or services. Supporting document — not a primary P&L source.',
        'N', NULL, 'N', 'N', 'N', 'N', NULL, 110);

    upsert_doc_cat('QUOTATION_LOA', 'Quotation / LOA', 'عرض سعر / خطاب ترسية',
        'Quotation or letter of award for event services. Supporting document.',
        'N', NULL, 'N', 'N', 'N', 'N', NULL, 120);

    upsert_doc_cat('EMAIL', 'Email', 'بريد إلكتروني',
        'Email correspondence (.eml / .msg) relating to the event — confirmations, clarifications, or figures communicated by email.',
        'N', NULL, 'N', 'N', 'N', 'N', NULL, 130);

    upsert_doc_cat('OTHER', 'Other Document', 'مستند آخر',
        'Any event document that does not match another category. Requires manual review.',
        'N', NULL, 'N', 'N', 'N', 'N', NULL, 999);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Document categories seeded: 14');
END;
/

-- =============================================================================
-- 7. P&L CATEGORIES — verbatim from the P&L Automation workbook
--    "Enhanced Cost lines" (18) + "Enhanced Revenue lines" (16) sheets.
-- =============================================================================
DECLARE
    PROCEDURE upsert_pnl_cat (
        p_code VARCHAR2, p_en VARCHAR2, p_type VARCHAR2, p_desc VARCHAR2, p_ord NUMBER
    ) IS
    BEGIN
        MERGE INTO dct_ar_pnl_categories t
        USING (SELECT p_code AS category_code FROM dual) s
        ON (t.category_code = s.category_code)
        WHEN NOT MATCHED THEN
            INSERT (category_code, category_name_en, category_type, description,
                    display_order, is_active, created_by)
            VALUES (p_code, p_en, p_type, p_desc, p_ord, 'Y', 'SEED')
        WHEN MATCHED THEN
            UPDATE SET category_name_en = p_en,
                       category_type    = p_type,
                       description      = p_desc,
                       display_order    = p_ord;
    END;
BEGIN
    -- ── Expense categories (workbook: Enhanced Cost lines) ──────────────────
    upsert_pnl_cat('VENUE_RENTAL', 'Venue Rental & Site Hire', 'EXPENSE',
        'Costs to secure and use the event location or site including charges required to occupy or operate within the space', 10);
    upsert_pnl_cat('TALENT_GUESTS', 'Talent / Guests (All-In)', 'EXPENSE',
        'All costs to engage and support performers, speakers, or guests including fees, travel, flights, accommodation, visas, and handling', 20);
    upsert_pnl_cat('PRODUCTION', 'Production (Incl. AV & Show Technical)', 'EXPENSE',
        'Costs related to designing, building, setting up, and technically delivering the event including production and show technical', 30);
    upsert_pnl_cat('MARKETING_MEDIA', 'Marketing & Media (Incl. PR & Communications)', 'EXPENSE',
        'Costs to promote the event and manage external communications including paid media, campaigns, digital activities, and PR', 40);
    upsert_pnl_cat('IP_RIGHTS', 'IP Rights', 'EXPENSE',
        'Costs for acquiring or using intellectual property including rights, licensing, and protected formats or content', 50);
    upsert_pnl_cat('PERMITS_LICENSES', 'Permits & Licenses', 'EXPENSE',
        'Costs to obtain legal approvals, regulatory permissions, and authorizations required to execute the event', 60);
    upsert_pnl_cat('EVENT_MANAGEMENT', 'Event Management', 'EXPENSE',
        'Costs for planning, coordinating, and managing event delivery through internal teams or external agencies, Agency, PM', 70);
    upsert_pnl_cat('TICKETING_SERVICES', 'Ticketing Services', 'EXPENSE',
        'Costs for managing ticketing systems, platforms, and access control for event entry', 80);
    upsert_pnl_cat('EVENT_OPERATIONS', 'Event Operations (Incl. Security)', 'EXPENSE',
        'Costs to operate the event on-ground including security, safety, cleaning, waste, traffic, and H&S support', 90);
    upsert_pnl_cat('STAFFING_MANPOWER', 'Staffing & Manpower', 'EXPENSE',
        'Costs for hiring and managing temporary or event-specific personnel for execution', 100);
    upsert_pnl_cat('HOSPITALITY_FB', 'Hospitality & Catering (F&B)', 'EXPENSE',
        'Costs for providing food, beverages, and catering services during the event', 110);
    upsert_pnl_cat('LOGISTICS_TRANSPORT', 'Logistics & Transportation', 'EXPENSE',
        'Costs for transporting people, equipment, and materials required for the event', 120);
    upsert_pnl_cat('PROFESSIONAL_SERVICES', 'Professional Services', 'EXPENSE',
        'Costs for specialized advisory or expert services such as consulting, translation, and planning', 130);
    upsert_pnl_cat('SPONSORSHIP_CASH_EXP', 'Sponsorship - Cash (Cost)', 'EXPENSE',
        'Cash-based sponsorship-related financial flows and costs', 140);
    upsert_pnl_cat('SPONSORSHIP_VIK_EXP', 'Sponsorship - VIK (Cost)', 'EXPENSE',
        'Non-cash sponsorship contributions valued as goods or services', 150);
    upsert_pnl_cat('MANAGEMENT_FEE', 'Management Fee', 'EXPENSE',
        'Costs charged for overall management and oversight not tied to a specific activity', 160);
    upsert_pnl_cat('CONTINGENCY', 'Contingency', 'EXPENSE',
        'Reserved or adjustment amounts for risk, uncertainty, or budget control', 170);
    upsert_pnl_cat('OTHER_COST', 'Other Cost', 'EXPENSE',
        'Miscellaneous, temporary category for unclassified costs requiring further review and reassignment, immaterial', 180);

    -- ── Revenue categories (workbook: Enhanced Revenue lines) ───────────────
    upsert_pnl_cat('TICKETING_REV', 'Ticketing Revenue', 'REVENUE',
        'Revenue generated from the sale of standard tickets for event access', 510);
    upsert_pnl_cat('PREMIUM_TICKETING_REV', 'Premium / VIP Ticketing Revenue', 'REVENUE',
        'Revenue from premium or VIP ticket tiers with enhanced access or benefits', 520);
    upsert_pnl_cat('COMP_TICKETS', 'Complimentary Tickets (Non-Revenue)', 'REVENUE',
        'Non-cash tickets issued without charge, tracked for reporting but not contributing to revenue', 530);
    upsert_pnl_cat('SPONSORSHIP_CASH_REV', 'Sponsorship - Cash', 'REVENUE',
        'Monetary sponsorship income received from partners', 540);
    upsert_pnl_cat('SPONSORSHIP_VIK_REV', 'Sponsorship - VIK', 'REVENUE',
        'Non-cash sponsorship contributions valued financially through goods or services', 550);
    upsert_pnl_cat('IP_SALE', 'IP Sale', 'REVENUE',
        'Revenue from selling or licensing intellectual property, formats, or content', 560);
    upsert_pnl_cat('FB_REV', 'Food & Beverage Revenue', 'REVENUE',
        'Revenue from sale of food, beverages, and catering services', 570);
    upsert_pnl_cat('ALCOHOL_REV', 'Alcohol Sales Revenue', 'REVENUE',
        'Revenue from sale of alcoholic beverages', 580);
    upsert_pnl_cat('MERCHANDISING_REV', 'Merchandising, Books & Publications', 'REVENUE',
        'Revenue from sale of merchandise, books, and publications', 590);
    upsert_pnl_cat('VALET_PARKING_REV', 'Valet & Parking Revenue', 'REVENUE',
        'Revenue from parking and valet services', 600);
    upsert_pnl_cat('ADVERTISING_MEDIA_REV', 'Advertising & Media Revenue', 'REVENUE',
        'Revenue from advertising placements and media exposure', 610);
    upsert_pnl_cat('ACTIVATIONS_REV', 'Activations Revenue', 'REVENUE',
        'Revenue from commercial partnerships and brand activations', 620);
    upsert_pnl_cat('VENUE_RENTAL_REV', 'Venue & Space Rental Revenue', 'REVENUE',
        'Revenue from renting out event spaces or facilities', 630);
    upsert_pnl_cat('PARTICIPATION_FEES', 'Participation & Registration Fees', 'REVENUE',
        'Revenue from participation, exhibition, or registration fees', 640);
    upsert_pnl_cat('GRANTS_SUPPORT', 'Grants & Government Support', 'REVENUE',
        'Funding received from government or institutional grants', 650);
    upsert_pnl_cat('OTHER_REVENUE', 'Other Revenue', 'REVENUE',
        'Temporary category for revenue that requires further classification', 660);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('P&L categories seeded: 18 expense + 16 revenue');
END;
/

PROMPT === AR seed complete ===
