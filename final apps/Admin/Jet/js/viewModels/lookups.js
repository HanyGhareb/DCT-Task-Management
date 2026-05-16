define(['knockout', 'services/settingService'], function (ko, settingService) {
  'use strict';

  function LookupsViewModel() {
    const self = this;

    self.lookupTypes = ko.observableArray(['ALL', ...settingService.getLookupTypes()]);
    self.filterType  = ko.observable('ALL');
    self.searchTerm  = ko.observable('');
    self.lookups     = ko.observableArray(settingService.getLookups());

    self.filtered = ko.computed(() => {
      let data = self.lookups();
      const t = self.filterType();
      if (t && t !== 'ALL') data = data.filter(l => l.lookupType === t);
      const q = self.searchTerm().toLowerCase();
      if (q) data = data.filter(l =>
        l.lookupCode.toLowerCase().includes(q) ||
        l.displayValue.toLowerCase().includes(q)
      );
      return data;
    });

    // Inline edit
    self.editTarget = ko.observable(null);
    self.showEdit   = ko.observable(false);
    self.isNew      = ko.observable(false);

    self.openNew = function () {
      self.editTarget({ lookupId: null, lookupType: ko.observable(''), lookupCode: ko.observable(''), displayValue: ko.observable(''), sortOrder: ko.observable(1), isActive: ko.observable(true) });
      self.isNew(true);
      self.showEdit(true);
    };

    self.openEdit = function (l) {
      self.editTarget({ lookupId: l.lookupId, lookupType: ko.observable(l.lookupType), lookupCode: ko.observable(l.lookupCode), displayValue: ko.observable(l.displayValue), sortOrder: ko.observable(l.sortOrder), isActive: ko.observable(l.isActive === 'Y') });
      self.isNew(false);
      self.showEdit(true);
    };

    self.closeEdit = function () { self.showEdit(false); self.editTarget(null); };

    self.saveEdit = function () {
      const t = self.editTarget();
      const data = { lookupType: t.lookupType(), lookupCode: t.lookupCode().toUpperCase().trim(), displayValue: t.displayValue().trim(), sortOrder: Number(t.sortOrder()), isActive: t.isActive() ? 'Y' : 'N' };
      if (self.isNew()) settingService.createLookup(data);
      else settingService.updateLookup(t.lookupId, data);
      self.lookups(settingService.getLookups());
      self.lookupTypes(['ALL', ...settingService.getLookupTypes()]);
      self.closeEdit();
    };

    self.removeLookup = function (l) {
      if (confirm('Delete "' + l.displayValue + '"?')) {
        settingService.removeLookup(l.lookupId);
        self.lookups(settingService.getLookups());
      }
    };
  }

  return LookupsViewModel;
});
