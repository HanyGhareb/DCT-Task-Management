define(
  ['knockout', 'services/authService', 'services/themeService', 'shared/i18n', 'shared/shell'],
  function (ko, authService, themeService, i18n, shell) {
  'use strict';

  function AppController() {
    const self = this;

    // ── Theme: persisted data-theme + settings-driven brand color ───────
    themeService.init();
    shell.initBrand('admin');   // THEME_BRAND_COLOR override applied post-login (see onLogin)

    // Platform announcement banner (Phase 4) — no-op until a session exists
    self._initAnnouncements = function () {
      require(['services/config'], function (config) {
        shell.initAnnouncements('admin', config.authBase || config.apiBase);
      });
    };
    self._initAnnouncements();

    // ── i18n (Phase 3): t() + live language switching ────────────────────
    // localStorage is the primary store; the LANG row in DCT_USER_PREFERENCES
    // (PUT /prefs/LANG) makes the preference follow the user across devices.
    self.t    = i18n.t;
    self.lang = i18n.lang;
    self.setLang = function (l) {
      i18n.setLang(l);
      require(['services/api'], function (api) {
        api.put('/prefs/LANG', { value: l }, { silent: true }).catch(function () {});
      });
    };
    self._applyServerLang = function () {
      require(['services/api'], function (api) {
        api.get('/prefs/', { silent: true }).then(function (r) {
          var row = (r.items || []).find(function (p) { return p.key === 'LANG'; });
          if (row && row.value && row.value !== i18n.lang()) i18n.setLang(row.value);
        }).catch(function () {});
      });
    };

    // ── Auth state ──────────────────────────────────────────────────────
    self.currentUser     = ko.observable(authService.getCurrentUser());
    self.isAuthenticated = ko.computed(() => !!self.currentUser());

    // ── Module config: { view: htmlString, viewModel: vm } ──────────────
    self.moduleConfig = ko.observable(null);

    // ── Navigation state ────────────────────────────────────────────────
    self.sideNavOpen    = ko.observable(true);
    self.currentNavItem = ko.observable('');
    self.userMenuOpen   = ko.observable(false);

    self.isLoginPage = ko.computed(() =>
      !self.isAuthenticated() || self.currentNavItem() === 'login'
    );

    // ── Module switcher (shared shell, Phase 3) ─────────────────────────
    self.modules       = shell.MODULES;
    self.currentModule = shell.byKey('admin');
    self.modswOpen     = ko.observable(false);
    self.toggleModsw   = function () { self.modswOpen(!self.modswOpen()); };
    self.switchModule  = function (m) {
      if (m.soon) return;
      if (m.key === self.currentModule.key) { self.modswOpen(false); return; }
      if (m.url) window.location.href = m.url;
    };

    // ── Nav groups — collapsible sections (labels via i18n keys) ────────
    const NAV_GROUPS = [
      {
        id: 'home', standalone: true, auth: 'all',
        items: [
          { id: 'dashboard', labelKey: 'nav.home', icon: '&#127968;' },
        ]
      },
      {
        id: 'workspace', labelKey: 'nav.workspace', auth: 'all',
        collapsed: ko.observable(false),
        items: [
          { id: 'profile',          labelKey: 'nav.profile',          icon: '&#128100;' },
          { id: 'notifications',    labelKey: 'nav.notifications',    icon: '&#128276;' },
          { id: 'pendingApprovals', labelKey: 'nav.pendingApprovals', icon: '&#9989;'   },
        ]
      },
      {
        id: 'userMgmt', labelKey: 'nav.userMgmt', auth: 'admin',
        collapsed: ko.observable(false),
        items: [
          { id: 'users',       labelKey: 'nav.users',       icon: '&#128101;' },
          { id: 'roles',       labelKey: 'nav.roles',       icon: '&#128737;' },
          { id: 'permissions', labelKey: 'nav.permissions', icon: '&#128273;' },
        ]
      },
      {
        id: 'organisation', labelKey: 'nav.organisation', auth: 'admin',
        collapsed: ko.observable(false),
        items: [
          { id: 'orgHierarchy', labelKey: 'nav.orgHierarchy', icon: '&#127959;' },
        ]
      },
      {
        id: 'ifinanceModules', labelKey: 'nav.ifinanceModules', auth: 'all',
        collapsed: ko.observable(false),
        items: [
          { id: 'hr-module', labelKey: 'mod.hr', icon: '&#128101;', url: '/HR/Jet/index.html' },
        ]
      },
      {
        id: 'system', labelKey: 'nav.system', auth: 'admin',
        collapsed: ko.observable(false),
        items: [
          { id: 'modules',           labelKey: 'nav.modules',           icon: '&#9707;'   },
          { id: 'approvalTemplates', labelKey: 'nav.approvalTemplates', icon: '&#128196;' },
          { id: 'approvalMonitor',   labelKey: 'nav.approvalMonitor',   icon: '&#128065;' },
          { id: 'delegations',       labelKey: 'nav.delegations',       icon: '&#129309;' },
          { id: 'announcements',     labelKey: 'nav.announcements',     icon: '&#128226;' },
          { id: 'lookups',           labelKey: 'nav.lookups',           icon: '&#128203;' },
          { id: 'appearance',        labelKey: 'nav.appearance',        icon: '&#127912;' },
          { id: 'systemSettings',    labelKey: 'nav.systemSettings',    icon: '&#9881;'   },
          { id: 'auditLog',          labelKey: 'nav.auditLog',          icon: '&#128218;' },
        ]
      },
    ];

    self.navGroups = ko.computed(() => {
      const user = self.currentUser();
      const isAdmin = user && (user.roles.includes('SYS_ADMIN') || user.roles.includes('USER_ADMIN'));
      return NAV_GROUPS.filter(g => g.auth === 'all' || (g.auth === 'admin' && isAdmin));
    });

    self.toggleGroup = function (group) {
      group.collapsed(!group.collapsed());
    };

    // ── User helpers ────────────────────────────────────────────────────
    self.userInitials = ko.computed(() => {
      const user = self.currentUser();
      if (!user) return '?';
      const parts = (user.displayName || user.username || '').split(' ');
      return parts.length >= 2
        ? (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
        : (parts[0] || '?')[0].toUpperCase();
    });

    self.unreadCount = ko.observable(0);
    authService.getUnreadCount().then(function (n) { self.unreadCount(n); }).catch(function () {});

    // ── Internal route loader ───────────────────────────────────────────
    // Uses RequireJS text! plugin for HTML and AMD for the viewModel class.
    self._loadRoute = function (path) {
      // Keep the route in the URL hash so F5 restores the same page
      if (path === 'login') {
        if (window.location.hash) {
          try { history.replaceState(null, '', window.location.pathname); } catch (e) {}
        }
      } else if (window.location.hash !== '#' + path) {
        try { history.replaceState(null, '', '#' + path); } catch (e) {}
      }
      // Auto-expand the group that contains this route
      NAV_GROUPS.forEach(function (g) {
        if (g.collapsed && g.items && g.items.some(function (item) { return item.id === path; })) {
          g.collapsed(false);
        }
      });
      require(
        ['text!views/' + path + '.html', 'viewModels/' + path],
        function (viewHtml, VMClass) {
          self.currentNavItem(path);
          self.moduleConfig({ view: viewHtml, viewModel: new VMClass() });
        },
        function (err) {
          console.error('[Router] Failed to load route:', path, err);
        }
      );
    };

    // ── Public navigate ─────────────────────────────────────────────────
    self.navigate = function (path) {
      self.userMenuOpen(false);
      self.modswOpen(false);
      // Re-validate on every navigation — catches deactivation without page reload
      const freshUser = authService.getCurrentUser();
      if (!freshUser && self.currentUser()) {
        self.currentUser(null);
        self._loadRoute('login');
        return;
      }
      if (path !== 'login' && !freshUser) {
        self._loadRoute('login');
        return;
      }
      self._loadRoute(path);
    };

    // ── Shell actions ───────────────────────────────────────────────────
    self.toggleNav      = function () { self.sideNavOpen(!self.sideNavOpen()); };
    /* Bound to <main> via click: — MUST return true, or KO preventDefaults
       every click that bubbles up and kills native default actions
       (file-picker open, checkbox toggle, …). */
    self.closeUserMenu  = function () { self.userMenuOpen(false); self.modswOpen(false); return true; };

    self.toggleUserMenu = function (vm, event) {
      event.stopPropagation();
      self.userMenuOpen(!self.userMenuOpen());
    };

    self.logout = function () {
      authService.logout();
      self.currentUser(null);
      self.userMenuOpen(false);
      self._loadRoute('login');
    };

    // Called by login viewModel via window._jetApp.onLogin(user)
    self.onLogin = function (user) {
      self.currentUser(user);
      authService.getUnreadCount().then(function (n) { self.unreadCount(n); }).catch(function () {});
      self._applyServerTheme();
      self._applyServerLang();
      self._initAnnouncements();
      self._loadRoute('dashboard');
    };

    // THEME_BRAND_COLOR from system settings (GET /settings via settingService)
    self._applyServerTheme = function () {
      require(['services/settingService'], function (settingService) {
        try {
          settingService.getByKey('THEME_BRAND_COLOR').then(function (row) {
            var hex = row && row.settingValue;
            if (hex) shell.applyBrand(hex);
          }).catch(function () {});
        } catch (e) {}
      });
    };

    // ── Boot: load initial route (URL hash survives F5) ────────────────
    if (self.currentUser()) self._applyServerTheme();
    var bootRoute = (window.location.hash || '').replace(/^#/, '');
    self._loadRoute(self.currentUser() ? (bootRoute || 'dashboard') : 'login');
  }

  return AppController;
});
