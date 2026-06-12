define(['knockout', 'services/arService', 'shared/i18n', 'shared/toast'],
function (ko, arService, i18n, toast) {
  'use strict';

  function EventDetailViewModel() {
    var self = this;
    self.t = i18n.t;
    self.fmt = function (n) {
      if (n === null || n === undefined) return '—';
      return i18n.fmtNum ? i18n.fmtNum(n, 0) : String(n);
    };

    var state = window._arApp.getState();
    self.eventId = state.eventId;

    self.activeTab = ko.observable(state.tab || 'overview');
    self.setTab = function (tab) { self.activeTab(tab); };

    self.event        = ko.observable(null);
    self.pnlSummary   = ko.observableArray([]);
    self.completeness = ko.observableArray([]);
    self.files        = ko.observableArray([]);
    self.lines        = ko.observableArray([]);
    self.findings     = ko.observableArray([]);
    self.kpis         = ko.observableArray([]);
    self.docCats      = ko.observableArray([]);
    self.pnlCats      = ko.observableArray([]);
    self.loading      = ko.observable(true);

    self.processing   = ko.observable(false);
    self.progress     = ko.observable(null);

    // P&L filters
    self.typeFilter   = ko.observable('');
    self.basisFilter  = ko.observable('');
    self.statusFilter = ko.observable('');
    self.pnlTotal     = ko.observable(0);
    self.pnlLimit     = ko.observable(200);
    self.pnlOffset    = ko.observable(0);

    self.draftCount = ko.computed(function () {
      return self.lines().filter(function (l) { return l.reviewStatus === 'DRAFT'; }).length;
    });

    /* ── helpers ──────────────────────────────────────────────────────── */
    self.confClass = function (c) {
      if (c === null || c === undefined) return '';
      return c >= 85 ? 'ar-conf ar-conf--hi' : (c >= 60 ? 'ar-conf ar-conf--md' : 'ar-conf ar-conf--lo');
    };
    self.chipClass = function (s) {
      var map = { DRAFT: 'ar-chip ar-chip--draft', CONFIRMED: 'ar-chip ar-chip--confirmed',
                  REJECTED: 'ar-chip ar-chip--rejected', BUDGET: 'ar-chip ar-chip--budget',
                  ACTUAL: 'ar-chip ar-chip--actual', FORECAST: 'ar-chip ar-chip--forecast' };
      return map[s] || 'ar-chip ar-chip--draft';
    };
    self.statusClass = function (s) {
      var map = { NEW: 'badge badge--neutral', FILES_UPLOADED: 'badge badge--info',
                  AI_PROCESSING: 'badge badge--warning', UNDER_REVIEW: 'badge badge--warning',
                  CONFIRMED: 'badge badge--success', CLOSED: 'badge badge--neutral' };
      return map[s] || 'badge badge--neutral';
    };

    /* ── loaders ──────────────────────────────────────────────────────── */
    function loadEvent() {
      return arService.getEvent(self.eventId).then(function (e) {
        self.event(e);
        self.pnlSummary(e.pnlSummary || []);
        self.completeness(e.completeness || []);
      });
    }
    function loadFiles() {
      return arService.getFiles(self.eventId).then(function (res) {
        var items = (res.items || []).map(function (f) {
          f._selCat = ko.observable(f.docCatId || f.aiDocCatId || null);
          return f;
        });
        self.files(items);
      });
    }
    function loadPnl() {
      return arService.getPnl(self.eventId, {
        type:    self.typeFilter() || null,
        basis:   self.basisFilter() || null,
        rstatus: self.statusFilter() || null,
        limit:   self.pnlLimit(),
        offset:  self.pnlOffset(),
      }).then(function (res) {
        self.pnlTotal(res.total || 0);
        var items = (res.items || []).map(function (l) {
          l._selCat = ko.observable(l.categoryId || null);
          return l;
        });
        self.lines(items);
      });
    }
    function loadFindings() {
      return arService.getFindings(self.eventId).then(function (res) { self.findings(res.items || []); });
    }
    function loadKpis() {
      return arService.getKpis(self.eventId).then(function (res) { self.kpis(res.items || []); });
    }

    self.reloadAll = function () {
      self.loading(true);
      Promise.all([loadEvent(), loadFiles(), loadPnl(), loadFindings(), loadKpis()])
        .then(function () { self.loading(false); })
        .catch(function () { self.loading(false); toast.error('Failed to load event'); });
    };

    self.reloadPnl = function () { loadPnl().catch(function () {}); };
    self.typeFilter.subscribe(self.reloadPnl);
    self.basisFilter.subscribe(self.reloadPnl);
    self.statusFilter.subscribe(self.reloadPnl);

    /* ── actions ──────────────────────────────────────────────────────── */
    self.editEvent = function () {
      window._arApp.navigate('eventForm', { eventId: self.eventId });
    };
    self.openUpload = function () {
      window._arApp.navigate('uploadWizard', { eventId: self.eventId });
    };
    self.openWhatIf = function () {
      window._arApp.navigate('whatIf', { eventId: self.eventId });
    };
    self.openReport = function () {
      window._arApp.navigate('reports', { eventId: self.eventId });
    };

    var _pollTimer = null;
    function _poll() {
      arService.getProgress(self.eventId).then(function (p) {
        self.progress(p);
        if (p.eventStatus === 'AI_PROCESSING') {
          _pollTimer = setTimeout(_poll, 4000);
        } else {
          self.processing(false);
          toast.success('AI processing finished');
          self.reloadAll();
        }
      }).catch(function () { _pollTimer = setTimeout(_poll, 6000); });
    }

    self.runAi = function () {
      self.processing(true);
      arService.startProcessing(self.eventId, 'BOTH').then(function () {
        toast.info('AI processing started…');
        _poll();
      }).catch(function (err) {
        self.processing(false);
        toast.error((err && err.message) || 'Failed to start AI');
      });
    };

    // per-file AI retry — shown when classification or extraction FAILED
    self.retryFile = function (f) {
      self.processing(true);
      arService.retryFile(f.fileId).then(function () {
        toast.info('Retrying AI for "' + f.fileName + '"…');
        _poll();
      }).catch(function (err) {
        self.processing(false);
        toast.error((err && err.message) || 'Retry failed');
      });
    };

    self.confirmFileCat = function (f) {
      var catId = f._selCat();
      if (!catId) { toast.error('Select a category first'); return; }
      arService.confirmClassification(f.fileId, catId).then(function () {
        toast.success('Classification confirmed');
        loadFiles();
      }).catch(function (err) { toast.error((err && err.message) || 'Failed'); });
    };

    self.downloadFile = function (f) {
      arService.downloadFile(f.fileId).then(function (res) {
        var url = URL.createObjectURL(res.blob);
        var a = document.createElement('a');
        a.href = url; a.download = res.fileName; a.click();
        setTimeout(function () { URL.revokeObjectURL(url); }, 5000);
      }).catch(function () { toast.error('Download failed'); });
    };

    self.viewSource = function (line) {
      if (!line.fileId) return;
      arService.downloadFile(line.fileId).then(function (res) {
        var url = URL.createObjectURL(res.blob);
        window.open(url, '_blank');
        setTimeout(function () { URL.revokeObjectURL(url); }, 60000);
      }).catch(function () { toast.error('Could not open source file'); });
    };

    self.deleteFileRow = function (f) {
      if (!window.confirm('Remove "' + f.fileName + '" from this event?')) return;
      arService.deleteFile(f.fileId).then(function () { loadFiles(); });
    };

    /* P&L line review */
    self.saveLineCategory = function (l) {
      arService.updateLine(l.lineId, { categoryId: l._selCat() }).then(function () {
        toast.success('Line updated — mapping learned');
        loadPnl();
      }).catch(function () { toast.error('Update failed'); });
    };
    self.setLineStatus = function (l, status) {
      arService.updateLine(l.lineId, { reviewStatus: status }).then(function () { loadPnl(); });
    };
    self.toggleIncluded = function (l) {
      arService.updateLine(l.lineId, { isIncluded: !l.isIncluded }).then(function () { loadPnl(); });
      return true;
    };
    self.deleteLine = function (l) {
      if (!window.confirm('Delete this line?')) return;
      arService.deleteLine(l.lineId).then(function () { loadPnl(); });
    };
    self.confirmAllDrafts = function () {
      arService.confirmLines(self.eventId).then(function (res) {
        toast.success((res.confirmed || 0) + ' line(s) confirmed');
        self.reloadAll();
      }).catch(function () { toast.error('Confirm failed'); });
    };

    /* findings + kpis review */
    self.setFindingStatus = function (f, status) {
      arService.updateFinding(f.findingId, { reviewStatus: status }).then(loadFindings);
    };
    self.setKpiStatus = function (k, status) {
      arService.updateKpi(k.kpiId, { reviewStatus: status }).then(loadKpis);
    };

    /* masters for dropdowns */
    arService.getDocCategories().then(function (res) { self.docCats(res.items || []); });
    arService.getCategories().then(function (res) { self.pnlCats(res.items || []); });

    self.dispose = function () { clearTimeout(_pollTimer); };

    self.reloadAll();
    // resume polling if the event is mid-processing
    arService.getProgress(self.eventId).then(function (p) {
      if (p.eventStatus === 'AI_PROCESSING') { self.processing(true); _poll(); }
    }).catch(function () {});
  }

  return EventDetailViewModel;
});
