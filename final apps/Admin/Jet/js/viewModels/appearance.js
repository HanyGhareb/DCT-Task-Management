define(['knockout', 'services/themeService', 'services/settingService', 'shared/regionPicker'],
function (ko, themeService, settingService, regionPicker) {
  'use strict';

  /* ── Visual definitions for each theme ───────────────────────────────
     These values drive the mini-shell preview rendered in the picker.
     They deliberately mirror the CSS variable values in themes.css.     */
  const THEME_DEFS = [
    {
      id:          'corporate',
      name:        'i-Finance Corporate',
      desc:        'Dark header with Oracle red brand identity — the signature i-Finance professional look',
      /* preview colours */
      headerBg:    '#1d1d1f',
      headerText:  '#ffffff',
      sidebarBg:   '#f5f5f5',
      contentBg:   '#fafafa',
      cardBg:      '#ffffff',
      tableHeadBg: '#f5f5f5',
      activeBg:    '#fff3f0',
      activeColor: '#C74634',
      accent:      '#C74634',
      textColor:   '#1d1d1f',
      border:      '#e0e0e0',
    },
    {
      id:          'redwood',
      name:        'Oracle Redwood',
      desc:        'Clean white navigation following Oracle Fusion Redwood design guidelines — blue primary actions',
      /* preview colours */
      headerBg:    '#ffffff',
      headerText:  '#201e1c',
      sidebarBg:   '#f8f8f8',
      contentBg:   '#f4f4f4',
      cardBg:      '#ffffff',
      tableHeadBg: '#f4f4f4',
      activeBg:    '#ddeeff',
      activeColor: '#0572CE',
      accent:      '#0572CE',
      textColor:   '#201e1c',
      border:      '#dde3ea',
    },
    {
      id:          'midnight',
      name:        'Midnight Dark',
      desc:        'Full dark mode optimised for low-light environments and extended screen time',
      /* preview colours */
      headerBg:    '#10101e',
      headerText:  '#dde0f0',
      sidebarBg:   '#141424',
      contentBg:   '#0e0e1c',
      cardBg:      '#1a1a2e',
      tableHeadBg: '#141424',
      activeBg:    'rgba(90,180,255,0.10)',
      activeColor: '#5ab4ff',
      accent:      '#5ab4ff',
      textColor:   '#dde0f0',
      border:      '#252538',
    },
    {
      id:          'vault',
      name:        'Vault Dark',
      desc:        'The security-section design as a full platform theme — GitHub-dark surfaces with the signature amber accent',
      /* preview colours — mirrors the --vault-* tokens */
      headerBg:    '#090C10',
      headerText:  '#E6EDF3',
      sidebarBg:   '#0D1117',
      contentBg:   '#0D1117',
      cardBg:      '#161B22',
      tableHeadBg: '#161B22',
      activeBg:    'rgba(240,136,62,0.13)',
      activeColor: '#F0883E',
      accent:      '#F0883E',
      textColor:   '#E6EDF3',
      border:      '#30363D',
    },
  ];

  function AppearanceViewModel() {
    const self = this;

    self.themes        = THEME_DEFS;
    self.selectedTheme = ko.observable(themeService.getCurrent());
    self.savedTheme    = ko.observable(themeService.getCurrent());
    self.saving        = ko.observable(false);
    self.savedMsg      = ko.observable('');
    self.compactMode      = ko.observable(false);
    self.animationsEnabled = ko.observable(true);
    self.appearanceSettings = ko.observableArray([]);
    self.loadingSettings = ko.observable(true);
    self.errorMsg = ko.observable('');
    var REGION_KEYS = regionPicker.REGION_KEYS;
    var FOCUS_KEYS = ['THEME_FOCUS_COLOR', 'FEATURE_FOCUS_HIGHLIGHT', 'THEME_FOCUS_FILL_LEVEL'];
    var rp = regionPicker.install(self);

    function makeItem(s) {
      var value = ko.observable(s.settingValue);
      var item = {
        settingKey: s.settingKey,
        description: s.description,
        isEditable: s.isEditable,
        isNumber: s.settingType === 'NUMBER',
        isToggle: s.settingType === 'BOOLEAN',
        value: value,
        original: s.settingValue,
        dirty: ko.observable(false)
      };
      item.toggleOn = ko.pureComputed(function () { return value() === 'Y'; });
      item.flip = function () { if (item.isEditable !== 'N') value(value() === 'Y' ? 'N' : 'Y'); };
      value.subscribe(function (v) { item.dirty(v !== item.original); });
      return item;
    }

    function allSettingItems() {
      var items = self.appearanceSettings().slice();
      var region = self.region();
      if (region) ['bg', 'fg', 'bColor', 'bWidth', 'bStyle'].forEach(function (key) {
        if (region[key]) items.push(region[key]);
      });
      if (self.focus()) items.push(self.focus());
      if (self.focusOn()) items.push(self.focusOn());
      if (self.focusLevel()) items.push(self.focusLevel());
      return items;
    }

    settingService.getSettingsByCategory().then(function (grouped) {
      var regionItems = {}, focusItems = {};
      var remaining = (grouped.APPEARANCE || []).filter(function (setting) {
        if (REGION_KEYS.indexOf(setting.settingKey) >= 0) {
          regionItems[setting.settingKey] = makeItem(setting); return false;
        }
        if (FOCUS_KEYS.indexOf(setting.settingKey) >= 0) {
          focusItems[setting.settingKey] = makeItem(setting); return false;
        }
        return true;
      }).map(makeItem);
      self.appearanceSettings(remaining);
      rp.setRegion({
        bg: regionItems.THEME_REGION_HEADER_BG,
        fg: regionItems.THEME_REGION_HEADER_FG,
        bColor: regionItems.THEME_REGION_BORDER_COLOR,
        bWidth: regionItems.THEME_REGION_BORDER_WIDTH,
        bStyle: regionItems.THEME_REGION_BORDER_STYLE
      });
      rp.setFocus({
        color: focusItems.THEME_FOCUS_COLOR,
        flag: focusItems.FEATURE_FOCUS_HIGHLIGHT,
        level: focusItems.THEME_FOCUS_FILL_LEVEL
      });
    }).catch(function (err) {
      self.errorMsg('Failed to load appearance settings: ' + ((err && err.message) || 'Unknown error'));
    }).then(function () { self.loadingSettings(false); });

    self.isDirty = ko.computed(function () {
      self.appearanceSettings(); self.region(); self.focus();
      return self.selectedTheme() !== self.savedTheme() ||
        allSettingItems().some(function (item) { return item.dirty(); });
    });

    /* Click on a theme card: accepts a theme id string */
    self.selectTheme = function (id) {
      self.selectedTheme(id);
      themeService.apply(id);
    };

    /* Save button: persist to ORDS and apply */
    self.saveAll = function () {
      self.saving(true);
      self.savedMsg('');
      var themeChanged = self.selectedTheme() !== self.savedTheme();
      var dirty = allSettingItems().filter(function (item) {
        return item.dirty() && item.isEditable !== 'N';
      });
      var tasks = dirty.map(function (item) {
        return settingService.updateSetting(item.settingKey, item.value());
      });
      if (themeChanged) tasks.push(themeService.save(self.selectedTheme()));
      Promise.all(tasks)
        .then(function () {
          self.savedTheme(self.selectedTheme());
          dirty.forEach(function (item) { item.original = item.value(); item.dirty(false); });
          self.saving(false);
          self.savedMsg('Appearance settings saved. All users will see the update on next page load.');
          setTimeout(function () { self.savedMsg(''); }, 5000);
        })
        .catch(function (err) {
          self.saving(false);
          self.savedMsg('Save failed: ' + ((err && err.message) || 'Check your connection and try again.'));
        });
    };
    self.saveTheme = self.saveAll;
  }

  return AppearanceViewModel;
});
