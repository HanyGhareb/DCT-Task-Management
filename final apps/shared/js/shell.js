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
      mc: 'AR',           nameKey: 'mod.ar',    descKey: 'mod.ar.desc' },
    { key: 'tm',    code: 'TM', app: '207', color: '#0E8A8A', url: '/TM/Jet/index.html',
      mc: 'TASK_MGMT',    nameKey: 'mod.tm',    descKey: 'mod.tm.desc' },
    { key: 'atd',   code: 'AT', app: '208', color: '#3A4FB0', url: '/ATD/Jet/index.html',
      mc: 'ATD',          nameKey: 'mod.atd',   descKey: 'mod.atd.desc' },
    { key: 'gl',    code: 'GL', app: '210', color: '#3F6F5F', url: '/GL/Jet/index.html',
      mc: 'GL',           nameKey: 'mod.gl',    descKey: 'mod.gl.desc' },
    { key: 'bi',    code: 'BI', app: '211', color: '#1F6F8B', url: '/BI/Jet/index.html',
      mc: 'REPORTING',    nameKey: 'mod.bi',    descKey: 'mod.bi.desc' }
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

  /* ── region appearance (region headers + borders, 2026-06-13) ───────────
     Five THEME_REGION_* settings drive every region header, table header and
     modal header through CSS vars (platform.css). Resolution order:
     module override (DCT_MODULE_SETTINGS row, non-empty value)
       → system default (DCT_SYSTEM_SETTINGS, delivered by GET /dct/boot)
         → the fallback baked into platform.css (mirrors the seed). */
  var REGION_KEYS = ['THEME_REGION_HEADER_BG', 'THEME_REGION_HEADER_FG',
                     'THEME_REGION_BORDER_COLOR', 'THEME_REGION_BORDER_WIDTH',
                     'THEME_REGION_BORDER_STYLE',
                     /* field-focus highlight (26_focus_theme.sql) — rides the same
                        boot → applyRegionTheme path as the region keys */
                     'THEME_FOCUS_COLOR', 'FEATURE_FOCUS_HIGHLIGHT', 'THEME_FOCUS_FILL_LEVEL'];

  function lum(rgb) {
    var a = rgb.map(function (v) {
      v /= 255; return v <= .03928 ? v / 12.92 : Math.pow((v + .055) / 1.055, 2.4);
    });
    return .2126 * a[0] + .7152 * a[1] + .0722 * a[2];
  }

  /** map: { THEME_REGION_HEADER_BG: '#334155', ... } — unknown/invalid values
      are ignored so a bad setting can never break the UI. */
  function applyRegionTheme(map) {
    map = map || {};
    var st = document.documentElement.style;
    var bgRgb = hex2rgb(map.THEME_REGION_HEADER_BG);
    var fgRgb = hex2rgb(map.THEME_REGION_HEADER_FG);
    if (bgRgb) st.setProperty('--region-hd-bg', rgb2hex(bgRgb));
    if (fgRgb) st.setProperty('--region-hd-fg', rgb2hex(fgRgb));
    if (bgRgb || fgRgb) {
      /* accent = darker of the pair (keeps table headers readable on soft
         fills); soft = 8% tint of the accent for thead backgrounds */
      var accent = (bgRgb && fgRgb) ? (lum(bgRgb) <= lum(fgRgb) ? bgRgb : fgRgb)
                                    : (bgRgb || fgRgb);
      st.setProperty('--region-hd-accent', rgb2hex(accent));
      st.setProperty('--region-hd-soft', rgb2hex(mix(accent, [255, 255, 255], .92)));
    }
    var bc = String(map.THEME_REGION_BORDER_COLOR || '').trim();
    if (bc.toUpperCase() === 'MATCH_HEADER') st.setProperty('--region-bd-color', 'var(--region-hd-bg)');
    else if (hex2rgb(bc)) st.setProperty('--region-bd-color', rgb2hex(hex2rgb(bc)));
    var bw = String(map.THEME_REGION_BORDER_WIDTH || '').trim();
    if (/^(\d+(\.\d+)?px|0)$/.test(bw)) st.setProperty('--region-bd-width', bw === '0' ? '0px' : bw);
    var bs = String(map.THEME_REGION_BORDER_STYLE || '').trim().toLowerCase();
    if (['solid', 'dashed', 'dotted', 'double'].indexOf(bs) >= 0) st.setProperty('--region-bd-style', bs);

    /* field-focus highlight: FEATURE_FOCUS_HIGHLIGHT flag gates THEME_FOCUS_COLOR.
       Absent flag → enabled (default-on convention). Disabled → neutral border,
       no colored ring. Invalid color is ignored so a bad setting can't break UI. */
    if ('FEATURE_FOCUS_HIGHLIGHT' in map || 'THEME_FOCUS_COLOR' in map) {
      var flag = String(map.FEATURE_FOCUS_HIGHLIGHT === undefined ? '' : map.FEATURE_FOCUS_HIGHLIGHT)
                   .trim().toLowerCase();
      var focusOff = (flag === 'n' || flag === 'false' || flag === '0');
      if (focusOff) {
        st.setProperty('--focus-color', 'var(--border-strong)');
        st.setProperty('--focus-ring', 'transparent');
        st.setProperty('--focus-fill', 'var(--surface)');
      } else {
        var fc = hex2rgb(map.THEME_FOCUS_COLOR);
        if (fc) {
          st.setProperty('--focus-color', rgb2hex(fc));
          st.setProperty('--focus-ring', 'rgba(' + fc.join(',') + ',0.20)');
          /* fill = opaque tint of the chosen color. THEME_FOCUS_FILL_LEVEL is the
             intensity 0–100 (% of the full color; higher = darker fill); default 15.
             level%→ mix t = 1 - level/100 toward white. */
          var lvl = parseFloat(map.THEME_FOCUS_FILL_LEVEL);
          if (isNaN(lvl)) lvl = 15;
          lvl = Math.max(0, Math.min(100, lvl));
          st.setProperty('--focus-fill', rgb2hex(mix(fc, [255, 255, 255], 1 - lvl / 100)));
        }
      }
    }
  }

  /**
   * initRegionTheme(authBase, getModuleRowsPromise) — module apps call this at
   * boot (Admin applies its existing /boot payload via applyRegionTheme
   * directly). Fetches the system defaults from /dct/boot, optionally merges
   * the module's own THEME_REGION_* rows on top, applies once. Silently
   * no-ops without a session.
   */
  function initRegionTheme(authBase, getModuleRowsPromise) {
    var sys = {}, mod = {};
    var token = null;
    try {
      var raw = localStorage.getItem('ifinance_jet_session');
      token = raw ? (JSON.parse(raw).sessionId || null) : null;
    } catch (e) {}
    var sysP = (token && authBase)
      ? fetch(authBase + '/boot', { headers: { 'Authorization': 'Bearer ' + token } })
          .then(function (r) { return r.ok ? r.json() : {}; })
          .then(function (d) {
            (d.settings || []).forEach(function (s) {
              if (REGION_KEYS.indexOf(s.key) >= 0) sys[s.key] = s.value;
            });
          }).catch(function () {})
      : Promise.resolve();
    var modP = Promise.resolve();
    if (typeof getModuleRowsPromise === 'function') {
      try {
        modP = getModuleRowsPromise().then(function (rows) {
          rows = (rows && rows.items) || rows || [];
          rows.forEach(function (r) {
            var k = r.settingKey || r.setting_key || r.key;
            var v = r.settingValue !== undefined ? r.settingValue
                  : (r.setting_value !== undefined ? r.setting_value : r.value);
            if (REGION_KEYS.indexOf(k) >= 0) mod[k] = v;
          });
        }).catch(function () {});
      } catch (e) {}
    }
    Promise.all([sysP, modP]).then(function () {
      var out = {};
      REGION_KEYS.forEach(function (k) {
        var v = (mod[k] !== undefined && mod[k] !== null && String(mod[k]) !== '') ? mod[k] : sys[k];
        if (v !== undefined && v !== null && String(v) !== '') out[k] = v;
      });
      applyRegionTheme(out);
    });
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

  /* ── feature flags (Wave 1) ─────────────────────────────────────────────
     Convention: FEATURE_<NAME> rows in DCT_SETTINGS, value 'Y'/'N'. Apps load
     settings once post-login and call setFeatures(); UI binds visibility via
     featureEnabled(). A missing row falls back to the call-site default, so
     features ship ON unless explicitly disabled (or pass dflt=false to ship
     dark until the row is flipped). */
  var features = {};

  function setFeatures(rows) {
    features = {};
    (rows || []).forEach(function (r) {
      var k = r.settingKey || r.key;
      if (k && k.indexOf('FEATURE_') === 0) {
        features[k] = String(r.settingValue !== undefined ? r.settingValue : r.value);
      }
    });
  }

  /** featureEnabled('COMMAND_PALETTE') or featureEnabled('FEATURE_COMMAND_PALETTE', false) */
  function featureEnabled(name, dflt) {
    var k = name.indexOf('FEATURE_') === 0 ? name : 'FEATURE_' + name;
    if (!(k in features)) return dflt === undefined ? true : !!dflt;
    return features[k] !== 'N' && features[k] !== 'false' && features[k] !== '0';
  }

  return { MODULES: MODULES, byKey: byKey, applyBrand: applyBrand,
           initBrand: initBrand, initAnnouncements: initAnnouncements,
           applyRegionTheme: applyRegionTheme, initRegionTheme: initRegionTheme,
           setFeatures: setFeatures, featureEnabled: featureEnabled };
});
