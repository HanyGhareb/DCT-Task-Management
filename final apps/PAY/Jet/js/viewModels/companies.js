define(['knockout', 'services/payService', 'services/authService', 'shared/i18n', 'shared/docUpload'],
function (ko, payService, authService, i18n, docUpload) {
  'use strict';

  function CompaniesViewModel() {
    var self = this;
    self.t = i18n.t;

    self.isAdmin = authService.hasRole('PAY_ADMIN') || authService.hasRole('SYS_ADMIN');

    // ── Lookups (from /boot) ────────────────────────────────────────────
    self.statusLov   = ko.observableArray([]);
    self.categoryLov = ko.observableArray([]);
    self.purposeLov  = ko.observableArray([]);
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

    self.search    = ko.observable('');
    self.fStatus   = ko.observable('');
    self.fCategory = ko.observable('');

    self.tableCollapsed = ko.observable(false);
    self.tableMax       = ko.observable(false);
    self.toggleTable    = function () { self.tableCollapsed(!self.tableCollapsed()); };
    self.toggleTableMax = function () { self.tableMax(!self.tableMax()); };

    self.badgeCls = function (status) {
      if (status === 'ACTIVE') return 'badge badge--success';
      if (status === 'SUSPENDED') return 'badge badge--warn';
      return 'badge badge--danger';
    };

    self.load = function () {
      self.loading(true);
      payService.getCompanies({
        search: self.search(), status: self.fStatus(), cat: self.fCategory(),
        limit: self.limit(), offset: self.offset()
      }).then(function (d) {
        self.rows(d.items || []);
        self.total(d.total || 0);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };
    self.onPage = function () { self.load(); };   // pager already moved offset()

    var reload = function () { self.offset(0); self.load(); };
    self.search.subscribe(function () { clearTimeout(self._st); self._st = setTimeout(reload, 350); });
    self.fStatus.subscribe(reload);
    self.fCategory.subscribe(reload);

    self.exportCsv = function () {
      var cols = ['code', 'nameEn', 'categoryName', 'status', 'trn', 'contactName', 'contactEmail', 'supplierRefs', 'activeContracts'];
      var lines = [cols.join(',')];
      self.rows().forEach(function (r) {
        lines.push(cols.map(function (c) {
          return '"' + String(r[c] === undefined || r[c] === null ? '' : r[c]).replace(/"/g, '""') + '"';
        }).join(','));
      });
      var blob = new Blob(['﻿' + lines.join('\n')], { type: 'text/csv;charset=utf-8' });
      var a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = 'pay-companies.csv';
      a.click();
    };

    // ── Drawer state ────────────────────────────────────────────────────
    self.dwOpen  = ko.observable(false);
    self.dwMax   = ko.observable(false);
    self.dwError = ko.observable('');
    self.dwOk    = ko.observable('');
    self.saving  = ko.observable(false);
    self.tab     = ko.observable('profile');
    self.toggleDwMax = function () { self.dwMax(!self.dwMax()); };

    self.form = {
      companyId: ko.observable(null),
      code: ko.observable(''), nameEn: ko.observable(''), nameAr: ko.observable(''),
      category: ko.observable('MANPOWER'), status: ko.observable('ACTIVE'),
      trn: ko.observable(''), licenseNo: ko.observable(''),
      phone: ko.observable(''), email: ko.observable(''), website: ko.observable(''),
      addressEn: ko.observable(''), addressAr: ko.observable(''),
      contactName: ko.observable(''), contactEmail: ko.observable(''), contactPhone: ko.observable(''),
      notes: ko.observable(''), isActive: ko.observable('Y')
    };
    self.dwTitle = ko.computed(function () {
      return self.form.companyId()
        ? (self.form.code() + ' — ' + self.form.nameEn())
        : i18n.t('co.drawerNew');
    });

    self.suppliers = ko.observableArray([]);
    self.docs      = ko.observableArray([]);

    function fillForm(d) {
      self.form.companyId(d.companyId || null);
      self.form.code(d.code || ''); self.form.nameEn(d.nameEn || ''); self.form.nameAr(d.nameAr || '');
      self.form.category(d.category || 'MANPOWER'); self.form.status(d.status || 'ACTIVE');
      self.form.trn(d.trn || ''); self.form.licenseNo(d.licenseNo || '');
      self.form.phone(d.phone || ''); self.form.email(d.email || ''); self.form.website(d.website || '');
      self.form.addressEn(d.addressEn || ''); self.form.addressAr(d.addressAr || '');
      self.form.contactName(d.contactName || ''); self.form.contactEmail(d.contactEmail || '');
      self.form.contactPhone(d.contactPhone || '');
      self.form.notes(d.notes || ''); self.form.isActive(d.isActive || 'Y');
      self.suppliers(d.suppliers || []);
    }

    self.openNew = function () {
      fillForm({}); self.suppliers([]); self.docs([]);
      self.tab('profile'); self.dwError(''); self.dwOk('');
      self.supEditing(false);
      self.dwOpen(true);
    };

    self.openEdit = function (row) {
      self.dwError(''); self.dwOk(''); self.tab('profile'); self.supEditing(false);
      payService.getCompany(row.companyId).then(function (d) {
        fillForm(d);
        self.dwOpen(true);
        self.loadDocs();
      }).catch(function () { self.dwError(i18n.t('err.load')); self.dwOpen(true); });
    };

    self.closeDw = function () { self.dwOpen(false); self.dwMax(false); };

    function formBody() {
      return {
        code: self.form.code(), nameEn: self.form.nameEn(), nameAr: self.form.nameAr(),
        category: self.form.category(), status: self.form.status(),
        trn: self.form.trn(), licenseNo: self.form.licenseNo(),
        phone: self.form.phone(), email: self.form.email(), website: self.form.website(),
        addressEn: self.form.addressEn(), addressAr: self.form.addressAr(),
        contactName: self.form.contactName(), contactEmail: self.form.contactEmail(),
        contactPhone: self.form.contactPhone(),
        notes: self.form.notes(), isActive: self.form.isActive()
      };
    }

    self.save = function () {
      self.dwError(''); self.dwOk(''); self.saving(true);
      var p = self.form.companyId()
        ? payService.updateCompany(self.form.companyId(), formBody())
        : payService.createCompany(formBody());
      p.then(function (d) {
        self.saving(false);
        if (d && d.companyId) self.form.companyId(d.companyId);
        self.dwOk(i18n.t('dr.saved'));
        self.load();
      }).catch(function (e) {
        self.saving(false);
        self.dwError((e && e.message) || i18n.t('err.save'));
      });
    };

    // ── Supplier references sub-editor ──────────────────────────────────
    self.supEditing = ko.observable(false);
    self.supSearch  = ko.observable('');
    self.supLov     = ko.observableArray([]);
    self.supForm = {
      supplierRefId: ko.observable(null),
      supplierNumber: ko.observable(''), supplierName: ko.observable(''),
      supplierSite: ko.observable(''), purpose: ko.observable('ALL'),
      bankName: ko.observable(''), iban: ko.observable(''), bankAccountNo: ko.observable(''),
      currency: ko.observable('AED'), paymentMethod: ko.observable(''),
      payGroup: ko.observable(''), paymentTerms: ko.observable(''),
      isDefault: ko.observable('N'), isActive: ko.observable('Y')
    };

    self.supSearch.subscribe(function (v) {
      clearTimeout(self._lt);
      if (!v || v.length < 2) { self.supLov([]); return; }
      self._lt = setTimeout(function () {
        payService.lovSuppliers(v).then(function (d) { self.supLov(d.items || []); });
      }, 300);
    });

    function fillSupForm(s) {
      self.supForm.supplierRefId(s.supplierRefId || null);
      self.supForm.supplierNumber(s.supplierNumber || '');
      self.supForm.supplierName(s.supplierName || '');
      self.supForm.supplierSite(s.supplierSite || '');
      self.supForm.purpose(s.purpose || 'ALL');
      self.supForm.bankName(s.bankName || ''); self.supForm.iban(s.iban || '');
      self.supForm.bankAccountNo(s.bankAccountNo || '');
      self.supForm.currency(s.currency || 'AED');
      self.supForm.paymentMethod(s.paymentMethod || '');
      self.supForm.payGroup(s.payGroup || ''); self.supForm.paymentTerms(s.paymentTerms || '');
      self.supForm.isDefault(s.isDefault || 'N'); self.supForm.isActive(s.isActive || 'Y');
    }

    self.supNew  = function () { fillSupForm({}); self.supSearch(''); self.supLov([]); self.supEditing(true); };
    self.supEdit = function (s) { if (!self.isAdmin) return; fillSupForm(s); self.supSearch(''); self.supLov([]); self.supEditing(true); };
    self.supCancel = function () { self.supEditing(false); };
    self.supToggleDefault = function () {
      self.supForm.isDefault(self.supForm.isDefault() === 'Y' ? 'N' : 'Y');
    };
    self.supPick = function (item) {
      self.supForm.supplierNumber(item.supplierNumber);
      self.supForm.supplierName(item.supplierName);
      if (item.bankName) self.supForm.bankName(item.bankName);
      if (item.iban) self.supForm.iban(item.iban);
      if (item.bankAccountNo) self.supForm.bankAccountNo(item.bankAccountNo);
      if (item.currency) self.supForm.currency(item.currency);
      if (item.payGroup) self.supForm.payGroup(item.payGroup);
      self.supLov([]); self.supSearch('');
    };

    self.supSave = function () {
      self.dwError(''); self.dwOk(''); self.saving(true);
      var body = {
        companyId: self.form.companyId(),
        supplierNumber: self.supForm.supplierNumber(), supplierName: self.supForm.supplierName(),
        supplierSite: self.supForm.supplierSite(), purpose: self.supForm.purpose(),
        bankName: self.supForm.bankName(), iban: self.supForm.iban(),
        bankAccountNo: self.supForm.bankAccountNo(), currency: self.supForm.currency(),
        paymentMethod: self.supForm.paymentMethod(), payGroup: self.supForm.payGroup(),
        paymentTerms: self.supForm.paymentTerms(),
        isDefault: self.supForm.isDefault(), isActive: self.supForm.isActive()
      };
      var p = self.supForm.supplierRefId()
        ? payService.updateSupplierRef(self.supForm.supplierRefId(), body)
        : payService.addSupplierRef(self.form.companyId(), body);
      p.then(function () {
        self.saving(false); self.supEditing(false);
        return payService.getCompany(self.form.companyId()).then(function (d) {
          self.suppliers(d.suppliers || []);
          self.load();
        });
      }).catch(function (e) {
        self.saving(false);
        self.dwError((e && e.message) || i18n.t('err.save'));
      });
    };

    // ── Documents ───────────────────────────────────────────────────────
    self.loadDocs = function () {
      if (!self.form.companyId()) { self.docs([]); return; }
      payService.getDocs('PAY_COMPANY', self.form.companyId()).then(function (d) {
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
        payService.uploadDoc('PAY_COMPANY', self.form.companyId(), file)
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
      self.statusLov(lov(b, 'PAY_COMPANY_STATUS'));
      self.categoryLov(lov(b, 'PAY_COMPANY_CATEGORY'));
      self.purposeLov(lov(b, 'PAY_SUPPLIER_PURPOSE'));
      self.maxUploadMb = b.maxUploadMb || 10;
      if (b.isPayAdmin) self.isAdmin = true;
    });
    self.load();
  }

  return CompaniesViewModel;
});
