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
      // APEX_JSON omits NULL fields — default every bound key first
      s = Object.assign({
        settingValue: null, settingLabel: '', settingDescription: '',
        allowedValues: null, defaultValue: null, effectiveDate: null
      }, s);
      var obs  = ko.observable(s.settingValue);
      var dObs = ko.observable(s.effectiveDate);
      var item = {
        settingId:    s.settingId,
        settingKey:   s.settingKey,
        label:        s.settingLabel || s.settingKey,
        description:  s.settingDescription || '',
        type:         s.valueType || 'TEXT',
        allowed:      s.allowedValues ? s.allowedValues.split('|') : [],
        defaultValue: s.defaultValue,
        isToggle:     (s.valueType === 'BOOLEAN') || /^[YN]$/.test(s.settingValue || ''),
        value:        obs,
        editDate:     dObs,
        original:     s.settingValue,
        originalDate: s.effectiveDate,
        dirty:        ko.observable(false),
        isEditable:   'Y'
      };
      item.toggleOn = ko.pureComputed(function () { return obs() === 'Y'; });
      item.flip = function () { obs(obs() === 'Y' ? 'N' : 'Y'); };
      function recompute() { item.dirty(obs() !== item.original || dObs() !== item.originalDate); }
      obs.subscribe(recompute);
      dObs.subscribe(recompute);
      return item;
    }

    function load(list) {
      var regionItems = {};
      var keyMap = { THEME_REGION_HEADER_BG: 'bg', THEME_REGION_HEADER_FG: 'fg',
                     THEME_REGION_BORDER_COLOR: 'bColor', THEME_REGION_BORDER_WIDTH: 'bWidth',
                     THEME_REGION_BORDER_STYLE: 'bStyle' };
      var rest = [];
      (list || []).forEach(function (s) {
        var item = makeItem(s);
        if (REGION_KEYS.indexOf(s.settingKey) >= 0) regionItems[keyMap[s.settingKey]] = item;
        else rest.push(item);
      });
      self.items(rest);
      self.groups(groupItems(rest));
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
      // light numeric guard (toggles/selects are constrained by their controls)
      var bad = dirty.filter(function (s) {
        return s.type === 'NUMBER' && s.value() !== null && s.value() !== '' && isNaN(parseFloat(s.value()));
      });
      if (bad.length) { self.errorMsg('Numeric setting "' + bad[0].settingKey + '" must be a number.'); return; }

      self.saving(true);
      self.successMsg(''); self.errorMsg('');
      Promise.all(dirty.map(function (s) {
        return settingService.update(s.settingId, s.value(), s.editDate ? s.editDate() : null);
      })).then(function () {
        dirty.forEach(function (s) {
          s.original = s.value();
          if (s.editDate) s.originalDate = s.editDate();
          s.dirty(false);
        });
        self.saving(false);
        self.successMsg('Settings saved successfully.');
        setTimeout(function () { self.successMsg(''); }, 3000);
      }).catch(function (err) {
        self.saving(false);
        self.errorMsg((err && err.message) || 'Save failed.');
      });
    };

    self.resetDefault = function (s) {
      if (!confirm('Reset "' + s.label + '" to default value "' + s.defaultValue + '"?')) return;
      settingService.resetToDefault(s.settingId).then(function () {
        self.successMsg('Setting reset to default.');
        setTimeout(function () { self.successMsg(''); }, 3000);
        _load();
      }).catch(function (err) { self.errorMsg((err && err.message) || 'Reset failed.'); });
    };

    function _load() {
      settingService.getAll().then(function (list) {
        load(list);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    _load();
  }

  return ModuleSettingsViewModel;
});
