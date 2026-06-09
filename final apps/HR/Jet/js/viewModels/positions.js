define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function PositionsViewModel() {
    var self = this;

    self.isAdmin    = authService.isHrAdmin();
    self.isMgr      = authService.isHrManager();
    self.positions  = ko.observableArray([]);
    self.orgs       = ko.observableArray([]);
    self.jobs       = ko.observableArray([]);
    self.grades     = ko.observableArray([]);
    self.loading    = ko.observable(true);
    self.error      = ko.observable('');
    self.saved      = ko.observable('');
    self.filterOrg  = ko.observable('');
    self.searchQ    = ko.observable('');
    self.filterVacancy = ko.observable('');

    // Sort state
    self.sortCol = ko.observable('positionNameEn');
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
      if (self.sortCol() !== col) return 'sort-icon';
      return 'sort-icon sort-icon--' + self.sortDir();
    };

    // Modal
    self.showModal     = ko.observable(false);
    self.editingId     = ko.observable(null);
    self.saving        = ko.observable(false);
    self.formError     = ko.observable('');
    self.auditExpanded = ko.observable(false);
    self.auditCreatedBy = ko.observable('');
    self.auditCreatedAt = ko.observable('');
    self.auditUpdatedBy = ko.observable('');
    self.auditUpdatedAt = ko.observable('');
    self.form = {
      position_code:      ko.observable(''),
      position_name_en:   ko.observable(''),
      position_name_ar:   ko.observable(''),
      job_id:             ko.observable(''),
      org_id:             ko.observable(''),
      grade_code:         ko.observable(''),
      approved_headcount: ko.observable('1'),
      position_type:      ko.observable('PERMANENT'),
      is_active:          ko.observable('Y'),
    };

    // Computed: save button text
    self.saveButtonText = ko.computed(function () {
      return self.saving() ? 'Saving…' : 'Save Position';
    });

    // Computed: active filters flag for Clear Filters button
    self.hasActiveFilters = ko.computed(function () {
      return !!(self.searchQ() || self.filterOrg() || self.filterVacancy());
    });

    self.clearFilters = function () {
      self.searchQ('');
      self.filterOrg('');
      self.filterVacancy('');
    };

    self.filtered = ko.computed(function () {
      var q   = (self.searchQ() || '').toUpperCase();
      var org = self.filterOrg();
      var vac = self.filterVacancy();
      var list = self.positions().filter(function (p) {
        var matchQ   = !q   || (p.positionNameEn || '').toUpperCase().includes(q) || (p.positionCode || '').toUpperCase().includes(q);
        var matchOrg = !org || String(p.orgId) === String(org);
        var matchVac = !vac || (vac === 'vacant' ? p.vacancyCount > 0 : vac === 'full' ? p.vacancyCount <= 0 : true);
        return matchQ && matchOrg && matchVac;
      });

      // Sort
      var col = self.sortCol();
      var dir = self.sortDir();
      list = list.slice().sort(function (a, b) {
        var va = a[col] != null ? a[col] : '';
        var vb = b[col] != null ? b[col] : '';
        if (typeof va === 'number' && typeof vb === 'number') {
          return dir === 'asc' ? va - vb : vb - va;
        }
        va = String(va).toLowerCase();
        vb = String(vb).toLowerCase();
        if (va < vb) return dir === 'asc' ? -1 :  1;
        if (va > vb) return dir === 'asc' ?  1 : -1;
        return 0;
      });

      return list;
    });

    self.totalApproved = ko.computed(function () { return self.positions().reduce(function (a, p) { return a + (p.approvedHeadcount || 0); }, 0); });
    self.totalFilled   = ko.computed(function () { return self.positions().reduce(function (a, p) { return a + (p.filledCount       || 0); }, 0); });
    self.totalVacant   = ko.computed(function () { return self.positions().reduce(function (a, p) { return a + (p.vacancyCount      || 0); }, 0); });

    self.fillPct = function (pos) {
      if (!pos.approvedHeadcount) return 0;
      return Math.min(100, Math.round((pos.filledCount / pos.approvedHeadcount) * 100));
    };

    // Fill rate bar CSS class — green >80%, orange 50-80%, red <50%
    self.fillBarClass = function (pos) {
      var pct = self.fillPct(pos);
      if (pct >= 80) return 'progress-bar-fill progress-bar-fill--green';
      if (pct >= 50) return 'progress-bar-fill progress-bar-fill--orange';
      return 'progress-bar-fill progress-bar-fill--red';
    };

    // Vacancy badge — danger when vacancyCount > approvedHeadcount/2
    self.vacancyClass = function (pos) {
      if (pos.vacancyCount <= 0)   return 'badge badge--approved';
      var threshold = (pos.approvedHeadcount || 0) / 2;
      if (pos.vacancyCount > threshold) return 'badge badge--danger';
      return 'badge badge--warning';
    };

    // Navigate to Employees filtered by position
    self.goToEmployees = function (pos) {
      if (window._hrApp && window._hrApp.navigate) {
        window._hrApp.navigate('employees', { positionId: pos.positionId, positionName: pos.positionNameEn });
      }
    };

    // Export CSV
    self.exportCSV = function () {
      var rows = [['Position Code', 'Position Name EN', 'Position Name AR', 'Job', 'Section', 'Grade', 'Type', 'Approved HC', 'Filled', 'Vacancies', 'Fill %', 'Status']];
      self.filtered().forEach(function (p) {
        rows.push([
          p.positionCode || '',
          p.positionNameEn || '',
          p.positionNameAr || '',
          p.jobNameEn || '',
          p.orgNameEn || '',
          p.gradeCode || '',
          p.positionType || '',
          p.approvedHeadcount || 0,
          p.filledCount || 0,
          p.vacancyCount || 0,
          self.fillPct(p) + '%',
          p.isActive === 'Y' ? 'Active' : 'Inactive',
        ]);
      });
      var csv = rows.map(function (r) {
        return r.map(function (c) { return '"' + String(c).replace(/"/g, '""') + '"'; }).join(',');
      }).join('\r\n');
      var blob = new Blob(['﻿' + csv], { type: 'text/csv;charset=utf-8;' });
      var url  = URL.createObjectURL(blob);
      var a    = document.createElement('a');
      a.href   = url;
      a.download = 'positions.csv';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    };

    self.fmtDateTime = function (dt) {
      if (!dt) return '—';
      var d = new Date(dt);
      if (isNaN(d.getTime())) return dt;
      var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return d.getDate() + ' ' + months[d.getMonth()] + ' ' + d.getFullYear()
           + ' · ' + String(d.getHours()).padStart(2, '0') + ':' + String(d.getMinutes()).padStart(2, '0');
    };

    self.toggleAudit = function () { self.auditExpanded(!self.auditExpanded()); };

    function _clearForm() {
      Object.keys(self.form).forEach(function (k) {
        if (k === 'is_active')               self.form[k]('Y');
        else if (k === 'approved_headcount') self.form[k]('1');
        else if (k === 'position_type')      self.form[k]('PERMANENT');
        else self.form[k]('');
      });
      self.formError('');
      self.editingId(null);
      self.auditExpanded(false);
      self.auditCreatedBy('');
      self.auditCreatedAt('');
      self.auditUpdatedBy('');
      self.auditUpdatedAt('');
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
      self.form.position_type(pos.positionType || 'PERMANENT');
      self.form.is_active(pos.isActive || 'Y');
      self.auditCreatedBy(pos.createdBy || '');
      self.auditCreatedAt(pos.createdAt || '');
      self.auditUpdatedBy(pos.updatedBy || '');
      self.auditUpdatedAt(pos.updatedAt || '');
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
        position_type:      self.form.position_type(),
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

    // ESC key handler
    self._onKeyDown = function (e) {
      if (e.key === 'Escape' && self.showModal()) self.closeModal();
    };
    document.addEventListener('keydown', self._onKeyDown);

    self.dispose = function () {
      document.removeEventListener('keydown', self._onKeyDown);
    };

    function _load() {
      self.loading(true);
      Promise.all([hrService.getPositions(), hrService.getOrgs(), hrService.getJobs(), hrService.getGrades()])
        .then(function (results) {
          self.positions(results[0]);
          self.orgs(results[1]);
          self.jobs(results[2]);
          self.grades(results[3]);
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
