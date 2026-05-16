define(['knockout', 'services/roleService'], function (ko, roleService) {
  'use strict';

  function RoleEditViewModel() {
    const self = this;

    const editId   = sessionStorage.getItem('editRoleId');
    self.isNew     = editId === 'new';
    self.pageTitle = ko.observable(self.isNew ? 'Add New Role' : 'Edit Role');

    const existing = self.isNew ? null : roleService.getById(editId);

    self.roleCode    = ko.observable(existing ? existing.roleCode    : '');
    self.roleName    = ko.observable(existing ? existing.roleName    : '');
    self.description = ko.observable(existing ? existing.description : '');
    self.isActive    = ko.observable(existing ? existing.isActive === 'Y' : true);

    // Permissions grouped by module
    const permsByModule = roleService.getPermissionsByModule();
    const currentPermIds = self.isNew ? [] : roleService.getRolePermIds(editId);

    self.permModules = Object.keys(permsByModule).map(module => ({
      module,
      permissions: permsByModule[module].map(p => ({
        permId: p.permId, permCode: p.permCode, permName: p.permName,
        checked: ko.observable(currentPermIds.includes(p.permId))
      }))
    }));

    self.errors     = ko.observable({});
    self.successMsg = ko.observable('');
    self.saving     = ko.observable(false);

    self.validate = function () {
      const errs = {};
      if (!self.roleCode().trim())  errs.roleCode  = 'Role Code is required';
      if (!self.roleName().trim())  errs.roleName  = 'Role Name is required';
      self.errors(errs);
      return Object.keys(errs).length === 0;
    };

    self.save = function () {
      if (!self.validate()) return;
      self.saving(true);
      setTimeout(() => {
        const selectedPermIds = [];
        self.permModules.forEach(m => m.permissions.forEach(p => { if (p.checked()) selectedPermIds.push(p.permId); }));

        const data = {
          roleCode: self.roleCode().toUpperCase().trim(),
          roleName: self.roleName().trim(),
          description: self.description().trim(),
          isActive: self.isActive() ? 'Y' : 'N',
        };
        let savedId;
        if (self.isNew) savedId = roleService.create(data).roleId;
        else { roleService.update(editId, data); savedId = Number(editId); }

        roleService.setRolePermissions(savedId, selectedPermIds);
        self.saving(false);
        self.successMsg('Role saved successfully!');
        setTimeout(() => { if (window._jetApp) window._jetApp.navigate('roles'); }, 800);
      }, 400);
    };

    self.cancel = function () { if (window._jetApp) window._jetApp.navigate('roles'); };
    self.hasError = function (f) { return !!(self.errors()[f]); };
    self.getError = function (f) { return self.errors()[f] || ''; };
  }

  return RoleEditViewModel;
});
