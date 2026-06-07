define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function GradesViewModel() {
    var self = this;

    self.isAdmin = authService.isHrAdmin();
    self.isMgr   = authService.isHrManager();
    self.grades  = ko.observableArray([]);
    self.loading = ko.observable(true);
    self.error   = ko.observable('');
    self.saved   = ko.observable('');
    self.searchQ = ko.observable('');

    self.showModal = ko.observable(false);
    self.editingCode = ko.observable(null);
    self.saving    = ko.observable(false);
    self.formError = ko.observable('');
    self.form = {
      grade_code:      ko.observable(''),
      grade_name_en:   ko.observable(''),
      grade_name_ar:   ko.observable(''),
      grade_level:     ko.observable(''),
      grade_category:  ko.observable('GENERAL'),
      salary_band_min: ko.observable(''),
      salary_band_max: ko.observable(''),
      is_active:       ko.observable('Y'),
    };

    self.filtered = ko.computed(function () {
      var q = (self.searchQ() || '').toUpperCase();
      return self.grades().filter(function (g) {
        return !q || (g.gradeCode || '').toUpperCase().includes(q)
                  || (g.gradeNameEn || '').toUpperCase().includes(q);
      });
    });

    function _clearForm() {
      self.form.grade_code('');
      self.form.grade_name_en('');
      self.form.grade_name_ar('');
      self.form.grade_level('');
      self.form.grade_category('GENERAL');
      self.form.salary_band_min('');
      self.form.salary_band_max('');
      self.form.is_active('Y');
      self.formError('');
      self.editingCode(null);
    }

    self.openAdd = function () { _clearForm(); self.showModal(true); };

    self.openEdit = function (g) {
      _clearForm();
      self.editingCode(g.gradeCode);
      self.form.grade_code(g.gradeCode || '');
      self.form.grade_name_en(g.gradeNameEn || '');
      self.form.grade_name_ar(g.gradeNameAr || '');
      self.form.grade_level(String(g.gradeLevel || ''));
      self.form.grade_category(g.gradeCategory || 'GENERAL');
      self.form.salary_band_min(g.salaryBandMin != null ? String(g.salaryBandMin) : '');
      self.form.salary_band_max(g.salaryBandMax != null ? String(g.salaryBandMax) : '');
      self.form.is_active(g.isActive || 'Y');
      self.showModal(true);
    };

    self.closeModal = function () { if (!self.saving()) self.showModal(false); };

    self.saveGrade = function () {
      var code  = self.form.grade_code().trim();
      var name  = self.form.grade_name_en().trim();
      var level = self.form.grade_level();
      if (!name) { self.formError('Grade Name (EN) is required.'); return; }
      if (!self.editingCode() && !code) { self.formError('Grade Code is required.'); return; }
      if (!level) { self.formError('Grade Level is required.'); return; }

      var data = {
        grade_code:      code,
        grade_name_en:   name,
        grade_name_ar:   self.form.grade_name_ar(),
        grade_level:     parseInt(level),
        grade_category:  self.form.grade_category() || 'GENERAL',
        salary_band_min: self.form.salary_band_min() || null,
        salary_band_max: self.form.salary_band_max() || null,
        is_active:       self.form.is_active(),
      };

      self.saving(true);
      var op = self.editingCode()
        ? hrService.updateGrade(self.editingCode(), data)
        : hrService.createGrade(data);

      op.then(function () {
        self.saving(false);
        self.showModal(false);
        self.saved(self.editingCode() ? 'Grade updated.' : 'Grade added.');
        setTimeout(function () { self.saved(''); }, 4000);
        _load();
      }).catch(function (err) {
        self.saving(false);
        self.formError((err && err.message) || 'Save failed.');
      });
    };

    function _load() {
      self.loading(true);
      hrService.getGrades().then(function (list) {
        self.grades(list);
        self.loading(false);
      }).catch(function (err) {
        self.error((err && err.message) || 'Failed to load grades.');
        self.loading(false);
      });
    }

    _load();
  }

  return GradesViewModel;
});
