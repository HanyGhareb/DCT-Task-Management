define(['knockout', 'shared/i18n', 'shared/toast', 'services/kpiService', 'services/authService'],
function (ko, i18n, toast, kpi, auth) {
  'use strict';

  var UI_KEY = 'kpi_ui';
  function uiGet() { try { return JSON.parse(localStorage.getItem(UI_KEY)) || {}; } catch (e) { return {}; } }
  function uiSet(k, v) { var u = uiGet(); u[k] = v; try { localStorage.setItem(UI_KEY, JSON.stringify(u)); } catch (e) {} }

  function ResultsViewModel() {
    var self = this;
    self.t    = i18n.t;
    self.lang = i18n.lang;

    var state = (window._jetApp && window._jetApp.getState()) || {};
    var thisYear = new Date().getFullYear();
    self.years = [];
    for (var y = thisYear + 1; y >= thisYear - 4; y--) self.years.push(y);
    if (state.year && self.years.indexOf(state.year) < 0) self.years.push(state.year);

    self.year    = ko.observable(state.year || thisYear);
    self.loading = ko.observable(true);
    self.busy    = ko.observable(false);
    self.isAdmin = ko.observable(auth.isKpiAdmin());
    self.columns = ko.observableArray([]);
    self.rows    = ko.observableArray([]);
    self.hasPeriods = ko.observable(false);

    /* FPB-style collapsible regions */
    var u = uiGet();
    self.sec = {
      search: ko.observable(u['res.search'] !== undefined ? u['res.search'] : true),
      matrix: ko.observable(u['res.matrix'] !== undefined ? u['res.matrix'] : true)
    };
    self.toggleSec = function (k) {
      var open = !self.sec[k]();
      self.sec[k](open);
      uiSet('res.' + k, open);
    };
    self.searchSummary = ko.pureComputed(function () {
      return self.year() + (self.hasPeriods()
        ? ' · ' + self.columns().length + ' ' + self.t('res.periodsWord')
        : ' · ' + self.t('res.noCalendarShort'));
    });

    self.freqLabel = function (f) {
      return self.t(f === 'QUARTERLY' ? 'kpi.freqQuarterly' : (f === 'MIXED' ? 'kpi.freqMixed' : 'kpi.freqAnnual'));
    };
    self.statusLabel = function (s) { return self.t('kpi.st' + s.charAt(0) + s.slice(1).toLowerCase()); };
    self.statusBadge = function (s) {
      return { DRAFT: 'badge--idle', SUBMITTED: 'badge--warning',
               APPROVED: 'badge--approved', RETURNED: 'badge--rejected' }[s] || 'badge--idle';
    };

    function load() {
      self.loading(true);
      Promise.all([
        kpi.getKpis(false),
        kpi.getPeriods(self.year()),
        kpi.getResults({ year: self.year(), limit: 500 })
      ]).then(function (r) {
        var defs = r[0], periods = r[1], results = r[2].items || [];
        self.hasPeriods(periods.length > 0);

        var annual = periods.filter(function (p) { return p.type === 'ANNUAL'; })[0];
        var qs = periods.filter(function (p) { return p.type === 'QUARTER'; })
                        .sort(function (a, b) { return a.quarter - b.quarter; });
        var cols = [];
        if (annual) cols.push({ key: 'ANNUAL', label: self.t('res.annual'), period: annual });
        qs.forEach(function (q) { cols.push({ key: 'Q' + q.quarter, label: 'Q' + q.quarter, period: q }); });
        self.columns(cols);

        var byKey = {};
        results.forEach(function (r0) {
          r0.score = ('score' in r0) ? r0.score : null;
          byKey[r0.kpiId + ':' + r0.periodId] = r0;
        });

        self.rows(defs.map(function (d) {
          return {
            kpi: d,
            cells: cols.map(function (c) {
              var na = (d.frequency === 'ANNUAL' && c.key !== 'ANNUAL')
                    || (d.frequency === 'QUARTERLY' && c.key === 'ANNUAL')
                    || (d.frequency === 'MIXED' && c.key !== 'ANNUAL');
              return { kpi: d, period: c.period, na: na,
                       result: byKey[d.kpiId + ':' + c.period.periodId] || null };
            })
          };
        }));
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    self.openCell = function (cell) {
      if (cell.na) return;
      if (cell.result) {
        window._jetApp.navigate('resultEntry', { resultId: cell.result.resultId });
        return;
      }
      kpi.initResult(cell.kpi.kpiId, cell.period.periodId).then(function (d) {
        window._jetApp.navigate('resultEntry', { resultId: d.resultId });
      }).catch(function (err) {
        toast.error((err && err.message) || self.t('res.initFailed'));
      });
    };

    self.generatePeriods = function () {
      self.busy(true);
      kpi.generatePeriods(self.year()).then(function () {
        toast.success(self.t('res.periodsReady'));
        self.busy(false); load();
      }).catch(function (err) {
        toast.error((err && err.message) || 'Failed'); self.busy(false);
      });
    };

    self.year.subscribe(load);
    load();
  }

  return ResultsViewModel;
});
