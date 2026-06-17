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

    // jobs
    listJobs:     function (params)    { return api.get('/jobs' + qs(params)); },
    getJob:       function (name)      { return api.get('/jobs/' + encodeURIComponent(name)); },
    createJob:    function (body)      { return api.post('/jobs', body); },
    updateJob:    function (name, body){ return api.put('/jobs/' + encodeURIComponent(name), body); },
    deleteJob:    function (name)      { return api.delete('/jobs/' + encodeURIComponent(name)); },
    enqueueJob:   function (name)      { return api.post('/jobs/' + encodeURIComponent(name) + '/enqueue', {}); },
    resetJob:     function (name)      { return api.post('/jobs/' + encodeURIComponent(name) + '/reset', {}); },

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

    // run logs
    listRuns:     function (params)    { return api.get('/runs' + qs(params)); },
    getRun:       function (id)        { return api.get('/runs/' + id); },
    runsExportUrl:function (params)    { return '/runs/export' + qs(params); },
  };
});
