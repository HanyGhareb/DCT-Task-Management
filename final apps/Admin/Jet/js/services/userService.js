/**
 * userService.js — Users CRUD
 *
 * All methods return Promises.
 * mock mode  (config.apiBase = null): localStorage-backed mock data.
 * real mode  (config.apiBase set)   : ORDS /dct/users/
 */
define(['services/config', 'services/api', 'mockData'], function (config, api, mockData) {
  'use strict';

  // ── Mock store (localStorage-backed) ───────────────────────────────────────
  var STORE_KEY = 'ifinance_jet_users';

  function load() {
    try {
      var raw = localStorage.getItem(STORE_KEY);
      if (raw) return JSON.parse(raw);
    } catch (e) {}
    return JSON.parse(JSON.stringify(mockData.USERS));
  }

  function persist() {
    localStorage.setItem(STORE_KEY, JSON.stringify(users));
  }

  var users  = load();
  var nextId = Math.max.apply(null, users.map(function (u) { return u.userId; })) + 1;

  // Normalise API user (snake_case / DB format → camelCase used by viewModels)
  function norm(u) {
    u.roles = (u.rolesCsv || '').split(',').filter(Boolean);
    return u;
  }

  // ── Public interface ────────────────────────────────────────────────────────
  return {

    getAll: function () {
      if (config.apiBase) {
        return api.get('/users/').then(function (r) { return r.items.map(norm); });
      }
      return Promise.resolve(users.filter(function (u) { return u.userId > 0; }));
    },

    getById: function (id) {
      if (config.apiBase) {
        return api.get('/users/' + id).then(norm);
      }
      return Promise.resolve(users.find(function (u) { return u.userId === Number(id); }) || null);
    },

    search: function (term) {
      if (!term) return this.getAll();
      if (config.apiBase) {
        return api.get('/users/?q=' + encodeURIComponent(term)).then(function (r) { return r.items.map(norm); });
      }
      var q = term.toLowerCase();
      return Promise.resolve(users.filter(function (u) {
        return u.username.toLowerCase().includes(q) ||
               u.displayName.toLowerCase().includes(q) ||
               (u.email || '').toLowerCase().includes(q) ||
               (u.orgName || '').toLowerCase().includes(q);
      }));
    },

    create: function (data) {
      if (config.apiBase) {
        return api.post('/users/', data);
      }
      var newUser = Object.assign({}, data, {
        userId:    ++nextId,
        createdAt: new Date().toISOString().slice(0, 10),
        roles:     data.roles || ['PLATFORM_USER'],
      });
      users.push(newUser);
      persist();
      return Promise.resolve(newUser);
    },

    update: function (id, data) {
      if (config.apiBase) {
        return api.put('/users/' + id, data);
      }
      var idx = users.findIndex(function (u) { return u.userId === Number(id); });
      if (idx === -1) return Promise.resolve(null);
      users[idx] = Object.assign({}, users[idx], data);
      persist();
      return Promise.resolve(users[idx]);
    },

    remove: function (id) {
      if (config.apiBase) {
        return api.delete('/users/' + id);
      }
      var idx = users.findIndex(function (u) { return u.userId === Number(id); });
      if (idx === -1) return Promise.resolve(false);
      users.splice(idx, 1);
      persist();
      return Promise.resolve(true);
    },

    // Synchronous helpers used during ViewModel construction (mock only)
    getById_sync: function (id) {
      return users.find(function (u) { return u.userId === Number(id); }) || null;
    },

    getOrgOptions: function () {
      if (config.apiBase) {
        return api.get('/orgs/').then(function (r) {
          return r.items.map(function (o) { return { value: o.orgId, label: o.nameEn }; });
        });
      }
      return Promise.resolve(mockData.ORGS.map(function (o) {
        return { value: o.orgId, label: o.nameEn };
      }));
    },

    getRoleOptions: function () {
      return Promise.resolve(mockData.ROLES.filter(function (r) { return r.isActive === 'Y'; })
        .map(function (r) { return { value: r.roleCode, label: r.roleName }; }));
    },

    reset: function () {
      localStorage.removeItem(STORE_KEY);
      users  = JSON.parse(JSON.stringify(mockData.USERS));
      nextId = Math.max.apply(null, users.map(function (u) { return u.userId; })) + 1;
    },
  };
});
