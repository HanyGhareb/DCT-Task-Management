/**
 * userService.js — Users CRUD (ORDS live mode only)
 *
 * All methods return Promises.
 * ORDS endpoints: /dct/users/
 */
define(['services/api'], function (api) {
  'use strict';

  function norm(u) {
    u.roles = (u.rolesCsv || '').split(',').filter(Boolean);
    return u;
  }

  return {

    getAll: function () {
      return api.get('/users/?limit=200').then(function (r) { return r.items.map(norm); });
    },

    /**
     * Phase 3 server-side pagination.
     * opts: { limit, offset, search, status ('Y'|'N'|null) }
     * Resolves { items, total, limit, offset } (items normalised).
     */
    getPage: function (opts) {
      opts = opts || {};
      var q = '?limit=' + (opts.limit || 50) + '&offset=' + (opts.offset || 0);
      if (opts.search) q += '&search=' + encodeURIComponent(opts.search);
      if (opts.status) q += '&status=' + encodeURIComponent(opts.status);
      return api.get('/users/' + q, { silent: opts.silent }).then(function (r) {
        r.items = (r.items || []).map(norm);
        return r;
      });
    },

    getById: function (id) {
      return api.get('/users/' + id).then(norm);
    },

    search: function (term) {
      if (!term) return this.getAll();
      return api.get('/users/?q=' + encodeURIComponent(term)).then(function (r) { return r.items.map(norm); });
    },

    create: function (data) {
      return api.post('/users/', data);
    },

    update: function (id, data) {
      return api.put('/users/' + id, data);
    },

    remove: function (id) {
      return api.delete('/users/' + id);
    },

    getOrgOptions: function () {
      return api.get('/orgs/').then(function (r) {
        return r.items.map(function (o) { return { value: o.orgId, label: o.nameEn }; });
      });
    },

    getRoleOptions: function () {
      return api.get('/roles/').then(function (r) {
        return (r.items || [])
          .filter(function (role) { return role.isActive === 'Y'; })
          .map(function (role) { return { value: role.roleCode, label: role.roleName }; });
      });
    },

    reset: function () {}, // no-op in ORDS mode
  };
});
