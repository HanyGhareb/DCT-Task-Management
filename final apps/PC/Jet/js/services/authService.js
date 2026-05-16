/**
 * authService.js — login / logout / session for Petty Cash module.
 * mock mode: validates against mockData.USERS.
 * real mode: POST /ords/admin/dct/auth/login (same endpoint as Admin app).
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  var SESSION_KEY = 'ifinance_pc_session';

  function getInitials(name) {
    var parts = (name || '').split(' ');
    return parts.length >= 2
      ? (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
      : (parts[0] || '?')[0].toUpperCase();
  }

  // Load persisted users (allows password/status changes to survive reload)
  function getUsers() {
    try {
      var raw = localStorage.getItem('ifinance_pc_users');
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
      // Mock mode
      var users = getUsers();
      var user = users.find(function (u) {
        return u.username.toUpperCase() === username.toUpperCase() && u.password === password;
      });
      if (!user || user.isActive !== 'Y') return Promise.resolve(null);
      var session = {
        sessionId:     null,
        userId:        user.userId,
        username:      user.username,
        displayName:   user.displayName,
        displayNameAr: user.displayNameAr,
        email:         user.email,
        phone:         user.phone,
        orgId:         user.orgId,
        orgName:       user.orgName,
        color:         user.color,
        employeeNumber:user.employeeNumber,
        roles:         user.roles || [],
        initials:      getInitials(user.displayName),
        loginAt:       new Date().toISOString(),
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
      var raw = localStorage.getItem(SESSION_KEY);
      if (!raw) return null;
      return JSON.parse(raw);
    },

    getUnreadCount: function () {
      var user = this.getCurrentUser();
      if (!user) return 0;
      var NOTIF_KEY = 'ifinance_pc_notifs';
      var list;
      try { var raw = localStorage.getItem(NOTIF_KEY); list = raw ? JSON.parse(raw) : mockData.NOTIFICATIONS; }
      catch (e) { list = mockData.NOTIFICATIONS; }
      return list.filter(function (n) { return n.isRead === 'N' && n.targetUserId === user.userId; }).length;
    },

    hasRole: function (role) {
      var user = this.getCurrentUser();
      return user && user.roles && user.roles.includes(role);
    },

    isApprover: function () {
      var user = this.getCurrentUser();
      return user && (user.roles.includes('MANAGER') || user.roles.includes('AP_PETTY_CASH_ADMIN') || user.roles.includes('SYS_ADMIN'));
    },

    isPcAdmin: function () {
      var user = this.getCurrentUser();
      return user && (user.roles.includes('AP_PETTY_CASH_ADMIN') || user.roles.includes('SYS_ADMIN'));
    },

    QUICK_LOGINS: [
      { label: 'System Admin',    username: 'ADMIN',             password: 'iFinance@2026', role: 'SYS_ADMIN' },
      { label: 'PC Admin',        username: 'AYESHA.AMERI',      password: 'Manager@2026',  role: 'AP_PETTY_CASH_ADMIN' },
      { label: 'Finance Director',username: 'HASHEM.ALKABBI',    password: 'Director@2026', role: 'MANAGER' },
      { label: 'Fin. Operations', username: 'NASER.ALKHAJA',     password: 'Manager@2026',  role: 'EMPLOYEE (Active PC)' },
      { label: 'Receivables Mgr', username: 'NOORA.ALALI',       password: 'Manager@2026',  role: 'EMPLOYEE (Active PC)' },
      { label: 'Budget Planning', username: 'SHAIKHA.GALAMERI',  password: 'Manager@2026',  role: 'EMPLOYEE (Pending)' },
    ],
  };
});
