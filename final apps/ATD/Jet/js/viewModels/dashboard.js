define(['knockout', 'services/atdService', 'shared/i18n', 'shared/chartLoader'],
function (ko, atd, i18n, charts) {
  'use strict';
  return function Dashboard() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.k = ko.observable({});
    self.queue = ko.observable({});
    self.recent = ko.observableArray([]);
    self.alerts = ko.observableArray([]);
    self.go = function (id) { window._jetApp.navigate(id); };
    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };

    atd.getDashboard().then(function (d) {
      self.k(d);
      self.queue(d.queue || {});
      self.recent(d.recent || []);
      self.alerts(d.alerts || []);
      self.loading(false);
      setTimeout(function () {
        var el = document.getElementById('atdQueueChart');
        var q = d.queue || {};
        if (el) charts.makeChart(el, {
          type: 'doughnut',
          data: {
            labels: [i18n.t('atd.dash.queue.ready'), i18n.t('atd.dash.queue.claimed'),
                     i18n.t('atd.dash.queue.done'), i18n.t('atd.dash.queue.failed')],
            datasets: [{ data: [q.ready || 0, q.claimed || 0, q.done || 0, q.failed || 0],
                         backgroundColor: ['#2C6CB0', '#B5651A', '#2A7D3A', '#C13A30'] }]
          },
          options: { plugins: { legend: { position: 'bottom' } } }
        });
      }, 40);
    }).catch(function () { self.loading(false); });
  };
});
