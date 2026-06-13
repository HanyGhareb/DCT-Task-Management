define(['knockout', 'services/settingService'], function (ko, settingService) {
  'use strict';

  function SystemSettingsViewModel() {
    var self = this;

    self.loading    = ko.observable(true);
    self.errorMsg   = ko.observable('');
    self.categories = ko.observableArray([]);
    self.savedMsg   = ko.observable('');
    self.saving     = ko.observable(false);

    settingService.getSettingsByCategory().then(function (grouped) {
      self.categories(Object.keys(grouped).map(function (cat) {
        return {
          label: cat,
          settings: grouped[cat].map(function (s) {
            var obs  = ko.observable(s.settingValue);
            var item = {
              settingKey:  s.settingKey,
              description: s.description,
              isEditable:  s.isEditable,
              // enh-2: BOOLEAN settings (FEATURE_* flags) render as switches
              isToggle:    s.settingType === 'BOOLEAN' ||
                           /^[YN]$/.test(s.settingValue || '') && cat === 'FEATURES',
              value:       obs,
              original:    s.settingValue,
              dirty:       ko.observable(false),
            };
            item.toggleOn = ko.pureComputed(function () { return obs() === 'Y'; });
            item.flip = function () { obs(obs() === 'Y' ? 'N' : 'Y'); };
            obs.subscribe(function (v) { item.dirty(v !== item.original); });
            return item;
          }),
        };
      }));
      self.loading(false);
    }).catch(function (err) {
      self.errorMsg('Failed to load settings: ' + ((err && err.message) || 'Unknown error'));
      self.loading(false);
    });

    self.hasDirty = ko.computed(function () {
      return self.categories().some(function (cat) {
        return cat.settings.some(function (s) { return s.dirty(); });
      });
    });

    self.saveAll = function () {
      self.saving(true);
      self.savedMsg('');
      var dirty = [];
      self.categories().forEach(function (cat) {
        cat.settings.forEach(function (s) {
          if (s.dirty() && s.isEditable === 'Y') dirty.push(s);
        });
      });
      if (!dirty.length) { self.saving(false); return; }

      Promise.all(dirty.map(function (s) {
        return settingService.updateSetting(s.settingKey, s.value());
      })).then(function () {
        dirty.forEach(function (s) { s.original = s.value(); s.dirty(false); });
        self.saving(false);
        self.savedMsg('Settings saved successfully!');
        setTimeout(function () { self.savedMsg(''); }, 3000);
      }).catch(function (err) {
        self.saving(false);
        self.savedMsg('Save failed: ' + ((err && err.message) || 'Unknown error'));
      });
    };
  }

  return SystemSettingsViewModel;
});
