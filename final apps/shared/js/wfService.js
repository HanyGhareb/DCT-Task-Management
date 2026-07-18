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
      // send facts as a JSON STRING: the server reads it with APEX_JSON.get_clob,
      // which raises ORA-06502 on a nested object member. A string round-trips
      // cleanly (the engine parses it back with JSON_OBJECT_T).
      return api.post('/processes/' + encodeURIComponent(processCode) + '/simulate',
                      { facts: typeof facts === 'string' ? facts : JSON.stringify(facts) }, WF);
    },

    /* ── designer WRITES (WF_ADMIN + owner_role_id) — requirement 1 ──────── */

    /** Full editable definition of a version: steps (+ their participants) + conditions. */
    design: function (versionId) {
      return api.get('/versions/' + versionId + '/design', WF);
    },

    /** The fact fields of a schema, for the condition builder's guided rows. */
    schemaFields: function (schemaId) {
      return api.get('/schemas/' + schemaId + '/fields', WF)
                .then(function (r) { return (r && r.fields) || []; });
    },

    /**
     * Clone the latest version of a process into an editable DRAFT. IDEMPOTENT:
     * returns the open draft if one already exists (one draft per process), so a
     * live PUBLISHED version is never edited in place — in-flight work is safe.
     */
    cloneDraft: function (processCode) {
      return api.post('/processes/' + encodeURIComponent(processCode) + '/draft', {}, WF);
    },

    saveStep:          function (vid, step) { return api.put('/versions/' + vid + '/step', step, WF); },
    deleteStep:        function (vid, key)  { return api.delete('/versions/' + vid + '/step/' + encodeURIComponent(key), WF); },
    saveCondition:     function (vid, cond) { return api.put('/versions/' + vid + '/condition', cond, WF); },
    deleteCondition:   function (vid, key)  { return api.delete('/versions/' + vid + '/condition/' + encodeURIComponent(key), WF); },
    saveParticipant:   function (vid, rule) { return api.put('/versions/' + vid + '/participant', rule, WF); },
    deleteParticipant: function (vid, rid)  { return api.delete('/versions/' + vid + '/participant/' + rid, WF); },
    validateVersion:   function (vid)       { return api.post('/versions/' + vid + '/validate', {}, WF); },
    publishVersion:    function (vid)       { return api.post('/versions/' + vid + '/publish', {}, WF); },
    discardDraft:      function (vid)       { return api.delete('/versions/' + vid, WF); },

    /** Shadow-mode drift: what the old engine decided vs what the new one would. */
    parity: function () {
      return api.get('/parity', WF).then(function (r) { return (r && r.items) || []; });
    },

    /* ── dynamic role assignments (WF_ADMIN) — role x business object, date-tracked ── */

    /** Registry (object types) + the DATA roles, in one call. */
    assignMeta: function () { return api.get('/assign/object-types', WF); },

    /** Object picker rows for one type: { key, label, parent?, extra? }. */
    assignLov: function (type, search, parent) {
      var q = '?type=' + encodeURIComponent(type);
      if (search) q += '&search=' + encodeURIComponent(search);
      if (parent) q += '&parent=' + encodeURIComponent(parent);
      return api.get('/assign/lov' + q, WF).then(function (r) { return (r && r.items) || []; });
    },

    /** Filtered, paged assignment list. filters: {type,key,role,userid,activeon,status,limit,offset} */
    assignList: function (f) {
      f = f || {};
      var q = Object.keys(f).filter(function (k) { return f[k] !== '' && f[k] != null; })
        .map(function (k) { return k + '=' + encodeURIComponent(f[k]); }).join('&');
      return api.get('/assign/list' + (q ? '?' + q : ''), WF);
    },

    assignCreate:  function (body)     { return api.post('/assign/', body, WF); },
    /** op: 'end' {endDate,note} | 'void' {reason} | 'update' {notes,endDate,clearEnd} */
    assignAct:     function (id, body) { return api.put('/assign/' + id, body, WF); },
    assignReplace: function (id, newUserId, effectiveDate) {
      return api.post('/assign/', { action: 'replace', assignmentId: id,
                                    newUserId: newUserId, effectiveDate: effectiveDate }, WF);
    },

    /** Full date-ordered history of one (object, role). */
    assignTimeline: function (type, key, key2, role) {
      var q = '?type=' + encodeURIComponent(type) + '&key=' + encodeURIComponent(key);
      if (key2) q += '&key2=' + encodeURIComponent(key2);
      if (role) q += '&role=' + encodeURIComponent(role);
      return api.get('/assign/timeline' + q, WF).then(function (r) { return (r && r.items) || []; });
    },

    /** Who holds the role on the object as of a date (today when omitted). */
    assignPreview: function (type, key, key2, role, asof) {
      var q = '?type=' + encodeURIComponent(type) + '&key=' + encodeURIComponent(key)
            + '&role=' + encodeURIComponent(role);
      if (key2) q += '&key2=' + encodeURIComponent(key2);
      if (asof) q += '&asof=' + encodeURIComponent(asof);
      return api.get('/assign/preview' + q, WF);
    },

    /** The audit trail, filtered + paged. */
    assignAudit: function (f) {
      f = f || {};
      var q = Object.keys(f).filter(function (k) { return f[k] !== '' && f[k] != null; })
        .map(function (k) { return k + '=' + encodeURIComponent(f[k]); }).join('&');
      return api.get('/assign/audit' + (q ? '?' + q : ''), WF);
    },

    /** Authed CSV download of the audit trail (object URL). */
    assignAuditCsv: function (f) {
      f = f || {};
      var q = Object.keys(f).filter(function (k) { return f[k] !== '' && f[k] != null; })
        .map(function (k) { return k + '=' + encodeURIComponent(f[k]); }).join('&');
      return api.fetchBlobUrl('/assign/audit/export' + (q ? '?' + q : ''), { base: 'wf' });
    }
  };
});
