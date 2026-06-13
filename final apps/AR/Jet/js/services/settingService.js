/**
 * settingService.js — AR module settings (DCT_MODULE_SETTINGS rows) +
 * AI provider registry (DCT_AR_AI_PROVIDERS, Manage Providers popup).
 * GET /settings/  returns { items: [{key, value, label, …, updatedBy, updatedAt}] }.
 * GET /providers/ returns { items: [{id, code, name, apiFormat, model, hasKey, …}] }
 *                 — api_key is write-only and never returned.
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

    /* ── AI provider registry ─────────────────────────────────────── */

    getProviders: function () {
      return api.get('/providers/').then(function (res) {
        return (res && res.items) || [];
      });
    },

    createProvider: function (p) {
      return api.post('/providers/', p);
    },

    updateProvider: function (id, p) {
      return api.put('/providers/' + id, p);
    },

    deleteProvider: function (id) {
      return api.delete('/providers/' + id);
    },
  };
});
