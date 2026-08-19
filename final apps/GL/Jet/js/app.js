/* ════════════════════════════════════════════════════════════════════
   General Ledger (App 210) — internal CoA classification workspace.
   Plain Knockout single-file SPA (Portal pattern). Reads the shared staff
   session ('ifinance_jet_session'); redirects to Admin when absent.
   ════════════════════════════════════════════════════════════════════ */
(function () {
  'use strict';

  var API = '/ords/admin/gl';
  var SK  = 'ifinance_jet_session';
  var ADMIN_LOGIN = '/Admin/Jet/index.html';

  var raw = localStorage.getItem(SK);
  var session = raw ? JSON.parse(raw) : null;
  if (!session || !session.sessionId) { location.href = ADMIN_LOGIN; return; }
  var TOKEN = session.sessionId;

  function api(method, path, body) {
    var o = { method: method, headers: { 'Authorization': 'Bearer ' + TOKEN } };
    if (body !== undefined) { o.headers['Content-Type'] = 'application/json'; o.body = JSON.stringify(body); }
    return fetch(API + path, o).then(function (r) {
      return r.json().catch(function () { return {}; }).then(function (d) {
        if (r.status === 401) { location.href = ADMIN_LOGIN; }
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
    navBudgetTrx:{en:'Budget Transactions',ar:'معاملات الموازنة'},
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
    pdataHint:{en:'Re-extract projects, tasks and budget from Fusion now (runs the Projects Data job set; ~1–3 minutes)',ar:'إعادة استخراج المشاريع والمهام والميزانية من فيوجن الآن (تشغيل مجموعة مهام بيانات المشاريع؛ ١–٣ دقائق تقريباً)'},
    pdataQueued:{en:'Source-data refresh started ({n} jobs queued)…',ar:'بدأ تحديث بيانات المصدر ({n} مهام في قائمة الانتظار)…'},
    pdataDone:{en:'Source data refreshed — projects, tasks and budget are up to date',ar:'تم تحديث بيانات المصدر — المشاريع والمهام والميزانية محدّثة'},
    pdataFailed:{en:'Source-data refresh: some jobs failed —',ar:'تحديث بيانات المصدر: فشلت بعض المهام —'},
    pdataTimeout:{en:'Source-data refresh is taking longer than expected — check the ATD Run Logs page',ar:'يستغرق تحديث بيانات المصدر وقتاً أطول من المتوقع — راجع سجلات التشغيل في ATD'},
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
    genReport:{en:'Generate Report ▾',ar:'إنشاء تقرير ▾'},
    genRunning:{en:'Generating…',ar:'جارٍ الإنشاء…'},
    repBook:{en:'Briefing Book (PDF)',ar:'كتيب الإحاطة (PDF)'},
    repBookSub:{en:'Executive briefing document',ar:'وثيقة إحاطة تنفيذية'},
    repXlsx:{en:'Excel Register (XLSX)',ar:'سجل إكسل (XLSX)'},
    repXlsxSub:{en:'Full detail lists for analysis',ar:'قوائم تفصيلية كاملة للتحليل'},
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
    buDrillHint:{en:'Click a figure to see its supporting AP / GRN / PR / PO lines.',ar:'انقر رقماً لعرض بنود الدائنين / الاستلام / طلب الشراء / أمر الشراء الداعمة له.'},
    buCardHint:{en:'Click to see all supporting lines (current filters).',ar:'انقر لعرض كل البنود الداعمة (حسب عوامل التصفية الحالية).'},
    buAllLines:{en:'All budget lines',ar:'كل بنود الموازنة'},
    buShowing:{en:'Showing top {n} of {c} lines by amount.',ar:'عرض أعلى {n} من {c} بند حسب المبلغ.'},
    buLinesLbl:{en:'budget lines',ar:'بند موازنة'},
    buOfBudget:{en:'of budget',ar:'من الموازنة'},
    buRemaining:{en:'of budget remaining',ar:'من الموازنة متبقٍّ'},
    buOverBudget:{en:'over budget',ar:'تجاوز الموازنة'},
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
    buProcashHint:{en:'Procash records money already paid through the bank portal that has NOT reached Fusion as a payable invoice yet, so no AP, GRN, PR or PO figure includes it. When on, it is ADDED to Actual and SUBTRACTED from Fund Available. A procash transaction drops out the moment its Fusion invoice is linked, so nothing is counted twice.',ar:'يسجّل الدفع المباشر مبالغ دُفعت عبر بوابة البنك ولم تصل بعد إلى فيوجن كفاتورة دائنة، لذا لا يظهر ضمن أي من أرقام الحسابات الدائنة أو الاستلام أو طلبات وأوامر الشراء. عند التفعيل يُضاف إلى المصروف الفعلي ويُخصم من المتاح. وتخرج المعاملة فور ربط فاتورتها في فيوجن فلا يُحتسب المبلغ مرتين.'},
    buProcashOnL:{en:'Procash included',ar:'الدفع المباشر مضمّن'},
    buProcashOff:{en:'Select to include Procash',ar:'حدد لتضمين الدفع المباشر'},
    cProcash:{en:'Procash',ar:'الدفع المباشر'},
    buProcashUnmapped:{en:'procash not on a budget line',ar:'دفع مباشر خارج بنود الموازنة'},
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
    insGrowth:{en:'Actual spend rose from {a} ({p1}) to {b} ({p2}) — {x}× across the year.',ar:'ارتفع الإنفاق الفعلي من {a} ({p1}) إلى {b} ({p2}) — {x}× خلال العام.'}
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
          { id: 'budgettrx',    labelKey: 'navBudgetTrx' },
          { id: 'cashflow',     labelKey: 'navCashflow' } ] },
      { id: 'gl', labelKey: 'grpGl', items: [
          { id: 'dashboard', labelKey: 'navDashboard' },
          { id: 'actuals',   labelKey: 'navActuals' },
          { id: 'recon',     labelKey: 'navRecon' },
          { id: 'legacy',    labelKey: 'navLegacy' },
          { id: 'dof',       labelKey: 'navDof' },
          { id: 'yoy',       labelKey: 'navYoy' } ] },
      { id: 'settings', labelKey: 'grpSettings', items: [
          { id: 'overview', labelKey: 'navOverview' } ] }
    ];
    self.navGroups = NAV_GROUPS;
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
            return !it.hidden || it.id === v;   // hidden tabs appear only while open
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
      { code: 'iF', name: 'Admin',            color: '#C74634', url: '/Admin/Jet/index.html' },
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
    self.goHome = function () { location.href = '/Admin/Jet/index.html'; };

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
      self.view(v);
      if (v === 'overview') { if (!self.coaLoaded()) self.loadCoa(); }
      else if (v === 'actuals') {
        if (!self.acFiltersLoaded()) self.loadAcFilters().then(function () { self.runActuals(0); });
        else self.runActuals(0);
      } else if (v === 'dashboard') self.loadDashboard();
      else if (v === 'butil') {
        if (!self.buFiltersLoaded()) self.loadBuFilters().then(function () { self.runButil(0); });
        else self.runButil(0);
      }
      else if (v === 'portfolio') {
        // shares the Budget Utilization criteria observables, so drilling
        // between the two pages keeps one scope with no parameter passing
        if (!self.buFiltersLoaded()) self.loadBuFilters().then(function () { self.runPortfolio(); });
        else if (!self.pfLoaded()) self.runPortfolio();
      }
      else if (v === 'proj360') {
        if (!self.p3Num()) { self.view('portfolio'); self.go('portfolio'); return; }
        if (!self.buFiltersLoaded()) { self.loadBuFilters().then(self.loadProj360); return; }
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

    /* ════ CLASSIFICATIONS ════ */
    self.clsType = ko.observable('SECTOR');
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
    self.vIsHier = ko.computed(function () { var d = dimByCode(self.vType()); return d && d.isHierarchical === 'Y'; });
    self.parentOpts = ko.computed(function () {
      return self.values().filter(function (v) { return v.type === self.vType() && v.classValueId !== self.editingValueId(); });
    });
    self.addValue = function () {
      self.modalErr(''); self.editingValueId(null); self.vType(self.clsType()); self.vCode(''); self.vNameEn('');
      self.vNameAr(''); self.vAlt1(''); self.vAlt2(''); self.vAlt3(''); self.vTag(''); self.vParent(''); self.vOrder(0); self.vActive('Y');
      self.valueModal(true);
    };
    self.editValue = function (r) {
      self.modalErr(''); self.editingValueId(r.classValueId); self.vType(r.type); self.vCode(r.valueCode);
      self.vNameEn(r.nameEn); self.vNameAr(r.nameAr || ''); self.vAlt1(r.altName1 || ''); self.vAlt2(r.altName2 || '');
      self.vAlt3(r.altName3 || ''); self.vTag(r.tag || ''); self.vParent(r.parentValueId || ''); self.vOrder(r.displayOrder || 0); self.vActive(r.isActive);
      self.valueModal(true);
    };
    self.closeValue = function () { self.valueModal(false); };
    self.saveValue = function () {
      self.modalErr('');
      if (!self.vCode() || !self.vNameEn()) { self.modalErr('Code and English name are required.'); return; }
      var body = { type: self.vType(), valueCode: self.vCode(), nameEn: self.vNameEn(), nameAr: self.vNameAr(),
        altName1: self.vAlt1(), altName2: self.vAlt2(), altName3: self.vAlt3(), tag: self.vTag(),
        parentValueId: self.vParent() || null, displayOrder: Number(self.vOrder()) || 0, isActive: self.vActive() };
      var p = self.editingValueId()
        ? api('PUT', '/class-values/' + self.editingValueId(), body)
        : api('POST', '/class-values', body);
      p.then(function () { self.valueModal(false); toast(self.t('saved')); self.loadValues(); self.refreshFilters(); })
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

    function clsRow(m) {
      var r = {
        mapId: m ? m.mapId : null,
        isNew: ko.observable(!m),
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
      var pOpts = d
        ? api('GET', '/segments/' + d.segmentKey + '/values' + qs({ limit: 500 }))
            .then(function (r) { self.clsSegOptions(r.items || []); })
            .catch(function () { self.clsSegOptions([]); })
        : Promise.resolve();
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
        if ((r.isNew() || r.dirty()) && !r.startDate()) { self.clsDrawerErr(self.t('startRequired')); return; }
      }
      var chain = Promise.resolve(), changed = 0;
      rows.forEach(function (row) {
        if (row.isNew()) {
          changed++;
          chain = chain.then(function () {
            return api('POST', '/mappings', {
              type: self.clsType(), segmentValue: row.segmentValue(), classValueId: v.classValueId,
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
        toast(self.t('saved'));
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
    self.loadSegOptions = function () {
      var d = dimByCode(self.mapType()); if (!d) return;
      return api('GET', '/segments/' + d.segmentKey + '/values' + qs({ search: self.segSearch(), limit: 100 }))
        .then(function (r) {
          self.segOptions((r.items || []).map(function (x) { x.label = x.segmentValue + ' · ' + (x.description || ''); return x; }));
        }).catch(fail);
    };
    self.mapType.subscribe(function () { self.mapSegment(''); self.mappings([]); if (self.view() === 'overview') self.loadSegOptions(); });
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
        startDate: self.mStart(), endDate: self.mEnd() || null, notes: self.mNotes() };
      var p = self.editingMapId()
        ? api('PUT', '/mappings/' + self.editingMapId(), body)
        : api('POST', '/mappings', body);
      p.then(function () { self.mapModal(false); toast(self.t('saved')); self.loadMappings(); self.loadSegOptions(); })
       .catch(fail);
    };
    self.deleteMapping = function (r) {
      if (!confirm(self.t('confirmDel'))) return;
      api('DELETE', '/mappings/' + r.mapId).then(function () { toast(self.t('deleted')); self.loadMappings(); }).catch(fail);
    };

    /* ════ EXPLORER ════ */
    self.expSearch = ko.observable(''); self.fSector = ko.observable(''); self.fChapter = ko.observable(''); self.asOf = ko.observable('');
    self.combos = ko.observableArray([]); self.comboTotal = ko.observable(0); self.comboOffset = ko.observable(0); self.comboLimit = 50;
    self.loadCombos = function (offset) {
      offset = Math.max(0, offset || 0); self.loading(true);
      return api('GET', '/combinations' + qs({ search: self.expSearch(), sector: self.fSector(), chapter: self.fChapter(),
        asof: self.asOf(), limit: self.comboLimit, offset: offset }))
        .then(function (d) { self.combos(d.items || []); self.comboTotal(d.total || 0); self.comboOffset(offset); self.loading(false); })
        .catch(function (e) { self.loading(false); fail(e); });
    };
    var expT;
    function expReload() { clearTimeout(expT); expT = setTimeout(function () { self.loadCombos(0); }, 300); }
    self.expSearch.subscribe(expReload); self.fSector.subscribe(function () { self.loadCombos(0); });
    self.fChapter.subscribe(function () { self.loadCombos(0); }); self.asOf.subscribe(function () { self.loadCombos(0); });
    self.comboRange = ko.computed(function () {
      if (!self.comboTotal()) return '';
      var a = self.comboOffset() + 1, b = Math.min(self.comboOffset() + self.comboLimit, self.comboTotal());
      return a + '–' + b + ' / ' + self.fmt(self.comboTotal());
    });
    self.exportCsv = function () {
      api('GET', '/combinations' + qs({ search: self.expSearch(), sector: self.fSector(), chapter: self.fChapter(), asof: self.asOf(), limit: 500, offset: 0 }))
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

    /* ── Chart of Accounts page (merged Overview + Classifications + Segment Mapping + Explorer) ── */
    self.coaOvOpen = ko.observable(true);
    self.coaClsOpen = ko.observable(false);
    self.coaMapOpen = ko.observable(false);
    self.coaExpOpen = ko.observable(true);
    self.coaLoaded = ko.observable(false);
    self.loadCoa = function () {
      self.loadCombos(0); self.loadValues(); self.loadSegOptions(); self.coaLoaded(true);
    };
    self.toggleCoa = function (s) {
      var m = { ov: self.coaOvOpen, cls: self.coaClsOpen, map: self.coaMapOpen, exp: self.coaExpOpen };
      if (m[s]) m[s](!m[s]()); return true;
    };
    self.coaMax = ko.observable(false);
    self.toggleCoaMax = function () {
      self.coaMax(!self.coaMax());
      document.body.style.overflow = self.coaMax() ? 'hidden' : '';
      if (self.coaMax()) self.coaExpOpen(true);
      return false;
    };
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && self.coaMax() && !self.drillDrawer() && !self.drillModal()) self.toggleCoaMax();
    });

    /* ── shared filter refresh (sector/chapter dropdowns) ── */
    self.refreshFilters = function () {
      api('GET', '/class-values?type=SECTOR').then(function (d) { self.sectorOpts((d.items || []).filter(function (v) { return v.isActive === 'Y'; })); });
      api('GET', '/class-values?type=CHAPTER').then(function (d) { self.chapterOpts((d.items || []).filter(function (v) { return v.isActive === 'Y'; })); });
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
      self.refreshing(true);
      api('POST', '/actuals/refresh', {}).then(function (d) {
        self.lastRefreshed(d.refreshedAt || '');
        self.refreshing(false);
        toast(self.t('refreshed'));
        if (self.view() === 'actuals') self.runActuals(self.acOffset());
        else if (self.view() === 'dashboard') self.loadDashboard();
      }).catch(function (e) { self.refreshing(false); toast(e.message, true); });
    };

    // structural-reload recovery: POST /actuals/rebuild -> prod.dct_views_rebuild
    // (re-creates the SELECT * base views, recompiles, refreshes the snapshot)
    self.rebuilding = ko.observable(false);
    self.rebuildViews = function () {
      if (self.rebuilding() || self.refreshing()) return;
      if (!window.confirm(self.t('rebuildConfirm'))) return;
      self.rebuilding(true);
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

    /* ── Projects Data refresh (butil page): POST /butil/refreshdata runs the
       ATD job set PROJECTS_DATA (Projects Full + Tasks Full + Projects Budget
       Full - V2 — GL/db/19 bridge over atd_set_pkg.run_now), then polls the
       GET until the fleet finishes and re-runs the current search. Keeps the
       task/project masters and the budget in lock-step so a budget line never
       hides behind a stale task master. */
    self.pdataBusy = ko.observable(false);
    self.refreshProjectsData = function () {
      if (self.pdataBusy()) return;
      self.pdataBusy(true);
      api('POST', '/butil/refreshdata', {}).then(function (d) {
        toast(self.t('pdataQueued').replace('{n}', d.queued));
        var tries = 0;
        (function poll() {
          if (++tries > 90) {                     // ~7.5 min ceiling
            self.pdataBusy(false); toast(self.t('pdataTimeout'), true); return;
          }
          setTimeout(function () {
            api('GET', '/butil/refreshdata').then(function (s) {
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
        search: self.buSearch(), limit: limit || self.buLimit, offset: offset || 0 };
    };
    self.runButil = function (offset) {
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      offset = Math.max(0, offset || 0); self.buLoading(true);
      return api('GET', '/butil' + qs(self.buParams(offset))).then(function (d) {
        self.buItems(d.items || []); self.buTotals(d.totals || {});
        self.buTotal(d.total || 0); self.buOffset(offset);
        self.buMissCc(d.missingCc || 0); self.buMissCcBudget(d.missingCcBudget || 0);
        self.buConsiderOvr(d.considerOverride === 'Y');
        self.buProcashOn(d.includeProcash === 'Y');
        self.buLoading(false);
      }).catch(function (e) { self.buLoading(false); fail(e); });
    };
    /* ── data-quality alert: budget lines (annual budget) with NO cost centre.
       Server counts them across the WHOLE filtered set on every /butil run;
       the red band shows only when the count is non-zero and drills to the
       shared drawer via /butil?nocc=Y (same filters). */
    self.buMissCc = ko.observable(0); self.buMissCcBudget = ko.observable(0);
    self.buMissCcMsg = ko.computed(function () {
      return self.t('buMissCcMsg')
        .replace('{n}', self.fmt(self.buMissCc()))
        .replace('{amt}', self.money(self.buMissCcBudget()));
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
    self.buReset = function () {
      self.buTypeSel(self.buTypes().indexOf(BU_DEFAULT_TYPE) >= 0 ? [BU_DEFAULT_TYPE] : []);
      self.buTypePick('');
      self.buSector(''); self.buSearch(''); self.buApprop(''); self.buProgram('');
      self.buChapterSel.removeAll(); self.buCcSel.removeAll(); self.buProjSel.removeAll();
      self.buChapterPick('');
      self.buBuSel(self.buBus().indexOf(BU_DEFAULT_UNIT) >= 0 ? [BU_DEFAULT_UNIT] : []); self.buBuPick('');
      self.buCc(''); self.buProject(''); self.buTask(''); self.buEtype('');
      self.buOvr(false);
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
      api('GET', '/butil' + qs(self.buParams(0, 5000))).then(function (d) {
        var rows = d.items || [];
        var cols = [['projectType', 'Project Type'], ['sector', 'Sector'], ['department', 'Department'],
          ['organization', 'Organization'],
          ['costCentre', 'Cost Centre'], ['projectNumber', 'Project Number'], ['projectName', 'Project Name'],
          ['taskNumber', 'Task'], ['glAccount', 'GL Account'], ['appropriation', 'Appropriation'],
          ['chapter', 'Chapter'], ['program', 'Program'], ['expenditureType', 'Expenditure Type'],
          ['budgetAnnual', 'Annual Budget'], ['budget', 'YTD Budget'], ['actualAp', 'Actual AP'], ['actualGrn', 'Actual GRN'],
          ['commitmentPr', 'Commitment (PR)'], ['obligationPo', 'Obligation (PO)'], ['fundAvailable', 'Fund Available']];
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
      api('POST', '/butil/xlsx', {
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
      return self.buBookBusy() || self.buXlsxBusy() || self.buPptBusy();
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
    self.skCols = skArr(20);  // one cell per results-table column (+ Procash)

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
      self.drillCols(d.columns || []); self.drillRows(d.rows || []);
      self.drillTotalV(d.total || 0); self.drillCount(d.count || (d.rows || []).length);
      self.drillLoading(false);
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
    function drillIsCombo(info) {
      return !!(info && info.col && info.col.key === 'combination' &&
                info.row && acRowMap[info.row.combination]);
    }
    self.drillGridOver = function (d, e) {
      var info = drillResolveCell(e.target);
      if (drillIsCombo(info)) { info.td.style.cursor = 'help'; self.comboHover(acRowMap[info.row.combination], e); }
      else self.comboOut();
      return true;
    };
    self.drillGridMove = function (d, e) {
      if (!self.tipShow()) return true;
      var info = drillResolveCell(e.target);
      if (drillIsCombo(info)) self.comboMove(info.row, e); else self.comboOut();
      return true;
    };
    function drillFail(e) { self.drillLoading(false); self.drillDrawer(false); toast(e.message, true); }
    // row cell → that single budget line's supporting transactions
    self.openBuDrill = function (row, metric) {
      var cap = metric.charAt(0).toUpperCase() + metric.slice(1);
      self.drillTitle(self.t('buDrill' + cap));
      self.drillSub((row.projectNumber || '') + (row.projectName ? ' · ' + row.projectName : ''));
      self.drillCtx([row.taskNumber, row.expenditureType].filter(Boolean).join('   ·   '));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      api('GET', '/butil/lines' + qs({ year: self.buYear(), period: self.buPeriod(), project: row.projectNumber,
        task: row.taskNumber, etype: row.expenditureType, metric: metric,
        ovr: self.buOvr() ? 'Y' : null })).then(fillDrill).catch(drillFail);
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
      api('GET', '/butil/lines' + qs({ year: self.buYear(), period: self.buPeriod(), metric: metric,
        projecttype: self.buType(), sector: self.buSector(), chapter: self.buChapterParam(), search: self.buSearch(),
        costcenter: self.buCcParam(), fproject: self.buProjParam(), ftask: self.buTask(), fetype: self.buEtype(),
        ovr: self.buOvr() ? 'Y' : null })).then(fillDrill).catch(drillFail);
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
      var rows = (self.pfItems || []).map(function (r) {
        return {
          health: self.pfBandLabel(r.healthBand),
          project: r.projectNumber + ' — ' + (r.projectName || ''),
          manager: r.manager || '',
          status: r.status || '',
          budgetAnnual: (Number(r.budgetAnnual) || 0) / div,
          budgetYtd: (Number(r.budget) || 0) / div,
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
                  zebra: true, stateRev: 1 });
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
      var p = self.buParams(0); delete p.limit; delete p.offset; delete p.ovr; delete p.procash;
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
    self.loadCfSummary = function () {
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
            var idx = aoa.length ? cfMapHeaders(aoa[0], CF_PJ_HEADS, ['project', 'task', 'etype', 'period', 'cfType', 'amount']) : null;
            if (!idx) { self.cfPjBusy(false); toast(self.t('cfPjUpBad'), true); return; }
            var rows = [];
            for (var i = 1; i < aoa.length; i++) {
              var r = aoa[i];
              if (!r || r[idx.project] == null || r[idx.period] == null) continue;
              rows.push({
                project: cfCell(r, idx.project), task: cfCell(r, idx.task),
                etype: cfCell(r, idx.etype), period: cfCell(r, idx.period),
                cfType: cfCell(r, idx.cfType).toUpperCase(),
                amount: Number(r[idx.amount]) || 0,
                year: idx.year != null && r[idx.year] != null ? Number(r[idx.year]) : null
              });
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
    self.cfPjTemplate = function () {
      window.require(['xlsx'], function (X) {
        var wb = X.utils.book_new();
        var ws = X.utils.aoa_to_sheet([
          ['PROJECT', 'TASK', 'EXPENDITURE_TYPE', 'PERIOD', 'CF_TYPE', 'AMOUNT'],
          ['100026', '1.1', 'Professional Services', '01-2026', 'APPROVED', 500000]
        ]);
        X.utils.book_append_sheet(wb, ws, 'Projects Cashflow');
        X.writeFile(wb, 'Projects_Cashflow_Template.xlsx');
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

    /* ── init ── */
    api('GET', '/boot').then(function (d) {
      self.dimensions(d.dimensions || []);
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
      self.go(self.view());
      self.ready(true);
    }).catch(function (e) { fail(e); self.ready(true); });
  }

  ko.applyBindings(new VM(), document.body);
})();
