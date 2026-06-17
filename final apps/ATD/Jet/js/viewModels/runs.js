define(['knockout', 'services/atdService', 'services/api', 'shared/i18n', 'shared/toast'],
function (ko, atd, api, i18n, toast) {
  'use strict';
  return function Runs() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.runs = ko.observableArray([]);
    self.jobs = ko.observableArray([]);
    self.statuses = ['SUCCESS', 'FAILED', 'RUNNING'];

    self.fJob = ko.observable(''); self.fStatus = ko.observable('');
    self.fFrom = ko.observable(''); self.fTo = ko.observable('');

    self.detail = ko.observable(null);

    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };

    self.load = function () {
      self.loading(true);
      atd.listRuns({ job: self.fJob(), status: self.fStatus(), fromdt: self.fFrom(), todt: self.fTo(), limit: 100 })
        .then(function (r) { self.runs(r.items || []); self.loading(false); })
        .catch(function () { self.loading(false); });
    };

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
