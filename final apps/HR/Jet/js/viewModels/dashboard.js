define(['knockout', 'services/authService', 'services/hrService', 'shared/i18n', 'shared/chartLoader'],
function (ko, authService, hrService, i18n, charts) {
  'use strict';

  function DashboardViewModel() {
    var self = this;
    self.t = i18n.t;

    self.user     = authService.getCurrentUser();
    self.isAdmin  = authService.isHrAdmin();
    self.isMgr    = authService.isHrManager();

    self.greeting = ko.computed(function () {
      var h = new Date().getHours();
      return i18n.t(h < 12 ? 'dash.greetingM' : h < 17 ? 'dash.greetingA' : 'dash.greetingE');
    });
    self.todayDate = ko.computed(function () {
      i18n.lang();
      return i18n.fmtDate(new Date(), { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });
    });

    self.stats = {
      totalEmployees:  ko.observable(0),
      totalPositions:  ko.observable(0),
      filledPositions: ko.observable(0),
      vacancies:       ko.observable(0),
      expiringDocs:    ko.observable(0),
    };
    self.fillRate = ko.computed(function () {
      var total = self.stats.totalPositions();
      if (!total) return 0;
      return Math.round((self.stats.filledPositions() / total) * 100);
    });

    self.headcountByOrg = ko.observableArray([]);
    self.loading        = ko.observable(true);

    self.goEmployees  = function () { if (window._hrApp) window._hrApp.navigate('employees'); };
    self.goPositions  = function () { if (window._hrApp) window._hrApp.navigate('positions'); };
    self.goDocuments  = function () { if (window._hrApp) window._hrApp.navigate('documents'); };
    self.goOrgChart   = function () { if (window._hrApp) window._hrApp.navigate('orgHierarchy'); };

    // ── Phase 3 charts (reuse existing report endpoints — no DB change) ──
    self.chartsEmpty = ko.observable(false);

    function _renderCharts(headcount, docs) {
      var p = charts.palette();
      var hc = (headcount || []).map(function (r) {
        return {
          org:      r.orgNameEn || r.org_name_en || ('Org ' + (r.orgId || r.org_id || '')),
          approved: r.totalApproved !== undefined ? r.totalApproved : (r.total_approved || 0),
          filled:   r.totalFilled   !== undefined ? r.totalFilled   : (r.total_filled   || 0)
        };
      }).filter(function (r) { return r.approved > 0 || r.filled > 0; }).slice(0, 8);
      var buckets = { '0-30': 0, '31-60': 0, '61-90': 0 };
      (docs || []).forEach(function (d) {
        var n = d.daysUntilExpiry !== undefined ? d.daysUntilExpiry : d.days_until_expiry;
        if (n === null || n === undefined) return;
        if (n <= 30) buckets['0-30']++;
        else if (n <= 60) buckets['31-60']++;
        else buckets['61-90']++;
      });
      var totalDocs = buckets['0-30'] + buckets['31-60'] + buckets['61-90'];
      self.chartsEmpty(hc.length === 0 && totalDocs === 0);

      var c1 = document.getElementById('hrChart1');
      if (c1 && hc.length) {
        charts.makeChart(c1, {
          type: 'bar',
          data: {
            labels: hc.map(function (r) { return r.org; }),
            datasets: [
              { label: 'Approved', data: hc.map(function (r) { return r.approved; }),
                backgroundColor: charts.alpha(p.text3, .35), borderRadius: 6 },
              { label: 'Filled', data: hc.map(function (r) { return r.filled; }),
                backgroundColor: charts.alpha(p.brand, .75), borderRadius: 6 }
            ]
          },
          options: { scales: { y: { beginAtZero: true, ticks: { precision: 0 } } } }
        });
      }
      var c2 = document.getElementById('hrChart2');
      if (c2 && totalDocs) {
        charts.makeChart(c2, {
          type: 'bar',
          data: {
            labels: ['0–30 days', '31–60', '61–90'],
            datasets: [{ label: 'documents',
                         data: [buckets['0-30'], buckets['31-60'], buckets['61-90']],
                         backgroundColor: [charts.alpha(p.red, .7), charts.alpha(p.amber, .7), charts.alpha(p.green, .6)],
                         borderRadius: 6 }]
          },
          options: { plugins: { legend: { display: false } },
                     scales: { y: { beginAtZero: true, ticks: { precision: 0 } } } }
        });
      }
    }

    function _load() {
      Promise.all([
        hrService.getDashboardStats(),
        hrService.getHeadcountSummary(),
        hrService.getExpiringDocs(90),
      ]).then(function (results) {
        var stats = results[0];
        self.stats.totalEmployees(stats.totalEmployees || 0);
        self.stats.totalPositions(stats.totalPositions || 0);
        self.stats.filledPositions(stats.filledPositions || 0);
        self.stats.vacancies(stats.vacancies || 0);
        self.stats.expiringDocs(stats.expiringDocs || 0);
        self.headcountByOrg(results[1] || []);
        self.loading(false);
        setTimeout(function () { _renderCharts(results[1], results[2]); }, 0);
      }).catch(function () {
        self.loading(false);
        self.chartsEmpty(true);
      });
    }

    _load();
  }

  return DashboardViewModel;
});
