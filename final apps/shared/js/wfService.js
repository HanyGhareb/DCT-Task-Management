/**
 * shared/js/wfService.js — the ONE client for the workflow platform (/ords/admin/wf).
 *
 * Every app talks to the same API for approvals, so approval behaviour is defined
 * once, server-side, and no app re-implements it. This module replaces the
 * per-app approvals services that each had their own copy of the rules.
 *
 * All calls go to the /wf/ module via api's { base: 'wf' } — the workflow API is
 * cross-module by design (it is the one worklist), so it is not any single app's
 * apiBase. It is EXEMPT from the module-access gate for that reason; authorization
 * is per TASK, in the engine.
 *
 * THE IMPORTANT ONE — act(task, outcomeCode, comments):
 *   outcomeCode is whatever the STEP offers. It is NOT a fixed verb list. A step on
 *   ENDORSE_SET yields ENDORSE / RETURN_FOR_INFO / REJECT; a legacy step yields
 *   APPROVED / REJECTED / RETURNED. Never hard-code a button — render task.outcomes.
 */
define(['shared/api'], function (api) {
  'use strict';

  var WF = { base: 'wf' };

  function opts(extra) {
    if (!extra) return WF;
    var o = { base: 'wf' };
    Object.keys(extra).forEach(function (k) { o[k] = extra[k]; });
    return o;
  }

  return {
    /* ── worklist ───────────────────────────────────────────────────────── */

    /** Every task this user may act on, across every module and BOTH engines. */
    worklist: function () {
      return api.get('/worklist', WF).then(function (r) { return (r && r.items) || []; });
    },

    /**
     * Record an outcome. `id` is the router key from the worklist item:
     * a legacy instance id (< 900,000,000) or a workflow task id (>= that).
     * The server routes on it; the caller never needs to know which engine.
     */
    act: function (id, outcomeCode, comments) {
      return api.post('/tasks/' + id + '/action',
                      { outcome: outcomeCode, comments: comments || null }, WF);
    },

    claim:   function (id) { return api.post('/tasks/' + id + '/claim',   {}, WF); },
    release: function (id) { return api.post('/tasks/' + id + '/release', {}, WF); },

    delegate: function (id, toUserId, comments) {
      return api.post('/tasks/' + id + '/delegate',
                      { toUserId: toUserId, comments: comments || null }, WF);
    },

    requestInfo: function (id, ofUserId, question) {
      return api.post('/tasks/' + id + '/request-info',
                      { ofUserId: ofUserId, question: question }, WF);
    },

    answerInfo: function (reqId, answer) {
      return api.post('/info-requests/' + reqId + '/answer', { answer: answer }, WF);
    },

    /* ── history + chain (requirement 4: worklist, notifications AND history) ── */

    /** The full audit timeline of a request — including WHY a step was skipped. */
    history: function (instanceId) {
      return api.get('/instances/' + instanceId + '/history', WF)
                .then(function (r) { return (r && r.events) || []; });
    },

    /**
     * The endorsement chain of a SOURCE record, from either engine.
     * Keyed by the business record (module + id), not by an engine-specific
     * instance id — so it keeps working across a migration with no client change.
     */
    chain: function (sourceModule, recordId) {
      return api.get('/chain?module=' + encodeURIComponent(sourceModule)
                     + '&record=' + encodeURIComponent(recordId), WF)
                .then(function (r) { return (r && r.steps) || []; });
    },

    /* ── designer (WF_ADMIN) ────────────────────────────────────────────── */

    processes: function () {
      return api.get('/processes', WF).then(function (r) { return (r && r.items) || []; });
    },

    versionSteps: function (versionId) {
      return api.get('/versions/' + versionId + '/steps', WF)
                .then(function (r) { return (r && r.steps) || []; });
    },

    outcomeSets: function () {
      return api.get('/outcome-sets', WF).then(function (r) { return (r && r.sets) || []; });
    },

    /**
     * Validate a condition WITHOUT saving it. The designer calls this on every
     * keystroke (debounced) so an invalid condition can never be saved at all.
     * Resolves to { valid: bool, error: string|null } — it does not reject on an
     * invalid expression, because "invalid" is the expected answer half the time.
     */
    compileCondition: function (expr, schemaId) {
      return api.post('/conditions/compile',
                      { expr: expr, schemaId: schemaId || null },
                      opts({ silent: true }));
    },

    /**
     * Dry-run a process against a set of facts. Creates NOTHING.
     * Returns { processCode, versionId, steps: [{stepKey, name, fires, condition,
     * skipReason, approvers[], dueAt}] } — i.e. which steps fire, which skip AND WHY,
     * and who would actually be asked, by name.
     */
    simulate: function (processCode, facts) {
      return api.post('/processes/' + encodeURIComponent(processCode) + '/simulate',
                      { facts: facts }, WF);
    },

    /** Shadow-mode drift: what the old engine decided vs what the new one would. */
    parity: function () {
      return api.get('/parity', WF).then(function (r) { return (r && r.items) || []; });
    }
  };
});
