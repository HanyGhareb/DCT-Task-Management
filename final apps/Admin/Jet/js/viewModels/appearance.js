define(['knockout', 'services/themeService'], function (ko, themeService) {
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

    self.isDirty = ko.computed(function () {
      return self.selectedTheme() !== self.savedTheme();
    });

    /* Click on a theme card: accepts a theme id string */
    self.selectTheme = function (id) {
      self.selectedTheme(id);
      themeService.apply(id);
    };

    /* Save button: persist to ORDS and apply */
    self.saveTheme = function () {
      self.saving(true);
      self.savedMsg('');
      themeService.save(self.selectedTheme())
        .then(function () {
          self.savedTheme(self.selectedTheme());
          self.saving(false);
          var name = (THEME_DEFS.find(function (t) { return t.id === self.selectedTheme(); }) || {}).name || self.selectedTheme();
          self.savedMsg('"' + name + '" theme saved. All users will see the update on next page load.');
          setTimeout(function () { self.savedMsg(''); }, 5000);
        })
        .catch(function (err) {
          self.saving(false);
          self.savedMsg('Save failed: ' + ((err && err.message) || 'Check your connection and try again.'));
        });
    };
  }

  return AppearanceViewModel;
});
