/**
 * procash.js — Procash Transactions register (App 212 / AP).
 *
 * Read-side page: KPI band, filters, paged register. Everything that writes
 * lives on the entry page (procashEntry); a row click hands the id over
 * through the shell state bag.
 */
define(['knockout', 'services/procashService', 'shared/i18n'],
function (ko, procashService, i18n) {
  'use strict';

  function ProcashViewModel() {
    var self = this;
    self.t = i18n.t;

    self.loading = ko.observable(true);
    self.rows    = ko.observableArray([]);
    self.total   = ko.observable(0);
    self.limit   = ko.observable(50);
    self.offset  = ko.observable(0);

    self.search  = ko.observable('');
    self.fStatus = ko.observable('');
    self.fBu     = ko.observable('');
    self.fLinked = ko.observable('');
    self.fFrom   = ko.observable('');
    self.fTo     = ko.observable('');
    self.fMine   = ko.observable(false);

    self.statusLov = ko.observableArray([]);
    self.buLov     = ko.observableArray([]);
    self.canCreate = ko.observable(false);

    self.tableMax       = ko.observable(false);
    self.toggleTableMax = function () { self.tableMax(!self.tableMax()); };

    // ── formatting ──────────────────────────────────────────────────────
    self.num = function (v) {
      if (v === null || v === undefined || v === '') return '';
      return Number(v).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    };
    var STATUS_LABELS = {};
    self.statusLabel = function (code) { return STATUS_LABELS[code] || code; };
    self.pillCls = function (code) {
      var tone = 'pc-pill--info';
      if (code === 'PROCESSED' || code === 'APPROVED' || code === 'INVOICED') tone = 'pc-pill--ok';
      else if (code === 'REJECTED' || code === 'CANCELLED') tone = 'pc-pill--err';
      else if (code === 'DRAFT') tone = 'pc-pill--mute';
      else if (code === 'SUBMITTED' || code === 'IN_APPROVAL') tone = 'pc-pill--warn';
      return 'pc-pill ' + tone;
    };

    // ── KPI band ────────────────────────────────────────────────────────
    self.totals   = ko.observable({});
    self.kTotal   = ko.computed(function () { return (self.totals().count || 0).toLocaleString('en-US'); });
    self.kAmount  = ko.computed(function () { return self.num(self.totals().amountAed || 0); });
    self.kOpen    = ko.computed(function () { return (self.totals().openCount || 0).toLocaleString('en-US'); });
    self.kAwaiting = ko.computed(function () { return (self.totals().awaitingInvoice || 0).toLocaleString('en-US'); });

    // ── data ────────────────────────────────────────────────────────────
    function params() {
      return {
        status:   self.fStatus() || null,
        bu:       self.fBu() || null,
        linked:   self.fLinked() || null,
        from:     self.fFrom() || null,
        to:       self.fTo() || null,
        mine:     self.fMine() ? 'Y' : null,
        search:   self.search() || null,
        limit:    self.limit(),
        offset:   self.offset()
      };
    }

    self.load = function () {
      self.loading(true);
      return procashService.list(params()).then(function (d) {
        self.rows(d.items || []);
        self.total(d.total || 0);
        self.totals(d.totals || {});
        self.loading(false);
      }, function () {
        self.rows([]); self.total(0); self.totals({}); self.loading(false);
      });
    };

    self.reload = function () { self.offset(0); self.load(); };
    self.onPage = function () { self.load(); };

    var searchTimer = null;
    self.onSearchKey = function () {
      if (searchTimer) clearTimeout(searchTimer);
      searchTimer = setTimeout(self.reload, 350);
      return true;
    };

    self.resetFilters = function () {
      self.fStatus(''); self.fBu(''); self.fLinked(''); self.fFrom(''); self.fTo('');
      self.fMine(false); self.search('');
      self.reload();
    };

    // ── navigation ──────────────────────────────────────────────────────
    self.openRow = function (row) {
      window._jetApp.navigate('procashEntry', { procashId: row.procashId });
    };
    self.openNew = function () {
      window._jetApp.navigate('procashEntry', { procashId: null });
    };

    self.exportCsv = function () {
      var p = params();
      delete p.limit; delete p.offset;
      procashService.exportBlobUrl(p).then(function (url) {
        var a = document.createElement('a');
        a.href = url;
        a.download = 'procash-' + new Date().toISOString().slice(0, 10) + '.csv';
        document.body.appendChild(a); a.click(); document.body.removeChild(a);
        setTimeout(function () { URL.revokeObjectURL(url); }, 4000);
      });
    };

    // ── boot ────────────────────────────────────────────────────────────
    procashService.lovs().then(function (d) {
      (d.statuses || []).forEach(function (s) {
        STATUS_LABELS[s.code] = i18n.lang() === 'ar' && s.nameAr ? s.nameAr : s.nameEn;
      });
      self.statusLov((d.statuses || []).map(function (s) {
        return { code: s.code, label: STATUS_LABELS[s.code] };
      }));
      self.buLov(d.businessUnits || []);
      self.canCreate(d.canCreate === 'Y');
      self.rows.valueHasMutated();
    }, function () { /* pick lists are advisory — the register still loads */ });

    self.load();
  }

  return ProcashViewModel;
});
