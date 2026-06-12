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

    /* ── Wave 4 (4.2): user-configurable layout ──────────────────────────
       Stat cards can be hidden/reordered, charts + module grid hidden.
       Persisted per-user as JSON in /prefs/DASHBOARD_LAYOUT. */
    var STAT_DEFS = [
      { id: 'activeUsers',      cls: 'stat-card--red',    key: 'dash.activeUsers' },
      { id: 'activeModules',    cls: 'stat-card--blue',   key: 'dash.activeModules' },
      { id: 'rolesDefined',     cls: 'stat-card--green',  key: 'dash.rolesDefined' },
      { id: 'pendingApprovals', cls: 'stat-card--orange', key: 'dash.pendingApprovals' },
      { id: 'activeSessions',   cls: 'stat-card--blue',   key: 'dash.activeSessions' },
    ];
    self.customizing = ko.observable(false);
    self.layout = ko.observable({ order: STAT_DEFS.map(function (d) { return d.id; }), hidden: [] });

    function normLayout(l) {
      var ids = STAT_DEFS.map(function (d) { return d.id; });
      var order = ((l && l.order) || []).filter(function (id) { return ids.indexOf(id) >= 0; });
      ids.forEach(function (id) { if (order.indexOf(id) < 0) order.push(id); });
      return { order: order, hidden: (l && l.hidden) || [] };
    }
    require(['services/api'], function (api) {
      api.get('/prefs/', { silent: true }).then(function (r) {
        var row = (r.items || []).find(function (p) { return p.key === 'DASHBOARD_LAYOUT'; });
        if (row && row.value) {
          try { self.layout(normLayout(JSON.parse(row.value))); } catch (e) {}
        }
      }).catch(function () {});
    });

    self.isHidden = function (id) { return self.layout().hidden.indexOf(id) >= 0; };
    self.toggleWidget = function (id) {
      var l = self.layout();
      var h = l.hidden.slice();
      var i = h.indexOf(id);
      if (i >= 0) h.splice(i, 1); else h.push(id);
      self.layout({ order: l.order, hidden: h });
      // re-showing a chart re-creates its canvas — paint it on the next tick
      if (self._statsData) setTimeout(function () { renderCharts(self._statsData); }, 0);
    };
    self.moveStat = function (id, dir) {
      var l = self.layout();
      var order = l.order.slice();
      var i = order.indexOf(id);
      var j = i + dir;
      if (i < 0 || j < 0 || j >= order.length) return;
      order[i] = order[j];
      order[j] = id;
      self.layout({ order: order, hidden: l.hidden });
    };
    self.statCards = ko.computed(function () {
      var l = self.layout();
      var custom = self.customizing();
      return l.order.map(function (id) {
        return STAT_DEFS.find(function (d) { return d.id === id; });
      }).filter(function (d) {
        return d && (custom || l.hidden.indexOf(d.id) < 0);
      });
    });
    self.toggleCustomize = function () {
      if (self.customizing()) {
        // leaving customize mode = save
        require(['services/api'], function (api) {
          api.put('/prefs/DASHBOARD_LAYOUT',
                  { value: JSON.stringify(self.layout()) }, { silent: true })
            .catch(function () {});
        });
      }
      self.customizing(!self.customizing());
      if (self._statsData) setTimeout(function () { renderCharts(self._statsData); }, 0);
    };

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
          options: {
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } },
            // Wave 3 drill-down: bar → approval monitor pre-filtered to module
            onHover: function (e, els) { e.native.target.style.cursor = els.length ? 'pointer' : ''; },
            onClick: function (e, els) {
              if (!els.length) return;
              sessionStorage.setItem('amPresetSearch', cyc[els[0].index].module || '');
              if (window._jetApp) window._jetApp.navigate('approvalMonitor');
            }
          }
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
          options: {
            scales: { y: { beginAtZero: true, ticks: { precision: 0 } } },
            // Wave 3 drill-down: logins series → audit log filtered to LOGIN
            onHover: function (e, els) { e.native.target.style.cursor = els.length ? 'pointer' : ''; },
            onClick: function (e, els) {
              if (!els.length) return;
              sessionStorage.setItem('auditPresetAction',
                els[0].datasetIndex === 0 ? 'LOGIN' : '');
              if (window._jetApp) window._jetApp.navigate('auditLog');
            }
          }
        });
      }
    }

    auditService.getStats().then(function (s) {
      self._statsData = s;   // kept for re-render when widgets are re-shown
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
