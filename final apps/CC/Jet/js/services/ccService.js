/**
 * ccService.js — all Credit Cards ORDS endpoint wrappers.
 * Every method returns a Promise (shared api.js adds the Bearer header).
 */
define(['services/api'], function (api) {
  'use strict';

  function qs(params) {
    var parts = [];
    Object.keys(params || {}).forEach(function (k) {
      var v = params[k];
      if (v !== undefined && v !== null && v !== '') {
        parts.push(encodeURIComponent(k) + '=' + encodeURIComponent(v));
      }
    });
    return parts.length ? '?' + parts.join('&') : '';
  }

  return {

    /* ── dashboard ─────────────────────────────────────────────────────── */
    getStats:  function () { return api.get('/dashboard/stats'); },
    getCharts: function () { return api.get('/dashboard/charts'); },

    /* ── cards ─────────────────────────────────────────────────────────── */
    getCards:        function (params) { return api.get('/cards/' + qs(params)); },
    getCard:         function (id)     { return api.get('/cards/' + id); },
    getLimitHistory: function (id)     { return api.get('/cards/' + id + '/limit-history').then(function (r) { return r.items || []; }); },
    registerCard:    function (data)   { return api.post('/cards/register', data); },

    /* ── requests ──────────────────────────────────────────────────────── */
    getRequests:     function (params) { return api.get('/requests/' + qs(params)); },
    getRequest:      function (id)     { return api.get('/requests/' + id); },
    createRequest:   function (data)   { return api.post('/requests/', data); },
    updateRequest:   function (id, data) { return api.put('/requests/' + id, data); },
    submitRequest:   function (id)     { return api.post('/requests/' + id + '/submit', {}); },
    withdrawRequest: function (id)     { return api.post('/requests/' + id + '/withdraw', {}); },

    /* ── documents ─────────────────────────────────────────────────────── */
    getDocRequirements: function (context) {
      return api.get('/doc-requirements' + qs({ context: context })).then(function (r) { return r.items || []; });
    },
    getDocuments: function (sourceType, sourceId) {
      return api.get('/documents/' + qs({ sourceType: sourceType, sourceId: sourceId }))
        .then(function (r) { return r.items || []; });
    },
    createDocument: function (data) { return api.post('/documents/', data); },
    uploadDocumentFile: function (id, b64, mime) {
      return api.put('/documents/' + id + '/file', { file_data_b64: b64, mime_type: mime });
    },

    /* ── replenishments ────────────────────────────────────────────────── */
    getReplenishments:    function (params) { return api.get('/replenishments/' + qs(params)); },
    getReplenishment:     function (id)     { return api.get('/replenishments/' + id); },
    createReplenishment:  function (data)   { return api.post('/replenishments/', data); },
    updateReplenishment:  function (id, data) { return api.put('/replenishments/' + id, data); },
    saveReplenishmentLines: function (id, lines) { return api.put('/replenishments/' + id + '/lines', { lines: lines }); },
    submitReplenishment:  function (id)     { return api.post('/replenishments/' + id + '/submit', {}); },

    /* ── proxies ───────────────────────────────────────────────────────── */
    getProxies:   function (params) { return api.get('/proxies/' + qs(params)).then(function (r) { return r.items || []; }); },
    createProxy:  function (data)   { return api.post('/proxies/', data); },
    updateProxy:  function (id, data) { return api.put('/proxies/' + id, data); },

    /* ── approvals ─────────────────────────────────────────────────────── */
    getPendingApprovals: function () {
      return api.get('/approvals/pending', { silent: true }).then(function (r) { return r.items || []; });
    },
    actionApproval: function (instanceId, action, comments) {
      return api.post('/approvals/' + instanceId + '/action', { action: action, comments: comments });
    },

    /* ── reference data ────────────────────────────────────────────────── */
    getLookups: function () { return api.get('/lookups'); },
    getGlCodes: function () { return api.get('/gl-codes'); },

    /* ── settings + notifications ──────────────────────────────────────── */
    getSettings: function () { return api.get('/settings').then(function (r) { return r.items || []; }); },
    updateSetting: function (settingId, value) { return api.put('/settings/' + settingId, { value: value }); },
    getNotifications: function () {
      return api.get('/notifications/', { silent: true }).then(function (r) { return r.items || []; });
    },
    markNotificationRead: function (id) { return api.post('/notifications/' + id + '/read', {}); },
    markAllNotificationsRead: function () { return api.post('/notifications/mark-all-read', {}); },
  };
});
