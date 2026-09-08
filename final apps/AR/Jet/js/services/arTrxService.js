/**
 * arTrxService.js — AR Transactions dashboard data layer (App 206).
 * ORDS-only over /ords/admin/ar/trx/* (AR/db/12). All reads.
 *
 * Facet params object (all optional): datefrom, dateto, duefrom, dueto,
 * glfrom, glto, customer, ctype, ttype, source, bu, complete, status, aging,
 * terms, project, cc, account, memo, search — multi-value facets are
 * pipe-delimited strings (a|b|c). Level = 'trx' | 'line'.
 */
define(['services/api', 'services/config'], function (api, config) {
  'use strict';

  var LEVEL_PATH = { trx: '/trx/list', line: '/trx/lines' };

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

    /** Facet LOVs + counts + min/max transaction date. */
    getFilters: function (params) { return api.get('/trx/filters' + qs(params)); },

    /** Executive KPIs + chart datasets for the current facet selection. */
    getSummary: function (params) { return api.get('/trx/summary' + qs(params)); },

    /** Paged register rows at the requested level. */
    getRows: function (level, params) {
      return api.get((LEVEL_PATH[level] || '/trx/list') + qs(params));
    },

    /** One transaction: header + lines (drill window). */
    getDetail: function (id) { return api.get('/trx/detail/' + id); },

    /** Authed CSV download URL (blob object URL) for the level's export. */
    getExportBlobUrl: function (level, params) {
      return api.fetchBlobUrl((LEVEL_PATH[level] || '/trx/list') + '/export' + qs(params));
    },

    /** Raw CSV text of the level's export (for the XLSX conversion). */
    getExportCsvText: function (level, params) {
      var path = (LEVEL_PATH[level] || '/trx/list') + '/export' + qs(params);
      return fetch(config.apiBase + path, {
        headers: { 'Authorization': 'Bearer ' + (JSON.parse(localStorage.getItem('ifinance_jet_session') || '{}').sessionId || '') }
      }).then(function (r) {
        if (!r.ok) throw new Error('Export failed (' + r.status + ')');
        return r.text();
      });
    },
  };
});
