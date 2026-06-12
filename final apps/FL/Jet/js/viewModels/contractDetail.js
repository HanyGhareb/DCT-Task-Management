define(['knockout', 'services/flService'], function (ko, flService) {
  'use strict';

  function ContractDetailViewModel() {
    var self = this;

    var id = Number(sessionStorage.getItem('flContractId') || 0);
    self.contractId = id;
    self.loading    = ko.observable(true);
    self.tab        = ko.observable('schedule');
    self.data       = ko.observable({});
    self.schedule   = ko.observableArray([]);
    self.amendments = ko.observableArray([]);
    self.renewals   = ko.observableArray([]);
    self.successMsg = ko.observable('');
    self.errorMsg   = ko.observable('');

    function flash(m) { self.successMsg(m); setTimeout(function () { self.successMsg(''); }, 3000); }

    self.reload = function () {
      Promise.all([
        flService.getContract(id),
        flService.getContractSchedule(id),
        flService.getAmendments(id),
        flService.getRenewals(id)
      ]).then(function (rs) {
        self.data(rs[0]);
        self.schedule(rs[1]);
        self.amendments(rs[2]);
        self.renewals(rs[3]);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };
    self.reload();

    self.setTab = function (t) { self.tab(t); };

    self.billPct = ko.computed(function () {
      var d = self.data();
      return d.totalAmount ? Math.min(100, Math.round((d.paidTotal || 0) / d.totalAmount * 100)) : 0;
    });

    self.submit = function () {
      flService.submitContract(id).then(function () {
        flash('Submitted for approval.');
        self.reload();
      }).catch(function (err) { self.errorMsg((err && err.message) || 'Submit failed'); });
    };

    self.generateVoucher = function (row) {
      flService.generateVoucher(row.scheduleId).then(function (r) {
        flash('Voucher ' + r.voucherNumber + ' created (DRAFT).');
        sessionStorage.setItem('flVoucherId', String(r.voucherId));
        if (window._jetApp) window._jetApp.navigate('voucherDetail');
      }).catch(function (err) { self.errorMsg((err && err.message) || 'Voucher generation failed'); });
    };

    /* amendment modal */
    self.showAmdModal = ko.observable(false);
    self.aForm = {
      reason: ko.observable(''), changeSummary: ko.observable(''),
      newTotalAmount: ko.observable(''), newEndDate: ko.observable('')
    };
    self.openAmendment = function () {
      self.aForm.reason(''); self.aForm.changeSummary('');
      self.aForm.newTotalAmount(''); self.aForm.newEndDate('');
      self.showAmdModal(true);
    };
    self.saveAmendment = function () {
      if (!self.aForm.reason().trim()) { self.errorMsg('A reason is required'); return; }
      flService.createAmendment(id, {
        reason: self.aForm.reason().trim(),
        changeSummary: self.aForm.changeSummary().trim(),
        newTotalAmount: self.aForm.newTotalAmount() ? Number(self.aForm.newTotalAmount()) : null,
        newEndDate: self.aForm.newEndDate() || null
      }).then(function () {
        self.showAmdModal(false);
        flash('Amendment created (DRAFT).');
        self.reload();
      }).catch(function (err) { self.errorMsg((err && err.message) || 'Save failed'); });
    };
    self.submitAmendment = function (a) {
      flService.submitAmendment(a.amendmentId).then(function () {
        flash('Amendment submitted.');
        self.reload();
      }).catch(function (err) { self.errorMsg((err && err.message) || 'Submit failed'); });
    };

    /* renewal modal */
    self.showRnlModal = ko.observable(false);
    self.rForm = {
      newStartDate: ko.observable(''), newEndDate: ko.observable(''),
      newTotalAmount: ko.observable(''), reason: ko.observable('')
    };
    self.openRenewal = function () {
      var d = self.data();
      self.rForm.newStartDate(''); self.rForm.newEndDate('');
      self.rForm.newTotalAmount(d.totalAmount || ''); self.rForm.reason('');
      self.showRnlModal(true);
    };
    self.saveRenewal = function () {
      if (!self.rForm.newStartDate() || !self.rForm.newTotalAmount() || !self.rForm.reason().trim()) {
        self.errorMsg('Start date, amount and reason are required'); return;
      }
      flService.createRenewal({
        originalContractId: id,
        newStartDate: self.rForm.newStartDate(),
        newEndDate: self.rForm.newEndDate() || null,
        newTotalAmount: Number(self.rForm.newTotalAmount()),
        reason: self.rForm.reason().trim()
      }).then(function () {
        self.showRnlModal(false);
        flash('Renewal created (DRAFT).');
        self.reload();
      }).catch(function (err) { self.errorMsg((err && err.message) || 'Save failed'); });
    };
    self.submitRenewal = function (r) {
      flService.submitRenewal(r.renewalId).then(function () {
        flash('Renewal submitted.');
        self.reload();
      }).catch(function (err) { self.errorMsg((err && err.message) || 'Submit failed'); });
    };

    self.schedBadge = function (s) {
      return { PENDING: 'badge--pendingp', VOUCHER_GENERATED: 'badge--vchgen',
               PAID: 'badge--paid', SKIPPED: 'badge--cancelled' }[s] || 'badge--pendingp';
    };
    self.statusBadge = function (s) {
      return { DRAFT: 'badge--draft', SUBMITTED: 'badge--submitted', APPROVED: 'badge--approved',
               ACTIVE: 'badge--approved', COMPLETED: 'badge--completed', CANCELLED: 'badge--cancelled',
               REJECTED: 'badge--rejected' }[s] || 'badge--draft';
    };

    self.openEdit = function () {
      sessionStorage.setItem('flEditContractId', String(id));
      if (window._jetApp) window._jetApp.navigate('contractEdit');
    };
    self.back = function () { if (window._jetApp) window._jetApp.navigate('contracts'); };
  }

  return ContractDetailViewModel;
});
