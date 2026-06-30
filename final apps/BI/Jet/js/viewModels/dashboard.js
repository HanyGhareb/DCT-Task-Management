define(['knockout', 'services/rptService'], function (ko, rpt) {
  'use strict';

  var BADGE = { SUCCESS: 'badge badge--success', FAILED: 'badge badge--danger',
                RUNNING: 'badge badge--info', QUEUED: 'badge badge--warn' };

  function DashboardViewModel() {
    var self = this;
    self.loading      = ko.observable(true);
    self.totalReports = ko.observable(0);
    self.recent       = ko.observableArray([]);
    self.succeeded    = ko.observable(0);
    self.failed       = ko.observable(0);
    self.running      = ko.observable(0);
    self.emailEnabled = ko.observable(true);

    self.go      = function (p) { window._jetApp.navigate(p); };
    self.openRun = function (r) { window._jetApp.navigate('runDetail', { runId: r.runId }); };
    self.badge   = function (s) { return BADGE[s] || 'badge'; };

    rpt.getReports({ limit: 1 }).then(function (r) { self.totalReports(r.total || 0); }).catch(function () {});

    rpt.getRuns({ limit: 12 }).then(function (r) {
      var items = r.items || [];
      self.recent(items);
      self.succeeded(items.filter(function (x) { return x.status === 'SUCCESS'; }).length);
      self.failed(items.filter(function (x) { return x.status === 'FAILED'; }).length);
      self.running(items.filter(function (x) { return x.status === 'RUNNING' || x.status === 'QUEUED'; }).length);
    }).catch(function () {}).then(function () { self.loading(false); });

    rpt.getConfig().then(function (r) {
      (r.items || []).forEach(function (c) {
        if (c.key === 'EMAIL_ENABLED') self.emailEnabled((c.value || 'N').toUpperCase() === 'Y');
      });
    }).catch(function () {});
  }

  return DashboardViewModel;
});
