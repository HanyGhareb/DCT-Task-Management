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
    appName:{en:'General Ledger',ar:'دفتر الأستاذ العام'}, appSub:{en:'CHART OF ACCOUNTS',ar:'دليل الحسابات'},
    signOut:{en:'Sign out',ar:'خروج'}, apps:{en:'Apps',ar:'التطبيقات'},
    home:{en:'Fusion i-Finance Home',ar:'الرئيسية'}, switchApp:{en:'Switch application',ar:'الانتقال إلى تطبيق'},
    navOverview:{en:'Overview',ar:'نظرة عامة'}, navClass:{en:'Classifications',ar:'التصنيفات'},
    navMapping:{en:'Segment Mapping',ar:'ربط البنود'}, navExplorer:{en:'Explorer',ar:'المستكشف'},
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

    /* ── Actuals (Budget vs Actual) report ── */
    navActuals:{en:'Actuals',ar:'الفعلي'}, navDashboard:{en:'Dashboard',ar:'لوحة المعلومات'},
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
    refreshed:{en:'Actuals snapshot refreshed',ar:'تم تحديث لقطة الفعلي'},
    refreshHint:{en:'Rebuild the classification snapshot so the report reflects the latest GL/ATD data and mapping edits.',ar:'إعادة بناء لقطة التصنيف لتعكس أحدث بيانات دفتر الأستاذ والربط.'},
    asOfRefresh:{en:'Updated',ar:'حُدّث'},
    rebuildViews:{en:'Rebuild views',ar:'إعادة بناء العروض'}, rebuilding:{en:'Rebuilding…',ar:'جارٍ إعادة البناء…'},
    rebuildHint:{en:'Use ONLY after a data reload that changed table structure (new or renamed columns). Re-creates the reporting base views over the ATD tables, recompiles anything invalid, then refreshes the snapshot. For a normal data reload, “Refresh actuals” is enough.',ar:'يُستخدم فقط بعد تحميل بيانات غيّر بنية الجداول (أعمدة جديدة أو معاد تسميتها): يعيد إنشاء عروض التقارير الأساسية فوق جداول ATD ويعيد ترجمة غير الصالح ثم يحدّث اللقطة. بعد تحميل بيانات اعتيادي يكفي «تحديث الفعلي».'},
    rebuildConfirm:{en:'Rebuild the reporting base views?\n\nUse this after a data reload that CHANGED table structure (new/renamed columns) — e.g. a report errors or a new column is missing even after “Refresh actuals”.\n\nSafe and repeatable; takes under a minute.',ar:'إعادة بناء عروض التقارير الأساسية؟\n\nيُستخدم بعد تحميل بيانات غيّر بنية الجداول (أعمدة جديدة/معاد تسميتها) — مثلاً عند ظهور خطأ في تقرير أو غياب عمود جديد رغم «تحديث الفعلي».\n\nإجراء آمن وقابل للتكرار ويستغرق أقل من دقيقة.'},
    rebuilt:{en:'Base views rebuilt & snapshot refreshed',ar:'أُعيد بناء العروض وتحديث اللقطة'},
    rebuiltLeft:{en:'Still invalid (needs a script fix):',ar:'ما زال غير صالح (يتطلب تعديل السكربت):'},

    /* ── Budget Utilization (project budget vs actual) ── */
    navButil:{en:'Budget Utilization',ar:'استخدام الموازنة'},
    navEncumbrances:{en:'Projects Encumbrances',ar:'ارتباطات المشاريع'},
    enTitle:{en:'Open Projects Encumbrance Follow-up',ar:'متابعة ارتباطات المشاريع المفتوحة'},
    enSub:{en:'Every open encumbrance line (Open Commitment PR + Open Obligation PO) with the full GL combination — all ten segments, code and name — for the selected Budget Utilization scope.',ar:'كل بند ارتباط مفتوح (التزام طلب شراء مفتوح + تعهد أمر شراء مفتوح) مع التركيبة المحاسبية الكاملة — جميع البنود العشرة رمزًا واسمًا — ضمن نطاق استخدام الموازنة المحدد.'},
    enOpenLabel:{en:'Open / Reserved (AED)',ar:'المفتوح / المحجوز (درهم)'},
    enLinesLabel:{en:'encumbrance lines',ar:'بنود الارتباط'},
    enTruncNote:{en:'Showing the top 10,000 lines by open amount.',ar:'يتم عرض أعلى 10٬000 بند حسب المبلغ المفتوح.'},
    enLoadingNote:{en:'Loading encumbrance lines…',ar:'جارٍ تحميل بنود الارتباط…'},
    enIrErr:{en:'The interactive report component could not be loaded. Please refresh the page; if the problem persists, contact the administrator.',ar:'تعذّر تحميل مكوّن التقرير التفاعلي. يرجى تحديث الصفحة؛ وإذا استمرت المشكلة، تواصل مع المسؤول.'},

    /* ── Encumbrances – Pending Approval (PR/PO documents awaiting approval) ── */
    navPending:{en:'Encumbrances – Pending Approval',ar:'الارتباطات – قيد الاعتماد'},
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
    buTitle:{en:'Budget Utilization',ar:'استخدام الموازنة'},
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
    self.view = ko.observable('overview');
    self.userName = session.displayName || session.username || '';
    self.initials = (function () { var n = (self.userName || '').split(' ').filter(Boolean); return ((n[0] || ' ')[0] + ((n[1] || '')[0] || '')).toUpperCase(); })();
    self.dimName = function (d) { return self.lang() === 'ar' ? (d.nameAr || d.nameEn) : d.nameEn; };

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
      { code: 'GL', name: 'General Ledger',   color: '#3F6F5F', url: '/GL/Jet/index.html' }
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
      self.view(v);
      if (v === 'classifications') self.loadValues();
      else if (v === 'mapping') self.loadSegOptions();
      else if (v === 'explorer') self.loadCombos(0);
      else if (v === 'actuals') {
        if (!self.acFiltersLoaded()) self.loadAcFilters().then(function () { self.runActuals(0); });
        else self.runActuals(0);
      } else if (v === 'dashboard') self.loadDashboard();
      else if (v === 'butil') {
        if (!self.buFiltersLoaded()) self.loadBuFilters().then(function () { self.runButil(0); });
        else self.runButil(0);
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
    self.loadValues = function () {
      self.loading(true);
      return api('GET', '/class-values' + qs({ type: self.clsType() })).then(function (d) {
        self.values(d.items || []); self.loading(false);
      }).catch(function (e) { self.loading(false); fail(e); });
    };
    self.clsType.subscribe(function () { if (self.view() === 'classifications') self.loadValues(); });

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
    self.mapType.subscribe(function () { self.mapSegment(''); self.mappings([]); if (self.view() === 'mapping') self.loadSegOptions(); });
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
    self.runActuals = function (offset) {
      if (!self.acPeriod()) { toast(self.t('periodRequired'), true); return; }
      if (!self.acAccTypeSel().length) { toast(self.t('accTypeRequired'), true); return; }
      offset = Math.max(0, offset || 0); self.acLoading(true);
      return api('GET', '/actuals' + qs(self.acParams(offset))).then(function (d) {
        self.acItems(d.items || []); self.acTotals(d.totals || {});
        self.acTotal(d.total || 0); self.acOffset(offset); self.acLoading(false);
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
      var a = self.acOffset() + 1, b = Math.min(self.acOffset() + self.acLimit, self.acTotal());
      return a + '–' + b + ' ' + self.t('rowsOf') + ' ' + self.fmt(self.acTotal());
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
        .then(fillDrill).catch(drillFail);
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
    self.buYear = ko.observable(''); self.buType = ko.observable(''); self.buSector = ko.observable('');
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
        if (!self.buType() && (d.projectTypes || []).indexOf(BU_DEFAULT_TYPE) >= 0) self.buType(BU_DEFAULT_TYPE);
        // default Business Unit to DCT on first load (only if the user hasn't picked one)
        if (!self.buBuSel().length && (d.businessUnits || []).indexOf(BU_DEFAULT_UNIT) >= 0) self.buBuSel([BU_DEFAULT_UNIT]);
        self.buPeriod(buDefaultPeriod(self.buYear()));
        self.buFiltersLoaded(true);
        self.buFiltersLoading(false);
        self.loadBuLovs();
      }).catch(function (e) { self.buFiltersLoading(false); fail(e); });
    };
    self.buParams = function (offset, limit) {
      return { year: self.buYear(), period: self.buPeriod(), projecttype: self.buType(), sector: self.buSector(), chapter: self.buChapterParam(),
        costcenter: self.buCcParam(), project: self.buProjParam(), task: self.buTask(), etype: self.buEtype(),
        bu: self.buBuParam(), appropriation: self.buApprop() || null, program: self.buProgram() || null,
        search: self.buSearch(), limit: limit || self.buLimit, offset: offset || 0 };
    };
    self.runButil = function (offset) {
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      offset = Math.max(0, offset || 0); self.buLoading(true);
      return api('GET', '/butil' + qs(self.buParams(offset))).then(function (d) {
        self.buItems(d.items || []); self.buTotals(d.totals || {});
        self.buTotal(d.total || 0); self.buOffset(offset); self.buLoading(false);
      }).catch(function (e) { self.buLoading(false); fail(e); });
    };
    self.buReset = function () {
      self.buType(self.buTypes().indexOf(BU_DEFAULT_TYPE) >= 0 ? BU_DEFAULT_TYPE : '');
      self.buSector(''); self.buSearch(''); self.buApprop(''); self.buProgram('');
      self.buChapterSel.removeAll(); self.buCcSel.removeAll(); self.buProjSel.removeAll();
      self.buChapterPick('');
      self.buBuSel(self.buBus().indexOf(BU_DEFAULT_UNIT) >= 0 ? [BU_DEFAULT_UNIT] : []); self.buBuPick('');
      self.buCc(''); self.buProject(''); self.buTask(''); self.buEtype('');
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
      return (Number(t.actualAp) || 0) + (Number(t.actualGrn) || 0);
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
        etype: self.buEtype() || null, search: self.buSearch() || null
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
        etype: self.buEtype() || null, search: self.buSearch() || null
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
        etype: self.buEtype() || null, search: self.buSearch() || null
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
    self.skCols = skArr(18);  // one cell per results-table column

    /* ── collapsible regions (Search / Overview) + results maximize ── */
    var buUi = {};
    try { buUi = JSON.parse(localStorage.getItem('gl_bu_ui') || '{}'); } catch (e) { buUi = {}; }
    self.buSecSearchOpen = ko.observable(buUi.search !== false);
    self.buSecKpisOpen = ko.observable(buUi.kpis !== false);
    self.buSecCalcOpen = ko.observable(buUi.calc === true);   // informational — collapsed by default
    // display unit for every butil figure (search-criteria field; display-only, no re-query)
    self.buUnit = ko.observable(['auto', 'B', 'M', 'K', 'X'].indexOf(buUi.unit) >= 0 ? buUi.unit : 'auto');
    function saveBuUi() {
      localStorage.setItem('gl_bu_ui', JSON.stringify({ search: self.buSecSearchOpen(), kpis: self.buSecKpisOpen(), calc: self.buSecCalcOpen(), unit: self.buUnit() }));
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
            : (k === 'calc') ? self.buSecCalcOpen : self.buSecKpisOpen;
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
      if (e.key === 'Escape' && self.buMax() && !self.drillDrawer() && !self.drillModal()) self.toggleBuMax();
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
    function fillDrill(d) {
      self.drillCols(d.columns || []); self.drillRows(d.rows || []);
      self.drillTotalV(d.total || 0); self.drillCount(d.count || (d.rows || []).length);
      self.drillLoading(false);
    }
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
        task: row.taskNumber, etype: row.expenditureType, metric: metric })).then(fillDrill).catch(drillFail);
    };
    // KPI card → all supporting lines across the filtered set (aggregate)
    self.openBuAgg = function (metric) {
      if (!self.buYear()) { toast(self.t('yearRequired'), true); return; }
      var cap = metric.charAt(0).toUpperCase() + metric.slice(1);
      self.drillTitle(self.t('buDrill' + cap));
      // the annual-budget drill ignores the period window — label it by year
      self.drillSub(self.t('buAllLines') + ' · ' + (metric !== 'budgetannual' && self.buPeriod()
        ? self.t('ytd') + ' ' + self.buPeriod() : self.buYear()));
      self.drillCtx([self.buType(), self.buSector(), self.buChapterParam().split('|').join(', '),
        self.buCcParam().split('|').join(', '), self.buProjParam().split('|').join(', '), self.buTask(), self.buEtype(),
        self.buSearch() ? '“' + self.buSearch() + '”' : ''].filter(Boolean).join('   ·   '));
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0); self.drillCount(0);
      self.drillDrawer(true); self.drillLoading(true);
      api('GET', '/butil/lines' + qs({ year: self.buYear(), period: self.buPeriod(), metric: metric,
        projecttype: self.buType(), sector: self.buSector(), chapter: self.buChapterParam(), search: self.buSearch(),
        costcenter: self.buCcParam(), fproject: self.buProjParam(), ftask: self.buTask(), fetype: self.buEtype() })).then(fillDrill).catch(drillFail);
    };
    self.closeDrawer = function () { self.drillDrawer(false); self.drillMax(false); };
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
      self.ready(true);
    }).catch(function (e) { fail(e); self.ready(true); });
  }

  ko.applyBindings(new VM(), document.body);
})();
