define(['knockout', 'services/authService'], function (ko, authService) {
  'use strict';

  function AppController() {
    const self = this;

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

    // ── Nav groups — collapsible sections ───────────────────────────────
    const NAV_GROUPS = [
      {
        id: 'home', standalone: true, auth: 'all',
        items: [
          { id: 'dashboard', label: 'Home', icon: '&#127968;' },
        ]
      },
      {
        id: 'workspace', label: 'My Workspace', auth: 'all',
        collapsed: ko.observable(false),
        items: [
          { id: 'profile',          label: 'My Profile',        icon: '&#128100;' },
          { id: 'notifications',    label: 'Notifications',     icon: '&#128276;' },
          { id: 'pendingApprovals', label: 'Pending Approvals', icon: '&#9989;'   },
        ]
      },
      {
        id: 'userMgmt', label: 'User Management', auth: 'admin',
        collapsed: ko.observable(false),
        items: [
          { id: 'users',       label: 'Users',       icon: '&#128101;' },
          { id: 'roles',       label: 'Roles',       icon: '&#128737;' },
          { id: 'permissions', label: 'Permissions', icon: '&#128273;' },
        ]
      },
      {
        id: 'organisation', label: 'Organisation', auth: 'admin',
        collapsed: ko.observable(false),
        items: [
          { id: 'orgHierarchy', label: 'Org Hierarchy', icon: '&#127959;' },
        ]
      },
      {
        id: 'ifinanceModules', label: 'i-Finance Modules', auth: 'all',
        collapsed: ko.observable(false),
        items: [
          { id: 'hr-module', label: 'Human Resources', icon: '&#128101;', url: '/HR/Jet/index.html' },
        ]
      },
      {
        id: 'system', label: 'System', auth: 'admin',
        collapsed: ko.observable(false),
        items: [
          { id: 'modules',           label: 'Module Registry',    icon: '&#9707;'   },
          { id: 'approvalTemplates', label: 'Approval Templates', icon: '&#128196;' },
          { id: 'approvalMonitor',   label: 'Approval Monitor',   icon: '&#128065;' },
          { id: 'lookups',           label: 'Lookups',            icon: '&#128203;' },
          { id: 'systemSettings',    label: 'System Settings',    icon: '&#9881;'   },
          { id: 'auditLog',          label: 'Audit Log',          icon: '&#128218;' },
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

    self.unreadCount = ko.observable(authService.getUnreadCount());

    // ── Internal route loader ───────────────────────────────────────────
    // Uses RequireJS text! plugin for HTML and AMD for the viewModel class.
    self._loadRoute = function (path) {
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
    self.closeUserMenu  = function () { self.userMenuOpen(false); };

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
      self.unreadCount(authService.getUnreadCount());
      self._loadRoute('dashboard');
    };

    // ── Boot: load initial route ────────────────────────────────────────
    self._loadRoute(self.currentUser() ? 'dashboard' : 'login');
  }

  return AppController;
});
