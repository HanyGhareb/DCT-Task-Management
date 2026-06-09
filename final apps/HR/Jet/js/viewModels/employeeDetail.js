define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function EmployeeDetailViewModel() {
    var self = this;

    // ── Auth ───────────────────────────────────────────────────────────────
    self.isAdmin = authService.isHrAdmin();
    self.isMgr   = authService.isHrManager();

    // ── State from router ──────────────────────────────────────────────────
    var state    = window._hrApp ? window._hrApp.getState() : {};
    var personId = state.personId;

    // ── Core observables ───────────────────────────────────────────────────
    self.employee    = ko.observable(null);
    self.assignments = ko.observableArray([]);
    self.contracts   = ko.observableArray([]);
    self.salaries    = ko.observableArray([]);
    self.documents   = ko.observableArray([]);
    self.grades      = ko.observableArray([]);
    self.loading     = ko.observable(true);
    self.error       = ko.observable('');
    self.activeTab   = ko.observable(state.activeTab || 'overview');

    // ── Shared lookup observables (loaded lazily on first modal open) ───────
    self.orgs            = ko.observableArray([]);
    self.positions       = ko.observableArray([]);
    self.jobs            = ko.observableArray([]);
    self.locations       = ko.observableArray([]);
    self.assignmentTypes = ko.observableArray([]);
    self.endReasons      = ko.observableArray([]);
    self.contractTypes   = ko.observableArray([]);
    self.salaryReasons   = ko.observableArray([]);

    // ── Photo ──────────────────────────────────────────────────────────────
    self.photoUploading = ko.observable(false);
    self.photoError     = ko.observable('');

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
        if (file.size > 5 * 1024 * 1024)    { self.photoError('Image must be under 5 MB.'); return; }
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

    // ── Edit Employee modal ────────────────────────────────────────────────
    self.showEditModal = ko.observable(false);
    self.editSaving    = ko.observable(false);
    self.editError     = ko.observable('');
    self.editAuditExpanded = ko.observable(false);
    self.editForm = {
      first_name_en: ko.observable(''),
      last_name_en:  ko.observable(''),
      gender:        ko.observable(''),
      email:         ko.observable(''),
      mobile:        ko.observable(''),
      grade_code:    ko.observable(''),
      position_id:   ko.observable(''),
      job_title_en:  ko.observable(''),
      is_active:     ko.observable('Y'),
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
      self.editForm.position_id(String(e.positionId || ''));
      self.editForm.job_title_en(e.jobTitleEn || '');
      self.editForm.is_active(e.isActive || 'Y');
      self.editError('');
      self.editAuditExpanded(false);
      if (!self.grades().length)    hrService.getGrades().then(function (l)    { self.grades(l); });
      if (!self.positions().length) hrService.getPositions().then(function (l) { self.positions(l); });
      self.showEditModal(true);
    };

    self.closeEdit      = function () { if (!self.editSaving()) self.showEditModal(false); };
    self.toggleEditAudit = function () { self.editAuditExpanded(!self.editAuditExpanded()); };

    self.fmtDateTime = function (dt) {
      if (!dt) return '—';
      var d = new Date(dt);
      if (isNaN(d.getTime())) return dt;
      var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return d.getDate() + ' ' + months[d.getMonth()] + ' ' + d.getFullYear()
           + ' · ' + String(d.getHours()).padStart(2, '0') + ':' + String(d.getMinutes()).padStart(2, '0');
    };;

    self.saveEdit = function () {
      var fn = self.editForm.first_name_en().trim();
      var ln = self.editForm.last_name_en().trim();
      var em = self.editForm.email().trim();
      if (!fn || !ln) { self.editError('First and Last Name are required.'); return; }
      if (!em)        { self.editError('Work Email is required.'); return; }

      var data = {
        first_name_en: fn,
        last_name_en:  ln,
        gender:        self.editForm.gender(),
        email:         em,
        mobile:        self.editForm.mobile(),
        grade_code:    self.editForm.grade_code() || null,
        position_id:   self.editForm.position_id() || null,
        job_title_en:  self.editForm.job_title_en(),
        is_active:     self.editForm.is_active(),
      };
      self.editSaving(true);
      hrService.updateEmployee(personId, data).then(function () {
        self.editSaving(false);
        self.showEditModal(false);
        var e = self.employee();
        var updPos = data.position_id
          ? self.positions().find(function (p) { return String(p.positionId) === String(data.position_id); })
          : null;
        self.employee(Object.assign({}, e, {
          fullNameEn:     (fn + ' ' + ln).trim(),
          gender:         data.gender,
          email:          data.email,
          mobile:         data.mobile,
          gradeCode:      data.grade_code,
          positionId:     data.position_id || e.positionId,
          positionNameEn: updPos ? updPos.positionNameEn : e.positionNameEn,
          jobTitleEn:     data.job_title_en,
          isActive:       data.is_active,
        }));
      }).catch(function (err) {
        self.editSaving(false);
        self.editError((err && err.message) || 'Save failed.');
      });
    };

    // ── Assignment — Create modal ───────────────────────────────────────────
    self.showAssignmentModal = ko.observable(false);
    self.assignmentSaving    = ko.observable(false);
    self.assignmentError     = ko.observable('');
    self.assignmentSaved     = ko.observable('');
    self.assignmentForm = {
      position_id:        ko.observable(''),
      org_id:             ko.observable(''),
      job_id:             ko.observable(''),
      grade_code:         ko.observable(''),
      location_id:        ko.observable(''),
      assignment_type_id: ko.observable(''),
      start_date:         ko.observable(''),
      probation_months:   ko.observable('3'),
      is_primary:         ko.observable('Y'),
      remarks:            ko.observable(''),
    };

    self.openAddAssignment = function () {
      Object.keys(self.assignmentForm).forEach(function (k) {
        if (k === 'is_primary')         self.assignmentForm[k]('Y');
        else if (k === 'probation_months') self.assignmentForm[k]('3');
        else if (k === 'start_date')    self.assignmentForm[k](new Date().toISOString().substring(0, 10));
        else                            self.assignmentForm[k]('');
      });
      self.assignmentError('');
      if (!self.orgs().length)            hrService.getOrgs().then(function (l)      { self.orgs(l); });
      if (!self.positions().length)       hrService.getPositions().then(function (l) { self.positions(l); });
      if (!self.jobs().length)            hrService.getJobs().then(function (l)      { self.jobs(l); });
      if (!self.grades().length)          hrService.getGrades().then(function (l)    { self.grades(l); });
      if (!self.locations().length)       hrService.getLocations().then(function (l) { self.locations(l); });
      if (!self.assignmentTypes().length) hrService.getLookupValues('HR_ASSIGNMENT_TYPE').then(function (l) { self.assignmentTypes(l); });
      self.showAssignmentModal(true);
    };

    self.closeAssignmentModal = function () { if (!self.assignmentSaving()) self.showAssignmentModal(false); };

    self.saveAssignment = function () {
      var orgId     = self.assignmentForm.org_id();
      var startDate = self.assignmentForm.start_date();
      if (!orgId)     { self.assignmentError('Section is required.'); return; }
      if (!startDate) { self.assignmentError('Start Date is required.'); return; }

      self.assignmentSaving(true);
      hrService.createAssignment({
        person_id:          personId,
        position_id:        self.assignmentForm.position_id()        || null,
        org_id:             orgId,
        job_id:             self.assignmentForm.job_id()             || null,
        grade_code:         self.assignmentForm.grade_code()         || null,
        location_id:        self.assignmentForm.location_id()        || null,
        assignment_type_id: self.assignmentForm.assignment_type_id() || null,
        start_date:         startDate,
        probation_months:   parseInt(self.assignmentForm.probation_months()) || null,
        is_primary:         self.assignmentForm.is_primary(),
        remarks:            self.assignmentForm.remarks(),
      }).then(function () {
        self.assignmentSaving(false);
        self.showAssignmentModal(false);
        self.assignmentSaved('Assignment created.');
        setTimeout(function () { self.assignmentSaved(''); }, 4000);
        hrService.getAssignments(personId).then(function (l) { self.assignments(l); });
        hrService.getEmployee(personId).then(function (e)    { self.employee(e); });
      }).catch(function (err) {
        self.assignmentSaving(false);
        self.assignmentError((err && err.message) || 'Save failed.');
      });
    };

    // ── Assignment — End modal ─────────────────────────────────────────────
    self.showEndModal       = ko.observable(false);
    self.endSaving          = ko.observable(false);
    self.endError           = ko.observable('');
    self.endingAssignmentId = ko.observable(null);
    self.endForm = {
      end_date:      ko.observable(''),
      end_reason_id: ko.observable(''),
      remarks:       ko.observable(''),
    };

    self.openEndAssignment = function (asgn) {
      self.endingAssignmentId(asgn.assignment_id || asgn.assignmentId);
      self.endForm.end_date(new Date().toISOString().substring(0, 10));
      self.endForm.end_reason_id('');
      self.endForm.remarks('');
      self.endError('');
      if (!self.endReasons().length) hrService.getLookupValues('HR_END_REASON').then(function (l) { self.endReasons(l); });
      self.showEndModal(true);
    };

    self.closeEndModal = function () { if (!self.endSaving()) self.showEndModal(false); };

    self.confirmEndAssignment = function () {
      var endDate = self.endForm.end_date();
      if (!endDate) { self.endError('End Date is required.'); return; }

      self.endSaving(true);
      hrService.endAssignment(self.endingAssignmentId(), {
        end_date:      endDate,
        end_reason_id: self.endForm.end_reason_id() || null,
        remarks:       self.endForm.remarks(),
      }).then(function () {
        self.endSaving(false);
        self.showEndModal(false);
        self.assignmentSaved('Assignment ended.');
        setTimeout(function () { self.assignmentSaved(''); }, 4000);
        hrService.getAssignments(personId).then(function (l) { self.assignments(l); });
        hrService.getEmployee(personId).then(function (e)    { self.employee(e); });
      }).catch(function (err) {
        self.endSaving(false);
        self.endError((err && err.message) || 'Failed to end assignment.');
      });
    };

    // ── Contract modal ─────────────────────────────────────────────────────
    self.showContractModal = ko.observable(false);
    self.contractSaving    = ko.observable(false);
    self.contractError     = ko.observable('');
    self.contractSaved     = ko.observable('');
    self.editingContractId = ko.observable(null);
    self.contractForm = {
      contract_number:    ko.observable(''),
      contract_type_id:   ko.observable(''),
      start_date:         ko.observable(''),
      end_date:           ko.observable(''),
      probation_months:   ko.observable('3'),
      notice_period_days: ko.observable('30'),
      signed_date:        ko.observable(''),
      remarks:            ko.observable(''),
    };

    function _clearContractForm() {
      self.contractForm.contract_number('');
      self.contractForm.contract_type_id('');
      self.contractForm.start_date('');
      self.contractForm.end_date('');
      self.contractForm.probation_months('3');
      self.contractForm.notice_period_days('30');
      self.contractForm.signed_date('');
      self.contractForm.remarks('');
      self.contractError('');
      self.editingContractId(null);
    }

    self.openAddContract = function () {
      _clearContractForm();
      if (!self.contractTypes().length) hrService.getLookupValues('HR_CONTRACT_TYPE').then(function (l) { self.contractTypes(l); });
      self.showContractModal(true);
    };

    self.openEditContract = function (c) {
      _clearContractForm();
      self.editingContractId(c.contract_id || c.contractId);
      self.contractForm.contract_number(c.contract_number    || c.contractNumber    || '');
      self.contractForm.contract_type_id(String(c.contract_type_id || c.contractTypeId || ''));
      self.contractForm.start_date((c.start_date || c.startDate || '').toString().substring(0, 10));
      self.contractForm.end_date((c.end_date     || c.endDate   || '').toString().substring(0, 10));
      self.contractForm.probation_months(String(c.probation_months    || c.probationMonths    || '3'));
      self.contractForm.notice_period_days(String(c.notice_period_days || c.noticePeriodDays  || '30'));
      self.contractForm.signed_date((c.signed_date || c.signedDate || '').toString().substring(0, 10));
      self.contractForm.remarks(c.remarks || '');
      if (!self.contractTypes().length) hrService.getLookupValues('HR_CONTRACT_TYPE').then(function (l) { self.contractTypes(l); });
      self.showContractModal(true);
    };

    self.closeContractModal = function () { if (!self.contractSaving()) self.showContractModal(false); };

    self.saveContract = function () {
      var typeId    = self.contractForm.contract_type_id();
      var startDate = self.contractForm.start_date();
      var cNum      = self.contractForm.contract_number().trim();
      if (!self.editingContractId() && !cNum) { self.contractError('Contract Number is required.'); return; }
      if (!typeId)    { self.contractError('Contract Type is required.'); return; }
      if (!startDate) { self.contractError('Start Date is required.'); return; }

      var data = {
        person_id:          personId,
        contract_number:    cNum,
        contract_type_id:   typeId,
        start_date:         startDate,
        end_date:           self.contractForm.end_date()           || null,
        probation_months:   parseInt(self.contractForm.probation_months())   || null,
        notice_period_days: parseInt(self.contractForm.notice_period_days()) || null,
        signed_date:        self.contractForm.signed_date()        || null,
        remarks:            self.contractForm.remarks(),
      };

      self.contractSaving(true);
      var op = self.editingContractId()
        ? hrService.updateContract(self.editingContractId(), data)
        : hrService.createContract(data);

      op.then(function () {
        self.contractSaving(false);
        self.showContractModal(false);
        self.contractSaved(self.editingContractId() ? 'Contract updated.' : 'Contract added.');
        setTimeout(function () { self.contractSaved(''); }, 4000);
        hrService.getContracts(personId).then(function (l) { self.contracts(l); });
      }).catch(function (err) {
        self.contractSaving(false);
        self.contractError((err && err.message) || 'Save failed.');
      });
    };

    // ── Salary Entry modal ─────────────────────────────────────────────────
    self.showSalaryModal = ko.observable(false);
    self.salarySaving    = ko.observable(false);
    self.salaryError     = ko.observable('');
    self.salarySaved     = ko.observable('');
    self.salaryForm = {
      effective_date:   ko.observable(''),
      basic_salary:     ko.observable(''),
      currency_code:    ko.observable('AED'),
      change_reason_id: ko.observable(''),
      remarks:          ko.observable(''),
    };

    self.openAddSalary = function () {
      self.salaryForm.effective_date(new Date().toISOString().substring(0, 10));
      self.salaryForm.basic_salary('');
      self.salaryForm.currency_code('AED');
      self.salaryForm.change_reason_id('');
      self.salaryForm.remarks('');
      self.salaryError('');
      if (!self.salaryReasons().length) hrService.getLookupValues('HR_SALARY_REASON').then(function (l) { self.salaryReasons(l); });
      self.showSalaryModal(true);
    };

    self.closeSalaryModal = function () { if (!self.salarySaving()) self.showSalaryModal(false); };

    self.saveSalary = function () {
      var effDate = self.salaryForm.effective_date();
      var amount  = parseFloat(self.salaryForm.basic_salary());
      if (!effDate)              { self.salaryError('Effective Date is required.'); return; }
      if (!amount || amount <= 0){ self.salaryError('Basic Salary must be a positive number.'); return; }

      self.salarySaving(true);
      hrService.addSalaryEntry({
        person_id:        personId,
        effective_date:   effDate,
        basic_salary:     amount,
        currency_code:    self.salaryForm.currency_code() || 'AED',
        change_reason_id: self.salaryForm.change_reason_id() || null,
        remarks:          self.salaryForm.remarks(),
      }).then(function () {
        self.salarySaving(false);
        self.showSalaryModal(false);
        self.salarySaved('Salary entry added.');
        setTimeout(function () { self.salarySaved(''); }, 4000);
        hrService.getSalaryHistory(personId).then(function (l) { self.salaries(l); });
        hrService.getEmployee(personId).then(function (e)      { self.employee(e); });
      }).catch(function (err) {
        self.salarySaving(false);
        self.salaryError((err && err.message) || 'Save failed.');
      });
    };

    // ── Document CRUD ──────────────────────────────────────────────────────
    self.docTypes        = ko.observableArray([]);
    self.showDocModal    = ko.observable(false);
    self.editingDocId    = ko.observable(null);
    self.docSaving       = ko.observable(false);
    self.docSaved        = ko.observable('');
    self.docFormError    = ko.observable('');
    self.docSelectedFile = ko.observable(null);
    self.docFileName     = ko.observable('');
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
      var fi = document.getElementById('docFileInput');
      if (fi) fi.value = '';
    }

    self.openAddDoc = function () {
      _clearDocForm();
      if (!self.docTypes().length) hrService.getDocTypes().then(function (l) { self.docTypes(l); });
      self.showDocModal(true);
    };

    self.openEditDoc = function (doc) {
      _clearDocForm();
      self.editingDocId(doc.docId);
      self.docForm.doc_number(doc.docNumber || '');
      self.docForm.issue_date(doc.issueDate  ? doc.issueDate.toString().substring(0, 10)  : '');
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
        .catch(function () { window.open(url, '_blank'); });
    };

    self.saveDoc = function () {
      var typeId = self.docForm.doc_type_id();
      if (!self.editingDocId() && !typeId) { self.docFormError('Document Type is required.'); return; }

      self.docSaving(true);
      var savedDocId = self.editingDocId();
      var data, op;

      if (savedDocId) {
        data = {
          doc_number:        self.docForm.doc_number(),
          issue_date:        self.docForm.issue_date()   || null,
          expiry_date:       self.docForm.expiry_date()  || null,
          issuing_authority: self.docForm.issuing_authority(),
          notes:             self.docForm.notes(),
        };
        op = hrService.updateDocument(savedDocId, data);
      } else {
        data = {
          person_id:         personId,
          doc_type_id:       typeId,
          doc_number:        self.docForm.doc_number(),
          issue_date:        self.docForm.issue_date()   || null,
          expiry_date:       self.docForm.expiry_date()  || null,
          issuing_authority: self.docForm.issuing_authority(),
          notes:             self.docForm.notes(),
        };
        op = hrService.addDocument(data);
      }

      var file = self.docSelectedFile();
      op.then(function (result) {
        var targetId = savedDocId || (result && (result.docId || result.doc_id));

        function _finish(tid) {
          var afterFile = (file && tid) ? hrService.uploadDocFile(tid, file) : Promise.resolve();
          return afterFile.then(function () {
            self.docSaving(false);
            self.showDocModal(false);
            self.docSaved(savedDocId ? 'Document updated.' : 'Document added.');
            setTimeout(function () { self.docSaved(''); }, 4000);
            hrService.getDocuments(personId).then(function (l) { self.documents(l); });
          }).catch(function (err) {
            self.docSaving(false);
            self.showDocModal(false);
            self.docSaved('Document saved, but file upload failed: ' + ((err && err.message) || 'unknown error'));
            setTimeout(function () { self.docSaved(''); }, 6000);
            hrService.getDocuments(personId).then(function (l) { self.documents(l); });
          });
        }

        if (file && !targetId) {
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

    // ── Helpers ────────────────────────────────────────────────────────────
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

    // ── ESC handler — closes whichever modal is topmost ────────────────────
    self._onKeyDown = function (e) {
      if (e.key !== 'Escape') return;
      if (self.showAssignmentModal()) { self.closeAssignmentModal(); return; }
      if (self.showEndModal())        { self.closeEndModal();        return; }
      if (self.showContractModal())   { self.closeContractModal();   return; }
      if (self.showSalaryModal())     { self.closeSalaryModal();     return; }
      if (self.showDocModal())        { self.closeDocModal();        return; }
      if (self.showEditModal())       { self.closeEdit();            return; }
    };
    document.addEventListener('keydown', self._onKeyDown);

    // ── Load ───────────────────────────────────────────────────────────────
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

    // Expose pickers on window — KO data-bind click can't trigger file dialogs
    window._hrPickDocFile = function () { self.pickDocFile(); };
    window._hrPickPhoto   = function () { self.pickPhoto(); };

    self.dispose = function () {
      document.removeEventListener('keydown', self._onKeyDown);
      delete window._hrPickDocFile;
      delete window._hrPickPhoto;
    };
  }

  return EmployeeDetailViewModel;
});
