define(['knockout', 'services/rptService', 'shared/toast'], function (ko, rpt, toast) {
  'use strict';

  function SettingsViewModel() {
    var self = this;
    self.loading  = ko.observable(true);
    self.saving   = ko.observable(false);
    self.rows     = ko.observableArray([]);
    self.hasDirty = ko.observable(false);

    // Send-test-email
    self.testTo   = ko.observable('');
    self.testing  = ko.observable(false);
    self.testMsg  = ko.observable('');
    self.testOk   = ko.observable(false);

    function recompute() {
      self.hasDirty(self.rows().some(function (r) { return !r.isSecret && r.value() !== r.orig; }));
    }

    self.load = function () {
      self.loading(true);
      rpt.getConfig().then(function (r) {
        self.rows((r.items || []).map(function (c) {
          var row = {
            key: c.key, description: c.description || '', type: c.valueType || 'STRING',
            isSecret: c.isSecret === 'Y', allowed: (c.enumValues || '').split(',').filter(Boolean),
            orig: c.value || '', value: ko.observable(c.value || '')
          };
          row.isBool = row.type === 'BOOL';
          row.isEnum = row.type === 'ENUM' && row.allowed.length > 0;
          row.dirty = ko.computed(function () { return !row.isSecret && row.value() !== row.orig; });
          row.value.subscribe(recompute);
          return row;
        }));
        self.hasDirty(false);
        // default the test recipient to the configured sender (a valid inbox)
        if (!self.testTo()) {
          var from = (r.items || []).filter(function (i) { return i.key === 'SMTP_FROM'; })[0];
          if (from && from.value) self.testTo(from.value);
        }
      }).catch(function () {}).then(function () { self.loading(false); });
    };

    self.toggle = function (row) { if (!row.isSecret) row.value(row.value() === 'Y' ? 'N' : 'Y'); };

    self.sendTest = function () {
      var to = (self.testTo() || '').trim();
      if (!to || !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(to)) {
        self.testOk(false); self.testMsg('Enter a valid recipient email address.'); return;
      }
      self.testing(true); self.testMsg('');
      rpt.sendTestEmail(to).then(function (r) {
        self.testing(false); self.testOk(true);
        self.testMsg('Test email sent to ' + to + '. Check the inbox (and spam)'
          + (r && r.emailEnabled === 'N'
             ? ' — note: EMAIL_ENABLED is N, so scheduled reports remain generate-only.' : '.'));
        toast.success('Test email sent');
      }).catch(function (err) {
        self.testing(false); self.testOk(false);
        self.testMsg((err && err.message)
          || 'Send failed. Verify the SMTP settings and the APEX instance mail configuration.');
      });
    };

    self.saveAll = function () {
      var changed = self.rows().filter(function (r) { return !r.isSecret && r.value() !== r.orig; })
        .map(function (r) { return { key: r.key, value: r.value() }; });
      if (!changed.length) return;
      self.saving(true);
      rpt.putConfig(changed).then(function () {
        toast.success('Settings saved'); self.saving(false); self.load();
      }).catch(function () { self.saving(false); });
    };

    self.load();
  }

  return SettingsViewModel;
});
