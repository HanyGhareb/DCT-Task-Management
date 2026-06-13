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
    footNote:        { en: 'Statements reflect approved vouchers only', ar: 'تعكس الكشوف السندات المعتمدة فقط' }
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
