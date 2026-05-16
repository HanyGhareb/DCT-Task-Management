/**
 * roleService.js — Roles & permissions CRUD
 * Production: GET /ords/prod/dct/roles/  etc.
 */
define(['mockData'], function (mockData) {
  'use strict';

  let roles = JSON.parse(JSON.stringify(mockData.ROLES));
  let rolePerms = JSON.parse(JSON.stringify(mockData.ROLE_PERMISSIONS));
  let nextId = roles.length + 1;

  return {
    getAll: function () { return roles; },

    getById: function (id) { return roles.find(r => r.roleId === Number(id)) || null; },

    getPermissions: function () { return mockData.PERMISSIONS; },

    getPermissionsByModule: function () {
      const map = {};
      mockData.PERMISSIONS.forEach(p => {
        if (!map[p.module]) map[p.module] = [];
        map[p.module].push(p);
      });
      return map;
    },

    getRolePermIds: function (roleId) {
      return rolePerms[Number(roleId)] || [];
    },

    setRolePermissions: function (roleId, permIds) {
      rolePerms[Number(roleId)] = permIds;
    },

    create: function (data) {
      const newRole = Object.assign({}, data, {
        roleId: ++nextId,
        memberCount: 0,
        isActive: data.isActive || 'Y',
      });
      roles.push(newRole);
      rolePerms[newRole.roleId] = [];
      return newRole;
    },

    update: function (id, data) {
      const idx = roles.findIndex(r => r.roleId === Number(id));
      if (idx === -1) return null;
      roles[idx] = Object.assign({}, roles[idx], data);
      return roles[idx];
    },

    remove: function (id) {
      const idx = roles.findIndex(r => r.roleId === Number(id));
      if (idx === -1) return false;
      roles.splice(idx, 1);
      delete rolePerms[Number(id)];
      return true;
    },

    // Full matrix: roles x permissions (for permissions page)
    getPermissionMatrix: function () {
      return mockData.PERMISSIONS.map(perm => {
        const row = { permId: perm.permId, permCode: perm.permCode, permName: perm.permName, module: perm.module };
        roles.forEach(role => {
          row['role_' + role.roleId] = (rolePerms[role.roleId] || []).includes(perm.permId);
        });
        return row;
      });
    },
  };
});
