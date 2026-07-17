/**
 * settingService.js — system settings & lookup values
 * ORDS: GET  /settings/           — list all settings
 *       PUT  /settings/:key       — update a setting by key
 *       POST /maintenance/log-cleanup — run configured ATD log retention
 *       GET  /lookups/            — list categories + nested values
 *       PUT  /lookups/values/:id  — update a lookup value
 *
 * All methods return Promises.
 */
define(['services/api', 'shared/refCache'], function (api, refCache) {
  'use strict';

  /* one cached fetch behind getLookups/getLookupTypes/getLookupsByType */
  function lookupsRaw() {
    return refCache.get('lookups', function () { return api.get('/lookups/'); });
  }

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
          createdBy:    v.createdBy,
          createdAt:    v.createdAt,
          updatedBy:    v.updatedBy,
          updatedAt:    v.updatedAt,
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

    getSettings: function (opts) {
      return api.get('/settings/', opts).then(function (r) {
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

    runLogCleanup: function () {
      return api.post('/maintenance/log-cleanup', {});
    },

    getStorageHealth: function () {
      return api.get('/maintenance/storage-health', { silent: true });
    },

    getStorageHistory: function () {
      return api.get('/maintenance/storage-history', { silent: true });
    },

    getDatabaseHealth: function () {
      return api.get('/maintenance/db-health', { silent: true });
    },

    runDatabaseHealth: function () {
      return api.post('/maintenance/db-health', {}, { silent: true });
    },

    getDataIntegrity: function () {
      return api.get('/maintenance/data-integrity', { silent: true });
    },

    runDataIntegrity: function () {
      return api.post('/maintenance/data-integrity', {}, { silent: true });
    },

    getSqlPerformance: function () {
      return api.get('/maintenance/sql-performance', { silent: true });
    },

    refreshSqlPerformance: function () {
      return api.post('/maintenance/sql-performance', {}, { silent: true });
    },

    getDatabaseLocks: function () {
      return api.get('/maintenance/database-locks', { silent: true });
    },

    refreshDatabaseLocks: function () {
      return api.post('/maintenance/database-locks', {}, { silent: true });
    },

    terminateDatabaseBlocker: function (lock, reason) {
      return api.post('/maintenance/database-locks/terminate', {
        instanceId: Number(lock.blockerInstance),
        sid: Number(lock.blockerSid),
        serial: Number(lock.blockerSerial),
        reason: reason
      }, { silent: true });
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
      return lookupsRaw().then(function (r) {
        return flattenLookups(r.items);
      });
    },

    getLookupTypes: function () {
      return lookupsRaw().then(function (r) {
        return (r.items || []).map(function (c) { return c.categoryCode; }).sort();
      });
    },

    getLookupsByType: function (type) {
      return lookupsRaw().then(function (r) {
        var flat = flattenLookups(r.items);
        if (!type || type === 'ALL') return flat;
        return flat.filter(function (l) { return l.lookupType === type; });
      });
    },

    updateLookup: function (id, data) {
      refCache.invalidate('lookups');
      return api.put('/lookups/values/' + id, {
        displayValue: data.displayValue,
        displayAr:    data.displayAr    || '',
        sortOrder:    Number(data.sortOrder) || 1,
        isActive:     data.isActive,
      });
    },

    /* Wave 2 (UAT SYS-04): in-app creation via POST /lookups/values.
       The category must already exist — new categories stay an APEX task
       (they imply code-level adoption anyway). */
    createLookup: function (data) {
      return lookupsRaw().then(function (r) {
        var cat = (r.items || []).find(function (c) {
          return c.categoryCode === data.lookupType;
        });
        if (!cat) {
          return Promise.reject({ message: 'Unknown lookup type "' + data.lookupType +
            '" — new categories are created in APEX Admin.' });
        }
        return api.post('/lookups/values', {
          categoryId:   cat.categoryId,
          lookupCode:   data.lookupCode,
          displayValue: data.displayValue,
          displayAr:    data.displayAr || '',
          sortOrder:    Number(data.sortOrder) || null
        }, { silent: true }).then(function (res) {
          refCache.invalidate('lookups');   // AFTER the insert — next read sees it
          return res;
        });
      });
    },
  };
});
