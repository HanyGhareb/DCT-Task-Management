/**
 * authService.js — login / logout / session (ORDS live mode only)
 *
 * login() returns a Promise resolving to the session object, or null on failure.
 */
define(['services/api'],
function (api) {
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
      return api.post('/auth/login', { username: username, password: password })
        .then(function (data) {
          data.roles    = (data.rolesCsv || '').split(',').filter(Boolean);
          data.initials = getInitials(data.displayName);
          localStorage.setItem(SESSION_KEY, JSON.stringify(data));
          return data;
        });
    },

    logout: function () {
      var token = this.getToken();
      localStorage.removeItem(SESSION_KEY);
      if (token) {
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
      return JSON.parse(raw);
    },

    /* Merge updated profile fields into the cached session so the UI stays
       correct across refreshes without re-login (session payload is otherwise
       only written at login time). */
    updateCachedUser: function (fields) {
      var raw = localStorage.getItem(SESSION_KEY);
      if (!raw) return;
      try {
        var s = JSON.parse(raw);
        Object.keys(fields || {}).forEach(function (k) { s[k] = fields[k]; });
        localStorage.setItem(SESSION_KEY, JSON.stringify(s));
      } catch (e) { /* corrupt session — leave as-is, next login rewrites it */ }
    },

    getUnreadCount: function () {
      if (!this.getCurrentUser()) return Promise.resolve(0);   // nothing to count pre-login
      return api.get('/notifications/', { silent: true }).then(function (r) {
        return (r.items || []).filter(function (n) { return n.isRead === 'N'; }).length;
      }).catch(function () { return 0; });
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
