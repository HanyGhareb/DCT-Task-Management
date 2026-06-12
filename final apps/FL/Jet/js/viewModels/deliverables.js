define(['knockout', 'services/flService'], function (ko, flService) {
  'use strict';

  function DeliverablesViewModel() {
    var self = this;

    self.loading      = ko.observable(true);
    self.loadError    = ko.observable(false);
    self.items        = ko.observableArray([]);
    self.statusFilter = ko.observable('');
    self.successMsg   = ko.observable('');
    self.errorMsg     = ko.observable('');

    function flash(m) { self.successMsg(m); setTimeout(function () { self.successMsg(''); }, 3000); }

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      flService.getDeliverables({ status: self.statusFilter() || null }).then(function (items) {
        self.items(items);
        self.loading(false);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };
    self.reload();
    self.statusFilter.subscribe(function () { self.reload(); });

    self.accept = function (item) {
      flService.acceptDeliverable(item.deliverableId).then(function () {
        flash('Accepted.');
        self.reload();
      }).catch(function (err) { self.errorMsg((err && err.message) || 'Action failed'); });
    };

    self.rejectTarget = ko.observable(null);
    self.rejectReason = ko.observable('');
    self.openReject = function (item) { self.rejectTarget(item); self.rejectReason(''); };
    self.confirmReject = function () {
      if (!self.rejectReason().trim()) { self.errorMsg('A rejection reason is required'); return; }
      flService.rejectDeliverable(self.rejectTarget().deliverableId, self.rejectReason().trim()).then(function () {
        self.rejectTarget(null);
        flash('Rejected.');
        self.reload();
      }).catch(function (err) { self.errorMsg((err && err.message) || 'Action failed'); });
    };

    self.badgeFor = function (s) {
      return { SUBMITTED: 'badge--submitted', ACCEPTED: 'badge--approved', REJECTED: 'badge--rejected' }[s] || 'badge--draft';
    };
  }

  return DeliverablesViewModel;
});
