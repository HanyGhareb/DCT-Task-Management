define(['knockout', 'services/config', 'services/api', 'mockData'],
function (ko, config, api, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_dt_rates';

  function loadRates() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return JSON.parse(JSON.stringify(mockData.PER_DIEM_RATES));
  }
  function saveRates(list) { localStorage.setItem(STORE_KEY, JSON.stringify(list)); }

  function PerDiemRatesViewModel() {
    var self = this;

    self.rates       = ko.observableArray([]);
    self.countries   = ko.observableArray(mockData.COUNTRIES.filter(function(c){ return c.tier !== 'HOME'; }));
    self.grades      = ['E1','E2','E3','E4','E5'];
    self.loading     = ko.observable(true);
    self.searchText  = ko.observable('');
    self.gradeFilter = ko.observable('');
    self.saving      = ko.observable(false);
    self.successMsg  = ko.observable('');
    self.error       = ko.observable('');

    // Edit row
    self.editRow     = ko.observable(null);

    self.filtered = ko.computed(function () {
      var q  = self.searchText().toLowerCase();
      var gf = self.gradeFilter();
      return self.rates().filter(function (r) {
        var c = self.countries().find(function(x){ return x.countryCode === r.countryCode; });
        var cname = c ? c.countryName.toLowerCase() : '';
        var matchQ = !q || r.countryCode.toLowerCase().includes(q) || cname.includes(q);
        var matchG = !gf || r.gradeCode === gf;
        return matchQ && matchG;
      });
    });

    self.countryName = function (code) {
      var c = self.countries().find(function(x){ return x.countryCode === code; });
      return c ? c.countryName : code;
    };

    self.startEdit = function (rate) {
      self.editRow({
        rateId:       rate.rateId,
        countryCode:  rate.countryCode,
        gradeCode:    rate.gradeCode,
        dailyRateAed: ko.observable(rate.dailyRateAed),
        mealAed:      ko.observable(rate.mealAed),
        incidentalsAed: ko.observable(rate.incidentalsAed),
        effectiveFrom: ko.observable(rate.effectiveFrom),
        isActive:     ko.observable(rate.isActive),
      });
    };
    self.cancelEdit = function () { self.editRow(null); };

    self.saveEdit = function () {
      var e = self.editRow();
      if (!e) return;
      self.saving(true);
      var list = loadRates();
      var idx  = list.findIndex(function(r){ return r.rateId === e.rateId; });
      if (idx !== -1) {
        list[idx].dailyRateAed   = parseFloat(e.dailyRateAed()) || 0;
        list[idx].mealAed        = parseFloat(e.mealAed()) || 0;
        list[idx].incidentalsAed = parseFloat(e.incidentalsAed()) || 0;
        list[idx].effectiveFrom  = e.effectiveFrom();
        list[idx].isActive       = e.isActive();
      }
      saveRates(list);
      self.rates(list);
      self.editRow(null);
      self.saving(false);
      self.successMsg('Rate updated.');
    };

    self.fmt = function (n) { return parseFloat(n || 0).toLocaleString('en-AE', { minimumFractionDigits: 2 }); };

    self.rates(loadRates());
    self.loading(false);
  }

  return PerDiemRatesViewModel;
});
