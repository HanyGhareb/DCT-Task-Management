define(['knockout', 'services/authService', 'services/pcService', 'services/settingService',
        'shared/i18n', 'shared/chartLoader'],
function (ko, authService, pcService, settingService, i18n, charts) {
  'use strict';

  function DashboardViewModel() {
    var self = this;
    self.t = i18n.t;

    var user = authService.getCurrentUser();
    self.user = user;

    self.greeting = ko.computed(function () {
      var h = new Date().getHours();
      return h < 12 ? 'Good morning' : h < 17 ? 'Good afternoon' : 'Good evening';
    });
    self.todayDate = new Date().toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });

    // Stats
    self.stats = {
      activePc:            ko.observable(0),
      pendingPc:           ko.observable(0),
      totalFloat:          ko.observable('0.00'),
      reimbPending:        ko.observable(0),
      orgPendingApprovals: ko.observable(0),
    };

    self.activeRecord   = ko.observable(null);
    self.recentActivity = ko.observableArray([]);
    self.loading        = ko.observable(true);
    self.closingMsg     = ko.observable('');
    self.showClosingBanner = ko.observable(false);

    self.isApprover = authService.isApprover();
    self.isPcAdmin  = authService.isPcAdmin();

    // Quick actions
    self.newRequest = function () { if (window._pcApp) window._pcApp.navigate('pcRequest'); };
    self.newReimb   = function () { if (window._pcApp) window._pcApp.navigate('reimbDetail'); };
    self.newClear   = function () { if (window._pcApp) window._pcApp.navigate('clearDetail'); };
    self.viewMy     = function () { if (window._pcApp) window._pcApp.navigate('myPettyCash'); };
    self.viewApprovals = function() { if (window._pcApp) window._pcApp.navigate('approvals'); };

    self.hasActivePc = ko.computed(function() {
      return self.activeRecord() !== null;
    });

    function _statusClass(s) {
      var map = { ACTIVE:'badge--active', PENDING_APPROVAL:'badge--pending', APPROVED:'badge--info',
                  SUBMITTED:'badge--pending', CLOSED:'badge--inactive', REJECTED:'badge--rejected' };
      return 'badge ' + (map[s] || 'badge--info');
    }
    self.statusClass = _statusClass;

    function _load() {
      pcService.getDashboardStats(user.userId).then(function(stats) {
        self.stats.activePc(stats.activePc);
        self.stats.pendingPc(stats.pendingPc);
        self.stats.totalFloat(stats.totalFloatFormatted);
        self.stats.reimbPending(stats.reimbPending);
        self.stats.orgPendingApprovals(stats.orgPendingApprovals || 0);
        if (stats.activeRecord) self.activeRecord(stats.activeRecord);
        self.loading(false);
      }).catch(function() { self.loading(false); });

      pcService.getRecentActivity(user.userId).then(function(list) {
        self.recentActivity(list);
      });

      // Closing banner
      var msg  = settingService.getValue('TEMP_PC_CLOSING_DEADLINE_MSG');
      var show = settingService.getValue('SHOW_CLOSING_BANNER');
      if (show === 'Y' && msg) {
        self.closingMsg(msg);
        self.showClosingBanner(true);
      }
    }

    // ── Phase 3 charts (GET /pc/charts) ──────────────────────────────────
    self.chartsLoading = ko.observable(true);
    self.chartsEmpty   = ko.observable(false);

    function _renderCharts(d) {
      var p = charts.palette();
      var orgs = d.floatsByOrg || [];
      var age  = d.tempAgeing || [];
      self.chartsEmpty(orgs.length === 0 && age.length === 0);

      var c1 = document.getElementById('pcChart1');
      if (c1 && orgs.length) {
        charts.makeChart(c1, {
          type: 'bar',
          data: {
            labels: orgs.map(function (r) { return r.org; }),
            datasets: [{ label: 'AED', data: orgs.map(function (r) { return r.outstanding; }),
                         backgroundColor: charts.alpha(p.brand, .75), borderRadius: 6 }]
          },
          options: { plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }
        });
      }
      var c2 = document.getElementById('pcChart2');
      if (c2 && age.length) {
        var order = ['0-30', '31-60', '61-90', '90+'];
        var byB = {}; age.forEach(function (r) { byB[r.bucket] = r.count; });
        charts.makeChart(c2, {
          type: 'bar',
          data: {
            labels: order,
            datasets: [{ label: 'floats',
                         data: order.map(function (b) { return byB[b] || 0; }),
                         backgroundColor: [charts.alpha(p.green, .65), charts.alpha(p.amber, .65),
                                           charts.alpha(p.amber, .85), charts.alpha(p.red, .7)],
                         borderRadius: 6 }]
          },
          options: { plugins: { legend: { display: false } },
                     scales: { y: { beginAtZero: true, ticks: { precision: 0 } } } }
        });
      }
    }

    pcService.getCharts().then(function (d) {
      self.chartsLoading(false);
      setTimeout(function () { _renderCharts(d); }, 0);
    }).catch(function () {
      self.chartsLoading(false);
      self.chartsEmpty(true);
    });

    _load();
  }

  return DashboardViewModel;
});
