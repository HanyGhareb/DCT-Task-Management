define(['knockout', 'services/authService', 'services/hrService',
        'services/notificationService', 'shared/regionPicker'],
function (ko, authService, hrService, notifService, regionPicker) {
  'use strict';

  var REGION_KEYS = regionPicker.REGION_KEYS;

  function ModuleSettingsViewModel() {
    var self = this;

    self.isAdmin    = authService.isHrAdmin();
    self.loading    = ko.observable(true);
    self.saving     = ko.observable(false);
    self.successMsg = ko.observable('');
    self.errorMsg   = ko.observable('');
    self.saved      = ko.observable(false);       // dev-tools reset confirmation
    self.items      = ko.observableArray([]);     // non-region settings

    /* installs self.region/palette/borderColors/pickers/contrastInfo/previewRegion */
    var rp = regionPicker.install(self);

    self.groups = ko.observableArray([]);   // settings grouped into themed cards
    var GROUP_DEFS = [
      { titleKey: 'set.grp.ai',       test: function (k) { return /^AI_/.test(k); } },
      { titleKey: 'set.grp.selfreg',  keys: ['ALLOW_SELF_REGISTRATION', 'FEATURE_FL_PORTAL',
              'REG_OTP_EXPIRY_MIN', 'REG_OTP_MAX_ATTEMPTS', 'REG_OTP_DEV_ECHO', 'DUP_BLOCK_ON_EXACT'] },
      { titleKey: 'set.grp.uploads',  test: function (k) { return /UPLOAD/.test(k); } },
      { titleKey: 'set.grp.notif',    test: function (k) { return /NOTIF/.test(k); } },
      { titleKey: 'set.grp.features', test: function (k) { return /^FEATURE_/.test(k); } }
    ];
    function groupItems(list) {
      var used = {}, groups = [];
      GROUP_DEFS.forEach(function (def) {
        var gi = list.filter(function (it) {
          if (used[it.settingKey]) return false;
          var hit = def.keys ? def.keys.indexOf(it.settingKey) >= 0
                             : (def.test && def.test(it.settingKey));
          if (hit) used[it.settingKey] = true;
          return hit;
        });
        if (gi.length) groups.push({ titleKey: def.titleKey, items: gi });
      });
      var leftover = list.filter(function (it) { return !used[it.settingKey]; });
      if (leftover.length) groups.push({ titleKey: 'set.grp.general', items: leftover });
      return groups;
    }

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

    hrService.getSettings().then(function (rows) {
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
      self.groups(groupItems(rest));
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
        return hrService.updateSetting(s.settingId, s.value());
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

    /* ── dev tool: reset mock data (admin only) ───────────────────────── */
    self.apiMode = ko.observable(!!window._hrConfig_apiBase);
    self.resetData = function () {
      if (!confirm('Reset all mock HR data to defaults?')) return;
      hrService.reset();
      notifService.reset();
      self.saved(true);
      setTimeout(function () { self.saved(false); }, 3000);
    };

    self.moduleInfo = {
      name:    'Human Resources (App 205)',
      version: '1.0.0',
      ords:    '/ords/admin/hr/',
      schema:  'PROD',
      tables:  8,
      views:   6
    };
  }

  return ModuleSettingsViewModel;
});
