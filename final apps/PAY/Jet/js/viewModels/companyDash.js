define(['knockout', 'services/payService', 'shared/i18n'],
function (ko, payService, i18n) {
  'use strict';

  function CompanyDashViewModel() {
    var self = this;
    self.t = i18n.t;

    self.loading = ko.observable(true);
    self.error   = ko.observable('');
    self.d       = ko.observable(null);

    self.money = function (v) {
      if (v === null || v === undefined || v === '') return '—';
      return Number(v).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    };
    self.num = function (v) {
      if (v === null || v === undefined || v === '') return '—';
      return Number(v).toLocaleString('en-US');
    };

    self.back = function () { if (window._jetApp) window._jetApp.navigate('companies'); };
    self.openContract = function (row) {
      if (window._jetApp) window._jetApp.navigate('contracts', { openContractId: row.contractId });
    };
    self.goEmployees = function () { if (window._jetApp) window._jetApp.navigate('employees'); };
    self.goRuns = function () { if (window._jetApp) window._jetApp.navigate('payRuns'); };

    var state = (window._jetApp && window._jetApp.getState && window._jetApp.getState()) || {};
    var cid = state.dashCompanyId;
    delete state.dashCompanyId;
    if (!cid) { self.back(); return; }

    self._charts = [];
    self._renderCharts = function (d) {
      require(['shared/chartLoader'], function (cl) {
        self._charts.forEach(function (c) { try { c.destroy(); } catch (e) {} });
        self._charts = [];
        var mk = function (id, cfg) {
          var el = document.getElementById(id);
          if (el) { self._charts.push(cl.makeChart(el, cfg)); }
        };
        var pcc = d.paidByCc || [];
        mk('cdPaidCc', {
          type: 'bar',
          data: {
            labels: pcc.map(function (x) { return x.costCenter + ((x.label || '') ? ' · ' + x.label : ''); }),
            datasets: [{ label: i18n.t('cd.paidAed'), data: pcc.map(function (x) { return x.paid; }),
                         backgroundColor: 'rgba(20,104,47,0.55)' }]
          },
          options: { indexAxis: 'y', plugins: { legend: { display: false } },
                     scales: { x: { ticks: { callback: function (v) { return Number(v).toLocaleString('en-US'); } } } } }
        });
        var trend = d.apTrend || [];
        mk('cdTrend', {
          type: 'line',
          data: {
            labels: trend.map(function (x) { return x.month; }),
            datasets: [
              { label: i18n.t('cd.invoiced'), data: trend.map(function (x) { return x.invoiced; }),
                borderColor: '#14682F', backgroundColor: 'rgba(20,104,47,0.12)', fill: true, tension: 0.3 },
              { label: i18n.t('cd.paid'), data: trend.map(function (x) { return x.paid; }),
                borderColor: '#B0721E', backgroundColor: 'rgba(176,114,30,0.10)', fill: true, tension: 0.3 }
            ]
          },
          options: { scales: { y: { ticks: { callback: function (v) { return Number(v).toLocaleString('en-US'); } } } } }
        });
        var sec = d.bySector || [];
        mk('cdSector', {
          type: 'doughnut',
          data: {
            labels: sec.map(function (x) { return x.sector; }),
            datasets: [{ data: sec.map(function (x) { return x.headcount; }),
                         backgroundColor: ['#14682F', '#B0721E', '#3A4FB0', '#8C6D1F', '#7D3243',
                                           '#0E8A8A', '#6C4AB6', '#1F6F8B', '#3F6F5F', '#888888'] }]
          },
          options: { plugins: { legend: { position: 'right' } } }
        });
      });
    };

    self.load = function () {
      self.loading(true); self.error('');
      payService.getCompanyDash(cid).then(function (d) {
        self.d(d);
        setTimeout(function () { self._renderCharts(d); }, 60);
      }).catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.loading(false); });
    };
    self.load();

    self.dispose = function () {
      self._charts.forEach(function (c) { try { c.destroy(); } catch (e) {} });
    };
  }

  return CompanyDashViewModel;
});
