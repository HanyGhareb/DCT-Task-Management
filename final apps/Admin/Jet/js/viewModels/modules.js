define(['knockout', 'services/moduleService'], function (ko, moduleService) {
  'use strict';

  function ModulesViewModel() {
    const self = this;

    self.allModules = ko.observableArray(moduleService.getAll());
    self.categories = moduleService.getCategories();
    self.searchTerm = ko.observable('');
    self.filterCat  = ko.observable('ALL');

    self.filteredModules = ko.computed(() => {
      let data = self.allModules();
      const q = self.searchTerm().toLowerCase();
      if (q) data = data.filter(m => m.nameEn.toLowerCase().includes(q) || m.moduleCode.toLowerCase().includes(q));
      if (self.filterCat() !== 'ALL') data = data.filter(m => m.category === self.filterCat());
      return data;
    });

    // Edit dialog
    self.editTarget = ko.observable(null);
    self.showEdit   = ko.observable(false);

    self.openEdit = function (mod) {
      self.editTarget({
        moduleId: mod.moduleId,
        nameEn: ko.observable(mod.nameEn),
        nameAr: ko.observable(mod.nameAr),
        category: ko.observable(mod.category),
        isActive: ko.observable(mod.isActive === 'Y'),
        displayOrder: ko.observable(mod.displayOrder),
        apexAppId: mod.apexAppId,
      });
      self.showEdit(true);
    };

    self.closeEdit = function () { self.showEdit(false); self.editTarget(null); };

    self.saveEdit = function () {
      const t = self.editTarget();
      if (!t) return;
      moduleService.update(t.moduleId, {
        nameEn: t.nameEn(), nameAr: t.nameAr(),
        category: t.category(),
        isActive: t.isActive() ? 'Y' : 'N',
        displayOrder: t.displayOrder(),
      });
      self.allModules(moduleService.getAll());
      self.closeEdit();
    };

    self.toggleActive = function (mod) {
      moduleService.toggleActive(mod.moduleId);
      self.allModules(moduleService.getAll());
    };
  }

  return ModulesViewModel;
});
