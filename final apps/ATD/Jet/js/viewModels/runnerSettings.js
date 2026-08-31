define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast'],
function (ko, atd, i18n, toast) {
  'use strict';
  return function RunnerSettings() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.items = ko.observableArray([]);
    self.saving = ko.observable(false);

    // --- My OTBI Account (per-user credential profile, db/62+63) ---
    self.credLoading = ko.observable(true);
    self.credSaving = ko.observable(false);
    self.credExists = ko.observable(false);
    self.credLogin = ko.observable('');
    self.credCatalog = ko.observable('');   // OTBI catalog folder name when it differs from the sign-in
    self.credChat = ko.observable('');
    self.credActive = ko.observable(true);
    self.credPwd = ko.observable('');          // write-only: sent only when non-empty
    self.credPwdSet = ko.observable(false);
    self.credUpdatedAt = ko.observable('');
    self.credRoster = ko.observableArray([]);

    function decorate(it) {
      // secrets arrive as '' from the API; their input is WRITE-ONLY (blank = keep)
      it.val = ko.observable(it.value || '');
      it.enumList = it.enumValues ? it.enumValues.split(',') : [];
      return it;
    }

    self.load = function () {
      self.loading(true);
      atd.getConfig().then(function (r) {
        self.items((r.items || []).map(decorate));
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };
    self.load();

    self.loadCred = function () {
      self.credLoading(true);
      atd.getMyCred().then(function (r) {
        self.credExists(!!r.exists);
        self.credLogin(r.fusionLogin || '');
        self.credCatalog(r.catalogLogin || '');
        self.credChat(r.tgChatId || '');
        self.credActive(r.isActive !== 'N');
        self.credPwdSet(r.passwordSet === 'Y');
        self.credUpdatedAt(r.updatedAt || '');
        self.credPwd('');
        self.credLoading(false);
      }).catch(function () { self.credLoading(false); });
      atd.listCreds().then(function (r) {
        self.credRoster(r.items || []);
      }).catch(function () { self.credRoster([]); });
    };
    self.loadCred();

    self.saveCred = function () {
      var login = (self.credLogin() || '').trim();
      if (!login) { toast.error(self.t('atd.rs.myacct.loginRequired')); return; }
      var body = {
        fusionLogin: login,
        catalogLogin: (self.credCatalog() || '').trim(),
        tgChatId: (self.credChat() || '').trim(),
        isActive: self.credActive() ? 'Y' : 'N'
      };
      // write-only secret: only send the password when the operator typed one
      var pwd = self.credPwd();
      if (pwd && pwd.trim()) { body.password = pwd; }
      self.credSaving(true);
      atd.saveMyCred(body).then(function () {
        toast.success(self.t('atd.rs.myacct.saved'));
        self.credSaving(false); self.loadCred();
      }).catch(function () { self.credSaving(false); });
    };

    self.removeCred = function () {
      if (!self.credExists()) { return; }
      if (!window.confirm(self.t('atd.rs.myacct.removeConfirm'))) { return; }
      self.credSaving(true);
      atd.deleteMyCred().then(function () {
        toast.success(self.t('atd.rs.myacct.removed'));
        self.credSaving(false); self.loadCred();
      }).catch(function () { self.credSaving(false); });
    };

    self.save = function () {
      self.saving(true);
      // secret rows are write-only: send one ONLY when the operator typed a new
      // value — sending the blank placeholder would WIPE the stored secret
      var payload = self.items().filter(function (it) {
        return it.isSecret !== 'Y' || (it.val() && it.val().trim());
      }).map(function (it) {
        return { key: it.key, value: it.val() };
      });
      atd.saveConfig(payload).then(function () {
        toast.success(self.t('atd.rs.saved')); self.saving(false); self.load();
      }).catch(function () { self.saving(false); });
    };
  };
});
