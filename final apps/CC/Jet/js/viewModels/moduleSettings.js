define(['knockout', 'services/ccService', 'shared/regionPicker'],
function (ko, ccService, regionPicker) {
  'use strict';

  var REGION_KEYS = regionPicker.REGION_KEYS;

  function ModuleSettingsViewModel() {
    var self = this;

    self.loading    = ko.observable(true);
    self.items      = ko.observableArray([]);   // non-region settings
    self.successMsg = ko.observable('');
    self.errorMsg   = ko.observable('');
    self.saving     = ko.observable(false);

    /* installs self.region/palette/borderColors/pickers/contrastInfo/previewRegion */
    var rp = regionPicker.install(self);

    function makeItem(s) {
      var obs  = ko.observable(s.value);
      var item = {
        settingId:   s.settingId,
        settingKey:  s.key,
        label:       s.label || s.key,
        description: s.description || '',
        type:        s.type || 'TEXT',
        allowed:     (s.allowed || '').split(/[|,]/).filter(Boolean),
        isToggle:    (s.type === 'BOOLEAN') || /^[YN]$/.test(s.value || ''),
        value:       obs,
        original:    s.value,
        dirty:       ko.observable(false),
        isEditable:  'Y'
      };
      item.toggleOn = ko.pureComputed(function () { return obs() === 'Y'; });
      item.flip = function () { obs(obs() === 'Y' ? 'N' : 'Y'); };
      obs.subscribe(function (v) { item.dirty(v !== item.original); });
      return item;
    }

    ccService.getSettings().then(function (rows) {
      var regionItems = {};
      var keyMap = { THEME_REGION_HEADER_BG: 'bg', THEME_REGION_HEADER_FG: 'fg',
                     THEME_REGION_BORDER_COLOR: 'bColor', THEME_REGION_BORDER_WIDTH: 'bWidth',
                     THEME_REGION_BORDER_STYLE: 'bStyle' };
      var rest = [];
      rows.forEach(function (s) {
        var item = makeItem(s);
        if (REGION_KEYS.indexOf(s.key) >= 0) regionItems[keyMap[s.key]] = item;
        else rest.push(item);
      });
      self.items(rest);
      rp.setRegion(regionItems);
      self.loading(false);
    }).catch(function (err) {
      self.errorMsg((err && err.message) || 'Failed to load settings');
      self.loading(false);
    });

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
