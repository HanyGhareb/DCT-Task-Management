define(['knockout', 'services/approvalService'],
function (ko, approvalService) {
  'use strict';

  function ApprovalRulesViewModel() {
    var self = this;

    self.templates = ko.observableArray([]);
    self.steps     = ko.observableArray([]);
    self.loading   = ko.observable(true);
    self.selectedTemplateId = ko.observable(null);

    self.selectTemplate = function (tpl) {
      self.selectedTemplateId(tpl.templateId);
      approvalService.getSteps(tpl.templateId).then(function (steps) {
        self.steps(steps.sort(function(a,b){ return a.stepSeq - b.stepSeq; }));
      });
    };

    self.conditionLabel = function (step) {
      if (step.conditionType === 'ALWAYS') return 'Always';
      if (step.conditionType === 'AMOUNT' && step.amountOperator) {
        return 'Amount ' + step.amountOperator + ' ' + step.amountThreshold + ' AED';
      }
      return step.conditionType;
    };

    approvalService.getTemplates().then(function (tpls) {
      self.templates(tpls);
      self.loading(false);
      if (tpls.length > 0) self.selectTemplate(tpls[0]);
    }).catch(function () { self.loading(false); });
  }

  return ApprovalRulesViewModel;
});
