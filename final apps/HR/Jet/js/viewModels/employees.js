define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function EmployeesViewModel() {
    var self = this;

    // ── Auth ───────────────────────────────────────────────────────────
    self.isAdmin = authService.isHrAdmin();
    self.isMgr   = authService.isHrManager();

    // ── Data ───────────────────────────────────────────────────────────
    self.employees = ko.observableArray([]);
    self.orgs      = ko.observableArray([]);
    self.grades    = ko.observableArray([]);
    self.positions = ko.observableArray([]);
    self.loading   = ko.observable(true);
    self.error     = ko.observable('');
    self.saved     = ko.observable('');

    // ── Filters ────────────────────────────────────────────────────────
    self.searchQ      = ko.observable('');
    self.filterOrg    = ko.observable('');
    self.filterGrade  = ko.observable('');
    self.filterStatus = ko.observable('Y');

    // ── View mode ──────────────────────────────────────────────────────
    self.viewMode = ko.observable('table');

    // ── Sorting ────────────────────────────────────────────────────────
    self.sortCol = ko.observable('fullNameEn');
    self.sortDir = ko.observable('asc');
    self.setSort = function (col) {
      if (self.sortCol() === col) {
        self.sortDir(self.sortDir() === 'asc' ? 'desc' : 'asc');
      } else {
        self.sortCol(col);
        self.sortDir('asc');
      }
      self.currentPage(1);
    };
    self.sortClass = function (col) {
      if (self.sortCol() !== col) return 'sort-icon sort-icon--none';
      return 'sort-icon sort-icon--' + self.sortDir();
    };

    // ── Pagination ─────────────────────────────────────────────────────
    self.pageSize    = 25;
    self.currentPage = ko.observable(1);
    self.setPage = function (p) {
      var tp = self.totalPages();
      if (p >= 1 && p <= tp) self.currentPage(p);
    };
    self.prevPage = function () { self.setPage(self.currentPage() - 1); };
    self.nextPage = function () { self.setPage(self.currentPage() + 1); };

    // ── Modal state ────────────────────────────────────────────────────
    self.showModal      = ko.observable(false);
    self.editingId      = ko.observable(null);
    self.saving         = ko.observable(false);
    self.formError      = ko.observable('');
    self.photoFile      = ko.observable(null);
    self.photoPreview   = ko.observable('');
    self.photoUploading = ko.observable(false);

    self.form = {
      first_name_en:   ko.observable(''),
      last_name_en:    ko.observable(''),
      first_name_ar:   ko.observable(''),
      last_name_ar:    ko.observable(''),
      employee_number: ko.observable(''),
      gender:          ko.observable(''),
      email:           ko.observable(''),
      mobile:          ko.observable(''),
      org_id:          ko.observable(''),
      position_id:     ko.observable(''),
      grade_code:      ko.observable(''),
      job_title_en:    ko.observable(''),
      hire_date:       ko.observable(''),
      is_active:       ko.observable('Y'),
    };

    // Positions filtered by the currently selected section
    self.filteredPositions = ko.computed(function () {
      var oi = self.form.org_id();
      if (!oi) return self.positions();
      return self.positions().filter(function (p) { return String(p.orgId) === String(oi); });
    });

    // Auto-fill grade when a position is selected
    self.form.position_id.subscribe(function (pid) {
      if (!pid) return;
      var pos = self.positions().find(function (p) { return String(p.positionId) === String(pid); });
      if (pos && pos.gradeCode) self.form.grade_code(pos.gradeCode);
    });

    // Clear position + grade when section changes
    self.form.org_id.subscribe(function () {
      self.form.position_id('');
      self.form.grade_code('');
    });

    // ── Helpers ────────────────────────────────────────────────────────
    self.fmtDate = function (d) {
      if (!d) return '—';
      var parts = String(d).substring(0, 10).split('-');
      if (parts.length !== 3) return d;
      var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      var m = parseInt(parts[1], 10);
      return parts[2] + ' ' + (months[m - 1] || parts[1]) + ' ' + parts[0];
    };

    var _colors = ['#0572CE','#2E7D32','#C74634','#6A1B9A','#E65100','#1a7f5a'];
    self.avatarColor = function (e) { return _colors[(e.personId || 0) % _colors.length]; };
    self.initials = function (name) {
      var words = (name || '').split(' ').filter(Boolean);
      if (words.length >= 2) return (words[0][0] + words[words.length - 1][0]).toUpperCase();
      return words.length ? words[0][0].toUpperCase() : '?';
    };

    self.genderLabel = function (g) { return g === 'F' ? 'Female' : g === 'M' ? 'Male' : g || '—'; };
    self.activeClass = function (a) { return a === 'Y' ? 'badge badge--active' : 'badge badge--inactive'; };

    self.modalInitials = ko.computed(function () {
      var name = (self.form.first_name_en() + ' ' + self.form.last_name_en()).trim();
      return self.initials(name) || '?';
    });

    self.saveButtonText = ko.computed(function () {
      if (self.photoUploading()) return 'Uploading photo…';
      if (self.saving())         return 'Saving…';
      return 'Save Employee';
    });

    // ── Stats ──────────────────────────────────────────────────────────
    self.stats = ko.computed(function () {
      var all    = self.employees();
      var active = all.filter(function (e) { return e.isActive === 'Y'; }).length;
      var orgSet = {};
      all.forEach(function (e) { if (e.orgId) orgSet[e.orgId] = 1; });
      return {
        total:    all.length,
        active:   active,
        inactive: all.length - active,
        sections: Object.keys(orgSet).length,
      };
    });

    // ── Filtered ───────────────────────────────────────────────────────
    self.filtered = ko.computed(function () {
      var q    = (self.searchQ() || '').toUpperCase();
      var org  = self.filterOrg();
      var grd  = self.filterGrade();
      var stat = self.filterStatus();
      return self.employees().filter(function (e) {
        var matchQ = !q
          || (e.fullNameEn    || '').toUpperCase().includes(q)
          || (e.fullNameAr    || '').toUpperCase().includes(q)
          || (e.firstNameAr   || '').toUpperCase().includes(q)
          || (e.lastNameAr    || '').toUpperCase().includes(q)
          || (e.employeeNumber|| '').toUpperCase().includes(q)
          || (e.email         || '').toUpperCase().includes(q);
        var matchOrg  = !org  || String(e.orgId)    === String(org);
        var matchGrd  = !grd  || e.gradeCode         === grd;
        var matchStat = !stat || e.isActive           === stat;
        return matchQ && matchOrg && matchGrd && matchStat;
      });
    });

    // ── Sorted ────────────────────────────────────────────────────────
    self.sorted = ko.computed(function () {
      var list = self.filtered().slice();
      var col  = self.sortCol();
      var dir  = self.sortDir();
      list.sort(function (a, b) {
        var av = (a[col] || '').toString().toLowerCase();
        var bv = (b[col] || '').toString().toLowerCase();
        if (av < bv) return dir === 'asc' ? -1 : 1;
        if (av > bv) return dir === 'asc' ?  1 : -1;
        return 0;
      });
      return list;
    });

    // ── Pagination computeds ───────────────────────────────────────────
    self.totalPages = ko.computed(function () {
      return Math.max(1, Math.ceil(self.sorted().length / self.pageSize));
    });

    self.filtered.subscribe(function () { self.currentPage(1); });

    self.paginated = ko.computed(function () {
      var p  = self.currentPage();
      var ps = self.pageSize;
      return self.sorted().slice((p - 1) * ps, p * ps);
    });

    self.pageNumbers = ko.computed(function () {
      var tp    = self.totalPages();
      var cp    = self.currentPage();
      var nums  = [];
      var start = Math.max(1, cp - 2);
      var end   = Math.min(tp, cp + 2);
      if (start > 1) nums.push(1);
      if (start > 2) nums.push('…');
      for (var i = start; i <= end; i++) nums.push(i);
      if (end < tp - 1) nums.push('…');
      if (end < tp)   nums.push(tp);
      return nums;
    });

    self.pageInfo = ko.computed(function () {
      var total = self.sorted().length;
      if (total === 0) return '0 employees';
      var p    = self.currentPage();
      var ps   = self.pageSize;
      var from = (p - 1) * ps + 1;
      var to   = Math.min(p * ps, total);
      return 'Showing ' + from + '–' + to + ' of ' + total + ' employee(s)';
    });

    // ── Filter helpers ─────────────────────────────────────────────────
    self.hasActiveFilters = ko.computed(function () {
      return !!(self.searchQ() || self.filterOrg() || self.filterGrade() || self.filterStatus() !== 'Y');
    });

    self.clearFilters = function () {
      self.searchQ('');
      self.filterOrg('');
      self.filterGrade('');
      self.filterStatus('Y');
      self.currentPage(1);
    };

    // ── Navigation ─────────────────────────────────────────────────────
    self.openEmployee = function (emp) {
      if (window._hrApp) window._hrApp.navigate('employeeDetail', { personId: emp.personId });
    };

    // ── Form helpers ───────────────────────────────────────────────────
    function _clearForm() {
      Object.keys(self.form).forEach(function (k) {
        self.form[k](k === 'is_active' ? 'Y' : '');
      });
      self.formError('');
      self.editingId(null);
      self.photoFile(null);
      self.photoPreview('');
    }

    self.openAdd = function () {
      _clearForm();
      self.showModal(true);
    };

    self.openEdit = function (emp) {
      _clearForm();
      self.editingId(emp.personId);
      // Use stored firstNameEn/lastNameEn directly; fall back to splitting fullNameEn
      self.form.first_name_en(emp.firstNameEn || (emp.fullNameEn || '').split(' ')[0] || '');
      self.form.last_name_en(emp.lastNameEn  || (emp.fullNameEn || '').split(' ').slice(1).join(' ') || '');
      self.form.first_name_ar(emp.firstNameAr || '');
      self.form.last_name_ar(emp.lastNameAr  || '');
      self.form.employee_number(emp.employeeNumber || '');
      self.form.gender(emp.gender || '');
      self.form.email(emp.email || '');
      self.form.mobile(emp.mobile || '');
      self.form.org_id(String(emp.orgId || ''));
      self.form.position_id(String(emp.positionId || ''));
      self.form.grade_code(emp.gradeCode || '');
      self.form.job_title_en(emp.jobTitleEn || '');
      self.form.hire_date(emp.hireDate ? String(emp.hireDate).substring(0, 10) : '');
      self.form.is_active(emp.isActive || 'Y');
      if (emp.photoUrl) self.photoPreview(emp.photoUrl);
      self.showModal(true);
    };

    self.closeModal = function () {
      if (!self.saving()) self.showModal(false);
    };

    // ── Photo pick (same pattern as employeeDetail) ────────────────────
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
        setTimeout(function () { if (document.body.contains(inp)) document.body.removeChild(inp); }, 500);
      });
      inp.click();
    }

    self.pickPhoto = function () {
      _pickFile('image/*', function (file) {
        if (!file.type.startsWith('image/')) { self.formError('Please select an image file.'); return; }
        if (file.size > 5 * 1024 * 1024) { self.formError('Image must be under 5 MB.'); return; }
        self.photoFile(file);
        var reader = new FileReader();
        reader.onload = function (e) { self.photoPreview(e.target.result); };
        reader.readAsDataURL(file);
      });
    };

    // ── Save ───────────────────────────────────────────────────────────
    self.saveEmployee = function () {
      var fn = self.form.first_name_en().trim();
      var ln = self.form.last_name_en().trim();
      var en = self.form.employee_number().trim();
      var hd = self.form.hire_date();
      var oi = self.form.org_id();
      var em = self.form.email().trim();

      if (!fn || !ln) { self.formError('First Name and Last Name are required.'); return; }
      if (!self.editingId() && !en) { self.formError('Employee Number is required.'); return; }
      if (!em) { self.formError('Work Email is required.'); return; }
      if (!hd) { self.formError('Hire Date is required.'); return; }
      if (!oi) { self.formError('Section is required.'); return; }

      var data = {
        first_name_en:   fn,
        last_name_en:    ln,
        first_name_ar:   self.form.first_name_ar(),
        last_name_ar:    self.form.last_name_ar(),
        employee_number: en,
        gender:          self.form.gender(),
        email:           em,
        mobile:          self.form.mobile(),
        org_id:          oi,
        grade_code:      self.form.grade_code(),
        position_id:     self.form.position_id() || null,
        job_title_en:    self.form.job_title_en(),
        hire_date:       hd,
        is_active:       self.form.is_active(),
      };

      self.saving(true);
      self.formError('');
      var isEdit = !!self.editingId();
      var op = isEdit
        ? hrService.updateEmployee(self.editingId(), data)
        : hrService.createEmployee(data);

      op.then(function (result) {
        var savedId = isEdit ? self.editingId() : (result && (result.personId || result.person_id));
        var file    = self.photoFile();

        function _finish() {
          self.saving(false);
          self.photoUploading(false);
          self.showModal(false);
          self.saved(isEdit ? 'Employee updated successfully.' : 'Employee added successfully.');
          setTimeout(function () { self.saved(''); }, 4000);
          _reload();
        }

        if (file && savedId) {
          self.photoUploading(true);
          hrService.uploadEmployeePhoto(savedId, file).then(_finish).catch(_finish);
        } else {
          _finish();
        }
      }).catch(function (err) {
        self.saving(false);
        self.formError((err && err.message) || 'Save failed. Please try again.');
      });
    };

    // ── Export CSV ─────────────────────────────────────────────────────
    self.exportCSV = function () {
      var headers = ['Employee Number','Full Name','Section','Grade','Position','Gender','Hire Date','Status'];
      var rows = [headers].concat(self.sorted().map(function (e) {
        return [
          e.employeeNumber || '',
          e.fullNameEn     || '',
          e.orgNameEn      || '',
          e.gradeCode      || '',
          e.positionNameEn || e.jobTitleEn || '',
          self.genderLabel(e.gender),
          e.hireDate       || '',
          e.isActive === 'Y' ? 'Active' : 'Inactive',
        ];
      }));
      var csv = rows.map(function (r) {
        return r.map(function (c) { return '"' + String(c).replace(/"/g, '""') + '"'; }).join(',');
      }).join('\n');
      var blob = new Blob([csv], { type: 'text/csv' });
      var url  = URL.createObjectURL(blob);
      var a    = document.createElement('a');
      a.href = url;
      a.download = 'employees_' + new Date().toISOString().slice(0, 10) + '.csv';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      setTimeout(function () { URL.revokeObjectURL(url); }, 2000);
    };

    // ── Reload ─────────────────────────────────────────────────────────
    function _reload() {
      self.loading(true);
      Promise.all([
        hrService.getEmployees({}),
        hrService.getOrgs(),
        hrService.getGrades(),
        hrService.getPositions(),
      ]).then(function (results) {
        self.employees(results[0]);
        self.orgs(results[1]);
        self.grades(results[2]);
        self.positions(results[3]);
        self.loading(false);
      }).catch(function (err) {
        self.error((err && err.message) || 'Failed to load employees.');
        self.loading(false);
      });
    }

    // ── ESC closes modal ───────────────────────────────────────────────
    function _onKeyDown(e) {
      if (e.key === 'Escape' && self.showModal()) self.closeModal();
    }
    document.addEventListener('keydown', _onKeyDown);

    // Window bridge — file dialogs must be triggered from onclick in JET
    window._hrEmpPickPhoto = function () { self.pickPhoto(); };

    self.dispose = function () {
      document.removeEventListener('keydown', _onKeyDown);
      delete window._hrEmpPickPhoto;
    };

    _reload();
  }

  return EmployeesViewModel;
});
