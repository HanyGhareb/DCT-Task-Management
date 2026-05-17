define(['knockout', 'services/config', 'services/authService', 'services/approvalService'],
function (ko, config, authService, approvalService) {
  'use strict';

  function AppController() {
    const self = this;

    // ── Shared navigation state (passed to detail viewModels) ───────────
    self._state = {};

    // ── Auth ────────────────────────────────────────────────────────────
    self.currentUser     = ko.observable(authService.getCurrentUser());
    self.isAuthenticated = ko.computed(() => !!self.currentUser());

    // ── Module config ────────────────────────────────────────────────────
    self.moduleConfig = ko.observable(null);

    // ── Navigation state ─────────────────────────────────────────────────
    self.sideNavOpen    = ko.observable(true);
    self.currentNavItem = ko.observable('');
    self.userMenuOpen   = ko.observable(false);

    self.isLoginPage = ko.computed(() =>
      !self.isAuthenticated() || self.currentNavItem() === 'login'
    );

    // ── Notification / pending counts ────────────────────────────────────
    self.unreadCount  = ko.observable(0);
    self.pendingCount = ko.observable(0);

    function _refreshCounts() {
      const user = authService.getCurrentUser();
      if (!user) return;
      self.unreadCount(authService.getUnreadCount());
      self.pendingCount(approvalService.getPendingCountForUser(user));
    }

    // ── Role helpers ─────────────────────────────────────────────────────
    function _hasRole(user, role) {
      return user && user.roles && user.roles.includes(role);
    }
    function _isApprover(user) {
      return _hasRole(user, 'MANAGER') || _hasRole(user, 'AP_PETTY_CASH_ADMIN') || _hasRole(user, 'SYS_ADMIN');
    }
    function _isPcAdmin(user) {
      return _hasRole(user, 'AP_PETTY_CASH_ADMIN') || _hasRole(user, 'SYS_ADMIN');
    }
    function _isAdmin(user) {
      return _hasRole(user, 'SYS_ADMIN');
    }

    // ── Nav groups ───────────────────────────────────────────────────────
    const NAV_GROUPS = [
      {
        id: 'home', standalone: true, auth: 'all',
        items: [
          { id: 'dashboard', label: 'Home', icon: '&#127968;' },
        ]
      },
      {
        id: 'myWork', label: 'My Petty Cash', auth: 'all',
        collapsed: ko.observable(false),
        items: [
          { id: 'myPettyCash',    label: 'My Petty Cash',    icon: '&#128179;' },
          { id: 'pcRequest',      label: 'New Request',       icon: '&#10133;'  },
          { id: 'reimbursements', label: 'Reimbursements',    icon: '&#128196;' },
          { id: 'clearing',       label: 'Clearing',          icon: '&#9989;'   },
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
        id: 'admin', label: 'Administration', auth: 'pcAdmin',
        collapsed: ko.observable(false),
        items: [
          { id: 'allPettyCash',      label: 'All Petty Cash',      icon: '&#128202;' },
          { id: 'allReimbursements', label: 'All Reimbursements',   icon: '&#128204;' },
          { id: 'allClearings',      label: 'All Clearings',        icon: '&#128205;' },
        ]
      },
      {
        id: 'config', label: 'Configuration', auth: 'admin',
        collapsed: ko.observable(true),
        items: [
          { id: 'glCodes',        label: 'GL Code Combinations', icon: '&#128200;' },
          { id: 'approvalRules',  label: 'Approval Rules',        icon: '&#128196;' },
          { id: 'moduleSettings', label: 'Module Settings',       icon: '&#9881;'   },
        ]
      },
    ];

    self.navGroups = ko.computed(() => {
      const user = self.currentUser();
      return NAV_GROUPS.filter(function (g) {
        if (g.auth === 'all')      return true;
        if (g.auth === 'approver') return _isApprover(user);
        if (g.auth === 'pcAdmin')  return _isPcAdmin(user);
        if (g.auth === 'admin')    return _isAdmin(user);
        return false;
      });
    });

    self.toggleGroup = function (group) {
      group.collapsed(!group.collapsed());
    };

    // ── User helpers ─────────────────────────────────────────────────────
    self.userInitials = ko.computed(() => {
      const user = self.currentUser();
      if (!user) return '?';
      const parts = (user.displayName || user.username || '').split(' ');
      return parts.length >= 2
        ? (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
        : (parts[0] || '?')[0].toUpperCase();
    });

    // ── Route loader ──────────────────────────────────────────────────────
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
        function (err) {
          console.error('[PCRouter] Failed to load route:', path, err);
        }
      );
    };

    // ── Auth guard ────────────────────────────────────────────────────────
    // Production: redirect browser to Admin JET portal (the identity provider).
    // Mock/dev:   load the local login page for standalone testing.
    function _requireAuth() {
      self.currentUser(null);
      if (config.apiBase) {
        window.location.href = '../Admin/Jet/index.html';
      } else {
        self._loadRoute('login');
      }
    }

    // ── Public navigate ───────────────────────────────────────────────────
    self.navigate = function (path, state) {
      self.userMenuOpen(false);
      if (state) { Object.assign(self._state, state); }
      const freshUser = authService.getCurrentUser();
      if (!freshUser) {
        _requireAuth();
        return;
      }
      self._loadRoute(path);
    };

    // ── Shell actions ─────────────────────────────────────────────────────
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

    // Called by mock login page only (dev mode).
    self.onLogin = function (user) {
      self.currentUser(user);
      _refreshCounts();
      self._loadRoute('dashboard');
    };

    // ── Boot ──────────────────────────────────────────────────────────────
    if (self.currentUser()) {
      self._loadRoute('dashboard');
    } else {
      _requireAuth();
    }
  }

  return AppController;
});
