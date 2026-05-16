define(['knockout', 'services/auditService'], function (ko, auditService) {
  'use strict';

  function PendingApprovalsViewModel() {
    const self = this;

    self.pending = ko.observableArray(auditService.getApprovals('PENDING'));
    self.actionMsg = ko.observable('');

    self.approve = function (instance) {
      auditService.getApprovals().find(a => a.instanceId === instance.instanceId) && (
        auditService.getApprovals().find(a => a.instanceId === instance.instanceId).overallStatus = 'APPROVED'
      );
      self.pending(auditService.getApprovals('PENDING'));
      self.actionMsg('Approval granted for: ' + instance.templateName);
      setTimeout(() => self.actionMsg(''), 3000);
    };

    self.reject = function (instance) {
      const found = auditService.getApprovals().find(a => a.instanceId === instance.instanceId);
      if (found) found.overallStatus = 'REJECTED';
      self.pending(auditService.getApprovals('PENDING'));
      self.actionMsg('Rejected: ' + instance.templateName);
      setTimeout(() => self.actionMsg(''), 3000);
    };

    self.getStepArray = function (inst) {
      return Array.from({ length: inst.totalSteps }, (_, i) => i + 1);
    };

    self.stepState = function (inst, step) {
      if (step < inst.currentStep) return 'done';
      if (step === inst.currentStep) return 'current';
      return 'pending';
    };
  }

  return PendingApprovalsViewModel;
});
