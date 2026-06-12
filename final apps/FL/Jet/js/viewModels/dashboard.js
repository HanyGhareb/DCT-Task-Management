define(['knockout', 'services/flService', 'shared/chartLoader', 'shared/i18n'],
function (ko, flService, chartLoader, i18n) {
  'use strict';

  function DashboardViewModel() {
    var self = this;

    self.loading = ko.observable(true);
    self.stats   = ko.observable({});

    // canvases sit inside `ifnot: loading()` — charts must render only after
    // loading(false) has put them in the DOM, so resolve both together
    Promise.all([
      flService.getStats().catch(function () { return {}; }),
      flService.getCharts().catch(function () { return null; })
    ]).then(function (res) {
      self.stats(res[0]);
      self.loading(false);
      if (res[1]) setTimeout(function () { renderCharts(res[1]); }, 0);
    });

    function renderCharts(c) {
      var spend = c.spendByOrg || [];
      var exp   = c.docExpiry || [];
      var el1 = document.getElementById('flChart1');
      var el2 = document.getElementById('flChart2');
      if (el1) {
        chartLoader.makeChart(el1, {
          type: 'bar',
          data: {
            labels: spend.map(function (r) { return r.org; }),
            datasets: [
              { label: i18n.t('common.committed') || 'Committed',
                data: spend.map(function (r) { return r.committed; }),
                backgroundColor: chartLoader.alpha(chartLoader.palette().brand, .75), borderRadius: 6 },
              { label: i18n.t('common.paid') || 'Paid',
                data: spend.map(function (r) { return r.paid; }),
                backgroundColor: 'rgba(45,164,78,.75)', borderRadius: 6 }
            ]
          },
          options: { maintainAspectRatio: false }
        });
      }
      if (el2) {
        var order = ['EXPIRED', 'LE30', 'LE60', 'LE90', 'GT90'];
        var labels = { EXPIRED: 'Expired', LE30: '≤ 30 days', LE60: '31–60', LE90: '61–90', GT90: '> 90 days' };
        var colors = { EXPIRED: '#D1242F', LE30: '#F0883E', LE60: '#E3B341', LE90: '#0969DA', GT90: '#2DA44E' };
        var byBucket = {};
        exp.forEach(function (r) { byBucket[r.bucket] = r.count; });
        chartLoader.makeChart(el2, {
          type: 'bar',
          data: {
            labels: order.map(function (b) { return labels[b]; }),
            datasets: [{ data: order.map(function (b) { return byBucket[b] || 0; }),
                         backgroundColor: order.map(function (b) { return colors[b]; }), borderRadius: 6 }]
          },
          options: { maintainAspectRatio: false, plugins: { legend: { display: false } } }
        });
      }
    }
  }

  return DashboardViewModel;
});
