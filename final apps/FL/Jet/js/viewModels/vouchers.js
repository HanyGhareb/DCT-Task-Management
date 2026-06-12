define(['knockout', 'services/flService'], function (ko, flService) {
  'use strict';

  function VouchersViewModel() {
    var self = this;

    self.loading      = ko.observable(true);
    self.loadError    = ko.observable(false);
    self.items        = ko.observableArray([]);
    self.statusFilter = ko.observable('');
    self.payFilter    = ko.observable('');
    self.offset       = ko.observable(0);
    self.limit        = ko.observable(50);
    self.total        = ko.observable(0);

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      flService.getVouchers({
        limit: self.limit(), offset: self.offset(),
        status: self.statusFilter() || null,
        paymentStatus: self.payFilter() || null
      }).then(function (r) {
        self.items(r.items || []);
        self.total(r.total || 0);
        self.loading(false);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };
    self.reload();
    self.statusFilter.subscribe(function () { self.offset(0); self.reload(); });
    self.payFilter.subscribe(function () { self.offset(0); self.reload(); });

    self.openItem = function (item) {
      sessionStorage.setItem('flVoucherId', String(item.voucherId));
      if (window._jetApp) window._jetApp.navigate('voucherDetail');
    };

    self.badgeFor = function (s) {
      return { DRAFT: 'badge--draft', SUBMITTED: 'badge--submitted', APPROVED: 'badge--approved',
               REJECTED: 'badge--rejected', CANCELLED: 'badge--cancelled' }[s] || 'badge--draft';
    };
    self.payBadge = function (s) {
      return { PENDING: 'badge--pendingp', PAID: 'badge--paid', CANCELLED: 'badge--cancelled' }[s] || 'badge--pendingp';
    };
  }

  return VouchersViewModel;
});
