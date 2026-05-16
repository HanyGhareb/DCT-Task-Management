define(['knockout', 'services/authService', 'services/approvalService'],
function (ko, authService, approvalService) {
  'use strict';

  function ApprovalsViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.records  = ko.observableArray([]);
    self.loading  = ko.observable(true);
    self.search   = ko.observable('');

    // Modal
    self.modalOpen    = ko.observable(false);
    self.modalItem    = ko.observable(null);
    self.modalAction  = ko.observable('APPROVED');
    self.modalComment = ko.observable('');
    self.modalError   = ko.observable('');
    self.modalSaving  = ko.observable(false);

    self.filtered = ko.computed(function () {
      var q = self.search().toLowerCase();
      return self.records().filter(function (r) {
        return !q || r.requestRef.toLowerCase().includes(q) || r.submittedBy.toLowerCase().includes(q);
      });
    });

    self.fmtAmount = function (n) { return n ? Number(n).toLocaleString('en-US', { minimumFractionDigits: 2 }) : '—'; };
    self.fmtDate   = function (d) { return d ? new Date(d).toLocaleDateString('en-GB', { day:'2-digit', month:'short', year:'numeric' }) : '—'; };

    self.typeLabel = function (t) {
      var map = { PETTY_CASH:'Petty Cash', REIMBURSEMENT:'Reimbursement', CLEARING:'Clearing' };
      return map[t] || t;
    };
    self.typeClass = function (t) {
      var map = { PETTY_CASH:'badge--blue', REIMBURSEMENT:'badge--info', CLEARING:'badge--warning' };
      return 'badge ' + (map[t] || 'badge--info');
    };

    self.openModal = function (item) {
      self.modalItem(item);
      self.modalAction('APPROVED');
      self.modalComment('');
      self.modalError('');
      self.modalOpen(true);
    };
    self.closeModal = function () { self.modalOpen(false); };

    self.commentRequired = ko.computed(function () {
      return self.modalAction() === 'REJECTED' || self.modalAction() === 'RETURNED';
    });

    self.submitAction = function () {
      self.modalError('');
      if (self.commentRequired() && !self.modalComment().trim()) {
        self.modalError('Please provide a comment when rejecting or returning a request.');
        return;
      }
      self.modalSaving(true);
      var item = self.modalItem();
      approvalService.submitAction(item.instanceId, self.modalAction(), self.modalComment(), user.userId)
        .then(function () {
          self.modalSaving(false);
          self.closeModal();
          _load();
        })
        .catch(function (err) {
          self.modalSaving(false);
          self.modalError((err && err.message) || 'Action failed. Please try again.');
        });
    };

    self.viewSource = function (item) {
      if (!window._pcApp) return;
      if (item.requestType === 'PETTY_CASH')    window._pcApp.navigate('pcDetail', { pcId: item.sourceRecordId });
      if (item.requestType === 'REIMBURSEMENT') window._pcApp.navigate('reimbDetail', { reimbId: item.sourceRecordId });
      if (item.requestType === 'CLEARING')      window._pcApp.navigate('clearDetail', { clearingId: item.sourceRecordId });
    };

    function _load() {
      self.loading(true);
      approvalService.getPendingForUser(user).then(function (list) {
        self.records(list);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    _load();
  }

  return ApprovalsViewModel;
});
