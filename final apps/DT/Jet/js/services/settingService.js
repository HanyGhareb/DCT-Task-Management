/**
 * settingService.js — Module settings for Duty Travel.
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_dt_settings';

  function loadSettings() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return JSON.parse(JSON.stringify(mockData.MODULE_SETTINGS));
  }
  function saveSettings(list) { localStorage.setItem(STORE_KEY, JSON.stringify(list)); }

  return {

    getAll: function () {
      if (config.apiBase) return api.get('/settings/').then(function(d){ return d.items || []; });
      return Promise.resolve(loadSettings());
    },

    getValue: function (key) {
      var list = loadSettings();
      var s = list.find(function(x){ return x.settingKey === key; });
      return s ? (s.settingValue !== null ? s.settingValue : s.defaultValue) : null;
    },

    update: function (settingId, value) {
      if (config.apiBase) return api.put('/settings/' + settingId, { settingValue: value });
      var list = loadSettings();
      var idx  = list.findIndex(function(s){ return s.settingId === settingId; });
      if (idx !== -1) list[idx].settingValue = value;
      saveSettings(list);
      return Promise.resolve(list[idx]);
    },

    reset: function () {
      localStorage.removeItem(STORE_KEY);
      return Promise.resolve(true);
    },
  };
});
