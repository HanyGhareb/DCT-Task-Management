define(['knockout', 'services/config', 'services/authService', 'shared/i18n', 'shared/shell'],
function (ko, config, authService, i18n, shell) {
  'use strict';

  function AppController() {
    const self = this;

    self._state = {};

    // ── Shared shell (Phase 3): brand from settings + i18n ──────────────
    shell.initBrand('ar', function () {
      return new Promise(function (resolve) {
        require(['services/settingService'], function (settingService) {
          settingService.getValue('THEME_BRAND_COLOR')
            .then(resolve)
            .catch(function () { resolve(null); });
        }, function () { resolve(null); });
      });
    });
    shell.initAnnouncements('ar', config.authBase || config.apiBase);
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

    // ── Module switcher ──────────────────────────────────────────────────
    self.modules       = shell.MODULES;
    self.currentModule = shell.byKey('ar');
    self.modswOpen     = ko.observable(false);
    self.toggleModsw   = function () { self.modswOpen(!self.modswOpen()); };
    self.switchModule  = function (m) {
      if (m.soon || !m.url) return;
      if (m.key === self.currentModule.key) { self.modswOpen(false); return; }
      window.location.href = m.url;
    };

    self.currentUser     = ko.observable(authService.getCurrentUser());
    self.isAuthenticated = ko.computed(() => !!self.currentUser());
    self.moduleConfig    = ko.observable(null);

    self.sideNavOpen    = ko.observable(true);
    self.currentNavItem = ko.observable('');
    self.userMenuOpen   = ko.observable(false);

    function _hasRole(user, role) {
      return user && user.roles && user.roles.includes(role);
    }
    function _isArUser(user) {
      return _hasRole(user, 'AR_USER') || _hasRole(user, 'AR_ADMIN') || _hasRole(user, 'SYS_ADMIN');
    }
    function _isArAdmin(user) {
      return _hasRole(user, 'AR_ADMIN') || _hasRole(user, 'SYS_ADMIN');
    }

    const NAV_GROUPS = [
      {
        id: 'home', standalone: true, auth: 'all',
        items: [
          { id: 'dashboard', labelKey: 'nav.home' },
        ]
      },
      {
        id: 'events', labelKey: 'nav.eventsGroup', auth: 'arUser',
        collapsed: ko.observable(false),
        items: [
          { id: 'events',    labelKey: 'nav.events' },
          { id: 'eventForm', labelKey: 'nav.newEvent' },
          { id: 'whatIf',    labelKey: 'nav.whatIf' },
          { id: 'reports',   labelKey: 'nav.reports' },
        ]
      },
      {
        id: 'customers', labelKey: 'nav.customersGroup', auth: 'arUser',
        collapsed: ko.observable(false),
        items: [
          { id: 'arCustomers',    labelKey: 'nav.arCustomers' },
          { id: 'arCustomerForm', labelKey: 'nav.newArCustomer' },
        ]
      },
      {
        id: 'admin', labelKey: 'nav.adminGroup', auth: 'arAdmin',
        collapsed: ko.observable(true),
        items: [
          { id: 'pnlCategories', labelKey: 'nav.pnlCategories' },
          { id: 'docCategories', labelKey: 'nav.docCategories' },
          { id: 'settings',      labelKey: 'nav.moduleSettings' },
        ]
      },
    ];

    self.navGroups = ko.computed(() => {
      const user = self.currentUser();
      return NAV_GROUPS.filter(function (g) {
        if (g.auth === 'all')     return true;
        if (g.auth === 'arUser')  return _isArUser(user);
        if (g.auth === 'arAdmin') return _isArAdmin(user);
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
          self.currentNavItem(path);
          self.moduleConfig({ view: viewHtml, viewModel: new VMClass() });
        },
        function (err) { console.error('[ARRouter] Failed to load route:', path, err); }
      );
    };

    // No standalone login for AR — Admin JET (App 200) is the identity provider.
    function _requireAuth() {
      self.currentUser(null);
      window.location.href = config.adminPortalUrl;
    }

    self.navigate = function (path, state) {
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

    if (self.currentUser()) {
      self._loadRoute('dashboard');
    } else {
      _requireAuth();
    }
  }

  return AppController;
});
