define(['knockout', 'services/authService', 'services/pcService', 'services/reimbService', 'services/clearService', 'services/approvalService'],
function (ko, authService, pcService, reimbService, clearService, approvalService) {
  'use strict';

  function PcDetailViewModel() {
    var self = this;

    var user  = authService.getCurrentUser();
    var state = window._pcApp ? window._pcApp.getState() : {};
    var pcId  = state.pcId;

    self.record       = ko.observable(null);
    self.budgetLines  = ko.observableArray([]);
    self.reimbursements = ko.observableArray([]);
    self.clearings    = ko.observableArray([]);
    self.approvalHistory = ko.observableArray([]);
    self.loading      = ko.observable(true);
    self.error        = ko.observable('');
    self.success      = ko.observable('');
    self.isPcAdmin    = authService.isPcAdmin();

    self.fmtAmount = function (n) { return n != null ? Number(n).toLocaleString('en-US', { minimumFractionDigits: 2 }) : '0.00'; };
    self.fmtDate   = function (d) { return d ? new Date(d).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }) : '—'; };

    self.statusClass = function (s) {
      var map = { ACTIVE:'badge--active', PENDING_APPROVAL:'badge--pending', SUBMITTED:'badge--pending',
                  APPROVED:'badge--info', CLOSED:'badge--inactive', REJECTED:'badge--rejected', DRAFT:'badge--idle' };
      return 'badge ' + (map[s] || 'badge--info');
    };

    self.actionClass = function (a) {
      var map = { APPROVED:'badge--active', REJECTED:'badge--rejected', RETURNED:'badge--warning' };
      return 'badge ' + (map[a] || 'badge--info');
    };

    self.canRaiseReimb = ko.computed(function () {
      var r = self.record();
      if (!r) return false;
      if (r.status !== 'ACTIVE') return false;
      // No active clearing
      var hasClear = self.clearings().some(function(c){ return ['SUBMITTED','PENDING_APPROVAL','APPROVED'].includes(c.status); });
      return !hasClear;
    });

    self.canRaiseClear = ko.computed(function () {
      var r = self.record();
      if (!r) return false;
      if (r.status !== 'ACTIVE') return false;
      // No pending reimbursements
      var hasPendReimb = self.reimbursements().some(function(rb){ return rb.status === 'PENDING_APPROVAL'; });
      // No active clearing
      var hasClear = self.clearings().some(function(c){ return ['SUBMITTED','PENDING_APPROVAL','APPROVED'].includes(c.status); });
      return !hasPendReimb && !hasClear;
    });

    self.canDisburse = ko.computed(function () {
      var r = self.record();
      return self.isPcAdmin && r && r.status === 'APPROVED';
    });

    self.newReimb = function () {
      if (window._pcApp) window._pcApp.navigate('reimbDetail', { pcId: pcId });
    };

    self.newClear = function () {
      if (window._pcApp) window._pcApp.navigate('clearDetail', { pcId: pcId });
    };

    self.editRequest = function () {
      if (window._pcApp) window._pcApp.navigate('pcRequest', { pcId: pcId });
    };

    self.disburse = function () {
      if (!confirm('Confirm disbursement of ' + self.fmtAmount(self.record() && self.record().amount) + ' AED?')) return;
      pcService.disburse(pcId, user.userId).then(function () {
        self.success('Petty cash disbursed successfully. Status updated to Active.');
        _load();
      }).catch(function (err) {
        self.error((err && err.message) || 'Disburse failed.');
      });
    };

    self.back = function () {
      if (window._pcApp) window._pcApp.navigate('myPettyCash');
    };

    self.viewReimb = function (rb) {
      if (window._pcApp) window._pcApp.navigate('reimbDetail', { reimbId: rb.reimbId, pcId: pcId });
    };

    self.viewClear = function (cl) {
      if (window._pcApp) window._pcApp.navigate('clearDetail', { clearingId: cl.clearingId, pcId: pcId });
    };

    function _load() {
      pcService.getById(pcId).then(function (rec) {
        self.record(rec);
        self.loading(false);
      });
      pcService.getBudgetLines(pcId).then(function (lines) { self.budgetLines(lines); });
      reimbService.getMyReimbursements(user.userId).then(function (list) {
        self.reimbursements(list.filter(function(r){ return r.pcId === pcId; }));
      });
      clearService.getMyClearings(user.userId).then(function (list) {
        self.clearings(list.filter(function(c){ return c.pcId === pcId; }));
      });
      approvalService.getHistoryForRecord(pcId, 'PETTY_CASH').then(function (actions) {
        self.approvalHistory(actions);
      });
    }

    if (pcId) {
      _load();
    } else {
      self.loading(false);
      self.error('No petty cash record selected.');
    }
  }

  return PcDetailViewModel;
});
