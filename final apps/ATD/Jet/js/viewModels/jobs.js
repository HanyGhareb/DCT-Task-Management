define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast'],
function (ko, atd, i18n, toast) {
  'use strict';
  return function Jobs() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.jobs = ko.observableArray([]);
    self.envs = ko.observableArray([]);
    self.targets = ko.observableArray([]);
    self.statuses = ['READY', 'CLAIMED', 'DONE', 'FAILED'];
    self.loadModes = ['TRUNCATE_INSERT', 'MERGE'];

    self.fSearch = ko.observable('');
    self.fStatus = ko.observable('');

    // drawer form state
    self.showForm = ko.observable(false);
    self.editName = ko.observable(null);
    self.fmJobName = ko.observable(''); self.fmEnv = ko.observable(''); self.fmTarget = ko.observable('');
    self.fmSource = ko.observable(''); self.fmStage = ko.observable(''); self.fmFinal = ko.observable('');
    self.fmLoadMode = ko.observable('TRUNCATE_INSERT'); self.fmKeyCols = ko.observable('');
    self.fmColMap = ko.observable(''); self.fmParams = ko.observable('');
    self.fmPriority = ko.observable(5); self.fmRunOrder = ko.observable(100);
    self.fmEnabled = ko.observable(true);

    self.formTitle = ko.computed(function () {
      return self.t(self.editName() ? 'atd.jobs.editTitle' : 'atd.jobs.newTitle');
    });
    self.formSaveLabel = ko.computed(function () {
      return self.t(self.editName() ? 'atd.action.saveChanges' : 'atd.action.create');
    });
    self.showForm.subscribe(function (v) { if (!v) self.editName(null); });

    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };

    self.load = function () {
      self.loading(true);
      atd.listJobs({ search: self.fSearch(), status: self.fStatus(), limit: 200 })
        .then(function (r) { self.jobs(r.items || []); self.loading(false); })
        .catch(function () { self.loading(false); });
    };

    atd.getLookups().then(function (l) {
      self.envs((l.envs || []).map(function (e) { return e.envName; }));
      self.targets((l.targets || []).map(function (t) { return t.targetName; }));
    }).catch(function () {}).then(function () { self.load(); });

    self.open = function (row) { window._jetApp.navigate('jobDetail', { jobName: row.jobName }); };

    self.newJob = function () {
      self.editName(null);
      self.fmJobName(''); self.fmEnv(self.envs()[0] || ''); self.fmTarget(self.targets()[0] || '');
      self.fmSource(''); self.fmStage(''); self.fmFinal(''); self.fmLoadMode('TRUNCATE_INSERT');
      self.fmKeyCols(''); self.fmColMap(''); self.fmParams(''); self.fmPriority(5); self.fmRunOrder(100);
      self.fmEnabled(true); self.showForm(true);
    };

    self.editJob = function (row) {
      atd.getJob(row.jobName).then(function (j) {
        self.editName(j.jobName);
        self.fmJobName(j.jobName); self.fmEnv(j.envName); self.fmTarget(j.targetName);
        self.fmSource(j.sourceRef || ''); self.fmStage(j.stageTable || ''); self.fmFinal(j.finalTable || '');
        self.fmLoadMode(j.loadMode || 'TRUNCATE_INSERT'); self.fmKeyCols(j.keyColumns || '');
        self.fmColMap(j.columnMapJson || ''); self.fmParams(j.paramsJson || '');
        self.fmPriority(j.priority); self.fmRunOrder(j.runOrder);
        self.fmEnabled((j.enabled || 'Y') === 'Y'); self.showForm(true);
      }).catch(function () {});
    };

    function _validJson(s, label) {
      if (!s || !String(s).trim()) return true;
      try { JSON.parse(s); return true; } catch (e) { toast.error(label + ': invalid JSON'); return false; }
    }

    self.save = function () {
      if (!self.fmJobName()) { toast.error(self.t('atd.field.jobName')); return; }
      if (!self.fmSource())  { toast.error(self.t('atd.field.sourceRef')); return; }
      if (!self.fmStage())   { toast.error(self.t('atd.field.stageTable')); return; }
      if (!_validJson(self.fmColMap(), self.t('atd.field.columnMap'))) return;
      if (!_validJson(self.fmParams(), self.t('atd.field.params'))) return;
      var body = {
        envName: self.fmEnv(), targetName: self.fmTarget(), sourceRef: self.fmSource(),
        stageTable: self.fmStage(), finalTable: self.fmFinal(), loadMode: self.fmLoadMode(),
        keyColumns: self.fmKeyCols(), columnMapJson: self.fmColMap(), paramsJson: self.fmParams(),
        priority: Number(self.fmPriority()), runOrder: Number(self.fmRunOrder()),
        enabled: self.fmEnabled() ? 'Y' : 'N'
      };
      var done = function () { toast.success(self.t('atd.common.saved')); self.showForm(false); self.load(); };
      if (self.editName()) {
        atd.updateJob(self.editName(), body).then(done).catch(function () {});
      } else {
        body.jobName = self.fmJobName();
        atd.createJob(body).then(done).catch(function () {});
      }
    };

    self.enqueue = function (row) {
      atd.enqueueJob(row.jobName).then(function () { toast.success(self.t('atd.jobs.enqueued')); self.load(); }).catch(function () {});
    };
    self.reset = function (row) {
      atd.resetJob(row.jobName).then(function () { toast.success(self.t('atd.jobs.reset')); self.load(); }).catch(function () {});
    };
    self.del = function (row) {
      if (!window.confirm(self.t('atd.jobs.confirmDelete'))) return;
      atd.deleteJob(row.jobName).then(function () { toast.success(self.t('atd.common.saved')); self.load(); }).catch(function () {});
    };
  };
});
