define(['knockout', 'services/auditService'], function (ko, auditService) {
  'use strict';

  function ApprovalMonitorViewModel() {
    var self = this;

    self.statusFilter = ko.observable('ALL');
    self.searchTerm   = ko.observable('');
    self.loading      = ko.observable(true);
    self.allApprovals = ko.observableArray([]);

    self.counts = ko.computed(function () {
      var all = self.allApprovals();
      return {
        all:      all.length,
        pending:  all.filter(function (a) { return a.overallStatus === 'PENDING'; }).length,
        approved: all.filter(function (a) { return a.overallStatus === 'APPROVED'; }).length,
        rejected: all.filter(function (a) { return a.overallStatus === 'REJECTED'; }).length,
      };
    });

    self.reload = function () {
      self.loading(true);
      auditService.getApprovals().then(function (items) {
        var f = self.statusFilter();
        self.allApprovals(f === 'ALL' ? items : items.filter(function (a) { return a.overallStatus === f; }));
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };
    self.reload();
    self.statusFilter.subscribe(function () { self.reload(); });

    self.filtered = ko.computed(function () {
      var q = self.searchTerm().toLowerCase();
      if (!q) return self.allApprovals();
      return self.allApprovals().filter(function (a) {
        return (a.templateName || '').toLowerCase().includes(q) ||
               (a.requestedBy  || '').toLowerCase().includes(q);
      });
    });

    self.getProgressPct = function (inst) {
      if (inst.overallStatus === 'APPROVED') return 100;
      return Math.round(((inst.currentStep || 0) / (inst.totalSteps || 1)) * 100);
    };

    self.getStepArray = function (inst) {
      return Array.from({ length: inst.totalSteps || 0 }, function (_, i) { return i + 1; });
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
