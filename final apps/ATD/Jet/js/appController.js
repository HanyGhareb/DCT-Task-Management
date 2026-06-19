define(['knockout', 'services/config', 'services/authService', 'services/atdService', 'shared/i18n', 'shared/shell'],
function (ko, config, authService, atd, i18n, shell) {
  'use strict';

  function AppController() {
    var self = this;

    self._state = {};

    // ── Shared shell: brand + i18n + region theme ───────────────────────
    shell.initBrand('atd');
    shell.initRegionTheme(config.authBase);
    self.t       = i18n.t;
    self.lang    = i18n.lang;
    self.setLang = i18n.setLang;

    // ── Module switcher ─────────────────────────────────────────────────
    self.modules       = shell.MODULES;
    self.currentModule = shell.byKey('atd');
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

    var NAV_GROUPS = [
      { id: 'home', standalone: true, items: [
          { id: 'dashboard', labelKey: 'atd.nav.dashboard' } ] },
      { id: 'ops', labelKey: 'atd.nav.opsGroup', collapsed: ko.observable(false), items: [
          { id: 'jobs',      labelKey: 'atd.nav.jobs' },
          { id: 'queue',     labelKey: 'atd.nav.queue' },
          { id: 'discovery', labelKey: 'atd.nav.discovery' },
          { id: 'runs',      labelKey: 'atd.nav.runs' } ] },
      { id: 'config', labelKey: 'atd.nav.configGroup', collapsed: ko.observable(false), items: [
          { id: 'environments',   labelKey: 'atd.nav.environments' },
          { id: 'targets',        labelKey: 'atd.nav.targets' },
          { id: 'runnerSettings', labelKey: 'atd.nav.runnerSettings' } ] }
    ];

    self.navGroups = ko.computed(function () { return NAV_GROUPS; });
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
          self.currentNavItem(path);
          self.moduleConfig({ view: viewHtml, viewModel: new VMClass() });
        },
        function (err) { console.error('[ATDRouter] Failed to load route:', path, err); }
      );
    };

    function _requireAuth() { self.currentUser(null); window.location.href = config.adminPortalUrl; }

    self.navigate = function (path, state) {
      self.userMenuOpen(false); self.modswOpen(false);
      if (state) { Object.assign(self._state, state); }
      if (!authService.getCurrentUser()) { _requireAuth(); return; }
      self._loadRoute(path);
    };

    self.toggleNav      = function () { self.sideNavOpen(!self.sideNavOpen()); };
    self.closeUserMenu  = function () { self.userMenuOpen(false); self.modswOpen(false); return true; };
    self.toggleUserMenu = function (vm, event) { event.stopPropagation(); self.userMenuOpen(!self.userMenuOpen()); };

    self.logout = function () { authService.logout(); self.userMenuOpen(false); self._state = {}; _requireAuth(); };

    self.onLogin = function (user) { self.currentUser(user); self._loadRoute('dashboard'); };

    var bootRoute = (window.location.hash || '').replace(/^#/, '');
    if (self.currentUser()) { self._loadRoute(bootRoute || 'dashboard'); }
    else { _requireAuth(); }
  }

  return AppController;
});
