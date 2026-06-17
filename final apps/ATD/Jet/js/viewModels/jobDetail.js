define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast'],
function (ko, atd, i18n, toast) {
  'use strict';
  return function JobDetail() {
    var self = this;
    self.t = i18n.t;
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
  };
});
