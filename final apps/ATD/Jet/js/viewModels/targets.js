define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast'],
function (ko, atd, i18n, toast) {
  'use strict';
  return function Targets() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.targets = ko.observableArray([]);
    self.kinds = ['LOCAL_ATP', 'REMOTE'];

    self.showForm = ko.observable(false);
    self.editName = ko.observable(null);
    self.fmName = ko.observable(''); self.fmDesc = ko.observable('');
    self.fmKind = ko.observable('LOCAL_ATP'); self.fmLink = ko.observable('');
    self.fmSchema = ko.observable(''); self.fmTns = ko.observable(''); self.fmEnabled = ko.observable(true);

    self.formTitle = ko.computed(function () { return self.t(self.editName() ? 'atd.targets.title' : 'atd.targets.new'); });
    self.formSaveLabel = ko.computed(function () { return self.t(self.editName() ? 'atd.action.saveChanges' : 'atd.action.create'); });
    self.showForm.subscribe(function (v) { if (!v) self.editName(null); });

    self.load = function () {
      self.loading(true);
      atd.listTargets().then(function (r) { self.targets(r.items || []); self.loading(false); })
        .catch(function () { self.loading(false); });
    };
    self.load();

    self.newTarget = function () {
      self.editName(null);
      self.fmName(''); self.fmDesc(''); self.fmKind('LOCAL_ATP'); self.fmLink('');
      self.fmSchema(''); self.fmTns(''); self.fmEnabled(true); self.showForm(true);
    };
    self.editTarget = function (tg) {
      self.editName(tg.targetName);
      self.fmName(tg.targetName); self.fmDesc(tg.description || ''); self.fmKind(tg.dbKind || 'LOCAL_ATP');
      self.fmLink(tg.dbLink || ''); self.fmSchema(tg.schemaName || ''); self.fmTns(tg.tnsAlias || '');
      self.fmEnabled((tg.enabled || 'Y') === 'Y'); self.showForm(true);
    };
    self.save = function () {
      if (!self.fmName()) { toast.error(self.t('atd.targets.col.name')); return; }
      var body = { description: self.fmDesc(), dbKind: self.fmKind(), dbLink: self.fmLink(),
                   schemaName: self.fmSchema(), tnsAlias: self.fmTns(),
                   enabled: self.fmEnabled() ? 'Y' : 'N' };
      var done = function () { toast.success(self.t('atd.common.saved')); self.showForm(false); self.load(); };
      if (self.editName()) { atd.updateTarget(self.editName(), body).then(done).catch(function () {}); }
      else { body.targetName = self.fmName(); atd.createTarget(body).then(done).catch(function () {}); }
    };
    self.del = function (tg) {
      if (!window.confirm(self.t('atd.targets.confirmDelete'))) return;
      atd.deleteTarget(tg.targetName).then(function () { toast.success(self.t('atd.common.saved')); self.load(); }).catch(function () {});
    };
  };
});
