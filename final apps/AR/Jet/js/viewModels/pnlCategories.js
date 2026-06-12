define(['knockout', 'services/arService', 'shared/i18n', 'shared/toast'],
function (ko, arService, i18n, toast) {
  'use strict';

  function PnlCategoriesViewModel() {
    var self = this;
    self.t = i18n.t;

    self.loading    = ko.observable(true);
    self.categories = ko.observableArray([]);
    self.search     = ko.observable('');

    self.filteredCategories = ko.computed(function () {
      var q = (self.search() || '').trim().toLowerCase();
      if (!q) return self.categories();
      return self.categories().filter(function (c) {
        return [c.code, c.nameEn, c.nameAr, c.type, c.description]
          .some(function (v) { return v && String(v).toLowerCase().indexOf(q) >= 0; });
      });
    });

    // editor
    self.editId      = ko.observable(null);
    self.code        = ko.observable('');
    self.nameEn      = ko.observable('');
    self.nameAr      = ko.observable('');
    self.type        = ko.observable('EXPENSE');
    self.description = ko.observable('');
    self.showEditor  = ko.observable(false);
    self.saving      = ko.observable(false);

    self.reload = function () {
      self.loading(true);
      arService.getCategories({ all: 1 }).then(function (res) {
        self.categories(res.items || []);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };

    self.newCat = function () {
      self.editId(null); self.code(''); self.nameEn(''); self.nameAr('');
      self.type('EXPENSE'); self.description('');
      self.showEditor(true);
    };
    self.editCat = function (c) {
      self.editId(c.categoryId); self.code(c.code); self.nameEn(c.nameEn);
      self.nameAr(c.nameAr || ''); self.type(c.type); self.description(c.description || '');
      self.showEditor(true);
    };
    self.cancelEdit = function () { self.showEditor(false); };

    self.save = function () {
      if (!self.nameEn() || (!self.editId() && !self.code())) {
        toast.error('Code and English name are required'); return;
      }
      self.saving(true);
      var payload = {
        nameEn: self.nameEn(), nameAr: self.nameAr() || null,
        type: self.type(), description: self.description() || null,
      };
      var p = self.editId()
        ? arService.updateCategory(self.editId(), payload)
        : arService.createCategory(Object.assign({ code: self.code() }, payload));
      p.then(function () {
        self.saving(false); self.showEditor(false);
        toast.success('Category saved — the AI prompt uses the description for mapping');
        self.reload();
      }).catch(function (err) {
        self.saving(false);
        toast.error((err && err.message) || 'Save failed');
      });
    };

    self.toggleActive = function (c) {
      arService.updateCategory(c.categoryId, { isActive: !c.isActive }).then(self.reload);
    };

    self.reload();
  }

  return PnlCategoriesViewModel;
});
