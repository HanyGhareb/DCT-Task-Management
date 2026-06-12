define(['knockout', 'services/arService', 'shared/i18n'],
function (ko, arService, i18n) {
  'use strict';

  function ReportsViewModel() {
    var self = this;
    self.t = i18n.t;
    self.fmt = function (n) {
      if (n === null || n === undefined) return '—';
      return i18n.fmtNum ? i18n.fmtNum(n, 0) : String(n);
    };

    var state = window._arApp.getState();

    self.events        = ko.observableArray([]);
    self.selectedEvent = ko.observable(state.eventId || null);
    self.event         = ko.observable(null);
    self.summary       = ko.observableArray([]);
    self.revenueRows   = ko.observableArray([]);
    self.expenseRows   = ko.observableArray([]);
    self.findings      = ko.observableArray([]);
    self.loading       = ko.observable(false);

    arService.getEvents({ limit: 200 }).then(function (res) { self.events(res.items || []); });

    function load() {
      var id = self.selectedEvent();
      if (!id) return;
      self.loading(true);
      Promise.all([
        arService.getEvent(id),
        arService.getEventStats(id),
        arService.getFindings(id),
      ]).then(function (rs) {
        self.event(rs[0]);
        self.summary(rs[1].summary || []);
        var byCat = rs[1].byCategory || [];
        function pivot(type) {
          var map = {};
          byCat.filter(function (r) { return r.lineType === type; }).forEach(function (r) {
            var k = r.name || 'Unmapped';
            map[k] = map[k] || { name: k, budget: 0, actual: 0 };
            if (r.basis === 'BUDGET') map[k].budget += r.amount;
            if (r.basis === 'ACTUAL') map[k].actual += r.amount;
          });
          return Object.values(map).map(function (r) {
            r.variance = r.actual - r.budget;
            return r;
          }).sort(function (a, b) { return b.actual - a.actual; });
        }
        self.revenueRows(pivot('REVENUE'));
        self.expenseRows(pivot('EXPENSE'));
        self.findings(rs[2].items || []);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }
    self.selectedEvent.subscribe(load);
    if (self.selectedEvent()) load();

    self.totals = ko.computed(function () {
      function sum(rows, f) { return rows.reduce(function (s, r) { return s + (r[f] || 0); }, 0); }
      var r = self.revenueRows(), e = self.expenseRows();
      return {
        revB: sum(r, 'budget'), revA: sum(r, 'actual'),
        expB: sum(e, 'budget'), expA: sum(e, 'actual'),
        netB: sum(r, 'budget') - sum(e, 'budget'),
        netA: sum(r, 'actual') - sum(e, 'actual'),
      };
    });

    self.exportCsv = function () {
      var ev = self.event();
      if (!ev) return;
      var rows = [['Section', 'Category', 'Budget (AED)', 'Actual (AED)', 'Variance (AED)']];
      self.revenueRows().forEach(function (r) {
        rows.push(['Revenue', r.name, r.budget, r.actual, r.variance]);
      });
      self.expenseRows().forEach(function (r) {
        rows.push(['Expense', r.name, r.budget, r.actual, r.variance]);
      });
      var tt = self.totals();
      rows.push(['Total', 'Net Result', tt.netB, tt.netA, tt.netA - tt.netB]);
      var csv = rows.map(function (r) {
        return r.map(function (c) {
          var s = String(c === null || c === undefined ? '' : c);
          return /[",\n]/.test(s) ? '"' + s.replace(/"/g, '""') + '"' : s;
        }).join(',');
      }).join('\r\n');
      var blob = new Blob(['﻿' + csv], { type: 'text/csv;charset=utf-8' });
      var a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = (ev.eventCode || 'event') + '-pnl.csv';
      a.click();
      setTimeout(function () { URL.revokeObjectURL(a.href); }, 5000);
    };

    self.print = function () { window.print(); };
  }

  return ReportsViewModel;
});
