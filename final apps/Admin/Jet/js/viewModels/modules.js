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

    // ── Module access (db/v2/49) — which roles see the app in the switcher ──
    self.accessTarget  = ko.observable(null);   // { moduleId, nameEn }
    self.accessRoles   = ko.observableArray([]);
    self.showAccess    = ko.observable(false);
    self.accessLoading = ko.observable(false);
    self.accessSaving  = ko.observable(false);
    self.accessError   = ko.observable('');

    self.grantedCount = ko.computed(function () {
      return self.accessRoles().filter(function (r) { return r.checked(); }).length;
    });

    self.openAccess = function (mod) {
      self.accessTarget({ moduleId: mod.moduleId, nameEn: mod.nameEn });
      self.accessRoles([]);
      self.accessError('');
      self.accessLoading(true);
      self.showAccess(true);
      moduleService.getRoles(mod.moduleId).then(function (r) {
        self.accessRoles((r.items || []).map(function (it) {
          return {
            roleId:   it.roleId,
            roleCode: it.roleCode,
            nameEn:   it.nameEn,
            nameAr:   it.nameAr || '',
            checked:  ko.observable(it.granted === 'Y'),
          };
        }));
        self.accessLoading(false);
      }).catch(function () {
        self.accessLoading(false);
        self.accessError('load');
      });
    };

    self.closeAccess = function () {
      self.showAccess(false);
      self.accessTarget(null);
      self.accessRoles([]);
    };

    self.clearAccess = function () {
      self.accessRoles().forEach(function (r) { r.checked(false); });
    };

    self.saveAccess = function () {
      var t = self.accessTarget();
      if (!t || self.accessSaving()) return;
      var ids = self.accessRoles().filter(function (r) { return r.checked(); })
                                  .map(function (r) { return r.roleId; });
      self.accessSaving(true);
      moduleService.setRoles(t.moduleId, ids).then(function () {
        self.accessSaving(false);
        self.closeAccess();
      }).catch(function () {
        self.accessSaving(false);
        self.accessError('save');
      });
    };
  }

  return ModulesViewModel;
});
