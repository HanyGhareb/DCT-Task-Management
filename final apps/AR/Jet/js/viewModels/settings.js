define(['knockout', 'services/arService', 'services/settingService', 'shared/i18n', 'shared/toast', 'shared/shell'],
function (ko, arService, settingService, i18n, toast, shell) {
  'use strict';

  function SettingsViewModel() {
    var self = this;
    self.t = i18n.t;

    self.loading  = ko.observable(true);
    self.settings = ko.observableArray([]);

    self.reload = function () {
      self.loading(true);
      settingService.getAll(true).then(function (items) {
        self.settings(items.map(function (s) {
          s._value = ko.observable(s.value);
          s._saving = ko.observable(false);
          return s;
        }));
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };

    self.save = function (s) {
      s._saving(true);
      settingService.update(s.key, s._value()).then(function (res) {
        s._saving(false);
        if (res && res.skipped) { toast.info('API key unchanged (enter a new key to replace it)'); return; }
        toast.success(s.label + ' saved');
        if (s.key === 'THEME_BRAND_COLOR') { shell.applyBrand(s._value()); }
      }).catch(function (err) {
        s._saving(false);
        toast.error((err && err.message) || 'Save failed');
      });
    };

    self.reload();
  }

  SettingsViewModel.prototype = {};
  return SettingsViewModel;
});
