define(['knockout', 'services/rptService', 'shared/toast'], function (ko, rpt, toast) {
  'use strict';

  var HEALTH_BADGE = { ONLINE: 'badge badge--success', STALE: 'badge badge--warn', OFFLINE: 'badge badge--danger' };
  var STATUS_BADGE = { RUNNING: 'badge badge--info', IDLE: 'badge badge--success', PAUSED: 'badge badge--warn',
                       STOPPED: 'badge', STARTING: 'badge badge--info' };
  var REFRESH_MS = 10000;

  function WorkersViewModel() {
    var self = this;
    self.loading  = ko.observable(true);
    self.workers  = ko.observableArray([]);
    self.jobs     = ko.observableArray([]);
    self.queued        = ko.observable(0);
    self.running       = ko.observable(0);
    self.failedToday   = ko.observable(0);
    self.successToday  = ko.observable(0);
    self.oldestQueued  = ko.observable(0);
    self.lastRefreshed = ko.observable('');

    self.onlineCount = ko.computed(function () {
      return self.workers().filter(function (w) { return w.health === 'ONLINE'; }).length;
    });

    self.healthBadge = function (h) { return HEALTH_BADGE[h] || 'badge'; };
    self.statusBadge = function (s) { return STATUS_BADGE[s] || 'badge'; };
    self.hbAgo = function (w) {
      if (w.heartbeatAgoSec === null || w.heartbeatAgoSec === undefined) return '—';
      var s = w.heartbeatAgoSec;
      if (s < 60) return s + 's';
      if (s < 3600) return Math.round(s / 60) + 'm';
      return Math.round(s / 3600) + 'h';
    };

    self.load = function (silent) {
      if (!silent) self.loading(true);
      rpt.getWorkers().then(function (d) {
        self.workers(d.workers || []);
        self.jobs(d.jobs || []);
        var q = d.queue || {};
        self.queued(q.queued || 0); self.running(q.running || 0);
        self.failedToday(q.failedToday || 0); self.successToday(q.successToday || 0);
        self.oldestQueued(q.oldestQueuedMin || 0);
        self.lastRefreshed(new Date().toLocaleTimeString());
      }).catch(function () {}).then(function () { self.loading(false); });
    };
    self.refresh = function () { self.load(); };

    // auto-refresh while the page is visible; the guard stops the timer after navigation
    var timer = setInterval(function () {
      if ((window.location.hash || '') !== '#workers') { clearInterval(timer); return; }
      self.load(true);
    }, REFRESH_MS);

    // ── worker actions ──────────────────────────────────────────────────
    self.command = function (w, cmd) {
      if (cmd === 'STOP' && !window.confirm('Stop worker "' + w.workerId + '"? It exits after the current run.')) return;
      rpt.workerCommand(w.workerId, cmd).then(function () {
        toast.success(cmd + ' sent to ' + w.workerId); self.load(true);
      }).catch(function () {});
    };
    self.pause  = function (w) { self.command(w, 'PAUSE'); };
    self.resume = function (w) { self.command(w, 'RESUME'); };
    self.stop   = function (w) { self.command(w, 'STOP'); };
    self.remove = function (w) {
      if (!window.confirm('Remove worker row "' + w.workerId + '"? (registry entry only)')) return;
      rpt.workerRemove(w.workerId).then(function () { toast.success('Removed'); self.load(true); }).catch(function () {});
    };
    self.canPause  = function (w) { return w.health !== 'OFFLINE' && w.status !== 'PAUSED' && w.command !== 'PAUSE'; };
    self.canResume = function (w) { return w.status === 'PAUSED' || w.command === 'PAUSE'; };
    self.canRemove = function (w) { return w.health === 'OFFLINE'; };

    // ── queue + scheduler jobs ──────────────────────────────────────────
    self.reclaim = function () {
      rpt.reclaimStuck().then(function () { toast.success('Stuck runs re-queued'); self.load(true); }).catch(function () {});
    };
    self.toggleJob = function (j) {
      var to = (j.enabled === 'TRUE') ? 'N' : 'Y';
      rpt.toggleJob(j.jobName, to).then(function () {
        toast.success(j.jobName + (to === 'Y' ? ' enabled' : ' disabled')); self.load(true);
      }).catch(function () {});
    };
    self.jobBadge = function (j) { return j.enabled === 'TRUE' ? 'badge badge--success' : 'badge badge--danger'; };

    self.load();
  }

  return WorkersViewModel;
});
