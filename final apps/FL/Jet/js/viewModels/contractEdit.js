define(['knockout', 'services/flService', 'shared/formGuard'], function (ko, flService, formGuard) {
  'use strict';

  function ContractEditViewModel() {
    var self = this;

    var editId = sessionStorage.getItem('flEditContractId') || 'new';
    self.isNew      = editId === 'new';
    self.contractId = ko.observable(self.isNew ? null : Number(editId));
    self.loading    = ko.observable(true);
    self.saving     = ko.observable(false);
    self.successMsg = ko.observable('');
    self.errorMsg   = ko.observable('');
    self.audit      = ko.observable(null);

    self.contractNumber = ko.observable('');
    self.status         = ko.observable('DRAFT');
    self.freelancerId   = ko.observable(null);
    self.title          = ko.observable('');
    self.startDate      = ko.observable('');
    self.endDate        = ko.observable('');
    self.totalAmount    = ko.observable('');
    self.billingMethod  = ko.observable('MONTHLY');
    self.billingUnitId  = ko.observable(null);
    self.billingUnitAmount = ko.observable('');
    self.orgId          = ko.observable(null);
    self.codingType     = ko.observable('GL');
    self.ccIdGl         = ko.observable(null);
    self.projectNumber  = ko.observable('');
    self.taskNumber     = ko.observable('');
    self.expenditureType = ko.observable('');
    self.notes          = ko.observable('');

    self.freelancerOptions = ko.observableArray([]);
    self.orgOptions        = ko.observableArray([]);
    self.billingUnits      = ko.observableArray([]);
    self.glOptions         = ko.observableArray([]);

    self.editable = ko.computed(function () { return self.isNew || self.status() === 'DRAFT'; });
    self.isPerCount = ko.computed(function () { return self.billingMethod() === 'PER_COUNT'; });

    // ── Review-mode display helpers (used by the .fl-readonly value twins when
    //    a submitted/active contract renders read-only via the form-layout scaffold)
    function lookupText(arr, keyField, valObs, textField) {
      var v = valObs(); if (v === null || v === undefined || v === '') return '';
      var hit = (arr() || []).filter(function (o) { return o[keyField] === v; })[0];
      return hit ? hit[textField] : '';
    }
    function aed(v) { return (v || v === 0) && v !== '' ? 'AED ' + Number(v).toLocaleString('en-US') : ''; }

    self.freelancerDisp  = ko.computed(function () { return lookupText(self.freelancerOptions, 'id', self.freelancerId, 'label') || '—'; });
    self.orgDisp         = ko.computed(function () { return lookupText(self.orgOptions, 'orgId', self.orgId, 'name') || '—'; });
    self.glDisp          = ko.computed(function () { return lookupText(self.glOptions, 'ccId', self.ccIdGl, 'ccCode') || '—'; });
    self.totalAmountDisp = ko.computed(function () { return aed(self.totalAmount()) || '—'; });
    self.endDateDisp     = ko.computed(function () { return self.endDate() || 'Open-ended'; });
    self.billingComboDisp = ko.computed(function () {
      var unit = lookupText(self.billingUnits, 'valueId', self.billingUnitId, 'name');
      var amt  = aed(self.billingUnitAmount()) || 'auto';
      return (unit ? unit + ' · ' : '') + amt;
    });

    Promise.all([
      flService.getLookups(),
      flService.getGlCodes(),
      flService.getFreelancers({ status: 'ACTIVE', limit: 200 })
    ]).then(function (rs) {
      self.billingUnits(rs[0].billingUnits || []);
      self.orgOptions(rs[0].orgs || []);
      self.glOptions(rs[1] || []);
      self.freelancerOptions((rs[2].items || []).map(function (f) {
        return { id: f.freelancerId, label: f.fullNameEn + ' (' + (f.vendorNumber || '-') + ')' };
      }));
      if (!self.isNew) {
        return flService.getContract(self.contractId()).then(function (c) {
          self.audit(c);
          self.contractNumber(c.contractNumber || '');
          self.status(c.status || 'DRAFT');
          self.freelancerId(c.freelancerId);
          self.title(c.title || '');
          self.startDate(c.startDate || '');
          self.endDate(c.endDate || '');
          self.totalAmount(c.totalAmount);
          self.billingMethod(c.billingMethod || 'MONTHLY');
          self.billingUnitId(c.billingUnitId);
          self.billingUnitAmount(c.billingUnitAmount);
          self.orgId(c.orgId);
          self.codingType(c.codingType || 'GL');
          self.ccIdGl(c.ccIdGl);
          self.projectNumber(c.projectNumber || '');
          self.taskNumber(c.taskNumber || '');
          self.expenditureType(c.expenditureType || '');
          self.notes(c.notes || '');
        });
      }
    }).then(function () { self.loading(false); initGuard(); })
      .catch(function () { self.loading(false); initGuard(); });

    function initGuard() {
      self._guard = formGuard.track([
        self.freelancerId, self.title, self.startDate, self.endDate,
        self.totalAmount, self.billingMethod, self.billingUnitId, self.billingUnitAmount,
        self.orgId, self.codingType, self.ccIdGl,
        self.projectNumber, self.taskNumber, self.expenditureType, self.notes
      ]);
    }

    function flash(m) { self.successMsg(m); setTimeout(function () { self.successMsg(''); }, 3000); }

    function payload() {
      return {
        freelancerId: self.freelancerId(),
        title: self.title().trim(),
        startDate: self.startDate(),
        endDate: self.endDate() || null,
        totalAmount: Number(self.totalAmount()),
        billingMethod: self.billingMethod(),
        billingUnitId: self.billingUnitId() || null,
        billingUnitAmount: self.billingUnitAmount() ? Number(self.billingUnitAmount()) : null,
        orgId: self.orgId(),
        codingType: self.codingType(),
        ccIdGl: self.codingType() === 'GL' ? self.ccIdGl() : null,
        projectNumber: self.codingType() === 'PROJECT' ? self.projectNumber().trim() : null,
        taskNumber: self.codingType() === 'PROJECT' ? self.taskNumber().trim() : null,
        expenditureType: self.codingType() === 'PROJECT' ? self.expenditureType().trim() : null,
        notes: self.notes().trim()
      };
    }

    function validate() {
      self.errorMsg('');
      if (!self.freelancerId()) { self.errorMsg('Freelancer is required.'); return false; }
      if (!self.title().trim()) { self.errorMsg('Title is required.'); return false; }
      if (!self.startDate())    { self.errorMsg('Start date is required.'); return false; }
      if (!Number(self.totalAmount()) || Number(self.totalAmount()) <= 0) {
        self.errorMsg('A positive total amount is required.'); return false;
      }
      if (!self.orgId())        { self.errorMsg('Organisation is required.'); return false; }
      if (self.codingType() === 'GL' && !self.ccIdGl()) {
        self.errorMsg('A GL code combination is required.'); return false;
      }
      if (self.codingType() === 'PROJECT' && !self.projectNumber().trim()) {
        self.errorMsg('A project number is required for PROJECT coding.'); return false;
      }
      return true;
    }

    self.saveDraft = function () {
      if (!validate()) return null;
      self.saving(true);
      var op = self.isNew
        ? flService.createContract(payload()).then(function (r) {
            self.isNew = false;
            self.contractId(r.contractId);
            self.contractNumber(r.contractNumber);
            sessionStorage.setItem('flEditContractId', String(r.contractId));
            return r;
          })
        : flService.updateContract(self.contractId(), payload());
      return op.then(function (r) {
        self.saving(false);
        flash('Saved.');
        if (self._guard) self._guard.reset();
        return r;
      }).catch(function (err) {
        self.saving(false);
        self.errorMsg((err && err.message) || 'Save failed');
        throw err;
      });
    };

    self.submit = function () {
      var save = self.saveDraft();
      if (!save) return;
      save.then(function () {
        return flService.submitContract(self.contractId());
      }).then(function () {
        self.status('SUBMITTED');
        flash('Submitted for approval.');
        setTimeout(function () {
          sessionStorage.setItem('flContractId', String(self.contractId()));
          if (window._jetApp) window._jetApp.navigate('contractDetail');
        }, 800);
      }).catch(function (err) {
        if (err && err.message) self.errorMsg(err.message);
      });
    };

    self.back = function () { if (window._jetApp) window._jetApp.navigate('contracts'); };
  }

  return ContractEditViewModel;
});
