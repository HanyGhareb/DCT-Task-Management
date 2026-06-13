define(['knockout', 'services/settingService'],
function (ko, settingService) {
  'use strict';

  function ModuleSettingsViewModel() {
    var self = this;

    self.settings = ko.observableArray([]);
    self.loading  = ko.observable(true);
    self.error    = ko.observable('');
    self.success  = ko.observable('');
    self.editingId = ko.observable(null);

    function _toObs(s) {
      // APEX_JSON omits NULL fields — default every bound key or the row's
      // bare KO references throw and kill the whole foreach (rows 2+ vanish)
      s = Object.assign({
        settingValue: null, settingLabel: '', settingDescription: '',
        allowedValues: null, defaultValue: null, effectiveDate: null,
      }, s);
      return Object.assign(s, {
        editValue: ko.observable(s.settingValue),
        editDate:  ko.observable(s.effectiveDate),
      });
    }

    self.startEdit = function (s) { self.editingId(s.settingId); };
    self.cancelEdit = function () { self.editingId(null); _load(); };

    self.saveEdit = function (s) {
      var newVal = s.editValue();
      // Basic value type validation
      if (s.valueType === 'BOOLEAN' && !['Y','N'].includes(newVal)) {
        self.error('Boolean setting must be Y or N.');
        return;
      }
      if (s.valueType === 'NUMBER' && isNaN(parseFloat(newVal)) && newVal !== null && newVal !== '') {
        self.error('Numeric setting must be a number.');
        return;
      }
      if (s.valueType === 'SELECT' && s.allowedValues) {
        var allowed = s.allowedValues.split('|');
        if (!allowed.includes(newVal)) {
          self.error('Value must be one of: ' + s.allowedValues);
          return;
        }
      }
      self.error('');
      settingService.update(s.settingId, newVal, s.editDate()).then(function () {
        self.success('Setting "' + s.settingKey + '" updated.');
        self.editingId(null);
        _load();
      }).catch(function (err) { self.error((err && err.message) || 'Update failed.'); });
    };

    self.resetDefault = function (s) {
      if (!confirm('Reset "' + s.settingLabel + '" to default value "' + s.defaultValue + '"?')) return;
      settingService.resetToDefault(s.settingId).then(function () {
        self.success('Setting reset to default.');
        _load();
      }).catch(function (err) { self.error((err && err.message) || 'Reset failed.'); });
    };

    self.typeClass = function (t) {
      var map = { BOOLEAN:'badge--info', NUMBER:'badge--warning', SELECT:'badge--active', TEXT:'badge--idle' };
      return 'badge ' + (map[t] || 'badge--info');
    };

    function _load() {
      settingService.getAll().then(function (list) {
        self.settings(list.map(_toObs));
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    _load();
  }

  return ModuleSettingsViewModel;
});
