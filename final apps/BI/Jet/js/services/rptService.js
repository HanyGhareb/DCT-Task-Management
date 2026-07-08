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
    /* run-parameter spec: [{ name, label, labelAr, hint, hintAr, required, lov: [...] }] */
    getReportParams: function (code) { return api.get('/reports/' + encodeURIComponent(code) + '/params'); },
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

    /* PDF templates (.docx Word / .j2 HTML) stored in DCT_RPT_TEMPLATE */
    getTemplates:   function ()     { return api.get('/templates/'); },
    templateUrl:    function (name) { return api.fetchBlobUrl('/templates/' + encodeURIComponent(name)); },
    /* raw-binary upload — file bytes are the body, descr rides in the query */
    uploadTemplate: function (name, file, descr) {
      return api.putBinary('/templates/' + encodeURIComponent(name), file,
                           { query: { descr: descr || '' } });
    },
    deleteTemplate: function (name) { return api.delete('/templates/' + encodeURIComponent(name)); },

    /* runtime / SMTP config */
    getConfig: function ()      { return api.get('/config'); },
    putConfig: function (items) { return api.put('/config', { items: items }); },
    /* send a test email via APEX_MAIL to confirm outbound email works */
    sendTestEmail: function (to) { return api.post('/config/test-email', { to: to }); },

    /* interactive report (viewer: BI_USER or SYS_ADMIN) */
    getIrCatalog:   function ()           { return api.get('/ir/catalog'); },
    /* body: { section?, params? } — one-shot capped fetch the grid works on */
    getIrData:      function (code, body) { return api.post('/ir/reports/' + encodeURIComponent(code) + '/data', body || {}); },
    /* dropdown values for one run parameter (PARAM_SPEC_JSON lov_sql) */
    getIrLov:       function (code, param) {
      return api.get('/ir/reports/' + encodeURIComponent(code) + '/lov?param=' + encodeURIComponent(param));
    },
    /* run-parameter spec editor (SYS_ADMIN): raw PARAM_SPEC_JSON + defaults */
    getParamSpec:   function (code)       { return api.get('/ir/reports/' + encodeURIComponent(code) + '/paramspec'); },
    putParamSpec:   function (code, spec) { return api.put('/ir/reports/' + encodeURIComponent(code) + '/paramspec', { paramSpec: spec }); },
    /* test a draft lov_sql before saving (SYS_ADMIN, cap 50) */
    previewLov:     function (sql)        { return api.post('/ir/lov/preview', { sql: sql }); },
    getIrLayouts:   function (code)       { return api.get('/ir/reports/' + encodeURIComponent(code) + '/layouts'); },
    createIrLayout: function (data)       { return api.post('/ir/layouts', data); },
    updateIrLayout: function (id, data)   { return api.put('/ir/layouts/' + id, data); },
    deleteIrLayout: function (id)         { return api.delete('/ir/layouts/' + id); },
  };
});
