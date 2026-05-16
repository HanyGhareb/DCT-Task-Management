define(['knockout', 'services/orgService'], function (ko, orgService) {
  'use strict';

  function OrgHierarchyViewModel() {
    const self = this;

    self.tree = orgService.getTree();

    self.flatList = orgService.getAll();
    self.searchTerm = ko.observable('');

    self.filteredList = ko.computed(() => {
      const q = self.searchTerm().toLowerCase();
      if (!q) return self.flatList;
      return self.flatList.filter(o =>
        o.nameEn.toLowerCase().includes(q) ||
        o.orgCode.toLowerCase().includes(q)
      );
    });

    self.getParentName = function (parentId) {
      if (!parentId) return '—';
      const p = self.flatList.find(o => o.orgId === parentId);
      return p ? p.nameEn : '—';
    };

    self.getTypeLabel = function (t) {
      return { DIVISION: 'Division', SECTION: 'Section' }[t] || t;
    };
  }

  return OrgHierarchyViewModel;
});
