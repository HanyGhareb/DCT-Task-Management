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

    // Modal state
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

    self.selectCategory = function (cat) {
      self.selectedCategory(cat);
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

    function _clearForm() {
      self.form.value_code('');
      self.form.value_name_en('');
      self.form.value_name_ar('');
      self.form.display_order('');
      self.form.is_active('Y');
      self.formError('');
      self.editingId(null);
    }

    self.openAdd = function () {
      _clearForm();
      self.showModal(true);
    };

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

    self.closeModal = function () {
      if (!self.saving()) self.showModal(false);
    };

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
        // Reload values for the current category
        if (cat) self.selectCategory(cat);
      }).catch(function (err) {
        self.saving(false);
        self.formError((err && err.message) || 'Save failed.');
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
