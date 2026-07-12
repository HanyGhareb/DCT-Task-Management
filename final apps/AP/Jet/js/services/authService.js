/**
 * authService.js — Session reader for the Accounts Payable module (App 212).
 * Production: session established by Admin JET (App 200). Read-only here.
 * Dev: login() posts to the shared /dct/auth endpoint for standalone testing.
 */
define(['services/config', 'services/api'],
function (config, api) {
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
      var loginUrl = (config.authBase || config.apiBase) + '/auth/login';
      return fetch(loginUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username: username, password: password }),
      }).then(function (r) { return r.json(); })
        .then(function (data) {
          if (!data || data.error || !data.userId) {
            localStorage.removeItem(SESSION_KEY);
            return null;
          }
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
        api.post('/auth/logout', {}, { base: 'auth', silent: true }).catch(function () {});
      }
    },

    getToken: function () {
      try {
        var raw = localStorage.getItem(SESSION_KEY);
        return raw ? (JSON.parse(raw).sessionId || null) : null;
      } catch (e) { return null; }
    },

    getCurrentUser: function () {
      try {
        var raw = localStorage.getItem(SESSION_KEY);
        return raw ? JSON.parse(raw) : null;
      } catch (e) { return null; }
    },

    hasRole: function (role) {
      var user = this.getCurrentUser();
      return !!(user && user.roles && user.roles.includes(role));
    },

    // Dev standalone only (production auth is the Admin JET hand-off).
    // No credentials in the repo — type them on the login form.
    QUICK_LOGINS: [],
  };
});
