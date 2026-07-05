/* ════════════════════════════════════════════════════════════════════
   Freelancer Self-Service Portal — Phase 1 (login, overview,
   contracts, payments). Plain Knockout, no requirejs: the portal is an
   EXTERNAL surface and deliberately does not share the staff session
   ('ifinance_jet_session') or the staff shell. Its bearer token only
   opens /fl/portal/* handlers.
   ════════════════════════════════════════════════════════════════════ */
(function () {
  'use strict';

  var API_BASE   = '/ords/admin/fl';
  var SESSION_KEY = 'ifinance_portal_session';

  /* ── i18n ──────────────────────────────────────────────────────── */
  var STR = {
    portalName:      { en: 'FREELANCER PORTAL',           ar: 'بوابة المستقلين' },
    loginHero:       { en: 'Your contracts, payments &amp; documents — <em>one quiet place.</em>',
                       ar: 'عقودك ودفعاتك ومستنداتك — <em>في مكان واحد.</em>' },
    loginHeroSub:    { en: 'For registered freelancers of the Finance Division. Track every payment period and stay ahead of expiring documents.',
                       ar: 'للمستقلين المسجلين لدى قطاع المالية. تابع كل فترة دفع وكن مطلعاً على المستندات التي تقارب الانتهاء.' },
    signIn:          { en: 'Sign in',                      ar: 'تسجيل الدخول' },
    signInHint:      { en: 'Use the e-mail address on your registration.', ar: 'استخدم البريد الإلكتروني المسجل لدينا.' },
    email:           { en: 'E-MAIL',                       ar: 'البريد الإلكتروني' },
    password:        { en: 'PASSWORD',                     ar: 'كلمة المرور' },
    continue:        { en: 'Continue →',                   ar: 'متابعة ←' },
    firstTime:       { en: 'First time here? Your invitation e-mail contains a set-password link.',
                       ar: 'أول مرة هنا؟ تجد رابط تعيين كلمة المرور في رسالة الدعوة.' },
    setPwdTitle:     { en: 'Set your password',            ar: 'تعيين كلمة المرور' },
    setPwdHint:      { en: 'Welcome! Pick a password (8 characters or more) to activate your portal account.',
                       ar: 'مرحباً! اختر كلمة مرور (٨ أحرف أو أكثر) لتفعيل حسابك.' },
    newPassword:     { en: 'NEW PASSWORD',                 ar: 'كلمة المرور الجديدة' },
    confirmPassword: { en: 'CONFIRM PASSWORD',             ar: 'تأكيد كلمة المرور' },
    setPwdBtn:       { en: 'Activate account →',           ar: 'تفعيل الحساب ←' },
    pwdMismatch:     { en: 'The two passwords do not match.', ar: 'كلمتا المرور غير متطابقتين.' },
    pwdSet:          { en: 'Password set — sign in with your e-mail.', ar: 'تم تعيين كلمة المرور — سجل الدخول بالبريد الإلكتروني.' },
    signOut:         { en: 'Sign out',                     ar: 'خروج' },
    navOverview:     { en: 'Overview',                     ar: 'نظرة عامة' },
    navContracts:    { en: 'Contracts',                    ar: 'العقود' },
    navPayments:     { en: 'Payments',                     ar: 'الدفعات' },
    greeting:        { en: 'Welcome back,',                ar: 'مرحباً،' },
    greetingSub:     { en: 'Here is where your engagement stands today.', ar: 'هذا هو وضع تعاقدك اليوم.' },
    nextPayment:     { en: 'NEXT PAYMENT',                 ar: 'الدفعة القادمة' },
    noUpcoming:      { en: 'No upcoming payments — all settled.', ar: 'لا توجد دفعات قادمة — تمت تسوية الكل.' },
    period:          { en: 'Period',                       ar: 'الفترة' },
    contract:        { en: 'Contract',                     ar: 'العقد' },
    status:          { en: 'Status',                       ar: 'الحالة' },
    accountTitle:    { en: 'Your account',                 ar: 'حسابك' },
    activeContracts: { en: 'active contracts',             ar: 'عقود نشطة' },
    totalContracts:  { en: 'total contracts',              ar: 'إجمالي العقود' },
    payoutAccount:   { en: 'payout account',               ar: 'حساب الصرف' },
    paymentTimeline: { en: 'Payment timeline',             ar: 'الجدول الزمني للدفعات' },
    myContracts:     { en: 'My <em>contracts.</em>',       ar: 'عقودي' },
    contractsSub:    { en: 'Every engagement with the Finance Division, with paid-to-date progress.',
                       ar: 'جميع تعاقداتك مع قطاع المالية مع نسبة ما تم سداده.' },
    paidToDate:      { en: 'Paid to date',                 ar: 'المدفوع حتى الآن' },
    openEnded:       { en: 'open',                         ar: 'مفتوح' },
    myPayments:      { en: 'My <em>payments.</em>',        ar: 'دفعاتي' },
    paymentsSub:     { en: 'Schedule rows and vouchers across all your contracts.',
                       ar: 'فترات الجدولة والسندات لجميع عقودك.' },
    schedule:        { en: 'Schedule',                     ar: 'الجدولة' },
    vouchers:        { en: 'Vouchers',                     ar: 'السندات' },
    nothingHere:     { en: 'Nothing here yet.',            ar: 'لا يوجد شيء هنا بعد.' },
    statePaid:       { en: 'PAID',                         ar: 'مدفوع' },
    stateScheduled:  { en: 'SCHEDULED',                    ar: 'مجدول' },
    stateInApproval: { en: 'IN APPROVAL',                  ar: 'قيد الاعتماد' },
    stateVoucher:    { en: 'VOUCHER RAISED',               ar: 'تم إنشاء السند' },
    loginFailed:     { en: 'Invalid e-mail or password.',  ar: 'البريد الإلكتروني أو كلمة المرور غير صحيحة.' },
    footOrg:         { en: 'Finance Division · i-Finance', ar: 'قطاع المالية · i-Finance' },
    footNote:        { en: 'Statements reflect approved vouchers only', ar: 'تعكس الكشوف السندات المعتمدة فقط' },
    /* ── self-registration wizard ── */
    registerLink:    { en: 'New freelancer? Register here →', ar: 'مستقل جديد؟ سجّل هنا ←' },
    regTitle:        { en: 'Freelancer registration', ar: 'تسجيل مستقل' },
    regEmailHint:    { en: 'Enter your e-mail to receive a verification code.', ar: 'أدخل بريدك الإلكتروني لاستلام رمز التحقق.' },
    sendCode:        { en: 'Send code →', ar: 'إرسال الرمز ←' },
    regCodeHint:     { en: 'Enter the 6-digit code we e-mailed you.', ar: 'أدخل الرمز المكون من ٦ أرقام المرسل إلى بريدك.' },
    verifyCode:      { en: 'Verify →', ar: 'تحقق ←' },
    code:            { en: 'VERIFICATION CODE', ar: 'رمز التحقق' },
    firstNameEn:     { en: 'FIRST NAME', ar: 'الاسم الأول' },
    lastNameEn:      { en: 'LAST NAME', ar: 'اسم العائلة' },
    dob:             { en: 'DATE OF BIRTH', ar: 'تاريخ الميلاد' },
    nationality:     { en: 'NATIONALITY', ar: 'الجنسية' },
    emiratesId:      { en: 'EMIRATES ID', ar: 'الهوية الإماراتية' },
    passportNo:      { en: 'PASSPORT NUMBER', ar: 'رقم الجواز' },
    mobileLbl:       { en: 'MOBILE', ar: 'الهاتف' },
    lineMgrEmail:    { en: 'LINE MANAGER E-MAIL', ar: 'بريد المدير المباشر' },
    lineMgrName:     { en: 'LINE MANAGER NAME', ar: 'اسم المدير المباشر' },
    bankNameLbl:     { en: 'BANK NAME', ar: 'اسم البنك' },
    ibanLbl:         { en: 'IBAN', ar: 'الآيبان' },
    saveContinue:    { en: 'Save & continue →', ar: 'حفظ ومتابعة ←' },
    regDocsHint:     { en: 'Upload your Passport, Emirates ID and Bank Letter. We can read them for you with AI.', ar: 'ارفع الجواز والهوية الإماراتية وخطاب البنك. يمكننا قراءتها بالذكاء الاصطناعي.' },
    regDocsHintAi:     { en: 'Upload your Passport, Emirates ID and Bank Letter — we read each one automatically and fill the form for you. Or just continue and type the details yourself.', ar: 'ارفع الجواز والهوية الإماراتية وخطاب البنك — نقرأ كل مستند تلقائياً ونملأ النموذج نيابة عنك. أو تابع وأدخل البيانات بنفسك.' },
    regDocsHintManual: { en: 'Upload your Passport, Emirates ID and Bank Letter (optional now), then continue to fill in your details.', ar: 'ارفع الجواز والهوية الإماراتية وخطاب البنك (اختياري الآن)، ثم تابع لإدخال بياناتك.' },
    aiExtract:       { en: '✨ Read with AI', ar: '✨ قراءة بالذكاء الاصطناعي' },
    upload:          { en: 'Upload', ar: 'رفع' },
    reviewSubmit:    { en: 'Review & submit →', ar: 'مراجعة وإرسال ←' },
    submitReg:       { en: 'Submit registration →', ar: 'إرسال التسجيل ←' },
    regDoneTitle:    { en: 'Registration submitted', ar: 'تم إرسال التسجيل' },
    regDoneMsg:      { en: 'Thank you. Your request is now with your line manager for endorsement, then Finance approval. You will be e-mailed when it is approved.', ar: 'شكراً لك. طلبك الآن لدى مديرك المباشر للاعتماد ثم موافقة المالية. سنرسل لك بريداً عند الموافقة.' },
    backToLogin:     { en: '← Back to sign in', ar: '→ العودة لتسجيل الدخول' },
    next:            { en: 'Next →', ar: 'التالي ←' },
    back:            { en: '← Back', ar: '→ رجوع' },
    regStepEmail:    { en: 'E-mail', ar: 'البريد' },
    regStepVerify:   { en: 'Verify', ar: 'التحقق' },
    regStepDocs:     { en: 'Documents', ar: 'المستندات' },
    regStepDetails:  { en: 'Details', ar: 'البيانات' },
    regStepReview:   { en: 'Review', ar: 'المراجعة' },
    extractedTitle:  { en: 'Extracted by AI', ar: 'تم استخراجه بالذكاء الاصطناعي' },
    expiryLbl:       { en: 'EXPIRY DATE', ar: 'تاريخ الانتهاء' },
    nameEnLbl:       { en: 'NAME (EN)', ar: 'الاسم (إنجليزي)' },
    nameArLbl:       { en: 'NAME (AR)', ar: 'الاسم (عربي)' },
    accountNameLbl:  { en: 'ACCOUNT HOLDER', ar: 'اسم صاحب الحساب' },
    accountNoLbl:    { en: 'ACCOUNT NUMBER', ar: 'رقم الحساب' },
    swiftLbl:        { en: 'SWIFT', ar: 'سويفت' },
    currencyLbl:     { en: 'CURRENCY', ar: 'العملة' },
    regPhotoLbl:     { en: 'Personal photo', ar: 'الصورة الشخصية' },
    regPhotoHint:    { en: 'A clear passport-style photo of your face.', ar: 'صورة واضحة لوجهك بنمط جواز السفر.' },
    reqTag:          { en: 'Required', ar: 'مطلوب' },
    optTag:          { en: 'Optional', ar: 'اختياري' },
    savedTag:        { en: '✓ Saved', ar: '✓ تم الحفظ' },
    uploadedDocsTitle:{ en: 'Uploaded documents', ar: 'المستندات المرفوعة' },
    regPhotoNeeded:  { en: 'Please add your personal photo before continuing.', ar: 'يرجى إضافة صورتك الشخصية قبل المتابعة.' },
    regPhotoImgOnly: { en: 'Please choose an image file for your photo.', ar: 'يرجى اختيار ملف صورة.' },

    /* ── DCT landing (public portal) ── */
    dlpEyebrow:      { en: 'DEPARTMENT OF CULTURE AND TOURISM — ABU DHABI', ar: 'دائرة الثقافة والسياحة — أبوظبي' },
    dlpHeadline:     { en: 'Create.<br>Get recognised.<br><span class="it">Get paid.</span>', ar: 'أبدع.<br>كن معترفاً بك.<br><span class="it">واحصل على أجرك.</span>' },
    dlpLede:         { en: "Abu Dhabi's freelance creatives belong here. Register with AI in minutes and start working with the DCT family — artists, photographers, performers, guides and producers all welcome.", ar: 'المبدعون المستقلون في أبوظبي مكانهم هنا. سجّل بالذكاء الاصطناعي خلال دقائق وابدأ العمل مع عائلة دائرة الثقافة والسياحة — فنانون ومصورون وفنانو أداء ومرشدون ومنتجون، الجميع مرحب بهم.' },
    dlpTrust1:       { en: 'Government-backed & secure', ar: 'مدعوم حكومياً وآمن' },
    dlpTrust2:       { en: 'sign-in supported', ar: 'تسجيل الدخول مدعوم' },
    dlpAiTag:        { en: 'AI SELF-REGISTRATION', ar: 'التسجيل الذاتي بالذكاء الاصطناعي' },
    dlpCardTitle:    { en: 'Join the DCT family today.', ar: 'انضم إلى عائلة الدائرة اليوم.' },
    dlpCardSub:      { en: 'Scan your Emirates ID — our AI fills your profile, validates your documents and guides you the whole way.', ar: 'امسح هويتك الإماراتية — يملأ الذكاء الاصطناعي ملفك ويتحقق من مستنداتك ويرشدك خطوة بخطوة.' },
    dlpStep1:        { en: 'Scan your Emirates ID', ar: 'امسح هويتك الإماراتية' },
    dlpStep1s:       { en: 'OCR reads your details instantly', ar: 'يقرأ النظام بياناتك فوراً' },
    dlpStep2:        { en: 'AI fills your profile', ar: 'الذكاء الاصطناعي يملأ ملفك' },
    dlpStep2s:       { en: '& checks every document for completeness', ar: 'ويتحقق من اكتمال كل مستند' },
    dlpStep3:        { en: 'Review & submit', ar: 'راجع وأرسل' },
    dlpStep3s:       { en: 'Done in minutes, not weeks', ar: 'يكتمل خلال دقائق وليس أسابيع' },
    dlpRegister:     { en: 'Register with AI', ar: 'سجّل بالذكاء الاصطناعي' },
    dlpAlready:      { en: 'Already registered?', ar: 'مسجّل بالفعل؟' },
    dlpBenefit1:     { en: 'Paid on time', ar: 'الدفع في الموعد' },
    dlpBenefit2:     { en: 'Real DCT projects', ar: 'مشاريع حقيقية للدائرة' },
    dlpBenefit3:     { en: 'One place for everything', ar: 'كل شيء في مكان واحد' }
  };

  /* ── tiny fetch wrapper ────────────────────────────────────────── */
  function api(method, path, body, token) {
    var opts = { method: method, headers: {} };
    if (body !== undefined) {
      opts.headers['Content-Type'] = 'application/json';
      opts.body = JSON.stringify(body);
    }
    if (token) opts.headers['Authorization'] = 'Bearer ' + token;
    return fetch(API_BASE + path, opts).then(function (r) {
      return r.json().catch(function () { return {}; }).then(function (d) {
        if (!r.ok) {
          var err = new Error(d.error || ('HTTP ' + r.status));
          err.status = r.status;
          throw err;
        }
        return d;
      });
    });
  }

  /* ── view model ────────────────────────────────────────────────── */
  function PortalVM() {
    var self = this;

    self.lang  = ko.observable(localStorage.getItem('ifinance_portal_lang') || 'en');
    self.view  = ko.observable('login');
    self.busy  = ko.observable(false);
    self.loginError = ko.observable('');

    self.email     = ko.observable('');
    self.password  = ko.observable('');
    self.password2 = ko.observable('');
    self.inviteToken = '';

    /* ── landing: sign-in overlay + Abu Dhabi photo slider ── */
    self.loginOpen = ko.observable(false);
    self.slideIdx  = ko.observable(0);
    self.slides = [
      { name: 'Louvre Abu Dhabi',          bg: "url('assets/photos/abudhabi-1.jpg') center/cover no-repeat, radial-gradient(130% 130% at 75% 18%, #5a1426 0%, #1a070d 70%)" },
      { name: 'Sheikh Zayed Grand Mosque', bg: "url('assets/photos/abudhabi-2.jpg') center/cover no-repeat, radial-gradient(130% 130% at 28% 30%, #3a0e1c 0%, #150509 70%)" },
      { name: 'Saadiyat Cultural District',bg: "url('assets/photos/abudhabi-3.jpg') center/cover no-repeat, radial-gradient(130% 130% at 62% 72%, #4a1020 0%, #1a070d 70%)" },
      { name: 'Abu Dhabi Creatives',       bg: "url('assets/photos/abudhabi-4.jpg') center/cover no-repeat, linear-gradient(130deg, #3c0a16 0%, #1a070d 100%)" }
    ];
    self.activeSlideName = ko.pureComputed(function () {
      var s = self.slides[self.slideIdx()]; return s ? s.name : '';
    });
    var _slideTimer = null;
    function _autoplay() {
      clearInterval(_slideTimer);
      _slideTimer = setInterval(function () {
        self.slideIdx((self.slideIdx() + 1) % self.slides.length);
      }, 5500);
    }
    self.slideGo   = function (n) { self.slideIdx((n + self.slides.length) % self.slides.length); _autoplay(); };
    self.slideNext = function () { self.slideGo(self.slideIdx() + 1); };
    self.slidePrev = function () { self.slideGo(self.slideIdx() - 1); };
    _autoplay();

    self.openLogin  = function () { self.loginError(''); self.view('login'); self.loginOpen(true); };
    self.closeLogin = function () { self.loginOpen(false); };

    /* ── self-registration wizard state ── */
    self.regStep   = ko.observable('email');   // email|otp|details|docs|review|done
    self.regBusy   = ko.observable(false);
    self.regError  = ko.observable('');
    self.regToken  = '';
    self.regId     = ko.observable(null);
    self.regAiEnabled = ko.observable(false);
    self.regStepIdx = ko.computed(function () {       // drives the wizard step-rail "done" marks
      return ['email', 'otp', 'docs', 'details', 'review', 'done'].indexOf(self.regStep());
    });
    self.regDevCode   = ko.observable('');   // DEV-only OTP echo (REG_OTP_DEV_ECHO=Y)
    self.rgEmail   = ko.observable('');
    self.rgCode    = ko.observable('');
    self.rgFirstName = ko.observable('');
    self.rgLastName  = ko.observable('');
    self.rgFirstNameAr = ko.observable('');
    self.rgLastNameAr  = ko.observable('');
    self.rgDob       = ko.observable('');
    self.rgNat       = ko.observable('');
    self.rgNationalId = ko.observable('');
    self.rgPassport  = ko.observable('');
    self.rgMobile    = ko.observable('');
    self.rgSpec      = ko.observable('');
    self.rgBankName  = ko.observable('');
    self.rgBankIban  = ko.observable('');
    self.rgBankAccountName = ko.observable('');
    self.rgBankAccountNumber = ko.observable('');
    self.rgBankSwift = ko.observable('');
    self.rgBankCurrency = ko.observable('AED');
    self.rgLineMgrEmail = ko.observable('');
    self.rgLineMgrName  = ko.observable('');
    self.rgRequestorEmail = ko.observable('');
    self.rgRequestorName  = ko.observable('');
    self.rgNats      = ko.observableArray([]);
    self.rgDocs      = ko.observableArray([
      { code: 'PASSPORT',    label: 'Passport',    mandatory: ko.observable(true), docId: ko.observable(null), fileName: ko.observable(''), aiMsg: ko.observable(''), aiOk: ko.observable(null), extracted: ko.observableArray([]) },
      { code: 'EMIRATES_ID', label: 'Emirates ID', mandatory: ko.observable(true), docId: ko.observable(null), fileName: ko.observable(''), aiMsg: ko.observable(''), aiOk: ko.observable(null), extracted: ko.observableArray([]) },
      { code: 'BANK_LETTER', label: 'Bank Letter', mandatory: ko.observable(true), docId: ko.observable(null), fileName: ko.observable(''), aiMsg: ko.observable(''), aiOk: ko.observable(null), extracted: ko.observableArray([]) }
    ]);
    // Personal photo (US-09): separate from the document checklist; stored on
    // the registration's photo_blob. Required-ness driven by PHOTO_REQUIRED.
    self.regPhotoRequired = ko.observable(false);
    self.regHasPhoto      = ko.observable(false);
    self.regPhotoName     = ko.observable('');
    self.regPhotoPreview  = ko.observable('');

    self.session = ko.observable(JSON.parse(sessionStorage.getItem(SESSION_KEY) || 'null') || {});
    self.me        = ko.observable({});
    self.contracts = ko.observableArray([]);
    self.schedule  = ko.observableArray([]);
    self.vouchers  = ko.observableArray([]);

    self.t = function (k) {
      var e = STR[k];
      return e ? (e[self.lang()] || e.en) : k;
    };
    self.toggleLang = function () {
      self.lang(self.lang() === 'en' ? 'ar' : 'en');
      localStorage.setItem('ifinance_portal_lang', self.lang());
      document.documentElement.dir  = self.lang() === 'ar' ? 'rtl' : 'ltr';
      document.documentElement.lang = self.lang();
    };
    if (self.lang() === 'ar') { document.documentElement.dir = 'rtl'; document.documentElement.lang = 'ar'; }

    self.isApp = ko.computed(function () {
      return ['overview', 'contracts', 'payments'].indexOf(self.view()) >= 0;
    });
    self.firstName = ko.computed(function () {
      var n = self.me().displayName || self.session().displayName || '';
      return n.split(' ')[0] || '';
    });
    self.initials = ko.computed(function () {
      var n = (self.me().displayName || self.session().displayName || '').split(' ').filter(Boolean);
      return n.length >= 2 ? (n[0][0] + n[n.length - 1][0]).toUpperCase()
                           : (n[0] ? n[0][0].toUpperCase() : '?');
    });
    self.timelineRows = ko.computed(function () { return self.schedule().slice(0, 8); });

    /* presentation helpers */
    self.payState = function (row) {
      if (row.paymentStatus === 'PAID' || row.status === 'PAID') return self.t('statePaid');
      var v = row.voucherStatus || '';
      if (v === 'SUBMITTED') return self.t('stateInApproval');
      if (v && v !== ' ')    return self.t('stateVoucher');
      return self.t('stateScheduled');
    };
    self.chipCss = function (row) {
      if (row.paymentStatus === 'PAID' || row.status === 'PAID') return 'ok';
      if ((row.voucherStatus || '').trim()) return 'due';
      return 'brand';
    };
    self.rowCss = function (row) {
      return { paid: row.paymentStatus === 'PAID' || row.status === 'PAID',
               now:  (row.voucherStatus || '').trim() !== '' && row.paymentStatus !== 'PAID' };
    };
    self.pct = function (c) {
      var tot = Number(c.totalAmount) || 0;
      return tot ? Math.min(100, Math.round((Number(c.paidTotal) || 0) * 100 / tot)) : 0;
    };

    /* ── auth flows ──────────────────────────────────────────────── */
    self.onLoginKey = function (d, ev) { if (ev.keyCode === 13) self.doLogin(); return true; };

    self.doLogin = function () {
      self.loginError('');
      self.busy(true);
      api('POST', '/portal/auth/login', { email: self.email(), password: self.password() })
        .then(function (r) {
          self.busy(false);
          self.password('');
          self.session({ token: r.token, displayName: r.displayName,
                         vendorNumber: r.vendorNumber, email: r.email });
          sessionStorage.setItem(SESSION_KEY, JSON.stringify(self.session()));
          self.go('overview');
        })
        .catch(function (e) {
          self.busy(false);
          self.loginError(e.status === 401 ? self.t('loginFailed') : e.message);
        });
    };

    self.doSetPassword = function () {
      self.loginError('');
      if (self.password() !== self.password2()) { self.loginError(self.t('pwdMismatch')); return; }
      self.busy(true);
      api('POST', '/portal/auth/set-password', { token: self.inviteToken, password: self.password() })
        .then(function () {
          self.busy(false);
          self.password(''); self.password2('');
          self.view('login');
          self.loginError(self.t('pwdSet'));
        })
        .catch(function (e) { self.busy(false); self.loginError(e.message); });
    };

    self.doLogout = function () {
      var tok = self.session().token;
      sessionStorage.removeItem(SESSION_KEY);
      self.session({});
      self.me({}); self.contracts([]); self.schedule([]); self.vouchers([]);
      self.view('login');
      if (tok) api('POST', '/portal/auth/logout', {}, tok).catch(function () {});
    };

    /* ── data loading ────────────────────────────────────────────── */
    function authed(method, path) {
      return api(method, path, undefined, self.session().token).catch(function (e) {
        if (e.status === 401) { self.doLogout(); }
        throw e;
      });
    }

    self.go = function (v) {
      self.view(v);
      if (v === 'overview') {
        authed('GET', '/portal/me').then(self.me).catch(function () {});
        authed('GET', '/portal/schedule').then(function (r) { self.schedule(r.items || []); }).catch(function () {});
      }
      if (v === 'contracts') {
        authed('GET', '/portal/contracts').then(function (r) { self.contracts(r.items || []); }).catch(function () {});
      }
      if (v === 'payments') {
        authed('GET', '/portal/schedule').then(function (r) { self.schedule(r.items || []); }).catch(function () {});
        authed('GET', '/portal/vouchers').then(function (r) { self.vouchers(r.items || []); }).catch(function () {});
      }
    };

    /* ── self-registration wizard ────────────────────────────────── */
    self.openRegister = function () {
      self.loginOpen(false);
      self.regError(''); self.regStep('email'); self.view('register');
      // reset any prior photo selection
      if (self.regPhotoPreview()) { try { URL.revokeObjectURL(self.regPhotoPreview()); } catch (e) {} }
      self.regPhotoPreview(''); self.regPhotoName(''); self.regHasPhoto(false);
      if (self.rgNats().length === 0) {
        api('GET', '/reg/public/nationalities').then(function (r) { self.rgNats(r.items || []); }).catch(function () {});
      }
    };
    self.regBackToLogin = function () { self.view('login'); };

    self.regStart = function () {
      self.regError(''); self.regBusy(true); self.regDevCode('');
      api('POST', '/reg/public/start', { email: self.rgEmail() })
        .then(function (r) {
          self.regBusy(false);
          // DEV echo: prefill the code so testing needs no email relay.
          if (r && r.devCode) { self.regDevCode(r.devCode); self.rgCode(r.devCode); }
          self.regStep('otp');
        })
        .catch(function (e) { self.regBusy(false); self.regError(e.message); });
    };

    self.regVerify = function () {
      self.regError(''); self.regBusy(true);
      api('POST', '/reg/public/verify', { email: self.rgEmail(), code: self.rgCode() })
        .then(function (r) {
          self.regToken = r.intakeToken;
          self.regAiEnabled(!!r.aiEnabled);
          self.rgRequestorEmail(self.rgEmail());
          // Create the empty draft up-front so documents can be uploaded first.
          return api('POST', '/reg/public/' + self.regToken + '/draft', {});
        })
        .then(function (r) {
          self.regId(r.registrationId);
          // Load photo/document-requirement config so the wizard reflects what
          // the admin marked required vs optional (and whether a photo is needed).
          return api('GET', '/reg/public/' + self.regToken).then(function (g) {
            self.regPhotoRequired(!!g.photoRequired);
            self.regHasPhoto(!!g.hasPhoto);
            (g.docRequirements || []).forEach(function (rq) {
              var d = self.rgDocs().filter(function (x) { return x.code === rq.code; })[0];
              if (d) d.mandatory(!!rq.mandatory);
            });
          }).catch(function () {});
        })
        .then(function () { self.regBusy(false); self.regStep('docs'); })
        .catch(function (e) { self.regBusy(false); self.regError(e.message); });
    };

    function regDetailPayload() {
      return {
        firstNameEn: self.rgFirstName(), lastNameEn: self.rgLastName(),
        firstNameAr: self.rgFirstNameAr(), lastNameAr: self.rgLastNameAr(),
        dateOfBirth: self.rgDob(), nationalityCode: self.rgNat(),
        nationalId: self.rgNationalId(), passportNumber: self.rgPassport(),
        mobile: self.rgMobile(), specialization: self.rgSpec(),
        bankName: self.rgBankName(), bankIban: self.rgBankIban(),
        bankAccountName: self.rgBankAccountName(), bankAccountNumber: self.rgBankAccountNumber(),
        bankSwift: self.rgBankSwift(), bankCurrencyCode: self.rgBankCurrency(),
        lineManagerEmail: self.rgLineMgrEmail(), lineManagerName: self.rgLineMgrName(),
        requestorEmail: self.rgRequestorEmail(), requestorName: self.rgRequestorName()
      };
    }

    function regPut() {
      return api('PUT', '/reg/public/' + self.regToken, regDetailPayload());
    }

    // Documents step is first (after OTP). Continue to the detail form whether
    // or not files were uploaded (AI auto-fills them when documents were read).
    self.regDocsContinue = function () {
      self.regError('');
      if (self.regPhotoRequired() && !self.regHasPhoto()) {
        self.regError(self.t('regPhotoNeeded')); return;
      }
      self.regStep('details');
    };

    self.regSaveDetails = function () {
      self.regError('');
      if (!self.rgFirstName() || !self.rgLastName() || !self.rgDob() || !self.rgNat()) {
        self.regError('First name, last name, date of birth and nationality are required.'); return;
      }
      self.regBusy(true);
      regPut().then(function (r) {
        self.regBusy(false); self.regId(r.registrationId); self.regStep('review');
      }).catch(function (e) { self.regBusy(false); self.regError(e.message); });
    };

    /* raw-binary upload (file IS the body; name/mime in the query string) */
    function uploadBytes(docId, file) {
      var q = '?file_name=' + encodeURIComponent(file.name) + '&mime_type=' + encodeURIComponent(file.type || 'application/octet-stream');
      return fetch(API_BASE + '/reg/public/' + self.regToken + '/documents/' + docId + '/file' + q,
        { method: 'PUT', headers: { 'Content-Type': file.type || 'application/octet-stream' }, body: file })
        .then(function (r) { if (!r.ok) throw new Error('Upload failed (' + r.status + ')'); return r.json(); });
    }

    self.regPickDoc = function (doc, ev) {
      var file = ev.target.files && ev.target.files[0];
      ev.target.value = '';
      if (!file) return;
      self.regError(''); self.regBusy(true);
      doc.aiMsg(''); doc.aiOk(null); doc.extracted.removeAll();
      api('POST', '/reg/public/' + self.regToken + '/documents', { docTypeCode: doc.code, documentName: file.name, mimeType: file.type })
        .then(function (r) { return uploadBytes(r.documentId, file).then(function () { doc.docId(r.documentId); doc.fileName(file.name); }); })
        .then(function () {
          self.regBusy(false);
          // Auto-start AI reading on upload when the feature is enabled.
          if (self.regAiEnabled()) self.regExtract(doc);
        })
        .catch(function (e) { self.regBusy(false); self.regError(e.message); });
      return true;
    };

    /* personal photo — raw binary -> registration photo_blob (US-09) */
    function uploadPhotoBytes(file) {
      var q = '?file_name=' + encodeURIComponent(file.name) + '&mime_type=' + encodeURIComponent(file.type || 'image/jpeg');
      return fetch(API_BASE + '/reg/public/' + self.regToken + '/photo' + q,
        { method: 'PUT', headers: { 'Content-Type': file.type || 'image/jpeg' }, body: file })
        .then(function (r) { if (!r.ok) throw new Error('Photo upload failed (' + r.status + ')'); return r.json(); });
    }

    self.regPickPhoto = function (vm, ev) {
      var file = ev.target.files && ev.target.files[0];
      ev.target.value = '';
      if (!file) return true;
      if (!/^image\//.test(file.type || '')) { self.regError(self.t('regPhotoImgOnly')); return true; }
      self.regError(''); self.regBusy(true);
      uploadPhotoBytes(file).then(function () {
        self.regBusy(false);
        if (self.regPhotoPreview()) { try { URL.revokeObjectURL(self.regPhotoPreview()); } catch (e) {} }
        self.regPhotoPreview(URL.createObjectURL(file));
        self.regPhotoName(file.name);
        self.regHasPhoto(true);
      }).catch(function (e) { self.regBusy(false); self.regError(e.message); });
      return true;
    };

    self.regExtract = function (doc) {
      if (!self.regAiEnabled()) { return; }
      if (!doc.docId()) { self.regError('Upload the file first.'); return; }
      self.regError(''); doc.aiMsg('Reading…'); doc.aiOk(null); doc.extracted.removeAll(); self.regBusy(true);
      api('POST', '/reg/public/' + self.regToken + '/documents/' + doc.docId() + '/extract', {})
        .then(function (res) {
          self.regBusy(false);
          // Unparseable / empty server response — never claim success.
          if (!res || res.extractId === undefined || res.extractId === null) {
            doc.aiOk(false);
            doc.aiMsg('✕ Could not read this document. Please try again or fill the form manually.');
            return;
          }
          // Wrong file in the slot: do NOT fill the form, show a clear error.
          if (res.typeMismatch) {
            doc.aiOk(false);
            var w = (res.warnings && res.warnings[0]) ||
                    ('This does not look like a ' + doc.label + '. Please upload the correct file.');
            doc.aiMsg('✕ ' + w);
            return;
          }
          var f = res.fields || {};
          var applied = 0;
          function set(obs, val, onlyIfEmpty) {
            if (val === null || val === undefined || val === '') return;
            if (onlyIfEmpty && obs()) { return; }
            obs(val); applied++;
          }
          // ALL-CAPS scans -> readable Title Case.
          function titleCase(s) {
            return String(s || '').toLowerCase().replace(/\b\w/g, function (c) { return c.toUpperCase(); });
          }
          // Resolve a nationality name/code (e.g. "Egypt", "Egyptian", "EGY")
          // to one of the dropdown option codes; '' if no confident match.
          function resolveNat(val) {
            if (!val) return '';
            var v = String(val).trim().toLowerCase();
            var rows = self.rgNats();
            var i, n;
            for (i = 0; i < rows.length; i++) { if (String(rows[i].code).toLowerCase() === v) return rows[i].code; }
            for (i = 0; i < rows.length; i++) { if (String(rows[i].name).toLowerCase() === v) return rows[i].code; }
            for (i = 0; i < rows.length; i++) {
              n = String(rows[i].name).toLowerCase();
              if (n.indexOf(v) === 0 || v.indexOf(n) === 0) return rows[i].code;   // Egypt <-> Egyptian / EGY
            }
            return '';
          }
          // Split a single full name into first / rest (best-effort).
          function firstOf(full) { var p = String(full || '').trim().split(/\s+/); return p[0] || ''; }
          function restOf(full)  { var p = String(full || '').trim().split(/\s+/); return p.slice(1).join(' '); }

          if (doc.code === 'PASSPORT') {
            set(self.rgPassport, f.passport_number);
            set(self.rgDob, f.date_of_birth ? String(f.date_of_birth).slice(0,10) : '', true);
            set(self.rgLastName, titleCase(f.surname), true);
            set(self.rgFirstName, titleCase(f.given_names), true);
            set(self.rgNat, resolveNat(f.nationality), true);
          } else if (doc.code === 'EMIRATES_ID') {
            set(self.rgNationalId, f.emirates_id);
            set(self.rgDob, f.date_of_birth ? String(f.date_of_birth).slice(0,10) : '', true);
            if (f.name_en) {
              set(self.rgFirstName, titleCase(firstOf(f.name_en)), true);
              set(self.rgLastName,  titleCase(restOf(f.name_en)),  true);
            }
            if (f.name_ar) {
              set(self.rgFirstNameAr, firstOf(f.name_ar), true);
              set(self.rgLastNameAr,  restOf(f.name_ar),  true);
            }
            set(self.rgNat, resolveNat(f.nationality), true);
          } else if (doc.code === 'BANK_LETTER') {
            set(self.rgBankIban, f.iban);
            set(self.rgBankName, f.bank_name);
            set(self.rgBankAccountName, f.account_holder_name);
            set(self.rgBankAccountNumber, f.account_number);
            set(self.rgBankSwift, f.swift);
            set(self.rgBankCurrency, f.currency);
          }
          // Build a friendly read-only summary of what the AI actually read, so
          // the applicant sees the extracted values immediately (before the form).
          doc.extracted.removeAll();
          (function () {
            function row(label, val) {
              if (val === null || val === undefined || String(val).trim() === '') return;
              doc.extracted.push({ label: label, value: String(val) });
            }
            if (doc.code === 'PASSPORT') {
              row(self.t('firstNameEn'), titleCase(f.given_names));
              row(self.t('lastNameEn'),  titleCase(f.surname));
              row(self.t('passportNo'),  f.passport_number);
              row(self.t('nationality'), f.nationality);
              row(self.t('dob'),         f.date_of_birth ? String(f.date_of_birth).slice(0,10) : '');
              row(self.t('expiryLbl'),   f.expiry_date ? String(f.expiry_date).slice(0,10) : '');
            } else if (doc.code === 'EMIRATES_ID') {
              row(self.t('nameEnLbl'),   f.name_en);
              row(self.t('nameArLbl'),   f.name_ar);
              row(self.t('emiratesId'),  f.emirates_id);
              row(self.t('nationality'), f.nationality);
              row(self.t('dob'),         f.date_of_birth ? String(f.date_of_birth).slice(0,10) : '');
              row(self.t('expiryLbl'),   f.card_expiry ? String(f.card_expiry).slice(0,10) : '');
            } else if (doc.code === 'BANK_LETTER') {
              row(self.t('bankNameLbl'),    f.bank_name);
              row(self.t('ibanLbl'),        f.iban);
              row(self.t('accountNameLbl'), f.account_holder_name);
              row(self.t('accountNoLbl'),   f.account_number);
              row(self.t('swiftLbl'),       f.swift);
              row(self.t('currencyLbl'),    f.currency);
            }
          })();
          var warns = res.warnings || [];
          if (res.nameMismatch) {
            // Name doesn't match another uploaded document -> possibly two people.
            doc.aiOk(false);
            doc.aiMsg('⚠ ' + (warns.join('; ')
                      || 'The name on this document does not match your other documents.'));
          } else if (applied === 0) {
            // Read OK but nothing usable — likely the wrong kind of file.
            doc.aiOk(false);
            doc.aiMsg('⚠ Read, but no ' + doc.label + ' fields were found'
                      + (warns.length ? ' — ' + warns.join('; ') : '. Check the file is correct.'));
          } else {
            doc.aiOk(true);
            doc.aiMsg('✓ Read — ' + applied + ' field(s) filled'
                      + (warns.length ? '. ' + warns.join('; ') : '.'));
          }
        })
        .catch(function (e) { self.regBusy(false); doc.aiMsg(''); doc.aiOk(null); self.regError(e.message); });
    };

    self.regToReview = function () {
      self.regError(''); self.regBusy(true);
      regPut().then(function () { self.regBusy(false); self.regStep('review'); })
        .catch(function (e) { self.regBusy(false); self.regError(e.message); });
    };

    self.regSubmit = function () {
      self.regError('');
      if (!self.rgLineMgrEmail()) { self.regError('A line manager e-mail is required.'); return; }
      self.regBusy(true);
      regPut().then(function () {
        return api('POST', '/reg/public/' + self.regToken + '/submit', {});
      }).then(function () { self.regBusy(false); self.regStep('done'); })
        .catch(function (e) { self.regBusy(false); self.regError(e.message); });
    };

    self.regGoto = function (step) { self.regError(''); self.regStep(step); };

    /* ── boot: invite deep link beats stored session ─────────────── */
    var m = (location.hash || '').match(/^#set-password=([0-9a-f]+)$/i);
    if (m) {
      self.inviteToken = m[1];
      history.replaceState(null, '', location.pathname);  // token out of the URL bar
      self.view('setpwd');
    } else if (self.session().token) {
      self.go('overview');
    }
  }

  ko.applyBindings(new PortalVM(), document.body);
})();
