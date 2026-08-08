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
    getCompanyGovernance: function (id) { return api.get('/companies/' + id + '/governance'); },
    updateCompanyGovernance: function (id, body) { return api.put('/companies/' + id + '/governance', body); },
    addContact: function (id, body) { return api.post('/companies/' + id + '/contacts', body); },
    updateContact: function (id, body) { return api.put('/contacts/' + id, body); },
    addCompliance: function (id, body) { return api.post('/companies/' + id + '/compliance', body); },
    updateCompliance: function (id, body) { return api.put('/compliance/' + id, body); },
    addScore: function (id, body) { return api.post('/companies/' + id + '/scores', body); },

    // ── Supplier references ──────────────────────────────────────────
    addSupplierRef:    function (companyId, body) { return api.post('/companies/' + companyId + '/suppliers', body); },
    updateSupplierRef: function (refId, body)     { return api.put('/suppliers/' + refId, body); },
    lovSuppliers:      function (search)          { return api.get('/lov/suppliers' + qs({ search: search })); },
    lovSupplierSites: function (registryId) { return api.get('/lov/supplier-sites' + qs({ registryid: registryId })); },
    lovSupplierBanks: function (registryId) { return api.get('/lov/supplier-banks' + qs({ registryid: registryId })); },
    refreshSupplierRef: function (id) { return api.post('/suppliers/' + id + '/refresh', {}); },
    // Payment LOVs sourced from the AP installments extract (+ AP header for terms)
    lovPayment: function () { return api.get('/lov/payment'); },

    // ── Contracts ────────────────────────────────────────────────────
    getContracts:   function (params)   { return api.get('/contracts' + qs(params)); },
    getContract:    function (id)       { return api.get('/contracts/' + id); },
    createContract: function (body)     { return api.post('/contracts', body); },
    updateContract: function (id, body) { return api.put('/contracts/' + id, body); },
    amendContract:  function (id, body) { return api.post('/contracts/' + id + '/amend', body); },
    amendContractGoverned: function (id, body) { return api.post('/contracts/' + id + '/amend-governed', body); },
    getContractGovernance: function (id) { return api.get('/contracts/' + id + '/governance'); },
    updateContractGovernance: function (id, body) { return api.put('/contracts/' + id + '/governance', body); },
    addFeeRule: function (id, body) { return api.post('/contracts/' + id + '/fee-rules', body); },
    updateFeeRule: function (id, body) { return api.put('/fee-rules/' + id, body); },
    addRenewalAction: function (id, body) { return api.post('/contracts/' + id + '/renewal-actions', body); },

    // ── Margin rules ─────────────────────────────────────────────────
    addMarginRule:    function (contractId, body) { return api.post('/contracts/' + contractId + '/margin-rules', body); },
    updateMarginRule: function (ruleId, body)     { return api.put('/margin-rules/' + ruleId, body); },

    // ── DCT banks ────────────────────────────────────────────────────
    getBanks:   function ()         { return api.get('/banks'); },
    createBank: function (body)     { return api.post('/banks', body); },
    updateBank: function (id, body) { return api.put('/banks/' + id, body); },

    // ── Workforce (Phase 2) ──────────────────────────────────────────
    getEmployees:   function (params)   { return api.get('/employees' + qs(params)); },
    getEmployee:    function (id)       { return api.get('/employees/' + id); },
    createEmployee: function (body)     { return api.post('/employees', body); },
    updateEmployee: function (id, body) { return api.put('/employees/' + id, body); },
    addAssignment:    function (personId, body) { return api.post('/employees/' + personId + '/assignments', body); },
    updateAssignment: function (id, body)       { return api.put('/assignments/' + id, body); },
    lifecycle:        function (personId, body) { return api.post('/employees/' + personId + '/lifecycle', body); },
    addEmpBank:    function (personId, body) { return api.post('/employees/' + personId + '/banks', body); },
    updateEmpBank: function (id, body)        { return api.put('/emp-banks/' + id, body); },
    getEmpDocs: function (personId) { return api.get('/employees/' + personId + '/docs'); },
    uploadEmpDoc: function (personId, file, docType, expiry) {
      // ORDS reads doctype / file_name / mime_type / expiry from the query string
      return api.putBinary('/employees/' + personId + '/docs', file, {
        mime: file.type || 'application/octet-stream',
        query: {
          doctype: docType || 'PAY_DOCUMENT',
          file_name: file.name,
          mime_type: file.type || 'application/octet-stream',
          expiry: expiry || ''
        }
      });
    },
    bulkEmployees: function (rows)   { return api.post('/employees/bulk', { rows: rows }); },
    lovMasters:    function ()       { return api.get('/lov/masters'); },
    lovEmployees:  function (search) { return api.get('/lov/employees' + qs({ search: search })); },
    getExpiringDocs: function (days) { return api.get('/employees/expiring-docs' + qs({ days: days })); },

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
    getDataQuality: function () { return api.get('/governance/data-quality'); },
    getRenewals: function () { return api.get('/governance/renewals'); },
  };
});
