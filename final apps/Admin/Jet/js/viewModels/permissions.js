define(['knockout', 'services/roleService'], function (ko, roleService) {
  'use strict';

  function PermissionsViewModel() {
    var self = this;

    self.roles    = ko.observableArray([]);
    self.modules  = ko.observableArray([]);
    self.matrix   = ko.observableArray([]);
    self.loading  = ko.observable(true);
    self.savedMsg = ko.observable('');
    self.error    = ko.observable('');

    function loadData() {
      self.loading(true);
      self.error('');
      roleService.getPermissionMatrix()
        .then(function (result) {
          self.roles(result.roles);
          self.matrix(result.matrix);
          var seen = {};
          var mods = [];
          result.matrix.forEach(function (row) {
            if (row.module && !seen[row.module]) { seen[row.module] = true; mods.push(row.module); }
          });
          self.modules(mods);
        })
        .catch(function (err) {
          self.error((err && err.message) || 'Failed to load permission matrix.');
        })
        .then(function () { self.loading(false); });
    }

    self.getPermsByModule = function (mod) {
      return self.matrix().filter(function (row) { return row.module === mod; });
    };

    self.togglePerm = function (row, role) {
      var key = 'role_' + role.roleId;
      row[key] = !row[key];
      self.matrix.notifySubscribers(self.matrix());
    };

    self.hasPerm = function (row, role) {
      return row['role_' + role.roleId];
    };

    self.saveAll = function () {
      self.savedMsg('');
      var saves = self.roles().map(function (role) {
        var permIds = self.matrix()
          .filter(function (row) { return row['role_' + role.roleId]; })
          .map(function (row) { return row.permId; });
        return roleService.setRolePermissions(role.roleId, permIds);
      });
      Promise.all(saves)
        .then(function () {
          self.savedMsg('Permission matrix saved!');
          setTimeout(function () { self.savedMsg(''); }, 3000);
        })
        .catch(function (err) {
          self.savedMsg('Save failed: ' + ((err && err.message) || 'Unknown error'));
        });
    };

    loadData();
  }

  return PermissionsViewModel;
});
