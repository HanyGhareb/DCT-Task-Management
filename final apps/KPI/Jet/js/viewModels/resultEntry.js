define(['knockout', 'shared/i18n', 'shared/toast', 'shared/docUpload',
        'services/kpiService', 'services/authService'],
function (ko, i18n, toast, docUpload, kpi, auth) {
  'use strict';

  var UI_KEY = 'kpi_ui';
  function uiGet() { try { return JSON.parse(localStorage.getItem(UI_KEY)) || {}; } catch (e) { return {}; } }
  function uiSet(k, v) { var u = uiGet(); u[k] = v; try { localStorage.setItem(UI_KEY, JSON.stringify(u)); } catch (e) {} }

  function ResultEntryViewModel() {
    var self = this;
    self.t    = i18n.t;
    self.lang = i18n.lang;

    var state = (window._jetApp && window._jetApp.getState()) || {};
    self.resultId = state.resultId;

    self.loading  = ko.observable(true);
    self.busy     = ko.observable(false);
    self.r        = ko.observable({});
    self.figureA  = ko.observable(null);
    self.figureB  = ko.observable(null);
    self.notes    = ko.observable('');
    self.criteria = ko.observableArray([]);
    self.docs     = ko.observableArray([]);
    self.history  = ko.observableArray([]);
    self.bands    = ko.observableArray([]);

    /* FPB-style collapsible regions (calc = "how this KPI is scored", collapsed by default) */
    var u = uiGet();
    self.sec = {
      calc:     ko.observable(u['re.calc'] !== undefined ? u['re.calc'] : false),
      figures:  ko.observable(true),
      criteria: ko.observable(true),
      evidence: ko.observable(true),
      trail:    ko.observable(true)
    };
    self.toggleSec = function (k) {
      var open = !self.sec[k]();
      self.sec[k](open);
      if (k === 'calc') uiSet('re.calc', open);
    };

    var me = auth.getCurrentUser() || {};

    self.editable = ko.pureComputed(function () {
      var r = self.r();
      if (['DRAFT', 'RETURNED'].indexOf(r.status) < 0) return false;
      return r.preparedBy === me.userId || auth.isKpiAdmin();
    });
    self.isAB       = ko.pureComputed(function () {
      return ['RATIO_A_OVER_B', 'ABS_VARIANCE'].indexOf(self.r().calcMethod) >= 0;
    });
    self.isWeighted = ko.pureComputed(function () { return self.r().calcMethod === 'WEIGHTED_CRITERIA'; });
    self.hasSources = ko.pureComputed(function () {
      var r = self.r();
      return self.isAB() && (r.suggestedA != null || r.suggestedB != null);
    });

    self.kpiName = ko.pureComputed(function () {
      var r = self.r();
      return self.lang() === 'ar' && r.kpiNameAr ? r.kpiNameAr : (r.kpiNameEn || '');
    });
    self.figALabel = ko.pureComputed(function () {
      var r = self.r();
      return (self.lang() === 'ar' && r.figureALabelAr ? r.figureALabelAr : r.figureALabelEn) || self.t('re.figureA');
    });
    self.figBLabel = ko.pureComputed(function () {
      var r = self.r();
      return (self.lang() === 'ar' && r.figureBLabelAr ? r.figureBLabelAr : r.figureBLabelEn) || self.t('re.figureB');
    });

    self.statusWord = function (s) {
      return self.t('kpi.st' + s.charAt(0) + s.slice(1).toLowerCase());
    };
    self.statusLabel = ko.pureComputed(function () {
      return self.r().status ? self.statusWord(self.r().status) : '';
    });
    self.statusBadgeOf = function (s) {
      return 'badge ' + ({ DRAFT: 'badge--idle', SUBMITTED: 'badge--warning',
                           APPROVED: 'badge--approved', RETURNED: 'badge--rejected' }[s] || 'badge--idle');
    };
    self.statusBadge = ko.pureComputed(function () { return self.statusBadgeOf(self.r().status || 'DRAFT'); });

    self.fmt = function (v) { return v == null ? '' : Number(v).toLocaleString('en-AE'); };

    /* band condition text: operator + thresholds + unit, e.g. "≥ 108%" */
    self.unitLabel = ko.pureComputed(function () {
      var r = self.r();
      return (self.lang() === 'ar' && r.unitAr ? r.unitAr : r.unitEn) || '';
    });
    self.bandCond = function (b) {
      var ul = self.unitLabel();
      var un = (ul === '%' || /^percent/i.test(ul) || ul.indexOf('نسبة') >= 0)
               ? '%' : (ul ? ' ' + ul : '');
      var v1 = b.threshold1 != null ? self.fmt(b.threshold1) + un : '';
      var v2 = b.threshold2 != null ? self.fmt(b.threshold2) + un : '';
      switch (b.operator) {
        case 'LT': return '< ' + v1;
        case 'LE': return '≤ ' + v1;
        case 'EQ': return '= ' + v1;
        case 'GE': return '≥ ' + v1;
        case 'GT': return '> ' + v1;
        case 'BETWEEN': return v1 + ' – ' + v2;
        default: return v1;
      }
    };
    self.bandLabel = function (b) {
      return (self.lang() === 'ar' && b.labelAr ? b.labelAr : b.labelEn) || '';
    };
    self.fmtSize = function (b) {
      if (b == null) return '';
      return b > 1048576 ? (b / 1048576).toFixed(1) + ' MB' : Math.max(1, Math.round(b / 1024)) + ' KB';
    };

    function applyResult(d) {
      d.resultPct = ('resultPct' in d) ? d.resultPct : null;
      d.score     = ('score' in d) ? d.score : null;
      d.suggestedA = ('suggestedA' in d) ? d.suggestedA : null;
      d.suggestedB = ('suggestedB' in d) ? d.suggestedB : null;
      d.figureA    = ('figureA' in d) ? d.figureA : null;
      d.figureB    = ('figureB' in d) ? d.figureB : null;
      d.targetValue = ('targetValue' in d) ? d.targetValue : null;
      d.wfInstanceId = ('wfInstanceId' in d) ? d.wfInstanceId : null;
      self.r(d);
      self.figureA(d.figureA);
      self.figureB(d.figureB);
      self.notes(d.notes || '');
      self.criteria((d.criteria || []).map(function (c) {
        c.levelNo       = ko.observable(('levelNo' in c) ? c.levelNo : null);
        c.achievedPct   = ko.observable(('achievedPct' in c) ? c.achievedPct : null);
        c.justification = ko.observable(c.justification || '');
        c.critScore     = ko.observable(('critScore' in c) ? c.critScore : null);
        return c;
      }));
      self.history(d.history || []);
    }

    function load() {
      kpi.getResult(self.resultId).then(function (d) {
        applyResult(d);
        if (d.kpiId && self.bands().length === 0) {
          kpi.getKpi(d.kpiId).then(function (def) {
            self.bands(def.bands || []);
          }).catch(function () {});
        }
        return kpi.getDocs(self.resultId);
      }).then(function (docs) {
        self.docs(docs);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    function patchScore(d) {
      var r = self.r();
      r.resultPct = ('resultPct' in d) ? d.resultPct : null;
      r.score     = ('score' in d) ? d.score : null;
      self.r(Object.assign({}, r));
    }

    self.save = function () {
      self.busy(true);
      kpi.saveResult(self.resultId, {
        figureA: self.figureA() === '' ? null : Number(self.figureA()),
        figureB: self.figureB() === '' ? null : Number(self.figureB()),
        notes: self.notes()
      }).then(function (d) {
        patchScore(d);
        toast.success(self.t('re.saved'));
        self.busy(false);
      }).catch(function (err) {
        toast.error((err && err.message) || 'Failed'); self.busy(false);
      });
    };

    self.useSuggested = function (which) {
      var r = self.r();
      if (which === 'a') self.figureA(r.suggestedA);
      else self.figureB(r.suggestedB);
      self.save();
    };

    self.refreshSuggestion = function () {
      self.busy(true);
      kpi.refreshSuggestions(self.resultId).then(function () {
        self.busy(false); load();
      }).catch(function () { self.busy(false); });
    };

    self.pickLevel = function (crit, levelNo) {
      crit.levelNo(levelNo);
      self.saveCriterion(crit);
    };

    self.saveCriterion = function (crit) {
      kpi.saveCriterion(self.resultId, crit.criterionId, {
        levelNo: crit.levelNo(),
        achievedPct: crit.achievedPct() === '' || crit.achievedPct() == null ? null : Number(crit.achievedPct()),
        justification: crit.justification()
      }).then(function (d) {
        patchScore(d);
      }).catch(function (err) {
        toast.error((err && err.message) || 'Failed');
      });
    };

    self.submit = function () {
      if (!window.confirm(self.t('re.submitConfirm'))) return;
      var chain = self.isAB() ? kpi.saveResult(self.resultId, {
        figureA: self.figureA() === '' ? null : Number(self.figureA()),
        figureB: self.figureB() === '' ? null : Number(self.figureB()),
        notes: self.notes()
      }) : Promise.resolve();
      self.busy(true);
      chain.then(function () {
        return kpi.submitResult(self.resultId);
      }).then(function () {
        toast.success(self.t('re.submitted'));
        self.busy(false); load();
      }).catch(function (err) {
        toast.error((err && err.message) || 'Failed'); self.busy(false);
      });
    };

    self.uploadDoc = function () {
      docUpload.choose({ maxMb: 10 }).then(function (file) {
        if (!file) return;
        self.busy(true);
        kpi.uploadDoc(self.resultId, file).then(function () {
          toast.success(self.t('re.uploaded'));
          return kpi.getDocs(self.resultId);
        }).then(function (docs) { self.docs(docs); self.busy(false); })
          .catch(function (err) {
            toast.error((err && err.message) || 'Upload failed'); self.busy(false);
          });
      });
    };

    self.downloadDoc = function (doc) {
      var win = window.open('', '_blank');
      kpi.docUrl(doc.docId).then(function (url) { if (win) win.location = url; })
        .catch(function () { if (win) win.close(); });
    };

    self.removeDoc = function (doc) {
      if (!window.confirm(self.t('re.deleteDocConfirm'))) return;
      kpi.deleteDoc(doc.docId).then(function () {
        return kpi.getDocs(self.resultId);
      }).then(function (docs) { self.docs(docs); });
    };

    self.goBack = function () { window._jetApp.navigate('results'); };

    if (!self.resultId) { self.goBack(); return; }
    load();
  }

  return ResultEntryViewModel;
});
