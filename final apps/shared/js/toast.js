/**
 * shared/js/toast.js — singleton toast stack (Phase 3 async-state standard).
 * Pure DOM, no Knockout dependency. Styles live in shared/css/platform.css.
 *
 *   toast.show('error', 'Title', 'Body', 7000);
 *   toast.error('Request failed');     toast.success('Saved');
 *
 * Stack is capped at 4; each toast auto-dismisses (default 5s) and is
 * RTL-aware via logical CSS properties on .toast-host.
 */
define([], function () {
  'use strict';

  var host = null;

  function ensureHost() {
    if (!host || !document.body.contains(host)) {
      host = document.createElement('div');
      host.className = 'toast-host';
      document.body.appendChild(host);
    }
    return host;
  }

  /* opts (Wave 1): { actionLabel, onAction } renders an inline action button
     (the undo pattern) — clicking it runs onAction and dismisses the toast. */
  function show(type, title, body, ms, opts) {
    var h = ensureHost();
    var el = document.createElement('div');
    el.className = 'toast' + (type ? ' toast--' + type : '');
    var x = document.createElement('button');
    x.className = 'toast__x';
    x.innerHTML = '&#10005;';
    x.onclick = function () { dismiss(); };
    var txt = document.createElement('div');
    if (title) {
      var t = document.createElement('span');
      t.className = 'toast__title';
      t.textContent = title;
      txt.appendChild(t);
    }
    if (body) {
      var b = document.createElement('span');
      b.className = 'toast__body';
      b.textContent = body;
      txt.appendChild(b);
    }
    if (opts && opts.actionLabel && typeof opts.onAction === 'function') {
      var a = document.createElement('button');
      a.className = 'toast__action';
      a.textContent = opts.actionLabel;
      a.onclick = function () {
        dismiss();
        try { opts.onAction(); } catch (e) {}
      };
      txt.appendChild(a);
    }
    el.appendChild(txt);
    el.appendChild(x);
    h.appendChild(el);
    while (h.children.length > 4) h.removeChild(h.firstChild);

    var timer = setTimeout(dismiss, ms || 5000);
    function dismiss() {
      clearTimeout(timer);
      if (el.parentNode) el.parentNode.removeChild(el);
    }
    return dismiss;
  }

  return {
    show:    show,
    error:   function (body, title) { return show('error',   title || 'Error',   body, 7000); },
    success: function (body, title) { return show('success', title || 'Done',    body); },
    info:    function (body, title) { return show('info',    title || '',        body); },
    warn:    function (body, title) { return show('warn',    title || '',        body); },
    /* undo('User deactivated', fn, 'Undo') — 8s window, then it sticks */
    undo:    function (body, onUndo, label) {
      return show('info', '', body, 8000, { actionLabel: label || 'Undo', onAction: onUndo });
    }
  };
});
