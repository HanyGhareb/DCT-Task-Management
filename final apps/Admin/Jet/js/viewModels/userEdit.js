define(['knockout', 'services/userService', 'services/roleService'],
function (ko, userService, roleService) {
  'use strict';

  function UserEditViewModel() {
    const self = this;

    const editId = sessionStorage.getItem('editUserId');
    self.isNew   = editId === 'new';
    self.pageTitle = ko.observable(self.isNew ? 'Add New User' : 'Edit User');

    const existing = self.isNew ? null : userService.getById(editId);

    // Form fields
    self.username        = ko.observable(existing ? existing.username        : '');
    self.displayName     = ko.observable(existing ? existing.displayName     : '');
    self.displayNameAr   = ko.observable(existing ? existing.displayNameAr   : '');
    self.email           = ko.observable(existing ? existing.email           : '');
    self.phone           = ko.observable(existing ? existing.phone           : '');
    self.employeeNumber  = ko.observable(existing ? existing.employeeNumber  : '');
    self.orgId           = ko.observable(existing ? existing.orgId           : '');
    self.isActive        = ko.observable(existing ? existing.isActive === 'Y' : true);
    self.isExternal      = ko.observable(existing ? existing.isExternal === 'Y' : false);
    self.password        = ko.observable('');
    self.confirmPassword = ko.observable('');

    // Role checkboxes
    const allRoles     = roleService.getAll().filter(r => r.isActive === 'Y');
    const currentRoles = existing ? (existing.roles || []) : ['PLATFORM_USER'];
    self.roles = allRoles.map(r => ({
      roleCode: r.roleCode, roleName: r.roleName, description: r.description,
      checked: ko.observable(currentRoles.includes(r.roleCode))
    }));

    self.orgOptions = userService.getOrgOptions();

    // Validation
    self.errors = ko.observable({});
    self.validate = function () {
      const errs = {};
      if (!self.username().trim())     errs.username    = 'Username is required';
      if (!self.displayName().trim())  errs.displayName = 'Display Name is required';
      if (!self.email().trim())        errs.email       = 'Email is required';
      if (!self.orgId())               errs.orgId       = 'Organisation is required';
      if (self.isNew && !self.password()) errs.password = 'Password is required for new users';
      if (self.password() && self.password() !== self.confirmPassword())
        errs.confirmPassword = 'Passwords do not match';
      self.errors(errs);
      return Object.keys(errs).length === 0;
    };

    self.successMsg = ko.observable('');
    self.saving = ko.observable(false);

    self.save = function () {
      if (!self.validate()) return;
      self.saving(true);
      setTimeout(() => {
        const selectedRoles = self.roles.filter(r => r.checked()).map(r => r.roleCode);
        const data = {
          username: self.username().toUpperCase().trim(),
          displayName: self.displayName().trim(),
          displayNameAr: self.displayNameAr().trim(),
          email: self.email().trim(),
          phone: self.phone().trim(),
          employeeNumber: self.employeeNumber().trim(),
          orgId: Number(self.orgId()),
          orgName: (self.orgOptions.find(o => o.value === Number(self.orgId())) || {}).label || '',
          isActive:   self.isActive() ? 'Y' : 'N',
          isExternal: self.isExternal() ? 'Y' : 'N',
          roles: selectedRoles,
          color: existing ? existing.color : '#' + Math.floor(Math.random() * 16777215).toString(16).padStart(6, '0'),
        };
        if (self.isNew) {
          if (self.password()) data.password = self.password();
          userService.create(data);
        } else {
          userService.update(editId, data);
        }
        self.saving(false);
        self.successMsg('User saved successfully!');
        setTimeout(() => {
          if (window._jetApp) window._jetApp.navigate('users');
        }, 800);
      }, 500);
    };

    self.cancel = function () {
      if (window._jetApp) window._jetApp.navigate('users');
    };

    self.hasError = function (field) { return !!(self.errors()[field]); };
    self.getError = function (field) { return self.errors()[field] || ''; };
  }

  return UserEditViewModel;
});
