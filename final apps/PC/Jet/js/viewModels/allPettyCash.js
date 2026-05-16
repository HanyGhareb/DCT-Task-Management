define(['knockout', 'services/authService', 'services/pcService'],
function (ko, authService, pcService) {
  'use strict';

  function AllPettyCashViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.records      = ko.observableArray([]);
    self.loading      = ko.observable(true);
    self.search       = ko.observable('');
    self.filterStatus = ko.observable('');
    self.filterType   = ko.observable('');
    self.success      = ko.observable('');
    self.error        = ko.observable('');

    self.STATUS_OPTIONS = [
      { value: '', label: 'All Statuses' },
      { value: 'ACTIVE',           label: 'Active' },
      { value: 'PENDING_APPROVAL', label: 'Pending Approval' },
      { value: 'APPROVED',         label: 'Approved (Awaiting Disburse)' },
      { value: 'SUBMITTED',        label: 'Submitted' },
      { value: 'CLOSED',           label: 'Closed' },
      { value: 'REJECTED',         label: 'Rejected' },
    ];
    self.TYPE_OPTIONS = [
      { value: '', label: 'All Types' },
      { value: 'TEMPORARY', label: 'Temporary' },
      { value: 'PERMANENT', label: 'Permanent' },
    ];

    self.filtered = ko.computed(function () {
      var q  = self.search().toLowerCase();
      var s  = self.filterStatus();
      var t  = self.filterType();
      return self.records().filter(function (r) {
        var matchQ = !q || r.pcNumber.toLowerCase().includes(q) || r.employeeName.toLowerCase().includes(q) || r.employeeNumber.toLowerCase().includes(q);
        var matchS = !s || r.status === s;
        var matchT = !t || r.pcType === t;
        return matchQ && matchS && matchT;
      });
    });

    self.fmtAmount  = function (n) { return n ? Number(n).toLocaleString('en-US', { minimumFractionDigits: 2 }) : '0.00'; };
    self.fmtDate    = function (d) { return d ? new Date(d).toLocaleDateString('en-GB', { day:'2-digit', month:'short', year:'numeric' }) : '—'; };

    self.statusClass = function (s) {
      var map = { ACTIVE:'badge--active', PENDING_APPROVAL:'badge--pending', SUBMITTED:'badge--pending',
                  APPROVED:'badge--info', CLOSED:'badge--inactive', REJECTED:'badge--rejected', DRAFT:'badge--idle' };
      return 'badge ' + (map[s] || 'badge--info');
    };

    self.viewDetail = function (rec) {
      if (window._pcApp) window._pcApp.navigate('pcDetail', { pcId: rec.pcId, pcNumber: rec.pcNumber });
    };

    self.disburse = function (rec) {
      if (!confirm('Disburse ' + self.fmtAmount(rec.amount) + ' AED to ' + rec.employeeName + '?')) return;
      pcService.disburse(rec.pcId, user.userId).then(function () {
        self.success('Disbursed ' + rec.pcNumber + ' successfully.');
        _load();
      }).catch(function (err) {
        self.error((err && err.message) || 'Disburse failed.');
      });
    };

    function _load() {
      pcService.getAllPettyCash().then(function (list) {
        self.records(list);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    _load();
  }

  return AllPettyCashViewModel;
});
