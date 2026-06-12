define(['knockout', 'services/flService'], function (ko, flService) {
  'use strict';

  function ContractsViewModel() {
    var self = this;

    self.loading      = ko.observable(true);
    self.loadError    = ko.observable(false);
    self.items        = ko.observableArray([]);
    self.searchBy     = ko.observable('');
    self.statusFilter = ko.observable('');
    self.offset       = ko.observable(0);
    self.limit        = ko.observable(50);
    self.total        = ko.observable(0);

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      flService.getContracts({
        limit: self.limit(), offset: self.offset(),
        search: self.searchBy().trim() || null,
        status: self.statusFilter() || null
      }).then(function (r) {
        self.items(r.items || []);
        self.total(r.total || 0);
        self.loading(false);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };
    self.reload();

    self.searchBy.extend({ rateLimit: { timeout: 300, method: 'notifyWhenChangesStop' } });
    self.searchBy.subscribe(function () { self.offset(0); self.reload(); });
    self.statusFilter.subscribe(function () { self.offset(0); self.reload(); });

    self.openNew = function () {
      sessionStorage.setItem('flEditContractId', 'new');
      if (window._jetApp) window._jetApp.navigate('contractEdit');
    };
    self.openItem = function (item) {
      sessionStorage.setItem('flContractId', String(item.contractId));
      if (window._jetApp) window._jetApp.navigate('contractDetail');
    };

    self.badgeFor = function (s) {
      return { DRAFT: 'badge--draft', SUBMITTED: 'badge--submitted', APPROVED: 'badge--approved',
               ACTIVE: 'badge--approved', COMPLETED: 'badge--completed', CANCELLED: 'badge--cancelled' }[s] || 'badge--draft';
    };
    self.billPct = function (item) {
      var t = item.totalAmount || 0;
      return t ? Math.min(100, Math.round((item.paidTotal || 0) / t * 100)) : 0;
    };
  }

  return ContractsViewModel;
});
