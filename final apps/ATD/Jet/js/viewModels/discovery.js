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
    self.requests = ko.observableArray([]);             // full list (also feeds the picker)
    self.newSa = ko.observable('');                     // "discover a subject area" input
    self.noop = function () {};                         // client-paged: slice is computed

    // client-side pagination (20 rows/page) over the full requests list
    self.reqOffset = ko.observable(0);
    self.reqLimit = ko.observable(20);
    self.reqTotal = ko.pureComputed(function () { return self.requests().length; });
    self.reqPage = ko.pureComputed(function () {
      var o = self.reqOffset(); return self.requests().slice(o, o + self.reqLimit());
    });

    self.loadRequests = function () {
      self.reqLoading(true);
      atd.listSubjectAreas().then(function (r) {
        self.requests(r.items || []); self.reqOffset(0); self.reqLoading(false);
      }).catch(function () { self.reqLoading(false); });
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
    self.runLimit = ko.observable(20);

    self.loadRuns = function () {
      self.runLoading(true);
      atd.listDiscoveryRuns({ limit: self.runLimit(), offset: self.runOffset() })
        .then(function (r) { self.runs(r.items || []); self.runTotal(r.total || 0); self.runLoading(false); })
        .catch(function () { self.runLoading(false); });
    };

    // ── 3. analysis build requests (atd_analysis_request) ──
    self.buildLoading = ko.observable(true);
    self.builds = ko.observableArray([]);

    // client-side pagination (20 rows/page)
    self.buildOffset = ko.observable(0);
    self.buildLimit = ko.observable(20);
    self.buildTotal = ko.pureComputed(function () { return self.builds().length; });
    self.buildPage = ko.pureComputed(function () {
      var o = self.buildOffset(); return self.builds().slice(o, o + self.buildLimit());
    });

    self.loadBuilds = function () {
      self.buildLoading(true);
      atd.listAnalyses().then(function (r) {
        self.builds(r.items || []); self.buildOffset(0); self.buildLoading(false);
      }).catch(function () { self.buildLoading(false); });
    };

    // ── 4. "Generate Schedule OTBI Data" (atd_schedgen_request) ──
    // Point it at a catalog folder; the runner creates <name>_F/_UH/_U10M for each
    // base analysis (optionally recursing subfolders).
    self.sgFolder  = ko.observable('');
    self.sgSub     = ko.observable(false);
    self.sgBusy    = ko.observable(false);
    self.sgLoading = ko.observable(true);
    self.sgRequests = ko.observableArray([]);

    self.loadScheduleGen = function () {
      self.sgLoading(true);
      atd.listScheduleGen().then(function (r) {
        self.sgRequests(r.items || []); self.sgLoading(false);
      }).catch(function () { self.sgLoading(false); });
    };

    self.generateSchedule = function () {
      var folder = (self.sgFolder() || '').trim();
      if (!folder) { toast.error(self.t('atd.schedgen.needFolder')); return; }
      self.sgBusy(true);
      atd.scheduleGen(folder, self.sgSub()).then(function () {
        self.sgBusy(false);
        toast.success(self.t('atd.schedgen.queued'));
        self.sgFolder(''); self.sgSub(false); self.loadScheduleGen();
      }).catch(function () { self.sgBusy(false); });
    };

    self.refresh = function () {
      self.loadRequests(); self.loadRuns(); self.loadBuilds(); self.loadScheduleGen();
    };

    // ── "Add New OTBI Analysis" drawer (builds an analysis via create_analysis.py) ──
    self.showAnalysisForm = ko.observable(false);
    self.anSubjectArea = ko.observable('');
    self.anSaveFolder = ko.observable('');
    self.anName = ko.observable('');
    self.anLoadMode = ko.observable('TRUNCATE_INSERT');
    self.anColumns = ko.observableArray([]);
    self.anParams = ko.observable('');
    function _colRow(folder, column, heading, path) {
      return { folder: ko.observable(folder || ''), column: ko.observable(column || ''),
               heading: ko.observable(heading || ''), path: path || null };
    }
    var SEP = ' ▸ ';   // "A ▸ B ▸ C" path display
    self.addAnColumn = function () { self.anColumns.push(_colRow()); };
    self.removeAnColumn = function (row) { self.anColumns.remove(row); };

    // ── column picker (reads the runner-scraped catalog; reuses the requests list) ──
    self.anPickSa = ko.observable('');            // dropdown selection (a discovered SA)
    self.anCatalog = ko.observableArray([]);      // folders [{folder, open, columns:[{name,picked}]}]
    self.anPickerBusy = ko.observable(false);
    self.anPickerMsg = ko.observable('');         // status line under the picker

    // a column row's identity = its folder path joined + column name
    function _rowKey(r) { return (r.path ? r.path.join(SEP) : r.folder()) + ' :: ' + r.column(); }

    // recursively wrap the nested catalog tree {folder, columns[], folders[]} for the
    // picker; each leaf carries its full folder PATH so picking it adds a path-aware row.
    function _wrapCatalog(folders, parentPath) {
      parentPath = parentPath || [];
      var have = {};
      self.anColumns().forEach(function (r) { have[_rowKey(r)] = true; });
      return (folders || []).map(function (f) {
        var path = parentPath.concat([f.folder]);
        var pkey = path.join(SEP);
        var cols = (f.columns || []).map(function (c) {
          var p = ko.observable(!!have[pkey + ' :: ' + c]);
          p.subscribe(function (on) {
            var match = self.anColumns().filter(function (r) {
              return (r.path ? r.path.join(SEP) : '') === pkey && r.column() === c;
            });
            if (on && !match.length) self.anColumns.push(_colRow(pkey, c, '', path));
            else if (!on) match.forEach(function (r) { self.anColumns.remove(r); });
          });
          return { name: c, picked: p };
        });
        var subs = _wrapCatalog(f.folders || [], path);
        var count = cols.length + subs.reduce(function (n, s) { return n + s.count; }, 0);
        return { folder: f.folder, path: path, open: ko.observable(false),
                 columns: cols, folders: subs, count: count };
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

    // ── AI column suggester (describe the data → tick the matching columns) ──
    self.anSuggestText = ko.observable('');
    self.anSuggestBusy = ko.observable(false);

    // tick a leaf by folder path + column in the loaded nested catalog (expanding
    // ancestors); returns false if the catalog isn't loaded or the leaf isn't found.
    function _pickByPath(path, column) {
      var cur = self.anCatalog(), node = null;
      for (var d = 0; d < path.length; d++) {
        node = null;
        for (var i = 0; i < cur.length; i++) { if (cur[i].folder === path[d]) { node = cur[i]; break; } }
        if (!node) return false;
        node.open(true);
        cur = node.folders;
      }
      var col = (node.columns || []).filter(function (c) { return c.name === column; })[0];
      if (col) { col.picked(true); return true; }   // subscribe adds the anColumns row
      return false;
    }

    function _applyPick(path, column) {
      if (_pickByPath(path || [], column)) return;
      // fallback (catalog not loaded / label drift): add the row directly
      var pkey = (path || []).join(SEP);
      var dup = self.anColumns().some(function (r) {
        return (r.path ? r.path.join(SEP) : '') === pkey && r.column() === column;
      });
      if (!dup) self.anColumns.push(_colRow(pkey, column, '', path || []));
    }

    self.suggestColumns = function () {
      var sa = (self.anSubjectArea() || '').trim();
      var req = (self.anSuggestText() || '').trim();
      if (!sa) { toast.error(self.t('atd.analysis.subjectArea')); return; }
      if (!req) { toast.error(self.t('atd.analysis.suggestNeed')); return; }
      self.anSuggestBusy(true);
      atd.suggestColumns(sa, req).then(function (r) {
        self.anSuggestBusy(false);
        var items = (r && r.items) || [];
        if (!items.length) { toast.error(self.t('atd.analysis.suggestNone')); return; }
        items.forEach(function (it) { _applyPick(it.path, it.column); });
        toast.success(self.t('atd.analysis.suggestAdded').replace('{n}', items.length));
      }).catch(function () { self.anSuggestBusy(false); });
    };

    self.newAnalysis = function () {
      self.anSubjectArea(''); self.anSaveFolder(''); self.anName('');
      self.anLoadMode('TRUNCATE_INSERT'); self.anParams('');
      self.anColumns([_colRow(), _colRow(), _colRow()]);
      self.anPickSa(''); self.anCatalog([]); self.anPickerMsg('');
      self.anSuggestText(''); self.anSuggestBusy(false);
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
        var o = { column: (r.column() || '').trim() };
        if (r.path && r.path.length) o.path = r.path;           // nested column
        else o.folder = (r.folder() || '').trim();              // manual depth-1 row
        var h = (r.heading() || '').trim(); if (h) o.heading = h;
        return o;
      }).filter(function (o) { return o.column && (o.folder || (o.path && o.path.length)); });
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
