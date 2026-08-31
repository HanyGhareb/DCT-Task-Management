define(['knockout', 'shared/i18n', 'services/kpiService', 'services/authService', 'shared/chartLoader'],
function (ko, i18n, kpi, auth, charts) {
  'use strict';

  var UI_KEY = 'kpi_ui';
  function uiGet() { try { return JSON.parse(localStorage.getItem(UI_KEY)) || {}; } catch (e) { return {}; } }
  function uiSet(k, v) { var u = uiGet(); u[k] = v; try { localStorage.setItem(UI_KEY, JSON.stringify(u)); } catch (e) {} }

  function DashboardViewModel() {
    var self = this;
    self.t    = i18n.t;
    self.lang = i18n.lang;

    var thisYear = new Date().getFullYear();
    self.years = [];
    for (var y = thisYear + 1; y >= thisYear - 4; y--) self.years.push(y);

    self.year        = ko.observable(thisYear);
    self.loading     = ko.observable(true);
    self.kpis        = ko.observableArray([]);
    self.overall     = ko.observable(null);
    self.kpiCount    = ko.observable(0);
    self.scoredCount = ko.observable(0);
    self.isAdmin     = ko.observable(auth.isKpiAdmin());

    /* FPB-style collapsible regions — state persisted in localStorage */
    var u = uiGet();
    self.sec = {
      guide: ko.observable(u['dash.guide'] !== undefined ? u['dash.guide'] : true),
      ov:    ko.observable(u['dash.ov']    !== undefined ? u['dash.ov']    : true),
      cards: ko.observable(u['dash.cards'] !== undefined ? u['dash.cards'] : true),
      chart: ko.observable(u['dash.chart'] !== undefined ? u['dash.chart'] : true)
    };
    var guideAuto = (u['dash.guide'] === undefined); // never touched by the user yet
    self.toggleSec = function (k) {
      var open = !self.sec[k]();
      self.sec[k](open);
      uiSet('dash.' + k, open);
      if (k === 'guide') guideAuto = false;
      if (k === 'chart' && open) drawChart(self.kpis());
    };

    self.overallDisplay = ko.pureComputed(function () {
      return self.overall() != null ? self.overall() : '—';
    });
    self.overallClass = ko.pureComputed(function () {
      return 'sc-' + (self.overall() != null ? Math.round(self.overall()) : 0);
    });
    self.overallBar = ko.pureComputed(function () {
      return (self.overall() != null ? Math.min(100, self.overall() / 5 * 100) : 0) + '%';
    });
    self.coverageBar = ko.pureComputed(function () {
      var n = self.kpiCount();
      return (n ? Math.round(self.scoredCount() / n * 100) : 0) + '%';
    });
    self.approvedCount = ko.pureComputed(function () {
      var n = 0;
      self.kpis().forEach(function (k) {
        (k.cells || []).forEach(function (c) { if (c.status === 'APPROVED') n++; });
      });
      return n;
    });
    self.inFlightCount = ko.pureComputed(function () {
      var n = 0;
      self.kpis().forEach(function (k) {
        (k.cells || []).forEach(function (c) { if (c.status === 'SUBMITTED') n++; });
      });
      return n;
    });
    self.ovSummary = ko.pureComputed(function () {
      return self.t('dash.scored').replace('{0}', self.scoredCount()).replace('{1}', self.kpiCount());
    });

    self.freqLabel = function (f) {
      return self.t(f === 'QUARTERLY' ? 'kpi.freqQuarterly' : (f === 'MIXED' ? 'kpi.freqMixed' : 'kpi.freqAnnual'));
    };
    self.statusShort = function (s) {
      var map = { DRAFT: self.t('kpi.stDraftShort'), SUBMITTED: self.t('kpi.stSubmittedShort'),
                  RETURNED: self.t('kpi.stReturnedShort') };
      return map[s] || '·';
    };

    self.openKpi     = function () { window._jetApp.navigate('results', { year: self.year() }); };
    self.goResults   = function () { window._jetApp.navigate('results', { year: self.year() }); };
    self.goWorklist  = function () { window._jetApp.navigate('myWorklist'); };
    self.goReports   = function () { window._jetApp.navigate('reports'); };

    var chart = null;
    function drawChart(rows) {
      setTimeout(function () {
        var el = document.getElementById('kpiScoreChart');
        if (!el) return;
        if (chart) { try { chart.destroy(); } catch (e) {} }
        chart = charts.makeChart(el, {
          type: 'bar',
          data: {
            labels: rows.map(function (k) {
              return self.lang() === 'ar' && k.nameAr ? k.nameAr : k.nameEn;
            }),
            datasets: [
              { label: self.t('dash.chartScore'),
                data: rows.map(function (k) { return k.avgScore != null ? k.avgScore : 0; }),
                backgroundColor: rows.map(function (k) {
                  var s = k.avgScore != null ? Math.round(k.avgScore) : 0;
                  return { 5: '#1B7F4B', 4: '#4C9A2A', 3: '#B58A1B', 2: '#D96C1E', 1: '#C7351F' }[s] || '#98A2B3';
                }) },
              { label: self.t('dash.chartTarget'), type: 'line',
                data: rows.map(function () { return 5; }),
                borderColor: '#8C6D1F', borderDash: [6, 4], pointRadius: 0 }
            ]
          },
          options: { scales: { y: { min: 0, max: 5, ticks: { stepSize: 1 } } } }
        });
      }, 0);
    }

    function load() {
      self.loading(true);
      kpi.scorecard(self.year()).then(function (d) {
        var rows = (d.kpis || []).map(function (k) {
          k.cells       = k.cells || [];
          k.avgScore    = ('avgScore' in k) ? k.avgScore : null;
          k.latestPct   = ('latestPct' in k) ? k.latestPct : null;
          k.prevYearScore = ('prevYearScore' in k) ? k.prevYearScore : null;
          k.targetLabel = k.targetLabel || (k.targetValue != null ? String(k.targetValue) : '');
          return k;
        });
        self.kpis(rows);
        self.overall(('overallScore' in d && d.overallScore !== '') ? d.overallScore : null);
        self.kpiCount(d.kpiCount || rows.length);
        self.scoredCount(d.scoredCount || 0);
        /* first visit: keep the guide open only while nothing is scored yet */
        if (guideAuto && (d.scoredCount || 0) > 0) self.sec.guide(false);
        self.loading(false);
        if (self.sec.chart()) drawChart(rows);
      }).catch(function () { self.loading(false); });
    }

    self.year.subscribe(load);
    load();
  }

  return DashboardViewModel;
});
