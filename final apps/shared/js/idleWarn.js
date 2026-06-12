/**
 * shared/js/idleWarn.js — idle-session warning (Wave 3, 4.6).
 *
 * Sessions expire server-side after SESSION_TIMEOUT_MINS of inactivity
 * (dct_rest.validate_session, db/v2/19). This module watches USER activity
 * (keys / clicks / pointer) and, a few minutes before the cutoff, shows a
 * "Still there?" dialog: Extend pings the server (touches the session),
 * anything less lets the caller log the user out cleanly instead of a
 * surprise 401 mid-form.
 *
 *   idleWarn.init({
 *     timeoutMins: 480, warnMins: 5,
 *     t: i18n.t,
 *     onExtend: function () { return api.get('/notifications/count'); },
 *     onTimeout: function () { app.logout(); }
 *   });
 */
define([], function () {
  'use strict';

  var cfg = null;
  var lastActivity = Date.now();
  var modal = null;
  var timer = null;

  function activity() {
    lastActivity = Date.now();
  }

  function showModal() {
    if (modal) return;
    modal = document.createElement('div');
    modal.className = 'modal-overlay';
    modal.style.zIndex = '1300';
    var box = document.createElement('div');
    box.className = 'modal-box';
    box.style.maxWidth = '360px';
    box.style.padding = '26px';
    box.setAttribute('role', 'alertdialog');
    var h = document.createElement('h3');
    h.textContent = t('idle.title', 'Still there?');
    h.style.marginBottom = '8px';
    var p = document.createElement('p');
    p.textContent = t('idle.body', 'You have been inactive for a while. Extend your session or you will be signed out.');
    p.style.cssText = 'font-size:13px;color:var(--text-2);margin-bottom:18px';
    var row = document.createElement('div');
    row.style.cssText = 'display:flex;gap:10px;justify-content:flex-end';
    var ext = document.createElement('button');
    ext.className = 'btn btn-primary';
    ext.textContent = t('idle.extend', 'Stay signed in');
    ext.onclick = function () {
      hideModal();
      activity();
      try { if (cfg.onExtend) cfg.onExtend(); } catch (e) {}
    };
    var out = document.createElement('button');
    out.className = 'btn btn-secondary';
    out.textContent = t('idle.logout', 'Sign out');
    out.onclick = function () {
      hideModal();
      try { if (cfg.onTimeout) cfg.onTimeout(); } catch (e) {}
    };
    row.appendChild(out);
    row.appendChild(ext);
    box.appendChild(h);
    box.appendChild(p);
    box.appendChild(row);
    modal.appendChild(box);
    document.body.appendChild(modal);
    ext.focus();
  }

  function hideModal() {
    if (modal && modal.parentNode) modal.parentNode.removeChild(modal);
    modal = null;
  }

  function t(key, fallback) {
    var v = cfg && typeof cfg.t === 'function' ? cfg.t(key) : key;
    return v === key ? fallback : v;
  }

  function tick() {
    if (!cfg || typeof cfg.enabled === 'function' && !cfg.enabled()) return;
    var idleMs    = Date.now() - lastActivity;
    var timeoutMs = (cfg.timeoutMins || 480) * 60000;
    var warnMs    = (cfg.warnMins || 5) * 60000;
    if (idleMs >= timeoutMs) {
      hideModal();
      try { if (cfg.onTimeout) cfg.onTimeout(); } catch (e) {}
      activity();   // don't re-fire until something happens again
    } else if (idleMs >= timeoutMs - warnMs) {
      showModal();
    }
  }

  return {
    init: function (options) {
      cfg = options || {};
      lastActivity = Date.now();
      ['keydown', 'pointerdown', 'wheel'].forEach(function (ev) {
        document.addEventListener(ev, activity, { passive: true });
      });
      if (timer) clearInterval(timer);
      timer = setInterval(tick, 30000);
    },
    /** allow the app to update the timeout once /boot resolves */
    setTimeoutMins: function (mins) {
      if (cfg && mins > 0) cfg.timeoutMins = mins;
    }
  };
});
