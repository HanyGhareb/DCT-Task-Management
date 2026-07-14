define(['knockout', 'services/flService', 'services/authService', 'services/docFile', 'shared/formGuard', 'shared/i18n', 'shared/docUpload'], function (ko, flService, authService, docFile, formGuard, i18n, docUpload) {
  'use strict';

  function RegistrationEditViewModel() {
    var self = this;
    var me = (authService.getCurrentUser && authService.getCurrentUser()) || {};

    var editId = sessionStorage.getItem('flEditRegId') || 'new';
    self.isNew   = editId === 'new';
    self.regId   = ko.observable(self.isNew ? null : Number(editId));
    self.loading = ko.observable(true);
    self.saving  = ko.observable(false);
    self.successMsg = ko.observable('');
    self.errorMsg   = ko.observable('');
    self.audit      = ko.observable(null);

    // Approval history — the route steps + actions, loaded once submitted.
    self.approvalMeta    = ko.observable(null);
    self.approvalSteps   = ko.observableArray([]);
    self.approvalLoading = ko.observable(false);
    self.forcing         = ko.observable(false);

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

    // Phase 1 — requestor + line manager (line manager = first approver)
    self.requestorEmail    = ko.observable('');
    self.requestorName     = ko.observable('');
    self.lineManagerEmail  = ko.observable('');
    self.lineManagerName   = ko.observable('');
    self.lineManagerHint   = ko.observable('');   // resolution feedback

    // Phase 1 — bank capture at registration (flows to bank account on approval)
    self.bankName          = ko.observable('');
    self.bankIban          = ko.observable('');
    self.bankAccountName   = ko.observable('');
    self.bankAccountNumber = ko.observable('');
    self.bankSwift         = ko.observable('');
    self.bankCurrencyCode  = ko.observable('AED');

    // Phase 1 — duplicate detection state
    self.dupStatus   = ko.observable('NONE');
    self.dupExact    = ko.observableArray([]);
    self.dupFuzzy    = ko.observableArray([]);
    self.isAdmin     = ko.observable(false);
    self.hasDupWarning = ko.computed(function () {
      return self.dupExact().length > 0 || self.dupFuzzy().length > 0;
    });

    // Phase 1 — AI extraction review modal
    self.aiOpen      = ko.observable(false);
    self.aiBusy      = ko.observable(false);
    self.aiDocType   = ko.observable('');
    self.aiConfidence = ko.observable(null);
    self.aiWarnings  = ko.observableArray([]);
    self.aiFields    = ko.observableArray([]);   // [{key,label,value,target}]
    self._aiRaw      = null;
    self.aiEnabled   = ko.observable(false);      // AI_FEATURES_ENABLED (module setting)

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
      // Show ALL configured documents up front (so the applicant sees the full
      // set immediately). Whether a nationality-specific document is REQUIRED to
      // submit mirrors the server rule in submit_registration: Emirates ID is
      // required for UAE nationals (or anyone who entered an EID); the Residence
      // Visa is required for expats (non-UAE). Others follow their config flag.
      return self.docRequirements().map(function (req) {
        var mandatory = req.isMandatory === 'Y';
        if (req.docTypeCode === 'EMIRATES_ID')    mandatory = mandatory && (nat === 'AE' || hasEid);
        if (req.docTypeCode === 'RESIDENCE_VISA')  mandatory = mandatory && (!!nat && nat !== 'AE');
        var up = null;
        for (var i = 0; i < uploaded.length; i++) {
          if (uploaded[i].docTypeId === req.docTypeId && uploaded[i].hasFile === 'Y') { up = uploaded[i]; break; }
        }
        return {
          docTypeId:   req.docTypeId,
          docTypeCode: req.docTypeCode,
          name:        ar ? (req.docTypeNameAr || req.docTypeName) : req.docTypeName,
          mandatory:   mandatory,
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

    // Requestor defaults to the signed-in staff member (STAFF channel).
    self.isAdmin(authService.isFlAdmin && authService.isFlAdmin());
    if (self.isNew) {
      self.requestorName(me.displayName || '');
      self.requestorEmail(me.email || '');
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
        self.requestorEmail(r.requestorEmail || me.email || '');
        self.requestorName(r.requestorName || me.displayName || '');
        self.lineManagerEmail(r.lineManagerEmail || '');
        self.lineManagerName(r.lineManagerName || '');
        self.bankName(r.bankName || '');
        self.bankIban(r.bankIban || '');
        self.bankAccountName(r.bankAccountName || '');
        self.bankAccountNumber(r.bankAccountNumber || '');
        self.bankSwift(r.bankSwift || '');
        self.bankCurrencyCode(r.bankCurrencyCode || 'AED');
        self.dupStatus(r.dupStatus || 'NONE');
        self.photoSrc('https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/fl/registrations/' + self.regId() + '/photo?t=' + Date.now());
        self.loading(false);
        initGuard();
        self.loadRegDocs();
        self.loadDuplicates();
        self.loadApprovalHistory();
      }).catch(function () { self.loading(false); initGuard(); });
    }

    // ---- Approval history + Force Approval --------------------------------
    self.loadApprovalHistory = function () {
      if (!self.regId()) { self.approvalSteps([]); self.approvalMeta(null); return; }
      self.approvalLoading(true);
      flService.getApprovalHistory(self.regId()).then(function (r) {
        if (r && r.hasInstance) { self.approvalMeta(r); self.approvalSteps(r.steps || []); }
        else { self.approvalMeta(null); self.approvalSteps([]); }
      }).catch(function () {
        self.approvalMeta(null); self.approvalSteps([]);
      }).then(function () { self.approvalLoading(false); });
    };

    // Show the region once the request has entered the workflow.
    self.showApproval = ko.computed(function () {
      return !!self.approvalMeta()
             || ['SUBMITTED', 'APPROVED', 'REJECTED', 'RETURNED'].indexOf(self.status()) >= 0;
    });

    // FL Admin may force-approve only while the request is still SUBMITTED.
    self.canForceApprove = ko.computed(function () {
      return self.isAdmin() && self.status() === 'SUBMITTED';
    });

    self.stepClass = function (st) {
      return { APPROVED: 'badge badge--success', DONE: 'badge badge--success',
               PENDING: 'badge badge--warn', WAITING: 'badge',
               REJECTED: 'badge badge--danger', RETURNED: 'badge badge--danger'
             }[st] || 'badge';
    };

    self.forceApprove = function () {
      if (!self.regId() || self.forcing()) return;
      var note = window.prompt(
        'Force-approve this registration?\n\nThis overrides the remaining approval steps and '
        + 'creates the freelancer. It is recorded in the approval history as a forced approval.\n\n'
        + 'Optional note:', '');
      if (note === null) return;   // cancelled
      self.forcing(true);
      self.errorMsg('');
      flService.forceApproveRegistration(self.regId(), note).then(function (r) {
        self.forcing(false);
        self.status((r && r.overallStatus) || 'APPROVED');
        flash('Force-approved.');
        load();                    // refresh the record (status, audit)
      }).catch(function (err) {
        self.forcing(false);
        self.errorMsg((err && err.message) || 'Force approval failed');
      });
    };

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

    // Is AI document extraction switched on for this module? Gates the AI-fill UI.
    flService.getSettings().then(function (items) {
      var ai = (items || []).filter(function (i) { return i.key === 'AI_FEATURES_ENABLED'; })[0];
      self.aiEnabled(!!ai && /^(Y|TRUE|1|ON)$/i.test(String(ai.value || '')));
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
        notes:       self.notes().trim(),
        requestorEmail:   self.requestorEmail().trim(),
        requestorName:    self.requestorName().trim(),
        lineManagerEmail: self.lineManagerEmail().trim(),
        lineManagerName:  self.lineManagerName().trim(),
        bankName:          self.bankName().trim(),
        bankIban:          self.bankIban().trim(),
        bankAccountName:   self.bankAccountName().trim(),
        bankAccountNumber: self.bankAccountNumber().trim(),
        bankSwift:         self.bankSwift().trim(),
        bankCurrencyCode:  (self.bankCurrencyCode() || 'AED').trim()
      };
    }

    // Resolve the line-manager email to a DCT user (on blur) — they become the
    // first approver, so they must be a registered active DCT user.
    self.resolveLineManager = function () {
      var em = self.lineManagerEmail().trim();
      self.lineManagerHint('');
      if (!em) return true;
      flService.lookupUser(em).then(function (r) {
        if (r && r.found) {
          self.lineManagerName(r.name || self.lineManagerName());
          self.lineManagerHint('✓ ' + (r.name || em));
        } else {
          self.lineManagerHint('⚠ Not a registered DCT user — they cannot approve.');
        }
      }).catch(function () {});
      return true;
    };

    // ---- Duplicate detection ---------------------------------------------
    self.loadDuplicates = function () {
      if (!self.regId()) return;
      flService.getRegistrationDuplicates(self.regId()).then(function (r) {
        self.dupExact((r && r.exact) || []);
        self.dupFuzzy((r && r.fuzzy) || []);
      }).catch(function () {});
    };

    self.overrideDuplicate = function () {
      if (!self.regId()) return;
      flService.overrideRegistrationDuplicate(self.regId()).then(function () {
        self.dupStatus('OVERRIDDEN');
        flash('Duplicate override recorded.');
      }).catch(function (err) {
        self.errorMsg((err && err.message) || 'Override failed');
      });
    };

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
      // Line manager (first approver) is required to submit.
      if (!draft && !self.lineManagerEmail().trim()) {
        self.errorMsg('A line manager email is required before submission.');
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
        self.loadApprovalHistory();
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
      if (!file) return;
      if (self.regId()) { processPhoto(file); return; }
      // No draft yet — auto-save a blank draft first, then upload the photo.
      var s = self.saveDraft();
      if (!s) { self.errorMsg('Please correct the highlighted fields, then add the photo again.'); return; }
      s.then(function () { processPhoto(file); }).catch(function () {});
    };

    function processPhoto(file) {
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
      // Open the native picker FIRST (it must run inside the click gesture), then —
      // if no draft exists yet — auto-save a blank draft (draft validation is
      // format-only) so documents can be attached (and AI-extracted) before the
      // details are typed. Mirrors the public Portal's documents-first flow.
      docUpload.choose({ accept: 'image/*,application/pdf', maxMb: 10 }).then(function (file) {
        if (!file) return;
        if (self.regId()) { uploadDocBlob(item, file); return; }
        var s = self.saveDraft();
        if (!s) { self.docError('Please correct the highlighted fields, then attach the document again.'); return; }
        s.then(function () { uploadDocBlob(item, file); }).catch(function () {});
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

    // Authed fetch through the configured API base (never the raw ADB host —
    // that bypasses the web-tier proxy and carries no Bearer token).
    self.hasFile     = docFile.hasFile;
    self.viewDoc     = function (item) { docFile.view(item); };
    self.downloadDoc = function (item) { docFile.download(item); };

    // ---- AI extraction (Passport / Emirates ID / Bank Letter) ------------
    // A passport reports nationality as an ISO-3 code (EGY, ARE) or a name
    // (Egyptian, Egypt); the dropdown uses ISO-2 codes (EG, AE) with adjective
    // names (Egyptian). Map ISO-3 -> ISO-2 for the common nationalities, then
    // fall back to exact-code / exact-name / prefix matching against the list.
    var ISO3_TO_ISO2 = {
      ARE:'AE', EGY:'EG', SAU:'SA', KWT:'KW', QAT:'QA', BHR:'BH', OMN:'OM',
      IND:'IN', PAK:'PK', BGD:'BD', LKA:'LK', NPL:'NP', PHL:'PH', IDN:'ID',
      LBN:'LB', SYR:'SY', JOR:'JO', PSE:'PS', IRQ:'IQ', YEM:'YE', SDN:'SD',
      MAR:'MA', DZA:'DZ', TUN:'TN', LBY:'LY', SOM:'SO', ETH:'ET', KEN:'KE',
      NGA:'NG', GHA:'GH', ZAF:'ZA', TUR:'TR', IRN:'IR', AFG:'AF',
      GBR:'GB', USA:'US', CAN:'CA', AUS:'AU', FRA:'FR', DEU:'DE', ITA:'IT',
      ESP:'ES', NLD:'NL', RUS:'RU', UKR:'UA', CHN:'CN', JPN:'JP', KOR:'KR',
      THA:'TH', MYS:'MY', SGP:'SG', VNM:'VN', BRA:'BR', ARG:'AR'
    };
    function resolveNat(val) {
      if (!val) return '';
      var raw = String(val).trim();
      var v = raw.toLowerCase();
      var rows = self.nationalities();
      var i, n, alias = ISO3_TO_ISO2[raw.toUpperCase()];
      if (alias) {
        for (i = 0; i < rows.length; i++) { if (String(rows[i].code).toUpperCase() === alias) return rows[i].code; }
      }
      for (i = 0; i < rows.length; i++) { if (String(rows[i].code).toLowerCase() === v) return rows[i].code; }
      for (i = 0; i < rows.length; i++) { if (String(rows[i].name).toLowerCase() === v) return rows[i].code; }
      for (i = 0; i < rows.length; i++) {
        n = String(rows[i].name).toLowerCase();
        if (n && (n.indexOf(v) === 0 || v.indexOf(n) === 0)) return rows[i].code;
      }
      return '';
    }
    function natName(code) {
      var rows = self.nationalities();
      for (var i = 0; i < rows.length; i++) { if (rows[i].code === code) return rows[i].name; }
      return '';
    }

    // Maps the model's JSON keys to form observables, per document type.
    var AI_MAP = {
      PASSPORT: [
        { key: 'passport_number', label: 'Passport No.', set: self.passportNumber },
        { key: 'date_of_birth',   label: 'Date of Birth', set: self.dateOfBirth },
        { key: 'surname',         label: 'Surname',      set: self.lastNameEn },
        { key: 'given_names',     label: 'Given Names',  set: self.firstNameEn },
        { key: 'nationality',     label: 'Nationality',  set: self.nationalityCode, resolve: true }
      ],
      EMIRATES_ID: [
        { key: 'emirates_id',  label: 'Emirates ID',  set: self.nationalId },
        { key: 'name_en',      label: 'Name (EN)',    set: null },
        { key: 'name_ar',      label: 'Name (AR)',    set: null },
        { key: 'date_of_birth', label: 'Date of Birth', set: self.dateOfBirth },
        { key: 'card_expiry',  label: 'Card Expiry',  set: null }
      ],
      BANK_LETTER: [
        { key: 'account_holder_name', label: 'Account Holder', set: self.bankAccountName },
        { key: 'bank_name',     label: 'Bank',     set: self.bankName },
        { key: 'iban',          label: 'IBAN',     set: self.bankIban },
        { key: 'account_number', label: 'Account No.', set: self.bankAccountNumber },
        { key: 'swift',         label: 'SWIFT',    set: self.bankSwift },
        { key: 'currency',      label: 'Currency', set: self.bankCurrencyCode }
      ]
    };

    self.runExtract = function (item) {
      if (!item.docId) { self.docError('Upload the document first, then extract.'); return; }
      self.docError('');
      self.aiBusy(true); self.aiOpen(true);
      self.aiDocType(item.docTypeCode); self.aiWarnings([]); self.aiFields([]); self.aiConfidence(null);
      flService.extractRegistrationDocument(self.regId(), item.docId).then(function (res) {
        self.aiBusy(false);
        self._aiRaw = (res && res.fields) || {};
        self.aiConfidence(res && res.confidence != null ? Math.round(res.confidence * 100) : null);
        self.aiWarnings((res && res.warnings) || []);
        var map = AI_MAP[item.docTypeCode] || [];
        var rows = [];
        map.forEach(function (m) {
          var v = self._aiRaw[m.key];
          if (v !== undefined && v !== null && String(v) !== '') {
            var display = String(v);
            // Nationality: show the resolved dropdown name (e.g. "EGY" -> "Egyptian")
            // so the user sees exactly what will be applied; keep raw if unmatched.
            if (m.resolve) { var c = resolveNat(v); if (c) display = natName(c) || display; }
            rows.push({ key: m.key, label: m.label, value: display, set: m.set,
                        resolve: !!m.resolve, apply: ko.observable(!!m.set) });
          }
        });
        self.aiFields(rows);
      }).catch(function (err) {
        self.aiBusy(false); self.aiOpen(false);
        self.docError((err && err.message) || 'AI extraction failed.');
      });
    };

    self.applyExtract = function () {
      self.aiFields().forEach(function (f) {
        if (f.set && f.apply()) {
          var v = f.value;
          if (f.key === 'date_of_birth' || f.key === 'card_expiry') {
            // normalise to YYYY-MM-DD if the model returned a parseable date
            var d = new Date(v); if (!isNaN(d.getTime())) v = d.toISOString().slice(0, 10);
          }
          if (f.resolve) {
            // Nationality → map the value to a dropdown code; only set on a match.
            var code = resolveNat(v);
            if (code) f.set(code);
          } else {
            f.set(v);
          }
        }
      });
      self.aiOpen(false);
      flash('Applied AI-extracted values — please review.');
    };

    self.closeAi = function () { self.aiOpen(false); };

    self.back = function () { if (window._jetApp) window._jetApp.navigate('registrations'); };
  }

  return RegistrationEditViewModel;
});
