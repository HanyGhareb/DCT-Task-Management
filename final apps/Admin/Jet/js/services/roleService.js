/**
 * roleService.js — Roles & permissions CRUD (ORDS live mode only)
 *
 * All methods return Promises.
 * ORDS endpoints: /dct/roles/  /dct/permissions/  /dct/roles/:id/permissions
 */
define(['services/api'], function (api) {
  'use strict';

  return {

    getAll: function () {
      return api.get('/roles/').then(function (r) { return r.items || []; });
    },

    getById: function (id) {
      return api.get('/roles/' + id);
    },

    getPermissions: function () {
      return api.get('/permissions/').then(function (r) { return r.items || []; });
    },

    getPermissionsByModule: function () {
      return this.getPermissions().then(function (perms) {
        var map = {};
        perms.forEach(function (p) {
          var mod = p.module || 'Platform';
          if (!map[mod]) map[mod] = [];
          map[mod].push(p);
        });
        return map;
      });
    },

    getRolePermIds: function (roleId) {
      return api.get('/roles/' + roleId).then(function (r) { return r.permIds || []; });
    },

    create: function (data) {
      return api.post('/roles/', data);
    },

    update: function (id, data) {
      return api.put('/roles/' + id, data);
    },

    remove: function (id) {
      return api.delete('/roles/' + id);
    },

    setRolePermissions: function (roleId, permIds) {
      return api.put('/roles/' + roleId, { permIds: permIds });
    },

    getPermissionMatrix: function () {
      var self = this;
      return Promise.all([self.getAll(), self.getPermissions()])
        .then(function (results) {
          var roles = results[0];
          var perms = results[1];
          return Promise.all(
            roles.map(function (role) {
              return self.getRolePermIds(role.roleId)
                .then(function (ids) { return { roleId: role.roleId, permIds: ids }; })
                .catch(function () { return { roleId: role.roleId, permIds: [] }; });
            })
          ).then(function (rolePermsList) {
            var permMap = {};
            rolePermsList.forEach(function (rp) { permMap[rp.roleId] = rp.permIds; });
            return { roles: roles, matrix: perms.map(function (perm) {
              var row = { permId: perm.permId, permCode: perm.permCode, permName: perm.permName, module: perm.module };
              roles.forEach(function (role) {
                row['role_' + role.roleId] = (permMap[role.roleId] || []).indexOf(perm.permId) !== -1;
              });
              return row;
            })};
          });
        });
    },
  };
});
