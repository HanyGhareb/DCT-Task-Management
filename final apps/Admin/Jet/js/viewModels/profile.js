define(['knockout', 'services/authService', 'services/userService'],
function (ko, authService, userService) {
  'use strict';

  function ProfileViewModel() {
    const self = this;

    const session = authService.getCurrentUser();
    const user    = session ? userService.getById(session.userId) : null;

    self.displayName   = ko.observable(user ? user.displayName   : '');
    self.displayNameAr = ko.observable(user ? user.displayNameAr : '');
    self.email         = ko.observable(user ? user.email         : '');
    self.phone         = ko.observable(user ? user.phone         : '');
    self.username      = user ? user.username      : '';
    self.employeeNumber= user ? user.employeeNumber : '';
    self.orgName       = user ? user.orgName        : '';
    self.roles         = user ? user.roles          : [];
    self.color         = user ? user.color          : '#C74634';
    self.successMsg    = ko.observable('');
    self.saving        = ko.observable(false);

    self.initials = ko.computed(() => {
      const p = self.displayName().split(' ');
      return p.length >= 2 ? (p[0][0] + p[p.length-1][0]).toUpperCase() : (p[0]||'?')[0].toUpperCase();
    });

    // Change password
    self.currentPassword = ko.observable('');
    self.newPassword     = ko.observable('');
    self.confirmNewPwd   = ko.observable('');
    self.pwdError        = ko.observable('');
    self.pwdSuccess      = ko.observable('');

    self.saveProfile = function () {
      self.saving(true);
      setTimeout(() => {
        if (user) {
          userService.update(user.userId, {
            displayName: self.displayName(), displayNameAr: self.displayNameAr(),
            email: self.email(), phone: self.phone(),
          });
        }
        self.saving(false);
        self.successMsg('Profile updated successfully!');
        setTimeout(() => self.successMsg(''), 3000);
      }, 400);
    };

    self.changePassword = function () {
      self.pwdError('');
      if (!self.newPassword()) { self.pwdError('New password is required.'); return; }
      if (self.newPassword() !== self.confirmNewPwd()) { self.pwdError('Passwords do not match.'); return; }
      if (self.newPassword().length < 8) { self.pwdError('Password must be at least 8 characters.'); return; }
      setTimeout(() => {
        self.pwdSuccess('Password changed successfully!');
        self.currentPassword(''); self.newPassword(''); self.confirmNewPwd('');
        setTimeout(() => self.pwdSuccess(''), 3000);
      }, 400);
    };

    // Delegations
    self.delegations = ko.observableArray([
      { fromName: 'Hashem Al Kabbi', toName: 'Naser Al Khaja', startDate: '20 May 2026', endDate: '25 May 2026', reason: 'Annual leave', status: 'Upcoming' }
    ]);
  }

  return ProfileViewModel;
});
