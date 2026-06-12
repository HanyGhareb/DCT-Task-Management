define(['knockout', 'services/arService', 'shared/i18n', 'shared/toast', 'shared/chartLoader'],
function (ko, arService, i18n, toast, charts) {
  'use strict';

  function WhatIfViewModel() {
    var self = this;
    self.t = i18n.t;
    self.fmt = function (n) {
      if (n === null || n === undefined) return '—';
      return i18n.fmtNum ? i18n.fmtNum(n, 0) : String(Math.round(n));
    };

    var state = window._arApp.getState();

    self.events        = ko.observableArray([]);
    self.selectedEvent = ko.observable(state.eventId || null);
    self.baseline      = ko.observableArray([]);   // {lineType, categoryId, name, amount}
    self.scenarios     = ko.observableArray([]);
    self.scenarioName  = ko.observable('Scenario 1');
    self.adjustments   = ko.observableArray([]);   // {lineType, categoryId(obs), adjType(obs), value(obs)}
    self.pnlCats       = ko.observableArray([]);
    self.loading       = ko.observable(false);

    arService.getEvents({ limit: 200 }).then(function (res) {
      self.events(res.items || []);
    });
    arService.getCategories().then(function (res) { self.pnlCats(res.items || []); });

    function loadBaseline() {
      var id = self.selectedEvent();
      if (!id) { self.baseline([]); return; }
      self.loading(true);
      Promise.all([arService.getEventStats(id), arService.getScenarios(id)])
        .then(function (rs) {
          var rows = (rs[0].byCategory || []).filter(function (r) { return r.basis === 'ACTUAL'; });
          self.baseline(rows);
          self.scenarios(rs[1].items || []);
          self.loading(false);
        }).catch(function () { self.loading(false); });
    }
    self.selectedEvent.subscribe(loadBaseline);
    if (self.selectedEvent()) loadBaseline();

    self.addAdjustment = function () {
      self.adjustments.push({
        lineType:   ko.observable('EXPENSE'),
        categoryId: ko.observable(null),
        adjType:    ko.observable('PCT'),
        value:      ko.observable(0),
      });
    };
    self.removeAdjustment = function (a) { self.adjustments.remove(a); };
    if (!self.adjustments().length) self.addAdjustment();

    /* apply adjustments to the baseline → scenario rows */
    function applyAdjustments(rows) {
      var adjusted = rows.map(function (r) {
        return { lineType: r.lineType, categoryId: r.categoryId, name: r.name,
                 base: r.amount, amount: r.amount };
      });
      self.adjustments().forEach(function (a) {
        var t = a.lineType(), c = a.categoryId(), ty = a.adjType(),
            v = parseFloat(a.value()) || 0;
        adjusted.forEach(function (r) {
          if (r.lineType !== t) return;
          if (c && r.categoryId !== c) return;
          if (ty === 'PCT')      r.amount = r.amount * (1 + v / 100);
          else if (ty === 'AMOUNT')   r.amount = r.amount + v;
          else if (ty === 'OVERRIDE') r.amount = v;
        });
      });
      return adjusted;
    }

    self.result = ko.computed(function () {
      var rows = self.baseline();
      var adjusted = applyAdjustments(rows);
      function sum(list, type) {
        return list.filter(function (r) { return r.lineType === type; })
                   .reduce(function (s, r) { return s + (r.amount || 0); }, 0);
      }
      var bRev = rows.filter(function (r) { return r.lineType === 'REVENUE'; })
                     .reduce(function (s, r) { return s + (r.amount || 0); }, 0);
      var bExp = rows.filter(function (r) { return r.lineType === 'EXPENSE'; })
                     .reduce(function (s, r) { return s + (r.amount || 0); }, 0);
      var sRev = sum(adjusted, 'REVENUE');
      var sExp = sum(adjusted, 'EXPENSE');
      return {
        rows: adjusted,
        baseRevenue: bRev, baseExpense: bExp, baseNet: bRev - bExp,
        scenRevenue: sRev, scenExpense: sExp, scenNet: sRev - sExp,
        deltaNet: (sRev - sExp) - (bRev - bExp),
      };
    });

    /* chart */
    var _chart = null;
    self.result.subscribe(function (r) {
      var c = document.getElementById('arWhatIfChart');
      if (!c) return;
      var p = charts.palette();
      if (_chart) { try { _chart.destroy(); } catch (e) {} }
      _chart = charts.makeChart(c, {
        type: 'bar',
        data: {
          labels: ['Revenue', 'Expense', 'Net'],
          datasets: [
            { label: 'Actual',   data: [r.baseRevenue, r.baseExpense, r.baseNet],
              backgroundColor: charts.alpha(p.brand, .65) },
            { label: 'Scenario', data: [r.scenRevenue, r.scenExpense, r.scenNet],
              backgroundColor: charts.alpha(p.amber, .75) },
          ]
        }
      });
    });

    /* persistence */
    self.saveScenario = function () {
      var id = self.selectedEvent();
      if (!id) { toast.error('Select an event first'); return; }
      arService.createScenario({
        eventId: id,
        name: self.scenarioName() || 'Scenario',
        adjustments: self.adjustments().map(function (a) {
          return { lineType: a.lineType(), categoryId: a.categoryId(),
                   adjType: a.adjType(), value: parseFloat(a.value()) || 0 };
        }),
      }).then(function () {
        toast.success('Scenario saved');
        return arService.getScenarios(id).then(function (res) { self.scenarios(res.items || []); });
      }).catch(function () { toast.error('Save failed'); });
    };

    self.loadScenario = function (s) {
      self.scenarioName(s.name);
      self.adjustments((s.adjustments || []).map(function (a) {
        return {
          lineType:   ko.observable(a.lineType),
          categoryId: ko.observable(a.categoryId),
          adjType:    ko.observable(a.adjType),
          value:      ko.observable(a.value),
        };
      }));
    };

    self.deleteScenario = function (s) {
      arService.deleteScenario(s.scenarioId).then(function () {
        self.scenarios.remove(s);
      });
    };
  }

  return WhatIfViewModel;
});
