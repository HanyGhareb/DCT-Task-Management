define(['knockout', 'services/tmService', 'shared/i18n'],
function (ko, tm, i18n) {
  'use strict';
  return function Reports() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.teams = ko.observableArray([]);
    // The 6 management reports (Team Progress rendered live below; the others
    // share the same data spine and are exportable in the full build).
    self.reportList = [
      'tm.report.progress', 'tm.report.sla', 'tm.report.workload',
      'tm.report.raid', 'tm.report.achievements', 'tm.report.deliverables'
    ];
    self.pct = function (done, total) { return total ? Math.round(done * 100 / total) : 0; };
    self.ragClass = function (rag) { return 'rag rag--' + String(rag || 'GREEN').toLowerCase(); };

    tm.listTeams({ limit: 200 }).then(function (r) {
      self.teams(r.items || []); self.loading(false);
    }).catch(function () { self.loading(false); });
  };
});
