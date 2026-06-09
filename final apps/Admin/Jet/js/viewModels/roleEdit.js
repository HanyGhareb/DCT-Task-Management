define(['knockout', 'services/roleService'], function (ko, roleService) {
  'use strict';

  function RoleEditViewModel() {
    var self = this;

    var editId     = sessionStorage.getItem('editRoleId');
    self.isNew     = editId === 'new';
    self.pageTitle = ko.observable(self.isNew ? 'Add New Role' : 'Edit Role');

    self.roleCode    = ko.observable('');
    self.roleName    = ko.observable('');
    self.description = ko.observable('');
    self.isActive    = ko.observable(true);
    self.permModules = ko.observableArray([]);
    self.loading     = ko.observable(true);
    self.errors      = ko.observable({});
    self.successMsg  = ko.observable('');
    self.saving      = ko.observable(false);

    function loadData() {
      var existingP      = self.isNew ? Promise.resolve(null) : roleService.getById(editId);
      var permsByModuleP = roleService.getPermissionsByModule();
      var currentIdsP    = self.isNew ? Promise.resolve([]) : roleService.getRolePermIds(editId);

      Promise.all([existingP, permsByModuleP, currentIdsP])
        .then(function (results) {
          var existing      = results[0];
          var permsByModule = results[1];
          var currentIds    = results[2];

          if (existing) {
            self.roleCode(existing.roleCode || '');
            self.roleName(existing.roleName || '');
            self.description(existing.description || '');
            self.isActive(existing.isActive !== 'N');
          }

          self.permModules(Object.keys(permsByModule).map(function (mod) {
            return {
              module: mod,
              permissions: permsByModule[mod].map(function (p) {
                return {
                  permId: p.permId, permCode: p.permCode, permName: p.permName,
                  checked: ko.observable(currentIds.indexOf(p.permId) !== -1)
                };
              })
            };
          }));
        })
        .catch(function () {})
        .then(function () { self.loading(false); });
    }

    self.validate = function () {
      var errs = {};
      if (!self.roleCode().trim()) errs.roleCode = 'Role Code is required';
      if (!self.roleName().trim()) errs.roleName = 'Role Name is required';
      self.errors(errs);
      return Object.keys(errs).length === 0;
    };

    self.save = function () {
      if (!self.validate()) return;
      self.saving(true);

      var selectedPermIds = [];
      self.permModules().forEach(function (m) {
        m.permissions.forEach(function (p) { if (p.checked()) selectedPermIds.push(p.permId); });
      });

      var data = {
        roleCode:    self.roleCode().toUpperCase().trim(),
        roleName:    self.roleName().trim(),
        description: self.description().trim(),
        isActive:    self.isActive() ? 'Y' : 'N',
      };

      var saveP = self.isNew
        ? roleService.create(data).then(function (r) { return r.roleId; })
        : roleService.update(editId, data).then(function () { return Number(editId); });

      saveP
        .then(function (savedId) { return roleService.setRolePermissions(savedId, selectedPermIds); })
        .then(function () {
          self.saving(false);
          self.successMsg('Role saved successfully!');
          setTimeout(function () { if (window._jetApp) window._jetApp.navigate('roles'); }, 800);
        })
        .catch(function (err) {
          self.saving(false);
          self.errors({ save: (err && err.message) || 'Save failed.' });
        });
    };

    self.cancel   = function () { if (window._jetApp) window._jetApp.navigate('roles'); };
    self.hasError = function (f) { return !!(self.errors()[f]); };
    self.getError = function (f) { return self.errors()[f] || ''; };

    loadData();
  }

  return RoleEditViewModel;
});
