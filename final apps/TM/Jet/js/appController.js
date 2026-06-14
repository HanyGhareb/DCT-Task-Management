define(['knockout', 'services/config', 'services/authService', 'services/tmService', 'shared/i18n', 'shared/shell'],
function (ko, config, authService, tmService, i18n, shell) {
  'use strict';

  function AppController() {
    var self = this;
    var formGuard = { anyDirty: function () { return false; }, clearAll: function () {} };
    require(['shared/formGuard'], function (fg) { formGuard = fg; });

    self._state = {};

    // ── Shared shell: brand + i18n + region theme ───────────────────────
    shell.initBrand('tm');
    shell.initAnnouncements('tm', config.authBase);
    shell.initRegionTheme(config.authBase);
    self.t       = i18n.t;
    self.lang    = i18n.lang;
    self.setLang = i18n.setLang;

    // ── Module switcher ─────────────────────────────────────────────────
    self.modules       = shell.MODULES;
    self.currentModule = shell.byKey('tm');
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

    self.unreadCount  = ko.observable(0);
    self.pendingCount = ko.observable(0);

    function _refreshCounts() {
      if (!authService.getCurrentUser()) return;
      tmService.getNotifications().then(function (items) {
        self.unreadCount((items || []).filter(function (n) {
          return (n.isRead || n.is_read) === 'N';
        }).length);
      }).catch(function () {});
    }

    function _hasRole(user, role) { return user && user.roles && user.roles.includes(role); }
    function _isTmAdmin(user) { return _hasRole(user, 'TM_ADMIN') || _hasRole(user, 'SYS_ADMIN'); }
    function _isManager(user) { return _hasRole(user, 'MANAGER') || _hasRole(user, 'TASK_DIRECTOR') || _isTmAdmin(user); }

    var NAV_GROUPS = [
      { id: 'home', standalone: true, auth: 'all', items: [
          { id: 'dashboard', labelKey: 'nav.home', icon: '&#127968;' } ] },
      { id: 'work', labelKey: 'nav.workGroup', auth: 'all', collapsed: ko.observable(false), items: [
          { id: 'myWork', labelKey: 'nav.myWork', icon: '&#9989;' },
          { id: 'teams',  labelKey: 'nav.teams',  icon: '&#128101;' },
          { id: 'library',labelKey: 'nav.library',icon: '&#128193;' } ] },
      { id: 'insights', labelKey: 'nav.insightsGroup', auth: 'mgr', collapsed: ko.observable(false), items: [
          { id: 'reports', labelKey: 'nav.reports', icon: '&#128202;' } ] },
      { id: 'admin', labelKey: 'nav.adminGroup', auth: 'admin', collapsed: ko.observable(false), items: [
          { id: 'teamRoles', labelKey: 'nav.teamRoles', icon: '&#128272;' } ] },
      { id: 'prefs', standalone: true, auth: 'all', items: [
          { id: 'preferences', labelKey: 'nav.preferences', icon: '&#9881;' } ] }
    ];

    self.navGroups = ko.computed(function () {
      var user = self.currentUser();
      return NAV_GROUPS.filter(function (g) {
        if (g.auth === 'all')   return true;
        if (g.auth === 'mgr')   return _isManager(user);
        if (g.auth === 'admin') return _isTmAdmin(user);
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
      if (path === 'login') {
        if (window.location.hash) { try { history.replaceState(null, '', window.location.pathname); } catch (e) {} }
      } else if (window.location.hash !== '#' + path) {
        try { history.replaceState(null, '', '#' + path); } catch (e) {}
      }
      NAV_GROUPS.forEach(function (g) {
        if (g.collapsed && g.items && g.items.some(function (i) { return i.id === path; })) g.collapsed(false);
      });
      require(['text!views/' + path + '.html', 'viewModels/' + path],
        function (viewHtml, VMClass) {
          formGuard.clearAll();
          self.currentNavItem(path);
          self.moduleConfig({ view: viewHtml, viewModel: new VMClass() });
          _refreshCounts();
        },
        function (err) { console.error('[TMRouter] Failed to load route:', path, err); }
      );
    };

    function _requireAuth() { self.currentUser(null); window.location.href = config.adminPortalUrl; }

    self.navigate = function (path, state) {
      if (path !== self.currentNavItem() && formGuard.anyDirty() && !window.confirm(i18n.t('guard.unsaved'))) return;
      self.userMenuOpen(false); self.modswOpen(false);
      if (state) { Object.assign(self._state, state); }
      if (!authService.getCurrentUser()) { _requireAuth(); return; }
      self._loadRoute(path);
    };

    self.toggleNav      = function () { self.sideNavOpen(!self.sideNavOpen()); };
    self.closeUserMenu  = function () { self.userMenuOpen(false); self.modswOpen(false); return true; };
    self.toggleUserMenu = function (vm, event) { event.stopPropagation(); self.userMenuOpen(!self.userMenuOpen()); };

    self.logout = function () { authService.logout(); self.userMenuOpen(false); self._state = {}; _requireAuth(); };

    self.onLogin = function (user) { self.currentUser(user); _refreshCounts(); self._loadRoute('dashboard'); };

    var bootRoute = (window.location.hash || '').replace(/^#/, '');

    require(['shared/commandPalette', 'shared/idleWarn', 'services/api'],
      function (cp, idleWarn, api) {
        function deEntity(s) { var d = document.createElement('div'); d.innerHTML = s || ''; return d.textContent; }
        var navItems = [];
        NAV_GROUPS.forEach(function (g) { (g.items || []).forEach(function (it) { navItems.push(it); }); });
        cp.init({
          t: i18n.t,
          enabled: function () { return !!self.currentUser(); },
          providers: [ { group: i18n.t('cmdp.groupNav'), min: 0, search: function (q) {
              var ql = (q || '').toLowerCase();
              return navItems.filter(function (it) { return !ql || i18n.t(it.labelKey).toLowerCase().indexOf(ql) >= 0; })
                .slice(0, q ? 6 : 7).map(function (it) {
                  return { icon: deEntity(it.icon), title: i18n.t(it.labelKey), run: function () { self.navigate(it.id); } };
                });
          } } ]
        });
        idleWarn.init({
          timeoutMins: 480, warnMins: 5, t: i18n.t,
          enabled: function () { return !!self.currentUser(); },
          onExtend: function () { api.get('/notifications/count', { base: 'auth', silent: true }).catch(function () {}); },
          onTimeout: function () { self.logout(); }
        });
      });

    if (self.currentUser()) { self._loadRoute(bootRoute || 'dashboard'); }
    else { _requireAuth(); }
  }

  return AppController;
});
