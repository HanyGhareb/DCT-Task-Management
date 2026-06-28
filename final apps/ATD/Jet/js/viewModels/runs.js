define(['knockout', 'services/atdService', 'services/api', 'shared/i18n', 'shared/toast', 'util/duration', 'util/filterStore'],
function (ko, atd, api, i18n, toast, fmtDuration, filterStore) {
  'use strict';
  return function Runs() {
    var self = this;
    self.t = i18n.t;
    self.fmtDuration = fmtDuration;
    self.loading = ko.observable(true);
    self.runs = ko.observableArray([]);
    self.total = ko.observable(0);
    self.jobs = ko.observableArray([]);
    // WARNING = a SUCCESS run that carries a message (server interprets it specially)
    self.statuses = ['SUCCESS', 'WARNING', 'FAILED', 'REQUEUED', 'HELD', 'RUNNING'];

    self.fJob = ko.observable(''); self.fStatus = ko.observable('');
    self.fFrom = ko.observable(''); self.fTo = ko.observable('');

    // server pagination (envelope {items,total,limit,offset}); 20 rows/page
    self.offset = ko.observable(0);
    self.limit = ko.observable(20);

    self.detail = ko.observable(null);

    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };

    self.load = function () {
      self.loading(true);
      atd.listRuns({ job: self.fJob(), status: self.fStatus(), fromdt: self.fFrom(), todt: self.fTo(),
                     limit: self.limit(), offset: self.offset() })
        .then(function (r) { self.runs(r.items || []); self.total(r.total || 0); self.loading(false); })
        .catch(function () { self.loading(false); });
    };

    // explicit Search / Clear (criteria remembered across refresh via filterStore)
    self.search = function () { self.offset(0); self.load(); };
    self.clearFilters = function () {
      self.fJob(''); self.fStatus(''); self.fFrom(''); self.fTo('');
      self._filterStore.clear(); self.offset(0); self.load();
    };

    // persist filter criteria so a refresh restores them (BEFORE the reload subscriptions
    // + initial load so restored values are applied without an extra reload).
    self._filterStore = filterStore.bind('runs', {
      job: self.fJob, status: self.fStatus, from: self.fFrom, to: self.fTo
    });

    // Reload when a filter changes — reset to the first page first. Drive off the
    // observable subscription (fires AFTER the value binding writes), not the DOM
    // change event (fires BEFORE KO updates the observable → one-change lag).
    [self.fJob, self.fStatus, self.fFrom, self.fTo].forEach(function (o) {
      o.subscribe(function () { self.offset(0); self.load(); });
    });

    atd.getLookups().then(function () {}).catch(function () {});
    atd.listJobs({ limit: 200 }).then(function (r) {
      self.jobs((r.items || []).map(function (j) { return j.jobName; }));
    }).catch(function () {}).then(function () { self.load(); });

    self.open = function (row) {
      atd.getRun(row.runId).then(function (d) { self.detail(d); }).catch(function () {});
    };
    self.closeDetail = function () { self.detail(null); };

    self.exportCsv = function () {
      api.fetchBlobUrl(atd.runsExportUrl({ job: self.fJob(), status: self.fStatus() }))
        .then(function (url) {
          var a = document.createElement('a');
          a.href = url; a.download = 'atd-runs.csv';
          document.body.appendChild(a); a.click();
          setTimeout(function () { document.body.removeChild(a); URL.revokeObjectURL(url); }, 1000);
        }).catch(function () { toast.error('Export failed'); });
    };
  };
});
