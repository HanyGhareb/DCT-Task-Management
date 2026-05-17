define(['knockout', 'services/config', 'services/authService', 'services/approvalService'],
function (ko, config, authService, approvalService) {
  'use strict';

  function AppController() {
    const self = this;

    self._state = {};

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
          { id: 'dashboard', label: 'Home', icon: '&#127968;' },
        ]
      },
      {
        id: 'myTravel', label: 'My Travel', auth: 'all',
        collapsed: ko.observable(false),
        items: [
          { id: 'myRequests',    label: 'My Requests',    icon: '&#9992;'   },
          { id: 'requestForm',   label: 'New Request',    icon: '&#10133;'  },
          { id: 'mySettlements', label: 'My Settlements', icon: '&#128196;' },
        ]
      },
      {
        id: 'approvals', label: 'Approvals', auth: 'approver',
        collapsed: ko.observable(false),
        items: [
          { id: 'approvals', label: 'Pending Approvals', icon: '&#128203;', badge: self.pendingCount },
        ]
      },
      {
        id: 'finance', label: 'Finance', auth: 'dtFinance',
        collapsed: ko.observable(false),
        items: [
          { id: 'disbursementQueue', label: 'Disbursement Queue',  icon: '&#128181;' },
          { id: 'closureQueue',      label: 'Settlement Closure',  icon: '&#9989;'   },
          { id: 'allSettlements',    label: 'All Settlements',     icon: '&#128204;' },
        ]
      },
      {
        id: 'admin', label: 'Administration', auth: 'dtAdmin',
        collapsed: ko.observable(false),
        items: [
          { id: 'allRequests',  label: 'All Travel Requests', icon: '&#128202;' },
          { id: 'travelReport', label: 'Travel Reports',      icon: '&#128200;' },
        ]
      },
      {
        id: 'config', label: 'Configuration', auth: 'sysAdmin',
        collapsed: ko.observable(true),
        items: [
          { id: 'perDiemRates',    label: 'Per Diem Rates',       icon: '&#128176;' },
          { id: 'countryGroups',   label: 'Country Groups',       icon: '&#127760;' },
          { id: 'docRequirements', label: 'Document Requirements', icon: '&#128196;' },
          { id: 'approvalRules',   label: 'Approval Rules',       icon: '&#128221;' },
          { id: 'moduleSettings',  label: 'Module Settings',      icon: '&#9881;'   },
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
      self.userMenuOpen(false);
      if (state) { Object.assign(self._state, state); }
      const freshUser = authService.getCurrentUser();
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
