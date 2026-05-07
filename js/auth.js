/* ================================================================
   auth.js — Authentication and session management
   ================================================================ */
'use strict';

const Auth = {
  login(email, password) {
    const user = USERS.find(u => u.email === email && u.password === password);
    if (!user) return { success: false };
    this._setSession(user.id);
    this._redirect(user.role);
    return { success: true, user };
  },

  quickLogin(userId) {
    const user = USERS.find(u => u.id === userId);
    if (!user) return;
    this._setSession(user.id);
    this._redirect(user.role);
  },

  logout() {
    localStorage.removeItem(DataStore.KEYS.SESSION);
    window.location.href = this._base() + 'index.html';
  },

  getCurrentUser() {
    const id = localStorage.getItem(DataStore.KEYS.SESSION);
    return USERS.find(u => u.id === id) || null;
  },

  isAuthenticated() { return !!this.getCurrentUser(); },

  requireAuth(role = null) {
    const user = this.getCurrentUser();
    if (!user) { window.location.href = this._base() + 'index.html'; return null; }
    if (role && user.role !== role) { this._redirect(user.role); return null; }
    return user;
  },

  _setSession(id) { localStorage.setItem(DataStore.KEYS.SESSION, id); },

  _redirect(role) {
    const base = this._base();
    window.location.href = role === 'director'
      ? base + 'pages/director-dashboard.html'
      : base + 'pages/manager-dashboard.html';
  },

  _base() {
    return window.location.pathname.includes('/pages/') ? '../' : '';
  }
};
