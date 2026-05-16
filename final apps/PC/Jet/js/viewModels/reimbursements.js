define(['knockout', 'services/authService', 'services/reimbService', 'services/pcService'],
function (ko, authService, reimbService, pcService) {
  'use strict';

  function ReimbursementsViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.records  = ko.observableArray([]);
    self.loading  = ko.observable(true);
    self.search   = ko.observable('');
    self.activePc = ko.observable(null);

    self.filtered = ko.computed(function () {
      var q = self.search().toLowerCase();
      return self.records().filter(function (r) {
        return !q || r.reimbNumber.toLowerCase().includes(q) || (r.purpose || '').toLowerCase().includes(q);
      });
    });

    self.fmtAmount = function (n) { return n ? Number(n).toLocaleString('en-US', { minimumFractionDigits: 2 }) : '0.00'; };
    self.fmtDate   = function (d) { return d ? new Date(d).toLocaleDateString('en-GB', { day:'2-digit', month:'short', year:'numeric' }) : '—'; };

    self.statusClass = function (s) {
      var map = { APPROVED:'badge--active', PENDING_APPROVAL:'badge--pending', SUBMITTED:'badge--pending',
                  REJECTED:'badge--rejected', DRAFT:'badge--idle' };
      return 'badge ' + (map[s] || 'badge--info');
    };

    self.viewDetail = function (rec) {
      if (window._pcApp) window._pcApp.navigate('reimbDetail', { reimbId: rec.reimbId, pcId: rec.pcId });
    };

    self.newReimb = function () {
      var pc = self.activePc();
      if (window._pcApp) window._pcApp.navigate('reimbDetail', { pcId: pc ? pc.pcId : null });
    };

    self.hasActivePc = ko.computed(function () { return self.activePc() !== null; });

    function _load() {
      reimbService.getMyReimbursements(user.userId).then(function (list) {
        self.records(list);
        self.loading(false);
      }).catch(function () { self.loading(false); });

      pcService.getMyPettyCash(user.userId).then(function (pcs) {
        var active = pcs.find(function(p){ return p.status === 'ACTIVE'; });
        self.activePc(active || null);
      });
    }

    _load();
  }

  return ReimbursementsViewModel;
});
