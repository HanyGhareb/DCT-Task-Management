/**
 * rebillService.js — ORDS calls for the AR Invoice Rebill page.
 * Base: /ords/admin/ar/rebill/.
 *
 * The AR-side bridge onto the ATD Fusion write-back queue: requests enqueued
 * here are drained by the worker fleet, which drives the Fusion Receivables UI
 * (otbi-atd/runner/actions/ar_invoice_rebill.py). All methods return Promises.
 */
define(['services/config', 'services/api'],
function (config, api) {
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
    // rows: [{invoiceNumber, cm:{...}, duplicate:{...}, lines:[...]}] — max 500.
    // Returns {total, enqueued, errors, items:[{row, invoiceNumber, actionId,
    // status, error}]}.
    enqueue: function (rows) { return api.post('/rebill/requests', { rows: rows }); },

    // params: status / search / limit / offset
    list:    function (params) { return api.get('/rebill/requests' + qs(params)); },

    // one request + its 9-stage timeline
    get:     function (id)     { return api.get('/rebill/requests/' + id); },

    // credit reasons / tax classifications / finish modes / stage labels
    lovs:    function ()       { return api.get('/rebill/lovs'); }
  };
});
