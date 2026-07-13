/**
 * atdService.js — Analytics Loader data service (App 208, ORDS live).
 * Thin wrapper over the shared api.js fetch wrapper; one method per atd.rest
 * endpoint (/ords/admin/atd/...). All methods return Promises.
 */
define(['services/api'],
function (api) {
  'use strict';

  function qs(params) {
    var p = [];
    Object.keys(params || {}).forEach(function (k) {
      var v = params[k];
      if (v !== null && v !== undefined && v !== '') p.push(k + '=' + encodeURIComponent(v));
    });
    return p.length ? '?' + p.join('&') : '';
  }

  return {
    // dashboard + pickers
    getDashboard: function ()          { return api.get('/dashboard'); },
    getLookups:   function ()          { return api.get('/lookups'); },

    // rebuild the GL classification snapshot the actuals reporting views read
    refreshActuals: function ()        { return api.post('/actuals/refresh', {}); },

    // jobs
    listJobs:     function (params)    { return api.get('/jobs' + qs(params)); },
    getJob:       function (name)      { return api.get('/jobs/' + encodeURIComponent(name)); },
    createJob:    function (body)      { return api.post('/jobs', body); },
    updateJob:    function (name, body){ return api.put('/jobs/' + encodeURIComponent(name), body); },
    deleteJob:    function (name)      { return api.delete('/jobs/' + encodeURIComponent(name)); },
    enqueueJob:   function (name)      { return api.post('/jobs/' + encodeURIComponent(name) + '/enqueue', {}); },

    // build a NEW OTBI analysis from a spec (runner --build picks it up)
    listAnalyses:   function ()        { return api.get('/analyses'); },
    createAnalysis: function (body)    { return api.post('/analyses', body); },

    // "Generate Schedule OTBI Data" — bulk F/UH/U10M variants for a folder
    // (runner --schedgen picks it up); includeSubfolders recurses.
    scheduleGen:     function (folderPath, includeSubfolders) {
      return api.post('/schedule-gen/', { folderPath: folderPath, includeSubfolders: !!includeSubfolders }); },
    listScheduleGen: function ()       { return api.get('/schedule-gen/'); },

    // subject-area column catalog — picker for "Add New OTBI Analysis"
    // (runner --discover scrapes the OTBI tree into the cache these read)
    listSubjectAreas:      function ()       { return api.get('/subject-areas'); },
    getSubjectAreaColumns: function (sa)     { return api.get('/subject-areas/columns?sa=' + encodeURIComponent(sa)); },
    discoverSubjectArea:   function (sa)     { return api.post('/subject-areas/discover', { subjectArea: sa }); },
    listDiscoveryRuns:     function (params) { return api.get('/subject-areas/runs' + qs(params)); },
    // AI column suggester: free-text request -> {items:[{path,column}]} from the catalog
    suggestColumns:        function (sa, request) { return api.post('/subject-areas/suggest', { sa: sa, request: request }); },
    resetJob:     function (name)      { return api.post('/jobs/' + encodeURIComponent(name) + '/reset', {}); },
    runJob:       function (name)      { return api.post('/jobs/' + encodeURIComponent(name) + '/run', {}); },
    reprepareJob: function (name, rebuild) { return api.post('/jobs/' + encodeURIComponent(name) + '/reprepare', { rebuild: rebuild ? 'Y' : 'N' }); },
    getSchema:    function (name)      { return api.get('/jobs/' + encodeURIComponent(name) + '/schema'); },
    applySchema:  function (name, body){ return api.post('/jobs/' + encodeURIComponent(name) + '/schema', body); },
    // schema-review gate: release a job held for review (schema_reviewed -> 'Y')
    approveSchema:function (name)      { return api.post('/jobs/' + encodeURIComponent(name) + '/approve-schema', {}); },

    // queue ops
    enqueueAll:   function ()          { return api.post('/enqueue', {}); },
    reap:         function (mins)      { return api.post('/reap', { leaseMinutes: mins }); },

    // environments
    listEnvs:     function ()          { return api.get('/envs'); },
    createEnv:    function (body)      { return api.post('/envs', body); },
    updateEnv:    function (name, body){ return api.put('/envs/' + encodeURIComponent(name), body); },
    deleteEnv:    function (name)      { return api.delete('/envs/' + encodeURIComponent(name)); },

    // targets
    listTargets:  function ()          { return api.get('/targets'); },
    createTarget: function (body)      { return api.post('/targets', body); },
    updateTarget: function (name, body){ return api.put('/targets/' + encodeURIComponent(name), body); },
    deleteTarget: function (name)      { return api.delete('/targets/' + encodeURIComponent(name)); },

    // parallel-worker fleet health (one row per VM, from ATD_WORKER_HEARTBEAT)
    listWorkers:  function ()          { return api.get('/workers'); },
    // observability: break window + per-VM session age + per-job freshness
    getJobHealth: function ()          { return api.get('/jobs/health'); },

    // job sets (grouped scheduling)
    listJobSets:    function ()             { return api.get('/job-sets'); },
    getJobSet:      function (code)         { return api.get('/job-sets/' + encodeURIComponent(code)); },
    createJobSet:   function (body)         { return api.post('/job-sets', body); },
    updateJobSet:   function (code, body)   { return api.put('/job-sets/' + encodeURIComponent(code), body); },
    deleteJobSet:   function (code)         { return api.delete('/job-sets/' + encodeURIComponent(code)); },
    addSetMembers:  function (code, body)   { return api.post('/job-sets/' + encodeURIComponent(code) + '/members', body); },
    updateSetMember:function (code, job, body) { return api.put('/job-sets/' + encodeURIComponent(code) + '/members/' + encodeURIComponent(job), body); },
    removeSetMember:function (code, job)    { return api.delete('/job-sets/' + encodeURIComponent(code) + '/members/' + encodeURIComponent(job)); },
    runJobSet:      function (code)         { return api.post('/job-sets/' + encodeURIComponent(code) + '/run', {}); },
    pauseJobSet:    function (code, paused) { return api.put('/job-sets/' + encodeURIComponent(code) + '/pause', { paused: paused ? 'Y' : 'N' }); },
    listSetCandidates: function ()          { return api.get('/job-set-jobs'); },

    // job categories (lookup + tagging)
    listCategories:  function ()           { return api.get('/categories'); },
    createCategory:  function (body)       { return api.post('/categories', body); },
    updateCategory:  function (code, body) { return api.put('/categories/' + encodeURIComponent(code), body); },
    deleteCategory:  function (code)       { return api.delete('/categories/' + encodeURIComponent(code)); },
    // ask a worker (or 'all') to re-login to Fusion (operator triggers MFA)
    refreshWorker: function (workerId) { return api.post('/workers/' + encodeURIComponent(workerId) + '/refresh', {}); },

    // run logs
    listRuns:     function (params)    { return api.get('/runs' + qs(params)); },
    getRun:       function (id)        { return api.get('/runs/' + id); },
    runsExportUrl:function (params)    { return '/runs/export' + qs(params); },

    // runner config (UI-managed operational settings)
    getConfig:    function ()          { return api.get('/config'); },
    saveConfig:   function (items)     { return api.put('/config', { items: items }); },

    // Fusion write-back actions (AP invoices...) — runner --actions performs these
    getActionStats: function ()        { return api.get('/actions/stats'); },
    listActions:    function (params)  { return api.get('/actions' + qs(params)); },
    getAction:      function (id)       { return api.get('/actions/' + id); },
    retryAction:    function (id)       { return api.post('/actions/' + id + '/retry', {}); },
    cancelAction:   function (id)       { return api.post('/actions/' + id + '/cancel', {}); },
    // Manage Projects Org — bulk-enqueue PPM_TASK_ADDL_INFO actions
    enqueuePpmActions: function (rows)  { return api.post('/actions/enqueue', { rows: rows }); },
    // type-ahead suggestion lists for the Manage Projects Org form
    // (type=project|task|cc; NOTE the param is `search`, not `q` — ORDS reserves q)
    ppmLov: function (type, opts)       { return api.get('/actions/ppmlov' + qs(Object.assign({ type: type }, opts || {}))); },
  };
});
