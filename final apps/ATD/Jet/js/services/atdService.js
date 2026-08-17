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

  function jobName(name) {
    var value = String(name == null ? '' : name).trim();
    if (!value || value.toLowerCase() === 'undefined' || value.toLowerCase() === 'null') {
      throw new Error('A valid canonical job name is required');
    }
    return encodeURIComponent(value);
  }

  function jobCall(name, suffix, method, body) {
    var path;
    try {
      path = '/jobs/' + jobName(name) + (suffix || '');
    } catch (e) {
      return Promise.reject(e);
    }
    if (method === 'GET') return api.get(path);
    if (method === 'PUT') return api.put(path, body || {});
    if (method === 'DELETE') return api.delete(path);
    return api.post(path, body || {});
  }

  return {
    // dashboard + pickers
    getDashboard: function ()          { return api.get('/dashboard'); },
    getAttention: function ()          { return api.get('/attention'); },
    getLookups:   function ()          { return api.get('/lookups'); },

    // rebuild the GL classification snapshot the actuals reporting views read
    refreshActuals: function ()        { return api.post('/actuals/refresh', {}); },

    // jobs
    listJobs:     function (params)    { return api.get('/jobs' + qs(params)); },
    getJob:       function (name)      { return jobCall(name, '', 'GET'); },
    createJob:    function (body)      { return api.post('/jobs', body); },
    updateJob:    function (name, body){ return jobCall(name, '', 'PUT', body); },
    deleteJob:    function (name)      { return jobCall(name, '', 'DELETE'); },
    enqueueJob:   function (name)      { return jobCall(name, '/enqueue', 'POST'); },

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
    resetJob:     function (name)      { return jobCall(name, '/reset', 'POST'); },
    runJob:       function (name)      { return jobCall(name, '/run', 'POST'); },
    reprepareJob: function (name, rebuild) { return jobCall(name, '/reprepare', 'POST', { rebuild: rebuild ? 'Y' : 'N' }); },
    getSchema:    function (name)      { return jobCall(name, '/schema', 'GET'); },
    applySchema:  function (name, body){ return jobCall(name, '/schema', 'POST', body); },
    // schema-review gate: release a job held for review (schema_reviewed -> 'Y')
    approveSchema:function (name)      { return jobCall(name, '/approve-schema', 'POST'); },

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
    pollWorkers:  function ()          { return api.get('/workers?_mfa=' + Date.now()); },
    // observability: break window + per-VM session age + per-job freshness
    getJobHealth: function ()          { return api.get('/jobs/health'); },

    // job sets (grouped scheduling)
    // Job-set CRUD changes must be visible immediately; avoid a stale browser/proxy GET.
    listJobSets:    function ()             { return api.get('/job-sets?_sets=' + Date.now()); },
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
    checkWorkerSession: function (workerId) { return api.post('/workers/' + encodeURIComponent(workerId) + '/check-session', {}); },

    // run logs
    listRuns:     function (params)    { return api.get('/runs' + qs(params)); },
    warningSummary:function (params)   { return api.get('/warnings/summary' + qs(params)); },
    getRun:       function (id)        { return api.get('/runs/' + id); },
    cancelRun:    function (id)        { return api.post('/runs/' + id + '/cancel', {}); },
    runsExportUrl:function (params)    { return '/runs/export' + qs(params); },

    // runner config (UI-managed operational settings)
    getConfig:    function ()          { return api.get('/config'); },
    saveConfig:   function (items)     { return api.put('/config', { items: items }); },

    // per-user OTBI credential profile (db/62+63) — jobs/actions the caller
    // enqueues sign in to Fusion as this account; password is write-only
    getMyCred:    function ()          { return api.get('/my-credential'); },
    saveMyCred:   function (body)      { return api.put('/my-credential', body); },
    deleteMyCred: function ()          { return api.delete('/my-credential'); },
    listCreds:    function ()          { return api.get('/credentials'); },

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

    // ---- Project Budget Transactions (PBT) extract -------------------------
    // Reads the ADG_FIN VBCS app through the worker's Fusion session and loads
    // prod.pa_budget_trx_* (db/77). Enqueue returns an actionId the page polls.
    pbtSummary:  function ()           { return api.get('/pbt/summary'); },
    pbtRun:      function (body)       { return api.post('/pbt/runs', body); },
    pbtRuns:     function (params)     { return api.get('/pbt/runs' + qs(params)); },
    pbtRunById:  function (id)         { return api.get('/pbt/runs/' + id); },
    pbtData:     function (params)     { return api.get('/pbt/data' + qs(params)); },
    pbtDetail:   function (num, type)  { return api.get('/pbt/data/' + encodeURIComponent(num) + qs({ type: type })); },
  };
});
