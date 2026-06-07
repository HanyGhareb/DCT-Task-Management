/**
 * api.js — Fetch wrapper for ORDS REST endpoints.
 * Injects Bearer token from the shared ifinance_jet_session (set by Admin JET).
 * On 401: clears session and redirects to Admin portal (or mock login in dev).
 */
define(['services/config'], function (config) {
  'use strict';

  var SESSION_KEY = 'ifinance_jet_session';

  function getToken() {
    try {
      var raw = localStorage.getItem(SESSION_KEY);
      return raw ? (JSON.parse(raw).sessionId || null) : null;
    } catch (e) { return null; }
  }

  function _handleExpiredSession() {
    localStorage.removeItem(SESSION_KEY);
    if (config.apiBase) {
      window.location.href = '/Admin/Jet/index.html';
    } else if (window._hrApp) {
      window._hrApp.navigate('login');
    }
  }

  function call(method, path, body) {
    var headers = { 'Content-Type': 'application/json' };
    var token = getToken();
    if (token) headers['Authorization'] = 'Bearer ' + token;

    return fetch(config.apiBase + path, {
      method:  method,
      headers: headers,
      body:    body !== undefined ? JSON.stringify(body) : undefined,
    }).then(function (r) {
      if (r.status === 401) {
        _handleExpiredSession();
        return Promise.reject({ status: 401, message: 'Session expired. Please log in again.' });
      }
      return r.text().then(function (text) {
        var data = {};
        try { if (text) data = JSON.parse(text); } catch (e) {}
        if (!r.ok) return Promise.reject({ status: r.status, message: (data && (data.message || data.error)) || 'Request failed' });
        return data;
      });
    });
  }

  return {
    get:    function (path)       { return call('GET',    path); },
    post:   function (path, body) { return call('POST',   path, body); },
    put:    function (path, body) { return call('PUT',    path, body); },
    delete: function (path)       { return call('DELETE', path); },
  };
});
