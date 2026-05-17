/**
 * authService.js — Session reader for Duty Travel module.
 *
 * Production: session established by Admin JET (App 200). Read-only here.
 * Mock/dev:   login() writes to ifinance_jet_session for standalone testing.
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  // Shared with Admin JET — never rename to a module-specific key.
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
        return api.post('/auth/login', { username: username, password: password })
          .then(function (data) {
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
        sessionId:      null,
        userId:         user.userId,
        username:       user.username,
        displayName:    user.displayName,
        displayNameAr:  user.displayNameAr,
        email:          user.email,
        phone:          user.phone,
        orgId:          user.orgId,
        orgName:        user.orgName,
        color:          user.color,
        employeeNumber: user.employeeNumber,
        gradeCode:      user.gradeCode,
        roles:          user.roles || [],
        initials:       getInitials(user.displayName),
        loginAt:        new Date().toISOString(),
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

    getUnreadCount: function () {
      var user = this.getCurrentUser();
      if (!user) return 0;
      var NOTIF_KEY = 'ifinance_dt_notifs';
      var list;
      try { var raw = localStorage.getItem(NOTIF_KEY); list = raw ? JSON.parse(raw) : mockData.NOTIFICATIONS; }
      catch (e) { list = mockData.NOTIFICATIONS; }
      return list.filter(function (n) { return n.isRead === 'N' && n.targetUserId === user.userId; }).length;
    },

    hasRole: function (role) {
      var user = this.getCurrentUser();
      return !!(user && user.roles && user.roles.includes(role));
    },

    isApprover: function () {
      var user = this.getCurrentUser();
      return !!(user && (user.roles.includes('DT_MANAGER') || user.roles.includes('DT_ADMIN') || user.roles.includes('DT_FINANCE') || user.roles.includes('SYS_ADMIN')));
    },

    isDtAdmin: function () {
      var user = this.getCurrentUser();
      return !!(user && (user.roles.includes('DT_ADMIN') || user.roles.includes('SYS_ADMIN')));
    },

    isDtFinance: function () {
      var user = this.getCurrentUser();
      return !!(user && (user.roles.includes('DT_FINANCE') || user.roles.includes('DT_ADMIN') || user.roles.includes('SYS_ADMIN')));
    },

    // Mock/dev only — used by login.html quick-login buttons.
    QUICK_LOGINS: [
      { label: 'System Admin',    username: 'ADMIN',            password: 'iFinance@2026', role: 'SYS_ADMIN / DT_ADMIN' },
      { label: 'Finance Director',username: 'HASHEM.ALKABBI',   password: 'Director@2026', role: 'DT_MANAGER' },
      { label: 'Fin. Operations', username: 'NASER.ALKHAJA',    password: 'Manager@2026',  role: 'DT_EMPLOYEE (Active Request)' },
      { label: 'DT Finance',      username: 'AYESHA.AMERI',     password: 'Manager@2026',  role: 'DT_FINANCE' },
      { label: 'Receivables Mgr', username: 'NOORA.ALALI',      password: 'Manager@2026',  role: 'DT_EMPLOYEE (Travelled)' },
      { label: 'Budget Planning', username: 'SHAIKHA.GALAMERI', password: 'Manager@2026',  role: 'DT_EMPLOYEE (Pending)' },
    ],
  };
});
