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

    /* ── bulk generation (behind ALLOW_BULK_VOUCHER_GENERATION) ───────── */
    self.bulkAllowed   = ko.observable(false);
    self.showBulkModal = ko.observable(false);
    self.bulkRunning   = ko.observable(false);
    flService.getSettings().then(function (items) {
      var s = items.filter(function (x) { return x.key === 'ALLOW_BULK_VOUCHER_GENERATION'; })[0];
      self.bulkAllowed(!!s && String(s.value).toUpperCase() === 'Y');
    }).catch(function () {});

    self.openBulk = function () { self.showBulkModal(true); };
    self.runBulk  = function () {
      self.bulkRunning(true);
      flService.bulkGenerateVouchers({}).then(function (r) {
        self.bulkRunning(false);
        self.showBulkModal(false);
        self.successMsg(r.created === 0
          ? 'No pending rows without a voucher — nothing to generate.'
          : r.created + ' voucher(s) created (DRAFT).');
        setTimeout(function () { self.successMsg(''); }, 4000);
        self.reload();
      }).catch(function (err) {
        self.bulkRunning(false);
        self.showBulkModal(false);
        self.errorMsg((err && err.message) || 'Bulk generation failed');
        setTimeout(function () { self.errorMsg(''); }, 5000);
      });
    };

    self.generateVoucher = function (row) {
      flService.generateVoucher(row.scheduleId).then(function (r) {
        self.successMsg('Voucher ' + r.voucherNumber + ' generated — this period is now "Generated". ' +
                        'It becomes "Approved" when the voucher is approved, and "Paid" once payment is confirmed.');
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

    // The schedule row mirrors its voucher's lifecycle:
    // PENDING -> VOUCHER_GENERATED (voucher raised) -> VOUCHER_APPROVED -> PAID.
    self.badgeFor = function (s) {
      return { PENDING: 'badge--pendingp', VOUCHER_GENERATED: 'badge--vchgen',
               VOUCHER_APPROVED: 'badge--submitted', PAID: 'badge--paid',
               SKIPPED: 'badge--cancelled' }[s] || 'badge--pendingp';
    };
    self.statusLabel = function (s) {
      return { PENDING: 'Pending', VOUCHER_GENERATED: 'Generated',
               VOUCHER_APPROVED: 'Approved', PAID: 'Paid', SKIPPED: 'Skipped' }[s] || s;
    };
    self.isOverdue = function (row) {
      return row.status === 'PENDING' && row.dueDate && row.dueDate < new Date().toISOString().substring(0, 10);
    };
  }

  return PaymentScheduleViewModel;
});
