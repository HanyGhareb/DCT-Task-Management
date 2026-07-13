/**
 * moduleService.js — Module registry
 * ORDS: GET /modules/      — list all modules
 *       PUT /modules/:id   — update a module
 *
 * All methods return Promises.
 */
define(['services/api', 'shared/refCache'], function (api, refCache) {
  'use strict';

  var CATEGORIES = [
    { id: 'CORE',     label: 'Core Platform',         icon: '&#127968;' },
    { id: 'FINANCE',  label: 'Finance',               icon: '&#128178;' },
    { id: 'HR',       label: 'HR & Employee',          icon: '&#128101;' },
    { id: 'BUDGET',   label: 'Budget & Planning',      icon: '&#128202;' },
    { id: 'PAYMENTS', label: 'Payments & Procurement', icon: '&#9989;'   },
  ];

  return {

    getAll: function () {
      return refCache.get('modules', function () {
        return api.get('/modules/').then(function (r) { return r.items || []; });
      });
    },

    getCategories: function () { return CATEGORIES; },

    getByCategory: function (cat) {
      return this.getAll().then(function (mods) {
        return mods.filter(function (m) { return m.category === cat && m.isActive === 'Y'; });
      });
    },

    getAccessibleForUser: function () {
      return this.getAll().then(function (mods) {
        return mods.filter(function (m) { return m.isActive === 'Y'; });
      });
    },

    update: function (moduleId, data) {
      refCache.invalidate('modules');
      return api.put('/modules/' + moduleId, data);
    },

    /* Module access (db/v2/49): which roles may see this app in the module
       switcher. Empty grant set = unrestricted (visible to everyone). */
    getRoles: function (moduleId) {
      return api.get('/modules/' + moduleId + '/roles');
    },

    setRoles: function (moduleId, roleIds) {
      return api.put('/modules/' + moduleId + '/roles', { roleIds: roleIds });
    },

    /* currentActive = current isActive value ('Y' or 'N') */
    toggleActive: function (moduleId, currentActive) {
      refCache.invalidate('modules');
      return api.put('/modules/' + moduleId, {
        isActive: currentActive === 'Y' ? 'N' : 'Y',
      });
    },
  };
});
