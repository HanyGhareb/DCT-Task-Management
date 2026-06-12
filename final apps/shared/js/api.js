/**
 * shared/js/api.js — the ONE fetch wrapper for every JET app (Phase 3).
 * Each app's js/services/api.js is a 1-line re-export of this module, so the
 * ~30 existing service files keep their 'services/api' dependency unchanged.
 *
 * - Injects Bearer token from the shared ifinance_jet_session.
 * - 401: clears the session, then either redirects to the Admin portal
 *   (config.adminPortalUrl — module apps) or routes to the app's own login
 *   (window._jetApp — Admin). No toast on 401.
 * - Any other failure: toast.error(message) then reject. Pass
 *   { silent: true } as the last argument to suppress the toast when the
 *   caller renders the error inline.
 * - Tolerant body parsing (text → JSON), message from data.message||data.error.
 */
define(['services/config', 'shared/toast'], function (config, toast) {
  'use strict';

  var SESSION_KEY = 'ifinance_jet_session';

  function getToken() {
    try {
      var raw = localStorage.getItem(SESSION_KEY);
      return raw ? (JSON.parse(raw).sessionId || null) : null;
    } catch (e) { return null; }
  }

  function handleExpiredSession() {
    localStorage.removeItem(SESSION_KEY);
    if (config.adminPortalUrl) {
      window.location.href = config.adminPortalUrl;
    } else if (window._jetApp) {
      window._jetApp.navigate('login');
    } else if (window._hrApp) {
      window._hrApp.navigate('login');
    }
  }

  function call(method, path, body, opts) {
    opts = opts || {};
    var headers = { 'Content-Type': 'application/json' };
    var token = getToken();
    if (token) headers['Authorization'] = 'Bearer ' + token;

    var base = (opts.base === 'auth' && config.authBase) ? config.authBase : config.apiBase;

    /* 401 on /auth/* is a credential failure the caller must render inline
       (e.g. "Invalid credentials" on the login form) — redirecting there
       reloads the login view and silently eats the error message. */
    var isAuthCall = path.indexOf('/auth/') === 0;

    return fetch(base + path, {
      method:  method,
      headers: headers,
      body:    body !== undefined ? JSON.stringify(body) : undefined
    }).then(function (r) {
      if (r.status === 401 && !isAuthCall) {
        handleExpiredSession();
        return Promise.reject({ status: 401, message: 'Session expired. Please log in again.' });
      }
      return r.text().then(function (text) {
        var data = {};
        try { if (text) data = JSON.parse(text); } catch (e) {}
        if (!r.ok) {
          var msg = (data && (data.message || data.error)) || ('Request failed (' + r.status + ')');
          if (!opts.silent && !isAuthCall) toast.error(msg);
          return Promise.reject({ status: r.status, message: msg });
        }
        return data;
      });
    }, function (netErr) {
      if (!opts.silent) toast.error('Network error — check your connection.');
      return Promise.reject({ status: 0, message: String(netErr) });
    });
  }

  return {
    get:    function (path, opts)       { return call('GET',    path, undefined, opts); },
    post:   function (path, body, opts) { return call('POST',   path, body,      opts); },
    put:    function (path, body, opts) { return call('PUT',    path, body,      opts); },
    delete: function (path, opts)       { return call('DELETE', path, undefined, opts); }
  };
});
