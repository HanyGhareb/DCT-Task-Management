define(['knockout', 'services/userService', 'services/roleService'],
function (ko, userService, roleService) {
  'use strict';

  function UserEditViewModel() {
    var self = this;

    var editId   = sessionStorage.getItem('editUserId');
    self.isNew   = editId === 'new';
    self.pageTitle = ko.observable(self.isNew ? 'Add New User' : 'Edit User');
    self.loading = ko.observable(true);

    // Form observables — populated after async load
    self.username        = ko.observable('');
    self.displayName     = ko.observable('');
    self.displayNameAr   = ko.observable('');
    self.email           = ko.observable('');
    self.phone           = ko.observable('');
    self.employeeNumber  = ko.observable('');
    self.orgId           = ko.observable('');
    self.isActive        = ko.observable(true);
    self.isExternal      = ko.observable(false);
    self.password        = ko.observable('');
    self.confirmPassword = ko.observable('');

    self.roles      = ko.observableArray([]);
    self.orgOptions = ko.observableArray([]);

    self.errors     = ko.observable({});
    self.successMsg = ko.observable('');
    self.saving     = ko.observable(false);
    self.audit      = ko.observable(null);   // createdBy/At, updatedBy/At

    self.hasError = function (field) { return !!(self.errors()[field]); };
    self.getError = function (field) { return self.errors()[field] || ''; };

    self.setFieldError = function (field, msg) {
      var e = Object.assign({}, self.errors());
      if (msg) e[field] = msg; else delete e[field];
      self.errors(e);
    };

    /* Live password checks — run on blur (leaving the field), not on save */
    self.passwordHint = 'Minimum 8 characters.';
    self.validatePassword = function () {
      var p = self.password();
      if (!p) {
        self.setFieldError('password', self.isNew ? 'Password is required for new users' : null);
      } else {
        self.setFieldError('password', p.length < 8 ? 'Password must be at least 8 characters' : null);
      }
      if (self.confirmPassword()) self.validateConfirm();
      return true;
    };
    self.validateConfirm = function () {
      self.setFieldError('confirmPassword',
        self.password() && self.confirmPassword() !== self.password()
          ? 'Passwords do not match' : null);
      return true;
    };

    self.validate = function () {
      var errs = {};
      if (!self.username().trim())    errs.username    = 'Username is required';
      if (!self.displayName().trim()) errs.displayName = 'Display Name is required';
      if (!self.email().trim())       errs.email       = 'Email is required';
      if (!self.orgId())              errs.orgId       = 'Organisation is required';
      if (self.isNew && !self.password()) errs.password = 'Password is required for new users';
      if (self.password() && self.password().length < 8)
        errs.password = 'Password must be at least 8 characters';
      if (self.password() && self.password() !== self.confirmPassword())
        errs.confirmPassword = 'Passwords do not match';
      self.errors(errs);
      return Object.keys(errs).length === 0;
    };

    self.save = function () {
      if (!self.validate()) return;
      self.saving(true);

      var selectedRoles = self.roles().filter(function (r) { return r.checked(); })
                                      .map(function (r) { return r.roleCode; });
      var orgLabel = (self.orgOptions().find(function (o) { return o.value === Number(self.orgId()); }) || {}).label || '';

      var data = {
        username:       self.username().toUpperCase().trim(),
        displayName:    self.displayName().trim(),
        displayNameAr:  self.displayNameAr().trim(),
        email:          self.email().trim(),
        phone:          self.phone().trim(),
        employeeNumber: self.employeeNumber().trim(),
        orgId:          Number(self.orgId()),
        orgName:        orgLabel,
        isActive:       self.isActive() ? 'Y' : 'N',
        isExternal:     self.isExternal() ? 'Y' : 'N',
        roles:          selectedRoles,
      };
      if (self.password()) data.password = self.password();

      var op = self.isNew ? userService.create(data) : userService.update(editId, data);
      op.then(function () {
        self.saving(false);
        self.successMsg('User saved successfully!');
        setTimeout(function () {
          if (window._jetApp) window._jetApp.navigate('users');
        }, 800);
      }).catch(function (err) {
        self.saving(false);
        self.errors({ _global: (err && err.message) || 'Save failed. Please try again.' });
      });
    };

    self.cancel = function () {
      if (window._jetApp) window._jetApp.navigate('users');
    };

    // ── Async load: user record + roles list + org options ──────────────────
    var userPromise = self.isNew
      ? Promise.resolve(null)
      : userService.getById(editId);

    Promise.all([userPromise, roleService.getAll(), userService.getOrgOptions()])
      .then(function (results) {
        var existing   = results[0];
        var allRoles   = results[1].filter(function (r) { return r.isActive === 'Y'; });
        var orgOpts    = results[2];

        /* Options MUST be set before the selected value — KO's value binding
           writes '' back into orgId when the select has no matching option
           yet (this is why the saved org appeared blank when editing). */
        self.orgOptions(orgOpts);

        if (existing) {
          self.audit(existing);
          self.username(existing.username || '');
          self.displayName(existing.displayName || '');
          self.displayNameAr(existing.displayNameAr || '');
          self.email(existing.email || '');
          self.phone(existing.phone || '');
          self.employeeNumber(existing.employeeNumber || '');
          self.orgId(existing.orgId || '');
          self.isActive(existing.isActive === 'Y');
          self.isExternal(existing.isExternal === 'Y');
        }

        var currentRoles = existing ? (existing.roles || []) : ['PLATFORM_USER'];
        self.roles(allRoles.map(function (r) {
          return {
            roleCode:    r.roleCode,
            roleName:    r.roleName,
            description: r.description,
            checked:     ko.observable(currentRoles.includes(r.roleCode)),
          };
        }));

        self.loading(false);
      })
      .catch(function () {
        self.loading(false);
      });
  }

  return UserEditViewModel;
});
