define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function EmployeesViewModel() {
    var self = this;

    self.isAdmin   = authService.isHrAdmin();
    self.isMgr     = authService.isHrManager();

    self.employees = ko.observableArray([]);
    self.orgs      = ko.observableArray([]);
    self.grades    = ko.observableArray([]);
    self.loading   = ko.observable(true);
    self.error     = ko.observable('');
    self.saved     = ko.observable('');

    self.searchQ   = ko.observable('');
    self.filterOrg = ko.observable('');

    // Modal state
    self.showModal = ko.observable(false);
    self.editingId = ko.observable(null);
    self.saving    = ko.observable(false);
    self.formError = ko.observable('');
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
      grade_code:      ko.observable(''),
      job_title_en:    ko.observable(''),
      hire_date:       ko.observable(''),
      is_active:       ko.observable('Y'),
    };

    self.filtered = ko.computed(function () {
      var q   = (self.searchQ() || '').toUpperCase();
      var org = self.filterOrg();
      return self.employees().filter(function (e) {
        var matchQ   = !q   || (e.fullNameEn || '').toUpperCase().includes(q)
                            || (e.employeeNumber || '').toUpperCase().includes(q)
                            || (e.email || '').toUpperCase().includes(q);
        var matchOrg = !org || String(e.orgId) === String(org);
        return matchQ && matchOrg;
      });
    });

    self.openEmployee = function (emp) {
      if (window._hrApp) window._hrApp.navigate('employeeDetail', { personId: emp.personId });
    };

    self.genderLabel = function (g) { return g === 'F' ? 'Female' : g === 'M' ? 'Male' : g || '—'; };
    self.activeClass = function (a) { return a === 'Y' ? 'badge badge--active' : 'badge badge--inactive'; };

    function _clearForm() {
      Object.keys(self.form).forEach(function (k) {
        self.form[k](k === 'is_active' ? 'Y' : '');
      });
      self.formError('');
      self.editingId(null);
    }

    self.openAdd = function () {
      _clearForm();
      self.showModal(true);
    };

    self.openEdit = function (emp) {
      _clearForm();
      self.editingId(emp.personId);
      // Split fullNameEn into first/last for edit
      var parts = (emp.fullNameEn || '').split(' ');
      self.form.first_name_en(parts[0] || '');
      self.form.last_name_en(parts.slice(1).join(' ') || '');
      self.form.employee_number(emp.employeeNumber || '');
      self.form.gender(emp.gender || '');
      self.form.email(emp.email || '');
      self.form.mobile(emp.mobile || '');
      self.form.org_id(String(emp.orgId || ''));
      self.form.grade_code(emp.gradeCode || '');
      self.form.job_title_en(emp.jobTitleEn || '');
      self.form.hire_date(emp.hireDate || '');
      self.form.is_active(emp.isActive || 'Y');
      self.showModal(true);
    };

    self.closeModal = function () {
      if (!self.saving()) self.showModal(false);
    };

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
        email:           self.form.email(),
        mobile:          self.form.mobile(),
        org_id:          oi,
        grade_code:      self.form.grade_code(),
        job_title_en:    self.form.job_title_en(),
        hire_date:       hd,
        is_active:       self.form.is_active(),
      };

      self.saving(true);
      self.formError('');
      var op = self.editingId()
        ? hrService.updateEmployee(self.editingId(), data)
        : hrService.createEmployee(data);

      op.then(function () {
        self.saving(false);
        self.showModal(false);
        self.saved(self.editingId() ? 'Employee updated successfully.' : 'Employee added successfully.');
        setTimeout(function () { self.saved(''); }, 4000);
        _reload();
      }).catch(function (err) {
        self.saving(false);
        self.formError((err && err.message) || 'Save failed. Please try again.');
      });
    };

    function _reload() {
      self.loading(true);
      Promise.all([
        hrService.getEmployees({ active: 'Y' }),
        hrService.getOrgs(),
        hrService.getGrades(),
      ]).then(function (results) {
        self.employees(results[0]);
        self.orgs(results[1]);
        self.grades(results[2]);
        self.loading(false);
      }).catch(function (err) {
        self.error((err && err.message) || 'Failed to load employees.');
        self.loading(false);
      });
    }

    _reload();
  }

  return EmployeesViewModel;
});
