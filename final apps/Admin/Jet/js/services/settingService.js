/**
 * settingService.js — system settings & lookup values
 * ORDS: GET  /settings/           — list all settings
 *       PUT  /settings/:key       — update a setting by key
 *       GET  /lookups/            — list categories + nested values
 *       PUT  /lookups/values/:id  — update a lookup value
 *
 * All methods return Promises.
 */
define(['services/api'], function (api) {
  'use strict';

  /* Flatten ORDS nested category+values → flat lookup rows VMs expect */
  function flattenLookups(categories) {
    var flat = [];
    (categories || []).forEach(function (cat) {
      (cat.values || []).forEach(function (v) {
        flat.push({
          lookupId:     v.valueId,
          lookupType:   cat.categoryCode,
          lookupCode:   v.lookupCode,
          displayValue: v.displayValue,
          displayAr:    v.displayAr    || '',
          sortOrder:    v.sortOrder,
          isActive:     v.isActive,
        });
      });
    });
    return flat;
  }

  /* ORDS {key, value, type, category, description, isEditable} → VM shape */
  function normSetting(s) {
    return {
      settingKey:   s.key,
      settingValue: s.value,
      settingType:  s.type,
      category:     s.category || s.type || 'GENERAL',
      description:  s.description,
      isEditable:   s.isEditable,
    };
  }

  return {

    /* ── Settings ─────────────────────────────────────────────────────── */

    getSettings: function () {
      return api.get('/settings/').then(function (r) {
        return (r.items || []).map(normSetting);
      });
    },

    getByKey: function (key) {
      return api.get('/settings/').then(function (r) {
        var s = (r.items || []).find(function (s) { return s.key === key; });
        return s ? normSetting(s) : null;
      });
    },

    /* settingKey-based update (ORDS uses key, not numeric ID) */
    updateSetting: function (settingKey, value) {
      return api.put('/settings/' + settingKey, { value: String(value) });
    },

    getSettingsByCategory: function () {
      return api.get('/settings/').then(function (r) {
        var map = {};
        (r.items || []).forEach(function (s) {
          var cat = s.category || s.type || 'GENERAL';
          if (!map[cat]) map[cat] = [];
          map[cat].push(normSetting(s));
        });
        return map;
      });
    },

    /* ── Lookups ──────────────────────────────────────────────────────── */

    getLookups: function () {
      return api.get('/lookups/').then(function (r) {
        return flattenLookups(r.items);
      });
    },

    getLookupTypes: function () {
      return api.get('/lookups/').then(function (r) {
        return (r.items || []).map(function (c) { return c.categoryCode; }).sort();
      });
    },

    getLookupsByType: function (type) {
      return api.get('/lookups/').then(function (r) {
        var flat = flattenLookups(r.items);
        if (!type || type === 'ALL') return flat;
        return flat.filter(function (l) { return l.lookupType === type; });
      });
    },

    updateLookup: function (id, data) {
      return api.put('/lookups/values/' + id, {
        displayValue: data.displayValue,
        displayAr:    data.displayAr    || '',
        sortOrder:    Number(data.sortOrder) || 1,
        isActive:     data.isActive,
      });
    },

    createLookup: function () {
      return Promise.reject({ message: 'Creating lookup values requires APEX Admin access.' });
    },

    removeLookup: function () {
      return Promise.reject({ message: 'Deleting lookup values requires APEX Admin access.' });
    },
  };
});
