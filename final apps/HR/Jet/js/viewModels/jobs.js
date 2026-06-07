define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function JobsViewModel() {
    var self = this;

    self.isAdmin  = authService.isHrAdmin();
    self.isMgr    = authService.isHrManager();
    self.jobs     = ko.observableArray([]);
    self.families = ko.observableArray([]);
    self.loading  = ko.observable(true);
    self.error    = ko.observable('');
    self.saved    = ko.observable('');
    self.filterFam = ko.observable('');
    self.searchQ   = ko.observable('');
    self.selected  = ko.observable(null);

    // Modal
    self.showModal = ko.observable(false);
    self.editingId = ko.observable(null);
    self.saving    = ko.observable(false);
    self.formError = ko.observable('');
    self.form = {
      job_code:             ko.observable(''),
      job_name_en:          ko.observable(''),
      job_name_ar:          ko.observable(''),
      job_family_id:        ko.observable(''),
      min_grade_code:       ko.observable(''),
      max_grade_code:       ko.observable(''),
      min_experience_years: ko.observable(''),
      description_en:       ko.observable(''),
      is_active:            ko.observable('Y'),
    };

    self.filtered = ko.computed(function () {
      var q   = (self.searchQ() || '').toUpperCase();
      var fam = self.filterFam();
      return self.jobs().filter(function (j) {
        var matchQ   = !q   || (j.jobNameEn || '').toUpperCase().includes(q) || (j.jobCode || '').toUpperCase().includes(q);
        var matchFam = !fam || String(j.jobFamilyId) === String(fam);
        return matchQ && matchFam;
      });
    });

    self.select = function (job) { self.selected(job); };

    function _clearForm() {
      Object.keys(self.form).forEach(function (k) { self.form[k](k === 'is_active' ? 'Y' : ''); });
      self.formError('');
      self.editingId(null);
    }

    self.openAdd = function () {
      _clearForm();
      self.showModal(true);
    };

    self.openEdit = function (job) {
      _clearForm();
      self.editingId(job.jobId);
      self.form.job_code(job.jobCode || '');
      self.form.job_name_en(job.jobNameEn || '');
      self.form.job_name_ar(job.jobNameAr || '');
      self.form.job_family_id(String(job.jobFamilyId || ''));
      self.form.min_grade_code(job.minGradeCode || '');
      self.form.max_grade_code(job.maxGradeCode || '');
      self.form.min_experience_years(job.minExperienceYears || '');
      self.form.description_en(job.descriptionEn || '');
      self.form.is_active(job.isActive || 'Y');
      self.showModal(true);
    };

    self.closeModal = function () { if (!self.saving()) self.showModal(false); };

    self.saveJob = function () {
      var name = self.form.job_name_en().trim();
      var code = self.form.job_code().trim();
      if (!name) { self.formError('Job Name (EN) is required.'); return; }
      if (!self.editingId() && !code) { self.formError('Job Code is required.'); return; }

      var data = {
        job_code:             code,
        job_name_en:          name,
        job_name_ar:          self.form.job_name_ar(),
        job_family_id:        self.form.job_family_id() || null,
        min_grade_code:       self.form.min_grade_code() || null,
        max_grade_code:       self.form.max_grade_code() || null,
        min_experience_years: self.form.min_experience_years() || null,
        description_en:       self.form.description_en() || null,
        is_active:            self.form.is_active(),
      };

      self.saving(true);
      var op = self.editingId()
        ? hrService.updateJob(self.editingId(), data)
        : hrService.createJob(data);

      op.then(function () {
        self.saving(false);
        self.showModal(false);
        self.saved(self.editingId() ? 'Job updated.' : 'Job added.');
        setTimeout(function () { self.saved(''); }, 4000);
        _load();
      }).catch(function (err) {
        self.saving(false);
        self.formError((err && err.message) || 'Save failed.');
      });
    };

    function _load() {
      self.loading(true);
      Promise.all([hrService.getJobs(), hrService.getJobFamilies()])
        .then(function (results) {
          self.jobs(results[0]);
          self.families(results[1]);
          if (results[0].length && !self.selected()) self.selected(results[0][0]);
          self.loading(false);
        }).catch(function (err) {
          self.error((err && err.message) || 'Failed to load jobs.');
          self.loading(false);
        });
    }

    _load();
  }

  return JobsViewModel;
});
