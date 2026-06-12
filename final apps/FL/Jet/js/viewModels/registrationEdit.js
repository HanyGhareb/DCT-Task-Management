define(['knockout', 'services/flService'], function (ko, flService) {
  'use strict';

  function RegistrationEditViewModel() {
    var self = this;

    var editId = sessionStorage.getItem('flEditRegId') || 'new';
    self.isNew   = editId === 'new';
    self.regId   = ko.observable(self.isNew ? null : Number(editId));
    self.loading = ko.observable(true);
    self.saving  = ko.observable(false);
    self.successMsg = ko.observable('');
    self.errorMsg   = ko.observable('');
    self.audit      = ko.observable(null);

    self.registrationNumber = ko.observable('');
    self.status        = ko.observable('DRAFT');
    self.firstNameEn   = ko.observable('');
    self.lastNameEn    = ko.observable('');
    self.firstNameAr   = ko.observable('');
    self.lastNameAr    = ko.observable('');
    self.dateOfBirth   = ko.observable('');
    self.nationalityCode = ko.observable('');
    self.nationalId    = ko.observable('');
    self.passportNumber = ko.observable('');
    self.email         = ko.observable('');
    self.mobile        = ko.observable('');
    self.specialization = ko.observable('');
    self.notes         = ko.observable('');
    self.photoSrc      = ko.observable('');
    self.nationalities = ko.observableArray([]);

    self.editable = ko.computed(function () {
      return self.status() === 'DRAFT' || self.status() === 'RETURNED';
    });
    self.needsEmiratesId = ko.computed(function () { return self.nationalityCode() === 'AE'; });

    function load() {
      if (self.isNew) { self.loading(false); return; }
      flService.getRegistration(self.regId()).then(function (r) {
        self.audit(r);
        self.registrationNumber(r.registrationNumber || '');
        self.status(r.status || 'DRAFT');
        self.firstNameEn(r.firstNameEn || '');
        self.lastNameEn(r.lastNameEn || '');
        self.firstNameAr(r.firstNameAr || '');
        self.lastNameAr(r.lastNameAr || '');
        self.dateOfBirth(r.dateOfBirth || '');
        self.nationalityCode(r.nationalityCode || '');
        self.nationalId(r.nationalId || '');
        self.passportNumber(r.passportNumber || '');
        self.email(r.email || '');
        self.mobile(r.mobile || '');
        self.specialization(r.specialization || '');
        self.notes(r.notes || '');
        self.photoSrc('https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/fl/registrations/' + self.regId() + '/photo?t=' + Date.now());
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }
    // Load the nationality options BEFORE binding the record value — if the
    // options arrive after, KO's options binding resets the selection to the
    // caption and the draft silently loses its nationality (same pattern as
    // contractEdit's Promise.all-then-load).
    flService.getLookups().then(function (lk) {
      self.nationalities(lk.nationalities || []);
    }).catch(function () {}).then(load);

    function payload() {
      return {
        firstNameEn: self.firstNameEn().trim(),
        lastNameEn:  self.lastNameEn().trim(),
        firstNameAr: self.firstNameAr().trim(),
        lastNameAr:  self.lastNameAr().trim(),
        dateOfBirth: self.dateOfBirth(),
        nationalityCode: self.nationalityCode(),
        nationalId:  self.nationalId().trim(),
        passportNumber: self.passportNumber().trim(),
        email:       self.email().trim(),
        mobile:      self.mobile().trim(),
        specialization: self.specialization().trim(),
        notes:       self.notes().trim()
      };
    }

    function flash(msg) {
      self.successMsg(msg);
      setTimeout(function () { self.successMsg(''); }, 3000);
    }

    self.saveDraft = function () {
      self.errorMsg('');
      if (!self.firstNameEn().trim() || !self.lastNameEn().trim() || !self.email().trim()
          || !self.dateOfBirth() || !self.nationalityCode()) {
        self.errorMsg('Name, date of birth, nationality and email are required.');
        return null;
      }
      self.saving(true);
      var op = self.isNew
        ? flService.createRegistration(payload()).then(function (r) {
            self.isNew = false;
            self.regId(r.registrationId);
            self.registrationNumber(r.registrationNumber);
            sessionStorage.setItem('flEditRegId', String(r.registrationId));
            return r;
          })
        : flService.updateRegistration(self.regId(), payload());
      return op.then(function (r) {
        self.saving(false);
        flash('Saved.');
        return r;
      }).catch(function (err) {
        self.saving(false);
        self.errorMsg((err && err.message) || 'Save failed');
        throw err;
      });
    };

    self.submit = function () {
      var save = self.saveDraft();
      if (!save) return;
      save.then(function () {
        return flService.submitRegistration(self.regId());
      }).then(function () {
        self.status('SUBMITTED');
        flash('Submitted for approval.');
      }).catch(function (err) {
        if (err && err.message) self.errorMsg(err.message);
      });
    };

    self.pickPhoto = function () {
      var input = document.getElementById('fl-reg-photo-input');
      if (input) input.click();
    };

    self.photoSelected = function (vm, event) {
      var file = event.target.files && event.target.files[0];
      event.target.value = '';
      if (!file || !self.regId()) {
        if (!self.regId()) self.errorMsg('Save the draft first, then attach the photo.');
        return;
      }
      var url = URL.createObjectURL(file);
      var img = new Image();
      img.onload = function () {
        URL.revokeObjectURL(url);
        var side = 512, quality = 0.85, b64 = null;
        while (side >= 96) {
          var scale = Math.min(1, side / Math.max(img.width, img.height));
          var canvas = document.createElement('canvas');
          canvas.width  = Math.max(1, Math.round(img.width * scale));
          canvas.height = Math.max(1, Math.round(img.height * scale));
          canvas.getContext('2d').drawImage(img, 0, 0, canvas.width, canvas.height);
          b64 = canvas.toDataURL('image/jpeg', quality).split(',')[1];
          if (b64.length <= 30000) break;
          if (quality > 0.6) { quality -= 0.1; } else { side -= 96; quality = 0.85; }
        }
        flService.uploadRegistrationPhoto(self.regId(), b64, 'image/jpeg', file.name).then(function () {
          self.photoSrc('https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/fl/registrations/' + self.regId() + '/photo?t=' + Date.now());
          flash('Photo uploaded.');
        }).catch(function (err) { self.errorMsg((err && err.message) || 'Photo upload failed'); });
      };
      img.onerror = function () { URL.revokeObjectURL(url); self.errorMsg('Could not read the image'); };
      img.src = url;
    };

    self.back = function () { if (window._jetApp) window._jetApp.navigate('registrations'); };
  }

  return RegistrationEditViewModel;
});
