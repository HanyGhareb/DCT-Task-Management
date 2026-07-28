define(['knockout', 'shared/i18n', 'shared/toast', 'services/kpiService'],
function (ko, i18n, toast, kpi) {
  'use strict';

  function KpiEditViewModel() {
    var self = this;
    self.t    = i18n.t;
    self.lang = i18n.lang;

    var state = (window._jetApp && window._jetApp.getState()) || {};
    self.kpiId   = ko.observable(state.kpiId || null);
    self.isNew   = ko.pureComputed(function () { return !self.kpiId(); });
    self.loading = ko.observable(true);
    self.busy    = ko.observable(false);

    // definition fields
    self.code = ko.observable(''); self.nameEn = ko.observable(''); self.nameAr = ko.observable('');
    self.descriptionEn = ko.observable(''); self.descriptionAr = ko.observable('');
    self.kpiType = ko.observable('STRATEGIC'); self.polarity = ko.observable('ASCENDING');
    self.unitEn = ko.observable('Percentage'); self.unitAr = ko.observable('');
    self.frequency = ko.observable('ANNUAL'); self.calcMethod = ko.observable('RATIO_A_OVER_B');
    self.calcDescEn = ko.observable(''); self.calcDescAr = ko.observable('');
    self.sourceOfDataEn = ko.observable(''); self.sourceOfDataAr = ko.observable('');
    self.ownerEn = ko.observable(''); self.ownerAr = ko.observable('');
    self.noteEn = ko.observable(''); self.noteAr = ko.observable('');
    self.sourceCodeA = ko.observable(null); self.sourceCodeB = ko.observable(null);
    self.figureALabelEn = ko.observable(''); self.figureALabelAr = ko.observable('');
    self.figureBLabelEn = ko.observable(''); self.figureBLabelAr = ko.observable('');
    self.weight = ko.observable(25); self.requiresEvidence = ko.observable('N');
    self.displayOrder = ko.observable(100); self.isActive = ko.observable('Y');

    self.bands    = ko.observableArray([]);
    self.targets  = ko.observableArray([]);
    self.criteria = ko.observableArray([]);

    self.isAB = ko.pureComputed(function () {
      return ['RATIO_A_OVER_B', 'ABS_VARIANCE'].indexOf(self.calcMethod()) >= 0;
    });
    self.isWeighted = ko.pureComputed(function () { return self.calcMethod() === 'WEIGHTED_CRITERIA'; });

    self.weightSum = ko.pureComputed(function () {
      return self.criteria().reduce(function (s, c) {
        return c.isActive() === 'Y' ? s + (Number(c.weight()) || 0) : s;
      }, 0);
    });

    // lookups + sources from boot
    var lookups = [];
    self.sourceOpts = ko.observableArray([]);
    self.lookupOpts = function (cat) {
      return lookups.filter(function (l) { return l.category === cat; })
        .map(function (l) {
          return { code: l.code, label: self.lang() === 'ar' && l.nameAr ? l.nameAr : l.nameEn };
        });
    };

    function mkBand(b) {
      return { score: b.score,
               operator: ko.observable(b.operator || 'GE'),
               threshold1: ko.observable(('threshold1' in b) ? b.threshold1 : null),
               threshold2: ko.observable(('threshold2' in b) ? b.threshold2 : null),
               labelEn: ko.observable(b.labelEn || ''), labelAr: ko.observable(b.labelAr || '') };
    }
    function mkTarget(t) {
      return { year: ko.observable(t.year), value: ko.observable(('value' in t) ? t.value : null),
               labelEn: ko.observable(t.labelEn || ''), labelAr: ko.observable(t.labelAr || '') };
    }
    function mkLevel(l) {
      return { levelNo: l.levelNo, titleEn: ko.observable(l.titleEn || ''), titleAr: ko.observable(l.titleAr || ''),
               descriptionEn: ko.observable(l.descriptionEn || ''), descriptionAr: ko.observable(l.descriptionAr || '') };
    }
    function mkCriterion(c) {
      var levels = (c.levels && c.levels.length) ? c.levels : [1, 2, 3, 4, 5].map(function (n) { return { levelNo: n }; });
      return { criterionId: c.criterionId || null,
               code: ko.observable(c.code || ''), nameEn: ko.observable(c.nameEn || ''), nameAr: ko.observable(c.nameAr || ''),
               weight: ko.observable(('weight' in c) ? c.weight : 0),
               entryType: ko.observable(c.entryType || 'MATURITY_1_5'),
               isActive: ko.observable(c.isActive || 'Y'),
               displayOrder: c.displayOrder || 100,
               showLevels: ko.observable(false),
               levels: levels.map(mkLevel) };
    }

    function applyKpi(d) {
      self.code(d.code); self.nameEn(d.nameEn); self.nameAr(d.nameAr);
      self.descriptionEn(d.descriptionEn); self.descriptionAr(d.descriptionAr);
      self.kpiType(d.type); self.polarity(d.polarity);
      self.unitEn(d.unitEn); self.unitAr(d.unitAr);
      self.frequency(d.frequency); self.calcMethod(d.calcMethod);
      self.calcDescEn(d.calcDescEn); self.calcDescAr(d.calcDescAr);
      self.sourceOfDataEn(d.sourceOfDataEn); self.sourceOfDataAr(d.sourceOfDataAr);
      self.ownerEn(d.ownerEn); self.ownerAr(d.ownerAr);
      self.noteEn(d.noteEn); self.noteAr(d.noteAr);
      self.sourceCodeA(d.sourceCodeA || null); self.sourceCodeB(d.sourceCodeB || null);
      self.figureALabelEn(d.figureALabelEn); self.figureALabelAr(d.figureALabelAr);
      self.figureBLabelEn(d.figureBLabelEn); self.figureBLabelAr(d.figureBLabelAr);
      self.weight(d.weight); self.requiresEvidence(d.requiresEvidence);
      self.displayOrder(d.displayOrder); self.isActive(d.isActive);
      var byScore = {};
      (d.bands || []).forEach(function (b) { byScore[b.score] = b; });
      self.bands([5, 4, 3, 2, 1].map(function (s) { return mkBand(byScore[s] || { score: s, operator: 'GE' }); }));
      self.targets((d.targets || []).map(mkTarget));
      self.criteria((d.criteria || []).map(mkCriterion));
    }

    function defBody() {
      return {
        kpiId: self.kpiId(), code: self.code(), nameEn: self.nameEn(), nameAr: self.nameAr(),
        descriptionEn: self.descriptionEn(), descriptionAr: self.descriptionAr(),
        type: self.kpiType(), polarity: self.polarity(),
        unitEn: self.unitEn(), unitAr: self.unitAr(),
        frequency: self.frequency(), calcMethod: self.calcMethod(),
        calcDescEn: self.calcDescEn(), calcDescAr: self.calcDescAr(),
        sourceOfDataEn: self.sourceOfDataEn(), sourceOfDataAr: self.sourceOfDataAr(),
        ownerEn: self.ownerEn(), ownerAr: self.ownerAr(),
        noteEn: self.noteEn(), noteAr: self.noteAr(),
        sourceCodeA: self.sourceCodeA() || null, sourceCodeB: self.sourceCodeB() || null,
        figureALabelEn: self.figureALabelEn(), figureALabelAr: self.figureALabelAr(),
        figureBLabelEn: self.figureBLabelEn(), figureBLabelAr: self.figureBLabelAr(),
        weight: Number(self.weight()) || 25, requiresEvidence: self.requiresEvidence(),
        displayOrder: Number(self.displayOrder()) || 100, isActive: self.isActive()
      };
    }

    self.saveDefinition = function () {
      if (!self.code() || !self.nameEn()) { toast.error(self.t('ke.needCodeName')); return; }
      self.busy(true);
      kpi.saveKpi(defBody()).then(function (d) {
        var wasNew = self.isNew();
        if (d && d.kpiId) self.kpiId(d.kpiId);
        toast.success(self.t('common.saved'));
        self.busy(false);
        if (wasNew) load();
      }).catch(function (err) { toast.error((err && err.message) || 'Failed'); self.busy(false); });
    };

    self.saveBands = function () {
      self.busy(true);
      kpi.saveBands(self.kpiId(), self.bands().map(function (b) {
        return { score: b.score, operator: b.operator(),
                 threshold1: b.threshold1() === '' ? null : Number(b.threshold1()),
                 threshold2: b.threshold2() === '' || b.threshold2() == null ? null : Number(b.threshold2()),
                 labelEn: b.labelEn(), labelAr: b.labelAr() };
      })).then(function () { toast.success(self.t('common.saved')); self.busy(false); })
        .catch(function (err) { toast.error((err && err.message) || 'Failed'); self.busy(false); });
    };

    self.addTarget = function () {
      self.targets.push(mkTarget({ year: new Date().getFullYear() + 1 }));
    };
    self.removeTarget = function (row) {
      if (row.year()) self._removedYears.push(Number(row.year()));
      self.targets.remove(row);
    };
    self._removedYears = [];
    self.saveTargets = function () {
      self.busy(true);
      kpi.saveTargets(self.kpiId(), self.targets().map(function (t0) {
        return { year: Number(t0.year()), value: Number(t0.value()),
                 labelEn: t0.labelEn(), labelAr: t0.labelAr() };
      }), self._removedYears).then(function () {
        self._removedYears = [];
        toast.success(self.t('common.saved')); self.busy(false);
      }).catch(function (err) { toast.error((err && err.message) || 'Failed'); self.busy(false); });
    };

    self.addCriterion = function () {
      self.criteria.push(mkCriterion({ weight: 0, entryType: 'MATURITY_1_5' }));
    };
    self.saveCriteria = function () {
      self.busy(true);
      kpi.saveCriteria(self.kpiId(), self.criteria().map(function (c, i) {
        return { criterionId: c.criterionId, code: c.code(), nameEn: c.nameEn(), nameAr: c.nameAr(),
                 weight: Number(c.weight()) || 0, entryType: c.entryType(), isActive: c.isActive(),
                 displayOrder: (i + 1) * 10,
                 levels: c.entryType() === 'MATURITY_1_5' ? c.levels.map(function (l) {
                   return { levelNo: l.levelNo, titleEn: l.titleEn(), titleAr: l.titleAr(),
                            descriptionEn: l.descriptionEn(), descriptionAr: l.descriptionAr() };
                 }) : [] };
      })).then(function () {
        toast.success(self.t('common.saved')); self.busy(false); load();
      }).catch(function (err) { toast.error((err && err.message) || 'Failed'); self.busy(false); });
    };

    self.deactivate = function () {
      if (!window.confirm(self.t('ke.deactivateConfirm'))) return;
      kpi.deleteKpi(self.kpiId()).then(function () {
        toast.success(self.t('common.saved'));
        window._jetApp.navigate('kpiList');
      });
    };

    self.goBack = function () { window._jetApp.navigate('kpiList'); };

    function load() {
      kpi.boot().then(function (b) {
        lookups = b.lookups || [];
        self.sourceOpts((b.sources || []).filter(function (s) { return s.isActive === 'Y'; })
          .map(function (s) {
            return { code: s.code, label: self.lang() === 'ar' && s.nameAr ? s.nameAr : s.nameEn };
          }));
        if (self.kpiId()) return kpi.getKpi(self.kpiId());
        return null;
      }).then(function (d) {
        if (d) applyKpi(d);
        else self.bands([5, 4, 3, 2, 1].map(function (s) { return mkBand({ score: s, operator: 'GE' }); }));
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    load();
  }

  return KpiEditViewModel;
});
