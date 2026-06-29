define(['knockout', 'services/atdService', 'shared/i18n', 'shared/chartLoader', 'shared/toast'],
function (ko, atd, i18n, charts, toast) {
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
    self.breakInfo = ko.observable(null);  // {enabled,active,start,end} Break window status
    self.jobHealth = ko.observableArray([]); // per-enabled-job freshness rows
    self._sessAge = {};                    // workerId -> {sessionStarted, sessionAgeMin}
    self.go = function (id) { window._jetApp.navigate(id); };

    // rebuild the GL actuals classification snapshot (also a button in the GL app
    // + an hourly job); handy to run straight after a load completes here.
    self.refreshingActuals = ko.observable(false);
    self.refreshActuals = function () {
      if (self.refreshingActuals()) return;
      self.refreshingActuals(true);
      atd.refreshActuals()
        .then(function () { toast.success(i18n.t('atd.dash.refreshActualsOk')); })
        .catch(function () { toast.error(i18n.t('atd.dash.refreshActualsFail')); })
        .then(function () { self.refreshingActuals(false); });
    };

    atd.getActionStats().then(function (a) { self.actions(a); }).catch(function () {});
    atd.listWorkers().then(function (r) { self.workers((r && r.items) || []); }).catch(function () {});
    // observability: break window + per-VM session age + per-job freshness
    atd.getJobHealth().then(function (h) {
      self.breakInfo(h.break || null);
      self.jobHealth(h.jobs || []);
      (h.workers || []).forEach(function (w) { self._sessAge[w.workerId] = w; });
      self.workers.valueHasMutated();      // re-render the fleet table with session ages
    }).catch(function () {});

    // minutes -> "Nm" / "Hh Mm"
    function ageText(m) {
      if (m === '' || m === null || m === undefined) return '—';
      m = Number(m);
      return m < 90 ? (m + 'm') : (Math.floor(m / 60) + 'h ' + (m % 60) + 'm');
    }
    self.sessionAge = function (w) {
      var s = self._sessAge[w && w.workerId]; return s ? ageText(s.sessionAgeMin) : '—';
    };
    // an Entra session lives ~8h; flag amber once past the warn threshold (7h)
    self.sessionAged = function (w) {
      var s = self._sessAge[w && w.workerId];
      return !!(s && s.sessionAgeMin !== '' && s.sessionAgeMin != null && Number(s.sessionAgeMin) >= 420);
    };
    self.sinceText = function (j) { return ageText(j && j.sinceMin); };
    self.jobStale = function (j) {
      return !!(j && (Number(j.consecutiveFails) > 0 || j.stuckRunning === 'Y'));
    };
    self.breakText = function () {
      var b = self.breakInfo(); if (!b) return '';
      return (b.start || '') + '–' + (b.end || '');
    };
    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };
    // a worker is "online" when its heartbeat is fresh (ORDS computes online=Y, age<=120s)
    self.workerDot = function (w) { return (w && w.online === 'Y') ? '#2A7D3A' : '#C13A30'; };
    self.workerAge = function (w) {
      var s = (w && w.ageSec) || 0;
      return s < 90 ? (s + 's') : (Math.round(s / 60) + 'm');
    };
    // operator-triggered re-login: ask this worker to start a fresh Fusion login;
    // the MFA number then arrives in Telegram / Authenticator for approval.
    self.refreshWorker = function (w) {
      if (!w || !w.workerId) return;
      if (!window.confirm(i18n.t('atd.workers.refresh.confirm').replace('{vm}', w.workerId))) return;
      atd.refreshWorker(w.workerId)
        .then(function () { toast.success(i18n.t('atd.workers.refresh.asked').replace('{vm}', w.workerId)); })
        .catch(function () { toast.error(i18n.t('atd.workers.refresh.failed')); });
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
