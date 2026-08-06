/**
 * payService.js — Outsource Payroll data layer (App 215).
 * ORDS-only over /ords/admin/pay/ via the shared fetch wrapper.
 */
define(['services/api', 'services/config'], function (api, config) {
  'use strict';

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

    /** Identity flags + PAY_* lookups + DCT banks. */
    boot: function () { return api.get('/boot'); },

    /** Overview dashboard figures + expiring contracts. */
    stats: function () { return api.get('/stats'); },

    // ── Companies ────────────────────────────────────────────────────
    getCompanies:  function (params)   { return api.get('/companies' + qs(params)); },
    getCompany:    function (id)       { return api.get('/companies/' + id); },
    createCompany: function (body)     { return api.post('/companies', body); },
    updateCompany: function (id, body) { return api.put('/companies/' + id, body); },

    // ── Supplier references ──────────────────────────────────────────
    addSupplierRef:    function (companyId, body) { return api.post('/companies/' + companyId + '/suppliers', body); },
    updateSupplierRef: function (refId, body)     { return api.put('/suppliers/' + refId, body); },
    lovSuppliers:      function (search)          { return api.get('/lov/suppliers' + qs({ search: search })); },

    // ── Contracts ────────────────────────────────────────────────────
    getContracts:   function (params)   { return api.get('/contracts' + qs(params)); },
    getContract:    function (id)       { return api.get('/contracts/' + id); },
    createContract: function (body)     { return api.post('/contracts', body); },
    updateContract: function (id, body) { return api.put('/contracts/' + id, body); },
    amendContract:  function (id, body) { return api.post('/contracts/' + id + '/amend', body); },

    // ── Margin rules ─────────────────────────────────────────────────
    addMarginRule:    function (contractId, body) { return api.post('/contracts/' + contractId + '/margin-rules', body); },
    updateMarginRule: function (ruleId, body)     { return api.put('/margin-rules/' + ruleId, body); },

    // ── DCT banks ────────────────────────────────────────────────────
    getBanks:   function ()         { return api.get('/banks'); },
    createBank: function (body)     { return api.post('/banks', body); },
    updateBank: function (id, body) { return api.put('/banks/' + id, body); },

    // ── Documents (shared DCT_DOCUMENTS, raw binary upload) ──────────
    getDocs:   function (type, id) { return api.get('/docs' + qs({ type: type, id: id })); },
    uploadDoc: function (type, id, file) {
      // ORDS reads file_name / mime_type from the query string (raw :body = bytes only)
      return api.putBinary('/docs', file, {
        mime: file.type || 'application/octet-stream',
        query: {
          type: type, id: id,
          file_name: file.name,
          mime_type: file.type || 'application/octet-stream'
        }
      });
    },
    deleteDoc: function (docId)    { return api.delete('/docs/' + docId); },
    docFileUrl: function (docId)   { return api.fetchBlobUrl('/docs/' + docId + '/file'); },
  };
});
