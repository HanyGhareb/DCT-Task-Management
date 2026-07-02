/**
 * rptService.js — Reporting Platform ORDS endpoint wrappers (/ords/admin/rpt).
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
    /* meta / dropdowns */
    getMeta: function () { return api.get('/meta'); },

    /* report definitions */
    getReports:   function (params) { return api.get('/reports/' + qs(params)); },
    getReport:    function (code)   { return api.get('/reports/' + encodeURIComponent(code)); },
    createReport: function (data)   { return api.post('/reports/', data); },
    updateReport: function (code, data) { return api.put('/reports/' + encodeURIComponent(code), data); },
    deleteReport: function (code)   { return api.delete('/reports/' + encodeURIComponent(code)); },
    /* params: plain object of run parameters — sent as the POST body; the
       server keeps the definition defaults when the body is absent/empty */
    runReport:    function (code, formats, params) {
      return api.post('/reports/' + encodeURIComponent(code) + '/run' + qs({ formats: formats }),
                      params || {});
    },

    /* runs */
    getRuns:   function (params) { return api.get('/runs/' + qs(params)); },
    getRun:    function (id)     { return api.get('/runs/' + id); },
    retryRun:  function (id)     { return api.post('/runs/' + id + '/retry', {}); },
    outputUrl: function (id, fmt) { return api.fetchBlobUrl('/runs/' + id + '/output/' + fmt); },

    /* schedules */
    getSchedules:   function (report) { return api.get('/schedules/' + qs({ report: report })); },
    createSchedule: function (data)   { return api.post('/schedules/', data); },
    updateSchedule: function (id, data) { return api.put('/schedules/' + id, data); },
    deleteSchedule: function (id)     { return api.delete('/schedules/' + id); },
    syncSchedules:  function ()       { return api.post('/schedules/sync', {}); },

    /* recipients */
    getRecipients:   function (report) { return api.get('/recipients/' + qs({ report: report })); },
    createRecipient: function (data)   { return api.post('/recipients/', data); },
    updateRecipient: function (id, data) { return api.put('/recipients/' + id, data); },
    deleteRecipient: function (id)     { return api.delete('/recipients/' + id); },

    /* workers (Python engine processes + DCT_RPT_* scheduler jobs) */
    getWorkers:    function ()            { return api.get('/workers/'); },
    workerCommand: function (id, command) { return api.post('/workers/command', { workerId: id, command: command }); },
    workerRemove:  function (id)          { return api.post('/workers/remove', { workerId: id }); },
    reclaimStuck:  function ()            { return api.post('/workers/reclaim', {}); },
    toggleJob:     function (job, enabled) { return api.post('/workers/job', { jobName: job, enabled: enabled }); },

    /* runtime / SMTP config */
    getConfig: function ()      { return api.get('/config'); },
    putConfig: function (items) { return api.put('/config', { items: items }); },
  };
});
