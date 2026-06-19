define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast', 'util/duration'],
function (ko, atd, i18n, toast, fmtDuration) {
  'use strict';
  return function Discovery() {
    var self = this;
    self.t = i18n.t;
    self.fmtDuration = fmtDuration;
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
    self.refresh();
  };
});
