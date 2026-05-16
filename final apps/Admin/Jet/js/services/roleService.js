/**
 * roleService.js — Roles & permissions CRUD
 *
 * All methods return Promises.
 * mock mode  (config.apiBase = null): in-memory mock data.
 * real mode  (config.apiBase set)   : ORDS /dct/roles/ + /dct/permissions/
 */
define(['services/config', 'services/api', 'mockData'], function (config, api, mockData) {
  'use strict';

  var roles    = JSON.parse(JSON.stringify(mockData.ROLES));
  var rolePerms = JSON.parse(JSON.stringify(mockData.ROLE_PERMISSIONS));
  var nextId   = roles.length + 1;

  return {

    getAll: function () {
      if (config.apiBase) {
        return api.get('/roles/').then(function (r) { return r.items; });
      }
      return Promise.resolve(roles);
    },

    getById: function (id) {
      if (config.apiBase) {
        return api.get('/roles/' + id);
      }
      return Promise.resolve(roles.find(function (r) { return r.roleId === Number(id); }) || null);
    },

    getPermissions: function () {
      if (config.apiBase) {
        return api.get('/permissions/').then(function (r) { return r.items; });
      }
      return Promise.resolve(mockData.PERMISSIONS);
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
      if (config.apiBase) {
        return api.get('/roles/' + roleId).then(function (r) { return r.permIds || []; });
      }
      return Promise.resolve(rolePerms[Number(roleId)] || []);
    },

    create: function (data) {
      if (config.apiBase) {
        return api.post('/roles/', data);
      }
      var newRole = Object.assign({}, data, {
        roleId: ++nextId, memberCount: 0, isActive: data.isActive || 'Y',
      });
      roles.push(newRole);
      rolePerms[newRole.roleId] = [];
      return Promise.resolve(newRole);
    },

    update: function (id, data) {
      if (config.apiBase) {
        return api.put('/roles/' + id, data);
      }
      var idx = roles.findIndex(function (r) { return r.roleId === Number(id); });
      if (idx === -1) return Promise.resolve(null);
      roles[idx] = Object.assign({}, roles[idx], data);
      if (data.permIds !== undefined) rolePerms[Number(id)] = data.permIds;
      return Promise.resolve(roles[idx]);
    },

    remove: function (id) {
      if (config.apiBase) {
        return api.delete('/roles/' + id);
      }
      var idx = roles.findIndex(function (r) { return r.roleId === Number(id); });
      if (idx === -1) return Promise.resolve(false);
      roles.splice(idx, 1);
      delete rolePerms[Number(id)];
      return Promise.resolve(true);
    },

    getPermissionMatrix: function () {
      return this.getPermissions().then(function (perms) {
        return perms.map(function (perm) {
          var row = {
            permId: perm.permId, permCode: perm.permCode,
            permName: perm.permName, module: perm.module,
          };
          roles.forEach(function (role) {
            row['role_' + role.roleId] = (rolePerms[role.roleId] || []).includes(perm.permId);
          });
          return row;
        });
      });
    },
  };
});
