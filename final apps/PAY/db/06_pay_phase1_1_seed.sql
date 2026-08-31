-- PAY Phase 1.1 configurable governance vocabulary (re-runnable)
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

DECLARE
  l_cat NUMBER;
  PROCEDURE cat(p_code VARCHAR2,p_en VARCHAR2,p_ar VARCHAR2) IS
  BEGIN
    UPDATE prod.dct_lookup_categories SET category_name_en=p_en,category_name_ar=p_ar,is_active='Y'
     WHERE category_code=p_code;
    IF SQL%ROWCOUNT=0 THEN
      INSERT INTO prod.dct_lookup_categories(category_code,category_name_en,category_name_ar,is_system,is_active)
      VALUES(p_code,p_en,p_ar,'Y','Y');
    END IF;
    SELECT category_id INTO l_cat FROM prod.dct_lookup_categories WHERE category_code=p_code;
  END;
  PROCEDURE val(p_code VARCHAR2,p_en VARCHAR2,p_ar VARCHAR2,p_ord NUMBER,p_def VARCHAR2 DEFAULT 'N') IS
  BEGIN
    UPDATE prod.dct_lookup_values SET value_name_en=p_en,value_name_ar=p_ar,display_order=p_ord,is_active='Y',is_default=p_def
     WHERE category_id=l_cat AND value_code=p_code;
    IF SQL%ROWCOUNT=0 THEN
      INSERT INTO prod.dct_lookup_values(category_id,value_code,value_name_en,value_name_ar,display_order,is_default,is_active)
      VALUES(l_cat,p_code,p_en,p_ar,p_ord,p_def,'Y');
    END IF;
  END;
BEGIN
  cat('PAY_CONTACT_TYPE','Company Contact Type','نوع جهة اتصال الشركة');
  val('CONTRACT_MANAGER','Contract Manager','مدير العقد',10,'Y'); val('PAYROLL','Payroll','الرواتب',20);
  val('FINANCE','Finance / Invoice','المالية / الفواتير',30); val('SIGNATORY','Authorized Signatory','المفوض بالتوقيع',40);
  val('ESCALATION','Escalation','التصعيد',50); val('OTHER','Other','أخرى',90);

  cat('PAY_COMPLIANCE_TYPE','Company Compliance Type','نوع امتثال الشركة');
  val('TRADE_LICENSE','Trade License','الرخصة التجارية',10,'Y'); val('TAX_CERT','Tax Certificate','الشهادة الضريبية',20);
  val('BANK_CONFIRM','Bank Confirmation','تأكيد الحساب البنكي',30); val('INSURANCE','Insurance Certificate','شهادة التأمين',40);
  val('OUTSOURCE_PERMIT','Outsourcing Permit','تصريح الإسناد الخارجي',50); val('OTHER','Other','أخرى',90);

  cat('PAY_AMENDMENT_TYPE','Contract Amendment Type','نوع تعديل العقد');
  val('RENEWAL','Renewal','تجديد',10); val('EXTENSION','Extension','تمديد',20);
  val('PRICING','Pricing Change','تغيير الأسعار',30); val('SCOPE','Scope Change','تغيير النطاق',40);
  val('SUPPLIER_SITE','Supplier Site Change','تغيير موقع المورد',50); val('TERMINATION','Termination','إنهاء',60); val('OTHER','Other','أخرى',90);

  cat('PAY_FEE_TYPE','Contract Fee Type','نوع رسوم العقد');
  val('MANAGEMENT','Management Fee','رسوم الإدارة',10,'Y'); val('ADMINISTRATION','Administration Fee','رسوم إدارية',20);
  val('RECRUITMENT','Recruitment Fee','رسوم التوظيف',30); val('PROCESSING','Processing Fee','رسوم المعالجة',40); val('OTHER','Other','أخرى',90);

  cat('PAY_FEE_METHOD','Fee Calculation Method','طريقة احتساب الرسوم');
  val('PERCENT','Percentage','نسبة مئوية',10); val('FLAT','Flat per Period','مبلغ ثابت للفترة',20,'Y');
  val('PER_EMPLOYEE','Per Employee','لكل موظف',30); val('PER_TRANSACTION','Per Transaction','لكل معاملة',40);

  cat('PAY_SUPPLIER_SYNC_STATUS','Fusion Supplier Sync Status','حالة مزامنة مورد فيوجن');
  val('VALID','Valid','صالح',10,'Y'); val('CHANGED','Changed in Fusion','تم التغيير في فيوجن',20);
  val('INACTIVE','Inactive','غير نشط',30); val('SITE_DISABLED','Site Disabled','موقع معطل',40);
  val('BANK_CHANGED','Bank Changed — Review Required','تغيير البنك — يتطلب مراجعة',50); val('MISSING','Missing from Extract','غير موجود في الاستخراج',60);

  cat('PAY_RENEWAL_STATUS','Contract Renewal Status','حالة تجديد العقد');
  val('NOT_STARTED','Not Started','لم يبدأ',10,'Y'); val('UNDER_REVIEW','Under Review','قيد المراجعة',20);
  val('REQUESTED','Renewal Requested','تم طلب التجديد',30); val('APPROVED','Approved for Renewal','تمت الموافقة على التجديد',40);
  val('RENEWED','Renewed','تم التجديد',50); val('NOT_RENEWING','Not Renewing','لن يتم التجديد',60); val('TERMINATED','Terminated','منتهي',70);

  cat('PAY_RENEWAL_ACTION','Renewal Action','إجراء التجديد');
  val('REVIEW','Review','مراجعة',10); val('RENEW','Renew','تجديد',20); val('EXTEND','Extend','تمديد',30);
  val('REPLACE','Replace','استبدال',40); val('TERMINATE','Terminate','إنهاء',50); val('ESCALATE','Escalate','تصعيد',60);

  cat('PAY_RISK_RATING','Company Risk Rating','تصنيف مخاطر الشركة');
  val('LOW','Low','منخفض',10,'Y'); val('MEDIUM','Medium','متوسط',20); val('HIGH','High','مرتفع',30); val('CRITICAL','Critical','حرج',40);

  cat('PAY_DOCUMENT_CONTEXT','PAY Document Context','سياق مستندات الرواتب');
  val('COMPANY','Company','الشركة',10); val('CONTRACT','Contract','العقد',20); val('AMENDMENT','Amendment','تعديل العقد',30);
  COMMIT;
END;
/

DECLARE
  PROCEDURE doc(p_code VARCHAR2,p_en VARCHAR2,p_ar VARCHAR2,p_cat VARCHAR2,p_exp VARCHAR2,p_days NUMBER,p_seq NUMBER,p_context VARCHAR2,p_block VARCHAR2) IS l_id NUMBER;
  BEGIN
    UPDATE prod.dct_document_types SET doc_type_name_en=p_en,doc_type_name_ar=p_ar,doc_category=p_cat,
      applies_to_modules='PAY',has_expiry=p_exp,expiry_alert_days=p_days,is_active='Y',display_order=p_seq,updated_at=SYSTIMESTAMP
      WHERE doc_type_code=p_code;
    IF SQL%ROWCOUNT=0 THEN INSERT INTO prod.dct_document_types(doc_type_code,doc_type_name_en,doc_type_name_ar,doc_category,applies_to_modules,has_expiry,expiry_alert_days,display_order,created_by)
      VALUES(p_code,p_en,p_ar,p_cat,'PAY',p_exp,p_days,p_seq,'PAY_SEED'); END IF;
    SELECT doc_type_id INTO l_id FROM prod.dct_document_types WHERE doc_type_code=p_code;
    UPDATE prod.dct_pay_doc_rule SET is_mandatory='Y',blocking_flag=p_block,expiry_alert_days=p_days,display_seq=p_seq,is_active='Y',updated_by='PAY_SEED',updated_at=SYSTIMESTAMP
      WHERE context_code=p_context AND doc_type_id=l_id;
    IF SQL%ROWCOUNT=0 THEN INSERT INTO prod.dct_pay_doc_rule(context_code,doc_type_id,is_mandatory,blocking_flag,expiry_alert_days,display_seq,created_by)
      VALUES(p_context,l_id,'Y',p_block,p_days,p_seq,'PAY_SEED'); END IF;
  END;
BEGIN
  doc('PAY_TRADE_LICENSE','Trade License','الرخصة التجارية','LEGAL','Y',60,10,'COMPANY','Y');
  doc('PAY_TAX_CERT','Tax Certificate','الشهادة الضريبية','FINANCIAL','Y',60,20,'COMPANY','Y');
  doc('PAY_BANK_CONFIRM','Bank Confirmation','تأكيد الحساب البنكي','FINANCIAL','N',0,30,'COMPANY','Y');
  doc('PAY_INSURANCE','Insurance Certificate','شهادة التأمين','LEGAL','Y',60,40,'COMPANY','N');
  doc('PAY_SIGNED_CONTRACT','Signed Contract','العقد الموقع','LEGAL','Y',60,10,'CONTRACT','Y');
  doc('PAY_PRICING_SCHEDULE','Pricing Schedule','جدول الأسعار','FINANCIAL','N',0,20,'CONTRACT','Y');
  doc('PAY_PO','Purchase Order','أمر الشراء','FINANCIAL','Y',30,30,'CONTRACT','N');
  doc('PAY_AMENDMENT','Signed Amendment','تعديل العقد الموقع','LEGAL','Y',60,10,'AMENDMENT','Y');
  COMMIT;
END;
/

PROMPT === PAY Phase 1.1 lookups seeded ===
