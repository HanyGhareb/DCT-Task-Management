define(
  ['knockout', 'services/authService', 'services/themeService', 'shared/i18n', 'shared/shell',
   'shared/formGuard'],
  function (ko, authService, themeService, i18n, shell, formGuard) {
  'use strict';

  function AppController() {
    const self = this;

    // ── Theme: persisted data-theme + settings-driven brand color ───────
    themeService.init();
    shell.initBrand('admin');   // THEME_BRAND_COLOR override applied post-login (see onLogin)

    // Platform announcement banner (Phase 4) — no-op until a session exists
    self._initAnnouncements = function () {
      require(['services/config'], function (config) {
        shell.initAnnouncements('admin', config.authBase || config.apiBase);
      });
    };
    self._initAnnouncements();

    // ── i18n (Phase 3): t() + live language switching ────────────────────
    // localStorage is the primary store; the LANG row in DCT_USER_PREFERENCES
    // (PUT /prefs/LANG) makes the preference follow the user across devices.
    self.t    = i18n.t;
    self.lang = i18n.lang;
    self.setLang = function (l) {
      i18n.setLang(l);   // marks the choice as user-made (i18n.wasUserSet)
      // Pre-login there is no session to PUT against (and a 401 would bounce
      // the login view) — onLogin pushes the choice once authenticated.
      if (!authService.getCurrentUser()) return;
      require(['services/api'], function (api) {
        api.put('/prefs/LANG', { value: l }, { silent: true }).catch(function () {});
      });
    };
    /* LOG-07: explicit choice this session > stored server pref > default.
       If the user picked a language on the login page, push it to the server;
       otherwise adopt the server-stored preference. */
    self._syncServerLang = function () {
      require(['services/api'], function (api) {
        if (i18n.wasUserSet()) {
          api.put('/prefs/LANG', { value: i18n.lang() }, { silent: true }).catch(function () {});
          return;
        }
        api.get('/prefs/', { silent: true }).then(function (r) {
          var row = (r.items || []).find(function (p) { return p.key === 'LANG'; });
          if (row && row.value && row.value !== i18n.lang()) i18n.setLang(row.value, { system: true });
        }).catch(function () {});
      });
    };

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

    // ── Module switcher (shared shell, Phase 3) ─────────────────────────
    self.modules       = shell.MODULES;
    self.currentModule = shell.byKey('admin');
    self.modswOpen     = ko.observable(false);
    self.toggleModsw   = function () { self.modswOpen(!self.modswOpen()); };
    self.switchModule  = function (m) {
      if (m.soon) return;
      if (m.key === self.currentModule.key) { self.modswOpen(false); return; }
      if (m.url) window.location.href = m.url;
    };

    // ── Nav groups — collapsible sections (labels via i18n keys) ────────
    const NAV_GROUPS = [
      {
        id: 'home', standalone: true, auth: 'all',
        items: [
          { id: 'dashboard', labelKey: 'nav.home', icon: '&#127968;' },
        ]
      },
      {
        id: 'workspace', labelKey: 'nav.workspace', auth: 'all',
        collapsed: ko.observable(false),
        items: [
          { id: 'profile',          labelKey: 'nav.profile',          icon: '&#128100;' },
          { id: 'notifications',    labelKey: 'nav.notifications',    icon: '&#128276;' },
          { id: 'pendingApprovals', labelKey: 'nav.pendingApprovals', icon: '&#9989;'   },
          { id: 'myWorklist',       labelKey: 'nav.myWorklist',       icon: '&#128203;' },
          { id: 'myDelegations',    labelKey: 'nav.myDelegations',    icon: '&#127958;' },
        ]
      },
      {
        id: 'userMgmt', labelKey: 'nav.userMgmt', auth: 'admin',
        collapsed: ko.observable(false),
        items: [
          { id: 'users',       labelKey: 'nav.users',       icon: '&#128101;' },
          { id: 'roles',       labelKey: 'nav.roles',       icon: '&#128737;' },
          { id: 'permissions', labelKey: 'nav.permissions', icon: '&#128273;' },
        ]
      },
      {
        id: 'securityConsole', labelKey: 'nav.securityConsole', auth: 'admin',
        collapsed: ko.observable(false),
        items: [
          { id: 'privileges',      labelKey: 'nav.privileges',      icon: '&#128272;' },
          { id: 'privilegeGroups', labelKey: 'nav.privilegeGroups', icon: '&#128450;' },
          { id: 'abstractRoles',   labelKey: 'nav.abstractRoles',   icon: '&#129489;' },
          { id: 'dutyRoles',       labelKey: 'nav.dutyRoles',       icon: '&#129513;' },
          { id: 'jobRoles',        labelKey: 'nav.jobRoles',        icon: '&#128188;' },
          { id: 'secProfiles',     labelKey: 'nav.secProfiles',     icon: '&#128274;' },
          { id: 'userManagement',  labelKey: 'nav.userManagement',  icon: '&#128101;' },
        ]
      },
      {
        id: 'organisation', labelKey: 'nav.organisation', auth: 'admin',
        collapsed: ko.observable(false),
        items: [
          { id: 'orgHierarchy', labelKey: 'nav.orgHierarchy', icon: '&#127959;' },
        ]
      },
      {
        id: 'ifinanceModules', labelKey: 'nav.ifinanceModules', auth: 'all',
        collapsed: ko.observable(false),
        items: [
          { id: 'hr-module', labelKey: 'mod.hr', icon: '&#128101;', url: '/HR/Jet/index.html' },
        ]
      },
      {
        id: 'system', labelKey: 'nav.system', auth: 'admin',
        collapsed: ko.observable(false),
        items: [
          { id: 'modules',           labelKey: 'nav.modules',           icon: '&#9707;'   },
          { id: 'processes',         labelKey: 'nav.processes',         icon: '&#128736;' },
          { id: 'roleAssignments',   labelKey: 'nav.roleAssignments',   icon: '&#129333;' },
          { id: 'approvalTemplates', labelKey: 'nav.approvalTemplates', icon: '&#128196;' },
          { id: 'approvalMonitor',   labelKey: 'nav.approvalMonitor',   icon: '&#128065;' },
          { id: 'delegations',       labelKey: 'nav.delegations',       icon: '&#129309;' },
          { id: 'announcements',     labelKey: 'nav.announcements',     icon: '&#128226;' },
          { id: 'lookups',           labelKey: 'nav.lookups',           icon: '&#128203;' },
          { id: 'appearance',        labelKey: 'nav.appearance',        icon: '&#127912;' },
          { id: 'systemSettings',    labelKey: 'nav.systemSettings',    icon: '&#9881;'   },
          { id: 'sessions',          labelKey: 'nav.sessions',          icon: '&#128274;' },
          { id: 'auditLog',          labelKey: 'nav.auditLog',          icon: '&#128218;' },
          { id: 'runners',           labelKey: 'nav.runners',           icon: '&#129302;' },
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

    self.unreadCount = ko.observable(0);

    /* ── live unread badge (Wave 1 / UAT WSP-10) ─────────────────────────
       The badge used to be fetched once at boot and went stale until reload.
       Poll every 60s while the tab is visible; refresh immediately when the
       tab regains focus and (throttled) on navigation, so marking
       notifications read updates the badge without a reload. */
    var lastUnreadFetch = 0;
    self._refreshUnread = function (force) {
      if (!self.currentUser()) { self.unreadCount(0); return; }
      var now = Date.now();
      if (!force && now - lastUnreadFetch < 15000) return;
      lastUnreadFetch = now;
      authService.getUnreadCount().then(function (n) {
        var prev = self.unreadCount();
        self.unreadCount(n);
        if (n > prev && prev !== 0) {
          require(['shared/toast'], function (toast) {
            toast.info(i18n.t('notif.newToast'));
          });
        }
      }).catch(function () {});
    };
    self._refreshUnread(true);
    setInterval(function () {
      if (document.visibilityState === 'visible') self._refreshUnread();
    }, 60000);
    document.addEventListener('visibilitychange', function () {
      if (document.visibilityState === 'visible') self._refreshUnread();
    });

    // ── Internal route loader ───────────────────────────────────────────
    // Uses RequireJS text! plugin for HTML and AMD for the viewModel class.
    self._loadRoute = function (path) {
      // Keep the route in the URL hash so F5 restores the same page
      if (path === 'login') {
        if (window.location.hash) {
          try { history.replaceState(null, '', window.location.pathname); } catch (e) {}
        }
      } else if (window.location.hash !== '#' + path) {
        try { history.replaceState(null, '', '#' + path); } catch (e) {}
      }
      // Auto-expand the group that contains this route
      NAV_GROUPS.forEach(function (g) {
        if (g.collapsed && g.items && g.items.some(function (item) { return item.id === path; })) {
          g.collapsed(false);
        }
      });
      // Wave 2 (3.4): skeleton-first swap — if the view fetch takes longer
      // than 120ms (cold cache / slow link), show shimmer rows immediately
      // instead of freezing on the previous page. Cached routes never flash.
      var routePending = true;
      var skTimer = setTimeout(function () {
        if (!routePending) return;
        self.moduleConfig({
          view: '<div class="page-wrap">' +
                '<div class="skeleton" style="height:54px;border-radius:10px;margin-block-end:18px"></div>' +
                '<list-skeleton params="rows: 8"></list-skeleton></div>',
          viewModel: {}
        });
      }, 120);
      require(
        ['text!views/' + path + '.html', 'viewModels/' + path],
        function (viewHtml, VMClass) {
          routePending = false;
          clearTimeout(skTimer);
          // route swap disposes the old view — its dirty-guards go with it
          formGuard.clearAll();
          self.currentNavItem(path);
          // enh-5: recent-pages trail for the command palette (cap 6, no login)
          if (path !== 'login') {
            try {
              var rec = JSON.parse(sessionStorage.getItem('recentRoutes') || '[]')
                .filter(function (r) { return r !== path; });
              rec.unshift(path);
              sessionStorage.setItem('recentRoutes', JSON.stringify(rec.slice(0, 6)));
            } catch (e) {}
          }
          self.moduleConfig({ view: viewHtml, viewModel: new VMClass() });
        },
        function (err) {
          routePending = false;
          clearTimeout(skTimer);
          console.error('[Router] Failed to load route:', path, err);
        }
      );
    };

    // ── Public navigate ─────────────────────────────────────────────────
    self.navigate = function (path) {
      // Wave 2: unsaved-changes guard — same wording the browser uses on close
      if (path !== self.currentNavItem() && formGuard.anyDirty() &&
          !window.confirm(i18n.t('guard.unsaved'))) {
        return;
      }
      self.userMenuOpen(false);
      self.modswOpen(false);
      self._refreshUnread();   // throttled — keeps the bell badge honest
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
    /* Bound to <main> via click: — MUST return true, or KO preventDefaults
       every click that bubbles up and kills native default actions
       (file-picker open, checkbox toggle, …). */
    self.closeUserMenu  = function () { self.userMenuOpen(false); self.modswOpen(false); return true; };

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

    /* Wave 3 (3.3): one GET /boot replaces the post-login fan-out
       (unread count + prefs + settings/flags/brand). Falls back to the
       individual calls until the endpoint is deployed. */
    self._bootSettings = {};   // key → value from /boot (LANDING_*, FEATURE_*, theme)
    self._bootstrap = function () {
      if (!self.currentUser()) return Promise.resolve();
      // Module switcher visibility (db/v2/49): module apps get this via
      // shell.initRegionTheme; Admin triggers it here. Fail-open.
      require(['services/config'], function (config) {
        shell.initModuleAccess(config.authBase || config.apiBase);
      });
      return new Promise(function (resolve) {
        require(['services/api'], function (api) {
          api.get('/boot', { silent: true }).then(function (b) {
            if (typeof b.unreadCount === 'number') self.unreadCount(b.unreadCount);
            if (i18n.wasUserSet()) {
              api.put('/prefs/LANG', { value: i18n.lang() }, { silent: true }).catch(function () {});
            } else if (b.prefs && b.prefs.LANG && b.prefs.LANG !== i18n.lang()) {
              i18n.setLang(b.prefs.LANG, { system: true });
            }
            if (b.settings && b.settings.length) {
              self._bootSettings = {};
              b.settings.forEach(function (s) { self._bootSettings[s.key] = s.value; });
              shell.setFeatures(b.settings);
              self._featRev(self._featRev() + 1);
              if (self._bootSettings.THEME_BRAND_COLOR) {
                shell.applyBrand(self._bootSettings.THEME_BRAND_COLOR);
              }
              shell.applyRegionTheme(self._bootSettings);
              // Cross-UI SSO hand-off (db/v2/41): module apps get the APEX
              // button via shell.initRegionTheme; Admin injects it here.
              if (self._bootSettings.FEATURE_SSO_HANDOFF === 'Y') {
                require(['services/config'], function (config) {
                  shell.injectApexLink(config.authBase || config.apiBase);
                });
              }
              if (self._idleWarn && self._bootSettings.SESSION_TIMEOUT_MINS) {
                self._idleWarn.setTimeoutMins(Number(self._bootSettings.SESSION_TIMEOUT_MINS));
              }
            }
            resolve();
          }).catch(function () {
            self._refreshUnread(true);
            self._applyServerTheme();
            self._syncServerLang();
            self._loadFeatures();
            resolve();
          });
        });
      });
    };

    // ── idle-session warning (Wave 3, 4.6) ──────────────────────────────
    // Server enforces SESSION_TIMEOUT_MINS of inactivity (db/v2/19); warn
    // 5 minutes before so nobody loses a half-filled form to a silent 401.
    require(['shared/idleWarn', 'services/api'], function (idleWarn, api) {
      idleWarn.init({
        timeoutMins: 480, warnMins: 5, t: i18n.t,
        enabled: function () {
          return !!self.currentUser() && shell.featureEnabled('IDLE_WARNING', true);
        },
        onExtend: function () {
          // any authenticated call touches the session server-side
          api.get('/notifications/count', { silent: true }).catch(function () {});
        },
        onTimeout: function () { self.logout(); }
      });
      self._idleWarn = idleWarn;
    });

    /* Wave 3 (4.3): per-role landing page — a LANDING_<ROLE> system setting
       (e.g. LANDING_MANAGER = pendingApprovals) decides the post-login route.
       First of the user's roles with a configured, valid route wins. */
    var KNOWN_ROUTES = ['dashboard', 'profile', 'notifications', 'pendingApprovals', 'myDelegations',
      'users', 'roles', 'permissions', 'orgHierarchy', 'modules', 'approvalTemplates',
      'approvalMonitor', 'delegations', 'announcements', 'lookups', 'appearance',
      'systemSettings', 'sessions', 'auditLog',
      'privileges', 'privilegeGroups', 'abstractRoles', 'dutyRoles', 'jobRoles',
      'secProfiles', 'userManagement'];
    self._landingRoute = function () {
      var user = self.currentUser();
      if (user && user.roles) {
        for (var i = 0; i < user.roles.length; i++) {
          var v = self._bootSettings['LANDING_' + user.roles[i]];
          if (v && KNOWN_ROUTES.indexOf(v) >= 0) return v;
        }
      }
      return 'dashboard';
    };

    // Called by login viewModel via window._jetApp.onLogin(user)
    self.onLogin = function (user) {
      self.currentUser(user);
      self._initAnnouncements();
      // land on the role's configured page — but never block login on a
      // slow /boot (800ms cap, then default to dashboard)
      Promise.race([
        self._bootstrap(),
        new Promise(function (r) { setTimeout(r, 800); })
      ]).then(function () {
        self._loadRoute(self._landingRoute());
      });
    };

    /* ── feature flags (Wave 1): FEATURE_* rows in system settings ──────
       Loaded silently; non-admin users that cannot read /settings/ simply
       get the call-site defaults. featureOn() is KO-reactive via featRev. */
    self._featRev = ko.observable(0);
    self._loadFeatures = function () {
      if (!self.currentUser()) return;
      require(['services/settingService'], function (settingService) {
        settingService.getSettings({ silent: true }).then(function (rows) {
          self._bootSettings = {};
          rows.forEach(function (s) { self._bootSettings[s.settingKey] = s.settingValue; });
          shell.setFeatures(rows);
          self._featRev(self._featRev() + 1);
        }).catch(function () {});
      });
    };
    self.featureOn = function (name, dflt) {
      self._featRev();   // KO dependency — re-evaluates when flags arrive
      return shell.featureEnabled(name, dflt);
    };

    // ── command palette (Wave 3, Ctrl+K / ⌘K) ───────────────────────────
    // Providers: navigation (always), users / roles / settings (admins,
    // min 2 chars). Roles & settings ride the refCache — no extra calls.
    function deEntity(s) {
      var d = document.createElement('div');
      d.innerHTML = s || '';
      return d.textContent;
    }
    self.openPalette = function () {
      require(['shared/commandPalette'], function (cp) { cp.open(); });
    };
    require(
      ['shared/commandPalette', 'services/userService', 'services/roleService',
       'services/settingService'],
      function (cp, userService, roleService, settingService) {
        var navItems = [];
        NAV_GROUPS.forEach(function (g) {
          (g.items || []).forEach(function (it) {
            navItems.push({ id: it.id, labelKey: it.labelKey, icon: it.icon,
                            auth: g.auth, url: it.url });
          });
        });
        cp.init({
          t: i18n.t,
          enabled: function () {
            return !!self.currentUser() && shell.featureEnabled('COMMAND_PALETTE', true);
          },
          providers: [
            // enh-5: recent pages — shown on the empty query only
            { group: i18n.t('cmdp.groupRecent'), min: 0, search: function (q) {
                if (q) return [];
                var rec;
                try { rec = JSON.parse(sessionStorage.getItem('recentRoutes') || '[]'); }
                catch (e) { rec = []; }
                return rec.slice(1, 5).map(function (r) {       // [0] = the page we're on
                  var it = navItems.find(function (n) { return n.id === r; });
                  return it && { icon: '🕘', title: i18n.t(it.labelKey),
                                 sub: i18n.t('cmdp.recentSub'),
                                 run: function () { self.navigate(it.id); } };
                }).filter(Boolean);
            } },
            // enh-5: action verbs (admins)
            { group: i18n.t('cmdp.groupActions'), min: 0, search: function (q) {
                if (!authService.isAdmin()) return [];
                var acts = [
                  { key: 'cmdp.actNewUser', icon: '➕', run: function () {
                      sessionStorage.setItem('editUserId', 'new'); self.navigate('userEdit'); } },
                  { key: 'cmdp.actNewRole', icon: '➕', run: function () {
                      sessionStorage.setItem('editRoleId', 'new'); self.navigate('roleEdit'); } },
                  { key: 'cmdp.actNewAnnouncement', icon: '📢', run: function () {
                      self.navigate('announcements'); } },
                  { key: 'cmdp.actNewDelegation', icon: '🤝', run: function () {
                      self.navigate('profile'); } },
                ];
                var ql = (q || '').toLowerCase();
                return acts.filter(function (a) {
                  return !ql || i18n.t(a.key).toLowerCase().indexOf(ql) >= 0;
                }).slice(0, q ? 4 : 2).map(function (a) {
                  return { icon: a.icon, title: i18n.t(a.key), run: a.run };
                });
            } },
            { group: i18n.t('cmdp.groupNav'), min: 0, search: function (q) {
                var ql = q.toLowerCase();
                return navItems.filter(function (it) {
                  if (it.auth === 'admin' && !authService.isAdmin()) return false;
                  return !ql || i18n.t(it.labelKey).toLowerCase().indexOf(ql) >= 0;
                }).slice(0, q ? 6 : 7).map(function (it) {
                  return { icon: deEntity(it.icon), title: i18n.t(it.labelKey),
                           run: function () {
                             if (it.url) window.location.href = it.url;
                             else self.navigate(it.id);
                           } };
                });
            } },
            { group: i18n.t('cmdp.groupUsers'), min: 2, limit: 5, search: function (q) {
                if (!authService.isAdmin()) return [];
                return userService.getPage({ limit: 5, offset: 0, search: q, status: null })
                  .then(function (r) {
                    return (r.items || []).map(function (u) {
                      return { icon: '👤', title: u.displayName,
                               sub: u.username + (u.email ? ' · ' + u.email : ''),
                               run: function () {
                                 sessionStorage.setItem('editUserId', u.userId);
                                 self.navigate('userEdit');
                               } };
                    });
                  });
            } },
            { group: i18n.t('cmdp.groupRoles'), min: 2, limit: 5, search: function (q) {
                if (!authService.isAdmin()) return [];
                var ql = q.toLowerCase();
                return roleService.getAll().then(function (roles) {
                  return roles.filter(function (r) {
                    return (r.roleName || '').toLowerCase().indexOf(ql) >= 0 ||
                           (r.roleCode || '').toLowerCase().indexOf(ql) >= 0;
                  }).map(function (r) {
                    return { icon: '🛡', title: r.roleName, sub: r.roleCode,
                             run: function () {
                               sessionStorage.setItem('editRoleId', r.roleId);
                               self.navigate('roleEdit');
                             } };
                  });
                });
            } },
            { group: i18n.t('cmdp.groupSettings'), min: 2, limit: 5, search: function (q) {
                if (!authService.isAdmin()) return [];
                var ql = q.toLowerCase();
                return settingService.getSettings({ silent: true }).then(function (rows) {
                  return rows.filter(function (s) {
                    return (s.settingKey || '').toLowerCase().indexOf(ql) >= 0;
                  }).map(function (s) {
                    return { icon: '⚙', title: s.settingKey, sub: s.description || '',
                             run: function () { self.navigate('systemSettings'); } };
                  });
                }).catch(function () { return []; });
            } }
          ]
        });
      });

    // THEME_BRAND_COLOR from system settings (GET /settings via settingService)
    self._applyServerTheme = function () {
      require(['services/settingService'], function (settingService) {
        try {
          settingService.getByKey('THEME_BRAND_COLOR').then(function (row) {
            var hex = row && row.settingValue;
            if (hex) shell.applyBrand(hex);
          }).catch(function () {});
        } catch (e) {}
      });
    };

    // ── Boot: load initial route (URL hash survives F5) ────────────────
    if (self.currentUser()) self._bootstrap();
    var bootRoute = (window.location.hash || '').replace(/^#/, '');
    if (/^sso=/.test(bootRoute)) {
      // APEX -> JET hand-off (db/v2/41): exchange the one-time code for a
      // bearer session. Scrub the code from the URL first (history/bookmarks),
      // show the login view while exchanging; an invalid or expired code just
      // leaves the normal login form up.
      var ssoCode = decodeURIComponent(bootRoute.slice(4));
      try {
        history.replaceState(null, '', window.location.pathname + window.location.search);
      } catch (e) {}
      self._loadRoute('login');
      authService.ssoExchange(ssoCode)
        .then(function (user) { self.onLogin(user); })
        .catch(function () {});
    } else {
      self._loadRoute(self.currentUser() ? (bootRoute || 'dashboard') : 'login');
    }
  }

  return AppController;
});
