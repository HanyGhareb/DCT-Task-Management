/**
 * secService — ORDS client for the Security Console (/dct/sec/).
 * Fusion-style RBAC: privileges, privilege groups, abstract/duty/job roles
 * with hierarchy + exclusions, security profiles (data scoping), dated user
 * assignments, effective-privilege preview and the page/artifact registry.
 * All methods return Promises. SYS_ADMIN-gated server-side.
 */
define(['services/api'], function (api) {
  'use strict';

  function qs(params) {
    var parts = [];
    Object.keys(params || {}).forEach(function (k) {
      if (params[k] !== undefined && params[k] !== null && params[k] !== '') {
        parts.push(k + '=' + encodeURIComponent(params[k]));
      }
    });
    return parts.length ? '?' + parts.join('&') : '';
  }

  return {
    // bootstrap for pickers: verbs, modules, object types, catalogs
    getMeta: function () { return api.get('/sec/meta'); },

    // privileges
    getPrivileges: function (p) { return api.get('/sec/privileges' + qs(p)); },
    createPrivilege: function (data) { return api.post('/sec/privileges', data); },
    updatePrivilege: function (id, data) { return api.put('/sec/privileges/' + id, data); },
    deletePrivilege: function (id) { return api.delete('/sec/privileges/' + id); },

    // privilege groups
    getGroups: function (p) { return api.get('/sec/groups' + qs(p)); },
    getGroup: function (id) { return api.get('/sec/groups/' + id); },
    createGroup: function (data) { return api.post('/sec/groups', data); },
    updateGroup: function (id, data) { return api.put('/sec/groups/' + id, data); },
    deleteGroup: function (id) { return api.delete('/sec/groups/' + id); },

    // roles (abstract / duty / job)
    getRoles: function (p) { return api.get('/sec/roles' + qs(p)); },
    getRole: function (id) { return api.get('/sec/roles/' + id); },
    createRole: function (data) { return api.post('/sec/roles', data); },
    updateRole: function (id, data) { return api.put('/sec/roles/' + id, data); },
    deleteRole: function (id) { return api.delete('/sec/roles/' + id); },
    copyRole: function (id, data) { return api.post('/sec/roles/' + id + '/copy', data); },

    // security profiles
    getProfiles: function (p) { return api.get('/sec/profiles' + qs(p)); },
    getProfile: function (id) { return api.get('/sec/profiles/' + id); },
    createProfile: function (data) { return api.post('/sec/profiles', data); },
    updateProfile: function (id, data) { return api.put('/sec/profiles/' + id, data); },
    deleteProfile: function (id) { return api.delete('/sec/profiles/' + id); },
    getLov: function (type, search, parent) {
      return api.get('/sec/lov' + qs({ type: type, search: search, parent: parent }));
    },

    // per-user security
    getUserSecurity: function (userId) { return api.get('/sec/users/' + userId + '/security'); },
    getUserEffective: function (userId) { return api.get('/sec/users/' + userId + '/effective'); },
    assignUserRole: function (userId, data) { return api.post('/sec/users/' + userId + '/roles', data); },
    endUserRole: function (userId, urId) {
      return api.post('/sec/users/' + userId + '/roles', { op: 'end', urId: urId });
    },
    assignUserProfile: function (userId, data) { return api.post('/sec/users/' + userId + '/profiles', data); },
    endUserProfile: function (userId, upId) {
      return api.post('/sec/users/' + userId + '/profiles', { op: 'end', upId: upId });
    },
    addUserExclusion: function (userId, data) { return api.post('/sec/users/' + userId + '/exclusions', data); },
    endUserExclusion: function (userId, exclusionId) {
      return api.post('/sec/users/' + userId + '/exclusions', { op: 'end', exclusionId: exclusionId });
    },

    // page registry + Security Info drawer
    getPages: function (p) { return api.get('/sec/pages' + qs(p)); },
    registerPage: function (data) { return api.post('/sec/pages', data); },
    getPageInfo: function (module, page) {
      return api.get('/sec/pageinfo' + qs({ module: module, page: page }));
    }
  };
});
