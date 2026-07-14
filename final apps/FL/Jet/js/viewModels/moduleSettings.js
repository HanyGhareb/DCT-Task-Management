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

    // Document-checklist rows (DCT_DOC_REQUIREMENTS). Each row carries TWO
    // switches: required/optional (is_mandatory) and shown/hidden (is_active).
    // A hidden row disappears from the checklist entirely; an optional one is
    // still shown and can be uploaded, but never blocks submission.
    function makeReq(r) {
      var mand = ko.observable(r.isMandatory === 'Y');
      var vis  = ko.observable(r.isActive === 'Y');
      var item = {
        docReqId:  r.docReqId,
        docTypeId: r.docTypeId,
        context:   r.contextCode,
        code:      r.docTypeCode,
        label:     r.docTypeName || r.docTypeCode,
        mandatory: mand,
        visible:   vis,
        origMand:  r.isMandatory === 'Y',
        origVis:   r.isActive === 'Y',
        dirty:     ko.observable(false)
      };
      function recheck() { item.dirty(mand() !== item.origMand || vis() !== item.origVis); }
      item.flip     = function () { mand(!mand()); };
      item.flipVis  = function () { vis(!vis()); };
      mand.subscribe(recheck);
      vis.subscribe(recheck);
      return item;
    }

    // Both checklists are configurable: REGISTRATION (what an applicant must
    // provide) and CONTRACT (what a contract needs before submission).
    self.docReqsContract = ko.observableArray([]);
    self.docTypeCatalog  = ko.observableArray([]);
    self.addRegType      = ko.observable(null);
    self.addConType      = ko.observable(null);
    self.docBusy         = ko.observable(false);

    function loadReqs() {
      return Promise.all([
        flService.getDocRequirementsAdmin('REGISTRATION', true),
        flService.getDocRequirementsAdmin('CONTRACT', true),
        flService.getDocTypeCatalog()
      ]).then(function (rs) {
        self.docReqs((rs[0] || []).map(makeReq));
        self.docReqsContract((rs[1] || []).map(makeReq));
        self.docTypeCatalog(rs[2] || []);
      }).catch(function () { /* sections simply stay empty on error */ });
    }
    loadReqs();

    // Document types not yet on a checklist — the "add document" pickers.
    function availableFor(listObs) {
      return ko.computed(function () {
        var have = listObs().map(function (r) { return r.docTypeId; });
        return self.docTypeCatalog().filter(function (t) { return have.indexOf(t.docTypeId) < 0; });
      });
    }
    self.addRegOptions = availableFor(self.docReqs);
    self.addConOptions = availableFor(self.docReqsContract);

    function addReq(context, typeObs) {
      var id = typeObs();
      if (!id) return;
      self.docBusy(true);
      flService.addDocRequirement({ contextCode: context, docTypeId: Number(id), isMandatory: 'Y' })
        .then(function () { typeObs(null); return loadReqs(); })
        .then(function () {
          self.docBusy(false);
          self.successMsg('Document added to the checklist.');
          setTimeout(function () { self.successMsg(''); }, 3000);
        })
        .catch(function (err) {
          self.docBusy(false);
          self.errorMsg((err && err.message) || 'Could not add the document');
        });
    }
    self.addRegDoc = function () { addReq('REGISTRATION', self.addRegType); };
    self.addConDoc = function () { addReq('CONTRACT',     self.addConType); };

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

    function allReqs() { return self.docReqs().concat(self.docReqsContract()); }

    self.hasDirty = ko.computed(function () {
      self.region();
      var reqDirty = allReqs().some(function (r) { return r.dirty(); });
      return reqDirty || allItems().some(function (s) { return s.dirty(); });
    });

    self.saveAll = function () {
      var dirty     = allItems().filter(function (s) { return s.dirty(); });
      var dirtyReqs = allReqs().filter(function (r) { return r.dirty(); });
      if (!dirty.length && !dirtyReqs.length) return;
      self.saving(true);
      self.successMsg(''); self.errorMsg('');
      var jobs = dirty.map(function (s) {
        return flService.updateSetting(s.settingId, s.value());
      }).concat(dirtyReqs.map(function (r) {
        return flService.patchDocRequirement(r.docReqId, {
          isMandatory: r.mandatory() ? 'Y' : 'N',
          isActive:    r.visible()   ? 'Y' : 'N'
        });
      }));
      Promise.all(jobs).then(function () {
        dirty.forEach(function (s) { s.original = s.value(); s.dirty(false); });
        dirtyReqs.forEach(function (r) {
          r.origMand = r.mandatory(); r.origVis = r.visible(); r.dirty(false);
        });
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
