/**
 * runners.js — Automation Runners Registry (Admin → System → Automation Registry)
 * A searchable catalogue of every runner/script the team has built: where it lives,
 * what it does, how to run it, deps/schedule, plus an optional stored copy
 * (inline text + binary upload). Full CRUD over /dct/runners.
 *
 * Editor fields are FLAT fm* observables (the reliable pattern with <edit-drawer>;
 * binding the drawer body to editTarget().field broke writeback for some fields).
 */
define(['knockout', 'services/runnerService', 'shared/i18n', 'shared/toast'],
function (ko, svc, i18n, toast) {
  'use strict';

  function RunnersViewModel() {
    var self = this;
    self.t = i18n.t;

    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.runners   = ko.observableArray([]);

    self.categories = ko.observableArray([]);
    self.runtimes   = ko.observableArray([]);
    self.statuses   = ko.observableArray([]);

    self.search    = ko.observable('');
    self.fCategory = ko.observable('');
    self.fRuntime  = ko.observable('');
    self.fStatus   = ko.observable('');

    self.offset = ko.observable(0);
    self.limit  = ko.observable(100);
    self.total  = ko.observable(0);

    // ── load ────────────────────────────────────────────────────────────────
    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      svc.list({
        limit: self.limit(), offset: self.offset(),
        search: self.search().trim() || null,
        category: self.fCategory() || null,
        runtime: self.fRuntime() || null,
        status: self.fStatus() || null
      }).then(function (r) {
        self.runners(r.items || []);
        self.total(r.total || (r.items || []).length);
        self.loading(false);
      }).catch(function () {
        self.loadError(true); self.loading(false);
      });
    };

    self.doSearch = function () { self.offset(0); self.reload(); };
    self.clearFilters = function () {
      self.search(''); self.fCategory(''); self.fRuntime(''); self.fStatus('');
      self.offset(0); self.reload();
    };

    svc.meta().then(function (m) {
      self.categories(m.categories || []);
      self.runtimes(m.runtimes || []);
      self.statuses(m.statuses || []);
    }).catch(function () {});
    self.reload();

    // ── editor (flat fields) ──────────────────────────────────────────────────
    self.showEdit  = ko.observable(false);
    self.isNew     = ko.observable(false);
    self.editError = ko.observable('');
    self.saving    = ko.observable(false);
    self.uploading = ko.observable(false);
    self.editId    = ko.observable(null);

    self.fmCode = ko.observable(''); self.fmName = ko.observable('');
    self.fmCategory = ko.observable(''); self.fmRuntime = ko.observable('PYTHON');
    self.fmStatus = ko.observable('ACTIVE'); self.fmOwner = ko.observable('');
    self.fmHost = ko.observable(''); self.fmSchedule = ko.observable('');
    self.fmFilePath = ko.observable(''); self.fmRepoPath = ko.observable('');
    self.fmPurpose = ko.observable(''); self.fmUsage = ko.observable('');
    self.fmDeps = ko.observable(''); self.fmTags = ko.observable('');
    self.fmLinks = ko.observable(''); self.fmNotes = ko.observable('');
    self.fmContent = ko.observable('');
    self.fmFileName = ko.observable(''); self.fmFileSize = ko.observable(0);

    function resetForm() {
      self.editId(null);
      self.fmCode(''); self.fmName(''); self.fmCategory(''); self.fmRuntime('PYTHON');
      self.fmStatus('ACTIVE'); self.fmOwner(''); self.fmHost(''); self.fmSchedule('');
      self.fmFilePath(''); self.fmRepoPath(''); self.fmPurpose(''); self.fmUsage('');
      self.fmDeps(''); self.fmTags(''); self.fmLinks(''); self.fmNotes('');
      self.fmContent(''); self.fmFileName(''); self.fmFileSize(0);
    }

    self.openNew = function () {
      resetForm();
      self.isNew(true); self.editError(''); self.showEdit(true);
    };

    self.openEdit = function (row) {
      self.editError('');
      svc.get(row.runnerId).then(function (d) {
        self.editId(d.runnerId);
        self.fmCode(d.runnerCode || ''); self.fmName(d.name || '');
        self.fmCategory(d.category || ''); self.fmRuntime(d.runtime || 'PYTHON');
        self.fmStatus(d.status || 'ACTIVE'); self.fmOwner(d.owner || '');
        self.fmHost(d.hostLocation || ''); self.fmSchedule(d.scheduleInfo || '');
        self.fmFilePath(d.filePath || ''); self.fmRepoPath(d.repoPath || '');
        self.fmPurpose(d.purpose || ''); self.fmUsage(d.usageNotes || '');
        self.fmDeps(d.dependencies || ''); self.fmTags(d.tags || '');
        self.fmLinks(d.relatedLinks || ''); self.fmNotes(d.notes || '');
        self.fmContent(d.contentText || '');
        self.fmFileName(d.fileName || ''); self.fmFileSize(d.fileSize || 0);
        self.isNew(false); self.showEdit(true);
      }).catch(function (e) { toast.error((e && e.message) || self.t('runner.loadFail')); });
    };

    self.closeEdit = function () { self.showEdit(false); self.editError(''); };

    self.saveEdit = function () {
      var data = {
        runnerCode: (self.fmCode() || '').toUpperCase().trim(),
        name: (self.fmName() || '').trim(),
        category: self.fmCategory() || null, runtime: self.fmRuntime() || null,
        status: self.fmStatus() || 'ACTIVE', owner: self.fmOwner() || null,
        hostLocation: self.fmHost() || null, scheduleInfo: self.fmSchedule() || null,
        filePath: self.fmFilePath() || null, repoPath: self.fmRepoPath() || null,
        purpose: self.fmPurpose() || null, usageNotes: self.fmUsage() || null,
        dependencies: self.fmDeps() || null, tags: self.fmTags() || null,
        relatedLinks: self.fmLinks() || null, notes: self.fmNotes() || null,
        contentText: self.fmContent() || null
      };
      if (!data.runnerCode) { self.editError(self.t('runner.err.code')); return; }
      if (!data.name)       { self.editError(self.t('runner.err.name')); return; }
      self.editError(''); self.saving(true);
      var op = self.isNew() ? svc.create(data) : svc.update(self.editId(), data);
      op.then(function (res) {
        self.saving(false);
        if (self.isNew() && res && res.runnerId) { self.editId(res.runnerId); self.isNew(false); }
        toast.success(self.t('runner.saved'));
        self.closeEdit(); self.reload();
      }).catch(function (e) {
        self.saving(false);
        self.editError((e && e.message) || self.t('runner.saveFail'));
      });
    };

    self.del = function (row) {
      if (!window.confirm(self.t('runner.confirmDelete') + '\n\n' + row.runnerCode)) return;
      svc.remove(row.runnerId).then(function () {
        toast.success(self.t('runner.deleted')); self.reload();
      }).catch(function (e) { toast.error((e && e.message) || self.t('runner.deleteFail')); });
    };

    // ── stored file (shared <doc-upload> onPick / download) ───────────────────
    self.onFilePicked = function (file) {
      if (!file) return;
      if (!self.editId()) { toast.error(self.t('runner.saveFirst')); return; }
      self.uploading(true);
      svc.uploadFile(self.editId(), file).then(function () {
        self.uploading(false);
        self.fmFileName(file.name); self.fmFileSize(file.size);
        toast.success(self.t('runner.fileUploaded'));
      }).catch(function (e) {
        self.uploading(false);
        toast.error((e && e.message) || self.t('runner.uploadFail'));
      });
    };

    self.downloadFile = function () {
      if (!self.editId() || !self.fmFileName()) return;
      svc.fileUrl(self.editId()).then(function (url) {
        var a = document.createElement('a');
        a.href = url; a.download = self.fmFileName() || (self.fmCode() + '.txt');
        document.body.appendChild(a); a.click(); document.body.removeChild(a);
        setTimeout(function () { URL.revokeObjectURL(url); }, 4000);
      }).catch(function () {});
    };

    self.statusClass = function (s) {
      s = (s || '').toUpperCase();
      if (s === 'ACTIVE') return 'badge badge--active';
      if (s === 'DEPRECATED' || s === 'ARCHIVED') return 'badge badge--inactive';
      return 'badge';
    };
  }

  return RunnersViewModel;
});
