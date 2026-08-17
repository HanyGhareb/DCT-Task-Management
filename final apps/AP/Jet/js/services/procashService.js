/**
 * procashService.js — Procash Transactions data layer (App 212 / AP).
 * ORDS-only over /ords/admin/ap/procash*.
 *
 * A procash transaction is a manual payment pushed through the bank portal
 * directly, outside Fusion Payables. Every write is validated server side by
 * PROD.DCT_AP_PROCASH_PKG — this layer only shapes URLs.
 *
 * Collection POST has NO trailing slash (/procash); the register GET does
 * (/procash/). That mirrors the published ORDS templates exactly.
 */
define(['services/api'], function (api) {
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

  function base(id) { return '/procash/' + id; }

  return {

    /** Paged register: status, bu, from, to, supplier, linked, mismatch, mine, search. */
    list: function (params) { return api.get('/procash/' + qs(params)); },

    /** One transaction: header + lines + documents + history + findings. */
    get: function (id) { return api.get(base(id)); },

    create: function (body) { return api.post('/procash', body); },
    update: function (id, body) { return api.put(base(id), body); },
    remove: function (id) { return api.delete(base(id)); },

    submit:  function (id, comments) { return api.post(base(id) + '/submit',  { comments: comments || null }); },
    process: function (id, comments) { return api.post(base(id) + '/process', { comments: comments || null }); },
    cancel:  function (id, comments) { return api.post(base(id) + '/cancel',  { comments: comments || null }); },

    linkInvoice:   function (id, body) { return api.post(base(id) + '/invoice', body); },
    unlinkInvoice: function (id)       { return api.delete(base(id) + '/invoice'); },

    addLine:    function (id, body)         { return api.post(base(id) + '/lines', body); },
    updateLine: function (id, lineId, body) { return api.put(base(id) + '/lines/' + lineId, body); },
    deleteLine: function (id, lineId)       { return api.delete(base(id) + '/lines/' + lineId); },

    listDocs: function (id) { return api.get(base(id) + '/documents'); },
    /** Raw binary upload — the file IS the body; name/type ride the query string. */
    uploadDoc: function (id, file, docType) {
      return api.postBinary(base(id) + '/documents', file, {
        mime: file.type, query: { name: file.name, mime: file.type, doctype: docType || 'OTHER' }
      });
    },
    removeDoc:  function (id, docId) { return api.delete(base(id) + '/documents/' + docId); },
    docFileUrl: function (id, docId) { return api.fetchBlobUrl(base(id) + '/documents/' + docId + '/file'); },

    /** Pick lists: statuses, coding bases, currencies, business units, doc types + permissions. */
    lovs:     function ()       { return api.get('/procash/meta/lovs'); },
    projects: function (search) { return api.get('/procash/meta/projects' + qs({ search: search })); },
    tasks:    function (project, search) { return api.get('/procash/meta/tasks' + qs({ project: project, search: search })); },
    etypes:   function (search) { return api.get('/procash/meta/etypes' + qs({ search: search })); },
    glCombos: function (search) { return api.get('/procash/meta/gl' + qs({ search: search })); },
    suppliers: function (search) { return api.get('/procash/meta/suppliers' + qs({ search: search })); },
    invoices: function (params) { return api.get('/procash/meta/invoices' + qs(params)); },

    exportBlobUrl: function (params) { return api.fetchBlobUrl('/procash/meta/export' + qs(params)); },
  };
});
