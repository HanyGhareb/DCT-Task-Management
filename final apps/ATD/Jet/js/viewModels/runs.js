define(['knockout', 'services/atdService', 'services/api', 'shared/i18n', 'shared/toast', 'util/duration', 'util/filterStore'],
function (ko, atd, api, i18n, toast, fmtDuration, filterStore) {
  'use strict';
  return function Runs() {
    var self = this;
    self.t = i18n.t;
    self.fmtDuration = fmtDuration;
    self.fmtPhase = function (ms) {
      ms = Number(ms || 0);
      return ms < 1000 ? (ms + ' ms') : fmtDuration(Math.max(1, Math.round(ms / 1000)));
    };
    self.loading = ko.observable(true);
    self.runs = ko.observableArray([]);
    self.total = ko.observable(0);
    self.jobs = ko.observableArray([]);
    self.sets = ko.observableArray([]);   // { code, name } for the Job Set filter
    // WARNING = a SUCCESS run that carries a message (server interprets it specially)
    self.statuses = ['SUCCESS', 'WARNING', 'FAILED', 'REQUEUED', 'HELD', 'RUNNING'];

    self.fJob = ko.observable(''); self.fStatus = ko.observable('');
    self.fFrom = ko.observable(''); self.fTo = ko.observable('');
    self.fSet = ko.observable('');

    // server pagination (envelope {items,total,limit,offset}); 20 rows/page
    self.offset = ko.observable(0);
    self.limit = ko.observable(20);

    self.detail = ko.observable(null);
    self.rerunning = ko.observable(false);
    self.warningGroups = ko.observableArray([]);
    self.warningGroupsLoading = ko.observable(true);
    self.warningGroupsOpen = ko.observable(true);

    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };
    self.statusText = function (r) {
      return r && r.status === 'SUCCESS' && Number(r.rowCount) === 0
        ? self.t('atd.status.successNoData') : ((r && r.status) || '');
    };
    self.isNoData = function (r) { return !!(r && r.status === 'SUCCESS' && Number(r.rowCount) === 0); };
    self.prettyJson = function (value) {
      if (!value) return '—';
      try { return JSON.stringify(JSON.parse(value), null, 2); }
      catch (e) { return String(value); }
    };
    self.toggleWarningGroups = function () { self.warningGroupsOpen(!self.warningGroupsOpen()); };
    self.openWarningGroup = function (row) { self.open({ runId: row.latestRunId }); };
    self.loadWarningGroups = function () {
      self.warningGroupsLoading(true);
      atd.warningSummary({ days: 30, limit: 25 }).then(function (r) {
        self.warningGroups((r && r.items) || []);
      }).catch(function () { self.warningGroups([]); })
        .then(function () { self.warningGroupsLoading(false); });
    };
    self.loadWarningGroups();

    self.load = function () {
      self.loading(true);
      atd.listRuns({ job: self.fJob(), status: self.fStatus(), fromdt: self.fFrom(), todt: self.fTo(),
                     setcode: self.fSet(), limit: self.limit(), offset: self.offset() })
        .then(function (r) { self.runs(r.items || []); self.total(r.total || 0); self.loading(false); })
        .catch(function () { self.loading(false); });
    };

    // explicit Search / Clear (criteria remembered across refresh via filterStore)
    self.search = function () { self.offset(0); self.load(); };
    self.clearFilters = function () {
      self.fJob(''); self.fStatus(''); self.fFrom(''); self.fTo(''); self.fSet('');
      self._filterStore.clear(); self.offset(0); self.load();
    };

    // persist filter criteria so a refresh restores them (BEFORE the reload subscriptions
    // + initial load so restored values are applied without an extra reload).
    self._filterStore = filterStore.bind('runs', {
      job: self.fJob, status: self.fStatus, from: self.fFrom, to: self.fTo, set: self.fSet
    });

    // Reload when a filter changes — reset to the first page first. Drive off the
    // observable subscription (fires AFTER the value binding writes), not the DOM
    // change event (fires BEFORE KO updates the observable → one-change lag).
    [self.fJob, self.fStatus, self.fFrom, self.fTo, self.fSet].forEach(function (o) {
      o.subscribe(function () { self.offset(0); self.load(); });
    });

    atd.getLookups().then(function () {}).catch(function () {});
    // Job Set filter options (from the sets defined on the Job Sets page)
    atd.listJobSets().then(function (r) {
      self.sets((r.items || []).map(function (s) { return { code: s.setCode, name: s.nameEn || s.setCode }; }));
    }).catch(function () {});
    atd.listJobs({ limit: 200 }).then(function (r) {
      self.jobs((r.items || []).map(function (j) { return j.jobName; }));
    }).catch(function () {}).then(function () { self.load(); });

    self.open = function (row) {
      atd.getRun(row.runId).then(function (d) { self.detail(d); }).catch(function () {});
    };
    self.closeDetail = function () { self.detail(null); };
    self.openJob = function (reviewSchema) {
      var d = self.detail(); if (!d || !d.jobName) return;
      self.detail(null);
      window._jetApp.navigate('jobDetail', { jobName: d.jobName, openSchema: !!reviewSchema });
    };
    self.runAgain = function () {
      var d = self.detail(); if (!d || !d.jobName || self.rerunning()) return;
      if (!window.confirm(i18n.t('atd.runAction.confirm').replace('{job}', d.jobName))) return;
      self.rerunning(true);
      atd.runJob(d.jobName).then(function () {
        toast.success(i18n.t('atd.runAction.queued').replace('{job}', d.jobName));
      }).catch(function () { toast.error(i18n.t('atd.runAction.failed')); })
        .then(function () { self.rerunning(false); });
    };
    self.copyError = function () {
      var text = String((self.detail() && self.detail().message) || '');
      if (!text) { toast.error(i18n.t('atd.runAction.noMessage')); return; }
      function ok() { toast.success(i18n.t('atd.runAction.copied')); }
      function fallback() {
        var el = document.createElement('textarea'); el.value = text;
        el.style.position = 'fixed'; el.style.opacity = '0'; document.body.appendChild(el);
        el.select(); try { document.execCommand('copy'); ok(); }
        catch (e) { toast.error(i18n.t('atd.runAction.copyFailed')); }
        document.body.removeChild(el);
      }
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(ok).catch(fallback);
      } else fallback();
    };

    self.exportCsv = function () {
      api.fetchBlobUrl(atd.runsExportUrl({ job: self.fJob(), status: self.fStatus(), setcode: self.fSet() }))
        .then(function (url) {
          var a = document.createElement('a');
          a.href = url; a.download = 'atd-runs.csv';
          document.body.appendChild(a); a.click();
          setTimeout(function () { document.body.removeChild(a); URL.revokeObjectURL(url); }, 1000);
        }).catch(function () { toast.error('Export failed'); });
    };
  };
});
