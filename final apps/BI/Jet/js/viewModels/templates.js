define(['knockout', 'services/rptService', 'shared/toast', 'shared/i18n', 'shared/docUpload'],
function (ko, rpt, toast, i18n, docUpload) {
  'use strict';

  // PDF report templates (DCT_RPT_TEMPLATE): .docx (Word -> LibreOffice PDF)
  // and .j2 (Jinja2 HTML -> Chromium PDF). Uploads go up as raw bytes
  // (api.putBinary); a saved template applies on the next run, no redeploy.
  function TemplatesViewModel() {
    var self = this;
    self.loading = ko.observable(true);
    self.items   = ko.observableArray([]);

    self.load = function () {
      self.loading(true);
      rpt.getTemplates()
        .then(function (r) { self.items(r.items || []); })
        .catch(function () {})
        .then(function () { self.loading(false); });
    };

    self.fmtBytes = function (n) {
      n = n || 0;
      return n < 1024 ? n + ' B' : n < 1048576 ? (n / 1024).toFixed(1) + ' KB' : (n / 1048576).toFixed(1) + ' MB';
    };

    // ── upload / replace drawer ─────────────────────────────────────────
    self.upEditing = ko.observable(false);
    self.upIsNew   = ko.observable(true);
    self.upSaving  = ko.observable(false);
    self.upName    = ko.observable('');
    self.upDescr   = ko.observable('');
    self.upFile    = ko.observable(null);

    self.openUpload = function () {
      self.upIsNew(true); self.upName(''); self.upDescr(''); self.upFile(null);
      self.upEditing(true);
    };

    self.openReplace = function (row) {
      self.upIsNew(false); self.upName(row.name); self.upDescr(row.description || '');
      self.upFile(null);
      self.upEditing(true);
    };

    self.chooseFile = function () {
      docUpload.choose({ accept: '.docx,.j2', maxMb: 10 }).then(function (file) {
        if (!file) return;
        self.upFile(file);
        if (self.upIsNew() && !self.upName()) self.upName(file.name);
      });
    };

    self.saveUpload = function () {
      if (self.upSaving()) return;
      var name = (self.upName() || '').trim();
      if (!/\.(docx|j2)$/i.test(name)) { toast.error(i18n.t('tpl.nameHint')); return; }
      if (!self.upFile()) { toast.error(i18n.t('tpl.noFile')); return; }
      self.upSaving(true);
      rpt.uploadTemplate(name, self.upFile(), self.upDescr()).then(function () {
        self.upSaving(false); self.upEditing(false);
        toast.success(i18n.t('tpl.uploaded'));
        self.load();
      }).catch(function () { self.upSaving(false); });
    };

    // ── download / delete ───────────────────────────────────────────────
    self.download = function (row) {
      rpt.templateUrl(row.name).then(function (url) {
        var a = document.createElement('a');
        a.href = url; a.download = row.name;
        document.body.appendChild(a); a.click(); document.body.removeChild(a);
        setTimeout(function () { URL.revokeObjectURL(url); }, 15000);
      }).catch(function () {});
    };

    self.remove = function (row) {
      if (row.usedBy > 0) return;
      if (!window.confirm(i18n.t('tpl.deleteConfirm', [row.name]))) return;
      rpt.deleteTemplate(row.name).then(function () {
        toast.success(i18n.t('tpl.deleted'));
        self.load();
      }).catch(function () {});
    };

    // ── authoring guide drawer ──────────────────────────────────────────
    self.guideOpen = ko.observable(false);
    self.openGuide = function () { self.guideOpen(true); };
    self.downloadStarter = function () {
      var starter = self.items().filter(function (t) { return t.name === 'report_starter.docx'; })[0];
      if (starter) { self.download(starter); }
      self.guideOpen(false);
    };

    self.load();
  }

  return TemplatesViewModel;
});
