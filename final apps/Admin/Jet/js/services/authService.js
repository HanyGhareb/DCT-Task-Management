/**
 * authService.js — login / logout / session
 *
 * mock mode  (config.apiBase = null): validates against userService in-memory data.
 * real mode  (config.apiBase set)   : POST /ords/prod/dct/auth/login
 *
 * login() always returns a Promise.
 */
define(['services/config', 'services/api', 'services/userService', 'mockData'],
function (config, api, userService, mockData) {
  'use strict';

  var SESSION_KEY = 'ifinance_jet_session';

  function getInitials(name) {
    var parts = (name || '').split(' ');
    return parts.length >= 2
      ? (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
      : (parts[0] || '?')[0].toUpperCase();
  }

  return {

    login: function (username, password) {
      if (config.apiBase) {
        // ── Real API ──────────────────────────────────────────────────────────
        return api.post('/auth/login', { username: username, password: password })
          .then(function (data) {
            // Normalise: split rolesCsv → roles array, compute initials
            data.roles    = (data.rolesCsv || '').split(',').filter(Boolean);
            data.initials = getInitials(data.displayName);
            localStorage.setItem(SESSION_KEY, JSON.stringify(data));
            return data;
          });
      } else {
        // ── Mock ──────────────────────────────────────────────────────────────
        var user = userService.getAll().find(function (u) {
          return u.username.toUpperCase() === username.toUpperCase() &&
                 u.password === password;
        });
        if (!user || user.isActive !== 'Y') return Promise.resolve(null);
        var session = {
          sessionId:      null,   // no real token in mock mode
          userId:         user.userId,
          username:       user.username,
          displayName:    user.displayName,
          displayNameAr:  user.displayNameAr,
          email:          user.email,
          phone:          user.phone,
          orgId:          user.orgId,
          orgName:        user.orgName,
          color:          user.color,
          isExternal:     user.isExternal,
          roles:          user.roles || [],
          initials:       getInitials(user.displayName),
          loginAt:        new Date().toISOString(),
        };
        localStorage.setItem(SESSION_KEY, JSON.stringify(session));
        return Promise.resolve(session);
      }
    },

    logout: function () {
      var token = this.getToken();
      localStorage.removeItem(SESSION_KEY);
      if (config.apiBase && token) {
        // Fire-and-forget — don't block logout on API response
        api.post('/auth/logout').catch(function () {});
      }
    },

    getToken: function () {
      try {
        var raw = localStorage.getItem(SESSION_KEY);
        return raw ? (JSON.parse(raw).sessionId || null) : null;
      } catch (e) { return null; }
    },

    getCurrentUser: function () {
      var raw = localStorage.getItem(SESSION_KEY);
      if (!raw) return null;
      var session = JSON.parse(raw);

      if (!config.apiBase) {
        // Mock mode: re-validate active status against live userService data
        var live = userService.getById(session.userId);
        if (!live || live.isActive !== 'Y') {
          localStorage.removeItem(SESSION_KEY);
          return null;
        }
      }
      // Real API mode: 401 responses in api.js handle session invalidation
      return session;
    },

    getUnreadCount: function () {
      return mockData.NOTIFICATIONS.filter(function (n) { return n.isRead === 'N'; }).length;
    },

    isAdmin: function () {
      var user = this.getCurrentUser();
      return user && (user.roles.includes('SYS_ADMIN') || user.roles.includes('USER_ADMIN'));
    },

    QUICK_LOGINS: [
      { label: 'System Admin',     username: 'ADMIN',              password: 'iFinance@2026', role: 'SYS_ADMIN' },
      { label: 'Finance Director', username: 'HASHEM.ALKABBI',     password: 'Director@2026', role: 'TASK_DIRECTOR' },
      { label: 'Fin. Operations',  username: 'NASER.ALKHAJA',      password: 'Manager@2026',  role: 'MANAGER' },
      { label: 'Payables Mgr',     username: 'AYESHA.AMERI',       password: 'Manager@2026',  role: 'MANAGER' },
      { label: 'Budget Mgr',       username: 'SHAIKHA.GALAMERI',   password: 'Manager@2026',  role: 'MANAGER' },
      { label: 'Revenue Mgr',      username: 'SHAIKHA.ALSUWAIDI',  password: 'Manager@2026',  role: 'MANAGER' },
    ],
  };
});
