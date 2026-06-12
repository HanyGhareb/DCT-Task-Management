define(['knockout', 'services/ccService'], function (ko, ccService) {
  'use strict';

  function ApprovalsViewModel() {
    var self = this;

    self.loading   = ko.observable(true);
    self.pending   = ko.observableArray([]);
    self.actionMsg = ko.observable('');

    function load() {
      self.loading(true);
      ccService.getPendingApprovals().then(function (items) {
        self.pending(items.map(function (it) {
          it.commentText = ko.observable('');
          it.actionMode  = ko.observable('');
          it.actionError = ko.observable('');
          it.busy        = ko.observable(false);
          return it;
        }));
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }
    load();

    self.startAction = function (item, mode) {
      item.actionError('');
      item.actionMode(item.actionMode() === mode ? '' : mode);
    };
    self.startApprove = function (item) { self.startAction(item, 'APPROVED'); };
    self.startReject  = function (item) { self.startAction(item, 'REJECTED'); };
    self.startReturn  = function (item) { self.startAction(item, 'RETURNED'); };
    self.cancelAction = function (item) { item.actionMode(''); item.actionError(''); };

    self.confirmAction = function (item) {
      var comments = item.commentText().trim();
      if (!comments) { item.actionError('A comment is required.'); return; }
      item.busy(true);
      ccService.actionApproval(item.instanceId, item.actionMode(), comments)
        .then(function () {
          item.busy(false);
          self.actionMsg(item.actionMode() + ': ' + (item.requestRef || item.instanceId));
          setTimeout(function () { self.actionMsg(''); }, 4000);
          load();
        })
        .catch(function (err) {
          item.busy(false);
          item.actionError((err && err.message) || 'Action failed');
        });
    };

    self.moduleChip = function (m) {
      return (m || '').replace('CC_', '').replace('_', ' ');
    };
    self.getStepArray = function (inst) {
      return Array.from({ length: inst.totalSteps || 0 }, function (_, i) { return i + 1; });
    };
    self.stepState = function (inst, step) {
      if (step < (inst.currentStep || 0)) return 'done';
      if (step === (inst.currentStep || 0)) return 'current';
      return 'pending';
    };
  }

  return ApprovalsViewModel;
});
