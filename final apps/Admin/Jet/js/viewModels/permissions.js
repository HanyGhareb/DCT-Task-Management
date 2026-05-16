define(['knockout', 'services/roleService'], function (ko, roleService) {
  'use strict';

  function PermissionsViewModel() {
    const self = this;

    self.roles       = roleService.getAll();
    self.permissions = roleService.getPermissions();
    self.matrix      = ko.observableArray(roleService.getPermissionMatrix());
    self.savedMsg    = ko.observable('');

    // Group permissions by module for display
    const modules = [...new Set(self.permissions.map(p => p.module))];
    self.modules = modules;

    self.getPermsByModule = function (mod) {
      return self.matrix().filter(row => row.module === mod);
    };

    self.togglePerm = function (row, role) {
      const key = 'role_' + role.roleId;
      row[key] = !row[key];
      self.matrix.notifySubscribers(self.matrix());
    };

    self.hasPerm = function (row, role) {
      return row['role_' + role.roleId];
    };

    self.saveAll = function () {
      self.roles.forEach(role => {
        const permIds = self.matrix()
          .filter(row => row['role_' + role.roleId])
          .map(row => row.permId);
        roleService.setRolePermissions(role.roleId, permIds);
      });
      self.savedMsg('Permission matrix saved!');
      setTimeout(() => self.savedMsg(''), 3000);
    };
  }

  return PermissionsViewModel;
});
