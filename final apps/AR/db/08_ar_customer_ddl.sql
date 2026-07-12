-- =============================================================================
-- i-Finance V2 -- AR Customer (DoF Fusion Receivables SOAP) -- DDL + Seed
-- File    : 08_ar_customer_ddl.sql
-- Schema  : PROD (run as ADMIN: sql -name prod_mcp)
-- Run     : after 01/02; rerunnable (safe drop + upserts)
-- Spec    : final apps/AR/docs/ws/receivables-customer-ws.md
-- =============================================================================
-- Adds:
--   1. DCT_AR_CUSTOMERS       -- local store of customer submissions to Fusion
--   2. Lookup categories AR_CUST_* (lookup-first, no status CHECKs)
--   3. Module settings AR_WS_* (endpoints, env switch, live switch)
--   4. Network ACL for PROD to the gateway hosts
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

ALTER SESSION SET CURRENT_SCHEMA = PROD;

-- =============================================================================
-- 1. SAFE DROP
-- =============================================================================
BEGIN
    FOR t IN (
        SELECT table_name FROM all_tables
        WHERE  owner = 'PROD' AND table_name = 'DCT_AR_CUSTOMERS'
    ) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE prod.' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
        DBMS_OUTPUT.PUT_LINE('Dropped: ' || t.table_name);
    END LOOP;
END;
/

-- =============================================================================
-- 2. DCT_AR_CUSTOMERS
--    One row per customer submission (CREATE or UPDATE-SITE-CUSTOMER).
--    payload_json holds the FULL form snapshot (all 68 service attributes);
--    the mirrored columns below exist for list/search/reporting only.
--    ws_status is lookup-first (AR_CUST_WS_STATUS): DRAFT, SENT, PROCESSED, ERROR
-- =============================================================================
CREATE TABLE dct_ar_customers (
    customer_id            NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    trx_oper               VARCHAR2(40)   DEFAULT 'CREATE' NOT NULL,   -- AR_CUST_TRX_OPER
    customer_type          VARCHAR2(30)   DEFAULT 'ORGANIZATION' NOT NULL,
    customer_name          VARCHAR2(400)  NOT NULL,
    customer_name_ar       VARCHAR2(400),
    customer_class_name    VARCHAR2(100),
    customer_category_name VARCHAR2(100),
    country_code           VARCHAR2(3),
    emirate                VARCHAR2(50),
    city                   VARCHAR2(100),
    site_name              VARCHAR2(200),
    site_code              VARCHAR2(100),
    trade_license_num      VARCHAR2(100),
    legacy_customer_number VARCHAR2(100),                              -- our reference; key for status sync
    legacy_site_number     VARCHAR2(100),
    contact_person         VARCHAR2(200),
    contact_number         VARCHAR2(60),
    email_address          VARCHAR2(200),
    vat_number             VARCHAR2(30),
    payload_json           CLOB           CHECK (payload_json IS JSON),
    ws_status              VARCHAR2(20)   DEFAULT 'DRAFT' NOT NULL,    -- AR_CUST_WS_STATUS
    fusion_customer_code   VARCHAR2(100),                              -- captured on PROCESSED
    fusion_site_number     VARCHAR2(100),
    ws_env                 VARCHAR2(10),                               -- env used at submit (STAGE/PROD/MOCK)
    ws_request_xml         CLOB,
    ws_response_xml        CLOB,
    error_message          VARCHAR2(4000),
    submitted_at           TIMESTAMP,
    processed_at           TIMESTAMP,
    is_active              VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    created_by             VARCHAR2(100),
    created_at             TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by             VARCHAR2(100),
    updated_at             TIMESTAMP
);

CREATE INDEX idx_dct_arc_status  ON dct_ar_customers (ws_status);
CREATE INDEX idx_dct_arc_legacy  ON dct_ar_customers (legacy_customer_number);
CREATE INDEX idx_dct_arc_name    ON dct_ar_customers (UPPER(customer_name));

COMMENT ON TABLE dct_ar_customers IS
'AR Customer submissions to DoF Fusion Receivables (CreateCustomers SOAP). payload_json = full attribute snapshot; ws_status: DRAFT/SENT/PROCESSED/ERROR (lookup AR_CUST_WS_STATUS).';

PROMPT Table created: DCT_AR_CUSTOMERS

-- =============================================================================
-- 3. LOOKUP CATEGORIES + VALUES (AR_CUST_*)
--    value_code carries the EXACT wire value the service expects.
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
    upsert_category('AR_CUST_WS_STATUS', 'AR Customer Submission Status', 'حالة إرسال العميل', v_cat);
    upsert_value(v_cat, 'DRAFT',     'Draft',                  'مسودة',          10, 'Y');
    upsert_value(v_cat, 'SENT',      'Sent - Awaiting Fusion', 'أرسل - بانتظار المعالجة', 20);
    upsert_value(v_cat, 'PROCESSED', 'Processed',              'تمت المعالجة',   30);
    upsert_value(v_cat, 'ERROR',     'Error',                  'خطأ',            40);

    upsert_category('AR_CUST_TRX_OPER', 'AR Customer Operation', 'عملية العميل', v_cat);
    upsert_value(v_cat, 'CREATE',               'Create Customer',      'إنشاء عميل',        10, 'Y');
    upsert_value(v_cat, 'UPDATE-SITE-CUSTOMER', 'Update Site Customer', 'تحديث موقع العميل', 20);

    upsert_category('AR_CUST_TYPE', 'AR Customer Type', 'نوع العميل', v_cat);
    upsert_value(v_cat, 'ORGANIZATION', 'Organization', 'مؤسسة', 10, 'Y');
    upsert_value(v_cat, 'PERSON',       'Person',       'فرد',   20);

    upsert_category('AR_CUST_CLASS', 'AR Customer Class', 'فئة العميل', v_cat);
    upsert_value(v_cat, 'Local Company', 'Local Company', 'شركة محلية', 10, 'Y');
    upsert_value(v_cat, 'International', 'International', 'دولية',      20);
    upsert_value(v_cat, 'Local',         'Local',         'محلي',       30);

    upsert_category('AR_CUST_CATEGORY', 'AR Customer Category', 'تصنيف العميل', v_cat);
    upsert_value(v_cat, 'High Value Customer', 'High Value Customer', 'عميل عالي القيمة', 10, 'Y');

    upsert_category('AR_CUST_SITE_PURPOSE', 'AR Customer Site Purpose', 'غرض موقع العميل', v_cat);
    upsert_value(v_cat, 'BOTH',    'Bill To and Ship To', 'فوترة وشحن', 10, 'Y');
    upsert_value(v_cat, 'BILL_TO', 'Bill To',             'فوترة',      20);
    upsert_value(v_cat, 'SHIP_TO', 'Ship To',             'شحن',        30);

    upsert_category('AR_PERSON_IDEN_TYPE', 'AR Person Identifier Type', 'نوع معرف الشخص', v_cat);
    upsert_value(v_cat, 'ID_NUMBER', 'ID Number', 'رقم الهوية',        10, 'Y');
    upsert_value(v_cat, 'EMAIL',     'Email',     'البريد الإلكتروني', 20);

    upsert_category('AR_VAT_REG_TYPE', 'AR VAT Registration Type', 'نوع تسجيل الضريبة', v_cat);
    upsert_value(v_cat, 'VAT', 'VAT', 'ضريبة القيمة المضافة', 10, 'Y');

    upsert_category('AR_TAX_REGIME', 'AR Tax Regime', 'النظام الضريبي', v_cat);
    upsert_value(v_cat, 'VAT_REGIME_UAE', 'UAE VAT Regime', 'النظام الضريبي الإماراتي', 10, 'Y');

    upsert_category('AR_TAX_REG_REASON', 'AR No-TRN Reason', 'سبب عدم وجود رقم ضريبي', v_cat);
    upsert_value(v_cat, 'NO TRADE LICENSE', 'No Trade License', 'لا توجد رخصة تجارية', 10, 'Y');

    upsert_category('AR_CUST_PAYMENT_TERMS', 'AR Customer Payment Terms', 'شروط الدفع', v_cat);
    upsert_value(v_cat, 'IMMEDIATE', 'Immediate', 'فوري', 10, 'Y');

    upsert_category('AR_DELIVERY_METHOD', 'AR Delivery Method', 'طريقة التسليم', v_cat);
    upsert_value(v_cat, 'EMAIL', 'Email', 'البريد الإلكتروني', 10, 'Y');
    upsert_value(v_cat, 'PRINT', 'Print', 'طباعة',             20);

    upsert_category('AR_STATEMENT_CYCLE', 'AR Statement Cycle', 'دورة كشف الحساب', v_cat);
    upsert_value(v_cat, 'Monthly', 'Monthly', 'شهري', 10, 'Y');

    upsert_category('AR_COLLECTOR', 'AR Collector', 'المحصل', v_cat);
    upsert_value(v_cat, 'Default Collector', 'Default Collector', 'المحصل الافتراضي', 10, 'Y');

    upsert_category('AR_CUST_PROFILE', 'AR Customer Profile', 'ملف العميل', v_cat);
    upsert_value(v_cat, 'DEFAULT', 'Default', 'افتراضي', 10, 'Y');

    upsert_category('AR_ACCT_RESP_TYPE', 'AR Account Contact Responsibility', 'مسؤولية جهة الاتصال', v_cat);
    upsert_value(v_cat, 'Statement', 'Statement', 'كشف حساب', 10, 'Y');

    upsert_category('AR_EMIRATE', 'AR Emirate', 'الإمارة', v_cat);
    upsert_value(v_cat, 'Abu Dhabi',      'Abu Dhabi',      'أبوظبي',        10, 'Y');
    upsert_value(v_cat, 'Dubai',          'Dubai',          'دبي',           20);
    upsert_value(v_cat, 'Sharjah',        'Sharjah',        'الشارقة',       30);
    upsert_value(v_cat, 'Ajman',          'Ajman',          'عجمان',         40);
    upsert_value(v_cat, 'Umm Al Quwain',  'Umm Al Quwain',  'أم القيوين',    50);
    upsert_value(v_cat, 'Ras Al Khaimah', 'Ras Al Khaimah', 'رأس الخيمة',    60);
    upsert_value(v_cat, 'Fujairah',       'Fujairah',       'الفجيرة',       70);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Lookup categories seeded: AR_CUST_* (17 categories)');
END;
/

PROMPT Lookups seeded

-- =============================================================================
-- 4. MODULE SETTINGS -- AR_WS_* (module ACCOUNTS_RECEIVABLE)
--    Non-secret values only; secrets live in DCT_SYSTEM_SETTINGS (section 4b).
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
        t_setting('AR_WS_LIVE', 'N',
            'Customer WS Live Mode',
            'Y = customer submissions call the DoF Fusion Receivables gateway; N = mock mode (no outbound call, simulated response, rows still tracked).',
            'BOOLEAN', 'Y|N', 'N'),
        t_setting('AR_WS_ENV', 'STAGE',
            'Customer WS Environment',
            'Which gateway environment live submissions target. STAGE = stage-api (UAT); PROD = api.abudhabi.ae (requires IP whitelisting of the ADB outbound IP).',
            'SELECT', 'STAGE|PROD', 'STAGE'),
        t_setting('AR_WS_URL_STAGE', 'https://stage-api.abudhabi.ae/ws/Receivables_TEST/1.0',
            'Gateway URL - Stage',
            'DoF Receivables SOAP endpoint on the UAT/stage API gateway.',
            'TEXT', NULL, 'https://stage-api.abudhabi.ae/ws/Receivables_TEST/1.0'),
        t_setting('AR_WS_URL_PROD', 'https://api.abudhabi.ae/ws/Receivables/1.0',
            'Gateway URL - Production',
            'DoF Receivables SOAP endpoint on the production API gateway.',
            'TEXT', NULL, 'https://api.abudhabi.ae/ws/Receivables/1.0'),
        t_setting('AR_WS_USER', 'ADGE_DCT_INTG_SVC',
            'Gateway Basic Auth User',
            'HTTP Basic authentication username for the DoF Receivables service.',
            'TEXT', NULL, 'ADGE_DCT_INTG_SVC'),
        t_setting('AR_WS_ORG_CODE', 'DCT',
            'Fusion Org Code',
            'ORG_CODE stamped on every customer payload.',
            'TEXT', NULL, 'DCT'),
        t_setting('AR_WS_SOURCE_SYSTEM', 'DCT_SYSTEM',
            'Fusion Source System',
            'SOURCE_SYSTEM stamped on every customer payload.',
            'TEXT', NULL, 'DCT_SYSTEM')
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
                    v_settings(i).s_label, v_settings(i).s_desc, v_settings(i).s_type,
                    v_settings(i).s_allow, v_settings(i).s_def, SYSDATE)
        WHEN MATCHED THEN
            UPDATE SET setting_label       = v_settings(i).s_label,
                       setting_description = v_settings(i).s_desc,
                       value_type          = v_settings(i).s_type,
                       allowed_values      = v_settings(i).s_allow;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Module settings seeded: AR_WS_* (' || v_settings.COUNT || ')');
END;
/

PROMPT Settings seeded

-- =============================================================================
-- 4b. SYSTEM SETTINGS -- gateway secrets (platform secret pattern:
--     value_type STRING + is_encrypted Y + category SECURITY, masked in Admin).
--     AR_WS_PASSWORD_STAGE ships as CHANGE_ME until the UAT password is provided.
-- =============================================================================
DECLARE
    PROCEDURE upsert_secret (p_key VARCHAR2, p_val VARCHAR2, p_desc VARCHAR2) IS
    BEGIN
        MERGE INTO dct_system_settings t
        USING (SELECT p_key AS setting_key FROM dual) s
        ON (t.setting_key = s.setting_key)
        WHEN NOT MATCHED THEN
            INSERT (setting_key, setting_value, value_type, category,
                    description_en, is_encrypted, is_system, created_by)
            VALUES (p_key, p_val, 'STRING', 'SECURITY', p_desc, 'Y', 'N', 'SYSTEM')
        WHEN MATCHED THEN
            UPDATE SET t.description_en = p_desc;
    END;
BEGIN
    upsert_secret('AR_WS_APIKEY_STAGE', '1d9b23f1-bfca-43fc-8099-944fd7faf664',
        'AR Customer WS: x-CentraSite-APIKey for the STAGE gateway (stage-api.abudhabi.ae).');
    upsert_secret('AR_WS_APIKEY_PROD', '030140d2-85be-4830-9cf2-b435b570283b',
        'AR Customer WS: x-CentraSite-APIKey for the PROD gateway (api.abudhabi.ae).');
    upsert_secret('AR_WS_PASSWORD_STAGE', 'CHANGE_ME',
        'AR Customer WS: Basic auth password for the STAGE gateway (UAT).');
    upsert_secret('AR_WS_PASSWORD_PROD', '5fhQjevgW$aY34w',
        'AR Customer WS: Basic auth password for the PROD gateway.');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('System settings seeded: AR_WS_* secrets (4)');
END;
/

PROMPT Secrets seeded

-- =============================================================================
-- 5. NETWORK ACL -- allow PROD to reach both gateway hosts
--    (runs with ADMIN invoker rights; current_schema does not affect this)
-- =============================================================================
BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => 'stage-api.abudhabi.ae',
        ace  => xs$ace_type(privilege_list => xs$name_list('http', 'connect', 'resolve'),
                            principal_name => 'PROD',
                            principal_type => xs_acl.ptype_db));
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => 'api.abudhabi.ae',
        ace  => xs$ace_type(privilege_list => xs$name_list('http', 'connect', 'resolve'),
                            principal_name => 'PROD',
                            principal_type => xs_acl.ptype_db));
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Network ACL granted to PROD: stage-api.abudhabi.ae, api.abudhabi.ae');
END;
/

PROMPT ACL granted

-- =============================================================================
-- Verification
-- =============================================================================
SELECT COUNT(*) AS ar_customers_cols FROM all_tab_columns
WHERE  owner = 'PROD' AND table_name = 'DCT_AR_CUSTOMERS';

SELECT c.category_code, COUNT(v.value_id) AS vals
FROM   dct_lookup_categories c
LEFT   JOIN dct_lookup_values v ON v.category_id = c.category_id
WHERE  c.category_code LIKE 'AR_CUST%' OR c.category_code IN
       ('AR_PERSON_IDEN_TYPE','AR_VAT_REG_TYPE','AR_TAX_REGIME','AR_TAX_REG_REASON',
        'AR_DELIVERY_METHOD','AR_STATEMENT_CYCLE','AR_COLLECTOR','AR_ACCT_RESP_TYPE','AR_EMIRATE')
GROUP  BY c.category_code ORDER BY 1;

SELECT setting_key, value_type FROM dct_module_settings
WHERE  setting_key LIKE 'AR_WS%' ORDER BY 1;

SELECT setting_key, is_encrypted FROM dct_system_settings
WHERE  setting_key LIKE 'AR_WS%' ORDER BY 1;

PROMPT 08_ar_customer_ddl.sql complete
EXIT
