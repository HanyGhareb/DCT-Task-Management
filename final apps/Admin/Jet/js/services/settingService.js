/**
 * settingService.js — system settings & lookup values
 * Production: GET /ords/prod/dct/system_settings/
 */
define(['mockData'], function (mockData) {
  'use strict';

  let settings = JSON.parse(JSON.stringify(mockData.SETTINGS));
  let lookups  = JSON.parse(JSON.stringify(mockData.LOOKUPS));
  let nextLookupId = lookups.length + 1;

  return {
    // Settings
    getSettings: function () { return settings; },
    getByKey: function (key) { return settings.find(s => s.settingKey === key); },
    updateSetting: function (settingId, value) {
      const s = settings.find(s => s.settingId === Number(settingId));
      if (s) { s.settingValue = value; s.updatedAt = new Date().toISOString().slice(0, 10); s.updatedBy = 'ADMIN'; }
      return s;
    },
    getSettingsByCategory: function () {
      const map = {};
      settings.forEach(s => {
        if (!map[s.category]) map[s.category] = [];
        map[s.category].push(s);
      });
      return map;
    },

    // Lookups
    getLookups: function () { return lookups; },
    getLookupTypes: function () {
      return [...new Set(lookups.map(l => l.lookupType))].sort();
    },
    getLookupsByType: function (type) {
      return lookups.filter(l => !type || l.lookupType === type).sort((a, b) => a.sortOrder - b.sortOrder);
    },
    createLookup: function (data) {
      const newL = Object.assign({}, data, { lookupId: ++nextLookupId, isActive: data.isActive || 'Y' });
      lookups.push(newL);
      return newL;
    },
    updateLookup: function (id, data) {
      const idx = lookups.findIndex(l => l.lookupId === Number(id));
      if (idx !== -1) lookups[idx] = Object.assign({}, lookups[idx], data);
      return lookups[idx];
    },
    removeLookup: function (id) {
      const idx = lookups.findIndex(l => l.lookupId === Number(id));
      if (idx !== -1) lookups.splice(idx, 1);
    },
  };
});
