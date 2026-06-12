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
     * Phase 3 server-side pagination.
     * opts: { limit, offset, search, action }
     * Resolves { items, total, limit, offset } (items normalised).
     */
    getPage: function (opts) {
      opts = opts || {};
      var q = '?limit=' + (opts.limit || 50) + '&offset=' + (opts.offset || 0);
      if (opts.search) q += '&search=' + encodeURIComponent(opts.search);
      if (opts.action) q += '&action=' + encodeURIComponent(opts.action);
      return api.get('/audit/' + q).then(function (r) {
        r.items = (r.items || []).map(normAudit);
        return r;
      });
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
