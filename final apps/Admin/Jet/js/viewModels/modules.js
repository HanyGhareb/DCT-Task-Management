define(['knockout', 'services/moduleService'], function (ko, moduleService) {
  'use strict';

  function ModulesViewModel() {
    var self = this;

    self.allModules = ko.observableArray([]);
    self.loading    = ko.observable(true);
    self.categories = moduleService.getCategories();
    self.searchTerm = ko.observable('');
    self.filterCat  = ko.observable('ALL');

    function loadModules() {
      moduleService.getAll().then(function (mods) {
        self.allModules(mods);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }
    loadModules();

    self.filteredModules = ko.computed(function () {
      var data = self.allModules();
      var q = self.searchTerm().toLowerCase();
      if (q) data = data.filter(function (m) {
        return (m.nameEn      || '').toLowerCase().includes(q) ||
               (m.moduleCode  || '').toLowerCase().includes(q);
      });
      if (self.filterCat() !== 'ALL') {
        data = data.filter(function (m) { return m.category === self.filterCat(); });
      }
      return data;
    });

    self.editTarget  = ko.observable(null);
    self.showEdit    = ko.observable(false);
    self.auditTarget = ko.observable(null);   // createdBy/At, updatedBy/At of the edited module

    self.openEdit = function (mod) {
      self.auditTarget(mod);
      self.editTarget({
        moduleId:     mod.moduleId,
        nameEn:       ko.observable(mod.nameEn),
        nameAr:       ko.observable(mod.nameAr),
        category:     ko.observable(mod.category),
        isActive:     ko.observable(mod.isActive === 'Y'),
        displayOrder: ko.observable(mod.displayOrder),
        apexAppId:    mod.apexAppId,
      });
      self.showEdit(true);
    };

    self.closeEdit = function () { self.showEdit(false); self.editTarget(null); };

    self.saveEdit = function () {
      var t = self.editTarget();
      if (!t) return;
      moduleService.update(t.moduleId, {
        nameEn:       t.nameEn(),
        nameAr:       t.nameAr(),
        category:     t.category(),
        isActive:     t.isActive() ? 'Y' : 'N',
        displayOrder: Number(t.displayOrder()),
      }).then(function () {
        self.closeEdit();
        loadModules();
      }).catch(function () { self.closeEdit(); });
    };

    self.toggleActive = function (mod) {
      moduleService.toggleActive(mod.moduleId, mod.isActive).then(function () {
        loadModules();
      });
    };
  }

  return ModulesViewModel;
});
