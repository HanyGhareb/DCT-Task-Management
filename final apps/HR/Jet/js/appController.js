define(['knockout', 'services/config', 'services/authService', 'services/notificationService', 'shared/i18n', 'shared/shell'],
function (ko, config, authService, notifService, i18n, shell) {
  'use strict';

  function AppController() {
    var self = this;

    self._state = {};

    // ── Shared shell (Phase 3): brand + i18n ────────────────────────────
    shell.initBrand('hr');
    self.t       = i18n.t;
    self.lang    = i18n.lang;
    self.setLang = i18n.setLang;

    // ── Module switcher (apps live side-by-side under "final apps/") ────
    self.modules       = shell.MODULES;
    self.currentModule = shell.byKey('hr');
    self.modswOpen     = ko.observable(false);
    self.toggleModsw   = function () { self.modswOpen(!self.modswOpen()); };
    self.switchModule  = function (m) {
      if (m.soon || !m.url) return;
      if (m.key === self.currentModule.key) { self.modswOpen(false); return; }
      window.location.href = m.url;   // root-absolute: "final apps/" is the web root in deployment
    };
    self.pendingCount = ko.observable(0);   // not used by HR; keeps the shared shell template uniform

    self.currentUser     = ko.observable(authService.getCurrentUser());
    self.isAuthenticated = ko.computed(function () { return !!self.currentUser(); });
    self.moduleConfig    = ko.observable(null);

    self.sideNavOpen    = ko.observable(true);
    self.currentNavItem = ko.observable('');
    self.userMenuOpen   = ko.observable(false);

    self.isLoginPage = ko.computed(function () {
      return !self.isAuthenticated() || self.currentNavItem() === 'login';
    });

    self.unreadCount = ko.observable(0);

    self.expiringAlerts = ko.observable(0);

    function _refreshCounts() {
      var user = authService.getCurrentUser();
      if (!user) return;
      self.unreadCount(notifService.getUnreadCount(user.userId));
      notifService.getExpiringDocCount().then(function (n) { self.expiringAlerts(n); }).catch(function () {});
    }

    function _hasRole(user, role) {
      return user && user.roles && user.roles.includes(role);
    }
    function _isHrAdmin(user) {
      return _hasRole(user, 'HR_ADMIN') || _hasRole(user, 'SYS_ADMIN');
    }
    function _isHrManager(user) {
      return _hasRole(user, 'HR_MANAGER') || _isHrAdmin(user);
    }
    function _isHrViewer(user) {
      return _hasRole(user, 'HR_VIEWER') || _isHrManager(user);
    }

    var NAV_GROUPS = [
      {
        id: 'home', standalone: true, auth: 'all',
        items: [
          { id: 'dashboard', labelKey: 'nav.home', icon: '&#127968;' },
        ]
      },
      {
        id: 'people', labelKey: 'nav.people', auth: 'viewer',
        collapsed: ko.observable(false),
        items: [
          { id: 'employees',     labelKey: 'nav.employees',    icon: '&#128100;' },
          { id: 'orgHierarchy',  labelKey: 'nav.orgHierarchy', icon: '&#127970;' },
        ]
      },
      {
        id: 'structure', labelKey: 'nav.structure', auth: 'viewer',
        collapsed: ko.observable(false),
        items: [
          { id: 'positions', labelKey: 'nav.positions', icon: '&#128203;' },
          { id: 'jobs',      labelKey: 'nav.jobs',      icon: '&#128196;' },
          { id: 'grades',    labelKey: 'nav.grades',    icon: '&#127942;' },
          { id: 'locations', labelKey: 'nav.locations', icon: '&#128205;' },
        ]
      },
      {
        id: 'compliance', labelKey: 'nav.compliance', auth: 'manager',
        collapsed: ko.observable(false),
        items: [
          { id: 'documents', labelKey: 'nav.documents', icon: '&#128196;', badge: self.expiringAlerts },
        ]
      },
      {
        id: 'admin', labelKey: 'nav.adminGroup', auth: 'admin',
        collapsed: ko.observable(false),
        items: [
          { id: 'lookups',        labelKey: 'nav.lookups',        icon: '&#128203;' },
          { id: 'moduleSettings', labelKey: 'nav.moduleSettings', icon: '&#9881;' },
        ]
      },
    ];

    self.navGroups = ko.computed(function () {
      var user = self.currentUser();
      return NAV_GROUPS.filter(function (g) {
        if (g.auth === 'all')     return true;
        if (g.auth === 'viewer')  return _isHrViewer(user);
        if (g.auth === 'manager') return _isHrManager(user);
        if (g.auth === 'admin')   return _isHrAdmin(user);
        return false;
      });
    });

    self.toggleGroup = function (group) { group.collapsed(!group.collapsed()); };

    self.userInitials = ko.computed(function () {
      var user = self.currentUser();
      if (!user) return '?';
      var parts = (user.displayName || user.username || '').split(' ');
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
          _refreshCounts();
        },
        function (err) { console.error('[HRRouter] Failed to load route:', path, err); }
      );
    };

    function _requireAuth() {
      self.currentUser(null);
      if (config.apiBase) {
        window.location.href = '/Admin/Jet/index.html';
      } else {
        self._loadRoute('login');
      }
    }

    self.navigate = function (path, state) {
      self.userMenuOpen(false);
      if (state) { Object.assign(self._state, state); }
      var freshUser = authService.getCurrentUser();
      if (!freshUser) { _requireAuth(); return; }
      self._loadRoute(path);
    };

    self.toggleNav      = function () { self.sideNavOpen(!self.sideNavOpen()); };
    self.closeUserMenu  = function () { self.userMenuOpen(false); };
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

    if (self.currentUser()) {
      self._loadRoute('dashboard');
    } else {
      _requireAuth();
    }
  }

  return AppController;
});
