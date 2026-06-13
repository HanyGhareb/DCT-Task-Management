define(['knockout', 'services/ccService'], function (ko, ccService) {
  'use strict';

  function ModuleSettingsViewModel() {
    var self = this;

    self.loading    = ko.observable(true);
    self.items      = ko.observableArray([]);
    self.successMsg = ko.observable('');
    self.errorMsg   = ko.observable('');
    self.saving     = ko.observable(false);

    ccService.getSettings().then(function (items) {
      self.items(items.map(function (s) {
        var obs = ko.observable(s.value);
        var item = {
          settingId: s.settingId,
          key: s.key,
          label: s.label || s.key,
          description: s.description || '',
          type: s.type || 'TEXT',
          allowed: (s.allowed || '').split(/[|,]/).filter(Boolean),
          value: obs,
          original: s.value,
          dirty: ko.observable(false)
        };
        obs.subscribe(function (v) { item.dirty(v !== item.original); });
        return item;
      }));
      self.loading(false);
    }).catch(function () { self.loading(false); });

    self.hasDirty = ko.computed(function () {
      return self.items().some(function (s) { return s.dirty(); });
    });

    self.saveAll = function () {
      var dirty = self.items().filter(function (s) { return s.dirty(); });
      if (!dirty.length) return;
      self.saving(true);
      Promise.all(dirty.map(function (s) {
        return ccService.updateSetting(s.settingId, s.value());
      })).then(function () {
        dirty.forEach(function (s) { s.original = s.value(); s.dirty(false); });
        self.saving(false);
        self.successMsg('Settings saved.');
        setTimeout(function () { self.successMsg(''); }, 3000);
      }).catch(function (err) {
        self.saving(false);
        self.errorMsg((err && err.message) || 'Save failed');
      });
    };
  }

  return ModuleSettingsViewModel;
});
