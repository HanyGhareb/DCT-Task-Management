define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function LookupsViewModel() {
    var self = this;

    self.isAdmin = authService.isHrAdmin();

    self.categories       = ko.observableArray([]);
    self.values           = ko.observableArray([]);
    self.selectedCategory = ko.observable(null);
    self.loadingCats      = ko.observable(true);
    self.loadingVals      = ko.observable(false);
    self.error            = ko.observable('');
    self.savedMsg         = ko.observable('');

    // Search
    self.searchCats = ko.observable('');
    self.searchVals = ko.observable('');

    self.filteredCategories = ko.computed(function () {
      var q = (self.searchCats() || '').toUpperCase();
      if (!q) return self.categories();
      return self.categories().filter(function (c) {
        return (c.category_name_en || '').toUpperCase().includes(q) ||
               (c.category_code    || '').toUpperCase().includes(q);
      });
    });

    self.filteredValues = ko.computed(function () {
      var q = (self.searchVals() || '').toUpperCase();
      if (!q) return self.values();
      return self.values().filter(function (v) {
        var code = (v.value_code || v.valueCode || '').toUpperCase();
        var name = (v.value_name_en || v.valueNameEn || '').toUpperCase();
        return code.includes(q) || name.includes(q);
      });
    });

    // Value modal state
    self.showModal  = ko.observable(false);
    self.editingId  = ko.observable(null);
    self.saving     = ko.observable(false);
    self.formError  = ko.observable('');
    self.form = {
      value_code:    ko.observable(''),
      value_name_en: ko.observable(''),
      value_name_ar: ko.observable(''),
      display_order: ko.observable(''),
      is_active:     ko.observable('Y'),
    };

    // Category modal state
    self.showCatModal  = ko.observable(false);
    self.savingCat     = ko.observable(false);
    self.catFormError  = ko.observable('');
    self.catForm = {
      category_code:    ko.observable(''),
      category_name_en: ko.observable(''),
      category_name_ar: ko.observable(''),
      is_active:        ko.observable('Y'),
    };

    self.selectCategory = function (cat) {
      self.selectedCategory(cat);
      self.searchVals('');
      self.loadingVals(true);
      self.values([]);
      hrService.getLookupValues(cat.category_code).then(function (list) {
        self.values(list);
        self.loadingVals(false);
      }).catch(function (err) {
        self.error((err && err.message) || 'Failed to load values.');
        self.loadingVals(false);
      });
    };

    // ── Value CRUD ────────────────────────────────────────────────────
    function _clearForm() {
      self.form.value_code('');
      self.form.value_name_en('');
      self.form.value_name_ar('');
      self.form.display_order('');
      self.form.is_active('Y');
      self.formError('');
      self.editingId(null);
    }

    self.openAdd = function () { _clearForm(); self.showModal(true); };

    self.openEdit = function (val) {
      _clearForm();
      self.editingId(val.value_id || val.valueId);
      self.form.value_code(val.value_code || val.valueCode || '');
      self.form.value_name_en(val.value_name_en || val.valueNameEn || '');
      self.form.value_name_ar(val.value_name_ar || val.valueNameAr || '');
      self.form.display_order(val.display_order || val.displayOrder || '');
      self.form.is_active(val.is_active || val.isActive || 'Y');
      self.showModal(true);
    };

    self.closeModal = function () { if (!self.saving()) self.showModal(false); };

    self.saveValue = function () {
      var code = self.form.value_code().trim();
      var name = self.form.value_name_en().trim();
      if (!self.editingId() && !code) { self.formError('Value Code is required.'); return; }
      if (!name) { self.formError('Name (EN) is required.'); return; }

      var cat = self.selectedCategory();
      var data = {
        category_code: cat ? cat.category_code : '',
        value_code:    code,
        value_name_en: name,
        value_name_ar: self.form.value_name_ar(),
        display_order: self.form.display_order() || null,
        is_active:     self.form.is_active(),
      };

      self.saving(true);
      var op = self.editingId()
        ? hrService.updateLookupValue(self.editingId(), data)
        : hrService.createLookupValue(data);

      op.then(function () {
        self.saving(false);
        self.showModal(false);
        self.savedMsg(self.editingId() ? 'Value updated.' : 'Value added.');
        setTimeout(function () { self.savedMsg(''); }, 4000);
        if (cat) self.selectCategory(cat);
      }).catch(function (err) {
        self.saving(false);
        self.formError((err && err.message) || 'Save failed.');
      });
    };

    // ── Category CRUD ─────────────────────────────────────────────────
    self.openAddCategory = function () {
      self.catForm.category_code('');
      self.catForm.category_name_en('');
      self.catForm.category_name_ar('');
      self.catForm.is_active('Y');
      self.catFormError('');
      self.showCatModal(true);
    };

    self.closeCatModal = function () { if (!self.savingCat()) self.showCatModal(false); };

    self.saveCategory = function () {
      var code = self.catForm.category_code().trim().toUpperCase();
      var name = self.catForm.category_name_en().trim();
      if (!code) { self.catFormError('Category Code is required.'); return; }
      if (!name) { self.catFormError('Category Name (EN) is required.'); return; }

      var data = {
        category_code:    code,
        category_name_en: name,
        category_name_ar: self.catForm.category_name_ar(),
        is_active:        self.catForm.is_active(),
      };

      self.savingCat(true);
      hrService.createLookupCategory(data).then(function () {
        self.savingCat(false);
        self.showCatModal(false);
        self.savedMsg('Category created.');
        setTimeout(function () { self.savedMsg(''); }, 4000);
        // Reload categories
        return hrService.getLookupCategories();
      }).then(function (list) {
        if (list) self.categories(list);
      }).catch(function (err) {
        self.savingCat(false);
        self.catFormError((err && err.message) || 'Save failed.');
      });
    };

    // Load categories on init
    hrService.getLookupCategories().then(function (list) {
      self.categories(list);
      self.loadingCats(false);
    }).catch(function (err) {
      self.error((err && err.message) || 'Failed to load categories.');
      self.loadingCats(false);
    });
  }

  return LookupsViewModel;
});
