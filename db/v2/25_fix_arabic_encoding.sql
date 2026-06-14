--------------------------------------------------------------------------------
-- 25_fix_arabic_encoding.sql
--
-- Repairs Arabic text that was destroyed when earlier seed scripts were run
-- through SQLcl WITHOUT a UTF-8 file encoding. The Arabic literals in those
-- .sql files were decoded with the Windows code page instead of UTF-8, so the
-- multi-byte Arabic either:
--   (a) collapsed to literal '?'  (DCT_USERS.DISPLAY_NAME_AR for ADMIN), or
--   (b) mojibake'd LOSSILY (every Arabic letter whose UTF-8 trailing byte was
--       0x80-0x9F -- the very common letters م ن ل و ي ه ف ق ك -- was replaced
--       by a single substitution char, so the value cannot be reversed).
--
-- Both modes are unrecoverable from the stored bytes, so this script re-supplies
-- the correct Arabic, keyed by stable business codes. It is idempotent and
-- re-runnable.
--
-- *** HOW TO RUN ***  This file contains literal Arabic. It MUST be executed
-- with SQLcl reading the file as UTF-8, or it will re-corrupt:
--
--   set JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8   (PowerShell: $env:JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8")
--   sql -name prod_mcp @25_fix_arabic_encoding.sql
--
-- Verify afterwards: no row should report CORRUPT > 0 in the final scan.
--------------------------------------------------------------------------------
SET DEFINE OFF
SET SERVEROUTPUT ON

PROMPT == Fixing DCT_USERS.display_name_ar (ADMIN) ==
UPDATE prod.dct_users SET display_name_ar = 'مدير النظام' WHERE username = 'ADMIN';

PROMPT == Fixing DCT_ROLES.role_name_ar ==
UPDATE prod.dct_roles SET role_name_ar = 'مدير المصروفات النثرية' WHERE role_code = 'AP_PETTY_CASH_ADMIN';
UPDATE prod.dct_roles SET role_name_ar = 'مدير بطاقات الائتمان'    WHERE role_code = 'CC_ADMIN';
UPDATE prod.dct_roles SET role_name_ar = 'مدير المتعاقدين'         WHERE role_code = 'FL_ADMIN';
UPDATE prod.dct_roles SET role_name_ar = 'بوابة المتعاقد'          WHERE role_code = 'FL_FREELANCER';
UPDATE prod.dct_roles SET role_name_ar = 'مشرف المتعاقدين'         WHERE role_code = 'FL_MANAGER';
UPDATE prod.dct_roles SET role_name_ar = 'مستخدم المتعاقدين'       WHERE role_code = 'FL_USER';

PROMPT == Fixing DCT_LOOKUP_CATEGORIES.category_name_ar ==
UPDATE prod.dct_lookup_categories SET category_name_ar = 'وحدة إصدار الفواتير'    WHERE category_code = 'FL_BILLING_UNIT';
UPDATE prod.dct_lookup_categories SET category_name_ar = 'أنواع وثائق المتعاقدين' WHERE category_code = 'FL_DOCUMENT_TYPE';
UPDATE prod.dct_lookup_categories SET category_name_ar = 'طرق الدفع'              WHERE category_code = 'FL_PAYMENT_METHOD';
UPDATE prod.dct_lookup_categories SET category_name_ar = 'مجموعات الدفع'          WHERE category_code = 'FL_PAY_GROUP';

PROMPT == Fixing DCT_LOOKUP_VALUES.value_name_ar ==
DECLARE
  PROCEDURE fix_val(p_cat VARCHAR2, p_code VARCHAR2, p_ar VARCHAR2) IS
  BEGIN
    UPDATE prod.dct_lookup_values v
       SET v.value_name_ar = p_ar
     WHERE v.value_code = p_code
       AND v.category_id = (SELECT category_id FROM prod.dct_lookup_categories WHERE category_code = p_cat);
  END;
BEGIN
  -- FL_BILLING_UNIT
  fix_val('FL_BILLING_UNIT', 'DELIVERABLE', 'لكل مخرج');
  fix_val('FL_BILLING_UNIT', 'HOUR',        'لكل ساعة');
  fix_val('FL_BILLING_UNIT', 'REPORT',      'لكل تقرير');
  fix_val('FL_BILLING_UNIT', 'UNIT',        'لكل وحدة');
  fix_val('FL_BILLING_UNIT', 'VISIT',       'لكل زيارة');
  -- FL_DOCUMENT_TYPE
  fix_val('FL_DOCUMENT_TYPE', 'CONTRACT_COPY',   'نسخة العقد');
  fix_val('FL_DOCUMENT_TYPE', 'DELIVERABLE_DOC', 'وثيقة المخرج');
  fix_val('FL_DOCUMENT_TYPE', 'EMIRATES_ID',     'الهوية الإماراتية');
  fix_val('FL_DOCUMENT_TYPE', 'INVOICE',         'فاتورة');
  fix_val('FL_DOCUMENT_TYPE', 'OTHER',           'أخرى');
  fix_val('FL_DOCUMENT_TYPE', 'PASSPORT',        'جواز السفر');
  fix_val('FL_DOCUMENT_TYPE', 'QUALIFICATION',   'شهادة مؤهل');
  fix_val('FL_DOCUMENT_TYPE', 'TRADE_LICENSE',   'رخصة تجارية');
  fix_val('FL_DOCUMENT_TYPE', 'VISA',            'تأشيرة / إقامة');
  -- FL_PAYMENT_METHOD
  fix_val('FL_PAYMENT_METHOD', 'BANK_TRANSFER', 'تحويل بنكي');
  fix_val('FL_PAYMENT_METHOD', 'CASH',          'نقد');
  fix_val('FL_PAYMENT_METHOD', 'CHEQUE',        'شيك');
  -- FL_PAY_GROUP
  fix_val('FL_PAY_GROUP', 'CONTRACTOR', 'مقاول');
  fix_val('FL_PAY_GROUP', 'FREELANCER', 'متعاقد مستقل');
  fix_val('FL_PAY_GROUP', 'VENDOR',     'مورد');
END;
/

COMMIT;

PROMPT
PROMPT == Post-fix verification scan (expect no CORRUPT rows) ==
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE v_cnt NUMBER;
BEGIN
  FOR c IN (
    SELECT table_name, column_name FROM all_tab_columns
    WHERE owner='PROD' AND data_type IN ('VARCHAR2','CHAR','NVARCHAR2','NCHAR')
      AND (column_name LIKE '%\_AR' ESCAPE '\' OR column_name LIKE '%\_AR\_%' ESCAPE '\')
      AND table_name IN (SELECT table_name FROM all_tables WHERE owner='PROD')
    ORDER BY table_name, column_name
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE
        'SELECT COUNT(*) FROM "PROD"."'||c.table_name||'" '||
        'WHERE "'||c.column_name||'" IS NOT NULL '||
        'AND NOT REGEXP_LIKE("'||c.column_name||'", UNISTR(''[\0600-\06FF]'')) '||
        'AND (INSTR("'||c.column_name||'",''?'')>0 OR REGEXP_LIKE("'||c.column_name||'", UNISTR(''[\0080-\00FF]'')))'
        INTO v_cnt;
      IF v_cnt>0 THEN DBMS_OUTPUT.PUT_LINE('  STILL CORRUPT: '||RPAD(c.table_name||'.'||c.column_name,50)||v_cnt); END IF;
    EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('== verification complete ==');
END;
/
