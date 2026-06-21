define(['knockout', 'services/atdService', 'shared/i18n', 'shared/toast', 'util/duration'],
function (ko, atd, i18n, toast, fmtDuration) {
  'use strict';
  return function JobDetail() {
    var self = this;
    self.t = i18n.t;
    self.fmtDuration = fmtDuration;
    self.loading = ko.observable(true);
    self.job = ko.observable({});
    self.history = ko.observableArray([]);
    var name = (window._jetApp.getState() || {}).jobName;

    self.statusClass = function (s) { return 'rstat rstat--' + String(s || '').toUpperCase(); };
    self.back = function () { window._jetApp.navigate('jobs'); };

    self.refresh = function () {
      atd.getJob(name).then(function (j) {
        self.job(j); self.history(j.history || []); self.loading(false);
      }).catch(function () { self.loading(false); });
    };
    self.refresh();

    self.enqueue = function () {
      atd.enqueueJob(name).then(function () { toast.success(self.t('atd.jobs.enqueued')); self.refresh(); }).catch(function () {});
    };

    // Re-prepare: clear the stored column map so the next run re-derives it from the
    // live analysis. rebuild=true also drops + recreates the table (accept an
    // incompatible column change, discarding currently loaded rows).
    self.reprepare = function (rebuild) {
      if (!window.confirm(self.t(rebuild ? 'atd.jobs.confirmRebuild' : 'atd.jobs.confirmRemap'))) return;
      atd.reprepareJob(name, rebuild).then(function () {
        toast.success(self.t(rebuild ? 'atd.jobs.rebuilt' : 'atd.jobs.remapped'));
        self.refresh();
      }).catch(function () {});
    };

    // ---- Schema review / editor -------------------------------------------
    // Show the live staging-table structure with editable column name + data type
    // and an editable table name. Nothing changes until Apply (the staging table is
    // data-only, so Apply just drops + recreates it from the edited definition and
    // the next run reloads). The server validates names/types (blocks DDL injection).
    self.schemaOpen = ko.observable(false);
    self.schemaLoading = ko.observable(false);
    self.schemaTable = ko.observable('');
    self.schemaCols = ko.observableArray([]);
    self.typeOptions = ['NUMBER', 'VARCHAR2(20)', 'VARCHAR2(40)', 'VARCHAR2(100)',
                        'VARCHAR2(400)', 'VARCHAR2(1000)', 'DATE', 'TIMESTAMP'];

    self.loadSchema = function () {
      self.schemaLoading(true);
      atd.getSchema(name).then(function (s) {
        var rev = {};
        try {
          var cm = JSON.parse(s.columnMapJson || '{}');
          Object.keys(cm).forEach(function (h) { rev[String(cm[h]).toUpperCase()] = h; });
        } catch (e) { /* no map yet */ }
        self.schemaTable(s.stageTable || '');
        self.schemaCols((s.columns || []).map(function (c) {
          // surface the column's current type as an extra option so it's never lost
          if (self.typeOptions.indexOf(c.type) === -1) self.typeOptions.push(c.type);
          return { header: rev[String(c.name).toUpperCase()] || '',
                   name: ko.observable(c.name),
                   type: ko.observable(c.type),
                   sample: c.sample || '' };
        }));
        self.schemaLoading(false);
      }).catch(function () { self.schemaLoading(false); });
    };

    self.toggleSchema = function () {
      var open = !self.schemaOpen();
      self.schemaOpen(open);
      if (open && self.schemaCols().length === 0) self.loadSchema();
      return true;
    };

    self.applySchema = function () {
      if (!self.schemaCols().length) { toast.error(self.t('atd.schema.empty')); return; }
      if (!window.confirm(self.t('atd.schema.confirmApply'))) return;
      var body = {
        tableName: self.schemaTable(),
        columns: self.schemaCols().map(function (c) {
          return { header: c.header, name: c.name(), type: c.type() };
        })
      };
      atd.applySchema(name, body).then(function () {
        toast.success(self.t('atd.schema.applied'));
        self.schemaCols([]); self.loadSchema(); self.refresh();
      }).catch(function () { /* api.js toasts the validation message */ });
    };
  };
});
