define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast'],
function (ko, atd, i18n, toast) {
  'use strict';
  return function Queue() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.jobs = ko.observableArray([]);
    self.lease = ko.observable(30);

    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };

    self.load = function () {
      self.loading(true);
      atd.listJobs({ limit: 200 }).then(function (r) { self.jobs(r.items || []); self.loading(false); })
        .catch(function () { self.loading(false); });
    };
    self.load();

    self.enqueueAll = function () {
      atd.enqueueAll().then(function (r) {
        toast.success((r.queued || 0) + ' ' + self.t('atd.queue.enqueued')); self.load();
      }).catch(function () {});
    };
    self.reap = function () {
      atd.reap(Number(self.lease())).then(function (r) {
        toast.success((r.reaped || 0) + ' ' + self.t('atd.queue.reaped')); self.load();
      }).catch(function () {});
    };
    self.enqueueOne = function (row) {
      atd.enqueueJob(row.jobName).then(function () { toast.success(self.t('atd.jobs.enqueued')); self.load(); }).catch(function () {});
    };
  };
});
