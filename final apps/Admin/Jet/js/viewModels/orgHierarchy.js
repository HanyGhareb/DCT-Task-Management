define(['knockout', 'services/orgService'], function (ko, orgService) {
  'use strict';

  function OrgHierarchyViewModel() {
    var self = this;

    self.loading    = ko.observable(true);
    self.tree       = ko.observableArray([]);
    self.flatList   = ko.observableArray([]);
    self.searchTerm = ko.observable('');

    Promise.all([orgService.getAll(), orgService.getTree()]).then(function (results) {
      self.flatList(results[0]);
      self.tree(results[1]);
      self.loading(false);
    }).catch(function () { self.loading(false); });

    self.filteredList = ko.computed(function () {
      var q = self.searchTerm().toLowerCase();
      if (!q) return self.flatList();
      return self.flatList().filter(function (o) {
        return (o.nameEn  || '').toLowerCase().includes(q) ||
               (o.orgCode || '').toLowerCase().includes(q);
      });
    });

    self.getParentName = function (parentId) {
      if (!parentId) return '—';
      var p = self.flatList().find(function (o) { return o.orgId === parentId; });
      return p ? p.nameEn : '—';
    };

    self.getTypeLabel = function (t) {
      return { DIVISION: 'Division', SECTION: 'Section' }[t] || t;
    };
  }

  return OrgHierarchyViewModel;
});
