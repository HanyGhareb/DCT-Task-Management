/**
 * runnerService.js — Automation Runners Registry (live ORDS)
 * ORDS (module dct.admin):
 *   GET    /runners/            list (search/category/runtime/status + paging)
 *   GET    /runners/meta        dropdown options
 *   POST   /runners/            create
 *   GET    /runners/:id         detail (incl. content text + file meta)
 *   PUT    /runners/:id         update
 *   DELETE /runners/:id         delete
 *   PUT    /runners/:id/file    raw-binary stored-copy upload
 *   GET    /runners/:id/file    stored-copy download (media)
 *   GET    /scheduler/jobs      PROD DBMS_SCHEDULER health (SYS_ADMIN)
 * All methods return Promises.
 */
define(['services/api'], function (api) {
  'use strict';

  function qs(o) {
    var p = [];
    Object.keys(o || {}).forEach(function (k) {
      if (o[k] !== undefined && o[k] !== null && o[k] !== '') {
        p.push(k + '=' + encodeURIComponent(o[k]));
      }
    });
    return p.length ? '?' + p.join('&') : '';
  }

  return {
    schedulerHealth: function () {
      return api.get('/scheduler/jobs', { silent: true });
    },

    /* list -> { items, total, limit, offset } */
    list: function (opts) {
      opts = opts || {};
      return api.get('/runners/' + qs({
        limit:    opts.limit || 100,
        offset:   opts.offset || 0,
        search:   opts.search,
        category: opts.category,
        runtime:  opts.runtime,
        status:   opts.status
      }));
    },
    meta:   function () { return api.get('/runners/meta'); },
    get:    function (id) { return api.get('/runners/' + id); },
    create: function (d) { return api.post('/runners/', d); },
    update: function (id, d) { return api.put('/runners/' + id, d); },
    remove: function (id) { return api.delete('/runners/' + id); },

    /* stored copy of the script file (raw binary; name/mime in the query) */
    uploadFile: function (id, file) {
      return api.putBinary('/runners/' + id + '/file', file,
        { mime: file.type || 'application/octet-stream',
          query: { name: file.name, mime: file.type || 'application/octet-stream' } });
    },
    fileUrl: function (id) { return api.fetchBlobUrl('/runners/' + id + '/file'); }
  };
});
