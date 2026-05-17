define(['knockout', 'services/config', 'services/api', 'mockData'],
function (ko, config, api, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_dt_rates';

  function loadRates() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return JSON.parse(JSON.stringify(mockData.PER_DIEM_RATES));
  }
  function saveRates(list) { localStorage.setItem(STORE_KEY, JSON.stringify(list)); }

  // Map either mock shape (countryCode/mealAed/…) or ORDS shape (rateKey/rateKeyName/…)
  // to a single normalised object the view can bind to.
  function _norm(r) {
    var rateKey = r.rateKey || r.countryCode || '';
    var country = mockData.COUNTRIES.find(function(c){ return c.countryCode === rateKey; });
    return {
      rateId:       r.rateId,
      rateKey:      rateKey,
      rateKeyName:  r.rateKeyName || (country ? country.countryName : rateKey),
      gradeCode:    r.gradeCode,
      gradeLabel:   r.gradeLabel || r.gradeCode,
      dailyRateAed: r.dailyRateAed || 0,
      effectiveFrom:r.effectiveFrom || '',
      effectiveTo:  r.effectiveTo  || '',
      isActive:     r.isActive,
      rateStatus:   r.rateStatus || (r.isActive === 'Y' ? 'CURRENT' : 'INACTIVE'),
      notes:        r.notes || '',
    };
  }

  function PerDiemRatesViewModel() {
    var self = this;

    self.rates       = ko.observableArray([]);
    self.grades      = ['E1','E2','E3','E4','E5'];
    self.loading     = ko.observable(true);
    self.searchText  = ko.observable('');
    self.gradeFilter = ko.observable('');
    self.saving      = ko.observable(false);
    self.successMsg  = ko.observable('');
    self.error       = ko.observable('');

    self.editRow = ko.observable(null);

    self.filtered = ko.computed(function () {
      var q  = self.searchText().toLowerCase();
      var gf = self.gradeFilter();
      return self.rates().filter(function (r) {
        var matchQ = !q || r.rateKey.toLowerCase().includes(q) || r.rateKeyName.toLowerCase().includes(q);
        var matchG = !gf || r.gradeCode === gf;
        return matchQ && matchG;
      });
    });

    self.startEdit = function (rate) {
      self.editRow({
        rateId:       rate.rateId,
        rateKey:      rate.rateKey,
        rateKeyName:  rate.rateKeyName,
        gradeCode:    rate.gradeCode,
        dailyRateAed: ko.observable(rate.dailyRateAed),
        effectiveFrom:ko.observable(rate.effectiveFrom),
        effectiveTo:  ko.observable(rate.effectiveTo),
        isActive:     ko.observable(rate.isActive),
        notes:        ko.observable(rate.notes),
      });
    };
    self.cancelEdit = function () { self.editRow(null); };

    self.saveEdit = function () {
      var e = self.editRow();
      if (!e) return;
      self.saving(true);
      self.error('');
      var payload = {
        dailyRateAed:  parseFloat(e.dailyRateAed()) || 0,
        effectiveFrom: e.effectiveFrom(),
        effectiveTo:   e.effectiveTo() || null,
        isActive:      e.isActive(),
        notes:         e.notes(),
      };
      if (config.apiBase) {
        api.put('/perdiem-rates/' + e.rateId, payload)
          .then(function () {
            return api.get('/perdiem-rates/').then(function(d) {
              self.rates((d.items || []).map(_norm));
            });
          })
          .then(function () {
            self.editRow(null);
            self.saving(false);
            self.successMsg('Rate updated.');
          })
          .catch(function (err) {
            self.saving(false);
            self.error(err && err.message ? err.message : 'Save failed.');
          });
        return;
      }
      // Mock mode
      var list = loadRates();
      var idx  = list.findIndex(function(r){ return r.rateId === e.rateId; });
      if (idx !== -1) {
        list[idx].dailyRateAed  = payload.dailyRateAed;
        list[idx].effectiveFrom = payload.effectiveFrom;
        list[idx].effectiveTo   = payload.effectiveTo;
        list[idx].isActive      = payload.isActive;
        list[idx].notes         = payload.notes;
      }
      saveRates(list);
      self.rates(list.map(_norm));
      self.editRow(null);
      self.saving(false);
      self.successMsg('Rate updated.');
    };

    self.fmt = function (n) { return parseFloat(n || 0).toLocaleString('en-AE', { minimumFractionDigits: 2 }); };

    // Load
    if (config.apiBase) {
      api.get('/perdiem-rates/').then(function(d) {
        self.rates((d.items || []).map(_norm));
        self.loading(false);
      }).catch(function(err) {
        self.error(err && err.message ? err.message : 'Failed to load rates.');
        self.loading(false);
      });
    } else {
      self.rates(loadRates().map(_norm));
      self.loading(false);
    }
  }

  return PerDiemRatesViewModel;
});
