define(['knockout', 'services/config', 'services/authService', 'services/approvalService', 'shared/i18n', 'shared/shell'],
function (ko, config, authService, approvalService, i18n, shell) {
  'use strict';

  function AppController() {
    const self = this;

    // ── Shared navigation state (passed to detail viewModels) ───────────
    self._state = {};

    // ── Shared shell (Phase 3): brand from settings + i18n ──────────────
    shell.initBrand('pc', function () {
      return new Promise(function (resolve) {
        require(['services/settingService'], function (settingService) {
          settingService.getValue('THEME_BRAND_COLOR').then(resolve).catch(function () { resolve(null); });
        }, function () { resolve(null); });
      });
    });
    self.t       = i18n.t;
    self.lang    = i18n.lang;
    self.setLang = i18n.setLang;

    // ── Module switcher (apps live side-by-side under "final apps/") ────
    self.modules       = shell.MODULES;
    self.currentModule = shell.byKey('pc');
    self.modswOpen     = ko.observable(false);
    self.toggleModsw   = function () { self.modswOpen(!self.modswOpen()); };
    self.switchModule  = function (m) {
      if (m.soon || !m.url) return;
      if (m.key === self.currentModule.key) { self.modswOpen(false); return; }
      window.location.href = m.url;   // root-absolute: "final apps/" is the web root in deployment
    };

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
          { id: 'dashboard', labelKey: 'nav.home', icon: '&#127968;' },
        ]
      },
      {
        id: 'myWork', labelKey: 'nav.myWork', auth: 'all',
        collapsed: ko.observable(false),
        items: [
          { id: 'myPettyCash',    labelKey: 'nav.myPettyCash',    icon: '&#128179;' },
          { id: 'pcRequest',      labelKey: 'nav.pcRequest',      icon: '&#10133;'  },
          { id: 'reimbursements', labelKey: 'nav.reimbursements', icon: '&#128196;' },
          { id: 'clearing',       labelKey: 'nav.clearing',       icon: '&#9989;'   },
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
        id: 'admin', labelKey: 'nav.adminGroup', auth: 'pcAdmin',
        collapsed: ko.observable(false),
        items: [
          { id: 'allPettyCash',      labelKey: 'nav.allPettyCash',      icon: '&#128202;' },
          { id: 'allReimbursements', labelKey: 'nav.allReimbursements', icon: '&#128204;' },
          { id: 'allClearings',      labelKey: 'nav.allClearings',      icon: '&#128205;' },
        ]
      },
      {
        id: 'config', labelKey: 'nav.config', auth: 'admin',
        collapsed: ko.observable(true),
        items: [
          { id: 'glCodes',        labelKey: 'nav.glCodes',        icon: '&#128200;' },
          { id: 'approvalRules',  labelKey: 'nav.approvalRules',  icon: '&#128196;' },
          { id: 'moduleSettings', labelKey: 'nav.moduleSettings', icon: '&#9881;'   },
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
