define(['knockout', 'services/rptService', 'shared/toast', 'shared/i18n'], function (ko, rpt, toast, i18n) {
  'use strict';

  function ReportsViewModel() {
    var self = this;
    self.loading = ko.observable(true);
    self.items   = ko.observableArray([]);
    self.total   = ko.observable(0);
    self.search  = ko.observable('');
    self.engine  = ko.observable('');
    self.limit   = 25;
    self.offset  = ko.observable(0);

    self.engines     = ['PYTHON', 'NATIVE'];
    self.sourceTypes = ['SQL', 'VIEW', 'PKG'];

    // ── modal form ──────────────────────────────────────────────────────
    self.editing = ko.observable(false);
    self.isNew   = ko.observable(false);
    self.saving  = ko.observable(false);
    self.fmCode    = ko.observable('');
    self.fmNameEn  = ko.observable('');
    self.fmNameAr  = ko.observable('');
    self.fmDesc    = ko.observable('');
    self.fmCategory = ko.observable('');
    self.fmSourceType = ko.observable('SQL');
    self.fmSourceRef  = ko.observable('');
    self.fmEngine  = ko.observable('PYTHON');
    self.fmFormats = ko.observable('PDF,XLSX');
    self.fmSubject = ko.observable('');
    self.fmBody    = ko.observable('');
    self.fmParams  = ko.observable('');
    self.fmEnabled = ko.observable(true);

    self.load = function () {
      self.loading(true);
      rpt.getReports({ search: self.search(), engine: self.engine(),
                       limit: self.limit, offset: self.offset() })
        .then(function (r) { self.items(r.items || []); self.total(r.total || 0); })
        .catch(function () {})
        .then(function () { self.loading(false); });
    };

    self.applyFilter = function () { self.offset(0); self.load(); };
    self.prev = function () { if (self.offset() > 0) { self.offset(Math.max(0, self.offset() - self.limit)); self.load(); } };
    self.next = function () { if (self.offset() + self.limit < self.total()) { self.offset(self.offset() + self.limit); self.load(); } };
    self.pageInfo = ko.computed(function () {
      var from = self.total() ? self.offset() + 1 : 0;
      var to = Math.min(self.offset() + self.limit, self.total());
      return from + '–' + to + ' / ' + self.total();
    });

    self.openNew = function () {
      self.isNew(true);
      self.fmCode(''); self.fmNameEn(''); self.fmNameAr(''); self.fmDesc(''); self.fmCategory('');
      self.fmSourceType('SQL'); self.fmSourceRef(''); self.fmEngine('PYTHON'); self.fmFormats('PDF,XLSX');
      self.fmSubject(''); self.fmBody(''); self.fmParams(''); self.fmEnabled(true);
      self.editing(true);
    };

    self.openEdit = function (row) {
      rpt.getReport(row.reportCode).then(function (d) {
        self.isNew(false);
        self.fmCode(d.reportCode); self.fmNameEn(d.nameEn); self.fmNameAr(d.nameAr || '');
        self.fmDesc(d.description || ''); self.fmCategory(d.category || '');
        self.fmSourceType(d.sourceType || 'SQL'); self.fmSourceRef(d.sourceRef || '');
        self.fmEngine(d.engine || 'PYTHON'); self.fmFormats(d.formats || 'PDF,XLSX');
        self.fmSubject(d.emailSubjectTpl || ''); self.fmBody(d.emailBodyTpl || '');
        self.fmParams(d.paramsJson || ''); self.fmEnabled((d.enabled || 'Y') === 'Y');
        self.editing(true);
      }).catch(function () {});
    };

    self.save = function () {
      if (self.saving()) return;
      var code = (self.fmCode() || '').trim().toUpperCase();
      if (!code) { toast.error('Report code is required'); return; }
      if (!self.fmNameEn()) { toast.error('Name (EN) is required'); return; }
      if (!self.fmSourceRef()) { toast.error('Source (SQL/view) is required'); return; }
      var payload = {
        reportCode: code, nameEn: self.fmNameEn(), nameAr: self.fmNameAr(),
        description: self.fmDesc(), category: self.fmCategory(),
        sourceType: self.fmSourceType(), sourceRef: self.fmSourceRef(),
        engine: self.fmEngine(), formats: self.fmFormats(),
        emailSubjectTpl: self.fmSubject(), emailBodyTpl: self.fmBody(),
        paramsJson: self.fmParams() || null, enabled: self.fmEnabled() ? 'Y' : 'N'
      };
      self.saving(true);
      var p = self.isNew() ? rpt.createReport(payload) : rpt.updateReport(code, payload);
      p.then(function () {
        self.saving(false); self.editing(false);
        toast.success(self.isNew() ? 'Report created' : 'Report updated');
        self.load();
      }).catch(function () { self.saving(false); });
    };

    // ── run with parameters (in-page drawer — no navigation to detail) ──
    self.runEditing = ko.observable(false);
    self.runSaving  = ko.observable(false);
    self.runCode    = ko.observable('');
    self.runName    = ko.observable('');
    self.runParams  = ko.observableArray([]);   // spec rows + value: ko.observable

    self.runNow = function (row) {
      rpt.getReportParams(row.reportCode).then(function (d) {
        var spec = (d && d.params) || [];
        if (!spec.length) {
          return rpt.runReport(row.reportCode).then(function (r) {
            toast.success('Queued run #' + r.runId);
            window._jetApp.navigate('runs');
          });
        }
        self.runCode(row.reportCode); self.runName(row.nameEn || row.reportCode);
        self.runParams(spec.map(function (p) { p.value = ko.observable(''); return p; }));
        self.runEditing(true);
      }).catch(function () {});
    };

    self.submitRun = function () {
      if (self.runSaving()) return;
      var params = {}, missing = [];
      self.runParams().forEach(function (p) {
        var v = (p.value() || '').trim();
        if (v === '') { if (p.required) missing.push(p.label || p.name); return; }
        params[p.name] = /^-?\d+(\.\d+)?$/.test(v) ? Number(v) : v;
      });
      if (missing.length) { toast.error(i18n.t('det.paramRequired') + ' ' + missing.join(', ')); return; }
      self.runSaving(true);
      rpt.runReport(self.runCode(), null, Object.keys(params).length ? params : null).then(function (r) {
        self.runSaving(false); self.runEditing(false);
        toast.success('Queued run #' + r.runId);
        window._jetApp.navigate('runs');
      }).catch(function () { self.runSaving(false); });
    };

    self.openDetail = function (row) { window._jetApp.navigate('reportDetail', { reportCode: row.reportCode }); };

    self.remove = function (row) {
      if (!window.confirm('Delete report "' + row.reportCode + '" and its schedules/recipients?')) return;
      rpt.deleteReport(row.reportCode).then(function () { toast.success('Deleted'); self.load(); }).catch(function () {});
    };

    self.load();
  }

  return ReportsViewModel;
});
