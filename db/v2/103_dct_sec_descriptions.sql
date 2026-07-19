-- =====================================================================
-- 103_dct_sec_descriptions.sql
-- Security Console review round (2026-07-19), user comment 1:
-- every privilege, privilege group and role must carry a proper
-- end-user description (EN + AR).
-- Fills description_en / description_ar ONLY where NULL (NVL-guarded,
-- rerunnable, never clobbers existing text). One deliberate overwrite:
-- FL_FREELANCER description_en had mojibake from a lossy encoding.
-- Run as ADMIN in a fresh SQLcl session with -Dfile.encoding=UTF-8.
-- =====================================================================
SET DEFINE OFF

-- ------------------------- ACCOUNTS RECEIVABLE -----------------------
UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Create new revenue events and edit their master details before review.'),
  description_ar = NVL(description_ar, 'إنشاء فعاليات إيرادات جديدة وتعديل بياناتها الأساسية قبل المراجعة.')
WHERE permission_code = 'AR.CREATE_EVENT';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Delete profit-and-loss lines from an event before it is confirmed.'),
  description_ar = NVL(description_ar, 'حذف بنود الأرباح والخسائر من الفعالية قبل اعتمادها.')
WHERE permission_code = 'AR.DELETE_LINES';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Export event profit-and-loss figures and reports to Excel or CSV.'),
  description_ar = NVL(description_ar, 'تصدير أرقام وتقارير الأرباح والخسائر إلى ملفات Excel أو CSV.')
WHERE permission_code = 'AR.EXPORT';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Maintain the catalogue of P&L item categories used to classify event lines.'),
  description_ar = NVL(description_ar, 'إدارة فئات بنود الأرباح والخسائر المستخدمة في تصنيف بنود الفعاليات.')
WHERE permission_code = 'AR.MANAGE_CATEGORIES';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Maintain the document categories available for event file uploads.'),
  description_ar = NVL(description_ar, 'إدارة فئات المستندات المتاحة لرفع ملفات الفعاليات.')
WHERE permission_code = 'AR.MANAGE_DOC_CATS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Create and compare what-if scenarios over an event profit-and-loss statement.'),
  description_ar = NVL(description_ar, 'إنشاء ومقارنة سيناريوهات افتراضية لقائمة أرباح وخسائر الفعالية.')
WHERE permission_code = 'AR.MANAGE_SCENARIOS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Configure Accounts Receivable module settings and defaults.'),
  description_ar = NVL(description_ar, 'ضبط إعدادات وحدة الذمم المدينة وقيمها الافتراضية.')
WHERE permission_code = 'AR.MODULE_SETTINGS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Review AI-classified profit-and-loss lines and confirm or correct them.'),
  description_ar = NVL(description_ar, 'مراجعة بنود الأرباح والخسائر المصنفة آلياً واعتمادها أو تصحيحها.')
WHERE permission_code = 'AR.REVIEW_PNL';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Run AI document classification and data extraction on uploaded event files.'),
  description_ar = NVL(description_ar, 'تشغيل التصنيف والاستخلاص الآلي للمستندات المرفوعة للفعاليات.')
WHERE permission_code = 'AR.RUN_AI';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Upload document folders and files to an event.'),
  description_ar = NVL(description_ar, 'رفع مجلدات وملفات المستندات إلى الفعالية.')
WHERE permission_code = 'AR.UPLOAD_FILES';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View events and their profit-and-loss data.'),
  description_ar = NVL(description_ar, 'عرض الفعاليات وبيانات أرباحها وخسائرها.')
WHERE permission_code = 'AR.VIEW_EVENTS';

-- ----------------------------- CREDIT CARDS --------------------------
UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Configure the approval workflow templates used for credit card requests.'),
  description_ar = NVL(description_ar, 'ضبط قوالب سير الاعتماد المستخدمة لطلبات بطاقات الائتمان.')
WHERE permission_code = 'CC.APPROVAL_RULES';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Approve or reject credit card requests routed to the holder.'),
  description_ar = NVL(description_ar, 'اعتماد أو رفض طلبات بطاقات الائتمان المحالة إلى المستخدم.')
WHERE permission_code = 'CC.APPROVE';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Approve or reject monthly card replenishment submissions.'),
  description_ar = NVL(description_ar, 'اعتماد أو رفض طلبات تعزيز رصيد البطاقة الشهرية.')
WHERE permission_code = 'CC.APPROVE_REPLENISHMENT';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Maintain the required-document checklist for each request type.'),
  description_ar = NVL(description_ar, 'إدارة قائمة المستندات المطلوبة لكل نوع من أنواع الطلبات.')
WHERE permission_code = 'CC.MANAGE_DOC_REQ';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Assign or revoke proxy submitters who act on behalf of cardholders.'),
  description_ar = NVL(description_ar, 'تعيين أو إلغاء المفوضين بالتقديم نيابة عن حاملي البطاقات.')
WHERE permission_code = 'CC.MANAGE_PROXIES';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Configure Credit Cards module settings and defaults.'),
  description_ar = NVL(description_ar, 'ضبط إعدادات وحدة بطاقات الائتمان وقيمها الافتراضية.')
WHERE permission_code = 'CC.MODULE_SETTINGS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Submit the monthly replenishment request for a corporate card.'),
  description_ar = NVL(description_ar, 'تقديم طلب التعزيز الشهري لبطاقة المؤسسة.')
WHERE permission_code = 'CC.REPLENISHMENT_SUBMIT';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View all replenishment submissions across the organisation.'),
  description_ar = NVL(description_ar, 'عرض جميع طلبات التعزيز على مستوى المؤسسة.')
WHERE permission_code = 'CC.REPLENISHMENT_VIEW';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Request a change to an existing card: limit adjustment, replacement or closure.'),
  description_ar = NVL(description_ar, 'طلب تعديل بطاقة قائمة: تغيير الحد أو الاستبدال أو الإغلاق.')
WHERE permission_code = 'CC.REQUEST_CHANGE';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Request the issue of a new corporate credit card.'),
  description_ar = NVL(description_ar, 'طلب إصدار بطاقة ائتمان مؤسسية جديدة.')
WHERE permission_code = 'CC.REQUEST_NEW';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View every credit card record across the organisation.'),
  description_ar = NVL(description_ar, 'عرض جميع سجلات بطاقات الائتمان في المؤسسة.')
WHERE permission_code = 'CC.VIEW_ALL';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View the holder''s own credit card and its requests.'),
  description_ar = NVL(description_ar, 'عرض بطاقة المستخدم الخاصة وطلباتها.')
WHERE permission_code = 'CC.VIEW_OWN';

-- ----------------------------- DUTY TRAVEL ---------------------------
UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Configure the approval workflow templates used for duty travel.'),
  description_ar = NVL(description_ar, 'ضبط قوالب سير الاعتماد المستخدمة لطلبات السفر الرسمي.')
WHERE permission_code = 'DT.APPROVAL_RULES';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Approve or reject duty travel requests routed to the holder.'),
  description_ar = NVL(description_ar, 'اعتماد أو رفض طلبات السفر الرسمي المحالة إلى المستخدم.')
WHERE permission_code = 'DT.APPROVE_REQUEST';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Approve or reject post-travel settlements.'),
  description_ar = NVL(description_ar, 'اعتماد أو رفض تسويات ما بعد السفر.')
WHERE permission_code = 'DT.APPROVE_SETTLEMENT';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Close a travelled request once its settlement is complete.'),
  description_ar = NVL(description_ar, 'إغلاق طلب السفر المنفذ بعد اكتمال تسويته.')
WHERE permission_code = 'DT.CLOSE_REQUEST';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Create and submit a duty travel request.'),
  description_ar = NVL(description_ar, 'إنشاء طلب سفر رسمي وتقديمه.')
WHERE permission_code = 'DT.CREATE_REQUEST';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Create the post-travel settlement for a completed trip.'),
  description_ar = NVL(description_ar, 'إنشاء تسوية ما بعد السفر لرحلة مكتملة.')
WHERE permission_code = 'DT.CREATE_SETTLEMENT';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Mark a travel advance as disbursed to the traveller.'),
  description_ar = NVL(description_ar, 'تأشير سلفة السفر بأنها صُرفت للمسافر.')
WHERE permission_code = 'DT.DISBURSE_ADVANCE';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Edit the holder''s own travel request while it is still in draft.'),
  description_ar = NVL(description_ar, 'تعديل طلب السفر الخاص بالمستخدم أثناء كونه مسودة.')
WHERE permission_code = 'DT.EDIT_OWN_REQUEST';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Export travel request and settlement data.'),
  description_ar = NVL(description_ar, 'تصدير بيانات طلبات السفر والتسويات.')
WHERE permission_code = 'DT.EXPORT';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Maintain the country-to-group mappings that drive per diem rates.'),
  description_ar = NVL(description_ar, 'إدارة ربط الدول بمجموعاتها المعتمدة في احتساب بدل الإعاشة.')
WHERE permission_code = 'DT.MANAGE_COUNTRY_GROUPS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Maintain the document requirements checklist for travel requests.'),
  description_ar = NVL(description_ar, 'إدارة قائمة المستندات المطلوبة لطلبات السفر.')
WHERE permission_code = 'DT.MANAGE_DOC_REQS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Maintain the per diem rate master by grade and country group.'),
  description_ar = NVL(description_ar, 'إدارة جدول بدلات الإعاشة حسب الدرجة ومجموعة الدول.')
WHERE permission_code = 'DT.MANAGE_RATES';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Configure Duty Travel module settings and defaults.'),
  description_ar = NVL(description_ar, 'ضبط إعدادات وحدة السفر الرسمي وقيمها الافتراضية.')
WHERE permission_code = 'DT.MODULE_SETTINGS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View all travel requests across the organisation.'),
  description_ar = NVL(description_ar, 'عرض جميع طلبات السفر على مستوى المؤسسة.')
WHERE permission_code = 'DT.VIEW_ALL_REQUESTS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View all settlements across the organisation.'),
  description_ar = NVL(description_ar, 'عرض جميع التسويات على مستوى المؤسسة.')
WHERE permission_code = 'DT.VIEW_ALL_SETTLEMENTS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View the holder''s own travel requests.'),
  description_ar = NVL(description_ar, 'عرض طلبات السفر الخاصة بالمستخدم.')
WHERE permission_code = 'DT.VIEW_OWN_REQUESTS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View the holder''s own settlements.'),
  description_ar = NVL(description_ar, 'عرض التسويات الخاصة بالمستخدم.')
WHERE permission_code = 'DT.VIEW_OWN_SETTLEMENTS';

-- -------------------------------- GL ---------------------------------
UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Export the budget utilization and encumbrance registers to Excel.'),
  description_ar = NVL(description_ar, 'تصدير سجلات استخدام الميزانية والارتباطات إلى Excel.')
WHERE permission_code = 'GL_EXPORT_REGISTERS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Maintain sector, chapter and DCT program classification values and their date-tracked segment assignments.'),
  description_ar = NVL(description_ar, 'إدارة قيم تصنيفات القطاع والباب والبرنامج وربطها الزمني بمقاطع دليل الحسابات.')
WHERE permission_code = 'GL_MANAGE_CLASSIFICATIONS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Run the actuals snapshot refresh that rebuilds the GL reporting figures.'),
  description_ar = NVL(description_ar, 'تشغيل تحديث لقطة المصروفات الفعلية لإعادة بناء أرقام تقارير الأستاذ العام.')
WHERE permission_code = 'GL_RUN_ACTUALS_REFRESH';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Generate the Budget Utilization briefing book and related PDF/Excel reports.'),
  description_ar = NVL(description_ar, 'إنشاء الكتاب التنفيذي لاستخدام الميزانية والتقارير المرتبطة به.')
WHERE permission_code = 'GL_RUN_BRIEFING_BOOK';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Run the structural views rebuild after a source data reload.'),
  description_ar = NVL(description_ar, 'تشغيل إعادة بناء العروض الهيكلية بعد إعادة تحميل بيانات المصدر.')
WHERE permission_code = 'GL_RUN_VIEWS_REBUILD';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View the Budget vs Actual report with commitments, obligations and funds available.'),
  description_ar = NVL(description_ar, 'عرض تقرير الميزانية مقابل الفعلي مع الارتباطات والالتزامات والأموال المتاحة.')
WHERE permission_code = 'GL_VIEW_ACTUALS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View the Budget Utilization report and its supporting drill-downs.'),
  description_ar = NVL(description_ar, 'عرض تقرير استخدام الميزانية وتفاصيله الداعمة.')
WHERE permission_code = 'GL_VIEW_BUDGET_UTILIZATION';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View chart-of-accounts classification values and their assignments.'),
  description_ar = NVL(description_ar, 'عرض قيم تصنيفات دليل الحسابات وارتباطاتها.')
WHERE permission_code = 'GL_VIEW_CLASSIFICATIONS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View the GL analytics dashboard.'),
  description_ar = NVL(description_ar, 'عرض لوحة تحليلات الأستاذ العام.')
WHERE permission_code = 'GL_VIEW_DASHBOARD';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View the open projects encumbrance follow-up register.'),
  description_ar = NVL(description_ar, 'عرض سجل متابعة الارتباطات المفتوحة للمشاريع.')
WHERE permission_code = 'GL_VIEW_ENCUMBRANCES';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Browse the chart-of-accounts explorer.'),
  description_ar = NVL(description_ar, 'استعراض مستكشف دليل الحسابات.')
WHERE permission_code = 'GL_VIEW_EXPLORER';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View the segment-to-classification mapping workbench.'),
  description_ar = NVL(description_ar, 'عرض شاشة ربط المقاطع بالتصنيفات.')
WHERE permission_code = 'GL_VIEW_MAPPING';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View the GL overview landing page.'),
  description_ar = NVL(description_ar, 'عرض الصفحة الرئيسية لوحدة الأستاذ العام.')
WHERE permission_code = 'GL_VIEW_OVERVIEW';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View PR and PO documents pending approval in Fusion, with aging and approver detail.'),
  description_ar = NVL(description_ar, 'عرض مستندات طلبات وأوامر الشراء المعلقة على الاعتماد في فيوجن مع تفاصيل التقادم والمعتمدين.')
WHERE permission_code = 'GL_VIEW_PENDING_APPROVALS';

-- ------------------------------ PETTY CASH ---------------------------
UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Approve or reject petty cash clearing requests.'),
  description_ar = NVL(description_ar, 'اعتماد أو رفض طلبات تسوية عهدة النثرية.')
WHERE permission_code = 'CLEARING.APPROVE';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Submit a clearing request against a petty cash custody.'),
  description_ar = NVL(description_ar, 'تقديم طلب تسوية على عهدة النثرية.')
WHERE permission_code = 'CLEARING.CREATE';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View the holder''s own clearing requests.'),
  description_ar = NVL(description_ar, 'عرض طلبات التسوية الخاصة بالمستخدم.')
WHERE permission_code = 'CLEARING.VIEW';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View all clearing requests across the organisation.'),
  description_ar = NVL(description_ar, 'عرض جميع طلبات التسوية على مستوى المؤسسة.')
WHERE permission_code = 'CLEARING.VIEW_ALL';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Maintain the GL code combination master used for budget coding.'),
  description_ar = NVL(description_ar, 'إدارة سجل تراكيب دليل الحسابات المستخدم في الترميز المالي.')
WHERE permission_code = 'GL_CODE_COMBINATIONS.ADMIN';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View and pick GL code combinations for budget coding lines.'),
  description_ar = NVL(description_ar, 'عرض واختيار تراكيب دليل الحسابات لبنود الترميز المالي.')
WHERE permission_code = 'GL_CODE_COMBINATIONS.VIEW';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Configure the approval workflow templates used for petty cash.'),
  description_ar = NVL(description_ar, 'ضبط قوالب سير الاعتماد المستخدمة للنثرية.')
WHERE permission_code = 'PC_APPROVAL_RULES.CONFIGURE';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Configure Petty Cash module settings and defaults.'),
  description_ar = NVL(description_ar, 'ضبط إعدادات وحدة النثرية وقيمها الافتراضية.')
WHERE permission_code = 'PC_MODULE_SETTINGS.CONFIGURE';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View Petty Cash module settings.'),
  description_ar = NVL(description_ar, 'عرض إعدادات وحدة النثرية.')
WHERE permission_code = 'PC_MODULE_SETTINGS.VIEW';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Full administrative access to the Petty Cash module.'),
  description_ar = NVL(description_ar, 'صلاحية إدارية كاملة على وحدة النثرية.')
WHERE permission_code = 'PETTY_CASH.ADMIN';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Approve or reject petty cash custody requests.'),
  description_ar = NVL(description_ar, 'اعتماد أو رفض طلبات عهدة النثرية.')
WHERE permission_code = 'PETTY_CASH.APPROVE';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Create and submit a petty cash custody request.'),
  description_ar = NVL(description_ar, 'إنشاء طلب عهدة نثرية وتقديمه.')
WHERE permission_code = 'PETTY_CASH.CREATE';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Edit the holder''s own petty cash request while it is still in draft.'),
  description_ar = NVL(description_ar, 'تعديل طلب النثرية الخاص بالمستخدم أثناء كونه مسودة.')
WHERE permission_code = 'PETTY_CASH.EDIT';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View the holder''s own petty cash requests.'),
  description_ar = NVL(description_ar, 'عرض طلبات النثرية الخاصة بالمستخدم.')
WHERE permission_code = 'PETTY_CASH.VIEW';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View all petty cash requests across the organisation.'),
  description_ar = NVL(description_ar, 'عرض جميع طلبات النثرية على مستوى المؤسسة.')
WHERE permission_code = 'PETTY_CASH.VIEW_ALL';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Approve or reject reimbursement requests.'),
  description_ar = NVL(description_ar, 'اعتماد أو رفض طلبات الاسترداد.')
WHERE permission_code = 'REIMBURSEMENT.APPROVE';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Create and submit a reimbursement request.'),
  description_ar = NVL(description_ar, 'إنشاء طلب استرداد مصروفات وتقديمه.')
WHERE permission_code = 'REIMBURSEMENT.CREATE';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View the holder''s own reimbursement requests.'),
  description_ar = NVL(description_ar, 'عرض طلبات الاسترداد الخاصة بالمستخدم.')
WHERE permission_code = 'REIMBURSEMENT.VIEW';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View all reimbursement requests across the organisation.'),
  description_ar = NVL(description_ar, 'عرض جميع طلبات الاسترداد على مستوى المؤسسة.')
WHERE permission_code = 'REIMBURSEMENT.VIEW_ALL';

-- ------------------------------- PLATFORM ----------------------------
UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Full administration of the Security Console: privileges, privilege groups, roles, hierarchies, exclusions and security profiles.'),
  description_ar = NVL(description_ar, 'الإدارة الكاملة لوحدة الأمان: الصلاحيات ومجموعاتها والأدوار والتسلسل الهرمي والاستثناءات وملفات أمان البيانات.')
WHERE permission_code = 'ADMIN_MANAGE_SECURITY';

-- ---------------------------- TASK MANAGEMENT ------------------------
UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Access the Task Management application.'),
  description_ar = NVL(description_ar, 'الدخول إلى تطبيق إدارة المهام.')
WHERE permission_code = 'TM.ACCESS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Maintain team-role templates and their capability flags.'),
  description_ar = NVL(description_ar, 'إدارة قوالب أدوار الفرق وصلاحياتها.')
WHERE permission_code = 'TM.MANAGE_ROLES';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Create teams and manage any team''s membership and settings.'),
  description_ar = NVL(description_ar, 'إنشاء الفرق وإدارة عضوية أي فريق وإعداداته.')
WHERE permission_code = 'TM.MANAGE_TEAMS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Configure Task Management module settings and defaults.'),
  description_ar = NVL(description_ar, 'ضبط إعدادات وحدة إدارة المهام وقيمها الافتراضية.')
WHERE permission_code = 'TM.MODULE_SETTINGS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View and update the holder''s own assigned tasks.'),
  description_ar = NVL(description_ar, 'عرض وتحديث المهام المسندة إلى المستخدم.')
WHERE permission_code = 'TM.MY_WORK';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'Run the management reports across teams and reporting cycles.'),
  description_ar = NVL(description_ar, 'تشغيل التقارير الإدارية عبر الفرق ودورات التقارير.')
WHERE permission_code = 'TM.REPORTS';

UPDATE prod.dct_permissions SET
  description_en = NVL(description_en, 'View all teams, their tasks and dashboards.'),
  description_ar = NVL(description_ar, 'عرض جميع الفرق ومهامها ولوحاتها.')
WHERE permission_code = 'TM.VIEW_ALL';

-- ------------------------------ ROLES --------------------------------
UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Abstract role: the user manages other staff and approves requests routed to line managers.'),
  description_ar = NVL(description_ar, 'دور تجريدي: المستخدم يدير موظفين آخرين ويعتمد الطلبات المحالة إلى المديرين المباشرين.')
WHERE role_code = 'MANAGER';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Duty role: maintain GL classification values (sector, chapter, DCT program) and their segment assignments. Never assigned to users directly.'),
  description_ar = NVL(description_ar, 'دور وظيفي فرعي: إدارة قيم تصنيفات الأستاذ العام وارتباط المقاطع بها. لا يُسند مباشرة للمستخدمين.')
WHERE role_code = 'GL_DUTY_CLASSIFICATION';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Duty role: run GL data operations such as actuals refresh and views rebuild. Never assigned to users directly.'),
  description_ar = NVL(description_ar, 'دور وظيفي فرعي: تشغيل عمليات بيانات الأستاذ العام مثل تحديث الفعلي وإعادة بناء العروض. لا يُسند مباشرة للمستخدمين.')
WHERE role_code = 'GL_DUTY_DATA_OPS';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Duty role: view the financial planning and reporting content in GL (budget utilization, actuals, dashboards, encumbrances). Never assigned to users directly.'),
  description_ar = NVL(description_ar, 'دور وظيفي فرعي: عرض محتوى التخطيط والتقارير المالية في الأستاذ العام. لا يُسند مباشرة للمستخدمين.')
WHERE role_code = 'GL_DUTY_FIN_REPORTING';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Read-only oversight access across modules for internal audit purposes.'),
  description_ar = NVL(description_ar, 'صلاحية اطلاع للقراءة فقط عبر الوحدات لأغراض التدقيق الداخلي.')
WHERE role_code = 'AUDITOR';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Job role: full General Ledger practitioner. Views all financial planning reports, maintains classifications and runs GL data operations.'),
  description_ar = NVL(description_ar, 'دور وظيفي: محاسب أستاذ عام كامل الصلاحية؛ يعرض التقارير المالية ويدير التصنيفات ويشغل عمليات البيانات.')
WHERE role_code = 'GL_ACCOUNTANT';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Job role: reads the GL financial planning and reporting content (budget utilization, actuals, dashboards, encumbrances).'),
  description_ar = NVL(description_ar, 'دور وظيفي: يطّلع على محتوى التخطيط والتقارير المالية في الأستاذ العام.')
WHERE role_code = 'GL_ANALYST';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Full administrative access to the HR module: employees, documents and module settings.'),
  description_ar = NVL(description_ar, 'صلاحية إدارية كاملة على وحدة الموارد البشرية: الموظفون والمستندات والإعدادات.')
WHERE role_code = 'HR_ADMIN';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Manages HR employee records and approves HR transactions for their scope.'),
  description_ar = NVL(description_ar, 'يدير سجلات الموظفين ويعتمد معاملات الموارد البشرية ضمن نطاقه.')
WHERE role_code = 'HR_MANAGER';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Read-only access to HR employee records.'),
  description_ar = NVL(description_ar, 'صلاحية قراءة فقط لسجلات موظفي الموارد البشرية.')
WHERE role_code = 'HR_VIEWER';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Administers the module registry: registers applications and controls their launcher visibility.'),
  description_ar = NVL(description_ar, 'يدير سجل الوحدات: تسجيل التطبيقات والتحكم في ظهورها للمستخدمين.')
WHERE role_code = 'MODULE_ADMIN';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Maintains the organisation hierarchy: divisions, sections and units.'),
  description_ar = NVL(description_ar, 'يدير الهيكل التنظيمي: القطاعات والإدارات والوحدات.')
WHERE role_code = 'ORG_ADMIN';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Baseline role for every signed-in platform user: profile, notifications and own worklist.'),
  description_ar = NVL(description_ar, 'الدور الأساسي لكل مستخدم مسجل: الملف الشخصي والإشعارات وقائمة المهام الخاصة.')
WHERE role_code = 'PLATFORM_USER';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Unrestricted platform administration: every module, the Security Console and all system settings.'),
  description_ar = NVL(description_ar, 'إدارة كاملة غير مقيدة للمنصة: جميع الوحدات ووحدة الأمان وإعدادات النظام.')
WHERE role_code = 'SYS_ADMIN';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Task Management executive view: sees every team''s progress and reporting-cycle summaries.'),
  description_ar = NVL(description_ar, 'عرض تنفيذي في إدارة المهام: يطّلع على تقدم جميع الفرق وملخصات دورات التقارير.')
WHERE role_code = 'TASK_DIRECTOR';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Task Management section manager: manages their team''s tasks, members and check-ins.'),
  description_ar = NVL(description_ar, 'مدير قسم في إدارة المهام: يدير مهام فريقه وأعضاءه ومتابعاتهم.')
WHERE role_code = 'TASK_MANAGER';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Read-only access to Task Management boards and reports.'),
  description_ar = NVL(description_ar, 'صلاحية قراءة فقط للوحات وتقارير إدارة المهام.')
WHERE role_code = 'TASK_VIEWER';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Internal testing role: used by automated test suites, carries no business access.'),
  description_ar = NVL(description_ar, 'دور اختبار داخلي تستخدمه حزم الاختبار الآلي ولا يمنح صلاحيات عمل.')
WHERE role_code = 'TEST';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Internal UAT role: used during user-acceptance rounds, carries no business access.'),
  description_ar = NVL(description_ar, 'دور اختبار قبول داخلي يستخدم أثناء جولات القبول ولا يمنح صلاحيات عمل.')
WHERE role_code = 'UAT_ROLE1';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Administers user accounts: creation, activation, role assignment and password resets.'),
  description_ar = NVL(description_ar, 'يدير حسابات المستخدمين: الإنشاء والتفعيل وإسناد الأدوار وإعادة تعيين كلمات المرور.')
WHERE role_code = 'USER_ADMIN';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Workflow data role: generic approver assignable to business objects in Role Assignments.'),
  description_ar = NVL(description_ar, 'دور بيانات لسير العمل: معتمد عام يُسند إلى كائنات الأعمال في شاشة إسناد الأدوار.')
WHERE role_code = 'WF_APPROVER';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Workflow data role: Finance Business Partner for a sector or department, resolved per transaction in Role Assignments.'),
  description_ar = NVL(description_ar, 'دور بيانات لسير العمل: شريك مالي لقطاع أو إدارة، يُحدد لكل معاملة من شاشة إسناد الأدوار.')
WHERE role_code = 'WF_FBP';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Workflow data role: recipients copied for information on workflow steps; their acknowledgement never blocks approval.'),
  description_ar = NVL(description_ar, 'دور بيانات لسير العمل: مستلمون للعلم فقط في خطوات سير العمل ولا يؤثر إقرارهم على الاعتماد.')
WHERE role_code = 'WF_FYI_GROUP';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Workflow data role: Procurement Business Partner, resolved per transaction in Role Assignments.'),
  description_ar = NVL(description_ar, 'دور بيانات لسير العمل: شريك مشتريات يُحدد لكل معاملة من شاشة إسناد الأدوار.')
WHERE role_code = 'WF_PBP';

UPDATE prod.dct_roles SET
  description_en = NVL(description_en, 'Workflow data role: budget planner assignable to business objects in Role Assignments.'),
  description_ar = NVL(description_ar, 'دور بيانات لسير العمل: مخطط ميزانية يُسند إلى كائنات الأعمال في شاشة إسناد الأدوار.')
WHERE role_code = 'WF_PLANNER';

-- deliberate overwrite: mojibake repair (lossy en-dash from an early seed)
UPDATE prod.dct_roles SET
  description_en = 'Freelancer self-service portal account: views own registrations, contracts and payment vouchers.',
  description_ar = NVL(description_ar, 'حساب بوابة الخدمة الذاتية للمستقلين: يعرض تسجيلاته وعقوده وسندات دفعه.')
WHERE role_code = 'FL_FREELANCER';

-- ------------------------- PRIVILEGE GROUPS --------------------------
UPDATE prod.dct_sec_priv_group SET
  description_en = NVL(description_en, 'Bundles the privileges needed to read GL financial planning and reporting content: budget utilization, actuals, dashboards, explorer and encumbrance registers.'),
  description_ar = NVL(description_ar, 'تجمع الصلاحيات اللازمة للاطلاع على محتوى التخطيط والتقارير المالية في الأستاذ العام.')
WHERE group_code = 'GL_FIN_PLANNING_REPORTING';

UPDATE prod.dct_sec_priv_group SET
  description_en = NVL(description_en, 'Bundles the GL administration privileges: classification management and data operations (refresh, rebuild).'),
  description_ar = NVL(description_ar, 'تجمع صلاحيات إدارة الأستاذ العام: إدارة التصنيفات وعمليات البيانات.')
WHERE group_code = 'GL_ADMINISTRATION';

COMMIT;

-- ------------------------- VERIFICATION ------------------------------
SELECT COUNT(*) AS privs_missing_desc FROM prod.dct_permissions WHERE description_en IS NULL;
SELECT COUNT(*) AS roles_missing_desc FROM prod.dct_roles WHERE description_en IS NULL;
SELECT COUNT(*) AS groups_missing_desc FROM prod.dct_sec_priv_group WHERE description_en IS NULL;
EXIT
