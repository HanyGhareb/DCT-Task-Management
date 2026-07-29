/**
 * appController.js — Finance KPIs V2 (App 213) shell controller.
 *
 * FPB portal chrome (pbar + pnav top tabs) over the standard multi-file
 * requirejs scaffold. Four top tabs (pages):
 *   me             — every KPI user
 *   admin          — KPI_ADMIN / SYS_ADMIN
 *   configurations — KPI_ADMIN / SYS_ADMIN
 *   settings       — KPI_ADMIN / SYS_ADMIN
 *
 * No real login here (platform rule): session is established by Admin JET
 * (App 200); when 'ifinance_jet_session' is absent we redirect there.
 * NOTE: deliberately NO shell.initBrand/initRegionTheme — the FPB tokens are
 * hard-coded in css/app.css (exact-FPB look is the whole point of V2).
 */
define(['knockout', 'services/config', 'services/authService', 'shared/i18n', 'shared/shell'],
function (ko, config, authService, i18n, shell) {
  'use strict';

  function AppController() {
    var self = this;
    var formGuard = { anyDirty: function () { return false; }, clearAll: function () {} };
    require(['shared/formGuard'], function (fg) { formGuard = fg; });

    self._state = {};

    self.t          = i18n.t;
    self.lang       = i18n.lang;
    self.toggleLang = i18n.toggle;

    self.currentUser = ko.observable(authService.getCurrentUser());
    self.ready       = ko.computed(function () { return !!self.currentUser(); });

    // ── App switcher (shared registry — KPI-V2 included) ────────────────
    self.modules        = shell.MODULES;
    self.currentModule  = shell.byKey('kpiv2');
    self.switcherOpen   = ko.observable(false);
    self.toggleSwitcher = function () { self.switcherOpen(!self.switcherOpen()); };
    self.goHome         = function () { window.location.href = config.adminPortalUrl; };

    self.userName = ko.computed(function () {
      var u = self.currentUser();
      return u ? (u.displayName || u.username || '') : '';
    });
    self.userInitials = ko.computed(function () {
      var parts = (self.userName() || '').split(' ');
      if (!parts[0]) return '?';
      return parts.length >= 2
        ? (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
        : parts[0][0].toUpperCase();
    });

    // ── Top tabs ─────────────────────────────────────────────────────────
    function _hasRole(user, role) { return !!(user && user.roles && user.roles.includes(role)); }
    function _isKpiAdmin(user) { return _hasRole(user, 'KPI_ADMIN') || _hasRole(user, 'SYS_ADMIN'); }

    var TABS = [
      { id: 'me',             labelKey: 'nav.me',             auth: 'all'   },
      { id: 'admin',          labelKey: 'nav.admin',          auth: 'admin' },
      { id: 'configurations', labelKey: 'nav.configurations', auth: 'admin' },
      { id: 'settings',       labelKey: 'nav.settings',       auth: 'admin' },
    ];

    self.visibleTabs = ko.computed(function () {
      var user = self.currentUser();
      return TABS.filter(function (tab) {
        return tab.auth === 'all' || _isKpiAdmin(user);
      });
    });

    self.currentTab   = ko.observable('');
    self.moduleConfig = ko.observable(null);

    function _tabById(id) {
      for (var i = 0; i < TABS.length; i++) if (TABS[i].id === id) return TABS[i];
      return null;
    }

    self._loadRoute = function (path) {
      var tab = _tabById(path);
      // unknown route, or an admin tab for a non-admin → land on Me
      if (!tab || (tab.auth === 'admin' && !_isKpiAdmin(self.currentUser()))) { path = 'me'; }
      if (window.location.hash !== '#' + path) {
        try { history.replaceState(null, '', '#' + path); } catch (e) {}
      }
      require(['text!views/' + path + '.html', 'viewModels/' + path],
        function (viewHtml, VMClass) {
          formGuard.clearAll();
          self.currentTab(path);
          self.moduleConfig({ view: viewHtml, viewModel: new VMClass() });
        },
        function (err) { console.error('[KPI2Router] Failed to load route:', path, err); }
      );
    };

    function _requireAuth() { self.currentUser(null); window.location.href = config.adminPortalUrl; }

    self.navigate = function (path, state) {
      if (path !== self.currentTab() && formGuard.anyDirty() && !window.confirm(i18n.t('guard.unsaved'))) return;
      self.switcherOpen(false);
      if (state) { Object.assign(self._state, state); }
      if (!authService.getCurrentUser()) { _requireAuth(); return; }
      self._loadRoute(path);
    };

    self.goTab = function (tab) { self.navigate(tab.id); };

    self.signOut = function () { authService.logout(); self._state = {}; _requireAuth(); };

    self.onLogin = function (user) { self.currentUser(user); self._loadRoute('me'); };

    var bootRoute = (window.location.hash || '').replace(/^#/, '');
    if (self.currentUser()) { self._loadRoute(bootRoute || 'me'); }
    else { _requireAuth(); }
  }

  return AppController;
});
