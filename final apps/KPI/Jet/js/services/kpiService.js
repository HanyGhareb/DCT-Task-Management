/**
 * kpiService.js — the ONE client for the /kpi/ ORDS module (App 213).
 * All methods return Promises (shared api.js injects the Bearer token and
 * bounces to login on 401).
 */
define(['services/api'],
function (api) {
  'use strict';

  return {
    // boot / reference
    boot:    function () { return api.get('/boot'); },
    users:   function (search) {
      return api.get('/users' + (search ? '?search=' + encodeURIComponent(search) : ''))
                .then(function (d) { return d.items || []; });
    },

    // registry
    getKpis: function (all) {
      return api.get('/kpis' + (all ? '?all=Y' : '')).then(function (d) { return d.items || []; });
    },
    getKpi:      function (id)   { return api.get('/kpis/' + id); },
    saveKpi:     function (body) { return api.post('/kpis', body); },
    deleteKpi:   function (id)   { return api.delete('/kpis/' + id); },
    saveBands:   function (id, bands)    { return api.post('/kpis/' + id + '/bands',    { bands: bands }); },
    saveCriteria:function (id, criteria) { return api.post('/kpis/' + id + '/criteria', { criteria: criteria }); },
    saveTargets: function (id, targets, removeYears) {
      return api.post('/kpis/' + id + '/targets', { targets: targets, removeYears: removeYears || [] });
    },

    // periods
    getPeriods:      function (year) { return api.get('/periods?year=' + year).then(function (d) { return d.items || []; }); },
    generatePeriods: function (year) { return api.post('/periods/generate', { year: year }); },

    // results
    getResults: function (params) {
      var q = Object.keys(params || {}).filter(function (k) { return params[k] !== null && params[k] !== undefined && params[k] !== ''; })
        .map(function (k) { return k + '=' + encodeURIComponent(params[k]); }).join('&');
      return api.get('/results' + (q ? '?' + q : ''));
    },
    initResult:    function (kpiId, periodId) { return api.post('/results/init', { kpiId: kpiId, periodId: periodId }); },
    getResult:     function (id)   { return api.get('/results/' + id); },
    saveResult:    function (id, body) { return api.put('/results/' + id, body); },
    saveCriterion: function (resultId, criterionId, body) {
      return api.put('/results/' + resultId + '/criteria/' + criterionId, body);
    },
    refreshSuggestions: function (id) { return api.post('/results/' + id + '/suggest', {}); },
    submitResult:  function (id)   { return api.post('/results/' + id + '/submit', {}); },

    // evidence
    getDocs:   function (resultId) { return api.get('/results/' + resultId + '/docs').then(function (d) { return d.items || []; }); },
    uploadDoc: function (resultId, file) {
      return api.putBinary('/results/' + resultId + '/docs', file,
                           { query: { file_name: file.name, mime_type: file.type || 'application/octet-stream' } });
    },
    deleteDoc: function (docId) { return api.delete('/docs/' + docId); },
    docUrl:    function (docId) { return api.fetchBlobUrl('/docs/' + docId + '/file'); },

    // dashboard + reports
    scorecard:    function (year) { return api.get('/scorecard' + (year ? '?year=' + year : '')); },
    runBook:      function (year) { return api.post('/reports/book', { year: year }); },
    bookStatus:   function (runId) { return api.get('/reports/' + runId + '/status'); },
    bookPdfUrl:   function (runId) { return api.fetchBlobUrl('/reports/' + runId + '/pdf'); }
  };
});
