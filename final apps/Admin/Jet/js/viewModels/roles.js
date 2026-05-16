define(['knockout', 'services/roleService'], function (ko, roleService) {
  'use strict';

  function RolesViewModel() {
    const self = this;

    self.allRoles   = ko.observableArray(roleService.getAll());
    self.searchTerm = ko.observable('');

    self.filteredRoles = ko.computed(() => {
      const q = self.searchTerm().toLowerCase().trim();
      if (!q) return self.allRoles();
      return self.allRoles().filter(r =>
        r.roleCode.toLowerCase().includes(q) ||
        r.roleName.toLowerCase().includes(q) ||
        (r.description || '').toLowerCase().includes(q)
      );
    });

    self.deleteTarget = ko.observable(null);
    self.showDeleteConfirm = ko.observable(false);

    self.navigateToEdit = function (roleId) {
      sessionStorage.setItem('editRoleId', roleId || 'new');
      if (window._jetApp) window._jetApp.navigate('roleEdit');
    };

    self.addRole    = function () { self.navigateToEdit('new'); };
    self.editRole   = function (role) { self.navigateToEdit(role.roleId); };

    self.confirmDelete = function (role) { self.deleteTarget(role); self.showDeleteConfirm(true); };
    self.cancelDelete  = function () { self.showDeleteConfirm(false); self.deleteTarget(null); };
    self.doDelete = function () {
      const t = self.deleteTarget();
      if (t) { roleService.remove(t.roleId); self.allRoles(roleService.getAll()); }
      self.cancelDelete();
    };
  }

  return RolesViewModel;
});
