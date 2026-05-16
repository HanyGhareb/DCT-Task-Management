/**
 * userService.js — Users CRUD
 * Production: GET /ords/prod/dct/users/  PUT /ords/prod/dct/users/:id  etc.
 */
define(['mockData'], function (mockData) {
  'use strict';

  const STORE_KEY = 'ifinance_jet_users';

  function load() {
    try {
      const raw = localStorage.getItem(STORE_KEY);
      if (raw) return JSON.parse(raw);
    } catch (e) {}
    return JSON.parse(JSON.stringify(mockData.USERS));
  }

  function persist() {
    localStorage.setItem(STORE_KEY, JSON.stringify(users));
  }

  let users = load();
  let nextId = Math.max.apply(null, users.map(function (u) { return u.userId; })) + 1;

  return {
    getAll: function () { return users.filter(u => u.userId > 0); },

    getById: function (id) { return users.find(u => u.userId === Number(id)) || null; },

    search: function (term) {
      if (!term) return this.getAll();
      const q = term.toLowerCase();
      return users.filter(u =>
        u.username.toLowerCase().includes(q) ||
        u.displayName.toLowerCase().includes(q) ||
        (u.email || '').toLowerCase().includes(q) ||
        (u.orgName || '').toLowerCase().includes(q)
      );
    },

    create: function (data) {
      const newUser = Object.assign({}, data, {
        userId: ++nextId,
        createdAt: new Date().toISOString().slice(0, 10),
        roles: data.roles || ['PLATFORM_USER'],
      });
      users.push(newUser);
      persist();
      return newUser;
    },

    update: function (id, data) {
      const idx = users.findIndex(u => u.userId === Number(id));
      if (idx === -1) return null;
      users[idx] = Object.assign({}, users[idx], data);
      persist();
      return users[idx];
    },

    remove: function (id) {
      const idx = users.findIndex(u => u.userId === Number(id));
      if (idx === -1) return false;
      users.splice(idx, 1);
      persist();
      return true;
    },

    getOrgOptions: function () {
      return mockData.ORGS.map(o => ({ value: o.orgId, label: o.nameEn }));
    },

    getRoleOptions: function () {
      return mockData.ROLES.filter(r => r.isActive === 'Y').map(r => ({ value: r.roleCode, label: r.roleName }));
    },

    // Reset to mockData defaults (useful for dev/testing)
    reset: function () {
      localStorage.removeItem(STORE_KEY);
      users = JSON.parse(JSON.stringify(mockData.USERS));
      nextId = Math.max.apply(null, users.map(function (u) { return u.userId; })) + 1;
    },
  };
});
