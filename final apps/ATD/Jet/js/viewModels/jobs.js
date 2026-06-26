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
    self.fCategory = ko.observable('');           // category filter (code or '')
    self.categories = ko.observableArray([]);     // all categories (lookup)

    // server pagination (envelope {items,total,limit,offset}); 20 rows/page
    self.offset = ko.observable(0);
    self.limit = ko.observable(20);
    self.total = ko.observable(0);

    // drawer form state
    self.showForm = ko.observable(false);
    self.editName = ko.observable(null);
    self.fmJobName = ko.observable(''); self.fmEnv = ko.observable(''); self.fmTarget = ko.observable('');
    self.fmSource = ko.observable(''); self.fmStage = ko.observable(''); self.fmFinal = ko.observable('');
    self.fmLoadMode = ko.observable('TRUNCATE_INSERT'); self.fmKeyCols = ko.observable('');
    self.fmColMap = ko.observable(''); self.fmParams = ko.observable('');
    self.fmPriority = ko.observable(5); self.fmRunOrder = ko.observable(100);
    self.fmFrequency = ko.observable('');   // run-frequency minutes; blank = default (ATD_DEFAULT_FREQ_MINUTES)
    self.fmEnabled = ko.observable(true);
    self.fmCategories = ko.observableArray([]);   // selected category codes for the job
    self.showAdvanced = ko.observable(false);
    self.toggleAdvanced = function () { self.showAdvanced(!self.showAdvanced()); };

    // ---- category helpers (chips + picker) ----
    self.activeCategories = ko.computed(function () {
      return self.categories().filter(function (c) { return c.active === 'Y'; });
    });
    self.catLabel = function (c) {              // c may be a lookup row or a job-tag {code,name}
      var ar = (i18n.lang && i18n.lang() === 'ar');
      return (ar ? (c.nameAr || c.name) : (c.nameEn || c.name)) || c.code;
    };
    self.chipStyle = function (color) { return { background: color || '#6B7280', color: '#fff' }; };
    self.isCatSelected = function (code) { return self.fmCategories.indexOf(code) >= 0; };
    self.toggleCat = function (code) {
      var arr = self.fmCategories();
      var i = arr.indexOf(code);
      if (i >= 0) arr.splice(i, 1); else arr.push(code);
      self.fmCategories(arr.slice());
    };
    self.loadCategories = function () {
      return atd.listCategories().then(function (r) { self.categories((r && r.items) || []); })
        .catch(function () {});
    };

    self.formTitle = ko.computed(function () {
      return self.t(self.editName() ? 'atd.jobs.editTitle' : 'atd.jobs.newTitle');
    });
    self.formSaveLabel = ko.computed(function () {
      return self.t(self.editName() ? 'atd.action.saveChanges' : 'atd.action.create');
    });
    self.showForm.subscribe(function (v) { if (!v) self.editName(null); });

    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };

    // "Add New OTBI Analysis" (builder + column picker) lives on the OTBI Discovery page.

    self.load = function () {
      self.loading(true);
      atd.listJobs({ search: self.fSearch(), status: self.fStatus(), category: self.fCategory(),
                     limit: self.limit(), offset: self.offset() })
        .then(function (r) {
          self.jobs(r.items || []);
          self.total(r.total || (r.items || []).length);
          self.loading(false);
        })
        .catch(function () { self.loading(false); });
    };
    self.reload = self.load;                     // pager onChange (offset already set)

    // Reload on status change via the observable subscription (fires after the value
    // binding writes) — the DOM change event fires before KO updates the observable.
    // Reset to page 1 when the filter changes.
    self.fStatus.subscribe(function () { self.offset(0); self.load(); });
    self.fCategory.subscribe(function () { self.offset(0); self.load(); });

    self.loadCategories();
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
      self.fmFrequency(''); self.fmEnabled(true); self.fmCategories([]);
      self.showAdvanced(false); self.showForm(true);
    };

    self.editJob = function (row) {
      atd.getJob(row.jobName).then(function (j) {
        self.editName(j.jobName); self.showAdvanced(true);
        self.fmJobName(j.jobName); self.fmEnv(j.envName); self.fmTarget(j.targetName);
        self.fmSource(j.sourceRef || ''); self.fmStage(j.stageTable || ''); self.fmFinal(j.finalTable || '');
        self.fmLoadMode(j.loadMode || 'TRUNCATE_INSERT'); self.fmKeyCols(j.keyColumns || '');
        self.fmColMap(j.columnMapJson || ''); self.fmParams(j.paramsJson || '');
        self.fmPriority(j.priority); self.fmRunOrder(j.runOrder);
        self.fmFrequency(j.frequencyMinutes != null && j.frequencyMinutes !== '' ? j.frequencyMinutes : '');
        self.fmCategories((j.categories || []).map(function (c) { return c.code; }));
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
          frequencyMinutes: (self.fmFrequency() === '' || self.fmFrequency() == null) ? null : Number(self.fmFrequency()),
          categories: self.fmCategories(),
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
      if (self.fmCategories().length) b.categories = self.fmCategories();
      if (self.showAdvanced()) {
        if (self.fmEnv())     b.envName = self.fmEnv();
        if (self.fmTarget())  b.targetName = self.fmTarget();
        b.loadMode = self.fmLoadMode();
        if (self.fmFinal())   b.finalTable = self.fmFinal();
        if (self.fmKeyCols()) b.keyColumns = self.fmKeyCols();
        if (self.fmColMap())  b.columnMapJson = self.fmColMap();
        if (self.fmParams())  b.paramsJson = self.fmParams();
        b.priority = Number(self.fmPriority()); b.runOrder = Number(self.fmRunOrder());
        if (self.fmFrequency() !== '' && self.fmFrequency() != null) b.frequencyMinutes = Number(self.fmFrequency());
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

    // ---- Manage Categories modal ----
    self.showCatMgr = ko.observable(false);
    self.catEdit = ko.observable(null);          // code being edited; null = new
    self.cmCode = ko.observable(''); self.cmNameEn = ko.observable(''); self.cmNameAr = ko.observable('');
    self.cmColor = ko.observable('#2C6CB0'); self.cmOrder = ko.observable(100); self.cmActive = ko.observable(true);
    self.resetCatForm = function () {
      self.catEdit(null); self.cmCode(''); self.cmNameEn(''); self.cmNameAr('');
      self.cmColor('#2C6CB0'); self.cmOrder(100); self.cmActive(true);
    };
    self.openCatMgr = function () { self.resetCatForm(); self.loadCategories(); self.showCatMgr(true); };
    self.editCat = function (c) {
      self.catEdit(c.code); self.cmCode(c.code); self.cmNameEn(c.nameEn); self.cmNameAr(c.nameAr || '');
      self.cmColor(c.color || '#2C6CB0'); self.cmOrder(c.displayOrder); self.cmActive(c.active === 'Y');
    };
    self.saveCat = function () {
      if (!self.cmNameEn()) { toast.error(self.t('atd.cat.nameEn')); return; }
      var body = { nameEn: self.cmNameEn(), nameAr: self.cmNameAr(), color: self.cmColor(),
                   displayOrder: Number(self.cmOrder()), active: self.cmActive() ? 'Y' : 'N' };
      var p;
      if (self.catEdit()) { p = atd.updateCategory(self.catEdit(), body); }
      else {
        if (!self.cmCode()) { toast.error(self.t('atd.cat.code')); return; }
        body.code = self.cmCode(); p = atd.createCategory(body);
      }
      p.then(function () { toast.success(self.t('atd.common.saved')); self.resetCatForm(); self.loadCategories(); })
       .catch(function () { toast.error(self.t('atd.cat.saveFailed')); });
    };
    self.delCat = function (c) {
      if (!window.confirm(self.t('atd.cat.confirmDelete').replace('{name}', self.catLabel(c)))) return;
      atd.deleteCategory(c.code)
        .then(function () { toast.success(self.t('atd.common.saved')); self.loadCategories(); })
        .catch(function () { toast.error(self.t('atd.cat.deleteFailed')); });
    };
  };
});
