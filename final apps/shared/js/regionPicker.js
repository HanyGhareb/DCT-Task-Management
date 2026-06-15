/* ── shared/js/regionPicker.js ──────────────────────────────────────────────
   Region Appearance palette picker — the THEME_REGION_* UI shared by every
   app's settings page (Admin System Settings + each module's Module Settings).

   Extracted from Admin's systemSettings.js so the curated palette, the WCAG-AA
   contrast math and the live-preview wiring live in exactly one place. The
   `.rgp-*` markup classes are already in shared/css/platform.css.

   Usage in a settings ViewModel:

     var rp = regionPicker.install(self);   // adds self.region/palette/pickers/contrastInfo
     ...
     // after loading settings, collect the five THEME_REGION_* items into a map
     // of { bg, fg, bColor, bWidth, bStyle } where each is an object holding a
     // `.value` ko.observable, then:
     rp.setRegion(regionItems);             // wires live preview + reveals the panel

   `self.region()` returns that same { bg, fg, bColor, bWidth, bStyle } map so the
   VM's dirty/save logic can include the region items (see Admin allItems()).      */
define(['knockout', 'shared/shell'], function (ko, shell) {
  'use strict';

  /* the five module/system setting keys that drive every region header + border */
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

  /* Install the picker observables + methods onto a settings ViewModel `self`.
     Declares everything up front (so KO `if: region()` reacts) and returns
     { setRegion } to populate the region map once settings have loaded.        */
  function install(self) {
    self.palette      = PALETTE;
    self.borderColors = BORDER_COLORS;
    self.borderWidths = BORDER_WIDTHS;
    self.borderStyles = BORDER_STYLES;
    self.region       = ko.observable(null);   // { bg, fg, bColor, bWidth, bStyle } items
    self.focus        = ko.observable(null);    // THEME_FOCUS_COLOR item (.value)
    self.focusOn      = ko.observable(null);    // FEATURE_FOCUS_HIGHLIGHT item (.value Y/N)
    self.focusLevel   = ko.observable(null);    // THEME_FOCUS_FILL_LEVEL item (.value 0–100)

    self._regionMap = function () {
      var r = self.region();
      var out = r ? {
        THEME_REGION_HEADER_BG:    r.bg.value(),
        THEME_REGION_HEADER_FG:    r.fg.value(),
        THEME_REGION_BORDER_COLOR: r.bColor ? r.bColor.value() : null,
        THEME_REGION_BORDER_WIDTH: r.bWidth ? r.bWidth.value() : null,
        THEME_REGION_BORDER_STYLE: r.bStyle ? r.bStyle.value() : null
      } : {};
      /* fold the focus highlight in so the live preview reflects color + on/off + fill level */
      if (self.focus())      out.THEME_FOCUS_COLOR = self.focus().value();
      if (self.focusOn())    out.FEATURE_FOCUS_HIGHLIGHT = self.focusOn().value();
      if (self.focusLevel()) out.THEME_FOCUS_FILL_LEVEL = self.focusLevel().value();
      return out;
    };
    /* live preview on this browser; permanent for everyone after Save */
    self.previewRegion = function () { shell.applyRegionTheme(self._regionMap()); };

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

    /* ── field-focus highlight (THEME_FOCUS_COLOR + FEATURE_FOCUS_HIGHLIGHT) ──
       Color is chosen with a native <input type="color"> (any color) bound
       straight to self.focus().value; only the on/off flag needs helpers here. */
    /* true when the highlight is enabled (flag missing → enabled, default-on) */
    self.focusEnabled = ko.pureComputed(function () {
      var fo = self.focusOn();
      if (!fo) return true;
      var v = String(fo.value() || '').trim().toLowerCase();
      return !(v === 'n' || v === 'false' || v === '0');
    });
    self.toggleFocusOn = function () {
      var fo = self.focusOn(); if (!fo) return;
      fo.value(self.focusEnabled() ? 'N' : 'Y');
    };

    self.contrastInfo = ko.pureComputed(function () {
      var r = self.region(); if (!r) return null;
      var c = contrast(r.bg.value(), r.fg.value());
      if (c === null) return null;
      return { txt: c.toFixed(1) + ':1 ' + (c >= 4.5 ? 'AA ✓' : '⚠ below AA'), ok: c >= 4.5 };
    });

    return {
      /* regionItems: { bg, fg, bColor?, bWidth?, bStyle? }, each holding a
         `.value` ko.observable. Requires at least bg + fg to show the panel. */
      setRegion: function (regionItems) {
        if (!regionItems || !regionItems.bg || !regionItems.fg) return;
        ['bg', 'fg', 'bColor', 'bWidth', 'bStyle'].forEach(function (k) {
          if (regionItems[k]) regionItems[k].value.subscribe(self.previewRegion);
        });
        self.region(regionItems);
      },
      /* focusItems: { color, flag, level } — each holding a `.value` ko.observable
         (color = THEME_FOCUS_COLOR hex, flag = FEATURE_FOCUS_HIGHLIGHT Y/N,
         level = THEME_FOCUS_FILL_LEVEL 0–100 fill intensity).
         Reveals the focus sub-panel + live-previews on change. Admin-only;
         module Settings VMs never call this, so the panel stays hidden there. */
      setFocus: function (focusItems) {
        if (!focusItems || !focusItems.color) return;
        focusItems.color.value.subscribe(self.previewRegion);
        if (focusItems.flag)  focusItems.flag.value.subscribe(self.previewRegion);
        if (focusItems.level) focusItems.level.value.subscribe(self.previewRegion);
        self.focus(focusItems.color);
        if (focusItems.flag)  self.focusOn(focusItems.flag);
        if (focusItems.level) self.focusLevel(focusItems.level);
      }
    };
  }

  return {
    REGION_KEYS:   REGION_KEYS,
    PALETTE:       PALETTE,
    BORDER_COLORS: BORDER_COLORS,
    BORDER_WIDTHS: BORDER_WIDTHS,
    BORDER_STYLES: BORDER_STYLES,
    contrast:      contrast,
    norm:          norm,
    install:       install
  };
});
