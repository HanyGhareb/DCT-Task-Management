define(['knockout', 'services/auditService', 'shared/i18n'],
function (ko, auditService, i18n) {
  'use strict';

  function AuditLogViewModel() {
    var self = this;
    self.t = i18n.t;

    // ── tri-state + server-side paging (Phase 3) ─────────────────────────
    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.entries   = ko.observableArray([]);

    self.searchBy     = ko.observable('');
    self.actionFilter = ko.observable('');             // '', LOGIN, CREATE, UPDATE, DELETE…
    self.offset       = ko.observable(0);
    self.limit        = ko.observable(50);
    self.total        = ko.observable(0);

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      auditService.getPage({
        limit:  self.limit(),
        offset: self.offset(),
        search: self.searchBy().trim() || null,
        action: self.actionFilter() || null
      }).then(function (r) {
        self.entries(r.items);
        self.total(r.total || r.items.length);
        self.loading(false);
      }).catch(function () {
        self.loading(false);
        self.loadError(true);
      });
    };

    self.searchBy.extend({ rateLimit: { timeout: 300, method: 'notifyWhenChangesStop' } });
    self.searchBy.subscribe(function () { self.offset(0); self.reload(); });
    self.actionFilter.subscribe(function () { self.offset(0); self.reload(); });

    self.formatDate = function (iso) {
      return iso ? i18n.fmtDate(iso, {
        day: 'numeric', month: 'short', year: 'numeric',
        hour: '2-digit', minute: '2-digit'
      }) : '—';
    };

    self.getActionBadgeClass = function (action) {
      return {
        CREATE: 'badge--active', UPDATE: 'badge--info',
        DELETE: 'badge--inactive', LOGIN: 'badge--admin',
      }[action] || 'badge--info';
    };

    self.reload();
  }

  return AuditLogViewModel;
});
