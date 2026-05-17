define(['knockout', 'services/settingService'],
function (ko, settingService) {
  'use strict';

  function ModuleSettingsViewModel() {
    var self = this;

    self.settings   = ko.observableArray([]);
    self.loading    = ko.observable(true);
    self.saving     = ko.observable(false);
    self.successMsg = ko.observable('');
    self.error      = ko.observable('');

    // Editable values map: settingId → ko.observable(value)
    self.editValues = {};

    function _buildEditable(list) {
      var ev = {};
      list.forEach(function(s) {
        ev[s.settingId] = ko.observable(s.settingValue !== null ? s.settingValue : s.defaultValue);
      });
      self.editValues = ev;
      self.settings(list);
    }

    self.getAllowedValues = function (setting) {
      return setting.allowedValues ? setting.allowedValues.split('|') : [];
    };

    self.saveAll = function () {
      self.error(''); self.saving(true);
      var keys = Object.keys(self.editValues);
      var promises = keys.map(function(sid) {
        return settingService.update(parseInt(sid), self.editValues[sid]());
      });
      Promise.all(promises).then(function () {
        self.saving(false);
        self.successMsg('Settings saved successfully.');
      }).catch(function(e) {
        self.saving(false);
        self.error(e && e.message ? e.message : 'Save failed.');
      });
    };

    self.resetDefaults = function () {
      if (!confirm('Reset all settings to defaults?')) return;
      settingService.reset().then(function () {
        return settingService.getAll();
      }).then(function (list) {
        _buildEditable(list);
        self.successMsg('Settings reset to defaults.');
      });
    };

    settingService.getAll().then(function (list) {
      _buildEditable(list);
      self.loading(false);
    }).catch(function () { self.loading(false); });
  }

  return ModuleSettingsViewModel;
});
