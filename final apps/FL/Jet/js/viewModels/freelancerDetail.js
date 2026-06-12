define(['knockout', 'services/flService'], function (ko, flService) {
  'use strict';

  function FreelancerDetailViewModel() {
    var self = this;

    var id = Number(sessionStorage.getItem('flFreelancerId') || 0);
    self.flId    = id;
    self.loading = ko.observable(true);
    self.tab     = ko.observable('profile');
    self.data    = ko.observable({});
    self.bankAccounts = ko.observableArray([]);
    self.contracts    = ko.observableArray([]);
    self.documents    = ko.observableArray([]);
    self.successMsg   = ko.observable('');
    self.errorMsg     = ko.observable('');
    self.photoSrc     = ko.observable('');
    self.docTypes     = ko.observableArray([]);

    function flash(m) { self.successMsg(m); setTimeout(function () { self.successMsg(''); }, 3000); }

    flService.getLookups().then(function (lk) { self.docTypes(lk.docTypes || []); }).catch(function () {});

    self.reload = function () {
      flService.getFreelancer(id).then(function (r) {
        self.data(r);
        self.bankAccounts(r.bankAccounts || []);
        self.contracts(r.contracts || []);
        self.photoSrc('https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/fl/freelancers/' + id + '/photo?t=' + Date.now());
        self.loading(false);
      }).catch(function () { self.loading(false); });
      flService.getDocuments({ freelancerId: id, limit: 100 }).then(function (r) {
        self.documents(r.items || []);
      }).catch(function () {});
    };
    self.reload();

    self.setTab = function (t) { self.tab(t); };

    /* ── status change ──────────────────────────────────────────────── */
    self.showStatusModal = ko.observable(false);
    self.newStatus       = ko.observable('ACTIVE');
    self.statusReason    = ko.observable('');
    self.openStatus  = function () {
      self.newStatus(self.data().status || 'ACTIVE');
      self.statusReason('');
      self.showStatusModal(true);
    };
    self.saveStatus = function () {
      var p = { status: self.newStatus() };
      if (self.newStatus() === 'BLACKLISTED') {
        if (!self.statusReason().trim()) { self.errorMsg('A blacklist reason is required'); return; }
        p.blacklistReason = self.statusReason().trim();
      }
      flService.updateFreelancer(id, p).then(function () {
        self.showStatusModal(false);
        flash('Status updated.');
        self.reload();
      }).catch(function (err) { self.errorMsg((err && err.message) || 'Update failed'); });
    };

    /* ── bank accounts ──────────────────────────────────────────────── */
    self.showBankModal = ko.observable(false);
    self.bForm = {
      bankName: ko.observable(''), accountNumber: ko.observable(''), iban: ko.observable(''),
      accountName: ko.observable(''), isPrimary: ko.observable(false)
    };
    self.openBank = function () {
      self.bForm.bankName(''); self.bForm.accountNumber(''); self.bForm.iban('');
      self.bForm.accountName(self.data().fullNameEn || ''); self.bForm.isPrimary(self.bankAccounts().length === 0);
      self.showBankModal(true);
    };
    self.saveBank = function () {
      if (!self.bForm.bankName().trim() || !self.bForm.accountNumber().trim() || !self.bForm.accountName().trim()) {
        self.errorMsg('Bank, account number and account name are required'); return;
      }
      flService.addBankAccount(id, {
        bankName: self.bForm.bankName().trim(),
        accountNumber: self.bForm.accountNumber().trim(),
        iban: self.bForm.iban().trim(),
        accountName: self.bForm.accountName().trim(),
        isPrimary: self.bForm.isPrimary() ? 'Y' : 'N'
      }).then(function () {
        self.showBankModal(false);
        flash('Bank account added.');
        self.reload();
      }).catch(function (err) { self.errorMsg((err && err.message) || 'Save failed'); });
    };
    self.makePrimary = function (acc) {
      flService.updateBankAccount(acc.bankAccountId, { isPrimary: 'Y' }).then(function () {
        flash('Primary account updated.');
        self.reload();
      }).catch(function () {});
    };

    /* ── documents ──────────────────────────────────────────────────── */
    self.showDocModal = ko.observable(false);
    self.dForm = {
      docTypeId: ko.observable(null), documentName: ko.observable(''),
      expiryDate: ko.observable(''), isRequired: ko.observable(true)
    };
    self.openDoc = function () {
      self.dForm.docTypeId(null); self.dForm.documentName(''); self.dForm.expiryDate('');
      self.dForm.isRequired(true);
      self.showDocModal(true);
    };
    self.saveDoc = function () {
      if (!self.dForm.docTypeId() || !self.dForm.documentName().trim()) {
        self.errorMsg('Document type and name are required'); return;
      }
      flService.createDocument({
        freelancerId: id, sourceType: 'FREELANCER',
        docTypeId: self.dForm.docTypeId(),
        documentName: self.dForm.documentName().trim(),
        expiryDate: self.dForm.expiryDate() || null,
        isRequired: self.dForm.isRequired() ? 'Y' : 'N'
      }).then(function () {
        self.showDocModal(false);
        flash('Document added.');
        self.reload();
      }).catch(function (err) { self.errorMsg((err && err.message) || 'Save failed'); });
    };

    self.expChip = function (s) {
      return { VALID: 'exp-chip--valid', EXPIRING_SOON: 'exp-chip--soon', EXPIRED: 'exp-chip--expired' }[s] || 'exp-chip--valid';
    };
    self.statusBadge = function (s) {
      return { ACTIVE: 'badge--approved', INACTIVE: 'badge--draft', BLACKLISTED: 'badge--blacklisted' }[s] || 'badge--draft';
    };
    self.conBadge = function (s) {
      return { DRAFT: 'badge--draft', SUBMITTED: 'badge--submitted', ACTIVE: 'badge--approved',
               COMPLETED: 'badge--completed', CANCELLED: 'badge--cancelled' }[s] || 'badge--draft';
    };

    self.openContract = function (c) {
      sessionStorage.setItem('flContractId', String(c.contractId));
      if (window._jetApp) window._jetApp.navigate('contractDetail');
    };
    self.back = function () { if (window._jetApp) window._jetApp.navigate('freelancers'); };
  }

  return FreelancerDetailViewModel;
});
