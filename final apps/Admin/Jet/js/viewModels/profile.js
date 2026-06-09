define(['knockout', 'services/authService', 'services/userService'],
function (ko, authService, userService) {
  'use strict';

  function ProfileViewModel() {
    var self = this;

    /* Use session data for immediate display; session is set at login time */
    var session = authService.getCurrentUser() || {};

    self.displayName    = ko.observable(session.displayName    || '');
    self.displayNameAr  = ko.observable(session.displayNameAr  || '');
    self.email          = ko.observable(session.email          || '');
    self.phone          = ko.observable(session.phone          || '');
    self.username       = session.username       || '';
    self.employeeNumber = session.employeeNumber || '';
    self.orgName        = session.orgName        || '';
    self.roles          = session.roles          || [];
    self.color          = session.color          || '#C74634';
    self.successMsg     = ko.observable('');
    self.saving         = ko.observable(false);
    self.errorMsg       = ko.observable('');

    self.initials = ko.computed(function () {
      var p = self.displayName().split(' ');
      return p.length >= 2
        ? (p[0][0] + p[p.length - 1][0]).toUpperCase()
        : (p[0] || '?')[0].toUpperCase();
    });

    self.saveProfile = function () {
      if (!session.userId) return;
      self.saving(true);
      self.errorMsg('');
      userService.update(session.userId, {
        displayName:   self.displayName(),
        displayNameAr: self.displayNameAr(),
        email:         self.email(),
        phone:         self.phone(),
      }).then(function () {
        self.saving(false);
        self.successMsg('Profile updated successfully!');
        setTimeout(function () { self.successMsg(''); }, 3000);
      }).catch(function (err) {
        self.saving(false);
        self.errorMsg('Update failed: ' + ((err && err.message) || 'Unknown error'));
      });
    };

    /* Change password */
    self.currentPassword = ko.observable('');
    self.newPassword     = ko.observable('');
    self.confirmNewPwd   = ko.observable('');
    self.pwdError        = ko.observable('');
    self.pwdSuccess      = ko.observable('');

    self.changePassword = function () {
      self.pwdError('');
      if (!self.newPassword())          { self.pwdError('New password is required.'); return; }
      if (self.newPassword() !== self.confirmNewPwd()) { self.pwdError('Passwords do not match.'); return; }
      if (self.newPassword().length < 8) { self.pwdError('Password must be at least 8 characters.'); return; }
      self.saving(true);
      userService.update(session.userId, { password: self.newPassword() })
        .then(function () {
          self.saving(false);
          self.pwdSuccess('Password changed successfully!');
          self.currentPassword(''); self.newPassword(''); self.confirmNewPwd('');
          setTimeout(function () { self.pwdSuccess(''); }, 3000);
        }).catch(function (err) {
          self.saving(false);
          self.pwdError('Password change failed: ' + ((err && err.message) || 'Unknown error'));
        });
    };

    /* Delegations */
    self.delegations = ko.observableArray([
      { fromName: 'Hashem Al Kabbi', toName: 'Naser Al Khaja', startDate: '20 May 2026', endDate: '25 May 2026', reason: 'Annual leave', status: 'Upcoming' }
    ]);
  }

  return ProfileViewModel;
});
