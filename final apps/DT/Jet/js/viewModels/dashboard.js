define(['knockout', 'services/authService', 'services/dtService', 'services/settingService',
        'shared/i18n', 'shared/chartLoader'],
function (ko, authService, dtService, settingService, i18n, charts) {
  'use strict';

  function DashboardViewModel() {
    var self = this;
    self.t = i18n.t;

    var user = authService.getCurrentUser();
    self.user = user;

    self.greeting = ko.computed(function () {
      var h = new Date().getHours();
      return i18n.t(h < 12 ? 'dash.greetingM' : h < 17 ? 'dash.greetingA' : 'dash.greetingE');
    });
    self.todayDate = ko.computed(function () {
      i18n.lang();
      return i18n.fmtDate(new Date(), { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });
    });

    self.stats = {
      activeRequests: ko.observable(0),
      draftRequests:  ko.observable(0),
      needSettlement: ko.observable(0),
      totalAdvance:   ko.observable('0.00'),
    };

    self.recentRequests = ko.observableArray([]);
    self.loading        = ko.observable(true);
    self.chartsEmpty    = ko.observable(false);

    self.isApprover  = authService.isApprover();
    self.isDtFinance = authService.isDtFinance();
    self.isDtAdmin   = authService.isDtAdmin();

    self.newRequest    = function () { if (window._dtApp) window._dtApp.navigate('requestForm'); };
    self.viewRequests  = function () { if (window._dtApp) window._dtApp.navigate('myRequests'); };
    self.viewApprovals = function () { if (window._dtApp) window._dtApp.navigate('approvals'); };
    self.viewDisburse  = function () { if (window._dtApp) window._dtApp.navigate('disbursementQueue'); };

    self.openRequest = function (req) {
      if (window._dtApp) window._dtApp.navigate('requestDetail', { reqId: req.reqId });
    };

    // ── Phase 3 charts (additive series on GET /dashboard/) ─────────────
    function _renderCharts(stats) {
      var p = charts.palette();
      var spend  = stats.monthlySpend || [];
      var funnel = stats.statusFunnel || [];
      self.chartsEmpty(spend.length === 0 && funnel.length === 0);

      var c1 = document.getElementById('dtChart1');
      if (c1 && spend.length) {
        charts.makeChart(c1, {
          type: 'line',
          data: {
            labels: spend.map(function (r) { return r.month; }),
            datasets: [
              { label: 'Advances', data: spend.map(function (r) { return r.advances; }),
                borderColor: p.brand, backgroundColor: charts.alpha(p.brand, .12), fill: true, tension: .35 },
              { label: 'Per-diem', data: spend.map(function (r) { return r.perDiem; }),
                borderColor: p.amber, borderDash: [6, 4], tension: .35 }
            ]
          },
          options: { scales: { y: { beginAtZero: true } } }
        });
      }
      var c2 = document.getElementById('dtChart2');
      if (c2 && funnel.length) {
        charts.makeChart(c2, {
          type: 'bar',
          data: {
            labels: funnel.map(function (r) { return r.status; }),
            datasets: [{ label: 'requests', data: funnel.map(function (r) { return r.count; }),
                         backgroundColor: charts.alpha(p.brand, .7), borderRadius: 6 }]
          },
          options: { indexAxis: 'y', plugins: { legend: { display: false } },
                     scales: { x: { beginAtZero: true, ticks: { precision: 0 } } } }
        });
      }
    }

    function _load() {
      dtService.getDashboardStats(user.userId).then(function (stats) {
        self.stats.activeRequests(stats.activeRequests);
        self.stats.draftRequests(stats.draftRequests);
        self.stats.needSettlement(stats.needSettlement);
        self.stats.totalAdvance(i18n.fmtNum(stats.totalAdvance || 0, 2));
        self.recentRequests(stats.recentRequests || []);
        self.loading(false);
        setTimeout(function () { _renderCharts(stats); }, 0);
      }).catch(function () {
        self.loading(false);
        self.chartsEmpty(true);
      });
    }

    _load();
  }

  return DashboardViewModel;
});
