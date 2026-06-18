define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast', 'util/duration'],
function (ko, atd, i18n, toast, fmtDuration) {
  'use strict';
  return function JobDetail() {
    var self = this;
    self.t = i18n.t;
    self.fmtDuration = fmtDuration;
    self.loading = ko.observable(true);
    self.job = ko.observable({});
    self.history = ko.observableArray([]);
    var name = (window._jetApp.getState() || {}).jobName;

    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };
    self.back = function () { window._jetApp.navigate('jobs'); };

    self.refresh = function () {
      atd.getJob(name).then(function (j) {
        self.job(j); self.history(j.history || []); self.loading(false);
      }).catch(function () { self.loading(false); });
    };
    self.refresh();

    self.enqueue = function () {
      atd.enqueueJob(name).then(function () { toast.success(self.t('atd.jobs.enqueued')); self.refresh(); }).catch(function () {});
    };

    // Re-prepare: clear the stored column map so the next run re-derives it from the
    // live analysis. rebuild=true also drops + recreates the table (accept an
    // incompatible column change, discarding currently loaded rows).
    self.reprepare = function (rebuild) {
      if (!window.confirm(self.t(rebuild ? 'atd.jobs.confirmRebuild' : 'atd.jobs.confirmRemap'))) return;
      atd.reprepareJob(name, rebuild).then(function () {
        toast.success(self.t(rebuild ? 'atd.jobs.rebuilt' : 'atd.jobs.remapped'));
        self.refresh();
      }).catch(function () {});
    };
  };
});
