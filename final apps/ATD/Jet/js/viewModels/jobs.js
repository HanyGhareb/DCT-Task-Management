define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast', 'util/duration'],
function (ko, atd, i18n, toast, fmtDuration) {
  'use strict';
  return function Jobs() {
    var self = this;
    self.t = i18n.t;
    self.fmtDuration = fmtDuration;
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
    self.showAdvanced = ko.observable(false);
    self.toggleAdvanced = function () { self.showAdvanced(!self.showAdvanced()); };

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

    // Reload on status change via the observable subscription (fires after the value
    // binding writes) — the DOM change event fires before KO updates the observable.
    self.fStatus.subscribe(function () { self.load(); });

    atd.getLookups().then(function (l) {
      self.envs((l.envs || []).map(function (e) { return e.envName; }));
      self.targets((l.targets || []).map(function (t) { return t.targetName; }));
    }).catch(function () {}).then(function () { self.load(); });

    self.open = function (row) { window._jetApp.navigate('jobDetail', { jobName: row.jobName }); };

    self.newJob = function () {
      self.editName(null);
      self.fmJobName(''); self.fmEnv(''); self.fmTarget('');
      self.fmSource(''); self.fmStage(''); self.fmFinal(''); self.fmLoadMode('TRUNCATE_INSERT');
      self.fmKeyCols(''); self.fmColMap(''); self.fmParams(''); self.fmPriority(5); self.fmRunOrder(100);
      self.fmEnabled(true); self.showAdvanced(false); self.showForm(true);
    };

    self.editJob = function (row) {
      atd.getJob(row.jobName).then(function (j) {
        self.editName(j.jobName); self.showAdvanced(true);
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
      if (!_validJson(self.fmColMap(), self.t('atd.field.columnMap'))) return;
      if (!_validJson(self.fmParams(), self.t('atd.field.params'))) return;

      if (self.editName()) {
        // edit: full body (PUT only overwrites keys present)
        var body = {
          envName: self.fmEnv(), targetName: self.fmTarget(), sourceRef: self.fmSource(),
          stageTable: self.fmStage(), finalTable: self.fmFinal(), loadMode: self.fmLoadMode(),
          keyColumns: self.fmKeyCols(), columnMapJson: self.fmColMap(), paramsJson: self.fmParams(),
          priority: Number(self.fmPriority()), runOrder: Number(self.fmRunOrder()),
          enabled: self.fmEnabled() ? 'Y' : 'N'
        };
        atd.updateJob(self.editName(), body).then(function () {
          toast.success(self.t('atd.common.saved')); self.showForm(false); self.load();
        }).catch(function () {});
        return;
      }

      // create: analysis path is the ONLY required field — everything else is
      // auto-derived server-side and prepared by the runner on first run.
      if (!self.fmSource()) { toast.error(self.t('atd.field.sourceRef')); return; }
      var b = { sourceRef: self.fmSource() };
      if (self.fmStage())   b.stageTable = self.fmStage();   // optional target table
      if (self.fmJobName()) b.jobName = self.fmJobName();
      if (self.showAdvanced()) {
        if (self.fmEnv())     b.envName = self.fmEnv();
        if (self.fmTarget())  b.targetName = self.fmTarget();
        b.loadMode = self.fmLoadMode();
        if (self.fmFinal())   b.finalTable = self.fmFinal();
        if (self.fmKeyCols()) b.keyColumns = self.fmKeyCols();
        if (self.fmColMap())  b.columnMapJson = self.fmColMap();
        if (self.fmParams())  b.paramsJson = self.fmParams();
        b.priority = Number(self.fmPriority()); b.runOrder = Number(self.fmRunOrder());
        b.enabled = self.fmEnabled() ? 'Y' : 'N';
      }
      atd.createJob(b).then(function (r) {
        var nm = (r && r.jobName) || self.fmSource();
        toast.success(self.t('atd.jobs.createdPrepare').replace('{name}', nm));
        self.showForm(false); self.load();
      }).catch(function () {});
    };

    self.enqueue = function (row) {
      atd.enqueueJob(row.jobName).then(function () { toast.success(self.t('atd.jobs.enqueued')); self.load(); }).catch(function () {});
    };
    self.runNow = function (row) {
      if (!window.confirm(self.t('atd.jobs.confirmRun'))) return;
      atd.runJob(row.jobName).then(function () { toast.success(self.t('atd.jobs.runQueued')); self.load(); }).catch(function () {});
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
