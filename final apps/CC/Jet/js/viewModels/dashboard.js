define(['knockout', 'services/ccService', 'shared/chartLoader', 'shared/i18n'],
function (ko, ccService, chartLoader, i18n) {
  'use strict';

  function DashboardViewModel() {
    var self = this;

    self.loading = ko.observable(true);
    self.stats   = ko.observable({});

    // canvases sit inside `ifnot: loading()` — charts must render only after
    // loading(false) has put them in the DOM, so resolve both together
    Promise.all([
      ccService.getStats().catch(function () { return {}; }),
      ccService.getCharts().catch(function () { return null; })
    ]).then(function (res) {
      self.stats(res[0]);
      self.loading(false);
      if (res[1]) setTimeout(function () { renderCharts(res[1]); }, 0);
    });

    function renderCharts(c) {
      var limits = c.limitsByOrg || [];
      var comp   = c.replCompliance || [];
      var el1 = document.getElementById('ccChart1');
      var el2 = document.getElementById('ccChart2');
      if (el1) {
        chartLoader.makeChart(el1, {
          type: 'bar',
          data: {
            labels: limits.map(function (r) { return r.org; }),
            datasets: [
              { data: limits.map(function (r) { return r.totalLimit; }),
                backgroundColor: chartLoader.alpha(chartLoader.palette().brand, .75), borderRadius: 6 }
            ]
          },
          options: { maintainAspectRatio: false, plugins: { legend: { display: false } } }
        });
      }
      if (el2) {
        chartLoader.makeChart(el2, {
          type: 'bar',
          data: {
            labels: comp.map(function (r) { return r.month; }),
            datasets: [
              { label: i18n.t('common.submitted'),
                data: comp.map(function (r) { return r.submitted; }),
                backgroundColor: 'rgba(45,164,78,.75)', borderRadius: 6 },
              { label: i18n.t('common.due'),
                data: comp.map(function (r) { return r.due; }),
                backgroundColor: chartLoader.alpha(chartLoader.palette().brand, .45), borderRadius: 6 }
            ]
          },
          options: { maintainAspectRatio: false,
                     scales: { y: { ticks: { precision: 0 } } } }
        });
      }
    }
  }

  return DashboardViewModel;
});
