define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast', 'util/duration'],
function (ko, atd, i18n, toast, fmtDuration) {
  'use strict';
  return function Discovery() {
    var self = this;
    self.t = i18n.t;
    self.fmtDuration = fmtDuration;
    self.loadModes = ['TRUNCATE_INSERT', 'MERGE'];
    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };

    // ── 1. discovery requests (atd_sa_catalog — current status per subject area) ──
    self.reqLoading = ko.observable(true);
    self.requests = ko.observableArray([]);
    self.newSa = ko.observable('');                     // "discover a subject area" input

    self.loadRequests = function () {
      self.reqLoading(true);
      atd.listSubjectAreas().then(function (r) { self.requests(r.items || []); self.reqLoading(false); })
        .catch(function () { self.reqLoading(false); });
    };

    self.discover = function (sa) {
      sa = (sa || '').trim();
      if (!sa) { toast.error(self.t('atd.discovery.needSa')); return; }
      atd.discoverSubjectArea(sa).then(function () {
        toast.success(self.t('atd.discovery.queued'));
        self.newSa(''); self.loadRequests();
      }).catch(function () {});
    };
    self.discoverNew = function () { self.discover(self.newSa()); };
    self.rediscover  = function (row) { self.discover(row.subjectArea); };

    // ── 2. discovery run history (atd_load_run_log, track=DISCOVER) ──
    self.runLoading = ko.observable(true);
    self.runs = ko.observableArray([]);
    self.runTotal = ko.observable(0);
    self.runOffset = ko.observable(0);
    self.runLimit = ko.observable(25);

    self.loadRuns = function () {
      self.runLoading(true);
      atd.listDiscoveryRuns({ limit: self.runLimit(), offset: self.runOffset() })
        .then(function (r) { self.runs(r.items || []); self.runTotal(r.total || 0); self.runLoading(false); })
        .catch(function () { self.runLoading(false); });
    };

    // ── 3. analysis build requests (atd_analysis_request) ──
    self.buildLoading = ko.observable(true);
    self.builds = ko.observableArray([]);

    self.loadBuilds = function () {
      self.buildLoading(true);
      atd.listAnalyses().then(function (r) { self.builds(r.items || []); self.buildLoading(false); })
        .catch(function () { self.buildLoading(false); });
    };

    self.refresh = function () { self.loadRequests(); self.loadRuns(); self.loadBuilds(); };

    // ── "Add New OTBI Analysis" drawer (builds an analysis via create_analysis.py) ──
    self.showAnalysisForm = ko.observable(false);
    self.anSubjectArea = ko.observable('');
    self.anSaveFolder = ko.observable('');
    self.anName = ko.observable('');
    self.anLoadMode = ko.observable('TRUNCATE_INSERT');
    self.anColumns = ko.observableArray([]);
    self.anParams = ko.observable('');
    function _colRow(folder, column, heading) {
      return { folder: ko.observable(folder || ''), column: ko.observable(column || ''),
               heading: ko.observable(heading || '') };
    }
    self.addAnColumn = function () { self.anColumns.push(_colRow()); };
    self.removeAnColumn = function (row) { self.anColumns.remove(row); };

    // ── column picker (reads the runner-scraped catalog; reuses the requests list) ──
    self.anPickSa = ko.observable('');            // dropdown selection (a discovered SA)
    self.anCatalog = ko.observableArray([]);      // folders [{folder, open, columns:[{name,picked}]}]
    self.anPickerBusy = ko.observable(false);
    self.anPickerMsg = ko.observable('');         // status line under the picker

    function _wrapCatalog(folders) {
      var have = {};
      self.anColumns().forEach(function (r) { have[r.folder() + ' ' + r.column()] = true; });
      return (folders || []).map(function (f) {
        return {
          folder: f.folder,
          open: ko.observable(false),
          columns: (f.columns || []).map(function (c) {
            var p = ko.observable(!!have[f.folder + ' ' + c]);
            p.subscribe(function (on) {
              var match = self.anColumns().filter(function (r) {
                return r.folder() === f.folder && r.column() === c;
              });
              if (on && !match.length) self.anColumns.push(_colRow(f.folder, c, ''));
              else if (!on) match.forEach(function (r) { self.anColumns.remove(r); });
            });
            return { name: c, picked: p };
          })
        };
      });
    }

    self.loadCatalog = function (sa) {
      self.anCatalog([]); self.anPickerMsg('');
      if (!sa) return;
      self.anPickerBusy(true);
      atd.getSubjectAreaColumns(sa).then(function (c) {
        self.anPickerBusy(false);
        // the cached catalog JSON is {subject_area,folders,scraped_at} (no status key);
        // a re-queued row still ships its folders, so show them whenever present.
        if (c && (c.folders || []).length) {
          self.anCatalog(_wrapCatalog(c.folders));
        } else if (c && c.status) {
          self.anPickerMsg(self.t('atd.analysis.status.' + String(c.status).toLowerCase()) || c.status);
        } else {
          self.anPickerMsg(self.t('atd.analysis.notDiscovered'));
        }
      }).catch(function () {
        self.anPickerBusy(false); self.anPickerMsg(self.t('atd.analysis.notDiscovered'));
      });
    };

    // picking a discovered SA from the dropdown fills the spec SA + loads its tree
    self.anPickSa.subscribe(function (sa) {
      if (sa) { self.anSubjectArea(sa); self.loadCatalog(sa); }
    });

    self.discoverColumns = function () {
      var sa = (self.anSubjectArea() || '').trim();
      if (!sa) { toast.error(self.t('atd.analysis.subjectArea')); return; }
      atd.discoverSubjectArea(sa).then(function () {
        toast.success(self.t('atd.analysis.discoverQueued'));
        self.anPickerMsg(self.t('atd.analysis.status.queued'));
        self.loadRequests();
      }).catch(function () {});
    };

    self.toggleFolder = function (f) { f.open(!f.open()); };
    self.togglePick = function (col) { col.picked(!col.picked()); };

    self.newAnalysis = function () {
      self.anSubjectArea(''); self.anSaveFolder(''); self.anName('');
      self.anLoadMode('TRUNCATE_INSERT'); self.anParams('');
      self.anColumns([_colRow(), _colRow(), _colRow()]);
      self.anPickSa(''); self.anCatalog([]); self.anPickerMsg('');
      self.loadRequests();
      self.showAnalysisForm(true);
    };
    self.saveAnalysis = function () {
      var name = (self.anName() || '').trim();
      var sa = (self.anSubjectArea() || '').trim();
      var folder = (self.anSaveFolder() || '').trim();
      if (!sa) { toast.error(self.t('atd.analysis.subjectArea')); return; }
      if (!name) { toast.error(self.t('atd.analysis.name')); return; }
      if (!folder) { toast.error(self.t('atd.analysis.saveFolder')); return; }
      var cols = self.anColumns().map(function (r) {
        var o = { folder: (r.folder() || '').trim(), column: (r.column() || '').trim() };
        var h = (r.heading() || '').trim(); if (h) o.heading = h;
        return o;
      }).filter(function (o) { return o.folder && o.column; });
      if (!cols.length) { toast.error(self.t('atd.analysis.needColumn')); return; }
      var spec = { subject_area: sa, save_folder: folder, name: name,
                   load_mode: self.anLoadMode(), columns: cols };
      if ((self.anParams() || '').trim()) {
        try { spec.params = JSON.parse(self.anParams()); }
        catch (e) { toast.error(self.t('atd.field.params') + ': invalid JSON'); return; }
      }
      atd.createAnalysis({ name: name, saveFolder: folder, specJson: JSON.stringify(spec) })
        .then(function () {
          toast.success(self.t('atd.analysis.queued'));
          self.showAnalysisForm(false); self.loadBuilds();
        }).catch(function () {});
    };

    self.refresh();
  };
});
