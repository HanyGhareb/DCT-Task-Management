define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function EmployeeDetailViewModel() {
    var self = this;

    self.isAdmin = authService.isHrAdmin();
    self.isMgr   = authService.isHrManager();

    var state    = window._hrApp ? window._hrApp.getState() : {};
    var personId = state.personId;

    self.employee    = ko.observable(null);
    self.assignments = ko.observableArray([]);
    self.contracts   = ko.observableArray([]);
    self.salaries    = ko.observableArray([]);
    self.documents   = ko.observableArray([]);
    self.loading     = ko.observable(true);
    self.error       = ko.observable('');
    self.activeTab   = ko.observable('overview');

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
  }

  return EmployeeDetailViewModel;
});
