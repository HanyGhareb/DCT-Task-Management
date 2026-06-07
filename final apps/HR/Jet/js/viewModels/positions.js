define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function PositionsViewModel() {
    var self = this;

    self.isAdmin    = authService.isHrAdmin();
    self.positions  = ko.observableArray([]);
    self.orgs       = ko.observableArray([]);
    self.jobs       = ko.observableArray([]);
    self.loading    = ko.observable(true);
    self.error      = ko.observable('');
    self.saved      = ko.observable('');
    self.filterOrg  = ko.observable('');
    self.searchQ    = ko.observable('');
    self.filterVacancy = ko.observable('');

    // Modal
    self.showModal = ko.observable(false);
    self.editingId = ko.observable(null);
    self.saving    = ko.observable(false);
    self.formError = ko.observable('');
    self.form = {
      position_code:      ko.observable(''),
      position_name_en:   ko.observable(''),
      position_name_ar:   ko.observable(''),
      job_id:             ko.observable(''),
      org_id:             ko.observable(''),
      grade_code:         ko.observable(''),
      approved_headcount: ko.observable('1'),
      is_active:          ko.observable('Y'),
    };

    self.filtered = ko.computed(function () {
      var q   = (self.searchQ() || '').toUpperCase();
      var org = self.filterOrg();
      var vac = self.filterVacancy();
      return self.positions().filter(function (p) {
        var matchQ   = !q   || (p.positionNameEn || '').toUpperCase().includes(q) || (p.positionCode || '').toUpperCase().includes(q);
        var matchOrg = !org || String(p.orgId) === String(org);
        var matchVac = !vac || (vac === 'vacant' ? p.vacancyCount > 0 : vac === 'full' ? p.vacancyCount <= 0 : true);
        return matchQ && matchOrg && matchVac;
      });
    });

    self.totalApproved = ko.computed(function () { return self.positions().reduce(function (a, p) { return a + (p.approvedHeadcount || 0); }, 0); });
    self.totalFilled   = ko.computed(function () { return self.positions().reduce(function (a, p) { return a + (p.filledCount       || 0); }, 0); });
    self.totalVacant   = ko.computed(function () { return self.positions().reduce(function (a, p) { return a + (p.vacancyCount      || 0); }, 0); });

    self.fillPct = function (pos) {
      if (!pos.approvedHeadcount) return 0;
      return Math.min(100, Math.round((pos.filledCount / pos.approvedHeadcount) * 100));
    };

    self.vacancyClass = function (pos) {
      return pos.vacancyCount > 0 ? 'badge badge--warning' : 'badge badge--approved';
    };

    function _clearForm() {
      Object.keys(self.form).forEach(function (k) {
        self.form[k](k === 'is_active' ? 'Y' : k === 'approved_headcount' ? '1' : '');
      });
      self.formError('');
      self.editingId(null);
    }

    self.openAdd = function () { _clearForm(); self.showModal(true); };

    self.openEdit = function (pos) {
      _clearForm();
      self.editingId(pos.positionId);
      self.form.position_code(pos.positionCode || '');
      self.form.position_name_en(pos.positionNameEn || '');
      self.form.position_name_ar(pos.positionNameAr || '');
      self.form.job_id(String(pos.jobId || ''));
      self.form.org_id(String(pos.orgId || ''));
      self.form.grade_code(pos.gradeCode || '');
      self.form.approved_headcount(String(pos.approvedHeadcount || '1'));
      self.form.is_active(pos.isActive || 'Y');
      self.showModal(true);
    };

    self.closeModal = function () { if (!self.saving()) self.showModal(false); };

    self.savePosition = function () {
      var name = self.form.position_name_en().trim();
      var code = self.form.position_code().trim();
      var jobId = self.form.job_id();
      var orgId = self.form.org_id();
      if (!name) { self.formError('Position Name (EN) is required.'); return; }
      if (!self.editingId() && !code) { self.formError('Position Code is required.'); return; }
      if (!jobId) { self.formError('Job is required.'); return; }
      if (!orgId) { self.formError('Section is required.'); return; }

      var data = {
        position_code:      code,
        position_name_en:   name,
        position_name_ar:   self.form.position_name_ar(),
        job_id:             jobId,
        org_id:             orgId,
        grade_code:         self.form.grade_code() || null,
        approved_headcount: parseInt(self.form.approved_headcount()) || 1,
        is_active:          self.form.is_active(),
      };

      self.saving(true);
      var op = self.editingId()
        ? hrService.updatePosition(self.editingId(), data)
        : hrService.createPosition(data);

      op.then(function () {
        self.saving(false);
        self.showModal(false);
        self.saved(self.editingId() ? 'Position updated.' : 'Position added.');
        setTimeout(function () { self.saved(''); }, 4000);
        _load();
      }).catch(function (err) {
        self.saving(false);
        self.formError((err && err.message) || 'Save failed.');
      });
    };

    function _load() {
      self.loading(true);
      Promise.all([hrService.getPositions(), hrService.getOrgs(), hrService.getJobs()])
        .then(function (results) {
          self.positions(results[0]);
          self.orgs(results[1]);
          self.jobs(results[2]);
          self.loading(false);
        }).catch(function (err) {
          self.error((err && err.message) || 'Failed to load positions.');
          self.loading(false);
        });
    }

    _load();
  }

  return PositionsViewModel;
});
