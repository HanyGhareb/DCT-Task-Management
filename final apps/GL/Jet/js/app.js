/* ════════════════════════════════════════════════════════════════════
   General Ledger (App 210) — internal CoA classification workspace.
   Plain Knockout single-file SPA (Portal pattern). Reads the shared staff
   session ('ifinance_jet_session'); redirects to Admin when absent.
   ════════════════════════════════════════════════════════════════════ */
(function () {
  'use strict';

  var API = '/ords/admin/gl';
  var SK  = 'ifinance_jet_session';
  var ADMIN_LOGIN = '/dct/index.html';

  // deep-link round-trip: bounce to login carrying the intended destination
  // (path + #tab) so the Admin login lands the user back here after sign-in
  function loginUrl() {
    return ADMIN_LOGIN + '?return=' + encodeURIComponent(location.pathname + location.hash);
  }

  var raw = localStorage.getItem(SK);
  var session = raw ? JSON.parse(raw) : null;
  if (!session || !session.sessionId) { location.href = loginUrl(); return; }
  var TOKEN = session.sessionId;

  function api(method, path, body) {
    var o = { method: method, headers: { 'Authorization': 'Bearer ' + TOKEN } };
    if (body !== undefined) { o.headers['Content-Type'] = 'application/json'; o.body = JSON.stringify(body); }
    return fetch(API + path, o).then(function (r) {
      return r.json().catch(function () { return {}; }).then(function (d) {
        if (r.status === 401) { location.href = loginUrl(); }
        if (!r.ok) { var e = new Error(d.error || ('HTTP ' + r.status)); e.status = r.status; throw e; }
        return d;
      });
    });
  }
  function today() { return new Date().toISOString().slice(0, 10); }
  function qs(o) { var a = []; for (var k in o) if (o[k] !== '' && o[k] != null) a.push(k + '=' + encodeURIComponent(o[k])); return a.length ? '?' + a.join('&') : ''; }

  /* ── i18n ─────────────────────────────────────────────────────── */
  var STR = {
    appName:{en:'Financial Planning and Budgeting',ar:'التخطيط المالي والموازنة'}, appSub:{en:'FP',ar:'التخطيط المالي'},
    signOut:{en:'Sign out',ar:'خروج'}, apps:{en:'Apps',ar:'التطبيقات'},
    home:{en:'Fusion i-Finance Home',ar:'الرئيسية'}, switchApp:{en:'Switch application',ar:'الانتقال إلى تطبيق'},
    grpProjects:{en:'Projects',ar:'المشاريع'},
    grpGl:{en:'General Ledger',ar:'دفتر الأستاذ العام'},
    grpSettings:{en:'Settings',ar:'الإعدادات'},
    navRevenueCategories:{en:'Revenue Categories',ar:'فئات الإيرادات'},
    revTitle:{en:'Revenue Categories',ar:'فئات الإيرادات'},revSub:{en:'Define a reporting hierarchy, revenue mapping rules and category-based access.',ar:'تعريف هيكل التقارير وقواعد تصنيف الإيرادات والصلاحيات حسب الفئة.'},
    rcCategories:{en:'Categories',ar:'الفئات'},rcMapping:{en:'Define Mapping',ar:'تعريف الربط'},rcAccessControl:{en:'Access Control',ar:'التحكم بالصلاحيات'},rcHierarchy:{en:'Main and subcategory hierarchy',ar:'هيكل الفئات الرئيسية والفرعية'},
    rcActive:{en:'Active categories',ar:'الفئات النشطة'},rcRules:{en:'Mapping rules',ar:'قواعد الربط'},rcAccess:{en:'Access grants',ar:'صلاحيات الوصول'},rcRuleHelp:{en:'Most specific rule wins',ar:'تُطبق القاعدة الأكثر تحديداً'},rcAccessHelp:{en:'Role and user assignments',ar:'تعيينات الأدوار والمستخدمين'},
    rcMain:{en:'Main',ar:'رئيسية'},rcSubcat:{en:'Subcategory',ar:'فئة فرعية'},rcCategory:{en:'Revenue Category',ar:'فئة الإيراد'},rcLevel:{en:'Level',ar:'المستوى'},rcSource:{en:'Revenue Source',ar:'مصدر الإيراد'},rcParent:{en:'Parent Main Category',ar:'الفئة الرئيسية'},
    rcNewCategory:{en:'+ New Category',ar:'+ فئة جديدة'},rcNewRule:{en:'+ New Mapping Rule',ar:'+ قاعدة ربط جديدة'},rcNewAccess:{en:'+ Assign Access',ar:'+ تعيين صلاحية'},rcSearch:{en:'Search categories, rules or access…',ar:'بحث في الفئات أو القواعد أو الصلاحيات…'},rcReadOnly:{en:'Read only',ar:'للقراءة فقط'},rcEmpty:{en:'No records yet.',ar:'لا توجد سجلات بعد.'},
    rcSpecific:{en:'Exact dimension values take precedence over ALL; priority resolves equally specific rules.',ar:'تسبق القيم المحددة قيمة ALL، وتفصل الأولوية بين القواعد المتساوية.'},rcInheritance:{en:'A main-category grant can include all current and future subcategories.',ar:'يمكن لصلاحية الفئة الرئيسية أن تشمل كل الفئات الفرعية الحالية والمستقبلية.'},
    rcTransType:{en:'Transaction Type',ar:'نوع المعاملة'},rcTransSource:{en:'Transaction Source',ar:'مصدر المعاملة'},rcRevenueType:{en:'Revenue Type',ar:'نوع الإيراد'},rcCostCenter:{en:'Cost Center',ar:'مركز التكلفة'},rcGlAccount:{en:'GL Account',ar:'حساب الأستاذ'},rcProject:{en:'Project Number',ar:'رقم المشروع'},rcTask:{en:'Task Number',ar:'رقم المهمة'},rcCustomer:{en:'Customer Number',ar:'رقم العميل'},
    rcPrincipal:{en:'Role / User',ar:'الدور / المستخدم'},rcType:{en:'Type',ar:'النوع'},rcScope:{en:'Scope',ar:'النطاق'},rcAllChildren:{en:'All subcategories',ar:'كل الفئات الفرعية'},rcThisOnly:{en:'This category only',ar:'هذه الفئة فقط'},rcIncludeChildren:{en:'Include current and future subcategories',ar:'تضمين الفئات الفرعية الحالية والمستقبلية'},
    rcHierarchyRule:{en:'Main categories have no parent. Each subcategory must have exactly one main parent.',ar:'الفئة الرئيسية بلا أصل، وكل فئة فرعية تتبع فئة رئيسية واحدة.'},rcAllHelp:{en:'Leave a dimension as ALL to match every value.',ar:'اترك البعد بقيمة ALL لمطابقة جميع القيم.'},
    priority:{en:'Priority',ar:'الأولوية'},description:{en:'Description',ar:'الوصف'},delete:{en:'Delete',ar:'حذف'},required:{en:'Complete all required fields.',ar:'يرجى استكمال جميع الحقول المطلوبة.'},
    rcCreatedBy:{en:'Created By',ar:'أنشأ بواسطة'},rcCreatedOn:{en:'Created On',ar:'تاريخ الإنشاء'},rcUpdatedBy:{en:'Updated By',ar:'حدّث بواسطة'},rcUpdatedOn:{en:'Updated On',ar:'تاريخ التحديث'},rcTracking:{en:'Tracking Information',ar:'معلومات التتبع'},
    navBudgetTrx:{en:'Budget Transactions',ar:'معاملات الموازنة'},
    navSectorPerf:{en:'Sector Performance',ar:'أداء القطاع'},
    spTitle:{en:'Sector Financial Performance',ar:'الأداء المالي للقطاع'},
    spSub:{en:'Overview and variance explanation of the financial performance of your sector for the selected period.',ar:'نظرة عامة وتفسير الانحرافات للأداء المالي لقطاعك خلال الفترة المحددة.'},
    spCriteria:{en:'Search criteria',ar:'معايير البحث'},
    spYear:{en:'Budget Year',ar:'السنة المالية'},
    spPeriod:{en:'Accounting Period',ar:'الفترة المحاسبية'},
    spFullYear:{en:'Full year',ar:'السنة الكاملة'},
    spSector:{en:'Sector',ar:'القطاع'},
    spDept:{en:'Department (Cost Centre)',ar:'الإدارة (مركز التكلفة)'},
    spKind:{en:'Expenditure kind',ar:'نوع الإنفاق'},
    spProjType:{en:'Project Type',ar:'نوع المشروع'},
    spBu:{en:'Business Unit',ar:'وحدة الأعمال'},
    spPlanType:{en:'Plan',ar:'الخطة'},
    spAll:{en:'All',ar:'الكل'},
    spPick:{en:'Add…',ar:'إضافة…'},
    spSearch:{en:'Search',ar:'بحث'},
    spClear:{en:'Clear',ar:'مسح'},
    spExport:{en:'Export CSV',ar:'تصدير CSV'},
    spCapexOpexOnly:{en:'Scoped to Opex and Capex, matching the source report.',ar:'النطاق يشمل المصروفات التشغيلية والرأسمالية فقط، مطابقةً للتقرير المصدر.'},
    spSampleBanner:{en:'PLAN FIGURES ARE SAMPLE DATA',ar:'أرقام الخطة بيانات تجريبية'},
    spSampleNote:{en:'No monthly plan has been uploaded yet, so every Plan figure on this page is generated demonstration data. Actual, Budget, Encumbrance and Funds Available are real.',ar:'لم يتم رفع خطة شهرية بعد، لذا فإن جميع أرقام الخطة في هذه الصفحة بيانات توضيحية مولّدة. أما الفعلي والموازنة والارتباطات والمتاح فهي حقيقية.'},
    spSamplePurge:{en:'Remove sample plan',ar:'إزالة الخطة التجريبية'},
    spSamplePurged:{en:'Sample plan data removed.',ar:'تمت إزالة بيانات الخطة التجريبية.'},
    spSampleConfirm:{en:'Remove all sample plan data for this year? Real uploaded plans are never touched.',ar:'إزالة جميع بيانات الخطة التجريبية لهذه السنة؟ لن تُمس الخطط الحقيقية المرفوعة.'},
    spBusinessOverview:{en:'Business Overview',ar:'نظرة عامة على الأعمال'},
    spBudgetOverview:{en:'Budget Overview',ar:'نظرة عامة على الموازنة'},
    spProjectLevel:{en:'Project Level',ar:'مستوى المشروع'},
    spRevenueOverview:{en:'Revenue Overview',ar:'نظرة عامة على الإيرادات'},
    spQuality:{en:'Data quality',ar:'جودة البيانات'},
    spRevenue:{en:'Revenue',ar:'الإيرادات'},
    spOpex:{en:'Opex',ar:'المصروفات التشغيلية'},
    spCapex:{en:'Capex',ar:'المصروفات الرأسمالية'},
    spOpexCapex:{en:'Opex & Capex',ar:'التشغيلية والرأسمالية'},
    spFyBudget:{en:'FY Budget',ar:'موازنة السنة'},
    spYtdActual:{en:'YTD Actual',ar:'الفعلي حتى تاريخه'},
    spYtdPlan:{en:'YTD Plan',ar:'الخطة حتى تاريخه'},
    spActVsBudget:{en:'YTD Actual vs FY Budget',ar:'الفعلي مقابل الموازنة'},
    spTarget:{en:'Target [YTD Plan / FY Plan]',ar:'المستهدف [الخطة حتى تاريخه / خطة السنة]'},
    spRevToOpex:{en:'Revenue to Opex %',ar:'نسبة الإيراد إلى المصروف التشغيلي'},
    spRevToOpexSub:{en:'Measuring financial sustainability using the revenue-to-opex ratio',ar:'قياس الاستدامة المالية باستخدام نسبة الإيراد إلى المصروف التشغيلي'},
    spFyTarget:{en:'FY Target %',ar:'مستهدف السنة'},
    spYtdActualPct:{en:'YTD Actual %',ar:'الفعلي حتى تاريخه'},
    spBudgetVsActual:{en:'Budget vs Actual (cumulative)',ar:'الموازنة مقابل الفعلي (تراكمي)'},
    spBudget:{en:'Budget',ar:'الموازنة'},
    spActual:{en:'Actual',ar:'الفعلي'},
    spPlan:{en:'Plan',ar:'الخطة'},
    spEncumbrance:{en:'Encumbrance',ar:'الارتباطات'},
    spFundsAvail:{en:'Funds Available',ar:'المتاح'},
    spActVsPlanPct:{en:'Actual vs Plan %',ar:'الفعلي مقابل الخطة'},
    spPlanVsBudget:{en:'Plan vs Budget',ar:'الخطة مقابل الموازنة'},
    spActVsPlanAmt:{en:'Actual vs Plan in Amount',ar:'الفعلي مقابل الخطة بالمبلغ'},
    spByDept:{en:'YTD Actual vs Budget & Plan by Department',ar:'الفعلي مقابل الموازنة والخطة حسب الإدارة'},
    spDeptCount:{en:'departments',ar:'إدارة'},
    spProject:{en:'Project',ar:'المشروع'},
    spTotal:{en:'Total',ar:'الإجمالي'},
    spExpandHint:{en:'Show the project level under every sector',ar:'إظهار مستوى المشروع تحت كل قطاع'},
    spSovereign:{en:'Sovereign',ar:'سيادي'},
    spCommercial:{en:'Commercial',ar:'تجاري'},
    spAchievement:{en:'Achievement',ar:'نسبة الإنجاز'},
    spMtdTrend:{en:'MTD Trend',ar:'الاتجاه الشهري'},
    spByType:{en:'Actual vs Plan by Type',ar:'الفعلي مقابل الخطة حسب النوع'},
    spPlanCoverage:{en:'Plan coverage',ar:'تغطية الخطة'},
    spUnmappedSector:{en:'Lines with no sector',ar:'بنود بلا قطاع'},
    spOrphanPlan:{en:'Plan rows with no budget line',ar:'بنود خطة بلا موازنة'},
    spUncategorised:{en:'Uncategorised revenue',ar:'إيرادات غير مصنفة'},
    spQualityNote:{en:'A figure that cannot be attributed is shown here rather than dropped.',ar:'أي رقم لا يمكن نسبته يُعرض هنا بدلاً من إسقاطه.'},
    spNoData:{en:'No data for the selected criteria.',ar:'لا توجد بيانات للمعايير المحددة.'},
    spBudgetFlatNote:{en:'The budget line is the full-year figure: the platform holds no budget-version history yet.',ar:'خط الموازنة يمثل رقم السنة الكاملة: لا يوجد سجل لإصدارات الموازنة بعد.'},
    spRevBudgetNote:{en:'The Fusion revenue budget sits on a single cost centre, so a sector or department filter can legitimately zero it while actual and plan stay populated.',ar:'موازنة الإيرادات في فيوجن مسجلة على مركز تكلفة واحد، لذا قد يصفّرها فلتر القطاع أو الإدارة بينما يبقى الفعلي والخطة.'},
    btTitle:{en:'Budget Transactions',ar:'معاملات الموازنة'},
    btSub:{en:'Project budget transactions extracted from the Project Budget Transactions application — header, details and approval trail.',ar:'معاملات موازنة المشاريع المستخرجة من تطبيق معاملات موازنة المشاريع — الرأس والتفاصيل وسجل الاعتماد.'},
    btCriteria:{en:'Search criteria',ar:'معايير البحث'},
    btTransactions:{en:'Transactions',ar:'المعاملات'},
    btDetails:{en:'Details',ar:'التفاصيل'},
    btApprovals:{en:'Approval history',ar:'سجل الاعتماد'},
    btType:{en:'Budget Type',ar:'نوع الموازنة'},
    btBu:{en:'Business Unit',ar:'وحدة الأعمال'},
    btProjType:{en:'Project Type',ar:'نوع المشروع'},
    btStatus:{en:'Status',ar:'الحالة'},
    btYear:{en:'Transaction Year',ar:'سنة المعاملة'},
    btApprover:{en:'Dept 1st Level Approver',ar:'المعتمد الأول للإدارة'},
    btTrxNo:{en:'Transaction No.',ar:'رقم المعاملة'},
    btDecree:{en:'Decree No.',ar:'رقم القرار'},
    btDateFrom:{en:'Transaction Date From',ar:'تاريخ المعاملة من'},
    btDateTo:{en:'Transaction Date To',ar:'تاريخ المعاملة إلى'},
    btSearchBtn:{en:'Search',ar:'بحث'},
    btClear:{en:'Clear',ar:'مسح'},
    btExport:{en:'Export CSV',ar:'تصدير CSV'},
    btAll:{en:'All',ar:'الكل'},
    btSelectRow:{en:'Select a transaction above to see its details and approval history.',ar:'اختر معاملة من الأعلى لعرض تفاصيلها وسجل اعتمادها.'},
    btNoRows:{en:'No transactions match the criteria.',ar:'لا توجد معاملات مطابقة للمعايير.'},
    btNoLines:{en:'This transaction has no detail lines.',ar:'لا توجد تفاصيل لهذه المعاملة.'},
    btNoAppr:{en:'No approval history recorded.',ar:'لا يوجد سجل اعتماد.'},
    btShowing:{en:'Showing',ar:'عرض'},
    btOf:{en:'of',ar:'من'},
    btPrev:{en:'Previous',ar:'السابق'},
    btNext:{en:'Next',ar:'التالي'},
    btLines:{en:'Lines',ar:'التفاصيل'},
    btApprCount:{en:'Approvals',ar:'الاعتمادات'},
    btOrganization:{en:'Organization',ar:'الجهة'},
    btCreationDate:{en:'Creation Date',ar:'تاريخ الإنشاء'},
    btProject:{en:'Project',ar:'المشروع'},
    btTask:{en:'Task',ar:'المهمة'},
    btExpType:{en:'Expenditure Type',ar:'نوع الإنفاق'},
    btCodeComb:{en:'Code Combination',ar:'تركيبة الحساب'},
    btAmount:{en:'Amount',ar:'المبلغ'},
    btLineStatus:{en:'Line Status',ar:'حالة السطر'},
    btBaseline:{en:'Baseline Status',ar:'حالة الاعتماد'},
    btJournal:{en:'Journal Status',ar:'حالة القيد'},
    btPeriod:{en:'Period',ar:'الفترة'},
    btNotes:{en:'Notes',ar:'ملاحظات'},
    btSector:{en:'Sector',ar:'القطاع'},
    btChapter:{en:'Chapter',ar:'الباب'},
    btProgram:{en:'DCT Program',ar:'برنامج الدائرة'},
    btApprop:{en:'Appropriation',ar:'الاعتماد'},
    btCostCenter:{en:'Cost Center',ar:'مركز التكلفة'},
    btAcctPeriod:{en:'Accounting Period',ar:'الفترة المحاسبية'},
    btSearchL:{en:'Search',ar:'بحث'},
    btSearchPh:{en:'Transaction, decree, project, task, expenditure type…',ar:'المعاملة، القرار، المشروع، المهمة، نوع الإنفاق…'},
    btLovHint:{en:'All — type to search…',ar:'الكل — اكتب للبحث…'},
    cFmCnt:{en:'Fund Movement Count',ar:'عدد حركات التمويل'},
    cFmAmt:{en:'Fund Movement Amount',ar:'مبلغ حركات التمويل'},
    chFmCnt:{en:'How many APPROVED Additional Fund transfer lines hit this row in the budget year, up to the selected accounting period — additions and deductions alike (zero-amount lines excluded). Hover for the green/red split; click to list the transactions.',ar:'عدد سطور تحويلات التمويل الإضافي المعتمدة على هذا الصف خلال سنة الموازنة وحتى الفترة المحاسبية المحددة — الإضافات والخصومات معاً (تُستثنى السطور الصفرية). مرّر للتفصيل الأخضر/الأحمر، وانقر لعرض المعاملات.'},
    chFmAmt:{en:'Net fund movement = additions − deductions (AED, APPROVED transactions only) on this row in the budget year, up to the selected period. Green = net addition, red = net deduction. Hover for the split; click to list the transactions.',ar:'صافي حركة التمويل = الإضافات − الخصومات (بالدرهم، للمعاملات المعتمدة فقط) على هذا الصف خلال سنة الموازنة وحتى الفترة المحددة. الأخضر = إضافة صافية والأحمر = خصم صافٍ. مرّر للتفصيل وانقر لعرض المعاملات.'},
    fmTipTitle:{en:'Fund movement',ar:'حركات التمويل'},
    fmAdds:{en:'additions',ar:'إضافات'},
    fmDeds:{en:'deductions',ar:'خصومات'},
    fmNet:{en:'Net',ar:'الصافي'},
    buDrillFm:{en:'Fund Movement — transfer transactions',ar:'حركات التمويل — معاملات التحويل'},
    fmSortBy:{en:'Sort:',ar:'الترتيب:'},
    fmSortDefault:{en:'Project · Task · Type · Date',ar:'المشروع · المهمة · النوع · التاريخ'},
    fmSortDate:{en:'Date · Project · Task · Type',ar:'التاريخ · المشروع · المهمة · النوع'},
    fmExtraNote:{en:'{n} transfer lines (net {amt}) fall under cost centres / sectors with no row above (no budget line in the current scope).',ar:'{n} سطر تحويل (بصافي {amt}) تقع تحت مراكز تكلفة أو قطاعات بلا صف أعلاه (لا يوجد خط موازنة ضمن النطاق الحالي).'},
    fmProjectNo:{en:'Project Number',ar:'رقم المشروع'},
    fmProjectName:{en:'Project Name',ar:'اسم المشروع'},
    fmTaskNo:{en:'Task Number',ar:'رقم المهمة'},
    fmCommitment:{en:'Commitment',ar:'الالتزام'},
    fmAnnBudget:{en:'Total Annual Budget',ar:'إجمالي الموازنة السنوية'},
    fmFundAvail:{en:'Project Fund Available',ar:'المتاح من تمويل المشروع'},
    fmTotActual:{en:'Total Actual',ar:'إجمالي الفعلي'},
    fmTrxNum:{en:'Transaction Num',ar:'رقم المعاملة'},
    fmTrxDate:{en:'Transaction Date',ar:'تاريخ المعاملة'},
    fmTrxYear:{en:'Transaction Year',ar:'سنة المعاملة'},
    fmTrxStatus:{en:'Transaction Status',ar:'حالة المعاملة'},
    fmSubmittedBy:{en:'Submitted By',ar:'قدّمها'},
    fmApprovedBy:{en:'Approved By',ar:'اعتمدها'},
    fmApprState:{en:'Approval State',ar:'حالة الاعتماد'},
    fmApprDate:{en:'Approval Date',ar:'تاريخ الاعتماد'},
    btLineHint:{en:'Line-level criterion: a transaction matches when one of its detail lines does.',ar:'معيار على مستوى السطر: تُطابق المعاملة عندما يُطابق أحد سطور تفاصيلها.'},
    btLineFilters:{en:'line criteria',ar:'معايير السطور'},
    btScopeRequired:{en:'Budget Type and Transaction Year are required.',ar:'نوع الموازنة وسنة المعاملة مطلوبان.'},
    btScopeHint:{en:'Required — Budget Type and Transaction Year scope the whole page.',ar:'مطلوب — نوع الموازنة وسنة المعاملة يحددان نطاق الصفحة بالكامل.'},
    btSubmitter:{en:'Submitted by',ar:'أرسلها'},
    btAssignee:{en:'Assignee',ar:'المسؤول'},
    btState:{en:'State',ar:'الحالة'},
    btWhen:{en:'Date',ar:'التاريخ'},
    navOverview:{en:'Chart of Accounts',ar:'دليل الحسابات'}, navClass:{en:'Classifications',ar:'التصنيفات'},
    navMapping:{en:'Segment Mapping',ar:'ربط البنود'}, navExplorer:{en:'Explorer',ar:'المستكشف'},
    coaTitle:{en:'Chart of Accounts',ar:'دليل الحسابات'},
    coaSub:{en:'Classification overview and the full GL combinations explorer — date-tracked Sector, Chapter and DCT Program on every combination.',ar:'نظرة عامة على التصنيفات ومستكشف التركيبات المحاسبية الكامل — القطاع والباب وبرنامج الدائرة المؤرخة على كل تركيبة.'},
    coaOverview:{en:'Classification overview',ar:'نظرة عامة على التصنيفات'},
    coaExplorer:{en:'Combinations explorer',ar:'مستكشف التركيبات'},
    ovTitle:{en:'Chart of Accounts classifications',ar:'تصنيفات دليل الحسابات'},
    ovSub:{en:'Date-tracked Sector, Chapter and DCT Program overlays on every GL combination.',ar:'تصنيفات القطاع والباب وبرنامج الدائرة المؤرخة على كل تركيبة محاسبية.'},
    combos:{en:'GL combinations',ar:'التركيبات المحاسبية'}, haveSector:{en:'have a sector',ar:'لها قطاع'},
    segmentsMapped:{en:'segments mapped',ar:'بنود مرتبطة'}, howItWorks:{en:'How it works',ar:'آلية العمل'},
    ovExplain:{en:'Each classification is keyed off one segment of the combination and is <em>date-tracked</em> — a cost center can belong to one sector this year and another next year. The Explorer resolves the value effective today, or as of any past date.',ar:'يرتبط كل تصنيف ببند واحد من التركيبة وهو <em>مؤرخ</em> — قد ينتمي مركز التكلفة لقطاع هذا العام وآخر العام القادم. يعرض المستكشف القيمة السارية اليوم أو في أي تاريخ سابق.'},
    clsTitle:{en:'Classification values',ar:'قيم التصنيف'},
    clsSub:{en:'Manage the Sector, Chapter and DCT Program master lists.',ar:'إدارة قوائم القطاع والباب وبرنامج الدائرة.'},
    addValue:{en:'Add value',ar:'إضافة قيمة'}, code:{en:'Code',ar:'الرمز'}, name:{en:'Name',ar:'الاسم'},
    altNames:{en:'Alternative names',ar:'أسماء بديلة'}, tag:{en:'Tag',ar:'وسم'},
    assignments:{en:'Assignments',ar:'الارتباطات'}, active:{en:'Active',ar:'نشط'},
    yes:{en:'Yes',ar:'نعم'}, no:{en:'No',ar:'لا'}, edit:{en:'Edit',ar:'تعديل'}, del:{en:'Delete',ar:'حذف'},
    noValues:{en:'No values yet.',ar:'لا توجد قيم بعد.'},
    mapTitle:{en:'Manage CoA Mapping',ar:'إدارة ربط دليل الحسابات'},
    mapSub:{en:'Chart of account Reporting',ar:'تقارير دليل الحسابات'},
    addAssign:{en:'Add assignment',ar:'إضافة ارتباط'}, searchSegment:{en:'Search segment…',ar:'بحث عن بند…'},
    pickSegment:{en:'— pick a segment value —',ar:'— اختر قيمة بند —'},
    effectiveHistory:{en:'Effective history',ar:'السجل الزمني'}, current:{en:'CURRENT',ar:'حالي'}, past:{en:'PAST',ar:'سابق'},
    open:{en:'open',ar:'مفتوح'}, noAssign:{en:'No assignments for this segment yet.',ar:'لا ارتباطات لهذا البند بعد.'},
    pickSegmentHint:{en:'Pick a dimension and a segment value to see and manage its date-tracked assignments.',ar:'اختر بُعداً وقيمة بند لعرض وإدارة ارتباطاتها المؤرخة.'},
    expTitle:{en:'Chart of Account Explorer',ar:'مستكشف دليل الحسابات'},
    expSub:{en:'Every combination with all segment descriptions and its effective classifications.',ar:'كل تركيبة مع أوصاف البنود وتصنيفاتها السارية.'},
    asOf:{en:'As of',ar:'حتى تاريخ'}, exportCsv:{en:'Export CSV',ar:'تصدير CSV'},
    searchCombos:{en:'Search combinations…',ar:'بحث في التركيبات…'},
    allSectors:{en:'All sectors',ar:'كل القطاعات'}, allChapters:{en:'All chapters',ar:'كل الأبواب'},
    fAccTypeL:{en:'Account Type',ar:'نوع الحساب'}, thAccType:{en:'Account Type',ar:'نوع الحساب'},
    allAccTypes:{en:'Add account type…',ar:'أضف نوع حساب…'},
    accTypeRequired:{en:'Account Type is required',ar:'نوع الحساب مطلوب'},
    atAssets:{en:'Assets',ar:'الأصول'}, atLiability:{en:'Liabilities',ar:'الالتزامات'},
    atRevenue:{en:'Revenue',ar:'الإيرادات'}, atExpense:{en:'Expense',ar:'المصروفات'},
    atEquity:{en:"Owner's Equity",ar:'حقوق الملكية'},
    today:{en:'Today',ar:'اليوم'}, combination:{en:'Combination',ar:'التركيبة'},
    costCenter:{en:'Cost center',ar:'مركز التكلفة'}, account:{en:'Account',ar:'الحساب'},
    program:{en:'Program',ar:'البرنامج'}, prev:{en:'‹ Prev',ar:'السابق ›'}, next:{en:'Next ›',ar:'‹ التالي'},
    noCombos:{en:'No combinations match.',ar:'لا توجد تركيبات مطابقة.'},
    footOrg:{en:'Finance Department · Fusion i-Finance',ar:'إدارة المالية · Fusion i-Finance'},
    footNote:{en:'Classifications are date-tracked',ar:'التصنيفات مؤرخة زمنياً'},
    editValue:{en:'Edit value',ar:'تعديل قيمة'}, newValue:{en:'New value',ar:'قيمة جديدة'},
    cancel:{en:'Cancel',ar:'إلغاء'}, save:{en:'Save',ar:'حفظ'}, dimension:{en:'Dimension',ar:'البُعد'},
    nameEn:{en:'Name (EN)',ar:'الاسم (إنجليزي)'}, nameAr:{en:'Name (AR)',ar:'الاسم (عربي)'},
    altName:{en:'Alt name',ar:'اسم بديل'}, parent:{en:'Parent',ar:'الأصل'}, none:{en:'— none —',ar:'— لا يوجد —'},
    order:{en:'Order',ar:'الترتيب'}, segment:{en:'Segment',ar:'البند'}, classValue:{en:'Classification value',ar:'قيمة التصنيف'},
    pickValue:{en:'— pick a value —',ar:'— اختر قيمة —'}, startDate:{en:'Start date',ar:'تاريخ البداية'},
    endDate:{en:'End date',ar:'تاريخ النهاية'}, optional:{en:'optional',ar:'اختياري'}, notes:{en:'Notes',ar:'ملاحظات'},
    editAssign:{en:'Edit assignment',ar:'تعديل ارتباط'}, newAssign:{en:'New assignment',ar:'ارتباط جديد'},
    saved:{en:'Saved',ar:'تم الحفظ'}, deleted:{en:'Deleted',ar:'تم الحذف'}, confirmDel:{en:'Delete this item?',ar:'حذف هذا العنصر؟'},
    close:{en:'Close',ar:'إغلاق'}, descriptionL:{en:'Description',ar:'الوصف'},
    saving:{en:'Saving…',ar:'جارٍ الحفظ…'},
    addAssignment:{en:'+ Add',ar:'+ إضافة'},
    noAssignments:{en:'No assignments yet — click + Add to map a segment to this value.',ar:'لا توجد تعيينات بعد — انقر + إضافة لربط بند بهذه القيمة.'},
    segRequired:{en:'Every new row needs a segment value.',ar:'كل سطر جديد يحتاج قيمة بند.'},
    startRequired:{en:'Every row needs a start date.',ar:'كل سطر يحتاج تاريخ بداية.'},
    nothingToSave:{en:'No changes to save.',ar:'لا توجد تغييرات للحفظ.'},
    clsRowHint:{en:'Click a row to view and manage its assignments.',ar:'انقر على أي سطر لعرض وإدارة تعييناته.'},
    clsDrillCtx:{en:'Every segment mapped to this value. Edit dates or notes inline, + Add to map a new segment, then Save.',ar:'كل البنود المرتبطة بهذه القيمة. عدّل التواريخ أو الملاحظات مباشرة، + إضافة لربط بند جديد، ثم احفظ.'},
    segments:{en:'Segments',ar:'البنود'},
    segEntity:{en:'Entity',ar:'الجهة'}, segCostCenter:{en:'Cost Center',ar:'مركز التكلفة'},
    segAccount:{en:'Account',ar:'الحساب'}, segAppropriation:{en:'Appropriation',ar:'الاعتماد'},
    segBudgetGroup:{en:'Budget Group',ar:'مجموعة الموازنة'}, segEntitySpecific:{en:'Entity Specific',ar:'خاص بالجهة'},
    segFuture1:{en:'Future 1',ar:'مستقبلي ١'}, segFuture2:{en:'Future 2',ar:'مستقبلي ٢'},
    segIntercompany:{en:'Intercompany',ar:'بين الشركات'}, segProgram:{en:'Program',ar:'البرنامج'},

    /* ── Legacy (EBS) — Fusion/EBS COA mapping + historical balances ── */
    navLegacy:{en:'Legacy (EBS)',ar:'النظام السابق (EBS)'},
    xmTitle:{en:'Legacy System (EBS) Mapping & Balances',ar:'ربط وأرصدة النظام السابق (EBS)'},
    xmSub:{en:'Cross-map between the Fusion chart and the legacy EBS GL (used until 31-Dec-2025), and the EBS historical balances for prior-year reporting.',ar:'الربط بين دليل حسابات Fusion ودفتر الأستاذ في النظام السابق EBS (المستخدم حتى 31-12-2025)، وأرصدة EBS التاريخية لتقارير السنوات السابقة.'},
    xmRegion:{en:'COA Account Mapping',ar:'ربط حسابات دليل الحسابات'},
    ebRegion:{en:'Legacy Balances (EBS)',ar:'أرصدة النظام السابق (EBS)'},
    xmAllSegments:{en:'All segments',ar:'كل البنود'},
    xmStatus:{en:'Status',ar:'الحالة'}, xmInactive:{en:'Inactive',ar:'غير نشط'}, xmAll:{en:'All',ar:'الكل'},
    xmAdd:{en:'+ Add mapping',ar:'+ إضافة ربط'},
    xmRows:{en:'mapping rows',ar:'سطر ربط'},
    xmRowHint:{en:'Click a row to edit it.',ar:'انقر على أي سطر لتعديله.'},
    xmEbsValue:{en:'EBS value',ar:'قيمة EBS'}, xmFusionValue:{en:'Fusion value',ar:'قيمة Fusion'},
    xmFusionDesc:{en:'Fusion description',ar:'وصف Fusion'},
    xmParentChild:{en:'Parent / Child',ar:'أصل / فرع'}, xmInChart:{en:'In chart',ar:'في الدليل'},
    xmUpdBy:{en:'Updated by',ar:'عدله'}, xmUpdAt:{en:'Updated at',ar:'تاريخ التعديل'},
    xmEditTitle:{en:'Edit mapping',ar:'تعديل ربط'}, xmNewTitle:{en:'New mapping',ar:'ربط جديد'},
    xmDrawerCtx:{en:'Each EBS value maps to exactly ONE Fusion value per segment. Deactivate a row instead of deleting it — history keeps translating.',ar:'كل قيمة EBS ترتبط بقيمة Fusion واحدة فقط لكل بند. عطّل السطر بدلاً من حذفه — يستمر السجل التاريخي في الترجمة.'},
    xmReqFields:{en:'Segment, EBS value and Fusion value are required',ar:'البند وقيمة EBS وقيمة Fusion مطلوبة'},
    xmUpload:{en:'Upload balances (Excel)',ar:'تحميل الأرصدة (إكسل)'},
    xmTemplate:{en:'Download template',ar:'تنزيل النموذج'},
    xmRegister:{en:'Generate Register (XLSX)',ar:'إنشاء السجل (XLSX)'},
    xmPickYear:{en:'Year…',ar:'السنة…'},
    ebYearL:{en:'Year',ar:'السنة'}, ebRowsL:{en:'Rows',ar:'الأسطر'},
    ebPeriodsL:{en:'Periods',ar:'الفترات'}, ebCombosL:{en:'Combinations',ar:'التركيبات'},
    ebPtdL:{en:'Actual (PTD)',ar:'الفعلي (للفترة)'},
    ebBgtL:{en:'Budget',ar:'الميزانية'}, ebEncL:{en:'Encumbrance',ar:'الارتباطات'},
    ebAccMapL:{en:'Account mapped',ar:'حسابات مرتبطة'}, ebAprMapL:{en:'Future2 mapped',ar:'مستقبلي٢ مرتبط'},
    ebEmpty:{en:'No legacy balances loaded yet — upload the EBS balance file to begin.',ar:'لم يتم تحميل أرصدة النظام السابق بعد — حمّل ملف أرصدة EBS للبدء.'},
    ebUnmappedAcc:{en:'Top unmapped EBS accounts',ar:'أهم حسابات EBS غير المرتبطة'},
    ebUnmappedF2:{en:'Top unmapped Future2 values',ar:'أهم قيم مستقبلي٢ غير المرتبطة'},
    ebAbsAmt:{en:'|PTD| amount',ar:'قيمة |الفترة|'},
    ebUpBad:{en:'Could not read the file — required columns: Entity, Cost Center, Account, Period, Actual Amount (plus Budget Code, Activity, Future1, Future2, Budget Amount, Encumbrance Amount).',ar:'تعذّرت قراءة الملف — الأعمدة المطلوبة: Entity, Cost Center, Account, Period, Actual Amount (بالإضافة إلى Budget Code, Activity, Future1, Future2, Budget Amount, Encumbrance Amount).'},
    ebUpBusy:{en:'Uploading chunk {i}/{n}…',ar:'جارٍ تحميل الدفعة {i}/{n}…'},
    ebUpDone:{en:'Upload complete: {ok} rows saved, {err} errors.',ar:'اكتمل التحميل: {ok} سطراً محفوظاً، {err} أخطاء.'},
    ebRegQueued:{en:'Register queued — run #',ar:'تم إرسال السجل — تشغيل رقم '},
    ebRegFailed:{en:'Register failed: ',ar:'فشل السجل: '},

    /* ── Cashflow (budget cashflow plan uploads) ── */
    navCashflow:{en:'Cashflow',ar:'التدفق النقدي'},
    cfTitle:{en:'Budget Cashflow Plan',ar:'خطة التدفق النقدي للميزانية'},
    cfSub:{en:'The approved / revised budget cashflow phasing maintained by Finance — uploaded from Excel and consumed by the DOF reports. A dedicated Cashflow module will take these over later.',ar:'التوزيع الزمني للتدفق النقدي للميزانية (المعتمد / المعدّل) الذي تديره المالية — يُحمّل من إكسل وتستخدمه تقارير دائرة المالية. ستتولى وحدة التدفق النقدي المخصصة هذه البيانات لاحقاً.'},
    cfGlRegion:{en:'GL Budget Cashflow (10-segment combinations)',ar:'التدفق النقدي لميزانية الأستاذ العام (تركيبات ١٠ بنود)'},
    cfPjRegion:{en:'Projects Cashflow (project / task / expenditure type)',ar:'التدفق النقدي للمشاريع (مشروع / مهمة / نوع مصروف)'},
    cfUploadGl:{en:'Upload GL cashflow (Excel)',ar:'تحميل التدفق النقدي للأستاذ (إكسل)'},
    cfUploadPj:{en:'Upload projects cashflow (Excel)',ar:'تحميل التدفق النقدي للمشاريع (إكسل)'},
    cfTypeL:{en:'Type',ar:'النوع'}, cfAmtL:{en:'Total amount',ar:'إجمالي المبلغ'},
    cfChMapL:{en:'Chapter mapped',ar:'مرتبط بالباب'}, cfProjectsL:{en:'Projects',ar:'المشاريع'},
    cfEmptyGl:{en:'No GL cashflow loaded yet — upload the plan to feed the DOF Budget Utilization and Quarterly reports.',ar:'لم يتم تحميل تدفق نقدي للأستاذ بعد — حمّل الخطة لتغذية تقارير دائرة المالية.'},
    cfEmptyPj:{en:'No projects cashflow loaded yet.',ar:'لم يتم تحميل تدفق نقدي للمشاريع بعد.'},
    cfUnmappedAppr:{en:'Top cashflow appropriations without a chapter',ar:'أهم اعتمادات التدفق النقدي بدون باب'},
    cfGlUpBad:{en:'Could not read the file — required columns: Appropriation, Period, CF Type, Amount (plus the other GL segments).',ar:'تعذّرت قراءة الملف — الأعمدة المطلوبة: Appropriation, Period, CF Type, Amount (بالإضافة إلى بقية البنود).'},
    cfPjUpBad:{en:'Could not read the file — required columns: Project, Task, Expenditure Type, Period, CF Type, Amount.',ar:'تعذّرت قراءة الملف — الأعمدة المطلوبة: Project, Task, Expenditure Type, Period, CF Type, Amount.'},
    cfTplBtn:{en:'Download template (all budget lines)',ar:'تنزيل النموذج (كل بنود الميزانية)'},
    cfTplBuilding:{en:'Building template…',ar:'جارٍ إعداد النموذج…'},
    cfTplHint:{en:'The template is pre-filled with every project / task / expenditure type of the selected budget year, its full 10-segment GL combination and any cashflow amounts already saved — type the monthly amounts and upload the same file back.',ar:'يأتي النموذج معبأً بكل مشروع / مهمة / نوع مصروف لسنة الميزانية المختارة مع تركيبة الأستاذ العام الكاملة (١٠ بنود) وأي مبالغ تدفق نقدي محفوظة — أدخل المبالغ الشهرية وأعد تحميل نفس الملف.'},
    cfTplEmpty:{en:'No budget lines found for that year — the template was created with the column layout only.',ar:'لا توجد بنود ميزانية لتلك السنة — تم إنشاء النموذج بالأعمدة فقط.'},
    cfTplDone:{en:'Template ready — {n} budget line(s) for {y}.',ar:'النموذج جاهز — {n} بند ميزانية لسنة {y}.'},
    cfTplFail:{en:'Could not build the template',ar:'تعذّر إعداد النموذج'},
    cfTplNoteSheet:{en:'How to use',ar:'طريقة الاستخدام'},

    /* ── DOF Reports (YoY / Budget Utilization / Quarterly) ── */
    navDof:{en:'DOF Submissions',ar:'تقارير دائرة المالية'},
    dofTitle:{en:'DOF Submissions',ar:'التقارير المقدمة لدائرة المالية'},
    dofSub:{en:'The Department of Finance performance submissions — YoY Performance, Budget Utilization and Quarterly Performance — generated from GL balances, the legacy EBS history and the uploaded cashflow plan.',ar:'تقارير الأداء المقدمة لدائرة المالية — الأداء السنوي واستخدام الميزانية والأداء الربع سنوي — مُعدة من أرصدة الأستاذ العام وسجل النظام السابق وخطة التدفق النقدي.'},
    dofReportL:{en:'Report',ar:'التقرير'},
    dofYoY:{en:'YoY Performance',ar:'الأداء السنوي المقارن'},
    dofButil:{en:'Budget Utilization (DOF)',ar:'استخدام الميزانية (دائرة المالية)'},
    dofQuarterly:{en:'Quarterly Performance',ar:'الأداء الربع سنوي'},
    dofPeriodL:{en:'Period (YTD end)',ar:'الفترة (حتى تاريخه)'},
    dofLatest:{en:'Latest loaded',ar:'أحدث فترة'},
    dofRun:{en:'Run',ar:'تشغيل'},
    dofGenerate:{en:'Generate Workbook (XLSX)',ar:'إنشاء المصنف (XLSX)'},
    dofGenBusy:{en:'Generating…',ar:'جارٍ الإنشاء…'},
    dofRowHint:{en:'Click a row to edit its Reasons for Variance / Remarks.',ar:'انقر على أي سطر لتحرير أسباب الانحراف / الملاحظات.'},
    dofNoteTitle:{en:'Reasons & Remarks',ar:'الأسباب والملاحظات'},
    dofNoteCtx:{en:'Saved notes persist and pre-fill every future run of this report.',ar:'تُحفظ الملاحظات وتظهر تلقائياً في كل تشغيل قادم لهذا التقرير.'},
    dofReason:{en:'Reason for variance',ar:'سبب الانحراف'},
    dofRemark:{en:'Remarks',ar:'الملاحظات'},
    dofReasonQ:{en:'Reason — Q',ar:'سبب الانحراف — الربع '},
    dofCfMissing:{en:'No cashflow plan loaded for this year — the cashflow columns are zero. Upload it on the Cashflow tab.',ar:'لا توجد خطة تدفق نقدي محملة لهذه السنة — أعمدة التدفق النقدي صفرية. حمّلها من تبويب التدفق النقدي.'},
    dofColEntity:{en:'Entity',ar:'الجهة'}, dofColEntityName:{en:'Entity Name',ar:'اسم الجهة'},
    dofColChapter:{en:'Chapter',ar:'الباب'},
    dofColAppr:{en:'Appropriation',ar:'الاعتماد'}, dofColApprDesc:{en:'Appropriation Description',ar:'وصف الاعتماد'},
    dofColEbsAcc:{en:'EBS Account',ar:'حساب EBS'}, dofColFusionAcc:{en:'Fusion Account',ar:'حساب Fusion'},
    dofColAccName:{en:'Account Name',ar:'اسم الحساب'},
    dofColPriorFy:{en:'Prior Year Actual FY',ar:'فعلي السنة السابقة (كاملة)'},
    dofColRevBudget:{en:'Revised Budget',ar:'الميزانية المعدلة'},
    dofColActualYtd:{en:'Actual YTD',ar:'الفعلي حتى تاريخه'},
    dofColPriorYtd:{en:'Prior Year Actual YTD',ar:'فعلي السنة السابقة حتى تاريخه'},
    dofColVariance:{en:'Variance',ar:'الانحراف'},
    dofColReason:{en:'Reasons for Variance',ar:'أسباب الانحراف'},
    dofColInitBudget:{en:'Initial Budget FY',ar:'الميزانية الأولية'},
    dofColRevBudgetFy:{en:'Revised Budget FY',ar:'الميزانية المعدلة'},
    dofColInitCf:{en:'Initial Budget YTD CF',ar:'التدفق النقدي الأولي حتى تاريخه'},
    dofColRevCf:{en:'Revised Budget YTD Cashflow',ar:'التدفق النقدي المعدل حتى تاريخه'},
    dofColUtilPct:{en:'Budget Utilization %',ar:'نسبة استخدام الميزانية %'},
    dofColApproved:{en:'Approved Budget',ar:'الميزانية المعتمدة'},
    dofColRevQ1:{en:'Revised Budget Q1',ar:'الميزانية المعدلة ر١'},
    dofColRevQ2:{en:'Revised Budget Q2',ar:'الميزانية المعدلة ر٢'},
    dofColAcf:{en:'Approved CF Q',ar:'التدفق المعتمد ر'},
    dofColRcf:{en:'Revised CF Q',ar:'التدفق المعدل ر'},
    dofColAct:{en:'Actual Q',ar:'الفعلي ر'},
    dofColVar:{en:'Variance Q',ar:'الانحراف ر'},
    dofColPct:{en:'Variance % Q',ar:'الانحراف % ر'},
    dofColRsn:{en:'Reasons Q',ar:'الأسباب ر'},
    dofColRemark:{en:'Remarks',ar:'الملاحظات'},
    /* year-dynamic column headers ({y} = the run year) + region labels */
    dofRows:{en:'rows',ar:'سطر'},
    dofColActualFyY:{en:'Actual FY {y}',ar:'الفعلي للسنة الكاملة {y}'},
    dofColRevBudgetY:{en:'Revised Budget {y}',ar:'الميزانية المعدلة {y}'},
    dofColActualYtdY:{en:'Actual YTD {y}',ar:'الفعلي حتى تاريخه {y}'},
    dofColVarianceY:{en:'Variance ({y} vs {p})',ar:'الانحراف ({y} مقابل {p})'},
    dofColInitBudgetY:{en:'Initial Budget FY {y}',ar:'الميزانية الأولية {y}'},
    dofColRevBudgetFyY:{en:'Revised Budget FY {y}',ar:'الميزانية المعدلة {y}'},
    dofColInitCfY:{en:'Initial Budget YTD CF {y}',ar:'التدفق النقدي الأولي حتى تاريخه {y}'},
    dofColRevCfY:{en:'Revised Budget YTD Cashflow {y}',ar:'التدفق النقدي المعدل حتى تاريخه {y}'},
    dofColApprovedY:{en:'Approved Budget {y}',ar:'الميزانية المعتمدة {y}'},
    dofColRevQ1Y:{en:'Revised Budget {y} Q1',ar:'الميزانية المعدلة {y} ر١'},
    dofColRevQ2Y:{en:'Revised Budget {y} Q2',ar:'الميزانية المعدلة {y} ر٢'},
    dofEbsEra:{en:'Years up to 2025 read the legacy EBS history (budget group 1) translated through the account mapping — Initial budget equals Revised for those years.',ar:'السنوات حتى 2025 تُقرأ من سجل النظام السابق (مجموعة الميزانية 1) عبر ربط الحسابات — الميزانية الأولية تساوي المعدلة لتلك السنوات.'},
    /* column-header ⓘ hints ({y} = run year, {p} = prior year) */
    dofHintActualFy:{en:'Full-year actual of {y}: every accounting period through December, including the year-end adjustment period.\nReference column — the Variance never uses it.',ar:'الفعلي الكامل لسنة {y}: جميع الفترات المحاسبية حتى ديسمبر بما فيها فترة التسوية الختامية.\nعمود مرجعي — لا يدخل في حساب الانحراف.'},
    dofHintActualYtd:{en:'Actual of {y} from 1 January to the selected "Period (YTD end)".',ar:'فعلي سنة {y} من 1 يناير حتى الفترة المحددة في «الفترة (حتى تاريخه)».'},
    dofHintPriorYtd:{en:'Actual of {p} cut off at the SAME month as Actual YTD {y} — the like-for-like comparator.\nVariance = Actual YTD {y} − Actual YTD {p}.',ar:'فعلي سنة {p} حتى نفس شهر القطع المستخدم في فعلي {y} — للمقارنة المتكافئة فترةً بفترة.\nالانحراف = فعلي {y} حتى تاريخه − فعلي {p} حتى تاريخه.'},
    dofHintRevBudget:{en:'Full-year revised budget of {y}: initial budget plus all approved adjustments.',ar:'الميزانية المعدلة الكاملة لسنة {y}: الميزانية الأولية مضافاً إليها جميع التعديلات المعتمدة.'},
    dofHintVariance:{en:'Actual YTD {y} − Actual YTD {p}: a same-period comparison — never measured against the full-year column.',ar:'فعلي {y} حتى تاريخه − فعلي {p} حتى تاريخه: مقارنة عن نفس الفترة — لا تُقاس أبداً مقابل عمود السنة الكاملة.'},
    dofHintInitBudget:{en:'Full-year initial (approved) budget of {y}.\nEBS-era years (before 2026) carry one budget measure, so Initial = Revised.',ar:'الميزانية الأولية (المعتمدة) الكاملة لسنة {y}.\nسنوات النظام السابق (قبل 2026) تحمل مقياس ميزانية واحداً، لذا الأولية = المعدلة.'},
    dofHintInitCf:{en:'APPROVED budget cashflow of {y} (user-uploaded plan) summed from 1 January to the selected YTD end.',ar:'التدفق النقدي المعتمد لسنة {y} (الخطة المحملة) مجموعاً من 1 يناير حتى نهاية الفترة المحددة.'},
    dofHintRevCf:{en:'REVISED budget cashflow of {y} (user-uploaded plan) summed from 1 January to the selected YTD end.',ar:'التدفق النقدي المعدل لسنة {y} (الخطة المحملة) مجموعاً من 1 يناير حتى نهاية الفترة المحددة.'},
    dofHintUtilPct:{en:'Actual YTD {y} ÷ Revised Budget YTD Cashflow × 100.',ar:'فعلي {y} حتى تاريخه ÷ التدفق النقدي المعدل حتى تاريخه × 100.'},
    dofHintVarianceBu:{en:'Revised Budget YTD Cashflow − Actual YTD {y}.',ar:'التدفق النقدي المعدل حتى تاريخه − فعلي {y} حتى تاريخه.'},
    dofHintApproved:{en:'Annual approved budget of {y}.\nEBS-era years (before 2026): the single stored budget measure.',ar:'الميزانية السنوية المعتمدة لسنة {y}.\nسنوات النظام السابق (قبل 2026): مقياس الميزانية الوحيد المخزن.'},
    dofHintRevQn:{en:'Revised budget of {y} as of the end of that quarter (cumulative through Q{q}).',ar:'الميزانية المعدلة لسنة {y} كما في نهاية ذلك الربع (تراكمياً حتى الربع {q}).'},
    /* layout enhancements (2026-08-04): year bands / unit / zero display / record drawer */
    dofBandFy:{en:'FY {y}',ar:'السنة المالية {y}'},
    dofBandBudget:{en:'Budget {y}',ar:'موازنة {y}'},
    dofBandPerf:{en:'Performance {y}',ar:'الأداء {y}'},
    dofBandQ:{en:'Quarter {q}',ar:'الربع {q}'},
    dofZeroL:{en:'Near-zero display',ar:'عرض القيم شبه الصفرية'},
    dofZeroMuted:{en:'Dimmed 0.00',ar:'0.00 باهت'},
    dofZeroDash:{en:'Dash (—)',ar:'شرطة (—)'},
    dofZeroBlank:{en:'Blank',ar:'فارغ'},
    dofZeroHint:{en:'How figures that round to zero at the selected unit are displayed — they usually mean "no data" (e.g. pre-2025 EBS actuals pending Finance confirmation), not a real zero.',ar:'كيفية عرض الأرقام التي تقارب الصفر عند الوحدة المحددة — غالباً تعني «لا بيانات» وليس صفراً حقيقياً.'},
    dofRecInfo:{en:'Record details',ar:'تفاصيل السجل'},
    dofColAccount:{en:'Account',ar:'الحساب'},
    dofAllApprs:{en:'All appropriations',ar:'كل الاعتمادات'},

    /* ── GL Balances YoY comparison ── */
    navYoy:{en:'Balances YoY',ar:'مقارنة الأرصدة سنوياً'},
    yoTitle:{en:'GL Balances — Year over Year',ar:'أرصدة الأستاذ العام — مقارنة سنوية'},
    yoSub:{en:'Compare YTD balances per GL account across years on the Fusion account basis — legacy EBS years (2016–2025) are translated through the account mapping; 2026 onward reads Fusion GL.',ar:'قارن الأرصدة التراكمية لكل حساب عبر السنوات على أساس حساب Fusion — سنوات النظام السابق (2016–2025) مترجمة عبر ربط الحسابات؛ ومن 2026 تُقرأ من Fusion مباشرة.'},
    yoYearsL:{en:'Years (max 6)',ar:'السنوات (بحد أقصى 6)'},
    yoMonthL:{en:'Balance as of',ar:'الرصيد كما في'},
    yoFullYear:{en:'Full year',ar:'السنة الكاملة'},
    yoSearchL:{en:'Account search',ar:'بحث الحساب'},
    yoTypeL:{en:'Account type',ar:'نوع الحساب'},
    yoAllTypes:{en:'All types',ar:'كل الأنواع'},
    yoRun:{en:'Run',ar:'تشغيل'},
    yoMeasureL:{en:'Measure',ar:'المقياس'},
    yoActual:{en:'Actual',ar:'الفعلي'},
    yoBudget:{en:'Budget',ar:'الميزانية'},
    yoEnc:{en:'Encumbrance',ar:'الارتباطات'},
    yoColAccount:{en:'Account',ar:'الحساب'},
    yoColName:{en:'Account Name',ar:'اسم الحساب'},
    yoColType:{en:'Type',ar:'النوع'},
    yoColChange:{en:'Change',ar:'التغير'},
    yoColChangePct:{en:'Change %',ar:'التغير %'},
    yoChangeHint:{en:'Change = latest selected year vs the previous one, for the chosen measure.',ar:'التغير = أحدث سنة مختارة مقابل السنة السابقة لها، حسب المقياس المختار.'},
    yoAccounts:{en:'accounts',ar:'حساب'},
    yoNoRows:{en:'No balances for the selected criteria — run with different years or clear the filters.',ar:'لا توجد أرصدة للمعايير المختارة — جرّب سنوات أخرى أو امسح المرشحات.'},
    yoXlsx:{en:'Export Excel Register',ar:'تصدير سجل Excel'},
    yoXlsBusy:{en:'Generating…',ar:'جارٍ الإنشاء…'},
    yoCsvBtn:{en:'Export CSV',ar:'تصدير CSV'},
    /* interactive-report round (2026-08-03) */
    yoColChart:{en:'Chart',ar:'الرسم البياني'},
    yoHintChart:{en:'Hover over the sparkline to see this account\'s values across the selected years.',ar:'مرر المؤشر فوق الرسم لعرض قيم الحساب عبر السنوات المحددة.'},
    yoHintYear:{en:'{m} balance of {y} — {a}.\nYears 2016–2025 read the legacy EBS stored YTD balances (incl. opening balances) through the account mapping; 2026 onward reads Fusion GL.',ar:'رصيد {m} لسنة {y} — {a}.\nتُقرأ السنوات 2016–2025 من أرصدة النظام السابق المخزنة (شاملة الأرصدة الافتتاحية) عبر ربط الحسابات؛ ومن 2026 تُقرأ من Fusion.'},
    yoHintChange:{en:'{m} {a} − {m} {b}: the change between the two latest selected years.',ar:'{m} {a} − {m} {b}: التغير بين آخر سنتين محددتين.'},
    yoHintChangePct:{en:'Change {b}-{a} ÷ |{b} value| × 100 — the change as a percentage of {b}.',ar:'التغير {b}-{a} ÷ |قيمة {b}| × 100 — نسبة التغير إلى سنة {b}.'},
    yoPickYear:{en:'Select at least one year.',ar:'اختر سنة واحدة على الأقل.'},
    yoMax6:{en:'Maximum 6 years.',ar:'بحد أقصى 6 سنوات.'},
    yoEbsNote:{en:'2016–2025 = legacy EBS (stored YTD balances incl. opening balances); 2026+ = Fusion GL. Account 452201 (Revenue Transfer to Treasury) and unmapped EBS accounts are excluded platform-wide.',ar:'2016–2025 = النظام السابق (أرصدة تراكمية مخزنة تشمل الأرصدة الافتتاحية)؛ 2026+ = Fusion. الحساب 452201 (تحويل الإيرادات للخزينة) والحسابات غير المربوطة مستبعدة على مستوى المنصة.'},
    yoBgL:{en:'Budget group',ar:'مجموعة الميزانية'},
    yoBg1:{en:'1 — Current operations',ar:'1 — العمليات الجارية'},
    yoBg2:{en:'2 — Capital projects',ar:'2 — المشاريع الرأسمالية'},
    yoBg8:{en:'8 — Accrual adjustments',ar:'8 — تسويات الاستحقاق'},
    yoBgHint:{en:'Default = 1 (Current operations). Groups 2 / 8 are optional add-ons (legacy EBS years only).',ar:'الافتراضي = 1 (العمليات الجارية). المجموعتان 2 / 8 اختياريتان (سنوات النظام السابق فقط).'},
    yoPickBg:{en:'Select at least one budget group.',ar:'اختر مجموعة ميزانية واحدة على الأقل.'},

    /* ── Actuals (Budget vs Actual) report ── */
    navActuals:{en:'Budget vs Actual',ar:'الموازنة مقابل الفعلي'}, navDashboard:{en:'Dashboard',ar:'لوحة المعلومات'},
    acTitle:{en:'Budget vs Actual',ar:'الموازنة مقابل الفعلي'},
    acSub:{en:'Year-to-date budget, encumbrance and actual spend per GL combination.',ar:'الموازنة والارتباطات والإنفاق الفعلي حتى تاريخه لكل تركيبة محاسبية.'},
    fPeriod:{en:'Accounting period',ar:'الفترة المحاسبية'}, fSectorL:{en:'Sector',ar:'القطاع'},
    fChapterL:{en:'Chapter',ar:'الباب'}, fProgramL:{en:'DCT Program',ar:'برنامج الدائرة'},
    fApprL:{en:'Appropriation',ar:'الاعتماد'}, fSearchL:{en:'Search',ar:'بحث'},
    fAccountL:{en:'Account',ar:'الحساب'}, fCostCenterL:{en:'Cost center',ar:'مركز التكلفة'}, fSourceL:{en:'Transaction source',ar:'مصدر الحركة'},
    allPrograms:{en:'All programs',ar:'كل البرامج'}, allApprops:{en:'All appropriations',ar:'كل الاعتمادات'},
    allAccounts:{en:'All accounts',ar:'كل الحسابات'}, allCostCenters:{en:'All cost centers',ar:'كل مراكز التكلفة'}, allSources:{en:'All sources',ar:'كل المصادر'},
    srcBudget:{en:'Has budget',ar:'له موازنة'}, srcCommitment:{en:'Has commitment (PR)',ar:'له التزام (طلب شراء)'},
    srcObligation:{en:'Has obligation (PO)',ar:'له تعهد (أمر شراء)'}, srcGlActual:{en:'Has GL actual',ar:'له فعلي بالأستاذ'},
    srcGrn:{en:'Has GRN received',ar:'له استلام'}, srcApDirect:{en:'Has AP direct',ar:'له مباشر دائنون'},
    srcOpenCommitment:{en:'Has open commitment',ar:'له التزام مفتوح'}, srcOpenObligation:{en:'Has open obligation',ar:'له تعهد مفتوح'},
    searchActuals:{en:'Cost center, account, code…',ar:'مركز التكلفة، الحساب، الرمز…'},
    btnSearch:{en:'Search',ar:'بحث'}, btnReset:{en:'Reset',ar:'إعادة تعيين'},
    btnApply:{en:'Apply',ar:'تطبيق'},
    acFilters:{en:'Filters',ar:'عوامل التصفية'},
    acFilterTitle:{en:'Report parameters',ar:'معايير التقرير'},
    acFilterSub:{en:'Choose the accounting period and any optional criteria, then Apply. The report, totals and exports all follow these parameters.',ar:'اختر الفترة المحاسبية وأي معايير اختيارية ثم اضغط تطبيق. يتبع التقرير والإجماليات والتصدير هذه المعايير.'},
    acEditFilters:{en:'Click to edit filters',ar:'انقر لتعديل عوامل التصفية'},
    acNoFilters:{en:'No filters applied — click to add',ar:'لا توجد عوامل تصفية — انقر للإضافة'},
    acUtilized:{en:'of budget spent (GL actual)',ar:'من الموازنة منصرف (فعلي الأستاذ)'},
    acRemainingLbl:{en:'of budget remaining',ar:'من الموازنة متبقٍّ'},
    lblOpenPr:{en:'Open PR',ar:'طلبات مفتوحة'}, lblOpenPo:{en:'Open PO',ar:'أوامر مفتوحة'},
    cTotalActual:{en:'Total Actual',ar:'إجمالي الفعلي'},
    cTotalEncumbrance:{en:'Total Encumbrance',ar:'إجمالي الارتباطات'},
    multiHint:{en:'Multi-select: every pick is added as a chip; the report matches ANY of the chips. Remove a chip with ×.',ar:'اختيار متعدد: كل اختيار يُضاف كشريحة؛ يطابق التقرير أياً من الشرائح. أزل الشريحة بعلامة ×.'},
    fUnitL:{en:'Figures in',ar:'عرض الأرقام'},
    unitAuto:{en:'Auto (B/M/K)',ar:'تلقائي (B/M/K)'},
    unitB:{en:'Billions (B)',ar:'مليارات (B)'},
    unitM:{en:'Millions (M)',ar:'ملايين (M)'},
    unitK:{en:'Thousands (K)',ar:'آلاف (K)'},
    unitExact:{en:'Exact number',ar:'الرقم الكامل'},
    cBudget:{en:'Budget',ar:'الموازنة'}, cEncumbrance:{en:'Encumbrance',ar:'الارتباطات'},
    cCommitment:{en:'Commitment (PR)',ar:'الالتزام (طلب شراء)'}, cObligation:{en:'Obligation (PO)',ar:'التعهد (أمر شراء)'},
    cOpenCommitment:{en:'Open Commitment (PR)',ar:'الالتزام المفتوح (طلب شراء)'}, cOpenObligation:{en:'Open Obligation (PO)',ar:'التعهد المفتوح (أمر شراء)'},
    cActual:{en:'GL Actual',ar:'الفعلي'}, cFunds:{en:'Funds available',ar:'المتاح'},
    cGrn:{en:'GRN actual',ar:'الاستلام الفعلي'}, cApDirect:{en:'AP direct',ar:'مباشر دائنون'},
    cSla:{en:'SLA Actual',ar:'فعلي الدفاتر المساعدة'}, lblPOs:{en:'POs',ar:'أوامر'}, lblPRs:{en:'PRs',ar:'طلبات'},
    cTotalPr:{en:'Total PR',ar:'إجمالي طلبات الشراء'}, cCommitmentPipeline:{en:'Commitment pipeline',ar:'التزامات قيد الإعداد'},
    cTotalPo:{en:'Total PO',ar:'إجمالي أوامر الشراء'}, cPoPipeline:{en:'PO pipeline',ar:'أوامر قيد الإعداد'},
    cOpenEncumbrance:{en:'Open encumbrance',ar:'الارتباطات المفتوحة'},
    cFundsGl:{en:'Funds avail. (GL)',ar:'المتاح (الأستاذ)'}, cFundsCalc:{en:'Funds avail. (calc)',ar:'المتاح (محسوب)'},
    lblTotal:{en:'Total',ar:'الإجمالي'}, lblOpen:{en:'Open',ar:'المفتوح'}, lblPipe:{en:'Pipeline',ar:'قيد الإعداد'},
    lblGL:{en:'GL',ar:'الأستاذ'}, lblCalc:{en:'Calc',ar:'محسوب'},
    cVariance:{en:'Variance',ar:'الفرق'},
    thCombo:{en:'Combination',ar:'التركيبة'}, thAppr:{en:'Appropriation',ar:'الاعتماد'},
    periodRequired:{en:'Please choose an accounting period.',ar:'الرجاء اختيار فترة محاسبية.'},
    noActuals:{en:'No combinations match these criteria.',ar:'لا توجد تركيبات مطابقة.'},
    rowsOf:{en:'of',ar:'من'},
    hBudget:{en:'Total approved budget YTD (initial + adjustments).',ar:'إجمالي الموازنة المعتمدة حتى تاريخه (الأولية + التعديلات).'},
    hEncumbrance:{en:'Commitments + obligations + other encumbrances booked in GL.',ar:'الالتزامات + التعهدات + ارتباطات أخرى المسجلة في دفتر الأستاذ.'},
    hCommitment:{en:'Total purchase requisitions (PR-backed PO lines) charged here, AED, YTD. Click a figure for the PR lines.',ar:'إجمالي طلبات الشراء المحملة هنا، بالدرهم، حتى تاريخه. انقر الرقم لعرض بنود الطلب.'},
    hObligation:{en:'Total purchase orders (all PO lines) charged here, AED, YTD. Click a figure for the PO lines.',ar:'إجمالي أوامر الشراء المحملة هنا، بالدرهم، حتى تاريخه. انقر الرقم لعرض بنود الأمر.'},
    hOpenCommitment:{en:'Open (unliquidated) commitment — PR-backed PO lines whose budget is still encumbered (Reserved / Partially Liquidated), AED, YTD. Click for the PR lines.',ar:'الالتزام المفتوح (غير المصفّى) — بنود أوامر الشراء الممولة من طلب شراء والتي لا تزال محجوزة على الموازنة (محجوزة / مصفّاة جزئياً)، بالدرهم، حتى تاريخه. انقر لعرض بنود الطلب.'},
    hOpenObligation:{en:'Open (unliquidated) obligation — PO lines whose budget is still encumbered (Reserved / Partially Liquidated), not yet expended, AED, YTD. Click for the PO lines.',ar:'التعهد المفتوح (غير المصفّى) — بنود أوامر الشراء التي لا تزال محجوزة على الموازنة (محجوزة / مصفّاة جزئياً) ولم تُصرف بعد، بالدرهم، حتى تاريخه. انقر لعرض بنود الأمر.'},
    hActual:{en:'Actual expenditure recognised in GL, YTD.',ar:'الإنفاق الفعلي المعترف به في دفتر الأستاذ حتى تاريخه.'},
    hFunds:{en:'Budget − encumbrance − actual = funds still available.',ar:'الموازنة − الارتباطات − الفعلي = الأموال المتاحة.'},
    hGrn:{en:'Goods/services received (GRN) against POs, AED, YTD.',ar:'البضائع/الخدمات المستلمة مقابل أوامر الشراء، بالدرهم، حتى تاريخه.'},
    hApDirect:{en:'Invoiced directly in AP with no PO (PO number is null), AED, YTD.',ar:'مفوتر مباشرة في الدائنون دون أمر شراء (رقم أمر الشراء فارغ)، بالدرهم، حتى تاريخه.'},
    hSla:{en:'Subledger Actuals = GRN received + AP direct, AED, YTD.',ar:'فعلي الدفاتر المساعدة = الاستلام + المباشر دائنون، بالدرهم، حتى تاريخه.'},
    hCommitmentGrp:{en:'Requisitions (AED, YTD). Total = Reserved + Liquidated; Open = still Reserved; Pipeline = Not-reserved (draft). Click a figure for the PR lines.',ar:'طلبات الشراء (بالدرهم، حتى تاريخه). الإجمالي = محجوز + مصفّى؛ المفتوح = محجوز؛ قيد الإعداد = غير محجوز. انقر رقماً لعرض البنود.'},
    hObligationGrp:{en:'Purchase orders (AED, YTD). Total = all except Failed/Passed; Open = Reserved/Partially-Liquidated netted by GRN received; Pipeline = Failed/Passed. Click a figure for the PO lines.',ar:'أوامر الشراء (بالدرهم، حتى تاريخه). الإجمالي = الكل عدا الفاشل/المار؛ المفتوح = محجوز/مصفّى جزئياً مطروحاً منه الاستلام؛ قيد الإعداد = فاشل/مار. انقر رقماً لعرض البنود.'},
    hOpenEncumbrance:{en:'Open encumbrance = Open commitment (open PR) + Open obligation (open PO), AED, YTD.',ar:'الارتباطات المفتوحة = الالتزام المفتوح + التعهد المفتوح، بالدرهم، حتى تاريخه.'},
    hFundsGrp:{en:'Funds available. GL = from GL balances; Calc = Budget − Open PO − Open PR − GRN − AP direct.',ar:'الأموال المتاحة. الأستاذ = من أرصدة الأستاذ؛ المحسوب = الموازنة − التعهد المفتوح − الالتزام المفتوح − الاستلام − المباشر دائنون.'},
    hCombo:{en:'Hover to see the full 10-segment account combination.',ar:'مرر للاطلاع على التركيبة المحاسبية الكاملة (10 بنود).'},
    drillTotal:{en:'Total',ar:'الإجمالي'}, noLines:{en:'No supporting lines for this period.',ar:'لا توجد بنود داعمة لهذه الفترة.'},
    mBudget:{en:'Budget',ar:'الموازنة'}, mEncumbrance:{en:'Encumbrance',ar:'الارتباطات'},
    mCommitment:{en:'Commitment — PRs',ar:'الالتزام — طلبات الشراء'}, mObligation:{en:'Obligation — POs',ar:'التعهد — أوامر الشراء'},
    mOpencommitment:{en:'Open commitment — PRs',ar:'الالتزام المفتوح — طلبات الشراء'}, mOpenobligation:{en:'Open obligation — POs',ar:'التعهد المفتوح — أوامر الشراء'},
    mCommitmentpipeline:{en:'Commitment pipeline — PRs',ar:'التزامات قيد الإعداد — طلبات الشراء'}, mPopipeline:{en:'PO pipeline',ar:'أوامر قيد الإعداد'},
    mGlactual:{en:'GL Actual',ar:'الفعلي'}, mGrn:{en:'GRN actual',ar:'الاستلام الفعلي'}, mApdirect:{en:'AP direct',ar:'مباشر دائنون'},
    mFunds:{en:'Funds available (GL)',ar:'الأموال المتاحة (الأستاذ)'}, mFundscalc:{en:'Funds available (calc)',ar:'الأموال المتاحة (محتسب)'},
    acKpiDrillHint:{en:'Click to see the supporting lines across the whole filtered set',ar:'انقر لعرض البنود الداعمة عبر كامل المجموعة المُصفّاة'},
    acAllLines:{en:'All lines',ar:'كل البنود'},
    refreshActuals:{en:'Refresh actuals',ar:'تحديث الفعلي'}, refreshing:{en:'Refreshing…',ar:'جارٍ التحديث…'},
    pdataBtn:{en:'Refresh source data',ar:'تحديث بيانات المصدر'}, pdataRunning:{en:'Refreshing data…',ar:'جارٍ تحديث البيانات…'},
    pdataHint:{en:'Re-extract ALL page source data from Fusion now: projects, tasks, budget + AP invoices (header/lines/distributions), PO, PR and GRN (15 full jobs; ~3–6 minutes)',ar:'إعادة استخراج كل بيانات المصدر من فيوجن الآن: المشاريع والمهام والميزانية + فواتير الموردين (رأس/بنود/توزيعات) وأوامر الشراء وطلبات الشراء والاستلام (١٥ مهمة كاملة؛ ٣–٦ دقائق تقريباً)'},
    pdataQueued:{en:'Source-data refresh started ({n} jobs queued)…',ar:'بدأ تحديث بيانات المصدر ({n} مهام في قائمة الانتظار)…'},
    pdataDone:{en:'Source data refreshed — projects, tasks, budget, AP, PO, PR and GRN are up to date',ar:'تم تحديث بيانات المصدر — المشاريع والمهام والميزانية وفواتير الموردين وأوامر الشراء وطلبات الشراء والاستلام محدّثة'},
    pdataFailed:{en:'Source-data refresh: some jobs failed —',ar:'تحديث بيانات المصدر: فشلت بعض المهام —'},
    pdataTimeout:{en:'Source-data refresh is taking longer than expected — check the ATD Run Logs page',ar:'يستغرق تحديث بيانات المصدر وقتاً أطول من المتوقع — راجع سجلات التشغيل في ATD'},
    cvbTitle:{en:'Refreshing source data from Fusion…',ar:'جارٍ تحديث بيانات المصدر من فيوجن…'},
    cvbCount:{en:'{d} of {n} extracts finished',ar:'اكتمل {d} من {n} استخراجاً'},
    cvbRunning:{en:'now extracting: {j}',ar:'يجري الآن استخراج: {j}'},
    cvbSrc:{en:'Fusion',ar:'فيوجن'}, cvbDst:{en:'i-Finance',ar:'i-Finance'},
    cvbHide:{en:'Hide — the refresh keeps running in the background',ar:'إخفاء — يستمر التحديث في الخلفية'},
    rdBtn:{en:'Refresh data',ar:'تحديث البيانات'},
    rdSrcSub:{en:'Re-extract all 15 source datasets from Fusion (~2–4 min)',ar:'إعادة استخراج كل بيانات المصدر (١٥ مهمة) من فيوجن (٢–٤ دقائق تقريباً)'},
    rdActSub:{en:'Re-snapshot the report figures (also runs hourly)',ar:'إعادة لقطة أرقام التقرير (تعمل كل ساعة تلقائياً)'},
    rdRebSub:{en:'Admin recovery after a structural data reload',ar:'استرداد إداري بعد إعادة تحميل هيكلية للبيانات'},
    rdLastL:{en:'Source data last refreshed: {t}',ar:'آخر تحديث لبيانات المصدر: {t}'},
    refreshed:{en:'Actuals snapshot refreshed',ar:'تم تحديث لقطة الفعلي'},
    refreshHint:{en:'Rebuild the classification snapshot so the report reflects the latest GL/ATD data and mapping edits.',ar:'إعادة بناء لقطة التصنيف لتعكس أحدث بيانات دفتر الأستاذ والربط.'},
    asOfRefresh:{en:'Updated',ar:'حُدّث'},
    rebuildViews:{en:'Rebuild views',ar:'إعادة بناء العروض'}, rebuilding:{en:'Rebuilding…',ar:'جارٍ إعادة البناء…'},
    rebuildHint:{en:'Use ONLY after a data reload that changed table structure (new or renamed columns). Re-creates the reporting base views over the ATD tables, recompiles anything invalid, then refreshes the snapshot. For a normal data reload, “Refresh actuals” is enough.',ar:'يُستخدم فقط بعد تحميل بيانات غيّر بنية الجداول (أعمدة جديدة أو معاد تسميتها): يعيد إنشاء عروض التقارير الأساسية فوق جداول ATD ويعيد ترجمة غير الصالح ثم يحدّث اللقطة. بعد تحميل بيانات اعتيادي يكفي «تحديث الفعلي».'},
    rebuildConfirm:{en:'Rebuild the reporting base views?\n\nUse this after a data reload that CHANGED table structure (new/renamed columns) — e.g. a report errors or a new column is missing even after “Refresh actuals”.\n\nSafe and repeatable; takes under a minute.',ar:'إعادة بناء عروض التقارير الأساسية؟\n\nيُستخدم بعد تحميل بيانات غيّر بنية الجداول (أعمدة جديدة/معاد تسميتها) — مثلاً عند ظهور خطأ في تقرير أو غياب عمود جديد رغم «تحديث الفعلي».\n\nإجراء آمن وقابل للتكرار ويستغرق أقل من دقيقة.'},
    rebuilt:{en:'Base views rebuilt & snapshot refreshed',ar:'أُعيد بناء العروض وتحديث اللقطة'},
    rebuiltLeft:{en:'Still invalid (needs a script fix):',ar:'ما زال غير صالح (يتطلب تعديل السكربت):'},

    /* ── Budget Utilization (project budget vs actual) ── */
    navButil:{en:'Project Budget Utilization',ar:'استخدام موازنة المشاريع'},
    /* ---- Executive Project Dashboard: Portfolio (pf*) + Project 360 (p3*) ---- */
    navPortfolio:{en:'Project Portfolio',ar:'محفظة المشاريع'},
    loadFailed:{en:'Could not load. Please try again.',ar:'تعذر التحميل. حاول مرة أخرى.'},
    fBuL:{en:'Business unit',ar:'وحدة الأعمال'},
    fCcL:{en:'Cost centre',ar:'مركز التكلفة'},
    fProjectL:{en:'Project',ar:'المشروع'},
    allBus:{en:'All business units',ar:'كل وحدات الأعمال'},
    navProj360:{en:'Project 360',ar:'المشروع 360'},
    pfTitle:{en:'Project Portfolio',ar:'محفظة المشاريع'},
    pfSub:{en:'Every project in the budget year — budget, commitments, consumption, payment and health at a glance. Click any row for the full project.',ar:'كل مشروع في السنة المالية — الموازنة والارتباطات والاستهلاك والسداد والحالة في لمحة. اضغط أي صف لعرض المشروع كاملاً.'},
    pfSecSearch:{en:'Search criteria',ar:'معايير البحث'},
    pfSecOverview:{en:'Overview',ar:'نظرة عامة'},
    pfSecHealth:{en:'Health and momentum',ar:'الحالة والاتجاه'},
    pfSecRegister:{en:'Projects register',ar:'سجل المشاريع'},
    pfHealthL:{en:'Health',ar:'الحالة'},
    pfAllHealth:{en:'All health bands',ar:'كل الحالات'},
    pfStatusL:{en:'Project status',ar:'حالة المشروع'},
    pfAllStatus:{en:'All statuses',ar:'كل الحالات'},
    pfManagerL:{en:'Project manager',ar:'مدير المشروع'},
    pfSortL:{en:'Rank by',ar:'الترتيب حسب'},
    pfSortHealth:{en:'Health (worst first)',ar:'الحالة (الأسوأ أولاً)'},
    pfSortBudget:{en:'Budget',ar:'الموازنة'},
    pfSortActual:{en:'Consumed',ar:'المستهلك'},
    pfSortCommitted:{en:'Committed',ar:'المرتبط'},
    pfSortFund:{en:'Funds available',ar:'المتاح'},
    pfSortUtil:{en:'Utilisation %',ar:'نسبة الاستخدام ٪'},
    pfRowHint:{en:'Click any row to open Project 360',ar:'اضغط أي صف لفتح المشروع 360'},
    pfKProjects:{en:'Projects',ar:'المشاريع'},
    pfKBudget:{en:'Portfolio budget',ar:'موازنة المحفظة'},
    pfKActual:{en:'Consumed',ar:'المستهلك'},
    pfKCommit:{en:'Committed',ar:'المرتبط'},
    pfKPaid:{en:'Paid',ar:'المسدد'},
    pfKFund:{en:'Funds available',ar:'المتاح'},
    pfKRisk:{en:'Needs attention',ar:'يحتاج انتباهاً'},
    pfAp:{en:'AP invoiced',ar:'فواتير الموردين'},
    pfGrn:{en:'GRN received',ar:'المستلم'},
    pfPr:{en:'Commitment (PR)',ar:'ارتباط (طلب شراء)'},
    pfPo:{en:'Obligation (PO)',ar:'تعهد (أمر شراء)'},
    pfPaidOf:{en:'{p}% of invoiced settled',ar:'تم سداد {p}٪ من المفوتر'},
    pfOfBudget:{en:'{p}% of budget',ar:'{p}٪ من الموازنة'},
    pfOverBudget:{en:'over budget',ar:'تجاوز الموازنة'},
    pfHCrit:{en:'Critical',ar:'حرج'},
    pfHRisk:{en:'At risk',ar:'معرّض للخطر'},
    pfHWatch:{en:'Watch',ar:'قيد المتابعة'},
    pfHOk:{en:'Healthy',ar:'سليم'},
    pfHNone:{en:'No data',ar:'لا بيانات'},
    pfBandGreen:{en:'Healthy',ar:'سليم'},
    pfBandAmber:{en:'Watch',ar:'قيد المتابعة'},
    pfBandRed:{en:'Critical',ar:'حرج'},
    pfBandGrey:{en:'No data',ar:'لا بيانات'},
    pfGaugeT:{en:'Portfolio utilisation',ar:'استخدام موازنة المحفظة'},
    pfGaugeSub:{en:'of annual budget consumed',ar:'من الموازنة السنوية مستهلك'},
    pfLegUtil:{en:'Consumed',ar:'المستهلك'},
    pfLegCommit:{en:'Consumed + committed',ar:'المستهلك + المرتبط'},
    pfLegElapsed:{en:'Year elapsed',ar:'المنقضي من السنة'},
    pfDistT:{en:'Health distribution',ar:'توزيع الحالة'},
    pfPressureT:{en:'Largest consumers',ar:'الأكبر استهلاكاً'},
    pfInsightsT:{en:'Insights',ar:'رؤى'},
    pfInsUtil:{en:'{n} projects in {y}: {p}% of annual budget consumed — {a} of {b} AED.',ar:'{n} مشروعاً في {y}: استُهلك {p}٪ من الموازنة السنوية — {a} من {b} درهم.'},
    pfInsPace:{en:'The year is {e}% elapsed, so the portfolio is running {d}.',ar:'انقضى {e}٪ من السنة، لذا فإن المحفظة {d}.'},
    pfPaceAhead:{en:'ahead of the calendar',ar:'متقدمة على التقويم'},
    pfPaceBehind:{en:'behind the calendar',ar:'متأخرة عن التقويم'},
    pfPaceOn:{en:'broadly on pace',ar:'ضمن الوتيرة تقريباً'},
    pfInsRisk:{en:'{c} projects are critical and {r} need watching.',ar:'{c} مشروعاً في وضع حرج و{r} تحتاج متابعة.'},
    pfInsOver:{en:'{n} projects have spent past their budget — funds available is negative.',ar:'{n} مشروعاً تجاوزت موازنتها — المتاح سالب.'},
    pfInsPaid:{en:'{p}% of invoiced value has been settled — {a} paid of {i} AED invoiced.',ar:'تم سداد {p}٪ من قيمة الفواتير — {a} مسدد من {i} درهم مفوتر.'},
    pfInsTop:{en:'{s} is the largest consumer at {a} AED, {p}% of its own budget.',ar:'{s} هو الأكبر استهلاكاً بـ {a} درهم، أي {p}٪ من موازنته.'},
    pfInsNoSpend:{en:'{n} projects hold a year-to-date budget but have spent nothing yet.',ar:'{n} مشروعاً لديها موازنة حتى تاريخه دون أي إنفاق.'},
    pfInsPending:{en:'{n} documents have waited more than 30 days for approval.',ar:'{n} مستنداً بانتظار الاعتماد لأكثر من 30 يوماً.'},
    pfInsUnbudgeted:{en:'{n} projects consumed {a} AED with no budget line at all.',ar:'{n} مشروعاً استهلكت {a} درهم دون أي بند موازنة.'},
    pfColProject:{en:'Project',ar:'المشروع'},
    pfColManager:{en:'Manager',ar:'المدير'},
    pfColStatus:{en:'Status',ar:'الحالة'},
    pfColHealth:{en:'Health',ar:'الحالة'},
    pfColBudgetA:{en:'Annual budget',ar:'الموازنة السنوية'},
    pfColBudgetY:{en:'YTD budget',ar:'الموازنة حتى تاريخه'},
    pfColAp:{en:'AP',ar:'الموردون'},
    pfColGrn:{en:'GRN',ar:'الاستلام'},
    pfColPr:{en:'PR',ar:'طلب الشراء'},
    pfColPo:{en:'PO',ar:'أمر الشراء'},
    pfColFund:{en:'Funds available',ar:'المتاح'},
    pfColUtil:{en:'Utilisation %',ar:'نسبة الاستخدام ٪'},
    pfColPaid:{en:'Paid',ar:'المسدد'},
    pfColBilled:{en:'Billed revenue',ar:'الإيراد المفوتر'},
    pfColPending:{en:'Pending docs',ar:'مستندات معلقة'},
    pfColTasks:{en:'Tasks',ar:'المهام'},
    pfGrpProject:{en:'Project',ar:'المشروع'},
    pfGrpBudget:{en:'Budget',ar:'الموازنة'},
    pfGrpConsumed:{en:'Consumed',ar:'المستهلك'},
    pfGrpCommitted:{en:'Committed',ar:'المرتبط'},
    pfGrpPosition:{en:'Position',ar:'الموقف'},
    pfGrpOther:{en:'Revenue and pipeline',ar:'الإيرادات وخط الأعمال'},
    pfHintHealth:{en:'Advisory score from burn discipline, fund headroom, approval friction and activity. Schedule is deliberately not scored: task actual dates are empty in the source.',ar:'درجة استرشادية من انضباط الإنفاق ومساحة التمويل واحتكاك الاعتماد والنشاط. الجدول الزمني غير مُقيَّم عمداً: تواريخ المهام الفعلية غير متوفرة في المصدر.'},
    pfHintPaid:{en:'Derived from each AP invoice header paid ratio, capped at 100%, applied to that invoice project distributions. Fusion payments carry no invoice or project reference, so they cannot be joined directly.',ar:'مشتق من نسبة السداد على رأس كل فاتورة مورد، بحد أقصى 100٪، مطبقة على توزيعات المشروع. مدفوعات فيوجن لا تحمل مرجع فاتورة أو مشروع فلا يمكن ربطها مباشرة.'},
    pfHintBilled:{en:'Billed (invoiced) revenue only. Collections cannot be shown — no AR receipts extract exists on the platform. Only 51 of 991 projects carry any AR line.',ar:'الإيراد المفوتر فقط. لا يمكن عرض التحصيلات — لا يوجد استخراج لإيصالات المدينين. 51 مشروعاً فقط من 991 لديها بنود مدينين.'},
    pfHintUtil:{en:'(Consumed + committed) as a share of the annual budget.',ar:'(المستهلك + المرتبط) كنسبة من الموازنة السنوية.'},
    pfNoRows:{en:'No projects match the selected criteria.',ar:'لا توجد مشاريع مطابقة للمعايير المحددة.'},
    pfUnitNote:{en:'Register figures are exact AED. The summary above is shown in {u}.',ar:'أرقام السجل بالدرهم بالضبط. الملخص أعلاه معروض بـ {u}.'},
    pfUnbudgeted:{en:'Unbudgeted spend',ar:'إنفاق بلا موازنة'},
    pfUnbudgetedHint:{en:'Money consumed against project/task/expenditure-type combinations that carry no budget line. These are excluded from the reconciling totals above so this page still ties to Budget Utilization.',ar:'مبالغ مستهلكة على تركيبات لا تحمل بند موازنة. مستثناة من الإجماليات أعلاه ليظل هذا التقرير مطابقاً لاستخدام الموازنة.'},
    /* ---- Project 360 ---- */
    p3Back:{en:'Portfolio',ar:'المحفظة'},
    p3SecKpis:{en:'Overview',ar:'نظرة عامة'},
    p3SecFunnel:{en:'Budget to payment',ar:'من الموازنة إلى السداد'},
    p3SecTasks:{en:'Tasks and schedule',ar:'المهام والجدول الزمني'},
    p3SecPipeline:{en:'Documents and pipeline',ar:'المستندات وخط الأعمال'},
    p3SecRev:{en:'Revenue (AR)',ar:'الإيرادات (المدينون)'},
    p3SecTrx:{en:'Budget transactions',ar:'معاملات الموازنة'},
    p3SecCash:{en:'Cashflow plan',ar:'خطة التدفق النقدي'},
    p3Manager:{en:'Project manager',ar:'مدير المشروع'},
    p3Status:{en:'Status',ar:'الحالة'},
    p3Type:{en:'Project type',ar:'نوع المشروع'},
    p3Bu:{en:'Business unit',ar:'وحدة الأعمال'},
    p3Appropriation:{en:'Appropriation',ar:'الاعتماد'},
    p3Chapter:{en:'Chapter',ar:'الباب'},
    p3Sectors:{en:'Sectors',ar:'القطاعات'},
    p3Departments:{en:'Departments',ar:'الإدارات'},
    p3CostCentres:{en:'Cost centres',ar:'مراكز التكلفة'},
    p3Start:{en:'Start date',ar:'تاريخ البدء'},
    p3Finish:{en:'Finish date',ar:'تاريخ الانتهاء'},
    p3Tasks:{en:'Tasks',ar:'المهام'},
    p3LastActivity:{en:'Last activity',ar:'آخر حركة'},
    p3WhyFlagged:{en:'Why this score',ar:'سبب هذه الدرجة'},
    p3CompBurn:{en:'Burn discipline',ar:'انضباط الإنفاق'},
    p3CompFunds:{en:'Fund headroom',ar:'مساحة التمويل'},
    p3CompApproval:{en:'Approval friction',ar:'احتكاك الاعتماد'},
    p3CompActivity:{en:'Activity',ar:'النشاط'},
    p3NotScored:{en:'not scored',ar:'غير مُقيَّم'},
    p3fBudget:{en:'Budget',ar:'الموازنة'},
    p3fPr:{en:'Requisitioned',ar:'مطلوب'},
    p3fPo:{en:'Ordered',ar:'مُطلَب'},
    p3fGrn:{en:'Received',ar:'مستلم'},
    p3fAp:{en:'Invoiced',ar:'مفوتر'},
    p3fPaid:{en:'Paid',ar:'مسدد'},
    p3fHint:{en:'Each stage is drawn to scale against the largest. Click a stage to list the documents behind it.',ar:'كل مرحلة مرسومة بمقياس مقارنة بالأكبر. اضغط أي مرحلة لعرض مستنداتها.'},
    p3ColTask:{en:'Task',ar:'المهمة'},
    p3ColTaskName:{en:'Task name',ar:'اسم المهمة'},
    p3ColOrg:{en:'Organization',ar:'الجهة'},
    p3ColPlanStart:{en:'Planned start',ar:'البدء المخطط'},
    p3ColPlanFinish:{en:'Planned finish',ar:'الانتهاء المخطط'},
    p3SchedPast:{en:'Past plan',ar:'تجاوز الخطة'},
    p3SchedOn:{en:'Within plan',ar:'ضمن الخطة'},
    p3SchedNone:{en:'No dates',ar:'بلا تواريخ'},
    p3SchedNote:{en:'Planned dates only. Task actual start and finish dates are empty in the source, so schedule progress and slippage cannot be shown and are not scored.',ar:'تواريخ مخططة فقط. تواريخ المهام الفعلية غير متوفرة في المصدر، لذا لا يمكن عرض التقدم أو التأخير ولا يتم تقييمهما.'},
    p3PipeOpenPr:{en:'Open commitments (PR)',ar:'ارتباطات مفتوحة (طلبات شراء)'},
    p3PipeOpenPo:{en:'Open obligations (PO)',ar:'تعهدات مفتوحة (أوامر شراء)'},
    p3PipeGrn:{en:'Received not invoiced',ar:'مستلم غير مفوتر'},
    p3PipePending:{en:'Pending approval',ar:'بانتظار الاعتماد'},
    p3GapBadge:{en:'DATA GAP',ar:'فجوة بيانات'},
    p3GapTitle:{en:'Collections cannot be shown',ar:'لا يمكن عرض التحصيلات'},
    p3GapBody:{en:'Only billed (invoiced) revenue is available. No AR receipts extract exists on the platform, so cash collected, outstanding receivable and DSO are deliberately not shown rather than estimated.',ar:'المتاح هو الإيراد المفوتر فقط. لا يوجد استخراج لإيصالات المدينين على المنصة، لذا لا تُعرض المبالغ المحصلة ولا الرصيد المستحق ولا متوسط فترة التحصيل — عمداً بدلاً من تقديرها.'},
    p3NoRev:{en:'No billed revenue recorded against this project in the selected year.',ar:'لا يوجد إيراد مفوتر مسجل على هذا المشروع في السنة المحددة.'},
    p3NoTrx:{en:'No budget transactions touch this project in the selected year.',ar:'لا توجد معاملات موازنة تخص هذا المشروع في السنة المحددة.'},
    p3NoCash:{en:'No cashflow plan has been uploaded for this project and year. Upload one on the Cashflow tab — the Fusion budget is not cashflow phased, so it cannot substitute.',ar:'لم تُحمّل خطة تدفق نقدي لهذا المشروع وهذه السنة. حمّلها من تبويب التدفق النقدي — موازنة فيوجن غير موزعة زمنياً فلا تصلح بديلاً.'},
    p3NoTasks:{en:'This project has no budget lines in the selected year.',ar:'لا توجد بنود موازنة لهذا المشروع في السنة المحددة.'},
    p3NoPipe:{en:'Nothing open in this stage.',ar:'لا يوجد مفتوح في هذه المرحلة.'},
    p3Unbudgeted:{en:'This project consumed {a} AED against combinations with no budget line.',ar:'استهلك هذا المشروع {a} درهم على تركيبات بلا بند موازنة.'},
    p3NoBudget:{en:'This project has NO budget line in the selected year. Its spend is shown but is excluded from the portfolio reconciling totals.',ar:'لا يوجد بند موازنة لهذا المشروع في السنة المحددة. يُعرض إنفاقه لكنه مستثنى من إجماليات المحفظة المطابِقة.'},
    p3PickFirst:{en:'Select a project from the portfolio first.',ar:'اختر مشروعاً من المحفظة أولاً.'},

    navEncumbrances:{en:'Projects Encumbrances',ar:'ارتباطات المشاريع'},
    enTitle:{en:'Open Projects Encumbrance Follow-up',ar:'متابعة ارتباطات المشاريع المفتوحة'},
    enSub:{en:'Every open encumbrance line (Open Commitment PR + Open Obligation PO) with the full GL combination — all ten segments, code and name — for the selected Budget Utilization scope.',ar:'كل بند ارتباط مفتوح (التزام طلب شراء مفتوح + تعهد أمر شراء مفتوح) مع التركيبة المحاسبية الكاملة — جميع البنود العشرة رمزًا واسمًا — ضمن نطاق استخدام الموازنة المحدد.'},
    enOpenLabel:{en:'Open / Reserved (AED)',ar:'المفتوح / المحجوز (درهم)'},
    enLinesLabel:{en:'encumbrance lines',ar:'بنود الارتباط'},
    enTruncNote:{en:'Showing the top 10,000 lines by open amount.',ar:'يتم عرض أعلى 10٬000 بند حسب المبلغ المفتوح.'},
    acLinesLabel:{en:'GL combinations',ar:'تركيبة محاسبية'},
    acTruncNote:{en:'Showing the first 10,000 rows — narrow the criteria for the full set.',ar:'يتم عرض أول 10٬000 صف — ضيّق المعايير لعرض المجموعة كاملة.'},
    acPrCount:{en:'PR count',ar:'عدد طلبات الشراء'},
    acPoCount:{en:'PO count',ar:'عدد أوامر الشراء'},
    drillSorted:{en:'↓ Sorted by {c} — highest first',ar:'↓ مرتب حسب {c} — الأعلى أولاً'},
    enLoadingNote:{en:'Loading encumbrance lines…',ar:'جارٍ تحميل بنود الارتباط…'},
    enIrErr:{en:'The interactive report component could not be loaded. Please refresh the page; if the problem persists, contact the administrator.',ar:'تعذّر تحميل مكوّن التقرير التفاعلي. يرجى تحديث الصفحة؛ وإذا استمرت المشكلة، تواصل مع المسؤول.'},

    /* ── Encumbrances – Pending Approval (PR/PO documents awaiting approval) ── */
    navPending:{en:'Encumbrances – Pending Approval',ar:'الارتباطات – قيد الاعتماد'},
    navRecon:{en:'Reconciliation',ar:'المطابقة'},
    /* ── Reconciliation (Actuals ↔ Budget Utilization) ── */
    rcTitle:{en:'Actuals ↔ Budget Utilization reconciliation',ar:'مطابقة الفعلي مع استخدام الموازنة'},
    rcSub:{en:'Data-integrity check between the two dashboards. Consumption (AP / GRN / PR / PO) is the SAME source both sides, so it reconciles exactly — any difference is one of the named buckets below. Budget lives in two different ledgers (GL vs Project), shown side by side.',ar:'فحص سلامة البيانات بين اللوحتين. الاستهلاك (فواتير / استلام / طلب / أمر شراء) مصدره واحد على الجانبين فيتطابق تمامًا — وأي فرق يعود لأحد البنود المسمّاة أدناه. الموازنة في سجلّين مختلفين (العام مقابل المشاريع) وتُعرض جنبًا إلى جنب.'},
    rcM_ap:{en:'AP Direct (actual)',ar:'الصرف المباشر (فعلي)'}, rcM_grn:{en:'GRN (actual)',ar:'الاستلام (فعلي)'},
    rcM_pr:{en:'Open Commitment (PR)',ar:'الالتزام المفتوح (طلب شراء)'}, rcM_po:{en:'Open Obligation (PO)',ar:'الارتباط المفتوح (أمر شراء)'},
    rcSeg_matched:{en:'Matched (in both)',ar:'مطابق (في كليهما)'},
    rcSeg_noProject:{en:'No project/task/etype (Actuals only)',ar:'بلا مشروع/مهمة/نوع (الفعلي فقط)'},
    rcSeg_apValidation:{en:'Not validated (AP)',ar:'غير مُعتمدة (فواتير)'},
    rcSeg_noBudgetLine:{en:'On un-budgeted line (orphan)',ar:'على بند بلا موازنة (يتيم)'},
    rcSeg_all:{en:'All records',ar:'كل السجلات'},
    rcGr_account:{en:'GL Account',ar:'الحساب'}, rcGr_sector:{en:'Sector',ar:'القطاع'}, rcGr_chapter:{en:'Chapter',ar:'الباب'},
    rcGr_costcenter:{en:'Cost Centre',ar:'مركز التكلفة'}, rcGr_appropriation:{en:'Appropriation',ar:'الاعتماد'},
    rcGr_program:{en:'DCT Program',ar:'برنامج الدائرة'}, rcGr_combination:{en:'GL Combination',ar:'التركيبة المحاسبية'},
    rcGr_budgetline:{en:'Project budget line',ar:'بند موازنة المشروع'},
    rcAllScope:{en:'All records in scope',ar:'كل السجلات في النطاق'},
    rcAllMeasures:{en:'All measures · AP + GRN + PR + PO',ar:'كل المقاييس · موردون + استلام + طلبات + أوامر'},
    rcGlLedger:{en:'GL ledger · GL_BALANCES (Expense, scoped chapters)',ar:'دفتر الأستاذ العام · الأرصدة (المصروفات، الأبواب المحددة)'},
    rcPpmLedger:{en:'Project ledger · PROJECTS_BUDGET (PPM)',ar:'دفتر المشاريع · موازنة المشاريع'},
    rcDrillMatched:{en:'Matched consumption (in both dashboards)',ar:'الاستهلاك المتطابق (في اللوحتين)'},
    rcDrillGlBudget:{en:'GL budget lines',ar:'بنود الموازنة العامة'},
    rcDrillPpmBudget:{en:'Project budget lines',ar:'بنود موازنة المشاريع'},
    rcDrillGlFund:{en:'Fund available — GL budget',ar:'المتاح — الموازنة العامة'},
    rcDrillPpmFund:{en:'Fund available — Project budget',ar:'المتاح — موازنة المشاريع'},
    rcDrillHint:{en:'Click to see the source detail',ar:'انقر لعرض التفاصيل المصدر'},
    rcSecFilters:{en:'Search criteria',ar:'معايير البحث'}, rcSecStatus:{en:'Reconciliation status',ar:'حالة المطابقة'},
    rcSecRegister:{en:'Reconciliation register',ar:'سجل المطابقة'},
    rcBudgetChapters:{en:'GL budget chapters (Expense)',ar:'أبواب الموازنة العامة (المصروفات)'},
    rcGlBudget:{en:'GL budget',ar:'الموازنة العامة'}, rcPpmBudget:{en:'Project budget',ar:'موازنة المشاريع'},
    rcBudgetNote:{en:'Two different Fusion ledgers — compared by dimension, never line to line.',ar:'سجلّان مختلفان في فيوجن — تُقارَن بالبُعد وليس بندًا ببند.'},
    rcNonProject:{en:'Non-project (Actuals only)',ar:'بلا مشروع (الفعلي فقط)'},
    rcNonProjectSub:{en:'Combinations with spend but no project/task/etype — cannot appear in Budget Utilization',ar:'تركيبات بها صرف بلا مشروع/مهمة/نوع — لا يمكن أن تظهر في استخدام الموازنة'},
    rcOrphan:{en:'Orphan consumption',ar:'استهلاك يتيم'},
    rcOrphanSub:{en:'Spend on a project line that carries no budget — the actionable integrity flag',ar:'صرف على بند مشروع بلا موازنة — مؤشر السلامة القابل للمعالجة'},
    rcCoverage:{en:'Coverage',ar:'التغطية'}, rcActualsSide:{en:'Actuals side',ar:'جانب الفعلي'}, rcButilSide:{en:'Budget Util. side',ar:'جانب استخدام الموازنة'},
    rcDifference:{en:'Difference',ar:'الفرق'}, rcConsActuals:{en:'Total consumption (Actuals)',ar:'إجمالي الاستهلاك (الفعلي)'},
    rcConsButil:{en:'Total consumption (Budget Util.)',ar:'إجمالي الاستهلاك (استخدام الموازنة)'},
    rcFundActuals:{en:'Fund available (GL budget)',ar:'المتاح (الموازنة العامة)'}, rcFundButil:{en:'Fund available (Project budget)',ar:'المتاح (موازنة المشاريع)'},
    rcCompTitle:{en:'Where the difference goes',ar:'أين يذهب الفرق'}, rcMeasTitle:{en:'Actuals vs Budget Utilization by measure',ar:'الفعلي مقابل استخدام الموازنة حسب المقياس'},
    rcGrainLabel:{en:'Group by',ar:'التجميع حسب'}, rcMeasureLabel:{en:'Measure',ar:'المقياس'},
    rcColDim:{en:'Dimension',ar:'البُعد'}, rcClickDrill:{en:'Click a difference to see the source records',ar:'انقر على أي فرق لعرض السجلات المصدر'},
    rcGlAccountL:{en:'GL Account',ar:'الحساب'}, rcMatched:{en:'Reconciles exactly',ar:'يتطابق تمامًا'},
    rcExplained:{en:'Explained by leakage buckets',ar:'مُفسَّر ببنود التسرب'},
    // ── hint (ⓘ) text — short, plain-language explainers for each region / KPI / column ──
    hRcSecFilters:{en:'Choose the scope to reconcile. Budget Year is required; every other filter is optional and narrows both sides equally. Set the same Accounting Period on both dashboards so they cover identical months.',ar:'حدّد نطاق المطابقة. السنة المالية إلزامية؛ باقي المرشّحات اختيارية وتضيّق الجانبين معًا. اضبط نفس الفترة المحاسبية على الجانبين لتغطية الأشهر نفسها.'},
    hRcSecStatus:{en:'The health summary. Green means the two dashboards agree; the tiles below quantify exactly where and why they differ.',ar:'ملخّص الحالة. الأخضر يعني توافق اللوحتين؛ والبطاقات أدناه تحدّد أين ولماذا يختلفان بالضبط.'},
    hRcSecRegister:{en:'The line-by-line proof. Each row shows Actuals vs Budget Utilization for one dimension value; click any Difference figure to open the exact source documents behind it.',ar:'الإثبات التفصيلي. كل صف يعرض الفعلي مقابل استخدام الموازنة لقيمة بُعد واحدة؛ انقر أي قيمة فرق لفتح المستندات المصدر خلفها.'},
    hRcCoverage:{en:'Share of General-Ledger consumption that is also captured inside Project Budget Utilization. 100% = perfectly reconciled. The rest is explained by the buckets on the right.',ar:'نسبة الاستهلاك في دفتر الأستاذ العام المُدرَجة أيضًا داخل استخدام موازنة المشاريع. 100٪ = مطابقة تامة. والباقي مُفسَّر بالبنود على اليمين.'},
    hRcNonProject:{en:'Spend on GL combinations that carry no project / task / expenditure-type. It is real consumption but can never appear in Project Budget Utilization — so it is a legitimate part of the gap.',ar:'صرف على تركيبات محاسبية بلا مشروع/مهمة/نوع إنفاق. استهلاك حقيقي لكنه لا يظهر أبدًا في استخدام موازنة المشاريع — فهو جزء مشروع من الفجوة.'},
    hRcOrphan:{en:'Spend charged to a project line that has NO budget allocated. This is the actionable data-integrity flag — money went out where nothing was budgeted. Chase these with Finance.',ar:'صرف مُحمّل على بند مشروع بلا موازنة مخصّصة. هذا مؤشر سلامة البيانات القابل للمعالجة — صُرفت أموال حيث لا موازنة. تابعها مع المالية.'},
    hRcBudget:{en:'Two independent Fusion budget ledgers side by side: GL budget (Expense, selected chapters) vs Project budget (PPM). They share no key, so compare them by dimension — never line to line.',ar:'سجلّا موازنة مستقلان في فيوجن جنبًا إلى جنب: الموازنة العامة (المصروفات، الأبواب المحددة) مقابل موازنة المشاريع. لا مفتاح مشترك بينهما، فقارنهما بالبُعد وليس بندًا ببند.'},
    hRcFund:{en:'Budget still available on each side = its budget minus its consumption. A large split between the two sides usually points to the same leakage buckets shown above.',ar:'الموازنة المتاحة على كل جانب = موازنته ناقص استهلاكه. الفارق الكبير بين الجانبين يشير عادةً إلى بنود التسرب نفسها الموضّحة أعلاه.'},
    hRcComp:{en:'How the total General-Ledger consumption splits: the matched part (inside Budget Utilization) plus each leakage bucket. The slices always add up to 100%.',ar:'كيف يتوزّع إجمالي الاستهلاك في دفتر الأستاذ العام: الجزء المتطابق (داخل استخدام الموازنة) زائد كل بند تسرب. تُجمِع الشرائح دائمًا 100٪.'},
    hRcMeas:{en:'Reconciliation per spend stream — AP invoices, GRN receipts, PR commitments, PO obligations. GRN and PO match to the riyal; AP and PR differ only by the named buckets.',ar:'المطابقة لكل مجرى صرف — فواتير الموردين، إيصالات الاستلام، ارتباطات طلبات الشراء، التزامات أوامر الشراء. الاستلام وأمر الشراء يتطابقان للريال؛ ويختلف الموردون والطلبات ببنود مُسمّاة فقط.'},
    hRcColActuals:{en:'Total consumption as counted by the General Ledger dashboard (all spend, project or not).',ar:'إجمالي الاستهلاك كما تحسبه لوحة دفتر الأستاذ العام (كل الصرف، بمشروع أو بدونه).'},
    hRcColButil:{en:'The same consumption as captured by Project Budget Utilization (project-tagged, valid, on a budget line).',ar:'الاستهلاك نفسه كما يظهر في استخدام موازنة المشاريع (مرتبط بمشروع، صالح، على بند موازنة).'},
    hRcColDiff:{en:'Actuals minus Budget Utilization. Click it to see the exact source records. It equals the sum of the bucket columns to its right.',ar:'الفعلي ناقص استخدام الموازنة. انقره لعرض السجلات المصدر. يساوي مجموع أعمدة البنود على يمينه.'},
    hRcColNoProject:{en:'Portion of the difference that is spend with no project / task / expenditure-type.',ar:'الجزء من الفرق الذي هو صرف بلا مشروع/مهمة/نوع إنفاق.'},
    hRcColApVal:{en:'AP-only: invoices excluded from Budget Utilization because their validation status is not Validated / Unpaid / Available.',ar:'للموردين فقط: فواتير مُستبعَدة من استخدام الموازنة لأن حالة تدقيقها ليست مُدقّقة/غير مدفوعة/متاحة.'},
    hRcColNoBudget:{en:'Portion of the difference that is spend on a project line with no budget allocated (orphan consumption).',ar:'الجزء من الفرق الذي هو صرف على بند مشروع بلا موازنة مخصّصة (استهلاك يتيم).'},
    pnTitle:{en:'Encumbrances – Pending Approval Follow-up',ar:'متابعة الارتباطات قيد الاعتماد'},
    pnSub:{en:'Every PR / PO document awaiting approval in Fusion, with its budget lines, full GL combination and approval trail (preparer, submitted date, pending approver, days pending) — for the selected Budget Utilization scope. Zero-value lines are excluded: only lines that will reserve funds are followed.',ar:'كل مستند طلب شراء / أمر شراء بانتظار الاعتماد في فيوجن، مع بنود موازنته والتركيبة المحاسبية الكاملة ومسار الاعتماد (المُعدّ، تاريخ التقديم، المعتمد الحالي، أيام الانتظار) — ضمن نطاق استخدام الموازنة المحدد. تُستبعد البنود ذات القيمة الصفرية: تتم متابعة البنود التي ستحجز أموالاً فقط.'},
    pnAsOf:{en:'Snapshot',ar:'اللقطة'},
    pnLinesLabel:{en:'pending lines',ar:'بند قيد الاعتماد'},
    pnAmtLabel:{en:'Pending amount (AED)',ar:'المبلغ قيد الاعتماد (درهم)'},
    pnTruncNote:{en:'Showing the top 10,000 lines (oldest first).',ar:'يتم عرض أول 10٬000 بند (الأقدم أولًا).'},
    pnLoadingNote:{en:'Loading pending approval lines…',ar:'جارٍ تحميل بنود قيد الاعتماد…'},
    pnDocsK:{en:'Pending documents',ar:'المستندات قيد الاعتماد'},
    pnAmtK:{en:'Pending amount',ar:'المبلغ قيد الاعتماد'},
    pnResK:{en:'Funds reserved',ar:'الأموال المحجوزة'},
    pnAgingK:{en:'Approval aging',ar:'تقادم الاعتماد'},
    pnPrRow:{en:'Requisitions (PR)',ar:'طلبات الشراء (PR)'},
    pnPoRow:{en:'Purchase orders (PO)',ar:'أوامر الشراء (PO)'},
    pnReserved:{en:'Reserved (in encumbrance)',ar:'محجوز (ضمن الارتباطات)'},
    pnUnreserved:{en:'Not reserved (pipeline)',ar:'غير محجوز (قيد الانتظار)'},
    pnResSub:{en:'already counted in open encumbrance',ar:'محتسب ضمن الارتباطات المفتوحة'},
    pnAvgDays:{en:'avg days pending',ar:'متوسط أيام الانتظار'},
    pnOldest:{en:'Oldest',ar:'الأقدم'},
    pnDaysUnit:{en:'days',ar:'يومًا'},
    pnDocsUnit:{en:'docs',ar:'مستند'},
    pnOver30:{en:'Over 30 days',ar:'أكثر من 30 يومًا'},
    pnWithin30:{en:'30 days or less',ar:'30 يومًا أو أقل'},
    pnAgingT:{en:'Aging analysis — days pending approval',ar:'تحليل التقادم — أيام انتظار الاعتماد'},
    pnApproversT:{en:'Top pending approvers — follow-up focus',ar:'أبرز المعتمدين المعلّق لديهم — تركيز المتابعة'},
    pnBucket:{en:'Days',ar:'الأيام'},
    pnColDocs:{en:'Documents',ar:'المستندات'},
    pnColAmt:{en:'Amount (AED)',ar:'المبلغ (درهم)'},
    pnColMaxD:{en:'Max days',ar:'أقصى أيام'},
    pnApprover:{en:'Pending with',ar:'معلّق لدى'},
    pnUnmatchedNote:{en:'{n} pending documents ({pr} PR / {po} PO) are not yet matched to the budget extract — they are listed in the Briefing Book annex.',ar:'{n} مستندًا قيد الاعتماد ({pr} طلب شراء / {po} أمر شراء) لم تُطابَق بعد مع مستخرج الموازنة — ترد قائمتها في ملحق كتيب الإحاطة.'},
    pnBookHint:{en:'Generate the Encumbrances Pending Approval Briefing Book PDF using ALL the current page filters — pending PR/PO registers, aging analysis, approver follow-up list and budget-impact insights (funds-reserved, non-zero lines only). Prepared by the reporting workers — takes about a minute.',ar:'إنشاء كتيب إحاطة الارتباطات قيد الاعتماد (PDF) وفق جميع عوامل تصفية الصفحة الحالية — سجلات طلبات وأوامر الشراء المعلقة وتحليل التقادم وقائمة متابعة المعتمدين وأثر الموازنة (البنود المحجوزة غير الصفرية فقط). يُجهَّز عبر خوادم التقارير — يستغرق نحو دقيقة.'},
    pnSourceL:{en:'Source',ar:'المصدر'},
    pnAllSources:{en:'All (PR + PO)',ar:'الكل (طلبات وأوامر الشراء)'},
    pnBuL:{en:'Business unit',ar:'وحدة الأعمال'},
    pnAllBus:{en:'All business units',ar:'كل وحدات الأعمال'},
    pnXlsx:{en:'Export Excel',ar:'تصدير إكسل'},
    pnXlsxRunning:{en:'Preparing Excel…',ar:'جارٍ إعداد الملف…'},
    pnXlsxHint:{en:'Generate the Pending PR & PO Register (Excel, for internal analysis) using ALL the current page filters: one flat sheet of every funds-reserved pending line with the full approval trail, budget line and GL classification (Sector, Cost centre, Account, Appropriation, Program — code and name), plus the extract-coverage annex sheet. Prepared by the reporting workers — takes under a minute.',ar:'إنشاء سجل طلبات وأوامر الشراء المعلقة (إكسل للتحليل الداخلي) وفق جميع عوامل تصفية الصفحة الحالية: ورقة واحدة لكل بند محجوز معلق مع مسار الاعتماد الكامل وبند الموازنة والتصنيف المحاسبي، إضافةً إلى ورقة ملحق التغطية. يُجهَّز عبر خوادم التقارير — يستغرق أقل من دقيقة.'},
    pnXlsxReady:{en:'Excel register downloaded.',ar:'تم تنزيل سجل الإكسل.'},
    buFbpReady:{en:'FBP - Projects Budget Utilization downloaded.',ar:'تم تنزيل تقرير FBP - استغلال ميزانية المشاريع.'},
    buMssReady:{en:'MSS - Projects Budget Utilization downloaded.',ar:'تم تنزيل تقرير MSS - استغلال ميزانية المشاريع.'},
    buMssHint:{en:'Generate the MSS - Projects Budget Utilization workbook (Excel) using ALL the current page filters — the Budget Utilization Register re-issued for the MSS distribution: sheet 1 carries the FIXED 26-column MSS layout (Task Number kept + Task Name added; no appropriation/program, YTD-budget or plan columns), a Requester column on every detail sheet (AP = the matched PO line’s requester, GRN/PO = the PO requestor, PR = the requisition requester, Pending = per document) and a Task Name column beside every Task Number on ALL sheets. The Manage Columns view does not affect it. Prepared by the reporting workers — takes about a minute.',ar:'إنشاء تقرير MSS - استغلال ميزانية المشاريع (إكسل) وفق جميع عوامل تصفية الصفحة الحالية — سجل استخدام الموازنة بنسخة توزيع MSS: الورقة الأولى بتخطيط ثابت من 26 عموداً (رقم المهمة واسمها معاً، دون أعمدة الاعتماد والبرنامج والخطة)، وعمود مقدم الطلب في كل ورقة تفاصيل (الفواتير من أمر الشراء المطابق، والاستلام وأوامر الشراء من طالب أمر الشراء، والطلبات من طالب طلب الشراء)، وعمود اسم المهمة بجانب رقم المهمة في جميع الأوراق. لا يتأثر بإدارة الأعمدة. يُجهَّز عبر خوادم التقارير — يستغرق نحو دقيقة.'},
    buFbpHint:{en:'Generate the FBP - Projects Budget Utilization workbook (Excel) using ALL the current page filters — the Budget Utilization Register re-issued for the FBP distribution: sheet 1 carries the FIXED 21-column FBP layout (Task Name in place of Task Number; no EBS/plan/vs-Budget/fund-movement columns) and every supporting detail list keeps its own worksheet. The Manage Columns view does not affect it. Prepared by the reporting workers — takes about a minute.',ar:'إنشاء تقرير FBP - استغلال ميزانية المشاريع (إكسل) وفق جميع عوامل تصفية الصفحة الحالية — سجل استخدام الموازنة بنسخة توزيع FBP: الورقة الأولى بتخطيط ثابت من 21 عموداً (اسم المهمة بدل رقم المهمة، دون أعمدة EBS أو الخطة أو مقابل الموازنة أو حركة الأموال) مع بقاء كل قائمة تفاصيل في ورقتها. لا يتأثر بإدارة الأعمدة. يُجهَّز عبر خوادم التقارير — يستغرق نحو دقيقة.'},
    buXlsxHint:{en:'Generate the Budget Utilization Register (Excel, for internal analysis) using ALL the current page filters: the utilization lines plus every supporting detail list in its own worksheet — direct AP invoices, GRN receipts, open purchase orders, open requisitions and the pending-approval PR/PO queue. Prepared by the reporting workers — takes about a minute.',ar:'إنشاء سجل استخدام الموازنة (إكسل للتحليل الداخلي) وفق جميع عوامل تصفية الصفحة الحالية: بنود الاستخدام مع كل قائمة تفاصيل داعمة في ورقة مستقلة — فواتير الدائنين المباشرة وإيصالات الاستلام وأوامر الشراء المفتوحة وطلبات الشراء المفتوحة وقائمة الانتظار قيد الاعتماد. يُجهَّز عبر خوادم التقارير — يستغرق نحو دقيقة.'},
    pnDrillHint:{en:'Click to see the matching pending lines.',ar:'انقر لعرض البنود المعلقة المطابقة.'},
    buTitle:{en:'Project Budget Utilization',ar:'استخدام موازنة المشاريع'},
    buSub:{en:'Project budget vs AP, GRN, open commitments and obligations — per task and expenditure type.',ar:'موازنة المشاريع مقابل الدائنين والاستلام والالتزامات والتعهدات المفتوحة — لكل مهمة ونوع إنفاق.'},
    fYearL:{en:'Budget year',ar:'سنة الموازنة'}, fTypeL:{en:'Project type',ar:'نوع المشروع'},
    allTypes:{en:'All types',ar:'كل الأنواع'},
    searchButil:{en:'Project, task, department…',ar:'المشروع، المهمة، الإدارة…'},
    lovHint:{en:'All — type to search…',ar:'الكل — اكتب للبحث…'},
    yearRequired:{en:'Please choose a budget year.',ar:'الرجاء اختيار سنة الموازنة.'},
    buBook:{en:'Briefing Book',ar:'كتيب الإحاطة'},
    buBookRunning:{en:'Preparing book…',ar:'جارٍ إعداد الكتيب…'},
    buBookHint:{en:'Generate the Budget Utilization Briefing Book PDF using ALL the current page filters (Year, Period, Type, Sector, Chapter, Cost center, Project, Task, Expenditure type, Search) — the book scope matches this page. Prepared by the reporting workers — takes about a minute.',ar:'إنشاء كتيب الإحاطة لاستخدام الموازنة (PDF) وفق جميع عوامل تصفية الصفحة الحالية — نطاق الكتيب يطابق الصفحة. يُجهَّز عبر خوادم التقارير — يستغرق نحو دقيقة.'},
    buBookQueued:{en:'Briefing book queued — run #',ar:'تم إرسال كتيب الإحاطة — تشغيل رقم '},
    buBookReady:{en:'Briefing book downloaded.',ar:'تم تنزيل كتيب الإحاطة.'},
    buBookFailed:{en:'Briefing book failed: ',ar:'فشل إنشاء كتيب الإحاطة: '},
    buBookTimeout:{en:'Still running — check again shortly (run #',ar:'لا يزال قيد التشغيل — تحقق بعد قليل (تشغيل رقم '},
    buSpbQueued:{en:'Sector Performance Report queued — run #',ar:'تم إرسال تقرير أداء القطاعات — تشغيل رقم '},
    buSpbReady:{en:'Sector Performance Report downloaded.',ar:'تم تنزيل تقرير أداء القطاعات.'},
    buSpbFailed:{en:'Sector Performance Report failed: ',ar:'فشل إنشاء تقرير أداء القطاعات: '},
    buSpbHint:{en:'Generate the Sector Performance Report PDF for the selected sector — the Briefing Book pack re-covered for distribution (DCT logo and copyright line on every page, simplified cover) using ALL the current page filters. Covers the Opex + Capex chapters by default — pick Chapters in Search to include others (e.g. Payroll). Prepared by the reporting workers — takes about a minute.',ar:'إنشاء تقرير أداء القطاعات (PDF) للقطاع المحدد — كتيب الإحاطة بغلاف مبسّط مع شعار الدائرة وسطر حقوق النشر على كل صفحة، وفق جميع عوامل تصفية الصفحة الحالية. يغطي فصلي التشغيل والرأسمالية افتراضياً — اختر الفصول في البحث لإدراج غيرها. يُجهَّز عبر خوادم التقارير — يستغرق نحو دقيقة.'},
    buSpbNeedSector:{en:'Select a sector in Search first — the Sector Performance Report runs for one sector.',ar:'اختر قطاعاً في البحث أولاً — تقرير أداء القطاعات يصدر لقطاع واحد.'},
    genReport:{en:'Generate Report ▾',ar:'إنشاء تقرير ▾'},
    genRunning:{en:'Generating…',ar:'جارٍ الإنشاء…'},
    repBook:{en:'Briefing Book (PDF)',ar:'كتيب الإحاطة (PDF)'},
    repBookSub:{en:'Executive briefing document',ar:'وثيقة إحاطة تنفيذية'},
    repSpb:{en:'Sector Performance Report (PDF)',ar:'تقرير أداء القطاعات (PDF)'},
    repSpbSub:{en:'Distribution copy with DCT branding',ar:'نسخة للتوزيع بشعار الدائرة'},
    repXlsx:{en:'Excel Register (XLSX)',ar:'سجل إكسل (XLSX)'},
    repXlsxSub:{en:'Full detail lists for analysis',ar:'قوائم تفصيلية كاملة للتحليل'},
    repFbp:{en:'FBP - Projects Budget Utilization (XLSX)',ar:'FBP - استغلال ميزانية المشاريع (XLSX)'},
    repFbpSub:{en:'Fixed FBP layout — Task Name on sheet 1',ar:'تخطيط FBP ثابت — اسم المهمة في الورقة الأولى'},
    repMss:{en:'MSS - Projects Budget Utilization (XLSX)',ar:'MSS - استغلال ميزانية المشاريع (XLSX)'},
    repMssSub:{en:'Fixed MSS layout — Requester on detail sheets',ar:'تخطيط MSS ثابت — مقدم الطلب في أوراق التفاصيل'},
    repPpt:{en:'PowerPoint (PPTX)',ar:'باوربوينت (PPTX)'},
    repPptSub:{en:'Executive slide deck',ar:'عرض شرائح تنفيذي'},
    buPptHint:{en:'Generate an executive PowerPoint deck using ALL the current page filters — cover, KPI overview, utilization by sector, budget composition, lines under pressure, actuals and supplier concentration, open obligations & commitments, and management insights. Native, editable slides. Prepared by the reporting workers — takes about a minute.',ar:'إنشاء عرض شرائح تنفيذي (باوربوينت) وفق جميع عوامل تصفية الصفحة الحالية — غلاف ومؤشرات أداء واستخدام حسب القطاع وتكوين الموازنة والبنود تحت الضغط والفعلي وتركّز الموردين والالتزامات والتعهدات المفتوحة ورؤى الإدارة. شرائح أصلية قابلة للتحرير. يُجهَّز عبر خوادم التقارير — يستغرق نحو دقيقة.'},
    pnPptReady:{en:'PowerPoint deck downloaded.',ar:'تم تنزيل عرض الشرائح.'},
    pnPptHint:{en:'Generate an executive PowerPoint deck of the pending approvals using ALL the current page filters — cover, pending-approval overview, aging analysis, pending value by sector, approver follow-up, longest-waiting documents and management insights (funds-reserved, non-zero lines only). Native, editable slides. Prepared by the reporting workers — takes about a minute.',ar:'إنشاء عرض شرائح تنفيذي (باوربوينت) للاعتمادات المعلقة وفق جميع عوامل تصفية الصفحة الحالية — غلاف ونظرة عامة على الاعتمادات المعلقة وتحليل التقادم والقيمة المعلقة حسب القطاع ومتابعة المعتمدين وأقدم المستندات ورؤى الإدارة (البنود المحجوزة غير الصفرية فقط). شرائح أصلية قابلة للتحرير. يُجهَّز عبر خوادم التقارير — يستغرق نحو دقيقة.'},
    noButil:{en:'No budget lines match these criteria.',ar:'لا توجد بنود موازنة مطابقة.'},
    cProjType:{en:'Type',ar:'النوع'}, cDept:{en:'Department',ar:'الإدارة'},
    cOrg:{en:'Organization',ar:'المنظمة'},
    cProject:{en:'Project',ar:'المشروع'}, cTask:{en:'Task',ar:'المهمة'},
    cGlAccount:{en:'GL Account',ar:'حساب الأستاذ'}, cChapter:{en:'Chapter',ar:'الباب'},
    cEtype:{en:'Expenditure type',ar:'نوع الإنفاق'},
    cActualAp:{en:'Actual AP',ar:'فعلي الدائنين'}, cActualGrn:{en:'Actual GRN',ar:'فعلي الاستلام'},
    cCommitPr:{en:'Commitment (PR)',ar:'الالتزام (طلب شراء)'}, cObligPo:{en:'Obligation (PO)',ar:'التعهد (أمر شراء)'},
    cFundAvail:{en:'Fund available',ar:'المتاح'},
    buDrillAp:{en:'Actual AP — invoices',ar:'فعلي الدائنين — الفواتير'},
    buDrillGrn:{en:'Actual GRN — receipts',ar:'فعلي الاستلام — الإيصالات'},
    buDrillBudget:{en:'YTD Budget — accounting periods',ar:'الموازنة منذ بداية السنة — الفترات المحاسبية'},
    buDrillBudgetannual:{en:'Annual Budget — accounting periods',ar:'الموازنة السنوية — الفترات المحاسبية'},
    cBudgetAnnual:{en:'Annual Budget',ar:'الموازنة السنوية'},
    cBudgetYtd:{en:'YTD Budget',ar:'الموازنة منذ بداية السنة'},
    buDrillPr:{en:'Commitment (PR) — lines',ar:'الالتزام (طلب شراء) — البنود'},
    buDrillPo:{en:'Obligation (PO) — lines',ar:'التعهد (أمر شراء) — البنود'},
    cPlanApprA:{en:'Plan Annual',ar:'الخطة السنوية'},
    cPlanApprY:{en:'Plan YTD',ar:'الخطة منذ بداية السنة'},
    cPlanRevA:{en:'Revised Plan Annual',ar:'الخطة المعدلة السنوية'},
    cPlanRevY:{en:'Revised Plan YTD',ar:'الخطة المعدلة منذ بداية السنة'},
    cPlanTile:{en:'Expenditure Plan',ar:'خطة الإنفاق'},
    planApproved:{en:'Approved',ar:'المعتمدة'},
    planRevised:{en:'Revised',ar:'المعدلة'},
    planOfAnnual:{en:'of annual plan',ar:'من الخطة السنوية'},
    buPlanHint:{en:'Uploaded expenditure plan (GL Cashflow tab). YTD = plan months up to the selected accounting period; full year = the whole plan. Click a figure to see its monthly plan rows.',ar:'خطة الإنفاق المرفوعة (تبويب التدفق النقدي). منذ بداية السنة = أشهر الخطة حتى الفترة المحاسبية المحددة؛ السنة الكاملة = كامل الخطة. انقر رقماً لعرض بنود الخطة الشهرية.'},
    buDrillPlanA:{en:'{t} Plan — Annual, monthly rows',ar:'الخطة {t} — سنوية، بنود شهرية'},
    buDrillPlanY:{en:'{t} Plan — YTD, monthly rows',ar:'الخطة {t} — منذ بداية السنة، بنود شهرية'},
    planColPeriod:{en:'Period',ar:'الفترة'},
    planColAmount:{en:'Planned Amount',ar:'المبلغ المخطط'},
    planColBy:{en:'Loaded By',ar:'حمّلها'},
    planColOn:{en:'Loaded On',ar:'تاريخ التحميل'},
    planColFile:{en:'Source File',ar:'ملف المصدر'},
    planUnmatchedNote:{en:'{amt} of the uploaded plan sits on lines not in this budget year and is not shown.',ar:'{amt} من الخطة المرفوعة على بنود غير موجودة في سنة الموازنة هذه ولا تُعرض.'},
    pfPlanY:{en:'Plan (YTD)',ar:'الخطة (منذ بداية السنة)'},
    pfPlanA:{en:'Plan (Annual)',ar:'الخطة (سنوية)'},
    pfPlanRevY:{en:'Revised Plan (YTD)',ar:'الخطة المعدلة (منذ بداية السنة)'},
    pfColPlanA:{en:'Plan Annual',ar:'الخطة السنوية'},
    pfColPlanY:{en:'Plan YTD',ar:'الخطة منذ بداية السنة'},
    pfColPlanRevA:{en:'Revised Plan Annual',ar:'الخطة المعدلة السنوية'},
    pfColPlanRevY:{en:'Revised Plan YTD',ar:'الخطة المعدلة منذ بداية السنة'},
    pfGrpPlan:{en:'Expenditure Plan',ar:'خطة الإنفاق'},
    /* ── plan insights (v1.88.0, mockups D1+K1+K2): vs-plan verdicts + coverage ── */
    piShowL:{en:'Show Plan',ar:'عرض الخطة'},
    piShowHint:{en:'Yes = the plan columns (Plan Annual / Plan YTD) with the vs Plan and Plan Coverage indicators. No = no plan columns in the results table. Plan with insights = all plan columns plus the visual micro-chart and composite columns.',ar:'نعم = أعمدة الخطة (السنوية / منذ بداية السنة) مع مؤشري "مقابل الخطة" و"تغطية الخطة". لا = بدون أعمدة الخطة في جدول النتائج. الخطة مع المؤشرات = كل أعمدة الخطة بالإضافة إلى المخطط المصغر والعمود المركب.'},
    piModeYes:{en:'Yes',ar:'نعم'},
    piModeNo:{en:'No',ar:'لا'},
    piModeIns:{en:'Plan with insights',ar:'الخطة مع المؤشرات'},
    cVsPlan:{en:'vs Plan',ar:'مقابل الخطة'},
    cPlanCov:{en:'Plan Coverage',ar:'تغطية الخطة'},
    cPlanPerf:{en:'Plan Performance',ar:'أداء الخطة'},
    cPlanComp:{en:'Plan vs Actual / Budget',ar:'الخطة مقابل الفعلي / الموازنة'},
    piWithin:{en:'Within plan',ar:'ضمن الخطة'},
    piBelow:{en:'Below plan',ar:'دون الخطة'},
    piAhead:{en:'Ahead of plan',ar:'متجاوز للخطة'},
    piNone:{en:'No plan',ar:'بلا خطة'},
    piCovFull:{en:'Full',ar:'كاملة'},
    piCovUnder:{en:'Under',ar:'ناقصة'},
    piCovOver:{en:'Over',ar:'زائدة'},
    piCovNone:{en:'Not planned',ar:'غير مخطط'},
    piVsPlanHint:{en:'vs Plan = Total Actual (AP + GRN) ÷ Plan YTD × 100 — uses the revised plan when one exists. 👍 {lo}–{hi}% = within plan · 👎 below {lo}% = slower than planned · ✋ above {hi}% = faster than planned.',ar:'مقابل الخطة = إجمالي الفعلي (دائنون + استلام) ÷ الخطة منذ بداية السنة × 100 — تُستخدم الخطة المعدلة إن وجدت. 👍 {lo}–{hi}% ضمن الخطة · 👎 أقل من {lo}% أبطأ من المخطط · ✋ أعلى من {hi}% أسرع من المخطط.'},
    piCovColHint:{en:'Plan Coverage = Plan Annual ÷ Annual Budget × 100. {lo}–{hi}% = fully planned · below {lo}% = under-planned (gap) · above {hi}% = over-planned.',ar:'تغطية الخطة = الخطة السنوية ÷ الموازنة السنوية × 100. {lo}–{hi}% مخطط بالكامل · أقل من {lo}% تخطيط ناقص (فجوة) · أعلى من {hi}% تخطيط زائد.'},
    piOfPlan:{en:'of plan',ar:'من الخطة'},
    piCovCap:{en:'plan covers {p}% of budget',ar:'الخطة تغطي {p}% من الموازنة'},
    piDelta:{en:'Δ vs plan',ar:'الفرق عن الخطة'},
    piPerfSub:{en:'Actual {a} vs plan {p}',ar:'الفعلي {a} مقابل الخطة {p}'},
    piCovSub:{en:'Plan {p} of budget {b}',ar:'الخطة {p} من الموازنة {b}'},
    piGap:{en:'Plan gap',ar:'فجوة الخطة'},
    piExecBandT:{en:'Plan execution',ar:'تنفيذ الخطة'},
    piExecBandMsg:{en:'{b} lines are below plan by {ba} and {a} lines are ahead of plan by {aa} for the selected criteria.',ar:'{b} بنداً دون الخطة بمقدار {ba} و{a} بنداً متجاوزاً للخطة بمقدار {aa} ضمن المعايير المحددة.'},
    piCovBandT:{en:'Plan coverage',ar:'تغطية الخطة'},
    piCovBandMsg:{en:'The expenditure plan covers {p}% of the annual budget — gap {amt} across {u} under-planned and {n} unplanned lines.',ar:'تغطي خطة الإنفاق {p}% من الموازنة السنوية — فجوة {amt} عبر {u} بنداً ناقص التخطيط و{n} بنداً غير مخطط.'},
    piViewBelow:{en:'View below-plan',ar:'عرض ما دون الخطة'},
    piViewAhead:{en:'View ahead-of-plan',ar:'عرض المتجاوز'},
    piViewUnplanned:{en:'View unplanned',ar:'عرض غير المخطط'},
    piChip:{en:'Plan filter: {s}',ar:'تصفية الخطة: {s}'},
    piTileHint:{en:'Click a row to filter the results to those lines.',ar:'انقر صفاً لتصفية النتائج على تلك البنود.'},
    /* ── vs Budget verdict + Manage columns (v1.96.0) ── */
    cVsBudget:{en:'vs Budget',ar:'مقابل الموازنة'},
    bdColHint:{en:'vs Budget = Total Actual (AP + GRN) ÷ ANNUAL Budget × 100 — always against the full-year budget, whatever accounting period is selected. 👍 below {n}% = on track · ✋ {n}–{o}% = near limit · 👎 above {o}% = over budget.',ar:'مقابل الموازنة = إجمالي الفعلي (دائنون + استلام) ÷ الموازنة السنوية × 100 — دائماً مقابل موازنة السنة الكاملة أياً كانت الفترة المحاسبية المحددة. 👍 أقل من {n}% ضمن الموازنة · ✋ {n}–{o}% قرب الحد · 👎 أعلى من {o}% تجاوز الموازنة.'},
    bdOk:{en:'On track',ar:'ضمن الموازنة'},
    bdNear:{en:'Near limit',ar:'قرب الحد'},
    bdOver:{en:'Over budget',ar:'تجاوز الموازنة'},
    bdNone:{en:'Not budgeted',ar:'بدون موازنة'},
    bdDelta:{en:'Δ vs annual budget',ar:'الفرق عن الموازنة السنوية'},
    colsBtnT:{en:'Manage columns — choose, reorder and save the columns shown in this table, its CSV export and the Excel Register',ar:'إدارة الأعمدة — اختر ورتّب واحفظ الأعمدة المعروضة في هذا الجدول وفي تصدير CSV وسجل الإكسل'},
    colsTitle:{en:'Manage Columns',ar:'إدارة الأعمدة'},
    colsEyebrow:{en:'Results table',ar:'جدول النتائج'},
    colsCtx:{en:'Tick the columns to show and order them with the arrows. Apply uses the layout now; Save view keeps it under a name for future use. The active layout also drives the CSV export and the Excel Register (sheet 1). Columns tied to a page feature (plan, comments) appear only while that feature is on.',ar:'حدد الأعمدة المطلوب عرضها ورتبها بالأسهم. «تطبيق» يستخدم التخطيط الآن؛ و«حفظ العرض» يحفظه باسم للاستخدام لاحقاً. التخطيط النشط يتحكم أيضاً في تصدير CSV وسجل الإكسل (الورقة 1). الأعمدة المرتبطة بخاصية في الصفحة (الخطة، التعليقات) تظهر فقط عند تفعيل تلك الخاصية.'},
    colsViewLbl:{en:'Saved views',ar:'العروض المحفوظة'},
    colsNoViewCap:{en:'— select a saved view —',ar:'— اختر عرضاً محفوظاً —'},
    colsNameLbl:{en:'View name',ar:'اسم العرض'},
    colsNamePh:{en:'e.g. Monthly review',ar:'مثال: المراجعة الشهرية'},
    colsApply:{en:'Apply',ar:'تطبيق'},
    colsSave:{en:'Save view',ar:'حفظ العرض'},
    colsDelete:{en:'Delete',ar:'حذف'},
    colsDefault:{en:'Set as default',ar:'تعيين كافتراضي'},
    colsReset:{en:'Reset to standard',ar:'إعادة للوضع القياسي'},
    colsSelAll:{en:'Select all',ar:'تحديد الكل'},
    colsClear:{en:'Clear all',ar:'إلغاء الكل'},
    colsUp:{en:'Move up',ar:'تحريك لأعلى'},
    colsDown:{en:'Move down',ar:'تحريك لأسفل'},
    colsGate:{en:'needs its feature on',ar:'يتطلب تفعيل الخاصية'},
    colsDefNote:{en:'Default view: {v} — applied automatically when the page opens.',ar:'العرض الافتراضي: {v} — يُطبق تلقائياً عند فتح الصفحة.'},
    colsSavedToast:{en:'Column view saved',ar:'تم حفظ عرض الأعمدة'},
    colsAppliedToast:{en:'Column layout applied',ar:'تم تطبيق تخطيط الأعمدة'},
    colsNeedName:{en:'Enter a view name first',ar:'أدخل اسم العرض أولاً'},
    buDrillHint:{en:'Click a figure to see its supporting AP / GRN / PR / PO lines.',ar:'انقر رقماً لعرض بنود الدائنين / الاستلام / طلب الشراء / أمر الشراء الداعمة له.'},
    buCardHint:{en:'Click to see all supporting lines (current filters).',ar:'انقر لعرض كل البنود الداعمة (حسب عوامل التصفية الحالية).'},
    buAllLines:{en:'All budget lines',ar:'كل بنود الموازنة'},
    buShowing:{en:'Showing top {n} of {c} lines by amount.',ar:'عرض أعلى {n} من {c} بند حسب المبلغ.'},
    buLinesLbl:{en:'budget lines',ar:'بند موازنة'},
    buOfBudget:{en:'of budget',ar:'من الموازنة'},
    buRemaining:{en:'of budget remaining',ar:'من الموازنة متبقٍّ'},
    buOverBudget:{en:'over budget',ar:'تجاوز الموازنة'},
    buNegTitle:{en:'Over budget — negative Fund Available.',ar:'تجاوز الموازنة — الرصيد المتاح بالسالب.'},
    buNegMsg:{en:'{n} budget line(s) have consumed MORE than their YTD budget — over-spent by {amt} in total under the current criteria. They are flagged in red in the results table below; review them and arrange a budget change or hold further spend.',ar:'يوجد {n} بند موازنة استُهلك فيه أكثر من موازنته حتى تاريخه — بتجاوز إجمالي قدره {amt} حسب المعايير الحالية. هذه البنود مميزة باللون الأحمر في جدول النتائج أدناه؛ يرجى مراجعتها وترتيب تعديل للموازنة أو إيقاف الصرف الإضافي.'},
    buNegHint:{en:'Fund Available = YTD Budget − (Actual AP + Actual GRN + Commitments PR + Obligations PO). A negative value means the line is over budget.',ar:'الرصيد المتاح = موازنة حتى تاريخه − (فعلي الفواتير + فعلي الاستلام + الارتباطات + الالتزامات). القيمة السالبة تعني تجاوز موازنة البند.'},
    buNegCellHint:{en:'Over budget — Fund Available is negative',ar:'تجاوز الموازنة — الرصيد المتاح بالسالب'},
    buNegCta:{en:'View lines',ar:'عرض البنود'},
    buNegDrill:{en:'Budget lines over budget (negative Fund Available)',ar:'بنود الموازنة المتجاوزة (الرصيد المتاح بالسالب)'},
    buMissCcTitle:{en:'Missing Cost Centre — action required.',ar:'مركز تكلفة مفقود — يلزم اتخاذ إجراء.'},
    buMissCcMsg:{en:'{n} budget line(s) totalling {amt} annual budget have NO cost centre, so Sector and Cost-centre reporting for them is incomplete. Maintain the Cost Center task attribute in Fusion (financial project plan).',ar:'يوجد {n} بند موازنة بإجمالي موازنة سنوية {amt} بدون مركز تكلفة، لذا فإن تقارير القطاع ومركز التكلفة لهذه البنود غير مكتملة. يرجى استكمال خاصية مركز التكلفة للمهمة في نظام فيوجن (الخطة المالية للمشروع).'},
    buMissCcCta:{en:'View lines',ar:'عرض البنود'},
    buMissCcHint:{en:'Click to list the budget lines that have an annual budget but no cost centre (current filters).',ar:'انقر لعرض بنود الموازنة التي لها موازنة سنوية وبدون مركز تكلفة (حسب عوامل التصفية الحالية).'},
    buMissCcDrill:{en:'Budget lines with missing Cost Centre',ar:'بنود الموازنة بدون مركز تكلفة'},
    buMissCcPName:{en:'Project name',ar:'اسم المشروع'},
    buSecSearch:{en:'Search',ar:'البحث'},
    buSecOverview:{en:'Overview',ar:'نظرة عامة'},
    buSecResults:{en:'Results',ar:'النتائج'},
    buFiltersActive:{en:'active filters',ar:'عوامل تصفية نشطة'},
    appliedFilters:{en:'Applied filters',ar:'عوامل التصفية المطبقة'},
    buMaxT:{en:'Maximize table (full screen)',ar:'تكبير الجدول (ملء الشاشة)'},
    buRestoreT:{en:'Exit full screen (Esc)',ar:'الخروج من ملء الشاشة (Esc)'},
    loadingData:{en:'Loading data',ar:'جارٍ تحميل البيانات'},
    fusionOpen:{en:'Open in Oracle Fusion (new tab)',ar:'فتح في أوراكل فيوجن (نافذة جديدة)'},
    fullYear:{en:'Full year',ar:'السنة كاملة'}, ytd:{en:'YTD',ar:'منذ بداية السنة حتى'},
    buPeriodHint:{en:'Year-to-date: every figure — including YTD Budget — covers 1 January through the end of the selected period. Annual Budget always shows the full year.',ar:'منذ بداية السنة: يشمل كل رقم — بما فيه الموازنة منذ بداية السنة — الفترة من 1 يناير حتى نهاية الفترة المحددة. تعرض الموازنة السنوية السنة كاملة دائماً.'},

    /* ── butil calculation-logic region ── */
    buSecCalc:{en:'Calculation Logic',ar:'منهجية الاحتساب'},
    calcIntro:{en:'How every figure on this page is computed from the search criteria (Budget Year + Accounting Period):',ar:'كيف يُحتسب كل رقم في هذه الصفحة وفق معايير البحث (سنة الميزانية + الفترة المحاسبية):'},
    calcThFig:{en:'Figure',ar:'الرقم'},
    calcThWhat:{en:'What it counts',ar:'ما يشمله'},
    calcThPeriod:{en:'Accounting Period (YTD) effect',ar:'أثر الفترة المحاسبية (منذ بداية السنة)'},
    calcBudgetWhat:{en:'Sum of ALL the line\'s accounting-period budget rows (budget year × project × task × expenditure type) — the approved full-year budget.',ar:'مجموع كل سجلات الموازنة بفترها المحاسبية للبند (سنة الميزانية × المشروع × المهمة × نوع الإنفاق) — الموازنة السنوية المعتمدة.'},
    calcBudgetPeriod:{en:'Not filtered — always the full year.',ar:'لا تتأثر — دائماً السنة كاملة.'},
    calcBudYtdWhat:{en:'Sum of the line\'s accounting-period budget rows up to the selected period. Drives Fund Available and Utilization %.',ar:'مجموع سجلات موازنة البند حتى الفترة المحددة. يُحتسب عليه المتاح ونسبة الاستخدام.'},
    calcBudYtdPeriod:{en:'Budget periods (MM-YYYY) on/before the selected month; budget with no period counts as annual (always included).',ar:'فترات الموازنة (شهر-سنة) حتى الشهر المحدد؛ الموازنة بلا فترة تُحسب سنوية (تُضمّن دائماً).'},
    calcApWhat:{en:'Validated supplier-invoice distributions with no PO match, in AED.',ar:'توزيعات فواتير الموردين المدققة غير المرتبطة بأمر شراء، بالدرهم.'},
    calcApPeriod:{en:'Invoice accounting date up to the selected period end.',ar:'تاريخ القيد المحاسبي للفاتورة حتى نهاية الفترة المحددة.'},
    calcGrnWhat:{en:'Goods/services receipts at ledger amount (already AED).',ar:'استلامات السلع/الخدمات بقيمة الأستاذ (بالدرهم أصلاً).'},
    calcGrnPeriod:{en:'Receipt date (accounted date, else transaction date) up to the period end.',ar:'تاريخ الاستلام (تاريخ القيد وإلا تاريخ الحركة) حتى نهاية الفترة.'},
    calcPrWhat:{en:'Open purchase-requisition distributions with funds status Reserved.',ar:'توزيعات طلبات الشراء المفتوحة بحالة أموال محجوزة.'},
    calcPrPeriod:{en:'PR budget date up to the period end.',ar:'تاريخ موازنة طلب الشراء حتى نهاية الفترة.'},
    calcPoWhat:{en:'Open purchase-order distributions (Reserved / Partially Liquidated), net of received GRN: the greater of (amount − receipts) and zero.',ar:'توزيعات أوامر الشراء المفتوحة (محجوزة / مسيّلة جزئياً) بعد خصم الاستلامات: الأكبر من (المبلغ − الاستلامات) وصفر.'},
    calcPoPeriod:{en:'PO budget date up to the period end.',ar:'تاريخ موازنة أمر الشراء حتى نهاية الفترة.'},
    calcNoteYear:{en:'Budget Year picks the annual budget and scopes every transaction to that year\'s budget lines.',ar:'تحدد سنة الميزانية الموازنة السنوية وتحصر كل الحركات في بنود موازنة تلك السنة.'},
    calcNotePeriod:{en:'With an Accounting Period selected, Fund Available reads: YTD Budget minus everything consumed up to that month-end (year-to-date). Full year = the two budget figures are equal.',ar:'عند اختيار فترة محاسبية يكون المتاح: الموازنة منذ بداية السنة ناقص كل ما استُهلك حتى نهاية ذلك الشهر. عند اختيار السنة كاملة يتساوى الرقمان.'},
    calcUtilNote:{en:'Utilization % = (Actual AP + Actual GRN + Commitment PR + Obligation PO) ÷ YTD Budget.',ar:'نسبة الاستخدام % = (فعلي الدائنين + فعلي الاستلام + الالتزام + التعهد) ÷ الموازنة منذ بداية السنة.'},

    /* ── Budget Change (signed budget_change, v2 2026-08-17) ── */
    buOvrConsider:{en:'Consider Override Budget',ar:'اعتماد الموازنة المعدّلة'},
    buOvrHint:{en:'When on, the signed Budget Change entered by users is ADDED to the Fusion budget on this page — Annual Budget, YTD Budget, Fund Available and Utilization all move by it (a negative change subtracts). A change counts in YTD from its own accounting period onward.',ar:'عند التفعيل يُضاف تغيير الموازنة المُدخل من المستخدمين إلى موازنة فيوجن في هذه الصفحة — فتتغيّر الموازنة السنوية والموازنة منذ بداية السنة والمتاح ونسبة الاستخدام بمقداره (والقيمة السالبة تُخصم). ويُحتسب التغيير ضمن «منذ بداية السنة» ابتداءً من فترته المحاسبية.'},
    buOvrOn:{en:'Budget Override included',ar:'الموازنة المعدّلة مضمّنة'},
    buProcashInc:{en:'Include Procash',ar:'تضمين الدفع المباشر'},
    buProcashHint:{en:'Procash = payments made through the bank portal that are not in Fusion as AP invoices yet. When included: Actual + Procash and Fund Available − Procash. A transaction drops out once its invoice is linked, so it is never counted twice.',ar:'الدفع المباشر = مبالغ دُفعت عبر بوابة البنك ولم تصل بعد إلى فيوجن كفواتير دائنة. عند التضمين: يُضاف إلى الفعلي ويُخصم من المتاح. وتخرج المعاملة فور ربط فاتورتها فلا تُحتسب مرتين.'},
    buProcashOnL:{en:'Procash included',ar:'الدفع المباشر مضمّن'},
    buProcashOff:{en:'Select to include Procash',ar:'حدد لتضمين الدفع المباشر'},
    cProcash:{en:'Procash',ar:'الدفع المباشر'},
    buProcashUnmapped:{en:'procash not on a budget line',ar:'دفع مباشر خارج بنود الموازنة'},

    /* ── "The Binder" report-generation popup (v1.80.0) ── */
    rgGenBook:{en:'Generating Briefing Book (PDF)',ar:'جارٍ إنشاء الكتاب التنفيذي (PDF)'},
    rgGenSpb:{en:'Generating Sector Performance Report (PDF)',ar:'جارٍ إنشاء تقرير أداء القطاعات (PDF)'},
    rgGenXlsx:{en:'Generating Excel Register (XLSX)',ar:'جارٍ إنشاء سجل إكسل (XLSX)'},
    rgGenFbp:{en:'Generating FBP - Projects Budget Utilization (XLSX)',ar:'جارٍ إنشاء تقرير FBP - استغلال ميزانية المشاريع (XLSX)'},
    rgGenMss:{en:'Generating MSS - Projects Budget Utilization (XLSX)',ar:'جارٍ إنشاء تقرير MSS - استغلال ميزانية المشاريع (XLSX)'},
    rgGenPpt:{en:'Generating PowerPoint deck (PPTX)',ar:'جارٍ إنشاء عرض باوربوينت (PPTX)'},
    rgElapsed:{en:'elapsed',ar:'الوقت المنقضي'},
    rgPolling:{en:'checking the run every {s} seconds',ar:'يتم فحص التشغيل كل {s} ثوانٍ'},
    rgHide:{en:'Hide — generation continues',ar:'إخفاء — يستمر الإنشاء'},
    rgBookT:{en:'Budget Utilization',ar:'استخدام الموازنة'},
    rgSecCover:{en:'Cover',ar:'الغلاف'},
    rgSecOverview:{en:'Overview',ar:'نظرة عامة'},
    rgSecAp:{en:'AP register',ar:'سجل الدائنين'},
    rgSecGrn:{en:'GRN register',ar:'سجل الاستلام'},
    rgSecOb:{en:'Open obligations',ar:'التعهدات المفتوحة'},
    rgSecCm:{en:'Open commitments',ar:'الالتزامات المفتوحة'},
    rgSecIns:{en:'Insights',ar:'الملاحظات التحليلية'},
    rfActPop:{en:'Refreshing actuals snapshot…',ar:'جارٍ تحديث لقطة الأرقام الفعلية…'},
    rfRebPop:{en:'Rebuilding views…',ar:'جارٍ إعادة بناء العروض…'},
    rfActSub:{en:'Re-computing the report figures — usually under a minute. Click outside to hide; the work continues.',ar:'يُعاد احتساب أرقام التقرير — عادةً أقل من دقيقة. انقر خارج النافذة لإخفائها؛ يستمر العمل.'},

    /* ── Projects Costing Adjustments (DCT_PA_COST_ADJ, 2026-08-22) ── */
    navCostAdj:{en:'Costing Adjustments',ar:'تسويات التكاليف'},
    buCadjInc:{en:'Include Cost Adjustment',ar:'تضمين تسوية التكاليف'},
    buCadjHint:{en:'Approved Projects Costing Adjustments re-allocate actual cost onto its correct budget line (a signed amount, plus an optional signed budget override on the same line). When on (the default), Actual moves by the adjustment, Budget by the override, and Fund Available follows. Lines carrying an adjustment are marked (*) in the results table.',ar:'تعيد تسويات التكاليف المعتمدة توزيع التكلفة الفعلية على بند الموازنة الصحيح (مبلغ موجب أو سالب، مع تعديل اختياري لموازنة البند نفسه). عند التفعيل (الوضع الافتراضي) يتغيّر الفعلي بمقدار التسوية والموازنة بمقدار التعديل ويتبعهما المتاح. وتُميَّز البنود التي عليها تسوية بعلامة (*) في جدول النتائج.'},
    buCadjOnL:{en:'Cost adjustment included',ar:'تسوية التكاليف مضمّنة'},
    buCadjOff:{en:'Select to include cost adjustment',ar:'حدد لتضمين تسوية التكاليف'},
    buAdjStarHint:{en:'This line includes approved cost adjustments',ar:'يتضمن هذا البند تسويات تكاليف معتمدة'},
    drillAdjSrc:{en:'Sourced from approved cost adjustment {ref}',ar:'مصدره تسوية التكاليف المعتمدة {ref}'},
    drillAdjNote:{en:'(**) This row is sourced from an approved cost adjustment — the Distribution (AED) column shows the adjustment amount; the other columns show the referenced invoice.',ar:'(**) هذا الصف مصدره تسوية تكاليف معتمدة — عمود التوزيع (درهم) يعرض مبلغ التسوية؛ بقية الأعمدة تعرض الفاتورة المرجعية.'},
    buAdjNote:{en:'(*) This line includes approved cost adjustments — Actual moves by the signed adjustment and Budget by its budget override.',ar:'(*) يتضمن هذا البند تسويات تكاليف معتمدة — يتغيّر الفعلي بمقدار التسوية والموازنة بمقدار تعديلها.'},

    /* ── Results-region level tabs (v1.89.0, layout B): Budget Line / Department / Sector ── */
    lvLine:{en:'Budget Line',ar:'بند الموازنة'},
    lvDept:{en:'Department',ar:'الإدارة'},
    lvSector:{en:'Sector',ar:'القطاع'},
    lvLines:{en:'Lines',ar:'البنود'},
    lvDepts:{en:'Departments',ar:'الإدارات'},
    lvSectors:{en:'Sectors',ar:'القطاعات'},
    lvBudget:{en:'Budget',ar:'الموازنة'},
    lvPlanYtd:{en:'Plan YTD',ar:'الخطة حتى تاريخه'},
    lvActual:{en:'Actual',ar:'الفعلي'},
    lvFund:{en:'Fund',ar:'المتاح'},
    lvEnc:{en:'Encumbrance',ar:'الارتباطات'},
    lvActualHint:{en:'Total Actual = Actual AP + Actual GRN (+ Procash when included).',ar:'إجمالي الفعلي = فعلي الدائنين + فعلي الاستلام (+ الدفع المباشر عند تضمينه).'},
    lvEncHint:{en:'Encumbrance = Commitment (PR) + Obligation (PO).',ar:'الارتباطات = الالتزام (طلب شراء) + التعهد (أمر شراء).'},
    lvBudgetHint:{en:'YTD Budget of the current result set.',ar:'موازنة النتائج الحالية منذ بداية السنة.'},
    lvPlanYtdHint:{en:'Effective YTD expenditure plan (revised when one exists).',ar:'خطة الإنفاق الفعّالة منذ بداية السنة (المعدلة إن وجدت).'},
    lvPlanOnly:{en:'Plan only',ar:'خطة فقط'},
    lvLineHint:{en:'The budget lines exactly as loaded — one row per project, task and expenditure type.',ar:'بنود الموازنة كما هي — صف لكل مشروع ومهمة ونوع مصروف.'},
    lvDeptHint:{en:'The same figures grouped per cost centre, including uploaded plan with no budget line.',ar:'الأرقام نفسها مجمّعة على مستوى مركز التكلفة، شاملة الخطة المرفوعة بلا بند موازنة.'},
    lvSectorHint:{en:'The same figures grouped per sector, including uploaded plan with no budget line.',ar:'الأرقام نفسها مجمّعة على مستوى القطاع، شاملة الخطة المرفوعة بلا بند موازنة.'},
    lvPlanOnlyNote:{en:'Amber "Plan only" rows carry an uploaded expenditure plan with no budget line at this level — included so plan totals match the Cashflow upload.',ar:'الصفوف الكهرمانية "خطة فقط" تحمل خطة إنفاق مرفوعة بلا بند موازنة على هذا المستوى — أُدرجت لتطابق إجماليات الخطة ملف التدفق النقدي المرفوع.'},
    lvExtraNote:{en:'Plan figures include {amt} of uploaded plan with no matching budget line.',ar:'تشمل أرقام الخطة {amt} من الخطة المرفوعة بلا بند موازنة مطابق.'},
    lvExtraCell:{en:'Includes {amt} of plan outside the budget lines',ar:'يشمل {amt} من الخطة خارج بنود الموازنة'},

    /* ── per-column hints, formula-first (2026-08-29 feedback round) ── */
    chSector:{en:'Sector — the classification of the line\'s cost-centre segment (managed in Settings › Chart of Accounts).',ar:'القطاع — تصنيف مقطع مركز التكلفة للبند (يُدار في الإعدادات › شجرة الحسابات).'},
    chDept:{en:'Department — the GL cost-centre description.',ar:'الإدارة — وصف مركز التكلفة في الأستاذ العام.'},
    chOrg:{en:'Organization — the task-owning organization in Fusion PPM (can differ from Department).',ar:'المنظمة — الجهة المالكة للمهمة في إدارة المشاريع (قد تختلف عن الإدارة).'},
    chCc:{en:'Cost centre — the GL cost-centre segment code.',ar:'مركز التكلفة — رمز مقطع مركز التكلفة.'},
    chProject:{en:'Project number and name — from the Fusion projects budget.',ar:'رقم المشروع واسمه — من موازنة مشاريع فيوجن.'},
    chTask:{en:'Task — the project task of this budget line.',ar:'المهمة — مهمة المشروع لهذا البند.'},
    cTaskName:{en:'Task Name',ar:'اسم المهمة'},
    chTaskName:{en:'Task Name — the name of the project task (from the Fusion tasks extract).',ar:'اسم المهمة — اسم مهمة المشروع (من مستخرج المهام في فيوجن).'},
    chGlAccount:{en:'GL account — the expenditure type\'s account (its 6-digit prefix).',ar:'حساب الأستاذ — حساب نوع المصروف (البادئة المكوّنة من 6 أرقام).'},
    chAppr:{en:'Appropriation — from the task\'s appropriation segment.',ar:'الاعتماد — من مقطع الاعتماد للمهمة.'},
    chChapter:{en:'Chapter — the classification grouping of the appropriation.',ar:'الباب — التصنيف الذي يجمع الاعتمادات.'},
    chProgram:{en:'DCT Program — from the program segment.',ar:'برنامج الدائرة — من مقطع البرنامج.'},
    chEtype:{en:'Expenditure type — the budget line\'s expenditure type.',ar:'نوع المصروف — نوع المصروف لبند الموازنة.'},
    chBudgetAnnual:{en:'Annual Budget = the full-year budget (all periods) — never cut by the Accounting Period. Includes the signed budget change / adjustment override when those options are on. Click for the budget period rows.',ar:'الموازنة السنوية = موازنة السنة كاملة (جميع الفترات) ولا تتأثر بالفترة المحاسبية. تشمل تغيير الموازنة/تعديل التسوية عند تفعيل الخيارين. انقر لعرض فترات الموازنة.'},
    chBudgetYtd:{en:'YTD Budget = budget periods up to the selected Accounting Period (Full year = Annual Budget). Click for the period rows.',ar:'الموازنة منذ بداية السنة = فترات الموازنة حتى الفترة المحاسبية المحددة (السنة الكاملة = الموازنة السنوية). انقر لعرض الفترات.'},
    chPlanA:{en:'Plan Annual = the uploaded expenditure plan for the whole year. Click for the monthly plan rows.',ar:'الخطة السنوية = خطة الإنفاق المرفوعة للسنة كاملة. انقر لعرض أشهر الخطة.'},
    chPlanY:{en:'Plan YTD = plan months up to the selected Accounting Period (Full year = Plan Annual). Click for the monthly plan rows.',ar:'الخطة منذ بداية السنة = أشهر الخطة حتى الفترة المحاسبية المحددة (السنة الكاملة = الخطة السنوية). انقر لعرض أشهر الخطة.'},
    chPlanRevA:{en:'Revised Plan Annual = the uploaded REVISED plan for the whole year (column appears only when a revised plan exists).',ar:'الخطة المعدلة السنوية = الخطة المعدلة المرفوعة للسنة كاملة (يظهر العمود فقط عند وجود خطة معدلة).'},
    chPlanRevY:{en:'Revised Plan YTD = revised plan months up to the selected Accounting Period.',ar:'الخطة المعدلة منذ بداية السنة = أشهر الخطة المعدلة حتى الفترة المحددة.'},
    chActualAp:{en:'Actual AP = validated direct AP invoices (no PO) up to the Accounting Period, + approved cost adjustments when included. Click for the invoices.',ar:'فعلي الدائنين = فواتير الدائنين المباشرة المدققة (بدون أمر شراء) حتى الفترة المحاسبية، مضافاً إليها تسويات التكاليف المعتمدة عند تضمينها. انقر لعرض الفواتير.'},
    chActualGrn:{en:'Actual GRN = goods / services received (receipts) up to the Accounting Period. Click for the receipts.',ar:'فعلي الاستلام = السلع والخدمات المستلمة حتى الفترة المحاسبية. انقر لعرض الاستلامات.'},
    chPr:{en:'Commitment (PR) = open funds-reserved purchase requisition lines (no PO yet). Click for the PR lines.',ar:'الالتزام (طلب شراء) = بنود طلبات الشراء المحجوزة المفتوحة (بدون أمر شراء بعد). انقر لعرض البنود.'},
    chPo:{en:'Obligation (PO) = open reserved purchase order lines − received (GRN-netted). Click for the PO lines.',ar:'التعهد (أمر شراء) = بنود أوامر الشراء المحجوزة المفتوحة مخصوماً منها المستلم. انقر لعرض البنود.'},
    chFund:{en:'Fund Available = YTD Budget − (Actual AP + Actual GRN + Commitment PR + Obligation PO); − Procash when included. Negative = over budget.',ar:'المتاح = الموازنة منذ بداية السنة − (فعلي الدائنين + فعلي الاستلام + الالتزام + التعهد)؛ ويُخصم الدفع المباشر عند تضمينه. السالب = تجاوز للموازنة.'},
    chCmt:{en:'Comments recorded on this budget line — click to view or add.',ar:'التعليقات المسجلة على هذا البند — انقر للعرض أو الإضافة.'},
    chCmtTxt:{en:'The recorded comment text — [period] author: text, newest first.',ar:'نص التعليقات المسجلة — [الفترة] الكاتب: النص، الأحدث أولاً.'},
    chLines:{en:'Lines = how many budget lines roll up into this row under the current criteria.',ar:'البنود = عدد بنود الموازنة المجمعة في هذا الصف وفق المعايير الحالية.'},
    chCmtGrp:{en:'Comments recorded for this department / sector at the selected Accounting Period (Full year = the whole year). Click the button to view or add.',ar:'التعليقات المسجلة لهذه الإدارة / هذا القطاع في الفترة المحاسبية المحددة (السنة الكاملة = كل السنة). انقر الزر للعرض أو الإضافة.'},

    /* ── Budget Utilization Comments (db/v2/125 + GL/db/26, 2026-08-23) ── */
    navComments:{en:'Comments',ar:'التعليقات'},
    navCmtRoles:{en:'Comment Roles',ar:'أدوار التعليقات'},
    navCmtPeriods:{en:'Reporting Periods',ar:'فترات التقارير'},
    cmtCol:{en:'Comments',ar:'التعليقات'},
    cmtOpenT:{en:'View / add business comments for this line and period',ar:'عرض أو إضافة تعليقات العمل لهذا البند وهذه الفترة'},
    buCmtStarHint:{en:'This line has business comments for the selected period',ar:'لهذا البند تعليقات عمل للفترة المحددة'},
    buCmtNote:{en:'(**) This line has business comments — open the Comments column to read and reply.',ar:'(**) لهذا البند تعليقات عمل — افتح عمود التعليقات للقراءة والرد.'},
    cmtDrawerTitle:{en:'Budget Utilization Comments',ar:'تعليقات استخدام الميزانية'},
    cmtLvlLine:{en:'Budget Line',ar:'بند الميزانية'},
    cmtLvlSector:{en:'Sector',ar:'قطاع'},
    cmtLvlCc:{en:'Cost Center',ar:'مركز التكلفة'},
    cmtLvlProject:{en:'Project',ar:'مشروع'},
    cmtLvlTask:{en:'Task',ar:'مهمة'},
    cmtLvlPo:{en:'Purchase Order',ar:'أمر شراء'},
    cmtLvlPr:{en:'Purchase Requisition',ar:'طلب شراء'},
    cmtLvlInv:{en:'AP Invoice',ar:'فاتورة الموردين'},
    cmtSecLine:{en:'Comments on this budget line',ar:'التعليقات على هذا البند'},
    cmtSecTask:{en:'Task-level comments',ar:'تعليقات على مستوى المهمة'},
    cmtSecProject:{en:'Project-level comments',ar:'تعليقات على مستوى المشروع'},
    cmtNoThread:{en:'No comments yet.',ar:'لا توجد تعليقات بعد.'},
    cmtAddTitle:{en:'Add a comment',ar:'إضافة تعليق'},
    cmtAddPh:{en:'Explain the business risk, challenge or requirement…',ar:'اشرح مخاطر العمل أو التحديات أو المتطلبات…'},
    cmtPeriodL:{en:'Accounting period',ar:'الفترة المحاسبية'},
    cmtPost:{en:'Post comment',ar:'نشر التعليق'},
    cmtReply:{en:'Reply',ar:'رد'},
    cmtReplyPh:{en:'Write a reply…',ar:'اكتب ردًا…'},
    cmtPostReply:{en:'Post reply',ar:'نشر الرد'},
    cmtEdit:{en:'Edit',ar:'تعديل'},
    cmtDelete:{en:'Delete',ar:'حذف'},
    cmtDeleteConfirm:{en:'Delete this comment?',ar:'هل تريد حذف هذا التعليق؟'},
    cmtDocDeleteConfirm:{en:'Remove this attachment?',ar:'هل تريد إزالة هذا المرفق؟'},
    cmtEdited:{en:'· edited',ar:'· معدل'},
    cmtAttach:{en:'+ Attach file',ar:'+ إرفاق ملف'},
    cmtAttachments:{en:'Attachments',ar:'المرفقات'},
    cmtNoDocs:{en:'No attachments.',ar:'لا توجد مرفقات.'},
    cmtDownload:{en:'Download',ar:'تنزيل'},
    cmtClosedBanner:{en:'Reporting period {p} is CLOSED — comments in it are read-only.',ar:'فترة التقارير {p} مغلقة — التعليقات فيها للقراءة فقط.'},
    cmtTextReq:{en:'Comment text is required',ar:'نص التعليق مطلوب'},
    cmtPeriodReq:{en:'Accounting period is required',ar:'الفترة المحاسبية مطلوبة'},
    cmtNoCap:{en:'You are not authorized to add or reply to comments. Ask the administrator to grant your role on the Comment Roles page.',ar:'لا تملك صلاحية إضافة التعليقات أو الرد عليها. اطلب من مسؤول النظام منح دورك من صفحة أدوار التعليقات.'},
    cmtRegTitle:{en:'Budget Utilization Comments',ar:'تعليقات استخدام الميزانية'},
    cmtRegSub:{en:'Business justification comments on the Budget Utilization report — every level, per accounting period. Budget-line comments are entered from the report grid, PO / PR / AP-invoice comments from the drill-down drawers, and Sector / Cost-Center comments from this page.',ar:'تعليقات مبررات العمل على تقرير استخدام الميزانية — بجميع المستويات ولكل فترة محاسبية. تُدخل تعليقات بنود الميزانية من جدول التقرير، وتعليقات أوامر وطلبات الشراء وفواتير الموردين من نوافذ التفصيل، وتعليقات القطاع ومركز التكلفة من هذه الصفحة.'},
    cmtRegRegion:{en:'Comments register',ar:'سجل التعليقات'},
    cmtRegRows:{en:'comments',ar:'تعليق'},
    cmtRegHint:{en:'Click a row to open its thread.',ar:'انقر على السطر لفتح سلسلته.'},
    cmtAllLevels:{en:'All levels',ar:'كل المستويات'},
    cmtAllPeriods:{en:'All periods',ar:'كل الفترات'},
    cmtNewSec:{en:'Sector / Cost-Center comment:',ar:'تعليق على قطاع أو مركز تكلفة:'},
    cmtPickLevel:{en:'Level',ar:'المستوى'},
    cmtPickValue:{en:'Pick a value…',ar:'اختر قيمة…'},
    cmtOpenThread:{en:'Open thread',ar:'فتح السلسلة'},
    cmtEntityCol:{en:'Entity',ar:'الكيان'},
    cmtTextCol:{en:'Comment',ar:'التعليق'},
    cmtRepliesCol:{en:'Replies',ar:'الردود'},
    cmtDocsCol:{en:'Files',ar:'الملفات'},
    cmtAuthorCol:{en:'Created by',ar:'أنشأه'},
    cmtUpdatedCol:{en:'Updated',ar:'آخر تحديث'},
    cmtRefresh:{en:'Refresh',ar:'تحديث'},
    rolesTitle:{en:'Comment Roles',ar:'أدوار التعليقات'},
    rolesSub:{en:'Which roles may add root comments, reply, and close reporting periods. Grants are stored on the common role-permission tables and apply immediately.',ar:'الأدوار المخوّلة بإضافة التعليقات والرد عليها وإغلاق فترات التقارير. تُحفظ الصلاحيات في جداول أدوار المنصة المشتركة وتسري فورًا.'},
    rolesRole:{en:'Role',ar:'الدور'},
    rolesMembers:{en:'Members',ar:'الأعضاء'},
    rolesAdd:{en:'Add comments',ar:'إضافة تعليقات'},
    rolesReply:{en:'Reply',ar:'الرد'},
    rolesClose:{en:'Close periods',ar:'إغلاق الفترات'},
    rolesHint:{en:'Tick a capability to grant it to the role; untick to revoke. System administrators always hold every capability.',ar:'حدد الصلاحية لمنحها للدور وألغِ التحديد لسحبها. يملك مسؤولو النظام كل الصلاحيات دائمًا.'},
    perTitle:{en:'Reporting Periods',ar:'فترات التقارير'},
    perSub:{en:'Close a reporting period to freeze every Budget Utilization comment in it — nothing can be added, edited or attached until the period is reopened.',ar:'أغلق فترة التقارير لتجميد جميع تعليقات استخدام الميزانية فيها — فلا يمكن إضافة أو تعديل أو إرفاق أي شيء حتى يُعاد فتح الفترة.'},
    perStatusOpen:{en:'Open',ar:'مفتوحة'},
    perStatusClosed:{en:'Closed',ar:'مغلقة'},
    perClose:{en:'Close',ar:'إغلاق'},
    perReopen:{en:'Reopen',ar:'إعادة فتح'},
    perCloseConfirm:{en:'Close reporting period {p}? No comment in it can be added or changed until it is reopened.',ar:'هل تريد إغلاق فترة التقارير {p}؟ لن يمكن إضافة أو تغيير أي تعليق فيها حتى يُعاد فتحها.'},
    perReopenConfirm:{en:'Reopen reporting period {p}?',ar:'هل تريد إعادة فتح فترة التقارير {p}؟'},
    perComments:{en:'Comments',ar:'التعليقات'},
    perClosedBy:{en:'Closed by',ar:'أغلقها'},
    perReopenedBy:{en:'Reopened by',ar:'أعاد فتحها'},
    perRemarks:{en:'Remarks',ar:'ملاحظات'},
    perRemarksPh:{en:'Optional remarks…',ar:'ملاحظات اختيارية…'},
    /* feedback round 2026-08-23 (v1.83.0) */
    buCmtDispL:{en:'Display Comments',ar:'عرض التعليقات'},
    buCmtDispHint:{en:'Include the business comments in the report: None (default), the selected accounting period only, or all periods of the year. Budget-line comments appear in an extra Comments column of the results table and CSV; the Excel Register adds them to sheet 1 plus a separate sheet for every other level (Sector / Cost Center / Project / Task / PO / PR / AP Invoice).',ar:'تضمين تعليقات العمل في التقرير: بدون (الافتراضي)، الفترة المحاسبية المحددة فقط، أو كل فترات السنة. تظهر تعليقات بنود الميزانية في عمود إضافي في جدول النتائج وملف CSV؛ ويضيفها سجل Excel إلى الورقة الأولى مع ورقة مستقلة لبقية المستويات.'},
    cmtDispNone:{en:'None',ar:'بدون'},
    cmtDispPeriod:{en:'Selected period only',ar:'الفترة المحددة فقط'},
    cmtDispAll:{en:'All periods',ar:'كل الفترات'},
    cmtFltTitle:{en:'Search comments',ar:'البحث في التعليقات'},
    cmtFltBy:{en:'Posted by',ar:'كتبها'},
    cmtFltAllBy:{en:'All users',ar:'كل المستخدمين'},
    cmtFltNone:{en:'No comments match the search criteria.',ar:'لا توجد تعليقات مطابقة لمعايير البحث.'},
    caTitle:{en:'Projects Costing Adjustments',ar:'تسويات تكاليف المشاريع'},
    caSub:{en:'Signed cost adjustments (± AED) that re-allocate actual cost to its correct project / task / expenditure type — with an optional signed budget override on the same line. Approved adjustments fold into Budget Utilization.',ar:'تسويات تكاليف موجبة أو سالبة تعيد توزيع التكلفة الفعلية على المشروع / المهمة / نوع المصروف الصحيح — مع تعديل اختياري لموازنة البند نفسه. تنعكس التسويات المعتمدة على استخدام الموازنة.'},
    caRegion:{en:'Adjustments register',ar:'سجل التسويات'},
    caRows:{en:'adjustments',ar:'تسوية'},
    caRowHint:{en:'Click a row to open it. DRAFT rows are editable; approval is manual.',ar:'انقر على السطر لفتحه. المسودات قابلة للتعديل والاعتماد يدوي.'},
    caNew:{en:'+ New Adjustment',ar:'+ تسوية جديدة'},
    caStatusL:{en:'Status',ar:'الحالة'},
    caAllStatuses:{en:'All statuses',ar:'كل الحالات'},
    caAllYears:{en:'All years',ar:'كل السنوات'},
    caRef:{en:'Ref',ar:'المرجع'},
    caInvoice:{en:'Invoice',ar:'الفاتورة'},
    caSupplier:{en:'Supplier',ar:'المورد'},
    caAmountCol:{en:'Adjustment (AED)',ar:'التسوية (درهم)'},
    caOvrCol:{en:'Budget Override (AED)',ar:'تعديل الموازنة (درهم)'},
    caAmountAed:{en:'Amount (AED)',ar:'المبلغ (درهم)'},
    caCreatedBy:{en:'Created by',ar:'أنشأها'},
    caCreatedAt:{en:'Created',ar:'تاريخ الإنشاء'},
    caActionedBy:{en:'Actioned by',ar:'اعتمدها/رفضها'},
    caActionedAt:{en:'Actioned',ar:'تاريخ الإجراء'},
    caNewTitle:{en:'New adjustment',ar:'تسوية جديدة'},
    caEditTitle:{en:'Edit adjustment',ar:'تعديل التسوية'},
    caViewTitle:{en:'Adjustment details',ar:'تفاصيل التسوية'},
    caDrawerCtx:{en:'Pick the mis-coded AP invoice distribution (optional — it may carry no project coding at all), then enter the CORRECTED budget line and the signed amounts. Only APPROVED adjustments reach the figures.',ar:'اختر توزيع فاتورة الدائنين الخاطئ الترميز (اختياري — وقد لا يحمل ترميز مشروع أصلاً)، ثم أدخل بند الموازنة الصحيح والمبالغ الموجبة أو السالبة. لا تصل إلى الأرقام إلا التسويات المعتمدة.'},
    caDistRegion:{en:'Source AP invoice distribution (optional)',ar:'توزيع فاتورة الدائنين المصدر (اختياري)'},
    caDistSearchPh:{en:'Invoice number / supplier / beneficiary…',ar:'رقم الفاتورة / المورد / المستفيد…'},
    caDistMin:{en:'Type at least 2 characters to search.',ar:'اكتب حرفين على الأقل للبحث.'},
    caDistPick:{en:'Select',ar:'اختيار'},
    caDistCoding:{en:'Current coding',ar:'الترميز الحالي'},
    caDistNoCoding:{en:'No project coding',ar:'بدون ترميز مشروع'},
    caDistNone:{en:'No distribution linked',ar:'لا يوجد توزيع مرتبط'},
    caOrigLine:{en:'Original coding',ar:'الترميز الأصلي'},
    caClear:{en:'Unlink',ar:'إلغاء الربط'},
    caCorrected:{en:'Corrected budget line',ar:'بند الموازنة الصحيح'},
    caAmount:{en:'Adjustment amount (± AED)',ar:'مبلغ التسوية (± درهم)'},
    caOvr:{en:'Budget override (± AED)',ar:'تعديل الموازنة (± درهم)'},
    caOvrHint:{en:'Optional signed change to the SAME budget line\'s budget (annual and YTD from its accounting period onward).',ar:'تعديل اختياري موجب أو سالب لموازنة البند نفسه (السنوية ومنذ بداية السنة ابتداءً من فترته المحاسبية).'},
    caPeriodHint:{en:'Required — the adjustment counts in YTD views from this accounting period onward.',ar:'مطلوب — تُحتسب التسوية في عروض «منذ بداية السنة» ابتداءً من هذه الفترة المحاسبية.'},
    caClass:{en:'Classification',ar:'التصنيف'},
    caPickClass:{en:'— pick —',ar:'— اختر —'},
    caReason:{en:'Reason',ar:'السبب'},
    caComments:{en:'Comments',ar:'ملاحظات'},
    caApprove:{en:'Approve',ar:'اعتماد'},
    caReject:{en:'Reject',ar:'رفض'},
    caDelete:{en:'Delete',ar:'حذف'},
    caApproveConfirm:{en:'Approve this adjustment? It will fold into the Budget Utilization figures.',ar:'اعتماد هذه التسوية؟ ستنعكس على أرقام استخدام الموازنة.'},
    caRejectConfirm:{en:'Reject this adjustment?',ar:'رفض هذه التسوية؟'},
    caDeleteConfirm:{en:'Delete this adjustment permanently?',ar:'حذف هذه التسوية نهائياً؟'},
    caReqFields:{en:'Budget year, accounting period, project, task, expenditure type and reason are required — and amount or budget override must be non-zero.',ar:'سنة الموازنة والفترة المحاسبية والمشروع والمهمة ونوع المصروف والسبب مطلوبة — ويجب ألا يكون مبلغ التسوية وتعديل الموازنة كلاهما صفراً.'},
    buOvrOff:{en:'Select to include Budget Override',ar:'حدد لتضمين الموازنة المعدّلة'},
    cOverrideBudget:{en:'Budget Change (+/-)',ar:'تغيير الموازنة (+/-)'},
    ovLinesN:{en:'{n} changed lines',ar:'{n} بند مُعدّل'},
    ovApplied:{en:'applied to figures',ar:'مطبّقة على الأرقام'},
    ovTileHint:{en:'Click to view and edit the Budget Change lines (current filters).',ar:'انقر لعرض وتعديل بنود تغيير الموازنة (حسب عوامل التصفية الحالية).'},
    ovDrillTitle:{en:'Budget Change lines',ar:'بنود تغيير الموازنة'},
    ovEditHint:{en:'Type the change in the Budget Change column — a positive amount adds to the budget line, a negative amount subtracts — then Save. Zero or an empty field removes the change (the line disappears on the next refresh). The change applies to its accounting period.',ar:'أدخل مقدار التغيير في عمود تغيير الموازنة — القيمة الموجبة تُضاف إلى بند الموازنة والسالبة تُخصم — ثم احفظ. الصفر أو الحقل الفارغ يزيل التغيير (يختفي البند عند التحديث التالي). ويسري التغيير على فترته المحاسبية.'},
    ovColFusion:{en:'Annual Budget (Fusion)',ar:'الموازنة السنوية (فيوجن)'},
    ovColFusionYtd:{en:'YTD Budget (Fusion)',ar:'الموازنة منذ بداية السنة (فيوجن)'},
    ovColAdjAnnual:{en:'Adjusted Annual',ar:'السنوية بعد التعديل'},
    ovColAdjYtd:{en:'Adjusted YTD',ar:'منذ بداية السنة بعد التعديل'},
    ovColUpdBy:{en:'Updated By',ar:'عدّل بواسطة'},
    ovColUpdAt:{en:'Updated At',ar:'تاريخ التعديل'},
    ovSaveBtn:{en:'Save',ar:'حفظ'},
    ovSaved:{en:'Budget change saved.',ar:'تم حفظ تغيير الموازنة.'},
    ovBadNumber:{en:'Budget change must be a number, positive or negative (or empty to clear).',ar:'يجب أن يكون تغيير الموازنة رقماً موجباً أو سالباً (أو فارغاً للإزالة).'},
    ovTotOverride:{en:'Net change',ar:'صافي التغيير'},
    ovTotFusion:{en:'Fusion annual total',ar:'إجمالي الموازنة السنوية (فيوجن)'},
    ovEmpty:{en:'No budget changes for these criteria.',ar:'لا توجد تغييرات موازنة لهذه المعايير.'},
    ovColReason:{en:'Reason Category',ar:'فئة السبب'},
    ovColComments:{en:'Comments',ar:'ملاحظات'},
    ovGuideTitle:{en:'Change the budget in bulk from Excel',ar:'تغيير الموازنة دفعة واحدة عبر إكسل'},
    ovGuideL1:{en:'Download the Excel template and open it in Microsoft Excel on Windows with the Oracle Visual Builder Add-in installed.',ar:'نزّل قالب إكسل وافتحه في مايكروسوفت إكسل على ويندوز مع تثبيت إضافة Oracle Visual Builder.'},
    ovGuideL2:{en:'Click Download Data after picking Budget Year, Accounting Period, Business Unit and Project Type, type the +/- amount in the gold Budget Change column only, then click Upload Changes.',ar:'انقر «تنزيل البيانات» بعد اختيار سنة الميزانية والفترة المحاسبية ووحدة الأعمال ونوع المشروع، وأدخل المبلغ (+/-) في عمود تغيير الموازنة الذهبي فقط، ثم انقر «رفع التغييرات».'},
    ovGuideL3:{en:'Uploaded changes appear in this list and in the Budget Change tile — or edit any line directly below.',ar:'تظهر التغييرات المرفوعة في هذه القائمة وفي بطاقة تغيير الموازنة — أو عدّل أي بند مباشرة أدناه.'},
    ovGuideLink:{en:'Download the Excel template',ar:'تنزيل قالب إكسل'},
    vbAddinLink:{en:'Add-in not installed? Download the Oracle Visual Builder Add-in for Excel (installer)',ar:'الأداة غير مثبّتة؟ تنزيل مثبّت أداة أوراكل فيجوال بيلدر لبرنامج إكسل'},
    vbAddinHint:{en:'Run the installer once (no admin rights needed), then restart Excel.',ar:'شغّل المثبّت مرة واحدة (لا يتطلب صلاحيات مسؤول) ثم أعد تشغيل برنامج إكسل.'},

    /* ── Budget Override from Excel (Visual Builder Add-in workflow) ── */
    xltplTitle:{en:'Budget Override from Excel',ar:'تعديل الموازنة عبر إكسل'},
    xltplIntro:{en:'Post Budget Change amounts (+/-) in bulk with the Oracle Visual Builder Add-in for Excel:',ar:'سجّل مبالغ تغيير الموازنة (+/-) دفعة واحدة عبر إضافة Oracle Visual Builder لبرنامج إكسل:'},
    xltplS1:{en:'Download the Excel template below.',ar:'نزّل قالب إكسل أدناه.'},
    xltplS2:{en:'Open it in Microsoft Excel on Windows with the Oracle Visual Builder Add-in for Excel installed.',ar:'افتحه في مايكروسوفت إكسل على ويندوز مع تثبيت إضافة Oracle Visual Builder لإكسل.'},
    xltplS3:{en:'Sign in and click Download Data, entering the Budget Year (and optionally the Accounting Period).',ar:'سجّل الدخول ثم انقر «تنزيل البيانات» مع إدخال سنة الميزانية (والفترة المحاسبية اختيارياً).'},
    xltplS4:{en:'Type the +/- amount in the gold Budget Change column ONLY, then click Upload Changes.',ar:'أدخل المبلغ (+/-) في عمود تغيير الموازنة الذهبي فقط، ثم انقر «رفع التغييرات».'},
    xltplS5:{en:'Uploaded changes appear here in the Budget Change tile — tick "Select to include Budget Override" to add them to the Annual and YTD Budget.',ar:'تظهر التغييرات المرفوعة هنا في بطاقة تغيير الموازنة — فعّل «حدد لتضمين الموازنة المعدّلة» لإضافتها إلى الموازنة السنوية ومنذ بداية السنة.'},
    xltplBtn:{en:'Download Excel Template',ar:'تنزيل قالب إكسل'},
    xltplBusy:{en:'Downloading…',ar:'جارٍ التنزيل…'},
    xltplDlFail:{en:'Template download failed',ar:'فشل تنزيل القالب'},

    /* ── Executive dashboard ── */
    dashTitle:{en:'Executive dashboard',ar:'لوحة المعلومات التنفيذية'},
    dashSub:{en:'Where the budget is going — spend, commitments and momentum at a glance.',ar:'إلى أين تتجه الموازنة — الإنفاق والارتباطات والاتجاه في لمحة.'},
    kUtil:{en:'Budget utilised',ar:'الموازنة المستخدمة'}, kCommit:{en:'Committed',ar:'مرتبط'},
    kPoTotal:{en:'PO commitments',ar:'التزامات أوامر الشراء'}, kPoCount:{en:'purchase orders',ar:'أمر شراء'},
    kCombos:{en:'active combinations',ar:'تركيبة نشطة'},
    secUtil:{en:'Budget utilisation',ar:'استخدام الموازنة'},
    secBySector:{en:'Actual spend by sector',ar:'الإنفاق الفعلي حسب القطاع'},
    secByProgram:{en:'Actual spend by DCT program',ar:'الإنفاق الفعلي حسب برنامج الدائرة'},
    secByAppr:{en:'PO commitments by appropriation',ar:'التزامات أوامر الشراء حسب الاعتماد'},
    secTrend:{en:'Actual spend — period over period',ar:'الإنفاق الفعلي — فترة بعد فترة'},
    secInsights:{en:'Insights',ar:'رؤى'},
    ofBudget:{en:'of budget spent',ar:'من الموازنة'}, committedOf:{en:'committed',ar:'مرتبط'},
    lblActual:{en:'Actual',ar:'الفعلي'}, lblBudget:{en:'Budget',ar:'الموازنة'},
    lblPoTotal:{en:'PO total',ar:'إجمالي الشراء'}, lblPoCount:{en:'POs',ar:'أوامر'},
    dashNoData:{en:'No data for this period.',ar:'لا توجد بيانات لهذه الفترة.'},
    insUtil:{en:'Budget utilisation is {p}% — {a} of {b} AED spent year-to-date.',ar:'استخدام الموازنة {p}% — صُرف {a} من {b} درهم حتى تاريخه.'},
    insCommit:{en:'A further {p}% is committed via encumbrances; {f} AED remains available.',ar:'إضافةً إلى {p}% مرتبطة عبر الارتباطات؛ يتبقى {f} درهم متاح.'},
    insTopSector:{en:'{s} leads actual spend at {a} AED ({p}% of total).',ar:'{s} يتصدر الإنفاق الفعلي بـ {a} درهم ({p}% من الإجمالي).'},
    insTopAppr:{en:'{s} carries the largest PO commitment: {a} AED across {n} orders.',ar:'{s} يحمل أكبر التزام شراء: {a} درهم عبر {n} أمر.'},
    insGrowth:{en:'Actual spend rose from {a} ({p1}) to {b} ({p2}) — {x}× across the year.',ar:'ارتفع الإنفاق الفعلي من {a} ({p1}) إلى {b} ({p2}) — {x}× خلال العام.'},

    /* ── Generate and Send (report distributions) + Email Logs + Recipients ── */
    navEmailLog:{en:'Email Logs',ar:'سجل الرسائل'},
    navRecipients:{en:'Report Recipients',ar:'مستلمو التقارير'},
    /* ── Terms and Key definitions (report intro content, Settings) ── */
    navTerms:{en:'Terms and Key definitions',ar:'الشروط والتعريفات الرئيسية'},
    tkTitle:{en:'Terms and Key definitions',ar:'الشروط والتعريفات الرئيسية'},
    tkSub:{en:'Rich-text definition documents printed as the first content entry of the related report (the document active within its start/end dates at the report period)',ar:'مستندات تعريفات منسقة تُطبع كأول بند محتوى في التقرير المرتبط (المستند النشط ضمن تاريخي البداية والنهاية في فترة التقرير)'},
    tkNew:{en:'+ New document',ar:'+ مستند جديد'},
    tkColTitle:{en:'Title',ar:'العنوان'},
    tkAppliedTo:{en:'Applied to',ar:'ينطبق على'},
    tkStart:{en:'Start date',ar:'تاريخ البداية'},
    tkEnd:{en:'End date',ar:'تاريخ النهاية'},
    tkStatus:{en:'Status',ar:'الحالة'},
    tkUpdated:{en:'Updated',ar:'آخر تحديث'},
    tkActive:{en:'Active',ar:'نشط'},
    tkInactive:{en:'Inactive',ar:'غير نشط'},
    tkNote:{en:'The report prints the ACTIVE document whose start/end window covers the report period end (full year = 31 December). Formatting is reproduced in the PDF exactly as typed.',ar:'يطبع التقرير المستند النشط الذي تغطي فترته نهاية فترة التقرير (السنة الكاملة = 31 ديسمبر). يُعاد إنتاج التنسيق في ملف PDF كما هو تماماً.'},
    tkNoRows:{en:'No definition documents yet — create the first one.',ar:'لا توجد مستندات تعريفات بعد — أنشئ المستند الأول.'},
    tkEditTitle:{en:'Edit definitions document',ar:'تحرير مستند التعريفات'},
    tkContent:{en:'Definitions content (rich text)',ar:'محتوى التعريفات (نص منسق)'},
    tkContentHint:{en:'Format the terms exactly as they should appear in the report — bold names, bullets, colors and sizes are all preserved.',ar:'نسّق الشروط تماماً كما يجب أن تظهر في التقرير — الأسماء الغامقة والتعداد والألوان والأحجام كلها محفوظة.'},
    tkEndHint:{en:'Leave empty for open-ended validity',ar:'اتركه فارغاً لصلاحية مفتوحة'},
    tkSaved:{en:'Definitions document saved',ar:'تم حفظ مستند التعريفات'},
    tkDeleted:{en:'Definitions document deleted',ar:'تم حذف مستند التعريفات'},
    tkDeleteConfirm:{en:'Delete this definitions document? The report will fall back to the next active document (or none).',ar:'حذف مستند التعريفات هذا؟ سيعود التقرير إلى المستند النشط التالي (أو لا شيء).'},
    tkCreated:{en:'Created',ar:'أُنشئ'},
    gsBtn:{en:'Generate and Send ▾',ar:'إنشاء وإرسال ▾'},
    gsRunning:{en:'Sending…',ar:'جارٍ الإرسال…'},
    gsLvlSector:{en:'Sector Level',ar:'مستوى القطاع'},
    gsLvlSectorSub:{en:'One email per selected sector',ar:'رسالة لكل قطاع محدد'},
    gsLvlDept:{en:'Department Level',ar:'مستوى الإدارة'},
    gsLvlDeptSub:{en:'One email per selected cost centre',ar:'رسالة لكل مركز تكلفة محدد'},
    gsLvlProject:{en:'Project Level',ar:'مستوى المشروع'},
    gsLvlProjectSub:{en:'One email per selected project (department recipients)',ar:'رسالة لكل مشروع محدد (مستلمو الإدارة)'},
    gsTitle:{en:'Generate and Send',ar:'إنشاء وإرسال'},
    gsPickTitle:{en:'Select the scope',ar:'اختر النطاق'},
    gsPickHint:{en:'Tick items in the tree, then Add them to the selection list.',ar:'حدد العناصر في الشجرة ثم أضفها إلى قائمة الاختيار.'},
    gsAdd:{en:'Add',ar:'إضافة'},
    gsSelected:{en:'Selected for sending',ar:'المحدد للإرسال'},
    gsNone:{en:'Nothing selected yet.',ar:'لم يتم تحديد شيء بعد.'},
    gsFormats:{en:'Attachments',ar:'المرفقات'},
    gsFmtPdf:{en:'Briefing Book (PDF)',ar:'الكتاب التنفيذي (PDF)'},
    gsFmtXlsx:{en:'Excel Register (XLSX)',ar:'سجل إكسل (XLSX)'},
    gsCriteria:{en:'Report criteria',ar:'معايير التقرير'},
    gsFullYear:{en:'Full year',ar:'السنة الكاملة'},
    gsInheritNote:{en:'A project email goes to the recipients of its owning department (cost centre).',ar:'رسالة المشروع تُرسل إلى مستلمي الإدارة (مركز التكلفة) المالكة له.'},
    gsNext:{en:'Next',ar:'التالي'},
    gsBack:{en:'Back',ar:'رجوع'},
    gsConfirmTitle:{en:'Confirm recipients',ar:'تأكيد المستلمين'},
    gsConfirmSub:{en:'Review exactly who will receive each report before sending.',ar:'راجع من سيستلم كل تقرير قبل الإرسال.'},
    gsTo:{en:'To',ar:'إلى'},
    gsCc:{en:'Cc',ar:'نسخة'},
    gsBcc:{en:'Bcc',ar:'نسخة مخفية'},
    gsHidden:{en:'hidden',ar:'مخفي'},
    gsNoList:{en:'No recipient list defined — this selection will be skipped.',ar:'لا توجد قائمة مستلمين — سيتم تخطي هذا الاختيار.'},
    gsSend:{en:'Confirm & Send',ar:'تأكيد وإرسال'},
    gsTestBanner:{en:'TEST MODE is ON — every email will be sent ONLY to the test mailbox ({to}), never to the recipients listed below.',ar:'وضع الاختبار مفعّل — سترسل كل الرسائل إلى بريد الاختبار فقط ({to}) وليس إلى المستلمين أدناه.'},
    gsTestNoTo:{en:'TEST MODE is ON with no test mailbox configured — nothing will be emailed (reports are still generated).',ar:'وضع الاختبار مفعّل بدون بريد اختبار — لن يُرسل شيء (سيتم إنشاء التقارير فقط).'},
    gsEmailOff:{en:'Email sending is globally DISABLED (EMAIL_ENABLED=N) — reports will be generated but no email will be sent.',ar:'إرسال البريد معطل بشكل عام — سيتم إنشاء التقارير دون إرسال أي بريد.'},
    gsEmailsPlanned:{en:'{n} email(s) will be prepared.',ar:'سيتم تجهيز {n} رسالة.'},
    gsProgress:{en:'Sending progress',ar:'تقدم الإرسال'},
    gsPollNote:{en:'Reports are generated by the worker fleet — this list refreshes every few seconds.',ar:'تُنشأ التقارير عبر خوادم المعالجة — تتحدث القائمة كل بضع ثوانٍ.'},
    gsAllDone:{en:'All runs completed.',ar:'اكتملت جميع العمليات.'},
    gsFilter:{en:'Filter…',ar:'تصفية…'},
    gsBatch:{en:'Batch',ar:'الدفعة'},
    gsSkipped:{en:'skipped',ar:'متخطى'},
    gsSent:{en:'sent',ar:'مرسل'},
    gsFailedN:{en:'failed',ar:'فشل'},
    elTitle:{en:'Report Email Logs',ar:'سجل رسائل التقارير'},
    elSub:{en:'Every Generate-and-Send email — who was addressed, what was attached, and what actually happened.',ar:'كل رسالة إنشاء وإرسال — المخاطبون والمرفقات وما حدث فعلاً.'},
    elFrom:{en:'From date',ar:'من تاريخ'},
    elTo:{en:'To date',ar:'إلى تاريخ'},
    elLevel:{en:'Level',ar:'المستوى'},
    elRecipient:{en:'Recipient contains',ar:'المستلم يحتوي'},
    elRunStatus:{en:'Run status',ar:'حالة التشغيل'},
    elEmailStatus:{en:'Email status',ar:'حالة الرسالة'},
    elTestFilter:{en:'Test emails',ar:'رسائل الاختبار'},
    elTestAll:{en:'All',ar:'الكل'},
    elTestOnly:{en:'Only test',ar:'الاختبار فقط'},
    elTestExcl:{en:'Exclude test',ar:'استبعاد الاختبار'},
    elReport:{en:'Report',ar:'التقرير'},
    elScope:{en:'Scope',ar:'النطاق'},
    elSubject:{en:'Subject',ar:'الموضوع'},
    elStatus:{en:'Status',ar:'الحالة'},
    elCounts:{en:'Sent / Failed / Skipped',ar:'مرسل / فشل / متخطى'},
    elBy:{en:'Requested by',ar:'بواسطة'},
    elAt:{en:'Requested at',ar:'التاريخ'},
    elPeriod:{en:'Period',ar:'الفترة'},
    elNoRows:{en:'No email history for the selected criteria.',ar:'لا يوجد سجل رسائل للمعايير المحددة.'},
    elDrillTitle:{en:'Email details',ar:'تفاصيل الرسالة'},
    elRecipients:{en:'Recipients',ar:'المستلمون'},
    elFiles:{en:'Attachments',ar:'المرفقات'},
    elDownload:{en:'Download',ar:'تنزيل'},
    elTestBadge:{en:'TEST',ar:'اختبار'},
    elShowing:{en:'{n} email run(s)',ar:'{n} عملية إرسال'},
    rlTitle:{en:'Report Recipients',ar:'مستلمو التقارير'},
    rlSub:{en:'The To / Cc / Bcc distribution list behind Generate and Send — one row per sector or cost centre.',ar:'قوائم التوزيع (إلى / نسخة / نسخة مخفية) خلف الإنشاء والإرسال — صف لكل قطاع أو مركز تكلفة.'},
    rlNew:{en:'+ New list',ar:'+ قائمة جديدة'},
    rlImport:{en:'Import from Excel',ar:'استيراد من إكسل'},
    rlScope:{en:'Scope',ar:'النطاق'},
    rlScopeSector:{en:'Sector',ar:'قطاع'},
    rlScopeCc:{en:'Cost Centre',ar:'مركز تكلفة'},
    rlSector:{en:'Sector',ar:'القطاع'},
    rlValue:{en:'Scope value',ar:'قيمة النطاق'},
    rlValueHintCc:{en:'7-digit cost centre code, e.g. 4510195',ar:'رمز مركز التكلفة (7 أرقام)، مثال 4510195'},
    rlValueHintSec:{en:'Sector name exactly as on the Budget Utilization page',ar:'اسم القطاع كما يظهر في صفحة استخدام الموازنة'},
    rlLabel:{en:'Display label',ar:'الاسم المعروض'},
    rlSubject:{en:'Email subject template',ar:'قالب موضوع الرسالة'},
    rlSubjectHint:{en:'Optional. Jinja2 template; blank = platform default "DCT i-Finance | report | scope | period". Variables: {{ scope_label }}, {{ period }}, {{ params.year }}, {{ report_name }}.',ar:'اختياري. قالب Jinja2؛ الفراغ = الصيغة الافتراضية. المتغيرات: {{ scope_label }}، {{ period }}، {{ params.year }}، {{ report_name }}.'},
    rlEnabled:{en:'Active',ar:'مفعل'},
    rlRecipients:{en:'Recipients',ar:'المستلمون'},
    rlAddRecip:{en:'+ Add recipient',ar:'+ إضافة مستلم'},
    rlEmail:{en:'Email',ar:'البريد الإلكتروني'},
    rlName:{en:'Name',ar:'الاسم'},
    rlDisp:{en:'Send as',ar:'نوع الإرسال'},
    rlEditTitle:{en:'Recipient list',ar:'قائمة المستلمين'},
    rlSave:{en:'Save',ar:'حفظ'},
    rlDelete:{en:'Delete',ar:'حذف'},
    rlDeleteConfirm:{en:'Delete this recipient list?',ar:'حذف قائمة المستلمين هذه؟'},
    rlSaved:{en:'Recipient list saved.',ar:'تم حفظ قائمة المستلمين.'},
    rlDeleted:{en:'Recipient list deleted.',ar:'تم حذف القائمة.'},
    rlUpdated:{en:'Updated',ar:'آخر تحديث'},
    rlNoRows:{en:'No recipient lists yet — import the Excel distribution list or add rows manually.',ar:'لا توجد قوائم بعد — استورد ملف إكسل أو أضف القوائم يدوياً.'},
    rlImpTitle:{en:'Import recipient lists from Excel',ar:'استيراد قوائم المستلمين من إكسل'},
    rlImpPick:{en:'Choose Excel file…',ar:'اختر ملف إكسل…'},
    rlImpSheet:{en:'Worksheet',ar:'ورقة العمل'},
    rlImpKind:{en:'Detected scope',ar:'النطاق المكتشف'},
    rlImpActive:{en:'Import rows marked Active only',ar:'استيراد الصفوف المفعلة فقط'},
    rlImpCols:{en:'Email columns — choose where each goes',ar:'أعمدة البريد — حدد وجهة كل عمود'},
    rlImpSkip:{en:'Skip',ar:'تجاهل'},
    rlImpReady:{en:'{n} row(s) ready to import.',ar:'{n} صف جاهز للاستيراد.'},
    rlImpRun:{en:'Import',ar:'استيراد'},
    rlImpDone:{en:'Import finished: {c} created, {u} updated, {e} errors.',ar:'انتهى الاستيراد: {c} جديد، {u} محدث، {e} أخطاء.'},
    rlImpNoEmail:{en:'No email-bearing columns detected in this sheet.',ar:'لا توجد أعمدة بريد في هذه الورقة.'},
    rlImpReplaceNote:{en:'Importing REPLACES the recipients of every matched scope row; other rows are untouched.',ar:'الاستيراد يستبدل مستلمي الصفوف المطابقة فقط؛ الصفوف الأخرى لا تُمس.'},

    /* ── FD Dashboard / Budget Status (user sketch, mockup A "Ring Bands", GL/db/42) ── */
    navFd:{en:'Budget Status',ar:'حالة الموازنة'},
    fdTitle:{en:'Budget Status',ar:'حالة الموازنة'},
    fdSub:{en:'Budget, Actual, Encumbrance and Fund Available by chapter — every entity',ar:'الموازنة والفعلي والالتزامات والرصيد المتاح حسب الباب — لجميع الجهات'},
    fdSectors:{en:'Sectors',ar:'القطاعات'},
    fdSectorsHint:{en:'Click one or more sectors to filter the chapters below',ar:'انقر على قطاع واحد أو أكثر لتصفية الأبواب أدناه'},
    fdAllSectors:{en:'Showing all sectors',ar:'عرض جميع القطاعات'},
    fdSelected:{en:'{n} selected',ar:'تم اختيار {n}'},
    fdClear:{en:'Clear',ar:'مسح'},
    fdUnitL:{en:'Entity',ar:'الجهة'},
    fdAllUnits:{en:'All entities',ar:'جميع الجهات'},
    fdEntDCT:{en:'DCT',ar:'دائرة الثقافة والسياحة'},
    fdEntMUSEUMS:{en:'MSS',ar:'الخدمات المشتركة للمتاحف'},
    fdEntALC:{en:'ALC',ar:'مركز أبوظبي للغة العربية'},
    fdEntMASTERPIECES:{en:'Masterpieces',ar:'المقتنيات الفنية'},
    fdEntUNCLASSIFIED:{en:'Unclassified',ar:'غير مصنف'},
    fdBudget:{en:'Budget',ar:'الموازنة'},
    fdActual:{en:'Actual',ar:'الفعلي'},
    fdEnc:{en:'Encumbrance',ar:'الالتزامات'},
    fdFund:{en:'Fund available',ar:'الرصيد المتاح'},
    fdBudgetSub:{en:'YTD · Budget Group 1',ar:'تراكمي · مجموعة الموازنة 1'},
    fdBudgetSubBg:{en:'YTD · Budget Group {g}',ar:'تراكمي · مجموعة الموازنة {g}'},
    fdBudgetSubBgs:{en:'YTD · Budget Groups {g}',ar:'تراكمي · مجموعات الموازنة {g}'},
    fdActualSub:{en:'of budget · GL actual',ar:'من الموازنة · الفعلي في الأستاذ العام'},
    fdEncSub:{en:'of budget · GL encumbrance',ar:'من الموازنة · التزامات الأستاذ العام'},
    fdRemains:{en:'of budget remains',ar:'من الموازنة متبقٍ'},
    fdOverBudget:{en:'over budget',ar:'تجاوز الموازنة'},
    fdUsed:{en:'used',ar:'مستخدم'},
    fdCH1:{en:'Chapter 1',ar:'الباب الأول'},
    fdCH2:{en:'Chapter 2',ar:'الباب الثاني'},
    fdCH3:{en:'Chapter 3',ar:'الباب الثالث'},
    fdCH4:{en:'Chapter 4',ar:'الباب الرابع'},
    fdCH5:{en:'Chapter 5',ar:'الباب الخامس'},
    fdAltCH1:{en:'Payroll',ar:'الرواتب والأجور'},
    fdAltCH2:{en:'Opex',ar:'المصروفات التشغيلية'},
    fdAltCH3:{en:'Capex',ar:'المصروفات الرأسمالية'},
    fdAltCH4:{en:'Subsidy',ar:'الدعم'},
    fdAltCH5:{en:'Aids & Grants',ar:'المساعدات والمنح'},
    fdFootScope:{en:'Basis: Fusion GL balances at the selected period (YTD), Chapters 1–5 — Chapters 1–3 on Budget Group 1 (the same figures as the Financial Performance report), Chapter 4 on Budget Group 3, Chapter 5 on Budget Group 5. Fund available = Budget − Actual − Encumbrance. Budget = expense accounts (4xxxxx) only — Treasury-contribution (funding) accounts are never counted.',ar:'الأساس: أرصدة الأستاذ العام في فيوجن للفترة المحددة (تراكمي)، الأبواب 1–5 — الأبواب 1–3 على مجموعة الموازنة 1 (نفس أرقام تقرير الأداء المالي)، الباب 4 على مجموعة الموازنة 3، الباب 5 على مجموعة الموازنة 5. الرصيد المتاح = الموازنة − الفعلي − الالتزامات. الموازنة = حسابات المصروفات (4xxxxx) فقط — حسابات مساهمة الخزانة (التمويل) لا تُحتسب أبداً.'},
    fdFootExcluded:{en:'Expense budget with no chapter classification (not in the bands — assign a Chapter in Settings › Chart of Accounts):',ar:'موازنة مصروفات بدون تصنيف باب (غير مدرجة في الأبواب — عيّن الباب في الإعدادات › دليل الحسابات):'},
    fdGrand:{en:'Total',ar:'الإجمالي'},
    fdTotalAlt:{en:'Chapters 1–5',ar:'الأبواب 1–5'},
    fdNoData:{en:'No GL balances are loaded for this period.',ar:'لا توجد أرصدة محملة لهذه الفترة.'},
    fdCombos:{en:'combinations',ar:'تركيبات'},
    fdDrillHint:{en:'Click any figure to list its GL code combinations — hover a combination for the segment descriptions',ar:'انقر على أي رقم لعرض تركيبات حساب الأستاذ العام الخاصة به — مرّر المؤشر فوق التركيبة لعرض أوصاف المقاطع'},
    fdDrillSectors:{en:'{n} sectors',ar:'{n} قطاعات'},
    fdDepts:{en:'Departments (Cost Centres)',ar:'الإدارات (مراكز التكلفة)'},
    fdDeptsHint:{en:'Cost centres of the selected sectors — click one or more to filter the chapters below',ar:'مراكز التكلفة للقطاعات المختارة — انقر على واحد أو أكثر لتصفية الأبواب أدناه'},
    fdAllDepts:{en:'Showing all departments',ar:'عرض جميع الإدارات'},
    fdDeptSearch:{en:'Filter departments…',ar:'تصفية الإدارات…'},
    fdNoDepts:{en:'No departments match.',ar:'لا توجد إدارات مطابقة.'},
    fdDrillDepts:{en:'{n} departments',ar:'{n} إدارات'},
    /* presentation switch (v1.105.0): rows / tiles / map — one Search parameter drives both regions */
    fdShowSummary:{en:'Show Summary',ar:'إظهار الملخص'},
    fdPrint:{en:'Print',ar:'طباعة'},
    fdPrintPdf:{en:'Dashboard as PDF',ar:'لوحة المعلومات بصيغة PDF'},
    fdPrintPpt:{en:'Dashboard as PowerPoint slides',ar:'لوحة المعلومات كشرائح PowerPoint'},
    fdLayoutL:{en:'Presentation',ar:'طريقة العرض'},
    fdLayoutTiles:{en:'Composition tiles',ar:'بطاقات التكوين'},
    fdLayoutRows:{en:'Ledger rows',ar:'صفوف دفترية'},
    fdLayoutMap:{en:'Proportional map',ar:'خريطة نسبية'},
    fdPresDescTiles:{en:'Cards with a composition bar',ar:'بطاقات بشريط تكوين'},
    fdPresDescRows:{en:'Ranked bars on one scale',ar:'أشرطة مرتبة بمقياس واحد'},
    fdPresDescMap:{en:'Treemap — area = budget',ar:'خريطة شجرية — المساحة = الموازنة'},
    fdPresHintTiles:{en:'One card per sector or department: the budget as the big figure, its share of the total, a bar split into Actual · Encumbrance · Fund as shares of the budget, and a state pill with what is still free.',ar:'بطاقة لكل قطاع أو إدارة: الموازنة كرقم رئيسي، حصتها من الإجمالي، شريط مقسّم إلى الفعلي · الالتزامات · الرصيد كنسب من الموازنة، وشارة حالة تبيّن المتبقي.'},
    fdPresHintRows:{en:'A ranked ledger: every bar is drawn on ONE shared scale (the longest = the largest budget) and split into Actual · Encumbrance · Fund, with the four figures in aligned columns. Best for precise comparison.',ar:'سجل مرتب: كل شريط مرسوم بمقياس واحد مشترك (الأطول = أكبر موازنة) ومقسّم إلى الفعلي · الالتزامات · الرصيد، مع الأرقام الأربعة في أعمدة متحاذية. الأنسب للمقارنة الدقيقة.'},
    fdPresHintMap:{en:'A proportional map: tile area = share of budget, colour = % consumed (Actual + Encumbrance) from pale to deep, rust when over committed; departments are nested inside their sectors. Best for seeing where the money sits.',ar:'خريطة نسبية: مساحة المربع = الحصة من الموازنة، واللون = % المستهلك (الفعلي + الالتزامات) من الفاتح إلى الداكن، وبني محمر عند تجاوز الالتزام؛ الإدارات متداخلة داخل قطاعاتها. الأنسب لمعرفة أين تتركز الأموال.'},
    fdPresState:{en:'State pill: On track below {near}% consumed · Tight from {near}% · Over committed above {over}% or a negative fund.',ar:'شارة الحالة: ضمن الحد أقل من {near}% مستهلك · قريب من الحد من {near}% · تجاوز الالتزام فوق {over}% أو رصيد سالب.'},
    fdSortL:{en:'Sort',ar:'الترتيب'},
    fdSortName:{en:'Sort: Name',ar:'الترتيب: الاسم'},
    fdHintSecLead:{en:'Pick one or more sectors',ar:'اختر قطاعاً واحداً أو أكثر'},
    fdHintSecBody:{en:'to filter the chapters below — nothing picked = every sector.',ar:'لتصفية الأبواب أدناه — بدون اختيار = جميع القطاعات.'},
    fdHintDeptLead:{en:'Pick one or more departments',ar:'اختر إدارة واحدة أو أكثر'},
    fdHintDeptBody:{en:'cost centres of the picked sectors — narrows the chapters further.',ar:'مراكز التكلفة للقطاعات المختارة — تضيّق نطاق الأبواب أكثر.'},
    fdHintTiles:{en:'Bar = Actual · Encumbrance · Fund as shares of the budget; the pill shows what is still free.',ar:'الشريط = الفعلي · الالتزامات · الرصيد كنسب من الموازنة؛ الشارة تبيّن المتبقي.'},
    fdHintRows:{en:'Bars share one scale — the longest is the largest budget.',ar:'الأشرطة بمقياس واحد — الأطول هو أكبر موازنة.'},
    fdHintMap:{en:'Tile area = share of budget · colour = % consumed (Actual + Encumbrance).',ar:'مساحة المربع = الحصة من الموازنة · اللون = % المستهلك (الفعلي + الالتزامات).'},
    fdHintSorted:{en:'Sorted by budget amount, largest first.',ar:'مرتبة حسب مبلغ الموازنة، الأكبر أولاً.'},
    fdHintTop:{en:'Showing the top {n} — "Show all" lists the rest.',ar:'عرض أعلى {n} — «عرض الكل» يعرض البقية.'},
    /* monthly-movement hint on the rings (Mockup 2, approach A — v1.107.0) */
    fdTrTitle:{en:'{m} — monthly movement',ar:'{m} — الحركة الشهرية'},
    fdTrSub:{en:'Strong = the month\'s movement · pale = balance brought forward · full width = {p} YTD {v}',ar:'الداكن = حركة الشهر · الفاتح = الرصيد المرحّل · العرض الكامل = {p} تراكمي {v}'},
    fdTrMove:{en:'Month movement',ar:'حركة الشهر'},
    fdTrBf:{en:'Brought forward',ar:'رصيد مرحّل'},
    fdTrAvg:{en:'Avg month',ar:'متوسط الشهر'},
    fdTrYtd:{en:'YTD',ar:'تراكمي'},
    fdTrNone:{en:'No earlier periods are loaded for this year.',ar:'لا توجد فترات سابقة محمّلة لهذه السنة.'},
    fdTrHint:{en:'hover a figure for its month-by-month movement',ar:'مرّر المؤشر فوق رقم لعرض حركته شهراً بشهر'},
    segmentKey:{en:'GL segment',ar:'مقطع دفتر الأستاذ'},
    defaultValue:{en:'Default value',ar:'القيمة الافتراضية'},
    defaultValueHint:{en:'Used for every combination no rule matches (Entity only)',ar:'تُستخدم لكل تركيبة لا تنطبق عليها أي قاعدة (الجهة فقط)'},
    defaultChip:{en:'Default',ar:'افتراضي'},
    entityCol:{en:'Entity',ar:'الجهة'},
    allEntities:{en:'All entities',ar:'جميع الجهات'},
    unclassified:{en:'Unclassified',ar:'غير مصنف'},
    entityRuleHint:{en:'Entity rules may read any of the 10 GL segments. A combination may match ONE rule only — the default value covers everything else. Saving refreshes the reports within about 15 seconds.',ar:'يمكن لقواعد الجهة قراءة أي من مقاطع دفتر الأستاذ العشرة. تنطبق قاعدة واحدة فقط على كل تركيبة — وتغطي القيمة الافتراضية ما تبقى. يحدّث الحفظ التقارير خلال نحو 15 ثانية.'},
    savedRefreshing:{en:'Saved — reports pick this up in about 15 seconds',ar:'تم الحفظ — ستظهر التغييرات في التقارير خلال نحو 15 ثانية'},
    fdNoBudgetNotice:{en:'No budget allocated — showing Ledger rows for spending and commitments.',ar:'لا توجد موازنة مخصصة — تُعرض المصروفات والارتباطات في صفوف دفترية.'},
    fdTrCardHint:{en:'Hover a card for its month-by-month movement (Actual by default) — hover a figure inside it to switch the measure.',ar:'مرّر المؤشر فوق بطاقة لعرض حركتها شهراً بشهر (الفعلي افتراضياً) — مرّر فوق رقم داخلها لتبديل المقياس.'},
    fdSector:{en:'Sector',ar:'القطاع'},
    fdDept:{en:'Department',ar:'الإدارة'},
    fdColScale:{en:'Budget to scale · Actual / Encumbrance / Fund',ar:'الموازنة بمقياس موحد · الفعلي / الالتزامات / الرصيد'},
    fdOfTotal:{en:'of total',ar:'من الإجمالي'},
    fdOfBudget:{en:'of budget',ar:'من الموازنة'},
    fdCommitted:{en:'committed',ar:'ملتزم به'},
    fdFree:{en:'free',ar:'متاح'},
    fdFundShort:{en:'Fund',ar:'الرصيد'},
    fdStOk:{en:'On track',ar:'ضمن الحد'},
    fdStTight:{en:'Tight',ar:'قريب من الحد'},
    fdStOver:{en:'Over committed',ar:'تجاوز الالتزام'},
    fdShowing:{en:'Showing {a} of {b}',ar:'عرض {a} من {b}'},
    fdShowAll:{en:'Show all {n} departments',ar:'عرض جميع الإدارات ({n})'},
    fdShowTop:{en:'Show top {n} only',ar:'عرض أعلى {n} فقط'},
    fdSortBudget:{en:'Sort: Budget',ar:'الترتيب: الموازنة'},
    fdSortUsed:{en:'Sort: % used',ar:'الترتيب: % المستخدم'},
    fdSortFree:{en:'Sort: % free',ar:'الترتيب: % المتاح'},
    fdTmArea:{en:'Tile area = share of budget',ar:'مساحة المربع = الحصة من الموازنة'},
    fdTmFill:{en:'Fill = % consumed (Actual + Encumbrance):',ar:'اللون = % المستهلك (الفعلي + الالتزامات):'},
    fdTmOver:{en:'over committed',ar:'تجاوز الالتزام'},
    /* ── Financial Performance Report (FMR_Dashboard.pdf replica, GL/db/37) ── */
    navFmr:{en:'Financial Performance',ar:'الأداء المالي'},
    fmrTitle:{en:'Financial Performance Report',ar:'تقرير الأداء المالي'},
    fmrSub:{en:'Budget Overview — Entity & Sector Level',ar:'نظرة عامة على الموازنة — مستوى الجهة والقطاع'},
    fmrEntityLevel:{en:'Budget Overview — Entity Level',ar:'نظرة عامة على الموازنة — مستوى الجهة'},
    fmrSectorLevel:{en:'Budget Overview — Sector Level',ar:'نظرة عامة على الموازنة — مستوى القطاع'},
    fmrTrend:{en:'YTD Trend by Type',ar:'الاتجاه التراكمي حسب النوع'},
    fmrCurrentVariance:{en:'Current Month Variances',ar:'تباينات الشهر الحالي'},
    fmrExpectedVariance:{en:'Expected Variances',ar:'التباينات المتوقعة'},
    fmrNoteSave:{en:'Save',ar:'حفظ'},
    fmrNoteEmpty:{en:'No variances recorded for this period yet.',ar:'لا توجد تباينات مسجلة لهذه الفترة بعد.'},
    fmrNotePlaceholder:{en:'Type a note for this period…',ar:'اكتب ملاحظة لهذه الفترة…'},
    fmrNoteUpdated:{en:'Updated {by} on {at}',ar:'حدّثه {by} في {at}'},
    fmrEntityFilter:{en:'Entity',ar:'الجهة'},
    fmrComments:{en:'Comments',ar:'التعليقات'},
    fmrNoPlan:{en:'No plan uploaded',ar:'لا توجد خطة محملة'},
    fmrPlanPartialNote:{en:'YTD Plan combines the Payroll GL Cashflow upload with the Opex/Capex project cashflow plan. An entity or sector with no uploaded plan shows "—" instead of 0%.',ar:'تجمع الخطة حتى تاريخه بين تحميل التدفق النقدي للرواتب وخطة التدفق النقدي للمشاريع (التشغيلية/الرأسمالية). الجهة أو القطاع بلا خطة محملة يظهر "—" بدلاً من 0%.'},
    fmrUnclassifiedNote:{en:'Unclassified = budgeted GL combinations with no matching classification yet (mostly unspent).',ar:'غير مصنّف = تركيبات موازنة لم تُصنّف بعد (غالباً غير منفقة).'},
    fmrSectorTbl:{en:'Sector',ar:'القطاع'},
    fmrYtdPlan:{en:'YTD Plan',ar:'الخطة حتى تاريخه'},
    fmrKpiDrillHint:{en:'Click to view supporting GL combinations',ar:'انقر لعرض التركيبات المحاسبية الداعمة'},
    fmrGenReport:{en:'Generate Report',ar:'إنشاء تقرير'},
    fmrReportSoon:{en:'Report generation coming soon',ar:'إنشاء التقارير قريباً'},
    fmrRepPdfSub:{en:'FMR Budget Overview book',ar:'كتيب نظرة عامة على الميزانية'},
    fmrRepXlsxSub:{en:'Sheet-per-section workbook',ar:'مصنف بورقة لكل قسم'},
    fmrRepPptSub:{en:'Executive slide deck',ar:'عرض شرائح تنفيذي'},
    fmrRepReady:{en:'Report downloaded',ar:'تم تنزيل التقرير'},
    fmrRepFailed:{en:'Report download failed',ar:'فشل تنزيل التقرير'},
    fmrHintBudget:{en:'YTD approved budget to the selected period. Scope: Budget Group 1 · Chapters 1–3 (Payroll, Opex, Capex) only.',ar:'الميزانية المعتمدة منذ بداية السنة حتى الفترة المختارة. النطاق: مجموعة الميزانية 1 · الفصول 1–3 (الرواتب، التشغيلية، الرأسمالية) فقط.'},
    fmrHintActual:{en:'YTD GL actuals for the same scope. Actual vs Budget = Actual ÷ Budget × 100. Click to open the supporting GL combinations.',ar:'المصروف الفعلي من دفتر الأستاذ حتى الفترة لنفس النطاق. الفعلي مقابل الميزانية = الفعلي ÷ الميزانية × 100. انقر لعرض التركيبات الداعمة.'},
    fmrHintPlan:{en:'YTD expenditure plan = the Payroll plan upload (Chapter 1) + the projects cashflow plan (Chapters 2–3), summed to the selected period. Plan vs Budget = Plan ÷ Budget × 100.',ar:'خطة الإنفاق التراكمية = خطة الرواتب المحمّلة (الفصل 1) + خطة التدفق النقدي للمشاريع (الفصلان 2 و3) حتى الفترة المختارة. الخطة مقابل الميزانية = الخطة ÷ الميزانية × 100.'},
    fmrHintActPlan:{en:'Actual ÷ YTD Plan × 100 — the spending pace against the plan. When no plan is loaded, no figure is shown (never fabricated).',ar:'الفعلي ÷ الخطة التراكمية × 100 — وتيرة الإنفاق مقارنة بالخطة. لا يُعرض رقم عند عدم وجود خطة محمّلة.'},
    fmrHintFunds:{en:'GL Funds Available at the selected period = Budget − actuals − encumbrances (the ledger figure, not re-derived).',ar:'الأموال المتاحة في دفتر الأستاذ عند الفترة المختارة = الميزانية − الفعلي − الارتباطات (رقم الدفتر كما هو).'},
    fmrHintGauge:{en:'Gauge = Actual vs Budget %. The entity comes from the combination\'s entity-specific segment: ALC 4510600 · Museums 4510700 · Masterpieces = appropriation 301439 (carved out of DCT).',ar:'العداد = نسبة الفعلي مقابل الميزانية. تُحدد الجهة من مقطع الكيان في التركيبة: ALC 4510600 · المتاحف 4510700 · المقتنيات = الاعتماد 301439 (مستثناة من DCT).'},
    fmrHintTrend:{en:'Budget vs Actual vs YTD Plan per type — Payroll = Chapter 1, Opex = Chapter 2, Capex = Chapter 3. Click any bar to open its supporting GL lines.',ar:'الميزانية مقابل الفعلي مقابل الخطة لكل نوع — الرواتب = الفصل 1، التشغيلية = الفصل 2، الرأسمالية = الفصل 3. انقر أي عمود لعرض بنوده الداعمة.'},
    fmrHintSector:{en:'Sectors ranked by Actual vs YTD Plan % (highest pace first). The entity buttons filter the split; the Comments button opens that sector\'s period comments.',ar:'القطاعات مرتبة حسب نسبة الفعلي مقابل الخطة (الأعلى أولاً). أزرار الجهات ترشّح التقسيم؛ وزر التعليقات يفتح تعليقات القطاع للفترة.'},
    fmrEntDct:{en:'DCT',ar:'الدائرة'},
    fmrEntAlc:{en:'ALC',ar:'مركز اللغة العربية'},
    fmrEntMuseums:{en:'Museums',ar:'المتاحف'},
    fmrEntMasterpieces:{en:'Masterpieces',ar:'روائع فنية'},
    fmrEntUnclassified:{en:'Unclassified',ar:'غير مصنّف'}
  };

  function VM() {
    var self = this;
    self.root = self;

    /* ── language / shell ── */
    self.lang = ko.observable(localStorage.getItem('gl_lang') || 'en');
    self.t = function (k) { var e = STR[k]; return e ? (e[self.lang()] || e.en) : k; };
    function applyDir() { document.documentElement.dir = self.lang() === 'ar' ? 'rtl' : 'ltr'; document.documentElement.lang = self.lang(); }
    self.toggleLang = function () {
      self.lang(self.lang() === 'en' ? 'ar' : 'en'); localStorage.setItem('gl_lang', self.lang()); applyDir();
      // keep the shared layer (used by the <interactive-report> component) in sync
      if (window._sharedI18n) { try { window._sharedI18n.setLang(self.lang(), { system: true }); } catch (e) {} }
    };
    applyDir();
    self.ready = ko.observable(false);
    // landing page = Projects › Budget Utilization (the day-to-day page)
    self.view = ko.observable('butil');

    /* caller capability flags for Budget Utilization Comments — defined BEFORE
       NAV_GROUPS because the settings sub-tabs' hidden() functions read it
       (loaded once at boot from /butilcmt/meta/caps, further down) */
    self.cmtCaps = ko.observable({});
    // Terms and Key definitions caps (NAV hidden() reads it; boot fetch below)
    self.termsCaps = ko.observable({});

    /* ── navigation: three groups, each with its own sub-tabs ───────────
       Adding a page = one entry here; the group row, the sub row and the
       deep-link-to-group resolution all follow from this list. */
    var NAV_GROUPS = [
      { id: 'projects', labelKey: 'grpProjects', items: [
          { id: 'portfolio',    labelKey: 'navPortfolio' },
          // proj360 must be IN this list -- activeGroup() scans it to decide
          // which group lights up -- but it is hidden from the sub-tab row
          // until a project is actually open, because a 360 with no project
          // selected is a dead tab.
          { id: 'proj360',      labelKey: 'navProj360', hidden: true },
          { id: 'butil',        labelKey: 'navButil' },
          { id: 'encumbrances', labelKey: 'navEncumbrances' },
          { id: 'pending',      labelKey: 'navPending' },
          { id: 'costadj',      labelKey: 'navCostAdj' },
          { id: 'comments',     labelKey: 'navComments' },
          { id: 'budgettrx',    labelKey: 'navBudgetTrx' },
          { id: 'sectorperf',   labelKey: 'navSectorPerf' },
          { id: 'cashflow',     labelKey: 'navCashflow' },
          { id: 'emaillog',     labelKey: 'navEmailLog' } ] },
      { id: 'gl', labelKey: 'grpGl', items: [
          { id: 'dashboard', labelKey: 'navDashboard' },
          { id: 'fmr',       labelKey: 'navFmr' },
          { id: 'fd',        labelKey: 'navFd' },
          { id: 'actuals',   labelKey: 'navActuals' },
          { id: 'recon',     labelKey: 'navRecon' },
          { id: 'legacy',    labelKey: 'navLegacy' },
          { id: 'dof',       labelKey: 'navDof' },
          { id: 'yoy',       labelKey: 'navYoy' } ] },
      { id: 'settings', labelKey: 'grpSettings', items: [
          { id: 'overview', labelKey: 'navOverview' },
          { id: 'revcats', labelKey: 'navRevenueCategories' },
          { id: 'recipients', labelKey: 'navRecipients' },
          // capability-gated admin pages (Budget Utilization Comments):
          // hidden() is re-evaluated by the activeGroupItems computed, so the
          // tabs appear as soon as /butilcmt/meta/caps lands
          { id: 'cmtroles',   labelKey: 'navCmtRoles',
            hidden: function () { return self.cmtCaps().canManageRoles !== 'Y'; } },
          { id: 'cmtperiods', labelKey: 'navCmtPeriods',
            hidden: function () { return self.cmtCaps().canClosePeriod !== 'Y'; } },
          // Terms and Key definitions -- rich-text report intro documents
          // (GL_MANAGE_TERMS / SYS_ADMIN only; caps land from /terms/meta/caps)
          { id: 'terms', labelKey: 'navTerms',
            hidden: function () { return self.termsCaps().canManage !== 'Y'; } } ] }
    ];
    self.navGroups = NAV_GROUPS;
    // ── URL hash deep links: #<tab id> or a friendly alias (#budget-status).
    // go() mirrors the route into the hash, so F5 / bookmarks / shared links
    // restore the same tab; unknown hashes fall back to the default page.
    var HASH_ALIAS = { 'budget-status': 'fd' };   // inbound friendly names
    var HASH_LABEL = { fd: 'budget-status' };     // outbound: what the bar shows
    function routeFromHash() {
      var h = (location.hash || '').replace(/^#/, '');
      if (!h) return null;
      try { h = decodeURIComponent(h); } catch (e) {}
      if (HASH_ALIAS[h]) h = HASH_ALIAS[h];
      for (var gi = 0; gi < NAV_GROUPS.length; gi++) {
        var its = NAV_GROUPS[gi].items;
        for (var ii = 0; ii < its.length; ii++) if (its[ii].id === h) return h;
      }
      return null;
    }
    // derived from the view, so a deep link lands on the right group
    self.activeGroup = ko.computed(function () {
      var v = self.view();
      for (var i = 0; i < NAV_GROUPS.length; i++)
        for (var j = 0; j < NAV_GROUPS[i].items.length; j++)
          if (NAV_GROUPS[i].items[j].id === v) return NAV_GROUPS[i].id;
      return 'projects';
    });
    self.activeGroupItems = ko.computed(function () {
      var g = self.activeGroup(), v = self.view();
      for (var i = 0; i < NAV_GROUPS.length; i++)
        if (NAV_GROUPS[i].id === g)
          return NAV_GROUPS[i].items.filter(function (it) {
            var h = (typeof it.hidden === 'function') ? it.hidden() : it.hidden;
            return !h || it.id === v;          // hidden tabs appear only while open
          });
      return [];
    });
    // clicking a group header opens its first page
    self.goGroup = function (gid) {
      for (var i = 0; i < NAV_GROUPS.length; i++)
        if (NAV_GROUPS[i].id === gid) { self.go(NAV_GROUPS[i].items[0].id); return; }
    };
    self.userName = session.displayName || session.username || '';
    self.initials = (function () { var n = (self.userName || '').split(' ').filter(Boolean); return ((n[0] || ' ')[0] + ((n[1] || '')[0] || '')).toUpperCase(); })();
    self.dimName = function (d) { return self.lang() === 'ar' ? (d.nameAr || d.nameEn) : d.nameEn; };

    /* ── Budget Transactions (PA_BUDGET_TRX_*, loaded by the ATD PBT extract)
       Mirrors the source screen: criteria → header grid → details of the
       selected header → its approval trail. Selecting a header row is what
       loads the two child regions, exactly as the source page behaves. */
    self.btFilters   = ko.observable(null);
    self.btLoaded    = ko.observable(false);
    self.btBusy      = ko.observable(false);
    self.btRows      = ko.observableArray([]);
    self.btTotal     = ko.observable(0);
    self.btPage      = ko.observable(1);
    self.btSize      = ko.observable(100);
    self.btSelected  = ko.observable(null);   // the chosen header row
    self.btDetail    = ko.observable(null);   // {header, lines[], approvals[]}
    self.btDetailBusy = ko.observable(false);
    self.btError     = ko.observable('');
    // criteria — same field set as the source screen
    self.btcType     = ko.observable('');
    self.btcBu       = ko.observable('');
    self.btcProjType = ko.observable('');
    self.btcStatus   = ko.observable('');
    self.btcYear     = ko.observable('');
    self.btcApprover = ko.observable('');
    self.btcTrxNum   = ko.observable('');
    self.btcDecree   = ko.observable('');
    self.btcFrom     = ko.observable('');
    self.btcTo       = ko.observable('');
    /* the LINE-level criteria — Budget Utilization parity (v1.65.0). These do
       not filter the header row; the server matches a transaction when ONE OF
       ITS LINES satisfies all of them (GL/db/20 over V_PA_BUDGET_TRX_LINE). */
    self.btcSector   = ko.observable('');
    self.btcChapter  = ko.observable('');
    self.btcProgram  = ko.observable('');
    self.btcApprop   = ko.observable('');
    self.btcCc       = ko.observable('');
    self.btcProject  = ko.observable('');
    self.btcTask     = ko.observable('');
    self.btcEtype    = ko.observable('');
    self.btcPeriod   = ko.observable('');
    self.btcSearch   = ko.observable('');
    // the four big type-ahead lists (own endpoint, like /butil/lov)
    self.btProjects  = ko.observableArray([]);
    self.btTasks     = ko.observableArray([]);
    self.btEtypes    = ko.observableArray([]);
    self.btCcs       = ko.observableArray([]);

    self.btPages = ko.computed(function () {
      return Math.max(1, Math.ceil(self.btTotal() / self.btSize()));
    });

    /* the page's opening scope (user-chosen 2026-08-17). Each is applied only
       when the live LOV actually offers it — a hard-coded value that no longer
       exists would be blanked by KO's options binding anyway, leaving the
       observable and the <select> disagreeing. Year is not listed: it is
       always "the current year, else the newest with data". */
    var BT_DEFAULTS = {
      type:     'Additional',                        // Additional Fund
      bu:       'Department of Culture and Tourism',
      projType: 'DCT OPEX Project Type'              // same default as Budget Utilization
    };
    // setting four observables fires four subscriptions; without this the page
    // would re-fetch its lists three times before it had even searched once
    var btApplying = false;
    self.btApplyDefaults = function (d, force) {
      d = d || self.btFilters() || {};
      btApplying = true;
      var has = function (list, v) { return (list || []).indexOf(v) >= 0; };
      if (force || !self.btcType()) {
        var codes = (d.types || []).map(function (t) { return t.code; });
        self.btcType(has(codes, BT_DEFAULTS.type) ? BT_DEFAULTS.type : (codes[0] || ''));
      }
      if (force || !self.btcYear()) {
        var now = String(new Date().getFullYear());
        self.btcYear(has(d.years, now) ? now : ((d.years || [])[0] || ''));
      }
      if (force || !self.btcBu()) {
        self.btcBu(has(d.businessUnits, BT_DEFAULTS.bu) ? BT_DEFAULTS.bu : '');
      }
      if (force || !self.btcProjType()) {
        self.btcProjType(has(d.projectTypes, BT_DEFAULTS.projType) ? BT_DEFAULTS.projType : '');
      }
      btApplying = false;
      self.btRescope();
    };

    self.loadBtFilters = function () {
      var hadScope = !!(self.btcType() && self.btcYear());
      return api('GET', '/budgettrx/filters' + qs({ type: self.btcType(), year: self.btcYear(),
                                                    bu: self.btcBu(), projecttype: self.btcProjType() }))
        .then(function (d) {
          self.btFilters(d);
          // Budget Type and Year are MANDATORY (the server 400s without them),
          // so the page opens on a real scope rather than an error
          self.btApplyDefaults(d);
          // That first call had no scope, so its line-derived lists (sectors,
          // chapters, …) span every type and year. Setting the defaults above
          // fires btRescope, which re-fetches them for the scope — so DON'T
          // re-fetch here too, or page open costs two identical calls.
          if (!hadScope) return;
          self.loadBtLov();
        }).catch(function (e) { self.btError(e.message || String(e)); });
    };
    /* changing the scope invalidates every in-scope list.
       DEBOUNCED, and that is load-bearing: applying the four defaults fires
       four subscriptions, and KO's <select> write-back means some of them land
       a tick later, so a plain "am I still applying?" flag let a half-built
       scope (type+year, no BU) through and fetched the lists twice. Coalescing
       into one tick makes the number of calls independent of firing order. */
    var btScopeKey = '', btScopeTimer = null;
    self.btRescope = function () {
      if (btApplying) return;
      clearTimeout(btScopeTimer);
      btScopeTimer = setTimeout(function () {
        var k = [self.btcType(), self.btcYear(), self.btcBu(), self.btcProjType()].join('|');
        if (!self.btcType() || !self.btcYear() || k === btScopeKey) return;
        btScopeKey = k;
        self.loadBtFilters();
      }, 60);
    };
    // 886 projects + 1,825 tasks + 184 expenditure types + 115 cost centres:
    // too big for the criteria payload, so they load once beside it and feed
    // the <datalist> autocompletes — the same split the Budget Utilization
    // page makes between /butil/filters and /butil/lov.
    var btLovKey = '';
    self.loadBtLov = function () {
      var key = [self.btcType(), self.btcYear(), self.btcBu(), self.btcProjType()].join('|');
      if (!self.btcType() || !self.btcYear() || key === btLovKey) return Promise.resolve();
      btLovKey = key;
      return api('GET', '/budgettrx/lov' + qs({ type: self.btcType(), year: self.btcYear(),
                                                bu: self.btcBu(), projecttype: self.btcProjType() }))
        .then(function (d) {
          self.btProjects(d.projects || []); self.btTasks(d.tasks || []);
          self.btEtypes(d.etypes || []);     self.btCcs(d.costCenters || []);
        }).catch(function () {
          // a failed autocomplete list must never break the page: the criteria
          // are free-text inputs, they just lose their suggestions
          btLovKey = '';
        });
    };
    // every list on this page belongs to the chosen type+year, so both the
    // criteria LOVs and the type-aheads refresh when either moves
    self.btcType.subscribe(function () { self.btRescope(); });
    self.btcYear.subscribe(function () { self.btRescope(); });
    self.btcBu.subscribe(function () { self.btRescope(); });
    self.btcProjType.subscribe(function () { self.btRescope(); });
    // how many line-level criteria are active — drives the "N filters" chip
    self.btLineFilterCount = ko.computed(function () {
      return [self.btcSector(), self.btcChapter(), self.btcProgram(), self.btcApprop(),
              self.btcCc(), self.btcProject(), self.btcTask(), self.btcEtype(),
              self.btcPeriod()].filter(function (v) { return !!v; }).length;
    });

    self.runBudgetTrx = function (page) {
      // mandatory scope — say so here rather than letting the server 400
      if (!self.btcType() || !self.btcYear()) {
        self.btError(self.t('btScopeRequired'));
        self.btRows([]); self.btTotal(0); self.btLoaded(true);
        return Promise.resolve();
      }
      self.btBusy(true);
      self.btError('');
      if (page) self.btPage(page);
      // a new search invalidates the child regions
      self.btSelected(null); self.btDetail(null);
      return api('GET', '/budgettrx' + qs({
        type: self.btcType(), bu: self.btcBu(), projecttype: self.btcProjType(),
        status: self.btcStatus(), year: self.btcYear(), approver: self.btcApprover(),
        trxnum: self.btcTrxNum(), decree: self.btcDecree(),
        from: self.btcFrom(), to: self.btcTo(),
        sector: self.btcSector(), chapter: self.btcChapter(),
        program: self.btcProgram(), appropriation: self.btcApprop(),
        costcenter: self.btcCc(), project: self.btcProject(),
        task: self.btcTask(), etype: self.btcEtype(),
        period: self.btcPeriod(), search: self.btcSearch(),
        page: self.btPage(), size: self.btSize()
      })).then(function (d) {
        self.btRows(d.items || []);
        self.btTotal(d.total || 0);
        self.btLoaded(true);
      }).catch(function (e) {
        self.btError(e.message || String(e)); self.btRows([]); self.btTotal(0);
      }).then(function () { self.btBusy(false); });
    };

    self.btSearch = function () { self.runBudgetTrx(1); };
    self.btClearCriteria = function () {
      // Clear resets to the DEFAULT SCOPE, not to empty: Budget Type and Year
      // are mandatory, so clearing them would produce an error instead of rows,
      // and Business Unit / Project Type go back to the chosen defaults too
      self.btApplyDefaults(null, true);
      self.btcStatus('');
      self.btcApprover(''); self.btcTrxNum(''); self.btcDecree('');
      self.btcFrom(''); self.btcTo('');
      self.btcSector(''); self.btcChapter(''); self.btcProgram(''); self.btcApprop('');
      self.btcCc(''); self.btcProject(''); self.btcTask(''); self.btcEtype('');
      self.btcPeriod(''); self.btcSearch('');
      self.runBudgetTrx(1);
    };
    self.btPrevPage = function () {
      if (self.btPage() > 1) self.runBudgetTrx(self.btPage() - 1);
    };
    self.btNextPage = function () {
      if (self.btPage() < self.btPages()) self.runBudgetTrx(self.btPage() + 1);
    };

    // row click → load the details + approval trail for that header
    self.btSelectRow = function (row) {
      self.btSelected(row);
      self.btDetail(null);
      self.btDetailBusy(true);
      api('GET', '/budgettrx/' + encodeURIComponent(row.transactionNum)
                 + qs({ type: row.transactionType }))
        .then(function (d) { self.btDetail(d); })
        .catch(function (e) { self.btError(e.message || String(e)); })
        .then(function () { self.btDetailBusy(false); });
    };
    self.btIsSelected = function (row) {
      var s = self.btSelected();
      return !!s && s.transactionNum === row.transactionNum
                 && s.transactionType === row.transactionType;
    };

    // the line columns differ per budget type, so the table is metadata-driven
    var BT_LINE_COLS = {
      'Additional': [
        ['projectNum', 'btProject'], ['projectName', ''], ['taskNum', 'btTask'],
        ['taskName', ''], ['organization', 'btOrganization'],
        ['expenditureType', 'btExpType'], ['codeCombination', 'btCodeComb'],
        ['additionalAmount', 'btAmount', 1], ['commitment', '', 1],
        ['totalAnnualBudget', '', 1], ['projectFundAvailable', '', 1],
        ['totalActual', '', 1], ['periodFrom', 'btPeriod'], ['periodTo', ''],
        ['lineStatus', 'btLineStatus', 0, 1], ['baselineStatus', 'btBaseline', 0, 1],
        ['journalStatus', 'btJournal', 0, 1], ['notes', 'btNotes']
      ],
      'Estimated-Cost': [
        ['projectNum', 'btProject'], ['projectName', ''], ['taskNum', 'btTask'],
        ['taskName', ''], ['organization', 'btOrganization'],
        ['expenditureType', 'btExpType'], ['codeCombination', 'btCodeComb'],
        ['estimatedCost', 'btAmount', 1], ['currentYearBudget', '', 1],
        ['glFundAvailable', '', 1], ['lineStatus', 'btLineStatus', 0, 1],
        ['baselineStatus', 'btBaseline', 0, 1], ['notes', 'btNotes']
      ],
      'Annual-Budget': [
        ['projectNum', 'btProject'], ['projectName', ''], ['taskNum', 'btTask'],
        ['taskName', ''], ['organization', 'btOrganization'],
        ['expenditureType', 'btExpType'], ['codeCombination', 'btCodeComb'],
        ['approvedBudget', 'btAmount', 1], ['proposedBudget', '', 1],
        ['revisedProjectCost', '', 1], ['availableProjectCost', '', 1],
        ['totalActual', '', 1], ['baselineStatus', 'btBaseline', 0, 1],
        ['journalStatus', 'btJournal', 0, 1], ['notes', 'btNotes']
      ]
    };
    function btLabel(key, fallback) {
      if (key) return self.t(key);
      // no i18n key: derive a readable header from the field name
      return fallback.replace(/([A-Z])/g, ' $1').replace(/^./, function (c) { return c.toUpperCase(); });
    }
    self.btLineCols = ko.computed(function () {
      var d = self.btDetail();
      if (!d || !d.header) return [];
      var spec = BT_LINE_COLS[d.header.transactionType] || BT_LINE_COLS['Additional'];
      return spec.map(function (c) {
        return { field: c[0], label: btLabel(c[1], c[0]), num: !!c[2], st: !!c[3] };
      });
    });
    self.btCell = function (row, col) {
      var v = row[col.field];
      if (v === null || v === undefined || v === '') return '';
      // money honours the SHARED "Figures in" setting (buUnit) like every other
      // GL page; 'X' (Exact) is the one that keeps the fils
      return col.num ? self.buNum(v) : v;
    };

    /* ── status tone ────────────────────────────────────────────────────
       The source vocabulary is inconsistent in BOTH case and wording -- the
       live data holds SUCCESS and Success, PASS and Pass, Draft and DRAFT --
       so tones are matched case-insensitively on keywords, never on equality.
       ORDER IS LOAD-BEARING: "Baselining Failed" also contains "baselin", so
       the failure patterns must be tested before the success ones or a failed
       transaction would render green. */
    var BT_TONES = [
      [/fail|error|reject/i,                     'err'],
      [/pend|in\s*process|in\s*progress/i,       'warn'],
      [/success|pass|approve|baselined|complet/i, 'ok'],
      [/draft|not\s*created|withdraw|cancel/i,   'mute'],
      [/entered|new|open/i,                      'info']
    ];
    self.btTone = function (v) {
      var s = (v == null ? '' : String(v)).trim();
      if (!s) return 'mute';
      for (var i = 0; i < BT_TONES.length; i++) if (BT_TONES[i][0].test(s)) return BT_TONES[i][1];
      return 'info';
    };
    // class for a status cell -- '' when there is no value, so an empty cell
    // stays empty instead of rendering a pill around nothing
    self.btStClass = function (v) {
      return (v == null || String(v).trim() === '') ? '' : 'st st--' + self.btTone(v);
    };
    // details grid: status columns become pills, negative amounts turn red
    self.btCellClass = function (row, col) {
      var v = row[col.field];
      if (col.st) return self.btStClass(v);
      if (col.num && Number(v) < 0) return 'neg';
      return '';
    };
    self.btCountClass = function (n) { return Number(n) > 0 ? 'ct' : 'ct zero'; };

    self.btExportCsv = function () {
      var rows = self.btRows();
      if (!rows.length) return;
      var cols = ['transactionNum', 'transactionType', 'businessUnit', 'projectType',
                  'decreeNo', 'transactionDate', 'trxYear', 'approver', 'status',
                  'organization', 'lines', 'approvals'];
      var out = [cols.join(',')];
      rows.forEach(function (r) {
        out.push(cols.map(function (c) {
          var v = r[c] == null ? '' : String(r[c]);
          return /[",\n]/.test(v) ? '"' + v.replace(/"/g, '""') + '"' : v;
        }).join(','));
      });
      var blob = new Blob(['﻿' + out.join('\n')], { type: 'text/csv;charset=utf-8;' });
      var a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = 'budget-transactions.csv';
      a.click();
      setTimeout(function () { URL.revokeObjectURL(a.href); }, 4000);
    };

    // Security Info drawer (SYS_ADMIN only) — reads the Security Console page
    // registry for the ACTIVE tab. Portal-style twin of <security-info>.
    self.isSysAdmin = ((session.rolesCsv || '').split(',').indexOf('SYS_ADMIN') >= 0);
    self.secDrawer = ko.observable(false);
    self.secLoading = ko.observable(false);
    self.secErr = ko.observable('');
    self.secInfo = ko.observable(null);
    self.secArts = ko.observableArray([]);
    self.secIr = ko.observable(null);
    self.secIrSection = ko.computed(function () { return 'GL_' + self.view(); });
    function buildSecIr(arts) {
      var ar = self.lang() === 'ar';
      var cols = [
        { key: 'type',      label: ar ? 'النوع' : 'Type',            type: 'text' },
        { key: 'label',     label: ar ? 'العنصر' : 'Artifact',       type: 'text' },
        { key: 'code',      label: ar ? 'المفتاح' : 'Key',           type: 'text' },
        { key: 'privCode',  label: ar ? 'الصلاحية' : 'Privilege',    type: 'text' },
        { key: 'privName',  label: ar ? 'اسم الصلاحية' : 'Privilege Name', type: 'text' },
        { key: 'grantedTo', label: ar ? 'ممنوحة إلى' : 'Granted To', type: 'text' }
      ];
      var rows = (arts || []).map(function (a) {
        return {
          type: a.type, label: a.label || a.code, code: a.code,
          privCode: a.privCode || (ar ? 'غير مؤمّن' : 'not secured'),
          privName: a.privName || '',
          grantedTo: (a.grantedTo || []).map(function (g) { return g.name || g.code; }).join(', ')
        };
      });
      self.secIr({ columns: cols, items: rows, total: rows.length,
                   truncated: false, maxRows: rows.length });
    }
    self.openSecurityInfo = function () {
      var page = self.view();
      self.secDrawer(true); self.secLoading(true); self.secErr('');
      self.secInfo(null); self.secArts([]);
      fetch('/ords/admin/dct/sec/pageinfo?module=GL&page=' + encodeURIComponent(page),
            { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) {
          if (r.status === 404) { throw new Error('notreg'); }
          if (!r.ok) { throw new Error('HTTP ' + r.status); }
          return r.json();
        })
        .then(function (d) { self.secInfo(d); self.secArts(d.artifacts || []); buildSecIr(d.artifacts || []); })
        .catch(function (e) {
          self.secErr(e.message === 'notreg'
            ? 'This page is not registered in the security catalog yet.'
            : ('Load failed: ' + e.message));
        })
        .then(function () { self.secLoading(false); });
    };
    self.closeSecurityInfo = function () { self.secDrawer(false); };

    self.loading = ko.observable(false);
    self.modalErr = ko.observable('');

    self.toast = ko.observable(''); self.toastBad = ko.observable(false);
    function toast(m, bad) { self.toastBad(!!bad); self.toast(m); setTimeout(function () { self.toast(''); }, 2600); }
    function fail(e) { self.modalErr(e.message || 'Error'); toast(e.message || 'Error', true); }
    self.fmt = function (n) { return (n || 0).toLocaleString('en-US'); };

    /* ── app switcher (jump to other i-Finance apps) ── */
    self.modules = [
      { code: 'iF', name: 'Admin',            color: '#C74634', url: '/dct/index.html' },
      { code: 'PC', name: 'Petty Cash',       color: '#2E7D32', url: '/PC/Jet/index.html' },
      { code: 'CC', name: 'Credit Cards',     color: '#B0721E', url: '/CC/Jet/index.html' },
      { code: 'FL', name: 'Freelancers',      color: '#7C4DBE', url: '/FL/Jet/index.html' },
      { code: 'DT', name: 'Duty Travel',      color: '#0572CE', url: '/DT/Jet/index.html' },
      { code: 'HR', name: 'HR',               color: '#1a7f5a', url: '/HR/Jet/index.html' },
      { code: 'AR', name: 'Event P&L',        color: '#6C4AB6', url: '/AR/Jet/index.html' },
      { code: 'TM', name: 'Task Management',  color: '#0E8A8A', url: '/TM/Jet/index.html' },
      { code: 'AT', name: 'Analytics Loader', color: '#3A4FB0', url: '/ATD/Jet/index.html' },
      { code: 'GL', name: 'General Ledger',   color: '#3F6F5F', url: '/GL/Jet/index.html' },
      { code: 'K2', name: 'Finance KPIs V2',  color: '#3F6F5F', url: '/KPI-V2/Jet/index.html' }
    ];
    self.switcherOpen = ko.observable(false);
    self.toggleSwitcher = function () { self.switcherOpen(!self.switcherOpen()); };
    self.goHome = function () { location.href = '/dct/index.html'; };

    /* ── styled full-segment hover popover for a combination row ── */
    self.tipRows = ko.observableArray([]);
    self.tipShow = ko.observable(false);
    self.tipX = ko.observable(0); self.tipY = ko.observable(0);
    // desc fields differ by source: Explorer/Actuals rows carry *Desc, the
    // Projects-Encumbrances IR rows carry *Name — accept either.
    function comboRows(r) {
      return [
        { label: self.t('segEntity'),        code: r.entityCode,         desc: r.entityDesc || r.entityName },
        { label: self.t('segCostCenter'),    code: r.costCenterCode,     desc: r.costCenterDesc || r.costCenterName },
        { label: self.t('segAccount'),       code: r.accountCode,        desc: r.accountDesc || r.accountName },
        { label: self.t('segAppropriation'), code: r.appropriationCode,  desc: r.appropriationDesc || r.appropriationName },
        { label: self.t('segBudgetGroup'),   code: r.budgetGroupCode,    desc: r.budgetGroupDesc || r.budgetGroupName },
        { label: self.t('segEntitySpecific'),code: r.entitySpecificCode, desc: r.entitySpecificDesc || r.entitySpecificName },
        { label: self.t('segFuture1'),       code: r.future1Code,        desc: r.future1Desc || r.future1Name },
        { label: self.t('segFuture2'),       code: r.future2Code,        desc: r.future2Desc || r.future2Name },
        { label: self.t('segIntercompany'),  code: r.intercompanyCode,   desc: r.intercompanyDesc || r.intercompanyName },
        { label: self.t('segProgram'),       code: r.programCode,        desc: r.programDesc || r.programName }
      ];
    }
    function place(e) {
      var w = 470, x = e.clientX + 16, y = e.clientY + 14;
      if (x + w > window.innerWidth) x = e.clientX - w - 16;
      if (y + 340 > window.innerHeight) y = Math.max(12, window.innerHeight - 350);
      self.tipX(x); self.tipY(y);
    }
    self.comboHover = function (r, e) { self.tipRows(comboRows(r)); place(e); self.tipShow(true); return true; };
    self.comboMove  = function (r, e) { place(e); return true; };
    self.comboOut   = function () { self.tipShow(false); return true; };

    /* ── same combination popover over the shared <interactive-report> grid ──
       The IR component owns its cells, so we delegate on the encumbrance wrapper
       and resolve the hovered cell's row/column from its KO binding context
       (ko.contextFor): $data = the column, $parent.row = the row. Only the
       'combination' column triggers the hint. Keeps the whole feature GL-side —
       no change to the shared component. */
    function enResolveCell(target) {
      var td = (target && target.closest) ? target.closest('td') : null;
      if (!td) return null;
      var ctx;
      try { ctx = ko.contextFor(td); } catch (e) { return null; }
      if (!ctx || !ctx.$parent || !ctx.$parent.row || !ctx.$data) return null;
      return { td: td, row: ctx.$parent.row, col: ctx.$data };
    }
    function enIsCombo(info) { return !!(info && info.col && info.col.key === 'combination' && info.row); }
    self.enGridOver = function (d, e) {
      var info = enResolveCell(e.target);
      if (enIsCombo(info)) { info.td.style.cursor = 'help'; self.comboHover(info.row, e); }
      else self.comboOut();
      return true;
    };
    self.enGridMove = function (d, e) {
      if (!self.tipShow()) return true;
      var info = enResolveCell(e.target);
      if (enIsCombo(info)) self.comboMove(info.row, e); else self.comboOut();
      return true;
    };
    self.enGridOut = function (d, e) {
      // only hide when the pointer actually leaves the grid wrapper (mouseout
      // bubbles on every inner boundary — otherwise the tip would flicker)
      if (!e.relatedTarget || !e.currentTarget.contains(e.relatedTarget)) self.comboOut();
      return true;
    };

    self.go = function (v) {
      // Classifications, Segment Mapping and Explorer are now regions of the
      // Chart of Accounts (overview) page — redirect any legacy nav/deep-link.
      if (v === 'classifications' || v === 'mapping' || v === 'explorer') v = 'overview';
      if (HASH_ALIAS[v]) v = HASH_ALIAS[v];
      self.view(v);
      // keep the route in the URL so F5 restores the page (friendly name when one exists)
      try { history.replaceState(null, '', '#' + (HASH_LABEL[v] || v)); } catch (e) {}
      if (v === 'overview') { if (!self.coaLoaded()) self.loadCoa(); }
      else if (v === 'actuals') {
        if (!self.acFiltersLoaded()) self.loadAcFilters().then(function () { self.runActuals(0); });
        else self.runActuals(0);
      } else if (v === 'dashboard') self.loadDashboard();
      else if (v === 'fmr') {
        if (!self.fmrLoaded()) self.loadFmr(); else self.runFmr();
      }
      else if (v === 'fd') {
        if (!self.fdLoaded()) self.loadFd(); else self.runFd();
      }
      else if (v === 'sectorperf') {
        if (!self.spFilters()) self.loadSpFilters().then(function () { self.runSectorPerf(); });
        else if (!self.spLoaded()) self.runSectorPerf();
      }
      else if (v === 'butil') {
        if (!self.buFiltersLoaded()) self.loadBuFilters().then(function () { self.runButil(0); });
        else self.runButil(0);
      }
      else if (v === 'portfolio') {
        // shares the Budget Utilization criteria observables, so drilling
        // between the two pages keeps one scope with no parameter passing.
        // The .catch matters: if the shared filters call fails (a transient
        // ORDS blip is enough) the page would otherwise sit on the busy
        // overlay forever with nothing said. Fail loudly and stop spinning.
        if (!self.buFiltersLoaded()) {
          self.loadBuFilters()
            .then(function () { self.runPortfolio(); })
            .catch(function (e) { self.pfLoading(false); toast(e && e.message || self.t('loadFailed'), true); });
        }
        else if (!self.pfLoaded()) self.runPortfolio();
      }
      else if (v === 'proj360') {
        if (!self.p3Num()) { self.view('portfolio'); self.go('portfolio'); return; }
        if (!self.buFiltersLoaded()) {
          self.loadBuFilters()
            .then(self.loadProj360)
            .catch(function (e) { self.p3Loading(false); toast(e && e.message || self.t('loadFailed'), true); });
          return;
        }
        self.loadProj360();
      }
      else if (v === 'encumbrances') {
        // reuses the Budget Utilization filter set; run once on first open
        if (!self.buFiltersLoaded()) self.loadBuFilters().then(function () { self.runEncumbrances(); });
        else if (!self.enLoaded()) self.runEncumbrances();
      }
      else if (v === 'pending') {
        // reuses the Budget Utilization filter set; run once on first open
        if (!self.buFiltersLoaded()) self.loadBuFilters().then(function () { self.runPending(); });
        else if (!self.pnLoaded()) self.runPending();
      }
      else if (v === 'budgettrx') {
        // own criteria set (not the butil one) — load LOVs, then first page
        if (!self.btFilters()) self.loadBtFilters().then(function () { self.runBudgetTrx(1); });
        else if (!self.btLoaded()) self.runBudgetTrx(1);
      }
      else if (v === 'costadj') {
        // butil filters feed the year list + the coding datalists in the drawer
        if (!self.buFiltersLoaded()) self.loadBuFilters();
        if (!self.caLookups()) self.loadCaLookups();
        if (!self.caLoaded()) self.runCostAdj();
      }
      else if (v === 'comments') {
        // butil filters feed the year list + the sector / cost-center datalists
        var cmtBoot = function () {
          if (!self.cmtRegYear()) self.cmtRegYear(self.buYear() || (self.buYears()[0] || ''));
          if (!self.cmtRegLoaded()) self.runCmtReg();
        };
        if (!self.buFiltersLoaded()) self.loadBuFilters().then(cmtBoot); else cmtBoot();
      }
      else if (v === 'emaillog') {
        // butil filters feed the year list only; the register has its own criteria
        if (!self.elLoaded()) self.elRun();
      }
      else if (v === 'recipients') { if (!self.rlLoaded()) self.rlLoad(); }
      else if (v === 'terms') { if (!self.tkLoaded()) self.tkLoad(); }
      else if (v === 'revcats') { if (!self.rcLoaded()) self.rcLoad(); }
      else if (v === 'cmtroles') { self.loadCmtRoles(); }
      else if (v === 'cmtperiods') {
        if (!self.buFiltersLoaded()) self.loadBuFilters();
        self.loadCmtPeriods();
      }
      else if (v === 'legacy') {
        if (!self.xmLoaded()) self.runEbsMap();
        if (!self.ebLoaded()) self.loadEbsSummary();
      }
      else if (v === 'cashflow') {
        if (!self.cfLoaded()) self.loadCfSummary();
      }
      else if (v === 'dof') {
        if (!self.dofLoaded()) self.runDof();
      }
      else if (v === 'yoy') {
        if (!self.yoLoaded()) self.runYoy();
      }
      else if (v === 'recon') {
        // show the spinner for the WHOLE initial load (filters fetch happens
        // BEFORE runRecon, which is what previously left first-load blank)
        if (!self.rcFiltersLoaded()) {
          self.rcBusy(true);
          self.loadRcFilters().then(function () { self.runRecon(); })
            .catch(function (e) { self.rcBusy(false); toast(e.message, true); });
        }
        else if (!self.rcLoaded()) self.runRecon();
      }
    };
    self.signOut = function () { location.href = ADMIN_LOGIN; };

    /* ── boot ── */
    self.dimensions = ko.observableArray([]);
    self.combinationCount = ko.observable(0);
    self.pctClassified = ko.observable(0);
    self.sectorOpts = ko.observableArray([]);
    self.chapterOpts = ko.observableArray([]);
    function dimByCode(c) { return self.dimensions().filter(function (d) { return d.code === c; })[0]; }
    // the 10 canonical GL segments (GET /gl/segments, GL/db/47) -- Entity rules may read any of them
    self.segments = ko.observableArray([]);
    self.segName = function (g) { return g ? (self.lang() === 'ar' ? (g.nameAr || g.nameEn) : g.nameEn) : ''; };
    self.segNameOf = function (key) { var g = self.segments().filter(function (x) { return x.key === key; })[0]; return g ? self.segName(g) : (key || ''); };

    /* ════ CLASSIFICATIONS ════ */
    self.clsType = ko.observable('SECTOR');
    self.clsIsEntity = ko.computed(function () { return self.clsType() === 'ENTITY'; });
    self.values = ko.observableArray([]);
    self.clsLoading = ko.observable(false);
    self.loadValues = function () {
      self.clsLoading(true);
      return api('GET', '/class-values' + qs({ type: self.clsType() })).then(function (d) {
        self.values(d.items || []); self.clsLoading(false);
      }).catch(function (e) { self.clsLoading(false); fail(e); });
    };
    self.clsType.subscribe(function () { if (self.view() === 'overview') self.loadValues(); });

    // value modal
    self.valueModal = ko.observable(false); self.editingValueId = ko.observable(null);
    self.vType = ko.observable('SECTOR'); self.vCode = ko.observable(''); self.vNameEn = ko.observable('');
    self.vNameAr = ko.observable(''); self.vAlt1 = ko.observable(''); self.vAlt2 = ko.observable(''); self.vAlt3 = ko.observable('');
    self.vTag = ko.observable(''); self.vParent = ko.observable(''); self.vOrder = ko.observable(0); self.vActive = ko.observable('Y');
    self.vDefault = ko.observable('N');
    self.vIsHier = ko.computed(function () { var d = dimByCode(self.vType()); return d && d.isHierarchical === 'Y'; });
    self.parentOpts = ko.computed(function () {
      return self.values().filter(function (v) { return v.type === self.vType() && v.classValueId !== self.editingValueId(); });
    });
    self.addValue = function () {
      self.modalErr(''); self.editingValueId(null); self.vType(self.clsType()); self.vCode(''); self.vNameEn('');
      self.vNameAr(''); self.vAlt1(''); self.vAlt2(''); self.vAlt3(''); self.vTag(''); self.vParent(''); self.vOrder(0); self.vActive('Y'); self.vDefault('N');
      self.valueModal(true);
    };
    self.editValue = function (r) {
      self.modalErr(''); self.editingValueId(r.classValueId); self.vType(r.type); self.vCode(r.valueCode);
      self.vNameEn(r.nameEn); self.vNameAr(r.nameAr || ''); self.vAlt1(r.altName1 || ''); self.vAlt2(r.altName2 || '');
      self.vAlt3(r.altName3 || ''); self.vTag(r.tag || ''); self.vParent(r.parentValueId || ''); self.vOrder(r.displayOrder || 0); self.vActive(r.isActive);
      self.vDefault(r.isDefault || 'N');
      self.valueModal(true);
    };
    self.closeValue = function () { self.valueModal(false); };
    self.saveValue = function () {
      self.modalErr('');
      if (!self.vCode() || !self.vNameEn()) { self.modalErr('Code and English name are required.'); return; }
      var body = { type: self.vType(), valueCode: self.vCode(), nameEn: self.vNameEn(), nameAr: self.vNameAr(),
        altName1: self.vAlt1(), altName2: self.vAlt2(), altName3: self.vAlt3(), tag: self.vTag(),
        parentValueId: self.vParent() || null, displayOrder: Number(self.vOrder()) || 0, isActive: self.vActive(), isDefault: self.vDefault() };
      var p = self.editingValueId()
        ? api('PUT', '/class-values/' + self.editingValueId(), body)
        : api('POST', '/class-values', body);
      p.then(function () { self.valueModal(false); toast(self.t('savedRefreshing')); self.loadValues(); self.refreshFilters(); })
       .catch(fail);
    };
    self.deleteValue = function (r) {
      if (!confirm(self.t('confirmDel'))) return;
      api('DELETE', '/class-values/' + r.classValueId)
        .then(function () { toast(self.t('deleted')); self.loadValues(); })
        .catch(function (e) { toast(e.message, true); });
    };

    /* ── classification assignments drawer (row click on the values table) ── */
    self.clsDrawer = ko.observable(false);
    self.clsDrillVal = ko.observable(null);
    self.clsDrillTitle = ko.observable('');
    self.clsDrillSub = ko.observable('');
    self.clsRows = ko.observableArray([]);
    self.clsSegOptions = ko.observableArray([]);
    self.clsDrillLoading = ko.observable(false);
    self.clsSaving = ko.observable(false);
    self.clsDrawerErr = ko.observable('');

    // segment values for the drawer datalist -- any of the 10 keys (GL/db/48)
    function clsLoadSegOptions(key) {
      if (!key) { self.clsSegOptions([]); return Promise.resolve(); }
      return api('GET', '/segments/' + key + '/values' + qs({ type: self.clsType(), limit: 500 }))
        .then(function (r) { self.clsSegOptions(r.items || []); })
        .catch(function () { self.clsSegOptions([]); });
    }
    function clsRow(m) {
      var dim = dimByCode(self.clsType());
      var r = {
        mapId: m ? m.mapId : null,
        isNew: ko.observable(!m),
        segmentKey: ko.observable(m ? (m.segmentKey || '') : ((dim && dim.segmentKey) || '')),
        segmentKeyName: m ? (m.segmentKeyName || '') : '',
        segmentValue: ko.observable(m ? m.segmentValue : ''),
        segmentDesc: ko.observable(m ? (m.segmentDesc || '') : ''),
        startDate: ko.observable(m ? m.startDate : today()),
        endDate: ko.observable(m ? (m.endDate || '') : ''),
        notes: ko.observable(m ? (m.notes || '') : ''),
        isCurrent: m ? m.isCurrent : 'Y',
        dirty: ko.observable(false)
      };
      function mark() { r.dirty(true); }
      r.startDate.subscribe(mark); r.endDate.subscribe(mark); r.notes.subscribe(mark);
      r.segmentKey.subscribe(function (k) { if (r.isNew() && self.clsIsEntity()) { r.segmentValue(''); r.segmentDesc(''); clsLoadSegOptions(k); } });
      r.segmentValue.subscribe(function (v) {
        if (!r.isNew()) return;
        var o = self.clsSegOptions().filter(function (x) { return x.segmentValue === v; })[0];
        r.segmentDesc(o ? (o.description || '') : '');
      });
      return r;
    }
    function clsLoadRows(v) {
      return api('GET', '/mappings' + qs({ type: self.clsType(), valueid: v.classValueId }))
        .then(function (d) { self.clsRows((d.items || []).map(clsRow)); });
    }
    self.openClsDrill = function (v) {
      self.clsDrillVal(v); self.clsDrawerErr(''); self.clsRows([]);
      var d = dimByCode(self.clsType());
      self.clsDrillSub(d ? self.dimName(d) : self.clsType());
      var nm = (self.lang() === 'ar' && v.nameAr) ? v.nameAr : v.nameEn;
      self.clsDrillTitle((nm || '') + ' · ' + (v.valueCode || ''));
      self.clsDrawer(true); self.clsDrillLoading(true);
      var pOpts = d ? clsLoadSegOptions(d.segmentKey) : Promise.resolve();
      Promise.all([pOpts, clsLoadRows(v)])
        .then(function () { self.clsDrillLoading(false); })
        .catch(function (e) { self.clsDrillLoading(false); self.clsDrawer(false); toast(e.message, true); });
    };
    self.clsAddRow = function () { self.clsRows.push(clsRow(null)); };
    self.clsRemoveRow = function (r) {
      if (r.isNew()) { self.clsRows.remove(r); return; }
      if (!confirm(self.t('confirmDel'))) return;
      api('DELETE', '/mappings/' + r.mapId).then(function () {
        self.clsRows.remove(r); toast(self.t('deleted'));
        self.loadValues(); self.refreshFilters();
      }).catch(function (e) { toast(e.message, true); });
    };
    self.closeClsDrill = function () { self.clsDrawer(false); };
    self.clsSaveAll = function () {
      if (self.clsSaving()) return;
      self.clsDrawerErr('');
      var v = self.clsDrillVal(); if (!v) return;
      var rows = self.clsRows(), i, r;
      for (i = 0; i < rows.length; i++) {
        r = rows[i];
        if (r.isNew() && !r.segmentValue()) { self.clsDrawerErr(self.t('segRequired')); return; }
        if (r.isNew() && self.clsIsEntity() && !r.segmentKey()) { self.clsDrawerErr(self.t('segmentKey') + ' ' + self.t('segRequired')); return; }
        if ((r.isNew() || r.dirty()) && !r.startDate()) { self.clsDrawerErr(self.t('startRequired')); return; }
      }
      var chain = Promise.resolve(), changed = 0;
      rows.forEach(function (row) {
        if (row.isNew()) {
          changed++;
          chain = chain.then(function () {
            return api('POST', '/mappings', {
              type: self.clsType(), segmentValue: row.segmentValue(), classValueId: v.classValueId,
              segmentKey: self.clsIsEntity() ? row.segmentKey() : undefined,
              startDate: row.startDate(), endDate: row.endDate() || null, notes: row.notes()
            }).then(function (res) { row.mapId = res.mapId; row.isNew(false); row.dirty(false); });
          });
        } else if (row.dirty()) {
          changed++;
          chain = chain.then(function () {
            return api('PUT', '/mappings/' + row.mapId, {
              classValueId: v.classValueId,
              startDate: row.startDate(), endDate: row.endDate() || null, notes: row.notes()
            }).then(function () { row.dirty(false); });
          });
        }
      });
      if (!changed) { toast(self.t('nothingToSave')); return; }
      self.clsSaving(true);
      chain.then(function () {
        toast(self.t('savedRefreshing'));
        self.loadValues(); self.refreshFilters();
        return clsLoadRows(v);
      }).then(function () { self.clsSaving(false); })
        .catch(function (e) { self.clsSaving(false); self.clsDrawerErr(e.message); });
    };

    /* ════ MAPPING ════ */
    self.mapType = ko.observable('SECTOR');
    self.segSearch = ko.observable('');
    self.segOptions = ko.observableArray([]);
    self.mapSegment = ko.observable('');
    self.mappings = ko.observableArray([]);
    self.mapValueOpts = ko.observableArray([]);
    self.mapSegKey = ko.observable('');          // Entity only: which GL segment the picked value belongs to
    self.loadSegOptions = function () {
      var d = dimByCode(self.mapType()); if (!d) return;
      var key = (d.code === 'ENTITY' && self.mapSegKey()) ? self.mapSegKey() : d.segmentKey;
      return api('GET', '/segments/' + key + '/values' + qs({ type: d.code, search: self.segSearch(), limit: 100 }))
        .then(function (r) {
          self.segOptions((r.items || []).map(function (x) { x.label = x.segmentValue + ' · ' + (x.description || ''); return x; }));
        }).catch(fail);
    };
    self.mapType.subscribe(function () { var d = dimByCode(self.mapType()); self.mapSegKey(d ? d.segmentKey : ''); self.mapSegment(''); self.mappings([]); if (self.view() === 'overview') self.loadSegOptions(); });
    self.mapSegKey.subscribe(function () { self.mapSegment(''); self.mappings([]); if (self.view() === 'overview' && self.mapType() === 'ENTITY') self.loadSegOptions(); });
    var segT; self.segSearch.subscribe(function () { clearTimeout(segT); segT = setTimeout(self.loadSegOptions, 300); });
    self.loadMappings = function () {
      if (!self.mapSegment()) { self.mappings([]); return; }
      api('GET', '/mappings' + qs({ type: self.mapType(), segment: self.mapSegment() }))
        .then(function (d) { self.mappings(d.items || []); }).catch(fail);
    };
    self.mapSegment.subscribe(self.loadMappings);

    self.mapModal = ko.observable(false); self.editingMapId = ko.observable(null);
    self.mType = ko.observable(''); self.mSegment = ko.observable(''); self.mValue = ko.observable('');
    self.mStart = ko.observable(''); self.mEnd = ko.observable(''); self.mNotes = ko.observable('');
    function loadMapValueOpts() {
      return api('GET', '/class-values' + qs({ type: self.mapType() })).then(function (d) {
        self.mapValueOpts((d.items || []).filter(function (v) { return v.isActive === 'Y'; }));
      });
    }
    self.addMapping = function () {
      if (!self.mapSegment()) return;
      self.modalErr(''); self.editingMapId(null); self.mType(self.dimName(dimByCode(self.mapType())));
      self.mSegment(self.mapSegment()); self.mValue(''); self.mStart(today()); self.mEnd(''); self.mNotes('');
      loadMapValueOpts().then(function () { self.mapModal(true); });
    };
    self.editMapping = function (r) {
      self.modalErr(''); self.editingMapId(r.mapId); self.mType(self.dimName(dimByCode(self.mapType())));
      self.mSegment(r.segmentValue); self.mValue(r.classValueId); self.mStart(r.startDate); self.mEnd(r.endDate || ''); self.mNotes(r.notes || '');
      loadMapValueOpts().then(function () { self.mapModal(true); });
    };
    self.closeMapping = function () { self.mapModal(false); };
    self.saveMapping = function () {
      self.modalErr('');
      if (!self.mValue() || !self.mStart()) { self.modalErr('Value and start date are required.'); return; }
      var body = { type: self.mapType(), segmentValue: self.mapSegment(), classValueId: Number(self.mValue()),
        segmentKey: self.mapType() === 'ENTITY' ? (self.mapSegKey() || undefined) : undefined,
        startDate: self.mStart(), endDate: self.mEnd() || null, notes: self.mNotes() };
      var p = self.editingMapId()
        ? api('PUT', '/mappings/' + self.editingMapId(), body)
        : api('POST', '/mappings', body);
      p.then(function () { self.mapModal(false); toast(self.t('savedRefreshing')); self.loadMappings(); self.loadSegOptions(); })
       .catch(fail);
    };
    self.deleteMapping = function (r) {
      if (!confirm(self.t('confirmDel'))) return;
      api('DELETE', '/mappings/' + r.mapId).then(function () { toast(self.t('deleted')); self.loadMappings(); }).catch(fail);
    };

    /* ════ EXPLORER ════ */
    self.expSearch = ko.observable(''); self.fSector = ko.observable(''); self.fChapter = ko.observable(''); self.asOf = ko.observable('');
    self.fEntity = ko.observable(''); self.entityOpts = ko.observableArray([]);
    self.combos = ko.observableArray([]); self.comboTotal = ko.observable(0); self.comboOffset = ko.observable(0); self.comboLimit = 50;
    self.loadCombos = function (offset) {
      offset = Math.max(0, offset || 0); self.loading(true);
      return api('GET', '/combinations' + qs({ search: self.expSearch(), sector: self.fSector(), chapter: self.fChapter(),
        entity: self.fEntity(), asof: self.asOf(), limit: self.comboLimit, offset: offset }))
        .then(function (d) { self.combos(d.items || []); self.comboTotal(d.total || 0); self.comboOffset(offset); self.loading(false); })
        .catch(function (e) { self.loading(false); fail(e); });
    };
    var expT;
    function expReload() { clearTimeout(expT); expT = setTimeout(function () { self.loadCombos(0); }, 300); }
    self.expSearch.subscribe(expReload); self.fSector.subscribe(function () { self.loadCombos(0); });
    self.fChapter.subscribe(function () { self.loadCombos(0); }); self.asOf.subscribe(function () { self.loadCombos(0); });
    self.fEntity.subscribe(function () { self.loadCombos(0); });
    self.comboRange = ko.computed(function () {
      if (!self.comboTotal()) return '';
      var a = self.comboOffset() + 1, b = Math.min(self.comboOffset() + self.comboLimit, self.comboTotal());
      return a + '–' + b + ' / ' + self.fmt(self.comboTotal());
    });
    self.exportCsv = function () {
      api('GET', '/combinations' + qs({ search: self.expSearch(), sector: self.fSector(), chapter: self.fChapter(), entity: self.fEntity(), asof: self.asOf(), limit: 500, offset: 0 }))
        .then(function (d) {
          var rows = d.items || [];
          var cols = ['ccString', 'costCenterCode', 'costCenterDesc', 'accountCode', 'accountDesc', 'appropriationCode', 'programCode', 'sectorName', 'chapterName', 'programName'];
          var csv = cols.join(',') + '\n' + rows.map(function (r) {
            return cols.map(function (c) { var v = (r[c] == null ? '' : '' + r[c]); return '"' + v.replace(/"/g, '""') + '"'; }).join(',');
          }).join('\n');
          var blob = new Blob([csv], { type: 'text/csv' }); var u = URL.createObjectURL(blob);
          var a = document.createElement('a'); a.href = u; a.download = 'gl_combinations' + (self.asOf() ? '_asof_' + self.asOf() : '') + '.csv';
          a.click(); URL.revokeObjectURL(u);
        }).catch(fail);
    };

    /* ── Chart of Accounts page —  4 sub-tabs: cls (values) | map (mapping) | exp (explorer) | ov (overview) ── */
    self.coaTab = ko.observable('cls');
    self.coaLoaded = ko.observable(false);
    self.loadCoa = function () {
      self.loadCombos(0); self.loadValues(); self.loadSegOptions(); self.coaLoaded(true);
    };
    self.coaMax = ko.observable(false);
    self.toggleCoaMax = function () {
      self.coaMax(!self.coaMax());
      document.body.style.overflow = self.coaMax() ? 'hidden' : '';
      if (self.coaMax()) self.coaTab('exp');
      return false;
    };
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && self.coaMax() && !self.drillDrawer() && !self.drillModal()) self.toggleCoaMax();
    });

    /* ── shared filter refresh (sector/chapter dropdowns) ── */
    self.refreshFilters = function () {
      api('GET', '/class-values?type=SECTOR').then(function (d) { self.sectorOpts((d.items || []).filter(function (v) { return v.isActive === 'Y'; })); });
      api('GET', '/class-values?type=CHAPTER').then(function (d) { self.chapterOpts((d.items || []).filter(function (v) { return v.isActive === 'Y'; })); });
      api('GET', '/class-values?type=ENTITY').then(function (d) {
        var l = (d.items || []).filter(function (v) { return v.isActive === 'Y'; });
        l.push({ valueCode: 'UNCLASSIFIED', nameEn: self.t('unclassified') });
        self.entityOpts(l);
      }).catch(function () {});
    };

    /* ════ formatting helpers (AED) ════ */
    self.money = function (n) { if (n == null || n === '') return '—'; return Math.round(Number(n)).toLocaleString('en-US'); };
    self.compact = function (n) {
      if (n == null || n === '') return '—'; var v = Number(n), a = Math.abs(v), s = v < 0 ? '-' : '';
      if (a >= 1e9) return s + (a / 1e9).toFixed(2) + 'B';
      if (a >= 1e6) return s + (a / 1e6).toFixed(1) + 'M';
      if (a >= 1e3) return s + (a / 1e3).toFixed(0) + 'K';
      return s + Math.round(a);
    };

    /* ════ snapshot refresh (manual button + Overview) ════ */
    self.refreshing = ko.observable(false);
    self.lastRefreshed = ko.observable('');
    self.refreshActuals = function () {
      if (self.refreshing()) return;
      self.refreshing(true); self.rfHidden(false);
      api('POST', '/actuals/refresh', {}).then(function (d) {
        self.lastRefreshed(d.refreshedAt || '');
        self.refreshing(false);
        toast(self.t('refreshed'));
        if (self.view() === 'actuals') self.runActuals(self.acOffset());
        else if (self.view() === 'dashboard') self.loadDashboard();
      }).catch(function (e) { self.refreshing(false); toast(e.message, true); });
    };

    /* every Refresh-data menu action shows a visible popup (user feedback
       2026-08-22 — "Refresh actuals" looked like nothing was happening):
       actuals + rebuild get a lite spinner card; the Data Conveyor stays
       exclusive to the source-data fleet run. Backdrop click hides it. */
    self.rfHidden = ko.observable(false);
    self.rfHide = function () { self.rfHidden(true); return false; };

    // structural-reload recovery: POST /actuals/rebuild -> prod.dct_views_rebuild
    // (re-creates the SELECT * base views, recompiles, refreshes the snapshot)
    self.rebuilding = ko.observable(false);
    self.rebuildViews = function () {
      if (self.rebuilding() || self.refreshing()) return;
      if (!window.confirm(self.t('rebuildConfirm'))) return;
      self.rebuilding(true); self.rfHidden(false);
      api('POST', '/actuals/rebuild', {}).then(function (d) {
        self.rebuilding(false);
        self.lastRefreshed(d.refreshedAt || '');
        if (d.invalidRemaining) toast(self.t('rebuiltLeft') + ' ' + d.invalidRemaining, true);
        else toast(self.t('rebuilt'));
        if (self.view() === 'actuals') self.runActuals(self.acOffset());
        else if (self.view() === 'butil') self.runButil(self.buOffset());
        else if (self.view() === 'dashboard') self.loadDashboard();
      }).catch(function (e) { self.rebuilding(false); toast(e.message, true); });
    };

    /* ── Source-data refresh (butil page): POST /butil/refreshdata queues ALL
       15 full extracts behind the page (GL/db/19): the PROJECTS_DATA job set
       (Projects Full + Tasks Full + Projects Budget Full - V2) PLUS AP
       Invoices/Lines/Distributions Full, PO Headers/Lines/Schedules/
       Distributions Full, PR Headers/Lines/Distributions, GRN Temporary Job +
       GRN Gap (user request 2026-08-22). Polls the GET until the fleet
       finishes (~3-6 min) and re-runs the current search. */
    self.pdataBusy = ko.observable(false);
    // Data Conveyor band feed (user-picked motion 2026-08-22): done count /
    // running job derived from the REAL poll — never a fake spinner
    self.pdataDone = ko.observable(0);
    self.pdataTotal = ko.observable(15);
    self.pdataJob = ko.observable('');
    self.cvbSegs = Array.apply(null, { length: 15 }).map(function (_, i) { return i; });
    self.cvbCount = ko.computed(function () {
      return self.t('cvbCount').replace('{d}', self.pdataDone()).replace('{n}', self.pdataTotal());
    });
    self.cvbJob = ko.computed(function () {
      return self.pdataJob() ? self.t('cvbRunning').replace('{j}', self.pdataJob()) : '';
    });
    // x on the popup hides it only — the refresh keeps running (header button
    // keeps its busy label); reset on every new run
    self.cvbHidden = ko.observable(false);
    /* ── "Refresh data" dropdown (2026-08-22): folds the 3 refresh buttons into
       one .gen-style menu; opening it fetches the latest source-data finish
       time from the poll endpoint. Rebuild views is admin-only in the menu. */
    self.rdOpen = ko.observable(false);
    self.rdLast = ko.observable('');
    self.toggleRd = function () {
      self.rdOpen(!self.rdOpen());
      if (self.rdOpen()) {
        api('GET', '/butil/refreshdata').then(function (s) {
          var best = 0, txt = '';
          (s.jobs || []).forEach(function (j) {
            var m = /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}) (AM|PM)$/.exec(j.lastFinished || '');
            if (!m) return;
            var t = new Date(+m[1], m[2] - 1, +m[3], (+m[4] % 12) + (m[6] === 'PM' ? 12 : 0), +m[5]).getTime();
            if (t > best) { best = t; txt = j.lastFinished; }
          });
          self.rdLast(txt);
        }).catch(function () { self.rdLast(''); });
      }
      return true;
    };
    self.closeRd = function () { self.rdOpen(false); return true; };
    self.rdLastTxt = ko.computed(function () {
      return self.rdLast() ? self.t('rdLastL').replace('{t}', self.rdLast()) : '';
    });
    self.rdBtnLabel = ko.computed(function () {
      if (self.pdataBusy()) return self.t('pdataRunning');
      if (self.rebuilding()) return self.t('rebuilding');
      if (self.refreshing()) return self.t('refreshing');
      return self.t('rdBtn');
    });
    function pdataProgress(s) {
      var all = s.jobs || [];
      var pend = all.filter(function (j) { return j.queueStatus === 'READY' || j.queueStatus === 'CLAIMED'; });
      self.pdataTotal(all.length || 15);
      self.pdataDone((all.length || 15) - pend.length);
      self.pdataJob(all.filter(function (j) { return j.queueStatus === 'CLAIMED'; })
                       .map(function (j) { return j.job; }).join(' · '));
    }
    self.refreshProjectsData = function () {
      if (self.pdataBusy()) return;
      self.pdataDone(0); self.pdataJob(''); self.cvbHidden(false);
      self.pdataBusy(true);
      api('POST', '/butil/refreshdata', {}).then(function (d) {
        toast(self.t('pdataQueued').replace('{n}', d.queued));
        var tries = 0;
        (function poll() {
          if (++tries > 180) {                    // ~15 min ceiling (15 full jobs since 2026-08-22)
            self.pdataBusy(false); toast(self.t('pdataTimeout'), true); return;
          }
          setTimeout(function () {
            api('GET', '/butil/refreshdata').then(function (s) {
              pdataProgress(s);
              if (s.busy === 'Y') { poll(); return; }
              var bad = (s.jobs || []).filter(function (j) {
                return j.queueStatus === 'FAILED' || j.lastStatus === 'FAILED';
              });
              self.pdataBusy(false);
              if (bad.length) {
                toast(self.t('pdataFailed') + ' ' + bad.map(function (j) { return j.job; }).join(', '), true);
              } else {
                toast(self.t('pdataDone'));
                if (self.view() === 'butil') self.runButil(self.buOffset());
              }
            }).catch(function () { poll(); });    // transient poll error: keep waiting
          }, 5000);
        })();
      }).catch(function (e) { self.pdataBusy(false); toast(e.message, true); });
    };

    /* ════ ACTUALS — Budget vs Actual report ════ */
    self.acFiltersLoaded = ko.observable(false);
    self.periods = ko.observableArray([]);
    self.acSectors = ko.observableArray([]); self.acChapters = ko.observableArray([]);
    self.acPrograms = ko.observableArray([]); self.acAppropriations = ko.observableArray([]);
    self.acAccounts = ko.observableArray([]); self.acCostCenters = ko.observableArray([]);
    self.acPeriod = ko.observable(''); self.acSearch = ko.observable(''); self.acSource = ko.observable('');
    // multi-select filters — pipe-delimited any-of, mirrors Budget Utilization.
    // each has a <select> pick observable that appends to its Sel chip array.
    self.acSectorSel = ko.observableArray([]);     self.acSectorPick = ko.observable('');
    self.acChapterSel = ko.observableArray([]);    self.acChapterPick = ko.observable('');
    self.acProgramSel = ko.observableArray([]);    self.acProgramPick = ko.observable('');
    self.acApprSel = ko.observableArray([]);       self.acApprPick = ko.observable('');
    self.acAccountSel = ko.observableArray([]);    self.acAccountPick = ko.observable('');
    self.acCostCenterSel = ko.observableArray([]); self.acCostCenterPick = ko.observable('');
    // Account Type is a MANDATORY filter — defaults to Expense ('4')
    self.acAccTypeSel = ko.observableArray(['4']);  self.acAccTypePick = ko.observable('');
    // account type LOV (leading account digit: 1=Assets…5=Owner's Equity), bilingual
    self.acAccTypes = ko.computed(function () {
      return [
        { code: '1', name: self.t('atAssets') },  { code: '2', name: self.t('atLiability') },
        { code: '3', name: self.t('atRevenue') }, { code: '4', name: self.t('atExpense') },
        { code: '5', name: self.t('atEquity') }
      ];
    });
    self.acAccTypeName = function (code) {
      var h = self.acAccTypes().filter(function (x) { return x.code === code; })[0];
      return h ? h.name : (code || '');
    };
    // resolve a code to its friendly LOV name for the chip tray (public wrapper)
    self.acLovName = function (arr, code) {
      var h = (arr() || []).filter(function (x) { return x.code === code; })[0];
      return h ? (h.name || h.code) : code;
    };
    // append the current pick to its chip array (ignores blank / duplicate)
    self.acAddSel = function (sel, pick) { var v = pick(); if (v && sel.indexOf(v) < 0) sel.push(v); pick(''); return true; };
    // type-ahead LOV commit (v1.57.0): the drawer's big LOVs are datalist text
    // inputs — match the typed/picked text against the LOV (exact code, then
    // 'code · name', then exact name, then a UNIQUE contains match) and turn it
    // into a chip; blank or ambiguous text is left in place untouched.
    self.acLovCommit = function (lov, sel, txt) {
      var v = (txt() || '').trim();
      if (!v) return true;
      var list = lov() || [], lo = v.toLowerCase();
      var hit = list.filter(function (x) { return x.code === v; })[0] ||
                list.filter(function (x) { return (x.code + ' · ' + (x.name || '')).toLowerCase() === lo; })[0] ||
                list.filter(function (x) { return (x.name || '').toLowerCase() === lo; })[0];
      if (!hit) {
        var cand = list.filter(function (x) {
          return (x.code + ' ' + (x.name || '')).toLowerCase().indexOf(lo) >= 0;
        });
        if (cand.length === 1) hit = cand[0];
      }
      if (hit) { if (sel.indexOf(hit.code) < 0) sel.push(hit.code); txt(''); }
      return true;
    };
    self.acChipRemove = function (arr, v) {
      // Account Type is mandatory — never let the tray empty it
      if (arr === self.acAccTypeSel && self.acAccTypeSel().length <= 1) { toast(self.t('accTypeRequired'), true); return; }
      arr.remove(v);
    };
    // transaction-source filter — keeps a row only when that measure is non-zero
    self.acSources = ko.computed(function () {
      return [
        { code: 'budget',         name: self.t('srcBudget') },
        { code: 'commitment',     name: self.t('srcCommitment') },
        { code: 'obligation',     name: self.t('srcObligation') },
        { code: 'openCommitment', name: self.t('srcOpenCommitment') },
        { code: 'openObligation', name: self.t('srcOpenObligation') },
        { code: 'glActual',       name: self.t('srcGlActual') },
        { code: 'grn',            name: self.t('srcGrn') },
        { code: 'apDirect',       name: self.t('srcApDirect') }
      ];
    });
    self.acItems = ko.observableArray([]); self.acTotals = ko.observable({});
    self.acTotal = ko.observable(0); self.acOffset = ko.observable(0); self.acLimit = 100;
    self.acLoading = ko.observable(false);

    self.loadAcFilters = function () {
      return api('GET', '/actuals/filters').then(function (d) {
        self.periods(d.periods || []);
        self.acSectors(d.sectors || []); self.acChapters(d.chapters || []);
        self.acPrograms(d.programs || []); self.acAppropriations(d.appropriations || []);
        self.acAccounts(d.accounts || []); self.acCostCenters(d.costCenters || []);
        if (!self.acPeriod()) self.acPeriod(d.defaultPeriod || (d.periods && d.periods[0] && d.periods[0].period) || '');
        self.acFiltersLoaded(true);
      }).catch(fail);
    };
    self.acParams = function (offset, limit) {
      return { period: self.acPeriod(),
        sector: self.acSectorSel().join('|'), chapter: self.acChapterSel().join('|'),
        program: self.acProgramSel().join('|'), appropriation: self.acApprSel().join('|'),
        account: self.acAccountSel().join('|'), costcenter: self.acCostCenterSel().join('|'),
        accounttype: self.acAccTypeSel().join('|'), source: self.acSource(),
        search: self.acSearch(),
        limit: limit || self.acLimit, offset: offset || 0 };
    };
    /* one-shot loader (v1.57.0 IR rework): the shared <interactive-report>
       needs the FULL filtered set client-side, so page-merge /actuals
       (server clamp = 1,000 rows/request, GL/db/05) up to AC_MAX rows —
       no handler change, so no 05 re-run cascade. The 100-row pager is
       gone; the IR grid owns sorting / filtering / paging. */
    var AC_MAX = 10000, AC_PAGE = 1000;
    self.acTruncated = ko.observable(false);
    self.runActuals = function () {
      if (!self.acPeriod()) { toast(self.t('periodRequired'), true); return; }
      if (!self.acAccTypeSel().length) { toast(self.t('accTypeRequired'), true); return; }
      self.acLoading(true);
      var rows = [];
      function pageIn(off) {
        return api('GET', '/actuals' + qs(self.acParams(off, AC_PAGE))).then(function (d) {
          if (off === 0) { self.acTotals(d.totals || {}); self.acTotal(d.total || 0); }
          var it = d.items || [];
          rows = rows.concat(it);
          if (it.length === AC_PAGE && rows.length < Math.min(self.acTotal(), AC_MAX)) return pageIn(off + AC_PAGE);
        });
      }
      return pageIn(0).then(function () {
        self.acTruncated(rows.length < self.acTotal());
        self.acItems(rows);
        self.acLoading(false);
      }).catch(function (e) { self.acLoading(false); fail(e); });
    };
    self.acReset = function () {
      self.acSectorSel.removeAll(); self.acChapterSel.removeAll(); self.acProgramSel.removeAll();
      self.acApprSel.removeAll(); self.acAccountSel.removeAll(); self.acCostCenterSel.removeAll();
      self.acAccTypeSel(['4']); self.acSearch(''); self.acSource('');  // mandatory — reset to Expense
      self.acSectorPick(''); self.acChapterPick(''); self.acProgramPick(''); self.acApprPick('');
      self.acAccountPick(''); self.acCostCenterPick(''); self.acAccTypePick('');
      var cur = self.periods().filter(function (p) { return p.isCurrent === 'Y'; })[0];
      if (cur) self.acPeriod(cur.period);
      self.runActuals(0);
    };
    self.acRange = ko.computed(function () {
      if (!self.acTotal()) return '';
      return self.fmt(self.acItems().length) + ' ' + self.t('rowsOf') + ' ' + self.fmt(self.acTotal());
    });
    // pull the business-question total for a summary card
    self.tot = function (k) { var t = self.acTotals() || {}; return t[k]; };
    // KPI-group context: a measure as a share of the filtered budget
    self.acPct = function (k) {
      var t = self.acTotals() || {}; var b = Number(t.budget) || 0;
      if (!b) return null;
      return (Number(t[k]) || 0) / b * 100;
    };
    self.acPctW = function (k) {
      var p = self.acPct(k);
      return (p == null ? 0 : Math.max(0, Math.min(100, p))) + '%';
    };
    self.acUtilTxt = ko.computed(function () {
      var p = self.acPct('glActual');
      if (p == null) return '';
      return (p >= 99.95 ? Math.round(p) : p.toFixed(1)) + '% ' + self.t('acUtilized');
    });
    self.acFundsTxt = ko.computed(function () {
      var p = self.acPct('fundsAvailable');
      if (p == null) return '';
      return (p >= 99.95 ? Math.round(p) : p.toFixed(1)) + '% ' + self.t('acRemainingLbl');
    });

    /* ── SHARED interactive-report envelope (v1.57.0): the Budget-vs-Actual
       register on the shared IR grid — grouped header bands (Commitment /
       Obligation / Actuals / Funds), frozen Combination + Cost-centre columns,
       per-group tints, per-column ⓘ hints. Figure cells stay drillable via
       the delegated wrapper handlers below; the IR normalizes rows down to
       declared columns, so a side map keyed on the combination string
       recovers the full source row (segment popover needs it). ── */
    var acRowMap = {};
    var AC_METRIC = { budget: 'budget', prTotal: 'commitment', openCommitment: 'opencommitment',
      commitmentPipeline: 'commitmentpipeline', totalPo: 'obligation', openObligation: 'openobligation',
      poPipeline: 'popipeline', glActual: 'glactual', grnActual: 'grn', apDirect: 'apdirect' };
    function acPair(code, name) { return code ? (name ? code + ' · ' + name : code) : (name || ''); }
    self.acIr = ko.pureComputed(function () {
      var items = self.acItems();
      if (!items.length && !self.acTotal()) return null;
      var t = self.t;
      var gPr = t('cCommitment'), gPo = t('cObligation'), gAct = t('cActual'), gF = t('cFunds');
      // display unit — the SAME buUnit attribute the Budget Utilization page
      // uses (drawer "Figures in" field): B/M/K scale every money column
      // (label gains the unit suffix); Auto/Exact = full numbers.
      var u = self.buUnit();
      var div = u === 'B' ? 1e9 : u === 'M' ? 1e6 : u === 'K' ? 1e3 : 1;
      var sfx = div > 1 ? ' (' + u + ')' : '';
      function mv(v) { return (v == null || v === '') ? null : Number(v) / div; }
      var cols = [
        { key: 'combination', label: t('thCombo'), type: 'text', sticky: true, width: 205, colClass: 'acc-mono', hint: t('hCombo') },
        { key: 'costCenter', label: t('costCenter'), type: 'text', sticky: true, width: 185, ellipsis: true },
        { key: 'account', label: t('account'), type: 'text', width: 200, ellipsis: true },
        { key: 'accountType', label: t('thAccType'), type: 'text' },
        { key: 'sector', label: t('fSectorL'), type: 'text', ellipsis: true },
        { key: 'program', label: t('program'), type: 'text', ellipsis: true },
        { key: 'appropriation', label: t('thAppr'), type: 'text' },
        { key: 'budget', label: t('cBudget'), type: 'money', colClass: 'acc-bud', hint: t('hBudget') },
        { key: 'prTotal', label: t('lblTotal'), type: 'money', group: gPr, groupClass: 'acg-pr', colClass: 'acc-pr', hint: t('hCommitmentGrp') },
        { key: 'openCommitment', label: t('lblOpen'), type: 'money', group: gPr, groupClass: 'acg-pr', colClass: 'acc-pr', hint: t('hCommitmentGrp') },
        { key: 'commitmentPipeline', label: t('lblPipe'), type: 'money', group: gPr, groupClass: 'acg-pr', colClass: 'acc-pr', hint: t('hCommitmentGrp') },
        { key: 'prCount', label: t('acPrCount'), type: 'num', group: gPr, groupClass: 'acg-pr', colClass: 'acc-pr' },
        { key: 'totalPo', label: t('lblTotal'), type: 'money', group: gPo, groupClass: 'acg-po', colClass: 'acc-po', hint: t('hObligationGrp') },
        { key: 'openObligation', label: t('lblOpen'), type: 'money', group: gPo, groupClass: 'acg-po', colClass: 'acc-po', hint: t('hObligationGrp') },
        { key: 'poPipeline', label: t('lblPipe'), type: 'money', group: gPo, groupClass: 'acg-po', colClass: 'acc-po', hint: t('hObligationGrp') },
        { key: 'poCount', label: t('acPoCount'), type: 'num', group: gPo, groupClass: 'acg-po', colClass: 'acc-po' },
        { key: 'openEncumbrance', label: t('cOpenEncumbrance'), type: 'money', colClass: 'acc-enc', hint: t('hOpenEncumbrance') },
        { key: 'glActual', label: t('cActual'), type: 'money', group: gAct, groupClass: 'acg-act', colClass: 'acc-act', hint: t('hActual') },
        { key: 'grnActual', label: t('cGrn'), type: 'money', group: gAct, groupClass: 'acg-act', colClass: 'acc-act', hint: t('hGrn') },
        { key: 'apDirect', label: t('cApDirect'), type: 'money', group: gAct, groupClass: 'acg-act', colClass: 'acc-act', hint: t('hApDirect') },
        { key: 'slaActual', label: t('cSla'), type: 'money', group: gAct, groupClass: 'acg-act', colClass: 'acc-act', hint: t('hSla') },
        { key: 'fundsAvailable', label: t('lblGL'), type: 'money', group: gF, groupClass: 'acg-funds', colClass: 'acc-funds', hint: t('hFundsGrp') },
        { key: 'fundsAvailableCalc', label: t('lblCalc'), type: 'money', group: gF, groupClass: 'acg-funds', colClass: 'acc-funds', hint: t('hFundsGrp') }
      ];
      if (sfx) cols.forEach(function (c) { if (c.type === 'money') c.label += sfx; });
      acRowMap = {};
      var rows = items.map(function (r) {
        acRowMap[r.ccString] = r;
        return {
          combination: r.ccString,
          costCenter: acPair(r.costCenterCode, r.costCenterDesc),
          account: acPair(r.accountCode, r.accountDesc),
          accountType: self.acAccTypeName(r.accountTypeCode),
          sector: r.sectorName || '',
          program: r.programName || '',
          appropriation: r.appropriationCode || '',
          budget: mv(r.budget), prTotal: mv(r.prTotal), openCommitment: mv(r.openCommitment),
          commitmentPipeline: mv(r.commitmentPipeline), prCount: r.prCount || 0,
          totalPo: mv(r.totalPo), openObligation: mv(r.openObligation), poPipeline: mv(r.poPipeline),
          poCount: r.poCount || 0, openEncumbrance: mv(r.openEncumbrance),
          glActual: mv(r.glActual), grnActual: mv(r.grnActual), apDirect: mv(r.apDirect),
          slaActual: mv(r.slaActual), fundsAvailable: mv(r.fundsAvailable),
          fundsAvailableCalc: mv(r.fundsAvailableCalc)
        };
      });
      return { columns: cols, items: rows, total: rows.length, truncated: self.acTruncated(),
               maxRows: AC_MAX, zebra: true, stateRev: 1, section: 'ac' };
    });
    /* delegated wrapper handlers over the IR grid (ko.contextFor — same
       pattern as the encumbrance / pending registers): the Combination cell
       shows the 10-segment popover, every figure cell drills to its
       supporting lines exactly like the old hand-built table did. */
    self.acGridOver = function (d, e) {
      var info = enResolveCell(e.target);
      if (!info) { self.comboOut(); return true; }
      if (info.col.key === 'combination' && acRowMap[info.row.combination]) {
        info.td.style.cursor = 'help';
        self.comboHover(acRowMap[info.row.combination], e);
      } else {
        self.comboOut();
        if (AC_METRIC[info.col.key]) { info.td.classList.add('ac-drillcell'); info.td.title = self.t('buDrillHint'); }
      }
      return true;
    };
    self.acGridMove = function (d, e) {
      if (!self.tipShow()) return true;
      var info = enResolveCell(e.target);
      if (info && info.col.key === 'combination' && acRowMap[info.row.combination]) self.comboMove(info.row, e);
      else self.comboOut();
      return true;
    };
    self.acGridClick = function (d, e) {
      var info = enResolveCell(e.target);
      if (info && AC_METRIC[info.col.key] && info.row.combination) {
        self.openDrill({ ccString: info.row.combination }, AC_METRIC[info.col.key]);
        return false;
      }
      return true;
    };

    /* ── report parameters drawer (filters moved off the page, 2026-07-14) ── */
    self.acFilterDrawer = ko.observable(false);
    self.openAcFilters = function () { self.acFilterDrawer(true); };
    self.closeAcFilters = function () { self.acFilterDrawer(false); };
    self.applyAcFilters = function () { self.acFilterDrawer(false); self.runActuals(0); };
    // Reset inside the drawer: clear criteria + re-run, but keep the drawer open
    self.acDrawerReset = function () { self.acReset(); };
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && self.acFilterDrawer()) self.acFilterDrawer(false);
    });
    self.acActiveCount = ko.computed(function () {
      return self.acSectorSel().length + self.acChapterSel().length + self.acProgramSel().length +
        self.acApprSel().length + self.acAccountSel().length + self.acCostCenterSel().length +
        self.acAccTypeSel().length + (self.acSource() ? 1 : 0) + (self.acSearch() ? 1 : 0);
    });
    // applied-criteria chips on the page (label + resolved display value)
    function lovName(arr, code, both) {
      var hit = (arr() || []).filter(function (x) { return x.code === code; })[0];
      if (!hit) return code;
      return both ? (hit.code + ' · ' + hit.name) : (hit.name || hit.code);
    }
    self.acFilterChips = ko.computed(function () {
      var c = [];
      self.acSectorSel().forEach(function (v) { c.push({ label: self.t('fSectorL'), value: lovName(self.acSectors, v) }); });
      self.acChapterSel().forEach(function (v) { c.push({ label: self.t('fChapterL'), value: lovName(self.acChapters, v) }); });
      self.acProgramSel().forEach(function (v) { c.push({ label: self.t('fProgramL'), value: lovName(self.acPrograms, v) }); });
      self.acApprSel().forEach(function (v) { c.push({ label: self.t('fApprL'), value: lovName(self.acAppropriations, v, true) }); });
      self.acAccountSel().forEach(function (v) { c.push({ label: self.t('fAccountL'), value: lovName(self.acAccounts, v, true) }); });
      self.acCostCenterSel().forEach(function (v) { c.push({ label: self.t('fCostCenterL'), value: lovName(self.acCostCenters, v, true) }); });
      self.acAccTypeSel().forEach(function (v) { c.push({ label: self.t('fAccTypeL'), value: self.acAccTypeName(v) }); });
      if (self.acSource()) {
        var s = self.acSources().filter(function (x) { return x.code === self.acSource(); })[0];
        c.push({ label: self.t('fSourceL'), value: s ? s.name : self.acSource() });
      }
      if (self.acSearch())     c.push({ label: self.t('fSearchL'),     value: '“' + self.acSearch() + '”' });
      return c;
    });

    /* ── drill-down: a single figure → its supporting lines ── */
    self.drillModal = ko.observable(false); self.drillLoading = ko.observable(false);
    self.drillTitle = ko.observable(''); self.drillCols = ko.observableArray([]);
    self.drillRows = ko.observableArray([]); self.drillTotalV = ko.observable(0);
    self.openDrill = function (row, metric) {
      self.drillTitle(self.t('m' + metric.charAt(0).toUpperCase() + metric.slice(1)) + ' · ' + row.ccString);
      self.drillSub(''); self.drillCtx('');
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0);
      self.drillModal(true); self.drillLoading(true);
      api('GET', '/actuals/lines' + qs({ period: self.acPeriod(), cc: row.ccString, metric: metric }))
        .then(function (d) {
          self.drillCols(d.columns || []); self.drillRows(d.rows || []); self.drillTotalV(d.total || 0);
          self.drillLoading(false);
        }).catch(function (e) { self.drillLoading(false); self.drillModal(false); toast(e.message, true); });
    };
    self.closeDrill = function () { self.drillModal(false); };
    // KPI-card drill → supporting lines across the WHOLE filtered set (aggregate),
    // in the shared slide-in drawer (same as Budget Utilization's openBuAgg).
    self.openAcAgg = function (metric) {
      if (!self.acPeriod()) { toast(self.t('periodRequired'), true); return; }
      self.drillTitle(self.t('m' + metric.charAt(0).toUpperCase() + metric.slice(1)) + ' · ' + self.t('acAllLines'));
      self.drillSub(self.t('fPeriod') + ' ' + self.acPeriod());
      self.drillCtx([
        self.acSectorSel().map(function (v) { return self.acLovName(self.acSectors, v); }).join(', '),
        self.acChapterSel().map(function (v) { return self.acLovName(self.acChapters, v); }).join(', '),
        self.acProgramSel().map(function (v) { return self.acLovName(self.acPrograms, v); }).join(', '),
        self.acApprSel().join(', '), self.acAccountSel().join(', '), self.acCostCenterSel().join(', '),
        self.acAccTypeSel().map(function (v) { return self.acAccTypeName(v); }).join(', '),
        self.acSearch() ? '“' + self.acSearch() + '”' : ''
      ].filter(Boolean).join('   ·   '));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      api('GET', '/actuals/lines' + qs({ period: self.acPeriod(), metric: metric,
        sector: self.acSectorSel().join('|'), chapter: self.acChapterSel().join('|'),
        program: self.acProgramSel().join('|'), appropriation: self.acApprSel().join('|'),
        account: self.acAccountSel().join('|'), costcenter: self.acCostCenterSel().join('|'),
        accounttype: self.acAccTypeSel().join('|'), source: self.acSource(), search: self.acSearch() }))
        .then(fillAcAgg).catch(drillFail);
    };
    self.cell = function (row, col) {
      var v = row[col.key];
      if (col.type === 'money') return self.money(v);
      if (col.type === 'num') return (v == null ? '' : Number(v).toLocaleString('en-US', { maximumFractionDigits: 4 }));
      return (v == null ? '' : v);
    };
    // Fusion deep-link for a drill cell (shared /shared/js/fusionLinks.js UMD
    // global) — Invoice/PO/PR numbers link to Fusion when the row carries the
    // FUSION internal id (invoiceId / poHeaderId / prHeaderId); null = plain text
    self.drillLink = function (row, col) {
      var F = window.FusionLinks;
      if (!F || !row || !col || !row[col.key]) return null;
      if (col.key === 'invoice' && row.invoiceId) return F.invoice(row.invoiceId);
      if (col.key === 'po' && row.poHeaderId)     return F.purchaseOrder(row.poHeaderId);
      if (col.key === 'pr' && row.prHeaderId)     return F.requisition(row.prHeaderId);
      // pending-approval KPI drills: mixed PR/PO rows carry source + fusionHeaderId
      if (col.key === 'docNumber' && row.fusionHeaderId) {
        return row.source === 'PR' ? F.requisition(row.fusionHeaderId)
                                   : F.purchaseOrder(row.fusionHeaderId);
      }
      return null;
    };
    // Related Invoices cell (GRN drill): each comma-separated invoice number
    // becomes its OWN Fusion deep-link. The row ships a hidden pipe-separated
    // "number~invoiceId" pair list (relatedInvPairs) alongside the display
    // string — numbers without a resolvable id render as plain text.
    self.relatedInvLinks = function (row) {
      var s = row && row.relatedInvoices;
      if (!s) return [];
      var map = {};
      ('' + (row.relatedInvPairs || '')).split('|').forEach(function (p) {
        var i = p.lastIndexOf('~');
        if (i > 0) map[p.slice(0, i)] = p.slice(i + 1);
      });
      var F = window.FusionLinks;
      return s.split(', ').map(function (n) {
        var id = map[n];
        return { n: n, url: (F && id) ? F.invoice(id) : null };
      });
    };
    self.drillFooterSpan = ko.computed(function () { return Math.max(1, self.drillCols().length - 1); });

    self.acExportCsv = function () {
      api('GET', '/actuals' + qs(self.acParams(0, 5000))).then(function (d) {
        var rows = (d.items || []).map(function (r) { r.accountTypeName = self.acAccTypeName(r.accountTypeCode); return r; });
        var cols = [['ccString', 'Combination'], ['costCenterCode', 'Cost Center'], ['costCenterDesc', 'Cost Center Desc'],
          ['accountCode', 'Account'], ['accountDesc', 'Account Desc'], ['accountTypeName', 'Account Type'], ['sectorName', 'Sector'], ['chapterName', 'Chapter'],
          ['programName', 'DCT Program'], ['appropriationCode', 'Appropriation'], ['appropriationDesc', 'Appropriation Desc'],
          ['budget', 'Budget'],
          ['prTotal', 'Total PR'], ['openCommitment', 'Open Commitment'], ['commitmentPipeline', 'Commitment Pipeline'], ['prCount', 'PR Count'],
          ['totalPo', 'Total PO'], ['openObligation', 'Open Obligation'], ['poPipeline', 'PO Pipeline'], ['poCount', 'PO Count'],
          ['openEncumbrance', 'Open Encumbrance'], ['glActual', 'GL Actual'],
          ['grnActual', 'GRN Actual'], ['apDirect', 'AP Direct'], ['slaActual', 'SLA Actual'],
          ['fundsAvailable', 'Funds Available (GL)'], ['fundsAvailableCalc', 'Funds Available (calc)'], ['variance', 'Variance']];
        var csv = cols.map(function (c) { return c[1]; }).join(',') + '\n' + rows.map(function (r) {
          return cols.map(function (c) { var v = (r[c[0]] == null ? '' : '' + r[c[0]]); return '"' + v.replace(/"/g, '""') + '"'; }).join(',');
        }).join('\n');
        var blob = new Blob([csv], { type: 'text/csv' }); var u = URL.createObjectURL(blob);
        var a = document.createElement('a'); a.href = u; a.download = 'gl_actuals_' + self.acPeriod() + '.csv'; a.click(); URL.revokeObjectURL(u);
      }).catch(fail);
    };

    /* ════ BUDGET UTILIZATION — project budget vs actual (year mandatory) ════ */
    var BU_DEFAULT_TYPE = 'DCT OPEX Project Type';
    var BU_DEFAULT_UNIT = 'Department of Culture and Tourism';   // default Business Unit selection
    self.buFiltersLoaded = ko.observable(false);
    self.buYears = ko.observableArray([]);
    self.buTypes = ko.observableArray([]);
    self.buSectors = ko.observableArray([]);
    self.buChapters = ko.observableArray([]);
    self.buYear = ko.observable(''); self.buSector = ko.observable('');
    /* Project Type is MULTI-SELECT (2026-08-09): picks become chips; buType
       stays as a computed returning the pipe-joined any-of list so every
       existing sender (butil / encumbrances / pending / report bridges)
       keeps working unchanged. */
    self.buTypeSel = ko.observableArray([]);
    self.buTypePick = ko.observable('');
    self.buType = ko.computed(function () { return self.buTypeSel().join('|'); });
    self.buTypeAdd = function () {
      var v = self.buTypePick();
      if (v && self.buTypeSel.indexOf(v) < 0) self.buTypeSel.push(v);
      self.buTypePick('');
      return true;
    };
    self.buCc = ko.observable(''); self.buProject = ko.observable('');
    self.buTask = ko.observable(''); self.buEtype = ko.observable('');
    self.buSearch = ko.observable('');
    /* Appropriation + DCT Program — exact-match classification LOVs (2026-07-21) */
    self.buApprop = ko.observable(''); self.buProgram = ko.observable('');
    self.buAppropList = ko.observableArray([]); self.buProgramList = ko.observableArray([]);

    /* ── multi-select filters (Chapter / Cost centre / Project, 2026-07-14) ──
       Every pick becomes a chip; the server matches ANY chip (pipe-delimited
       exact list). A free-typed pipe-less value keeps the original
       contains-match semantics. */
    self.buChapterSel = ko.observableArray([]);
    self.buCcSel = ko.observableArray([]);
    self.buProjSel = ko.observableArray([]);
    self.buChapterPick = ko.observable('');
    self.buChapterAdd = function () {
      var v = self.buChapterPick();
      if (v && self.buChapterSel.indexOf(v) < 0) self.buChapterSel.push(v);
      self.buChapterPick('');
      return true;
    };
    self.buChipRemove = function (arr, v) { arr.remove(v); };
    /* Business Unit multi-select (2026-07-18) — butil scope: every budget line
       takes its PROJECT's Business Unit (projects master, real names since the
       extract fix); one pick-list + chips shared by the Budget Utilization and
       Projects Encumbrances pages. The Pending Approval page keeps its OWN
       snapshot-document BU filter (pnBuSel) and overrides p.bu in runPending. */
    self.buBus = ko.observableArray([]);
    self.buBuSel = ko.observableArray([]);
    self.buBuPick = ko.observable('');
    self.buBuAdd = function () {
      var v = self.buBuPick();
      if (v && self.buBuSel.indexOf(v) < 0) self.buBuSel.push(v);
      self.buBuPick('');
      return true;
    };
    self.buBuParam = function () { return self.buBuSel().join('|') || null; };
    // datalist inputs: an exact LOV value becomes a chip and clears the input
    self.buCcCommit = function () {
      var v = (self.buCc() || '').trim();
      if (v && self.buCcs().some(function (x) { return x.cc === v; })) {
        if (self.buCcSel.indexOf(v) < 0) self.buCcSel.push(v);
        self.buCc('');
      }
      return true;
    };
    self.buProjCommit = function () {
      var v = (self.buProject() || '').trim();
      if (v && self.buProjects().some(function (x) { return x.p === v; })) {
        if (self.buProjSel.indexOf(v) < 0) self.buProjSel.push(v);
        self.buProject('');
      }
      return true;
    };
    // chips + any residual free text -> one pipe-delimited request value
    function buMulti(selArr, txtObs) {
      var a = selArr().slice();
      var t = (txtObs() || '').trim();
      if (t && a.indexOf(t) < 0) a.push(t);
      return a.length > 1 ? a.join('|') : (a[0] || '');
    }
    self.buChapterParam = function () { return self.buChapterSel().join('|'); };
    self.buCcParam = function () { return buMulti(self.buCcSel, self.buCc); };
    self.buProjParam = function () { return buMulti(self.buProjSel, self.buProject); };
    // YTD period (MM-YYYY within the selected year; '' = full year)
    self.buPeriod = ko.observable('');
    self.buPeriodOpts = ko.computed(function () {
      var y = self.buYear(); if (!y) return [];
      var a = [];
      for (var m = 1; m <= 12; m++) a.push((m < 10 ? '0' + m : '' + m) + '-' + y);
      return a;
    });
    function buDefaultPeriod(y) {
      var now = new Date();
      if (Number(y) === now.getFullYear()) {
        var m = now.getMonth() + 1;
        return (m < 10 ? '0' + m : '' + m) + '-' + y;
      }
      return '';
    }
    self.buCcs = ko.observableArray([]); self.buProjects = ko.observableArray([]);
    self.buTasks = ko.observableArray([]); self.buEtypes = ko.observableArray([]);
    self.buItems = ko.observableArray([]); self.buTotals = ko.observable({});
    self.buTotal = ko.observable(0); self.buOffset = ko.observable(0); self.buLimit = 100;
    self.buLoading = ko.observable(false);
    self.buFiltersLoading = ko.observable(false);
    // one busy flag for the page overlay: initial filters load OR a running /butil search
    self.buBusy = ko.computed(function () { return self.buLoading() || self.buFiltersLoading(); });

    // autocomplete LOVs (cost centre / project / task / expenditure type) — per year
    var buLovYear = null;
    self.loadBuLovs = function () {
      var y = self.buYear();
      if (!y || y === buLovYear) return;
      buLovYear = y;
      api('GET', '/butil/lov' + qs({ year: y })).then(function (d) {
        // set the simple ($data) lists first so a render error in the object
        // datalists can never block them (defensive; the $data.* bindings fix the cause)
        self.buTasks(d.tasks || []); self.buEtypes(d.etypes || []);
        self.buCcs(d.costCenters || []); self.buProjects(d.projects || []);
      }).catch(function () { buLovYear = null; });
    };
    self.buYear.subscribe(function (y) {
      if (!self.buFiltersLoaded()) return;
      self.loadBuLovs();
      // a period belongs to one year — re-default when the year changes
      self.buPeriod(buDefaultPeriod(y));
    });

    self.loadBuFilters = function () {
      self.buFiltersLoading(true);
      return api('GET', '/butil/filters').then(function (d) {
        self.buYears(d.years || []);
        self.buTypes(d.projectTypes || []);
        self.buSectors(d.sectors || []);
        self.buChapters(d.chapters || []);
        self.buBus(d.businessUnits || []);
        self.buAppropList(d.appropriations || []);
        self.buProgramList(d.programs || []);
        // KO nulls a <select> value when options were empty at bind time; re-assert.
        if (!self.buYear() && d.defaultYear != null) self.buYear(d.defaultYear);
        if (!self.buTypeSel().length && (d.projectTypes || []).indexOf(BU_DEFAULT_TYPE) >= 0) self.buTypeSel([BU_DEFAULT_TYPE]);
        // default Business Unit to DCT on first load (only if the user hasn't picked one)
        if (!self.buBuSel().length && (d.businessUnits || []).indexOf(BU_DEFAULT_UNIT) >= 0) self.buBuSel([BU_DEFAULT_UNIT]);
        self.buPeriod(buDefaultPeriod(self.buYear()));
        self.buFiltersLoaded(true);
        self.buFiltersLoading(false);
        self.loadBuLovs();
      }).catch(function (e) { self.buFiltersLoading(false); fail(e); });
    };
    /* ── Include Budget Change (budget_change, v2 2026-08-17) — when on, /butil,
       both drill kinds and the report bridges send ovr=Y and the signed change
       is ADDED to the annual AND YTD budget server-side. The "applied" hint on
       the Budget Change tile binds to the RESPONSE flag (buConsiderOvr), so it
       can never claim a change the loaded figures don't actually reflect. */
    self.buOvr = ko.observable(false);
    self.buConsiderOvr = ko.observable(false);   // echoed by the last /butil response
    /* "Include Procash" (2026-08-17): money already pushed through the bank
       portal that has NOT reached Fusion as a payable invoice yet, so no AP,
       GRN, PR or PO figure sees it. It is ALWAYS reported by the server; with
       this on, it is added to Actual and subtracted from Fund Available. Like
       the override flag, the "included" state binds to the RESPONSE echo, so
       the page can never claim an adjustment the figures do not carry. */
    self.buProcash = ko.observable(false);
    self.buProcashOn = ko.observable(false);     // echoed by the last /butil response
    self.toggleBuProcash = function () {
      self.buProcash(!self.buProcash());
      if (self.buYear() && (self.buTotal() || self.buItems().length)) self.runButil(0);
      return true;
    };
    /* "Include Cost Adjustment" (2026-08-22, DEFAULT ON): approved Projects
       Costing Adjustment rows fold into the figures SERVER-side (Actual +adj,
       Budget +override, Fund follows), so the table, KPI band, CSV and the
       negFund band all move together. Lines carrying one are starred (*). */
    self.buCadj = ko.observable(true);
    self.buCadjOn = ko.observable(false);        // echoed by the last /butil response
    /* "Display Comments" (2026-08-23): NONE (default) / PERIOD / ALL — when on,
       /butil rows ship commentsText and the results table + CSV gain a
       Comments column; the Excel register adds sheet-1 comments + the
       other-levels sheet (cmtmode). */
    self.buCmtDisp = ko.observable('NONE');
    self.buCmtDispMode = ko.observable('NONE');  // echoed by the last /butil response
    self.buCmtDispOpts = ko.computed(function () {
      self.lang();
      return [{ v: 'NONE', l: self.t('cmtDispNone') },
              { v: 'PERIOD', l: self.t('cmtDispPeriod') },
              { v: 'ALL', l: self.t('cmtDispAll') }];
    });
    self.buCmtDisp.subscribe(function () {
      if (self.buYear() && (self.buTotal() || self.buItems().length)) self.runButil(self.buOffset());
    });
    self.toggleBuCadj = function () {
      self.buCadj(!self.buCadj());
      if (self.buYear() && (self.buTotal() || self.buItems().length)) self.runButil(0);
      return true;
    };
    self.toggleBuOvr = function () {
      self.buOvr(!self.buOvr());
      // re-run in place (AP include-cancelled precedent) once results exist
      if (self.buYear() && (self.buTotal() || self.buItems().length)) self.runButil(0);
      return true;
    };
    self.buParams = function (offset, limit) {
      return { year: self.buYear(), period: self.buPeriod(), projecttype: self.buType(), sector: self.buSector(), chapter: self.buChapterParam(),
        costcenter: self.buCcParam(), project: self.buProjParam(), task: self.buTask(), etype: self.buEtype(),
        bu: self.buBuParam(), appropriation: self.buApprop() || null, program: self.buProgram() || null,
        ovr: self.buOvr() ? 'Y' : null,
        procash: self.buProcash() ? 'Y' : null,
        costadj: self.buCadj() ? 'Y' : 'N',     // server default is Y — send N explicitly
        cmtdisp: self.buCmtDisp() !== 'NONE' ? self.buCmtDisp() : null,
        planstate: self.buPlanState() || null,  // plan-insight verdict filter (GL/db/32)
        search: self.buSearch(), limit: limit || self.buLimit, offset: offset || 0 };
    };
    self.runButil = function (offset) {
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      offset = Math.max(0, offset || 0); self.buLoading(true);
      return api('GET', '/butil' + qs(self.buParams(offset))).then(function (d) {
        self.buItems(d.items || []); self.buTotals(d.totals || {});
        self.buTotal(d.total || 0); self.buOffset(offset);
        self.buMissCc(d.missingCc || 0); self.buMissCcBudget(d.missingCcBudget || 0);
        self.buNegFund(d.negFund || 0); self.buNegFundTotal(d.negFundTotal || 0);
        self.buConsiderOvr(d.considerOverride === 'Y');
        self.buProcashOn(d.includeProcash === 'Y');
        self.buCadjOn(d.includeCostAdj === 'Y');
        self.buCmtOn(d.commentsEnabled === 'Y');
        self.buCmtDispMode(d.commentsDisplay || 'NONE');
        if (d.planThresholds) self.buPlanThr(d.planThresholds);
        if (d.budgetThresholds) self.buBudThr(d.budgetThresholds);
        self.buLoading(false);
        // Fund Movement per-key map (v1.94.0) — cheap no-op when year/period unchanged
        self.runBuFm('line');
        // keep the Department / Sector tab in step with the new criteria
        // (no-op when the agg params are unchanged — the cache key matches)
        if (self.buLevel() !== 'line') self.runBuAgg(self.buLevel());
      }).catch(function (e) { self.buLoading(false); fail(e); });
    };
    /* ── Results-region level tabs (v1.89.0, user layout pick B):
       1 Budget Line (the untouched line table) · 2 Department (cost-centre
       grain) · 3 Sector — Department/Sector come from GET /butil/agg
       (GL/db/33): the SAME butil join + filters GROUPed server-side, plus
       the uploaded plan rows with NO budget line folded into the group plan
       figures (a group with plan but no lines ships planOnly='Y'), so every
       tab figure reconciles to the Budget Line tab and the KPI band. */
    self.buLevel = ko.observable('line');
    self.buAggItems = ko.observableArray([]);
    self.buAggTotals = ko.observable({});
    self.buAggLoading = ko.observable(false);
    var buAggKey = null;
    self.buAggParams = function (level) {
      var p = self.buParams(0, 1);
      delete p.limit; delete p.offset; delete p.cmtdisp; delete p.planstate;
      p.level = level;
      return p;
    };
    self.runBuAgg = function (level) {
      var key = JSON.stringify(self.buAggParams(level));
      if (key === buAggKey && self.buAggItems().length) return;
      self.buAggLoading(true);
      return api('GET', '/butil/agg' + qs(self.buAggParams(level))).then(function (d) {
        buAggKey = key;
        self.buAggItems(d.items || []);
        self.buAggTotals(d.totals || {});
        self.buAggLoading(false);
        self.runBuFm(level);   // group Fund Movement map (v1.94.0)
      }).catch(function (e) { self.buAggLoading(false); fail(e); });
    };
    self.setBuLevel = function (lvl) {
      self.buLevel(lvl);
      if (lvl !== 'line') self.runBuAgg(lvl);
    };
    // a comment added/edited through the drawer must show up in the group's
    // Comments cell — drop the cache so the next fetch is fresh
    self.buAggInvalidate = function () { buAggKey = null; };
    // the toolbar summary strip re-computes per level (mock B's live strip)
    self.buLvlSum = ko.computed(function () {
      var lvl = self.buLevel();
      if (lvl === 'line') {
        var t = self.buTotals() || {};
        return { nl: self.t('lvLines'), n: self.fmt(self.buTotal() || 0),
          budget: t.budget, plan: t.planEffYtd,
          actual: (Number(t.actualAp) || 0) + (Number(t.actualGrn) || 0)
                  + (self.buProcashOn() ? (Number(t.procash) || 0) : 0),
          enc: (Number(t.commitmentPr) || 0) + (Number(t.obligationPo) || 0),
          fund: t.fundAvailable };
      }
      var a = self.buAggTotals() || {};
      return { nl: self.t(lvl === 'dept' ? 'lvDepts' : 'lvSectors'), n: self.fmt(a.groups || 0),
        budget: a.budget, plan: a.planEffYtd,
        actual: (Number(a.actualAp) || 0) + (Number(a.actualGrn) || 0)
                + (self.buProcashOn() ? (Number(a.procash) || 0) : 0),
        enc: (Number(a.commitmentPr) || 0) + (Number(a.obligationPo) || 0),
        fund: a.fundAvailable };
    });
    // the REVISED plan pair appears on the agg tables the same way it does on
    // the line table — only once any revised plan exists in the loaded set
    self.buAggRevOn = ko.computed(function () {
      var t = self.buAggTotals() || {};
      return (Number(t.planRevisedAnnual) || 0) !== 0;
    });
    self.buAggAnyPlanOnly = ko.computed(function () {
      return self.buAggItems().some(function (r) { return r.planOnly === 'Y'; });
    });
    self.buAnyAggAdjNote = ko.computed(function () {
      return self.buCadjOn()
        && self.buAggItems().some(function (r) { return r.hasAdj === 'Y'; });
    });
    self.buAggExtra = ko.computed(function () {
      return Number((self.buAggTotals() || {}).planExtra) || 0;
    });
    // group comments: a Department row opens the COST_CENTER-level thread,
    // a Sector row the SECTOR-level thread (db/v2/125 entity levels)
    self.openCmtGroup = function (row) {
      if (self.buLevel() === 'dept') {
        self.openCmt({ level: 'COST_CENTER', year: self.buYear(), period: self.buPeriod() || '',
          ekey: row.costCentre || '', name: row.department || '',
          title: self.t('lvDept') + ' — ' + (row.costCentre || '') + (row.department ? ' · ' + row.department : ''), sub: '' });
      } else {
        self.openCmt({ level: 'SECTOR', year: self.buYear(), period: self.buPeriod() || '',
          ekey: row.sector || '', name: row.sector || '',
          title: self.t('lvSector') + ' — ' + (row.sector || ''), sub: '' });
      }
    };
    // CSV for the aggregated tabs (client-side — the full set is loaded)
    self.buAggExportCsv = function () {
      var lvl = self.buLevel(), rows = self.buAggItems();
      // columns follow the ACTIVE Manage-columns view for this tab
      var cols = [];
      self.buColsAgg().forEach(function (c) { (c.csv || []).forEach(function (p) { cols.push(p); }); });
      cols = cols.concat([['planExtra', 'Plan Outside Budget Lines'], ['planOnly', 'Plan Only'], ['costAdj', 'Cost Adjustment']]);
      rows.forEach(function (r) {
        var fm = self.fmOfGrp(r);
        r._fmCnt = fm ? fm.cnt : ''; r._fmAmt = fm ? fm.amt : '';
      });
      var csv = cols.map(function (c) { return c[1]; }).join(',') + '\n' + rows.map(function (r) {
        return cols.map(function (c) { var v = (r[c[0]] == null ? '' : '' + r[c[0]]); return '"' + v.replace(/"/g, '""') + '"'; }).join(',');
      }).join('\n');
      var blob = new Blob(['\ufeff' + csv], { type: 'text/csv' }); var u = URL.createObjectURL(blob);
      var a = document.createElement('a'); a.href = u;
      a.download = 'gl_budget_utilization_' + (lvl === 'dept' ? 'departments_' : 'sectors_') + self.buYear() + '.csv';
      a.click(); URL.revokeObjectURL(u);
    };
    /* ── data-quality alert: budget lines (annual budget) with NO cost centre.
       Server counts them across the WHOLE filtered set on every /butil run;
       the red band shows only when the count is non-zero and drills to the
       shared drawer via /butil?nocc=Y (same filters). */
    self.buMissCc = ko.observable(0); self.buMissCcBudget = ko.observable(0);
    // any visible row carrying an approved cost adjustment -> show the (*) note;
    // both the star and the note appear only while the figures INCLUDE the
    // adjustments (the response echo), so the page never claims an adjustment
    // the loaded figures do not carry
    self.buAnyAdj = ko.computed(function () {
      return self.buCadjOn()
        && self.buItems().some(function (r) { return r.hasAdj === 'Y'; });
    });
    /* Expenditure plan (db/v2/126, 2026-08-26): APPROVED columns always show;
       the REVISED pair appears only once any revised plan exists in the
       filtered set (today the uploads are APPROVED-only). */
    self.buPlanRevOn = ko.computed(function () {
      var t = self.buTotals() || {};
      return (Number(t.planRevisedAnnual) || 0) !== 0
        || self.buItems().some(function (r) { return (Number(r.planRevisedAnnual) || 0) !== 0; });
    });
    // "(x.x%)" YTD-share-of-annual suffix on the Plan tile's YTD hero
    self.buPlanYtdPct = function () {
      var t = self.buTotals() || {}; var a = Number(t.planApprovedAnnual) || 0;
      if (!a || t.planApprovedYtd == null) return '';
      var p = (Number(t.planApprovedYtd) || 0) / a * 100;
      return '(' + (p >= 99.95 ? Math.round(p) : p.toFixed(1)) + '% ' + self.t('planOfAnnual') + ')';
    };
    // (**) marker + Comments column render only against a server that ships
    // the commentsEnabled echo (GL/db/21 CMT WIRED) — never against a stale one
    self.buCmtOn = ko.observable(false);
    self.buAnyCmt = ko.computed(function () {
      return self.buCmtOn()
        && self.buItems().some(function (r) { return r.hasCmt === 'Y'; });
    });
    // over-budget warning band: count + total of lines with NEGATIVE Fund
    // Available across the FULL filtered set (server aggregate, not page rows)
    self.buNegFund = ko.observable(0); self.buNegFundTotal = ko.observable(0);
    self.buNegMsg = ko.computed(function () {
      return self.t('buNegMsg')
        .replace('{n}', self.fmt(self.buNegFund()))
        .replace('{amt}', self.money(Math.abs(self.buNegFundTotal())));
    });
    /* Cost centre is MANDATORY on every budget line (user rule 2026-08-30):
       a Department/Sector group with NO key = lines missing that
       classification. The warning band fires from EITHER source — the /butil
       missingCc aggregate (any tab) or a keyless group on an agg tab — and
       the message takes its count/amount from whichever one tripped it. */
    self.buAggMissRow = ko.computed(function () {
      if (self.buLevel() === 'line') return null;
      var dept = self.buLevel() === 'dept';
      return self.buAggItems().filter(function (r) {
        return !(dept ? r.costCentre : r.sector);
      })[0] || null;
    });
    self.buMissBandOn = ko.computed(function () {
      return self.buMissCc() > 0 || !!self.buAggMissRow();
    });
    self.buMissCcMsg = ko.computed(function () {
      var n = self.buMissCc(), amt = self.buMissCcBudget();
      if (!n) {
        var m = self.buAggMissRow();
        if (m) { n = m.lines || 0; amt = m.budgetAnnual || 0; }
      }
      return self.t('buMissCcMsg')
        .replace('{n}', self.fmt(n))
        .replace('{amt}', self.money(amt));
    });
    self.openBuMissCc = function () {
      self.drillTitle(self.t('buMissCcDrill'));
      self.drillSub(self.t('buAllLines') + ' · ' + self.buYear());
      self.drillCtx([self.buType().split('|').join(', '), self.buSector(), self.buChapterParam().split('|').join(', '),
        self.buProjParam().split('|').join(', '), self.buTask(), self.buEtype(),
        self.buSearch() ? '“' + self.buSearch() + '”' : ''].filter(Boolean).join('   ·   '));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      var p = self.buParams(0, 5000); p.nocc = 'Y';
      api('GET', '/butil' + qs(p)).then(function (d) {
        self.drillCols([
          { key: 'projectNumber',   label: self.t('cProject'),     type: 'text' },
          { key: 'projectName',     label: self.t('buMissCcPName'), type: 'text' },
          { key: 'taskNumber',      label: self.t('cTask'),        type: 'text' },
          { key: 'expenditureType', label: self.t('cEtype'),       type: 'text' },
          { key: 'department',      label: self.t('cDept'),        type: 'text' },
          { key: 'appropriation',   label: self.t('segAppropriation'), type: 'text' },
          { key: 'budgetAnnual',    label: self.t('cBudgetAnnual'), type: 'money' }
        ]);
        self.drillRows(d.items || []);
        self.drillTotalV(d.missingCcBudget || 0); self.drillCount(d.total || 0);
        self.drillLoading(false);
      }).catch(drillFail);
    };
    /* ── over-budget alert: lines whose EFFECTIVE Fund Available is negative
       across the WHOLE filtered set (server aggregate, GL/db/28). Drills to
       the shared drawer via /butil?negfund=Y (same filters, incl. the page's
       own procash=/costadj= toggles so the drawer never disagrees with the
       band's own count/total). */
    self.openBuNegFund = function () {
      self.drillTitle(self.t('buNegDrill'));
      self.drillSub(self.t('buAllLines') + ' · ' + self.buYear());
      self.drillCtx([self.buType().split('|').join(', '), self.buSector(), self.buChapterParam().split('|').join(', '),
        self.buProjParam().split('|').join(', '), self.buTask(), self.buEtype(),
        self.buSearch() ? '“' + self.buSearch() + '”' : ''].filter(Boolean).join('   ·   '));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      var p = self.buParams(0, 5000); p.negfund = 'Y';
      api('GET', '/butil' + qs(p)).then(function (d) {
        self.drillCols([
          { key: 'projectNumber',   label: self.t('cProject'),      type: 'text' },
          { key: 'projectName',     label: self.t('buMissCcPName'), type: 'text' },
          { key: 'taskNumber',      label: self.t('cTask'),         type: 'text' },
          { key: 'expenditureType', label: self.t('cEtype'),        type: 'text' },
          { key: 'department',      label: self.t('cDept'),         type: 'text' },
          { key: 'budget',          label: self.t('cBudgetYtd'),    type: 'money' },
          { key: 'actualAp',        label: self.t('cActualAp'),     type: 'money' },
          { key: 'actualGrn',       label: self.t('cActualGrn'),    type: 'money' },
          { key: 'commitmentPr',    label: self.t('cCommitPr'),     type: 'money' },
          { key: 'obligationPo',    label: self.t('cObligPo'),      type: 'money' },
          { key: 'fundAvailable',   label: self.t('cFundAvail'),    type: 'money' }
        ]);
        self.drillRows(d.items || []);
        self.drillTotalV(d.negFundTotal || 0); self.drillCount(d.total || 0);
        self.drillLoading(false);
      }).catch(drillFail);
    };
    self.buReset = function () {
      self.buTypeSel(self.buTypes().indexOf(BU_DEFAULT_TYPE) >= 0 ? [BU_DEFAULT_TYPE] : []);
      self.buTypePick('');
      self.buSector(''); self.buSearch(''); self.buApprop(''); self.buProgram('');
      self.buChapterSel.removeAll(); self.buCcSel.removeAll(); self.buProjSel.removeAll();
      self.buChapterPick('');
      self.buBuSel(self.buBus().indexOf(BU_DEFAULT_UNIT) >= 0 ? [BU_DEFAULT_UNIT] : []); self.buBuPick('');
      self.buCc(''); self.buProject(''); self.buTask(''); self.buEtype('');
      self.buOvr(false);
      self.buCadj(true);                        // cost adjustment is on by default
      self.buCmtDisp('NONE');                   // comments display off by default
      self.buPlanState('');                     // plan-insight verdict filter off
      self.buPlanMode('YES');                   // Show Plan defaults Yes
      if (self.buYears().length) self.buYear(self.buYears()[0]);
      self.buPeriod(buDefaultPeriod(self.buYear()));
      self.runButil(0);
    };
    self.buRange = ko.computed(function () {
      if (!self.buTotal()) return '';
      var a = self.buOffset() + 1, b = Math.min(self.buOffset() + self.buLimit, self.buTotal());
      return a + '–' + b + ' ' + self.t('rowsOf') + ' ' + self.fmt(self.buTotal());
    });
    self.buTot = function (k) { var t = self.buTotals() || {}; return t[k]; };
    // KPI band context: each measure as a share of the filtered budget
    self.buPct = function (k) {
      var t = self.buTotals() || {}; var b = Number(t.budget) || 0;
      if (!b) return null;
      return (Number(t[k]) || 0) / b * 100;
    };
    self.buBarW = function (k) {
      var p = self.buPct(k);
      return (p == null ? 0 : Math.max(0, Math.min(100, p))) + '%';
    };
    self.buPctTxt = function (k) {
      var p = self.buPct(k);
      if (p == null) return '';
      return (p >= 99.95 ? Math.round(p) : p.toFixed(1)) + '% ' + self.t('buOfBudget');
    };
    self.buFundSub = ko.computed(function () {
      var t = self.buTotals() || {}; var b = Number(t.budget) || 0;
      if (!b) return '';
      var f = Number(t.fundAvailable) || 0;
      if (f < 0) return self.t('buOverBudget');
      return (f / b * 100).toFixed(1) + '% ' + self.t('buRemaining');
    });
    // consolidated KPI tiles (2026-07-14): Total Actual = AP + GRN,
    // Total Encumbrance = open Commitment (PR) + open Obligation (PO)
    self.buActualTot = ko.computed(function () {
      var t = self.buTotals() || {};
      if (t.actualAp == null && t.actualGrn == null) return null;
      // procash joins Actual only when the server says it was included, so the
      // tile always matches the Fund figure beside it
      return (Number(t.actualAp) || 0) + (Number(t.actualGrn) || 0)
             + (self.buProcashOn() ? (Number(t.procash) || 0) : 0);
    });
    self.buEncumbTot = ko.computed(function () {
      var t = self.buTotals() || {};
      if (t.commitmentPr == null && t.obligationPo == null) return null;
      return (Number(t.commitmentPr) || 0) + (Number(t.obligationPo) || 0);
    });
    /* ── Plan Insights (v1.88.0, GL/db/32 — mockups D1 + K1 + K2): the server
       computes each row's Plan-vs-Actual verdict (planExecState WITHIN/BELOW/
       AHEAD/NOPLAN + planExecPct/planVariance, effective plan = REVISED when
       one exists) and Plan-vs-Budget coverage (planCovState FULL/UNDER/OVER/
       NONE + planCovPct), plus full-filtered-set aggregates in totals. The
       thresholds are echoed per response (GL module settings) so the page
       colors rows EXACTLY as the server counted them. */
    /* "Show Plan" LOV (v1.88.1, user feedback): YES (default) = plan columns +
       vs Plan / Plan Coverage indicators; NO = no plan columns in the results
       table; INSIGHTS = everything incl. the D2 micro-chart + D3 composite.
       Frontend-only — rows always carry the data (CSV stays complete). */
    self.buPlanMode = ko.observable('YES');
    self.buPlanModeOpts = ko.computed(function () {
      self.lang();
      return [{ v: 'YES', l: self.t('piModeYes') },
              { v: 'NO', l: self.t('piModeNo') },
              { v: 'INSIGHTS', l: self.t('piModeIns') }];
    });
    self.buPlanOn = ko.computed(function () { return self.buPlanMode() !== 'NO'; });
    self.buPlanIns = ko.computed(function () { return self.buPlanMode() === 'INSIGHTS'; });
    self.buPlanState = ko.observable('');          // planstate verdict filter (K1/K2 drills)
    self.buPlanThr = ko.observable({ execLow: 90, execHigh: 110, covLow: 95, covHigh: 105 });
    self.piHand = function (s) { return s === 'WITHIN' ? '👍' : s === 'BELOW' ? '👎' : s === 'AHEAD' ? '✋' : '—'; };
    self.piCls = function (s) { return s === 'WITHIN' ? 'ok' : s === 'BELOW' ? 'low' : s === 'AHEAD' ? 'high' : 'none'; };
    self.piLbl = function (s) {
      return s === 'WITHIN' ? self.t('piWithin') : s === 'BELOW' ? self.t('piBelow')
           : s === 'AHEAD' ? self.t('piAhead') : self.t('piNone');
    };
    self.piCovCls = function (s) { return s === 'FULL' ? 'full' : s === 'UNDER' ? 'under' : s === 'OVER' ? 'over' : 'np'; };
    self.piCovLbl = function (s) {
      return s === 'FULL' ? self.t('piCovFull') : s === 'UNDER' ? self.t('piCovUnder')
           : s === 'OVER' ? self.t('piCovOver') : self.t('piCovNone');
    };
    self.pct1 = function (p) { return p == null ? '' : '' + (Math.round(p * 10) / 10); };
    self.piVsTxt = function (r) { return r.planExecPct != null ? self.pct1(r.planExecPct) + '%' : ''; };
    self.piCovTxt = function (r) {
      if (r.planCovState === 'NONE' || !r.planCovState) return self.t('piCovNone');
      return (r.planCovPct != null ? self.pct1(r.planCovPct) + '% · ' : '') + self.piCovLbl(r.planCovState);
    };
    self.piRowTip = function (r) {
      if (r.planExecState === 'NOPLAN' || !r.planExecState) return self.t('piNone');
      return self.piLbl(r.planExecState) + ' — ' + self.t('piDelta') + ' ' + self.money(r.planVariance || 0);
    };
    // D2 micro-chart geometry: track = plan YTD (100%), fill = actual (capped),
    // dark tick = YTD budget on the same scale, thin plum bar = coverage %
    self.piFillW = function (r) { return Math.max(0, Math.min(100, Number(r.planExecPct) || 0)) + '%'; };
    self.piTickW = function (r) {
      var pl = Number(r.planEffYtd) || 0; if (pl <= 0) return '0%';
      return Math.max(0, Math.min(100, 100 * (Number(r.budget) || 0) / pl)) + '%';
    };
    self.piCovW = function (r) { return Math.max(0, Math.min(100, Number(r.planCovPct) || 0)) + '%'; };
    self.piCovCapTxt = function (r) {
      return r.planCovPct != null ? self.t('piCovCap').replace('{p}', self.pct1(r.planCovPct)) : self.t('piCovNone');
    };
    // K1 tiles: overall execution / coverage over the WHOLE filtered set
    self.piExecPct = ko.computed(function () {
      var t = self.buTotals() || {}; var p = Number(t.planEffYtd) || 0;
      if (!p) return null; return (self.buActualTot() || 0) / p * 100;
    });
    self.piExecState = ko.computed(function () {
      var p = self.piExecPct(); var th = self.buPlanThr();
      if (p == null) return 'NOPLAN';
      return p < th.execLow ? 'BELOW' : p > th.execHigh ? 'AHEAD' : 'WITHIN';
    });
    self.piCovPct = ko.computed(function () {
      var t = self.buTotals() || {}; var b = Number(t.budgetAnnual) || 0;
      if (!b) return null; return (Number(t.planEffAnnual) || 0) / b * 100;
    });
    self.setPlanState = function (s) { self.buPlanState(s); self.runButil(0); };
    self.clearPlanState = function () { self.buPlanState(''); self.runButil(0); };
    self.piVsHdrTip = ko.computed(function () {
      var th = self.buPlanThr();
      return self.t('piVsPlanHint').replace('{lo}', th.execLow).replace('{hi}', th.execHigh);
    });
    self.piCovHdrTip = ko.computed(function () {
      var th = self.buPlanThr();
      return self.t('piCovColHint').replace('{lo}', th.covLow).replace('{hi}', th.covHigh);
    });

    /* ── vs Budget verdict (v1.96.0, GL/db/35): the server classifies each
       row's displayed Total Actual against its ADJUSTED ANNUAL budget (user
       rule 2026-08-31: Annual always, never the YTD slice) — OK below the
       near threshold, NEAR up to the over threshold, OVER above it; spend on
       a zero-budget line = OVER, nothing at all = NOBUDGET. Thresholds are
       echoed per response (BUD_UTIL_NEAR_PCT / BUD_UTIL_OVER_PCT settings). */
    self.buBudThr = ko.observable({ near: 90, over: 100 });
    self.bdHand = function (s) { return s === 'OK' ? '👍' : s === 'NEAR' ? '✋' : s === 'OVER' ? '👎' : '—'; };
    self.bdCls = function (s) { return s === 'OK' ? 'ok' : s === 'NEAR' ? 'low' : s === 'OVER' ? 'high' : 'none'; };
    self.bdLbl = function (s) {
      return s === 'OK' ? self.t('bdOk') : s === 'NEAR' ? self.t('bdNear')
           : s === 'OVER' ? self.t('bdOver') : self.t('bdNone');
    };
    self.bdTxt = function (r) { return r.budUtilPct != null ? self.pct1(r.budUtilPct) + '%' : ''; };
    self.bdRowTip = function (r) {
      if (!r.budState || r.budState === 'NOBUDGET') return self.t('bdNone');
      return self.bdLbl(r.budState)
        + (r.budVariance != null ? ' — ' + self.t('bdDelta') + ' ' + self.money(r.budVariance) : '');
    };
    self.bdHdrTip = ko.computed(function () {
      var th = self.buBudThr();
      return self.t('bdColHint').replace(/\{n\}/g, th.near).replace(/\{o\}/g, th.over);
    });

    /* ── Manage columns (v1.96.0): both results tables are COLUMN-REGISTRY
       driven — each column is one row below (key, label/hint keys, th css,
       cell template id, optional feature gate, CSV expansion, Excel-Register
       sheet-1 column mapping). The header and body render from the ACTIVE
       view (order + hidden set); the same view drives the CSV export and,
       for the Budget Line tab, the Excel Register sheet 1 (sheetcols →
       runner _apply_sheet_cols). Views are NAMED, saved per level to the
       user's server prefs (gl.butil.colviews via /dct/prefs — they roam
       with the account; localStorage is the instant-boot mirror). */
    var BU_LINE_COLS = [
      { k: 'sector', l: 'fSectorL', h: 'chSector', tpl: 'buc-sector', csv: [['sector', 'Sector']], xls: ['sector'] },
      { k: 'department', l: 'cDept', h: 'chDept', tpl: 'buc-department', csv: [['department', 'Department']], xls: ['department'] },
      { k: 'organization', l: 'cOrg', h: 'chOrg', tpl: 'buc-organization', csv: [['organization', 'Organization']], xls: ['organization'] },
      { k: 'costCentre', l: 'costCenter', h: 'chCc', tpl: 'buc-costcentre', csv: [['costCentre', 'Cost Centre']], xls: ['cost_centre'] },
      { k: 'project', l: 'cProject', h: 'chProject', tpl: 'buc-project', csv: [['projectNumber', 'Project Number'], ['projectName', 'Project Name']], xls: ['project_number', 'project_name'] },
      { k: 'task', l: 'cTask', h: 'chTask', tpl: 'buc-task', csv: [['taskNumber', 'Task']], xls: ['task_number'] },
      { k: 'taskName', l: 'cTaskName', h: 'chTaskName', tpl: 'buc-taskname', csv: [['taskName', 'Task Name']], xls: ['task_name'] },
      { k: 'glAccount', l: 'cGlAccount', h: 'chGlAccount', tpl: 'buc-glaccount', csv: [['glAccount', 'GL Account']], xls: ['account_number', 'ebs_account'] },
      { k: 'appropriation', l: 'thAppr', h: 'chAppr', tpl: 'buc-appropriation', csv: [['appropriation', 'Appropriation']], xls: ['appropriation_code', 'appropriation_name'] },
      { k: 'chapter', l: 'cChapter', h: 'chChapter', tpl: 'buc-chapter', csv: [['chapter', 'Chapter']], xls: ['chapter'] },
      { k: 'program', l: 'program', h: 'chProgram', tpl: 'buc-program', csv: [['program', 'Program']], xls: ['dct_program_code', 'dct_program_name'] },
      { k: 'etype', l: 'cEtype', h: 'chEtype', tpl: 'buc-etype', csv: [['expenditureType', 'Expenditure Type']], xls: ['expenditure_type'] },
      { k: 'budgetAnnual', l: 'cBudgetAnnual', h: 'chBudgetAnnual', cls: 'num', tpl: 'buc-budgetannual', csv: [['budgetAnnual', 'Annual Budget']], xls: ['annual_budget'] },
      { k: 'budget', l: 'cBudgetYtd', h: 'chBudgetYtd', cls: 'num', tpl: 'buc-budget', csv: [['budget', 'YTD Budget']], xls: ['ytd_budget'] },
      { k: 'vsBudget', l: 'cVsBudget', hf: 'bdHdrTip', cls: 'pi-th', tpl: 'buc-vsbudget',
        csv: [['budUtilPct', 'Budget Utilization %'], ['budVariance', 'Budget Variance'], ['budState', 'Budget Status']],
        xls: ['budget_utilization_pct', 'budget_variance', 'budget_status'] },
      { k: 'planApprA', l: 'cPlanApprA', h: 'chPlanA', cls: 'num', tpl: 'buc-planappra', gate: function () { return self.buPlanOn(); }, csv: [['planApprovedAnnual', 'Plan Annual']], xls: ['plan_annual'] },
      { k: 'planApprY', l: 'cPlanApprY', h: 'chPlanY', cls: 'num', tpl: 'buc-planappry', gate: function () { return self.buPlanOn(); }, csv: [['planApprovedYtd', 'Plan YTD']], xls: ['plan_ytd'] },
      { k: 'planRevA', l: 'cPlanRevA', h: 'chPlanRevA', cls: 'num', tpl: 'buc-planreva', gate: function () { return self.buPlanOn() && self.buPlanRevOn(); }, csv: [['planRevisedAnnual', 'Revised Plan Annual']], xls: ['revised_plan_annual'] },
      { k: 'planRevY', l: 'cPlanRevY', h: 'chPlanRevY', cls: 'num', tpl: 'buc-planrevy', gate: function () { return self.buPlanOn() && self.buPlanRevOn(); }, csv: [['planRevisedYtd', 'Revised Plan YTD']], xls: ['revised_plan_ytd'] },
      { k: 'vsPlan', l: 'cVsPlan', hf: 'piVsHdrTip', cls: 'pi-th', tpl: 'buc-vsplan', gate: function () { return self.buPlanOn(); },
        csv: [['planEffYtd', 'Effective Plan YTD'], ['planExecPct', 'Plan Utilization %'], ['planVariance', 'Plan Variance'], ['planExecState', 'Plan Status']],
        xls: ['plan_utilization_pct', 'plan_variance', 'plan_status'] },
      { k: 'planCov', l: 'cPlanCov', hf: 'piCovHdrTip', cls: 'pi-th', tpl: 'buc-plancov', gate: function () { return self.buPlanOn(); },
        csv: [['planCovPct', 'Plan Coverage %'], ['planCovState', 'Coverage Status']], xls: ['plan_coverage_pct', 'plan_coverage_status'] },
      { k: 'planPerf', l: 'cPlanPerf', hf: 'piVsHdrTip', cls: 'pi-th pi-th-wide', tpl: 'buc-planperf', gate: function () { return self.buPlanIns(); }, csv: [], xls: [] },
      { k: 'planComp', l: 'cPlanComp', hf: 'piVsHdrTip', cls: 'pi-th pi-th-wide', tpl: 'buc-plancomp', gate: function () { return self.buPlanIns(); }, csv: [], xls: [] },
      { k: 'actualAp', l: 'cActualAp', h: 'chActualAp', cls: 'num', tpl: 'buc-actualap', csv: [['actualAp', 'Actual AP']], xls: ['actual_ap'] },
      { k: 'actualGrn', l: 'cActualGrn', h: 'chActualGrn', cls: 'num', tpl: 'buc-actualgrn', csv: [['actualGrn', 'Actual GRN']], xls: ['actual_grn', 'actual_total'] },
      { k: 'procash', l: 'cProcash', h: 'buProcashHint', cls: 'num', tpl: 'buc-procash', csv: [['procash', 'Procash']], xls: [] },
      { k: 'commitmentPr', l: 'cCommitPr', h: 'chPr', cls: 'num', tpl: 'buc-commitmentpr', csv: [['commitmentPr', 'Commitment (PR)']], xls: ['commitment_pr'] },
      { k: 'obligationPo', l: 'cObligPo', h: 'chPo', cls: 'num', tpl: 'buc-obligationpo', csv: [['obligationPo', 'Obligation (PO)']], xls: ['obligation_po', 'open_encumbrance'] },
      { k: 'fundAvailable', l: 'cFundAvail', h: 'chFund', cls: 'num', tpl: 'buc-fundavailable', csv: [['fundAvailable', 'Fund Available']], xls: ['fund_available', 'utilization_pct'] },
      { k: 'fmCnt', l: 'cFmCnt', h: 'chFmCnt', cls: 'num', tpl: 'buc-fmcnt', csv: [['_fmCnt', 'Fund Movement Count']], xls: ['fund_movement_count'] },
      { k: 'fmAmt', l: 'cFmAmt', h: 'chFmAmt', cls: 'num', tpl: 'buc-fmamt', csv: [['_fmAmt', 'Fund Movement Amount']], xls: ['fund_movement_amount'] },
      { k: 'cmtText', l: 'cmtTextCol', h: 'chCmtTxt', cls: 'cmt-txt-th', tpl: 'buc-cmttext', gate: function () { return self.buCmtDispMode() !== 'NONE'; }, csv: [['commentsText', 'Comments Text']], xls: ['comments'] },
      { k: 'cmtBtn', l: 'cmtCol', h: 'chCmt', cls: 'cmt-th', tpl: 'buc-cmtbtn', gate: function () { return self.buCmtOn(); }, csv: [['cmtCount', 'Comments'], ['hasCmt', 'Has Comments']], xls: [] }
    ];
    var BU_AGG_COLS = [
      { k: 'sector', l: 'fSectorL', h: 'chSector', tpl: 'bua-sector', csv: [['sector', 'Sector']] },
      { k: 'costCentre', l: 'costCenter', h: 'chCc', tpl: 'bua-costcentre', gate: function () { return self.buLevel() === 'dept'; }, csv: [['costCentre', 'Cost Centre']] },
      { k: 'department', l: 'cDept', h: 'chDept', tpl: 'bua-department', gate: function () { return self.buLevel() === 'dept'; }, csv: [['department', 'Department']] },
      { k: 'lines', l: 'lvLines', h: 'chLines', cls: 'num', tpl: 'bua-lines', csv: [['lines', 'Lines']] },
      { k: 'budgetAnnual', l: 'cBudgetAnnual', h: 'chBudgetAnnual', cls: 'num', tpl: 'bua-budgetannual', csv: [['budgetAnnual', 'Annual Budget']] },
      { k: 'budget', l: 'cBudgetYtd', h: 'chBudgetYtd', cls: 'num', tpl: 'bua-budget', csv: [['budget', 'YTD Budget']] },
      { k: 'vsBudget', l: 'cVsBudget', hf: 'bdHdrTip', cls: 'pi-th', tpl: 'bua-vsbudget',
        csv: [['budUtilPct', 'Budget Utilization %'], ['budVariance', 'Budget Variance'], ['budState', 'Budget Status']] },
      { k: 'planApprA', l: 'cPlanApprA', h: 'chPlanA', cls: 'num', tpl: 'bua-planappra', csv: [['planApprovedAnnual', 'Plan Annual']] },
      { k: 'planApprY', l: 'cPlanApprY', h: 'chPlanY', cls: 'num', tpl: 'bua-planappry', csv: [['planApprovedYtd', 'Plan YTD']] },
      { k: 'planRevA', l: 'cPlanRevA', h: 'chPlanRevA', cls: 'num', tpl: 'bua-planreva', gate: function () { return self.buAggRevOn(); }, csv: [['planRevisedAnnual', 'Revised Plan Annual']] },
      { k: 'planRevY', l: 'cPlanRevY', h: 'chPlanRevY', cls: 'num', tpl: 'bua-planrevy', gate: function () { return self.buAggRevOn(); }, csv: [['planRevisedYtd', 'Revised Plan YTD']] },
      { k: 'vsPlan', l: 'cVsPlan', hf: 'piVsHdrTip', cls: 'pi-th', tpl: 'bua-vsplan',
        csv: [['planEffYtd', 'Effective Plan YTD'], ['planExecPct', 'Plan Utilization %'], ['planVariance', 'Plan Variance'], ['planExecState', 'Plan Status']] },
      { k: 'planCov', l: 'cPlanCov', hf: 'piCovHdrTip', cls: 'pi-th', tpl: 'bua-plancov', csv: [['planCovPct', 'Plan Coverage %'], ['planCovState', 'Coverage Status']] },
      { k: 'actualAp', l: 'cActualAp', h: 'chActualAp', cls: 'num', tpl: 'bua-actualap', csv: [['actualAp', 'Actual AP']] },
      { k: 'actualGrn', l: 'cActualGrn', h: 'chActualGrn', cls: 'num', tpl: 'bua-actualgrn', csv: [['actualGrn', 'Actual GRN']] },
      { k: 'procash', l: 'cProcash', h: 'buProcashHint', cls: 'num', tpl: 'bua-procash', csv: [['procash', 'Procash']] },
      { k: 'commitmentPr', l: 'cCommitPr', h: 'chPr', cls: 'num', tpl: 'bua-commitmentpr', csv: [['commitmentPr', 'Commitment (PR)']] },
      { k: 'obligationPo', l: 'cObligPo', h: 'chPo', cls: 'num', tpl: 'bua-obligationpo', csv: [['obligationPo', 'Obligation (PO)']] },
      { k: 'fundAvailable', l: 'cFundAvail', h: 'chFund', cls: 'num', tpl: 'bua-fundavailable', csv: [['fundAvailable', 'Fund Available']] },
      { k: 'fmCnt', l: 'cFmCnt', h: 'chFmCnt', cls: 'num', tpl: 'bua-fmcnt', csv: [['_fmCnt', 'Fund Movement Count']] },
      { k: 'fmAmt', l: 'cFmAmt', h: 'chFmAmt', cls: 'num', tpl: 'bua-fmamt', csv: [['_fmAmt', 'Fund Movement Amount']] },
      { k: 'cmtBtn', l: 'cmtCol', h: 'chCmtGrp', cls: 'cmt-th cmt-th-agg', tpl: 'bua-cmtbtn', gate: function () { return self.buCmtOn(); }, csv: [['cmtCount', 'Comments']] }
    ];
    var COLVIEW_PREF = 'gl.butil.colviews';
    var COLVIEW_LS = 'gl_bu_colviews';
    self.buColData = ko.observable((function () {
      try { return JSON.parse(localStorage.getItem(COLVIEW_LS) || 'null') || {}; } catch (e) { return {}; }
    })());
    // server pref wins over the local mirror (views roam with the account)
    fetch('/ords/admin/dct/prefs/', { headers: { 'Authorization': 'Bearer ' + TOKEN } })
      .then(function (r) { return r.ok ? r.json() : null; })
      .then(function (d) {
        var hit = ((d && d.items) || []).filter(function (p) { return p.key === COLVIEW_PREF; })[0];
        if (hit && hit.value) {
          try {
            self.buColData(JSON.parse(hit.value));
            localStorage.setItem(COLVIEW_LS, hit.value);
          } catch (e) { /* keep the local mirror */ }
        }
      }).catch(function () {});
    function colPersist() {
      var v = JSON.stringify(self.buColData());
      try { localStorage.setItem(COLVIEW_LS, v); } catch (e) {}
      fetch('/ords/admin/dct/prefs/' + COLVIEW_PREF, {
        method: 'PUT',
        headers: { 'Authorization': 'Bearer ' + TOKEN, 'Content-Type': 'application/json' },
        body: JSON.stringify({ value: v })
      }).catch(function () {});
    }
    // the active state for a level: last applied layout, else its default view
    self.buColState = function (lvl) {
      var d = self.buColData()[lvl] || {};
      if (d.active && d.active.order) return d.active;
      if (d.def && d.views && d.views[d.def]) return d.views[d.def];
      return null;
    };
    // registry keys ADDED after a view was saved slot in at their registry
    // position (the shared-IR reconcile rule) instead of vanishing
    function colReconcile(reg, st) {
      if (!st || !st.order) return null;
      var valid = {}; reg.forEach(function (c) { valid[c.k] = 1; });
      var order = st.order.filter(function (k) { return valid[k]; });
      reg.forEach(function (c, i) {
        if (order.indexOf(c.k) >= 0 || (st.off || []).indexOf(c.k) >= 0) return;
        var pos = -1;
        for (var j = i - 1; j >= 0; j--) {
          var p = order.indexOf(reg[j].k);
          if (p >= 0) { pos = p; break; }
        }
        order.splice(pos + 1, 0, c.k);
      });
      return { order: order, off: (st.off || []).filter(function (k) { return valid[k]; }) };
    }
    function colActive(reg, lvl) {
      var st = colReconcile(reg, self.buColState(lvl));
      var order = st ? st.order : reg.map(function (c) { return c.k; });
      var off = st ? st.off : [];
      var byK = {}; reg.forEach(function (c) { byK[c.k] = c; });
      return order.map(function (k) { return byK[k]; }).filter(function (c) {
        return c && off.indexOf(c.k) < 0 && (!c.gate || c.gate());
      });
    }
    self.buColsLine = ko.computed(function () { self.buColData(); return colActive(BU_LINE_COLS, 'line'); });
    self.buColsAgg = ko.computed(function () {
      self.buColData();
      return colActive(BU_AGG_COLS, self.buLevel() === 'sector' ? 'sector' : 'dept');
    });
    self.buColHint = function (c) { return c.hf ? self[c.hf]() : (c.h ? self.t(c.h) : ''); };
    // ordered register sheet-1 column list for the ACTIVE line view; null while
    // the standard layout is untouched so a default run keeps the full sheet
    self.buSheetCols = function () {
      var st = colReconcile(BU_LINE_COLS, self.buColState('line'));
      if (!st) return null;
      var byK = {}; BU_LINE_COLS.forEach(function (c) { byK[c.k] = c; });
      var out = ['budget_combination'], seen = { budget_combination: 1 };
      st.order.forEach(function (k) {
        var c = byK[k];
        if (!c || st.off.indexOf(k) >= 0) return;
        (c.xls || []).forEach(function (n) { if (!seen[n]) { seen[n] = 1; out.push(n); } });
      });
      return out.length > 1 ? out.join(',') : null;
    };
    /* ── Manage-columns drawer ── */
    self.colDrOpen = ko.observable(false);
    self.colDrLevel = ko.observable('line');
    self.colDrItems = ko.observableArray([]);
    self.colDrViewNames = ko.observableArray([]);
    self.colDrViewSel = ko.observable('');
    self.colDrName = ko.observable('');
    self.colDrDef = ko.observable('');
    function colReg(lvl) { return lvl === 'line' ? BU_LINE_COLS : BU_AGG_COLS; }
    function colItemsFrom(reg, st) {
      var order = st ? st.order : reg.map(function (c) { return c.k; });
      var off = st ? st.off : [];
      var byK = {}; reg.forEach(function (c) { byK[c.k] = c; });
      return order.map(function (k) {
        var c = byK[k];
        return { k: k, c: c, on: ko.observable(off.indexOf(k) < 0), gated: !!(c.gate && !c.gate()) };
      });
    }
    self.openColDrawer = function () {
      var lvl = self.buLevel();
      self.colDrLevel(lvl);
      var reg = colReg(lvl);
      self.colDrItems(colItemsFrom(reg, colReconcile(reg, self.buColState(lvl))));
      var d = self.buColData()[lvl] || {};
      self.colDrViewNames(Object.keys(d.views || {}));
      self.colDrDef(d.def || '');
      self.colDrViewSel(''); self.colDrName('');
      self.colDrOpen(true);
    };
    self.closeColDrawer = function () { self.colDrOpen(false); };
    self.colMove = function (it, dir) {
      var a = self.colDrItems().slice();
      var i = a.indexOf(it), j = i + dir;
      if (i < 0 || j < 0 || j >= a.length) return;
      a.splice(i, 1); a.splice(j, 0, it);
      self.colDrItems(a);
    };
    self.colSetAll = function (on) { self.colDrItems().forEach(function (it) { it.on(on); }); };
    function colDrState() {
      return { order: self.colDrItems().map(function (it) { return it.k; }),
               off: self.colDrItems().filter(function (it) { return !it.on(); }).map(function (it) { return it.k; }) };
    }
    function colDataFor(lvl) {
      var d = self.buColData();
      d[lvl] = d[lvl] || {}; d[lvl].views = d[lvl].views || {};
      return d;
    }
    self.colApply = function () {
      var lvl = self.colDrLevel(); var d = colDataFor(lvl);
      d[lvl].active = colDrState();
      self.buColData(Object.assign({}, d)); colPersist();
      self.colDrOpen(false);
      toast(self.t('colsAppliedToast'));
    };
    self.colSaveView = function () {
      var name = (self.colDrName() || self.colDrViewSel() || '').trim();
      if (!name) { toast(self.t('colsNeedName'), true); return; }
      var lvl = self.colDrLevel(); var d = colDataFor(lvl);
      d[lvl].views[name] = colDrState();
      d[lvl].active = colDrState();
      if (!d[lvl].def) d[lvl].def = name;
      self.buColData(Object.assign({}, d)); colPersist();
      self.colDrViewNames(Object.keys(d[lvl].views));
      self.colDrViewSel(name); self.colDrDef(d[lvl].def || '');
      toast(self.t('colsSavedToast'));
    };
    self.colDrViewSel.subscribe(function (name) {
      if (!name) return;
      var lvl = self.colDrLevel();
      var d = self.buColData()[lvl] || {};
      var v = (d.views || {})[name];
      if (!v) return;
      var reg = colReg(lvl);
      self.colDrItems(colItemsFrom(reg, colReconcile(reg, v)));
      self.colDrName(name);
    });
    self.colDeleteView = function () {
      var name = self.colDrViewSel(); if (!name) return;
      var lvl = self.colDrLevel(); var d = colDataFor(lvl);
      delete d[lvl].views[name];
      if (d[lvl].def === name) d[lvl].def = '';
      self.buColData(Object.assign({}, d)); colPersist();
      self.colDrViewNames(Object.keys(d[lvl].views));
      self.colDrViewSel(''); self.colDrName(''); self.colDrDef(d[lvl].def || '');
    };
    self.colSetDefault = function () {
      var name = self.colDrViewSel(); if (!name) { toast(self.t('colsNeedName'), true); return; }
      var lvl = self.colDrLevel(); var d = colDataFor(lvl);
      d[lvl].def = name;
      self.buColData(Object.assign({}, d)); colPersist();
      self.colDrDef(name);
    };
    self.colReset = function () {
      var lvl = self.colDrLevel(); var d = colDataFor(lvl);
      d[lvl].active = null;
      self.buColData(Object.assign({}, d)); colPersist();
      self.colDrItems(colItemsFrom(colReg(lvl), null));
      self.colDrViewSel(''); self.colDrName('');
    };
    // K2 insight strips — hidden while a planstate filter is applied (the chip
    // beside the Results header takes over)
    self.piExecBandOn = ko.computed(function () {
      return !self.buPlanState() && ((self.buTot('planBelow') || 0) > 0 || (self.buTot('planAhead') || 0) > 0);
    });
    self.piCovBandOn = ko.computed(function () {
      return !self.buPlanState() && self.piCovPct() != null;
    });
    self.piExecBandMsg = ko.computed(function () {
      return self.t('piExecBandMsg')
        .replace('{b}', self.fmt(self.buTot('planBelow') || 0)).replace('{ba}', self.money(self.buTot('planBelowAmt') || 0))
        .replace('{a}', self.fmt(self.buTot('planAhead') || 0)).replace('{aa}', self.money(self.buTot('planAheadAmt') || 0));
    });
    self.piCovBandMsg = ko.computed(function () {
      return self.t('piCovBandMsg')
        .replace('{p}', self.pct1(self.piCovPct()))
        .replace('{amt}', self.money(self.buTot('planCovGap') || 0))
        .replace('{u}', self.fmt(self.buTot('planCovUnder') || 0))
        .replace('{n}', self.fmt(self.buTot('planCovNone') || 0));
    });
    // width of one component inside the tile's stacked composition bar
    self.buSegW = function (part, total) {
      total = Number(total) || 0;
      if (!total) return '0%';
      return Math.max(0, Math.min(100, (Number(part) || 0) / total * 100)) + '%';
    };
    self.buTotPctTxt = function (v) {
      var t = self.buTotals() || {}; var b = Number(t.budget) || 0;
      if (!b || v == null) return '';
      var p = v / b * 100;
      return (p >= 99.95 ? Math.round(p) : p.toFixed(1)) + '% ' + self.t('buOfBudget');
    };
    // "(x.x%)" of-budget suffix on the duo-tile breakdown rows (AP/GRN/PR/PO)
    self.buPartPct = function (v) {
      var t = self.buTotals() || {}; var b = Number(t.budget) || 0;
      if (!b || v == null) return '';
      var p = (Number(v) || 0) / b * 100;
      return '(' + (p >= 99.95 ? Math.round(p) : p.toFixed(1)) + '%)';
    };
    // "(x.x%)" YTD-share-of-annual suffix on the Budget tile's YTD row
    self.buYtdOfAnnual = function () {
      var t = self.buTotals() || {}; var a = Number(t.budgetAnnual) || 0;
      if (!a || t.budget == null) return '';
      var p = (Number(t.budget) || 0) / a * 100;
      return '(' + (p >= 99.95 ? Math.round(p) : p.toFixed(1)) + '%)';
    };
    self.buExportCsv = function () {
      // the Department / Sector tab exports its own aggregated view
      if (self.buLevel() !== 'line') { self.buAggExportCsv(); return; }
      api('GET', '/butil' + qs(self.buParams(0, 5000))).then(function (d) {
        var rows = d.items || [];
        // columns follow the ACTIVE Manage-columns view (order + hidden set);
        // the audit tail (cost-adj components) always rides along
        var cols = [];
        self.buColsLine().forEach(function (c) { (c.csv || []).forEach(function (p) { cols.push(p); }); });
        cols = cols.concat([['costAdj', 'Cost Adjustment'], ['costAdjOvr', 'Budget Override (Adj)'], ['hasAdj', 'Has Adjustment']]);
        rows.forEach(function (r) {
          var fm = self.buFmLineMap()[(r.projectNumber || '') + '|' + (r.taskNumber || '') + '|' + (r.expenditureType || '')];
          r._fmCnt = fm ? fm.cnt : ''; r._fmAmt = fm ? fm.amt : '';
        });
        var csv = cols.map(function (c) { return c[1]; }).join(',') + '\n' + rows.map(function (r) {
          return cols.map(function (c) { var v = (r[c[0]] == null ? '' : '' + r[c[0]]); return '"' + v.replace(/"/g, '""') + '"'; }).join(',');
        }).join('\n');
        var blob = new Blob([csv], { type: 'text/csv' }); var u = URL.createObjectURL(blob);
        var a = document.createElement('a'); a.href = u; a.download = 'gl_budget_utilization_' + self.buYear() + '.csv'; a.click(); URL.revokeObjectURL(u);
      }).catch(fail);
    };

    /* ── Briefing Book (BUDGET_UTIL_BOOK via the /gl/butil/book bridge) ──
       Enqueues the Reporting-Platform run with the page's Year / Sector /
       Project type / Cost center filters, polls until the worker finishes,
       then downloads the PDF with the session token. */
    self.buBookBusy = ko.observable(false);
    function buBookDownload(runId) {
      return fetch(API + '/butil/book/' + runId + '/pdf',
                   { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) {
          if (!r.ok) { throw new Error('PDF download failed (HTTP ' + r.status + ')'); }
          return r.blob();
        })
        .then(function (b) {
          var u = URL.createObjectURL(b);
          var a = document.createElement('a');
          a.href = u; a.download = 'Budget_Utilization_Briefing_Book_' + self.buYear() + '.pdf';
          a.click(); URL.revokeObjectURL(u);
        });
    }
    self.runBuBook = function () {
      if (self.buBookBusy()) return;
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.buBookBusy(true);
      self.rgStart('rgGenBook', 6);
      // full page filter set (mirrors buParams) so the book scope = the page scope
      api('POST', '/butil/book', {
        year: Number(self.buYear()), period: self.buPeriod() || null,
        bu: self.buBuParam(),
        sector: self.buSector() || null, chapter: self.buChapterParam() || null,
        projecttype: self.buType() || null, costcenter: self.buCcParam() || null,
        project: self.buProjParam() || null, task: self.buTask() || null,
        etype: self.buEtype() || null, search: self.buSearch() || null,
        ovr: self.buOvr() ? 'Y' : null
      }).then(function (d) {
        var runId = d.runId;
        toast(self.t('buBookQueued') + runId);
        var tries = 0;
        (function poll() {
          if (++tries > 60) {                       // ~6 min ceiling
            self.buBookBusy(false);
            toast(self.t('buBookTimeout') + runId + ')', true);
            return;
          }
          setTimeout(function () {
            api('GET', '/butil/book/' + runId).then(function (s) {
              if (s.status === 'SUCCESS' && s.hasPdf) {
                buBookDownload(runId)
                  .then(function () { self.buBookBusy(false); toast(self.t('buBookReady')); })
                  .catch(function (e) { self.buBookBusy(false); toast(e.message, true); });
              } else if (s.status === 'FAILED') {
                self.buBookBusy(false);
                toast(self.t('buBookFailed') + (s.error || ''), true);
              } else { poll(); }
            }).catch(function () { poll(); });      // transient poll error: keep waiting
          }, 6000);
        })();
      }).catch(function (e) { self.buBookBusy(false); fail(e); });
    };

    /* ── Sector Performance Report (SECTOR_PERF_BOOK via /gl/butil/sectorbook) —
       the Briefing Book pack re-covered for distribution: DCT logo top-right
       and a copyright line on EVERY page, simplified cover, prepared by
       Financial Planning and Reporting. Same filter scope as the book. */
    self.buSpbBusy = ko.observable(false);
    function buSpbDownload(runId) {
      return fetch(API + '/butil/sectorbook/' + runId + '/pdf',
                   { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) {
          if (!r.ok) { throw new Error('PDF download failed (HTTP ' + r.status + ')'); }
          return r.blob();
        })
        .then(function (b) {
          var u = URL.createObjectURL(b);
          var a = document.createElement('a');
          a.href = u; a.download = 'Sector_Performance_Report_' + self.buYear() + '.pdf';
          a.click(); URL.revokeObjectURL(u);
        });
    }
    self.runBuSpb = function () {
      if (self.buSpbBusy()) return;
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      // user rule 2026-09-06: the report runs for exactly ONE sector
      if (!self.buSector()) { toast(self.t('buSpbNeedSector'), true); return; }
      self.buSpbBusy(true);
      self.rgStart('rgGenSpb', 6);
      // full page filter set (mirrors buParams) so the report scope = the page scope
      api('POST', '/butil/sectorbook', {
        year: Number(self.buYear()), period: self.buPeriod() || null,
        bu: self.buBuParam(),
        sector: self.buSector() || null, chapter: self.buChapterParam() || null,
        projecttype: self.buType() || null, costcenter: self.buCcParam() || null,
        project: self.buProjParam() || null, task: self.buTask() || null,
        etype: self.buEtype() || null, search: self.buSearch() || null,
        ovr: self.buOvr() ? 'Y' : null
      }).then(function (d) {
        var runId = d.runId;
        toast(self.t('buSpbQueued') + runId);
        var tries = 0;
        (function poll() {
          if (++tries > 60) {                       // ~6 min ceiling
            self.buSpbBusy(false);
            toast(self.t('buBookTimeout') + runId + ')', true);
            return;
          }
          setTimeout(function () {
            api('GET', '/butil/sectorbook/' + runId).then(function (s) {
              if (s.status === 'SUCCESS' && s.hasPdf) {
                buSpbDownload(runId)
                  .then(function () { self.buSpbBusy(false); toast(self.t('buSpbReady')); })
                  .catch(function (e) { self.buSpbBusy(false); toast(e.message, true); });
              } else if (s.status === 'FAILED') {
                self.buSpbBusy(false);
                toast(self.t('buSpbFailed') + (s.error || ''), true);
              } else { poll(); }
            }).catch(function () { poll(); });      // transient poll error: keep waiting
          }, 6000);
        })();
      }).catch(function (e) { self.buSpbBusy(false); fail(e); });
    };

    /* ── Excel register (BUDGET_UTIL_REGISTER via the /gl/butil/xlsx bridge) —
       the analysis companion of the Briefing Book: every detail list in its
       own worksheet (utilization lines, AP, GRN, open PO, open PR, pending). */
    self.buXlsxBusy = ko.observable(false);
    function buXlsxDownload(runId) {
      return fetch(API + '/butil/xlsx/' + runId + '/file',
                   { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) {
          if (!r.ok) { throw new Error('Excel download failed (HTTP ' + r.status + ')'); }
          return r.blob();
        })
        .then(function (b) {
          var u = URL.createObjectURL(b);
          var a = document.createElement('a');
          a.href = u; a.download = 'Budget_Utilization_Register_' + self.buYear() + '.xlsx';
          a.click(); URL.revokeObjectURL(u);
        });
    }
    self.runBuXlsx = function () {
      if (self.buXlsxBusy()) return;
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.buXlsxBusy(true);
      self.rgStart('rgGenXlsx', 5);
      api('POST', '/butil/xlsx', {
        year: Number(self.buYear()), period: self.buPeriod() || null,
        bu: self.buBuParam(),
        sector: self.buSector() || null, chapter: self.buChapterParam() || null,
        projecttype: self.buType() || null, costcenter: self.buCcParam() || null,
        project: self.buProjParam() || null, task: self.buTask() || null,
        etype: self.buEtype() || null, search: self.buSearch() || null,
        ovr: self.buOvr() ? 'Y' : null,
        cmtmode: self.buCmtDisp() !== 'NONE' ? self.buCmtDisp() : null,
        // Manage-columns saved view -> register sheet-1 columns (GL/db/11 bridge)
        sheetcols: self.buSheetCols()
      }).then(function (d) {
        var runId = d.runId;
        toast(self.t('buBookQueued') + runId);
        var tries = 0;
        (function poll() {
          if (++tries > 60) {
            self.buXlsxBusy(false);
            toast(self.t('buBookTimeout') + runId + ')', true);
            return;
          }
          setTimeout(function () {
            api('GET', '/butil/xlsx/' + runId).then(function (s) {
              if (s.status === 'SUCCESS' && s.hasFile) {
                buXlsxDownload(runId)
                  .then(function () { self.buXlsxBusy(false); toast(self.t('pnXlsxReady')); })
                  .catch(function (e) { self.buXlsxBusy(false); toast(e.message, true); });
              } else if (s.status === 'FAILED') {
                self.buXlsxBusy(false);
                toast(self.t('buBookFailed') + (s.error || ''), true);
              } else { poll(); }
            }).catch(function () { poll(); });
          }, 5000);
        })();
      }).catch(function (e) { self.buXlsxBusy(false); fail(e); });
    };

    /* ── FBP - Projects Budget Utilization (FBP_BUTIL_REGISTER via the
       /gl/butil/fbpxlsx bridge, GL/db/52) — the register re-issued for the FBP
       distribution: sheet 1 = the FIXED 21-column FBP layout (Task Name in
       place of Task Number), so deliberately NO sheetcols is sent — the page's
       Manage Columns view must never change this report. */
    self.buFbpBusy = ko.observable(false);
    function buFbpDownload(runId) {
      return fetch(API + '/butil/fbpxlsx/' + runId + '/file',
                   { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) {
          if (!r.ok) { throw new Error('Excel download failed (HTTP ' + r.status + ')'); }
          return r.blob();
        })
        .then(function (b) {
          var u = URL.createObjectURL(b);
          var a = document.createElement('a');
          a.href = u; a.download = 'FBP_Projects_Budget_Utilization_' + self.buYear() + '.xlsx';
          a.click(); URL.revokeObjectURL(u);
        });
    }
    self.runBuFbp = function () {
      if (self.buFbpBusy()) return;
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.buFbpBusy(true);
      self.rgStart('rgGenFbp', 5);
      api('POST', '/butil/fbpxlsx', {
        year: Number(self.buYear()), period: self.buPeriod() || null,
        bu: self.buBuParam(),
        sector: self.buSector() || null, chapter: self.buChapterParam() || null,
        projecttype: self.buType() || null, costcenter: self.buCcParam() || null,
        project: self.buProjParam() || null, task: self.buTask() || null,
        etype: self.buEtype() || null, search: self.buSearch() || null,
        ovr: self.buOvr() ? 'Y' : null,
        cmtmode: self.buCmtDisp() !== 'NONE' ? self.buCmtDisp() : null
      }).then(function (d) {
        var runId = d.runId;
        toast(self.t('buBookQueued') + runId);
        var tries = 0;
        (function poll() {
          if (++tries > 60) {
            self.buFbpBusy(false);
            toast(self.t('buBookTimeout') + runId + ')', true);
            return;
          }
          setTimeout(function () {
            api('GET', '/butil/fbpxlsx/' + runId).then(function (s) {
              if (s.status === 'SUCCESS' && s.hasFile) {
                buFbpDownload(runId)
                  .then(function () { self.buFbpBusy(false); toast(self.t('buFbpReady')); })
                  .catch(function (e) { self.buFbpBusy(false); toast(e.message, true); });
              } else if (s.status === 'FAILED') {
                self.buFbpBusy(false);
                toast(self.t('buBookFailed') + (s.error || ''), true);
              } else { poll(); }
            }).catch(function () { poll(); });
          }, 5000);
        })();
      }).catch(function (e) { self.buFbpBusy(false); fail(e); });
    };

    /* ── MSS - Projects Budget Utilization (MSS_BUTIL_REGISTER via the
       /gl/butil/mssxlsx bridge, GL/db/53) — the register re-issued for the MSS
       distribution: fixed 26-column sheet 1 (Task Number + Task Name),
       Requester on the detail sheets, Task Name on Open PO/PR. Layout is baked
       into the definition, so NO sheetcols is sent. */
    self.buMssBusy = ko.observable(false);
    function buMssDownload(runId) {
      return fetch(API + '/butil/mssxlsx/' + runId + '/file',
                   { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) {
          if (!r.ok) { throw new Error('Excel download failed (HTTP ' + r.status + ')'); }
          return r.blob();
        })
        .then(function (b) {
          var u = URL.createObjectURL(b);
          var a = document.createElement('a');
          a.href = u; a.download = 'MSS_Projects_Budget_Utilization_' + self.buYear() + '.xlsx';
          a.click(); URL.revokeObjectURL(u);
        });
    }
    self.runBuMss = function () {
      if (self.buMssBusy()) return;
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.buMssBusy(true);
      self.rgStart('rgGenMss', 5);
      api('POST', '/butil/mssxlsx', {
        year: Number(self.buYear()), period: self.buPeriod() || null,
        bu: self.buBuParam(),
        sector: self.buSector() || null, chapter: self.buChapterParam() || null,
        projecttype: self.buType() || null, costcenter: self.buCcParam() || null,
        project: self.buProjParam() || null, task: self.buTask() || null,
        etype: self.buEtype() || null, search: self.buSearch() || null,
        ovr: self.buOvr() ? 'Y' : null,
        cmtmode: self.buCmtDisp() !== 'NONE' ? self.buCmtDisp() : null
      }).then(function (d) {
        var runId = d.runId;
        toast(self.t('buBookQueued') + runId);
        var tries = 0;
        (function poll() {
          if (++tries > 60) {
            self.buMssBusy(false);
            toast(self.t('buBookTimeout') + runId + ')', true);
            return;
          }
          setTimeout(function () {
            api('GET', '/butil/mssxlsx/' + runId).then(function (s) {
              if (s.status === 'SUCCESS' && s.hasFile) {
                buMssDownload(runId)
                  .then(function () { self.buMssBusy(false); toast(self.t('buMssReady')); })
                  .catch(function (e) { self.buMssBusy(false); toast(e.message, true); });
              } else if (s.status === 'FAILED') {
                self.buMssBusy(false);
                toast(self.t('buBookFailed') + (s.error || ''), true);
              } else { poll(); }
            }).catch(function () { poll(); });
          }, 5000);
        })();
      }).catch(function (e) { self.buMssBusy(false); fail(e); });
    };

    /* ── PowerPoint deck (BUDGET_UTIL_BOOK rendered as PPTX via /gl/butil/ppt) —
       an executive slide deck of the same data as the Briefing Book. */
    self.buPptBusy = ko.observable(false);
    function buPptDownload(runId) {
      return fetch(API + '/butil/ppt/' + runId + '/file',
                   { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) {
          if (!r.ok) { throw new Error('PowerPoint download failed (HTTP ' + r.status + ')'); }
          return r.blob();
        })
        .then(function (b) {
          var u = URL.createObjectURL(b);
          var a = document.createElement('a');
          a.href = u; a.download = 'Budget_Utilization_Briefing_' + self.buYear() + '.pptx';
          a.click(); URL.revokeObjectURL(u);
        });
    }
    self.runBuPpt = function () {
      if (self.buPptBusy()) return;
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.buPptBusy(true);
      self.rgStart('rgGenPpt', 6);
      api('POST', '/butil/ppt', {
        year: Number(self.buYear()), period: self.buPeriod() || null,
        bu: self.buBuParam(),
        sector: self.buSector() || null, chapter: self.buChapterParam() || null,
        projecttype: self.buType() || null, costcenter: self.buCcParam() || null,
        project: self.buProjParam() || null, task: self.buTask() || null,
        etype: self.buEtype() || null, search: self.buSearch() || null,
        ovr: self.buOvr() ? 'Y' : null
      }).then(function (d) {
        var runId = d.runId;
        toast(self.t('buBookQueued') + runId);
        var tries = 0;
        (function poll() {
          if (++tries > 60) {
            self.buPptBusy(false);
            toast(self.t('buBookTimeout') + runId + ')', true);
            return;
          }
          setTimeout(function () {
            api('GET', '/butil/ppt/' + runId).then(function (s) {
              if (s.status === 'SUCCESS' && s.hasFile) {
                buPptDownload(runId)
                  .then(function () { self.buPptBusy(false); toast(self.t('pnPptReady')); })
                  .catch(function (e) { self.buPptBusy(false); toast(e.message, true); });
              } else if (s.status === 'FAILED') {
                self.buPptBusy(false);
                toast(self.t('buBookFailed') + (s.error || ''), true);
              } else { poll(); }
            }).catch(function () { poll(); });
          }, 6000);
        })();
      }).catch(function (e) { self.buPptBusy(false); fail(e); });
    };

    /* ── "Generate Report" dropdown (Briefing Book PDF / Excel / PowerPoint) ── */
    self.genOpen = ko.observable(false);
    self.toggleGen = function () { self.genOpen(!self.genOpen()); return true; };
    self.closeGen = function () { self.genOpen(false); return true; };
    self.buGenBusy = ko.computed(function () {
      return self.buBookBusy() || self.buSpbBusy() || self.buXlsxBusy() || self.buFbpBusy() || self.buMssBusy() || self.buPptBusy();
    });

    /* ── "The Binder" report-generation popup (v1.80.0, user-picked study B) ──
       Centred over the dimmed page while a Briefing Book / Excel Register /
       PowerPoint run is generated (Data Conveyor pattern): the book assembles
       from its real sections, the elapsed clock is REAL, × hides the popup
       while the run continues, and it closes itself on ANY exit path via the
       buGenBusy subscription (success, failure, timeout, enqueue error). */
    self.rgShow = ko.observable(false);
    self.rgHidden = ko.observable(false);
    self.rgLabel = ko.observable('');
    self.rgPoll = ko.observable(6);
    self.rgElapsed = ko.observable('0:00');
    var rgTimer = null, rgT0 = 0;
    function rgStart(labelKey, pollSecs) {
      self.rgLabel(self.t(labelKey)); self.rgPoll(pollSecs);
      self.rgHidden(false); self.rgElapsed('0:00'); rgT0 = Date.now();
      if (rgTimer) clearInterval(rgTimer);
      rgTimer = setInterval(function () {
        var s = Math.floor((Date.now() - rgT0) / 1000);
        self.rgElapsed(Math.floor(s / 60) + ':' + ('0' + (s % 60)).slice(-2));
      }, 1000);
      self.rgShow(true);
    }
    self.rgStart = rgStart;
    function rgStop() {
      if (rgTimer) { clearInterval(rgTimer); rgTimer = null; }
      self.rgShow(false);
    }
    self.rgHide = function () { self.rgHidden(true); return false; };
    self.buGenBusy.subscribe(function (busy) { if (!busy) rgStop(); });
    self.rgSub = ko.computed(function () {
      return self.t('rgElapsed') + ' ' + self.rgElapsed() + ' · '
           + self.t('rgPolling').replace('{s}', self.rgPoll());
    });

    /* ════ PROJECTS ENCUMBRANCES — open PO/PR lines with the full GL combination ══
       Reuses the Budget Utilization filter bar (buParams) VERBATIM, so the scope
       is identical to that page. The result set renders in the SHARED
       <interactive-report> component (one-shot capped fetch; column show/hide,
       filters, sort, calc columns, aggregates, control breaks, highlights, CSV/
       XLSX export and saved layouts all come from the component). The Open total
       reconciles to the butil Total Encumbrance (Commitment PR + Obligation PO). */
    var EN_MAX = 10000;
    self.enData = ko.observable(null);        // IR envelope, or null before first run
    self.enLoading = ko.observable(false);
    self.enLoaded = ko.observable(false);
    self.enCount = ko.observable(0);
    self.enOpenTotal = ko.observable(0);
    self.enTruncated = ko.observable(false);
    // set when the shared IR component failed to load (see index.html boot)
    self.enIrError = ko.observable(!!window._irLoadError);
    self.enOpenTotalTxt = ko.computed(function () {
      return Number(self.enOpenTotal() || 0).toLocaleString('en-US',
        { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    });
    self.runEncumbrances = function () {
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.enLoading(true);
      var p = self.buParams(0, EN_MAX);       // same filters as Budget Utilization
      delete p.procash;                       // /encumbrances has no procash figure
      delete p.costadj;                       // ...and no cost-adjustment figure
      delete p.offset;
      return api('GET', '/encumbrances' + qs(p)).then(function (d) {
        self.enCount(d.count || 0);
        self.enOpenTotal((d.totals && d.totals.openAed) || 0);
        self.enTruncated(!!d.truncated);
        self.enData({ columns: d.columns || [], items: d.items || [],
          total: d.count || 0, truncated: !!d.truncated,
          maxRows: d.maxRows || EN_MAX, section: 'enc' });
        self.enLoaded(true); self.enLoading(false);
      }).catch(function (e) { self.enLoading(false); fail(e); });
    };

    /* ════ ENCUMBRANCES – PENDING APPROVAL — PR/PO docs awaiting approval ════
       Same Budget Utilization filter bar (buParams) and the same shared
       <interactive-report> grid as the Projects Encumbrances tab, over
       GET /gl/pending (daily Fusion BIP snapshot joined to the encumbrance
       line detail, db/v2/52). The endpoint aggregates the monitoring KPIs /
       aging buckets / top approvers over the FULL filtered set server-side,
       so the tiles stay correct even when the register itself is capped. */
    var PN_MAX = 10000;
    self.pnSource = ko.observable('');        // '' = both, 'PR' | 'PO'
    /* Business Unit multi-select (2026-07-17): the BIP snapshot is the ONE
       cross-BU source on the platform (the OTBI extracts are DCT-scoped), so
       the filter lives on this page. Picks become chips; the server matches
       ANY chip (pipe-delimited exact list) across register, KPIs AND the
       unmatched coverage figures; options come from the /pending response. */
    self.pnBus = ko.observableArray([]);
    self.pnBuSel = ko.observableArray([]);
    self.pnBuPick = ko.observable('');
    self.pnBuAdd = function () {
      var v = self.pnBuPick();
      if (v && self.pnBuSel.indexOf(v) < 0) self.pnBuSel.push(v);
      self.pnBuPick('');
      return true;
    };
    self.pnBuParam = function () { return self.pnBuSel().join('|') || null; };
    self.pnItems = [];                        // raw register rows (KPI drill source)
    self.pnData = ko.observable(null);        // IR envelope, or null before first run
    self.pnLoading = ko.observable(false);
    self.pnLoaded = ko.observable(false);
    self.pnCount = ko.observable(0);
    self.pnKpis = ko.observable(null);
    self.pnAging = ko.observableArray([]);
    self.pnApprovers = ko.observableArray([]);
    self.pnUnmatched = ko.observable(null);
    self.pnTruncated = ko.observable(false);
    self.pnAsOf = ko.observable('');
    self.pnTotAmt = ko.observable(0);
    self.pnIrError = self.enIrError;          // same shared-component guard
    self.pnK = function (k) { var o = self.pnKpis(); return (o && o[k] != null) ? o[k] : 0; };
    self.pnPctTxt = function (part, total) {
      if (!total) return '';
      return Math.round(100 * (part || 0) / total) + '%';
    };
    self.pnSegW = function (part, total) {
      if (!total) return '0%';
      return Math.max(0, Math.min(100, 100 * (part || 0) / total)).toFixed(1) + '%';
    };
    self.pnTotAmtTxt = ko.computed(function () {
      return Number(self.pnTotAmt() || 0).toLocaleString('en-US',
        { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    });
    self.pnUnmatchedTxt = ko.computed(function () {
      var u = self.pnUnmatched();
      if (!u || !u.docs) return '';
      return self.t('pnUnmatchedNote').replace('{n}', self.fmt(u.docs))
        .replace('{pr}', self.fmt(u.prDocs || 0)).replace('{po}', self.fmt(u.poDocs || 0));
    });
    self.runPending = function () {
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.pnLoading(true);
      var p = self.buParams(0, PN_MAX);       // same filters as Budget Utilization
      delete p.procash;                       // /pending has no procash figure
      delete p.costadj;                       // ...and no cost-adjustment figure
      delete p.offset;
      p.source = self.pnSource() || null;     // page-local PR / PO scope
      p.bu = self.pnBuParam();                // page-local Business Unit any-of list
      return api('GET', '/pending' + qs(p)).then(function (d) {
        // Fusion deep-link map: docNumber alone cannot build a deep link, so
        // keep source|doc# -> FUSION internal header id aside (the shared IR
        // grid only keeps declared columns on its rows)
        pnLinkMap = {};
        (d.items || []).forEach(function (r) {
          if (r.fusionHeaderId) { pnLinkMap[r.source + '|' + r.docNumber] = r.fusionHeaderId; }
        });
        if (d.businessUnits) { self.pnBus(d.businessUnits); }
        self.pnItems = d.items || [];
        self.pnCount(d.count || 0);
        self.pnKpis(d.kpis || {});
        self.pnAging(d.aging || []);
        self.pnApprovers(d.approvers || []);
        self.pnUnmatched(d.unmatched || null);
        self.pnAsOf(d.asOf || '');
        self.pnTotAmt((d.totals && d.totals.lineAed) || 0);
        self.pnTruncated(!!d.truncated);
        self.pnData({ columns: d.columns || [], items: d.items || [],
          total: d.count || 0, truncated: !!d.truncated,
          maxRows: d.maxRows || PN_MAX, section: 'pend' });
        self.pnLoaded(true); self.pnLoading(false);
      }).catch(function (e) { self.pnLoading(false); fail(e); });
    };
    /* ── KPI drill-downs — every tile breakdown row, aging bucket and top
       approver opens the SHARED right-edge drill drawer with the matching
       pending lines (client-side filter of the loaded register; Document #
       cells deep-link to Fusion via drillLink's docNumber rule). ── */
    var PN_DRILL_KEYS = ['source', 'docNumber', 'docLine', 'description', 'preparerBuyer',
      'submittedDate', 'pendingDays', 'pendingWith', 'fundsStatus',
      'projectNumber', 'task', 'expenditureType', 'lineAmount'];
    var PN_DRILL_CAP = 1000;
    function pnDrillCols() {
      var byKey = {};
      ((self.pnData() || {}).columns || []).forEach(function (c) { byKey[c.key] = c; });
      return PN_DRILL_KEYS.map(function (k) {
        var c = byKey[k] || { key: k, label: k, type: 'text' };
        return { key: c.key, label: c.label, type: c.type };
      });
    }
    function pnReservedRow(r) {
      return r.fundsStatus === 'Reserved' || r.fundsStatus === 'Partially Liquidated';
    }
    function openPnList(rows, title) {
      self.drillTitle(title);
      self.drillSub(self.t('pnTitle'));
      self.drillCtx([self.buPeriod() ? self.t('ytd') + ' ' + self.buPeriod() : self.buYear(),
        self.pnSource() || null,
        self.pnBuSel().join(', ') || null].filter(Boolean).join('   ·   '));
      self.drillCols(pnDrillCols());
      self.drillRows(rows.slice(0, PN_DRILL_CAP));
      self.drillTotalV(rows.reduce(function (s, r) { return s + (Number(r.lineAmount) || 0); }, 0));
      self.drillCount(rows.length);
      self.drillLoading(false);
      self.drillDrawer(true);
    }
    self.openPnDrill = function (kind) {
      var defs = {
        pr:         { f: function (r) { return r.source === 'PR'; },        t: self.t('pnPrRow') },
        po:         { f: function (r) { return r.source === 'PO'; },        t: self.t('pnPoRow') },
        reserved:   { f: pnReservedRow,                                     t: self.t('pnReserved') },
        unreserved: { f: function (r) { return !pnReservedRow(r); },        t: self.t('pnUnreserved') },
        over30:     { f: function (r) { return (r.pendingDays || 0) > 30; },  t: self.t('pnOver30') },
        within30:   { f: function (r) { return (r.pendingDays || 0) <= 30; }, t: self.t('pnWithin30') }
      };
      var d = defs[kind];
      if (!d) return;
      openPnList(self.pnItems.filter(d.f), d.t);
    };
    self.openPnBucket = function (b) {
      // b = {bucket:'0-7'|'8-15'|'16-30'|'31+'}
      var lo = { '0-7': 0, '8-15': 8, '16-30': 16, '31+': 31 }[b.bucket] || 0;
      var hi = { '0-7': 7, '8-15': 15, '16-30': 30, '31+': Infinity }[b.bucket];
      openPnList(self.pnItems.filter(function (r) {
        var v = r.pendingDays || 0; return v >= lo && v <= hi;
      }), self.t('pnBucket') + ' ' + b.bucket + ' ' + self.t('pnDaysUnit'));
    };
    self.openPnApprover = function (a) {
      // mirror the server key: NVL(SUBSTR(pending_with,1,400),'(Unassigned)')
      openPnList(self.pnItems.filter(function (r) {
        return ((r.pendingWith || '(Unassigned)').substring(0, 400)) === a.name;
      }), self.t('pnApprover') + ' · ' + a.name);
    };

    /* ── Fusion deep-links on the register's Document # cells ──
       Same delegated ko.contextFor pattern as the combination popover (no
       shared-component change): hovering a docNumber cell shows the link
       affordance, clicking opens the Fusion PR / PO deep link in a new tab
       (shared fusionLinks.js builders over the FUSION internal header id). */
    var pnLinkMap = {};
    function pnDocHref(row) {
      var F = window.FusionLinks;
      if (!F || !row || !row.docNumber) return null;
      var id = pnLinkMap[row.source + '|' + row.docNumber];
      if (!id) return null;
      return row.source === 'PR' ? F.requisition(id) : F.purchaseOrder(id);
    }
    function pnResolveCell(target) {
      var td = (target && target.closest) ? target.closest('td') : null;
      if (!td) return null;
      var ctx;
      try { ctx = ko.contextFor(td); } catch (e) { return null; }
      if (!ctx || !ctx.$parent || !ctx.$parent.row || !ctx.$data) return null;
      return { td: td, row: ctx.$parent.row, col: ctx.$data };
    }
    self.pnGridOver = function (d, e) {
      self.enGridOver(d, e);                  // combination popover behaviour
      var info = pnResolveCell(e.target);
      if (info && info.col.key === 'docNumber' && pnDocHref(info.row)) {
        info.td.classList.add('pn-doclink');
        info.td.title = self.t('fusionOpen');
      }
      return true;
    };
    self.pnGridClick = function (d, e) {
      var info = pnResolveCell(e.target);
      if (info && info.col.key === 'docNumber') {
        var href = pnDocHref(info.row);
        if (href && href !== '#') { window.open(href, '_blank', 'noopener'); return false; }
      }
      return true;
    };
    /* Excel register (ENC_PENDING_REGISTER via the /gl/pending/xlsx bridge) —
       the analysis companion of the Briefing Book: one flat sheet of every
       funds-reserved pending line + the extract-coverage annex sheet. */
    self.pnXlsxBusy = ko.observable(false);
    function pnXlsxDownload(runId) {
      return fetch(API + '/pending/xlsx/' + runId + '/file',
                   { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) {
          if (!r.ok) { throw new Error('Excel download failed (HTTP ' + r.status + ')'); }
          return r.blob();
        })
        .then(function (b) {
          var u = URL.createObjectURL(b);
          var a = document.createElement('a');
          a.href = u; a.download = 'Encumbrances_Pending_Approval_Register_' + self.buYear() + '.xlsx';
          a.click(); URL.revokeObjectURL(u);
        });
    }
    self.runPnXlsx = function () {
      if (self.pnXlsxBusy()) return;
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.pnXlsxBusy(true);
      api('POST', '/pending/xlsx', {
        year: Number(self.buYear()), period: self.buPeriod() || null,
        source: self.pnSource() || null, bu: self.pnBuParam(),
        sector: self.buSector() || null, chapter: self.buChapterParam() || null,
        projecttype: self.buType() || null, costcenter: self.buCcParam() || null,
        project: self.buProjParam() || null, task: self.buTask() || null,
        etype: self.buEtype() || null, search: self.buSearch() || null
      }).then(function (d) {
        var runId = d.runId;
        toast(self.t('buBookQueued') + runId);
        var tries = 0;
        (function poll() {
          if (++tries > 60) {
            self.pnXlsxBusy(false);
            toast(self.t('buBookTimeout') + runId + ')', true);
            return;
          }
          setTimeout(function () {
            api('GET', '/pending/xlsx/' + runId).then(function (s) {
              if (s.status === 'SUCCESS' && s.hasFile) {
                pnXlsxDownload(runId)
                  .then(function () { self.pnXlsxBusy(false); toast(self.t('pnXlsxReady')); })
                  .catch(function (e) { self.pnXlsxBusy(false); toast(e.message, true); });
              } else if (s.status === 'FAILED') {
                self.pnXlsxBusy(false);
                toast(self.t('buBookFailed') + (s.error || ''), true);
              } else { poll(); }
            }).catch(function () { poll(); });
          }, 4000);
        })();
      }).catch(function (e) { self.pnXlsxBusy(false); fail(e); });
    };
    /* Briefing Book (ENC_PENDING_BOOK via the /gl/pending/book bridge) */
    self.pnBookBusy = ko.observable(false);
    function pnBookDownload(runId) {
      return fetch(API + '/pending/book/' + runId + '/pdf',
                   { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) {
          if (!r.ok) { throw new Error('PDF download failed (HTTP ' + r.status + ')'); }
          return r.blob();
        })
        .then(function (b) {
          var u = URL.createObjectURL(b);
          var a = document.createElement('a');
          a.href = u; a.download = 'Encumbrances_Pending_Approval_Book_' + self.buYear() + '.pdf';
          a.click(); URL.revokeObjectURL(u);
        });
    }
    self.runPnBook = function () {
      if (self.pnBookBusy()) return;
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.pnBookBusy(true);
      // full page filter set (mirrors buParams) so the book scope = the page scope
      api('POST', '/pending/book', {
        year: Number(self.buYear()), period: self.buPeriod() || null,
        bu: self.pnBuParam(),
        sector: self.buSector() || null, chapter: self.buChapterParam() || null,
        projecttype: self.buType() || null, costcenter: self.buCcParam() || null,
        project: self.buProjParam() || null, task: self.buTask() || null,
        etype: self.buEtype() || null, search: self.buSearch() || null
      }).then(function (d) {
        var runId = d.runId;
        toast(self.t('buBookQueued') + runId);
        var tries = 0;
        (function poll() {
          if (++tries > 60) {                       // ~6 min ceiling
            self.pnBookBusy(false);
            toast(self.t('buBookTimeout') + runId + ')', true);
            return;
          }
          setTimeout(function () {
            api('GET', '/pending/book/' + runId).then(function (s) {
              if (s.status === 'SUCCESS' && s.hasPdf) {
                pnBookDownload(runId)
                  .then(function () { self.pnBookBusy(false); toast(self.t('buBookReady')); })
                  .catch(function (e) { self.pnBookBusy(false); toast(e.message, true); });
              } else if (s.status === 'FAILED') {
                self.pnBookBusy(false);
                toast(self.t('buBookFailed') + (s.error || ''), true);
              } else { poll(); }
            }).catch(function () { poll(); });      // transient poll error: keep waiting
          }, 6000);
        })();
      }).catch(function (e) { self.pnBookBusy(false); fail(e); });
    };
    /* PowerPoint deck (ENC_PENDING_BOOK formats=PPTX via /gl/pending/ppt) —
       the executive companion of the Briefing Book: the same pending-approval
       data as native, editable slides (overview · aging · sector · approvers ·
       longest-waiting · insights). */
    self.pnPptBusy = ko.observable(false);
    function pnPptDownload(runId) {
      return fetch(API + '/pending/ppt/' + runId + '/file',
                   { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) {
          if (!r.ok) { throw new Error('PowerPoint download failed (HTTP ' + r.status + ')'); }
          return r.blob();
        })
        .then(function (b) {
          var u = URL.createObjectURL(b);
          var a = document.createElement('a');
          a.href = u; a.download = 'Encumbrances_Pending_Approval_' + self.buYear() + '.pptx';
          a.click(); URL.revokeObjectURL(u);
        });
    }
    self.runPnPpt = function () {
      if (self.pnPptBusy()) return;
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.pnPptBusy(true);
      api('POST', '/pending/ppt', {
        year: Number(self.buYear()), period: self.buPeriod() || null,
        bu: self.pnBuParam(),
        sector: self.buSector() || null, chapter: self.buChapterParam() || null,
        projecttype: self.buType() || null, costcenter: self.buCcParam() || null,
        project: self.buProjParam() || null, task: self.buTask() || null,
        etype: self.buEtype() || null, search: self.buSearch() || null
      }).then(function (d) {
        var runId = d.runId;
        toast(self.t('buBookQueued') + runId);
        var tries = 0;
        (function poll() {
          if (++tries > 60) {
            self.pnPptBusy(false);
            toast(self.t('buBookTimeout') + runId + ')', true);
            return;
          }
          setTimeout(function () {
            api('GET', '/pending/ppt/' + runId).then(function (s) {
              if (s.status === 'SUCCESS' && s.hasFile) {
                pnPptDownload(runId)
                  .then(function () { self.pnPptBusy(false); toast(self.t('pnPptReady')); })
                  .catch(function (e) { self.pnPptBusy(false); toast(e.message, true); });
              } else if (s.status === 'FAILED') {
                self.pnPptBusy(false);
                toast(self.t('buBookFailed') + (s.error || ''), true);
              } else { poll(); }
            }).catch(function () { poll(); });
          }, 6000);
        })();
      }).catch(function (e) { self.pnPptBusy(false); fail(e); });
    };
    /* ── pending page "Generate Report" dropdown (PDF / Excel / PowerPoint) ── */
    self.pnGenOpen = ko.observable(false);
    self.togglePnGen = function () { self.pnGenOpen(!self.pnGenOpen()); return true; };
    self.closePnGen = function () { self.pnGenOpen(false); return true; };
    self.pnGenBusy = ko.computed(function () {
      return self.pnBookBusy() || self.pnXlsxBusy() || self.pnPptBusy();
    });

    /* ── loading-state helpers: skeleton shimmer rows for the results table ── */
    function skArr(n) { var a = []; for (var i = 0; i < n; i++) a.push(i); return a; }
    self.skRows = skArr(8);   // shimmer rows shown while /butil runs
    // one shimmer cell per ACTIVE results-table column (registry-driven v1.96.0)
    self.skCols = ko.computed(function () {
      var n = self.view() === 'butil' && self.buLevel() !== 'line'
        ? self.buColsAgg().length : self.buColsLine().length;
      return skArr(Math.max(n || 0, 8));
    });

    /* ── collapsible regions (Search / Overview) + results maximize ── */
    var buUi = {};
    try { buUi = JSON.parse(localStorage.getItem('gl_bu_ui') || '{}'); } catch (e) { buUi = {}; }
    self.buSecSearchOpen = ko.observable(buUi.search !== false);
    self.buSecKpisOpen = ko.observable(buUi.kpis !== false);
    self.buSecCalcOpen = ko.observable(buUi.calc === true);   // informational — collapsed by default
    self.buSecXltplOpen = ko.observable(buUi.xltpl === true); // Excel-override guide — collapsed by default
    // display unit for every butil figure (search-criteria field; display-only, no re-query)
    self.buUnit = ko.observable(['auto', 'B', 'M', 'K', 'X'].indexOf(buUi.unit) >= 0 ? buUi.unit : 'auto');
    function saveBuUi() {
      localStorage.setItem('gl_bu_ui', JSON.stringify({ search: self.buSecSearchOpen(), kpis: self.buSecKpisOpen(), calc: self.buSecCalcOpen(), xltpl: self.buSecXltplOpen(), unit: self.buUnit() }));
    }
    self.buUnit.subscribe(saveBuUi);
    self.buUnitOpts = ko.computed(function () {
      return [
        { v: 'auto', l: self.t('unitAuto') },
        { v: 'B', l: self.t('unitB') },
        { v: 'M', l: self.t('unitM') },
        { v: 'K', l: self.t('unitK') },
        { v: 'X', l: self.t('unitExact') }
      ];
    });
    // unit-aware formatter for all butil figures (KPI band + results table)
    self.buNum = function (n) {
      if (n == null || n === '') return '—';
      var u = self.buUnit();
      if (u === 'auto') return self.compact(n);
      if (u === 'X') return self.money(n);
      var v = Number(n), s = v < 0 ? '-' : '', a = Math.abs(v);
      if (u === 'B') return s + (a / 1e9).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + 'B';
      if (u === 'M') return s + (a / 1e6).toLocaleString('en-US', { minimumFractionDigits: 1, maximumFractionDigits: 1 }) + 'M';
      return s + Math.round(a / 1e3).toLocaleString('en-US') + 'K';
    };
    self.toggleBuSec = function (k) {
      var o = (k === 'search') ? self.buSecSearchOpen
            : (k === 'calc') ? self.buSecCalcOpen
            : (k === 'xltpl') ? self.buSecXltplOpen : self.buSecKpisOpen;
      o(!o()); saveBuUi();
    };
    self.buActiveFilters = ko.computed(function () {
      return [self.buType(), self.buSector(), self.buChapterParam(), self.buCcParam(), self.buProjParam(),
        self.buTask(), self.buEtype(), self.buSearch()].filter(Boolean).length;
    });
    // header summaries shown only while the region is collapsed
    self.buSearchSummary = ko.computed(function () {
      if (self.buSecSearchOpen()) return '';
      var n = self.buActiveFilters();
      return (self.buYear() || '') + (n ? ' · ' + n + ' ' + self.t('buFiltersActive') : '');
    });
    self.buKpiSummary = ko.computed(function () {
      if (self.buSecKpisOpen()) return '';
      var t = self.buTotals() || {};
      if (t.budget == null) return '';
      return self.t('cBudget') + ' ' + self.buNum(t.budget)
        + '  ·  ' + self.t('cTotalActual') + ' ' + self.buNum(self.buActualTot())
        + '  ·  ' + self.t('cTotalEncumbrance') + ' ' + self.buNum(self.buEncumbTot())
        + '  ·  ' + self.t('cFundAvail') + ' ' + self.buNum(t.fundAvailable);
    });
    self.buMax = ko.observable(false);
    self.toggleBuMax = function () {
      self.buMax(!self.buMax());
      document.body.style.overflow = self.buMax() ? 'hidden' : '';
    };
    document.addEventListener('keydown', function (e) {
      // Esc restores the table — unless a drawer/modal is open above it (it owns Esc-like close)
      if (e.key === 'Escape' && self.colDrOpen()) { self.colDrOpen(false); return; }
      if (e.key === 'Escape' && self.buMax() && !self.drillDrawer() && !self.drillModal() && !self.ovDrawer()) self.toggleBuMax();
    });

    /* ── drill-down: a figure → its supporting lines (slide-in drawer) ── */
    self.drillDrawer = ko.observable(false);
    self.drillMax = ko.observable(false);
    self.toggleDrillMax = function () { self.drillMax(!self.drillMax()); };
    document.addEventListener('keydown', function (e) {
      // Esc inside a maximized drawer restores it first (second Esc closes via scrim/cancel)
      if (e.key === 'Escape' && self.drillDrawer() && self.drillMax()) self.drillMax(false);
    });
    self.drillSub = ko.observable(''); self.drillCtx = ko.observable(''); self.drillCount = ko.observable(0);
    // "showing top N of M" note when the line set is capped
    self.drillCapNote = ko.computed(function () {
      var c = self.drillCount(), n = self.drillRows().length;
      return c > n ? self.t('buShowing').replace('{n}', self.fmt(n)).replace('{c}', self.fmt(c)) : '';
    });
    // sort-criteria note shown on top of the drawer table (set per drill kind)
    self.drillSortNote = ko.observable('');
    function fillDrill(d) {
      self.drillSortNote('');
      self.fmDrillOn(false);      // only the Fund Movement drill re-sets it
      self.drillCmtLevel(null);   // only the butil AP/PR/PO drills re-set it
      self.drillCols(d.columns || []); self.drillRows(d.rows || []);
      self.drillTotalV(d.total || 0); self.drillCount(d.count || (d.rows || []).length);
      self.drillLoading(false);
    }
    /* PO / PR / AP-invoice document rows take comments too (entity_key = the
       document number): append a synthetic Comments column to the drill grid */
    var CMT_METRIC_LVL = { ap: 'AP_INVOICE', pr: 'PR', po: 'PO' };
    function cmtDecorateDrill(metric) {
      var lvl = CMT_METRIC_LVL[metric];
      if (!lvl || !self.buCmtOn()) return;
      self.drillCmtLevel(lvl);
      self.drillCols(self.drillCols().concat([{ key: '_cmt', label: self.t('cmtCol'), type: 'cmt' }]));
    }
    /* aggregate-drawer post-processing (2026-08-08 review round):
       ① Cost-centre column shows 'code - name' (resolved from the /actuals/filters
         LOV — no handler change), ② rows guaranteed amount-descending (the server
         already orders by amt DESC; this makes the contract explicit client-side),
       ③ the sort-criteria note above the table states what the order is. */
    function fillAcAgg(d) {
      var rows = d.rows || [], cols = d.columns || [];
      var ccMap = {};
      self.acCostCenters().forEach(function (c) { if (c.name) ccMap[c.code] = c.name; });
      rows.forEach(function (r) {
        if (r.costCenter && ccMap[r.costCenter]) r.costCenter = r.costCenter + ' - ' + ccMap[r.costCenter];
      });
      var amt = cols.filter(function (c) { return c.key === 'amount'; })[0] ||
                cols.slice().reverse().filter(function (c) { return c.type === 'money'; })[0];
      if (amt) rows.sort(function (a, b) { return (Number(b[amt.key]) || 0) - (Number(a[amt.key]) || 0); });
      fillDrill({ columns: cols, rows: rows, total: d.total, count: d.count });
      if (amt) self.drillSortNote(self.t('drillSorted').split('{c}').join(amt.label));
    }
    /* combination popover inside the drill drawer — delegated on the table
       wrapper; here the cell context is $data = column / $parent = row (plain
       KO foreach, unlike the IR grid's $parent.row). The full segment row is
       recovered from acRowMap (the one-shot register covers the same set). */
    function drillResolveCell(target) {
      var td = (target && target.closest) ? target.closest('td') : null;
      if (!td) return null;
      var ctx;
      try { ctx = ko.contextFor(td); } catch (e) { return null; }
      if (!ctx || !ctx.$data || !ctx.$parent) return null;
      return { td: td, col: ctx.$data, row: ctx.$parent };
    }
    // the segment source differs by drill: Actuals rows resolve via acRowMap,
    // Fund Movement / FMR trend rows via the drill response's own combos
    // side-map (v1.95.0 pattern, extended to the FMR trend drill)
    function drillComboRow(info) {
      if (!(info && info.col && info.col.key === 'combination' && info.row)) return null;
      return acRowMap[info.row.combination] || fmComboMap[info.row.combination] || fmrComboMap[info.row.combination] || fdComboMap[info.row.combination] || null;
    }
    self.drillGridOver = function (d, e) {
      var info = drillResolveCell(e.target), cr = drillComboRow(info);
      if (cr) { info.td.style.cursor = 'help'; self.comboHover(cr, e); }
      else self.comboOut();
      return true;
    };
    self.drillGridMove = function (d, e) {
      if (!self.tipShow()) return true;
      var info = drillResolveCell(e.target);
      if (drillComboRow(info)) self.comboMove(info.row, e); else self.comboOut();
      return true;
    };
    function drillFail(e) { self.drillLoading(false); self.drillDrawer(false); toast(e.message, true); }
    // row cell → that single budget line's supporting transactions
    /* Approved cost adjustments are folded into the /butil FIGURES server-side
       (costadj=Y default), so the AP / budget drills fetch the adjustment rows
       from /butil/lines/costadj (GL/db/29) IN PARALLEL and append them — the
       drawer total reconciles to the starred on-screen figure again (user
       report 2026-08-26, project 4511000981 / PCA-00018). Gated on the same
       response echo that stars the rows, so an unchecked "Include Cost
       Adjustment" keeps the drill raw too. */
    var CADJ_DRILL_METRICS = { ap: 1, budget: 1, budgetannual: 1 };
    function drillWithCostAdj(params, metric, wantAdj) {
      var reqs = [api('GET', '/butil/lines' + qs(params))];
      if (wantAdj) reqs.push(api('GET', '/butil/lines/costadj' + qs(params)));
      Promise.all(reqs).then(function (res) {
        var d = res[0], adj = res[1];
        if (adj && (adj.rows || []).length) {
          d = { columns: d.columns, rows: (d.rows || []).concat(adj.rows),
                total: (Number(d.total) || 0) + (Number(adj.total) || 0),
                count: (Number(d.count) || (d.rows || []).length) + (Number(adj.count) || 0) };
        }
        fillDrill(d); cmtDecorateDrill(metric);
      }).catch(drillFail);
    }
    self.openBuDrill = function (row, metric) {
      var cap = metric.charAt(0).toUpperCase() + metric.slice(1);
      self.drillTitle(self.t('buDrill' + cap));
      self.drillSub((row.projectNumber || '') + (row.projectName ? ' · ' + row.projectName : ''));
      self.drillCtx([row.taskNumber, row.expenditureType].filter(Boolean).join('   ·   '));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      drillWithCostAdj({ year: self.buYear(), period: self.buPeriod(), project: row.projectNumber,
        task: row.taskNumber, etype: row.expenditureType, metric: metric,
        ovr: self.buOvr() ? 'Y' : null }, metric,
        CADJ_DRILL_METRICS[metric] && self.buCadjOn() && row.hasAdj === 'Y');
    };
    // KPI card → all supporting lines across the filtered set (aggregate)
    self.openBuAgg = function (metric) {
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      var cap = metric.charAt(0).toUpperCase() + metric.slice(1);
      self.drillTitle(self.t('buDrill' + cap));
      // the annual-budget drill ignores the period window — label it by year
      self.drillSub(self.t('buAllLines') + ' · ' + (metric !== 'budgetannual' && self.buPeriod()
        ? self.t('ytd') + ' ' + self.buPeriod() : self.buYear()));
      self.drillCtx([self.buType().split('|').join(', '), self.buSector(), self.buChapterParam().split('|').join(', '),
        self.buCcParam().split('|').join(', '), self.buProjParam().split('|').join(', '), self.buTask(), self.buEtype(),
        self.buSearch() ? '“' + self.buSearch() + '”' : ''].filter(Boolean).join('   ·   '));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      drillWithCostAdj({ year: self.buYear(), period: self.buPeriod(), metric: metric,
        projecttype: self.buType(), sector: self.buSector(), chapter: self.buChapterParam(), search: self.buSearch(),
        costcenter: self.buCcParam(), fproject: self.buProjParam(), ftask: self.buTask(), fetype: self.buEtype(),
        ovr: self.buOvr() ? 'Y' : null }, metric,
        CADJ_DRILL_METRICS[metric] && self.buCadjOn());
    };
    /* ── expenditure-plan drills (db/v2/126 + GL/db/30, 2026-08-26) ──
       A plan cell opens the monthly DCT_PROJECT_CASHFLOW rows behind it; a
       Plan tile row opens them across the filtered set. A YTD figure passes
       the page period (months on/before it); the Annual figure omits it —
       either way the drawer total ties to the on-screen balance. */
    function planDrillCols(agg) {
      var c = agg ? [
        { key: 'project', label: self.t('cProject'), type: 'text' },
        { key: 'task',    label: self.t('cTask'),    type: 'text' },
        { key: 'etype',   label: self.t('cEtype'),   type: 'text' }] : [];
      return c.concat([
        { key: 'period',   label: self.t('planColPeriod'), type: 'text' },
        { key: 'amount',   label: self.t('planColAmount'), type: 'money' },
        { key: 'loadedBy', label: self.t('planColBy'),     type: 'text' },
        { key: 'loaded',   label: self.t('planColOn'),     type: 'text' },
        { key: 'file',     label: self.t('planColFile'),   type: 'text' }]);
    }
    function planDrillTitle(type, annual) {
      return self.t(annual ? 'buDrillPlanA' : 'buDrillPlanY')
        .replace('{t}', self.t(type === 'REVISED' ? 'planRevised' : 'planApproved'));
    }
    function runPlanDrill(params, agg) {
      api('GET', '/butil/lines/plan' + qs(params)).then(function (d) {
        fillDrill({ columns: planDrillCols(agg), rows: d.rows, total: d.total, count: d.count });
      }).catch(drillFail);
    }
    self.openBuPlanDrill = function (row, type, annual) {
      if (row.hasPlan !== 'Y') return;
      self.drillTitle(planDrillTitle(type, annual));
      self.drillSub((row.projectNumber || '') + (row.projectName ? ' · ' + row.projectName : ''));
      self.drillCtx([row.taskNumber, row.expenditureType].filter(Boolean).join('   ·   '));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      runPlanDrill({ year: self.buYear(), period: annual ? null : self.buPeriod(),
        project: row.projectNumber, task: row.taskNumber, etype: row.expenditureType,
        type: type }, false);
    };
    self.openBuPlanAgg = function (type, annual) {
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.drillTitle(planDrillTitle(type, annual));
      self.drillSub(self.t('buAllLines') + ' · ' + (!annual && self.buPeriod()
        ? self.t('ytd') + ' ' + self.buPeriod() : self.buYear()));
      self.drillCtx([self.buType().split('|').join(', '), self.buSector(), self.buChapterParam().split('|').join(', '),
        self.buCcParam().split('|').join(', '), self.buProjParam().split('|').join(', '), self.buTask(), self.buEtype(),
        self.buSearch() ? '“' + self.buSearch() + '”' : ''].filter(Boolean).join('   ·   '));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      runPlanDrill({ year: self.buYear(), period: annual ? null : self.buPeriod(), type: type,
        projecttype: self.buType(), sector: self.buSector(), chapter: self.buChapterParam(), search: self.buSearch(),
        costcenter: self.buCcParam(), fproject: self.buProjParam(), ftask: self.buTask(), fetype: self.buEtype() }, true);
    };
    /* ── Department / Sector tab figure drills (v1.92.0, 2026-08-30): every
       money cell of a group row opens the SAME drill drawer as the Budget
       Line tab, aggregate mode scoped to the group's cost centre / sector on
       top of the page filters — so the drawer total ties to the cell. Plan
       drills send extra=Y (GL/db/30) so the uploaded plan rows with NO budget
       line, folded into the group figure by GL/db/33, appear in the drawer
       too. A group with no key (unclassified sector / missing cost centre)
       cannot be scoped server-side and stays non-drillable. */
    self.buAggCanDrill = function (row) {
      return self.buLevel() === 'dept' ? !!row.costCentre : !!row.sector;
    };
    function buAggGrpScope(row) {
      var dept = self.buLevel() === 'dept';
      return { year: self.buYear(), period: self.buPeriod(),
        projecttype: self.buType(), chapter: self.buChapterParam(),
        bu: self.buBuParam(), appropriation: self.buApprop() || null, program: self.buProgram() || null,
        sector: row.sector || self.buSector() || null,
        costcenter: dept ? row.costCentre : self.buCcParam(),
        fproject: self.buProjParam(), ftask: self.buTask(), fetype: self.buEtype(),
        search: self.buSearch() };
    }
    function buAggGrpLabel(row) {
      return self.buLevel() === 'dept'
        ? (row.costCentre || '') + (row.department ? ' · ' + row.department : '')
        : (row.sector || '');
    }
    self.openBuAggDrill = function (row, metric) {
      // keyless group = lines missing their mandatory cost-centre
      // classification — every cell of that row opens the missing-lines list
      if (!self.buAggCanDrill(row)) { self.openBuMissCc(); return; }
      var cap = metric.charAt(0).toUpperCase() + metric.slice(1);
      self.drillTitle(self.t('buDrill' + cap));
      self.drillSub(buAggGrpLabel(row));
      self.drillCtx(self.t(self.buLevel() === 'dept' ? 'lvDept' : 'lvSector') + ' · '
        + (metric !== 'budgetannual' && self.buPeriod() ? self.t('ytd') + ' ' + self.buPeriod() : self.buYear()));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      var p = buAggGrpScope(row);
      p.metric = metric; p.ovr = self.buOvr() ? 'Y' : null;
      drillWithCostAdj(p, metric,
        CADJ_DRILL_METRICS[metric] && self.buCadjOn() && row.hasAdj === 'Y');
    };
    self.openBuAggPlan = function (row, type, annual) {
      if (!self.buAggCanDrill(row)) { self.openBuMissCc(); return; }
      if (!((type === 'REVISED' ? row.planRevisedAnnual : row.planApprovedAnnual) || 0)) return;
      self.drillTitle(planDrillTitle(type, annual));
      self.drillSub(buAggGrpLabel(row));
      self.drillCtx(self.t(self.buLevel() === 'dept' ? 'lvDept' : 'lvSector') + ' · '
        + (!annual && self.buPeriod() ? self.t('ytd') + ' ' + self.buPeriod() : self.buYear()));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      var p = buAggGrpScope(row);
      p.period = annual ? null : self.buPeriod(); p.type = type; p.extra = 'Y';
      runPlanDrill(p, true);
    };
    /* ── Fund Movement columns (v1.94.0, GL/db/34): Additional Fund transfer
       COUNT + NET signed AMOUNT on every tab — since 2026-08-31 (user, with
       the sheet-8 rule) APPROVED transactions ONLY, server-side in db/34,
       and the same pair rides the register's Budget Utilization Lines sheet
       (fund_movement_count/_amount, reporting/db/25). Values come from
       GET /butil/fundmove (grouped server-side per level) and merge
       client-side: the Budget Line tab keys on the EXACT project|task|etype
       (user pick — only exact matches land on a row), Department/Sector
       attribute by the transfer's OWN cost centre / sector (the register
       sheet's rule), so transfers under a cost centre with no budget line
       surface in a note under the table, never dropped. Zero-amount lines
       are excluded so a cell count always equals its drilldown row count. */
    self.buFmLineMap = ko.observable({});
    self.buFmAggMap = ko.observable({});
    var buFmKeyLine = null, buFmKeyAgg = null;
    function fmLineKey(r) { return (r.projectNumber || '') + '|' + (r.taskNumber || '') + '|' + (r.expenditureType || ''); }
    self.runBuFm = function (level) {
      if (level === 'line') {
        var p = { year: self.buYear(), period: self.buPeriod() || null, level: 'line' };
        var k = JSON.stringify(p);
        if (k === buFmKeyLine) return;
        api('GET', '/butil/fundmove' + qs(p)).then(function (d) {
          buFmKeyLine = k;
          var m = {};
          (d.items || []).forEach(function (i) { m[(i.project || '') + '|' + (i.task || '') + '|' + (i.etype || '')] = i; });
          self.buFmLineMap(m);
        }).catch(function () {});
        return;
      }
      var p2 = self.buAggParams(level), k2 = JSON.stringify(p2);
      if (k2 === buFmKeyAgg) return;
      api('GET', '/butil/fundmove' + qs(p2)).then(function (d) {
        buFmKeyAgg = k2;
        var m = {};
        (d.items || []).forEach(function (i) { m[i.key || ''] = i; });
        self.buFmAggMap(m);
      }).catch(function () {});
    };
    self.fmOfRow = function (r) { return self.buFmLineMap()[fmLineKey(r)] || null; };
    self.fmOfGrp = function (r) {
      var key = self.buLevel() === 'dept' ? (r.costCentre || '') : (r.sector || '');
      return self.buFmAggMap()[key] || null;
    };
    self.fmTxt = function (fm, kind) {
      if (!fm) return '—';
      return kind === 'cnt' ? self.fmt(fm.cnt) : self.buNum(fm.amt);
    };
    self.fmCls = function (fm, kind) {
      return { 'money-cell': !!fm, dash: !fm,
        'fm-pos': kind === 'amt' && !!fm && fm.amt > 0,
        'fm-neg': kind === 'amt' && !!fm && fm.amt < 0 };
    };
    // transfers attributed to a cost centre / sector with no group row above
    self.buFmAggExtra = ko.computed(function () {
      var lvl = self.buLevel();
      if (lvl === 'line') return null;
      var m = self.buFmAggMap(), seen = {};
      self.buAggItems().forEach(function (r) { seen[lvl === 'dept' ? (r.costCentre || '') : (r.sector || '')] = 1; });
      var n = 0, amt = 0;
      Object.keys(m).forEach(function (k) { if (!seen[k]) { n += m[k].cnt; amt += m[k].amt; } });
      return n ? { n: n, amt: amt } : null;
    });
    /* green/red additions-vs-deductions breakdown popover on cell hover */
    self.fmTip = ko.observable(null);
    self.fmTipX = ko.observable(0); self.fmTipY = ko.observable(0);
    self.fmHover = function (fm, e) {
      if (!fm) { self.fmTip(null); return true; }
      var w = 300, x = e.clientX + 14, y = e.clientY + 12;
      if (x + w > window.innerWidth) x = e.clientX - w - 14;
      if (y + 180 > window.innerHeight) y = Math.max(12, window.innerHeight - 190);
      self.fmTipX(x); self.fmTipY(y); self.fmTip(fm);
      return true;
    };
    self.fmOut = function () { self.fmTip(null); return true; };
    /* drilldown: the transfer transactions behind a cell — SAME columns as
       the register's Fund Movement sheet, two sort orders (user spec) */
    function fmDrillCols() {
      return [
        { key: 'project', label: self.t('fmProjectNo'), type: 'text' },
        { key: 'projectName', label: self.t('fmProjectName'), type: 'text' },
        { key: 'task', label: self.t('fmTaskNo'), type: 'text' },
        { key: 'etype', label: self.t('cEtype'), type: 'text' },
        { key: 'combination', label: self.t('btCodeComb'), type: 'text' },
        { key: 'amount', label: self.t('btAmount'), type: 'money', pn: true },
        { key: 'commitment', label: self.t('fmCommitment'), type: 'money' },
        { key: 'annualBudget', label: self.t('fmAnnBudget'), type: 'money' },
        { key: 'fundAvailable', label: self.t('fmFundAvail'), type: 'money' },
        { key: 'totalActual', label: self.t('fmTotActual'), type: 'money' },
        { key: 'costCentre', label: self.t('btCostCenter'), type: 'text' },
        { key: 'department', label: self.t('cDept'), type: 'text' },
        { key: 'organization', label: self.t('btOrganization'), type: 'text' },
        { key: 'sector', label: self.t('btSector'), type: 'text' },
        { key: 'trxNum', label: self.t('fmTrxNum'), type: 'text' },
        { key: 'decreeNo', label: self.t('btDecree'), type: 'text' },
        { key: 'trxDate', label: self.t('fmTrxDate'), type: 'text' },
        { key: 'trxYear', label: self.t('fmTrxYear'), type: 'text' },
        { key: 'businessUnit', label: self.t('btBu'), type: 'text' },
        { key: 'trxStatus', label: self.t('fmTrxStatus'), type: 'status' },
        { key: 'lineStatus', label: self.t('btLineStatus'), type: 'status' },
        { key: 'baselineStatus', label: self.t('btBaseline'), type: 'status' },
        { key: 'journalStatus', label: self.t('btJournal'), type: 'status' },
        { key: 'submittedBy', label: self.t('fmSubmittedBy'), type: 'text' },
        { key: 'approvedBy', label: self.t('fmApprovedBy'), type: 'text' },
        { key: 'approvalState', label: self.t('fmApprState'), type: 'status' },
        { key: 'approvalDate', label: self.t('fmApprDate'), type: 'text' },
        { key: 'notes', label: self.t('btNotes'), type: 'text' }
      ];
    }
    self.fmDrillOn = ko.observable(false);
    self.fmDrillSort = ko.observable('default');
    var fmDrillParams = null, fmComboMap = {}, fmrComboMap = {}, fdComboMap = {};
    function runFmDrill(params) {
      fmDrillParams = params;
      var p = Object.assign({}, params, { sort: self.fmDrillSort() });
      api('GET', '/butil/lines/fundmove' + qs(p)).then(function (d) {
        // segment side-map for the Code Combination popover (10 code+desc pairs
        // per distinct combination, resolved server-side against the COA snap)
        fmComboMap = d.combos || {};
        fillDrill({ columns: fmDrillCols(), rows: d.rows, total: d.total, count: d.count });
        self.fmDrillOn(true);
      }).catch(drillFail);
    }
    self.setFmDrillSort = function (s) {
      if (s === self.fmDrillSort() || !fmDrillParams) return;
      self.fmDrillSort(s); self.drillLoading(true);
      runFmDrill(fmDrillParams);
    };
    self.openBuFmDrill = function (row) {
      if (!self.fmOfRow(row)) return;
      self.drillTitle(self.t('buDrillFm'));
      self.drillSub((row.projectNumber || '') + (row.projectName ? ' · ' + row.projectName : ''));
      self.drillCtx([row.taskNumber, row.expenditureType].filter(Boolean).join('   ·   '));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      runFmDrill({ year: self.buYear(), period: self.buPeriod() || null,
        project: row.projectNumber, task: row.taskNumber, etype: row.expenditureType });
    };
    self.openBuAggFmDrill = function (row) {
      if (!self.buAggCanDrill(row)) { self.openBuMissCc(); return; }
      if (!self.fmOfGrp(row)) return;
      self.drillTitle(self.t('buDrillFm'));
      self.drillSub(buAggGrpLabel(row));
      self.drillCtx(self.t(self.buLevel() === 'dept' ? 'lvDept' : 'lvSector') + ' · '
        + (self.buPeriod() ? self.t('ytd') + ' ' + self.buPeriod() : self.buYear()));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      runFmDrill(buAggGrpScope(row));
    };
    self.closeDrawer = function () { self.drillDrawer(false); self.drillMax(false); self.drillSortNote(''); self.comboOut(); };
    // export the loaded drill lines — modal + drawer share drillCols/drillRows
    self.drillExportCsv = function () {
      var cols = self.drillCols(), rows = self.drillRows();
      if (!cols.length || !rows.length) return;
      var esc = function (v) { return '"' + ('' + (v == null ? '' : v)).replace(/"/g, '""') + '"'; };
      var lines = [cols.map(function (c) { return esc(c.label); }).join(',')];
      rows.forEach(function (r) {
        lines.push(cols.map(function (c) { return esc(r[c.key]); }).join(','));
      });
      // reconciliation footer: label in the first column, total under the last (amount) column
      lines.push(cols.map(function (c, i) {
        return esc(i === 0 ? self.t('drillTotal') : (i === cols.length - 1 ? self.drillTotalV() : ''));
      }).join(','));
      var name = (self.drillTitle() + (self.drillSub() ? '_' + self.drillSub() : ''))
        .replace(/[^\w\u0600-\u06FF]+/g, '_').replace(/^_+|_+$/g, '').toLowerCase() || 'lines';
      var blob = new Blob(['\uFEFF' + lines.join('\n')], { type: 'text/csv;charset=utf-8' });
      var u = URL.createObjectURL(blob);
      var a = document.createElement('a'); a.href = u; a.download = 'gl_drill_' + name + '.csv';
      a.click(); URL.revokeObjectURL(u);
    };

    /* ══ EXECUTIVE PROJECT DASHBOARD ═══════════════════════════════════
       Two pages, one scope. Both reuse the Budget Utilization criteria
       observables (buYear / buPeriod / buType / buSector / ... / buUnit), which
       is what makes the drill from the portfolio into a project free of
       parameter passing and keeps every figure reconciling to the butil page.
       ───────────────────────────────────────────────────────────────── */

    /* ---- Portfolio state ---- */
    self.pfLoading  = ko.observable(false);
    self.pfLoaded   = ko.observable(false);
    self.pfData     = ko.observable(null);
    self.pfTotals   = ko.observable({});
    self.pfCount    = ko.observable(0);
    self.pfMax      = ko.observable(false);
    self.pfHealth   = ko.observable('');   // band filter
    self.pfStatus   = ko.observable('');
    self.pfManager  = ko.observable('');
    self.pfSort     = ko.observable('health');
    self.pfFilters  = ko.observable(null);
    self.pfIr       = ko.observable(null);
    self.pfBusy     = ko.computed(function () { return self.pfLoading() || self.buFiltersLoading(); });

    // side-map: the shared interactive report strips any field that is not a
    // declared column, so the raw row (and anything the 360 wants to show
    // optimistically) is kept here, keyed on the project number.
    var pfRowMap = {};
    self.pfItems = [];

    // region open/closed state, persisted like the butil page
    var PF_UI = {};
    try { PF_UI = JSON.parse(localStorage.getItem('gl_pf_ui') || '{}') || {}; } catch (e) { PF_UI = {}; }
    self.pfSecSearchOpen = ko.observable(PF_UI.search !== false);
    self.pfSecKpisOpen   = ko.observable(PF_UI.kpis   !== false);
    self.pfSecHealthOpen = ko.observable(PF_UI.health !== false);
    function savePfUi() {
      try {
        localStorage.setItem('gl_pf_ui', JSON.stringify({
          search: self.pfSecSearchOpen(), kpis: self.pfSecKpisOpen(), health: self.pfSecHealthOpen() }));
      } catch (e) {}
    }
    self.togglePfSec = function (k) {
      var o = { search: self.pfSecSearchOpen, kpis: self.pfSecKpisOpen, health: self.pfSecHealthOpen }[k];
      if (o) { o(!o()); savePfUi(); }
    };
    self.togglePfMax = function () {
      self.pfMax(!self.pfMax());
      document.body.style.overflow = self.pfMax() ? 'hidden' : '';
    };
    document.addEventListener('keydown', function (e) {
      // a row click can open the drawer from inside the maximised region, so
      // Esc must not restore the region while the drawer is still up
      if (e.key === 'Escape' && self.pfMax() && !self.drillDrawer()) self.togglePfMax();
    });

    self.pfSortOpts = ko.computed(function () {
      return [{ v: 'health', l: self.t('pfSortHealth') }, { v: 'budget', l: self.t('pfSortBudget') },
              { v: 'actual', l: self.t('pfSortActual') }, { v: 'committed', l: self.t('pfSortCommitted') },
              { v: 'fundavailable', l: self.t('pfSortFund') }, { v: 'utilization', l: self.t('pfSortUtil') }];
    });
    self.pfBandOpts = ko.computed(function () {
      return [{ v: 'RED', l: self.t('pfBandRed') }, { v: 'AMBER', l: self.t('pfBandAmber') },
              { v: 'GREEN', l: self.t('pfBandGreen') }, { v: 'GREY', l: self.t('pfBandGrey') }];
    });

    self.loadPfFilters = function () {
      return api('GET', '/projects/filters').then(function (d) {
        self.pfFilters(d);
        if (!self.buYear() && d.defaultYear != null) self.buYear(d.defaultYear);
        return d;
      }).catch(function () { self.pfFilters({}); });
    };

    /* health band -> tone + label. Bands come from the server (one scoring
       formula, in one place); the client only maps them to the shared status
       pill vocabulary. */
    var PF_TONE = { RED: 'err', AMBER: 'warn', GREEN: 'ok', GREY: 'mute' };
    self.pfBandTone  = function (b) { return PF_TONE[b] || 'mute'; };
    self.pfBandClass = function (b) { return b ? 'st st--' + self.pfBandTone(b) : ''; };
    self.pfBandLabel = function (b) {
      return self.t({ RED: 'pfBandRed', AMBER: 'pfBandAmber', GREEN: 'pfBandGreen' }[b] || 'pfBandGrey');
    };

    self.pfParams = function () {
      return { year: self.buYear(), period: self.buPeriod(), projecttype: self.buType(),
        sector: self.buSector(), chapter: self.buChapterParam(), costcenter: self.buCcParam(),
        project: self.buProjParam(), bu: self.buBuParam(),
        appropriation: self.buApprop() || null, program: self.buProgram() || null,
        status: self.pfStatus() || null, band: self.pfHealth() || null,
        manager: self.pfManager() || null, sort: self.pfSort(),
        ovr: self.buOvr() ? 'Y' : null, search: self.buSearch(), limit: 2000 };
    };

    self.runPortfolio = function () {
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.pfLoading(true);
      return api('GET', '/projects' + qs(self.pfParams())).then(function (d) {
        self.pfData(d);
        self.pfTotals(d.totals || {});
        self.pfCount(d.total || 0);
        self.pfItems = d.items || [];
        pfRowMap = {};
        self.pfItems.forEach(function (r) { pfRowMap[r.projectNumber] = r; });
        self.pfBuildIr();
        self.pfLoaded(true);
      }).catch(function (e) {
        toast(e.message || 'error', true); self.pfData(null); self.pfItems = [];
      }).then(function () { self.pfLoading(false); });
    };

    /* ---- KPI helpers (all money goes through the SHARED buUnit formatter) ---- */
    self.pfT = function (k) { var t = self.pfTotals() || {}; return Number(t[k]) || 0; };
    self.pfActualTot = ko.computed(function () { return self.pfT('actualAp') + self.pfT('actualGrn'); });
    self.pfCommitTot = ko.computed(function () { return self.pfT('commitmentPr') + self.pfT('obligationPo'); });
    self.pfUtilPct = ko.computed(function () {
      var b = self.pfT('budgetAnnual'); if (!b) return 0;
      return Math.round((self.pfActualTot() + self.pfCommitTot()) * 100 / b);
    });
    self.pfPaidPct = ko.computed(function () {
      var i = self.pfT('apInvoiced'); if (!i) return 0;
      return Math.round(self.pfT('apPaid') * 100 / i);
    });
    self.pfSegW = function (part, total) {
      var t = Number(total) || 0; if (!t) return '0%';
      return Math.max(0, Math.min(100, (Number(part) || 0) * 100 / t)).toFixed(1) + '%';
    };
    self.pfOfBudget = function (v) {
      var b = self.pfT('budgetAnnual'); if (!b) return '';
      return self.t('pfOfBudget').replace('{p}', Math.round((Number(v) || 0) * 100 / b));
    };
    self.pfBands = ko.computed(function () { return (self.pfData() || {}).bands || {}; });
    self.pfFlags = ko.computed(function () { return (self.pfData() || {}).flags || {}; });
    self.pfGaps  = ko.computed(function () { return (self.pfData() || {}).dataGaps || {}; });
    self.pfRiskCount = ko.computed(function () {
      var b = self.pfBands(); return (Number(b.red) || 0) + (Number(b.amber) || 0);
    });
    // NOTE: these computeds must read pfData() -- an OBSERVABLE -- not the plain
    // self.pfItems array. A ko.computed only re-runs when an observable it
    // touched changes, so depending on the array alone would evaluate once
    // (while it was still empty) and never again.
    self.pfElapsed = ko.computed(function () {
      var it = (self.pfData() || {}).items || [];
      return it.length ? Number(it[0].elapsedPct) || 0 : 0;
    });

    /* Health distribution bar: four segments, each drillable. */
    self.pfHealthBands = ko.computed(function () {
      var b = self.pfBands(), tot = (Number(b.green)||0)+(Number(b.amber)||0)+(Number(b.red)||0)+(Number(b.grey)||0);
      if (!tot) return [];
      return [{ key:'RED', cls:'h-crit', label:self.t('pfBandRed'), n:Number(b.red)||0 },
              { key:'AMBER', cls:'h-risk', label:self.t('pfBandAmber'), n:Number(b.amber)||0 },
              { key:'GREEN', cls:'h-ok', label:self.t('pfBandGreen'), n:Number(b.green)||0 },
              { key:'GREY', cls:'h-none', label:self.t('pfBandGrey'), n:Number(b.grey)||0 }
             ].map(function (x) { x.pct = (x.n * 100 / tot).toFixed(1); return x; });
    });

    /* Radial gauge -- same construction as the GL dashboard gauge: a circle of
       radius r, stroke-dasharray set to the consumed fraction of 2*pi*r. Two
       arcs share the ring (consumed, then consumed+committed behind it) and a
       tick marks how much of the year has elapsed. */
    self.pfGauge = ko.computed(function () {
      var b = self.pfT('budgetAnnual'), r = 62, C = 2 * Math.PI * r;
      function clamp(p) { return Math.max(0, Math.min(100, p || 0)); }
      var util = clamp(b ? self.pfActualTot() * 100 / b : 0);
      var commit = clamp(b ? (self.pfActualTot() + self.pfCommitTot()) * 100 / b : 0);
      var elapsed = clamp(self.pfElapsed());
      return { r: r, C: C.toFixed(1),
        util: Math.round(util), commit: Math.round(commit), elapsed: Math.round(elapsed),
        dashUtil:   ((util / 100) * C).toFixed(1) + ' ' + C.toFixed(1),
        dashCommit: ((commit / 100) * C).toFixed(1) + ' ' + C.toFixed(1),
        over: commit > 100 };
    });

    /* Largest consumers -- top 12 by consumed, drawn as proportional bars. */
    self.pfPressure = ko.computed(function () {
      var it = ((self.pfData() || {}).items || []).slice();
      it.forEach(function (r) { r._consumed = (Number(r.actualAp)||0) + (Number(r.actualGrn)||0); });
      it = it.filter(function (r) { return r._consumed > 0; })
             .sort(function (a, b) { return b._consumed - a._consumed; }).slice(0, 12);
      var max = it.length ? it[0]._consumed : 1;
      return it.map(function (r) {
        return { num: r.projectNumber, name: r.projectName, band: r.healthBand,
                 amount: r._consumed, w: Math.max(1, r._consumed * 100 / max).toFixed(1),
                 util: Number(r.utilizationPct) || 0 };
      });
    });

    /* Auto-generated executive sentences (same substitution style as the GL
       dashboard insights). Every claim here is a figure the page also shows. */
    self.pfInsights = ko.computed(function () {
      var d = self.pfData(); if (!d || !d.totals) return [];
      var C = self.compact, out = [], f = self.pfFlags(), b = self.pfBands(), g = self.pfGaps();
      function sub(s, o) { for (var k in o) s = s.split('{' + k + '}').join(o[k]); return s; }
      out.push(sub(self.t('pfInsUtil'), { n: self.fmt(self.pfCount()), y: self.buYear(),
        p: Math.round(self.pfActualTot() * 100 / (self.pfT('budgetAnnual') || 1)),
        a: C(self.pfActualTot()), b: C(self.pfT('budgetAnnual')) }));
      var gap = self.pfUtilPct() - self.pfElapsed();
      out.push(sub(self.t('pfInsPace'), { e: Math.round(self.pfElapsed()),
        d: self.t(gap > 10 ? 'pfPaceAhead' : (gap < -10 ? 'pfPaceBehind' : 'pfPaceOn')) }));
      if ((Number(b.red) || 0) + (Number(b.amber) || 0) > 0)
        out.push(sub(self.t('pfInsRisk'), { c: self.fmt(b.red || 0), r: self.fmt(b.amber || 0) }));
      if (Number(f.overBudget) > 0) out.push(sub(self.t('pfInsOver'), { n: self.fmt(f.overBudget) }));
      if (self.pfT('apInvoiced') > 0)
        out.push(sub(self.t('pfInsPaid'), { p: self.pfPaidPct(), a: C(self.pfT('apPaid')), i: C(self.pfT('apInvoiced')) }));
      var top = self.pfPressure()[0];
      if (top) out.push(sub(self.t('pfInsTop'), { s: top.name || top.num, a: C(top.amount), p: top.util }));
      if (Number(f.noSpend) > 0) out.push(sub(self.t('pfInsNoSpend'), { n: self.fmt(f.noSpend) }));
      if (Number(g.unbudgetedProjects) > 0)
        out.push(sub(self.t('pfInsUnbudgeted'), { n: self.fmt(g.unbudgetedProjects), a: C(self.pfT('unbudgetedSpend')) }));
      return out;
    });

    /* ---- the register, on the SHARED interactive report ----
       Money columns are scaled by the shared buUnit divisor and the label
       carries the suffix, matching what the Budget vs Actual register does. */
    self.pfBuildIr = function () {
      var u = self.buUnit(), div = 1, sfx = '';
      if (u === 'B') { div = 1e9; sfx = ' (B)'; }
      else if (u === 'M') { div = 1e6; sfx = ' (M)'; }
      else if (u === 'K') { div = 1e3; sfx = ' (K)'; }
      function money(key, label, group, groupClass, hint) {
        return { key: key, label: self.t(label) + sfx, type: 'money',
                 group: self.t(group), groupClass: groupClass,
                 hint: hint ? self.t(hint) : undefined };
      }
      var cols = [
        { key: 'health', label: self.t('pfColHealth'), type: 'text', sticky: true, width: 118,
          group: self.t('pfGrpProject'), groupClass: 'ir-g-proj', hint: self.t('pfHintHealth') },
        { key: 'project', label: self.t('pfColProject'), type: 'text', sticky: true, width: 300, ellipsis: true,
          group: self.t('pfGrpProject'), groupClass: 'ir-g-proj' },
        { key: 'manager', label: self.t('pfColManager'), type: 'text', ellipsis: true,
          group: self.t('pfGrpProject'), groupClass: 'ir-g-proj' },
        { key: 'status', label: self.t('pfColStatus'), type: 'text',
          group: self.t('pfGrpProject'), groupClass: 'ir-g-proj' },
        money('budgetAnnual', 'pfColBudgetA', 'pfGrpBudget', 'ir-g-budget'),
        money('budgetYtd', 'pfColBudgetY', 'pfGrpBudget', 'ir-g-budget'),
        money('planA', 'pfColPlanA', 'pfGrpPlan', 'ir-g-plan', 'buPlanHint'),
        money('planY', 'pfColPlanY', 'pfGrpPlan', 'ir-g-plan', 'buPlanHint'),
        money('ap', 'pfColAp', 'pfGrpConsumed', 'ir-g-actual'),
        money('grn', 'pfColGrn', 'pfGrpConsumed', 'ir-g-actual'),
        money('paid', 'pfColPaid', 'pfGrpConsumed', 'ir-g-actual', 'pfHintPaid'),
        money('pr', 'pfColPr', 'pfGrpCommitted', 'ir-g-commit'),
        money('po', 'pfColPo', 'pfGrpCommitted', 'ir-g-commit'),
        money('fund', 'pfColFund', 'pfGrpPosition', 'ir-g-pos'),
        { key: 'util', label: self.t('pfColUtil'), type: 'num',
          group: self.t('pfGrpPosition'), groupClass: 'ir-g-pos', hint: self.t('pfHintUtil') },
        money('billed', 'pfColBilled', 'pfGrpOther', 'ir-g-rev', 'pfHintBilled'),
        { key: 'pendingDocs', label: self.t('pfColPending'), type: 'num',
          group: self.t('pfGrpOther'), groupClass: 'ir-g-rev' },
        { key: 'tasks', label: self.t('pfColTasks'), type: 'num',
          group: self.t('pfGrpOther'), groupClass: 'ir-g-rev' }
      ];
      // the Revised plan pair joins the grid only once any revised plan exists
      var anyRev = (self.pfItems || []).some(function (r) { return (Number(r.planRevisedAnnual) || 0) !== 0; });
      if (anyRev) {
        cols.splice(6, 0,
          money('planRevA', 'pfColPlanRevA', 'pfGrpPlan', 'ir-g-plan', 'buPlanHint'),
          money('planRevY', 'pfColPlanRevY', 'pfGrpPlan', 'ir-g-plan', 'buPlanHint'));
      }
      var rows = (self.pfItems || []).map(function (r) {
        return {
          health: self.pfBandLabel(r.healthBand),
          project: r.projectNumber + ' — ' + (r.projectName || ''),
          manager: r.manager || '',
          status: r.status || '',
          budgetAnnual: (Number(r.budgetAnnual) || 0) / div,
          budgetYtd: (Number(r.budget) || 0) / div,
          planA: (Number(r.planApprovedAnnual) || 0) / div,
          planY: (Number(r.planApprovedYtd) || 0) / div,
          planRevA: (Number(r.planRevisedAnnual) || 0) / div,
          planRevY: (Number(r.planRevisedYtd) || 0) / div,
          ap: (Number(r.actualAp) || 0) / div,
          grn: (Number(r.actualGrn) || 0) / div,
          paid: (Number(r.apPaid) || 0) / div,
          pr: (Number(r.commitmentPr) || 0) / div,
          po: (Number(r.obligationPo) || 0) / div,
          fund: (Number(r.fundAvailable) || 0) / div,
          util: Number(r.utilizationPct) || 0,
          billed: (Number(r.billed) || 0) / div,
          pendingDocs: Number(r.pendingDocs) || 0,
          tasks: Number(r.taskCount) || 0,
          _rowClass: 'pf-h-' + String(r.healthBand || 'GREY').toLowerCase()
        };
      });
      self.pfIr({ columns: cols, items: rows, total: rows.length, section: 'pf',
                  zebra: true, stateRev: 2 });
    };
    // re-render (without re-fetching) when the unit or the language changes
    self.buUnit.subscribe(function () { if (self.pfLoaded()) self.pfBuildIr(); });
    self.lang.subscribe(function () { if (self.pfLoaded()) self.pfBuildIr(); });

    self.pfUnitNote = ko.computed(function () {
      var u = self.buUnit();
      if (u !== 'B' && u !== 'M' && u !== 'K') return '';
      return self.t('pfUnitNote').replace('{u}', u);
    });

    /* Row click -> Project 360. The interactive report drops undeclared row
       fields, so the project number is recovered from the merged identity cell
       through the side map rather than ridden on the row. */
    function pfResolve(target) {
      var td = (target && target.closest) ? target.closest('td') : null;
      if (!td) return null;
      var ctx; try { ctx = ko.contextFor(td); } catch (e) { return null; }
      if (!ctx || !ctx.$parent || !ctx.$parent.row) return null;
      var proj = ctx.$parent.row.project;
      if (!proj) return null;
      return String(proj).split(' — ')[0];
    }
    self.pfGridClick = function (d, e) {
      var num = pfResolve(e.target);
      if (num && pfRowMap[num]) self.openProj360(num);
      return true;
    };
    self.pfGridOver = function (d, e) {
      var td = (e.target && e.target.closest) ? e.target.closest('td') : null;
      if (td && pfResolve(e.target)) td.style.cursor = 'pointer';
      return true;
    };

    /* ══ Project 360 ══════════════════════════════════════════════════ */
    self.p3Num      = ko.observable('');
    self.p3Loading  = ko.observable(false);
    self.p3Data     = ko.observable(null);
    self.p3Tasks    = ko.observableArray([]);
    self.p3Pipe     = ko.observable(null);
    self.p3Rev      = ko.observable(null);
    self.p3Trx      = ko.observableArray([]);
    self.p3Cash     = ko.observable(null);
    self.p3PipeTab  = ko.observable('openPr');

    self.openProj360 = function (num) {
      if (!num) return;
      if (self.pfMax()) self.togglePfMax();
      self.p3Num(num);
      self.go('proj360');
    };
    self.backToPortfolio = function () { self.go('portfolio'); };

    self.p3Card = ko.computed(function () { return (self.p3Data() || {}).project || {}; });
    self.p3Year = ko.computed(function () { return (self.p3Data() || {}).year || {}; });
    self.p3H    = ko.computed(function () { return (self.p3Data() || {}).health || {}; });
    self.p3Ap   = ko.computed(function () { return (self.p3Data() || {}).ap || {}; });
    self.p3RevS = ko.computed(function () { return (self.p3Data() || {}).revenue || {}; });
    self.p3Pend = ko.computed(function () { return (self.p3Data() || {}).pending || {}; });
    self.p3Sched= ko.computed(function () { return (self.p3Data() || {}).schedule || {}; });

    self.p3BandClass = function () { return self.pfBandClass(self.p3H().band); };
    self.p3BandLabel = function () { return self.pfBandLabel(self.p3H().band); };

    /* Status pill tone for the free-text project status.
       ORDER IS LOAD-BEARING and matches the budgettrx precedent: failure
       patterns are tested FIRST, and the mute tier is tested before the ok
       tier because "Inactive" contains "active". Never match on equality --
       the live vocabulary mixes cases. */
    var P3_TONES = [
      [/fail|error|reject|cancel|terminat|abandon/i, 'err'],
      [/inactive|draft|not\s*created|withdraw|unapproved|suspend/i, 'mute'],
      [/pend|in\s*process|in\s*progress|on\s*hold|await|submitted/i, 'warn'],
      [/success|pass|approve|baselined|complet|closed|(^|[^a-z])active([^a-z]|$)/i, 'ok'],
      [/entered|new|open|planning/i, 'info']
    ];
    self.p3StTone = function (v) {
      var s = (v == null ? '' : String(v)).trim();
      if (!s) return 'mute';
      for (var i = 0; i < P3_TONES.length; i++) if (P3_TONES[i][0].test(s)) return P3_TONES[i][1];
      return 'info';
    };
    self.p3StClass = function (v) {
      return (v == null || String(v).trim() === '') ? '' : 'st st--' + self.p3StTone(v);
    };

    /* The funnel: Budget -> PR -> PO -> GRN -> Invoiced -> Paid, drawn to scale
       against the largest stage. Each bar is clickable and opens the shared
       drill drawer through the EXISTING /butil/lines endpoint, so a stage total
       and its document list can never disagree. */
    var P3_STAGES = [
      { key: 'budgetAnnual', metric: 'budgetannual', lab: 'p3fBudget', cls: 'f-budget' },
      { key: 'commitmentPr', metric: 'pr',           lab: 'p3fPr',     cls: 'f-pr' },
      { key: 'obligationPo', metric: 'po',           lab: 'p3fPo',     cls: 'f-po' },
      { key: 'actualGrn',    metric: 'grn',          lab: 'p3fGrn',    cls: 'f-grn' },
      { key: 'apInvoiced',   metric: 'ap',           lab: 'p3fAp',     cls: 'f-ap' },
      { key: 'apPaid',       metric: null,           lab: 'p3fPaid',   cls: 'f-paid' }
    ];
    self.p3Funnel = ko.computed(function () {
      var f = (self.p3Data() || {}).funnel; if (!f) return null;
      var W = 1000, H = 210, pl = 10, pt = 30, pb = 46;
      var innerH = H - pt - pb, gap = 26;
      var slot = (W - 2 * pl) / P3_STAGES.length, barW = slot - gap;
      var maxV = 1;
      P3_STAGES.forEach(function (s) { maxV = Math.max(maxV, Math.abs(Number(f[s.key]) || 0)); });
      var st = P3_STAGES.map(function (s, i) {
        var v = Math.abs(Number(f[s.key]) || 0);
        var h = Math.max(2, v / maxV * innerH);
        var x = pl + i * slot, y = pt + (innerH - h) / 2;
        var prev = i ? Math.abs(Number(f[P3_STAGES[i - 1].key]) || 0) : 0;
        return { key: s.key, metric: s.metric, cls: s.cls, label: self.t(s.lab),
                 x: +x.toFixed(1), y: +y.toFixed(1), w: +barW.toFixed(1), h: +h.toFixed(1),
                 cx: +(x + barW / 2).toFixed(1), value: v,
                 txt: self.buNum(v), exact: self.money(v),
                 pctPrev: i ? (prev ? Math.round(v * 100 / prev) + '%' : '—') : '' };
      });
      var bands = [];
      for (var i = 0; i < st.length - 1; i++) {
        var a = st[i], b = st[i + 1];
        bands.push({ d: 'M' + (a.x + a.w) + ',' + a.y + ' L' + b.x + ',' + b.y +
                        ' L' + b.x + ',' + (b.y + b.h) + ' L' + (a.x + a.w) + ',' + (a.y + a.h) + ' Z',
                     mx: +((a.x + a.w + b.x) / 2).toFixed(1), my: pt + innerH / 2, pct: b.pctPrev });
      }
      return { W: W, H: H, baseY: pt + innerH, stages: st, bands: bands };
    });

    self.p3StageDrill = function (stage) {
      if (!stage || !stage.metric) return;   // Paid has no line endpoint
      self.drillTitle(stage.label);
      self.drillSub(self.p3Num() + ' — ' + (self.p3Card().projectName || ''));
      self.drillCtx([self.buYear(), self.buPeriod()].filter(Boolean).join('   ·   '));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      api('GET', '/butil/lines' + qs({ year: self.buYear(), period: self.buPeriod(),
        fproject: self.p3Num(), metric: stage.metric, ovr: self.buOvr() ? 'Y' : null }))
        .then(fillDrill).catch(drillFail);
    };

    self.loadProj360 = function () {
      var num = self.p3Num(); if (!num) return;
      self.p3Loading(true);
      self.p3Data(null); self.p3Tasks([]); self.p3Pipe(null);
      self.p3Rev(null); self.p3Trx([]); self.p3Cash(null);
      var p = { year: self.buYear(), period: self.buPeriod(), ovr: self.buOvr() ? 'Y' : null };
      var base = '/projects/' + encodeURIComponent(num);
      return Promise.all([
        api('GET', base + qs(p)).then(self.p3Data).catch(function (e) { toast(e.message || 'error', true); }),
        api('GET', base + '/tasks' + qs(p)).then(function (d) { self.p3Tasks(d.items || []); }).catch(function () {}),
        api('GET', base + '/pipeline' + qs(p)).then(self.p3Pipe).catch(function () {}),
        api('GET', base + '/revenue' + qs({ year: p.year })).then(self.p3Rev).catch(function () {}),
        api('GET', base + '/trx' + qs({ year: p.year })).then(function (d) { self.p3Trx(d.items || []); }).catch(function () {}),
        api('GET', base + '/cashflow' + qs({ year: p.year })).then(self.p3Cash).catch(function () {})
      ]).then(function () { self.p3Loading(false); });
    };

    self.p3PipeRows = ko.computed(function () {
      var p = self.p3Pipe(); if (!p) return [];
      return p[self.p3PipeTab()] || [];
    });
    self.p3PipeTabs = ko.computed(function () {
      var p = self.p3Pipe() || {}, c = p.counts || {};
      return [{ k: 'openPr', l: self.t('p3PipeOpenPr'), n: c.openPr || 0 },
              { k: 'openPo', l: self.t('p3PipeOpenPo'), n: c.openPo || 0 },
              { k: 'uninvoicedGrn', l: self.t('p3PipeGrn'), n: c.uninvoicedGrn || 0 },
              { k: 'pending', l: self.t('p3PipePending'), n: c.pending || 0 }];
    });
    self.p3SchedClass = function (t) {
      if (!t.plannedFinish) return 'st st--mute';
      return t.plannedFinishPast === 'Y' ? 'st st--warn' : 'st st--ok';
    };
    self.p3SchedLabel = function (t) {
      if (!t.plannedFinish) return self.t('p3SchedNone');
      return self.t(t.plannedFinishPast === 'Y' ? 'p3SchedPast' : 'p3SchedOn');
    };
    self.p3CompRow = function (score, labelKey) {
      var v = Number(score);
      return { label: self.t(labelKey),
               scored: v >= 0,
               txt: v >= 0 ? String(Math.round(v)) : self.t('p3NotScored'),
               w: v >= 0 ? Math.max(0, Math.min(100, v)) + '%' : '0%' };
    };
    self.p3Components = ko.computed(function () {
      var c = self.p3H().components || {};
      return [self.p3CompRow(c.burn, 'p3CompBurn'), self.p3CompRow(c.funds, 'p3CompFunds'),
              self.p3CompRow(c.approval, 'p3CompApproval'), self.p3CompRow(c.activity, 'p3CompActivity')];
    });


    /* ── Budget Change drawer — view + inline-edit the budget_change lines ──
       Opened from the Budget Change KPI tile; loads /butil/override/lines
       with the CURRENT page filters. The Budget Change cell is an inline
       signed number input (Enter or the row Save button POSTs /butil/override;
       empty or 0 clears the change) and a successful save updates the row in
       place, toasts and re-runs /butil so the KPIs/table pick the change up. */
    self.ovDrawer = ko.observable(false);
    self.ovMax = ko.observable(false);
    self.toggleOvMax = function () { self.ovMax(!self.ovMax()); };
    document.addEventListener('keydown', function (e) {
      // Esc inside the maximized override drawer restores it first (like the drill drawer)
      if (e.key === 'Escape' && self.ovDrawer() && self.ovMax()) self.ovMax(false);
    });
    self.ovLoading = ko.observable(false);
    self.ovRows = ko.observableArray([]);
    self.ovCount = ko.observable(0);
    self.ovTotFusion = ko.observable(0);
    // reason-category lookup shipped by GET /butil/override/lines (top-level reasons[])
    self.ovReasons = ko.observableArray([]);
    // language-aware option list (recomputes when the UI language toggles)
    self.ovReasonOpts = ko.computed(function () {
      var ar = self.lang() === 'ar';
      return self.ovReasons().map(function (r) {
        return { code: r.code, label: (ar ? r.nameAr : '') || r.name || r.code };
      });
    });
    self.ovReasonName = function (code) {
      if (!code) return '';
      var m = self.ovReasons().filter(function (r) { return r.code === code; })[0];
      return m ? ((self.lang() === 'ar' ? m.nameAr : '') || m.name || code) : code;
    };
    // reconciling totals footer: net change recomputes live as rows are edited
    self.ovTotOverride = ko.computed(function () {
      return self.ovRows().reduce(function (s, r) {
        var v = r.override();
        return s + (v == null || ('' + v).trim() === '' ? 0 : Number(v) || 0);
      }, 0);
    });
    self.openOvDrawer = function () {
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.ovDrawer(true); self.ovLoading(true); self.ovRows([]); self.ovCount(0); self.ovTotFusion(0);
      var p = self.buParams(0); delete p.limit; delete p.offset; delete p.ovr; delete p.procash; delete p.costadj;
      api('GET', '/butil/override/lines' + qs(p)).then(function (d) {
        var reasons = (d.reasons || []).slice();
        // KO options: gotcha — a stored code absent from its list is blanked;
        // re-inject any row's retired/unknown reason code as its own option
        (d.items || []).forEach(function (r) {
          if (r.reasonCategory && !reasons.some(function (x) { return x.code === r.reasonCategory; }))
            reasons.push({ code: r.reasonCategory, name: r.reasonCategory, nameAr: r.reasonCategory });
        });
        self.ovReasons(reasons);
        self.ovRows((d.items || []).map(function (r) {
          r.override = ko.observable(r.changeAmount == null ? '' : '' + r.changeAmount);
          r.reason = ko.observable(r.reasonCategory || '');
          r.comm = ko.observable(r.comments || '');
          r.updBy = ko.observable(r.updatedBy || '');
          r.updAt = ko.observable(r.updatedAt || '');
          r.saving = ko.observable(false);
          return r;
        }));
        self.ovCount(d.total || 0);
        self.ovTotFusion((d.totals && d.totals.fusionAnnual) || 0);
        self.ovLoading(false);
      }).catch(function (e) { self.ovLoading(false); self.ovDrawer(false); toast(e.message, true); });
    };
    self.closeOvDrawer = function () { self.ovDrawer(false); self.ovMax(false); };
    self.saveOvRow = function (row) {
      if (row.saving()) return;
      var raw = ('' + (row.override() == null ? '' : row.override())).trim();
      var val = raw === '' ? null : Number(raw);
      if (raw !== '' && isNaN(val)) { toast(self.t('ovBadNumber'), true); return; }
      row.saving(true);
      api('POST', '/butil/override', {
        id: row.id, budget_change: val,
        reason_category: row.reason() || null,
        comments: ('' + (row.comm() || '')).trim() || null
      }).then(function (d) {
        row.override(d.budget_change == null ? '' : '' + d.budget_change);
        row.reason(d.reason_category || '');
        row.comm(d.comments || '');
        row.updBy(d.budget_change_updated_by || '');
        row.updAt(d.budget_change_updated_at || '');
        // the saved change moves the line's adjusted figures — keep them live
        if (d.adjusted_annual != null) row.adjustedAnnual = d.adjusted_annual;
        if (d.adjusted_ytd != null) row.adjustedYtd = d.adjusted_ytd;
        row.saving(false);
        toast(self.t('ovSaved'));
        self.runButil(self.buOffset());          // KPIs + results reflect the new override
      }).catch(function (e) { row.saving(false); toast(e.message, true); });
    };
    // export the loaded override lines — same shape as drillExportCsv (BOM + total footer)
    self.ovExportCsv = function () {
      var rows = self.ovRows();
      if (!rows.length) return;
      var esc = function (v) { return '"' + ('' + (v == null ? '' : v)).replace(/"/g, '""') + '"'; };
      var heads = [self.t('cProject'), self.t('buMissCcPName'), self.t('cTask'), self.t('cEtype'),
        self.t('fPeriod'), self.t('ovColFusion'), self.t('ovColFusionYtd'), self.t('cOverrideBudget'),
        self.t('ovColAdjAnnual'), self.t('ovColAdjYtd'),
        self.t('ovColReason'), self.t('ovColComments'),
        self.t('ovColUpdBy'), self.t('ovColUpdAt')];
      var lines = [heads.map(esc).join(',')];
      rows.forEach(function (r) {
        lines.push([r.projectNumber, r.projectName, r.taskNumber, r.expenditureType,
          r.accountingPeriod, r.fusionAnnual, r.fusionYtd, r.override(),
          r.adjustedAnnual, r.adjustedYtd,
          self.ovReasonName(r.reason()), r.comm(),
          r.updBy(), r.updAt()].map(esc).join(','));
      });
      // reconciliation footer: fusion annual + net change under their own columns
      lines.push([self.t('drillTotal'), '', '', '', '', self.ovTotFusion(), '', self.ovTotOverride(),
        '', '', '', '', '', ''].map(esc).join(','));
      var blob = new Blob(['\uFEFF' + lines.join('\n')], { type: 'text/csv;charset=utf-8' });
      var u = URL.createObjectURL(blob);
      var a = document.createElement('a'); a.href = u; a.download = 'gl_budget_change_' + self.buYear() + '.csv';
      a.click(); URL.revokeObjectURL(u);
    };

    /* ── Budget Override from Excel — template download (Visual Builder Add-in).
       The /xl/ template endpoint lives OUTSIDE the /gl/ module, so this uses
       the raw authed-blob fetch (same pattern as the briefing-book download). */
    self.xltplBusyF = ko.observable(false);
    self.downloadXlTemplate = function () {
      if (self.xltplBusyF()) return;
      self.xltplBusyF(true);
      fetch('/ords/admin/xl/templates/download?code=BUDGET_OVERRIDE',
            { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) {
          if (!r.ok) { throw new Error(self.t('xltplDlFail') + ' (HTTP ' + r.status + ')'); }
          return r.blob();
        })
        .then(function (b) {
          var u = URL.createObjectURL(b);
          var a = document.createElement('a');
          a.href = u; a.download = 'Budget_Override_Template.xlsx';
          a.click(); URL.revokeObjectURL(u);
          self.xltplBusyF(false);
        })
        .catch(function (e) { self.xltplBusyF(false); toast(e.message, true); });
    };

    // The VB add-in itself (current-user MSI) is also hosted in the template
    // repository (code VBAFE_ADDIN) for PCs where it is not installed yet.
    self.downloadVbAddin = function () {
      fetch('/ords/admin/xl/templates/download?code=VBAFE_ADDIN',
            { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) {
          if (!r.ok) { throw new Error(self.t('xltplDlFail') + ' (HTTP ' + r.status + ')'); }
          return r.blob();
        })
        .then(function (b) {
          var u = URL.createObjectURL(b);
          var a = document.createElement('a');
          a.href = u; a.download = 'vbafe-installer-current-user.msi';
          a.click(); URL.revokeObjectURL(u);
        })
        .catch(function (e) { toast(e.message, true); });
      return false;
    };

    /* ════ DASHBOARD — executive analytics ════ */
    self.dashLoaded = ko.observable(false); self.dashLoading = ko.observable(false);
    self.dashPeriod = ko.observable(''); self.dash = ko.observable(null);
    self.loadDashboard = function () {
      var run = function () {
        if (!self.dashPeriod()) self.dashPeriod(self.acPeriod() || (self.periods()[0] || {}).period || '');
        self.dashLoading(true);
        return api('GET', '/dashboard' + qs({ period: self.dashPeriod() })).then(function (d) {
          self.dash(d); self.dashLoaded(true); self.dashLoading(false);
          if (d && d.period && d.period !== self.dashPeriod()) self.dashPeriod(d.period);
        }).catch(function (e) { self.dashLoading(false); fail(e); });
      };
      if (!self.acFiltersLoaded()) return self.loadAcFilters().then(run);
      return run();
    };
    self.dashPeriod.subscribe(function () { if (self.view() === 'dashboard' && self.dashLoaded()) self.loadDashboard(); });

    function cloneWithPct(arr, key) {
      var max = 1; arr.forEach(function (x) { max = Math.max(max, Math.abs(Number(x[key]) || 0)); });
      return arr.map(function (x) { var o = {}; for (var k in x) o[k] = x[k]; o._pct = Math.round((Math.abs(Number(x[key]) || 0)) * 100 / max); return o; });
    }
    self.kpis = ko.computed(function () { var d = self.dash(); return (d && d.kpis) || {}; });
    self.sectorBars = ko.computed(function () { var d = self.dash(); return d ? cloneWithPct((d.bySector || []).slice(), 'actual') : []; });
    self.programBars = ko.computed(function () { var d = self.dash(); return d ? cloneWithPct((d.byProgram || []).slice(), 'actual') : []; });
    self.apprBars = ko.computed(function () { var d = self.dash(); return d ? cloneWithPct((d.byAppropriation || []).slice(), 'poTotal') : []; });

    // utilisation radial gauge geometry
    self.gauge = ko.computed(function () {
      var k = self.kpis(), r = 60, C = 2 * Math.PI * r;
      var util = Math.max(0, Math.min(100, Number(k.utilizationPct) || 0));
      var commit = Math.max(0, Math.min(100, Number(k.commitmentPct) || 0));
      return { util: util, commit: commit, C: C.toFixed(1),
        dash: ((util / 100) * C).toFixed(1) + ' ' + C.toFixed(1),
        dashCommit: ((commit / 100) * C).toFixed(1) + ' ' + C.toFixed(1) };
    });

    // period-over-period actual trend (SVG line + area, scaled to actual max)
    self.trend = ko.computed(function () {
      var d = self.dash(); if (!d || !d.trend || !d.trend.length) return null;
      var t = d.trend, W = 560, H = 170, pl = 12, pb = 26, pt = 14;
      var maxV = 1; t.forEach(function (p) { maxV = Math.max(maxV, Number(p.actual) || 0); });
      var n = t.length, xs = function (i) { return pl + (n === 1 ? 0 : i * (W - 2 * pl) / (n - 1)); };
      var ys = function (v) { return (H - pb) - (Number(v) || 0) / maxV * (H - pb - pt); };
      var pts = t.map(function (p, i) { return { x: +xs(i).toFixed(1), y: +ys(p.actual).toFixed(1), period: p.period, actual: p.actual }; });
      var line = pts.map(function (p) { return p.x + ',' + p.y; }).join(' ');
      var area = 'M' + pts[0].x + ',' + (H - pb) + ' L' + line.split(' ').join(' L') + ' L' + pts[n - 1].x + ',' + (H - pb) + ' Z';
      return { W: W, H: H, baseY: H - pb, line: line, area: area, pts: pts, maxV: maxV };
    });

    // auto-generated executive insights
    self.insights = ko.computed(function () {
      var d = self.dash(); if (!d || !d.kpis) return [];
      var k = d.kpis, out = [], M = self.money, C = self.compact;
      function sub(s, o) { for (var key in o) s = s.replace('{' + key + '}', o[key]); return s; }
      out.push(sub(self.t('insUtil'), { p: k.utilizationPct || 0, a: C(k.actual), b: C(k.budget) }));
      out.push(sub(self.t('insCommit'), { p: k.commitmentPct || 0, f: C(k.fundsAvailable) }));
      var sectors = (d.bySector || []).filter(function (x) { return (Number(x.actual) || 0) > 0; });
      if (sectors.length) {
        var top = sectors[0], pct = k.actual > 0 ? Math.round(top.actual * 100 / k.actual) : 0;
        out.push(sub(self.t('insTopSector'), { s: top.name, a: C(top.actual), p: pct }));
      }
      var apprs = (d.byAppropriation || []).filter(function (x) { return (Number(x.poTotal) || 0) > 0; });
      if (apprs.length) out.push(sub(self.t('insTopAppr'), { s: apprs[0].name, a: C(apprs[0].poTotal), n: apprs[0].poCount }));
      var tr = (d.trend || []).filter(function (x) { return (Number(x.actual) || 0) > 0; });
      if (tr.length >= 2) {
        var a = tr[0], b = tr[tr.length - 1], x = a.actual > 0 ? (b.actual / a.actual).toFixed(1) : '—';
        out.push(sub(self.t('insGrowth'), { a: C(a.actual), p1: a.period, b: C(b.actual), p2: b.period, x: x }));
      }
      return out;
    });

    /* ══════════ RECONCILIATION (Actuals ↔ Budget Utilization) ══════════
       Verifies data integrity between the two GL dashboards. Consumption
       (AP/GRN/PR/PO) reconciles to residual 0 via named leakage buckets;
       budget = two ledgers shown side by side (GL Expense CHx vs PPM). */
    function rcMulti() {
      var sel = ko.observableArray([]), pick = ko.observable('');
      return { sel: sel, pick: pick, add: function () { var v = pick(); if (v && sel.indexOf(v) < 0) sel.push(v); pick(''); return true; } };
    }
    self.rcFiltersLoaded = ko.observable(false); self.rcLoaded = ko.observable(false); self.rcBusy = ko.observable(false);
    self.rcYears = ko.observableArray([]); self.rcYear = ko.observable('');
    self.rcPeriodsAll = ko.observableArray([]);
    self.rcPeriodOpts = ko.computed(function () { var y = String(self.rcYear() || ''); return self.rcPeriodsAll().filter(function (p) { return p.slice(3) === y; }); });
    self.rcPeriod = ko.observable('');
    self.rcSectors = ko.observableArray([]); self.rcChapters = ko.observableArray([]);
    self.rcAccounts = ko.observableArray([]); self.rcCostCenters = ko.observableArray([]);
    self.rcApprops = ko.observableArray([]); self.rcPrograms = ko.observableArray([]);
    self.rcSector = rcMulti(); self.rcChap = rcMulti(); self.rcAcct = rcMulti();
    self.rcCc = rcMulti(); self.rcAppr = rcMulti(); self.rcProg = rcMulti();
    self.rcBChap = rcMulti();  // GL budget chapters (Expense scope, default CH2..CH5)
    self.rcChipRemove = function (arr, v) { arr.remove(v); };
    self.rcGrain = ko.observable('account');
    self.rcGrains = ['account', 'sector', 'chapter', 'costcenter', 'appropriation', 'program', 'combination', 'budgetline'];
    self.rcMeasureSel = ko.observable('ap');
    self.rcMeasureTabs = ['ap', 'grn', 'pr', 'po'];
    self.rcSummary = ko.observable(null); self.rcRows = ko.observableArray([]);

    self.loadRcFilters = function () {
      return api('GET', '/recon/filters').then(function (d) {
        self.rcYears(d.years || []); self.rcPeriodsAll(d.periods || []);
        self.rcSectors((d.sectors || []).map(function (s) { return { v: s, l: s }; }));
        self.rcChapters((d.chapters || []).map(function (c) { return { v: c.code, l: c.code + ' · ' + c.name }; }));
        self.rcAccounts((d.glAccounts || []).map(function (c) { return { v: c.code, l: c.code + (c.desc ? ' — ' + c.desc : '') }; }));
        self.rcCostCenters((d.costCenters || []).map(function (c) { return { v: c.code, l: c.code + (c.desc ? ' — ' + c.desc : '') }; }));
        self.rcApprops((d.appropriations || []).map(function (c) { return { v: c.code, l: c.code + (c.desc ? ' — ' + c.desc : '') }; }));
        self.rcPrograms((d.programs || []).map(function (c) { return { v: c.code, l: c.code + (c.desc ? ' — ' + c.desc : '') }; }));
        if (!self.rcYear()) self.rcYear(d.defaultYear || (d.years || [])[0] || '');
        self.rcBChap.sel((d.budgetChapters || ['CH2', 'CH3', 'CH4', 'CH5']).slice());
        self.rcFiltersLoaded(true);
      });
    };
    function rcPipe(m) { return m.sel().length ? m.sel().join('|') : null; }
    self.rcParams = function () {
      return {
        year: self.rcYear(), period: self.rcPeriod() || null,
        sector: rcPipe(self.rcSector), chapter: rcPipe(self.rcChap), glaccount: rcPipe(self.rcAcct),
        costcenter: rcPipe(self.rcCc), appropriation: rcPipe(self.rcAppr), program: rcPipe(self.rcProg),
        budgetchapters: self.rcBChap.sel().length ? self.rcBChap.sel().join('|') : null
      };
    };
    self.runRecon = function () {
      if (!self.rcYear()) return;
      self.rcBusy(true);
      var p = self.rcParams();
      var rp = Object.assign({}, p, { grain: self.rcGrain(), measure: self.rcMeasureSel(), limit: 1000 });
      Promise.all([api('GET', '/recon/summary' + qs(p)), api('GET', '/recon/rows' + qs(rp))]).then(function (res) {
        self.rcSummary(res[0]); self.rcRows(res[1].rows || []); self.rcLoaded(true); self.rcBusy(false);
      }).catch(function (e) { self.rcBusy(false); toast(e.message, true); });
    };
    self.runRcRows = function () {
      var rp = Object.assign({}, self.rcParams(), { grain: self.rcGrain(), measure: self.rcMeasureSel(), limit: 1000 });
      self.rcBusy(true);
      api('GET', '/recon/rows' + qs(rp)).then(function (d) { self.rcRows(d.rows || []); self.rcBusy(false); })
        .catch(function (e) { self.rcBusy(false); toast(e.message, true); });
    };
    self.rcSetGrain = function (g) { if (self.rcGrain() === g) return true; self.rcGrain(g); if (self.rcLoaded()) self.runRcRows(); return true; };
    self.rcSetMeasure = function (m) { if (self.rcMeasureSel() === m) return true; self.rcMeasureSel(m); if (self.rcLoaded()) self.runRcRows(); return true; };
    self.rcReset = function () {
      [self.rcSector, self.rcChap, self.rcAcct, self.rcCc, self.rcAppr, self.rcProg].forEach(function (m) { m.sel([]); m.pick(''); });
      self.rcPeriod(''); self.rcBChap.sel(['CH2', 'CH3', 'CH4', 'CH5']); self.runRecon();
    };

    /* KPI / chart computeds (all measures, from /recon/summary) */
    self.rcMeasures = ko.computed(function () {
      var s = self.rcSummary(); if (!s) return [];
      var keys = ['ap', 'grn', 'pr', 'po'], mx = 1;
      keys.forEach(function (k) { mx = Math.max(mx, s.measures[k].actuals, s.measures[k].butil); });
      return keys.map(function (k) {
        var x = s.measures[k];
        return {
          key: k, label: self.t('rcM_' + k), act: x.actuals, but: x.butil, diff: x.diff,
          noProject: x.noProject, noBudgetLine: x.noBudgetLine, apValidation: x.apValidation,
          cov: x.actuals ? Math.round(x.butil / x.actuals * 100) : 100,
          status: (Math.abs(x.diff) < 1 ? 'ok' : (x.noBudgetLine > 0.5 ? 'warn' : 'info')),
          wAct: Math.max(1, Math.round(x.actuals / mx * 100)), wBut: Math.max(0, Math.round(x.butil / mx * 100))
        };
      });
    });
    self.rcDonut = ko.computed(function () {
      var s = self.rcSummary(); if (!s) return null;
      var d = s.derived, tot = d.consumptionActuals || 0; if (!tot) return null;
      var seg = [
        { k: 'matched', v: d.consumptionButil, c: '#3F6F5F' },
        { k: 'noProject', v: d.noProjectTotal, c: '#C9992B' },
        { k: 'apValidation', v: d.apValidationTotal, c: '#7C4DBE' },
        { k: 'noBudgetLine', v: d.noBudgetLineTotal, c: '#C0504D' }
      // drop empty buckets from the chart (e.g. Non-project once '#' rows are excluded)
      ].filter(function (g) { return g.k === 'matched' || Math.abs(g.v) > 0.5; });
      var acc = 0, stops = [];
      seg.forEach(function (g) { var a = acc / tot * 100, b = (acc + Math.max(0, g.v)) / tot * 100; stops.push(g.c + ' ' + a.toFixed(2) + '% ' + b.toFixed(2) + '%'); acc += Math.max(0, g.v); });
      return {
        css: 'conic-gradient(' + stops.join(',') + ')',
        seg: seg.map(function (g) { return { k: g.k, label: self.t('rcSeg_' + g.k), v: g.v, c: g.c, pct: Math.round(g.v / tot * 100) }; })
      };
    });
    self.rcBudget = ko.computed(function () { var s = self.rcSummary(); return s ? s.budget : null; });
    self.rcFund = ko.computed(function () { var s = self.rcSummary(); return s ? s.fund : null; });
    self.rcNonProject = ko.computed(function () { var s = self.rcSummary(); return s ? s.derived.noProjectTotal : 0; });
    self.rcOrphan = ko.computed(function () { var s = self.rcSummary(); return s ? s.derived.noBudgetLineTotal : 0; });
    self.rcConsAct = ko.computed(function () { var s = self.rcSummary(); return s ? s.derived.consumptionActuals : 0; });
    self.rcConsBut = ko.computed(function () { var s = self.rcSummary(); return s ? s.derived.consumptionButil : 0; });
    self.rcCoverage = ko.computed(function () { var a = self.rcConsAct(); return a ? Math.round(self.rcConsBut() / a * 100) : 100; });
    self.rcRowMax = ko.computed(function () { var mx = 1; self.rcRows().forEach(function (r) { mx = Math.max(mx, Math.abs(r.actualsSide), Math.abs(r.butilSide)); }); return mx; });
    self.rcMeasName = function (m) { return self.t('rcM_' + m); };

    /* difference → source drill (reuses the shared drill drawer) */
    self.rcDrill = function (measure, bucket, row) {
      self.drillTitle(self.t('rcM_' + measure) + '  ·  ' + self.t('rcSeg_' + bucket));
      self.drillSub(row ? (self.t('rcGr_' + self.rcGrain()) + ': ' + row.key) : self.t('rcAllScope'));
      self.drillCtx(self.rcPeriod() ? self.t('ytd') + ' ' + self.rcPeriod() : String(self.rcYear()));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true); self.drillMax(false);
      var p = Object.assign({}, self.rcParams(), { measure: measure, bucket: bucket });
      if (row) {
        if (self.rcGrain() === 'budgetline') { var pt = String(row.key).split(' / '); p.grain = 'budgetline'; p.project = pt[0]; p.task = pt[1] === '-' ? null : pt[1]; p.etype = pt[2] === '-' ? null : pt[2]; }
        else { p.grain = self.rcGrain(); p.key = row.key; }
      }
      api('GET', '/recon/drill' + qs(p)).then(function (d) {
        self.drillCols(d.columns || []); self.drillRows(d.rows || []); self.drillTotalV(d.total || 0); self.drillCount(d.count || 0); self.drillLoading(false);
      }).catch(function (e) { self.drillLoading(false); self.drillDrawer(false); toast(e.message, true); });
    };
    /* register cell → drill the selected measure + bucket for that row */
    self.rcCellDrill = function (row, bucket) { self.rcDrill(self.rcMeasureSel(), bucket, row); return true; };

    /* KPI tile → cross-measure (all AP+GRN+PR+PO) source-doc drill for a bucket */
    self.rcKpiDrill = function (bucket, titleKey) {
      self.drillTitle(self.t(titleKey));
      self.drillSub(self.t('rcAllMeasures'));
      self.drillCtx(self.rcPeriod() ? self.t('ytd') + ' ' + self.rcPeriod() : String(self.rcYear()));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true); self.drillMax(false);
      var p = Object.assign({}, self.rcParams(), { measure: 'all', bucket: bucket });
      api('GET', '/recon/drill' + qs(p)).then(function (d) {
        self.drillCols(d.columns || []); self.drillRows(d.rows || []); self.drillTotalV(d.total || 0); self.drillCount(d.count || 0); self.drillLoading(false);
      }).catch(function (e) { self.drillLoading(false); self.drillDrawer(false); toast(e.message, true); });
      return true;
    };
    /* Budget / Fund tile → per-ledger budget-line detail (side gl|ppm; focus budget|fund picks the reconciling total) */
    self.rcBudgetDrill = function (side, focus, titleKey) {
      self.drillTitle(self.t(titleKey));
      self.drillSub(self.t(side === 'gl' ? 'rcGlLedger' : 'rcPpmLedger'));
      self.drillCtx(self.rcPeriod() ? self.t('ytd') + ' ' + self.rcPeriod() : String(self.rcYear()));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true); self.drillMax(false);
      var p = Object.assign({}, self.rcParams(), { side: side });
      api('GET', '/recon/budget' + qs(p)).then(function (d) {
        self.drillCols(d.columns || []); self.drillRows(d.rows || []);
        self.drillTotalV(focus === 'fund' ? (d.fundTotal || 0) : (d.total || 0));
        self.drillCount(d.count || 0); self.drillLoading(false);
      }).catch(function (e) { self.drillLoading(false); self.drillDrawer(false); toast(e.message, true); });
      return true;
    };

    self.rcExportCsv = function () {
      var rows = self.rcRows(); if (!rows.length) return;
      var head = ['Key', 'Label', 'Actuals', 'Butil', 'Difference', 'NonProject', 'APValidation', 'NoBudgetLine'];
      var lines = [head.join(',')];
      rows.forEach(function (r) {
        lines.push([r.key, '"' + String(r.label || '').replace(/"/g, '""') + '"', Math.round(r.actualsSide), Math.round(r.butilSide), Math.round(r.diff), Math.round(r.noProject), Math.round(r.apValidation), Math.round(r.noBudgetLine)].join(','));
      });
      var blob = new Blob(['﻿' + lines.join('\n')], { type: 'text/csv;charset=utf-8;' });
      var a = document.createElement('a'); a.href = URL.createObjectURL(blob);
      a.download = 'reconciliation_' + self.rcMeasureSel() + '_' + self.rcGrain() + '_' + self.rcYear() + '.csv';
      a.click();
    };

    /* ════ LEGACY (EBS) — Fusion/EBS COA mapping + historical balances ════
       Mapping register on the SHARED <interactive-report>; admin edits via a
       drawer; EBS balance Excel upload (SheetJS client parse + chunked POST,
       the AR-rebill pattern) + per-year coverage from /ebs-balances/summary.
       Writes are SYS_ADMIN while security enforcement is off (server-gated
       GL_MANAGE_EBS_MAPPING). */
    self.canManageEbs = self.isSysAdmin;
    /* ══════════ Projects Costing Adjustments (DCT_PA_COST_ADJ, 2026-08-22) ══
       Manual signed cost adjustments on a budget line — optionally sourced
       from a mis-coded AP invoice distribution — plus an optional signed
       budget override on the same line. DRAFT rows are editable; APPROVED
       rows fold into Budget Utilization behind "Include Cost Adjustment". */
    self.canManageCadj = self.isSysAdmin;
    self.caLoaded = ko.observable(false);
    self.caLoading = ko.observable(false);
    self.caData = ko.observable(null);
    self.caCount = ko.observable(0);
    self.caLookups = ko.observable(null);
    self.caYear = ko.observable('');
    self.caStatus = ko.observable('');
    self.caSearch = ko.observable('');
    var caRowMap = {};                        // ref -> full API row (IR keeps only declared cols)
    self.caStatusOpts = ko.computed(function () {
      var lk = self.caLookups();
      return ((lk && lk.statuses) || []).map(function (s) {
        return { v: s.code, l: self.lang() === 'ar' && s.nameAr ? s.nameAr : s.name };
      });
    });
    self.caClassOpts = ko.computed(function () {
      var lk = self.caLookups();
      return ((lk && lk.classifications) || []).map(function (s) {
        return { v: s.code, l: self.lang() === 'ar' && s.nameAr ? s.nameAr : s.name };
      });
    });
    self.loadCaLookups = function () {
      return api('GET', '/costadj/meta/lookups').then(self.caLookups).catch(fail);
    };
    /* column order = the user's annotated layout (2026-08-22 feedback):
       Status first, then Project / Task / Etype / the two signed amounts /
       Invoice / Supplier / Ref / Reason, with the time + audit columns last.
       budgetYear is 'text' so it renders 2026, never 2,026. */
    function caColumns() {
      return [
        { key: 'status',          label: self.t('caStatusL'),    type: 'text' },
        { key: 'projectNumber',   label: self.t('cProject'),     type: 'text' },
        { key: 'taskNumber',      label: self.t('cTask'),        type: 'text' },
        { key: 'expenditureType', label: self.t('cEtype'),       type: 'text' },
        { key: 'amount',          label: self.t('caAmountCol'),  type: 'money' },
        { key: 'budgetOverride',  label: self.t('caOvrCol'),     type: 'money' },
        { key: 'invoiceNumber',   label: self.t('caInvoice'),    type: 'text' },
        { key: 'supplier',        label: self.t('caSupplier'),   type: 'text' },
        { key: 'ref',             label: self.t('caRef'),        type: 'text' },
        { key: 'reason',          label: self.t('caReason'),     type: 'text' },
        { key: 'budgetYear',      label: self.t('fYearL'),       type: 'text' },
        { key: 'period',          label: self.t('fPeriod'),      type: 'text' },
        { key: 'className',       label: self.t('caClass'),      type: 'text' },
        { key: 'createdBy',       label: self.t('caCreatedBy'),  type: 'text' },
        { key: 'createdAt',       label: self.t('caCreatedAt'),  type: 'text' },
        { key: 'actionedBy',      label: self.t('caActionedBy'), type: 'text' },
        { key: 'actionedAt',      label: self.t('caActionedAt'), type: 'text' }
      ];
    }
    self.runCostAdj = function () {
      self.caLoading(true);
      var p = { year: self.caYear() || null, status: self.caStatus() || null,
                search: self.caSearch() || null };
      return api('GET', '/costadj' + qs(p)).then(function (d) {
        caRowMap = {};
        (d.items || []).forEach(function (r) {
          caRowMap[r.ref] = r;
          // status pill: the IR renders row._rowClass on the <tr>; app.css
          // styles ONLY the td[data-key=status] cell from it (colour + icon)
          r._rowClass = 'ca-st-' + (r.status || '').toLowerCase();
        });
        self.caCount(d.total || 0);
        self.caData({ columns: caColumns(), items: d.items || [], total: d.total || 0,
                      truncated: (d.total || 0) >= 2000, maxRows: 2000, section: 'cadj',
                      // designed column-order change beats stale IR autosave
                      stateRev: 2,
                      // Invoice cells deep-link to the Fusion AP invoice (the
                      // internal invoice_id rides the side-map, not the row)
                      cellLink: function (row, key) {
                        if (key !== 'invoiceNumber') return null;
                        var full = caRowMap[row.ref], F = window.FusionLinks;
                        return (full && full.invoiceId && F) ? F.invoice(full.invoiceId) : null;
                      } });
        self.caLoaded(true); self.caLoading(false);
      }).catch(function (e) { self.caLoading(false); fail(e); });
    };
    /* row click -> drawer; resolve the IR cell like the EBS map page does.
       Invoice cells are Fusion deep-link anchors — let those navigate. */
    self.caGridClick = function (d, e) {
      if (e.target && e.target.closest && e.target.closest('a.ir-link')) return true;
      var td = (e.target && e.target.closest) ? e.target.closest('td') : null;
      if (!td) return true;
      var ctx;
      try { ctx = ko.contextFor(td); } catch (err) { return true; }
      if (!ctx || !ctx.$parent || !ctx.$parent.row) return true;
      var row = caRowMap[ctx.$parent.row.ref];
      if (row) { self.openCaEdit(row); return false; }
      return true;
    };
    /* drawer state */
    self.caDrawer = ko.observable(false);
    self.caSaving = ko.observable(false);
    self.caId = ko.observable(null);
    self.caRow = ko.observable(null);         // full API row while editing/viewing
    self.caFYear = ko.observable('');
    self.caFPeriod = ko.observable('');
    self.caFProj = ko.observable('');
    self.caFTask = ko.observable('');
    self.caFEtype = ko.observable('');
    self.caFAmount = ko.observable('');
    self.caFOvr = ko.observable('');
    self.caFClass = ko.observable('');
    self.caFReason = ko.observable('');
    self.caFComments = ko.observable('');
    self.caFDist = ko.observable(null);       // linked AP distribution (or null)
    self.caReadOnly = ko.computed(function () {
      var r = self.caRow();
      return (!!r && r.status !== 'DRAFT') || !self.canManageCadj;
    });
    self.caPeriodOpts = ko.computed(function () {
      var y = self.caFYear(); if (!y) return [];
      var out = []; for (var m = 1; m <= 12; m++) out.push((m < 10 ? '0' : '') + m + '-' + y);
      return out;
    });
    // the accounting period is MANDATORY (2026-08-22): current month for the
    // current year, December for any other year — always a real period
    function caDefPeriod(y) {
      if (!y) return '';
      var now = new Date();
      if (Number(y) === now.getFullYear()) {
        var m = now.getMonth() + 1;
        return (m < 10 ? '0' + m : '' + m) + '-' + y;
      }
      return '12-' + y;
    }
    /* dependent pick lists (2026-08-22): tasks scope to the picked project,
       expenditure types to project(+task) — served from the hourly butil key
       cache. Loaded on the inputs' CHANGE events (blur / datalist pick),
       never per keystroke. */
    self.caTasks = ko.observableArray([]);
    self.caEtypes = ko.observableArray([]);
    self.loadCaTasks = function () {
      self.caTasks([]);
      var y = self.caFYear(), pn = (self.caFProj() || '').trim();
      if (!y || !pn) return;
      api('GET', '/costadj/meta/tasks' + qs({ year: y, project: pn }))
        .then(function (d) { self.caTasks(d.items || []); }).catch(function () {});
    };
    self.loadCaEtypes = function () {
      self.caEtypes([]);
      var y = self.caFYear(), pn = (self.caFProj() || '').trim();
      if (!y || !pn) return;
      api('GET', '/costadj/meta/etypes' + qs({ year: y, project: pn,
        task: (self.caFTask() || '').trim() || null }))
        .then(function (d) { self.caEtypes(d.items || []); }).catch(function () {});
    };
    self.caProjChanged = function () { self.loadCaTasks(); self.loadCaEtypes(); return true; };
    self.caTaskChanged = function () { self.loadCaEtypes(); return true; };
    // year change: keep the chosen month on the new year (the options list is
    // rebuilt, and KO blanks a value absent from it — re-assert next tick)
    self.caFYear.subscribe(function (y) {
      if (!self.caDrawer()) return;
      var mm = (self.caFPeriod() || '').substring(0, 2);
      var v = (/^(0[1-9]|1[0-2])$/.test(mm) && y) ? mm + '-' + y : caDefPeriod(y);
      setTimeout(function () { self.caFPeriod(v); }, 0);
      self.loadCaTasks(); self.loadCaEtypes();
    });
    self.openCaNew = function () {
      self.caId(null); self.caRow(null);
      self.caFYear(self.buYear() || (self.buYears()[0] || ''));
      self.caFPeriod(caDefPeriod(self.caFYear()));
      self.caFProj(''); self.caFTask(''); self.caFEtype('');
      self.caFAmount(''); self.caFOvr(''); self.caFClass(''); self.caFReason(''); self.caFComments('');
      self.caFDist(null); self.caDistRows([]); self.caDistQ('');
      self.caTasks([]); self.caEtypes([]);
      self.caDrawer(true);
    };
    self.openCaEdit = function (row) {
      self.caId(row.id); self.caRow(row);
      self.caFYear(row.budgetYear);
      self.caFProj(row.projectNumber); self.caFTask(row.taskNumber); self.caFEtype(row.expenditureType);
      self.caFAmount(row.amount); self.caFOvr(row.budgetOverride || '');
      self.caFClass(row.classification || ''); self.caFReason(row.reason || '');
      self.caFComments(row.comments || '');
      self.caFDist(row.invoiceNumber ? { invoiceId: row.invoiceId, invoiceNumber: row.invoiceNumber,
        line: row.invoiceLine, dist: row.distLine, supplier: row.supplier, amountAed: null,
        projectNumber: row.origProject, taskNumber: row.origTask, expenditureType: row.origEtype } : null);
      self.caDistRows([]); self.caDistQ('');
      // period AFTER year (the year subscription re-defaults it next tick)
      setTimeout(function () { self.caFPeriod(row.period || caDefPeriod(row.budgetYear)); }, 0);
      self.loadCaTasks(); self.loadCaEtypes();
      self.caDrawer(true);
    };
    self.closeCaDrawer = function () { self.caDrawer(false); };
    /* AP invoice distribution search (server cap 50) */
    self.caDistQ = ko.observable('');
    self.caDistRows = ko.observableArray([]);
    self.caDistBusy = ko.observable(false);
    self.searchCaDists = function () {
      var s = (self.caDistQ() || '').trim();
      if (s.length < 2) { toast(self.t('caDistMin'), true); return; }
      self.caDistBusy(true);
      api('GET', '/costadj/meta/dists' + qs({ search: s })).then(function (d) {
        self.caDistRows(d.items || []); self.caDistBusy(false);
      }).catch(function (e) { self.caDistBusy(false); fail(e); });
    };
    self.pickCaDist = function (r) {
      self.caFDist(r);
      // prefill a default amount the user can edit or negate
      if (!self.caFAmount()) self.caFAmount(r.amountAed);
      self.caDistRows([]);
      return true;
    };
    self.clearCaDist = function () { self.caFDist(null); };
    self.saveCa = function () {
      var amt = Number(self.caFAmount() || 0), ovr = Number(self.caFOvr() || 0);
      if (!self.caFYear() || !self.caFPeriod() || !(self.caFProj() || '').trim()
          || !(self.caFTask() || '').trim() || !(self.caFEtype() || '').trim()
          || !(self.caFReason() || '').trim() || (!amt && !ovr)) {
        toast(self.t('caReqFields'), true); return;
      }
      var d = self.caFDist();
      var body = { budgetYear: Number(self.caFYear()), period: self.caFPeriod() || null,
        projectNumber: self.caFProj().trim(), taskNumber: self.caFTask().trim(),
        expenditureType: self.caFEtype().trim(),
        amount: amt,
        budgetOverride: (self.caFOvr() === '' || self.caFOvr() == null) ? null : ovr,
        classification: self.caFClass() || null, reason: self.caFReason().trim(),
        comments: self.caFComments() || null,
        invoiceId: d ? d.invoiceId : null, invoiceNumber: d ? d.invoiceNumber : null,
        invoiceLine: d ? d.line : null, distLine: d ? d.dist : null,
        supplier: d ? (d.supplier || null) : null,
        origProject: d ? (d.projectNumber || null) : null,
        origTask: d ? (d.taskNumber || null) : null,
        origEtype: d ? (d.expenditureType || null) : null };
      self.caSaving(true);
      var done = function () { self.caSaving(false); self.caDrawer(false);
                               toast(self.t('saved')); self.runCostAdj(); };
      var oops = function (e) { self.caSaving(false); toast(e.message, true); };
      if (self.caId()) api('PUT', '/costadj/' + self.caId(), body).then(done).catch(oops);
      else api('POST', '/costadj', body).then(done).catch(oops);
    };
    self.deleteCa = function () {
      if (!self.caId() || !window.confirm(self.t('caDeleteConfirm'))) return;
      self.caSaving(true);
      api('DELETE', '/costadj/' + self.caId()).then(function () {
        self.caSaving(false); self.caDrawer(false); toast(self.t('deleted')); self.runCostAdj();
      }).catch(function (e) { self.caSaving(false); toast(e.message, true); });
    };
    self.actionCa = function (act) {
      if (!self.caId()) return;
      if (!window.confirm(self.t(act === 'APPROVE' ? 'caApproveConfirm' : 'caRejectConfirm'))) return;
      self.caSaving(true);
      api('POST', '/costadj/' + self.caId() + '/action', { action: act }).then(function () {
        self.caSaving(false); self.caDrawer(false); toast(self.t('saved')); self.runCostAdj();
      }).catch(function (e) { self.caSaving(false); toast(e.message, true); });
    };

    /* ══════════ Budget Utilization COMMENTS (db/v2/125 + GL/db/26, 2026-08-23) ══
       Threaded business-justification comments per budget year + accounting
       period at 8 levels. Entry is split by context: the grid's Comments
       column (BUTIL_LINE), a chat icon on the AP/PR/PO drill rows, and the
       Comments register page (SECTOR / COST_CENTER + the full review list).
       Capabilities come from /butilcmt/meta/caps (common role-permission
       grants); a CLOSED reporting period freezes every write server-side —
       the UI mirrors that with locks/banners. */
    // self.cmtCaps is defined up top (NAV hidden() reads it)
    self.loadCmtCaps = function () {
      return api('GET', '/butilcmt/meta/caps').then(self.cmtCaps).catch(function () {});
    };
    self.loadCmtCaps();
    // Terms and Key definitions caps -- shows the Settings tab for managers
    api('GET', '/terms/meta/caps').then(self.termsCaps).catch(function () {});

    var CMT_LVL_KEY = { BUTIL_LINE: 'cmtLvlLine', SECTOR: 'cmtLvlSector', COST_CENTER: 'cmtLvlCc',
                        PROJECT: 'cmtLvlProject', TASK: 'cmtLvlTask', PO: 'cmtLvlPo',
                        PR: 'cmtLvlPr', AP_INVOICE: 'cmtLvlInv' };
    self.cmtLevelName = function (lvl) { return self.t(CMT_LVL_KEY[lvl] || lvl); };

    /* ---- thread drawer ---- */
    self.cmtDrawer = ko.observable(false);
    self.cmtLoading = ko.observable(false);
    self.cmtBusy = ko.observable(false);
    self.cmtCtx = ko.observable(null);        // {level, year, period, project, task, etype, ekey, name, title, sub}
    self.cmtSections = ko.observableArray([]);
    self.cmtClosed = ko.observableArray([]);  // CLOSED periods (MM-YYYY) of the thread's year
    self.cmtPeriod = ko.observable('');       // accounting period of a NEW root comment
    self.cmtText = ko.observable('');
    self.cmtReplyFor = ko.observable(null);
    self.cmtReplyText = ko.observable('');
    self.cmtEditId = ko.observable(null);
    self.cmtEditText = ko.observable('');
    self.cmtDocsFor = ko.observable(null);    // comment id whose attachments panel is open
    self.cmtDocsPer = ko.observable('');      // that comment's accounting period
    self.cmtDocsMine = ko.observable(false);  // caller may upload/remove there
    self.cmtDocs = ko.observableArray([]);
    self.drillCmtLevel = ko.observable(null); // AP_INVOICE / PR / PO while a doc drill is decorated

    /* drawer search region (2026-08-23 feedback): collapsed by default;
       Posted by + Accounting Period filter the LOADED thread client-side.
       The period filter DEFAULTS to the dashboard's accounting-period
       selection, so the drawer visibly follows the page parameter while the
       thread itself is loaded year-wide (clear the filter to see everything). */
    self.cmtFltOpen = ko.observable(false);
    self.cmtFltBy = ko.observable('');
    self.cmtFltPer = ko.observable('');
    self.toggleCmtFlt = function () { self.cmtFltOpen(!self.cmtFltOpen()); };
    self.cmtAuthors = ko.computed(function () {
      var seen = {}, out = [];
      self.cmtSections().forEach(function (s) {
        (s.items || []).forEach(function (r) {
          if (!seen[r.createdBy]) { seen[r.createdBy] = 1; out.push({ v: r.createdBy, l: r.author }); }
          (r.replies || []).forEach(function (p) {
            if (!seen[p.createdBy]) { seen[p.createdBy] = 1; out.push({ v: p.createdBy, l: p.author }); }
          });
        });
      });
      return out.sort(function (a, b) { return a.l < b.l ? -1 : 1; });
    });
    self.cmtSectionsView = ko.computed(function () {
      var by = self.cmtFltBy(), per = self.cmtFltPer();
      return self.cmtSections().map(function (s) {
        return { level: s.level, items: (s.items || []).filter(function (r) {
          if (per && r.period !== per) return false;
          if (by && r.createdBy !== by
              && !(r.replies || []).some(function (p) { return p.createdBy === by; })) return false;
          return true;
        }) };
      });
    });
    self.cmtAnyLoaded = ko.computed(function () {
      return self.cmtSections().some(function (s) { return (s.items || []).length > 0; });
    });

    /* author photos: fetched once per user via the /dct/ media route, cached
       as object URLs; hasPhoto gates the fetch so missing photos never 404 */
    var cmtPhotoCache = {};
    self.cmtPhotoRev = ko.observable(0);
    self.cmtPhoto = function (id) {
      self.cmtPhotoRev();
      return (id != null && cmtPhotoCache[id]) ? cmtPhotoCache[id] : null;
    };
    function cmtFetchPhotos(sections) {
      var want = {};
      function claim(r) {
        if (r.hasPhoto === 'Y' && r.authorId != null && !(r.authorId in cmtPhotoCache)) want[r.authorId] = 1;
      }
      sections.forEach(function (s) {
        (s.items || []).forEach(function (r) { claim(r); (r.replies || []).forEach(claim); });
      });
      Object.keys(want).forEach(function (id) {
        cmtPhotoCache[id] = null;   // claimed — never re-fetched
        fetch('/ords/admin/dct/users/' + id + '/photo',
              { headers: { 'Authorization': 'Bearer ' + TOKEN } })
          .then(function (r) { if (!r.ok) { throw new Error(); } return r.blob(); })
          .then(function (b) {
            cmtPhotoCache[id] = URL.createObjectURL(b);
            self.cmtPhotoRev(self.cmtPhotoRev() + 1);
          }).catch(function () {});
      });
    }

    self.cmtPeriodClosed = function (p) { return self.cmtClosed.indexOf(p) >= 0; };
    self.cmtAddClosed = ko.computed(function () {
      return !!self.cmtPeriod() && self.cmtClosed.indexOf(self.cmtPeriod()) >= 0;
    });
    self.cmtDocsCanEdit = ko.computed(function () {
      return self.cmtDocsMine() && !self.cmtPeriodClosed(self.cmtDocsPer());
    });
    self.cmtPeriodOpts = ko.computed(function () {
      var c = self.cmtCtx(); if (!c) return [];
      var out = []; for (var m = 1; m <= 12; m++) out.push((m < 10 ? '0' : '') + m + '-' + c.year);
      return out;
    });
    self.cmtScopeLine = ko.computed(function () {
      var c = self.cmtCtx(); if (!c) return '';
      return self.t('fYearL') + ' ' + c.year + ' · '
        + (self.cmtFltPer() ? self.t('cmtPeriodL') + ' ' + self.cmtFltPer() : self.t('cmtAllPeriods'));
    });
    self.cmtSecTitle = function (s) {
      if (s.level === 'BUTIL_LINE') return self.t('cmtSecLine');
      if (s.level === 'TASK') return self.t('cmtSecTask');
      if (s.level === 'PROJECT') return self.t('cmtSecProject');
      return self.cmtLevelName(s.level);
    };
    self.cmtInitials = function (n) {
      var p = ('' + (n || '')).split(' ').filter(Boolean);
      return ((p[0] || '?')[0] + ((p[1] || '')[0] || '')).toUpperCase();
    };
    self.cmtSize = function (b) {
      b = Number(b) || 0;
      if (b >= 1048576) return (b / 1048576).toFixed(1) + ' MB';
      if (b >= 1024) return Math.round(b / 1024) + ' KB';
      return b + ' B';
    };

    self.openCmt = function (ctx) {
      self.cmtCtx(ctx);
      self.cmtText(''); self.cmtReplyFor(null); self.cmtReplyText('');
      self.cmtEditId(null); self.cmtDocsFor(null); self.cmtDocs([]);
      // the search region mirrors the page's accounting-period parameter
      self.cmtFltOpen(false); self.cmtFltBy('');
      self.cmtFltPer(/^(0[1-9]|1[0-2])-[0-9]{4}$/.test(ctx.period || '') ? ctx.period : '');
      self.cmtPeriod(/^(0[1-9]|1[0-2])-[0-9]{4}$/.test(ctx.period || '') ? ctx.period : caDefPeriod(ctx.year));
      self.cmtDrawer(true);
      self.loadCmtThread();
    };
    self.closeCmtDrawer = function () {
      self.cmtDrawer(false);
      // refresh the Department / Sector tab's comment count + text
      if (self.view() === 'butil' && self.buLevel() !== 'line') { self.buAggInvalidate(); self.runBuAgg(self.buLevel()); }
    };
    self.loadCmtThread = function () {
      var c = self.cmtCtx(); if (!c) return;
      self.cmtLoading(true);
      // year-wide load — the drawer's search region scopes the view client-side
      return api('GET', '/butilcmt' + qs({ level: c.level, year: c.year,
        project: c.project || null, task: c.task || null, etype: c.etype || null, ekey: c.ekey || null }))
        .then(function (d) {
          self.cmtClosed(d.closedPeriods || []);
          var secs = (d.sections || []).filter(function (s) {
            return s.items.length || s.level === c.level;   // empty related sections stay hidden
          });
          self.cmtSections(secs);
          cmtFetchPhotos(secs);
          self.cmtLoading(false);
        }).catch(function (e) { self.cmtLoading(false); toast(e.message, true); });
    };

    /* entry points */
    self.openCmtLine = function (row) {
      self.openCmt({ level: 'BUTIL_LINE', year: self.buYear(), period: self.buPeriod() || '',
        project: row.projectNumber, task: row.taskNumber, etype: row.expenditureType,
        title: row.projectNumber + ' · ' + row.taskNumber + ' · ' + row.expenditureType,
        sub: row.projectName || '' });
    };
    self.openCmtDoc = function (row) {
      var lvl = self.drillCmtLevel(); if (!lvl) return;
      var key = lvl === 'AP_INVOICE' ? row.invoice : (lvl === 'PO' ? row.po : row.pr);
      if (!key) return;
      self.openCmt({ level: lvl, year: self.buYear(), period: self.buPeriod() || '',
        ekey: '' + key, name: row.supplier || '',
        title: self.cmtLevelName(lvl) + ' ' + key, sub: row.supplier || '' });
    };

    /* writes — the server re-checks capability + period status on every one */
    function cmtAfterWrite(c) {
      if (c && c.level === 'BUTIL_LINE' && self.view() === 'butil') self.runButil(self.buOffset());
      if (self.cmtRegLoaded()) self.runCmtReg();
    }
    self.postCmtRoot = function () {
      var c = self.cmtCtx(); if (!c) return;
      var txt = (self.cmtText() || '').trim();
      if (!txt) { toast(self.t('cmtTextReq'), true); return; }
      if (!self.cmtPeriod()) { toast(self.t('cmtPeriodReq'), true); return; }
      self.cmtBusy(true);
      api('POST', '/butilcmt', { level: c.level, budgetYear: Number(c.year), period: self.cmtPeriod(),
        projectNumber: c.project || null, taskNumber: c.task || null, expenditureType: c.etype || null,
        entityKey: c.ekey || null, entityName: c.name || null, text: txt })
        .then(function () { self.cmtBusy(false); self.cmtText(''); toast(self.t('saved'));
          self.loadCmtThread(); cmtAfterWrite(c); })
        .catch(function (e) { self.cmtBusy(false); toast(e.message, true); });
    };
    self.startCmtReply = function (root) { self.cmtReplyFor(root.id); self.cmtReplyText(''); };
    self.cancelCmtReply = function () { self.cmtReplyFor(null); };
    self.postCmtReply = function () {
      var txt = (self.cmtReplyText() || '').trim();
      if (!txt) { toast(self.t('cmtTextReq'), true); return; }
      if (!self.cmtReplyFor()) return;
      self.cmtBusy(true);
      api('POST', '/butilcmt', { parentId: self.cmtReplyFor(), text: txt })
        .then(function () { self.cmtBusy(false); self.cmtReplyFor(null); toast(self.t('saved'));
          self.loadCmtThread(); cmtAfterWrite(self.cmtCtx()); })
        .catch(function (e) { self.cmtBusy(false); toast(e.message, true); });
    };
    self.startCmtEdit = function (cm) { self.cmtEditId(cm.id); self.cmtEditText(cm.text); };
    self.cancelCmtEdit = function () { self.cmtEditId(null); };
    self.saveCmtEdit = function () {
      var txt = (self.cmtEditText() || '').trim();
      if (!txt) { toast(self.t('cmtTextReq'), true); return; }
      self.cmtBusy(true);
      api('PUT', '/butilcmt/' + self.cmtEditId(), { text: txt })
        .then(function () { self.cmtBusy(false); self.cmtEditId(null); toast(self.t('saved'));
          self.loadCmtThread(); cmtAfterWrite(self.cmtCtx()); })
        .catch(function (e) { self.cmtBusy(false); toast(e.message, true); });
    };
    self.deleteCmt = function (cm) {
      if (!window.confirm(self.t('cmtDeleteConfirm'))) return;
      self.cmtBusy(true);
      api('DELETE', '/butilcmt/' + cm.id)
        .then(function () { self.cmtBusy(false); toast(self.t('deleted'));
          self.loadCmtThread(); cmtAfterWrite(self.cmtCtx()); })
        .catch(function (e) { self.cmtBusy(false); toast(e.message, true); });
    };

    /* attachments (shared dct_documents, raw-binary PUT) */
    function loadCmtDocs(id) {
      api('GET', '/butilcmt/' + id + '/docs')
        .then(function (d) { self.cmtDocs(d.items || []); }).catch(function () {});
    }
    self.toggleCmtDocs = function (cm, period) {
      if (self.cmtDocsFor() === cm.id) { self.cmtDocsFor(null); return; }
      self.cmtDocsFor(cm.id);
      self.cmtDocsPer(period || cm.period || '');
      self.cmtDocsMine(cm.mine === 'Y' || self.isSysAdmin);
      self.cmtDocs([]);
      loadCmtDocs(cm.id);
    };
    self.cmtUpload = function () {
      var id = self.cmtDocsFor(); if (!id) return;
      var inp = document.createElement('input'); inp.type = 'file';
      inp.onchange = function () {
        var f = inp.files && inp.files[0]; if (!f) return;
        self.cmtBusy(true);
        fetch(API + '/butilcmt/' + id + '/docs?file_name=' + encodeURIComponent(f.name)
              + '&mime_type=' + encodeURIComponent(f.type || 'application/octet-stream'),
          { method: 'PUT', body: f,
            headers: { 'Authorization': 'Bearer ' + TOKEN,
                       'Content-Type': f.type || 'application/octet-stream' } })
          .then(function (r) {
            return r.json().catch(function () { return {}; }).then(function (d) {
              if (!r.ok) throw new Error(d.error || ('HTTP ' + r.status));
              return d;
            });
          })
          .then(function () { self.cmtBusy(false); toast(self.t('saved'));
            loadCmtDocs(id); self.loadCmtThread(); })
          .catch(function (e) { self.cmtBusy(false); toast(e.message, true); });
      };
      inp.click();
    };
    self.cmtDocDownload = function (doc) {
      fetch(API + '/butilcmt/docs/' + doc.docId, { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) { if (!r.ok) throw new Error('HTTP ' + r.status); return r.blob(); })
        .then(function (b) {
          var u = URL.createObjectURL(b);
          var a = document.createElement('a'); a.href = u; a.download = doc.fileName || 'attachment';
          a.click(); URL.revokeObjectURL(u);
        }).catch(function (e) { toast(e.message, true); });
    };
    self.cmtDocDelete = function (doc) {
      if (!window.confirm(self.t('cmtDocDeleteConfirm'))) return;
      var id = self.cmtDocsFor();
      api('DELETE', '/butilcmt/docs/' + doc.docId)
        .then(function () { toast(self.t('deleted')); if (id) loadCmtDocs(id); self.loadCmtThread(); })
        .catch(function (e) { toast(e.message, true); });
    };

    /* ---- Comments register page (all levels + SECTOR / COST_CENTER entry) ---- */
    self.cmtRegLoaded = ko.observable(false);
    self.cmtRegLoading = ko.observable(false);
    self.cmtRegData = ko.observable(null);
    self.cmtRegCount = ko.observable(0);
    self.cmtRegYear = ko.observable('');
    self.cmtRegPeriod = ko.observable('');
    self.cmtRegLevel = ko.observable('');
    self.cmtRegSearch = ko.observable('');
    self.cmtNewLevel = ko.observable('SECTOR');
    self.cmtNewKey = ko.observable('');
    var cmtRegMap = {};                       // ref -> full API row (IR keeps only declared cols)
    self.cmtRegPeriodOpts = ko.computed(function () {
      var y = self.cmtRegYear(); if (!y) return [];
      var out = []; for (var m = 1; m <= 12; m++) out.push((m < 10 ? '0' : '') + m + '-' + y);
      return out;
    });
    self.cmtLevelOpts = ko.computed(function () {
      self.lang();
      return ['BUTIL_LINE', 'SECTOR', 'COST_CENTER', 'PROJECT', 'TASK', 'PO', 'PR', 'AP_INVOICE']
        .map(function (l) { return { v: l, l: self.cmtLevelName(l) }; });
    });
    self.cmtNewLevelOpts = ko.computed(function () {
      self.lang();
      return ['SECTOR', 'COST_CENTER'].map(function (l) { return { v: l, l: self.cmtLevelName(l) }; });
    });
    function cmtRegColumns() {
      return [
        { key: 'levelName',  label: self.t('cmtPickLevel'),  type: 'text' },
        { key: 'period',     label: self.t('fPeriod'),       type: 'text' },
        { key: 'entity',     label: self.t('cmtEntityCol'),  type: 'text' },
        { key: 'text',       label: self.t('cmtTextCol'),    type: 'text' },
        { key: 'replyCount', label: self.t('cmtRepliesCol'), type: 'num' },
        { key: 'docCount',   label: self.t('cmtDocsCol'),    type: 'num' },
        { key: 'author',     label: self.t('cmtAuthorCol'),  type: 'text' },
        { key: 'createdAt',  label: self.t('caCreatedAt'),   type: 'text' },
        { key: 'updatedAt',  label: self.t('cmtUpdatedCol'), type: 'text' },
        { key: 'ref',        label: self.t('caRef'),         type: 'text' },
        { key: 'budgetYear', label: self.t('fYearL'),        type: 'text' }
      ];
    }
    self.runCmtReg = function () {
      self.cmtRegLoading(true);
      var lvl = self.cmtRegLevel() || null;
      var p = { year: self.cmtRegYear() || null, period: self.cmtRegPeriod() || null,
                search: self.cmtRegSearch() || null };
      return api('GET', '/butilcmt' + qs(p)).then(function (d) {
        cmtRegMap = {};
        // the level filter is client-side (the register call is capped at 2000)
        var items = (d.items || []).filter(function (r) { return !lvl || r.level === lvl; });
        items.forEach(function (r) {
          r.levelName = self.cmtLevelName(r.level);
          r.entity = r.level === 'BUTIL_LINE'
              ? (r.projectNumber + ' · ' + r.taskNumber + ' · ' + r.expenditureType)
            : r.level === 'TASK' ? (r.projectNumber + ' · ' + r.taskNumber)
            : r.level === 'PROJECT' ? r.projectNumber
            : (r.entityKey + (r.entityName && r.entityName !== r.entityKey ? ' — ' + r.entityName : ''));
          cmtRegMap[r.ref] = r;
        });
        self.cmtRegCount(items.length);
        self.cmtRegData({ columns: cmtRegColumns(), items: items, total: items.length,
                          truncated: (d.total || 0) >= 2000, maxRows: 2000,
                          section: 'bucmt', stateRev: 1 });
        self.cmtRegLoaded(true); self.cmtRegLoading(false);
      }).catch(function (e) { self.cmtRegLoading(false); fail(e); });
    };
    self.cmtRegGridClick = function (d, e) {
      var td = (e.target && e.target.closest) ? e.target.closest('td') : null;
      if (!td) return true;
      var ctx;
      try { ctx = ko.contextFor(td); } catch (err) { return true; }
      if (!ctx || !ctx.$parent || !ctx.$parent.row) return true;
      var row = cmtRegMap[ctx.$parent.row.ref];
      if (row) { self.openCmtReg(row); return false; }
      return true;
    };
    self.openCmtReg = function (r) {
      self.openCmt({ level: r.level, year: r.budgetYear, period: r.period || '',
        project: r.projectNumber || null, task: r.taskNumber || null, etype: r.expenditureType || null,
        ekey: r.entityKey || null, name: r.entityName || '',
        title: r.entity || '', sub: '' });
    };
    self.openCmtNew = function () {
      var lvl = self.cmtNewLevel(), key = (self.cmtNewKey() || '').trim();
      if (!key) { toast(self.t('cmtPickValue'), true); return; }
      var name = '';
      if (lvl === 'COST_CENTER') {
        var m = self.buCcs().filter(function (c) { return c.cc === key; })[0];
        if (m) name = m.dept || '';
      }
      var yr = Number(self.cmtRegYear() || self.buYear() || new Date().getFullYear());
      self.openCmt({ level: lvl, year: yr, period: self.cmtRegPeriod() || '',
        ekey: key, name: name,
        title: self.cmtLevelName(lvl) + ' — ' + key + (name ? ' · ' + name : ''), sub: '' });
    };

    /* ---- Comment Roles admin page (common dct_role_permissions grants) ---- */
    self.cmtRoles = ko.observableArray([]);
    self.cmtRolesLoading = ko.observable(false);
    self.loadCmtRoles = function () {
      self.cmtRolesLoading(true);
      api('GET', '/butilcmt/admin/roles').then(function (d) {
        self.cmtRoles(d.items || []); self.cmtRolesLoading(false);
      }).catch(function (e) { self.cmtRolesLoading(false); toast(e.message, true); });
    };
    self.cmtRoleToggle = function (row, cap) {
      var cur = cap === 'ADD' ? row.canAdd : cap === 'REPLY' ? row.canReply : row.canClose;
      api('POST', '/butilcmt/admin/roles',
          { roleId: row.roleId, capability: cap === 'CLOSE' ? 'CLOSE_PERIOD' : cap,
            granted: cur === 'Y' ? 'N' : 'Y' })
        .then(function () { self.loadCmtRoles(); self.loadCmtCaps(); })
        .catch(function (e) { toast(e.message, true); self.loadCmtRoles(); });
      return true;   // let the checkbox toggle optimistically; the reload corrects it
    };

    /* ---- Reporting Periods admin page (close / reopen) ---- */
    self.cmtPerYear = ko.observable(new Date().getFullYear());
    self.cmtPerRows = ko.observableArray([]);
    self.cmtPerLoading = ko.observable(false);
    self.cmtPerYearOpts = ko.computed(function () {
      var ys = self.buYears();
      if (ys && ys.length) return ys;
      var y = new Date().getFullYear(); return [y + 1, y, y - 1];
    });
    self.loadCmtPeriods = function () {
      if (!self.cmtPerYear()) return;
      self.cmtPerLoading(true);
      api('GET', '/butilcmt/admin/periods' + qs({ year: self.cmtPerYear() })).then(function (d) {
        // APEX_JSON omits NULL/empty keys — normalise the rows or the bare-name
        // bindings in the foreach abort silently after the first row
        self.cmtPerRows((d.items || []).map(function (p) {
          ['remarks', 'closedBy', 'closedAt', 'reopenedBy', 'reopenedAt'].forEach(function (k) {
            if (p[k] == null) p[k] = '';
          });
          p.rem = ko.observable('');
          return p;
        }));
        self.cmtPerLoading(false);
      }).catch(function (e) { self.cmtPerLoading(false); toast(e.message, true); });
    };
    self.cmtPerYear.subscribe(function () {
      if (self.view() === 'cmtperiods') self.loadCmtPeriods();
    });
    self.cmtPerAction = function (p, act) {
      var msg = self.t(act === 'CLOSE' ? 'perCloseConfirm' : 'perReopenConfirm').replace('{p}', p.period);
      if (!window.confirm(msg)) return;
      api('POST', '/butilcmt/admin/periods',
          { year: Number(self.cmtPerYear()), period: p.period, action: act, remarks: p.rem() || null })
        .then(function () { toast(self.t('saved')); self.loadCmtPeriods(); })
        .catch(function (e) { toast(e.message, true); });
    };

    self.xmOpen = ko.observable(true);
    self.ebOpen = ko.observable(true);
    self.xmData = ko.observable(null);
    self.xmLoading = ko.observable(false);
    self.xmLoaded = ko.observable(false);
    self.xmCount = ko.observable(0);
    self.xmSeg = ko.observable('');
    self.xmActive = ko.observable('Y');
    self.xmSearch = ko.observable('');
    self.xmSegments = ko.observableArray([]);
    self.xmActiveOpts = ko.computed(function () {
      return [{ v: 'Y', l: self.t('active') }, { v: 'N', l: self.t('xmInactive') },
              { v: 'ALL', l: self.t('xmAll') }];
    });
    var xmRowMap = {};                        // segment|ebsValue -> full API row
    function xmColumns() {
      return [
        { key: 'segment',     label: self.t('segment'),       type: 'text' },
        { key: 'ebsValue',    label: self.t('xmEbsValue'),    type: 'text' },
        { key: 'fusionValue', label: self.t('xmFusionValue'), type: 'text' },
        { key: 'fusionDesc',  label: self.t('xmFusionDesc'),  type: 'text' },
        { key: 'parentChild', label: self.t('xmParentChild'), type: 'text' },
        { key: 'inChart',     label: self.t('xmInChart'),     type: 'text' },
        { key: 'active',      label: self.t('active'),        type: 'text' },
        { key: 'updatedBy',   label: self.t('xmUpdBy'),       type: 'text' },
        { key: 'updatedAt',   label: self.t('xmUpdAt'),       type: 'text' }
      ];
    }
    self.runEbsMap = function () {
      self.xmLoading(true);
      var p = { segment: self.xmSeg() || null, active: self.xmActive() || null,
                search: self.xmSearch() || null };
      return api('GET', '/coamap' + qs(p)).then(function (d) {
        self.xmSegments(d.segments || []);
        xmRowMap = {};
        (d.items || []).forEach(function (r) { xmRowMap[r.segment + '|' + r.ebsValue] = r; });
        self.xmCount(d.total || 0);
        self.xmData({ columns: xmColumns(), items: d.items || [], total: d.total || 0,
                      truncated: (d.total || 0) >= 5000, maxRows: 5000, section: 'ebsmap' });
        self.xmLoaded(true); self.xmLoading(false);
      }).catch(function (e) { self.xmLoading(false); fail(e); });
    };
    /* row click -> edit drawer (admins only); resolve the IR cell like the
       pending page does — the shared grid keeps only declared columns */
    self.xmGridClick = function (d, e) {
      if (!self.canManageEbs) return true;
      var td = (e.target && e.target.closest) ? e.target.closest('td') : null;
      if (!td) return true;
      var ctx;
      try { ctx = ko.contextFor(td); } catch (err) { return true; }
      if (!ctx || !ctx.$parent || !ctx.$parent.row) return true;
      var row = xmRowMap[ctx.$parent.row.segment + '|' + ctx.$parent.row.ebsValue];
      if (row) { self.openXmEdit(row); return false; }
      return true;
    };
    /* drawer state */
    self.xmDrawer = ko.observable(false);
    self.xmSaving = ko.observable(false);
    self.xmId = ko.observable(null);
    self.xmFSeg = ko.observable('ACCOUNT');
    self.xmFEbs = ko.observable('');
    self.xmFFusion = ko.observable('');
    self.xmFDesc = ko.observable('');
    self.xmFPc = ko.observable('CHILD');
    self.xmFActive = ko.observable('Y');
    self.openXmNew = function () {
      self.xmId(null); self.xmFSeg(self.xmSeg() || 'ACCOUNT'); self.xmFEbs('');
      self.xmFFusion(''); self.xmFDesc(''); self.xmFPc('CHILD'); self.xmFActive('Y');
      self.xmDrawer(true);
    };
    self.openXmEdit = function (row) {
      self.xmId(row.id); self.xmFSeg(row.segment); self.xmFEbs(row.ebsValue);
      self.xmFFusion(row.fusionValue); self.xmFDesc(row.description || '');
      self.xmFPc(row.parentChild || 'CHILD'); self.xmFActive(row.active || 'Y');
      self.xmDrawer(true);
    };
    self.closeXmDrawer = function () { self.xmDrawer(false); };
    self.saveXm = function () {
      if (!self.xmFSeg() || !self.xmFEbs().trim() || !self.xmFFusion().trim()) {
        toast(self.t('xmReqFields'), true); return;
      }
      self.xmSaving(true);
      var done = function () { self.xmSaving(false); self.xmDrawer(false);
                               toast(self.t('saved')); self.runEbsMap(); };
      var oops = function (e) { self.xmSaving(false); toast(e.message, true); };
      if (self.xmId()) {
        api('PUT', '/coamap/' + self.xmId(), {
          fusionValue: self.xmFFusion().trim(), description: self.xmFDesc() || '',
          parentChild: self.xmFPc(), active: self.xmFActive()
        }).then(done).catch(oops);
      } else {
        api('POST', '/coamap', {
          segment: self.xmFSeg(), ebsValue: self.xmFEbs().trim(),
          fusionValue: self.xmFFusion().trim(), description: self.xmFDesc() || '',
          parentChild: self.xmFPc()
        }).then(done).catch(oops);
      }
    };

    /* ── legacy balances: coverage summary + Excel upload + register ── */
    self.ebLoaded = ko.observable(false);
    self.ebYears = ko.observableArray([]);
    self.ebUnmappedAcc = ko.observableArray([]);
    self.ebUnmappedF2 = ko.observableArray([]);
    self.ebUploadBusy = ko.observable(false);
    self.ebUploadNote = ko.observable('');
    self.ebRegYear = ko.observable('');
    self.ebRegBusy = ko.observable(false);
    self.ebYearOpts = ko.computed(function () {
      return self.ebYears().map(function (y) { return y.year; }).filter(Boolean);
    });
    self.loadEbsSummary = function () {
      return api('GET', '/ebs-balances/summary').then(function (d) {
        self.ebYears(d.years || []);
        self.ebUnmappedAcc(d.unmappedAccounts || []);
        self.ebUnmappedF2(d.unmappedFuture2 || []);
        if (!self.ebRegYear() && (d.years || []).length) self.ebRegYear(d.years[0].year);
        self.ebLoaded(true);
      }).catch(fail);
    };
    self.ebPct = function (part, total) {
      return total ? Math.round(100 * (part || 0) / total) + '%' : '—';
    };
    /* Excel upload: SheetJS client parse (requirejs 'xlsx' path is configured
       in index.html) -> chunks of 500 -> POST /gl/ebs-balances */
    /* 2026-07-30 (2): matches the full EBS "GL Period Balances" export layout
       (CC_ID + per-segment descriptions + Account Type + Budget/Encumbrance/
       Actual measures). Matching is synonym-priority with column CLAIMING:
       segment keys resolve first, so with a "Budget Group Code" column
       present, a bare "Budget" column is the AMOUNT; a lone bare "Budget"
       (legacy template) still means the budget-code segment. */
    var EB_HEADS = {
      ccId:          ['CCID'],
      entity:        ['ENTITYCODE', 'ENTITY'],
      costCenter:    ['COSTCENTERCODE', 'COSTCENTER', 'CC'],
      budgetCode:    ['BUDGETGROUPCODE', 'BUDGETCODE', 'BUDGET'],
      account:       ['ACCOUNTNUMBER', 'ACCOUNTCODE', 'GLACCOUNT', 'ACCOUNT'],
      activity:      ['ACTIVITYCODE', 'ACTIVITY'],
      future1:       ['FUTURE1'],
      future2:       ['FUTURE2'],
      entityDesc:    ['ENTITYDESCRIPTION', 'ENTITYDESC'],
      costCenterDesc:['COSTCENTERDESCRIPTION', 'COSTCENTERDESC'],
      budgetDesc:    ['BUDGETGROUPDESCRIPTION', 'BUDGETDESCRIPTION', 'BUDGETDESC'],
      accountDesc:   ['ACCOUNTDESCRIPTION', 'ACCOUNTDESC'],
      activityDesc:  ['ACTIVITYDESCRIPTION', 'ACTIVITYDESC'],
      future1Desc:   ['FUTURE1DESCRIPTION', 'FUTURE1DESC'],
      future2Desc:   ['FUTURE2DESCRIPTION', 'FUTURE2DESC'],
      accountType:   ['ACCOUNTTYPE'],
      period:        ['PERIODNAME', 'ACCOUNTINGPERIOD', 'PERIOD'],
      ptd:           ['PTD', 'PTDAMOUNT', 'ACTUALAMOUNT', 'ACTUALPTD', 'ACTUAL', 'AMOUNT'],
      budget:        ['BUDGETAMOUNT', 'BUDGETAMT', 'BUDGETPTD', 'BUDGET'],
      encumbrance:   ['ENCUMBRANCEAMOUNT', 'ENCUMBRANCE', 'ENCAMOUNT']
    };
    function ebMapHeaders(headerRow) {
      var norm = headerRow.map(function (h) {
        return String(h == null ? '' : h).toUpperCase().replace(/[^A-Z0-9]/g, '');
      });
      var idx = {}, claimed = {};
      Object.keys(EB_HEADS).forEach(function (k) {
        var syns = EB_HEADS[k];
        for (var s = 0; s < syns.length; s++) {
          for (var i = 0; i < norm.length; i++) {
            if (norm[i] === syns[s] && !claimed[i]) {
              idx[k] = i; claimed[i] = true; return;
            }
          }
        }
      });
      var req = ['entity', 'costCenter', 'account', 'period'];
      for (var j = 0; j < req.length; j++) { if (idx[req[j]] == null) return null; }
      return idx;
    }
    self.uploadEbs = function () { document.getElementById('ebFile').click(); };
    self.ebFileChosen = function (d, e) {
      var f = e.target.files && e.target.files[0];
      e.target.value = '';
      if (!f) return true;
      self.ebUploadBusy(true); self.ebUploadNote('');
      window.require(['xlsx'], function (X) {
        var rd = new FileReader();
        rd.onload = function () {
          try {
            var wb = X.read(new Uint8Array(rd.result), { type: 'array' });
            var ws = wb.Sheets[wb.SheetNames[0]];
            var aoa = X.utils.sheet_to_json(ws, { header: 1, raw: true, defval: null });
            var idx = aoa.length ? ebMapHeaders(aoa[0]) : null;
            if (!idx) { self.ebUploadBusy(false); toast(self.t('ebUpBad'), true); return; }
            var rows = [];
            var optStr = function (r, k) {
              if (idx[k] == null || r[idx[k]] == null) return undefined;
              var v = String(r[idx[k]]).trim();
              return v || undefined;
            };
            for (var i = 1; i < aoa.length; i++) {
              var r = aoa[i];
              if (!r || r[idx.account] == null || r[idx.period] == null) continue;
              var row = {
                entity:     String(r[idx.entity] == null ? '' : r[idx.entity]).trim(),
                costCenter: String(r[idx.costCenter] == null ? '' : r[idx.costCenter]).trim(),
                budgetCode: idx.budgetCode != null && r[idx.budgetCode] != null ? String(r[idx.budgetCode]).trim() : '0',
                account:    String(r[idx.account]).trim(),
                activity:   idx.activity != null && r[idx.activity] != null ? String(r[idx.activity]).trim() : '0',
                future1:    idx.future1 != null && r[idx.future1] != null ? String(r[idx.future1]).trim() : '0',
                future2:    idx.future2 != null && r[idx.future2] != null ? String(r[idx.future2]).trim() : '0',
                period:     String(r[idx.period]).trim(),
                ptd:        idx.ptd != null ? (Number(r[idx.ptd]) || 0) : 0,
                budget:     idx.budget != null ? (Number(r[idx.budget]) || 0) : 0,
                encumbrance: idx.encumbrance != null ? (Number(r[idx.encumbrance]) || 0) : 0
              };
              if (idx.ccId != null && r[idx.ccId] != null && String(r[idx.ccId]).trim() !== '') {
                row.ccId = Number(r[idx.ccId]);
              }
              ['entityDesc', 'costCenterDesc', 'budgetDesc', 'accountDesc',
               'activityDesc', 'future1Desc', 'future2Desc', 'accountType'].forEach(function (k) {
                var v = optStr(r, k);
                if (v !== undefined) row[k] = v;
              });
              rows.push(row);
            }
            if (!rows.length) { self.ebUploadBusy(false); toast(self.t('ebUpBad'), true); return; }
            var chunks = [];
            for (var c = 0; c < rows.length; c += 500) chunks.push(rows.slice(c, c + 500));
            var ok = 0, err = 0, firstErr = '';
            (function send(i) {
              if (i >= chunks.length) {
                self.ebUploadBusy(false);
                var msg = self.t('ebUpDone').replace('{ok}', ok).replace('{err}', err);
                self.ebUploadNote(msg + (firstErr ? ' — ' + firstErr : ''));
                toast(msg, err > 0);
                self.loadEbsSummary();
                return;
              }
              self.ebUploadNote(self.t('ebUpBusy').replace('{i}', i + 1).replace('{n}', chunks.length));
              api('POST', '/ebs-balances', { sourceFile: f.name, rows: chunks[i] })
                .then(function (res) {
                  ok += res.ok || 0; err += res.errors || 0;
                  if (!firstErr && res.results) {
                    var bad = res.results.filter(function (x) { return x.status === 'ERROR'; })[0];
                    if (bad) firstErr = 'row ' + bad.row + ': ' + (bad.error || '');
                  }
                  send(i + 1);
                })
                .catch(function (e2) { self.ebUploadBusy(false); toast(e2.message, true); });
            })(0);
          } catch (ex) { self.ebUploadBusy(false); toast(self.t('ebUpBad'), true); }
        };
        rd.readAsArrayBuffer(f);
      });
      return true;
    };
    self.ebTemplate = function () {
      /* exact "GL Period Balances" EBS export layout (docs/Reports/GL/Data) */
      window.require(['xlsx'], function (X) {
        var wb = X.utils.book_new();
        var ws = X.utils.aoa_to_sheet([
          ['CC_ID', 'Entity Code', 'Entity Description', 'Cost Center', 'Cost Center Description',
           'Budget Group Code', 'Budget Group Description', 'Account Number', 'Account Description',
           'Activity Code', 'Activity Description', 'Future1', 'Future1 Description',
           'Future2', 'Future2 Description', 'Account Type', 'Period Name',
           'Budget', 'Encumbrance', 'Actual'],
          [376499, '451', 'Department of Culture and Tourism - Abu Dhabi', '4510001', 'DCT - System set up accounts',
           '1', 'Current operations', '520105', 'Salaries',
           '0', '', '451000', 'TCA General Account',
           '0', 'Un Specified', 'Expense', 'Jan-25',
           20000, 1500, 12345.67]
        ]);
        X.utils.book_append_sheet(wb, ws, 'EBS Balances');
        X.writeFile(wb, 'EBS_Balances_Template.xlsx');
      });
    };
    /* prior-year register (EBS_GL_BALANCE_REGISTER via /gl/ebs-balances/register) */
    function ebRegDownload(runId) {
      return fetch(API + '/ebs-balances/register/' + runId + '/file',
                   { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) {
          if (!r.ok) { throw new Error('Excel download failed (HTTP ' + r.status + ')'); }
          return r.blob();
        })
        .then(function (b) {
          var u = URL.createObjectURL(b);
          var a = document.createElement('a');
          a.href = u; a.download = 'EBS_GL_Balance_Register_' + self.ebRegYear() + '.xlsx';
          a.click(); URL.revokeObjectURL(u);
        });
    }
    self.runEbsRegister = function () {
      if (self.ebRegBusy() || !self.ebRegYear()) return;
      self.ebRegBusy(true);
      api('POST', '/ebs-balances/register', { year: Number(self.ebRegYear()) })
        .then(function (d) {
          var runId = d.runId;
          toast(self.t('ebRegQueued') + runId);
          var tries = 0;
          (function poll() {
            if (++tries > 60) { self.ebRegBusy(false); toast(self.t('ebRegFailed') + 'timeout', true); return; }
            setTimeout(function () {
              api('GET', '/ebs-balances/register/' + runId).then(function (s) {
                if (s.status === 'SUCCESS' && s.hasFile) {
                  ebRegDownload(runId)
                    .then(function () { self.ebRegBusy(false); toast(self.t('pnXlsxReady')); })
                    .catch(function (e) { self.ebRegBusy(false); toast(e.message, true); });
                } else if (s.status === 'FAILED') {
                  self.ebRegBusy(false); toast(self.t('ebRegFailed') + (s.error || ''), true);
                } else { poll(); }
              }).catch(function () { poll(); });
            }, 4000);
          })();
        }).catch(function (e) { self.ebRegBusy(false); fail(e); });
    };

    /* ════ CASHFLOW — budget cashflow plan uploads (GL + Projects) ════
       Two user-loaded tables (db/v2/111) feeding the DOF reports until the
       dedicated Cashflow module exists. Same SheetJS chunked-upload pattern
       as the EBS balances. Writes are SYS_ADMIN while security enforcement
       is off (server-gated GL_MANAGE_CASHFLOW). */
    self.canManageCf = self.isSysAdmin;
    self.cfLoaded = ko.observable(false);
    self.cfGlYears = ko.observableArray([]);
    self.cfPjYears = ko.observableArray([]);
    self.cfUnmappedAppr = ko.observableArray([]);
    self.cfGlBusy = ko.observable(false);
    self.cfPjBusy = ko.observable(false);
    self.cfNote = ko.observable('');
    /* Projects-cashflow TEMPLATE (2026-08-19, GL/db/23): the sheet is built from
       the budget lines of the picked year — every project / task / expenditure
       type with its full 10-segment GL combination and the amounts already
       saved — in a WIDE layout (one column per accounting period). The picker's
       years come from the same route (meta=Y); a user without the cashflow
       privilege gets a 403 there and the template falls back to the sample. */
    self.cfTplYears = ko.observableArray([]);
    self.cfTplYear = ko.observable('');
    self.cfTplBusy = ko.observable(false);
    self.loadCfTplYears = function () {
      return api('GET', '/cashflow/projects/template?meta=Y').then(function (d) {
        var list = (d.years || []).map(String);
        self.cfTplYears(list);
        if (!list.length) return;
        /* a KO <select> that was bound with an EMPTY option list blanks its
           value the moment the options land — re-assert the year after KO has
           rendered them (same rule as the AP procash LOVs) */
        var want = String(d.year || list[0]);
        self.cfTplYear(want);
        setTimeout(function () { if (self.cfTplYear() !== want) self.cfTplYear(want); }, 0);
      }).catch(function () { self.cfTplYears([]); });
    };
    self.loadCfSummary = function () {
      self.loadCfTplYears();
      return api('GET', '/cashflow/summary').then(function (d) {
        self.cfGlYears(d.glYears || []);
        self.cfPjYears(d.projectYears || []);
        self.cfUnmappedAppr(d.unmappedAppr || []);
        self.cfLoaded(true);
      }).catch(fail);
    };
    var CF_GL_HEADS = {
      entity:         ['ENTITY', 'ENTITYCODE'],
      program:        ['PROGRAM', 'PROGRAMCODE'],
      costCenter:     ['COSTCENTER', 'COSTCENTERCODE', 'CC'],
      budgetGroup:    ['BUDGETGROUP', 'BG'],
      account:        ['ACCOUNT', 'ACCOUNTCODE', 'GLACCOUNT'],
      entitySpecific: ['ENTITYSPECIFIC', 'ES'],
      appropriation:  ['APPROPRIATION', 'APPROPRIATIONCODE', 'APPR', 'F2APPROPRIATION'],
      intercompany:   ['INTERCOMPANY', 'IC'],
      future1:        ['FUTURE1'],
      future2:        ['FUTURE2'],
      period:         ['PERIOD', 'ACCOUNTINGPERIOD', 'PERIODNAME'],
      cfType:         ['CFTYPE', 'TYPE', 'CASHFLOWTYPE'],
      amount:         ['AMOUNT', 'CFAMOUNT', 'CASHFLOWAMOUNT'],
      year:           ['YEAR', 'BUDGETYEAR']
    };
    var CF_PJ_HEADS = {
      project: ['PROJECT', 'PROJECTNUMBER', 'PROJECTNO'],
      task:    ['TASK', 'TASKNUMBER', 'TASKNO'],
      etype:   ['ETYPE', 'EXPENDITURETYPE', 'EXPTYPE'],
      period:  ['PERIOD', 'ACCOUNTINGPERIOD', 'PERIODNAME'],
      cfType:  ['CFTYPE', 'TYPE', 'CASHFLOWTYPE'],
      amount:  ['AMOUNT', 'CFAMOUNT', 'CASHFLOWAMOUNT'],
      year:    ['YEAR', 'BUDGETYEAR']
    };
    function cfMapHeaders(headerRow, heads, req) {
      var norm = headerRow.map(function (h) {
        return String(h == null ? '' : h).toUpperCase().replace(/[^A-Z0-9]/g, '');
      });
      var idx = {};
      Object.keys(heads).forEach(function (k) {
        for (var i = 0; i < norm.length; i++) {
          if (heads[k].indexOf(norm[i]) >= 0) { idx[k] = i; return; }
        }
      });
      for (var j = 0; j < req.length; j++) { if (idx[req[j]] == null) return null; }
      return idx;
    }
    function cfCell(r, i) { return i != null && r[i] != null ? String(r[i]).trim() : ''; }
    /* wide-template support: a header cell that IS an accounting period
       ('01-2026', 'Jan-2026') becomes an amount column for that period */
    var CF_MONS = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
    function cfWideCols(headerRow) {
      var out = [];
      (headerRow || []).forEach(function (h, i) {
        var txt = String(h == null ? '' : h).trim().toUpperCase();
        var m = /^(0?[1-9]|1[0-2])[-\/](\d{4})$/.exec(txt);
        if (m) { out.push({ i: i, period: ('0' + m[1]).slice(-2) + '-' + m[2] }); return; }
        var m2 = /^([A-Z]{3})[A-Z]*[-\/ ](\d{4})$/.exec(txt);
        if (m2 && CF_MONS.indexOf(m2[1]) >= 0) {
          out.push({ i: i, period: ('0' + (CF_MONS.indexOf(m2[1]) + 1)).slice(-2) + '-' + m2[2] });
        }
      });
      return out;
    }
    function cfUploadRows(path, file, rows, busyObs) {
      var chunks = [];
      for (var c = 0; c < rows.length; c += 500) chunks.push(rows.slice(c, c + 500));
      var ok = 0, err = 0, firstErr = '';
      (function send(i) {
        if (i >= chunks.length) {
          busyObs(false);
          var msg = self.t('ebUpDone').replace('{ok}', ok).replace('{err}', err);
          self.cfNote(msg + (firstErr ? ' — ' + firstErr : ''));
          toast(msg, err > 0);
          self.loadCfSummary();
          return;
        }
        self.cfNote(self.t('ebUpBusy').replace('{i}', i + 1).replace('{n}', chunks.length));
        api('POST', path, { sourceFile: file.name, rows: chunks[i] })
          .then(function (res) {
            ok += res.ok || 0; err += res.errors || 0;
            if (!firstErr && res.results) {
              var bad = res.results.filter(function (x) { return x.status === 'ERROR'; })[0];
              if (bad) firstErr = 'row ' + bad.row + ': ' + (bad.error || '');
            }
            send(i + 1);
          })
          .catch(function (e2) { busyObs(false); toast(e2.message, true); });
      })(0);
    }
    self.uploadCfGl = function () { document.getElementById('cfGlFile').click(); };
    self.uploadCfPj = function () { document.getElementById('cfPjFile').click(); };
    self.cfGlChosen = function (d, e) {
      var f = e.target.files && e.target.files[0];
      e.target.value = '';
      if (!f) return true;
      self.cfGlBusy(true); self.cfNote('');
      window.require(['xlsx'], function (X) {
        var rd = new FileReader();
        rd.onload = function () {
          try {
            var wb = X.read(new Uint8Array(rd.result), { type: 'array' });
            var aoa = X.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]], { header: 1, raw: true, defval: null });
            var idx = aoa.length ? cfMapHeaders(aoa[0], CF_GL_HEADS, ['appropriation', 'period', 'cfType', 'amount']) : null;
            if (!idx) { self.cfGlBusy(false); toast(self.t('cfGlUpBad'), true); return; }
            var rows = [];
            for (var i = 1; i < aoa.length; i++) {
              var r = aoa[i];
              if (!r || r[idx.appropriation] == null || r[idx.period] == null) continue;
              rows.push({
                entity: cfCell(r, idx.entity), program: cfCell(r, idx.program),
                costCenter: cfCell(r, idx.costCenter), budgetGroup: cfCell(r, idx.budgetGroup),
                account: cfCell(r, idx.account), entitySpecific: cfCell(r, idx.entitySpecific),
                appropriation: cfCell(r, idx.appropriation), intercompany: cfCell(r, idx.intercompany),
                future1: cfCell(r, idx.future1), future2: cfCell(r, idx.future2),
                period: cfCell(r, idx.period),
                cfType: cfCell(r, idx.cfType).toUpperCase(),
                amount: Number(r[idx.amount]) || 0,
                year: idx.year != null && r[idx.year] != null ? Number(r[idx.year]) : null
              });
            }
            if (!rows.length) { self.cfGlBusy(false); toast(self.t('cfGlUpBad'), true); return; }
            cfUploadRows('/cashflow', f, rows, self.cfGlBusy);
          } catch (ex) { self.cfGlBusy(false); toast(self.t('cfGlUpBad'), true); }
        };
        rd.readAsArrayBuffer(f);
      });
      return true;
    };
    self.cfPjChosen = function (d, e) {
      var f = e.target.files && e.target.files[0];
      e.target.value = '';
      if (!f) return true;
      self.cfPjBusy(true); self.cfNote('');
      window.require(['xlsx'], function (X) {
        var rd = new FileReader();
        rd.onload = function () {
          try {
            var wb = X.read(new Uint8Array(rd.result), { type: 'array' });
            var aoa = X.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]], { header: 1, raw: true, defval: null });
            /* two accepted shapes: the classic LONG sheet (PERIOD + AMOUNT
               columns) and the WIDE template (one column per period). Blank
               month cells are skipped — an untouched template row must never
               post a zero; a typed 0 DOES post and clears a saved amount. */
            var idx = aoa.length ? cfMapHeaders(aoa[0], CF_PJ_HEADS, ['project', 'task', 'etype', 'period', 'cfType', 'amount']) : null;
            var kidx = idx || (aoa.length ? cfMapHeaders(aoa[0], CF_PJ_HEADS, ['project', 'task', 'etype']) : null);
            var wide = idx ? [] : (aoa.length ? cfWideCols(aoa[0]) : []);
            if (!idx && !(kidx && wide.length)) { self.cfPjBusy(false); toast(self.t('cfPjUpBad'), true); return; }
            var rows = [], i, r;
            if (idx) {
              for (i = 1; i < aoa.length; i++) {
                r = aoa[i];
                if (!r || r[idx.project] == null || r[idx.period] == null) continue;
                rows.push({
                  project: cfCell(r, idx.project), task: cfCell(r, idx.task),
                  etype: cfCell(r, idx.etype), period: cfCell(r, idx.period),
                  cfType: cfCell(r, idx.cfType).toUpperCase(),
                  amount: Number(r[idx.amount]) || 0,
                  year: idx.year != null && r[idx.year] != null ? Number(r[idx.year]) : null
                });
              }
            } else {
              for (i = 1; i < aoa.length; i++) {
                r = aoa[i];
                if (!r || r[kidx.project] == null) continue;
                var typ = (cfCell(r, kidx.cfType) || 'APPROVED').toUpperCase();
                for (var w = 0; w < wide.length; w++) {
                  var raw = r[wide[w].i];
                  if (raw === null || raw === undefined || String(raw).trim() === '') continue;
                  var amt = Number(String(raw).replace(/,/g, ''));
                  if (!isFinite(amt)) continue;
                  rows.push({
                    project: cfCell(r, kidx.project), task: cfCell(r, kidx.task),
                    etype: cfCell(r, kidx.etype), period: wide[w].period,
                    cfType: typ, amount: amt, year: Number(wide[w].period.slice(3))
                  });
                }
              }
            }
            if (!rows.length) { self.cfPjBusy(false); toast(self.t('cfPjUpBad'), true); return; }
            cfUploadRows('/cashflow/projects', f, rows, self.cfPjBusy);
          } catch (ex) { self.cfPjBusy(false); toast(self.t('cfPjUpBad'), true); }
        };
        rd.readAsArrayBuffer(f);
      });
      return true;
    };
    self.cfGlTemplate = function () {
      window.require(['xlsx'], function (X) {
        var wb = X.utils.book_new();
        var ws = X.utils.aoa_to_sheet([
          ['ENTITY', 'PROGRAM', 'COST_CENTER', 'BUDGET_GROUP', 'ACCOUNT', 'ENTITY_SPECIFIC', 'APPROPRIATION', 'INTERCOMPANY', 'FUTURE1', 'FUTURE2', 'PERIOD', 'CF_TYPE', 'AMOUNT'],
          ['451', '000000', '9110000', '1', '411121', '0000000', '100103', '000', '000000', '000000', '01-2026', 'APPROVED', 1000000],
          ['451', '000000', '9110000', '1', '411121', '0000000', '100103', '000', '000000', '000000', '01-2026', 'REVISED', 1200000]
        ]);
        X.utils.book_append_sheet(wb, ws, 'GL Cashflow');
        X.writeFile(wb, 'GL_Cashflow_Template.xlsx');
      });
    };
    /* reference columns — informational only, the upload ignores them */
    var CF_TPL_REF = [
      ['glCombination', 'GL_COMBINATION'], ['sector', 'SECTOR'],
      ['department', 'DEPARTMENT'], ['costCenter', 'COST_CENTER'],
      ['glAccount', 'GL_ACCOUNT'], ['appropriation', 'APPROPRIATION'],
      ['chapter', 'CHAPTER'], ['program', 'PROGRAM'],
      ['businessUnit', 'BUSINESS_UNIT'], ['projectType', 'PROJECT_TYPE']
    ];
    function cfPjBuildTemplate(d, year) {
      var lines = d.lines || [], periods = (d.periods || []).slice();
      if (!periods.length) {
        for (var m = 1; m <= 12; m++) periods.push(('0' + m).slice(-2) + '-' + year);
      }
      window.require(['xlsx'], function (X) {
        var head = ['PROJECT', 'PROJECT_NAME', 'TASK', 'EXPENDITURE_TYPE', 'CF_TYPE']
          .concat(periods)
          .concat(CF_TPL_REF.map(function (c) { return c[1]; }))
          .concat(['ANNUAL_BUDGET']);
        var aoa = [head];
        function line2row(l, type, pfx) {
          var r = [l.project, l.projectName || '', l.task, l.etype, type];
          for (var i = 1; i <= 12; i++) {
            var v = l[pfx + ('0' + i).slice(-2)];
            r.push(v ? Number(v) : null);
          }
          CF_TPL_REF.forEach(function (c) { r.push(l[c[0]] || ''); });
          r.push(Number(l.budgetAnnual) || 0);
          return r;
        }
        lines.forEach(function (l) {
          aoa.push(line2row(l, 'APPROVED', 'a'));
          var rev = false;
          for (var i = 1; i <= 12; i++) { if (l['r' + ('0' + i).slice(-2)]) rev = true; }
          if (rev) aoa.push(line2row(l, 'REVISED', 'r'));
        });
        if (!lines.length) {
          aoa.push(['100026', 'Sample project', '1.1', 'Professional Services', 'APPROVED']
            .concat(periods.map(function () { return null; }))
            .concat(CF_TPL_REF.map(function () { return ''; }))
            .concat([0]));
        }
        var ws = X.utils.aoa_to_sheet(aoa);
        ws['!cols'] = head.map(function (h, i) {
          return { wch: i === 1 ? 30 : (i === 3 ? 42 : Math.max(12, h.length + 2)) };
        });
        var wb = X.utils.book_new();
        X.utils.book_append_sheet(wb, ws, 'Projects Cashflow');
        X.utils.book_append_sheet(wb, X.utils.aoa_to_sheet([
          [self.t('cfTplHint')],
          [''],
          ['Budget year: ' + year + '  |  budget lines: ' + lines.length],
          ['Keys (must not be edited): PROJECT, TASK, EXPENDITURE_TYPE.'],
          ['CF_TYPE = APPROVED or REVISED — copy a row and switch it to plan both.'],
          ['One column per accounting period (MM-YYYY): type the amount in the month cell.'],
          ['Blank month cells are ignored on upload; a typed 0 clears a saved amount.'],
          ['Columns after the months (GL_COMBINATION, SECTOR, ...) are reference only.']
        ]), self.t('cfTplNoteSheet'));
        X.writeFile(wb, 'Projects_Cashflow_Template_' + year + '.xlsx');
        self.cfTplBusy(false);
        var msg = self.t('cfTplDone').replace('{n}', lines.length).replace('{y}', year);
        self.cfNote(lines.length ? msg : self.t('cfTplEmpty'));
        toast(lines.length ? msg : self.t('cfTplEmpty'));
      });
    }
    self.cfPjTemplate = function () {
      var year = self.cfTplYear() || String(new Date().getFullYear());
      self.cfTplBusy(true);
      self.cfNote('');
      api('GET', '/cashflow/projects/template?year=' + encodeURIComponent(year))
        .then(function (d) { cfPjBuildTemplate(d, year); })
        .catch(function (e) {
          /* no privilege / route missing -> still hand out the empty layout */
          cfPjBuildTemplate({}, year);
          self.cfNote(self.t('cfTplFail') + ' — ' + (e && e.message ? e.message : ''));
        });
    };

    /* ════ DOF REPORTS — YoY / Budget Utilization / Quarterly ════
       On-screen datasets over /gl/dof/* (SHARED interactive-report), row click
       opens the Reasons/Remarks drawer (persisted notes), Generate Workbook
       enqueues DOF_YOY_PERF / DOF_QUARTERLY_PERF via the register bridge. */
    self.canEditDofNotes = self.isSysAdmin;
    self.dofLoaded = ko.observable(false);
    self.dofBusy = ko.observable(false);
    self.dofReport = ko.observable('yoy');
    self.dofYear = ko.observable(String(new Date().getFullYear()));
    self.dofPeriod = ko.observable('');
    self.dofData = ko.observable(null);
    self.dofCount = ko.observable(0);
    self.dofCfWarn = ko.observable(false);
    self.dofEraNote = ko.observable(false);
    self.dofGenBusy = ko.observable(false);
    /* 2026-08-03: the report runs against ALL loaded fiscal years — 2016-2025
       come from the legacy EBS history (mapped view), 2026+ from Fusion GL */
    self.dofYears = ko.computed(function () {
      var y = new Date().getFullYear(), out = [];
      for (var i = y + 1; i >= 2016; i--) out.push(String(i));
      return out;
    });
    /* butil-style collapsible Search / Results regions (state persisted) */
    var dofUi = {};
    try { dofUi = JSON.parse(localStorage.getItem('gl_dof_ui') || '{}'); } catch (e) { dofUi = {}; }
    self.dofSecSearchOpen = ko.observable(dofUi.search !== false);
    self.dofSecResOpen = ko.observable(dofUi.res !== false);
    /* display unit ("Showing figures in") + near-zero display mode — both are
       display-only search-criteria parameters; no re-query, the cached run is
       re-emitted (2026-08-04 layout round) */
    self.dofUnit = ko.observable(['X', 'K', 'M', 'B'].indexOf(dofUi.unit) >= 0 ? dofUi.unit : 'X');
    self.dofZero = ko.observable(['muted', 'dash', 'blank'].indexOf(dofUi.zero) >= 0 ? dofUi.zero : 'muted');
    function saveDofUi() {
      try {
        localStorage.setItem('gl_dof_ui', JSON.stringify(
          { search: self.dofSecSearchOpen(), res: self.dofSecResOpen(),
            unit: self.dofUnit(), zero: self.dofZero() }));
      } catch (e) {}
    }
    self.toggleDofSec = function (k) {
      var o = k === 'search' ? self.dofSecSearchOpen : self.dofSecResOpen;
      o(!o());
      saveDofUi();
    };
    self.dofUnitOpts = ko.computed(function () {
      return [
        { v: 'X', l: self.t('unitExact') },
        { v: 'K', l: self.t('unitK') },
        { v: 'M', l: self.t('unitM') },
        { v: 'B', l: self.t('unitB') }
      ];
    });
    self.dofZeroOpts = ko.computed(function () {
      return [
        { v: 'muted', l: self.t('dofZeroMuted') },
        { v: 'dash', l: self.t('dofZeroDash') },
        { v: 'blank', l: self.t('dofZeroBlank') }
      ];
    });
    /* Chapter + Appropriation criteria — MULTI-select (any-of), butil chips
       pattern; LOVs derived from the loaded run (2026-08-04 (2)). Declared
       before the search-summary computed, which reads the selections. */
    self.dofChapters = ko.observableArray([]);
    self.dofApprs = ko.observableArray([]);        /* [{c, l, ch}] */
    self.dofChSel = ko.observableArray([]);
    self.dofApSel = ko.observableArray([]);
    self.dofChPick = ko.observable('');
    self.dofApPick = ko.observable('');
    self.dofChAdd = function () {
      var v = self.dofChPick();
      if (v && self.dofChSel.indexOf(v) < 0) self.dofChSel.push(v);
      self.dofChPick('');
      return true;
    };
    self.dofApAdd = function () {
      var v = self.dofApPick();
      if (v && self.dofApSel.indexOf(v) < 0) self.dofApSel.push(v);
      self.dofApPick('');
      return true;
    };
    self.dofApprOpts = ko.computed(function () {
      var ch = self.dofChSel();
      return self.dofApprs().filter(function (a) {
        return !ch.length || ch.indexOf(a.ch) >= 0;
      });
    });
    self.dofApLabel = function (code) {
      var l = code;
      self.dofApprs().forEach(function (a) { if (a.c === code) l = a.l; });
      return l;
    };
    self.dofSearchSummary = ko.computed(function () {
      if (self.dofSecSearchOpen()) return '';
      var rep = self.dofReport(), lbl = '';
      self.dofReports().forEach(function (o) { if (o.v === rep) lbl = o.l; });
      var s = lbl + ' · ' + self.dofYear();
      if (rep !== 'quarterly' && self.dofPeriod()) s += ' · ' + self.dofPeriod();
      if (self.dofChSel().length) s += ' · ' + self.dofChSel().join(', ');
      if (self.dofApSel().length) s += ' · ' + self.dofApSel().join(', ');
      return s;
    });
    self.dofResSummary = ko.computed(function () {
      return self.dofLoaded() ? self.fmt(self.dofCount()) + ' ' + self.t('dofRows') : '';
    });
    self.dofReset = function () {
      self.dofReport('yoy');
      self.dofYear(String(new Date().getFullYear()));
      self.dofPeriod('');
      self.dofChSel.removeAll();
      self.dofApSel.removeAll();
      self.dofChPick('');
      self.dofApPick('');
    };
    function dofY(key, y, p) {
      var s = self.t(key).replace('{y}', y);
      if (p !== undefined) s = s.replace('{p}', p);
      return s;
    }
    self.dofPeriods = ko.computed(function () {
      var y = self.dofYear(), out = [];
      for (var m = 1; m <= 12; m++) out.push(('0' + m).slice(-2) + '-' + y);
      return out;
    });
    self.dofReports = ko.computed(function () {
      return [{ v: 'yoy', l: self.t('dofYoY') },
              { v: 'butil', l: self.t('dofButil') },
              { v: 'quarterly', l: self.t('dofQuarterly') }];
    });
    var dofRowMap = {};
    /* column headers carry the RUN year (2026-08-03 user request): e.g. for
       2026 the prior-FY column reads "Actual FY 2025", the budget column
       "Revised Budget 2026" — dofY() substitutes {y}/{p} in the i18n key.
       2026-08-04 layout round: columns are ordered in YEAR BLOCKS (identity →
       current year → prior year → comparison), each block under a grouped
       header band (col.group) with a per-year tint (col.colClass — app.css),
       the code identity columns FROZEN (col.sticky), variance columns carry
       ▲/▼ delta arrows, and long texts truncate to one line (col.ellipsis). */
    /* 2026-08-04 (2): code + description MERGED into one column per identity
       dimension (user feedback — narrow frozen columns truncated the headers):
       Appropriation = "100103 — FA103-Manpower Expense", Account = fusion
       code — name (EBS code keeps its own column), Entity = code — name */
    function dofIdCols(withAccount) {
      var t = self.t;
      var cols = [
        { key: 'chapter', label: t('dofColChapter'), type: 'text', sticky: true, width: 130 },
        { key: 'apprFull', label: t('dofColAppr'), type: 'text', sticky: true, width: 230, ellipsis: true }
      ];
      if (withAccount) {
        cols.push({ key: 'accountFull', label: t('dofColAccount'), type: 'text', sticky: true, width: 240, ellipsis: true });
        cols.push({ key: 'ebsAccount', label: t('dofColEbsAcc'), type: 'text' });
      }
      cols.push({ key: 'entityFull', label: t('dofColEntity'), type: 'text', ellipsis: true });
      return cols;
    }
    function dofColsYoy(yr) {
      var t = self.t, py = yr - 1;
      var gCur = dofY('dofBandFy', yr), gPri = dofY('dofBandFy', py);
      return dofIdCols(true).concat([
        /* current-year block first, then prior year, then the comparison */
        { key: 'revBudget', label: dofY('dofColRevBudgetY', yr), hint: dofY('dofHintRevBudget', yr), type: 'money',
          group: gCur, groupClass: 'dofg-cur', colClass: 'dofc-cur' },
        { key: 'actualYtd', label: dofY('dofColActualYtdY', yr), hint: dofY('dofHintActualYtd', yr), type: 'money',
          group: gCur, groupClass: 'dofg-cur', colClass: 'dofc-cur' },
        { key: 'priorYtd', label: dofY('dofColActualYtdY', py), hint: dofY('dofHintPriorYtd', yr, py), type: 'money',
          group: gPri, groupClass: 'dofg-pri', colClass: 'dofc-pri' },
        { key: 'priorFy', label: dofY('dofColActualFyY', py), hint: dofY('dofHintActualFy', py), type: 'money',
          group: gPri, groupClass: 'dofg-pri', colClass: 'dofc-pri' },
        { key: 'variance', label: dofY('dofColVarianceY', yr, py), hint: dofY('dofHintVariance', yr, py), type: 'money',
          delta: true },
        { key: 'reason', label: t('dofColReason'), type: 'text', ellipsis: true }
      ]);
    }
    function dofColsButil(yr) {
      var t = self.t;
      var gBud = dofY('dofBandBudget', yr), gPerf = dofY('dofBandPerf', yr);
      return dofIdCols(false).concat([
        { key: 'initBudget', label: dofY('dofColInitBudgetY', yr), hint: dofY('dofHintInitBudget', yr), type: 'money',
          group: gBud, groupClass: 'dofg-cur', colClass: 'dofc-cur' },
        { key: 'revBudget', label: dofY('dofColRevBudgetFyY', yr), hint: dofY('dofHintRevBudget', yr), type: 'money',
          group: gBud, groupClass: 'dofg-cur', colClass: 'dofc-cur' },
        { key: 'initCfYtd', label: dofY('dofColInitCfY', yr), hint: dofY('dofHintInitCf', yr), type: 'money',
          group: gBud, groupClass: 'dofg-cur', colClass: 'dofc-cur' },
        { key: 'revCfYtd', label: dofY('dofColRevCfY', yr), hint: dofY('dofHintRevCf', yr), type: 'money',
          group: gBud, groupClass: 'dofg-cur', colClass: 'dofc-cur' },
        { key: 'actualYtd', label: dofY('dofColActualYtdY', yr), hint: dofY('dofHintActualYtd', yr), type: 'money',
          group: gPerf, groupClass: 'dofg-perf' },
        { key: 'variance', label: t('dofColVariance'), hint: dofY('dofHintVarianceBu', yr), type: 'money',
          group: gPerf, groupClass: 'dofg-perf', delta: true },
        { key: 'utilPct', label: t('dofColUtilPct'), hint: dofY('dofHintUtilPct', yr), type: 'num',
          group: gPerf, groupClass: 'dofg-perf' },
        { key: 'reason', label: t('dofColReason'), type: 'text', ellipsis: true }
      ]);
    }
    function dofColsQuarterly(yr) {
      var t = self.t;
      var gBud = dofY('dofBandBudget', yr);
      var cols = dofIdCols(false).concat([
        { key: 'approvedBudget', label: dofY('dofColApprovedY', yr), hint: dofY('dofHintApproved', yr), type: 'money',
          group: gBud, groupClass: 'dofg-cur', colClass: 'dofc-cur' },
        { key: 'revBudgetQ1', label: dofY('dofColRevQ1Y', yr), hint: dofY('dofHintRevQn', yr).replace('{q}', 1), type: 'money',
          group: gBud, groupClass: 'dofg-cur', colClass: 'dofc-cur' },
        { key: 'revBudgetQ2', label: dofY('dofColRevQ2Y', yr), hint: dofY('dofHintRevQn', yr).replace('{q}', 2), type: 'money',
          group: gBud, groupClass: 'dofg-cur', colClass: 'dofc-cur' }
      ]);
      for (var q = 1; q <= 4; q++) {
        var gq = t('dofBandQ').replace('{q}', q), qc = (q % 2 ? 'dofc-qa' : 'dofc-qb');
        cols.push({ key: 'acf' + q, label: t('dofColAcf') + q, type: 'money', group: gq, colClass: qc });
        cols.push({ key: 'rcf' + q, label: t('dofColRcf') + q, type: 'money', group: gq, colClass: qc });
        cols.push({ key: 'act' + q, label: t('dofColAct') + q, type: 'money', group: gq, colClass: qc });
        cols.push({ key: 'var' + q, label: t('dofColVar') + q, type: 'money', group: gq, colClass: qc, delta: true });
        cols.push({ key: 'pct' + q, label: t('dofColPct') + q, type: 'num', group: gq, colClass: qc });
        cols.push({ key: 'rsn' + q, label: t('dofColRsn') + q, type: 'text', group: gq, colClass: qc, ellipsis: true });
      }
      cols.push({ key: 'remark', label: t('dofColRemark'), type: 'text', ellipsis: true });
      return cols;
    }
    /* the loaded run is cached RAW; dofEmit() re-projects it into the IR
       envelope whenever the display unit, near-zero mode or the Chapter /
       Appropriation multi-select criteria change (no re-query).
       dofColsCache feeds the drawer's full-record section. */
    var dofRaw = null;
    var dofColsCache = [];
    /* recomputed grand row for a FILTERED detail set (server totals cover the
       full run; ratios recomputed, not summed) */
    function dofGrandOf(det, rep, items) {
      var src = null;
      items.forEach(function (r) { if (r.rowType === 'GRAND') src = r; });
      var g = { rowType: 'GRAND', _rowClass: 'ir-row-grand',
                chapter: src ? src.chapter : 'Grand Total' };
      det.forEach(function (r) {
        for (var k in r) {
          if (typeof r[k] === 'number') g[k] = (g[k] || 0) + r[k];
        }
      });
      if (rep === 'butil') {
        g.utilPct = g.revCfYtd ? Math.round(10000 * (g.actualYtd || 0) / g.revCfYtd) / 100 : null;
      }
      if (rep === 'quarterly') {
        for (var q = 1; q <= 4; q++) {
          g['pct' + q] = g['rcf' + q] ? Math.round(10000 * (g['var' + q] || 0) / g['rcf' + q]) / 100 : null;
        }
      }
      return g;
    }
    function dofEmit() {
      if (!dofRaw) return;
      var rep = dofRaw.rep, yr = dofRaw.yr, items = dofRaw.items;
      var cols = rep === 'yoy' ? dofColsYoy(yr) : rep === 'butil' ? dofColsButil(yr) : dofColsQuarterly(yr);
      var f = { X: 1, K: 1e3, M: 1e6, B: 1e9 }[self.dofUnit()] || 1;
      var zmode = self.dofZero();
      var moneyKeys = [];
      cols.forEach(function (c) {
        if (c.type !== 'money') return;
        moneyKeys.push(c.key);
        /* "rounds to zero at the current unit" = near-zero */
        c.nearZero = { mode: zmode, threshold: 0.005 };
      });
      dofColsCache = cols;
      /* chapter / appropriation any-of filters; totals follow the filter —
         whole-chapter picks keep the server CHTOTAL rows, appropriation picks
         (or multi-chapter) get a recomputed grand row */
      var fc = self.dofChSel(), fa = self.dofApSel();
      var rows = items;
      if (fc.length || fa.length) {
        var det = items.filter(function (r) {
          return r.rowType === 'DETAIL'
            && (!fc.length || fc.indexOf(r.chapter) >= 0)
            && (!fa.length || fa.indexOf(r.apprCode) >= 0);
        });
        if (!fa.length) {
          rows = items.filter(function (r) {
            if (r.rowType === 'DETAIL') return det.indexOf(r) >= 0;
            if (r.rowType === 'CHTOTAL') {
              return fc.indexOf(String(r.chapter || '').replace(/ Total$/, '')) >= 0;
            }
            return false;
          });
          if (fc.length > 1) rows = rows.concat([dofGrandOf(det, rep, items)]);
        } else {
          rows = det.concat(det.length ? [dofGrandOf(det, rep, items)] : []);
        }
      }
      var emitted = f === 1 ? rows : rows.map(function (r) {
        var o = {}, k;
        for (k in r) { if (Object.prototype.hasOwnProperty.call(r, k)) o[k] = r[k]; }
        moneyKeys.forEach(function (mk) {
          if (o[mk] !== null && o[mk] !== undefined && o[mk] !== '') o[mk] = Number(o[mk]) / f;
        });
        return o;
      });
      self.dofCount(emitted.length);
      self.dofData({ columns: cols, items: emitted, total: emitted.length,
                     truncated: false, maxRows: 10000, zebra: true, stateRev: 2,
                     section: 'dof' + rep });
    }
    self.dofUnit.subscribe(function () { saveDofUi(); dofEmit(); });
    self.dofZero.subscribe(function () { saveDofUi(); dofEmit(); });
    self.dofChSel.subscribe(dofEmit);
    self.dofApSel.subscribe(dofEmit);
    self.runDof = function () {
      var rep = self.dofReport(), yr = self.dofYear();
      self.dofBusy(true);
      var p = { year: yr };
      if (rep !== 'quarterly' && self.dofPeriod()) p.period = self.dofPeriod();
      var path = rep === 'yoy' ? '/dof/yoy' : rep === 'butil' ? '/dof/butil' : '/dof/quarterly';
      return api('GET', path + qs(p)).then(function (d) {
        var items = d.rows || [];
        dofRowMap = {};
        var chs = {}, aps = {};
        function join2(a, b) { return a ? (b ? a + ' — ' + b : String(a)) : ''; }
        items.forEach(function (r) {
          /* merged identity fields (code — description, 2026-08-04 (2)) */
          r.apprFull = join2(r.apprCode, r.apprDesc);
          r.accountFull = join2(r.accountCode, r.accountName);
          r.entityFull = join2(r.entity, r.entityName);
          /* chapter sub-total / grand-total bands (shared IR row._rowClass) */
          if (r.rowType === 'CHTOTAL') r._rowClass = 'ir-row-subtotal';
          else if (r.rowType === 'GRAND') r._rowClass = 'ir-row-grand';
          if (r.rowType !== 'DETAIL') return;
          if (r.chapter) chs[r.chapter] = 1;
          if (r.apprCode && !aps[r.apprCode]) {
            aps[r.apprCode] = { c: r.apprCode, l: r.apprFull, ch: r.chapter };
          }
          /* side-map keys use the MERGED fields — those are the columns the
             IR rows actually carry (normalizeRows drops non-column keys) */
          if (rep === 'yoy') dofRowMap[r.apprFull + '|' + r.accountFull] = r;
          else if (r.apprCode) dofRowMap[r.apprFull] = r;
        });
        self.dofChapters(Object.keys(chs).sort());
        self.dofApprs(Object.keys(aps).sort().map(function (k) { return aps[k]; }));
        var warn;
        if (rep === 'butil') {
          warn = items.length > 0 && !items.some(function (r) { return r.hasCf === 'Y'; });
        } else if (rep === 'quarterly') {
          warn = items.length > 0 && !items.some(function (r) {
            return (r.acf1 + r.acf2 + r.acf3 + r.acf4 + r.rcf1 + r.rcf2 + r.rcf3 + r.rcf4) !== 0;
          });
        } else warn = false;
        /* legacy EBS years have no cashflow plan by design — no warning */
        if (Number(yr) < 2026) warn = false;
        self.dofEraNote(Number(yr) < 2026);
        self.dofCfWarn(warn);
        self.dofCount(items.length);
        dofRaw = { rep: rep, yr: Number(yr), items: items };
        dofEmit();
        self.dofLoaded(true); self.dofBusy(false);
      }).catch(function (e) { self.dofBusy(false); fail(e); });
    };
    /* row click -> reasons/remarks drawer (resolve the IR cell like the
       legacy mapping grid does) */
    self.dofDrawer = ko.observable(false);
    self.dofSaving = ko.observable(false);
    self.dofNRow = ko.observable(null);
    self.dofNReason = ko.observable('');
    self.dofNQ = [ko.observable(''), ko.observable(''), ko.observable(''), ko.observable('')];
    self.dofNRemark = ko.observable('');
    /* full record info shown in the drawer (2026-08-04 user request):
       every dataset column of the clicked row, raw AED values */
    self.dofNInfo = ko.observableArray([]);
    self.dofGridClick = function (d, e) {
      if (!self.canEditDofNotes) return true;
      var td = (e.target && e.target.closest) ? e.target.closest('td') : null;
      if (!td) return true;
      var ctx;
      try { ctx = ko.contextFor(td); } catch (err) { return true; }
      if (!ctx || !ctx.$parent || !ctx.$parent.row) return true;
      var rr = ctx.$parent.row, rep = self.dofReport();
      var row = rep === 'yoy' ? dofRowMap[rr.apprFull + '|' + rr.accountFull] : dofRowMap[rr.apprFull];
      if (row) { self.openDofNote(row); return false; }
      return true;
    };
    self.openDofNote = function (row) {
      self.dofNRow(row);
      var rep = self.dofReport();
      if (rep === 'quarterly') {
        for (var q = 0; q < 4; q++) self.dofNQ[q](row['rsn' + (q + 1)] || '');
        self.dofNRemark(row.remark || '');
      } else self.dofNReason(row.reason || '');
      /* record grid mirrors the TABLE formatting exactly (user feedback
         2026-08-04 (3)): same unit scaling, 2-decimal money format, near-zero
         mode and the ▲/▼ colored variance */
      var f = { X: 1, K: 1e3, M: 1e6, B: 1e9 }[self.dofUnit()] || 1;
      var zmode = self.dofZero();
      function fmt2(n) {
        return n.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
      }
      var info = [];
      dofColsCache.forEach(function (c) {
        if (c.key === 'reason' || c.key === 'remark' || /^rsn\d$/.test(c.key)) return;
        var v = row[c.key];
        var e = { l: c.label, num: c.type === 'money' || c.type === 'num',
                  cls: '', arrow: '' };
        if (v === null || v === undefined || v === '') {
          e.v = '—';
        } else if (c.type === 'money') {
          var n = Number(v) / f;
          var nz = Math.abs(n) <= 0.005;
          if (nz && zmode === 'dash') e.v = '—';
          else if (nz && zmode === 'blank') e.v = '';
          else e.v = fmt2(n);
          if (nz && zmode === 'muted') e.cls = 'dim';
          if (c.delta && !nz) {
            e.arrow = n > 0 ? '▲' : '▼';
            e.cls = n > 0 ? 'pos' : 'neg';
          }
        } else if (c.type === 'num') {
          var n2 = Number(v);
          e.v = isNaN(n2) ? String(v)
            : (n2 % 1 === 0 ? n2.toLocaleString('en-US') : fmt2(n2));
        } else {
          e.v = String(v);
        }
        info.push(e);
      });
      self.dofNInfo(info);
      self.dofDrawer(true);
    };
    self.closeDofDrawer = function () { self.dofDrawer(false); };
    self.saveDofNote = function () {
      var row = self.dofNRow();
      if (!row) return;
      var rep = self.dofReport(), yr = Number(self.dofYear());
      var puts = [];
      function put(body) { puts.push(function () { return api('PUT', '/dof/notes', body); }); }
      if (rep === 'yoy') {
        put({ year: yr, entity: row.entity, appropriation: row.apprCode,
              account: row.accountCode, noteType: 'REASON', text: self.dofNReason() || '' });
      } else if (rep === 'butil') {
        put({ year: yr, entity: row.entity, appropriation: row.apprCode,
              noteType: 'REASON', text: self.dofNReason() || '' });
      } else {
        for (var q = 1; q <= 4; q++) {
          put({ year: yr, entity: row.entity, appropriation: row.apprCode,
                quarter: q, noteType: 'REASON', text: self.dofNQ[q - 1]() || '' });
        }
        put({ year: yr, entity: row.entity, appropriation: row.apprCode,
              noteType: 'REMARK', text: self.dofNRemark() || '' });
      }
      self.dofSaving(true);
      (function next(i) {
        if (i >= puts.length) {
          self.dofSaving(false); self.dofDrawer(false);
          toast(self.t('saved')); self.runDof();
          return;
        }
        puts[i]().then(function () { next(i + 1); })
          .catch(function (e) { self.dofSaving(false); toast(e.message, true); });
      })(0);
    };
    /* Generate Workbook — the YoY workbook carries both the YoY and the DOF
       Budget Utilization sheets, so 'butil' also enqueues DOF_YOY_PERF */
    self.runDofRegister = function () {
      if (self.dofGenBusy()) return;
      var rep = self.dofReport() === 'quarterly' ? 'QUARTERLY' : 'YOY';
      var body = { report: rep, year: Number(self.dofYear()) };
      if (rep === 'YOY' && self.dofPeriod()) body.period = self.dofPeriod();
      self.dofGenBusy(true);
      api('POST', '/dof/register', body).then(function (d) {
        var runId = d.runId;
        toast(self.t('ebRegQueued') + runId);
        var tries = 0;
        (function poll() {
          if (++tries > 60) { self.dofGenBusy(false); toast(self.t('ebRegFailed') + 'timeout', true); return; }
          setTimeout(function () {
            api('GET', '/dof/register/' + runId).then(function (s) {
              if (s.status === 'SUCCESS' && s.hasFile) {
                fetch(API + '/dof/register/' + runId + '/file',
                      { headers: { 'Authorization': 'Bearer ' + TOKEN } })
                  .then(function (r) {
                    if (!r.ok) { throw new Error('Excel download failed (HTTP ' + r.status + ')'); }
                    return r.blob();
                  })
                  .then(function (b) {
                    var u = URL.createObjectURL(b);
                    var a = document.createElement('a');
                    a.href = u;
                    a.download = 'DOF_' + rep + '_' + self.dofYear() + '.xlsx';
                    a.click(); URL.revokeObjectURL(u);
                    self.dofGenBusy(false); toast(self.t('pnXlsxReady'));
                  })
                  .catch(function (e) { self.dofGenBusy(false); toast(e.message, true); });
              } else if (s.status === 'FAILED') {
                self.dofGenBusy(false); toast(self.t('ebRegFailed') + (s.error || ''), true);
              } else { poll(); }
            }).catch(function () { poll(); });
          }, 5000);
        })();
      }).catch(function (e) { self.dofGenBusy(false); fail(e); });
    };

    /* ═══════════ GL BALANCES YoY COMPARISON (2026-08-02) ═══════════
       Fusion-account basis: EBS years read stored YTD measures through the
       account map; 2026+ reads Fusion GL. Server = GET /gl/ebs-balances/yoy
       (long format), pivoted client-side; search/type filter locally. */
    (function () {
      var CUR_YEAR = new Date().getFullYear();
      var opts = [];
      for (var y = CUR_YEAR; y >= 2016; y--) opts.push(y);
      self.yoYearOpts = opts;
      self.yoSel = ko.observableArray([CUR_YEAR, CUR_YEAR - 1, CUR_YEAR - 2].filter(function (y) { return y >= 2016; }));
      self.yoMonthOpts = (function () {
        var m = [{ v: 0, l: null }];
        for (var i = 1; i <= 12; i++) m.push({ v: i, l: null });
        return m;
      })();
      self.yoMonth = ko.observable(0);
      /* PLATFORM RULE 2026-08-02: Budget Group defaults to '1' (Current
         operations); 2 (Capital) / 8 (Accrual) optional (EBS years only). */
      self.yoBgOpts = ['1', '2', '8'];
      self.yoBg = ko.observableArray(['1']);
      self.yoBgLabel = function (b) {
        return self.t(b === '1' ? 'yoBg1' : b === '2' ? 'yoBg2' : 'yoBg8');
      };
      self.yoToggleBg = function (b) {
        var i = self.yoBg.indexOf(b);
        if (i >= 0) self.yoBg.splice(i, 1); else self.yoBg.push(b);
      };
      self.yoSearch = ko.observable('');
      self.yoType = ko.observable('');
      self.yoMeasure = ko.observable('actual');
      self.yoBusy = ko.observable(false);
      self.yoLoaded = ko.observable(false);
      self.yoRegBusy = ko.observable(false);
      self.yoRows = ko.observableArray([]);   /* raw long-format rows */
      self.yoYears = ko.observableArray([]);  /* years of the loaded result, desc */
      self.yoMonthLabel = function (o) {
        if (o.v === 0) return self.t('yoFullYear');
        return ['January','February','March','April','May','June','July','August',
                'September','October','November','December'][o.v - 1] + ' (YTD)';
      };
      self.yoToggleYear = function (y) {
        var i = self.yoSel.indexOf(y);
        if (i >= 0) self.yoSel.splice(i, 1);
        else if (self.yoSel().length >= 6) { toast(self.t('yoMax6'), true); return; }
        else self.yoSel.push(y);
      };
      self.yoTypes = ko.pureComputed(function () {
        var seen = {};
        self.yoRows().forEach(function (r) { if (r.accountType) seen[r.accountType] = 1; });
        return Object.keys(seen).sort();
      });
      /* pivot: one row per account, vals keyed by year */
      self.yoPivot = ko.pureComputed(function () {
        var by = {}, order = [];
        self.yoRows().forEach(function (r) {
          var k = r.account;
          if (!by[k]) { by[k] = { account: k, name: r.accountName || '', type: r.accountType || '', vals: {} }; order.push(k); }
          if (!by[k].name && r.accountName) by[k].name = r.accountName;
          by[k].vals[r.year] = r;
        });
        return order.map(function (k) { return by[k]; });
      });
      self.yoView = ko.pureComputed(function () {
        var q = (self.yoSearch() || '').trim().toUpperCase();
        var ty = self.yoType();
        return self.yoPivot().filter(function (r) {
          if (ty && r.type !== ty) return false;
          if (q && (r.account + ' ' + r.name).toUpperCase().indexOf(q) < 0) return false;
          return true;
        });
      });
      self.yoVal = function (row, year) {
        var v = row.vals[year];
        return v ? (v[self.yoMeasure()] || 0) : null;
      };
      self.yoValTxt = function (row, year) {
        var v = self.yoVal(row, year);
        return v === null ? '—' : self.fmt(Math.round(v));
      };
      /* change = latest selected year vs the previous one */
      self.yoChange = function (row) {
        var ys = self.yoYears();
        if (ys.length < 2) return null;
        var a = self.yoVal(row, ys[0]), b = self.yoVal(row, ys[1]);
        if (a === null && b === null) return null;
        return (a || 0) - (b || 0);
      };
      self.yoChangeTxt = function (row) {
        var c = self.yoChange(row);
        return c === null ? '—' : self.fmt(Math.round(c));
      };
      self.yoChangePct = function (row) {
        var ys = self.yoYears();
        if (ys.length < 2) return '—';
        var b = self.yoVal(row, ys[1]);
        var c = self.yoChange(row);
        if (c === null || !b) return '—';
        return (Math.round(1000 * c / Math.abs(b)) / 10) + '%';
      };
      self.yoTotal = function (year) {
        var t = 0;
        self.yoView().forEach(function (r) { t += self.yoVal(r, year) || 0; });
        return self.fmt(Math.round(t));
      };
      /* ── SHARED interactive-report envelope (2026-08-03 rework): year
         columns ASCENDING left-to-right, dynamic "Change YY-YY" headers for
         the two latest selected years, per-column ⓘ hints, and a trailing
         Chart column (shared IR 'spark' type — hover shows the cross-year
         trend chart). Recomputes on run / measure / search / type change. */
      self.yoIr = ko.pureComputed(function () {
        if (!self.yoLoaded()) return null;
        var t = self.t;
        var ys = self.yoYears().slice().sort(function (a, b) { return a - b; });
        var meas = self.yoMeasure();
        var measL = t(meas === 'budget' ? 'yoBudget' : meas === 'encumbrance' ? 'yoEnc' : 'yoActual');
        var asof = Number(self.yoMonth()) === 0 ? t('yoFullYear')
                                                : self.yoMonthLabel({ v: Number(self.yoMonth()) });
        var n = ys.length;
        var yA = n ? ys[n - 1] : null, yB = n > 1 ? ys[n - 2] : null;  /* latest / previous */
        var sfx = yB ? ' ' + String(yB).slice(-2) + '-' + String(yA).slice(-2) : '';
        function sub(k, m) {
          var s = t(k);
          Object.keys(m || {}).forEach(function (p) { s = s.split('{' + p + '}').join(m[p]); });
          return s;
        }
        var cols = [
          { key: 'account', label: t('yoColAccount'), type: 'text' },
          { key: 'name', label: t('yoColName'), type: 'text' },
          { key: 'type', label: t('yoColType'), type: 'text' }
        ];
        ys.forEach(function (y, yi) {
          /* alternating per-year column tint so adjacent years don't blur
             (2026-08-04 layout round — yoc-a / yoc-b in app.css) */
          cols.push({ key: 'y' + y, label: String(y), type: 'money',
                      colClass: 'yoc-' + (yi % 2 ? 'b' : 'a'),
                      hint: sub('yoHintYear', { y: y, m: measL, a: asof }) });
        });
        if (yB) {
          /* gold-tinted comparison block w/ ▲ increase green / ▼ decrease red */
          cols.push({ key: 'change', label: t('yoColChange') + sfx, type: 'money',
                      colClass: 'yoc-chg', delta: true,
                      hint: sub('yoHintChange', { a: yA, b: yB, m: measL }) });
          cols.push({ key: 'changePct', label: t('yoColChangePct') + sfx, type: 'num',
                      colClass: 'yoc-chg', delta: true,
                      hint: sub('yoHintChangePct', { a: String(yA).slice(-2), b: String(yB).slice(-2) }) });
        }
        cols.push({ key: 'chart', label: t('yoColChart'), type: 'spark', hint: t('yoHintChart'),
                    spark: { cols: ys.map(function (y) { return 'y' + y; }),
                             labels: ys.map(String) } });
        var items = self.yoView().map(function (r) {
          var o = { account: r.account, name: r.name, type: r.type, chart: null };
          ys.forEach(function (y) { o['y' + y] = self.yoVal(r, y); });
          if (yB) {
            var c = self.yoChange(r);
            o.change = c;
            var p = self.yoChangePct(r);
            o.changePct = (p === '—') ? null : Number(p.replace('%', ''));
          }
          return o;
        });
        return { columns: cols, items: items, total: items.length, truncated: false,
                 maxRows: 10000, zebra: true, stateRev: 2, section: 'yoy' };
      });
      self.runYoy = function () {
        if (self.yoBusy()) return;
        var yrs = self.yoSel().slice().sort(function (a, b) { return b - a; });
        if (!yrs.length) { toast(self.t('yoPickYear'), true); return; }
        var bgs = self.yoBg().slice().sort();
        if (!bgs.length) { toast(self.t('yoPickBg'), true); return; }
        self.yoBusy(true);
        api('GET', '/ebs-balances/yoy?years=' + yrs.join('|') + '&month=' + self.yoMonth()
                 + '&bg=' + encodeURIComponent(bgs.join('|')))
          .then(function (d) {
            self.yoRows(d.rows || []);
            self.yoYears(d.years || yrs);
            self.yoLoaded(true);
            self.yoBusy(false);
          })
          .catch(function (e) { self.yoBusy(false); toast(e.message, true); });
      };
      self.yoCsv = function () {
        var ys = self.yoYears().slice().sort(function (a, b) { return a - b; });
        var head = ['Account', 'Account Name', 'Type'];
        ys.forEach(function (y) { head.push(self.yoMeasure() + ' ' + y); });
        head.push('Change', 'Change %');
        var lines = [head.join(',')];
        var tot = {};
        self.yoView().forEach(function (r) {
          var cells = ['"' + r.account + '"', '"' + (r.name || '').replace(/"/g, '""') + '"', '"' + r.type + '"'];
          ys.forEach(function (y) {
            var v = self.yoVal(r, y);
            cells.push(v === null ? '' : v);
            tot[y] = (tot[y] || 0) + (v || 0);
          });
          var c = self.yoChange(r);
          cells.push(c === null ? '' : c, self.yoChangePct(r).replace('%', ''));
          lines.push(cells.join(','));
        });
        var trow = ['"Total"', '', ''];
        ys.forEach(function (y) { trow.push(tot[y] || 0); });
        lines.push(trow.join(','));
        var blob = new Blob(['﻿' + lines.join('\n')], { type: 'text/csv;charset=utf-8' });
        var u = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = u; a.download = 'gl_balances_yoy_' + self.yoMeasure() + '.csv';
        a.click(); URL.revokeObjectURL(u);
      };
      self.runYoyXlsx = function () {
        if (self.yoRegBusy()) return;
        var yrs = self.yoSel().slice().sort(function (a, b) { return b - a; });
        if (!yrs.length) { toast(self.t('yoPickYear'), true); return; }
        var body = { years: yrs.join('|'), month: Number(self.yoMonth()),
                     bg: (self.yoBg().slice().sort().join('|') || '1') };
        if ((self.yoSearch() || '').trim()) body.search = self.yoSearch().trim();
        if (self.yoType()) body.atype = self.yoType();
        self.yoRegBusy(true);
        api('POST', '/ebs-balances/yoy/xlsx', body).then(function (d) {
          var runId = d.runId;
          toast(self.t('ebRegQueued') + runId);
          var tries = 0;
          (function poll() {
            if (++tries > 60) { self.yoRegBusy(false); toast(self.t('ebRegFailed') + 'timeout', true); return; }
            setTimeout(function () {
              api('GET', '/ebs-balances/yoy/xlsx/' + runId).then(function (s) {
                if (s.status === 'SUCCESS' && s.hasFile) {
                  fetch(API + '/ebs-balances/yoy/xlsx/' + runId + '/file',
                        { headers: { 'Authorization': 'Bearer ' + TOKEN } })
                    .then(function (r) {
                      if (!r.ok) { throw new Error('Excel download failed (HTTP ' + r.status + ')'); }
                      return r.blob();
                    })
                    .then(function (b) {
                      var u = URL.createObjectURL(b);
                      var a = document.createElement('a');
                      a.href = u; a.download = 'GL_Balances_YoY_' + yrs.join('_') + '.xlsx';
                      a.click(); URL.revokeObjectURL(u);
                      self.yoRegBusy(false); toast(self.t('pnXlsxReady'));
                    })
                    .catch(function (e) { self.yoRegBusy(false); toast(e.message, true); });
                } else if (s.status === 'FAILED') {
                  self.yoRegBusy(false); toast(self.t('ebRegFailed') + (s.error || ''), true);
                } else { poll(); }
              }).catch(function () { poll(); });
            }, 4000);
          })();
        }).catch(function (e) { self.yoRegBusy(false); toast(e.message, true); });
      };
    })();

    /* ── Sector Financial Performance (2026-08-19) ────────────────────
       Rebuild of docs/Reports/GL/Sector Report_October.pdf. Every figure comes
       from /gl/sectorperf*, which reads DCT_SECTOR_PERF_V -- itself built on
       top of the Budget Utilization view, so Budget / Actual / Encumbrance /
       Funds Available reconcile to the Budget Utilization page by construction.
       PLAN is the only added measure, and while no real plan is loaded it is
       generated sample data flagged by the amber banner. */
    (function () {
      self.spFilters   = ko.observable(null);
      self.spLoaded    = ko.observable(false);
      self.spBusy      = ko.observable(false);
      self.spError     = ko.observable('');
      self.spOverview  = ko.observable(null);
      self.spSectors   = ko.observableArray([]);
      self.spTotalRow  = ko.observable(null);
      self.spDepts     = ko.observableArray([]);
      self.spTrend     = ko.observableArray([]);
      self.spTrendMeta = ko.observable(null);
      self.spRev       = ko.observable(null);
      self.spExpand    = ko.observable(false);

      // criteria
      self.spcYear     = ko.observable('');
      self.spcPeriod   = ko.observable('');
      self.spcPlanType = ko.observable('APPROVED');
      self.spcProjType = ko.observable('');
      self.spcBu       = ko.observable('');
      self.spSectorSel = ko.observableArray([]);
      self.spDeptSel   = ko.observableArray([]);
      self.spKindSel   = ko.observableArray([]);
      self.spSectorPick = ko.observable('');
      self.spDeptPick   = ko.observable('');
      self.spKindPick   = ko.observable('');

      function pipe(arr) { return arr().length ? arr().join('|') : ''; }
      function addChip(arr, v) { if (v && arr().indexOf(v) < 0) arr.push(v); }

      self.spSectorPick.subscribe(function (v) { if (v) { addChip(self.spSectorSel, v); self.spSectorPick(''); } });
      self.spDeptPick.subscribe(function (v) { if (v) { addChip(self.spDeptSel, v); self.spDeptPick(''); } });
      self.spKindPick.subscribe(function (v) { if (v) { addChip(self.spKindSel, v); self.spKindPick(''); } });

      self.spChipRemove = function (arr, v) { arr.remove(v); };

      self.spQuery = function () {
        return qs({
          year: self.spcYear(),
          period: self.spcPeriod(),
          sector: pipe(self.spSectorSel),
          costcenter: pipe(self.spDeptSel),
          kind: self.spKindSel().length ? pipe(self.spKindSel) : 'Opex|Capex',
          projecttype: self.spcProjType(),
          bu: self.spcBu(),
          plantype: self.spcPlanType()
        });
      };

      /* Default period = the CURRENT month when the selected year is the current
         year (the Budget Utilization page's rule). Without it the page opens on
         "full year", where YTD Plan == FY Plan and the source pack's
         Target [YTD Plan / FY Plan] column reads a useless 100% on every row. */
      self.spDefaultPeriod = function () {
        var now = new Date(), y = String(self.spcYear() || '');
        if (y !== String(now.getFullYear())) return '';
        return ('0' + (now.getMonth() + 1)).slice(-2) + '-' + y;
      };

      self.loadSpFilters = function () {
        return api('GET', '/sectorperf/filters').then(function (d) {
          self.spFilters(d);
          if (!self.spcYear()) self.spcYear(String(d.year || (d.years || [])[0] || ''));
          // KO blanks a <select> whose option list was empty at bind time --
          // re-assert after the LOV lands (the cashflow-page lesson).
          setTimeout(function () { self.spcYear(String(self.spcYear())); }, 0);
          if (!self.spKindSel().length) self.spKindSel(['Opex', 'Capex']);
          if (!self.spcPeriod()) self.spcPeriod(self.spDefaultPeriod());
        });
      };

      self.spDeptLabel = function (cc) {
        var l = ((self.spFilters() || {}).departments || []).filter(function (d) { return d.costCentre === cc; })[0];
        return l ? l.department + ' (' + cc + ')' : cc;
      };

      self.runSectorPerf = function () {
        if (!self.spcYear()) return Promise.resolve();
        self.spBusy(true); self.spError('');
        var q = self.spQuery();
        var lvl = self.spExpand() ? '&level=project' : '';
        return Promise.all([
          api('GET', '/sectorperf' + q),
          api('GET', '/sectorperf/sectors' + q + lvl),
          api('GET', '/sectorperf/departments' + q),
          api('GET', '/sectorperf/trend' + q),
          api('GET', '/sectorperf/revenue' + q)
        ]).then(function (r) {
          self.spOverview(r[0]);
          self.spSectors(r[1].items || []);
          self.spTotalRow(r[1].total || null);
          self.spDepts(r[2].items || []);
          self.spTrend(r[3].items || []);
          self.spTrendMeta({ budgetAnnual: r[3].budgetAnnual, basis: r[3].budgetBasis });
          self.spRev(r[4]);
          self.spLoaded(true);
          self.spBusy(false);
        }).catch(function (e) {
          self.spBusy(false);
          self.spError(e && e.message || self.t('loadFailed'));
        });
      };

      self.spSearch = function () { self.runSectorPerf(); };
      self.spClear = function () {
        self.spcPeriod(self.spDefaultPeriod()); self.spcPlanType('APPROVED');
        self.spcProjType(''); self.spcBu('');
        self.spSectorSel([]); self.spDeptSel([]); self.spKindSel(['Opex', 'Capex']); self.spExpand(false);
        self.runSectorPerf();
      };
      self.spToggleExpand = function () { self.spExpand(!self.spExpand()); self.runSectorPerf(); };

      /* the page-1 matrix: the four rows of the source pack, in its order.
         Opex & Capex is a computed total row, not a server row, so it always
         agrees with the two rows above it. */
      self.spMatrix = ko.computed(function () {
        var o = self.spOverview(); if (!o) return [];
        var by = {}; (o.matrix || []).forEach(function (m) { by[m.kind] = m; });
        function row(key, label, m) {
          m = m || {};
          return {
            key: key, label: label,
            fyBudget: m.fyBudget || 0, ytdActual: m.ytdActual || 0,
            ytdPlan: m.ytdPlan || 0, fyPlan: m.fyPlan || 0,
            actualVsBudgetPct: m.actualVsBudgetPct, targetPct: m.targetPct
          };
        }
        var rev = o.revenue || {};
        var oc = { fyBudget: 0, ytdActual: 0, ytdPlan: 0, fyPlan: 0 };
        ['Opex', 'Capex'].forEach(function (k) {
          var m = by[k] || {};
          oc.fyBudget += m.fyBudget || 0; oc.ytdActual += m.ytdActual || 0;
          oc.ytdPlan += m.ytdPlan || 0;   oc.fyPlan   += m.fyPlan || 0;
        });
        oc.actualVsBudgetPct = oc.fyBudget ? Math.round(oc.ytdActual * 1000 / oc.fyBudget) / 10 : null;
        oc.targetPct         = oc.fyPlan   ? Math.round(oc.ytdPlan   * 1000 / oc.fyPlan) / 10 : null;
        return [
          row('revenue', self.t('spRevenue'), {
            fyBudget: rev.fyBudget, ytdActual: rev.ytdActual, ytdPlan: rev.ytdPlan,
            fyPlan: rev.fyPlan, actualVsBudgetPct: rev.actualVsBudgetPct, targetPct: rev.targetPct }),
          row('opex',  self.t('spOpex'),  by.Opex),
          row('capex', self.t('spCapex'), by.Capex),
          row('total', self.t('spOpexCapex'), oc)
        ];
      });

      /* RAG dots of the source pack: 0-33 red, 33-67 amber, 67-100 green */
      self.spRag = function (pct) {
        if (pct == null) return 'sp-rag--na';
        if (pct < 33) return 'sp-rag--low';
        if (pct < 67) return 'sp-rag--mid';
        return 'sp-rag--high';
      };
      self.spPct = function (v) { return v == null ? '—' : self.fmtPct(v); };
      self.fmtPct = function (v) { return (Math.round(v * 10) / 10).toFixed(1) + '%'; };

      /* gauge: a half-donut drawn with one SVG arc (no chart library in this
         app -- every visual here is hand-built SVG/CSS, like the dashboard) */
      self.spGaugeDash = function (pct) {
        var p = Math.max(0, Math.min(100, pct || 0));
        var len = Math.PI * 80;                 // r = 80, half circle
        return (len * p / 100) + ' ' + len;
      };

      self.spTrendMax = ko.computed(function () {
        var m = 0;
        self.spTrend().forEach(function (t) {
          m = Math.max(m, t.budgetCumulative || 0, t.actualCumulative || 0, t.planCumulative || 0);
        });
        return m || 1;
      });
      self.spBarH = function (v) { return Math.max(0, (v || 0) * 100 / self.spTrendMax()) + '%'; };

      self.spDeptMax = ko.computed(function () {
        var m = 0;
        self.spDepts().forEach(function (d) { m = Math.max(m, d.budget || 0, d.actual || 0, d.plan || 0); });
        return m || 1;
      });
      self.spDeptW = function (v) { return Math.max(0, (v || 0) * 100 / self.spDeptMax()) + '%'; };

      self.spRevMax = ko.computed(function () {
        var m = 0;
        ((self.spRev() || {}).categories || []).forEach(function (c) {
          m = Math.max(m, Math.abs(c.actual || 0), Math.abs(c.plan || 0));
        });
        return m || 1;
      });
      self.spRevW = function (v) { return Math.max(0, Math.abs(v || 0) * 100 / self.spRevMax()) + '%'; };

      self.spTrendMonthMax = ko.computed(function () {
        var m = 0;
        ((self.spRev() || {}).trend || []).forEach(function (t) { m = Math.max(m, t.actual || 0); });
        return m || 1;
      });
      self.spTrendMonthH = function (v) { return Math.max(0, (v || 0) * 100 / self.spTrendMonthMax()) + '%'; };

      self.spStream = function (code) {
        return (((self.spRev() || {}).streams) || []).filter(function (s) { return s.stream === code; })[0] || {};
      };

      /* sample-plan banner + one-click removal */
      self.spSampleActive = ko.computed(function () {
        var o = self.spOverview(); return !!o && o.sampleActive === 'Y';
      });
      self.spPurgeSample = function () {
        if (!window.confirm(self.t('spSampleConfirm'))) return;
        api('DELETE', '/sectorperf/sample?year=' + encodeURIComponent(self.spcYear()))
          .then(function () { toast(self.t('spSamplePurged')); self.runSectorPerf(); })
          .catch(function (e) { toast(e.message, true); });
      };

      self.spExportCsv = function () {
        var rows = [], t = self.t.bind(self);
        rows.push([t('spSector'), t('spProject'), t('spBudget'), t('spActual'),
                   t('spActVsBudget'), t('spPlan'), t('spActVsPlanAmt'),
                   t('spEncumbrance'), t('spFundsAvail')]);
        self.spSectors().forEach(function (r) {
          rows.push([r.sector, r.projectName || '', r.budget, r.actual,
                     r.actualVsBudgetPct == null ? '' : r.actualVsBudgetPct,
                     r.plan, r.actualVsPlanAmount, r.encumbrance, r.fundsAvailable]);
        });
        var tot = self.spTotalRow();
        if (tot) rows.push([t('spTotal'), '', tot.budget, tot.actual,
                            tot.actualVsBudgetPct == null ? '' : tot.actualVsBudgetPct,
                            tot.plan, tot.actualVsPlanAmount, tot.encumbrance, tot.fundsAvailable]);
        var csv = '﻿' + rows.map(function (r) {
          return r.map(function (c) {
            c = c == null ? '' : String(c);
            return /[",\n]/.test(c) ? '"' + c.replace(/"/g, '""') + '"' : c;
          }).join(',');
        }).join('\n');
        var a = document.createElement('a');
        a.href = URL.createObjectURL(new Blob([csv], { type: 'text/csv;charset=utf-8;' }));
        a.download = 'sector-performance-' + self.spcYear() + '.csv';
        document.body.appendChild(a); a.click(); document.body.removeChild(a);
      };
    })();

    /* ════════════════════════════════════════════════════════════════════
       FD Dashboard — "Budget status" (2026-09-03). The user's notebook
       sketch (final apps/BI/docs/FD Dashboard) rendered as mockup A "Ring
       Bands" (picked out of three). GL-balances basis: GL/db/42
       GET /fd/status applies the SAME period view + Budget-Group-1 +
       Chapters-1-3 rules as the Financial Performance tab, so the two pages
       always agree. ONE request returns the sector × entity × chapter cube;
       sector-card clicks and the business-unit toggle aggregate client-side,
       so filtering never waits on the server. v1.105.0: the Sectors and
       Departments regions render in one of THREE presentations picked from
       the Search region (tiles / rows / map) — see the presentation block.
       ════════════════════════════════════════════════════════════════════ */
    (function () {
      self.fdLoaded = ko.observable(false);
      self.fdBusy   = ko.observable(false);
      self.fdError  = ko.observable('');
      self.fdData   = ko.observable(null);
      self.fdSel    = ko.observableArray([]);   // selected sector codes (any-of; empty = all)
      self.fdEntity = ko.observable('ALL');     // ALL | DCT | MUSEUMS | ALC | MASTERPIECES

      var fdUi = {};
      try { fdUi = JSON.parse(localStorage.getItem('gl_fd_ui') || '{}'); } catch (ex) { fdUi = {}; }
      if (!fdUi || typeof fdUi !== 'object' || Array.isArray(fdUi)) fdUi = {};
      self.fdSecSearchOpen = ko.observable(fdUi.search !== false);
      function saveFdUi() {
        try { localStorage.setItem('gl_fd_ui', JSON.stringify({ search: self.fdSecSearchOpen(), layout: self.fdLayout ? self.fdLayout() : undefined })); } catch (ex) { /* Storage may be unavailable; retain this session's controls. */ }
      }
      self.toggleFdSec = function () {
        self.fdSecSearchOpen(!self.fdSecSearchOpen());
        saveFdUi();
        return true;
      };

      self.fdYears = ko.observableArray((function () {
        var y = new Date().getFullYear(), out = [];
        for (var i = y - 2; i <= y + 1; i++) out.push(String(i));
        return out;
      })());
      self.fdYear    = ko.observable('');
      self.fdPeriods = ko.observableArray([]);
      self.fdPeriod  = ko.observable('');
      function rebuildFdPeriods() {
        var y = self.fdYear(); if (!y) { self.fdPeriods([]); return; }
        var fmt;
        try { fmt = new Intl.DateTimeFormat(self.lang() === 'ar' ? 'ar' : 'en', { month: 'short' }); } catch (ex) { fmt = null; }
        var out = [];
        for (var m = 1; m <= 12; m++) {
          var mm = ('0' + m).slice(-2);
          var label = fmt ? fmt.format(new Date(Number(y), m - 1, 1)) : mm;
          out.push({ period: mm + '-' + y, label: label + ' ' + y });
        }
        var nowY = String(new Date().getFullYear());
        var cur = (nowY === y) ? (('0' + (new Date().getMonth() + 1)).slice(-2) + '-' + y) : out[out.length - 1].period;
        self.fdPeriods(out);
        // same KO law as the FMR page: <select options:fdPeriods> force-picks
        // January the instant the list changes — win now and on the next tick
        self.fdPeriod(cur);
        setTimeout(function () { if (self.fdPeriod() !== cur) self.fdPeriod(cur); }, 0);
      }
      self.fdYear.subscribe(rebuildFdPeriods);

      /* ── entities / sectors / chapters ─────────────────────────────── */
      self.fdEntities = ko.computed(function () { var d = self.fdData(); return (d && d.entities) || []; });
      self.fdEntName = function (code) {
        if (code === 'ALL') return self.t('fdAllUnits');
        var e = self.fdEntities().filter(function (x) { return x.code === code; })[0];
        if (e) return (self.lang() === 'ar' && e.nameAr) ? e.nameAr : (e.name || code);
        return STR['fdEnt' + code] ? self.t('fdEnt' + code) : code;
      };

      self.fdSearchSummary = ko.computed(function () {
        if (self.fdSecSearchOpen()) return '';
        var p = (self.fdPeriods() || []).filter(function (x) { return x.period === self.fdPeriod(); })[0];
        var ent = self.fdEntity();
        return [self.fdYear(), p ? p.label : '', self.fdEntName(ent)].filter(Boolean).join(' · ');
      });

      // rows in the current business-unit scope (sector filter NOT applied —
      // the cards themselves show scope totals so the reader can pick)
      /* ── approach A (v1.107.0, user): ONE request per YEAR. The response keeps
         rows[] for the anchor period AND ships series[] = the same cube for every
         loaded period of the year (m = {MM:[b,a,e,f,n]}). Any other period of the
         year is derived here (fdRowsAt) — a period switch inside the year never
         calls the server, and the ring hint sums the series under the scope. */
      var fdNameMaps = ko.computed(function () {
        var d = self.fdData(), sn = {}, cn = {};
        if (!d) return { sn: sn, cn: cn };
        (d.sectors || []).forEach(function (x) { sn[x.code] = { name: x.name, nameAr: x.nameAr }; });
        (d.costCenters || []).forEach(function (x) { cn[x.code] = x.name; });
        (d.rows || []).forEach(function (r) { if (!sn[r.sector]) sn[r.sector] = { name: r.sectorName }; if (!cn[r.costCenter]) cn[r.costCenter] = r.costCenterName; });
        return { sn: sn, cn: cn };
      });
      function fdMM(period) { return period ? String(period).slice(0, 2) : ''; }
      self.fdPeriodsLoaded = ko.computed(function () { var d = self.fdData(); return (d && d.periods) || []; });
      function fdHasPeriod(p) { return self.fdPeriodsLoaded().indexOf(p) >= 0; }
      function fdRowsAt(period) {
        var d = self.fdData(); if (!d) return [];
        if (period === d.period) return d.rows || [];
        var mm = fdMM(period), maps = fdNameMaps(), out = [];
        (d.series || []).forEach(function (x) {
          var m = x.m && x.m[mm]; if (!m) return;
          var sn = maps.sn[x.s] || {};
          out.push({ sector: x.s, sectorName: sn.name || x.s, costCenter: x.c, costCenterName: maps.cn[x.c] || x.c,
                     entity: x.e, chapter: x.ch, budget: m[0] || 0, actual: m[1] || 0, encumbrance: m[2] || 0,
                     fundsAvailable: m[3] || 0, combinations: m[4] || 0 });
        });
        return out;
      }
      self.fdCurRows = ko.computed(function () {
        var d = self.fdData(); if (!d) return [];
        var p = self.fdPeriod();
        return (p === d.period || fdHasPeriod(p)) ? fdRowsAt(p) : [];
      });
      var fdScopeRows = ko.computed(function () {
        var ent = self.fdEntity();
        return self.fdCurRows().filter(function (r) { return ent === 'ALL' || r.entity === ent; });
      });
      function fdSum(rows) {
        var o = { budget: 0, actual: 0, encumbrance: 0, fundsAvailable: 0, combinations: 0 };
        rows.forEach(function (r) {
          o.budget += r.budget || 0; o.actual += r.actual || 0; o.encumbrance += r.encumbrance || 0;
          o.fundsAvailable += r.fundsAvailable || 0; o.combinations += r.combinations || 0;
        });
        return o;
      }
      self.fdIsSel = function (code) { return self.fdSel.indexOf(code) >= 0; };
      self.fdToggleSector = function (code) {
        if (self.fdIsSel(code)) self.fdSel.remove(code); else self.fdSel.push(code);
        fdPruneDepts();
        return true;
      };
      self.fdClearSectors = function () { self.fdSel([]); fdPruneDepts(); return true; };
      self.fdSelSummary = ko.computed(function () {
        var n = self.fdSel().length;
        return n ? self.t('fdSelected').replace('{n}', n) : self.t('fdAllSectors');
      });
      self.fdSectorName = function (s) { return (self.lang() === 'ar' && s.nameAr) ? s.nameAr : s.name; };

      // sector cards: every sector of the loaded period, totals in the
      // current business-unit scope, budget-desc; a sector with nothing in
      // scope (e.g. a DCT-only sector under MSS) or with all-zero figures
      // ("Museums": 7 empty combinations) is hidden — nothing to pick
      self.fdSectors = ko.computed(function () {
        var d = self.fdData(); if (!d) return [];
        var rows = fdScopeRows(), by = {};
        rows.forEach(function (r) { (by[r.sector] = by[r.sector] || []).push(r); });
        var lov = (d.sectors || []).slice(), seen = {};
        lov.forEach(function (s) { seen[s.code] = 1; });
        Object.keys(by).forEach(function (k) { if (!seen[k]) lov.push({ code: k, name: by[k][0].sectorName || k }); });
        return lov.map(function (s) {
          var t = fdSum(by[s.code] || []);
          return { code: s.code, name: s.name, nameAr: s.nameAr, budget: t.budget, actual: t.actual,
                   encumbrance: t.encumbrance, fundsAvailable: t.fundsAvailable, has: !!by[s.code] };
        }).filter(function (s) { return s.has && (s.budget || s.actual || s.encumbrance); })
          .sort(function (a, b) { return b.budget - a.budget; });
      });
      self.fdSetEntity = function (code) {
        self.fdEntity(code);
        // drop picks that have nothing in the new scope (their card is gone)
        var codes = self.fdSectors().map(function (s) { return s.code; });
        self.fdSel(self.fdSel().filter(function (c) { return codes.indexOf(c) >= 0; }));
        fdPruneDepts();
        return true;
      };

      /* ── departments (cost centres) — second card region (user, 2026-09-03):
         the cost centres of the picked sectors (all sectors when none picked),
         scope totals, budget-desc, multi-select any-of; a text filter narrows
         the CARDS only, never the figures. A pick that no longer belongs to
         the picked sectors / business unit is dropped (fdPruneDepts). */
      self.fdCcSel = ko.observableArray([]);
      self.fdDeptQ = ko.observable('');
      self.fdIsDeptSel = function (code) { return self.fdCcSel.indexOf(code) >= 0; };
      self.fdToggleDept = function (code) {
        if (self.fdIsDeptSel(code)) self.fdCcSel.remove(code); else self.fdCcSel.push(code);
        return true;
      };
      self.fdClearDepts = function () { self.fdCcSel([]); return true; };
      var fdDeptsAll = ko.computed(function () {
        var d = self.fdData(); if (!d) return [];
        var sel = self.fdSel(), by = {};
        fdScopeRows().forEach(function (r) {
          if (!sel.length || sel.indexOf(r.sector) >= 0) (by[r.costCenter] = by[r.costCenter] || []).push(r);
        });
        var lov = (d.costCenters || []).slice(), seen = {};
        lov.forEach(function (c) { seen[c.code] = 1; });
        Object.keys(by).forEach(function (k) { if (!seen[k]) { var r0 = by[k][0]; lov.push({ code: k, name: r0.costCenterName || k, sector: r0.sector, sectorName: r0.sectorName }); } });
        return lov.map(function (c) {
          var t = fdSum(by[c.code] || []);
          return { code: c.code, name: c.name, sector: c.sector, sectorName: c.sectorName,
                   budget: t.budget, actual: t.actual, encumbrance: t.encumbrance, fundsAvailable: t.fundsAvailable, has: !!by[c.code] };
        }).filter(function (c) { return c.has && (c.budget || c.actual || c.encumbrance); })
          .sort(function (a, b) { return b.budget - a.budget; });
      });
      self.fdDepts = ko.computed(function () {
        var q = (self.fdDeptQ() || '').trim().toLowerCase();
        return fdDeptsAll().filter(function (c) { return !q || (c.code + ' ' + c.name).toLowerCase().indexOf(q) >= 0; });
      });
      self.fdDeptsTotal = ko.computed(function () { return fdDeptsAll().length; });
      function fdPruneDepts() {
        var codes = fdDeptsAll().map(function (c) { return c.code; });
        self.fdCcSel(self.fdCcSel().filter(function (c) { return codes.indexOf(c) >= 0; }));
      }
      self.fdDeptSelSummary = ko.computed(function () {
        var n = self.fdCcSel().length;
        return n ? self.t('fdSelected').replace('{n}', n) : self.t('fdAllDepts');
      });

      /* ── presentation switch (v1.105.0, user): ONE Search-region parameter
         drives BOTH regions — 'tiles' (composition cards, default) · 'rows'
         (ledger, every bar on one shared scale) · 'map' (proportional treemap,
         area = budget, fill = % consumed). Remembered in this browser
         (gl_fd_ui.layout). State pills and map heat reuse the vs-Budget
         thresholds BUD_UTIL_NEAR_PCT / BUD_UTIL_OVER_PCT, echoed by GL/db/42
         as thresholds{near,over} — no new settings. */
      self.fdLayout = ko.observable(['rows', 'tiles', 'map'].indexOf(fdUi.layout) >= 0 ? fdUi.layout : 'tiles');
      self.fdLayoutOpts = ko.computed(function () {
        return [{ v: 'tiles', l: self.t('fdLayoutTiles') }, { v: 'rows', l: self.t('fdLayoutRows') }, { v: 'map', l: self.t('fdLayoutMap') }];
      });
      self.fdNoBudget = function (scope) {
        if (self.fdLayout() !== 'map') return false;
        var rows = scope === 'sectors' ? self.fdSectors() : self.fdDepts();
        return rows.length > 0 && rows.every(function (r) { return !r.budget; });
      };
      self.fdIs = function (k, scope) { return (scope && self.fdNoBudget(scope) ? 'rows' : self.fdLayout()) === k; };
      self.fdThr = ko.computed(function () {
        var d = self.fdData(), t = (d && d.thresholds) || {};
        return { near: Number(t.near) || 90, over: Number(t.over) || 100 };
      });
      self.fdScopeBudget = ko.computed(function () { return fdSum(fdScopeRows()).budget; });
      self.fdSetLayout = function (v) { self.fdLayout(v); return true; };
      // radio option cards (v1.106.0) + the formatted reading hint for the picked one
      self.fdPresOpts = ko.computed(function () {
        return [{ v: 'tiles', l: self.t('fdLayoutTiles'), d: self.t('fdPresDescTiles') },
                { v: 'rows',  l: self.t('fdLayoutRows'),  d: self.t('fdPresDescRows') },
                { v: 'map',   l: self.t('fdLayoutMap'),   d: self.t('fdPresDescMap') }];
      });
      function fdKeyFor(k, tiles, rows, map) { return k === 'rows' ? rows : k === 'map' ? map : tiles; }
      self.fdPresHint = ko.computed(function () {
        var k = self.fdLayout(), th = self.fdThr();
        return { title: self.t(fdKeyFor(k, 'fdLayoutTiles', 'fdLayoutRows', 'fdLayoutMap')),
                 body:  self.t(fdKeyFor(k, 'fdPresHintTiles', 'fdPresHintRows', 'fdPresHintMap')),
                 state: k === 'map' ? '' : self.t('fdPresState').replace(/\{near\}/g, th.near).replace('{over}', th.over) };
      });
      // one-line reading tip inside the coloured region strips
      self.fdHintTip = ko.computed(function () { return self.t(fdKeyFor(self.fdLayout(), 'fdHintTiles', 'fdHintRows', 'fdHintMap')); });
      // explicit sort on BOTH regions (user, v1.106.0): budget amount (default, largest
      // first) · % used · % free · name; the map is always by budget — that is its area
      self.fdSortOpts = ko.computed(function () {
        return [{ v: 'budget', l: self.t('fdSortBudget') }, { v: 'used', l: self.t('fdSortUsed') },
                { v: 'free', l: self.t('fdSortFree') }, { v: 'name', l: self.t('fdSortName') }];
      });
      self.fdSecSort = ko.observable('budget');
      function fdSortList(l, k) {
        l = l.slice();
        if (k === 'used') l.sort(function (a, b) { return self.fdPct(b.actual, b.budget) - self.fdPct(a.actual, a.budget) || b.budget - a.budget; });
        else if (k === 'free') l.sort(function (a, b) { return self.fdPct(b.fundsAvailable, b.budget) - self.fdPct(a.fundsAvailable, a.budget) || b.budget - a.budget; });
        else if (k === 'name') l.sort(function (a, b) { return String(a.name || '').localeCompare(String(b.name || '')); });
        else l.sort(function (a, b) { return (Number(b.budget) || 0) - (Number(a.budget) || 0); });
        return l;
      }
      self.fdSectorsSorted = ko.computed(function () { return fdSortList(self.fdSectors(), self.fdSecSort()); });
      self.fdSectorNameOf = function (code) {
        var s = self.fdSectors().filter(function (x) { return x.code === code; })[0];
        return s ? self.fdSectorName(s) : code;
      };
      self.fdConsumed = function (r) {
        var b = Number(r.budget) || 0;
        return b ? ((Number(r.actual) || 0) + (Number(r.encumbrance) || 0)) / b * 100 : 0;
      };
      // 3-state verdict on the consumed share (Actual + Encumbrance) of budget:
      // over = fund negative or consumed > over%; tight = consumed >= near%
      self.fdState = function (r) {
        var th = self.fdThr(), c = self.fdConsumed(r);
        if ((Number(r.fundsAvailable) || 0) < 0 || c > th.over + 0.0001) return 'over';
        return c >= th.near ? 'tight' : 'ok';
      };
      self.fdStateCss = function (r) { var k = self.fdState(r); return { ok: k === 'ok', tight: k === 'tight', over: k === 'over' }; };
      self.fdStateLabel = function (r) { var k = self.fdState(r); return self.t(k === 'over' ? 'fdStOver' : k === 'tight' ? 'fdStTight' : 'fdStOk'); };
      self.fdFreeTxt = function (r) { var f = self.fdPct(r.fundsAvailable, r.budget); return (f < 0 ? '−' : '') + Math.abs(f) + '% ' + self.t('fdFree'); };
      self.fdShare = function (a, b) {
        b = Number(b) || 0; if (!b) return '0%';
        var v = (Number(a) || 0) / b * 100;
        return (v > 0 && v < 1 ? v.toFixed(1) : Math.round(v)) + '%';
      };
      // compact figure for cards / rows / map — honours "Figures in" except
      // Exact (a 10-digit figure cannot live in a 200px tile; the exact value
      // stays in the tooltip and the ledger sub-line)
      self.fdBig = function (v) { return self.buUnit() === 'X' ? self.compact(v) : self.buNum(v); };
      // composition bar segments (share of budget, clamped so they never overflow)
      self.fdSeg = function (r) {
        var b = Number(r.budget) || 0, a = 0, e = 0, f = 0;
        if (b > 0) {
          a = Math.max(0, Math.min(100, (Number(r.actual) || 0) / b * 100));
          e = Math.max(0, Math.min(100 - a, (Number(r.encumbrance) || 0) / b * 100));
          f = Math.max(0, Math.min(100 - a - e, (Number(r.fundsAvailable) || 0) / b * 100));
        }
        return { a: a + '%', e: e + '%', f: f + '%', over: (Number(r.fundsAvailable) || 0) < 0 };
      };
      self.fdTip = function (r) {
        return self.t('fdBudget') + ' ' + self.money(r.budget) + ' · ' + self.t('fdActual') + ' ' + self.money(r.actual)
             + ' · ' + self.t('fdEnc') + ' ' + self.money(r.encumbrance) + ' · ' + self.t('fdFund') + ' ' + self.money(r.fundsAvailable);
      };
      var fdMaxSector = ko.computed(function () { return Math.max.apply(null, [1].concat(self.fdSectors().map(function (s) { return s.budget; }))); });
      var fdMaxDept   = ko.computed(function () { return Math.max.apply(null, [1].concat(fdDeptsAll().map(function (c) { return c.budget; }))); });
      // ledger rows: bar length = budget on ONE shared scale (longest = largest budget in the region)
      self.fdRowW = function (r, isDept) {
        var m = isDept ? fdMaxDept() : fdMaxSector();
        return Math.max(0, Math.min(100, (Number(r.budget) || 0) / m * 100)) + '%';
      };
      self.fdSelChips = ko.computed(function () {
        var sel = self.fdSel();
        return self.fdSectors().filter(function (s) { return sel.indexOf(s.code) >= 0; });
      });

      // departments: sort (tiles) + top-N with "Show all" (rows 12 / tiles 18;
      // the map always draws every department — that is its point)
      self.fdDeptSort = ko.observable('budget');
      self.fdDeptShowAll = ko.observable(false);
      self.fdDeptTopN = ko.computed(function () { return self.fdLayout() === 'rows' ? 12 : 18; });
      self.fdDeptsSorted = ko.computed(function () { return fdSortList(self.fdDepts(), self.fdDeptSort()); });
      self.fdDeptTopTxt = ko.computed(function () {
        return (self.fdLayout() !== 'map' && !self.fdDeptShowAll() && self.fdDeptsSorted().length > self.fdDeptTopN())
          ? self.t('fdHintTop').replace('{n}', self.fdDeptTopN()) : '';
      });
      self.fdDeptsShown = ko.computed(function () {
        var l = self.fdDeptsSorted();
        return (self.fdLayout() === 'map' || self.fdDeptShowAll()) ? l : l.slice(0, self.fdDeptTopN());
      });
      self.fdDeptHasMore = ko.computed(function () { return self.fdLayout() !== 'map' && self.fdDeptsSorted().length > self.fdDeptTopN(); });
      self.fdToggleDeptAll = function () { self.fdDeptShowAll(!self.fdDeptShowAll()); return true; };
      self.fdDeptMoreTxt = ko.computed(function () {
        return self.fdDeptShowAll() ? self.t('fdShowTop').replace('{n}', self.fdDeptTopN())
                                    : self.t('fdShowAll').replace('{n}', self.fdDeptsSorted().length);
      });
      self.fdDeptCountTxt = ko.computed(function () {
        var n = self.fdCcSel().length;
        if (n) return self.t('fdSelected').replace('{n}', n);
        return self.t('fdShowing').replace('{a}', self.fdDeptsShown().length).replace('{b}', self.fdDeptsTotal());
      });
      self.fdLayout.subscribe(function () { saveFdUi(); self.fdDeptShowAll(false); setTimeout(fdMeasureAll, 30); });

      /* ── proportional map: squarified treemap, laid out in pixels from the
         measured region width (fdMeasure binding + resize); tiles are
         positioned with inset-inline-start so the map mirrors in RTL ── */
      self.fdMapW = ko.observable(1100);
      self.fdMapH = { sectors: 330, depts: 380 };
      function fdMeasureAll() {
        var el = document.querySelector('#pg-fd .fd-tm-wrap[data-measure]');
        if (el && el.clientWidth && el.clientWidth !== self.fdMapW()) self.fdMapW(el.clientWidth);
      }
      var fdRt; window.addEventListener('resize', function () { clearTimeout(fdRt); fdRt = setTimeout(fdMeasureAll, 120); });
      self.view.subscribe(function (v) { if (v === 'fd') setTimeout(fdMeasureAll, 30); });
      ko.bindingHandlers.fdMeasure = { init: function (el) { el.setAttribute('data-measure', '1'); setTimeout(fdMeasureAll, 0); } };
      function fdWorst(row, side, scale) {
        var s = 0; row.forEach(function (i) { s += i.v * scale; });
        var th = s / side, w = 0;
        row.forEach(function (i) { var len = i.v * scale / th; w = Math.max(w, th / len, len / th); });
        return w;
      }
      function fdSquarify(items, x, y, w, h) {
        var out = [], rest = items.filter(function (i) { return i.v > 0; }).sort(function (a, b) { return b.v - a.v; });
        if (!rest.length || w <= 0 || h <= 0) return out;
        var total = 0; rest.forEach(function (i) { total += i.v; });
        var scale = w * h / total, cx = x, cy = y, cw = w, ch = h;
        while (rest.length) {
          var vert = cw >= ch, side = vert ? ch : cw, row = [], best = Infinity;
          while (rest.length) {
            var cand = row.concat([rest[0]]), wr = fdWorst(cand, side, scale);
            if (wr <= best || !row.length) { row = cand; best = wr; rest.shift(); } else break;
          }
          var area = 0; row.forEach(function (i) { area += i.v * scale; });
          var th = area / side, off = 0;
          row.forEach(function (i) {
            var len = i.v * scale / th;
            out.push({ it: i.r, x: vert ? cx : cx + off, y: vert ? cy + off : cy, w: vert ? th : len, h: vert ? len : th });
            off += len;
          });
          if (vert) { cx += th; cw -= th; } else { cy += th; ch -= th; }
        }
        return out;
      }
      var FD_HEAT = ['#DCE9E3', '#9CC3B3', '#4F8A75', '#2C5044', '#9E3B33'];
      function fdHeatLo() { return Math.max(60, self.fdThr().near - 10); }
      self.fdHeatBands = ko.computed(function () {
        var th = self.fdThr(), lo = fdHeatLo();
        return [{ c: FD_HEAT[0], l: '<60%' }, { c: FD_HEAT[1], l: '60–' + lo + '%' }, { c: FD_HEAT[2], l: lo + '–' + th.near + '%' },
                { c: FD_HEAT[3], l: th.near + '–' + th.over + '%' }, { c: FD_HEAT[4], l: self.t('fdTmOver') }];
      });
      function fdHeat(r) {
        var c = self.fdConsumed(r), k = self.fdState(r);
        var i = k === 'over' ? 4 : k === 'tight' ? 3 : c >= fdHeatLo() ? 2 : c >= 60 ? 1 : 0;
        return { bg: FD_HEAT[i], dark: i >= 2 };
      }
      // treemap weights: area = budget; an item with NO budget but real
      // activity (actual / encumbrance on an unbudgeted cost centre) cannot
      // have zero area or it would vanish from the map — it gets a sliver
      // (0.6% of the largest item) and, being over committed, paints rust
      function fdMapItems(list) {
        var mx = 0; list.forEach(function (r) { mx = Math.max(mx, Number(r.budget) || 0); });
        var floor = mx * 0.006;
        return list.map(function (r) {
          var b = Number(r.budget) || 0;
          return { v: b > 0 ? b : ((r.actual || r.encumbrance) ? floor : 0), r: r };
        });
      }
      function fdTile(r, b, isDept) {
        var hh = fdHeat(r), big = b.w > 118 && b.h > 84, mid = b.w > 72 && b.h > 30;
        return { r: r, x: Math.round(b.x), y: Math.round(b.y), w: Math.round(b.w), h: Math.round(b.h), bg: hh.bg, dark: hh.dark,
                 big: big, mid: !big && mid, sub: b.h > 44, code: isDept && b.h > 100 };
      }
      self.fdSectorTiles = ko.computed(function () {
        if (self.fdLayout() !== 'map') return [];
        return fdSquarify(fdMapItems(self.fdSectors()), 0, 0, self.fdMapW(), self.fdMapH.sectors)
          .map(function (b) { return fdTile(b.it, b, false); });
      });
      self.fdDeptGroups = ko.computed(function () {
        if (self.fdLayout() !== 'map') return [];
        var by = {}, order = [];
        self.fdDeptsSorted().forEach(function (c) { if (!by[c.sector]) { by[c.sector] = []; order.push(c.sector); } by[c.sector].push(c); });
        var items = {}; order.forEach(function (k) { items[k] = fdMapItems(by[k]); });
        var groups = fdSquarify(order.map(function (k) { var v = 0; items[k].forEach(function (i) { v += i.v; }); return { v: v, r: k }; }),
                                0, 0, self.fdMapW(), self.fdMapH.depts);
        return groups.map(function (g) {
          var strip = (g.h > 46 && g.w > 60) ? 20 : 0;
          // a sliver group (e.g. Unclassified, 17x3 px) still lists every
          // department: no padding below 12 px and never a zero-size inner box
          var pad = (g.w > 12 && g.h > 12) ? 2 : 0;
          return { code: g.it, name: self.fdSectorNameOf(g.it), x: Math.round(g.x), y: Math.round(g.y), w: Math.round(g.w), h: Math.round(g.h), strip: strip,
                   tiles: fdSquarify(items[g.it], g.x + pad, g.y + strip + pad, Math.max(g.w - 2 * pad, 1), Math.max(g.h - strip - 2 * pad, 1))
                            .map(function (b) { return fdTile(b.it, b, true); }) };
        });
      });
      self.fdTileStyle = function (t) { return 'inset-inline-start:' + t.x + 'px;top:' + t.y + 'px;width:' + t.w + 'px;height:' + t.h + 'px;background:' + t.bg; };
      self.fdGrpStyle  = function (g) { return 'inset-inline-start:' + g.x + 'px;top:' + g.y + 'px;width:' + g.w + 'px;height:' + g.h + 'px'; };
      self.fdShortName = function (c) { return String(c.name || '').replace(/^(DCT|Museums|ALC)\s[-–]\s/, ''); };

      // rows after ALL filters (business unit ∩ sectors ∩ departments) — what
      // the bands, the drills and the total foot show
      self.fdRows = ko.computed(function () {
        var sel = self.fdSel(), cc = self.fdCcSel();
        return fdScopeRows().filter(function (r) {
          return (!sel.length || sel.indexOf(r.sector) >= 0) && (!cc.length || cc.indexOf(r.costCenter) >= 0);
        });
      });
      self.fdChapters = ko.computed(function () {
        var d = self.fdData(); if (!d) return [];
        var rows = self.fdRows();
        return (d.chapters || []).map(function (c) {
          var t = fdSum(rows.filter(function (r) { return r.chapter === c.code; }));
          var nm = self.t('fd' + c.code), alt = self.t('fdAlt' + c.code);
          t.code = c.code;
          t.name = (!nm || nm === 'fd' + c.code) ? c.name : nm;
          t.alt  = (!alt || alt === 'fdAlt' + c.code) ? (c.alt || '') : alt;
          return t;
        });
      });
      self.fdTotals   = ko.computed(function () { return fdSum(self.fdRows()); });
      // Total band on top of the chapter rings (v1.111.0, user): the SAME
      // scope as the chapter bands summed — code '' = no chapter predicate, so
      // its drill (/fd/lines) and its hover ladder cover Chapters 1-3 together
      self.fdTotalBand = ko.computed(function () {
        if (!self.fdChapters().length) return null;
        var t = fdSum(self.fdRows());
        t.code = ''; t.total = true; t.name = self.t('fdGrand'); t.alt = self.t('fdTotalAlt');
        return t;
      });
      self.fdExcluded = ko.computed(function () {
        var d = self.fdData(); if (!d) return null;
        var p = self.fdPeriod();
        if (p === d.period) return d.excluded || null;
        return (d.excludedByPeriod && d.excludedByPeriod[fdMM(p)]) || null;
      });
      self.fdHasData  = ko.computed(function () { return self.fdCurRows().length > 0; });

      /* ── figure helpers ─────────────────────────────────────────────── */
      self.fdPct = function (a, b) { b = Number(b) || 0; return b ? Math.round((Number(a) || 0) / b * 100) : 0; };
      self.fdBarW = function (a, b) { return Math.max(0, Math.min(100, self.fdPct(a, b))) + '%'; };
      var FD_C = 2 * Math.PI * 38;   // ring r=38 in a 92x92 viewBox
      self.fdRingDash = function (v, bud) {
        var p = (Number(bud) || 0) > 0 ? Math.max(0, Math.min(1, (Number(v) || 0) / Number(bud))) : 0;
        return (p * FD_C).toFixed(1) + ' ' + FD_C.toFixed(1);
      };
      // budget group of a band (v1.112.0): from the server's scope.budgetGroupByChapter
      // ('CH1:1|...|CH4:3|CH5:5') — never hard-coded client-side; the Total band lists every group
      self.fdBgOf = function (code) {
        var d = self.fdData(), map = {}, gs = [];
        ((d && d.scope && d.scope.budgetGroupByChapter) || '').split('|').forEach(function (kv) {
          var a = kv.split(':'); if (a[0] && a[1]) map[a[0]] = a[1];
        });
        if (code) return map[code] || '1';
        for (var k in map) if (gs.indexOf(map[k]) < 0) gs.push(map[k]);
        return gs.length ? gs.sort().join(' / ') : '1';
      };
      self.fdBudgetSubOf = function (t) {
        return self.t(t.code ? 'fdBudgetSubBg' : 'fdBudgetSubBgs').replace('{g}', self.fdBgOf(t.code));
      };
      self.fdFundSub = function (t) {
        return t.fundsAvailable < 0 ? self.t('fdOverBudget')
             : (self.fdPct(t.fundsAvailable, t.budget) + '% ' + self.t('fdRemains'));
      };

      /* sector card icons — inline SVG (stroke = currentColor, so they take
         the .fd-ico disc colour); keyed on DCT_GL_CLASS_VALUE sector codes */
      var FD_ICONS = {
        building: '<svg viewBox="0 0 24 24"><rect x="4" y="3" width="16" height="18" rx="1.5"/><path d="M9 21v-5h6v5M8 7h2M14 7h2M8 11h2M14 11h2"/></svg>',
        mask: '<svg viewBox="0 0 24 24"><path d="M4 5c2.5 1 5.5 1.5 8 1.5S17.5 6 20 5v6.5c0 4.5-3.5 8-8 8s-8-3.5-8-8Z"/><path d="M8.5 10.5c.8-.6 1.7-.6 2.5 0M13 10.5c.8-.6 1.7-.6 2.5 0M9 15c1.8 1.4 4.2 1.4 6 0"/></svg>',
        compass: '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="m15.5 8.5-2.2 5.3-5.3 2.2 2.2-5.3Z"/></svg>',
        brief: '<svg viewBox="0 0 24 24"><rect x="3" y="7" width="18" height="13" rx="2"/><path d="M9 7V5a1.5 1.5 0 0 1 1.5-1.5h3A1.5 1.5 0 0 1 15 5v2M3 12h18"/></svg>',
        mega: '<svg viewBox="0 0 24 24"><path d="M4 10v4h3l7 4V6l-7 4Z"/><path d="M17 9.5a3.5 3.5 0 0 1 0 5M8 14l1.5 5"/></svg>',
        target: '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="5"/><circle cx="12" cy="12" r="1.2"/></svg>',
        museum: '<svg viewBox="0 0 24 24"><path d="M3 9.5 12 4l9 5.5M4 10h16M6 10v8M10 10v8M14 10v8M18 10v8M3 20h18"/></svg>',
        book: '<svg viewBox="0 0 24 24"><path d="M4 5.5A2.5 2.5 0 0 1 6.5 3H20v15H6.5A2.5 2.5 0 0 0 4 20.5Z"/><path d="M4 20.5V5.5M8 7h8"/></svg>',
        shield: '<svg viewBox="0 0 24 24"><path d="M12 3 5 6v5c0 4.5 3 8 7 9.5 4-1.5 7-5 7-9.5V6Z"/><path d="m9.5 12 1.8 1.8L15 10"/></svg>',
        scale: '<svg viewBox="0 0 24 24"><path d="M12 4v16M6 20h12M5 8h14"/><path d="M5 8 3 13h4ZM19 8l-2 5h4Z"/></svg>',
        wrench: '<svg viewBox="0 0 24 24"><path d="M14.5 6.5a4 4 0 0 0 5.2 5.2L10 21.5l-3-3L16.7 8.7"/><path d="M14.5 6.5 17 4l3 3-2.5 2.5"/></svg>',
        clip: '<svg viewBox="0 0 24 24"><rect x="5" y="4" width="14" height="17" rx="2"/><path d="M9 4.5V3h6v1.5M9 10h6M9 14h6M9 18h3"/></svg>',
        lab: '<svg viewBox="0 0 24 24"><path d="M9 3h6M10 3v6l-5 9a2 2 0 0 0 1.7 3h10.6a2 2 0 0 0 1.7-3l-5-9V3"/><path d="M7.5 15h9"/></svg>',
        grid: '<svg viewBox="0 0 24 24"><rect x="4" y="4" width="7" height="7" rx="1.5"/><rect x="13" y="4" width="7" height="7" rx="1.5"/><rect x="4" y="13" width="7" height="7" rx="1.5"/><rect x="13" y="13" width="7" height="7" rx="1.5"/></svg>'
      };
      var FD_SECTOR_ICON = {
        TOURISM: 'compass', CULTURE: 'mask', SUPPORT_SERVICE: 'building', EXECUTIVE_OFFICE: 'brief',
        STRATEGIC_MARKETING_COMMUNICATION: 'mega', STRATEGIC_AFFAIRS: 'target',
        LOUVRE_ABU_DHABI: 'museum', AD_GUGGENHEIM_MUSEUM: 'museum', ZAYED_NATIONAL_MUSEUM: 'museum',
        NATURAL_HISTORY_MUSEUM: 'museum', MUSEUM_SHARED_SERVICES: 'museum', MUSEUMS: 'museum',
        TEAMLAB: 'lab', ALC: 'book', INTERNAL_AUDIT: 'shield', LEGAL_GOVERNMENT_AFFAIRS: 'scale',
        PROJECTS_MANAGEMENT_ENGINEERING: 'wrench', TENDERING_AND_PROJECTS_CONTROL: 'clip'
      };
      self.fdSectorIcon = function (code) { return FD_ICONS[FD_SECTOR_ICON[code] || 'grid']; };

      /* ── figure drill (GL/db/43 GET /fd/lines) ───────────────────────
         Every ring / the Fund square opens the SHARED drill drawer with that
         chapter's rows at full 10-segment combination grain, under the SAME
         scope the band shows (period, business unit, picked sectors) — so the
         drawer total == the figure clicked. The response's combos{} side-map
         feeds the drawer's delegated Combination popover (drillComboRow →
         fdComboMap), the same styled 10-segment hint the butil drills use. */
      var FD_METRIC_KEY = { budget: 'fdBudget', actual: 'fdActual', encumbrance: 'fdEnc', fundsavailable: 'fdFund' };
      self.fdOpenDrill = function (item, metric) {
        var ent = self.fdEntity(), sel = self.fdSel(), cc = self.fdCcSel();
        var names = self.fdSectors().filter(function (x) { return sel.indexOf(x.code) >= 0; })
                        .map(function (x) { return self.fdSectorName(x); });
        var scope = sel.length ? (names.length <= 3 ? names.join(', ') : self.t('fdDrillSectors').replace('{n}', names.length))
                               : self.t('fdAllSectors');
        if (cc.length) {
          var dn = fdDeptsAll().filter(function (x) { return cc.indexOf(x.code) >= 0; }).map(function (x) { return x.name; });
          scope += ' · ' + (dn.length <= 2 ? dn.join(', ') : self.t('fdDrillDepts').replace('{n}', dn.length));
        }
        self.drillTitle(item.name + (item.alt ? ' · ' + item.alt : '') + ' — ' + self.t(FD_METRIC_KEY[metric] || metric));
        self.drillSub(self.t('fdTitle') + ' · ' + self.fdPeriod() + ' · ' + self.fdEntName(ent) + ' · ' + scope);
        self.drillCtx('');
        self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
        self.fdTrShow(false);
        self.drillDrawer(true); self.drillLoading(true);
        api('GET', '/fd/lines' + qs({ period: self.fdPeriod(), chapter: item.code, metric: metric,
                                     entity: ent === 'ALL' ? '' : ent, sector: sel.length ? sel.join('|') : '',
                                     costcenter: cc.length ? cc.join('|') : '' }))
          .then(function (d) { fdComboMap = d.combos || {}; fillDrill(d); })
          .catch(drillFail);
        return true;
      };

      /* ── ring hint: monthly movement (Mockup 2, v1.107.0) ──────────────
         Hover a ring / the Fund square → fixed popover: one bar per loaded
         period up to the selected one, split into balance brought forward
         (pale) + the month's movement (strong; red when negative), figures at
         the right. Built from series[] under the band's OWN scope (business
         unit ∩ sectors ∩ departments) — the last row equals the ring figure. */
      self.fdShowSummary = ko.observable(false);
      self.fdTrShow = ko.observable(false);
      self.fdShowSummary.subscribe(function (show) { if (!show) self.fdTrOut(); });
      self.fdTrX = ko.observable(0); self.fdTrY = ko.observable(0);
      self.fdTrData = ko.observable(null);
      var FD_TR_IDX = { budget: 0, actual: 1, encumbrance: 2, fundsavailable: 3 };
      var FD_TR_KEY = { budget: 'fdBudget', actual: 'fdActual', encumbrance: 'fdEnc', fundsavailable: 'fdFund' };
      function fdMonthLabel(mm, y) {
        try { return new Intl.DateTimeFormat(self.lang() === 'ar' ? 'ar' : 'en', { month: 'short' }).format(new Date(Number(y), Number(mm) - 1, 1)); }
        catch (ex) { return mm; }
      }
      var FD_TR_FIELD = { budget: 'budget', actual: 'actual', encumbrance: 'encumbrance', fundsavailable: 'fundsAvailable' };
      // ONE ladder builder (v1.108.0): keep(x) picks the series keys in scope,
      // bold = the popover's subject (a chapter band, a sector, a department);
      // item (cards only) adds the 4-measure chip strip so the card's whole
      // picture rides with the ladder. Everything is summed from series[] —
      // a card hover costs no request (≈0.1 ms over the 283 keys)
      function fdTrBuild(metric, keep, bold, item) {
        var d = self.fdData(); if (!d || !d.series) return null;
        var idx = FD_TR_IDX[metric], curMM = fdMM(self.fdPeriod()), y = String(d.year);
        var per = (d.periods || []).map(fdMM).filter(function (mm) { return mm <= curMM; });
        var sums = {}; per.forEach(function (mm) { sums[mm] = 0; });
        d.series.forEach(function (x) {
          if (!keep(x)) return;
          per.forEach(function (mm) { var m = x.m[mm]; if (m) sums[mm] += (m[idx] || 0); });
        });
        var rows = [], prev = 0, maxAbs = 0;
        per.forEach(function (mm) {
          var v = sums[mm];
          rows.push({ mm: mm, label: fdMonthLabel(mm, y), ytd: v, mov: v - prev, cur: mm === curMM });
          maxAbs = Math.max(maxAbs, Math.abs(v), Math.abs(prev));
          prev = v;
        });
        // one scale for the ladder: full width = the largest YTD balance of the year so far
        rows.forEach(function (r) {
          var bf = r.ytd - r.mov, neg = r.mov < 0;
          var bfW = maxAbs ? Math.min(100, Math.abs(bf) / maxAbs * 100) : 0;
          var movW = maxAbs ? Math.min(100, Math.abs(r.mov) / maxAbs * 100) : 0;
          r.neg = neg;
          r.bfW = bfW;                                       // pale = balance brought forward
          r.movW = Math.min(movW, neg ? bfW : 100 - bfW);    // strong = the month's movement
          r.movStart = neg ? Math.max(0, bfW - r.movW) : bfW; // a decrease is drawn INSIDE the pale, in red
          r.movTxt = (r.mov >= 0 ? '+' : '−') + self.fdBig(Math.abs(r.mov));
          r.ytdTxt = self.fdBig(r.ytd) + ' ' + self.t('fdTrYtd');
        });
        var last = rows.length ? rows[rows.length - 1] : null;
        var pl = (self.fdPeriods() || []).filter(function (x) { return x.period === self.fdPeriod(); })[0];
        var metrics = item ? Object.keys(FD_TR_FIELD).map(function (k) {
          return { m: k, l: self.t(FD_TR_KEY[k]), v: self.fdBig(item[FD_TR_FIELD[k]]), on: k === metric };
        }) : null;
        return { metric: metric, chapter: bold,
                 title: self.t('fdTrTitle').replace('{m}', self.t(FD_TR_KEY[metric])),
                 sub: self.t('fdTrSub').replace('{p}', pl ? pl.label : self.fdPeriod()).replace('{v}', last ? self.fdBig(last.ytd) : '—'),
                 rows: rows, avgTxt: last && rows.length ? self.fdBig(last.ytd / rows.length) : '—', metrics: metrics };
      }
      // chapter band: business unit ∩ picked sectors ∩ picked departments (= the band's own scope)
      self.fdTrend = function (item, metric) {
        var ent = self.fdEntity(), sel = self.fdSel(), cc = self.fdCcSel();
        return fdTrBuild(metric, function (x) {
          return (!item.code || x.ch === item.code) && (ent === 'ALL' || x.e === ent)
              && (!sel.length || sel.indexOf(x.s) >= 0) && (!cc.length || cc.indexOf(x.c) >= 0);
        }, item.name + (item.alt ? ' · ' + item.alt : ''), null);
      };
      // sector card: business unit only — a sector's figure ignores the department picks (same scope as fdSectors)
      self.fdTrendSector = function (s, metric) {
        var ent = self.fdEntity();
        return fdTrBuild(metric, function (x) { return x.s === s.code && (ent === 'ALL' || x.e === ent); }, self.fdSectorName(s), s);
      };
      // department card: business unit ∩ picked sectors (same scope as fdDeptsAll)
      self.fdTrendDept = function (c, metric) {
        var ent = self.fdEntity(), sel = self.fdSel();
        return fdTrBuild(metric, function (x) {
          return x.c === c.code && (ent === 'ALL' || x.e === ent) && (!sel.length || sel.indexOf(x.s) >= 0);
        }, c.code + ' · ' + c.name, c);
      };
      function fdTrPlace(el, n, mx) {
        var r = el.getBoundingClientRect(), W = 460, H = 118 + 30 * Math.max(1, n) + (mx ? 44 : 0);
        var x = r.left, y = r.bottom + 8;
        if (x + W > window.innerWidth - 8) x = Math.max(8, window.innerWidth - 8 - W);
        if (y + H > window.innerHeight - 8) y = Math.max(8, r.top - 8 - H);
        self.fdTrX(x); self.fdTrY(y);
      }
      var fdTrEl = null, fdTrN = 0, fdTrMx = false;
      function fdTrShowAt(el, t) {
        fdTrEl = el; fdTrN = t.rows.length; fdTrMx = !!t.metrics;
        self.fdTrData(t); fdTrPlace(el, fdTrN, fdTrMx); self.fdTrShow(true);
      }
      self.fdTrOver = function (item, metric, e) {
        if (!self.fdShowSummary()) return self.fdTrOut();
        var t = self.fdTrend(item, metric); if (t) fdTrShowAt(e.currentTarget, t);
        return true;
      };
      // sector / department cards (all three presentations): entering the card
      // = Actual; a figure inside it = that measure. Always anchored on the
      // CARD (not the figure) so the popover never jumps while the pointer
      // moves across the card; the card's mouseleave hides it
      self.fdTrCard = function (kind, item, metric, e) {
        if (!self.fdShowSummary()) return self.fdTrOut();
        var el = e.currentTarget, card = (el.closest && el.closest('.fd-tile,.fd-lg-row,.fd-tm')) || el;
        var t = kind === 'dept' ? self.fdTrendDept(item, metric || 'actual') : self.fdTrendSector(item, metric || 'actual');
        if (t) fdTrShowAt(card, t);
        return true;
      };
      self.fdTrOut = function () { self.fdTrShow(false); fdTrEl = null; return true; };
      // the popover is position:fixed — keep it glued to its ring / card while the page scrolls
      window.addEventListener('scroll', function () { if (self.fdTrShow() && fdTrEl) fdTrPlace(fdTrEl, fdTrN, fdTrMx); }, true);

      // Same authenticated enqueue -> poll -> download workflow as Projects Budget Utilization.
      self.fdPrintOpen = ko.observable(false);
      self.fdPrintBusy = ko.observable(false);
      self.toggleFdPrint = function () { self.fdPrintOpen(!self.fdPrintOpen()); return true; };
      self.runFdReport = function (fmt) {
        self.fdPrintOpen(false);
        if (self.fdPrintBusy() || self.fdBusy() || self.fdError() || !self.fdHasData() || ['PDF','PPTX'].indexOf(fmt) < 0) return;
        var period = self.fdPeriod(); // freeze the request, including the download filename
        var params = { period:period, format:fmt, entity:self.fdEntity(),
          sectors:self.fdSel().join('|'), departments:self.fdCcSel().join('|'),
          presentation:self.fdLayout(), unit:self.buUnit(), lang:self.lang(),
          sector_sort:self.fdSecSort(), department_sort:self.fdDeptSort(), department_search:self.fdDeptQ() };
        self.fdPrintBusy(true);
        function failed(e) { self.fdPrintBusy(false); toast(e.message || String(e), true); }
        return api('POST', '/fd/report', params).then(function (d) {
          var runId = d.runId, tries = 0;
          toast(self.t('buBookQueued') + runId);
          function poll() {
            if (++tries > 72) { failed(new Error(self.t('buBookTimeout') + runId + ')')); return; }
            setTimeout(function () {
              api('GET', '/fd/report/' + runId).then(function (s) {
                if (s.status === 'FAILED') { failed(new Error(self.t('buBookFailed') + (s.error || ''))); return; }
                if (s.status !== 'SUCCESS' || !s.hasFile) { poll(); return; }
                fetch(API + '/fd/report/' + runId + '/file', {headers:{Authorization:'Bearer ' + TOKEN}})
                  .then(function (r) { if (!r.ok) throw new Error(self.t('fmrRepFailed') + ' (HTTP ' + r.status + ')'); return r.blob(); })
                  .then(function (b) {
                    var u = URL.createObjectURL(b), a = document.createElement('a');
                    a.href = u; a.download = 'Budget_Status_' + period + (fmt === 'PPTX' ? '.pptx' : '.pdf');
                    document.body.appendChild(a); a.click(); a.remove();
                    setTimeout(function () { URL.revokeObjectURL(u); }, 1000);
                    self.fdPrintBusy(false); toast(self.t('fmrRepReady'));
                  }).catch(failed);
              }).catch(function () { poll(); });
            }, 5000);
          }
          poll();
        }).catch(failed);
      };

      /* ── loading ────────────────────────────────────────────────────── */
      var fdRequestId = 0;
      self.runFd = function () {
        var requestId = ++fdRequestId;
        if (!self.fdPeriod()) { self.fdBusy(false); return Promise.resolve(); }
        self.fdBusy(true); self.fdError('');
        return api('GET', '/fd/status' + qs({ period: self.fdPeriod() }))
          .then(function (d) { if (requestId !== fdRequestId) return; self.fdData(d); fdPruneDepts(); self.fdBusy(false); self.fdLoaded(true); })
          .catch(function (e) { if (requestId !== fdRequestId) return; self.fdBusy(false); self.fdError((e && e.message) || String(e)); });
      };
      self.loadFd = function () {
        // default period = the Budget vs Actual page's own rule (GET
        // /actuals/filters defaultPeriod), same as the FMR tab — never the
        // browser's "today", which can run ahead of the last extract
        return api('GET', '/actuals/filters').then(function (d) {
          var per = d.defaultPeriod || (('0' + (new Date().getMonth() + 1)).slice(-2) + '-' + new Date().getFullYear());
          var want = per.slice(3);
          self.fdYear(want);
          setTimeout(function () { if (self.fdYear() !== want) self.fdYear(want); }, 0);
          rebuildFdPeriods();
          self.fdPeriod(per);
          setTimeout(function () { if (self.fdPeriod() !== per) self.fdPeriod(per); }, 0);
          return self.runFd();
        }).catch(function (e) { self.fdError((e && e.message) || String(e)); });
      };
      self.fdReset = function () { self.fdShowSummary(false); self.fdSel([]); self.fdCcSel([]); self.fdDeptQ(''); self.fdDeptShowAll(false); self.fdSecSort('budget'); self.fdDeptSort('budget'); self.fdEntity('ALL'); return self.loadFd(); };
      self.fdPeriod.subscribe(function (p) {
        if (!self.fdLoaded()) return;
        var d = self.fdData();
        // inside the loaded year = derived client-side (no request); otherwise fetch that year
        if (d && fdHasPeriod(p)) { ++fdRequestId; self.fdBusy(false); self.fdError(''); fdPruneDepts(); self.fdTrShow(false); return; }   // periods[] includes the anchor
        self.runFd();
      });
    })();

    /* ════════════════════════════════════════════════════════════════════
       FINANCIAL PERFORMANCE REPORT (FMR) — Budget Overview, Entity + Sector
       level, replicating docs/Reports/FMR/FMR_Dashboard.pdf pages 2-3 over
       GL/db/37 (/gl/fmr/entity, /gl/fmr/sector, /gl/fmr/notes). Entity/type
       classification rules and the Payroll Plan 2026 load are documented in
       that script's header — DCT/ALC/Museums/Masterpieces come from the
       ES + appropriation segments, Payroll/Opex/Capex/CWIP from chapter_code;
       an Unclassified bucket keeps unmatched budget visible instead of
       silently folding it into DCT/Other (a real ~9bn AED slice of budget
       has no COA-snapshot row yet, mostly unspent).
       ════════════════════════════════════════════════════════════════════ */
    (function () {
      self.fmrLoaded = ko.observable(false);
      self.fmrBusy   = ko.observable(false);
      self.fmrError  = ko.observable('');

      var FMR_ENT_KEY = { DCT: 'fmrEntDct', ALC: 'fmrEntAlc', MUSEUMS: 'fmrEntMuseums',
                           MASTERPIECES: 'fmrEntMasterpieces', UNCLASSIFIED: 'fmrEntUnclassified' };
      self.fmrEntName = function (code) {
        var k = FMR_ENT_KEY[code]; if (k) return self.t(k);
        var e = (self.fmrEntities() || []).filter(function (x) { return x.code === code; })[0];
        return e ? (e.name || code) : code;
      };

      /* entity gauge icons (2026-09-02, user: "professional icons to gauge") —
         inline SVG so they inherit the brand color from the .sp-gauge-ico disc */
      var FMR_ENT_ICONS = {
        DCT: '<svg viewBox="0 0 24 24"><path d="M12 2 3.5 5.5v2h17v-2L12 2zm-6.5 7v8.5H4V21h16v-3.5h-1.5V9h-3v8.5h-2V9h-3v8.5h-2V9h-3z"/></svg>',
        ALC: '<svg viewBox="0 0 24 24"><path d="M12 5.4C10.5 4.35 8.45 3.9 6.5 3.9c-1.75 0-3.6.35-5 1.2v13.9c1.4-.85 3.25-1.2 5-1.2 1.95 0 4 .45 5.5 1.5 1.5-1.05 3.55-1.5 5.5-1.5 1.75 0 3.6.35 5 1.2V5.1c-1.4-.85-3.25-1.2-5-1.2-1.95 0-4 .45-5.5 1.5zm9 11.25c-1.1-.35-2.3-.55-3.5-.55-1.7 0-3.35.3-4.5.95V7.1c1.15-.65 2.8-.95 4.5-.95 1.2 0 2.4.2 3.5.55v9.95z"/></svg>',
        MUSEUMS: '<svg viewBox="0 0 24 24"><path d="M12 1.5 2 6.5V8h20V6.5l-10-5zM4 9.5v8H2.75V21h18.5v-3.5H20v-8h-2.6v8h-2.9v-8h-2.6v8H9v-8H6.5v8H4v-8z"/></svg>',
        MASTERPIECES: '<svg viewBox="0 0 24 24"><path d="M3 3h18v18H3V3zm2 2v14h14V5H5zm3.4 3.6a1.7 1.7 0 1 1 0 3.4 1.7 1.7 0 0 1 0-3.4zM6.6 17.2l3.7-4.8 2.5 3.1 3.4-4.4 1.2 1.5V17.2H6.6z"/></svg>'
      };
      self.fmrEntIcon = function (code) { return FMR_ENT_ICONS[code] || FMR_ENT_ICONS.DCT; };

      /* Generate Report dropdown — PDF / Excel / PowerPoint via GL_FMR_REPORT
         (GL/db/41 bridge + reporting/db/40 definition), the butil .gen pattern */
      self.fmrGenOpen = ko.observable(false);
      self.fmrGenBusy = ko.observable(false);
      self.toggleFmrGen = function () { self.fmrGenOpen(!self.fmrGenOpen()); return true; };
      self.closeFmrGen = function () { self.fmrGenOpen(false); return true; };
      function fmrReportDownload(runId, fmt) {
        var ext = fmt === 'PPTX' ? '.pptx' : (fmt === 'XLSX' ? '.xlsx' : '.pdf');
        return fetch(API + '/fmr/report/' + runId + '/file',
                     { headers: { 'Authorization': 'Bearer ' + TOKEN } })
          .then(function (r) {
            if (!r.ok) { throw new Error(self.t('fmrRepFailed') + ' (HTTP ' + r.status + ')'); }
            return r.blob();
          })
          .then(function (b) {
            var u = URL.createObjectURL(b);
            var a = document.createElement('a');
            a.href = u;
            a.download = 'Financial_Performance_Report_' + (self.fmrPeriod() || '') + ext;
            a.click(); URL.revokeObjectURL(u);
          });
      }
      self.runFmrReport = function (fmt) {
        if (self.fmrGenBusy()) return;
        if (!self.fmrPeriod()) { toast(self.t('cmtPeriodL'), true); return; }
        self.fmrGenBusy(true);
        api('POST', '/fmr/report', { period: self.fmrPeriod(), format: fmt }).then(function (d) {
          var runId = d.runId;
          toast(self.t('buBookQueued') + runId);
          var tries = 0;
          (function poll() {
            if (++tries > 60) {
              self.fmrGenBusy(false);
              toast(self.t('buBookTimeout') + runId + ')', true);
              return;
            }
            setTimeout(function () {
              api('GET', '/fmr/report/' + runId).then(function (s) {
                if (s.status === 'SUCCESS' && s.hasFile) {
                  fmrReportDownload(runId, fmt)
                    .then(function () { self.fmrGenBusy(false); toast(self.t('fmrRepReady')); })
                    .catch(function (e) { self.fmrGenBusy(false); toast(e.message, true); });
                } else if (s.status === 'FAILED') {
                  self.fmrGenBusy(false);
                  toast(self.t('buBookFailed') + (s.error || ''), true);
                } else { poll(); }
              }).catch(function () { poll(); });
            }, 5000);
          })();
        }).catch(function (e) { self.fmrGenBusy(false); toast(e.message || String(e), true); });
      };

      /* collapsible Search region — same pattern as Budget Utilization's
         own bu-sec/toggleBuSec (own localStorage key, this page's Year+
         Period aren't part of gl_bu_ui). */
      var fmrUi = {};
      try { fmrUi = JSON.parse(localStorage.getItem('gl_fmr_ui') || '{}'); } catch (ex) { fmrUi = {}; }
      self.fmrSecSearchOpen = ko.observable(fmrUi.search !== false);
      self.toggleFmrSec = function () {
        self.fmrSecSearchOpen(!self.fmrSecSearchOpen());
        localStorage.setItem('gl_fmr_ui', JSON.stringify({ search: self.fmrSecSearchOpen() }));
        return true;
      };
      self.fmrSearchSummary = ko.computed(function () {
        if (self.fmrSecSearchOpen()) return '';
        var p = (self.fmrPeriods() || []).filter(function (x) { return x.period === self.fmrPeriod(); })[0];
        return [self.fmrYear(), p ? p.label : ''].filter(Boolean).join(' · ');
      });
      self.fmrReset = function () { self.loadFmr(); };

      self.fmrYears = ko.observableArray((function () {
        var y = new Date().getFullYear(), out = [];
        for (var i = y - 2; i <= y + 1; i++) out.push(String(i));
        return out;
      })());
      self.fmrYear   = ko.observable('');
      self.fmrPeriods = ko.observableArray([]);
      self.fmrPeriod  = ko.observable('');

      self.fmrEntityData  = ko.observable(null);
      self.fmrSectorsRaw  = ko.observableArray([]);
      self.fmrNotesRaw    = ko.observableArray([]);

      self.fmrOverall  = ko.computed(function () { var d = self.fmrEntityData(); return (d && d.overall) || {}; });
      self.fmrEntities = ko.computed(function () { var d = self.fmrEntityData(); return (d && d.entities) || []; });
      self.fmrTrend    = ko.computed(function () { var d = self.fmrEntityData(); return (d && d.trend) || []; });

      self.fmrTrendMax = ko.computed(function () {
        var m = 0;
        self.fmrTrend().forEach(function (t) { m = Math.max(m, t.budget || 0, t.actual || 0, t.plan || 0); });
        return m || 1;
      });
      self.fmrBarH = function (v) { return Math.max(0, (v || 0) * 100 / self.fmrTrendMax()) + '%'; };

      /* build the MM-YYYY period list for the picked year (reuses the same
         12-month + "current" idea as the rest of GL — no server round trip
         needed since any MM-YYYY is a valid period param) */
      function rebuildFmrPeriods() {
        var y = self.fmrYear(); if (!y) { self.fmrPeriods([]); return; }
        var fmt;
        try { fmt = new Intl.DateTimeFormat(self.lang() === 'ar' ? 'ar' : 'en', { month: 'short' }); } catch (ex) { fmt = null; }
        var out = [];
        for (var m = 1; m <= 12; m++) {
          var mm = ('0' + m).slice(-2);
          var label = fmt ? fmt.format(new Date(Number(y), m - 1, 1)) : mm;
          out.push({ period: mm + '-' + y, label: label + ' ' + y });
        }
        var nowY = String(new Date().getFullYear());
        var cur = (nowY === y) ? (('0' + (new Date().getMonth() + 1)).slice(-2) + '-' + y) : out[out.length - 1].period;
        self.fmrPeriods(out);
        // the <select options:fmrPeriods, value:fmrPeriod> binding force-picks
        // its FIRST option (January) the instant fmrPeriods changes, clobbering
        // whatever this function is about to set — a same-year guard can't
        // tell that apart from a deliberate pick, so just always win, twice
        // (once now, once next tick after the select's own write-back).
        self.fmrPeriod(cur);
        setTimeout(function () { if (self.fmrPeriod() !== cur) self.fmrPeriod(cur); }, 0);
      }
      self.fmrYear.subscribe(rebuildFmrPeriods);

      // entity filter for the Sector-level table (Select all = empty selection)
      self.fmrSectorEntitySel = ko.observableArray([]);
      self.fmrEntityFilterOpts = [
        { code: 'DCT' }, { code: 'ALC' }, { code: 'MUSEUMS' }, { code: 'MASTERPIECES' }, { code: 'UNCLASSIFIED' }
      ];
      self.fmrToggleEntityFilter = function (code) {
        var i = self.fmrSectorEntitySel.indexOf(code);
        if (i >= 0) self.fmrSectorEntitySel.splice(i, 1); else self.fmrSectorEntitySel.push(code);
      };
      self.fmrSectorEntitySel.subscribe(function () { runFmrSectors(); });

      self.fmrSectors = ko.computed(function () { return self.fmrSectorsRaw(); });

      function fmrNoteOf(typ) {
        return (self.fmrNotesRaw() || []).filter(function (n) { return n.noteType === typ; })[0] || null;
      }
      self.fmrNoteCurrentText = ko.observable('');
      self.fmrNoteExpectedText = ko.observable('');
      self.fmrNoteCurrentMeta = ko.computed(function () {
        var n = fmrNoteOf('CURRENT_VARIANCE');
        return (n && n.updatedBy) ? self.t('fmrNoteUpdated').replace('{by}', n.updatedBy).replace('{at}', n.updatedAt) : '';
      });
      self.fmrNoteExpectedMeta = ko.computed(function () {
        var n = fmrNoteOf('EXPECTED_VARIANCE');
        return (n && n.updatedBy) ? self.t('fmrNoteUpdated').replace('{by}', n.updatedBy).replace('{at}', n.updatedAt) : '';
      });

      function runFmrEntity() {
        return api('GET', '/fmr/entity' + qs({ period: self.fmrPeriod() })).then(function (d) {
          self.fmrEntityData(d);
        });
      }
      function runFmrSectors() {
        var sel = self.fmrSectorEntitySel();
        return api('GET', '/fmr/sector' + qs({ period: self.fmrPeriod(), entity: sel.length ? sel.join('|') : '' }))
          .then(function (d) { self.fmrSectorsRaw(d.sectors || []); });
      }
      function runFmrNotes() {
        return api('GET', '/fmr/notes' + qs({ period: self.fmrPeriod() })).then(function (d) {
          self.fmrNotesRaw(d.items || []);
          var c = fmrNoteOf('CURRENT_VARIANCE'), e = fmrNoteOf('EXPECTED_VARIANCE');
          self.fmrNoteCurrentText(c ? c.text : '');
          self.fmrNoteExpectedText(e ? e.text : '');
        });
      }
      self.runFmr = function () {
        self.fmrBusy(true); self.fmrError('');
        return Promise.all([runFmrEntity(), runFmrSectors(), runFmrNotes()])
          .then(function () { self.fmrBusy(false); self.fmrLoaded(true); })
          .catch(function (e) { self.fmrBusy(false); self.fmrError((e && e.message) || String(e)); });
      };
      self.loadFmr = function () {
        // the <select options:fmrYears, value:fmrYear> binding force-selects
        // its FIRST option (2 years ago) the moment it initialises if the
        // bound observable is still '' — same KO law as cfTplYear/buType:
        // set the real default here (page-open time, after that binding has
        // already fired) and re-assert once more on the next tick in case a
        // later re-render repeats it. The default PERIOD mirrors the Budget
        // vs Actual page's own rule (GET /actuals/filters defaultPeriod =
        // current calendar month if it has data, else the latest loaded
        // period) rather than blindly picking "this month", which can be
        // ahead of the last extract.
        return api('GET', '/actuals/filters').then(function (d) {
          var per = d.defaultPeriod || (('0' + (new Date().getMonth() + 1)).slice(-2) + '-' + new Date().getFullYear());
          var want = per.slice(3);
          self.fmrYear(want);
          setTimeout(function () { if (self.fmrYear() !== want) self.fmrYear(want); }, 0);
          rebuildFmrPeriods();
          self.fmrPeriod(per);
          setTimeout(function () { if (self.fmrPeriod() !== per) self.fmrPeriod(per); }, 0);
          return self.runFmr();
        });
      };
      self.fmrPeriod.subscribe(function () { if (self.fmrLoaded()) self.runFmr(); });

      self.fmrSaveNote = function (noteType) {
        var text = noteType === 'CURRENT_VARIANCE' ? self.fmrNoteCurrentText() : self.fmrNoteExpectedText();
        api('PUT', '/fmr/notes', { period: self.fmrPeriod(), noteType: noteType, text: text })
          .then(function () { toast(self.t('saved') || 'Saved'); runFmrNotes(); })
          .catch(function (e) { toast(e.message, true); });
      };

      // Sector row "Comments" — opens the SAME SECTOR-level thread the
      // Budget Utilization page uses (db/v2/125), so a note left here shows
      // up there too and vice versa; no separate comment store for this page.
      self.fmrOpenSectorComments = function (row) {
        self.openCmt({ level: 'SECTOR', year: self.fmrYear(), period: self.fmrPeriod() || '',
          ekey: row.code || '', name: row.name || '',
          title: self.t('fmrSectorTbl') + ' — ' + (row.name || ''), sub: '' });
      };

      // YTD Trend bar (Budget/Actual/Plan × Payroll/Opex/Capex) -> its
      // supporting lines, in the SAME shared drill drawer every other GL
      // page already uses (drillCols/drillRows/fillDrill from GL/db/37's
      // GET /fmr/trend/lines, which returns the generic {columns,rows,
      // total,count} shape those observables already expect) -- no new UI.
      var FMR_TREND_CHAPTER = { PAYROLL: 'CH1', OPEX: 'CH2', CAPEX: 'CH3' };
      var FMR_METRIC_LABEL = { budget: 'spBudget', actual: 'spActual', plan: 'fmrYtdPlan' };
      self.fmrOpenTrendDrill = function (item, metric) {
        self.drillTitle(item.name + ' — ' + self.t(FMR_METRIC_LABEL[metric] || metric));
        self.drillSub(self.t('fmrTrend') + ' · ' + self.fmrPeriod());
        self.drillCtx('');
        self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
        self.drillDrawer(true); self.drillLoading(true);
        api('GET', '/fmr/trend/lines' + qs({ period: self.fmrPeriod(), chapter: FMR_TREND_CHAPTER[item.type], metric: metric }))
          .then(function (d) { fmrComboMap = d.combos || {}; fillDrill(d); })
          .catch(drillFail);
      };

      /* Entity-level KPI tiles (Budget/Actual/YTD Plan/Actual vs Plan %/
         Funds Available) -> the SAME /fmr/trend/lines endpoint, called with
         NEITHER chapter NOR entity (the KPI band's own scope is the grand
         total across every chapter and every entity) so every drill reads
         chapter-then-account across the whole entity level. "Actual vs Plan
         %" has no lines of its own -- it opens the Plan side of the ratio
         (Actual already has its own tile). */
      var FMR_KPI_METRIC = { budget: 'budget', actual: 'actual', plan: 'plan', actualvsplan: 'plan', fundsavailable: 'fundsavailable' };
      var FMR_KPI_LABEL  = { budget: 'spBudget', actual: 'spActual', plan: 'fmrYtdPlan', actualvsplan: 'spActVsPlanPct', fundsavailable: 'spFundsAvail' };
      self.fmrOpenKpiDrill = function (kpi) {
        self.drillTitle(self.t(FMR_KPI_LABEL[kpi] || kpi) + ' — ' + self.t('fmrEntityLevel'));
        self.drillSub(self.t('fmrTrend') + ' · ' + self.fmrPeriod());
        self.drillCtx('');
        self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
        self.drillDrawer(true); self.drillLoading(true);
        api('GET', '/fmr/trend/lines' + qs({ period: self.fmrPeriod(), metric: FMR_KPI_METRIC[kpi] || kpi }))
          .then(function (d) { fmrComboMap = d.combos || {}; fillDrill(d); })
          .catch(drillFail);
      };
    })();

    /* ════════════════════════════════════════════════════════════════════
       GENERATE AND SEND — scoped Budget Utilization reports emailed to the
       predefined To/Cc/Bcc lists (GL/db/27 + reporting/db/39). Level menu →
       tree-select drawer → recipient confirmation → batch send + live poll.
       TEST MODE (EMAIL_TEST_MODE, ships ON): everything goes to the test
       mailbox only — the confirmation view shouts it in amber.
       ════════════════════════════════════════════════════════════════════ */
    self.gsMenuOpen = ko.observable(false);
    self.toggleGsMenu = function () { self.gsMenuOpen(!self.gsMenuOpen()); return true; };
    self.closeGsMenu = function () { self.gsMenuOpen(false); return true; };

    self.gsDrawer  = ko.observable(false);
    self.gsStep    = ko.observable(1);            // 1 pick · 2 confirm · 3 progress
    self.gsLevel   = ko.observable('SECTOR');
    self.gsBusy    = ko.observable(false);        // tree / preview loading
    self.gsNodes   = ko.observableArray([]);      // normalized tree for <tree-select>
    self.gsPicked  = ko.observableArray([]);      // leaf keys ticked in the tree
    self.gsChosen  = ko.observableArray([]);      // right-hand list [{key,label,sub}]
    self.gsFmtPdf  = ko.observable(true);
    self.gsFmtXlsx = ko.observable(false);
    self.gsPreview = ko.observable(null);         // {emailEnabled,testMode,testTo,items[]}
    self.gsSendBusy = ko.observable(false);
    self.gsBatch   = ko.observable(null);         // last batch poll payload
    var gsMap = {};                               // leaf key -> node payload
    var gsPollTimer = null;

    self.gsLevelLabel = ko.computed(function () {
      var l = self.gsLevel();
      return self.t(l === 'SECTOR' ? 'gsLvlSector' : l === 'DEPARTMENT' ? 'gsLvlDept' : 'gsLvlProject');
    });

    function gsNormalize(level, sectors) {
      gsMap = {};
      return (sectors || []).map(function (s) {
        if (level === 'SECTOR') {
          var sk = 'S|' + s.sector;
          gsMap[sk] = { sector: s.sector, label: s.sector };
          return { key: sk, label: s.sector, has: s.hasRecipients !== false };
        }
        return {
          key: 'G|' + s.sector, label: s.sector,
          children: (s.children || []).map(function (c) {
            var lbl = c.department || c.costCenter;
            if (level === 'DEPARTMENT') {
              var ck = 'C|' + c.costCenter;
              gsMap[ck] = { costcenter: c.costCenter, label: lbl, sub: c.costCenter };
              return { key: ck, label: lbl, sub: c.costCenter, has: c.hasRecipients !== false };
            }
            return {
              key: 'GC|' + c.costCenter, label: lbl, sub: c.costCenter,
              has: c.hasRecipients !== false,
              children: (c.children || []).map(function (p) {
                var pk = 'P|' + c.costCenter + '|' + p.project;
                gsMap[pk] = { costcenter: c.costCenter, project: p.project,
                              label: p.project + (p.projectName ? ' — ' + p.projectName : ''),
                              sub: lbl };
                return { key: pk, label: p.project, sub: p.projectName || '',
                         has: c.hasRecipients !== false };
              })
            };
          })
        };
      });
    }

    self.openGs = function (level) {
      self.gsMenuOpen(false);
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      self.gsLevel(level); self.gsStep(1);
      self.gsPicked([]); self.gsChosen([]); self.gsPreview(null); self.gsBatch(null);
      self.gsDrawer(true); self.gsBusy(true); self.gsNodes([]);
      api('GET', '/butil/dist/meta/tree?level=' + level + '&year=' + encodeURIComponent(self.buYear()))
        .then(function (d) { self.gsNodes(gsNormalize(level, d.sectors)); })
        .catch(fail)
        .then(function () { self.gsBusy(false); });
    };
    self.closeGs = function () {
      if (gsPollTimer) { clearTimeout(gsPollTimer); gsPollTimer = null; }
      self.gsDrawer(false);
    };

    self.gsAdd = function () {
      var have = {};
      self.gsChosen().forEach(function (c) { have[c.key] = 1; });
      var added = 0;
      self.gsPicked().forEach(function (k) {
        var p = gsMap[k];
        if (p && !have[k]) { self.gsChosen.push({ key: k, label: p.label, sub: p.sub || '' }); added++; }
      });
      if (!added) toast(self.t('gsNone'), true);
    };
    self.gsRemove = function (item) {
      self.gsChosen.remove(item);
      self.gsPicked(self.gsPicked().filter(function (k) { return k !== item.key; }));
    };

    function gsNodesPayload() {
      return self.gsChosen().map(function (c) {
        var p = gsMap[c.key] || {};
        return { sector: p.sector || null, costcenter: p.costcenter || null,
                 project: p.project || null, label: p.label || c.label };
      });
    }
    self.gsCriteria = function () {
      return {
        year: Number(self.buYear()), period: self.buPeriod() || null,
        bu: self.buBuParam(), chapter: self.buChapterParam() || null,
        projecttype: self.buType() || null, task: self.buTask() || null,
        etype: self.buEtype() || null, search: self.buSearch() || null,
        ovr: self.buOvr() ? 'Y' : null,
        cmtmode: self.buCmtDisp && self.buCmtDisp() !== 'NONE' ? self.buCmtDisp() : null
      };
    };
    self.gsCriteriaTxt = ko.computed(function () {
      if (!self.gsDrawer()) return '';
      var bits = [self.buYear()];
      if (self.buPeriod()) bits.push('YTD ' + self.buPeriod()); else bits.push(self.t('gsFullYear'));
      if (self.buType && self.buType()) bits.push(self.buType());
      return bits.join(' · ');
    });

    self.gsNext = function () {
      if (!self.gsChosen().length) { toast(self.t('gsNone'), true); return; }
      if (!self.gsFmtPdf() && !self.gsFmtXlsx()) { toast(self.t('gsFormats'), true); return; }
      self.gsBusy(true);
      api('POST', '/butil/dist/meta/preview',
          { level: self.gsLevel(), nodes: gsNodesPayload() })
        .then(function (d) { self.gsPreview(d); self.gsStep(2); })
        .catch(fail)
        .then(function () { self.gsBusy(false); });
    };

    self.gsRunsPlanned = ko.computed(function () {
      var p = self.gsPreview();
      if (!p) return 0;
      var found = (p.items || []).filter(function (i) { return i.found; }).length;
      return found * ((self.gsFmtPdf() ? 1 : 0) + (self.gsFmtXlsx() ? 1 : 0));
    });

    function gsPoll(batchId, tries) {
      gsPollTimer = setTimeout(function () {
        api('GET', '/butil/dist/batch/' + batchId).then(function (d) {
          self.gsBatch(d);
          var open = (d.runs || []).some(function (r) {
            return r.status !== 'SUCCESS' && r.status !== 'FAILED';
          });
          if (open && tries < 240) gsPoll(batchId, tries + 1);
          else self.gsSendBusy(false);
        }).catch(function () {
          if (tries < 240) gsPoll(batchId, tries + 1); else self.gsSendBusy(false);
        });
      }, 5000);
    }

    self.gsSendGo = function () {
      if (self.gsSendBusy()) return;
      var formats = [];
      if (self.gsFmtPdf()) formats.push('PDF');
      if (self.gsFmtXlsx()) formats.push('XLSX');
      self.gsSendBusy(true);
      api('POST', '/butil/dist/meta/send',
          { level: self.gsLevel(), formats: formats,
            criteria: self.gsCriteria(), nodes: gsNodesPayload() })
        .then(function (d) {
          self.gsStep(3);
          self.gsBatch({ batchId: d.batchId, runs: [] });
          gsPoll(d.batchId, 0);
        })
        .catch(function (e) { self.gsSendBusy(false); fail(e); });
    };
    self.gsAllDone = ko.computed(function () {
      var b = self.gsBatch();
      if (!b || !(b.runs || []).length) return false;
      return b.runs.every(function (r) { return r.status === 'SUCCESS' || r.status === 'FAILED'; });
    });
    self.gsRunTone = function (r) {
      return r.status === 'SUCCESS' ? (r.failedCount > 0 ? 'warn' : 'ok')
           : r.status === 'FAILED' ? 'err' : 'info';
    };

    /* ── Email Logs page ─────────────────────────────────────────────── */
    self.elLoaded = ko.observable(false);
    self.elBusy   = ko.observable(false);
    self.elRows   = ko.observableArray([]);
    self.elCount  = ko.observable(0);
    self.elFrom = ko.observable(''); self.elTo = ko.observable('');
    self.elLevel = ko.observable(''); self.elSector = ko.observable('');
    self.elCc = ko.observable(''); self.elProject = ko.observable('');
    self.elRecipient = ko.observable(''); self.elStatus = ko.observable('');
    self.elEmailStatus = ko.observable(''); self.elTest = ko.observable('');
    self.elReport = ko.observable(''); self.elBatch = ko.observable('');
    self.elRun = function () {
      self.elBusy(true);
      api('GET', '/butil/emails' + qs({
        datefrom: self.elFrom(), dateto: self.elTo(), level: self.elLevel(),
        sector: self.elSector(), costcenter: self.elCc(), project: self.elProject(),
        recipient: self.elRecipient(), status: self.elStatus(),
        emailstatus: self.elEmailStatus(), istest: self.elTest(),
        report: self.elReport(), batch: self.elBatch()
      })).then(function (d) {
        self.elRows(d.items || []); self.elCount(d.count || 0); self.elLoaded(true);
      }).catch(fail).then(function () { self.elBusy(false); });
    };
    self.elClear = function () {
      ['elFrom','elTo','elLevel','elSector','elCc','elProject','elRecipient',
       'elStatus','elEmailStatus','elTest','elReport','elBatch']
        .forEach(function (k) { self[k](''); });
      self.elRun();
    };
    self.elDrawer = ko.observable(false);
    self.elDetail = ko.observable(null);
    self.elDetailBusy = ko.observable(false);
    self.elDrill = function (row) {
      self.elDrawer(true); self.elDetailBusy(true); self.elDetail(null);
      api('GET', '/butil/emails/' + row.runId)
        .then(function (d) { self.elDetail(d); })
        .catch(fail).then(function () { self.elDetailBusy(false); });
    };
    self.elDownload = function (file) {
      var d = self.elDetail(); if (!d) return;
      var path = d.report === 'BUDGET_UTIL_REGISTER'
        ? '/butil/xlsx/' + d.runId + '/file'
        : (file.format === 'PPTX' ? '/butil/ppt/' + d.runId + '/file'
                                  : '/butil/book/' + d.runId + '/pdf');
      fetch(API + path, { headers: { 'Authorization': 'Bearer ' + TOKEN } })
        .then(function (r) { if (!r.ok) throw new Error('Download failed (HTTP ' + r.status + ')'); return r.blob(); })
        .then(function (b) {
          var u = URL.createObjectURL(b), a = document.createElement('a');
          a.href = u; a.download = file.fileName || ('report.' + (file.format || 'pdf').toLowerCase());
          a.click(); URL.revokeObjectURL(u);
        }).catch(function (e) { toast(e.message, true); });
    };
    self.elTone = function (r) {
      return r.status === 'SUCCESS' ? (r.failedCount > 0 ? 'warn' : 'ok')
           : r.status === 'FAILED' ? 'err' : 'info';
    };

    /* ── Revenue Categories (Settings) ─────────────────────────────── */
    self.rcLoaded = ko.observable(false); self.rcBusy = ko.observable(false);
    self.rcCanManage = ko.observable(false); self.rcTab = ko.observable('categories');
    self.rcSearch = ko.observable(''); self.rcCategories = ko.observableArray([]);
    self.rcRules = ko.observableArray([]); self.rcAccess = ko.observableArray([]);
    self.rcRoles = ko.observableArray([]); self.rcUsers = ko.observableArray([]);
    self.rcName = function(c){ return self.lang()==='ar' && c.nameAr ? c.nameAr : c.nameEn; };
    self.rcPath = function(c){ return (c.parentName ? c.parentName+' › ' : '') + self.rcName(c); };
    self.rcSourceLabel = function(s){ return s==='AR_TRANSACTION'?'AR Transaction':(s==='MISC_RECEIPT'?'Misc. Receipt':'Both'); };
    self.rcActiveCount = ko.computed(function(){ return self.rcCategories().filter(function(c){return c.active==='Y';}).length; });
    self.rcMainCount = ko.computed(function(){ return self.rcCategories().filter(function(c){return c.level==='MAIN';}).length; });
    self.rcSubCount = ko.computed(function(){ return self.rcCategories().filter(function(c){return c.level==='SUB';}).length; });
    self.rcMainCategories = ko.computed(function(){ return self.rcCategories().filter(function(c){return c.level==='MAIN'&&c.active==='Y';}); });
    self.rcSubCategories = ko.computed(function(){ return self.rcCategories().filter(function(c){return c.level==='SUB'&&c.active==='Y';}); });
    function rcMatch(row){ var q=self.rcSearch().trim().toLowerCase(); return !q||JSON.stringify(row).toLowerCase().indexOf(q)>=0; }
    self.rcFilteredCategories=ko.computed(function(){return self.rcCategories().filter(rcMatch);});
    self.rcFilteredRules=ko.computed(function(){return self.rcRules().filter(rcMatch);});
    self.rcFilteredAccess=ko.computed(function(){return self.rcAccess().filter(rcMatch);});
    self.rcLoad=function(){self.rcBusy(true);return api('GET','/revenue-categories').then(function(d){self.rcCanManage(d.canManage==='Y');self.rcCategories(d.categories||[]);self.rcRules(d.rules||[]);self.rcAccess(d.access||[]);self.rcRoles(d.roles||[]);self.rcUsers(d.users||[]);self.rcLoaded(true);}).catch(fail).then(function(){self.rcBusy(false);});};

    self.rcCategoryModal=ko.observable(false); self.rcCatId=ko.observable(null);
    self.rcCatLevel=ko.observable('MAIN');self.rcCatParent=ko.observable(null);self.rcCatCode=ko.observable('');
    self.rcCatNameEn=ko.observable('');self.rcCatNameAr=ko.observable('');self.rcCatSource=ko.observable('AR_TRANSACTION');
    self.rcCatPriority=ko.observable(100);self.rcCatActive=ko.observable('Y');self.rcCatDescription=ko.observable('');self.rcCatCreatedBy=ko.observable('');self.rcCatCreatedOn=ko.observable('');self.rcCatUpdatedBy=ko.observable('');self.rcCatUpdatedOn=ko.observable('');
    self.rcEditCategory=function(c){if(!self.rcCanManage())return;self.rcCatId(c.categoryId);self.rcCatLevel(c.level);self.rcCatParent(c.parentId);self.rcCatCode(c.code);self.rcCatNameEn(c.nameEn);self.rcCatNameAr(c.nameAr||'');self.rcCatSource(c.source);self.rcCatPriority(c.priority);self.rcCatActive(c.active);self.rcCatDescription(c.description||'');self.rcCatCreatedBy(c.createdBy||'');self.rcCatCreatedOn(c.createdOn||'');self.rcCatUpdatedBy(c.updatedBy||'');self.rcCatUpdatedOn(c.updatedOn||'');self.rcCategoryModal(true);};
    self.rcNewCategory=function(){self.rcCatId(null);self.rcCatLevel('MAIN');self.rcCatParent(null);self.rcCatCode('');self.rcCatNameEn('');self.rcCatNameAr('');self.rcCatSource('AR_TRANSACTION');self.rcCatPriority(100);self.rcCatActive('Y');self.rcCatDescription('');self.rcCatCreatedBy('');self.rcCatCreatedOn('');self.rcCatUpdatedBy('');self.rcCatUpdatedOn('');self.rcCategoryModal(true);};
    self.rcSaveCategory=function(){var b={level:self.rcCatLevel(),parentId:self.rcCatLevel()==='SUB'?Number(self.rcCatParent()):null,code:self.rcCatCode().trim(),nameEn:self.rcCatNameEn().trim(),nameAr:self.rcCatNameAr().trim()||null,source:self.rcCatSource(),priority:Number(self.rcCatPriority())||100,active:self.rcCatActive(),description:self.rcCatDescription().trim()||null};if(!b.code||!b.nameEn||(b.level==='SUB'&&!b.parentId)){toast(self.t('required'),true);return;}var req=self.rcCatId()?api('PUT','/revenue-categories/'+self.rcCatId(),b):api('POST','/revenue-categories',b);req.then(function(){self.rcCategoryModal(false);toast(self.t('saved'));self.rcLoad();}).catch(fail);};
    self.rcDeleteCategory=function(){if(!self.rcCatId()||!confirm(self.t('delete')+'?'))return;api('DELETE','/revenue-categories/'+self.rcCatId()).then(function(){self.rcCategoryModal(false);self.rcLoad();}).catch(fail);};

    self.rcRuleModal=ko.observable(false);self.rcRuleCategory=ko.observable(null);self.rcRuleSource=ko.observable('AR_TRANSACTION');self.rcRulePriority=ko.observable(100);
    self.rcDimensions=[{key:'transactionType',kind:'TRANSACTION_TYPE',label:'rcTransType'},{key:'transactionSource',kind:'TRANSACTION_SOURCE',label:'rcTransSource'},{key:'revenueType',kind:'REVENUE_TYPE',label:'rcRevenueType'},{key:'costCenter',kind:'COST_CENTER',label:'rcCostCenter'},{key:'glAccount',kind:'GL_ACCOUNT',label:'rcGlAccount'},{key:'projectNumber',kind:'PROJECT',label:'rcProject'},{key:'taskNumber',kind:'TASK',label:'rcTask'},{key:'customerNumber',kind:'CUSTOMER',label:'rcCustomer'}];
    self.rcRuleValues={};self.rcDimensions.forEach(function(d){self.rcRuleValues[d.key]=ko.observable('ALL');});
    self.rcLovOpen=ko.observable('');self.rcLovQuery=ko.observable('');self.rcLovItems=ko.observableArray([]);self.rcLovBusy=ko.observable(false);var rcLovTimer=null;
    self.rcCloseLov=function(){self.rcLovOpen('');self.rcLovQuery('');self.rcLovItems([]);if(rcLovTimer){clearTimeout(rcLovTimer);rcLovTimer=null;}};
    self.rcLovDisabled=function(d){return d.key==='taskNumber'&&self.rcRuleValues.projectNumber()==='ALL';};
    self.rcLovSelectedLabel=function(d){var v=self.rcRuleValues[d.key]();return v==='ALL'?'ALL — All values':v;};
    self.rcLoadLov=function(d){if(self.rcLovDisabled(d)){self.rcCloseLov();return;}self.rcLovBusy(true);var p='?kind='+encodeURIComponent(d.kind)+'&search='+encodeURIComponent(self.rcLovQuery().trim());if(d.key==='taskNumber')p+='&project='+encodeURIComponent(self.rcRuleValues.projectNumber());api('GET','/revenue-categories/lov'+p).then(function(x){if(self.rcLovOpen()===d.key)self.rcLovItems(x.items||[]);}).catch(fail).then(function(){self.rcLovBusy(false);});};
    self.rcToggleLov=function(d){if(self.rcLovDisabled(d))return;if(self.rcLovOpen()===d.key){self.rcCloseLov();return;}self.rcLovOpen(d.key);self.rcLovQuery('');self.rcLovItems([]);self.rcLoadLov(d);setTimeout(function(){var n=document.querySelector('.rc-lov-menu .rc-lov-search');if(n)n.focus();},0);};
    self.rcLovSearch=function(d){if(rcLovTimer)clearTimeout(rcLovTimer);rcLovTimer=setTimeout(function(){self.rcLoadLov(d);},250);};
    self.rcLovPick=function(d,item){self.rcRuleValues[d.key](item.value);if(d.key==='projectNumber')self.rcRuleValues.taskNumber('ALL');self.rcCloseLov();};
    self.rcNewRule=function(){self.rcRuleCategory(null);self.rcRuleSource('AR_TRANSACTION');self.rcRulePriority(100);self.rcDimensions.forEach(function(d){self.rcRuleValues[d.key]('ALL');});self.rcCloseLov();self.rcRuleModal(true);};
    self.rcSaveRule=function(){if(!self.rcRuleCategory()){toast(self.t('required'),true);return;}var b={categoryId:Number(self.rcRuleCategory()),source:self.rcRuleSource(),priority:Number(self.rcRulePriority())||100};self.rcDimensions.forEach(function(d){b[d.key]=self.rcRuleValues[d.key]().trim()||'ALL';});api('POST','/revenue-categories/rules',b).then(function(){self.rcRuleModal(false);self.rcLoad();}).catch(fail);};
    self.rcDeleteRule=function(r,e){if(e)e.stopPropagation();if(!confirm(self.t('delete')+'?'))return;api('DELETE','/revenue-categories/rules/'+r.ruleId).then(self.rcLoad).catch(fail);};

    self.rcAccessModal=ko.observable(false);self.rcAccessType=ko.observable('ROLE');self.rcAccessPrincipal=ko.observable(null);self.rcAccessCategory=ko.observable(null);self.rcAccessChildren=ko.observable(false);
    self.rcAccessSelectedIsMain=ko.computed(function(){var id=Number(self.rcAccessCategory());return self.rcCategories().some(function(c){return c.categoryId===id&&c.level==='MAIN';});});
    self.rcAccessType.subscribe(function(){self.rcAccessPrincipal(null);});self.rcAccessSelectedIsMain.subscribe(function(v){if(!v)self.rcAccessChildren(false);});
    self.rcNewAccess=function(){self.rcAccessType('ROLE');self.rcAccessPrincipal(null);self.rcAccessCategory(null);self.rcAccessChildren(false);self.rcAccessModal(true);};
    self.rcSaveAccess=function(){if(!self.rcAccessPrincipal()||!self.rcAccessCategory()){toast(self.t('required'),true);return;}api('POST','/revenue-categories/access',{principalType:self.rcAccessType(),principalId:Number(self.rcAccessPrincipal()),categoryId:Number(self.rcAccessCategory()),includeChildren:self.rcAccessChildren()?'Y':'N',active:'Y'}).then(function(){self.rcAccessModal(false);self.rcLoad();}).catch(fail);};
    self.rcDeleteAccess=function(a,e){if(e)e.stopPropagation();if(!confirm(self.t('delete')+'?'))return;api('DELETE','/revenue-categories/access/'+a.accessId).then(self.rcLoad).catch(fail);};
    self.rcNewForTab=function(){if(self.rcTab()==='categories')self.rcNewCategory();else if(self.rcTab()==='rules')self.rcNewRule();else self.rcNewAccess();};

    /* ── Report Recipients admin page ────────────────────────────────── */
    self.rlLoaded = ko.observable(false);
    self.rlBusy   = ko.observable(false);
    self.rlRows   = ko.observableArray([]);
    self.rlLoad = function () {
      self.rlBusy(true);
      api('GET', '/butil/dist').then(function (d) {
        self.rlRows(d.items || []); self.rlLoaded(true);
      }).catch(fail).then(function () { self.rlBusy(false); });
    };
    self.rlDrawer = ko.observable(false);
    self.rlEdit   = ko.observable(null);
    function rlBlank() {
      return { distId: null, scopeType: ko.observable('COSTCENTER'),
               scopeValue: ko.observable(''), scopeLabel: ko.observable(''),
               sectorName: ko.observable(''), subjectTpl: ko.observable(''),
               enabled: ko.observable(true), recips: ko.observableArray([]) };
    }
    function rlRecipRow(r) {
      return { disposition: ko.observable((r && r.disposition) || 'TO'),
               email: ko.observable((r && r.email) || ''),
               name: ko.observable((r && r.name) || '') };
    }
    self.rlNew = function () {
      var e = rlBlank();
      e.recips.push(rlRecipRow(null));
      self.rlEdit(e); self.rlDrawer(true);
    };
    self.rlOpen = function (row) {
      api('GET', '/butil/dist/' + row.distId).then(function (d) {
        var e = rlBlank();
        e.distId = d.distId;
        e.scopeType(d.scopeType); e.scopeValue(d.scopeValue);
        e.scopeLabel(d.scopeLabel || ''); e.sectorName(d.sectorName || '');
        e.subjectTpl(d.subjectTpl || ''); e.enabled(d.enabled === 'Y');
        (d.recipients || []).forEach(function (r) { e.recips.push(rlRecipRow(r)); });
        if (!e.recips().length) e.recips.push(rlRecipRow(null));
        self.rlEdit(e); self.rlDrawer(true);
      }).catch(fail);
    };
    self.rlAddRecip = function () { self.rlEdit().recips.push(rlRecipRow(null)); };
    self.rlDelRecip = function (r) { self.rlEdit().recips.remove(r); };
    self.rlSave = function () {
      var e = self.rlEdit(); if (!e) return;
      if (!e.scopeValue().trim()) { toast(self.t('rlValue'), true); return; }
      var body = {
        scopeType: e.scopeType(), scopeValue: e.scopeValue().trim(),
        scopeLabel: e.scopeLabel().trim() || null,
        sectorName: e.sectorName().trim() || null,
        subjectTpl: e.subjectTpl().trim() || null,
        enabled: e.enabled() ? 'Y' : 'N',
        recipients: e.recips().filter(function (r) { return r.email().trim(); })
          .map(function (r) { return { disposition: r.disposition(), email: r.email().trim(),
                                       name: r.name().trim() || null }; })
      };
      var req = e.distId ? api('PUT', '/butil/dist/' + e.distId, body)
                         : api('POST', '/butil/dist', body);
      req.then(function () { toast(self.t('rlSaved')); self.rlDrawer(false); self.rlLoad(); })
         .catch(fail);
    };
    self.rlDelete = function () {
      var e = self.rlEdit(); if (!e || !e.distId) return;
      if (!window.confirm(self.t('rlDeleteConfirm'))) return;
      api('DELETE', '/butil/dist/' + e.distId)
        .then(function () { toast(self.t('rlDeleted')); self.rlDrawer(false); self.rlLoad(); })
        .catch(fail);
    };

    /* ── Excel import (SheetJS, client-parsed, chunked upsert) ────────── */
    self.rlImpDrawer = ko.observable(false);
    self.rlImpBusy   = ko.observable(false);
    self.rlImpSheets = ko.observableArray([]);
    self.rlImpSheet  = ko.observable('');
    self.rlImpKind   = ko.observable('');
    self.rlImpCols   = ko.observableArray([]);   // [{idx,label,disp:ko}]
    self.rlImpActive = ko.observable(true);
    self.rlImpHasStatus = ko.observable(false);
    self.rlImpRows   = ko.observable(0);
    self.rlImpErr    = ko.observable('');
    var rlWb = null, rlSheetCache = {};
    self.rlImpOpen = function () {
      rlWb = null; rlSheetCache = {};
      self.rlImpSheets([]); self.rlImpSheet(''); self.rlImpKind('');
      self.rlImpCols([]); self.rlImpRows(0); self.rlImpErr('');
      self.rlImpDrawer(true);
    };
    self.rlImpPick = function () { document.getElementById('rc-imp-file').click(); };
    self.rlImpFile = function (vm, ev) {
      var f = ev.target.files && ev.target.files[0];
      ev.target.value = '';
      if (!f) return;
      self.rlImpBusy(true); self.rlImpErr('');
      window.require(['xlsx'], function (X) {
        var rd = new FileReader();
        rd.onload = function () {
          try {
            rlWb = X.read(new Uint8Array(rd.result), { type: 'array' });
            self.rlImpSheets(rlWb.SheetNames.slice());
            var pref = rlWb.SheetNames.filter(function (n) { return /department/i.test(n); })[0]
                    || rlWb.SheetNames.filter(function (n) { return /^sectors$/i.test(n); })[0]
                    || rlWb.SheetNames[0];
            self.rlImpSheet(pref);
            rlAnalyze(X, pref);
          } catch (e) { self.rlImpErr(String(e.message || e)); }
          self.rlImpBusy(false);
        };
        rd.readAsArrayBuffer(f);
      });
    };
    self.rlImpSheet.subscribe(function (name) {
      if (!rlWb || !name) return;
      window.require(['xlsx'], function (X) { rlAnalyze(X, name); });
    });
    function rlSheetAoa(X, name) {
      if (!rlSheetCache[name]) {
        rlSheetCache[name] = X.utils.sheet_to_json(rlWb.Sheets[name], { header: 1, raw: true, defval: null });
      }
      return rlSheetCache[name];
    }
    var rlParsed = null;   // {hdrIdx, cols:{cc,sector,label,status}, emailCols[], rows}
    function rlAnalyze(X, name) {
      self.rlImpErr(''); self.rlImpCols([]); self.rlImpRows(0); self.rlImpKind('');
      rlParsed = null;
      var aoa = rlSheetAoa(X, name);
      // header row = first row with 3+ text cells
      var hdrIdx = -1;
      for (var i = 0; i < Math.min(aoa.length, 10); i++) {
        var texts = (aoa[i] || []).filter(function (c) { return typeof c === 'string' && c.trim(); });
        if (texts.length >= 3) { hdrIdx = i; break; }
      }
      if (hdrIdx < 0) { self.rlImpErr(self.t('rlImpNoEmail')); return; }
      var hdr = aoa[hdrIdx].map(function (h) { return h == null ? '' : String(h).trim(); });
      var data = aoa.slice(hdrIdx + 1);
      function findCol(re) {
        for (var c = 0; c < hdr.length; c++) if (re.test(hdr[c])) return c;
        return -1;
      }
      var ccCol = findCol(/cost\s*cent/i);
      var secCol = findCol(/sector/i);
      var lblCol = findCol(/department.*name|name.*aderp/i);
      if (lblCol < 0) lblCol = findCol(/department/i);
      var stCol = findCol(/cc\s*status|status/i);
      // email columns = >=25% of populated cells contain '@'
      var emailCols = [];
      for (var c2 = 0; c2 < hdr.length; c2++) {
        var tot = 0, hits = 0;
        for (var r2 = 0; r2 < data.length; r2++) {
          var v = data[r2] ? data[r2][c2] : null;
          if (v == null || String(v).trim() === '') continue;
          tot++;
          if (String(v).indexOf('@') >= 0) hits++;
        }
        if (tot > 0 && hits / tot >= 0.25) {
          var label = hdr[c2] || ('Col ' + (c2 + 1));
          if (/^email/i.test(label)) {
            for (var p = c2 - 1; p >= 0; p--) {
              if (hdr[p]) { label = hdr[p].replace(/emp\.?\s*name/i, '').trim() + ' ' + label; break; }
            }
          }
          // CC patterns FIRST: "Director /ED Email" must not fall into the
          // TO bucket via its "ED Email" token (default = leadership on Cc)
          var def = /director|key\s*user|ap\s/i.test(label) ? 'CC'
                  : /pbp|fbp|\bbp\b|^ed\b|ed email/i.test(label) ? 'TO' : 'SKIP';
          emailCols.push({ idx: c2, label: label, disp: ko.observable(def) });
        }
      }
      if (!emailCols.length) { self.rlImpErr(self.t('rlImpNoEmail')); return; }
      var kind = ccCol >= 0 ? 'COSTCENTER' : (secCol >= 0 ? 'SECTOR' : '');
      if (!kind) { self.rlImpErr(self.t('rlImpNoEmail')); return; }
      self.rlImpKind(kind);
      self.rlImpHasStatus(stCol >= 0);
      self.rlImpCols(emailCols);
      rlParsed = { hdr: hdr, data: data,
                   cc: ccCol, sector: secCol, label: lblCol, status: stCol,
                   emailCols: emailCols };
      self.rlImpRows(rlBuildRows().length);
    }
    function rlPadCc(v) {
      var d = String(v == null ? '' : v).replace(/\D/g, '');
      if (!d) return '';
      return d.length < 7 ? ('0000000' + d).slice(-7) : d;
    }
    function rlBuildRows() {
      if (!rlParsed) return [];
      var kind = self.rlImpKind(), out = [], seen = {};
      rlParsed.data.forEach(function (row) {
        if (!row) return;
        var scope = kind === 'COSTCENTER' ? rlPadCc(row[rlParsed.cc])
                                          : String(row[rlParsed.sector] || '').trim();
        if (!scope) return;
        if (self.rlImpActive() && rlParsed.status >= 0) {
          var st = String(row[rlParsed.status] || '').trim();
          if (!/^active/i.test(st)) return;                 // 'NOT Active' is excluded
        }
        if (seen[scope]) return;
        seen[scope] = 1;
        var recips = [], have = {};
        rlParsed.emailCols.forEach(function (ec) {
          var disp = ec.disp();
          if (disp === 'SKIP') return;
          String(row[ec.idx] || '').split(/[,;\/\s\n\r&]+/).forEach(function (tok) {
            tok = tok.trim();
            var k = tok.toLowerCase();
            if (tok.indexOf('@') > 0 && !have[k]) { have[k] = 1; recips.push({ disposition: disp, email: tok }); }
          });
        });
        if (!recips.length) return;
        out.push({
          scopeType: kind, scopeValue: scope,
          scopeLabel: kind === 'COSTCENTER'
            ? String((rlParsed.label >= 0 ? row[rlParsed.label] : '') || '').trim() || scope
            : scope,
          sectorName: rlParsed.sector >= 0 ? String(row[rlParsed.sector] || '').trim() : null,
          recipients: recips
        });
      });
      return out;
    }
    self.rlImpRefresh = function () { self.rlImpRows(rlBuildRows().length); };
    self.rlImpActive.subscribe(function () { if (rlParsed) self.rlImpRows(rlBuildRows().length); });
    self.rlImpRun = function () {
      var rows = rlBuildRows();
      if (!rows.length) { toast(self.t('rlImpNoEmail'), true); return; }
      self.rlImpBusy(true);
      var created = 0, updated = 0, errors = 0;
      function chunk(from) {
        if (from >= rows.length) {
          self.rlImpBusy(false);
          toast(self.t('rlImpDone').replace('{c}', created).replace('{u}', updated).replace('{e}', errors), errors > 0);
          self.rlImpDrawer(false); self.rlLoad();
          return;
        }
        api('POST', '/butil/dist/meta/import', { rows: rows.slice(from, from + 200) })
          .then(function (d) {
            created += d.created || 0; updated += d.updated || 0; errors += d.errors || 0;
            chunk(from + 200);
          })
          .catch(function (e) { self.rlImpBusy(false); fail(e); });
      }
      chunk(0);
    };

    /* ── Terms and Key definitions (Settings; report intro content) ────
       One rich-text DOCUMENT per record (user decision 2026-09-06) with a
       validity window + lookup status + applied-to report scope; the ACTIVE
       document at the report's period end prints as content entry 01 of the
       Sector Performance Report with the author's formatting (Quill HTML,
       CLOB server-side). Quill is loaded as a UMD script BEFORE require.js
       (index.html boot chain); if it failed to load the drawer degrades to
       a raw-HTML textarea so editing is never blocked. */
    self.tkLoaded = ko.observable(false);
    self.tkBusy = ko.observable(false);
    self.tkRows = ko.observableArray([]);
    self.tkAppliedLov = ko.observableArray([]);
    self.tkStatusLov = ko.observableArray([]);
    self.tkDrawer = ko.observable(false);
    self.tkEdit = ko.observable(null);
    self.tkSaving = ko.observable(false);
    self.tkQuillOk = ko.observable(!!window.Quill);
    var tkQuill = null;
    self.tkLovLabel = function (o) { return self.lang() === 'ar' ? (o.nameAr || o.name) : o.name; };
    self.tkLoad = function () {
      self.tkBusy(true);
      var reqs = [api('GET', '/terms')];
      if (!self.tkAppliedLov().length) reqs.push(api('GET', '/terms/meta/lookups'));
      Promise.all(reqs).then(function (r) {
        self.tkRows((r[0].items || []).map(function (it) {
          it.endDate = it.endDate || ''; it.updatedBy = it.updatedBy || '';
          it.updatedAt = it.updatedAt || ''; return it;
        }));
        if (r[1]) { self.tkAppliedLov(r[1].appliedTo || []); self.tkStatusLov(r[1].statuses || []); }
        self.tkLoaded(true);
      }).catch(fail).then(function () { self.tkBusy(false); });
    };
    function tkBlank() {
      return { termId: null, title: ko.observable(''), appliedTo: ko.observable('SECTOR_PERF'),
               status: ko.observable('ACTIVE'), startDate: ko.observable(''), endDate: ko.observable(''),
               contentHtml: ko.observable(''), createdBy: '', createdAt: '' };
    }
    function tkInitQuill(html) {
      if (!window.Quill) { self.tkQuillOk(false); return; }
      self.tkQuillOk(true);
      // the editor host renders inside the drawer's ko-if -- init after paint
      setTimeout(function () {
        var host = document.getElementById('tk-quill');
        if (!host) return;
        if (!tkQuill) {
          tkQuill = new window.Quill(host, {
            theme: 'snow',
            modules: { toolbar: [
              [{ header: [1, 2, 3, false] }],
              ['bold', 'italic', 'underline', 'strike'],
              [{ color: [] }, { background: [] }],
              [{ size: ['small', false, 'large', 'huge'] }],
              [{ list: 'ordered' }, { list: 'bullet' }],
              [{ indent: '-1' }, { indent: '+1' }],
              [{ align: [] }, { direction: 'rtl' }],
              ['clean']
            ] }
          });
        }
        tkQuill.setContents(tkQuill.clipboard.convert({ html: html || '' }), 'silent');
      }, 0);
    }
    self.tkNew = function () {
      var e = tkBlank();
      e.startDate(new Date().toISOString().slice(0, 10));
      self.tkEdit(e); self.tkDrawer(true); tkInitQuill('');
    };
    self.tkOpen = function (row) {
      api('GET', '/terms/' + row.termId).then(function (d) {
        var e = tkBlank();
        e.termId = d.termId;
        e.title(d.title || ''); e.appliedTo(d.appliedTo); e.status(d.status);
        e.startDate(d.startDate || ''); e.endDate(d.endDate || '');
        e.contentHtml(d.contentHtml || '');
        e.createdBy = d.createdBy || ''; e.createdAt = d.createdAt || '';
        self.tkEdit(e); self.tkDrawer(true); tkInitQuill(d.contentHtml || '');
      }).catch(fail);
    };
    self.tkSave = function () {
      var e = self.tkEdit(); if (!e) return;
      if (!e.title().trim()) { toast(self.t('tkColTitle'), true); return; }
      if (!e.startDate()) { toast(self.t('tkStart'), true); return; }
      var html = (self.tkQuillOk() && tkQuill) ? tkQuill.getSemanticHTML() : e.contentHtml();
      var body = { title: e.title().trim(), appliedTo: e.appliedTo(), status: e.status(),
                   startDate: e.startDate(), endDate: e.endDate() || null, contentHtml: html };
      self.tkSaving(true);
      var req = e.termId ? api('PUT', '/terms/' + e.termId, body) : api('POST', '/terms', body);
      req.then(function () { toast(self.t('tkSaved')); self.tkDrawer(false); self.tkLoad(); })
         .catch(fail).then(function () { self.tkSaving(false); });
    };
    self.tkDelete = function () {
      var e = self.tkEdit(); if (!e || !e.termId) return;
      if (!window.confirm(self.t('tkDeleteConfirm'))) return;
      api('DELETE', '/terms/' + e.termId)
        .then(function () { toast(self.t('tkDeleted')); self.tkDrawer(false); self.tkLoad(); })
        .catch(fail);
    };

    /* ── init ── */
    api('GET', '/boot').then(function (d) {
      self.dimensions(d.dimensions || []);
      api('GET', '/segments').then(function (g) { self.segments(g.items || []); }).catch(function () {});
      // KO nulls a <select> value when options were empty at bind time; re-assert.
      if (!self.clsType()) self.clsType('SECTOR');
      if (!self.mapType()) self.mapType('SECTOR');
      self.combinationCount(d.combinationCount || 0);
      if (typeof d.classifiedCount === 'number' && d.combinationCount) {
        self.pctClassified(Math.round(d.classifiedCount * 100 / d.combinationCount));
      }
      self.refreshFilters();
      // load whatever the landing page is through the SAME path a nav click
      // takes, so the default page can change without touching init again
      self.go(routeFromHash() || self.view());
      self.ready(true);
    }).catch(function (e) { fail(e); self.ready(true); });
  }

  ko.applyBindings(new VM(), document.body);
})();
