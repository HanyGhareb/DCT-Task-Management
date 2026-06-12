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

    // ── Wave 3: CSV export of the current filter (≤1000 rows) ────────────
    self.exporting = ko.observable(false);
    self.exportCsv = function () {
      self.exporting(true);
      auditService.exportRows({
        search: self.searchBy().trim() || null,
        action: self.actionFilter() || null
      }).then(function (rows) {
        self.exporting(false);
        var esc = function (v) {
          v = v === undefined || v === null ? '' : String(v);
          return /[",\n]/.test(v) ? '"' + v.replace(/"/g, '""') + '"' : v;
        };
        var lines = ['loggedAt,username,action,objectType,objectId,status,error'];
        rows.forEach(function (r) {
          lines.push([r.loggedAt, r.actionBy, r.actionType, r.objectType,
                      r.objectId, r.status, r.error].map(esc).join(','));
        });
        // ﻿ BOM so Excel opens UTF-8 (Arabic usernames) correctly
        var blob = new Blob(['﻿' + lines.join('\r\n')], { type: 'text/csv;charset=utf-8' });
        var a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = 'audit-log-' + new Date().toISOString().slice(0, 10) + '.csv';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(a.href);
      }).catch(function () { self.exporting(false); });
    };

    self.reload();
  }

  return AuditLogViewModel;
});
