define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast'],
function (ko, atd, i18n, toast) {
  'use strict';
  return function Environments() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.envs = ko.observableArray([]);
    self.tracks = ['BROWSER', 'API'];

    // client-side pagination (20 rows/page)
    self.offset = ko.observable(0);
    self.limit = ko.observable(20);
    self.total = ko.pureComputed(function () { return self.envs().length; });
    self.envsPage = ko.pureComputed(function () {
      var o = self.offset(); return self.envs().slice(o, o + self.limit());
    });
    self.noop = function () {};
    self.authTypes = ['SESSION', 'WSS', 'BASIC', 'OAUTH'];

    self.showForm = ko.observable(false);
    self.editName = ko.observable(null);
    self.fmName = ko.observable(''); self.fmDesc = ko.observable('');
    self.fmUrl = ko.observable(''); self.fmXmlp = ko.observable('');
    self.fmAuth = ko.observable('SESSION'); self.fmCred = ko.observable('');
    self.fmTrack = ko.observable('BROWSER'); self.fmEnabled = ko.observable(true);

    self.formTitle = ko.computed(function () { return self.t(self.editName() ? 'atd.envs.title' : 'atd.envs.new'); });
    self.formSaveLabel = ko.computed(function () { return self.t(self.editName() ? 'atd.action.saveChanges' : 'atd.action.create'); });
    self.showForm.subscribe(function (v) { if (!v) self.editName(null); });

    self.load = function () {
      self.loading(true);
      atd.listEnvs().then(function (r) { self.envs(r.items || []); self.offset(0); self.loading(false); })
        .catch(function () { self.loading(false); });
    };
    self.load();

    self.newEnv = function () {
      self.editName(null);
      self.fmName(''); self.fmDesc(''); self.fmUrl(''); self.fmXmlp('');
      self.fmAuth('SESSION'); self.fmCred(''); self.fmTrack('BROWSER'); self.fmEnabled(true);
      self.showForm(true);
    };
    self.editEnv = function (e) {
      self.editName(e.envName);
      self.fmName(e.envName); self.fmDesc(e.description || ''); self.fmUrl(e.analyticsBaseUrl || '');
      self.fmXmlp(e.xmlpserverBaseUrl || ''); self.fmAuth(e.authType || 'SESSION');
      self.fmCred(e.credentialRef || ''); self.fmTrack(e.extractTrack || 'BROWSER');
      self.fmEnabled((e.enabled || 'Y') === 'Y'); self.showForm(true);
    };
    self.save = function () {
      if (!self.fmName()) { toast.error(self.t('atd.envs.col.name')); return; }
      var body = { description: self.fmDesc(), analyticsBaseUrl: self.fmUrl(),
                   xmlpserverBaseUrl: self.fmXmlp(), authType: self.fmAuth(),
                   credentialRef: self.fmCred(), extractTrack: self.fmTrack(),
                   enabled: self.fmEnabled() ? 'Y' : 'N' };
      var done = function () { toast.success(self.t('atd.common.saved')); self.showForm(false); self.load(); };
      if (self.editName()) { atd.updateEnv(self.editName(), body).then(done).catch(function () {}); }
      else { body.envName = self.fmName(); atd.createEnv(body).then(done).catch(function () {}); }
    };
    self.del = function (e) {
      if (!window.confirm(self.t('atd.envs.confirmDelete'))) return;
      atd.deleteEnv(e.envName).then(function () { toast.success(self.t('atd.common.saved')); self.load(); }).catch(function () {});
    };
  };
});
