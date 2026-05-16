define(['knockout', 'services/settingService'], function (ko, settingService) {
  'use strict';

  function SystemSettingsViewModel() {
    const self = this;

    const grouped = settingService.getSettingsByCategory();
    self.categories = Object.keys(grouped).map(cat => ({
      label: cat,
      settings: grouped[cat].map(s => ({
        settingId: s.settingId,
        settingKey: s.settingKey,
        description: s.description,
        updatedBy: s.updatedBy,
        updatedAt: s.updatedAt,
        value: ko.observable(s.settingValue),
        original: s.settingValue,
        dirty: ko.observable(false),
      }))
    }));

    // Track dirty
    self.categories.forEach(cat => {
      cat.settings.forEach(s => {
        s.value.subscribe(v => { s.dirty(v !== s.original); });
      });
    });

    self.savedMsg = ko.observable('');
    self.saving   = ko.observable(false);

    self.saveAll = function () {
      self.saving(true);
      setTimeout(() => {
        self.categories.forEach(cat => {
          cat.settings.forEach(s => {
            if (s.dirty()) {
              settingService.updateSetting(s.settingId, s.value());
              s.original = s.value();
              s.dirty(false);
            }
          });
        });
        self.saving(false);
        self.savedMsg('Settings saved successfully!');
        setTimeout(() => self.savedMsg(''), 3000);
      }, 400);
    };

    self.hasDirty = ko.computed(() =>
      self.categories.some(cat => cat.settings.some(s => s.dirty()))
    );
  }

  return SystemSettingsViewModel;
});
