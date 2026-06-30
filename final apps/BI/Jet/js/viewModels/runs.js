define(['knockout', 'services/rptService', 'shared/toast'], function (ko, rpt, toast) {
  'use strict';

  var BADGE = { SUCCESS: 'badge badge--success', FAILED: 'badge badge--danger',
                RUNNING: 'badge badge--info', QUEUED: 'badge badge--warn' };

  function RunsViewModel() {
    var self = this;
    var st = (window._jetApp && window._jetApp.getState()) || {};
    self.loading = ko.observable(true);
    self.items   = ko.observableArray([]);
    self.total   = ko.observable(0);
    self.report  = ko.observable(st.runsReport || '');
    self.status  = ko.observable('');
    self.limit   = 25;
    self.offset  = ko.observable(0);
    self.statuses = ['', 'QUEUED', 'RUNNING', 'SUCCESS', 'FAILED'];

    self.badge = function (s) { return BADGE[s] || 'badge'; };

    self.load = function () {
      self.loading(true);
      rpt.getRuns({ report: self.report(), status: self.status(), limit: self.limit, offset: self.offset() })
        .then(function (r) { self.items(r.items || []); self.total(r.total || 0); })
        .catch(function () {})
        .then(function () { self.loading(false); });
    };
    self.applyFilter = function () { self.offset(0); self.load(); };
    self.refresh = function () { self.load(); };
    self.prev = function () { if (self.offset() > 0) { self.offset(Math.max(0, self.offset() - self.limit)); self.load(); } };
    self.next = function () { if (self.offset() + self.limit < self.total()) { self.offset(self.offset() + self.limit); self.load(); } };
    self.pageInfo = ko.computed(function () {
      var from = self.total() ? self.offset() + 1 : 0;
      return from + '–' + Math.min(self.offset() + self.limit, self.total()) + ' / ' + self.total();
    });

    self.open  = function (row) { window._jetApp.navigate('runDetail', { runId: row.runId }); };
    self.retry = function (row) {
      rpt.retryRun(row.runId).then(function (r) { toast.success('Re-queued as run #' + r.runId); self.load(); }).catch(function () {});
    };

    self.load();
  }

  return RunsViewModel;
});
