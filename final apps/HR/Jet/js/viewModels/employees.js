define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function EmployeesViewModel() {
    var self = this;

    self.isAdmin   = authService.isHrAdmin();
    self.isMgr     = authService.isHrManager();

    self.employees = ko.observableArray([]);
    self.orgs      = ko.observableArray([]);
    self.loading   = ko.observable(true);
    self.error     = ko.observable('');

    self.searchQ   = ko.observable('');
    self.filterOrg = ko.observable('');

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

    function _load() {
      Promise.all([
        hrService.getEmployees({ active: 'Y' }),
        hrService.getOrgs(),
      ]).then(function (results) {
        self.employees(results[0]);
        self.orgs(results[1]);
        self.loading(false);
      }).catch(function (err) {
        self.error((err && err.message) || 'Failed to load employees.');
        self.loading(false);
      });
    }

    _load();
  }

  return EmployeesViewModel;
});
