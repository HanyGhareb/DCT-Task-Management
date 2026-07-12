/**
 * arCustomerService.js — ORDS calls for the AR Customer pages (DoF Fusion
 * Receivables SOAP integration). Base: /ords/admin/ar/customers/.
 * All methods return Promises.
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
    list:   function (params)      { return api.get('/customers/' + qs(params)); },
    get:    function (id)          { return api.get('/customers/' + id); },
    create: function (payload)     { return api.post('/customers/', payload); },
    update: function (id, payload) { return api.put('/customers/' + id, payload); },
    remove: function (id)          { return api['delete']('/customers/' + id); },
    submit: function (id)          { return api.post('/customers/' + id + '/submit', {}); },
    sync:   function (id)          { return api.post('/customers/' + id + '/sync', {}); },

    // live Fusion lookup (dup check); params: name/code/vat/iden/cr/fromdt/todt/wstatus/page
    wsSearch: function (params)    { return api.get('/customers/wssearch' + qs(params)); },

    // all AR_CUST_* value sets + countries + ws mode flags
    lovs:   function ()            { return api.get('/customers/lovs'); },
  };
});
