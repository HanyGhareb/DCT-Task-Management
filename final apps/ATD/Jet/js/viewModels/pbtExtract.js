/**
 * Project Budget Transactions — extract console (App 208).
 *
 * Runs the PA_BUDGET_TRX action against the ADG_FIN VBCS app and monitors it:
 * parameters (type / date or range / BU / status) -> enqueue -> poll the action
 * row -> show worker VM, timings, row counts -> browse what landed.
 *
 * Monitoring is the action queue's own telemetry (db/19 + db/46), so a run is
 * traceable here AND on the Actions and Run Logs pages.
 */
define(['knockout', 'services/atdService', 'shared/i18n'],
function (ko, svc, i18n) {
  'use strict';

  var POLL_MS = 4000;
  var TERMINAL = ['DONE', 'FAILED', 'CANCELLED'];

  function PbtExtractViewModel() {
    var self = this;
    self.t = i18n.t;

    // ---- parameters -------------------------------------------------------
    self.types = ko.observableArray([]);          // from /pbt/summary
    self.fType = ko.observable('Additional');
    self.fMode = ko.observable('RANGE');
    self.fFrom = ko.observable('');
    self.fTo = ko.observable('');
    self.fBus = ko.observableArray([]);           // selected BU names
    self.fStatuses = ko.observableArray([]);
    self.fApprovals = ko.observable(true);
    self.fPurge = ko.observable(false);
    self.allBus = ko.observableArray([]);
    self.allStatuses = ko.observableArray([]);

    // ---- run + monitoring -------------------------------------------------
    self.busy = ko.observable(false);
    self.run = ko.observable(null);               // the live/last action row
    self.runs = ko.observableArray([]);
    self.summary = ko.observable(null);
    self.syncEnabled = ko.observable('N');
    self.error = ko.observable('');
    self.toast = ko.observable('');

    // ---- extracted-data register -----------------------------------------
    self.rows = ko.observableArray([]);
    self.total = ko.observable(0);
    self.page = ko.observable(1);
    self.size = ko.observable(100);
    self.dataBusy = ko.observable(false);
    self.qType = ko.observable('');
    self.qStatus = ko.observable('');
    self.qBu = ko.observable('');
    self.qSearch = ko.observable('');
    self.qFrom = ko.observable('');
    self.qTo = ko.observable('');

    // ---- drill drawer -----------------------------------------------------
    self.drawerOpen = ko.observable(false);
    self.drawerBusy = ko.observable(false);
    self.detail = ko.observable(null);

    self.isRunning = ko.computed(function () {
      var r = self.run();
      return !!r && TERMINAL.indexOf(r.status) < 0;
    });

    self.rangeNeeded = ko.computed(function () { return self.fMode() === 'RANGE'; });

    self.modeHint = ko.computed(function () {
      return self.t('atd.pbt.mode.' + self.fMode().toLowerCase() + '.hint');
    });

    self.pageCount = ko.computed(function () {
      return Math.max(1, Math.ceil(self.total() / self.size()));
    });

    // ---- loaders ----------------------------------------------------------
    self.loadSummary = function () {
      return svc.pbtSummary().then(function (r) {
        self.summary(r);
        self.types(r.types || []);
        self.syncEnabled(r.syncEnabled || 'N');
        self.allBus((r.byBu || []).map(function (b) { return b.bu; }).filter(Boolean));
        self.allStatuses((r.byStatus || []).map(function (s) { return s.status; }).filter(Boolean));
        if (!self.fBus().length) self.fBus(self.allBus().slice());
      }).catch(function (e) { self.error(e.message || String(e)); });
    };

    self.loadRuns = function () {
      return svc.pbtRuns({ limit: 25 }).then(function (r) {
        self.runs(r.items || []);
      }).catch(function (e) { self.error(e.message || String(e)); });
    };

    self.loadData = function () {
      self.dataBusy(true);
      return svc.pbtData({
        type: self.qType() || undefined,
        status: self.qStatus() || undefined,
        bu: self.qBu() || undefined,
        search: self.qSearch() || undefined,
        from: self.qFrom() || undefined,
        to: self.qTo() || undefined,
        page: self.page(),
        size: self.size()
      }).then(function (r) {
        self.rows(r.items || []);
        self.total(r.total || 0);
      }).catch(function (e) {
        self.error(e.message || String(e));
      }).then(function () { self.dataBusy(false); });
    };

    self.searchData = function () { self.page(1); self.loadData(); };
    self.prevPage = function () {
      if (self.page() > 1) { self.page(self.page() - 1); self.loadData(); }
    };
    self.nextPage = function () {
      if (self.page() < self.pageCount()) { self.page(self.page() + 1); self.loadData(); }
    };

    // ---- run --------------------------------------------------------------
    self.submit = function () {
      self.error('');
      var mode = self.fMode();
      if (mode === 'RANGE' && !self.fFrom() && !self.fTo()) {
        self.error(self.t('atd.pbt.err.rangeRequired'));
        return;
      }
      if (self.fFrom() && self.fTo() && self.fTo() < self.fFrom()) {
        self.error(self.t('atd.pbt.err.badRange'));
        return;
      }
      var body = {
        mode: mode,
        transactionTypes: self.fType() ? [self.fType()] : undefined,
        businessUnits: self.fBus().length ? self.fBus() : undefined,
        statuses: self.fStatuses().length ? self.fStatuses() : undefined,
        includeApprovals: !!self.fApprovals(),
        purgeMissing: !!self.fPurge()
      };
      if (mode === 'RANGE') {
        if (self.fFrom()) body.dateFrom = self.fFrom();
        if (self.fTo()) body.dateTo = self.fTo();
      }
      self.busy(true);
      svc.pbtRun(body).then(function (r) {
        self.toast(self.t('atd.pbt.queued') + ' #' + r.actionId);
        self.run({ actionId: r.actionId, status: r.status, mode: r.mode });
        self.poll(r.actionId);
        self.loadRuns();
      }).catch(function (e) {
        self.error(e.message || String(e));
      }).then(function () { self.busy(false); });
    };

    // Poll the action row until it reaches a terminal state. The queue is
    // drained by the fleet's idle loop, so a run may sit READY for a moment
    // before a worker claims it — that wait is itself worth showing.
    self.poll = function (id) {
      svc.pbtRunById(id).then(function (r) {
        self.run(r);
        if (TERMINAL.indexOf(r.status) < 0) {
          setTimeout(function () { self.poll(id); }, POLL_MS);
        } else {
          self.loadRuns();
          self.loadSummary();
          if (r.status === 'DONE') self.loadData();
        }
      }).catch(function (e) { self.error(e.message || String(e)); });
    };

    self.watchRun = function (row) { self.run(row); self.poll(row.actionId); };

    // ---- drill ------------------------------------------------------------
    self.openDetail = function (row) {
      self.drawerOpen(true);
      self.drawerBusy(true);
      self.detail(null);
      svc.pbtDetail(row.transactionNum, row.transactionType).then(function (r) {
        self.detail(r);
      }).catch(function (e) {
        self.error(e.message || String(e));
      }).then(function () { self.drawerBusy(false); });
    };
    self.closeDrawer = function () { self.drawerOpen(false); };

    // ---- helpers ----------------------------------------------------------
    self.toggleBu = function (bu) {
      var a = self.fBus();
      if (a.indexOf(bu) >= 0) self.fBus(a.filter(function (x) { return x !== bu; }));
      else self.fBus(a.concat([bu]));
    };
    self.hasBu = function (bu) { return self.fBus().indexOf(bu) >= 0; };
    self.toggleStatus = function (s) {
      var a = self.fStatuses();
      if (a.indexOf(s) >= 0) self.fStatuses(a.filter(function (x) { return x !== s; }));
      else self.fStatuses(a.concat([s]));
    };
    self.hasStatus = function (s) { return self.fStatuses().indexOf(s) >= 0; };

    self.statusClass = function (st) {
      if (st === 'DONE') return 'badge badge-success';
      if (st === 'FAILED' || st === 'CANCELLED') return 'badge badge-danger';
      if (st === 'CLAIMED') return 'badge badge-info';
      return 'badge';
    };

    self.num = function (v) {
      if (v === null || v === undefined || v === '') return '';
      return Number(v).toLocaleString('en-US', { maximumFractionDigits: 2 });
    };

    // ---- init -------------------------------------------------------------
    self.loadSummary();
    self.loadRuns();
    self.loadData();
  }

  return PbtExtractViewModel;
});
