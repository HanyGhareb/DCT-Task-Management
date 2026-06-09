define(['knockout', 'services/auditService'], function (ko, auditService) {
  'use strict';

  function PendingApprovalsViewModel() {
    var self = this;

    self.loading   = ko.observable(true);
    self.pending   = ko.observableArray([]);
    self.actionMsg = ko.observable('');

    auditService.getApprovals('PENDING').then(function (items) {
      self.pending(items);
      self.loading(false);
    }).catch(function () { self.loading(false); });

    self.approve = function (instance) {
      self.actionMsg('Approval submitted for: ' + (instance.templateName || instance.instanceId));
      setTimeout(function () { self.actionMsg(''); }, 3000);
    };

    self.reject = function (instance) {
      self.actionMsg('Rejection submitted for: ' + (instance.templateName || instance.instanceId));
      setTimeout(function () { self.actionMsg(''); }, 3000);
    };

    self.getStepArray = function (inst) {
      return Array.from({ length: inst.totalSteps || 0 }, function (_, i) { return i + 1; });
    };

    self.stepState = function (inst, step) {
      if (step < inst.currentStep) return 'done';
      if (step === inst.currentStep) return 'current';
      return 'pending';
    };
  }

  return PendingApprovalsViewModel;
});
