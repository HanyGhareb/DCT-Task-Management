define(['knockout', 'services/payService', 'services/authService', 'shared/i18n', 'shared/docUpload'],
function (ko, payService, authService, i18n, docUpload) {
  'use strict';

  function ContractsViewModel() {
    var self = this;
    self.t = i18n.t;

    self.isAdmin = authService.hasRole('PAY_ADMIN') || authService.hasRole('SYS_ADMIN');

    // ── Lookups ─────────────────────────────────────────────────────────
    self.statusLov  = ko.observableArray([]);
    self.buLov      = ko.observableArray([]);
    self.methodLov  = ko.observableArray([]);
    self.basisLov   = ko.observableArray([]);
    self.scopeLov   = ko.observableArray([]);
    self.companyLov = ko.observableArray([]);
    self.supplierRefLov = ko.observableArray([]);
    self.maxUploadMb = 10;

    function lov(boot, cat) {
      return (boot.lookups || []).filter(function (l) { return l.category === cat; })
        .map(function (l) { return { code: l.code, name: i18n.lang() === 'ar' && l.nameAr ? l.nameAr : l.nameEn }; });
    }

    // ── Register state ──────────────────────────────────────────────────
    self.loading = ko.observable(true);
    self.rows    = ko.observableArray([]);
    self.total   = ko.observable(0);
    self.limit   = ko.observable(50);
    self.offset  = ko.observable(0);

    self.search   = ko.observable('');
    self.fCompany = ko.observable('');
    self.fStatus  = ko.observable('');
    self.fBu      = ko.observable('');
    self.fExpOnly = ko.observable(false);
    self.toggleExpOnly = function () { self.fExpOnly(!self.fExpOnly()); };

    self.tableCollapsed = ko.observable(false);
    self.tableMax       = ko.observable(false);
    self.toggleTable    = function () { self.tableCollapsed(!self.tableCollapsed()); };
    self.toggleTableMax = function () { self.tableMax(!self.tableMax()); };

    self.badgeCls = function (status) {
      if (status === 'ACTIVE') return 'badge badge--success';
      if (status === 'DRAFT') return 'badge badge--warn';
      if (status === 'SUPERSEDED') return 'badge badge--idle';
      return 'badge badge--danger';
    };

    self.load = function () {
      self.loading(true);
      payService.getContracts({
        search: self.search(), companyid: self.fCompany(), status: self.fStatus(),
        bu: self.fBu(), expiring: self.fExpOnly() ? 60 : '',
        limit: self.limit(), offset: self.offset()
      }).then(function (d) {
        self.rows(d.items || []);
        self.total(d.total || 0);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };
    self.onPage = function () { self.load(); };

    var reload = function () { self.offset(0); self.load(); };
    self.search.subscribe(function () { clearTimeout(self._st); self._st = setTimeout(reload, 350); });
    self.fCompany.subscribe(reload);
    self.fStatus.subscribe(reload);
    self.fBu.subscribe(reload);
    self.fExpOnly.subscribe(reload);

    self.exportCsv = function () {
      var cols = ['contractNo', 'company', 'titleEn', 'status', 'dateFrom', 'dateTo', 'buCode', 'currency', 'vatRate', 'marginRules', 'versionNo'];
      var lines = [cols.join(',')];
      self.rows().forEach(function (r) {
        lines.push(cols.map(function (c) {
          return '"' + String(r[c] === undefined || r[c] === null ? '' : r[c]).replace(/"/g, '""') + '"';
        }).join(','));
      });
      var blob = new Blob(['﻿' + lines.join('\n')], { type: 'text/csv;charset=utf-8' });
      var a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = 'pay-contracts.csv';
      a.click();
    };

    // ── Drawer state ────────────────────────────────────────────────────
    self.dwOpen  = ko.observable(false);
    self.dwMax   = ko.observable(false);
    self.dwError = ko.observable('');
    self.dwOk    = ko.observable('');
    self.saving  = ko.observable(false);
    self.tab     = ko.observable('details');
    self.toggleDwMax = function () { self.dwMax(!self.dwMax()); };

    self.form = {
      contractId: ko.observable(null),
      companyId: ko.observable(''), contractNo: ko.observable(''),
      titleEn: ko.observable(''), titleAr: ko.observable(''),
      status: ko.observable('DRAFT'),
      dateFrom: ko.observable(''), dateTo: ko.observable(''),
      buCode: ko.observable(''), supplierRefId: ko.observable(''),
      currency: ko.observable('AED'), serviceFee: ko.observable(''),
      vatRate: ko.observable(5), renewalAlertDays: ko.observable(60),
      expiryBlocking: ko.observable('N'),
      notes: ko.observable(''), isActive: ko.observable('Y')
    };
    self.dwTitle = ko.computed(function () {
      return self.form.contractId()
        ? (self.form.contractNo() + ' · v' + (self._versionNo || 1))
        : i18n.t('ct.drawerNew');
    });

    self.marginRules = ko.observableArray([]);
    self.versions    = ko.observableArray([]);
    self.docs        = ko.observableArray([]);

    self.toggleExpiryBlocking = function () {
      self.form.expiryBlocking(self.form.expiryBlocking() === 'Y' ? 'N' : 'Y');
    };

    // supplier refs of the selected company feed the site-scope select
    self.form.companyId.subscribe(function (cid) {
      if (!cid) { self.supplierRefLov([]); return; }
      payService.getCompany(cid).then(function (d) {
        self.supplierRefLov((d.suppliers || []).filter(function (s) { return s.isActive === 'Y'; }));
      });
    });

    function fillForm(d) {
      self._versionNo = d.versionNo || 1;
      self.form.contractId(d.contractId || null);
      self.form.companyId(d.companyId || '');
      self.form.contractNo(d.contractNo || '');
      self.form.titleEn(d.titleEn || ''); self.form.titleAr(d.titleAr || '');
      self.form.status(d.status || 'DRAFT');
      self.form.dateFrom(d.dateFrom || ''); self.form.dateTo(d.dateTo || '');
      self.form.buCode(d.buCode || '');
      self.form.supplierRefId(d.supplierRefId || '');
      self.form.currency(d.currency || 'AED');
      self.form.serviceFee(d.serviceFee || '');
      self.form.vatRate(d.vatRate !== undefined ? d.vatRate : 5);
      self.form.renewalAlertDays(d.renewalAlertDays || 60);
      self.form.expiryBlocking(d.expiryBlocking || 'N');
      self.form.notes(d.notes || ''); self.form.isActive(d.isActive || 'Y');
      self.marginRules(d.marginRules || []);
      self.versions(d.versions || []);
    }

    self.openNew = function () {
      fillForm({}); self.docs([]);
      self.tab('details'); self.dwError(''); self.dwOk('');
      self.mrEditing(false);
      self.dwOpen(true);
    };

    self.openEdit = function (row) {
      self.dwError(''); self.dwOk(''); self.tab('details'); self.mrEditing(false);
      payService.getContract(row.contractId).then(function (d) {
        fillForm(d);
        self.dwOpen(true);
        self.loadDocs();
      }).catch(function () { self.dwError(i18n.t('err.load')); self.dwOpen(true); });
    };
    self.openVersion = function (v) { self.openEdit({ contractId: v.contractId }); };

    self.closeDw = function () { self.dwOpen(false); self.dwMax(false); };

    function formBody() {
      return {
        companyId: self.form.companyId(), contractNo: self.form.contractNo(),
        titleEn: self.form.titleEn(), titleAr: self.form.titleAr(),
        status: self.form.status(),
        dateFrom: self.form.dateFrom(), dateTo: self.form.dateTo(),
        buCode: self.form.buCode(),
        supplierRefId: self.form.supplierRefId() || null,
        currency: self.form.currency(), serviceFee: self.form.serviceFee(),
        vatRate: self.form.vatRate(), renewalAlertDays: self.form.renewalAlertDays(),
        expiryBlocking: self.form.expiryBlocking(),
        notes: self.form.notes(), isActive: self.form.isActive()
      };
    }

    self.save = function () {
      self.dwError(''); self.dwOk(''); self.saving(true);
      var p = self.form.contractId()
        ? payService.updateContract(self.form.contractId(), formBody())
        : payService.createContract(formBody());
      p.then(function (d) {
        self.saving(false);
        var id = (d && d.contractId) || self.form.contractId();
        self.dwOk(i18n.t('dr.saved'));
        self.load();
        return payService.getContract(id).then(fillForm);
      }).catch(function (e) {
        self.saving(false);
        self.dwError((e && e.message) || i18n.t('err.save'));
      });
    };

    self.amend = function () {
      var newNo = window.prompt(i18n.t('ct.amendPrompt'), self.form.contractNo() + '-A' + ((self._versionNo || 1)));
      if (!newNo) return;
      self.dwError(''); self.dwOk(''); self.saving(true);
      payService.amendContract(self.form.contractId(), { newContractNo: newNo }).then(function (d) {
        self.saving(false);
        self.dwOk(i18n.t('ct.amendDone'));
        self.load();
        return payService.getContract(d.contractId).then(function (full) {
          fillForm(full);
          self.loadDocs();
        });
      }).catch(function (e) {
        self.saving(false);
        self.dwError((e && e.message) || i18n.t('err.save'));
      });
    };

    // ── Margin rules sub-editor ─────────────────────────────────────────
    self.mrEditing = ko.observable(false);
    self.mrForm = {
      ruleId: ko.observable(null),
      effectiveFrom: ko.observable(''), effectiveTo: ko.observable(''),
      method: ko.observable('PERCENT'), basis: ko.observable('GROSS'),
      rateValue: ko.observable(''), vatApplicable: ko.observable('Y'),
      paymentScope: ko.observable('ALL'), notes: ko.observable(''),
      isActive: ko.observable('Y')
    };

    function fillMrForm(m) {
      self.mrForm.ruleId(m.ruleId || null);
      self.mrForm.effectiveFrom(m.effectiveFrom || self.form.dateFrom() || '');
      self.mrForm.effectiveTo(m.effectiveTo || '');
      self.mrForm.method(m.method || 'PERCENT');
      self.mrForm.basis(m.basis || 'GROSS');
      self.mrForm.rateValue(m.rateValue !== undefined ? m.rateValue : '');
      self.mrForm.vatApplicable(m.vatApplicable || 'Y');
      self.mrForm.paymentScope(m.paymentScope || 'ALL');
      self.mrForm.notes(m.notes || '');
      self.mrForm.isActive(m.isActive || 'Y');
    }

    self.mrNew    = function () { fillMrForm({}); self.mrEditing(true); };
    self.mrEdit   = function (m) { if (!self.isAdmin) return; fillMrForm(m); self.mrEditing(true); };
    self.mrCancel = function () { self.mrEditing(false); };
    self.mrToggleVat = function () {
      self.mrForm.vatApplicable(self.mrForm.vatApplicable() === 'Y' ? 'N' : 'Y');
    };

    self.mrSave = function () {
      self.dwError(''); self.dwOk(''); self.saving(true);
      var body = {
        contractId: self.form.contractId(),
        effectiveFrom: self.mrForm.effectiveFrom(), effectiveTo: self.mrForm.effectiveTo(),
        method: self.mrForm.method(), basis: self.mrForm.basis(),
        rateValue: self.mrForm.rateValue(), vatApplicable: self.mrForm.vatApplicable(),
        paymentScope: self.mrForm.paymentScope(), notes: self.mrForm.notes(),
        isActive: self.mrForm.isActive()
      };
      var p = self.mrForm.ruleId()
        ? payService.updateMarginRule(self.mrForm.ruleId(), body)
        : payService.addMarginRule(self.form.contractId(), body);
      p.then(function () {
        self.saving(false); self.mrEditing(false);
        return payService.getContract(self.form.contractId()).then(function (d) {
          self.marginRules(d.marginRules || []);
          self.load();
        });
      }).catch(function (e) {
        self.saving(false);
        self.dwError((e && e.message) || i18n.t('err.save'));
      });
    };

    // ── Documents ───────────────────────────────────────────────────────
    self.loadDocs = function () {
      if (!self.form.contractId()) { self.docs([]); return; }
      payService.getDocs('PAY_CONTRACT', self.form.contractId()).then(function (d) {
        self.docs(d.items || []);
      });
    };
    self.fmtSize = function (b) {
      if (!b) return '';
      if (b < 1024) return b + ' B';
      if (b < 1048576) return Math.round(b / 1024) + ' KB';
      return (b / 1048576).toFixed(1) + ' MB';
    };
    self.docUpload = function () {
      docUpload.choose({ maxMb: self.maxUploadMb }).then(function (file) {
        if (!file) return;
        self.dwError('');
        payService.uploadDoc('PAY_CONTRACT', self.form.contractId(), file)
          .then(self.loadDocs)
          .catch(function (e) { self.dwError((e && e.message) || i18n.t('err.save')); });
      });
    };
    self.docView = function (doc) {
      var w = window.open('', '_blank');
      payService.docFileUrl(doc.docId).then(function (url) { w.location = url; })
        .catch(function () { w.close(); });
    };
    self.docDelete = function (doc) {
      if (!window.confirm(i18n.t('doc.confirmDelete'))) return;
      payService.deleteDoc(doc.docId).then(self.loadDocs);
    };

    // ── Boot ────────────────────────────────────────────────────────────
    payService.boot().then(function (b) {
      self.statusLov(lov(b, 'PAY_CONTRACT_STATUS'));
      self.buLov(lov(b, 'PAY_BU'));
      self.methodLov(lov(b, 'PAY_MARGIN_METHOD'));
      self.basisLov(lov(b, 'PAY_MARGIN_BASIS'));
      self.scopeLov(lov(b, 'PAY_PAYMENT_SCOPE'));
      self.maxUploadMb = b.maxUploadMb || 10;
      if (b.isPayAdmin) self.isAdmin = true;
    });
    payService.getCompanies({ limit: 200 }).then(function (d) {
      self.companyLov(d.items || []);
    });
    self.load();

    // deep-link from the dashboard's expiring table
    var state = (window._jetApp && window._jetApp.getState && window._jetApp.getState()) || {};
    if (state.openContractId) {
      var cid = state.openContractId;
      delete state.openContractId;
      self.openEdit({ contractId: cid });
    }
  }

  return ContractsViewModel;
});
