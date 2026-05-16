define(['knockout', 'services/authService', 'services/clearService', 'services/pcService'],
function (ko, authService, clearService, pcService) {
  'use strict';

  function ClearingViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.records  = ko.observableArray([]);
    self.loading  = ko.observable(true);
    self.activePc = ko.observable(null);
    self.search   = ko.observable('');

    self.filtered = ko.computed(function () {
      var q = self.search().toLowerCase();
      return self.records().filter(function (r) {
        return !q || r.clearingNumber.toLowerCase().includes(q);
      });
    });

    self.fmtAmount = function (n) { return n ? Number(n).toLocaleString('en-US', { minimumFractionDigits: 2 }) : '0.00'; };
    self.fmtDate   = function (d) { return d ? new Date(d).toLocaleDateString('en-GB', { day:'2-digit', month:'short', year:'numeric' }) : '—'; };

    self.statusClass = function (s) {
      var map = { APPROVED:'badge--active', PENDING_APPROVAL:'badge--pending', SUBMITTED:'badge--pending',
                  REJECTED:'badge--rejected', DRAFT:'badge--idle' };
      return 'badge ' + (map[s] || 'badge--info');
    };

    self.hasActivePc = ko.computed(function () { return self.activePc() !== null; });
    self.canNewClear = ko.computed(function () {
      var pc = self.activePc();
      if (!pc) return false;
      // No existing pending clearing
      return !self.records().some(function(r){ return ['SUBMITTED','PENDING_APPROVAL','APPROVED'].includes(r.status); });
    });

    self.viewDetail = function (rec) {
      if (window._pcApp) window._pcApp.navigate('clearDetail', { clearingId: rec.clearingId, pcId: rec.pcId });
    };

    self.newClearing = function () {
      var pc = self.activePc();
      if (window._pcApp) window._pcApp.navigate('clearDetail', { pcId: pc ? pc.pcId : null });
    };

    function _load() {
      clearService.getMyClearings(user.userId).then(function (list) {
        self.records(list);
        self.loading(false);
      }).catch(function () { self.loading(false); });

      pcService.getMyPettyCash(user.userId).then(function (pcs) {
        self.activePc(pcs.find(function(p){ return p.status === 'ACTIVE'; }) || null);
      });
    }

    _load();
  }

  return ClearingViewModel;
});
