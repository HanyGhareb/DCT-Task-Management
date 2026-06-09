define(['knockout', 'services/auditService'], function (ko, auditService) {
  'use strict';

  function ApprovalTemplatesViewModel() {
    var self = this;

    self.loading    = ko.observable(true);
    self.templates  = ko.observableArray([]);
    self.searchTerm = ko.observable('');

    auditService.getTemplates().then(function (items) {
      self.templates(items);
      self.loading(false);
    }).catch(function () { self.loading(false); });

    self.filtered = ko.computed(function () {
      var q = self.searchTerm().toLowerCase();
      if (!q) return self.templates();
      return self.templates().filter(function (t) {
        return (t.templateName || '').toLowerCase().includes(q) ||
               (t.templateCode || '').toLowerCase().includes(q) ||
               (t.module       || '').toLowerCase().includes(q);
      });
    });

    self.selected   = ko.observable(null);
    self.showDetail = ko.observable(false);

    self.viewTemplate = function (t) {
      auditService.getTemplateById(t.templateId).then(function (template) {
        self.selected(template);
        self.showDetail(!!template);
      });
    };
    self.closeDetail = function () { self.showDetail(false); self.selected(null); };

    self.toggleActive = function (t) {
      auditService.updateTemplate(t.templateId, { isActive: t.isActive === 'Y' ? 'N' : 'Y' })
        .then(function () {
          auditService.getTemplates().then(function (items) { self.templates(items); });
        });
    };
  }

  return ApprovalTemplatesViewModel;
});
