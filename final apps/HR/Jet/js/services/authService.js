/**
 * authService.js — Session reader for HR module.
 * Production: session established by Admin JET (App 200). Read-only here.
 * Mock/dev:   login() writes to ifinance_jet_session for standalone testing.
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  var SESSION_KEY = 'ifinance_jet_session';

  function getInitials(name) {
    var parts = (name || '').split(' ');
    return parts.length >= 2
      ? (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
      : (parts[0] || '?')[0].toUpperCase();
  }

  function getUsers() {
    try {
      var raw = localStorage.getItem('ifinance_jet_users');
      return raw ? JSON.parse(raw) : mockData.USERS;
    } catch (e) { return mockData.USERS; }
  }

  return {

    login: function (username, password) {
      if (config.apiBase) {
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
      }
      var users = getUsers();
      var user = users.find(function (u) {
        return u.username.toUpperCase() === username.toUpperCase() && u.password === password;
      });
      if (!user || user.isActive !== 'Y') return Promise.resolve(null);
      var session = {
        sessionId:   null,
        userId:      user.userId,
        username:    user.username,
        displayName: user.displayName,
        email:       user.email,
        orgId:       user.orgId,
        orgName:     user.orgName,
        color:       user.color,
        roles:       user.roles || [],
        initials:    getInitials(user.displayName),
        loginAt:     new Date().toISOString(),
      };
      localStorage.setItem(SESSION_KEY, JSON.stringify(session));
      return Promise.resolve(session);
    },

    logout: function () {
      var token = this.getToken();
      localStorage.removeItem(SESSION_KEY);
      if (config.apiBase && token) {
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
      try {
        var raw = localStorage.getItem(SESSION_KEY);
        return raw ? JSON.parse(raw) : null;
      } catch (e) { return null; }
    },

    hasRole: function (role) {
      var user = this.getCurrentUser();
      return !!(user && user.roles && user.roles.includes(role));
    },

    isHrAdmin: function () {
      var user = this.getCurrentUser();
      return !!(user && user.roles && (user.roles.includes('HR_ADMIN') || user.roles.includes('SYS_ADMIN')));
    },

    isHrManager: function () {
      var user = this.getCurrentUser();
      return !!(user && user.roles && (user.roles.includes('HR_MANAGER') || user.roles.includes('HR_ADMIN') || user.roles.includes('SYS_ADMIN')));
    },

    isHrViewer: function () {
      var user = this.getCurrentUser();
      return !!(user && user.roles && (user.roles.includes('HR_VIEWER') || user.roles.includes('HR_MANAGER') || user.roles.includes('HR_ADMIN') || user.roles.includes('SYS_ADMIN')));
    },

    QUICK_LOGINS: [
      { label: 'System Admin',     username: 'ADMIN',          password: 'iFinance@2026', role: 'SYS_ADMIN / HR_ADMIN' },
      { label: 'HR Officer',       username: 'HR.OFFICER',     password: 'HR@2026',       role: 'HR_ADMIN' },
      { label: 'Finance Director', username: 'HASHEM.ALKABBI', password: 'Director@2026', role: 'HR_MANAGER' },
      { label: 'Staff Member',     username: 'NASER.ALKHAJA',  password: 'Manager@2026',  role: 'HR_VIEWER' },
    ],
  };
});
