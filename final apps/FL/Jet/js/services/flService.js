/**
 * flService.js — Freelancers module data service (ORDS live only).
 * Base: /ords/admin/fl (services/config.js). All methods return Promises.
 * Pagination envelope: { items, total, limit, offset }.
 */
define(['services/api'], function (api) {
  'use strict';

  function qs(opts, keys) {
    var parts = ['limit=' + (opts.limit || 50), 'offset=' + (opts.offset || 0)];
    (keys || []).forEach(function (k) {
      if (opts[k] !== undefined && opts[k] !== null && opts[k] !== '') {
        parts.push(k + '=' + encodeURIComponent(opts[k]));
      }
    });
    return '?' + parts.join('&');
  }

  return {

    /* ── dashboard ─────────────────────────────────────────────────────── */
    getStats:  function () { return api.get('/dashboard/stats'); },
    getCharts: function () { return api.get('/dashboard/charts'); },

    /* ── reference data ────────────────────────────────────────────────── */
    getLookups: function () { return api.get('/lookups'); },
    getGlCodes: function () {
      return api.get('/gl-codes').then(function (r) { return Array.isArray(r) ? r : (r.items || []); });
    },

    /* ── registrations ─────────────────────────────────────────────────── */
    getRegistrations: function (opts) { return api.get('/registrations/' + qs(opts || {}, ['status', 'search'])); },
    getRegistration:  function (id)   { return api.get('/registrations/' + id); },
    createRegistration: function (d)  { return api.post('/registrations/', d); },
    updateRegistration: function (id, d) { return api.put('/registrations/' + id, d); },
    submitRegistration: function (id) { return api.post('/registrations/' + id + '/submit', {}); },
    uploadRegistrationPhoto: function (id, b64, mime, name) {
      return api.put('/registrations/' + id + '/photo',
                     { photo_data_b64: b64, mime_type: mime, file_name: name });
    },

    /* ── freelancers ───────────────────────────────────────────────────── */
    getFreelancers: function (opts) { return api.get('/freelancers/' + qs(opts || {}, ['status', 'search'])); },
    getFreelancer:  function (id)   { return api.get('/freelancers/' + id); },
    updateFreelancer: function (id, d) { return api.put('/freelancers/' + id, d); },
    addBankAccount: function (id, d) { return api.post('/freelancers/' + id + '/bank-accounts', d); },
    updateBankAccount: function (id, d) { return api.put('/bank-accounts/' + id, d); },

    /* ── contracts ─────────────────────────────────────────────────────── */
    getContracts: function (opts) { return api.get('/contracts/' + qs(opts || {}, ['status', 'freelancerId', 'search'])); },
    getContract:  function (id)   { return api.get('/contracts/' + id); },
    createContract: function (d)  { return api.post('/contracts/', d); },
    updateContract: function (id, d) { return api.put('/contracts/' + id, d); },
    submitContract: function (id) { return api.post('/contracts/' + id + '/submit', {}); },
    getContractSchedule: function (id) {
      return api.get('/contracts/' + id + '/schedule').then(function (r) { return r.items || []; });
    },
    getAmendments: function (contractId) {
      return api.get('/contracts/' + contractId + '/amendments').then(function (r) { return r.items || []; });
    },
    createAmendment: function (contractId, d) { return api.post('/contracts/' + contractId + '/amendments', d); },
    submitAmendment: function (id) { return api.post('/amendments/' + id + '/submit', {}); },

    /* ── renewals ──────────────────────────────────────────────────────── */
    getRenewals: function (contractId) {
      var q = contractId ? '?contractId=' + contractId : '';
      return api.get('/renewals/' + q).then(function (r) { return r.items || []; });
    },
    createRenewal: function (d)  { return api.post('/renewals/', d); },
    submitRenewal: function (id) { return api.post('/renewals/' + id + '/submit', {}); },

    /* ── payment schedule (global worklist) ───────────────────────────── */
    getSchedule: function (opts) { return api.get('/schedule/' + qs(opts || {}, ['status', 'dueBefore'])); },

    /* ── vouchers ──────────────────────────────────────────────────────── */
    getVouchers: function (opts) { return api.get('/vouchers/' + qs(opts || {}, ['status', 'paymentStatus', 'freelancerId'])); },
    getVoucher:  function (id)   { return api.get('/vouchers/' + id); },
    generateVoucher: function (scheduleId) { return api.post('/vouchers/', { scheduleId: scheduleId }); },
    updateVoucher: function (id, d) { return api.put('/vouchers/' + id, d); },
    submitVoucher: function (id) { return api.post('/vouchers/' + id + '/submit', {}); },
    markVoucherPaid: function (id, d) { return api.post('/vouchers/' + id + '/mark-paid', d || {}); },

    /* ── deliverables ──────────────────────────────────────────────────── */
    getDeliverables: function (opts) {
      opts = opts || {};
      var parts = [];
      if (opts.contractId) parts.push('contractId=' + opts.contractId);
      if (opts.status)     parts.push('status=' + opts.status);
      return api.get('/deliverables/' + (parts.length ? '?' + parts.join('&') : ''))
        .then(function (r) { return r.items || []; });
    },
    createDeliverable: function (d)  { return api.post('/deliverables/', d); },
    acceptDeliverable: function (id) { return api.post('/deliverables/' + id + '/accept', {}); },
    rejectDeliverable: function (id, reason) { return api.post('/deliverables/' + id + '/reject', { reason: reason }); },

    /* ── documents (unified store) ─────────────────────────────────────── */
    getDocuments: function (opts) { return api.get('/documents/' + qs(opts || {}, ['freelancerId', 'expiryStatus'])); },
    createDocument: function (d)  { return api.post('/documents/', d); },
    uploadDocumentFile: function (id, b64, mime) {
      return api.put('/documents/' + id + '/file', { file_data_b64: b64, mime_type: mime });
    },

    /* ── profile change requests ───────────────────────────────────────── */
    getProfileChanges: function (opts) {
      opts = opts || {};
      var parts = [];
      if (opts.freelancerId) parts.push('freelancerId=' + opts.freelancerId);
      if (opts.status)       parts.push('status=' + opts.status);
      return api.get('/profile-changes/' + (parts.length ? '?' + parts.join('&') : ''))
        .then(function (r) { return r.items || []; });
    },
    createProfileChange: function (d)  { return api.post('/profile-changes/', d); },
    submitProfileChange: function (id) { return api.post('/profile-changes/' + id + '/submit', {}); },

    /* ── approvals ─────────────────────────────────────────────────────── */
    getPendingApprovals: function () {
      return api.get('/approvals/pending', { silent: true }).then(function (r) { return r.items || []; });
    },
    actionApproval: function (instanceId, action, comments) {
      return api.post('/approvals/' + instanceId + '/action', { action: action, comments: comments });
    },

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
