/**
 * themeService.js — Platform theme management
 *
 * Applies theme via data-theme on <body> and persists to
 * localStorage('ifinance_theme') so child module SPAs inherit the theme
 * without a separate DB call.
 *
 * init()  — applies localStorage value immediately (sync), then syncs
 *            from ORDS in the background.
 * save()  — applies immediately + persists to ORDS; returns Promise.
 *
 * Valid theme IDs: 'corporate' | 'redwood' | 'midnight'
 * Default (no data-theme on body) = corporate.
 */
define(['services/settingService'], function (settingService) {
  'use strict';

  var KEY     = 'APP_THEME';
  var VALID   = ['corporate', 'redwood', 'midnight', 'vault'];
  var DEFAULT = 'corporate';
  var LS_KEY  = 'ifinance_theme';

  /** Sync read from localStorage — always fast. */
  function getCurrent() {
    var stored = localStorage.getItem(LS_KEY);
    return (stored && VALID.includes(stored)) ? stored : DEFAULT;
  }

  /** Apply theme to DOM immediately. */
  function apply(themeId) {
    var id = VALID.includes(themeId) ? themeId : DEFAULT;
    if (id === 'corporate') {
      document.body.removeAttribute('data-theme');
    } else {
      document.body.setAttribute('data-theme', id);
    }
    localStorage.setItem(LS_KEY, id);
  }

  /** Apply immediately + persist to ORDS. Returns Promise. */
  function save(themeId) {
    apply(themeId);
    return settingService.updateSetting(KEY, themeId);
  }

  /**
   * Apply from localStorage instantly, then fetch from ORDS and re-apply
   * if the DB value differs (handles first-ever load with no localStorage).
   */
  function init() {
    apply(getCurrent());
    settingService.getByKey(KEY).then(function (s) {
      if (s && s.settingValue && VALID.includes(s.settingValue)) {
        apply(s.settingValue);
      }
    }).catch(function () {});
  }

  return { getCurrent: getCurrent, apply: apply, save: save, init: init };
});
