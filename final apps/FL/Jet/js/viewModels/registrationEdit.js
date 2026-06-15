define(['knockout', 'services/flService', 'shared/formGuard', 'shared/i18n', 'shared/docUpload'], function (ko, flService, formGuard, i18n, docUpload) {
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

    // Required documents
    self.docRequirements = ko.observableArray([]);   // from /doc-requirements?context=REGISTRATION
    self.regDocs         = ko.observableArray([]);    // uploaded docs for this registration
    self.docError        = ko.observable('');
    self.docBusy         = ko.observable(false);
    self.lang            = (i18n && i18n.lang) ? i18n.lang : ko.observable('en');

    self.editable = ko.computed(function () {
      return self.status() === 'DRAFT' || self.status() === 'RETURNED';
    });
    self.needsEmiratesId = ko.computed(function () { return self.nationalityCode() === 'AE'; });

    // Which required docs apply to THIS registration, merged with upload status.
    self.docChecklist = ko.computed(function () {
      var nat = self.nationalityCode();
      var hasEid = !!(self.nationalId() || '').trim();
      var uploaded = self.regDocs();
      var ar = self.lang() === 'ar';
      return self.docRequirements().filter(function (req) {
        if (req.docTypeCode === 'EMIRATES_ID')    return nat === 'AE' || hasEid;
        if (req.docTypeCode === 'RESIDENCE_VISA')  return !!nat && nat !== 'AE';
        return true;
      }).map(function (req) {
        var up = null;
        for (var i = 0; i < uploaded.length; i++) {
          if (uploaded[i].docTypeId === req.docTypeId && uploaded[i].hasFile === 'Y') { up = uploaded[i]; break; }
        }
        return {
          docTypeId:   req.docTypeId,
          docTypeCode: req.docTypeCode,
          name:        ar ? (req.docTypeNameAr || req.docTypeName) : req.docTypeName,
          mandatory:   req.isMandatory === 'Y',
          uploaded:    !!up,
          docId:       up ? up.documentId : null,
          fileName:    up ? up.documentName : ''
        };
      });
    });

    // Names of mandatory applicable docs not yet uploaded (gates Submit only).
    self.missingDocs = function () {
      return self.docChecklist().filter(function (d) { return d.mandatory && !d.uploaded; })
                                .map(function (d) { return d.name; });
    };

    function initGuard() {
      self._guard = formGuard.track([
        self.firstNameEn, self.lastNameEn, self.firstNameAr, self.lastNameAr,
        self.dateOfBirth, self.nationalityCode, self.nationalId, self.passportNumber,
        self.email, self.mobile, self.specialization, self.notes
      ]);
    }

    function load() {
      if (self.isNew) { self.loading(false); initGuard(); return; }
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
        initGuard();
        self.loadRegDocs();
      }).catch(function () { self.loading(false); initGuard(); });
    }

    self.loadRegDocs = function () {
      if (!self.regId()) { self.regDocs([]); return; }
      flService.getRegistrationDocuments(self.regId()).then(function (items) {
        self.regDocs(items);
      }).catch(function () {});
    };

    // Load the nationality options BEFORE binding the record value — if the
    // options arrive after, KO's options binding resets the selection to the
    // caption and the draft silently loses its nationality (same pattern as
    // contractEdit's Promise.all-then-load).
    flService.getLookups().then(function (lk) {
      self.nationalities(lk.nationalities || []);
    }).catch(function () {}).then(load);

    flService.getDocRequirements('REGISTRATION').then(function (reqs) {
      self.docRequirements(reqs);
    }).catch(function () {});

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

    // ---- Field-level validation -------------------------------------------
    // One validator per field returns an error string ('' = valid). Reused by
    // the blur handler (inline) and by validate() (full check on Submit).
    // Mirrors the server checks in DCT_FL_PKG.submit_registration.
    var V = {
      firstNameEn: function () {
        return self.firstNameEn().trim() ? '' : 'Required.';
      },
      lastNameEn: function () {
        return self.lastNameEn().trim() ? '' : 'Required.';
      },
      dateOfBirth: function () {
        var v = self.dateOfBirth();
        if (!v) return 'Required.';
        var dob = new Date(v);
        if (isNaN(dob.getTime())) return 'Not a valid date.';
        var today = new Date(); today.setHours(0, 0, 0, 0);
        if (dob > today) return 'Cannot be in the future.';
        if (dob.getFullYear() < 1900) return 'Year is not valid.';
        var age = today.getFullYear() - dob.getFullYear();
        var md = today.getMonth() - dob.getMonth();
        if (md < 0 || (md === 0 && today.getDate() < dob.getDate())) age--;
        if (age < 18) return 'Must be at least 18 years old.';
        return '';
      },
      nationalityCode: function () {
        return self.nationalityCode() ? '' : 'Required.';
      },
      email: function () {
        var v = self.email().trim();
        if (!v) return 'Required.';
        if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(v))
          return 'Enter a valid email (becomes the portal login).';
        return '';
      },
      nationalId: function () {
        var v = self.nationalId().trim();
        if (self.needsEmiratesId() && !v) return 'Required for UAE nationals.';
        if (v && !/^784\d{12}$/.test(v.replace(/\D/g, '')))
          return 'Must be 15 digits starting with 784.';
        return '';
      },
      passportNumber: function () {
        var v = self.passportNumber().trim();
        if (v && !/^[A-Za-z0-9]{6,12}$/.test(v))
          return '6–12 letters or digits.';
        return '';
      },
      mobile: function () {
        var v = self.mobile().trim();
        if (v && !/^\+?\d{7,15}$/.test(v.replace(/[\s\-()]/g, '')))
          return '7–15 digits, optional leading +.';
        return '';
      }
    };
    var FIELD_ORDER = ['firstNameEn', 'lastNameEn', 'dateOfBirth', 'nationalityCode',
                       'email', 'nationalId', 'passportNumber', 'mobile'];

    self.err = {};
    FIELD_ORDER.forEach(function (k) { self.err[k] = ko.observable(''); });

    // Inline check fired on blur. Returns true so KO doesn't cancel the event.
    self.checkField = function (name) {
      if (V[name]) self.err[name](V[name]());
      // "at least one ID" is cross-field — re-evaluate the partner field too.
      if (name === 'nationalId' || name === 'passportNumber') crossCheckIds();
      return true;
    };

    function crossCheckIds() {
      if (!self.nationalId().trim() && !self.passportNumber().trim()) {
        if (!self.err.passportNumber()) self.err.passportNumber('Provide an Emirates ID or a passport number.');
      } else {
        // clear the cross-field message if a single-field error isn't present
        if (self.err.passportNumber() === 'Provide an Emirates ID or a passport number.') {
          self.err.passportNumber(V.passportNumber());
        }
      }
    }

    // Validation. SUBMIT = full (required + format). Draft (opts.draft) = format
    // only: blank fields are allowed, but any value entered must be well-formed.
    function validate(opts) {
      var draft = !!(opts && opts.draft);
      var ok = true;
      FIELD_ORDER.forEach(function (k) {
        var blank = !(self[k]() || '').toString().trim();
        var m = (draft && blank) ? '' : V[k]();
        self.err[k](m);
        if (m) ok = false;
      });
      // "at least one ID" is a submit-only requirement (a draft may have neither yet).
      if (!draft && !self.nationalId().trim() && !self.passportNumber().trim()) {
        self.err.passportNumber('Provide an Emirates ID or a passport number.');
        ok = false;
      }
      // Required documents gate Submit only (drafts may be saved without them).
      if (!draft) {
        var missing = self.missingDocs();
        if (missing.length) {
          ok = false;
          self.docError((self.regId() ? 'Attach required document(s): ' : 'Save the draft, then attach: ') + missing.join(', ') + '.');
        } else {
          self.docError('');
        }
      }
      return ok;
    }

    self.saveDraft = function () {
      self.errorMsg('');
      if (!validate({ draft: true })) { self.errorMsg('Please correct the highlighted fields.'); return null; }
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
        if (self._guard) self._guard.reset();
        return r;
      }).catch(function (err) {
        self.saving(false);
        self.errorMsg((err && err.message) || 'Save failed');
        throw err;
      });
    };

    self.submit = function () {
      self.errorMsg('');
      if (!validate()) { self.errorMsg('Please correct the highlighted fields.'); return; }
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

    // ---- Required-document uploads (raw-binary, no size cap) --------------
    // Picks a file via the shared dialog (size/type validated there) then
    // uploads its raw bytes: createDocument (metadata) → putBinary (the file).
    self.pickDocFile = function (item) {
      self.docError('');
      if (!self.regId()) { self.docError('Save the draft first, then attach documents.'); return; }
      docUpload.choose({ accept: 'image/*,application/pdf', maxMb: 10 }).then(function (file) {
        if (file) uploadDocBlob(item, file);
      });
    };

    function uploadDocBlob(item, file) {
      self.docBusy(true);
      var mime = file.type || 'application/octet-stream';
      var chain = item.docId ? flService.deleteDocument(item.docId) : Promise.resolve();
      chain.then(function () {
        return flService.createDocument({
          sourceType: 'REGISTRATION', sourceId: self.regId(),
          docTypeId: item.docTypeId, documentName: file.name, mimeType: mime, isRequired: 'Y'
        });
      }).then(function (r) {
        return flService.uploadDocumentFile(r.documentId, file);
      }).then(function () {
        self.docBusy(false);
        self.loadRegDocs();
        flash('Document uploaded.');
      }).catch(function (err) {
        self.docBusy(false);
        self.docError((err && err.message) || 'Document upload failed');
      });
    }

    self.removeDoc = function (item) {
      if (!item.docId) return;
      self.docBusy(true);
      flService.deleteDocument(item.docId).then(function () {
        self.docBusy(false);
        self.loadRegDocs();
      }).catch(function (err) {
        self.docBusy(false);
        self.docError((err && err.message) || 'Remove failed');
      });
    };

    self.viewDoc = function (item) {
      if (!item.docId) return;
      window.open('https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/fl/documents/' + item.docId + '/file', '_blank');
    };

    self.back = function () { if (window._jetApp) window._jetApp.navigate('registrations'); };
  }

  return RegistrationEditViewModel;
});
