/**
 * appearance.js — Fusion BPM app skin picker (WF_ADMIN / SYS_ADMIN).
 *
 * Clicking a card previews the skin instantly (data-bpm-skin on <body>);
 * Save persists it to the BPM module setting THEME_SKIN so it applies to
 * every BPM user at their next boot. Leaving without saving is harmless —
 * themeService.sync() restores the saved skin on the next app start.
 */
define(['knockout', 'services/themeService', 'services/settingService', 'shared/i18n'],
function (ko, themeService, settingService, i18n) {
  'use strict';

  function AppearanceViewModel() {
    var self = this;
    self.t = i18n.t;

    // preview swatches per skin — mirrors css/skins.css tokens
    self.themes = [
      { id: 'night',   nameKey: 'ap.night',   descKey: 'ap.night.desc',
        pv: { chrome: '#120E15', side: '#120E15', bg: '#17131A', card: '#1F1A24', accent: '#E0637E', line: '#2E2636', text: '#F2EDEF' } },
      { id: 'redwood', nameKey: 'ap.redwood', descKey: 'ap.redwood.desc',
        pv: { chrome: '#312D2A', side: '#FFFFFF', bg: '#FBF9F8', card: '#FFFFFF', accent: '#C74634', line: '#E4E1DC', text: '#161513' } },
      { id: 'diwan',   nameKey: 'ap.diwan',   descKey: 'ap.diwan.desc',
        pv: { chrome: '#5A2230', side: '#F3EEE5', bg: '#F8F5EF', card: '#FFFFFF', accent: '#A8823C', line: '#E5DCD2', text: '#2A1E22' } }
    ];

    self.selected   = ko.observable(themeService.getCurrent());
    self.savedValue = ko.observable(themeService.getCurrent());
    self.saving     = ko.observable(false);
    self.message    = ko.observable('');
    self.error      = ko.observable('');
    self.dirty      = ko.computed(function () { return self.selected() !== self.savedValue(); });

    // authoritative current value from the DB
    settingService.getByKey('THEME_SKIN').then(function (s) {
      if (s && s.value) {
        var v = String(s.value).toLowerCase();
        if (themeService.VALID.indexOf(v) >= 0) {
          self.savedValue(v);
          if (!self.dirty()) { self.selected(v); }
        }
      }
    }).catch(function () {});

    self.pick = function (th) {
      self.message('');
      self.selected(th.id);
      themeService.apply(th.id);          // live preview, whole app
    };

    self.save = function () {
      if (self.saving()) { return; }
      self.saving(true); self.error(''); self.message('');
      themeService.save(self.selected()).then(function () {
        self.savedValue(self.selected());
        self.message(self.t('ap.saved'));
      }).catch(function (e) {
        self.error((e && e.message) || self.t('ap.saveFailed'));
      }).finally(function () { self.saving(false); });
    };

    self.revert = function () {
      self.selected(self.savedValue());
      themeService.apply(self.savedValue());
      self.message('');
    };
  }

  return AppearanceViewModel;
});
