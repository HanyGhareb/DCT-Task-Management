/**
 * auditService.js — audit log (live ORDS) + platform stats
 * ORDS: GET /audit/   — recent audit entries
 *
 * Approval instances, templates, sessions, and login history are not yet
 * exposed via ORDS — those methods return empty arrays.
 *
 * All methods return Promises.
 */
define(['services/api'], function (api) {
  'use strict';

  /* Map ORDS field names → shape used by VMs */
  function normAudit(r) {
    return {
      auditId:    r.logId,
      actionBy:   r.username,
      actionType: r.action,
      objectType: r.objectType,
      objectId:   r.objectId,
      status:     r.status,
      error:      r.error,
      loggedAt:   r.loggedAt,
    };
  }

  return {

    /* ── Audit log — live ─────────────────────────────────────────────── */

    getAuditLog: function (filter) {
      return api.get('/audit/').then(function (r) {
        var data = (r.items || []).map(normAudit);
        if (filter && filter.actionType) {
          data = data.filter(function (a) { return a.actionType === filter.actionType; });
        }
        if (filter && filter.objectType) {
          data = data.filter(function (a) { return a.objectType === filter.objectType; });
        }
        if (filter && filter.actionBy) {
          var q = filter.actionBy.toLowerCase();
          data = data.filter(function (a) { return (a.actionBy || '').toLowerCase().includes(q); });
        }
        return data;
      });
    },

    /**
     * Phase 3 server-side pagination (+ enh-2 round: fromdt/todt, YYYY-MM-DD).
     * opts: { limit, offset, search, action, fromdt, todt }
     * Resolves { items, total, limit, offset } (items normalised).
     */
    getPage: function (opts) {
      opts = opts || {};
      var q = '?limit=' + (opts.limit || 50) + '&offset=' + (opts.offset || 0);
      if (opts.search) q += '&search=' + encodeURIComponent(opts.search);
      if (opts.action) q += '&action=' + encodeURIComponent(opts.action);
      if (opts.fromdt) q += '&fromdt=' + encodeURIComponent(opts.fromdt);
      if (opts.todt)   q += '&todt='   + encodeURIComponent(opts.todt);
      return api.get('/audit/' + q).then(function (r) {
        r.items = (r.items || []).map(normAudit);
        return r;
      });
    },

    /**
     * Server-built CSV of the full filtered history (GET /audit/export).
     * Resolves a Blob — the api wrapper JSON-parses everything, so this one
     * goes through fetch directly with the same bearer token.
     */
    exportServerCsv: function (opts) {
      opts = opts || {};
      var q = [];
      if (opts.search) q.push('search=' + encodeURIComponent(opts.search));
      if (opts.action) q.push('action=' + encodeURIComponent(opts.action));
      if (opts.fromdt) q.push('fromdt=' + encodeURIComponent(opts.fromdt));
      if (opts.todt)   q.push('todt='   + encodeURIComponent(opts.todt));
      return Promise.all([
        new Promise(function (res) { require(['services/config', 'services/authService'], function (c, a) { res([c, a]); }); })
      ]).then(function (mods) {
        var config = mods[0][0], authService = mods[0][1];
        return fetch(config.apiBase + '/audit/export' + (q.length ? '?' + q.join('&') : ''), {
          headers: { Authorization: 'Bearer ' + authService.getToken() }
        }).then(function (r) {
          if (!r.ok) return Promise.reject({ status: r.status, message: 'Export failed (' + r.status + ')' });
          return r.blob();
        });
      });
    },

    /* Wave 3: before/after JSON snapshots of one entry (GET /audit/:id) */
    getDetail: function (logId) {
      return api.get('/audit/' + logId, { silent: true }).then(function (r) {
        var parse = function (s) {
          try { return s ? JSON.parse(s) : null; } catch (e) { return null; }
        };
        return { oldValues: parse(r.oldValues), newValues: parse(r.newValues),
                 oldRaw: r.oldValues || '', newRaw: r.newValues || '' };
      });
    },

    /**
     * Wave 3: export the current filter as CSV rows (server cap is 200/page —
     * walk pages up to maxRows). Resolves an array of normalised entries.
     */
    exportRows: function (opts, maxRows) {
      var self = this;
      maxRows = maxRows || 1000;
      var all = [];
      function page(offset) {
        return self.getPage({ limit: 200, offset: offset,
                              search: opts.search, action: opts.action })
          .then(function (r) {
            all = all.concat(r.items);
            if (all.length < Math.min(r.total, maxRows) && r.items.length > 0) {
              return page(offset + 200);
            }
            return all.slice(0, maxRows);
          });
      }
      return page(0);
    },

    /* Phase 3: Admin dashboard stats + chart series (GET /stats/) */
    getStats: function () {
      return api.get('/stats/');
    },

    /* ── Not in ORDS yet — return empty ──────────────────────────────── */

    getLoginHistory:  function () { return Promise.resolve([]); },
    getSessions:      function () { return Promise.resolve([]); },
    revokeSession:    function () { return Promise.resolve(false); },

    /* ── Approvals (cross-module, wired post-UAT 2026-06-11) ─────────── */

    /* Monitor: every instance (optionally by status) */
    getApprovals: function (status) {
      var q = status && status !== 'ALL' ? '?status=' + encodeURIComponent(status) : '';
      return api.get('/approvals/' + q).then(function (r) { return r.items || []; });
    },

    /* My queue: instances whose current step matches one of my roles */
    getPendingApprovals: function () {
      return api.get('/approvals/pending').then(function (r) { return r.items || []; });
    },

    /* action: 'APPROVED' | 'REJECTED' | 'RETURNED' — comments mandatory */
    actionApproval: function (instanceId, action, comments) {
      return api.post('/approvals/' + instanceId + '/action',
                      { action: action, comments: comments });
    },

    getTemplates: function () {
      return api.get('/approval-templates/').then(function (r) { return r.items || []; });
    },

    getTemplateById: function (id) {
      return api.get('/approval-templates/' + id);
    },

    updateTemplate: function (id, data) {
      return api.put('/approval-templates/' + id, data);
    },

    /* Wave 4 (1.4): safe template editing — clone-as-draft → edit → activate.
       The live template is never edited; activation archives the old version. */
    cloneTemplate: function (id) {
      return api.post('/approval-templates/' + id + '/clone', {}, { silent: true });
    },
    activateTemplate: function (id) {
      return api.post('/approval-templates/' + id + '/activate', {}, { silent: true });
    },
    /* enh-2 round: archived version → new draft of the live template */
    restoreTemplate: function (id) {
      return api.post('/approval-templates/' + id + '/restore', {}, { silent: true });
    },
    /* steps: [{ stepId, seq, label, slaHours }] — drafts only (server-enforced) */
    updateTemplateSteps: function (id, steps) {
      return api.put('/approval-templates/' + id + '/steps', { steps: steps }, { silent: true });
    },

    /* ── Platform stats — aggregate live API data ─────────────────────── */

    getPlatformStats: function () {
      return Promise.all([
        api.get('/users/').then(function (r) { return r.items || []; }).catch(function () { return []; }),
        api.get('/roles/').then(function (r) { return r.items || []; }).catch(function () { return []; }),
        api.get('/modules/').then(function (r) { return r.items || []; }).catch(function () { return []; }),
      ]).then(function (results) {
        var users = results[0], roles = results[1], modules = results[2];
        return {
          totalUsers:       users.length,
          activeUsers:      users.filter(function (u) { return u.isActive === 'Y'; }).length,
          totalRoles:       roles.length,
          activeModules:    modules.filter(function (m) { return m.isActive === 'Y'; }).length,
          pendingApprovals: 0,
          activeSessions:   0,
        };
      });
    },
  };
});
