define(['knockout', 'services/config', 'services/authService', 'services/flService', 'shared/i18n', 'shared/shell'],
function (ko, config, authService, flService, i18n, shell) {
  'use strict';

  function AppController() {
    var self = this;

    self._state = {};

    // ── Shared shell: brand + i18n ──────────────────────────────────────
    shell.initBrand('fl');
    shell.initAnnouncements('fl', config.authBase || config.apiBase);
    self.t       = i18n.t;
    self.lang    = i18n.lang;
    self.setLang = i18n.setLang;

    // ── Module switcher ─────────────────────────────────────────────────
    self.modules       = shell.MODULES;
    self.currentModule = shell.byKey('fl');
    self.modswOpen     = ko.observable(false);
    self.toggleModsw   = function () { self.modswOpen(!self.modswOpen()); };
    self.switchModule  = function (m) {
      if (m.soon || !m.url) return;
      if (m.key === self.currentModule.key) { self.modswOpen(false); return; }
      window.location.href = m.url;
    };

    self.currentUser     = ko.observable(authService.getCurrentUser());
    self.isAuthenticated = ko.computed(function () { return !!self.currentUser(); });
    self.moduleConfig    = ko.observable(null);

    self.sideNavOpen    = ko.observable(true);
    self.currentNavItem = ko.observable('');
    self.userMenuOpen   = ko.observable(false);

    self.isLoginPage = ko.computed(function () {
      return !self.isAuthenticated() || self.currentNavItem() === 'login';
    });

    self.unreadCount    = ko.observable(0);
    self.pendingCount   = ko.observable(0);   // approvals badge
    self.expiringDocs   = ko.observable(0);   // compliance badge

    function _refreshCounts() {
      if (!authService.getCurrentUser()) return;
      flService.getNotifications().then(function (items) {
        self.unreadCount(items.filter(function (n) { return n.isRead === 'N'; }).length);
      }).catch(function () {});
      flService.getPendingApprovals().then(function (items) {
        self.pendingCount(items.length);
      }).catch(function () {});
      flService.getStats().then(function (s) {
        self.expiringDocs(s.docsExpiring || 0);
      }).catch(function () {});
    }

    function _hasRole(user, role) {
      return user && user.roles && user.roles.includes(role);
    }
    function _isFlAdmin(user)   { return _hasRole(user, 'FL_ADMIN') || _hasRole(user, 'SYS_ADMIN'); }
    function _isFlManager(user) { return _hasRole(user, 'FL_MANAGER') || _isFlAdmin(user); }
    function _isFlViewer(user)  { return _hasRole(user, 'FL_USER') || _isFlManager(user); }

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
          { id: 'registrations', labelKey: 'nav.registrations', icon: '&#128221;' },
          { id: 'freelancers',   labelKey: 'nav.freelancers',   icon: '&#128100;' },
        ]
      },
      {
        id: 'contracts', labelKey: 'nav.contractsGroup', auth: 'viewer',
        collapsed: ko.observable(false),
        items: [
          { id: 'contracts',       labelKey: 'nav.contracts',       icon: '&#128196;' },
          { id: 'paymentSchedule', labelKey: 'nav.paymentSchedule', icon: '&#128197;' },
        ]
      },
      {
        id: 'payments', labelKey: 'nav.payments', auth: 'viewer',
        collapsed: ko.observable(false),
        items: [
          { id: 'vouchers',     labelKey: 'nav.vouchers',     icon: '&#128181;' },
          { id: 'deliverables', labelKey: 'nav.deliverables', icon: '&#128230;' },
        ]
      },
      {
        id: 'compliance', labelKey: 'nav.compliance', auth: 'manager',
        collapsed: ko.observable(false),
        items: [
          { id: 'documents', labelKey: 'nav.documents', icon: '&#128206;', badge: self.expiringDocs },
        ]
      },
      {
        id: 'approvals', labelKey: 'nav.approvalsGroup', auth: 'manager',
        collapsed: ko.observable(false),
        items: [
          { id: 'approvals', labelKey: 'nav.approvals', icon: '&#9989;', badge: self.pendingCount },
        ]
      },
      {
        id: 'admin', labelKey: 'nav.adminGroup', auth: 'admin',
        collapsed: ko.observable(false),
        items: [
          { id: 'moduleSettings', labelKey: 'nav.moduleSettings', icon: '&#9881;' },
        ]
      },
    ];

    self.navGroups = ko.computed(function () {
      var user = self.currentUser();
      return NAV_GROUPS.filter(function (g) {
        if (g.auth === 'all')     return true;
        if (g.auth === 'viewer')  return _isFlViewer(user);
        if (g.auth === 'manager') return _isFlManager(user);
        if (g.auth === 'admin')   return _isFlAdmin(user);
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
      // hash mirror so F5 restores the page
      if (path === 'login') {
        if (window.location.hash) {
          try { history.replaceState(null, '', window.location.pathname); } catch (e) {}
        }
      } else if (window.location.hash !== '#' + path) {
        try { history.replaceState(null, '', '#' + path); } catch (e) {}
      }
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
        function (err) { console.error('[FLRouter] Failed to load route:', path, err); }
      );
    };

    function _requireAuth() {
      self.currentUser(null);
      window.location.href = config.adminPortalUrl;
    }

    self.navigate = function (path, state) {
      self.userMenuOpen(false);
      self.modswOpen(false);
      if (state) { Object.assign(self._state, state); }
      var freshUser = authService.getCurrentUser();
      if (!freshUser) { _requireAuth(); return; }
      self._loadRoute(path);
    };

    self.toggleNav      = function () { self.sideNavOpen(!self.sideNavOpen()); };
    /* Bound to <main> via click: — MUST return true, or KO preventDefaults
       every click that bubbles up and kills native default actions. */
    self.closeUserMenu  = function () { self.userMenuOpen(false); self.modswOpen(false); return true; };
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

    // ── Boot (hash survives F5) ─────────────────────────────────────────
    var bootRoute = (window.location.hash || '').replace(/^#/, '');
    if (self.currentUser()) {
      self._loadRoute(bootRoute || 'dashboard');
    } else {
      _requireAuth();
    }
  }

  return AppController;
});
