define(['knockout', 'services/auditService'], function (ko, auditService) {
  'use strict';

  function ApprovalMonitorViewModel() {
    const self = this;

    self.statusFilter = ko.observable('ALL');
    self.searchTerm   = ko.observable('');

    self.reload = function () {
      self.allApprovals(auditService.getApprovals(
        self.statusFilter() === 'ALL' ? null : self.statusFilter()
      ));
    };

    self.allApprovals = ko.observableArray(auditService.getApprovals());
    self.statusFilter.subscribe(() => self.reload());

    self.filtered = ko.computed(() => {
      const q = self.searchTerm().toLowerCase();
      if (!q) return self.allApprovals();
      return self.allApprovals().filter(a =>
        a.templateName.toLowerCase().includes(q) ||
        a.requestedBy.toLowerCase().includes(q)
      );
    });

    self.counts = ko.computed(() => ({
      all:      auditService.getApprovals().length,
      pending:  auditService.getApprovals().filter(a => a.overallStatus === 'PENDING').length,
      approved: auditService.getApprovals().filter(a => a.overallStatus === 'APPROVED').length,
      rejected: auditService.getApprovals().filter(a => a.overallStatus === 'REJECTED').length,
    }));

    self.getProgressPct = function (inst) {
      if (inst.overallStatus === 'APPROVED') return 100;
      if (inst.overallStatus === 'REJECTED') return Math.round((inst.currentStep / inst.totalSteps) * 100);
      return Math.round(((inst.currentStep) / inst.totalSteps) * 100);
    };

    self.getStepArray = function (inst) {
      return Array.from({ length: inst.totalSteps }, (_, i) => i + 1);
    };

    self.stepState = function (inst, step) {
      if (inst.overallStatus === 'APPROVED') return 'done';
      if (step < inst.currentStep) return 'done';
      if (step === inst.currentStep) return 'current';
      return 'pending';
    };
  }

  return ApprovalMonitorViewModel;
});
