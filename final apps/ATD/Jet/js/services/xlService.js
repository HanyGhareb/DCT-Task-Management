/**
 * xlService.js — VB Excel Template repository service (App 208).
 *
 * Talks to the PLATFORM `xl` ORDS module (/ords/admin/xl/), NOT the app's
 * own /atd/ module — so it cannot ride services/api.js (whose binary +
 * default calls are pinned to config.apiBase). The base is derived by
 * swapping the module segment, mirroring the shared api.js 'wf' pattern.
 *
 * Same Bearer token / 401 / error-toast contract as shared/js/api.js.
 * All errors from the server arrive as {"error":"..."} with a proper status.
 */
define(['services/config', 'shared/toast'], function (config, toast) {
  'use strict';

  var SESSION_KEY = 'ifinance_jet_session';
  var BASE = (config.xlBase ||
              (config.authBase || config.apiBase || '')
                .replace(/\/(dct|pc|dt|hr|fl|cc|ar|tm|atd|gl|rpt|ap)$/, '/xl'));

  function getToken() {
    try {
      var raw = localStorage.getItem(SESSION_KEY);
      return raw ? (JSON.parse(raw).sessionId || null) : null;
    } catch (e) { return null; }
  }

  function expired() {
    localStorage.removeItem(SESSION_KEY);
    if (config.adminPortalUrl) window.location.href = config.adminPortalUrl;
  }

  function qs(params) {
    var p = [];
    Object.keys(params || {}).forEach(function (k) {
      var v = params[k];
      if (v !== null && v !== undefined && v !== '') {
        p.push(encodeURIComponent(k) + '=' + encodeURIComponent(v));
      }
    });
    return p.length ? '?' + p.join('&') : '';
  }

  function call(method, path, body) {
    var headers = body !== undefined ? { 'Content-Type': 'application/json' } : {};
    var token = getToken();
    if (token) headers['Authorization'] = 'Bearer ' + token;
    return fetch(BASE + path, {
      method: method,
      headers: headers,
      body: body !== undefined ? JSON.stringify(body) : undefined
    }).then(function (r) {
      if (r.status === 401) {
        expired();
        return Promise.reject({ status: 401, message: 'Session expired. Please log in again.' });
      }
      return r.text().then(function (text) {
        var data = {};
        try { if (text) data = JSON.parse(text); } catch (e) {}
        if (!r.ok) {
          var msg = (data && (data.message || data.error)) || ('Request failed (' + r.status + ')');
          toast.error(msg);
          return Promise.reject({ status: r.status, message: msg });
        }
        return data;
      });
    }, function (netErr) {
      toast.error('Network error — check your connection.');
      return Promise.reject({ status: 0, message: String(netErr) });
    });
  }

  return {
    /* SYS_ADMIN — full repository (each template ships its versions[]) */
    list: function () { return call('GET', '/templates/'); },

    /* create (no templateId) or partial update (with templateId) */
    save: function (body) { return call('POST', '/templates/', body); },

    newVersion: function (templateId, notes) {
      return call('POST', '/templates/version', { templateId: templateId, notes: notes });
    },

    activate: function (templateId, versionNo) {
      return call('POST', '/templates/activate', { templateId: templateId, versionNo: versionNo });
    },

    deleteVersion: function (templateId, versionNo) {
      return call('POST', '/templates/delete-version', { templateId: templateId, versionNo: versionNo });
    },

    /* raw-binary workbook upload — kind = 'master' | 'published' */
    uploadFile: function (templateId, versionNo, kind, file) {
      var headers = { 'Content-Type': 'application/octet-stream' };
      var token = getToken();
      if (token) headers['Authorization'] = 'Bearer ' + token;
      var url = BASE + '/templates/file' + qs({
        templateid: templateId, ver: versionNo, kind: kind, filename: file.name
      });
      return fetch(url, { method: 'PUT', headers: headers, body: file }).then(function (r) {
        if (r.status === 401) {
          expired();
          return Promise.reject({ status: 401, message: 'Session expired. Please log in again.' });
        }
        return r.text().then(function (text) {
          var data = {};
          try { if (text) data = JSON.parse(text); } catch (e) {}
          if (!r.ok) {
            var msg = (data && (data.message || data.error)) || ('Upload failed (' + r.status + ')');
            toast.error(msg);
            return Promise.reject({ status: r.status, message: msg });
          }
          return data;
        });
      }, function (netErr) {
        toast.error('Network error — upload failed.');
        return Promise.reject({ status: 0, message: String(netErr) });
      });
    },

    /* authed blob fetch → object URL (caller revokes) */
    fileBlobUrl: function (templateId, versionNo, kind) {
      var headers = {};
      var token = getToken();
      if (token) headers['Authorization'] = 'Bearer ' + token;
      var url = BASE + '/templates/file' + qs({ templateid: templateId, ver: versionNo, kind: kind });
      return fetch(url, { method: 'GET', headers: headers }).then(function (r) {
        if (r.status === 401) {
          expired();
          return Promise.reject({ status: 401, message: 'Session expired. Please log in again.' });
        }
        if (!r.ok) {
          toast.error('Could not open the file (' + r.status + ').');
          return Promise.reject({ status: r.status, message: 'Download failed (' + r.status + ')' });
        }
        return r.blob().then(function (b) { return URL.createObjectURL(b); });
      }, function (netErr) {
        toast.error('Network error — could not open the file.');
        return Promise.reject({ status: 0, message: String(netErr) });
      });
    }
  };
});
