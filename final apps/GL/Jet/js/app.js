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
    home:{en:'i-Finance Home',ar:'الرئيسية'}, switchApp:{en:'Switch application',ar:'الانتقال إلى تطبيق'},
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
    today:{en:'Today',ar:'اليوم'}, combination:{en:'Combination',ar:'التركيبة'},
    costCenter:{en:'Cost center',ar:'مركز التكلفة'}, account:{en:'Account',ar:'الحساب'},
    program:{en:'Program',ar:'البرنامج'}, prev:{en:'‹ Prev',ar:'السابق ›'}, next:{en:'Next ›',ar:'‹ التالي'},
    noCombos:{en:'No combinations match.',ar:'لا توجد تركيبات مطابقة.'},
    footOrg:{en:'Finance Department · i-Finance',ar:'إدارة المالية · i-Finance'},
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
    refreshActuals:{en:'Refresh actuals',ar:'تحديث الفعلي'}, refreshing:{en:'Refreshing…',ar:'جارٍ التحديث…'},
    refreshed:{en:'Actuals snapshot refreshed',ar:'تم تحديث لقطة الفعلي'},
    refreshHint:{en:'Rebuild the classification snapshot so the report reflects the latest GL/ATD data and mapping edits.',ar:'إعادة بناء لقطة التصنيف لتعكس أحدث بيانات دفتر الأستاذ والربط.'},
    asOfRefresh:{en:'Updated',ar:'حُدّث'},

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
    self.toggleLang = function () { self.lang(self.lang() === 'en' ? 'ar' : 'en'); localStorage.setItem('gl_lang', self.lang()); applyDir(); };
    applyDir();
    self.ready = ko.observable(false);
    self.view = ko.observable('overview');
    self.userName = session.displayName || session.username || '';
    self.initials = (function () { var n = (self.userName || '').split(' ').filter(Boolean); return ((n[0] || ' ')[0] + ((n[1] || '')[0] || '')).toUpperCase(); })();
    self.dimName = function (d) { return self.lang() === 'ar' ? (d.nameAr || d.nameEn) : d.nameEn; };
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
    function comboRows(r) {
      return [
        { label: self.t('segEntity'),        code: r.entityCode,         desc: r.entityDesc },
        { label: self.t('segCostCenter'),    code: r.costCenterCode,     desc: r.costCenterDesc },
        { label: self.t('segAccount'),       code: r.accountCode,        desc: r.accountDesc },
        { label: self.t('segAppropriation'), code: r.appropriationCode,  desc: r.appropriationDesc },
        { label: self.t('segBudgetGroup'),   code: r.budgetGroupCode,    desc: r.budgetGroupDesc },
        { label: self.t('segEntitySpecific'),code: r.entitySpecificCode, desc: r.entitySpecificDesc },
        { label: self.t('segFuture1'),       code: r.future1Code,        desc: r.future1Desc },
        { label: self.t('segFuture2'),       code: r.future2Code,        desc: r.future2Desc },
        { label: self.t('segIntercompany'),  code: r.intercompanyCode,   desc: r.intercompanyDesc },
        { label: self.t('segProgram'),       code: r.programCode,        desc: r.programDesc }
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

    self.go = function (v) {
      self.view(v);
      if (v === 'classifications') self.loadValues();
      else if (v === 'mapping') self.loadSegOptions();
      else if (v === 'explorer') self.loadCombos(0);
      else if (v === 'actuals') {
        if (!self.acFiltersLoaded()) self.loadAcFilters().then(function () { self.runActuals(0); });
        else self.runActuals(0);
      } else if (v === 'dashboard') self.loadDashboard();
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

    /* ════ ACTUALS — Budget vs Actual report ════ */
    self.acFiltersLoaded = ko.observable(false);
    self.periods = ko.observableArray([]);
    self.acSectors = ko.observableArray([]); self.acChapters = ko.observableArray([]);
    self.acPrograms = ko.observableArray([]); self.acAppropriations = ko.observableArray([]);
    self.acAccounts = ko.observableArray([]); self.acCostCenters = ko.observableArray([]);
    self.acPeriod = ko.observable(''); self.acSector = ko.observable(''); self.acChapter = ko.observable('');
    self.acProgram = ko.observable(''); self.acAppr = ko.observable(''); self.acSearch = ko.observable('');
    self.acAccount = ko.observable(''); self.acCostCenter = ko.observable(''); self.acSource = ko.observable('');
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
      return { period: self.acPeriod(), sector: self.acSector(), chapter: self.acChapter(),
        program: self.acProgram(), appropriation: self.acAppr(),
        account: self.acAccount(), costcenter: self.acCostCenter(), source: self.acSource(),
        search: self.acSearch(),
        limit: limit || self.acLimit, offset: offset || 0 };
    };
    self.runActuals = function (offset) {
      if (!self.acPeriod()) { toast(self.t('periodRequired'), true); return; }
      offset = Math.max(0, offset || 0); self.acLoading(true);
      return api('GET', '/actuals' + qs(self.acParams(offset))).then(function (d) {
        self.acItems(d.items || []); self.acTotals(d.totals || {});
        self.acTotal(d.total || 0); self.acOffset(offset); self.acLoading(false);
      }).catch(function (e) { self.acLoading(false); fail(e); });
    };
    self.acReset = function () {
      self.acSector(''); self.acChapter(''); self.acProgram(''); self.acAppr(''); self.acSearch('');
      self.acAccount(''); self.acCostCenter(''); self.acSource('');
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

    /* ── drill-down: a single figure → its supporting lines ── */
    self.drillModal = ko.observable(false); self.drillLoading = ko.observable(false);
    self.drillTitle = ko.observable(''); self.drillCols = ko.observableArray([]);
    self.drillRows = ko.observableArray([]); self.drillTotalV = ko.observable(0);
    self.openDrill = function (row, metric) {
      self.drillTitle(self.t('m' + metric.charAt(0).toUpperCase() + metric.slice(1)) + ' · ' + row.ccString);
      self.drillCols([]); self.drillRows([]); self.drillTotalV(0);
      self.drillModal(true); self.drillLoading(true);
      api('GET', '/actuals/lines' + qs({ period: self.acPeriod(), cc: row.ccString, metric: metric }))
        .then(function (d) {
          self.drillCols(d.columns || []); self.drillRows(d.rows || []); self.drillTotalV(d.total || 0);
          self.drillLoading(false);
        }).catch(function (e) { self.drillLoading(false); self.drillModal(false); toast(e.message, true); });
    };
    self.closeDrill = function () { self.drillModal(false); };
    self.cell = function (row, col) {
      var v = row[col.key];
      if (col.type === 'money') return self.money(v);
      if (col.type === 'num') return (v == null ? '' : Number(v).toLocaleString('en-US', { maximumFractionDigits: 4 }));
      return (v == null ? '' : v);
    };
    self.drillFooterSpan = ko.computed(function () { return Math.max(1, self.drillCols().length - 1); });

    self.acExportCsv = function () {
      api('GET', '/actuals' + qs(self.acParams(0, 5000))).then(function (d) {
        var rows = d.items || [];
        var cols = [['ccString', 'Combination'], ['costCenterCode', 'Cost Center'], ['costCenterDesc', 'Cost Center Desc'],
          ['accountCode', 'Account'], ['accountDesc', 'Account Desc'], ['sectorName', 'Sector'], ['chapterName', 'Chapter'],
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
