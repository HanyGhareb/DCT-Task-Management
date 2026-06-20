define(['knockout', 'services/tmService', 'shared/i18n', 'shared/chartLoader'],
function (ko, tm, i18n, charts) {
  'use strict';
  return function Exec() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.teams = ko.observableArray([]);
    self.groupBy = ko.observable('org');   // org | tree | flat

    // ---- KPI roll-ups ----
    self.kTeams   = ko.computed(function () { return self.teams().length; });
    self.kOverdue = ko.computed(function () { return self.teams().reduce(function (a, t) { return a + (t.overdueTasks || 0); }, 0); });
    self.kRisks   = ko.computed(function () { return self.teams().reduce(function (a, t) { return a + (t.highRisks || 0); }, 0); });
    self.kOnTime  = ko.computed(function () {
      var v = self.teams().filter(function (t) { return t.onTimeRate !== null && t.onTimeRate !== undefined; });
      if (!v.length) return '—';
      return Math.round(v.reduce(function (a, t) { return a + t.onTimeRate; }, 0) / v.length) + '%';
    });

    // ---- grouped scorecard ----
    self.groups = ko.computed(function () {
      var by = self.groupBy(), rows = self.teams(), map = {}, order = [], nm = {};
      rows.forEach(function (t) { nm[t.teamId] = t.teamName; });
      rows.forEach(function (t) {
        var key = by === 'flat' ? self.t('tm.exec.flat')
                : by === 'tree' ? (t.parentTeamId ? (nm[t.parentTeamId] || self.t('tm.exec.flat')) : t.teamName)
                : (t.orgName || '—');
        if (!map[key]) { map[key] = []; order.push(key); }
        map[key].push(t);
      });
      return order.map(function (k) { return { name: k, teams: map[k] }; });
    });

    self.ragDot = function (rag) { return 'rag-dot rag-dot--' + (rag || 'GREY'); };
    self.badges = function (t) {
      var b = [];
      if (t.onTimeRate === 100) b.push({ cls: 'tm-badge tm-badge--gold',  label: '★ ' + self.t('tm.badge.onTimeStreak') });
      if ((t.overdueTasks || 0) === 0) b.push({ cls: 'tm-badge tm-badge--green', label: '✓ ' + self.t('tm.badge.zeroOverdue') });
      if ((t.objectiveProgress || 0) >= 90 && (t.highRisks || 0) === 0) b.push({ cls: 'tm-badge tm-badge--blue', label: '◎ ' + self.t('tm.badge.onTrack') });
      return b;
    };
    self.barStyle = function (pct) { return 'width:' + Math.max(0, Math.min(100, pct || 0)) + '%'; };
    self.setGroup = function (g) { self.groupBy(g); };
    self.openTeam = function (t) { window._jetApp.navigate('teamDetail', { teamId: t.teamId }); };

    function renderChart() {
      setTimeout(function () {
        var counts = { GREEN: 0, AMBER: 0, RED: 0, GREY: 0 };
        self.teams().forEach(function (t) { counts[t.health || 'GREY'] = (counts[t.health || 'GREY'] || 0) + 1; });
        var el = document.getElementById('execRagChart');
        if (el) charts.makeChart(el, {
          type: 'doughnut',
          data: {
            labels: ['On track', 'Needs attention', 'Off track', 'No data'],
            datasets: [{ data: [counts.GREEN, counts.AMBER, counts.RED, counts.GREY],
                         backgroundColor: ['#3FB950', '#F0883E', '#F85149', '#8A93A2'] }]
          },
          options: { plugins: { legend: { position: 'bottom' } } }
        });
        // on-time leaderboard (top 8 by on-time rate)
        var lb = self.teams().filter(function (t) { return t.onTimeRate !== null && t.onTimeRate !== undefined; })
                   .sort(function (a, b) { return b.onTimeRate - a.onTimeRate; }).slice(0, 8);
        var el2 = document.getElementById('execOnTimeChart');
        if (el2) charts.makeChart(el2, {
          type: 'bar',
          data: {
            labels: lb.map(function (t) { return t.teamCode || t.teamName; }),
            datasets: [{ label: 'On-time %', data: lb.map(function (t) { return t.onTimeRate; }),
                         backgroundColor: '#0E8A8A', borderRadius: 6 }]
          },
          options: { indexAxis: 'y', plugins: { legend: { display: false } },
                     scales: { x: { beginAtZero: true, max: 100, ticks: { precision: 0 } } } }
        });
      }, 40);
    }

    self.load = function () {
      self.loading(true);
      tm.execTeams().then(function (r) {
        self.teams(r.items || []); self.loading(false); renderChart();
      }).catch(function () { self.loading(false); });
    };
    self.load();
  };
});
