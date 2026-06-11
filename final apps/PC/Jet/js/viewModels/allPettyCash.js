define(['knockout', 'services/authService', 'services/pcService', 'shared/i18n', 'shared/toast'],
function (ko, authService, pcService, i18n, toast) {
  'use strict';

  function AllPettyCashViewModel() {
    var self = this;
    self.t = i18n.t;

    var user = authService.getCurrentUser();

    // ── tri-state + server paging (Phase 3) ──────────────────────────────
    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.records   = ko.observableArray([]);

    self.search       = ko.observable('');
    self.filterStatus = ko.observable('');
    self.filterType   = ko.observable('');          // applied client-side on the page
    self.offset       = ko.observable(0);
    self.limit        = ko.observable(50);
    self.total        = ko.observable(0);

    self.STATUS_OPTIONS = [
      { value: '',                 label: 'All Statuses' },
      { value: 'ACTIVE',           label: 'Active' },
      { value: 'PENDING_APPROVAL', label: 'Pending Approval' },
      { value: 'SUBMITTED',        label: 'Submitted' },
      { value: 'CLOSED',           label: 'Closed' },
      { value: 'REJECTED',         label: 'Rejected' },
    ];
    self.TYPE_OPTIONS = [
      { value: '',          label: 'All Types' },
      { value: 'TEMPORARY', label: 'Temporary' },
      { value: 'PERMANENT', label: 'Permanent' },
    ];

    self.filtered = ko.pureComputed(function () {
      var t = self.filterType();
      return t ? self.records().filter(function (r) { return r.pcType === t; }) : self.records();
    });

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      pcService.getAllPage({
        limit:  self.limit(),
        offset: self.offset(),
        search: self.search().trim() || null,
        status: self.filterStatus() || null
      }).then(function (r) {
        self.records(r.items);
        self.total(r.total || r.items.length);
        self.loading(false);
      }).catch(function () {
        self.loading(false);
        self.loadError(true);
      });
    };

    self.search.extend({ rateLimit: { timeout: 300, method: 'notifyWhenChangesStop' } });
    self.search.subscribe(function () { self.offset(0); self.reload(); });
    self.filterStatus.subscribe(function () { self.offset(0); self.reload(); });

    self.fmtAmount = function (n) { return i18n.fmtNum(n || 0, 2); };
    self.fmtDate   = function (d) { return d ? i18n.fmtDate(d) : '—'; };

    self.statusClass = function (s) {
      var map = { ACTIVE:'badge--active', PENDING_APPROVAL:'badge--pending', SUBMITTED:'badge--pending',
                  APPROVED:'badge--info', CLOSED:'badge--inactive', REJECTED:'badge--rejected', DRAFT:'badge--idle' };
      return 'badge ' + (map[s] || 'badge--info');
    };

    self.viewDetail = function (rec) {
      if (window._pcApp) window._pcApp.navigate('pcDetail', { pcId: rec.pcId, pcNumber: rec.pcNumber });
    };

    self.disburse = function (rec) {
      if (!confirm('Disburse ' + self.fmtAmount(rec.amount) + ' AED to ' + rec.employeeName + '?')) return;
      pcService.disburse(rec.pcId, user.userId).then(function () {
        toast.success('Disbursed ' + rec.pcNumber + ' successfully.');
        self.reload();
      });
    };

    self.reload();
  }

  return AllPettyCashViewModel;
});
