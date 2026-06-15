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
    /* No Content-Type on body-less requests — ORDS rejects a DELETE that
       declares application/json with a zero-length body (HTTP 400). */
    var headers = body !== undefined ? { 'Content-Type': 'application/json' } : {};
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

  /* ── Binary upload / download ────────────────────────────────────────────
     putBinary sends a File/Blob as the raw request body (NO base64, NO JSON),
     so there is no ~32 KB cap — the ORDS handler reads it via :body (BLOB).
     File metadata (name, mime, ...) rides in the query string since the body
     is the file's bytes. fetchBlobUrl pulls a session-protected media/stream
     endpoint with the Bearer token and returns an object URL for view/download.
  */
  function callBinary(method, path, file, opts) {
    opts = opts || {};
    var headers = {};
    headers['Content-Type'] = opts.mime || (file && file.type) || 'application/octet-stream';
    var token = getToken();
    if (token) headers['Authorization'] = 'Bearer ' + token;

    var meta = opts.query || {};
    var q = [];
    Object.keys(meta).forEach(function (k) {
      if (meta[k] !== undefined && meta[k] !== null && meta[k] !== '') {
        q.push(encodeURIComponent(k) + '=' + encodeURIComponent(meta[k]));
      }
    });
    var url = config.apiBase + path + (q.length ? (path.indexOf('?') >= 0 ? '&' : '?') + q.join('&') : '');

    return fetch(url, { method: method, headers: headers, body: file }).then(function (r) {
      if (r.status === 401) {
        handleExpiredSession();
        return Promise.reject({ status: 401, message: 'Session expired. Please log in again.' });
      }
      return r.text().then(function (text) {
        var data = {};
        try { if (text) data = JSON.parse(text); } catch (e) {}
        if (!r.ok) {
          var msg = (data && (data.message || data.error)) || ('Upload failed (' + r.status + ')');
          if (!opts.silent) toast.error(msg);
          return Promise.reject({ status: r.status, message: msg });
        }
        return data;
      });
    }, function (netErr) {
      if (!opts.silent) toast.error('Network error — upload failed.');
      return Promise.reject({ status: 0, message: String(netErr) });
    });
  }

  function fetchBlobUrl(path, opts) {
    opts = opts || {};
    var headers = {};
    var token = getToken();
    if (token) headers['Authorization'] = 'Bearer ' + token;
    return fetch(config.apiBase + path, { method: 'GET', headers: headers }).then(function (r) {
      if (r.status === 401) {
        handleExpiredSession();
        return Promise.reject({ status: 401, message: 'Session expired. Please log in again.' });
      }
      if (!r.ok) {
        if (!opts.silent) toast.error('Could not open the file (' + r.status + ').');
        return Promise.reject({ status: r.status, message: 'Download failed (' + r.status + ')' });
      }
      return r.blob().then(function (b) { return URL.createObjectURL(b); });
    }, function (netErr) {
      if (!opts.silent) toast.error('Network error — could not open the file.');
      return Promise.reject({ status: 0, message: String(netErr) });
    });
  }

  return {
    get:    function (path, opts)       { return call('GET',    path, undefined, opts); },
    post:   function (path, body, opts) { return call('POST',   path, body,      opts); },
    put:    function (path, body, opts) { return call('PUT',    path, body,      opts); },
    delete: function (path, opts)       { return call('DELETE', path, undefined, opts); },
    putBinary:    function (path, file, opts) { return callBinary('PUT',  path, file, opts); },
    postBinary:   function (path, file, opts) { return callBinary('POST', path, file, opts); },
    fetchBlobUrl: fetchBlobUrl
  };
});
