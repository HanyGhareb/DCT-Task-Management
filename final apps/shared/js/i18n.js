/**
 * shared/js/i18n.js — EN/AR translation + RTL helper (Phase 3).
 *
 * Usage (appController):
 *   i18n.init().then(boot);              // loads /shared/i18n/common.<lang>.json
 *                                        // + js/i18n/app.<lang>.json (app strings)
 *   self.t    = i18n.t;                  // views: data-bind="text: $root.t('users.title')"
 *   self.lang = i18n.lang;
 *
 * t() reads both lang() and an internal revision observable, so every KO
 * binding re-evaluates live when the language switches — no page reload.
 * Persistence: localStorage 'ifinance_lang' (shared across the 4 same-origin
 * apps) + optional server echo via the Admin prefs/ endpoint (caller's job).
 * Numbers/amounts keep LATIN DIGITS in Arabic (finance convention).
 */
define(['knockout'], function (ko) {
  'use strict';

  var LS_KEY = 'ifinance_lang';
  var lang   = ko.observable(localStorage.getItem(LS_KEY) === 'ar' ? 'ar' : 'en');
  var rev    = ko.observable(0);
  var dicts  = { en: {}, ar: {} };
  var loaded = { en: false, ar: false };

  function applyDocument(l) {
    document.documentElement.lang = l;
    document.documentElement.dir  = (l === 'ar') ? 'rtl' : 'ltr';
  }

  function fetchJson(url) {
    // Same cache policy as requirejs urlArgs: fresh on localhost, APP_VERSION on deploys.
    var v = (!window.APP_VERSION || /^(localhost|127\.0\.0\.1)$/.test(location.hostname))
            ? Date.now() : window.APP_VERSION;
    return fetch(url + '?v=' + v).then(function (r) {
      return r.ok ? r.json() : {};
    }).catch(function () { return {}; });
  }

  function load(l) {
    if (loaded[l]) return Promise.resolve();
    return Promise.all([
      fetchJson('/shared/i18n/common.' + l + '.json'),
      fetchJson('js/i18n/app.' + l + '.json')
    ]).then(function (parts) {
      dicts[l] = Object.assign({}, parts[0], parts[1]);
      loaded[l] = true;
      rev(rev() + 1);
    });
  }

  /** t('users.title') | t('pager.range', [26, 50, 312]) */
  function t(key, params) {
    rev();                                   // KO dependency: re-eval on dict load
    var l = lang();
    var v = dicts[l][key];
    if (v === undefined && l !== 'en') v = dicts.en[key];
    if (v === undefined) v = key;
    if (params) {
      params.forEach(function (p, i) { v = v.split('{' + i + '}').join(p); });
    }
    return v;
  }

  /* True once the user explicitly picked a language this session (lang pill on
     login page or topbar). Decision rule for post-login sync (UAT LOG-07):
     explicit choice this session > stored server pref > default EN. */
  var userTouched = false;

  function setLang(l, opts) {
    if (l !== 'en' && l !== 'ar') return;
    if (!opts || !opts.system) userTouched = true;
    localStorage.setItem(LS_KEY, l);
    applyDocument(l);
    load(l).then(function () { lang(l); });
  }

  function init() {
    applyDocument(lang());
    // Load current language now; prefetch the other quietly for instant toggle.
    var p = load(lang());
    setTimeout(function () { load(lang() === 'en' ? 'ar' : 'en'); }, 1500);
    return p;
  }

  /* Latin digits in both languages (finance convention) */
  function fmtNum(n, frac) {
    if (n === null || n === undefined || isNaN(n)) return '';
    return new Intl.NumberFormat('en-AE', {
      minimumFractionDigits: frac === undefined ? 0 : frac,
      maximumFractionDigits: frac === undefined ? 2 : frac
    }).format(n);
  }
  function fmtDate(d, opts) {
    if (!d) return '';
    var dt = (d instanceof Date) ? d : new Date(d);
    if (isNaN(dt)) return String(d);
    var locale = lang() === 'ar' ? 'ar-AE-u-nu-latn' : 'en-GB';
    return new Intl.DateTimeFormat(locale, opts || { year: 'numeric', month: 'short', day: 'numeric' }).format(dt);
  }

  return {
    t: t, lang: lang, setLang: setLang, init: init,
    toggle: function () { setLang(lang() === 'en' ? 'ar' : 'en'); },
    wasUserSet: function () { return userTouched; },
    fmtNum: fmtNum, fmtDate: fmtDate
  };
});
