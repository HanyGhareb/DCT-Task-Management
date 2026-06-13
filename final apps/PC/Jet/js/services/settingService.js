/**
 * settingService.js — Module settings CRUD.
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_pc_settings';

  function loadSettings() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return JSON.parse(JSON.stringify(mockData.MODULE_SETTINGS));
  }
  function saveSettings(list) { localStorage.setItem(STORE_KEY, JSON.stringify(list)); }

  return {

    getAll: function () {
      if (config.apiBase) return api.get('/settings');
      return Promise.resolve(loadSettings());
    },

    getValue: function (key) {
      var list = loadSettings();
      var s = list.find(function(r){ return r.settingKey === key; });
      return s ? s.settingValue : null;
    },

    /* Promise-returning variant — getValue() is sync and mock-only (returns
       null in live mode), which broke .then() callers at boot. */
    getValueAsync: function (key) {
      function find(list) {
        var s = (list || []).find(function (r) { return r.settingKey === key; });
        return s ? s.settingValue : null;
      }
      if (config.apiBase) return api.get('/settings').then(find);
      return Promise.resolve(find(loadSettings()));
    },

    update: function (settingId, newValue, effectiveDate) {
      if (config.apiBase) return api.put('/settings/' + settingId, { settingValue: newValue, effectiveDate: effectiveDate });
      var list = loadSettings();
      var idx  = list.findIndex(function(r){ return r.settingId === settingId; });
      if (idx !== -1) {
        list[idx].settingValue  = newValue;
        list[idx].effectiveDate = effectiveDate || list[idx].effectiveDate;
      }
      saveSettings(list);
      return Promise.resolve(list[idx]);
    },

    resetToDefault: function (settingId) {
      if (config.apiBase) return api.post('/settings/' + settingId + '/reset');
      var list = loadSettings();
      var idx  = list.findIndex(function(r){ return r.settingId === settingId; });
      if (idx !== -1) list[idx].settingValue = list[idx].defaultValue;
      saveSettings(list);
      return Promise.resolve(list[idx]);
    },
  };
});
