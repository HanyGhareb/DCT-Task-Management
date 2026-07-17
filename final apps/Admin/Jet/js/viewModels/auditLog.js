define(['knockout', 'services/auditService', 'services/authService', 'shared/i18n'],
function (ko, auditService, authService, i18n) {
  'use strict';

  function AuditLogViewModel() {
    var self = this;
    self.t = i18n.t;

    // ── tri-state + server-side paging (Phase 3) ─────────────────────────
    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.entries   = ko.observableArray([]);
    var currentUser = authService.getCurrentUser();
    self.isSysAdmin = !!(currentUser && (currentUser.roles || []).indexOf('SYS_ADMIN') >= 0);
    self.stats = ko.observable(null);
    self.statsLoading = ko.observable(false);
    self.purgeCategory = ko.observable('');
    self.purgeDays = ko.observable(365);
    self.purging = ko.observable(false);
    self.purgeMsg = ko.observable('');

    self.loadStats = function () {
      if (!self.isSysAdmin) return;
      self.statsLoading(true);
      auditService.getAuditStats().then(function (r) {
        self.stats(r);
      }).catch(function () {
        self.stats(null);
      }).then(function () {
        self.statsLoading(false);
      });
    };

    self.searchBy     = ko.observable('');
    self.actionFilter = ko.observable('');             // '', LOGIN, CREATE, UPDATE, DELETE…
    self.categoryFilter = ko.observable('');
    self.fromDate     = ko.observable('');             // enh-3: YYYY-MM-DD, inclusive
    self.toDate       = ko.observable('');

    // Wave 3: dashboard drill-down lands here with a preset action filter
    var presetAction = sessionStorage.getItem('auditPresetAction');
    if (presetAction !== null) {
      sessionStorage.removeItem('auditPresetAction');
      self.actionFilter(presetAction);   // set before the subscribe below exists
    }
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
        action: self.actionFilter() || null,
        category: self.categoryFilter() || null,
        fromdt: self.fromDate() || null,
        todt:   self.toDate() || null
      }).then(function (r) {
        self.entries(r.items);
        self.total(r.total || r.items.length);
        self.loading(false);
      }).catch(function () {
        self.loading(false);
        self.loadError(true);
      });
      self.loadStats();
    };

    self.searchBy.extend({ rateLimit: { timeout: 300, method: 'notifyWhenChangesStop' } });
    self.searchBy.subscribe(function () { self.offset(0); self.reload(); });
    self.actionFilter.subscribe(function () { self.offset(0); self.reload(); });
    self.categoryFilter.subscribe(function () { self.offset(0); self.reload(); });
    self.fromDate.subscribe(function () { self.offset(0); self.reload(); });
    self.toDate.subscribe(function () { self.offset(0); self.reload(); });

    self.formatDate = function (iso) {
      return iso ? i18n.fmtDate(iso, {
        day: 'numeric', month: 'short', year: 'numeric',
        hour: '2-digit', minute: '2-digit', hour12: true
      }) : '—';
    };

    self.getActionBadgeClass = function (action) {
      return {
        CREATE: 'badge--active', UPDATE: 'badge--info',
        DELETE: 'badge--inactive', LOGIN: 'badge--admin',
      }[action] || 'badge--info';
    };

    // ── Wave 3: expandable before/after diff per entry ───────────────────
    self.expandedId  = ko.observable(null);
    self.diffRows    = ko.observableArray([]);   // [{field, oldVal, newVal, changed}]
    self.diffLoading = ko.observable(false);
    self.diffEmpty   = ko.observable(false);

    self.toggleExpand = function (entry) {
      if (self.expandedId() === entry.auditId) { self.expandedId(null); return; }
      self.expandedId(entry.auditId);
      self.diffRows([]);
      self.diffEmpty(false);
      self.diffLoading(true);
      auditService.getDetail(entry.auditId).then(function (d) {
        self.diffLoading(false);
        var o = d.oldValues || {}, n = d.newValues || {};
        var keys = Object.keys(o);
        Object.keys(n).forEach(function (k) { if (keys.indexOf(k) < 0) keys.push(k); });
        if (!keys.length) { self.diffEmpty(true); return; }
        self.diffRows(keys.sort().map(function (k) {
          var ov = o[k] === undefined || o[k] === null ? '' : String(o[k]);
          var nv = n[k] === undefined || n[k] === null ? '' : String(n[k]);
          return { field: k, oldVal: ov, newVal: nv, changed: ov !== nv };
        }));
      }).catch(function () {
        self.diffLoading(false);
        self.diffEmpty(true);
      });
    };

    // ── enh-3: server-built CSV of the full filtered history ─────────────
    // (replaces the Wave 3 client-side page-walk, which capped at 1000 rows)
    self.exporting = ko.observable(false);
    self.exportCsv = function () {
      self.exporting(true);
      auditService.exportServerCsv({
        search: self.searchBy().trim() || null,
        action: self.actionFilter() || null,
        fromdt: self.fromDate() || null,
        todt:   self.toDate() || null
      }).then(function (blob) {
        self.exporting(false);
        var a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = 'audit-log-' + new Date().toISOString().slice(0, 10) + '.csv';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(a.href);
      }).catch(function () { self.exporting(false); });
    };

    self.canPurge = ko.pureComputed(function () {
      var d = Number(self.purgeDays());
      return self.isSysAdmin && !self.purging() && !!self.purgeCategory() &&
             Number.isInteger(d) && d >= 30 && d <= 3650;
    });

    self.purge = function () {
      if (!self.canPurge()) return;
      var ar = document.documentElement.lang === 'ar';
      var message = ar
        ? 'حذف سجلات التدقيق في الفئة ' + self.purgeCategory() + ' الأقدم من ' + self.purgeDays() + ' يومًا؟ لا يمكن التراجع عن هذا الإجراء.'
        : 'Permanently delete ' + self.purgeCategory() + ' audit records older than ' + self.purgeDays() + ' days? This cannot be undone.';
      if (!window.confirm(message)) return;
      self.purging(true);
      self.purgeMsg('');
      auditService.purgeAudit(self.purgeCategory(), self.purgeDays()).then(function (r) {
        self.purgeMsg(ar ? 'تم حذف ' + r.deleted + ' سجل.' : r.deleted + ' audit record(s) deleted.');
        self.offset(0);
        self.reload();
      }).catch(function (e) {
        self.purgeMsg((ar ? 'فشل الحذف: ' : 'Purge failed: ') + ((e && e.message) || 'Unknown error'));
      }).then(function () {
        self.purging(false);
      });
    };

    self.reload();
  }

  return AuditLogViewModel;
});
