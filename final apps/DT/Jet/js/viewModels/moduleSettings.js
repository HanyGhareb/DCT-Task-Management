define(['knockout', 'services/settingService', 'shared/regionPicker'],
function (ko, settingService, regionPicker) {
  'use strict';

  var REGION_KEYS = regionPicker.REGION_KEYS;

  function ModuleSettingsViewModel() {
    var self = this;

    self.items      = ko.observableArray([]);   // non-region settings
    self.loading    = ko.observable(true);
    self.saving     = ko.observable(false);
    self.successMsg = ko.observable('');
    self.errorMsg   = ko.observable('');

    /* installs self.region/palette/borderColors/pickers/contrastInfo/previewRegion */
    var rp = regionPicker.install(self);

    function makeItem(s) {
      // APEX_JSON omits NULL fields — default what the row binds bare
      if (s.settingValue === undefined)       s.settingValue = null;
      if (s.defaultValue === undefined)       s.defaultValue = null;
      if (s.settingDescription === undefined) s.settingDescription = '';
      if (s.allowedValues === undefined)      s.allowedValues = null;
      var init = s.settingValue !== null ? s.settingValue : s.defaultValue;
      var obs  = ko.observable(init);
      var item = {
        settingId:    s.settingId,
        settingKey:   s.settingKey,
        label:        s.settingLabel || s.settingKey,
        description:  s.settingDescription || '',
        type:         s.valueType || 'TEXT',
        allowed:      s.allowedValues ? s.allowedValues.split('|') : [],
        defaultValue: s.defaultValue,
        isToggle:     (s.valueType === 'BOOLEAN') || /^[YN]$/.test(init || ''),
        value:        obs,
        original:     init,
        dirty:        ko.observable(false),
        isEditable:   'Y'
      };
      item.toggleOn = ko.pureComputed(function () { return obs() === 'Y'; });
      item.flip = function () { obs(obs() === 'Y' ? 'N' : 'Y'); };
      obs.subscribe(function (v) { item.dirty(v !== item.original); });
      return item;
    }

    function load(list) {
      var regionItems = {};
      var keyMap = { THEME_REGION_HEADER_BG: 'bg', THEME_REGION_HEADER_FG: 'fg',
                     THEME_REGION_BORDER_COLOR: 'bColor', THEME_REGION_BORDER_WIDTH: 'bWidth',
                     THEME_REGION_BORDER_STYLE: 'bStyle' };
      var rest = [];
      list.forEach(function (s) {
        var item = makeItem(s);
        if (REGION_KEYS.indexOf(s.settingKey) >= 0) regionItems[keyMap[s.settingKey]] = item;
        else rest.push(item);
      });
      self.items(rest);
      rp.setRegion(regionItems);
    }

    function allItems() {
      var list = self.items().slice();
      var r = self.region();
      if (r) ['bg', 'fg', 'bColor', 'bWidth', 'bStyle'].forEach(function (k) {
        if (r[k]) list.push(r[k]);
      });
      return list;
    }

    self.hasDirty = ko.computed(function () {
      self.region();
      return allItems().some(function (s) { return s.dirty(); });
    });

    self.saveAll = function () {
      var dirty = allItems().filter(function (s) { return s.dirty(); });
      if (!dirty.length) return;
      self.saving(true);
      self.successMsg(''); self.errorMsg('');
      Promise.all(dirty.map(function (s) {
        return settingService.update(s.settingId, s.value());
      })).then(function () {
        dirty.forEach(function (s) { s.original = s.value(); s.dirty(false); });
        self.saving(false);
        self.successMsg('Settings saved successfully.');
        setTimeout(function () { self.successMsg(''); }, 3000);
      }).catch(function (e) {
        self.saving(false);
        self.errorMsg(e && e.message ? e.message : 'Save failed.');
      });
    };

    self.resetDefaults = function () {
      if (!confirm('Reset all settings to defaults?')) return;
      settingService.reset().then(function () {
        return settingService.getAll();
      }).then(function (list) {
        load(list);
        self.successMsg('Settings reset to defaults.');
        setTimeout(function () { self.successMsg(''); }, 3000);
      });
    };

    settingService.getAll().then(function (list) {
      load(list);
      self.loading(false);
    }).catch(function () { self.loading(false); });
  }

  return ModuleSettingsViewModel;
});
