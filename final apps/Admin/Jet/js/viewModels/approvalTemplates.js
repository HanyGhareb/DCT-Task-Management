define(['knockout', 'services/auditService'], function (ko, auditService) {
  'use strict';

  function ApprovalTemplatesViewModel() {
    const self = this;

    self.templates = ko.observableArray(auditService.getTemplates());
    self.searchTerm = ko.observable('');

    self.filtered = ko.computed(() => {
      const q = self.searchTerm().toLowerCase();
      if (!q) return self.templates();
      return self.templates().filter(t =>
        t.templateName.toLowerCase().includes(q) ||
        t.templateCode.toLowerCase().includes(q) ||
        t.module.toLowerCase().includes(q)
      );
    });

    self.selected = ko.observable(null);
    self.showDetail = ko.observable(false);

    self.viewTemplate = function (t) {
      self.selected(auditService.getTemplateById(t.templateId));
      self.showDetail(true);
    };
    self.closeDetail = function () { self.showDetail(false); self.selected(null); };

    self.toggleActive = function (t) {
      auditService.updateTemplate(t.templateId, { isActive: t.isActive === 'Y' ? 'N' : 'Y' });
      self.templates(auditService.getTemplates());
    };
  }

  return ApprovalTemplatesViewModel;
});
