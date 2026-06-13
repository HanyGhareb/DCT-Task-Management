define(['knockout', 'services/settingService', 'shared/shell'],
function (ko, settingService, shell) {
  'use strict';

  /* ── Region Appearance (THEME_REGION_*, 2026-06-13) ─────────────────────
     The five keys render in a dedicated palette-picker panel instead of the
     generic per-category rows; saving goes through the same PUT /settings/:key
     upsert. Live preview via shell.applyRegionTheme on every change. */
  var REGION_KEYS = ['THEME_REGION_HEADER_BG', 'THEME_REGION_HEADER_FG',
                     'THEME_REGION_BORDER_COLOR', 'THEME_REGION_BORDER_WIDTH',
                     'THEME_REGION_BORDER_STYLE'];

  /* curated palette — every chip is an accessible fill/font pair */
  var PALETTE = [
    { nm: 'Slate',      bg: '#334155', fg: '#FFFFFF' },
    { nm: 'Navy',       bg: '#1E3A8A', fg: '#FFFFFF' },
    { nm: 'Teal',       bg: '#00695C', fg: '#FFFFFF' },
    { nm: 'Forest',     bg: '#1B5E20', fg: '#FFFFFF' },
    { nm: 'Maroon',     bg: '#8E2A24', fg: '#FFFFFF' },
    { nm: 'Plum',       bg: '#5B2C6F', fg: '#FFFFFF' },
    { nm: 'Charcoal',   bg: '#1D1D1F', fg: '#FFFFFF' },
    { nm: 'Soft Gray',  bg: '#F1F5F9', fg: '#334155' },
    { nm: 'Soft Blue',  bg: '#E3F2FD', fg: '#0D47A1' },
    { nm: 'Soft Green', bg: '#E8F5E9', fg: '#1B5E20' },
    { nm: 'Soft Amber', bg: '#FFF3E0', fg: '#7A4F09' }
  ];
  var BORDER_COLORS = ['#E3E6EB', '#334155', '#1E3A8A', '#00695C', '#1B5E20', '#8E2A24'];
  var BORDER_WIDTHS = ['1px', '1.5px', '2px', '3px', '0'];
  var BORDER_STYLES = ['solid', 'dashed', 'dotted', 'double'];

  function lum(hex) {
    var h = String(hex || '').replace('#', '');
    if (!/^[0-9a-fA-F]{6}$/.test(h)) return null;
    var n = parseInt(h, 16);
    var a = [n >> 16 & 255, n >> 8 & 255, n & 255].map(function (v) {
      v /= 255; return v <= .03928 ? v / 12.92 : Math.pow((v + .055) / 1.055, 2.4);
    });
    return .2126 * a[0] + .7152 * a[1] + .0722 * a[2];
  }
  function contrast(bg, fg) {
    var l1 = lum(bg), l2 = lum(fg);
    if (l1 === null || l2 === null) return null;
    return (Math.max(l1, l2) + .05) / (Math.min(l1, l2) + .05);
  }
  function norm(hex) { return String(hex || '').trim().toUpperCase(); }

  function SystemSettingsViewModel() {
    var self = this;

    self.loading    = ko.observable(true);
    self.errorMsg   = ko.observable('');
    self.categories = ko.observableArray([]);
    self.savedMsg   = ko.observable('');
    self.saving     = ko.observable(false);

    self.palette      = PALETTE;
    self.borderColors = BORDER_COLORS;
    self.borderWidths = BORDER_WIDTHS;
    self.borderStyles = BORDER_STYLES;
    self.region       = ko.observable(null);   // { bg, fg, bColor, bWidth, bStyle } items

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
        var r = {
          bg:     regionItems.THEME_REGION_HEADER_BG,
          fg:     regionItems.THEME_REGION_HEADER_FG,
          bColor: regionItems.THEME_REGION_BORDER_COLOR,
          bWidth: regionItems.THEME_REGION_BORDER_WIDTH,
          bStyle: regionItems.THEME_REGION_BORDER_STYLE,
        };
        /* live preview on this browser; permanent for everyone after Save */
        Object.keys(r).forEach(function (k) {
          if (r[k]) r[k].value.subscribe(function () { self.previewRegion(); });
        });
        self.region(r);
      }
      self.loading(false);
    }).catch(function (err) {
      self.errorMsg('Failed to load settings: ' + ((err && err.message) || 'Unknown error'));
      self.loading(false);
    });

    self._regionMap = function () {
      var r = self.region();
      if (!r) return {};
      return {
        THEME_REGION_HEADER_BG:     r.bg.value(),
        THEME_REGION_HEADER_FG:     r.fg.value(),
        THEME_REGION_BORDER_COLOR:  r.bColor ? r.bColor.value() : null,
        THEME_REGION_BORDER_WIDTH:  r.bWidth ? r.bWidth.value() : null,
        THEME_REGION_BORDER_STYLE:  r.bStyle ? r.bStyle.value() : null,
      };
    };
    self.previewRegion = function () { shell.applyRegionTheme(self._regionMap()); };

    /* palette + border pickers (header buttons / chips) */
    self.pickPal = function (p) {
      var r = self.region(); if (!r) return;
      r.bg.value(p.bg); r.fg.value(p.fg);
    };
    self.isPal = function (p) {
      var r = self.region();
      return !!r && norm(r.bg.value()) === norm(p.bg) && norm(r.fg.value()) === norm(p.fg);
    };
    self.pickBorderColor = function (c) {
      var r = self.region(); if (r && r.bColor) r.bColor.value(c);
    };
    self.isBorderColor = function (c) {
      var r = self.region();
      return !!(r && r.bColor) && norm(r.bColor.value()) === norm(c);
    };
    self.pickWidth = function (w) {
      var r = self.region(); if (r && r.bWidth) r.bWidth.value(w);
    };
    self.pickStyle = function (s) {
      var r = self.region(); if (r && r.bStyle) r.bStyle.value(s);
    };

    self.contrastInfo = ko.pureComputed(function () {
      var r = self.region(); if (!r) return null;
      var c = contrast(r.bg.value(), r.fg.value());
      if (c === null) return null;
      return { txt: c.toFixed(1) + ':1 ' + (c >= 4.5 ? 'AA ✓' : '⚠ below AA'), ok: c >= 4.5 };
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
