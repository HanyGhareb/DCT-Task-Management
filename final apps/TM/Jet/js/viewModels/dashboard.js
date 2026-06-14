define(['knockout', 'services/tmService', 'shared/i18n', 'shared/chartLoader'],
function (ko, tm, i18n, charts) {
  'use strict';
  return function Dashboard() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.k = ko.observable({});
    self.go = function (id) { window._jetApp.navigate(id); };

    tm.getDashboard().then(function (d) {
      self.k(d);
      self.loading(false);
      setTimeout(function () {
        var h = document.getElementById('tmHealthChart');
        if (h) charts.makeChart(h, {
          type: 'doughnut',
          data: {
            labels: (d.teamsByHealth || []).map(function (x) { return x.rag; }),
            datasets: [{ data: (d.teamsByHealth || []).map(function (x) { return x.count; }),
                         backgroundColor: ['#3FB950', '#F0883E', '#F85149', '#8A93A2'] }]
          }
        });
        var c = document.getElementById('tmClassChart');
        if (c) charts.makeChart(c, {
          type: 'bar',
          data: {
            labels: (d.teamsByClass || []).map(function (x) { return x.cls; }),
            datasets: [{ label: 'Teams', data: (d.teamsByClass || []).map(function (x) { return x.count; }),
                         backgroundColor: '#0E8A8A', borderRadius: 6 }]
          },
          options: { plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true, ticks: { precision: 0 } } } }
        });
      }, 40);
    }).catch(function () { self.loading(false); });
  };
});
