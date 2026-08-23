define(['knockout', 'services/atdService', 'shared/i18n', 'shared/chartLoader', 'shared/toast'],
function (ko, atd, i18n, charts, toast) {
  'use strict';
  if (!ko.bindingHandlers.atdMfaAutoRefresh) {
    ko.bindingHandlers.atdMfaAutoRefresh = {
      init: function (element, valueAccessor, allBindings, viewModel) {
        viewModel.startMfaPolling();
        ko.utils.domNodeDisposal.addDisposeCallback(element, function () {
          viewModel.stopMfaPolling();
        });
      }
    };
  }
  return function Dashboard() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.k = ko.observable({});
    self.queue = ko.observable({});
    self.recent = ko.observableArray([]);
    self.alerts = ko.observableArray([]);
    self.attention = ko.observableArray([]);
    self.attentionLoading = ko.observable(true);
    self.actions = ko.observable(null);   // Fusion action-queue health tile
    self.workers = ko.observableArray([]); // parallel-worker fleet (one row per VM)
    self.breakInfo = ko.observable(null);  // {enabled,active,start,end} Break window status
    self.jobHealth = ko.observableArray([]); // per-enabled-job freshness rows
    self._sessAge = {};                    // workerId -> {sessionStarted, sessionAgeMin}
    self._mfaPollTimer = null;
    self._mfaPollBusy = false;
    self._mfaState = {};
    self.go = function (id) { window._jetApp.navigate(id); };
    self.openAttention = function (row) {
      if (!row || !row.jobName) return;
      window._jetApp.navigate('jobDetail', { jobName: row.jobName });
    };
    self.attentionClass = function (row) {
      return 'attn-row attn-row--' + String((row && row.severity) || 'warning').toLowerCase();
    };
    self.attentionText = function (row) {
      if (!row) return '';
      var key = 'atd.attn.reason.' + row.reasonCode;
      return i18n.t(key)
        .replace('{count}', row.count == null ? '' : row.count)
        .replace('{age}', ageText(row.ageMin))
        .replace('{frequency}', ageText(row.frequencyMin))
        .replace('{status}', row.status || '');
    };

    atd.getAttention()
      .then(function (r) { self.attention((r && r.items) || []); })
      .catch(function () { self.attention([]); })
      .then(function () { self.attentionLoading(false); });

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

    function mfaStateFor(worker) {
      var id = (worker && worker.workerId) || '';
      if (!self._mfaState[id]) {
        self._mfaState[id] = {
          status: ko.observable(''), number: ko.observable(''), updated: ko.observable(''),
          error: ko.observable(''), messageId: ko.observable(null), env: ko.observable('')
        };
      }
      return self._mfaState[id];
    }
    function syncMfa(worker) {
      var state = mfaStateFor(worker);
      state.status(worker.mfaStatus || ''); state.number(worker.mfaNumber || '');
      state.updated(worker.mfaUpdated || ''); state.error(worker.mfaError || '');
      state.messageId(worker.mfaMessageId || null); state.env(worker.mfaEnv || '');
    }
    self.mfaState = mfaStateFor;

    // Inline verdict after Check session / Force re-login: the MFA column ends
    // up right eventually, but the CLICK should answer where it happened — incl.
    // the confusing silent case (a live Microsoft sign-in completes with NO MFA
    // number; the operator otherwise waits for a push that never comes).
    self._verdicts = {};
    function verdictFor(worker) {
      var id = (worker && worker.workerId) || '';
      if (!self._verdicts[id]) self._verdicts[id] = { active: ko.observable(false), timer: null };
      return self._verdicts[id];
    }
    var VERDICT_TERMINAL = { SESSION_OK: 1, APPROVED: 1, EXPIRED: 1, FAILED: 1 };
    var VERDICT_MAP = {
      CHECKING:    { cls: 'warn', key: 'atd.workers.verdict.checking' },
      REQUESTED:   { cls: 'warn', key: 'atd.workers.verdict.relogin' },
      WAITING_MFA: { cls: 'warn', key: 'atd.workers.verdict.waitslot' },
      DETECTED:    { cls: 'warn', key: 'atd.workers.verdict.approve' },
      DELIVERED:   { cls: 'warn', key: 'atd.workers.verdict.approve' },
      SESSION_OK:  { cls: 'ok',   key: 'atd.workers.verdict.ok' },
      APPROVED:    { cls: 'ok',   key: 'atd.workers.verdict.approved' },
      EXPIRED:     { cls: 'err',  key: 'atd.workers.verdict.expired' },
      FAILED:      { cls: 'err',  key: 'atd.workers.verdict.failed' }
    };
    self.startVerdict = function (w, optimistic) {
      var v = verdictFor(w);
      if (v.timer) { clearTimeout(v.timer); v.timer = null; }
      // pre-set the state the server writes on this action, so the badge never
      // opens on a stale terminal value while the 3s poll catches up
      if (optimistic) mfaStateFor(w).status(optimistic);
      v.active(true);
    };
    self.verdictOn = function (w) { return verdictFor(w).active(); };
    self.verdictClass = function (w) {
      var s = String(mfaStateFor(w).status() || '').toUpperCase();
      var m = VERDICT_MAP[s] || VERDICT_MAP.CHECKING;
      return 'wk-verdict wk-verdict--' + m.cls;
    };
    self.verdictText = function (w) {
      var v = verdictFor(w);
      var s = String(mfaStateFor(w).status() || '').toUpperCase();
      var m = VERDICT_MAP[s] || VERDICT_MAP.CHECKING;
      if (VERDICT_TERMINAL[s] && v.active() && !v.timer) {
        v.timer = setTimeout(function () { v.timer = null; v.active(false); }, 90000);
      }
      return i18n.t(m.key);
    };

    atd.getActionStats().then(function (a) { self.actions(a); }).catch(function () {});
    // fleet table + per-VM session ages, reloadable from the region-header ↻ button
    self.fleetLoading = ko.observable(false);
    self.loadFleet = function () {
      if (self.fleetLoading()) return;
      self.fleetLoading(true);
      var workersDone = atd.listWorkers().then(function (r) {
        var rows = (r && r.items) || [];
        rows.forEach(syncMfa); self.workers(rows);
      }).catch(function () {});
      var agesDone = atd.getJobHealth().then(function (h) {
        self.breakInfo(h.break || null);
        self.jobHealth(h.jobs || []);
        (h.workers || []).forEach(function (w) { self._sessAge[w.workerId] = w; });
      }).catch(function () {});
      Promise.all([workersDone, agesDone]).then(function () {
        self.workers.valueHasMutated();          // re-render with fresh session ages
        self.fleetLoading(false);
      });
    };
    self.loadFleet();
    self.refreshMfaOnly = function () {
      if (self._mfaPollBusy || document.hidden) return;
      self._mfaPollBusy = true;
      atd.pollWorkers().then(function (r) {
        var latest = (r && r.items) || [];
        latest.forEach(syncMfa);
      }).catch(function () {
        // Best-effort live status: the normal page data remains usable during an API blip.
      }).then(function () { self._mfaPollBusy = false; });
    };
    self.startMfaPolling = function () {
      if (!self._mfaPollTimer) self._mfaPollTimer = window.setInterval(self.refreshMfaOnly, 3000);
    };
    self.stopMfaPolling = function () {
      if (self._mfaPollTimer) window.clearInterval(self._mfaPollTimer);
      self._mfaPollTimer = null;
    };
    // Fusion write-back actions in the SAME view as the extracts (user request
    // 2026-07-26: a 101-invoice AR-rebill drain ran all night invisible here)
    self.recentActions = ko.observableArray([]);
    atd.listActions({ limit: 8 })
      .then(function (r) { self.recentActions((r && r.items) || []); })
      .catch(function () {});
    // observability (break window + per-VM session age + per-job freshness) loads
    // with the fleet table via loadFleet() above.

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
    self.loginTime = function (w) {
      if (!w || w.lastLoginSeconds === '' || w.lastLoginSeconds == null) return '—';
      var seconds = Number(w.lastLoginSeconds);
      return seconds < 60 ? (seconds + 's') : (Math.floor(seconds / 60) + 'm ' + Math.round(seconds % 60) + 's');
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
    self.statusText = function (r) {
      return r && r.status === 'SUCCESS' && Number(r.rowCount) === 0
        ? i18n.t('atd.status.successNoData') : ((r && r.status) || '');
    };
    self.isNoData = function (r) { return !!(r && r.status === 'SUCCESS' && Number(r.rowCount) === 0); };
    // a worker is "online" when its heartbeat is fresh (ORDS computes online=Y, age<=120s)
    self.workerDot = function (w) { return (w && w.online === 'Y') ? '#2A7D3A' : '#C13A30'; };
    self.workerAge = function (w) {
      var s = (w && w.ageSec) || 0;
      return s < 90 ? (s + 's') : (Math.round(s / 60) + 'm');
    };
    self.mfaLabel = function (w) {
      var s = String(mfaStateFor(w).status() || '').toUpperCase();
      return s ? i18n.t('atd.workers.mfa.' + s.toLowerCase()) : '—';
    };
    self.mfaPending = function (w) {
      return ['DETECTED', 'DELIVERED', 'FAILED'].indexOf(
        String(mfaStateFor(w).status() || '').toUpperCase()) >= 0;
    };
    self.checkWorkerSession = function (w) {
      if (!w || !w.workerId) return;
      atd.checkWorkerSession(w.workerId)
        .then(function () {
          self.startVerdict(w, 'CHECKING');
          toast.success(i18n.t('atd.workers.check.asked').replace('{vm}', w.workerId));
        })
        .catch(function () { toast.error(i18n.t('atd.workers.check.failed')); });
    };
    // operator-triggered re-login: ask this worker to start a fresh Fusion login;
    // the MFA number then arrives in Telegram / Authenticator for approval.
    self.refreshWorker = function (w) {
      if (!w || !w.workerId) return;
      if (!window.confirm(i18n.t('atd.workers.refresh.confirm').replace('{vm}', w.workerId))) return;
      atd.refreshWorker(w.workerId)
        .then(function () {
          self.startVerdict(w, 'REQUESTED');
          toast.success(i18n.t('atd.workers.refresh.asked').replace('{vm}', w.workerId));
        })
        .catch(function () { toast.error(i18n.t('atd.workers.refresh.failed')); });
    };
    // operator hold: pause = claim nothing new (the in-flight job finishes first)
    self.pauseWorker = function (w) {
      if (!w || !w.workerId) return;
      atd.pauseWorker(w.workerId)
        .then(function () {
          toast.success(i18n.t('atd.workers.pause.asked').replace('{vm}', w.workerId));
          self.loadFleet();
        })
        .catch(function () { toast.error(i18n.t('atd.workers.pause.failed')); });
    };
    self.resumeWorker = function (w) {
      if (!w || !w.workerId) return;
      atd.resumeWorker(w.workerId)
        .then(function () {
          toast.success(i18n.t('atd.workers.resume.asked').replace('{vm}', w.workerId));
          self.loadFleet();
        })
        .catch(function () { toast.error(i18n.t('atd.workers.resume.failed')); });
    };
    // drill-down: the VM name opens Run Logs pre-filtered to that host
    self.openWorkerRuns = function (w) {
      if (!w || !w.workerId) return;
      window._jetApp.navigate('runs', { vmFilter: w.workerId });
    };
    // all live Fusion sessions this worker holds (service + per-user personal
    // profiles, from heartbeat sessions_json); sessions other than the account
    // shown on the row render as muted sub-lines with their own age
    self.workerSessions = function (w) {
      var raw = w && w.sessionsJson;
      if (!raw) return [];
      var list;
      try { list = JSON.parse(raw) || []; } catch (e) { return []; }
      var main = String(w.sessionAccount || '').toLowerCase();
      return list.filter(function (s) {
        return s && s.account && String(s.account).toLowerCase() !== main;
      }).map(function (s) {
        return {
          account: s.account,
          kind: i18n.t(s.kind === 'personal' ? 'atd.workers.sess.personal'
                                             : 'atd.workers.sess.service'),
          age: (s.ageMin === null || s.ageMin === undefined) ? '' : ageText(Number(s.ageMin))
        };
      });
    };
    // pill shows PAUSED as soon as the flag is set (the heartbeat status catches
    // up on the worker's next beat); a BUSY worker keeps BUSY until it finishes
    self.workerStatusText = function (w) {
      if (w && w.paused === 'Y' && w.status !== 'BUSY') return 'PAUSED';
      return (w && w.status) || '';
    };
    // offline banner: DOWN (peer-flagged), or silent > 5 min while not mid-job
    // (a BUSY worker legitimately stops heartbeating for the length of a run)
    self.offlineWorkers = ko.computed(function () {
      return self.workers().filter(function (w) {
        return w.status === 'DOWN' ||
               (w.online !== 'Y' && w.status !== 'BUSY' && Number(w.ageSec) > 300);
      });
    });

    atd.getDashboard().then(function (d) {
      self.k(d);
      self.queue(d.queue || {});
      self.recent(d.recent || []);
      self.alerts((d.alerts || []).filter(function (r) { return !self.isNoData(r); }));
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
