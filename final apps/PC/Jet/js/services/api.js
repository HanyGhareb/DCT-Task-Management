/**
 * api.js — Fetch wrapper for ORDS REST endpoints.
 * Injects Bearer token, handles 401 auto-logout, normalises errors.
 */
define(['services/config'], function (config) {
  'use strict';

  var SESSION_KEY = 'ifinance_pc_session';

  function getToken() {
    try {
      var raw = localStorage.getItem(SESSION_KEY);
      return raw ? (JSON.parse(raw).sessionId || null) : null;
    } catch (e) { return null; }
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
        localStorage.removeItem(SESSION_KEY);
        if (window._pcApp) window._pcApp.navigate('login');
        return Promise.reject({ status: 401, message: 'Session expired. Please log in again.' });
      }
      return r.json().then(function (data) {
        if (!r.ok) return Promise.reject({ status: r.status, message: data.error || 'Request failed' });
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
