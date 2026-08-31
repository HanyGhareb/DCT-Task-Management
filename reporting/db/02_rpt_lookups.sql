-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 02 lookups (lookup-first vocabularies)
-- File   : reporting/db/02_rpt_lookups.sql
-- Run as : sql -name prod_mcp
-- Purpose: seed the RPT_* lookup categories + values in DCT_LOOKUP_VALUES so the
--          package validates status/enum sets via DCT_LOOKUP_PKG.validate_lookup
--          (no status CHECK constraints on the DCT_RPT_* tables). Manage values
--          afterwards in Admin > Lookups.
-- Idempotent: MERGE upserts (never clobbers manual edits beyond name/order).
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  v_cat NUMBER;

  PROCEDURE upsert_category (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
  BEGIN
    MERGE INTO prod.dct_lookup_categories t
    USING (SELECT p_code AS category_code FROM dual) s
    ON (t.category_code = s.category_code)
    WHEN NOT MATCHED THEN
      INSERT (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
      VALUES (p_code, p_en, p_ar, NULL, 'Y', 'Y')
    WHEN MATCHED THEN
      UPDATE SET t.category_name_en = p_en, t.category_name_ar = p_ar;
    SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
  END;

  PROCEDURE upsert_value (p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                          p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N') IS
  BEGIN
    MERGE INTO prod.dct_lookup_values t
    USING (SELECT p_cat AS category_id, p_code AS value_code FROM dual) s
    ON (t.category_id = s.category_id AND t.value_code = s.value_code)
    WHEN NOT MATCHED THEN
      INSERT (category_id, value_code, value_name_en, value_name_ar, display_order, is_default, is_active)
      VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_default, 'Y')
    WHEN MATCHED THEN
      UPDATE SET t.value_name_en = p_en, t.value_name_ar = p_ar, t.display_order = p_ord;
  END;
BEGIN
  -- report data source type
  upsert_category('RPT_SOURCE_TYPE', 'Report Source Type', 'نوع مصدر التقرير', v_cat);
  upsert_value(v_cat, 'VIEW', 'Database View', 'عرض قاعدة البيانات', 10, 'Y');
  upsert_value(v_cat, 'SQL',  'SQL Query',     'استعلام SQL',        20);
  upsert_value(v_cat, 'PKG',  'Package Call',  'استدعاء حزمة',       30);

  -- generation engine
  upsert_category('RPT_ENGINE', 'Report Engine', 'محرك التقرير', v_cat);
  upsert_value(v_cat, 'PYTHON', 'Python Microservice',  'خدمة بايثون',      10, 'Y');
  upsert_value(v_cat, 'NATIVE', 'Oracle Native (APEX)', 'أوراكل الأصلي',    20);

  -- output formats
  upsert_category('RPT_FORMAT', 'Report Format', 'صيغة التقرير', v_cat);
  upsert_value(v_cat, 'PDF',  'PDF',   'PDF',   10, 'Y');
  upsert_value(v_cat, 'XLSX', 'Excel', 'إكسل',  20);
  upsert_value(v_cat, 'PPTX', 'PowerPoint', 'باوربوينت', 25);
  upsert_value(v_cat, 'CSV',  'CSV',   'CSV',   30);

  -- run status
  upsert_category('RPT_RUN_STATUS', 'Report Run Status', 'حالة تشغيل التقرير', v_cat);
  upsert_value(v_cat, 'QUEUED',  'Queued',  'في الانتظار', 10, 'Y');
  upsert_value(v_cat, 'RUNNING', 'Running', 'قيد التنفيذ',  20);
  upsert_value(v_cat, 'SUCCESS', 'Success', 'ناجح',        30);
  upsert_value(v_cat, 'FAILED',  'Failed',  'فشل',         40);

  -- run trigger
  upsert_category('RPT_TRIGGER', 'Report Run Trigger', 'مصدر تشغيل التقرير', v_cat);
  upsert_value(v_cat, 'ONDEMAND', 'On Demand', 'عند الطلب', 10, 'Y');
  upsert_value(v_cat, 'SCHEDULE', 'Scheduled', 'مجدول',     20);

  -- recipient type
  upsert_category('RPT_RECIP_TYPE', 'Report Recipient Type', 'نوع مستلم التقرير', v_cat);
  upsert_value(v_cat, 'EMAIL', 'Email Address', 'بريد إلكتروني',  10, 'Y');
  upsert_value(v_cat, 'USER',  'Specific User', 'مستخدم محدد',    20);
  upsert_value(v_cat, 'ROLE',  'Role',          'دور',            30);
  upsert_value(v_cat, 'ORG',   'Organisation',  'وحدة تنظيمية',   40);
  upsert_value(v_cat, 'SELF',  'Requester',     'مقدم الطلب',     50);

  -- delivery channel
  upsert_category('RPT_CHANNEL', 'Report Delivery Channel', 'قناة تسليم التقرير', v_cat);
  upsert_value(v_cat, 'EMAIL',   'Email',          'بريد إلكتروني', 10, 'Y');
  upsert_value(v_cat, 'INAPP',   'In-App Notice',  'إشعار داخل التطبيق', 20);
  upsert_value(v_cat, 'PUSH',    'Mobile Push',    'إشعار الجوال',  30);
  upsert_value(v_cat, 'WEBHOOK', 'Webhook',        'ويب هوك',       40);

  -- delivery status
  upsert_category('RPT_DELIVERY_STATUS', 'Report Delivery Status', 'حالة تسليم التقرير', v_cat);
  upsert_value(v_cat, 'PENDING', 'Pending', 'معلق',  10, 'Y');
  upsert_value(v_cat, 'SENT',    'Sent',    'مرسل',  20);
  upsert_value(v_cat, 'FAILED',  'Failed',  'فشل',   30);
  upsert_value(v_cat, 'SKIPPED', 'Skipped', 'متخطى', 40);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('RPT_* lookup categories + values seeded.');
END;
/

PROMPT 02_rpt_lookups.sql complete.
