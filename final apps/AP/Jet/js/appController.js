define(['knockout', 'services/config', 'services/authService', 'shared/i18n', 'shared/shell'],
function (ko, config, authService, i18n, shell) {
  'use strict';

  function AppController() {
    var self = this;
    var formGuard = { anyDirty: function () { return false; }, clearAll: function () {} };
    require(['shared/formGuard'], function (fg) { formGuard = fg; });

    self._state = {};

    // ── Shared shell: brand + i18n ──────────────────────────────────────
    shell.initBrand('ap');
    shell.initAnnouncements('ap', config.authBase || config.apiBase);
    shell.initRegionTheme(config.authBase || config.apiBase, function () {
      return Promise.resolve(null);   // AP has no module-settings row; registry default brand
    });
    self.t       = i18n.t;
    self.lang    = i18n.lang;
    self.setLang = i18n.setLang;

    // ── Module switcher ─────────────────────────────────────────────────
    self.modules       = shell.MODULES;
    self.currentModule = shell.byKey('ap');
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
      { id: 'main', items: [
        { id: 'home',      labelKey: 'nav.home' },
        { id: 'dashboard', labelKey: 'nav.dashboard' },
      ] }
    ];
    self.navGroups = ko.computed(function () { return NAV_GROUPS; });

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
        if (window.location.hash) {
          try { history.replaceState(null, '', window.location.pathname); } catch (e) {}
        }
      } else if (window.location.hash !== '#' + path) {
        try { history.replaceState(null, '', '#' + path); } catch (e) {}
      }
      require(
        ['text!views/' + path + '.html', 'viewModels/' + path],
        function (viewHtml, VMClass) {
          formGuard.clearAll();
          self.currentNavItem(path);
          self.moduleConfig({ view: viewHtml, viewModel: new VMClass() });
        },
        function (err) { console.error('[APRouter] Failed to load route:', path, err); }
      );
    };

    function _requireAuth() {
      self.currentUser(null);
      window.location.href = config.adminPortalUrl;
    }

    self.navigate = function (path, state) {
      if (path !== self.currentNavItem() && formGuard.anyDirty() &&
          !window.confirm(i18n.t('guard.unsaved'))) {
        return;
      }
      self.userMenuOpen(false);
      self.modswOpen(false);
      if (state) { Object.assign(self._state, state); }
      var freshUser = authService.getCurrentUser();
      if (!freshUser) { _requireAuth(); return; }
      self._loadRoute(path);
    };

    self.toggleNav      = function () { self.sideNavOpen(!self.sideNavOpen()); };
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
      self._loadRoute('home');
    };

    var bootRoute = (window.location.hash || '').replace(/^#/, '');
    if (self.currentUser()) {
      self._loadRoute(bootRoute || 'home');
    } else {
      _requireAuth();
    }
  }

  return AppController;
});
