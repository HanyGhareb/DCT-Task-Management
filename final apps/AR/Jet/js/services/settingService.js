/**
 * settingService.js — AR module settings (DCT_MODULE_SETTINGS rows).
 * GET /settings/ returns { items: [{key, value, label, …}] }.
 */
define(['services/api'], function (api) {
  'use strict';

  var _cache = null;

  function load(force) {
    if (_cache && !force) return Promise.resolve(_cache);
    return api.get('/settings/').then(function (res) {
      _cache = (res && res.items) || [];
      return _cache;
    });
  }

  return {
    getAll: function (force) { return load(force); },

    getValue: function (key) {
      return load().then(function (items) {
        var s = items.find(function (i) { return i.key === key; });
        return s ? s.value : null;
      });
    },

    update: function (key, value) {
      _cache = null;
      return api.put('/settings/', { key: key, value: value });
    },
  };
});
