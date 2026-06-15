/**
 * authService.js — Session reader for the Accounts Receivable module.
 *
 * Session is established by Admin JET (App 200) and shared via
 * localStorage['ifinance_jet_session']. This module only reads it;
 * there is no standalone/mock login for AR.
 */
define(['services/config', 'services/api'],
function (config, api) {
  'use strict';

  // Shared with Admin JET — never rename to a module-specific key.
  var SESSION_KEY = 'ifinance_jet_session';

  return {

    logout: function () {
      var token = this.getToken();
      localStorage.removeItem(SESSION_KEY);
      if (token) { api.post('/auth/logout', {}, { base: 'auth', silent: true }).catch(function () {}); }
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

    isArAdmin: function () {
      var user = this.getCurrentUser();
      return !!(user && user.roles &&
        (user.roles.includes('AR_ADMIN') || user.roles.includes('SYS_ADMIN')));
    },

    isArUser: function () {
      var user = this.getCurrentUser();
      return !!(user && user.roles &&
        (user.roles.includes('AR_USER') || user.roles.includes('AR_ADMIN') ||
         user.roles.includes('SYS_ADMIN')));
    },
  };
});
