/**
 * procashEntry.js — create / edit / progress one procash transaction.
 *
 * The server owns every rule (DCT_AP_PROCASH_PKG): this VM mirrors the state
 * it is told about (canEdit / canProcess / canUnlink / findings) rather than
 * re-deciding it, so a permission or lifecycle change is a data change.
 *
 * The record id arrives through the shell state bag (_jetApp.getState()), set
 * by the register page; a null id means "new".
 */
define(['knockout', 'services/procashService', 'shared/i18n', 'shared/docUpload'],
function (ko, procashService, i18n, docUpload) {
  'use strict';

  function ProcashEntryViewModel() {
    var self = this;
    self.t = i18n.t;

    var state = (window._jetApp && window._jetApp.getState()) || {};
    self.procashId = ko.observable(state.procashId || null);

    // ── header fields ───────────────────────────────────────────────────
    self.paymentNumber  = ko.observable('');
    self.bankReference  = ko.observable('');
    self.bankAccount    = ko.observable('');
    self.businessUnit   = ko.observable('');
    self.supplierNumber = ko.observable('');
    self.supplierName   = ko.observable('');
    self.payeeName      = ko.observable('');
    self.amount         = ko.observable(null);
    self.currencyCode   = ko.observable('AED');
    self.exchangeRate   = ko.observable(1);
    self.paymentDate    = ko.observable(new Date().toISOString().slice(0, 10));
    self.description    = ko.observable('');
    self.comments       = ko.observable('');
    self.status         = ko.observable('DRAFT');
    self.createdBy      = ko.observable('');
    self.createdOn      = ko.observable('');

    self.invoiceId       = ko.observable(0);
    self.invoiceNumber   = ko.observable('');
    self.invoiceSupplier = ko.observable('');
    self.invoiceDate     = ko.observable('');
    self.invoiceAmount   = ko.observable(0);
    self.invoiceCurrency = ko.observable('');
    self.invoiceLinkedBy = ko.observable('');
    self.invoiceLinkedOn = ko.observable('');
    self.amountMismatch  = ko.observable('');

    self.lines     = ko.observableArray([]);
    self.documents = ko.observableArray([]);
    self.history   = ko.observableArray([]);
    self.findings  = ko.observableArray([]);
    self.lineTotal = ko.observable(0);

    self.saving    = ko.observable(false);
    self.uploading = ko.observable(false);
    self.tab       = ko.observable('lines');

    // ── permissions, as reported by the server ──────────────────────────
    self.canEditFlag   = ko.observable(true);
    self.canProcessFlag = ko.observable(false);
    self.canUnlinkFlag  = ko.observable(false);
    self.approvalMode   = ko.observable('NONE');

    self.canEdit = ko.computed(function () {
      return !self.procashId() || self.canEditFlag();
    });
    self.canSubmit = ko.computed(function () {
      return !!self.procashId() && ['DRAFT', 'REJECTED'].indexOf(self.status()) >= 0 && self.canEditFlag();
    });
    self.canProcess = ko.computed(function () {
      var want = self.approvalMode() === 'WORKFLOW' ? 'APPROVED' : 'SUBMITTED';
      return !!self.procashId() && self.status() === want && self.canProcessFlag();
    });
    self.canLink = ko.computed(function () {
      return !!self.procashId() && self.status() === 'PROCESSED';
    });
    self.canUnlink = ko.computed(function () {
      return !!self.procashId() && self.status() === 'INVOICED' && self.canUnlinkFlag();
    });
    self.canCancel = ko.computed(function () {
      return !!self.procashId() && ['CANCELLED', 'INVOICED'].indexOf(self.status()) < 0;
    });
    self.canAttach = ko.computed(function () {
      return !!self.procashId() && self.status() !== 'CANCELLED';
    });

    // ── pick lists ──────────────────────────────────────────────────────
    self.buLov       = ko.observableArray([]);
    self.currencyLov = ko.observableArray([]);
    self.docTypeLov  = ko.observableArray([]);
    self.projectLov  = ko.observableArray([]);
    self.taskLov     = ko.observableArray([]);
    self.etypeLov    = ko.observableArray([]);
    self.glLov       = ko.observableArray([]);
    self.uploadType  = ko.observable('OTHER');
    self.supplierLovRaw = ko.observableArray([]);
    self.supSearch      = ko.observable('');
    self.glSearch       = ko.observable('');

    // A KO <select> whose option list is still empty at bind time BLANKS its
    // bound value, so the currency and business unit have to be re-applied once
    // the pick lists land — whichever order the two arrive in.
    var wantCcy = 'AED', wantBu = '';
    self.currencyCode.subscribe(function (v) { if (v) wantCcy = v; });
    self.businessUnit.subscribe(function (v) { if (v) wantBu = v; });
    function restoreSelects() {
      if (!self.currencyCode() && wantCcy) self.currencyCode(wantCcy);
      if (!self.businessUnit() && wantBu) self.businessUnit(wantBu);
    }

    // A KO `options:` binding BLANKS a bound value that is absent from the
    // list, so every dropdown re-injects whatever is stored as its own option.
    // That is what keeps a line coded to a retired project (or to a code typed
    // through the API / Excel, which are no longer validated) readable here.
    function optsWith(rawObs, valueObs, labelFor) {
      return ko.computed(function () {
        var list = (rawObs() || []).map(function (x) {
          return { code: x.code, label: labelFor ? labelFor(x) : x.code };
        });
        var v = valueObs();
        if (v && !list.some(function (o) { return o.code === v; })) {
          list.unshift({ code: v, label: v });
        }
        return list;
      });
    }
    var codeName = function (x) { return x.name ? x.code + ' — ' + x.name : x.code; };

    var STATUS_LABELS = {};
    var BASIS_LABELS  = {};
    self.statusLabel = function (code) { return code ? (STATUS_LABELS[code] || code) : ''; };
    self.basisLabel  = function (code) { return BASIS_LABELS[code] || code; };
    self.pillCls = function (code) {
      var tone = 'pc-pill--info';
      if (code === 'PROCESSED' || code === 'APPROVED' || code === 'INVOICED') tone = 'pc-pill--ok';
      else if (code === 'REJECTED' || code === 'CANCELLED') tone = 'pc-pill--err';
      else if (code === 'DRAFT') tone = 'pc-pill--mute';
      else if (code === 'SUBMITTED' || code === 'IN_APPROVAL') tone = 'pc-pill--warn';
      return 'pc-pill ' + tone;
    };

    self.num = function (v) {
      if (v === null || v === undefined || v === '') return '';
      return Number(v).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    };
    self.kb = function (bytes) {
      if (!bytes) return '';
      return bytes < 1024 * 1024
        ? Math.round(bytes / 1024) + ' KB'
        : (bytes / 1024 / 1024).toFixed(1) + ' MB';
    };

    self.supplierLov = optsWith(self.supplierLovRaw, self.supplierNumber, codeName);
    self.projectOpts = optsWith(self.projectLov, function () { return self.lProject && self.lProject(); }, codeName);
    self.taskOpts    = optsWith(self.taskLov,    function () { return self.lTask && self.lTask(); },    codeName);
    self.etypeOpts   = optsWith(self.etypeLov,   function () { return self.lEtype && self.lEtype(); },  codeName);
    self.glOpts      = optsWith(self.glLov,      function () { return self.lGl && self.lGl(); },
                                function (x) { return x.account ? x.code + ' — ' + x.account : x.code; });

    self.pageTitle = ko.computed(function () {
      return self.procashId()
        ? i18n.t('pc.entryTitle') + ' ' + self.paymentNumber()
        : i18n.t('pc.entryNew');
    });
    self.amountAedDisplay = ko.computed(function () {
      var a = parseFloat(self.amount()), r = parseFloat(self.exchangeRate());
      if (isNaN(a) || isNaN(r)) return '';
      return self.num(Math.round(a * r * 100) / 100);
    });
    self.balanced = ko.computed(function () {
      return Math.abs((parseFloat(self.amount()) || 0) - (self.lineTotal() || 0)) < 0.005;
    });

    // ── load ────────────────────────────────────────────────────────────
    function fill(d) {
      self.paymentNumber(d.paymentNumber || '');
      self.bankReference(d.bankReference || '');
      self.bankAccount(d.bankAccount || '');
      self.businessUnit(d.businessUnit || '');
      self.supplierNumber(d.supplierNumber || '');
      self.supplierName(d.supplierName || '');
      self.payeeName(d.payeeName || '');
      self.amount(d.amount);
      self.currencyCode(d.currencyCode || 'AED');
      self.exchangeRate(d.exchangeRate);
      self.paymentDate(d.paymentDate || '');
      self.description(d.description || '');
      self.comments(d.comments || '');
      self.status(d.status || 'DRAFT');
      self.createdBy(d.createdBy || '');
      self.createdOn(d.createdOn || '');
      self.invoiceId(d.invoiceId || 0);
      self.invoiceNumber(d.invoiceNumber || '');
      self.invoiceSupplier(d.invoiceSupplier || '');
      self.invoiceDate(d.invoiceDate || '');
      self.invoiceAmount(d.invoiceAmount || 0);
      self.invoiceCurrency(d.invoiceCurrency || '');
      self.invoiceLinkedBy(d.invoiceLinkedBy || '');
      self.invoiceLinkedOn(d.invoiceLinkedOn || '');
      self.amountMismatch(d.amountMismatch || '');
      self.lines(d.lines || []);
      self.documents(d.documents || []);
      self.history(d.history || []);
      self.findings(d.findings || []);
      self.lineTotal(d.lineTotal || 0);
      self.canEditFlag(d.canEdit === 'Y');
      self.canProcessFlag(d.canProcess === 'Y');
      self.canUnlinkFlag(d.canUnlink === 'Y');
      self.approvalMode(d.approvalMode || 'NONE');
      restoreSelects();
    }

    self.reload = function () {
      if (!self.procashId()) return Promise.resolve();
      return procashService.get(self.procashId()).then(fill);
    };

    function fail(e) {
      window.alert((e && (e.message || e.error)) || i18n.t('pc.errGeneric'));
    }

    // ── header actions ──────────────────────────────────────────────────
    self.onCurrency = function () {
      var c = (self.currencyCode() || '').toUpperCase();
      if (c === 'AED') { self.exchangeRate(1); return true; }
      var hit = self.currencyLov().filter(function (x) { return x.code === c; })[0];
      if (hit) self.exchangeRate(hit.rate);
      return true;
    };

    function body() {
      return {
        bankReference:  self.bankReference(),
        bankAccount:    self.bankAccount(),
        businessUnit:   self.businessUnit(),
        supplierNumber: self.supplierNumber(),
        supplierName:   self.supplierName(),
        payeeName:      self.payeeName(),
        amount:         parseFloat(self.amount()),
        currencyCode:   self.currencyCode(),
        exchangeRate:   parseFloat(self.exchangeRate()),
        paymentDate:    self.paymentDate(),
        description:    self.description(),
        comments:       self.comments()
      };
    }

    self.save = function () {
      self.saving(true);
      var p = self.procashId()
        ? procashService.update(self.procashId(), body())
        : procashService.create(body());
      return p.then(function (d) {
        self.saving(false);
        if (!self.procashId()) self.procashId(d.procashId);
        return self.reload();
      }, function (e) { self.saving(false); fail(e); });
    };

    self.submitTrx = function () {
      return procashService.submit(self.procashId()).then(self.reload, fail);
    };
    self.processTrx = function () {
      return procashService.process(self.procashId()).then(self.reload, fail);
    };
    self.cancelTrx = function () {
      if (!window.confirm(i18n.t('pc.confirmCancel'))) return;
      return procashService.cancel(self.procashId()).then(self.reload, fail);
    };
    self.unlinkInvoice = function () {
      if (!window.confirm(i18n.t('pc.confirmUnlink'))) return;
      return procashService.unlinkInvoice(self.procashId()).then(self.reload, fail);
    };
    self.goBack = function () { window._jetApp.navigate('procash'); };

    // ── lines ───────────────────────────────────────────────────────────
    self.lineDwOpen  = ko.observable(false);
    self.lineDwTitle = ko.observable('');
    self.lLineId   = ko.observable(null);
    self.lBasis    = ko.observable('PROJECT');
    self.lProject  = ko.observable('');
    self.lTask     = ko.observable('');
    self.lEtype    = ko.observable('');
    self.lGl       = ko.observable('');
    self.lAmount   = ko.observable(null);
    self.lComments = ko.observable('');

    self.addLine = function () {
      self.lLineId(null); self.lBasis('PROJECT');
      self.lProject(''); self.lTask(''); self.lEtype(''); self.lGl('');
      self.lAmount(null); self.lComments('');
      self.lineDwTitle(i18n.t('pc.addLine'));
      self.lineDwOpen(true);
    };
    self.editLine = function (line) {
      self.lLineId(line.lineId);
      self.lBasis(line.codingBasis);
      self.lProject(line.projectNumber || '');
      self.lTask(line.taskNumber || '');
      self.lEtype(line.expenditureType || '');
      self.lGl(line.glCombination || '');
      self.lAmount(line.amount);
      self.lComments(line.comments || '');
      self.lineDwTitle(i18n.t('pc.editLine') + ' ' + line.lineNum);
      self.lineDwOpen(true);
      if (line.projectNumber) loadTasks(line.projectNumber);
      if (line.glCombination) {
        self.glSearch(line.glCombination);
        procashService.glCombos(line.glCombination).then(function (d) { self.glLov(d.items || []); });
      }
    };
    self.closeLineDw = function () { self.lineDwOpen(false); };

    self.saveLine = function () {
      var payload = {
        codingBasis:     self.lBasis(),
        projectNumber:   self.lBasis() === 'PROJECT' ? self.lProject() : null,
        taskNumber:      self.lBasis() === 'PROJECT' ? self.lTask() : null,
        expenditureType: self.lBasis() === 'PROJECT' ? self.lEtype() : null,
        glCombination:   self.lBasis() === 'GL' ? self.lGl() : null,
        amount:          parseFloat(self.lAmount()),
        comments:        self.lComments()
      };
      var p = self.lLineId()
        ? procashService.updateLine(self.procashId(), self.lLineId(), payload)
        : procashService.addLine(self.procashId(), payload);
      return p.then(function () {
        self.lineDwOpen(false);
        return self.reload();
      }, fail);
    };

    self.removeLine = function (line) {
      if (!window.confirm(i18n.t('pc.confirmRemoveLine'))) return;
      return procashService.deleteLine(self.procashId(), line.lineId).then(self.reload, fail);
    };

    // datalist feeds — debounced so typing does not hammer the API
    function debounce(fn) {
      var t = null;
      return function () {
        if (t) clearTimeout(t);
        t = setTimeout(fn, 300);
        return true;
      };
    }
    function loadTasks(project) {
      if (!project) { self.taskLov([]); return; }
      procashService.tasks(project, null).then(function (d) { self.taskLov(d.items || []); },
                                               function () { self.taskLov([]); });
    }
    self.onProjectPick = function () {
      self.lTask('');
      loadTasks(self.lProject());
      return true;
    };
    // The GL chart runs to thousands of combinations, so the dropdown is fed by
    // a search rather than listing all of them; picking is still strict.
    self.onGlSearch = debounce(function () {
      procashService.glCombos(self.glSearch()).then(function (d) { self.glLov(d.items || []); });
    });
    self.onSupSearch = debounce(function () {
      procashService.suppliers(self.supSearch()).then(function (d) { self.supplierLovRaw(d.items || []); });
    });
    self.onSupplierPick = function () {
      var hit = (self.supplierLovRaw() || []).filter(function (x) { return x.code === self.supplierNumber(); })[0];
      if (hit) {
        self.supplierName(hit.name);
        self.payeeName(hit.name);
      }
      return true;
    };

    // ── documents ───────────────────────────────────────────────────────
    self.uploadDoc = function () {
      docUpload.choose({ accept: '.pdf,.png,.jpg,.jpeg,.xlsx,.docx,.msg,.eml', maxMb: 10 })
        .then(function (file) {
          if (!file) return null;
          self.uploading(true);
          return procashService.uploadDoc(self.procashId(), file, self.uploadType())
            .then(function () { self.uploading(false); return self.reload(); },
                  function (e) { self.uploading(false); fail(e); });
        });
    };
    self.viewDoc = function (doc) {
      var w = window.open('', '_blank');           // opened synchronously or the blocker eats it
      procashService.docFileUrl(self.procashId(), doc.docId).then(function (url) {
        if (w) w.location = url; else window.location = url;
      }, function (e) { if (w) w.close(); fail(e); });
    };
    self.removeDoc = function (doc) {
      if (!window.confirm(i18n.t('pc.confirmRemoveDoc'))) return;
      return procashService.removeDoc(self.procashId(), doc.docId).then(self.reload, fail);
    };

    // ── invoice picker ──────────────────────────────────────────────────
    self.invDwOpen = ko.observable(false);
    self.invSearch = ko.observable('');
    self.invRows   = ko.observableArray([]);

    function loadInvoices() {
      return procashService.invoices({ search: self.invSearch() || null, bu: self.businessUnit() || null })
        .then(function (d) { self.invRows(d.items || []); }, function () { self.invRows([]); });
    }
    self.openInvoicePicker = function () {
      self.invSearch(''); self.invRows([]);
      self.invDwOpen(true);
      loadInvoices();
    };
    self.closeInvDw = function () { self.invDwOpen(false); };
    self.onInvSearch = debounce(loadInvoices);
    self.pickInvoice = function (row) {
      return procashService.linkInvoice(self.procashId(), { invoiceId: row.invoiceId })
        .then(function () { self.invDwOpen(false); return self.reload(); }, fail);
    };

    // ── boot ────────────────────────────────────────────────────────────
    procashService.lovs().then(function (d) {
      (d.statuses || []).forEach(function (s) {
        STATUS_LABELS[s.code] = i18n.lang() === 'ar' && s.nameAr ? s.nameAr : s.nameEn;
      });
      (d.codingBases || []).forEach(function (b) {
        BASIS_LABELS[b.code] = i18n.lang() === 'ar' && b.nameAr ? b.nameAr : b.nameEn;
      });
      self.buLov(d.businessUnits || []);
      self.currencyLov(d.currencies || []);
      restoreSelects();
      self.docTypeLov((d.docTypes || []).map(function (x) {
        return { code: x.code, label: i18n.lang() === 'ar' && x.nameAr ? x.nameAr : x.nameEn };
      }));
      if (self.docTypeLov().length) self.uploadType(self.docTypeLov()[0].code);
      self.approvalMode(d.approvalMode || 'NONE');
      self.canProcessFlag(d.canProcess === 'Y');
      self.status.valueHasMutated();
    });

    procashService.projects(null).then(function (d) { self.projectLov(d.items || []); });
    procashService.etypes(null).then(function (d) { self.etypeLov(d.items || []); });
    procashService.suppliers(null).then(function (d) { self.supplierLovRaw(d.items || []); });
    procashService.glCombos(null).then(function (d) { self.glLov(d.items || []); });

    self.reload();
  }

  return ProcashEntryViewModel;
});
