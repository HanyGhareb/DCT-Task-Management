define(['knockout', 'services/arService', 'shared/i18n', 'shared/chartLoader'],
function (ko, arService, i18n, charts) {
  'use strict';

  function DashboardViewModel() {
    var self = this;
    self.t = i18n.t;

    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);

    self.eventsYtd      = ko.observable(0);
    self.totalRevenue   = ko.observable('—');
    self.totalExpense   = ko.observable('—');
    self.netResult      = ko.observable('—');
    self.pendingReviews = ko.observable(0);
    self.potentialLoss  = ko.observable('—');

    self.openEvents = function () { window._arApp.navigate('events'); };

    function fmt(n) { return i18n.fmtNum ? i18n.fmtNum(n || 0, 0) : String(n || 0); }

    function _renderCharts(stats) {
      var p = charts.palette();

      var c1 = document.getElementById('arChart1');
      if (c1 && (stats.revExpByEvent || []).length) {
        charts.makeChart(c1, {
          type: 'bar',
          data: {
            labels: stats.revExpByEvent.map(function (r) { return r.event; }),
            datasets: [
              { label: 'Revenue', data: stats.revExpByEvent.map(function (r) { return r.revenue; }),
                backgroundColor: charts.alpha(p.brand, .75) },
              { label: 'Expense', data: stats.revExpByEvent.map(function (r) { return r.expense; }),
                backgroundColor: charts.alpha(p.red, .65) },
            ]
          }
        });
      }

      var c2 = document.getElementById('arChart2');
      if (c2 && (stats.marginTrend || []).length) {
        charts.makeChart(c2, {
          type: 'line',
          data: {
            labels: stats.marginTrend.map(function (r) { return r.month; }),
            datasets: [
              { label: 'Net result', data: stats.marginTrend.map(function (r) { return r.net; }),
                borderColor: p.brand, backgroundColor: charts.alpha(p.brand, .12),
                fill: true, tension: .3 },
            ]
          }
        });
      }

      var c3 = document.getElementById('arChart3');
      if (c3 && (stats.expenseByCategory || []).length) {
        charts.makeChart(c3, {
          type: 'doughnut',
          data: {
            labels: stats.expenseByCategory.map(function (r) { return r.category; }),
            datasets: [{ data: stats.expenseByCategory.map(function (r) { return r.amount; }) }]
          }
        });
      }

      var c4 = document.getElementById('arChart4');
      if (c4 && (stats.budgetVsActual || []).length) {
        charts.makeChart(c4, {
          type: 'bar',
          data: {
            labels: stats.budgetVsActual.map(function (r) { return r.event; }),
            datasets: [
              { label: 'Budget expense', data: stats.budgetVsActual.map(function (r) { return r.budget; }),
                backgroundColor: charts.alpha(p.blue, .55) },
              { label: 'Actual expense', data: stats.budgetVsActual.map(function (r) { return r.actual; }),
                backgroundColor: charts.alpha(p.amber, .75) },
            ]
          }
        });
      }
    }

    arService.getDashboard().then(function (stats) {
      self.eventsYtd(stats.eventsYtd || 0);
      self.totalRevenue(fmt(stats.totalRevenue));
      self.totalExpense(fmt(stats.totalExpense));
      self.netResult(fmt(stats.netResult));
      self.pendingReviews(stats.pendingReviews || 0);
      self.potentialLoss(fmt(stats.potentialLoss));
      self.loading(false);
      setTimeout(function () { _renderCharts(stats); }, 0);
    }).catch(function () {
      self.loading(false);
      self.loadError(true);
    });
  }

  return DashboardViewModel;
});
