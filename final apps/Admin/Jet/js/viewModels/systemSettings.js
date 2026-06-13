define(['knockout', 'services/settingService', 'shared/regionPicker'],
function (ko, settingService, regionPicker) {
  'use strict';

  /* ── Region Appearance (THEME_REGION_*, 2026-06-13) ─────────────────────
     The five keys render in a dedicated palette-picker panel (shared/regionPicker)
     instead of the generic per-category rows; saving goes through the same
     PUT /settings/:key upsert. Live preview via shell.applyRegionTheme on change. */
  var REGION_KEYS = regionPicker.REGION_KEYS;

  function SystemSettingsViewModel() {
    var self = this;

    self.loading    = ko.observable(true);
    self.errorMsg   = ko.observable('');
    self.categories = ko.observableArray([]);
    self.savedMsg   = ko.observable('');
    self.saving     = ko.observable(false);

    /* installs self.region/palette/borderColors/pickers/contrastInfo/previewRegion */
    var rp = regionPicker.install(self);

    function makeItem(s, cat) {
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
    }

    settingService.getSettingsByCategory().then(function (grouped) {
      var regionItems = {};
      self.categories(Object.keys(grouped).map(function (cat) {
        return {
          label: cat,
          settings: grouped[cat].filter(function (s) {
            if (REGION_KEYS.indexOf(s.settingKey) < 0) return true;
            regionItems[s.settingKey] = makeItem(s, cat);
            return false;
          }).map(function (s) { return makeItem(s, cat); }),
        };
      }).filter(function (cat) { return cat.settings.length; }));

      if (regionItems.THEME_REGION_HEADER_BG && regionItems.THEME_REGION_HEADER_FG) {
        rp.setRegion({
          bg:     regionItems.THEME_REGION_HEADER_BG,
          fg:     regionItems.THEME_REGION_HEADER_FG,
          bColor: regionItems.THEME_REGION_BORDER_COLOR,
          bWidth: regionItems.THEME_REGION_BORDER_WIDTH,
          bStyle: regionItems.THEME_REGION_BORDER_STYLE
        });
      }
      self.loading(false);
    }).catch(function (err) {
      self.errorMsg('Failed to load settings: ' + ((err && err.message) || 'Unknown error'));
      self.loading(false);
    });

    function allItems() {
      var list = [];
      self.categories().forEach(function (cat) {
        cat.settings.forEach(function (s) { list.push(s); });
      });
      var r = self.region();
      if (r) ['bg', 'fg', 'bColor', 'bWidth', 'bStyle'].forEach(function (k) {
        if (r[k]) list.push(r[k]);
      });
      return list;
    }

    self.hasDirty = ko.computed(function () {
      self.region();   // re-evaluate once the region panel loads
      return self.categories().length >= 0 && allItems().some(function (s) { return s.dirty(); });
    });

    self.saveAll = function () {
      self.saving(true);
      self.savedMsg('');
      var dirty = allItems().filter(function (s) { return s.dirty() && s.isEditable !== 'N'; });
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
