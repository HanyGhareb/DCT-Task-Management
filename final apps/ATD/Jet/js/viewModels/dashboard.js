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
    self.actions = ko.observable(null);   // Fusion action-queue health tile
    self.workers = ko.observableArray([]); // parallel-worker fleet (one row per VM)
    self.go = function (id) { window._jetApp.navigate(id); };

    atd.getActionStats().then(function (a) { self.actions(a); }).catch(function () {});
    atd.listWorkers().then(function (r) { self.workers((r && r.items) || []); }).catch(function () {});
    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };
    // a worker is "online" when its heartbeat is fresh (ORDS computes online=Y, age<=120s)
    self.workerDot = function (w) { return (w && w.online === 'Y') ? '#2A7D3A' : '#C13A30'; };
    self.workerAge = function (w) {
      var s = (w && w.ageSec) || 0;
      return s < 90 ? (s + 's') : (Math.round(s / 60) + 'm');
    };

    atd.getDashboard().then(function (d) {
      self.k(d);
      self.queue(d.queue || {});
      self.recent(d.recent || []);
      self.alerts(d.alerts || []);
      self.loading(false);
      setTimeout(function () {
        var el = document.getElementById('atdQueueChart');
        var q = d.queue || {};
        var counts = [q.ready || 0, q.claimed || 0, q.done || 0, q.failed || 0];
        var names = [i18n.t('atd.dash.queue.ready'), i18n.t('atd.dash.queue.claimed'),
                     i18n.t('atd.dash.queue.done'), i18n.t('atd.dash.queue.failed')];
        // show the figure next to each segment in the legend, e.g. "Ready (5)"
        var labels = names.map(function (n, i) { return n + ' (' + counts[i] + ')'; });
        if (el) charts.makeChart(el, {
          type: 'doughnut',
          data: {
            labels: labels,
            datasets: [{ data: counts,
                         backgroundColor: ['#2C6CB0', '#B5651A', '#2A7D3A', '#C13A30'] }]
          },
          options: {
            plugins: {
              legend: { position: 'bottom' },
              tooltip: { callbacks: { label: function (c) { return c.label; } } }
            }
          }
        });
      }, 40);
    }).catch(function () { self.loading(false); });
  };
});
