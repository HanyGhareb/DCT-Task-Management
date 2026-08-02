/**
 * themeService.js — Fusion BPM app skins.
 *
 * Applies a skin via `data-bpm-skin` on <body> (css/skins.css) and keeps it in
 * localStorage('bpm_skin') for a flash-free boot; the authoritative value is
 * the BPM module setting THEME_SKIN (admin-set, applies to every BPM user).
 *
 *   init()  — apply localStorage (default 'night') sync, then correct from ORDS.
 *   save()  — apply + persist THEME_SKIN; returns Promise.
 *
 * Valid ids: 'night' (default) | 'redwood' | 'diwan'.
 * The attribute name is BPM-local on purpose — Admin's data-theme vocabulary
 * (corporate/redwood/midnight/vault in shared/css/themes.css) must not collide.
 */
define(['services/settingService'], function (settingService) {
  'use strict';

  var KEY     = 'THEME_SKIN';
  var VALID   = ['night', 'redwood', 'diwan'];
  var DEFAULT = 'night';
  var LS_KEY  = 'bpm_skin';

  function getCurrent() {
    var stored = localStorage.getItem(LS_KEY);
    return (stored && VALID.indexOf(stored) >= 0) ? stored : DEFAULT;
  }

  function apply(id) {
    var skin = (VALID.indexOf(id) >= 0) ? id : DEFAULT;
    document.body.setAttribute('data-bpm-skin', skin);
    localStorage.setItem(LS_KEY, skin);
  }

  function save(id) {
    apply(id);
    return settingService.getByKey(KEY).then(function (s) {
      if (!s) { throw new Error('THEME_SKIN setting not seeded'); }
      return settingService.updateSetting(s.settingId, id.toUpperCase());
    });
  }

  /** Sync from the DB (no-op when unauthenticated — boot may precede login). */
  function sync() {
    return settingService.getByKey(KEY).then(function (s) {
      if (s && s.value && VALID.indexOf(String(s.value).toLowerCase()) >= 0) {
        apply(String(s.value).toLowerCase());
      }
    }).catch(function () {});
  }

  function init() {
    apply(getCurrent());
    sync();
  }

  return { VALID: VALID, getCurrent: getCurrent, apply: apply, save: save, sync: sync, init: init };
});
