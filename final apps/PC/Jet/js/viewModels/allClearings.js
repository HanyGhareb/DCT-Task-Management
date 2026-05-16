define(['knockout', 'services/clearService'],
function (ko, clearService) {
  'use strict';

  function AllClearingsViewModel() {
    var self = this;

    self.records  = ko.observableArray([]);
    self.loading  = ko.observable(true);
    self.search   = ko.observable('');
    self.filterStatus = ko.observable('');

    self.STATUS_OPTIONS = [
      { value: '', label: 'All Statuses' },
      { value: 'PENDING_APPROVAL', label: 'Pending Approval' },
      { value: 'APPROVED', label: 'Approved' },
      { value: 'REJECTED', label: 'Rejected' },
    ];

    self.filtered = ko.computed(function () {
      var q = self.search().toLowerCase();
      var s = self.filterStatus();
      return self.records().filter(function (r) {
        var matchQ = !q || r.clearingNumber.toLowerCase().includes(q) || r.employeeName.toLowerCase().includes(q) || r.pcNumber.toLowerCase().includes(q);
        var matchS = !s || r.status === s;
        return matchQ && matchS;
      });
    });

    self.fmtAmount = function (n) { return n ? Number(n).toLocaleString('en-US', { minimumFractionDigits: 2 }) : '0.00'; };
    self.fmtDate   = function (d) { return d ? new Date(d).toLocaleDateString('en-GB', { day:'2-digit', month:'short', year:'numeric' }) : '—'; };

    self.statusClass = function (s) {
      var map = { APPROVED:'badge--active', PENDING_APPROVAL:'badge--pending', SUBMITTED:'badge--pending', REJECTED:'badge--rejected' };
      return 'badge ' + (map[s] || 'badge--info');
    };

    self.viewDetail = function (rec) {
      if (window._pcApp) window._pcApp.navigate('clearDetail', { clearingId: rec.clearingId, pcId: rec.pcId });
    };

    clearService.getAllClearings().then(function (list) {
      self.records(list);
      self.loading(false);
    }).catch(function () { self.loading(false); });
  }

  return AllClearingsViewModel;
});
