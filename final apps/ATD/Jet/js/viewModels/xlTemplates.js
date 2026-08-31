/**
 * xlTemplates.js — VB Templates repository page (App 208).
 * Manages the Visual Builder Excel template repository (/ords/admin/xl/):
 * per-process templates → versions → MASTER (admin) + PUBLISHED (end-user)
 * workbooks; exactly one version is ACTIVE per template.
 */
define(['knockout', 'services/xlService', 'shared/i18n', 'shared/toast', 'shared/docUpload'],
function (ko, xl, i18n, toast, docUpload) {
  'use strict';
  return function XlTemplates() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.tpls = ko.observableArray([]);
    self.busy = ko.observable(false);

    /* expanded template rows (by templateId — survives reloads) */
    self.openIds = ko.observableArray([]);
    self.isOpen = function (t) { return self.openIds.indexOf(t.templateId) >= 0; };
    self.toggle = function (t) {
      if (self.isOpen(t)) self.openIds.remove(t.templateId);
      else self.openIds.push(t.templateId);
    };

    self.activeVer = function (t) {
      var hit = null;
      (t.versions || []).forEach(function (v) { if (v.isActive === 'Y') hit = v; });
      return hit;
    };
    self.verCount = function (t) { return (t.versions || []).length; };
    self.fileMeta = function (kb, by, at) {
      var bits = [];
      if (kb !== null && kb !== undefined) bits.push(kb + ' KB');
      if (by) bits.push(by);
      if (at) bits.push(at);
      return bits.join(' · ');
    };

    self.load = function () {
      self.loading(true);
      xl.list().then(function (r) { self.tpls(r.items || []); self.loading(false); })
        .catch(function () { self.loading(false); });
    };
    self.load();

    /* ── template create / edit drawer ─────────────────────────────────── */
    self.showForm = ko.observable(false);
    self.editId = ko.observable(null);
    self.fmCode = ko.observable(''); self.fmName = ko.observable('');
    self.fmNameAr = ko.observable(''); self.fmModule = ko.observable('');
    self.fmDesc = ko.observable('');
    self.formTitle = ko.computed(function () { return self.t(self.editId() ? 'atd.xl.edit' : 'atd.xl.new'); });
    self.formSaveLabel = ko.computed(function () { return self.t(self.editId() ? 'atd.action.saveChanges' : 'atd.action.create'); });
    self.showForm.subscribe(function (v) { if (!v) self.editId(null); });

    self.newTpl = function () {
      self.editId(null);
      self.fmCode(''); self.fmName(''); self.fmNameAr(''); self.fmModule(''); self.fmDesc('');
      self.showForm(true);
    };
    self.editTpl = function (t) {
      self.editId(t.templateId);
      self.fmCode(t.code || ''); self.fmName(t.name || ''); self.fmNameAr(t.nameAr || '');
      self.fmModule(t.module || ''); self.fmDesc(t.description || '');
      self.showForm(true);
    };
    self.saveTpl = function () {
      if (!self.editId() && (!self.fmCode() || !self.fmName())) {
        toast.error(self.t('atd.xl.codeNameRequired')); return;
      }
      var body = { name: self.fmName(), nameAr: self.fmNameAr(),
                   description: self.fmDesc(), module: self.fmModule() };
      if (self.editId()) body.templateId = self.editId();
      else body.code = self.fmCode();
      xl.save(body).then(function () {
        toast.success(self.t('atd.common.saved'));
        self.showForm(false); self.load();
      }).catch(function () {});
    };

    /* ── new version drawer ────────────────────────────────────────────── */
    self.showVerForm = ko.observable(false);
    self.verTplId = ko.observable(null);
    self.verTplCode = ko.observable('');
    self.fmNotes = ko.observable('');
    self.verFormTitle = ko.computed(function () {
      return self.t('atd.xl.newVersion') + (self.verTplCode() ? ' — ' + self.verTplCode() : '');
    });
    self.newVersion = function (t) {
      self.verTplId(t.templateId); self.verTplCode(t.code || '');
      self.fmNotes(''); self.showVerForm(true);
    };
    self.saveVersion = function () {
      xl.newVersion(self.verTplId(), self.fmNotes()).then(function (r) {
        toast.success(self.t('atd.xl.verCreated', [r.versionNo]));
        self.showVerForm(false);
        if (self.openIds.indexOf(self.verTplId()) < 0) self.openIds.push(self.verTplId());
        self.load();
      }).catch(function () {});
    };

    /* ── workbook upload / download ────────────────────────────────────── */
    self.upload = function (t, v, kind) {
      docUpload.choose({ accept: '.xlsx', maxMb: 25 }).then(function (file) {
        if (!file) return;
        self.busy(true);
        xl.uploadFile(t.templateId, v.versionNo, kind, file).then(function () {
          self.busy(false);
          toast.success(self.t('atd.xl.uploaded', [file.name]));
          self.load();
        }).catch(function () { self.busy(false); });
      });
    };

    self.download = function (t, v, kind) {
      var name = (kind === 'master' ? v.masterFile : v.pubFile) ||
                 (t.code + '_v' + v.versionNo + '_' + kind + '.xlsx');
      xl.fileBlobUrl(t.templateId, v.versionNo, kind).then(function (url) {
        var a = document.createElement('a');
        a.href = url; a.download = name;
        document.body.appendChild(a); a.click();
        document.body.removeChild(a);
        setTimeout(function () { URL.revokeObjectURL(url); }, 4000);
      }).catch(function () {});
    };

    /* ── version actions ───────────────────────────────────────────────── */
    self.activate = function (t, v) {
      if (!v.pubFile) { toast.error(self.t('atd.xl.needsPublished')); return; }
      if (!window.confirm(self.t('atd.xl.activateConfirm', [v.versionNo, t.code]))) return;
      xl.activate(t.templateId, v.versionNo).then(function () {
        toast.success(self.t('atd.common.saved')); self.load();
      }).catch(function () {});
    };

    self.delVersion = function (t, v) {
      if (v.isActive === 'Y') return;
      if (!window.confirm(self.t('atd.xl.deleteConfirm', [v.versionNo, t.code]))) return;
      xl.deleteVersion(t.templateId, v.versionNo).then(function () {
        toast.success(self.t('atd.common.saved')); self.load();
      }).catch(function () {});
    };
  };
});
