/**
 * apService.js — Accounts Payable analytics data layer (App 212).
 * ORDS-only over /ords/admin/ap/. All reads; the module is analytics-only.
 *
 * Facet params object (all optional): datefrom, dateto, supplier, paid, val,
 * acc, inv, itype, curr, paygroup, paymethod, sector, dept, cc, project,
 * task, etype, account, approp, po, pr, req, search — multi-value facets are
 * pipe-delimited strings (a|b|c). Level = 'header' | 'line' | 'dist'.
 */
define(['services/api', 'services/config'], function (api, config) {
  'use strict';

  var LEVEL_PATH = { header: '/invoices', line: '/lines', dist: '/dists' };

  function qs(params) {
    var parts = [];
    Object.keys(params || {}).forEach(function (k) {
      var v = params[k];
      if (v === null || v === undefined || v === '') return;
      parts.push(encodeURIComponent(k) + '=' + encodeURIComponent(v));
    });
    return parts.length ? '?' + parts.join('&') : '';
  }

  return {

    /** Facet LOVs + counts (inclcxl=N excludes cancelled invoices from them). */
    getFilters: function (params) { return api.get('/filters' + qs(params)); },

    /** KPIs + chart datasets for the current facet selection. */
    getSummary: function (params) { return api.get('/summary' + qs(params)); },

    /** Paged register rows at the requested level. */
    getRows: function (level, params) {
      return api.get((LEVEL_PATH[level] || '/invoices') + qs(params));
    },

    /** One invoice: header + lines + distributions (drill drawer). */
    getInvoice: function (id) { return api.get('/invoices/' + id); },

    /** Authed CSV download URL (blob object URL) for the level's export. */
    getExportBlobUrl: function (level, params) {
      return api.fetchBlobUrl((LEVEL_PATH[level] || '/invoices') + '/export' + qs(params));
    },

    /** Raw CSV text of the level's export (for the XLSX conversion). */
    getExportCsvText: function (level, params) {
      var path = (LEVEL_PATH[level] || '/invoices') + '/export' + qs(params);
      return fetch(config.apiBase + path, {
        headers: { 'Authorization': 'Bearer ' + (JSON.parse(localStorage.getItem('ifinance_jet_session') || '{}').sessionId || '') }
      }).then(function (r) {
        if (!r.ok) throw new Error('Export failed (' + r.status + ')');
        return r.text();
      });
    },
  };
});
