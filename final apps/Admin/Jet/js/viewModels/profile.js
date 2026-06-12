define(['knockout', 'services/authService', 'services/userService', 'services/delegationService'],
function (ko, authService, userService, delegationService) {
  'use strict';

  function ProfileViewModel() {
    var self = this;

    /* Session gives instant first paint; the server is the source of truth
       (the session snapshot is only written at login, so it goes stale as
       soon as the profile is edited). */
    var session = authService.getCurrentUser() || {};

    self.displayName    = ko.observable(session.displayName    || '');
    self.displayNameAr  = ko.observable(session.displayNameAr  || '');
    self.email          = ko.observable(session.email          || '');
    self.phone          = ko.observable(session.phone          || '');
    self.employeeNumber = ko.observable(session.employeeNumber || '');
    self.orgName        = ko.observable(session.orgName        || '');
    self.photoUrl       = ko.observable(session.photoUrl       || '');
    self.username       = session.username       || '';
    self.roles          = session.roles          || [];
    self.color          = session.color          || '#C74634';
    self.successMsg     = ko.observable('');
    self.saving         = ko.observable(false);
    self.errorMsg       = ko.observable('');
    self.audit          = ko.observable(null);   // createdBy/At, updatedBy/At

    /* Cache-busted img src — the photo URL is stable, the bytes change */
    self.photoSrc = ko.observable('');
    function setPhoto(url) {
      self.photoUrl(url || '');
      self.photoSrc(url ? url + '?t=' + Date.now() : '');
    }
    setPhoto(session.photoUrl);

    /* Server-first load: refresh every editable field from GET /users/:id */
    if (session.userId) {
      userService.getById(session.userId).then(function (u) {
        self.audit(u);
        self.displayName(u.displayName       || '');
        self.displayNameAr(u.displayNameAr   || '');
        self.email(u.email                   || '');
        self.phone(u.phone                   || '');
        self.employeeNumber(u.employeeNumber || '');
        self.orgName(u.orgName               || '');
        setPhoto(u.photoUrl);
        /* keep the cached session in step so other views/top bar agree */
        authService.updateCachedUser({
          displayName: u.displayName, displayNameAr: u.displayNameAr,
          email: u.email, phone: u.phone, employeeNumber: u.employeeNumber,
          photoUrl: u.photoUrl || null,
        });
      }).catch(function () { /* session values already shown */ });
    }

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
      var payload = {
        displayName:    self.displayName(),
        displayNameAr:  self.displayNameAr(),
        email:          self.email(),
        phone:          self.phone(),
        employeeNumber: self.employeeNumber(),
      };
      userService.update(session.userId, payload).then(function () {
        authService.updateCachedUser(payload);
        self.saving(false);
        self.successMsg('Profile updated successfully!');
        setTimeout(function () { self.successMsg(''); }, 3000);
      }).catch(function (err) {
        self.saving(false);
        self.errorMsg('Update failed: ' + ((err && err.message) || 'Unknown error'));
      });
    };

    /* Photo upload */
    self.uploadingPhoto = ko.observable(false);
    self.photoError     = ko.observable('');

    self.pickPhoto = function (vm, event) {
      var input = document.getElementById('profile-photo-input');
      if (input) input.click();
    };

    self.photoSelected = function (vm, event) {
      var file = event.target.files && event.target.files[0];
      event.target.value = '';            /* allow re-selecting the same file */
      if (!file || !session.userId) return;
      self.photoError('');
      self.uploadingPhoto(true);
      userService.uploadPhoto(session.userId, file).then(function (r) {
        setPhoto(r.photoUrl);
        authService.updateCachedUser({ photoUrl: r.photoUrl });
        self.uploadingPhoto(false);
        self.successMsg('Photo updated!');
        setTimeout(function () { self.successMsg(''); }, 3000);
      }).catch(function (err) {
        self.uploadingPhoto(false);
        self.photoError((err && err.message) || 'Photo upload failed');
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

    /* Delegations — real data (Phase 4) */
    self.delegations     = ko.observableArray([]);
    self.delLoading      = ko.observable(true);
    self.delBusy         = ko.observable(false);
    self.showDelModal    = ko.observable(false);
    self.delUsers        = ko.observableArray([]);
    self.delDelegateId   = ko.observable('');
    self.delStart        = ko.observable('');
    self.delEnd          = ko.observable('');
    self.delReason       = ko.observable('');
    self.delError        = ko.observable('');

    function loadDelegations() {
      delegationService.getAll(true).then(function (items) {
        self.delegations(items);
        self.delLoading(false);
      }).catch(function () { self.delLoading(false); });
    }
    loadDelegations();

    self.openDelModal = function () {
      self.delError('');
      userService.getAll().then(function (items) {
        self.delUsers((items || []).filter(function (u) {
          return u.userId !== session.userId && u.isActive !== 'N';
        }));
        self.showDelModal(true);
      });
    };

    self.createDelegation = function () {
      self.delError('');
      if (!self.delDelegateId()) { self.delError('Pick who will act on your behalf.'); return; }
      if (!self.delEnd())        { self.delError('An end date is required.'); return; }
      self.delBusy(true);
      delegationService.create({
        delegateId: Number(self.delDelegateId()),
        scope:      'ALL_ROLES',
        startDate:  self.delStart() || null,
        endDate:    self.delEnd(),
        reason:     self.delReason()
      }).then(function () {
        self.delBusy(false);
        self.showDelModal(false);
        self.delDelegateId(''); self.delStart(''); self.delEnd(''); self.delReason('');
        loadDelegations();
      }).catch(function (err) {
        self.delBusy(false);
        self.delError((err && err.message) || 'Could not create the delegation');
      });
    };

    self.cancelDelegation = function (d) {
      self.delBusy(true);
      delegationService.cancel(d.delegationId).then(function () {
        self.delBusy(false);
        loadDelegations();
      }).catch(function () { self.delBusy(false); });
    };

    self.isMyOutgoing = function (d) { return d.delegatorId === session.userId; };
    self.delBadge = function (s) {
      var map = { ACTIVE: 'badge--approved', CANCELLED: 'badge--idle', EXPIRED: 'badge--idle' };
      return 'badge ' + (map[s] || 'badge--pending');
    };
  }

  return ProfileViewModel;
});
