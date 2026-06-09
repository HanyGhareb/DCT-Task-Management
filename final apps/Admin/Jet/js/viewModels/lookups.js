define(['knockout', 'services/settingService'], function (ko, settingService) {
  'use strict';

  function LookupsViewModel() {
    var self = this;

    self.loading     = ko.observable(true);
    self.errorMsg    = ko.observable('');
    self.lookupTypes = ko.observableArray(['ALL']);
    self.filterType  = ko.observable('ALL');
    self.searchTerm  = ko.observable('');
    self.lookups     = ko.observableArray([]);

    function loadData() {
      self.loading(true);
      self.errorMsg('');
      Promise.all([
        settingService.getLookups(),
        settingService.getLookupTypes(),
      ]).then(function (results) {
        self.lookups(results[0]);
        self.lookupTypes(['ALL'].concat(results[1]));
        self.loading(false);
      }).catch(function (err) {
        self.errorMsg('Failed to load lookups: ' + ((err && err.message) || 'Unknown error'));
        self.loading(false);
      });
    }
    loadData();

    self.filtered = ko.computed(function () {
      var data = self.lookups();
      var t = self.filterType();
      if (t && t !== 'ALL') data = data.filter(function (l) { return l.lookupType === t; });
      var q = self.searchTerm().toLowerCase();
      if (q) data = data.filter(function (l) {
        return (l.lookupCode    || '').toLowerCase().includes(q) ||
               (l.displayValue  || '').toLowerCase().includes(q);
      });
      return data;
    });

    self.editTarget = ko.observable(null);
    self.showEdit   = ko.observable(false);
    self.isNew      = ko.observable(false);
    self.editError  = ko.observable('');
    self.saving     = ko.observable(false);

    self.openNew = function () {
      self.editTarget({ lookupId: null, lookupType: ko.observable(''), lookupCode: ko.observable(''), displayValue: ko.observable(''), sortOrder: ko.observable(1), isActive: ko.observable(true) });
      self.isNew(true);
      self.editError('');
      self.showEdit(true);
    };

    self.openEdit = function (l) {
      self.editTarget({ lookupId: l.lookupId, lookupType: ko.observable(l.lookupType), lookupCode: ko.observable(l.lookupCode), displayValue: ko.observable(l.displayValue), sortOrder: ko.observable(l.sortOrder), isActive: ko.observable(l.isActive === 'Y') });
      self.isNew(false);
      self.editError('');
      self.showEdit(true);
    };

    self.closeEdit = function () { self.showEdit(false); self.editTarget(null); self.editError(''); };

    self.saveEdit = function () {
      var t = self.editTarget();
      if (!t) return;
      self.saving(true);
      self.editError('');
      var data = {
        lookupType:   t.lookupType(),
        lookupCode:   (t.lookupCode() || '').toUpperCase().trim(),
        displayValue: (t.displayValue() || '').trim(),
        sortOrder:    Number(t.sortOrder()) || 1,
        isActive:     t.isActive() ? 'Y' : 'N',
      };
      var op = self.isNew()
        ? settingService.createLookup(data)
        : settingService.updateLookup(t.lookupId, data);

      op.then(function () {
        self.saving(false);
        self.closeEdit();
        loadData();
      }).catch(function (err) {
        self.saving(false);
        self.editError((err && err.message) || 'Save failed');
      });
    };

    self.removeLookup = function (l) {
      if (!confirm('Delete "' + l.displayValue + '"?')) return;
      settingService.removeLookup(l.lookupId).catch(function (err) {
        alert((err && err.message) || 'Delete failed');
      });
    };
  }

  return LookupsViewModel;
});
