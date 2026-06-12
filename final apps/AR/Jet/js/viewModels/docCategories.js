define(['knockout', 'services/arService', 'shared/i18n', 'shared/toast'],
function (ko, arService, i18n, toast) {
  'use strict';

  function DocCategoriesViewModel() {
    var self = this;
    self.t = i18n.t;

    self.loading    = ko.observable(true);
    self.categories = ko.observableArray([]);
    self.eventTypes = ko.observableArray([]);
    self.search     = ko.observable('');

    self.filteredCategories = ko.computed(function () {
      var q = (self.search() || '').trim().toLowerCase();
      if (!q) return self.categories();
      return self.categories().filter(function (c) {
        return [c.code, c.nameEn, c.nameAr, c.description, c.hints]
          .some(function (v) { return v && String(v).toLowerCase().indexOf(q) >= 0; });
      });
    });

    // editor
    self.editId      = ko.observable(null);
    self.code        = ko.observable('');
    self.nameEn      = ko.observable('');
    self.nameAr      = ko.observable('');
    self.description = ko.observable('');
    self.isPnlSource = ko.observable(false);
    self.pnlBasis    = ko.observable('ACTUAL');
    self.exLines     = ko.observable(false);
    self.exKpis      = ko.observable(false);
    self.exFindings  = ko.observable(false);
    self.exMeta      = ko.observable(false);
    self.hints       = ko.observable('');
    self.requiredFor = ko.observable('');
    self.showEditor  = ko.observable(false);
    self.saving      = ko.observable(false);

    arService.getLookups().then(function (lk) { self.eventTypes(lk.AR_EVENT_TYPE || []); });

    self.reload = function () {
      self.loading(true);
      arService.getDocCategories({ all: 1 }).then(function (res) {
        self.categories(res.items || []);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };

    self.newCat = function () {
      self.editId(null); self.code(''); self.nameEn(''); self.nameAr('');
      self.description(''); self.isPnlSource(false); self.pnlBasis('ACTUAL');
      self.exLines(false); self.exKpis(false); self.exFindings(false); self.exMeta(false);
      self.hints(''); self.requiredFor('');
      self.showEditor(true);
    };
    self.editCat = function (c) {
      self.editId(c.docCatId); self.code(c.code); self.nameEn(c.nameEn);
      self.nameAr(c.nameAr || ''); self.description(c.description || '');
      self.isPnlSource(!!c.isPnlSource); self.pnlBasis(c.pnlBasis || 'ACTUAL');
      self.exLines(!!c.extractLines); self.exKpis(!!c.extractKpis);
      self.exFindings(!!c.extractFindings); self.exMeta(!!c.extractMeta);
      self.hints(c.hints || ''); self.requiredFor(c.requiredFor || '');
      self.showEditor(true);
    };
    self.cancelEdit = function () { self.showEditor(false); };

    self.save = function () {
      if (!self.nameEn() || (!self.editId() && !self.code())) {
        toast.error('Code and English name are required'); return;
      }
      self.saving(true);
      var payload = {
        nameEn: self.nameEn(), nameAr: self.nameAr() || null,
        description: self.description() || null,
        isPnlSource: self.isPnlSource(),
        pnlBasis: self.isPnlSource() ? self.pnlBasis() : null,
        extractLines: self.exLines(), extractKpis: self.exKpis(),
        extractFindings: self.exFindings(), extractMeta: self.exMeta(),
        hints: self.hints() || null,
        requiredFor: self.requiredFor() || null,
      };
      var p = self.editId()
        ? arService.updateDocCategory(self.editId(), payload)
        : arService.createDocCategory(Object.assign({ code: self.code() }, payload));
      p.then(function () {
        self.saving(false); self.showEditor(false);
        toast.success('Document category saved');
        self.reload();
      }).catch(function (err) {
        self.saving(false);
        toast.error((err && err.message) || 'Save failed');
      });
    };

    self.toggleActive = function (c) {
      arService.updateDocCategory(c.docCatId, { isActive: !c.isActive }).then(self.reload);
    };

    self.flagsText = function (c) {
      var f = [];
      if (c.extractLines)    f.push('lines');
      if (c.extractKpis)     f.push('KPIs');
      if (c.extractFindings) f.push('findings');
      if (c.extractMeta)     f.push('meta');
      return f.length ? f.join(' · ') : '—';
    };

    self.reload();
  }

  return DocCategoriesViewModel;
});
