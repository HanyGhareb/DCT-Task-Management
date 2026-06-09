define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function GradesViewModel() {
    var self = this;

    self.isAdmin = authService.isHrAdmin();
    self.isMgr   = authService.isHrManager();
    self.grades          = ko.observableArray([]);
    self.gradeCategories = ko.observableArray([]);
    self.loading = ko.observable(true);
    self.error   = ko.observable('');
    self.saved   = ko.observable('');
    self.searchQ      = ko.observable('');
    self.filterStatus = ko.observable('Y');

    // ── Sorting ────────────────────────────────────────────────────────
    self.sortCol = ko.observable('gradeLevel');
    self.sortDir = ko.observable('asc');
    self.setSort = function (col) {
      if (self.sortCol() === col) {
        self.sortDir(self.sortDir() === 'asc' ? 'desc' : 'asc');
      } else {
        self.sortCol(col);
        self.sortDir('asc');
      }
    };
    self.sortClass = function (col) {
      if (self.sortCol() !== col) return 'sort-icon sort-icon--none';
      return 'sort-icon sort-icon--' + self.sortDir();
    };

    // ── Modal ──────────────────────────────────────────────────────────
    self.showModal     = ko.observable(false);
    self.editingCode   = ko.observable(null);
    self.saving        = ko.observable(false);
    self.formError     = ko.observable('');
    self.auditExpanded = ko.observable(false);

    self.form = {
      grade_code:      ko.observable(''),
      grade_name_en:   ko.observable(''),
      grade_name_ar:   ko.observable(''),
      grade_level:     ko.observable(''),
      grade_category:  ko.observable('PROFESSIONAL'),
      salary_band_min: ko.observable(''),
      salary_band_max: ko.observable(''),
      display_order:   ko.observable(''),
      is_active:       ko.observable('Y'),
    };

    self.auditCreatedBy = ko.observable('');
    self.auditCreatedAt = ko.observable('');
    self.auditUpdatedBy = ko.observable('');
    self.auditUpdatedAt = ko.observable('');

    // ── Helpers ────────────────────────────────────────────────────────
    self.categoryLabel = function (c) {
      var match = self.gradeCategories().filter(function (x) { return x.value_code === c; })[0];
      return (match && match.value_name_en) || c || '—';
    };

    self.salaryRange = function (g) {
      var min = g.salaryBandMin != null && g.salaryBandMin !== '' ? Number(g.salaryBandMin) : null;
      var max = g.salaryBandMax != null && g.salaryBandMax !== '' ? Number(g.salaryBandMax) : null;
      if (min !== null && max !== null) return 'AED ' + min.toLocaleString() + ' – ' + max.toLocaleString();
      if (min !== null) return 'AED ' + min.toLocaleString() + '+';
      if (max !== null) return 'Up to AED ' + max.toLocaleString();
      return '—';
    };

    self.fmtDateTime = function (dt) {
      if (!dt) return '—';
      var d = new Date(dt);
      if (isNaN(d.getTime())) return dt;
      var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return d.getDate() + ' ' + months[d.getMonth()] + ' ' + d.getFullYear()
           + ' · ' + String(d.getHours()).padStart(2, '0') + ':' + String(d.getMinutes()).padStart(2, '0');
    };

    // ── Filtered + Sorted ──────────────────────────────────────────────
    self.filtered = ko.computed(function () {
      var q    = (self.searchQ() || '').toUpperCase();
      var stat = self.filterStatus();
      var col  = self.sortCol();
      var dir  = self.sortDir();

      var list = self.grades().filter(function (g) {
        var matchQ = !q
          || (g.gradeCode     || '').toUpperCase().includes(q)
          || (g.gradeNameEn   || '').toUpperCase().includes(q)
          || (g.gradeCategory || '').toUpperCase().includes(q);
        var matchStat = !stat || g.isActive === stat;
        return matchQ && matchStat;
      });

      list.sort(function (a, b) {
        var av, bv;
        if (col === 'gradeLevel' || col === 'headcount') {
          av = Number(a[col]) || 0;
          bv = Number(b[col]) || 0;
        } else {
          av = (a[col] || '').toString().toLowerCase();
          bv = (b[col] || '').toString().toLowerCase();
        }
        if (av < bv) return dir === 'asc' ? -1 : 1;
        if (av > bv) return dir === 'asc' ?  1 : -1;
        return 0;
      });

      return list;
    });

    // ── Form helpers ───────────────────────────────────────────────────
    function _clearForm() {
      self.form.grade_code('');
      self.form.grade_name_en('');
      self.form.grade_name_ar('');
      self.form.grade_level('');
      self.form.grade_category('PROFESSIONAL');
      self.form.salary_band_min('');
      self.form.salary_band_max('');
      self.form.display_order('');
      self.form.is_active('Y');
      self.formError('');
      self.editingCode(null);
      self.auditExpanded(false);
      self.auditCreatedBy('');
      self.auditCreatedAt('');
      self.auditUpdatedBy('');
      self.auditUpdatedAt('');
    }

    self.openAdd = function () { _clearForm(); self.showModal(true); };

    self.openEdit = function (g) {
      _clearForm();
      self.editingCode(g.gradeCode);
      self.form.grade_code(g.gradeCode || '');
      self.form.grade_name_en(g.gradeNameEn || '');
      self.form.grade_name_ar(g.gradeNameAr || '');
      self.form.grade_level(String(g.gradeLevel || ''));
      self.form.grade_category(g.gradeCategory || 'PROFESSIONAL');
      self.form.salary_band_min(g.salaryBandMin != null ? String(g.salaryBandMin) : '');
      self.form.salary_band_max(g.salaryBandMax != null ? String(g.salaryBandMax) : '');
      self.form.display_order(g.displayOrder != null ? String(g.displayOrder) : '');
      self.form.is_active(g.isActive || 'Y');
      self.auditCreatedBy(g.createdBy || '');
      self.auditCreatedAt(g.createdAt || '');
      self.auditUpdatedBy(g.updatedBy || '');
      self.auditUpdatedAt(g.updatedAt || '');
      self.showModal(true);
    };

    self.closeModal  = function () { if (!self.saving()) self.showModal(false); };
    self.toggleAudit = function () { self.auditExpanded(!self.auditExpanded()); };

    self.saveGrade = function () {
      var code  = self.form.grade_code().trim();
      var name  = self.form.grade_name_en().trim();
      var level = parseInt(self.form.grade_level(), 10);
      var minV  = self.form.salary_band_min();
      var maxV  = self.form.salary_band_max();
      var minS  = minV !== '' ? parseFloat(minV) : null;
      var maxS  = maxV !== '' ? parseFloat(maxV) : null;

      if (!name)                                { self.formError('Grade Name (EN) is required.'); return; }
      if (!self.editingCode() && !code)         { self.formError('Grade Code is required.'); return; }
      if (isNaN(level) || level < 1)            { self.formError('Grade Level must be 1 or greater.'); return; }
      if (minS !== null && maxS !== null && minS > maxS) {
        self.formError('Min Salary cannot exceed Max Salary.'); return;
      }

      var doV  = self.form.display_order();
      var data = {
        grade_code:      code,
        grade_name_en:   name,
        grade_name_ar:   self.form.grade_name_ar(),
        grade_level:     level,
        grade_category:  self.form.grade_category() || 'PROFESSIONAL',
        salary_band_min: minS,
        salary_band_max: maxS,
        display_order:   doV !== '' ? parseInt(doV, 10) : null,
        is_active:       self.form.is_active(),
      };

      self.saving(true);
      self.formError('');
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
      Promise.all([
        hrService.getGrades(),
        hrService.getLookupValues('HR_GRADE_CATEGORY'),
      ]).then(function (results) {
        self.grades(results[0]);
        self.gradeCategories(results[1]);
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
