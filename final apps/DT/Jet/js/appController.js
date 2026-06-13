define(['knockout', 'services/config', 'services/authService', 'services/approvalService', 'shared/i18n', 'shared/shell'],
function (ko, config, authService, approvalService, i18n, shell) {
  'use strict';

  function AppController() {
    const self = this;
    // enh-7: dirty-form guard — loaded async so the define() signature stays
    // untouched; no-ops until shared/formGuard arrives (ms after boot).
    var formGuard = { anyDirty: function () { return false; }, clearAll: function () {} };
    require(['shared/formGuard'], function (fg) { formGuard = fg; });

    self._state = {};

    // ── Shared shell (Phase 3): brand from settings + i18n ──────────────
    shell.initBrand('dt', function () {
      return new Promise(function (resolve) {
        require(['services/settingService'], function (settingService) {
          var fn = settingService.getValue || settingService.getByKey;
          if (!fn) { resolve(null); return; }
          fn.call(settingService, 'THEME_BRAND_COLOR').then(function (v) {
            resolve(v && v.settingValue !== undefined ? v.settingValue : v);
          }).catch(function () { resolve(null); });
        }, function () { resolve(null); });
      });
    });
    shell.initAnnouncements('dt', config.authBase || config.apiBase);
    shell.initRegionTheme(config.authBase || config.apiBase, function () {
      return new Promise(function (resolve) {
        require(['services/settingService'], function (settingService) {
          settingService.getAll().then(resolve).catch(function () { resolve(null); });
        }, function () { resolve(null); });
      });
    });
    self.t       = i18n.t;
    self.lang    = i18n.lang;
    self.setLang = i18n.setLang;

    // ── Module switcher (apps live side-by-side under "final apps/") ────
    self.modules       = shell.MODULES;
    self.currentModule = shell.byKey('dt');
    self.modswOpen     = ko.observable(false);
    self.toggleModsw   = function () { self.modswOpen(!self.modswOpen()); };
    self.switchModule  = function (m) {
      if (m.soon || !m.url) return;
      if (m.key === self.currentModule.key) { self.modswOpen(false); return; }
      window.location.href = m.url;   // root-absolute: "final apps/" is the web root in deployment
    };

    self.currentUser     = ko.observable(authService.getCurrentUser());
    self.isAuthenticated = ko.computed(() => !!self.currentUser());
    self.moduleConfig    = ko.observable(null);

    self.sideNavOpen    = ko.observable(true);
    self.currentNavItem = ko.observable('');
    self.userMenuOpen   = ko.observable(false);

    self.isLoginPage = ko.computed(() =>
      !self.isAuthenticated() || self.currentNavItem() === 'login'
    );

    self.unreadCount  = ko.observable(0);
    self.pendingCount = ko.observable(0);

    function _refreshCounts() {
      const user = authService.getCurrentUser();
      if (!user) return;
      self.unreadCount(authService.getUnreadCount());
      self.pendingCount(approvalService.getPendingCountForUser(user));
    }

    function _hasRole(user, role) {
      return user && user.roles && user.roles.includes(role);
    }
    function _isApprover(user) {
      return _hasRole(user, 'DT_MANAGER') || _hasRole(user, 'DT_ADMIN') || _hasRole(user, 'SYS_ADMIN');
    }
    function _isDtFinance(user) {
      return _hasRole(user, 'DT_FINANCE') || _hasRole(user, 'DT_ADMIN') || _hasRole(user, 'SYS_ADMIN');
    }
    function _isDtAdmin(user) {
      return _hasRole(user, 'DT_ADMIN') || _hasRole(user, 'SYS_ADMIN');
    }
    function _isSysAdmin(user) {
      return _hasRole(user, 'SYS_ADMIN');
    }

    const NAV_GROUPS = [
      {
        id: 'home', standalone: true, auth: 'all',
        items: [
          { id: 'dashboard', labelKey: 'nav.home', icon: '&#127968;' },
        ]
      },
      {
        id: 'myTravel', labelKey: 'nav.myTravel', auth: 'all',
        collapsed: ko.observable(false),
        items: [
          { id: 'myRequests',    labelKey: 'nav.myRequests',    icon: '&#9992;'   },
          { id: 'requestForm',   labelKey: 'nav.requestForm',   icon: '&#10133;'  },
          { id: 'mySettlements', labelKey: 'nav.mySettlements', icon: '&#128196;' },
        ]
      },
      {
        id: 'approvals', labelKey: 'nav.approvalsGroup', auth: 'approver',
        collapsed: ko.observable(false),
        items: [
          { id: 'approvals', labelKey: 'nav.approvals', icon: '&#128203;', badge: self.pendingCount },
        ]
      },
      {
        id: 'finance', labelKey: 'nav.finance', auth: 'dtFinance',
        collapsed: ko.observable(false),
        items: [
          { id: 'disbursementQueue', labelKey: 'nav.disbursementQueue', icon: '&#128181;' },
          { id: 'closureQueue',      labelKey: 'nav.closureQueue',      icon: '&#9989;'   },
          { id: 'allSettlements',    labelKey: 'nav.allSettlements',    icon: '&#128204;' },
        ]
      },
      {
        id: 'admin', labelKey: 'nav.adminGroup', auth: 'dtAdmin',
        collapsed: ko.observable(false),
        items: [
          { id: 'allRequests',  labelKey: 'nav.allRequests',  icon: '&#128202;' },
          { id: 'travelReport', labelKey: 'nav.travelReport', icon: '&#128200;' },
        ]
      },
      {
        id: 'config', labelKey: 'nav.config', auth: 'sysAdmin',
        collapsed: ko.observable(true),
        items: [
          { id: 'perDiemRates',    labelKey: 'nav.perDiemRates',    icon: '&#128176;' },
          { id: 'countryGroups',   labelKey: 'nav.countryGroups',   icon: '&#127760;' },
          { id: 'docRequirements', labelKey: 'nav.docRequirements', icon: '&#128196;' },
          { id: 'approvalRules',   labelKey: 'nav.approvalRules',   icon: '&#128221;' },
          { id: 'moduleSettings',  labelKey: 'nav.moduleSettings',  icon: '&#9881;'   },
        ]
      },
    ];

    self.navGroups = ko.computed(() => {
      const user = self.currentUser();
      return NAV_GROUPS.filter(function (g) {
        if (g.auth === 'all')       return true;
        if (g.auth === 'approver')  return _isApprover(user);
        if (g.auth === 'dtFinance') return _isDtFinance(user);
        if (g.auth === 'dtAdmin')   return _isDtAdmin(user);
        if (g.auth === 'sysAdmin')  return _isSysAdmin(user);
        return false;
      });
    });

    self.toggleGroup = function (group) { group.collapsed(!group.collapsed()); };

    self.userInitials = ko.computed(() => {
      const user = self.currentUser();
      if (!user) return '?';
      const parts = (user.displayName || user.username || '').split(' ');
      return parts.length >= 2
        ? (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
        : (parts[0] || '?')[0].toUpperCase();
    });

    self._loadRoute = function (path) {
      NAV_GROUPS.forEach(function (g) {
        if (g.collapsed && g.items && g.items.some(function (i) { return i.id === path; })) {
          g.collapsed(false);
        }
      });
      require(
        ['text!views/' + path + '.html', 'viewModels/' + path],
        function (viewHtml, VMClass) {
          formGuard.clearAll();   // route swap disposes the old view
          self.currentNavItem(path);
          self.moduleConfig({ view: viewHtml, viewModel: new VMClass() });
          _refreshCounts();
        },
        function (err) { console.error('[DTRouter] Failed to load route:', path, err); }
      );
    };

    // Production: redirect to Admin JET (identity provider).
    // Mock/dev: load local login route for standalone testing.
    function _requireAuth() {
      self.currentUser(null);
      if (config.apiBase) {
        window.location.href = '../Admin/Jet/index.html';
      } else {
        self._loadRoute('login');
      }
    }

    self.navigate = function (path, state) {
      // enh-7: unsaved-changes guard (same wording the browser uses on close)
      if (path !== self.currentNavItem() && formGuard.anyDirty() &&
          !window.confirm(i18n.t('guard.unsaved'))) {
        return;
      }
      self.userMenuOpen(false);
      if (state) { Object.assign(self._state, state); }
      const freshUser = authService.getCurrentUser();
      if (!freshUser) { _requireAuth(); return; }
      self._loadRoute(path);
    };

    self.toggleNav      = function () { self.sideNavOpen(!self.sideNavOpen()); };
    /* Bound to <main> via click: — MUST return true, or KO preventDefaults
       every click that bubbles up and kills native default actions
       (file-picker open, checkbox toggle, …). */
    self.closeUserMenu  = function () { self.userMenuOpen(false); return true; };
    self.toggleUserMenu = function (vm, event) {
      event.stopPropagation();
      self.userMenuOpen(!self.userMenuOpen());
    };

    self.logout = function () {
      authService.logout();
      self.userMenuOpen(false);
      self._state = {};
      _requireAuth();
    };

    self.onLogin = function (user) {
      self.currentUser(user);
      _refreshCounts();
      self._loadRoute('dashboard');
    };


    // ── Wave rollout (enh-7): Ctrl+K palette + idle session warning ───────
    require(['shared/commandPalette', 'shared/idleWarn', 'services/api'],
      function (cp, idleWarn, api) {
        function deEntity(s) {
          var d = document.createElement('div');
          d.innerHTML = s || '';
          return d.textContent;
        }
        var navItems = [];
        NAV_GROUPS.forEach(function (g) {
          (g.items || []).forEach(function (it) {
            navItems.push({ id: it.id, labelKey: it.labelKey, icon: it.icon });
          });
        });
        cp.init({
          t: i18n.t,
          enabled: function () { return !!self.currentUser(); },
          providers: [
            { group: i18n.t('cmdp.groupNav'), min: 0, search: function (q) {
                var ql = (q || '').toLowerCase();
                return navItems.filter(function (it) {
                  return !ql || i18n.t(it.labelKey).toLowerCase().indexOf(ql) >= 0;
                }).slice(0, q ? 6 : 7).map(function (it) {
                  return { icon: deEntity(it.icon), title: i18n.t(it.labelKey),
                           run: function () { self.navigate(it.id); } };
                });
            } }
          ]
        });
        // server cutoff is SESSION_TIMEOUT_MINS (dct_rest.validate_session);
        // 480 matches the platform default seeded in DCT_SYSTEM_SETTINGS
        idleWarn.init({
          timeoutMins: 480, warnMins: 5, t: i18n.t,
          enabled: function () { return !!self.currentUser(); },
          onExtend: function () {
            api.get('/notifications/count', { base: 'auth', silent: true }).catch(function () {});
          },
          onTimeout: function () { self.logout(); }
        });
      });

    if (self.currentUser()) {
      self._loadRoute('dashboard');
    } else {
      _requireAuth();
    }
  }

  return AppController;
});
