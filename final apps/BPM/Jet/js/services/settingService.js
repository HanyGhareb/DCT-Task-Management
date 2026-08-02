/**
 * settingService.js — BPM module settings over the additive /dct/bpm/settings
 * routes (BPM owns no ORDS module; these two templates live on dct.admin —
 * final apps/BPM/db/03_bpm_settings_ords.sql, re-run after any db/v2/11 re-run).
 */
define(['services/api'], function (api) {
  'use strict';

  return {
    /** All DCT_MODULE_SETTINGS rows for module BPM. */
    getSettings: function () {
      return api.get('/bpm/settings').then(function (r) { return r.items || []; });
    },

    /** One row by key (or null). */
    getByKey: function (key) {
      return this.getSettings().then(function (items) {
        return items.find(function (s) { return s.key === key; }) || null;
      });
    },

    /** Update a setting's value (WF_ADMIN / SYS_ADMIN on the server). */
    updateSetting: function (settingId, value) {
      return api.put('/bpm/settings/' + settingId, { value: value });
    }
  };
});
