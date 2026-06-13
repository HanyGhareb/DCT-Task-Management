/**
 * settings.js — Module Settings, grouped into regions with per-region save.
 *
 * - Regions: AI Provider & Models / AI Processing & Review Gate /
 *   File Handling / Defaults & Appearance (+ trailing Other for new keys).
 * - Dirty tracking per field (_value vs _orig); a region's Save sends only
 *   its changed settings, then refreshes the inline audit line locally.
 * - AI providers live in DCT_AR_AI_PROVIDERS and are managed in the
 *   Manage Providers popup; the AI_PROVIDER setting selects the active code.
 */
define(['knockout', 'services/settingService', 'services/authService',
        'shared/i18n', 'shared/toast', 'shared/shell', 'shared/regionPicker'],
function (ko, settingService, authService, i18n, toast, shell, regionPicker) {
  'use strict';

  var REGION_DEFS = [
    { id: 'ai',       icon: '🤖', titleKey: 'set.regionAi',
      keys: ['AI_PROVIDER'] },
    { id: 'review',   icon: '⚙️', titleKey: 'set.regionReview',
      keys: ['AUTO_CLASSIFY_ON_UPLOAD', 'REQUIRE_HUMAN_REVIEW', 'MIN_CONFIDENCE_AUTOCONFIRM'] },
    { id: 'files',    icon: '📁', titleKey: 'set.regionFiles',
      keys: ['ENABLE_ALT_FILE_NAME', 'ALT_FILE_NAME_FORMAT', 'MAX_FILE_SIZE_MB'] },
    { id: 'defaults', icon: '🎨', titleKey: 'set.regionDefaults',
      keys: ['DEFAULT_CURRENCY', 'EVENT_CODE_PREFIX', 'THEME_BRAND_COLOR',
             'THEME_REGION_HEADER_BG', 'THEME_REGION_HEADER_FG',
             'THEME_REGION_BORDER_COLOR', 'THEME_REGION_BORDER_WIDTH',
             'THEME_REGION_BORDER_STYLE'] }
  ];

  function asStr(v) { return v === null || v === undefined ? '' : String(v); }

  function nowStamp() {
    var d = new Date(), p = function (n) { return (n < 10 ? '0' : '') + n; };
    return d.getFullYear() + '-' + p(d.getMonth() + 1) + '-' + p(d.getDate())
         + ' ' + p(d.getHours()) + ':' + p(d.getMinutes());
  }

  function SettingsViewModel() {
    var self = this;
    self.t = i18n.t;

    var u = authService.getCurrentUser() || {};
    var currentUser = u.username || u.userName || u.displayName || '';

    self.loading = ko.observable(true);
    self.regions = ko.observableArray([]);

    /* Region Appearance palette picker — installs self.region/palette/pickers/
       contrastInfo; the five THEME_REGION_* keys render in the panel inside the
       "Defaults & Appearance" region instead of as plain rows, but stay in that
       region's settings array so its per-region Save still persists them. */
    var rp = regionPicker.install(self);
    var REGION_KEY_MAP = {
      THEME_REGION_HEADER_BG: 'bg', THEME_REGION_HEADER_FG: 'fg',
      THEME_REGION_BORDER_COLOR: 'bColor', THEME_REGION_BORDER_WIDTH: 'bWidth',
      THEME_REGION_BORDER_STYLE: 'bStyle'
    };

    /* ── AI provider registry ─────────────────────────────────────── */
    self.providers         = ko.observableArray([]);
    self.aiProviderSetting = ko.observable(null);

    self.providerOptions = ko.pureComputed(function () {
      var active = self.providers().filter(function (p) { return p.isActive === 'Y'; })
                                   .map(function (p) { return p.code; });
      if (active.length) return active;
      var s = self.aiProviderSetting();
      return s && s.allowed ? s.allowed.split('|') : [];
    });

    self.currentProviderCode = ko.pureComputed(function () {
      var s = self.aiProviderSetting();
      return s ? asStr(s._value()) : '';
    });

    /* ── settings → decorated regions ─────────────────────────────── */
    function decorate(s) {
      s._value = ko.observable(s.value);
      s._orig  = ko.observable(asStr(s.value));
      s._dirty = ko.pureComputed(function () { return asStr(s._value()) !== s._orig(); });
      s._updatedBy = ko.observable(s.updatedBy || '');
      s._updatedAt = ko.observable(s.updatedAt || '');
      return s;
    }

    function buildRegions(items) {
      var byKey = {};
      items.forEach(function (s) { byKey[s.key] = decorate(s); });
      self.aiProviderSetting(byKey.AI_PROVIDER || null);

      /* wire the five THEME_REGION_* keys into the palette picker (sharing each
         setting's own _value observable) and flag them so the view hides their
         plain rows — they remain in the defaults region for dirty/save. */
      var regionItems = {};
      Object.keys(REGION_KEY_MAP).forEach(function (k) {
        if (byKey[k]) { byKey[k]._isRegion = true; regionItems[REGION_KEY_MAP[k]] = { value: byKey[k]._value }; }
      });
      rp.setRegion(regionItems);

      var used = {};
      var regions = REGION_DEFS.map(function (def) {
        var settings = def.keys.filter(function (k) { return byKey[k]; })
                               .map(function (k) { used[k] = true; return byKey[k]; });
        return makeRegion(def.id, def.icon, def.titleKey, settings);
      });

      var rest = items.filter(function (s) { return !used[s.key]; }).map(function (s) { return byKey[s.key]; });
      if (rest.length) regions.push(makeRegion('other', '🔧', 'set.regionOther', rest));

      self.regions(regions.filter(function (r) { return r.settings.length; }));
    }

    function makeRegion(id, icon, titleKey, settings) {
      var region = { id: id, icon: icon, titleKey: titleKey, settings: settings,
                     saving: ko.observable(false) };
      region.dirtyCount = ko.pureComputed(function () {
        return settings.filter(function (s) { return s._dirty(); }).length;
      });
      return region;
    }

    self.reload = function () {
      self.loading(true);
      Promise.all([settingService.getAll(true), settingService.getProviders()])
        .then(function (res) {
          buildRegions(res[0]);
          self.providers(res[1]);
          self.loading(false);
        })
        .catch(function () { self.loading(false); });
    };

    /* ── per-region save (only dirty fields) ──────────────────────── */
    self.saveRegion = function (region) {
      var dirty = region.settings.filter(function (s) { return s._dirty(); });
      if (!dirty.length || region.saving()) return;
      region.saving(true);
      Promise.all(dirty.map(function (s) {
        return settingService.update(s.key, s._value()).then(function (res) {
          if (res && res.skipped) {
            toast.info(self.t('set.keyUnchanged'));
            return;
          }
          s._orig(asStr(s._value()));
          s._updatedBy(currentUser);
          s._updatedAt(nowStamp());
          if (s.key === 'THEME_BRAND_COLOR') shell.applyBrand(s._value());
        });
      })).then(function () {
        region.saving(false);
        toast.success(self.t('set.saved'));
      }).catch(function (err) {
        region.saving(false);
        toast.error((err && err.message) || 'Save failed');
      });
    };

    /* ── Manage Providers popup ───────────────────────────────────── */
    self.apiFormats    = ['ANTHROPIC', 'GEMINI'];
    self.provModalOpen = ko.observable(false);
    self.provEditing   = ko.observable(false);
    self.provSaving    = ko.observable(false);
    self.provForm = {
      id:        ko.observable(null),
      code:      ko.observable(''),
      name:      ko.observable(''),
      apiFormat: ko.observable('ANTHROPIC'),
      baseUrl:   ko.observable(''),
      model:     ko.observable(''),
      apiKey:    ko.observable(''),
      hasKey:    ko.observable('N'),
      isActive:  ko.observable('Y')
    };
    self.provAudit = ko.observable({});

    self.openProviders = function () {
      self.provEditing(false);
      self.provModalOpen(true);
    };
    self.closeProviders = function () { self.provModalOpen(false); };

    function fillForm(p) {
      self.provForm.id(p ? p.id : null);
      self.provForm.code(p ? p.code : '');
      self.provForm.name(p ? p.name : '');
      self.provForm.apiFormat(p ? p.apiFormat : 'ANTHROPIC');
      self.provForm.baseUrl((p && p.baseUrl) || '');
      self.provForm.model(p ? p.model : '');
      self.provForm.apiKey('');
      self.provForm.hasKey(p ? p.hasKey : 'N');
      self.provForm.isActive(p ? p.isActive : 'Y');
      self.provAudit(p ? { createdBy: p.createdBy, createdAt: p.createdAt,
                           updatedBy: p.updatedBy, updatedAt: p.updatedAt } : {});
    }

    self.addProvider  = function () { fillForm(null); self.provEditing(true); };
    self.editProvider = function (p) { fillForm(p); self.provEditing(true); };
    self.cancelProvEdit = function () { self.provEditing(false); };

    function reloadProviders() {
      return settingService.getProviders().then(function (items) { self.providers(items); });
    }

    self.saveProvider = function () {
      var f = self.provForm;
      if (!f.code().trim() || !f.name().trim() || !f.model().trim()) {
        toast.error(self.t('set.provRequired'));
        return;
      }
      var payload = {
        code:      f.code().trim().toUpperCase(),
        name:      f.name().trim(),
        apiFormat: f.apiFormat(),
        baseUrl:   f.baseUrl().trim() || null,
        model:     f.model().trim(),
        isActive:  f.isActive()
      };
      if (f.apiKey().trim()) payload.apiKey = f.apiKey().trim();

      self.provSaving(true);
      var op = f.id() ? settingService.updateProvider(f.id(), payload)
                      : settingService.createProvider(payload);
      op.then(function () {
        return reloadProviders();
      }).then(function () {
        self.provSaving(false);
        self.provEditing(false);
        toast.success(self.t('set.provSaved'));
      }).catch(function () { self.provSaving(false); });
    };

    self.deleteProvider = function (p) {
      if (!window.confirm(self.t('set.provDeleteConfirm').replace('{0}', p.name))) return;
      settingService.deleteProvider(p.id).then(function () {
        return reloadProviders();
      }).then(function () {
        toast.success(self.t('set.provDeleted'));
      }).catch(function () { /* api wrapper already toasts the 400/500 message */ });
    };

    self.isSelectedProvider = function (p) {
      return p.code === self.currentProviderCode();
    };

    self.reload();
  }

  SettingsViewModel.prototype = {};
  return SettingsViewModel;
});
