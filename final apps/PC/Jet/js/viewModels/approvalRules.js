define(['knockout', 'services/approvalService', 'mockData'],
function (ko, approvalService, mockData) {
  'use strict';

  function ApprovalRulesViewModel() {
    var self = this;

    self.templates      = ko.observableArray([]);
    self.selectedTmpl   = ko.observable(null);
    self.steps          = ko.observableArray([]);
    self.loading        = ko.observable(true);
    self.stepsLoading   = ko.observable(false);
    self.error          = ko.observable('');
    self.success        = ko.observable('');

    self.CONDITION_TYPES = ['ALWAYS','AMOUNT','TYPE_FILTER','COMBINED','CUSTOM'];
    self.OPERATORS       = ['>','>=','<','<=','='];
    self.ROLES           = ['MANAGER','AP_PETTY_CASH_ADMIN','TASK_DIRECTOR','SYS_ADMIN'];

    self.selectTemplate = function (tmpl) {
      self.selectedTmpl(tmpl);
      self.stepsLoading(true);
      approvalService.getSteps(tmpl.templateId).then(function (steps) {
        self.steps(steps.map(function(s){ return _toObs(s); }));
        self.stepsLoading(false);
      });
    };

    function _toObs(s) {
      return {
        stepId:          s.stepId,
        templateId:      s.templateId,
        stepSeq:         ko.observable(s.stepSeq),
        stepName:        ko.observable(s.stepName),
        requiredRole:    ko.observable(s.requiredRole),
        conditionType:   ko.observable(s.conditionType),
        amountOperator:  ko.observable(s.amountOperator || ''),
        amountThreshold: ko.observable(s.amountThreshold || ''),
        typeFilter:      ko.observable(s.typeFilter || ''),
        isMandatory:     ko.observable(s.isMandatory || 'Y'),
        allowSkip:       ko.observable(s.allowSkip || 'N'),
        escalationDays:  ko.observable(s.escalationDays || 3),
        isActive:        ko.observable(s.isActive || 'Y'),
        showAmount:      ko.computed(function(){ return ['AMOUNT','COMBINED'].includes(this.conditionType()); }, { conditionType: ko.observable(s.conditionType) }),
        showTypeFilter:  ko.computed(function(){ return ['TYPE_FILTER','COMBINED'].includes(this.conditionType()); }, { conditionType: ko.observable(s.conditionType) }),
      };
    }

    self.templateTypeLabel = function (t) {
      var map = { PETTY_CASH:'Petty Cash Advance', REIMBURSEMENT:'Reimbursement', CLEARING:'Clearing' };
      return map[t] || t;
    };

    self.typeClass = function (t) {
      var map = { PETTY_CASH:'badge--active', REIMBURSEMENT:'badge--info', CLEARING:'badge--warning' };
      return 'badge ' + (map[t] || 'badge--info');
    };

    self.condTypeLabel = function (c) {
      var map = { ALWAYS:'Always', AMOUNT:'Amount Threshold', TYPE_FILTER:'PC Type Filter', COMBINED:'Combined', CUSTOM:'Custom PL/SQL' };
      return map[c] || c;
    };

    approvalService.getTemplates().then(function (list) {
      self.templates(list);
      self.loading(false);
      if (list.length > 0) self.selectTemplate(list[0]);
    });
  }

  return ApprovalRulesViewModel;
});
