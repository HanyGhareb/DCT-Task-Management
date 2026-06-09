define(['knockout', 'services/roleService'], function (ko, roleService) {
  'use strict';

  function RolesViewModel() {
    var self = this;

    self.allRoles   = ko.observableArray([]);
    self.loading    = ko.observable(true);
    self.searchTerm = ko.observable('');

    self.filteredRoles = ko.computed(function () {
      var q = self.searchTerm().toLowerCase().trim();
      if (!q) return self.allRoles();
      return self.allRoles().filter(function (r) {
        return r.roleCode.toLowerCase().indexOf(q) !== -1 ||
               r.roleName.toLowerCase().indexOf(q) !== -1 ||
               (r.description || '').toLowerCase().indexOf(q) !== -1;
      });
    });

    self.deleteTarget       = ko.observable(null);
    self.showDeleteConfirm  = ko.observable(false);

    function loadRoles() {
      self.loading(true);
      roleService.getAll()
        .then(function (items) { self.allRoles(items); })
        .catch(function () {})
        .then(function () { self.loading(false); });
    }

    self.navigateToEdit = function (roleId) {
      sessionStorage.setItem('editRoleId', roleId || 'new');
      if (window._jetApp) window._jetApp.navigate('roleEdit');
    };

    self.addRole  = function () { self.navigateToEdit('new'); };
    self.editRole = function (role) { self.navigateToEdit(role.roleId); };

    self.confirmDelete = function (role) { self.deleteTarget(role); self.showDeleteConfirm(true); };
    self.cancelDelete  = function () { self.showDeleteConfirm(false); self.deleteTarget(null); };
    self.doDelete = function () {
      var t = self.deleteTarget();
      self.cancelDelete();
      if (t) { roleService.remove(t.roleId).then(function () { loadRoles(); }).catch(function () {}); }
    };

    loadRoles();
  }

  return RolesViewModel;
});
