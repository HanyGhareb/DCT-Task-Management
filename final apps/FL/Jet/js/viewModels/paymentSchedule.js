define(['knockout', 'services/flService'], function (ko, flService) {
  'use strict';

  function PaymentScheduleViewModel() {
    var self = this;

    self.loading      = ko.observable(true);
    self.loadError    = ko.observable(false);
    self.items        = ko.observableArray([]);
    self.statusFilter = ko.observable('PENDING');
    self.offset       = ko.observable(0);
    self.limit        = ko.observable(50);
    self.total        = ko.observable(0);
    self.successMsg   = ko.observable('');
    self.errorMsg     = ko.observable('');

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      flService.getSchedule({
        limit: self.limit(), offset: self.offset(),
        status: self.statusFilter() || null
      }).then(function (r) {
        self.items(r.items || []);
        self.total(r.total || 0);
        self.loading(false);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };
    self.reload();
    self.statusFilter.subscribe(function () { self.offset(0); self.reload(); });

    self.generateVoucher = function (row) {
      flService.generateVoucher(row.scheduleId).then(function (r) {
        self.successMsg('Voucher ' + r.voucherNumber + ' created (DRAFT).');
        setTimeout(function () { self.successMsg(''); }, 3000);
        self.reload();
      }).catch(function (err) {
        self.errorMsg((err && err.message) || 'Voucher generation failed');
        setTimeout(function () { self.errorMsg(''); }, 5000);
      });
    };

    self.openContract = function (row) {
      sessionStorage.setItem('flContractId', String(row.contractId));
      if (window._jetApp) window._jetApp.navigate('contractDetail');
    };

    self.badgeFor = function (s) {
      return { PENDING: 'badge--pendingp', VOUCHER_GENERATED: 'badge--vchgen',
               PAID: 'badge--paid', SKIPPED: 'badge--cancelled' }[s] || 'badge--pendingp';
    };
    self.isOverdue = function (row) {
      return row.status === 'PENDING' && row.dueDate && row.dueDate < new Date().toISOString().substring(0, 10);
    };
  }

  return PaymentScheduleViewModel;
});
