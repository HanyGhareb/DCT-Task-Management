/**
 * shared/js/shell.js — shared shell glue (Phase 3, approved mockup rev 3).
 *
 * 1. MODULE REGISTRY — drives the top-bar module switcher in every app.
 *    Default brand colors here are FALLBACKS; the live color comes from each
 *    module's THEME_BRAND_COLOR row in DCT_MODULE_SETTINGS (Settings page).
 * 2. applyBrand(hex) — injects --brand/--brand-rgb and DERIVES --brand-dark
 *    and --brand-soft from the one stored hex (admins manage a single color).
 * 3. initBrand(moduleKey, getSettingFn) — applies the registry default
 *    immediately, then overrides with the setting when it resolves.
 */
define([], function () {
  'use strict';

  var MODULES = [
    { key: 'admin', code: 'iF', app: '200', color: '#C74634', url: '/Admin/Jet/index.html',
      nameKey: 'mod.admin', descKey: 'mod.admin.desc' },
    { key: 'pc',    code: 'PC', app: '201', color: '#2E7D32', url: '/PC/Jet/index.html',
      nameKey: 'mod.pc',    descKey: 'mod.pc.desc' },
    { key: 'cc',    code: 'CC', app: '202', color: '#B0721E', url: null, soon: true,
      nameKey: 'mod.cc',    descKey: 'mod.cc.desc' },
    { key: 'fl',    code: 'FL', app: '203', color: '#7C4DBE', url: null, soon: true,
      nameKey: 'mod.fl',    descKey: 'mod.fl.desc' },
    { key: 'dt',    code: 'DT', app: '204', color: '#0572CE', url: '/DT/Jet/index.html',
      nameKey: 'mod.dt',    descKey: 'mod.dt.desc' },
    { key: 'hr',    code: 'HR', app: '205', color: '#1a7f5a', url: '/HR/Jet/index.html',
      nameKey: 'mod.hr',    descKey: 'mod.hr.desc' }
  ];

  function byKey(key) {
    for (var i = 0; i < MODULES.length; i++) if (MODULES[i].key === key) return MODULES[i];
    return MODULES[0];
  }

  /* ── one hex → brand / brand-rgb / brand-dark / brand-soft ─────────── */
  function hex2rgb(h) {
    h = String(h || '').replace('#', '');
    if (h.length === 3) h = h.replace(/./g, '$&$&');
    if (!/^[0-9a-fA-F]{6}$/.test(h)) return null;
    var n = parseInt(h, 16);
    return [n >> 16 & 255, n >> 8 & 255, n & 255];
  }
  function mix(a, b, t) { return a.map(function (v, i) { return Math.round(v + (b[i] - v) * t); }); }
  function rgb2hex(r) {
    return '#' + r.map(function (v) { var s = v.toString(16); return s.length === 1 ? '0' + s : s; }).join('');
  }

  function applyBrand(hex) {
    var rgb = hex2rgb(hex);
    if (!rgb) return false;
    var st = document.documentElement.style;
    st.setProperty('--brand', '#' + String(hex).replace('#', ''));
    st.setProperty('--brand-rgb', rgb.join(','));
    st.setProperty('--brand-dark', rgb2hex(mix(rgb, [0, 0, 0], .28)));
    st.setProperty('--brand-soft', rgb2hex(mix(rgb, [255, 255, 255], .90)));
    return true;
  }

  /**
   * Apply the registry default now, then the module's THEME_BRAND_COLOR
   * when it arrives. getSettingPromise: () => Promise<hex|null> (optional).
   */
  function initBrand(moduleKey, getSettingPromise) {
    applyBrand(byKey(moduleKey).color);
    if (typeof getSettingPromise === 'function') {
      try {
        getSettingPromise().then(function (hex) {
          if (hex) applyBrand(hex);
        }).catch(function () {});
      } catch (e) {}
    }
  }

  return { MODULES: MODULES, byKey: byKey, applyBrand: applyBrand, initBrand: initBrand };
});
