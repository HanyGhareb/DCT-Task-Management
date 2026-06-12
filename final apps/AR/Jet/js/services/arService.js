/**
 * arService.js — all ORDS calls for the Accounts Receivable module.
 * Base: /ords/admin/ar/ (config.apiBase). All methods return Promises.
 */
define(['services/config', 'services/api', 'services/authService'],
function (config, api, authService) {
  'use strict';

  function qs(params) {
    var parts = [];
    Object.keys(params || {}).forEach(function (k) {
      if (params[k] !== null && params[k] !== undefined && params[k] !== '') {
        parts.push(encodeURIComponent(k) + '=' + encodeURIComponent(params[k]));
      }
    });
    return parts.length ? '?' + parts.join('&') : '';
  }

  return {

    /* ── events ─────────────────────────────────────────────────────── */
    getEvents: function (params) { return api.get('/events/' + qs(params)); },
    getEvent: function (id)      { return api.get('/events/' + id); },
    createEvent: function (data) { return api.post('/events/', data); },
    updateEvent: function (id, data) { return api.put('/events/' + id, data); },

    /* ── files ──────────────────────────────────────────────────────── */
    getFiles: function (eventId) { return api.get('/events/' + eventId + '/files'); },

    // metadata first (returns fileId + duplicate flag) …
    createFileMeta: function (eventId, meta) {
      return api.post('/events/' + eventId + '/files', meta);
    },

    // … then the raw binary
    uploadFileContent: function (fileId, file) {
      return file.arrayBuffer().then(function (buf) {
        var url = config.apiBase + '/files/' + fileId + '/content';
        return fetch(url, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/octet-stream',
            'Authorization': 'Bearer ' + authService.getToken(),
          },
          body: buf,
        }).then(function (r) {
          if (!r.ok) return Promise.reject({ status: r.status, message: 'File upload failed' });
          return {};
        });
      });
    },

    // authenticated download → blob URL (source-file links)
    downloadFile: function (fileId) {
      var url = config.apiBase + '/files/' + fileId + '/content';
      return fetch(url, {
        headers: { 'Authorization': 'Bearer ' + authService.getToken() },
      }).then(function (r) {
        if (!r.ok) return Promise.reject({ status: r.status, message: 'Download failed' });
        var disp = r.headers.get('Content-Disposition') || '';
        var m = disp.match(/filename="([^"]+)"/);
        return r.blob().then(function (b) {
          return { blob: b, fileName: m ? m[1] : ('file-' + fileId) };
        });
      });
    },

    confirmClassification: function (fileId, docCatId) {
      return api.put('/files/' + fileId + '/classification', { docCatId: docCatId });
    },

    deleteFile: function (fileId) { return api['delete']('/files/' + fileId); },

    /* ── AI processing ──────────────────────────────────────────────── */
    startProcessing: function (eventId, action) {
      return api.post('/events/' + eventId + '/process', { action: action || 'BOTH' });
    },
    retryFile: function (fileId) {
      return api.post('/files/' + fileId + '/process', {});
    },
    getProgress: function (eventId) { return api.get('/events/' + eventId + '/progress'); },

    /* ── P&L lines ──────────────────────────────────────────────────── */
    getPnl: function (eventId, params) {
      return api.get('/events/' + eventId + '/pnl' + qs(params));
    },
    createLine: function (eventId, data) { return api.post('/events/' + eventId + '/pnl', data); },
    updateLine: function (lineId, data)  { return api.put('/pnl/' + lineId, data); },
    deleteLine: function (lineId)        { return api['delete']('/pnl/' + lineId); },
    confirmLines: function (eventId, lineIds) {
      return api.post('/events/' + eventId + '/pnl/confirm',
                      lineIds && lineIds.length ? { lineIds: lineIds } : {});
    },

    /* ── findings + KPIs ────────────────────────────────────────────── */
    getFindings: function (eventId)        { return api.get('/events/' + eventId + '/findings'); },
    updateFinding: function (id, data)     { return api.put('/findings/' + id, data); },
    getKpis: function (eventId)            { return api.get('/events/' + eventId + '/kpis'); },
    createKpi: function (eventId, data)    { return api.post('/events/' + eventId + '/kpis', data); },
    updateKpi: function (id, data)         { return api.put('/kpis/' + id, data); },
    deleteKpi: function (id)               { return api['delete']('/kpis/' + id); },

    /* ── masters ────────────────────────────────────────────────────── */
    getCategories: function (params)       { return api.get('/categories/' + qs(params)); },
    createCategory: function (data)        { return api.post('/categories/', data); },
    updateCategory: function (id, data)    { return api.put('/categories/' + id, data); },
    getDocCategories: function (params)    { return api.get('/doc-categories/' + qs(params)); },
    createDocCategory: function (data)     { return api.post('/doc-categories/', data); },
    updateDocCategory: function (id, data) { return api.put('/doc-categories/' + id, data); },

    /* ── what-if scenarios ──────────────────────────────────────────── */
    getScenarios: function (eventId)       { return api.get('/scenarios/' + qs({ eventId: eventId })); },
    createScenario: function (data)        { return api.post('/scenarios/', data); },
    updateScenario: function (id, data)    { return api.put('/scenarios/' + id, data); },
    deleteScenario: function (id)          { return api['delete']('/scenarios/' + id); },

    /* ── stats + meta ───────────────────────────────────────────────── */
    getDashboard: function ()              { return api.get('/stats/dashboard'); },
    getEventStats: function (eventId)      { return api.get('/stats/events/' + eventId); },
    getLookups: function ()                { return api.get('/meta/lookups'); },
  };
});
