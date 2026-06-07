define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function EmployeeDetailViewModel() {
    var self = this;

    self.isAdmin = authService.isHrAdmin();
    self.isMgr   = authService.isHrManager();

    // Edit modal state
    self.showEditModal = ko.observable(false);
    self.editSaving    = ko.observable(false);
    self.editError     = ko.observable('');
    self.editForm = {
      first_name_en: ko.observable(''),
      last_name_en:  ko.observable(''),
      gender:        ko.observable(''),
      email:         ko.observable(''),
      mobile:        ko.observable(''),
      grade_code:    ko.observable(''),
      job_title_en:  ko.observable(''),
      is_active:     ko.observable('Y'),
    };

    // Photo upload state
    self.photoUploading = ko.observable(false);
    self.photoError     = ko.observable('');

    // Creates a temporary <input type="file"> on document.body, triggers it, then removes it.
    // This bypasses every CSS/KO/JET interference issue.
    function _pickFile(accept, onFile) {
      var inp = document.createElement('input');
      inp.type = 'file';
      inp.accept = accept;
      inp.style.cssText = 'position:fixed;top:-9999px;left:-9999px;width:0;height:0;opacity:0';
      document.body.appendChild(inp);
      inp.addEventListener('change', function () {
        var f = inp.files && inp.files[0];
        document.body.removeChild(inp);
        if (f) onFile(f);
      });
      // Remove if user cancels (focus returns to window without change firing)
      window.addEventListener('focus', function _cleanup() {
        window.removeEventListener('focus', _cleanup);
        setTimeout(function () {
          if (document.body.contains(inp)) document.body.removeChild(inp);
        }, 500);
      });
      inp.click();
    }

    self.pickPhoto = function () {
      _pickFile('image/*', function (file) {
        if (!file.type.startsWith('image/')) { self.photoError('Please select an image file.'); return; }
        if (file.size > 5 * 1024 * 1024) { self.photoError('Image must be under 5 MB.'); return; }
        self.photoError('');
        self.photoUploading(true);
        hrService.uploadEmployeePhoto(personId, file).then(function (res) {
          self.photoUploading(false);
          var e = self.employee();
          if (e && res.photoUrl) self.employee(Object.assign({}, e, { photoUrl: res.photoUrl }));
        }).catch(function (err) {
          self.photoUploading(false);
          self.photoError((err && err.message) || 'Photo upload failed.');
        });
      });
    };

    self.openEdit = function () {
      var e = self.employee();
      if (!e) return;
      var parts = (e.fullNameEn || '').split(' ');
      self.editForm.first_name_en(parts[0] || '');
      self.editForm.last_name_en(parts.slice(1).join(' ') || '');
      self.editForm.gender(e.gender || '');
      self.editForm.email(e.email || '');
      self.editForm.mobile(e.mobile || '');
      self.editForm.grade_code(e.gradeCode || '');
      self.editForm.job_title_en(e.jobTitleEn || '');
      self.editForm.is_active(e.isActive || 'Y');
      self.editError('');
      if (!self.grades().length) {
        hrService.getGrades().then(function (list) { self.grades(list); });
      }
      self.showEditModal(true);
    };

    self.closeEdit = function () {
      if (!self.editSaving()) self.showEditModal(false);
    };

    self.saveEdit = function () {
      var fn = self.editForm.first_name_en().trim();
      var ln = self.editForm.last_name_en().trim();
      var em = self.editForm.email().trim();
      if (!fn || !ln) { self.editError('First and Last Name are required.'); return; }
      if (!em) { self.editError('Work Email is required.'); return; }

      var data = {
        first_name_en: fn,
        last_name_en:  ln,
        gender:        self.editForm.gender(),
        email:         self.editForm.email(),
        mobile:        self.editForm.mobile(),
        grade_code:    self.editForm.grade_code(),
        job_title_en:  self.editForm.job_title_en(),
        is_active:     self.editForm.is_active(),
      };

      self.editSaving(true);
      hrService.updateEmployee(personId, data).then(function (updated) {
        self.editSaving(false);
        self.showEditModal(false);
        // Refresh employee data
        var e = self.employee();
        self.employee(Object.assign({}, e, {
          fullNameEn:  (fn + ' ' + ln).trim(),
          gender:      data.gender,
          email:       data.email,
          mobile:      data.mobile,
          gradeCode:   data.grade_code,
          jobTitleEn:  data.job_title_en,
          isActive:    data.is_active,
        }));
      }).catch(function (err) {
        self.editSaving(false);
        self.editError((err && err.message) || 'Save failed.');
      });
    };

    var state    = window._hrApp ? window._hrApp.getState() : {};
    var personId = state.personId;

    self.employee    = ko.observable(null);
    self.assignments = ko.observableArray([]);
    self.contracts   = ko.observableArray([]);
    self.salaries    = ko.observableArray([]);
    self.documents   = ko.observableArray([]);
    self.grades      = ko.observableArray([]);
    self.loading     = ko.observable(true);
    self.error       = ko.observable('');
    self.activeTab   = ko.observable(state.activeTab || 'overview');

    // Document CRUD
    self.docTypes     = ko.observableArray([]);
    self.showDocModal = ko.observable(false);
    self.editingDocId = ko.observable(null);
    self.docSaving    = ko.observable(false);
    self.docSaved     = ko.observable('');
    self.docFormError = ko.observable('');
    self.docSelectedFile = ko.observable(null);     // File object from <input type="file">
    self.docFileName     = ko.observable('');       // display name
    self.docForm = {
      doc_type_id:       ko.observable(''),
      doc_number:        ko.observable(''),
      issue_date:        ko.observable(''),
      expiry_date:       ko.observable(''),
      issuing_authority: ko.observable(''),
      notes:             ko.observable(''),
    };

    function _clearDocForm() {
      Object.keys(self.docForm).forEach(function (k) { self.docForm[k](''); });
      self.docFormError('');
      self.editingDocId(null);
      self.docSelectedFile(null);
      self.docFileName('');
      // clear any file input on the page
      var fi = document.getElementById('docFileInput');
      if (fi) fi.value = '';
    }

    self.openAddDoc = function () {
      _clearDocForm();
      if (!self.docTypes().length) {
        hrService.getDocTypes().then(function (list) { self.docTypes(list); });
      }
      self.showDocModal(true);
    };

    self.openEditDoc = function (doc) {
      _clearDocForm();
      self.editingDocId(doc.docId);
      self.docForm.doc_number(doc.docNumber || '');
      self.docForm.issue_date(doc.issueDate ? doc.issueDate.toString().substring(0, 10) : '');
      self.docForm.expiry_date(doc.expiryDate ? doc.expiryDate.toString().substring(0, 10) : '');
      self.docForm.issuing_authority(doc.issuingAuthority || '');
      self.docForm.notes(doc.notes || '');
      self.docFileName(doc.fileName || '');
      self.showDocModal(true);
    };

    self.pickDocFile = function () {
      _pickFile('.pdf,.xls,.xlsx,.doc,.docx,.zip,.png,.jpg,.jpeg', function (file) {
        self.docSelectedFile(file);
        self.docFileName(file.name);
      });
    };

    self.closeDocModal = function () { if (!self.docSaving()) self.showDocModal(false); };

    self.downloadDoc = function (doc) {
      var url = hrService.getDocFileUrl(doc.docId, doc.fileName);
      if (!url) { alert('No file attached to this document.'); return; }
      // Use fetch+blob so Chrome allows cross-origin download with the correct filename
      fetch(url)
        .then(function (r) { return r.blob(); })
        .then(function (blob) {
          var blobUrl = URL.createObjectURL(blob);
          var a = document.createElement('a');
          a.href = blobUrl;
          a.download = doc.fileName || 'document';
          document.body.appendChild(a);
          a.click();
          document.body.removeChild(a);
          setTimeout(function () { URL.revokeObjectURL(blobUrl); }, 2000);
        })
        .catch(function () {
          window.open(url, '_blank');
        });
    };

    self.saveDoc = function () {
      var typeId = self.docForm.doc_type_id();
      if (!self.editingDocId() && !typeId) { self.docFormError('Document Type is required.'); return; }

      self.docSaving(true);
      var data, op;
      var savedDocId = self.editingDocId();

      if (savedDocId) {
        data = {
          doc_number:        self.docForm.doc_number(),
          issue_date:        self.docForm.issue_date() || null,
          expiry_date:       self.docForm.expiry_date() || null,
          issuing_authority: self.docForm.issuing_authority(),
          notes:             self.docForm.notes(),
        };
        op = hrService.updateDocument(savedDocId, data);
      } else {
        data = {
          person_id:         personId,
          doc_type_id:       typeId,
          doc_number:        self.docForm.doc_number(),
          issue_date:        self.docForm.issue_date() || null,
          expiry_date:       self.docForm.expiry_date() || null,
          issuing_authority: self.docForm.issuing_authority(),
          notes:             self.docForm.notes(),
        };
        op = hrService.addDocument(data);
      }

      var file = self.docSelectedFile();
      op.then(function (result) {
        // result for POST returns { docId } (from :body_text in ORDS, or _doc in mock)
        // result for PUT returns {} — savedDocId holds the existing ID
        var targetId = savedDocId || (result && (result.docId || result.doc_id));

        function _finish(tid) {
          var afterFile = (file && tid) ? hrService.uploadDocFile(tid, file) : Promise.resolve();
          return afterFile.then(function () {
            self.docSaving(false);
            self.showDocModal(false);
            self.docSaved(savedDocId ? 'Document updated.' : 'Document added.');
            setTimeout(function () { self.docSaved(''); }, 4000);
            hrService.getDocuments(personId).then(function (list) { self.documents(list); });
          }).catch(function (err) {
            // file upload failed but metadata was saved — show warning, still close
            self.docSaving(false);
            self.showDocModal(false);
            self.docSaved('Document saved, but file upload failed: ' + ((err && err.message) || 'unknown error'));
            setTimeout(function () { self.docSaved(''); }, 6000);
            hrService.getDocuments(personId).then(function (list) { self.documents(list); });
          });
        }

        if (file && !targetId) {
          // ORDS didn't return docId — re-fetch docs and pick the newest for this person
          return hrService.getDocuments(personId).then(function (list) {
            self.documents(list);
            var newest = list.length ? list[list.length - 1] : null;
            return _finish(newest && newest.docId);
          });
        }
        return _finish(targetId);
      }).catch(function (err) {
        self.docSaving(false);
        self.docFormError((err && err.message) || 'Save failed.');
      });
    };

    self.setTab = function (tab) { self.activeTab(tab); };

    self.goBack = function () { if (window._hrApp) window._hrApp.navigate('employees'); };

    self.initials = ko.computed(function () {
      var e = self.employee();
      if (!e) return '?';
      var parts = (e.fullNameEn || '').split(' ');
      return parts.length >= 2
        ? (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
        : (parts[0] || '?')[0].toUpperCase();
    });

    self.avatarColor = ko.computed(function () {
      var e = self.employee();
      if (!e) return '#1a7f5a';
      var colors = ['#0572CE','#2E7D32','#C74634','#6A1B9A','#E65100','#1a7f5a'];
      return colors[(e.personId || 0) % colors.length];
    });

    self.alertClass = function (alert) {
      var map = { EXPIRED: 'badge--rejected', CRITICAL: 'badge--advance_paid', WARNING: 'badge--warning', UPCOMING: 'badge--info' };
      return 'badge ' + (map[alert] || 'badge--idle');
    };

    self.fmtSalary = function (n) {
      if (!n) return '—';
      return parseFloat(n).toLocaleString('en-AE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    };

    function _load() {
      if (!personId) {
        self.error('No employee selected.');
        self.loading(false);
        return;
      }
      Promise.all([
        hrService.getEmployee(personId),
        hrService.getAssignments(personId),
        hrService.getContracts(personId),
        hrService.getSalaryHistory(personId),
        hrService.getDocuments(personId),
      ]).then(function (results) {
        self.employee(results[0]);
        self.assignments(results[1]);
        self.contracts(results[2]);
        self.salaries(results[3]);
        self.documents(results[4]);
        self.loading(false);
      }).catch(function (err) {
        self.error((err && err.message) || 'Failed to load employee details.');
        self.loading(false);
      });
    }

    _load();

    // Expose pickers on window so onclick="" in the view can reach them
    // (KO data-bind click may be unreliable for triggering file dialogs in JET)
    window._hrPickDocFile   = function () { self.pickDocFile(); };
    window._hrPickPhoto     = function () { self.pickPhoto(); };

    self.dispose = function () {
      delete window._hrPickDocFile;
      delete window._hrPickPhoto;
    };
  }

  return EmployeeDetailViewModel;
});
