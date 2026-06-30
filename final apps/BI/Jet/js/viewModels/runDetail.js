define(['knockout', 'services/rptService', 'shared/toast'], function (ko, rpt, toast) {
  'use strict';

  var BADGE = { SUCCESS: 'badge badge--success', FAILED: 'badge badge--danger',
                RUNNING: 'badge badge--info', QUEUED: 'badge badge--warn',
                SENT: 'badge badge--success', PENDING: 'badge badge--warn', SKIPPED: 'badge' };

  function RunDetailViewModel() {
    var self = this;
    var st = (window._jetApp && window._jetApp.getState()) || {};
    self.runId = st.runId || null;

    self.loading     = ko.observable(true);
    self.run         = ko.observable(null);
    self.outputs     = ko.observableArray([]);
    self.deliveries  = ko.observableArray([]);
    self.badge = function (s) { return BADGE[s] || 'badge'; };

    self.back = function () { window._jetApp.navigate('runs'); };

    self.load = function () {
      self.loading(true);
      rpt.getRun(self.runId).then(function (d) {
        self.run(d); self.outputs(d.outputs || []); self.deliveries(d.deliveries || []);
      }).catch(function () {}).then(function () { self.loading(false); });
    };

    self.retry = function () {
      rpt.retryRun(self.runId).then(function (r) {
        toast.success('Re-queued as run #' + r.runId);
        window._jetApp.navigate('runDetail', { runId: r.runId });
        self.runId = r.runId; self.load();
      }).catch(function () {});
    };

    self.download = function (o) {
      rpt.outputUrl(self.runId, o.format).then(function (url) {
        var a = document.createElement('a');
        a.href = url; a.download = o.fileName || (o.format + '.bin');
        document.body.appendChild(a); a.click(); document.body.removeChild(a);
        setTimeout(function () { URL.revokeObjectURL(url); }, 15000);
      }).catch(function () {});
    };

    self.fmtBytes = function (n) {
      n = n || 0;
      return n < 1024 ? n + ' B' : n < 1048576 ? (n / 1024).toFixed(1) + ' KB' : (n / 1048576).toFixed(1) + ' MB';
    };

    if (!self.runId) { self.loading(false); } else { self.load(); }
  }

  return RunDetailViewModel;
});
