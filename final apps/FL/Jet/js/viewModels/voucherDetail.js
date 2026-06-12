define(['knockout', 'services/flService', 'services/authService'], function (ko, flService, authService) {
  'use strict';

  function VoucherDetailViewModel() {
    var self = this;

    var id = Number(sessionStorage.getItem('flVoucherId') || 0);
    self.loading    = ko.observable(true);
    self.data       = ko.observable({});
    self.successMsg = ko.observable('');
    self.errorMsg   = ko.observable('');
    self.saving     = ko.observable(false);

    self.invoiceNumber = ko.observable('');
    self.invoiceDate   = ko.observable('');
    self.paymentMethod = ko.observable('');
    self.notes         = ko.observable('');

    var user = authService.getCurrentUser() || { roles: [] };
    self.isAdmin = (user.roles || []).indexOf('FL_ADMIN') >= 0 || (user.roles || []).indexOf('SYS_ADMIN') >= 0;

    function flash(m) { self.successMsg(m); setTimeout(function () { self.successMsg(''); }, 3000); }

    self.reload = function () {
      flService.getVoucher(id).then(function (v) {
        self.data(v);
        self.invoiceNumber(v.invoiceNumber || '');
        self.invoiceDate(v.invoiceDate || '');
        self.paymentMethod(v.paymentMethod || 'BANK_TRANSFER');
        self.notes(v.notes || '');
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };
    self.reload();

    self.editable = ko.computed(function () { return self.data().status === 'DRAFT'; });

    self.saveDraft = function () {
      self.saving(true);
      self.errorMsg('');
      return flService.updateVoucher(id, {
        invoiceNumber: self.invoiceNumber().trim(),
        invoiceDate:   self.invoiceDate() || null,
        paymentMethod: self.paymentMethod(),
        notes:         self.notes().trim()
      }).then(function () {
        self.saving(false);
        flash('Saved.');
      }).catch(function (err) {
        self.saving(false);
        self.errorMsg((err && err.message) || 'Save failed');
        throw err;
      });
    };

    self.submit = function () {
      self.saveDraft().then(function () {
        return flService.submitVoucher(id);
      }).then(function () {
        flash('Submitted for approval.');
        self.reload();
      }).catch(function (err) {
        if (err && err.message) self.errorMsg(err.message);
      });
    };

    self.markPaid = function () {
      flService.markVoucherPaid(id, {}).then(function () {
        flash('Payment confirmed.');
        self.reload();
      }).catch(function (err) { self.errorMsg((err && err.message) || 'Payment confirmation failed'); });
    };

    self.statusBadge = function (s) {
      return { DRAFT: 'badge--draft', SUBMITTED: 'badge--submitted', APPROVED: 'badge--approved',
               REJECTED: 'badge--rejected', CANCELLED: 'badge--cancelled' }[s] || 'badge--draft';
    };
    self.payBadge = function (s) {
      return { PENDING: 'badge--pendingp', PAID: 'badge--paid', CANCELLED: 'badge--cancelled' }[s] || 'badge--pendingp';
    };

    self.openContract = function () {
      sessionStorage.setItem('flContractId', String(self.data().contractId));
      if (window._jetApp) window._jetApp.navigate('contractDetail');
    };
    self.back = function () { if (window._jetApp) window._jetApp.navigate('vouchers'); };
  }

  return VoucherDetailViewModel;
});
