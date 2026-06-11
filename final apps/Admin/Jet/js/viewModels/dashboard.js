define(['knockout', 'services/authService', 'services/moduleService', 'services/auditService',
        'shared/i18n', 'shared/chartLoader'],
function (ko, authService, moduleService, auditService, i18n, charts) {
  'use strict';

  function DashboardViewModel() {
    var self = this;
    self.t = i18n.t;

    var user  = authService.getCurrentUser();
    self.user = user;

    self.greeting = ko.computed(function () {
      var h = new Date().getHours();
      return i18n.t(h < 12 ? 'dash.greetingM' : h < 17 ? 'dash.greetingA' : 'dash.greetingE');
    });
    self.todayDate = ko.computed(function () {
      i18n.lang();
      return i18n.fmtDate(new Date(), { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });
    });

    /* Headline stats + chart series — one GET /stats/ (Phase 3) */
    self.statsLoading = ko.observable(true);
    self.stats        = ko.observable({
      activeUsers: '—', activeModules: '—', rolesDefined: '—',
      pendingApprovals: '—', activeSessions: '—'
    });
    self.chartsEmpty  = ko.observable(false);

    function renderCharts(data) {
      var p = charts.palette();
      var cyc = data.approvalCycle || [];
      var act = data.activity || [];
      self.chartsEmpty(cyc.length === 0 && act.length === 0);

      var c1 = document.getElementById('admChart1');
      if (c1 && cyc.length) {
        charts.makeChart(c1, {
          type: 'bar',
          data: {
            labels: cyc.map(function (r) { return r.module; }),
            datasets: [{
              label: i18n.t('dash.avgDays'),
              data: cyc.map(function (r) { return r.avgDays; }),
              backgroundColor: charts.alpha(p.brand, .75),
              borderRadius: 6
            }]
          },
          options: { plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }
        });
      }
      var c2 = document.getElementById('admChart2');
      if (c2 && act.length) {
        charts.makeChart(c2, {
          type: 'line',
          data: {
            labels: act.map(function (r) { return r.day.slice(5); }),
            datasets: [
              { label: i18n.t('dash.logins'),  data: act.map(function (r) { return r.logins; }),
                borderColor: p.brand, backgroundColor: charts.alpha(p.brand, .12), fill: true, tension: .35 },
              { label: i18n.t('dash.actions'), data: act.map(function (r) { return r.actions; }),
                borderColor: p.amber, backgroundColor: charts.alpha(p.amber, .10), fill: true, tension: .35 }
            ]
          },
          options: { scales: { y: { beginAtZero: true, ticks: { precision: 0 } } } }
        });
      }
    }

    auditService.getStats().then(function (s) {
      self.stats({
        activeUsers:      s.activeUsers,
        activeModules:    s.activeModules,
        rolesDefined:     s.rolesDefined,
        pendingApprovals: s.pendingApprovals,
        activeSessions:   s.activeSessions
      });
      self.statsLoading(false);
      // canvases exist only after KO renders the ifnot:statsLoading block
      setTimeout(function () { renderCharts(s); }, 0);
    }).catch(function () {
      self.statsLoading(false);
      self.chartsEmpty(true);
    });

    /* Module cards — unchanged behavior */
    self.categoryGroups = ko.observableArray([]);
    var categories = moduleService.getCategories();
    moduleService.getAccessibleForUser().then(function (allMods) {
      var groups = categories
        .map(function (cat) {
          return {
            id: cat.id, label: cat.label, icon: cat.icon,
            modules: allMods.filter(function (m) { return m.category === cat.id; }),
          };
        })
        .filter(function (g) { return g.modules.length > 0; });
      self.categoryGroups(groups);
    }).catch(function () {});
  }

  return DashboardViewModel;
});
