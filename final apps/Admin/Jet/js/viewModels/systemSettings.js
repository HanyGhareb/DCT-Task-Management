define(['knockout', 'services/settingService', 'services/authService'],
function (ko, settingService, authService) {
  'use strict';

  /* ── Region Appearance (THEME_REGION_*, 2026-06-13) ─────────────────────
     The five keys render in a dedicated palette-picker panel (shared/regionPicker)
     instead of the generic per-category rows; saving goes through the same
     PUT /settings/:key upsert. Live preview via shell.applyRegionTheme on change. */
  /* field-focus highlight (26_focus_theme.sql) — pulled out of the generic rows
     and rendered in the Appearance panel beside the region picker. */

  function SystemSettingsViewModel() {
    var self = this;

    self.loading    = ko.observable(true);
    self.errorMsg   = ko.observable('');
    self.categories = ko.observableArray([]);
    self.savedMsg   = ko.observable('');
    self.saving     = ko.observable(false);
    self.cleanupRunning = ko.observable(false);
    self.cleanupMsg     = ko.observable('');
    self.storageHealth  = ko.observable(null);
    self.storageHistory = ko.observable(null);
    self.storageLoading = ko.observable(false);
    self.databaseHealth = ko.observable(null);
    self.healthLoading  = ko.observable(false);
    self.healthRunning  = ko.observable(false);
    self.healthMsg      = ko.observable('');
    self.dataIntegrity  = ko.observable(null);
    self.integrityLoading = ko.observable(false);
    self.integrityRunning = ko.observable(false);
    self.integrityMsg     = ko.observable('');
    self.sqlPerformance   = ko.observable(null);
    self.perfLoading      = ko.observable(false);
    self.perfRunning      = ko.observable(false);
    self.perfMsg          = ko.observable('');
    self.perfExpanded     = ko.observable(true);
    self.databaseLocks    = ko.observable(null);
    self.locksLoading     = ko.observable(false);
    self.locksRunning     = ko.observable(false);
    self.locksMsg         = ko.observable('');
    self.lockDetails      = ko.observable(null);
    self.terminatingLock  = ko.observable('');
    var currentUser = authService.getCurrentUser();
    self.isSysAdmin = !!(currentUser && (currentUser.roles || []).indexOf('SYS_ADMIN') >= 0);

    self.loadStorageHealth = function () {
      if (!self.isSysAdmin) return;
      self.storageLoading(true);
      settingService.getStorageHealth().then(function (result) {
        self.storageHealth(result);
      }).catch(function () {
        self.storageHealth(null);
      }).then(function () {
        self.storageLoading(false);
      });
    };
    self.loadStorageHealth();

    self.loadStorageHistory = function () {
      if (!self.isSysAdmin) return;
      settingService.getStorageHistory().then(function (result) {
        self.storageHistory(result);
      }).catch(function () {
        self.storageHistory(null);
      });
    };
    self.loadStorageHistory();

    self.loadDatabaseHealth = function () {
      if (!self.isSysAdmin) return;
      self.healthLoading(true);
      settingService.getDatabaseHealth().then(function (result) {
        self.databaseHealth(result);
      }).catch(function () {
        self.databaseHealth(null);
      }).then(function () {
        self.healthLoading(false);
      });
    };
    self.loadDatabaseHealth();

    self.runDatabaseHealth = function () {
      self.healthRunning(true);
      self.healthMsg('');
      settingService.runDatabaseHealth().then(function (result) {
        var ar = document.documentElement.lang === 'ar';
        self.healthMsg(result.status === 'HEALTHY'
          ? (ar ? 'اكتمل الفحص. جميع كائنات قاعدة البيانات بحالة جيدة.' : 'Check completed. All database objects are healthy.')
          : (ar ? 'اكتمل الفحص وتم العثور على مشكلات.' : 'Check completed with issues. Review the details below.'));
        return self.loadDatabaseHealth();
      }).catch(function (err) {
        self.healthMsg((document.documentElement.lang === 'ar' ? 'فشل الفحص: ' : 'Health check failed: ') +
          ((err && err.message) || 'Unknown error'));
      }).then(function () {
        self.healthRunning(false);
      });
    };

    self.loadDataIntegrity = function () {
      if (!self.isSysAdmin) return;
      self.integrityLoading(true);
      settingService.getDataIntegrity().then(function (result) {
        self.dataIntegrity(result);
      }).catch(function () {
        self.dataIntegrity(null);
      }).then(function () {
        self.integrityLoading(false);
      });
    };
    self.loadDataIntegrity();

    self.runDataIntegrity = function () {
      self.integrityRunning(true);
      self.integrityMsg('');
      settingService.runDataIntegrity().then(function () {
        var ar = document.documentElement.lang === 'ar';
        self.integrityMsg(ar ? 'اكتمل فحص سلامة البيانات.' : 'Data integrity check completed.');
        return self.loadDataIntegrity();
      }).catch(function (err) {
        self.integrityMsg((document.documentElement.lang === 'ar' ? 'فشل الفحص: ' : 'Integrity check failed: ') +
          ((err && err.message) || 'Unknown error'));
      }).then(function () {
        self.integrityRunning(false);
      });
    };

    self.loadSqlPerformance = function () {
      if (!self.isSysAdmin) return;
      self.perfLoading(true);
      settingService.getSqlPerformance().then(function (result) {
        self.sqlPerformance(result);
      }).catch(function () {
        self.sqlPerformance(null);
      }).then(function () {
        self.perfLoading(false);
      });
    };
    self.loadSqlPerformance();

    self.refreshSqlPerformance = function () {
      self.perfRunning(true);
      self.perfMsg('');
      settingService.refreshSqlPerformance().then(function () {
        self.perfMsg(document.documentElement.lang === 'ar'
          ? 'تم تحديث إحصاءات أداء SQL.' : 'SQL performance statistics refreshed.');
        return self.loadSqlPerformance();
      }).catch(function (err) {
        self.perfMsg((document.documentElement.lang === 'ar' ? 'فشل التحديث: ' : 'Performance refresh failed: ') +
          ((err && err.message) || 'Unknown error'));
      }).then(function () {
        self.perfRunning(false);
      });
    };

    self.toggleSqlPerformance = function () {
      self.perfExpanded(!self.perfExpanded());
    };

    self.loadDatabaseLocks = function () {
      if (!self.isSysAdmin) return;
      self.locksLoading(true);
      settingService.getDatabaseLocks().then(function (result) {
        self.databaseLocks(result);
      }).catch(function () {
        self.databaseLocks(null);
      }).then(function () {
        self.locksLoading(false);
      });
    };
    self.loadDatabaseLocks();

    self.refreshDatabaseLocks = function () {
      self.locksRunning(true);
      self.locksMsg('');
      settingService.refreshDatabaseLocks().then(function () {
        self.locksMsg(document.documentElement.lang === 'ar'
          ? 'تم تحديث حالة أقفال قاعدة البيانات.' : 'Database lock status refreshed.');
        return self.loadDatabaseLocks();
      }).catch(function (err) {
        self.locksMsg((document.documentElement.lang === 'ar' ? 'فشل التحديث: ' : 'Lock refresh failed: ') +
          ((err && err.message) || 'Unknown error'));
      }).then(function () {
        self.locksRunning(false);
      });
    };

    self.toggleLockDetails = function (item) {
      self.lockDetails(self.lockDetails() === item ? null : item);
    };

    self.terminateBlocker = function (item) {
      var ar = document.documentElement.lang === 'ar';
      var reason = window.prompt(ar
        ? 'أدخل سبب إنهاء الجلسة المسببة للحظر (10 أحرف على الأقل):'
        : 'Enter the reason for terminating the blocking session (minimum 10 characters):');
      if (reason === null) return;
      reason = reason.trim();
      if (reason.length < 10) {
        window.alert(ar ? 'يجب أن يكون السبب 10 أحرف على الأقل.' : 'The reason must be at least 10 characters.');
        return;
      }
      var question = ar
        ? 'إنهاء الجلسة ' + item.blockerSession + '؟ سيتم التراجع عن العمل غير المحفوظ.'
        : 'Terminate session ' + item.blockerSession + '? Its uncommitted work will be rolled back.';
      if (!window.confirm(question)) return;
      self.terminatingLock(item.blockerSession);
      self.locksMsg('');
      settingService.terminateDatabaseBlocker(item, reason).then(function () {
        self.lockDetails(null);
        self.locksMsg(ar ? 'تم إرسال أمر إنهاء الجلسة وتسجيله في سجل التدقيق.'
          : 'Session termination was issued and recorded in the audit log.');
        return self.loadDatabaseLocks();
      }).catch(function (err) {
        self.locksMsg((ar ? 'فشل إنهاء الجلسة: ' : 'Termination failed: ') +
          ((err && err.message) || 'Unknown error'));
      }).then(function () {
        self.terminatingLock('');
      });
    };

    self.growthText = function (value) {
      if (value === null || value === undefined || value === '') return '—';
      var amount = Number(value || 0);
      return (amount > 0 ? '+' : '') + amount.toFixed(2) + ' MB';
    };

    self.storageBarWidth = ko.pureComputed(function () {
      var h = self.storageHealth();
      return Math.min(100, Math.max(0, Number(h && h.percent || 0))) + '%';
    });

    function makeItem(s, cat) {
      var obs  = ko.observable(s.settingValue);
      var item = {
        settingKey:  s.settingKey,
        description: s.description,
        isEditable:  (/^ATD_(SUCCESS|ISSUE)_LOG_RETENTION_DAYS$/.test(s.settingKey) && !self.isSysAdmin)
                       ? 'N' : s.isEditable,
        isNumber:    s.settingType === 'NUMBER',
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
      self.categories(Object.keys(grouped).filter(function (cat) {
        return cat !== 'APPEARANCE';
      }).map(function (cat) {
        return {
          label: cat,
          settings: grouped[cat].map(function (s) { return makeItem(s, cat); }),
        };
      }).filter(function (cat) { return cat.settings.length; }));

      self.loading(false);
    }).catch(function (err) {
      self.errorMsg('Failed to load settings: ' + ((err && err.message) || 'Unknown error'));
      self.loading(false);
    });

    function allItems() {
      var list = [];
      self.categories().forEach(function (cat) {
        cat.settings.forEach(function (s) { list.push(s); });
      });
      return list;
    }

    self.hasDirty = ko.computed(function () {
      return self.categories().length >= 0 && allItems().some(function (s) { return s.dirty(); });
    });

    self.canRunCleanup = ko.computed(function () {
      return self.isSysAdmin && !self.cleanupRunning() && !self.saving() && !self.hasDirty();
    });

    self.runLogCleanup = function () {
      var ar = document.documentElement.lang === 'ar';
      var question = ar
        ? 'تشغيل تنظيف السجلات الآن باستخدام مدد الاحتفاظ المحفوظة؟'
        : 'Run log cleanup now using the saved retention periods?';
      if (!window.confirm(question)) return;
      self.cleanupRunning(true);
      self.cleanupMsg('');
      settingService.runLogCleanup().then(function (result) {
        var total = Number(result.totalDeleted || 0);
        self.cleanupMsg(ar
          ? 'اكتمل التنظيف. تم حذف ' + total + ' سجل.'
          : 'Cleanup completed. ' + total + ' log row(s) deleted.');
        self.loadStorageHealth();
        self.loadStorageHistory();
      }).catch(function (err) {
        self.cleanupMsg((ar ? 'فشل التنظيف: ' : 'Cleanup failed: ') +
          ((err && err.message) || 'Unknown error'));
      }).then(function () {
        self.cleanupRunning(false);
      });
    };

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
        self.loadStorageHealth();
        self.loadStorageHistory();
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
