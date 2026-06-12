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
      mc: 'ADMIN',        nameKey: 'mod.admin', descKey: 'mod.admin.desc' },
    { key: 'pc',    code: 'PC', app: '201', color: '#2E7D32', url: '/PC/Jet/index.html',
      mc: 'PETTY_CASH',   nameKey: 'mod.pc',    descKey: 'mod.pc.desc' },
    { key: 'cc',    code: 'CC', app: '202', color: '#B0721E', url: '/CC/Jet/index.html',
      mc: 'CREDIT_CARDS', nameKey: 'mod.cc',    descKey: 'mod.cc.desc' },
    { key: 'fl',    code: 'FL', app: '203', color: '#7C4DBE', url: '/FL/Jet/index.html',
      mc: 'FREELANCERS',  nameKey: 'mod.fl',    descKey: 'mod.fl.desc' },
    { key: 'dt',    code: 'DT', app: '204', color: '#0572CE', url: '/DT/Jet/index.html',
      mc: 'DUTY_TRAVEL',  nameKey: 'mod.dt',    descKey: 'mod.dt.desc' },
    { key: 'hr',    code: 'HR', app: '205', color: '#1a7f5a', url: '/HR/Jet/index.html',
      mc: 'HR',           nameKey: 'mod.hr',    descKey: 'mod.hr.desc' },
    { key: 'ar',    code: 'AR', app: '206', color: '#6C4AB6', url: '/AR/Jet/index.html',
      mc: 'AR',           nameKey: 'mod.ar',    descKey: 'mod.ar.desc' }
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

  /* ── platform announcement banner (Phase 4) ────────────────────────────
     Fetches /dct/announcements/active for the module and injects a banner
     strip above the layout. Dismissals persist per announcement id for the
     browser session (sessionStorage). Vanilla DOM — no KO dependency. */
  var DISMISS_KEY = 'ifinance_dismissed_announcements';

  function dismissed() {
    try { return JSON.parse(sessionStorage.getItem(DISMISS_KEY) || '[]'); }
    catch (e) { return []; }
  }
  function dismiss(id) {
    var d = dismissed();
    if (d.indexOf(id) < 0) d.push(id);
    sessionStorage.setItem(DISMISS_KEY, JSON.stringify(d));
  }

  function renderBanners(items) {
    var old = document.getElementById('annBannerHost');
    if (old) old.parentNode.removeChild(old);
    var show = items.filter(function (a) { return dismissed().indexOf(a.announcementId) < 0; });
    if (!show.length) return;
    var isAr = (document.documentElement.lang || '').toLowerCase() === 'ar';
    var host = document.createElement('div');
    host.id = 'annBannerHost';
    show.forEach(function (a) {
      var bar = document.createElement('div');
      bar.className = 'ann-banner ann-banner--' + (a.severity || 'INFO').toLowerCase();
      var icon = a.severity === 'CRITICAL' ? '⛔' : (a.severity === 'WARNING' ? '⚠' : 'ℹ');
      var title = (isAr && a.titleAr) ? a.titleAr : a.titleEn;
      var body  = (isAr && a.bodyAr)  ? a.bodyAr  : (a.bodyEn || '');
      var text = document.createElement('div');
      text.className = 'ann-banner__text';
      var b = document.createElement('b');
      b.textContent = icon + ' ' + title;
      text.appendChild(b);
      if (body) {
        var span = document.createElement('span');
        span.textContent = ' — ' + body;
        text.appendChild(span);
      }
      var x = document.createElement('button');
      x.className = 'ann-banner__close';
      x.innerHTML = '&#10005;';
      x.onclick = function () {
        dismiss(a.announcementId);
        bar.parentNode.removeChild(bar);
        if (!host.childNodes.length) host.parentNode.removeChild(host);
      };
      bar.appendChild(text);
      bar.appendChild(x);
      host.appendChild(bar);
    });
    /* top of the work surface — scrolls with the page, never under the
       fixed topbar */
    var content = document.querySelector('.app-content');
    if (content) content.insertBefore(host, content.firstChild);
    else document.body.insertBefore(host, document.body.firstChild);
  }

  /**
   * initAnnouncements(moduleKey, authBase) — call once at app boot (after
   * initBrand). authBase = the /dct admin module base URL. Silently no-ops
   * when there is no session yet.
   */
  function initAnnouncements(moduleKey, authBase) {
    var token = null;
    try {
      var raw = localStorage.getItem('ifinance_jet_session');
      token = raw ? (JSON.parse(raw).sessionId || null) : null;
    } catch (e) {}
    if (!token || !authBase) return;
    fetch(authBase + '/announcements/active?module=' + encodeURIComponent(byKey(moduleKey).mc), {
      headers: { 'Authorization': 'Bearer ' + token }
    }).then(function (r) { return r.ok ? r.json() : { items: [] }; })
      .then(function (d) { renderBanners(d.items || []); })
      .catch(function () {});
  }

  return { MODULES: MODULES, byKey: byKey, applyBrand: applyBrand,
           initBrand: initBrand, initAnnouncements: initAnnouncements };
});
