define(['knockout', 'services/auditService'], function (ko, auditService) {
  'use strict';

  function AuditLogViewModel() {
    const self = this;

    self.activeTab = ko.observable('audit');

    // Audit log tab
    self.searchBy   = ko.observable('');
    self.auditEntries = ko.observableArray(auditService.getAuditLog());

    self.filteredAudit = ko.computed(() => {
      const q = self.searchBy().toLowerCase();
      if (!q) return self.auditEntries();
      return self.auditEntries().filter(a =>
        a.actionBy.toLowerCase().includes(q) ||
        a.actionType.toLowerCase().includes(q) ||
        a.objectType.toLowerCase().includes(q)
      );
    });

    self.refreshAudit = function () { self.auditEntries(auditService.getAuditLog()); };

    // Login history tab
    self.loginHistory = ko.observableArray(auditService.getLoginHistory());

    // Sessions tab
    self.sessions = ko.observableArray(auditService.getSessions());
    self.revokeSession = function (s) {
      if (confirm('Revoke session for ' + s.username + '?')) {
        auditService.revokeSession(s.sessionId);
        self.sessions(auditService.getSessions());
      }
    };

    self.formatDate = function (iso) {
      if (!iso) return '—';
      return new Date(iso).toLocaleString('en-GB', { day:'numeric', month:'short', year:'numeric', hour:'2-digit', minute:'2-digit' });
    };

    self.getActionBadgeClass = function (action) {
      return { CREATE: 'badge--active', UPDATE: 'badge--info', DELETE: 'badge--inactive', LOGIN: 'badge--admin' }[action] || 'badge--info';
    };
  }

  return AuditLogViewModel;
});
