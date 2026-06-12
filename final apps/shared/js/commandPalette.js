/**
 * shared/js/commandPalette.js — Ctrl+K / ⌘K global command palette (Wave 3).
 * Vanilla DOM (no KO dependency), Vault-styled via .cmdp-* classes in
 * platform.css. Any app can use it:
 *
 *   commandPalette.init({
 *     t: i18n.t,                      // for placeholder / hints
 *     providers: [
 *       { group: 'Navigation', min: 0, search: function (q) {
 *           return Promise.resolve([{ icon:'🏠', title:'Home', sub:'dashboard',
 *                                     run: function(){ app.navigate('dashboard'); } }]);
 *       } },
 *       ...
 *     ]
 *   });
 *
 * Provider contract: search(q) → Promise<[{icon, title, sub, run}]>.
 * `min` (default 0) = minimum query length before the provider is asked.
 * Results render grouped in provider order; keyboard: ↑/↓ move, Enter runs,
 * Esc closes. RTL-safe (logical properties only).
 */
define([], function () {
  'use strict';

  var opts    = null;
  var host    = null;
  var input   = null;
  var listEl  = null;
  var items   = [];      // flat [{...item, group}]
  var sel     = 0;
  var queryId = 0;       // discard stale async results

  function t(key, fallback) {
    var v = opts && typeof opts.t === 'function' ? opts.t(key) : key;
    return v === key ? fallback : v;
  }

  /* ── open / close ─────────────────────────────────────────────────── */
  function isOpen() { return !!host; }

  function open() {
    if (host) return;
    host = document.createElement('div');
    host.className = 'cmdp-overlay';
    host.innerHTML =
      '<div class="cmdp" role="dialog" aria-modal="true" aria-label="Command palette">' +
      '  <div class="cmdp-inputwrap">' +
      '    <span class="cmdp-glyph">&#8984;</span>' +
      '    <input class="cmdp-input" type="text" autocomplete="off" spellcheck="false">' +
      '    <kbd class="cmdp-esc">esc</kbd>' +
      '  </div>' +
      '  <div class="cmdp-list"></div>' +
      '  <div class="cmdp-foot"><kbd>&#8593;</kbd><kbd>&#8595;</kbd> ' +
           '<span class="cmdp-foot-txt"></span> <kbd>&#8629;</kbd></div>' +
      '</div>';
    document.body.appendChild(host);

    input  = host.querySelector('.cmdp-input');
    listEl = host.querySelector('.cmdp-list');
    input.placeholder = t('cmdp.placeholder', 'Search pages, users, roles, settings…');
    host.querySelector('.cmdp-foot-txt').textContent = t('cmdp.navigateHint', 'navigate');

    host.addEventListener('mousedown', function (e) {
      if (e.target === host) close();
    });
    input.addEventListener('keydown', onInputKey);
    input.addEventListener('input', function () { runQuery(input.value); });
    input.focus();
    runQuery('');
  }

  function close() {
    if (!host) return;
    host.parentNode.removeChild(host);
    host = input = listEl = null;
    items = [];
    sel = 0;
  }

  /* ── querying ─────────────────────────────────────────────────────── */
  function runQuery(q) {
    q = (q || '').trim();
    var id = ++queryId;
    var provs = (opts.providers || []).filter(function (p) {
      return q.length >= (p.min || 0);
    });
    Promise.all(provs.map(function (p) {
      var r;
      try { r = p.search(q); } catch (e) { r = []; }
      return Promise.resolve(r).then(function (res) {
        return (res || []).slice(0, p.limit || 6).map(function (it) {
          it.group = p.group;
          return it;
        });
      }).catch(function () { return []; });
    })).then(function (groups) {
      if (id !== queryId || !host) return;   // a newer query superseded this one
      items = Array.prototype.concat.apply([], groups);
      sel = 0;
      render();
    });
  }

  function render() {
    if (!listEl) return;
    listEl.innerHTML = '';
    if (!items.length) {
      var empty = document.createElement('div');
      empty.className = 'cmdp-empty';
      empty.textContent = t('cmdp.noResults', 'Nothing matches');
      listEl.appendChild(empty);
      return;
    }
    var lastGroup = null;
    items.forEach(function (it, i) {
      if (it.group !== lastGroup) {
        lastGroup = it.group;
        var g = document.createElement('div');
        g.className = 'cmdp-group';
        g.textContent = it.group;
        listEl.appendChild(g);
      }
      var row = document.createElement('div');
      row.className = 'cmdp-item' + (i === sel ? ' cmdp-item--sel' : '');
      row.setAttribute('data-idx', i);
      var ic = document.createElement('span');
      ic.className = 'cmdp-ic';
      ic.textContent = it.icon || '●';
      var txt = document.createElement('div');
      txt.className = 'cmdp-txt';
      var ti = document.createElement('div');
      ti.className = 'cmdp-title';
      ti.textContent = it.title;
      txt.appendChild(ti);
      if (it.sub) {
        var su = document.createElement('div');
        su.className = 'cmdp-sub';
        su.textContent = it.sub;
        txt.appendChild(su);
      }
      row.appendChild(ic);
      row.appendChild(txt);
      row.addEventListener('mouseenter', function () { sel = i; markSel(); });
      row.addEventListener('mousedown', function (e) { e.preventDefault(); runItem(it); });
      listEl.appendChild(row);
    });
  }

  function markSel() {
    if (!listEl) return;
    Array.prototype.forEach.call(listEl.querySelectorAll('.cmdp-item'), function (el) {
      var on = Number(el.getAttribute('data-idx')) === sel;
      el.classList.toggle('cmdp-item--sel', on);
      if (on && el.scrollIntoView) el.scrollIntoView({ block: 'nearest' });
    });
  }

  function runItem(it) {
    close();
    try { it.run(); } catch (e) {}
  }

  function onInputKey(e) {
    if (e.key === 'Escape')      { close(); }
    else if (e.key === 'ArrowDown') { e.preventDefault(); if (items.length) { sel = (sel + 1) % items.length; markSel(); } }
    else if (e.key === 'ArrowUp')   { e.preventDefault(); if (items.length) { sel = (sel - 1 + items.length) % items.length; markSel(); } }
    else if (e.key === 'Enter')     { if (items[sel]) runItem(items[sel]); }
  }

  /* ── public ───────────────────────────────────────────────────────── */
  function onGlobalKey(e) {
    if ((e.ctrlKey || e.metaKey) && String(e.key).toLowerCase() === 'k') {
      if (opts && typeof opts.enabled === 'function' && !opts.enabled()) return;
      e.preventDefault();
      if (isOpen()) close(); else open();
    }
  }

  return {
    /** init({ t, providers, enabled? }) — call once at app boot */
    init: function (options) {
      opts = options || {};
      document.removeEventListener('keydown', onGlobalKey);
      document.addEventListener('keydown', onGlobalKey);
    },
    open: open,
    close: close
  };
});
