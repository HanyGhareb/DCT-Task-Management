define(['knockout', 'services/authService', 'services/pcService'],
function (ko, authService, pcService) {
  'use strict';

  function MyPettyCashViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.records  = ko.observableArray([]);
    self.loading  = ko.observable(true);
    self.search   = ko.observable('');
    self.filterStatus = ko.observable('');

    self.STATUS_OPTIONS = [
      { value: '', label: 'All Statuses' },
      { value: 'ACTIVE',           label: 'Active' },
      { value: 'PENDING_APPROVAL', label: 'Pending Approval' },
      { value: 'SUBMITTED',        label: 'Submitted' },
      { value: 'APPROVED',         label: 'Approved' },
      { value: 'CLOSED',           label: 'Closed' },
      { value: 'REJECTED',         label: 'Rejected' },
    ];

    self.filtered = ko.computed(function () {
      var q = self.search().toLowerCase();
      var s = self.filterStatus();
      return self.records().filter(function (r) {
        var matchQ = !q || r.pcNumber.toLowerCase().includes(q) || r.purpose.toLowerCase().includes(q);
        var matchS = !s || r.status === s;
        return matchQ && matchS;
      });
    });

    self.newRequest = function () {
      if (window._pcApp) window._pcApp.navigate('pcRequest');
    };

    self.viewDetail = function (rec) {
      if (window._pcApp) window._pcApp.navigate('pcDetail', { pcId: rec.pcId, pcNumber: rec.pcNumber });
    };

    self.statusLabel = function (s) {
      var map = { ACTIVE:'Active', PENDING_APPROVAL:'Pending Approval', SUBMITTED:'Submitted',
                  APPROVED:'Approved', CLOSED:'Closed', REJECTED:'Rejected', DRAFT:'Draft' };
      return map[s] || s;
    };

    self.statusClass = function (s) {
      var map = { ACTIVE:'badge--active', PENDING_APPROVAL:'badge--pending', SUBMITTED:'badge--pending',
                  APPROVED:'badge--info', CLOSED:'badge--inactive', REJECTED:'badge--rejected', DRAFT:'badge--idle' };
      return 'badge ' + (map[s] || 'badge--info');
    };

    self.typeLabel  = function (t) { return t === 'PERMANENT' ? '&#9855; Permanent' : '&#128337; Temporary'; };
    self.fmtAmount  = function (n) { return n ? Number(n).toLocaleString('en-US', { minimumFractionDigits: 2 }) : '0.00'; };
    self.fmtDate    = function (d) { return d ? new Date(d).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }) : '—'; };

    pcService.getMyPettyCash(user.userId).then(function (list) {
      self.records(list);
      self.loading(false);
    }).catch(function () { self.loading(false); });
  }

  return MyPettyCashViewModel;
});
