define(['knockout', 'services/auditService'], function (ko, auditService) {
  'use strict';

  function AuditLogViewModel() {
    var self = this;

    self.activeTab    = ko.observable('audit');
    self.searchBy     = ko.observable('');
    self.loading      = ko.observable(true);
    self.auditEntries = ko.observableArray([]);

    function loadAudit() {
      self.loading(true);
      auditService.getAuditLog().then(function (data) {
        self.auditEntries(data);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }
    loadAudit();

    self.filteredAudit = ko.computed(function () {
      var q = self.searchBy().toLowerCase();
      if (!q) return self.auditEntries();
      return self.auditEntries().filter(function (a) {
        return (a.actionBy   || '').toLowerCase().includes(q) ||
               (a.actionType || '').toLowerCase().includes(q) ||
               (a.objectType || '').toLowerCase().includes(q);
      });
    });

    self.refreshAudit = function () { loadAudit(); };

    /* Login history & sessions are not in ORDS yet */
    self.loginHistory = ko.observableArray([]);
    self.sessions     = ko.observableArray([]);
    self.revokeSession = function () {};

    self.formatDate = function (iso) {
      if (!iso) return '—';
      return new Date(iso).toLocaleString('en-GB', {
        day: 'numeric', month: 'short', year: 'numeric',
        hour: '2-digit', minute: '2-digit',
      });
    };

    self.getActionBadgeClass = function (action) {
      return {
        CREATE: 'badge--active', UPDATE: 'badge--info',
        DELETE: 'badge--inactive', LOGIN: 'badge--admin',
      }[action] || 'badge--info';
    };
  }

  return AuditLogViewModel;
});
