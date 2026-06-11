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
    getApprovals:     function () { return Promise.resolve([]); },
    getTemplates:     function () { return Promise.resolve([]); },
    getTemplateById:  function () { return Promise.resolve(null); },
    updateTemplate:   function () { return Promise.resolve(null); },

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
