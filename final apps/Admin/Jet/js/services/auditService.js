/**
 * auditService.js — audit log, login history, active sessions, approval instances
 * Production: GET /ords/prod/dct/audit_log/
 */
define(['mockData'], function (mockData) {
  'use strict';

  let auditLog     = JSON.parse(JSON.stringify(mockData.AUDIT_LOG));
  let loginHistory = JSON.parse(JSON.stringify(mockData.LOGIN_HISTORY));
  let sessions     = JSON.parse(JSON.stringify(mockData.ACTIVE_SESSIONS));
  let approvals    = JSON.parse(JSON.stringify(mockData.APPROVAL_INSTANCES));
  let templates    = JSON.parse(JSON.stringify(mockData.APPROVAL_TEMPLATES));

  return {
    // Audit log
    getAuditLog: function (filter) {
      let data = auditLog.slice();
      if (filter && filter.actionType) data = data.filter(a => a.actionType === filter.actionType);
      if (filter && filter.objectType) data = data.filter(a => a.objectType === filter.objectType);
      if (filter && filter.actionBy)   data = data.filter(a => a.actionBy.toLowerCase().includes(filter.actionBy.toLowerCase()));
      return data.sort((a, b) => b.auditId - a.auditId);
    },

    // Login history
    getLoginHistory: function () { return loginHistory.slice().sort((a, b) => b.histId - a.histId); },

    // Active sessions
    getSessions: function () { return sessions; },
    revokeSession: function (sessionId) {
      const s = sessions.find(s => s.sessionId === sessionId);
      if (s) s.status = 'REVOKED';
    },

    // Approval monitor
    getApprovals: function (status) {
      let data = approvals.slice();
      if (status && status !== 'ALL') data = data.filter(a => a.overallStatus === status);
      return data.sort((a, b) => b.instanceId - a.instanceId);
    },

    // Approval templates
    getTemplates: function () { return templates; },
    getTemplateById: function (id) { return templates.find(t => t.templateId === Number(id)) || null; },
    updateTemplate: function (id, data) {
      const idx = templates.findIndex(t => t.templateId === Number(id));
      if (idx !== -1) templates[idx] = Object.assign({}, templates[idx], data);
      return templates[idx];
    },

    // Platform stats
    getPlatformStats: function () {
      const mockData2 = mockData;
      return {
        totalUsers:    mockData2.USERS.length,
        activeUsers:   mockData2.USERS.filter(u => u.isActive === 'Y').length,
        totalRoles:    mockData2.ROLES.length,
        activeModules: mockData2.MODULES.filter(m => m.isActive === 'Y').length,
        pendingApprovals: approvals.filter(a => a.overallStatus === 'PENDING').length,
        activeSessions: sessions.filter(s => s.status === 'ACTIVE').length,
      };
    },
  };
});
