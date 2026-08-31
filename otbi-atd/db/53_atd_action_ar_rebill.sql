-- ===========================================================================
-- otbi-atd : 53 action type seed - AR_INVOICE_REBILL
-- File    : 53_atd_action_ar_rebill.sql   (rerunnable)
-- ===========================================================================
-- Third Fusion write-back action type: credit an AR invoice off in full,
-- duplicate it, correct the tax classification on the affected memo lines,
-- complete the duplicate, then set the Project/Task DFF on each line.
--
-- The queue, the ORDS layer and the App 208 UI are all generic over
-- action_type, so the action type itself is the only mandatory DB change.
-- The other vocabularies here exist so the AR page's dropdowns are
-- lookup-first: finance adds a new credit reason or tax classification in
-- Admin lookups, with no deploy.
--
-- Plain INSERT-if-absent, no MERGE blocks. CRLF, UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO ON

-- ---------------------------------------------------------------------------
-- Helper : seed a category and its values without MERGE
-- ---------------------------------------------------------------------------
DECLARE
  v_cat NUMBER;

  PROCEDURE ensure_category(p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
    n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO n FROM prod.dct_lookup_categories WHERE category_code = p_code;
    IF n = 0 THEN
      INSERT INTO prod.dct_lookup_categories
             (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
      VALUES (p_code, p_en, p_ar, NULL, 'Y', 'Y');
    END IF;
    SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
  END;

  PROCEDURE ensure_value(p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                         p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N') IS
    n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO n FROM prod.dct_lookup_values
     WHERE category_id = p_cat AND value_code = p_code;
    IF n = 0 THEN
      INSERT INTO prod.dct_lookup_values
             (category_id, value_code, value_name_en, value_name_ar,
              display_order, is_default, is_active)
      VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_default, 'Y');
    ELSE
      UPDATE prod.dct_lookup_values
         SET value_name_en = p_en,
             display_order = p_ord,
             is_active     = 'Y'
       WHERE category_id = p_cat AND value_code = p_code;
    END IF;
  END;

BEGIN
  -- the action type itself
  ensure_category('ATD_ACTION_TYPE', 'ATD Action Type', N'نوع إجراء الموزع', v_cat);
  ensure_value(v_cat, 'AR_INVOICE_REBILL',
               'AR Invoice Rebill', N'إعادة إصدار فاتورة مدينين', 30);

  -- how the credit memo is finished (ours, not Fusion's)
  ensure_category('AR_REBILL_CM_FINISH', 'AR Rebill Credit Memo Finish',
                  N'إنهاء إشعار الخصم', v_cat);
  ensure_value(v_cat, 'COMPLETE_AND_CLOSE', 'Complete and Close', N'إكمال وإغلاق', 10, 'Y');
  ensure_value(v_cat, 'SAVE',               'Save',               N'حفظ',         20);

  -- credit reasons offered on the AR page (extend in Admin lookups, no deploy)
  ensure_category('AR_CREDIT_REASON', 'AR Credit Reason', N'سبب الإشعار الدائن', v_cat);
  ensure_value(v_cat, 'Tax rate error', 'Tax rate error', N'خطأ في نسبة الضريبة', 10, 'Y');

  -- tax classifications offered per line
  ensure_category('AR_TAX_CLASSIFICATION', 'AR Tax Classification',
                  N'التصنيف الضريبي', v_cat);
  ensure_value(v_cat, 'VAT OUTPUT - STD', 'VAT OUTPUT - STD',
               N'ضريبة القيمة المضافة - قياسي', 10, 'Y');

  -- saga stage labels, for the request timeline on the AR page
  ensure_category('AR_REBILL_STAGE', 'AR Rebill Stage', N'مرحلة إعادة الإصدار', v_cat);
  ensure_value(v_cat, 'LOCATE',        'Locate invoice',            N'البحث عن الفاتورة',        10);
  ensure_value(v_cat, 'CM_CREATE',     'Create credit memo',        N'إنشاء إشعار دائن',         20);
  ensure_value(v_cat, 'CM_CONFIRM',    'Confirm credit memo',       N'تأكيد الإشعار الدائن',     30);
  ensure_value(v_cat, 'CM_CAPTURE',    'Capture CM document no.',   N'التقاط رقم مستند الإشعار', 40);
  ensure_value(v_cat, 'DUPLICATE',     'Duplicate invoice',         N'نسخ الفاتورة',             50);
  ensure_value(v_cat, 'DUP_EDIT',      'Apply tax classification',  N'تطبيق التصنيف الضريبي',    60);
  ensure_value(v_cat, 'DUP_COMPLETE',  'Complete duplicate',        N'إكمال الفاتورة الجديدة',   80);
  ensure_value(v_cat, 'DUP_CAPTURE',   'Capture invoice document no.', N'التقاط رقم المستند',    90);
  ensure_value(v_cat, 'DUP_LINE_DFF',  'Set project and task',      N'تحديد المشروع والمهمة',    70);

  COMMIT;
  DBMS_OUTPUT.put_line('AR_INVOICE_REBILL vocabularies seeded');
END;
/

-- ---------------------------------------------------------------------------
-- Verify
-- ---------------------------------------------------------------------------
SELECT c.category_code, v.value_code, v.value_name_en, v.display_order, v.is_active
  FROM prod.dct_lookup_values v
  JOIN prod.dct_lookup_categories c ON c.category_id = v.category_id
 WHERE c.category_code IN ('ATD_ACTION_TYPE','AR_REBILL_CM_FINISH','AR_CREDIT_REASON',
                           'AR_TAX_CLASSIFICATION','AR_REBILL_STAGE')
 ORDER BY c.category_code, v.display_order;

SET ECHO OFF
PROMPT otbi-atd 53 AR rebill seed : done
