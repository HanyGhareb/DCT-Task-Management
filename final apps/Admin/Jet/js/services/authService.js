/**
 * authService.js — login / logout / session
 * Production: POST /ords/prod/dct/auth/login  (ORDS REST)
 */
define(['mockData', 'services/userService'], function (mockData, userService) {
  'use strict';

  const SESSION_KEY = 'ifinance_jet_session';

  function getInitials(name) {
    const parts = (name || '').split(' ');
    return parts.length >= 2 ? (parts[0][0] + parts[parts.length - 1][0]).toUpperCase() : (parts[0] || '?')[0].toUpperCase();
  }

  return {
    // Authenticate — uses live userService copy so deactivations within session are respected
    login: function (username, password) {
      const user = userService.getAll().find(
        u => u.username.toUpperCase() === username.toUpperCase() && u.password === password
      );
      if (!user) return null;
      if (user.isActive !== 'Y') return null;
      const session = {
        userId: user.userId, username: user.username,
        displayName: user.displayName, displayNameAr: user.displayNameAr,
        email: user.email, phone: user.phone,
        orgId: user.orgId, orgName: user.orgName,
        roles: user.roles, color: user.color,
        initials: getInitials(user.displayName),
        loginAt: new Date().toISOString(),
      };
      localStorage.setItem(SESSION_KEY, JSON.stringify(session));
      return session;
    },

    logout: function () {
      localStorage.removeItem(SESSION_KEY);
    },

    getCurrentUser: function () {
      const raw = localStorage.getItem(SESSION_KEY);
      if (!raw) return null;
      const session = JSON.parse(raw);
      // Re-validate against live user data — catches deactivation mid-session
      const liveUser = userService.getById(session.userId);
      if (!liveUser || liveUser.isActive !== 'Y') {
        localStorage.removeItem(SESSION_KEY);
        return null;
      }
      return session;
    },

    getUnreadCount: function () {
      return mockData.NOTIFICATIONS.filter(n => n.isRead === 'N').length;
    },

    isAdmin: function () {
      const user = this.getCurrentUser();
      return user && (user.roles.includes('SYS_ADMIN') || user.roles.includes('USER_ADMIN'));
    },

    // Quick-login helpers for demo
    QUICK_LOGINS: [
      { label: 'System Admin',   username: 'ADMIN',            password: 'iFinance@2026', role: 'SYS_ADMIN' },
      { label: 'Finance Director', username: 'HASHEM.ALKABBI', password: 'Director@2026', role: 'TASK_DIRECTOR' },
      { label: 'Fin. Operations',  username: 'NASER.ALKHAJA',  password: 'Manager@2026',  role: 'MANAGER' },
      { label: 'Payables Mgr',     username: 'AYESHA.AMERI',   password: 'Manager@2026',  role: 'MANAGER' },
      { label: 'Budget Mgr',       username: 'SHAIKHA.GALAMERI', password: 'Manager@2026', role: 'MANAGER' },
      { label: 'Revenue Mgr',      username: 'SHAIKHA.ALSUWAIDI', password: 'Manager@2026', role: 'MANAGER' },
    ],
  };
});
