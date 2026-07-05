define(['knockout', 'services/flService', 'shared/regionPicker'],
function (ko, flService, regionPicker) {
  'use strict';

  var REGION_KEYS = regionPicker.REGION_KEYS;

  function ModuleSettingsViewModel() {
    var self = this;

    self.loading    = ko.observable(true);
    self.items      = ko.observableArray([]);   // non-region settings (flat, for save)
    self.groups     = ko.observableArray([]);   // same items grouped for display
    self.successMsg = ko.observable('');
    self.docReqs    = ko.observableArray([]);   // registration doc required/optional (US-10)
    self.photoItem  = ko.observable(null);      // PHOTO_REQUIRED setting, rendered in the docs section

    // Ordered group definitions; a setting falls into the first group it matches,
    // anything unmatched lands in "General" so nothing is ever hidden.
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

    // Registration document required/optional rows (drive DCT_DOC_REQUIREMENTS).
    function makeReq(r) {
      var obs  = ko.observable(r.isMandatory === 'Y');
      var item = {
        docReqId: r.docReqId,
        code:     r.docTypeCode,
        label:    r.docTypeName || r.docTypeCode,
        mandatory: obs,
        original:  r.isMandatory === 'Y',
        dirty:     ko.observable(false)
      };
      item.flip = function () { obs(!obs()); };
      obs.subscribe(function (v) { item.dirty(v !== item.original); });
      return item;
    }

    flService.getDocRequirements('REGISTRATION').then(function (rows) {
      self.docReqs((rows || []).map(makeReq));
    }).catch(function () { /* section simply stays empty on error */ });

    flService.getSettings().then(function (rows) {
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
      // PHOTO_REQUIRED is shown inside the Registration Documents section, not
      // the generic grid (kept in self.items so saveAll still persists it).
      self.photoItem(rest.filter(function (i) { return i.settingKey === 'PHOTO_REQUIRED'; })[0] || null);
      self.groups(groupItems(rest.filter(function (i) { return i.settingKey !== 'PHOTO_REQUIRED'; })));
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
      var reqDirty = self.docReqs().some(function (r) { return r.dirty(); });
      return reqDirty || allItems().some(function (s) { return s.dirty(); });
    });

    self.saveAll = function () {
      var dirty     = allItems().filter(function (s) { return s.dirty(); });
      var dirtyReqs = self.docReqs().filter(function (r) { return r.dirty(); });
      if (!dirty.length && !dirtyReqs.length) return;
      self.saving(true);
      self.successMsg(''); self.errorMsg('');
      var jobs = dirty.map(function (s) {
        return flService.updateSetting(s.settingId, s.value());
      }).concat(dirtyReqs.map(function (r) {
        return flService.updateDocRequirement(r.docReqId, r.mandatory() ? 'Y' : 'N');
      }));
      Promise.all(jobs).then(function () {
        dirty.forEach(function (s) { s.original = s.value(); s.dirty(false); });
        dirtyReqs.forEach(function (r) { r.original = r.mandatory(); r.dirty(false); });
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
