define(['knockout', 'shared/i18n', 'services/kpiService'],
function (ko, i18n, kpi) {
  'use strict';

  function KpiListViewModel() {
    var self = this;
    self.t    = i18n.t;
    self.lang = i18n.lang;

    self.loading = ko.observable(true);
    self.showAll = ko.observable(false);
    self.kpis    = ko.observableArray([]);

    self.freqLabel = function (f) {
      return self.t(f === 'QUARTERLY' ? 'kpi.freqQuarterly' : (f === 'MIXED' ? 'kpi.freqMixed' : 'kpi.freqAnnual'));
    };
    self.methodLabel = function (m) {
      return self.t({ RATIO_A_OVER_B: 'kpi.methRatio', ABS_VARIANCE: 'kpi.methVariance',
                      WEIGHTED_CRITERIA: 'kpi.methWeighted' }[m] || 'kpi.methRatio');
    };

    self.openKpi = function (k) { window._jetApp.navigate('kpiEdit', { kpiId: k.kpiId }); };
    self.newKpi  = function () { window._jetApp.navigate('kpiEdit', { kpiId: null }); };

    function load() {
      self.loading(true);
      kpi.getKpis(self.showAll()).then(function (items) {
        self.kpis(items);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    self.showAll.subscribe(load);
    load();
  }

  return KpiListViewModel;
});
