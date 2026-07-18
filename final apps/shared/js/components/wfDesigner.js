/**
 * shared/js/components/wfDesigner.js — <wf-designer> Knockout component.
 *
 * Requirement 1: a business admin edits an approval chain from a UI page, with no
 * code deploy. This is the whole point of the platform, expressed as one component.
 *
 * The safety model is the server's, surfaced here:
 *   - A PUBLISHED version is read-only. "Edit chain" CLONES it to a DRAFT
 *     (idempotent — resumes the open draft), so in-flight instances are untouched.
 *   - Publish is REFUSED on an incomplete draft; the problems are shown, not hidden.
 *   - A condition is compiled live (server-side) as you type — an invalid one is
 *     stored but can never be published.
 *
 * There is NO hard-coded approval verb, resolver, or outcome here: the outcome sets,
 * the fact fields (for conditions) and the resolver list are DATA. Adding an outcome
 * or a fact field is a server change this UI picks up with no edit.
 *
 * Usage (Admin #processes is a 3-line host):
 *   <wf-designer params="modules: ['FL_CONTRACT']"></wf-designer>
 *   modules  array|null  optional source_module filter (null = every process)
 */
define(['knockout', 'shared/i18n', 'shared/wfService', 'shared/skeleton',
        'shared/components/wfDiagram',
        'text!shared/components/wfDesigner.html'],
function (ko, i18n, wf, skeletonReg, wfDiagramReg, templateHtml) {
  'use strict';

  var RESOLVERS = ['ROLE', 'ROLE_SCOPED_ORG', 'ASSIGNED_ROLE', 'FACT_USER', 'STATIC_USER',
                   'LINE_MANAGER', 'FACT_LINE_MANAGER', 'ORG_HEAD',
                   'PREVIOUS_ACTOR', 'INITIATOR'];
  var FALLBACKS  = ['ANY_ROLE_HOLDER', 'BUSINESS_ADMIN', 'ORG_HEAD', 'FAIL', 'NONE'];
  var COMMENTS   = ['ON_NEGATIVE', 'ALWAYS', 'NEVER'];
  var QUORUMS    = ['ALL', 'ANY', 'N_OF_M', 'PERCENT'];
  var KINDS      = ['HUMAN', 'SYSTEM', 'NOTIFY'];

  function unwrap(v) { return ko.isObservable(v) ? v() : v; }

  function DesignerVM(params) {
    var self = this;
    params = params || {};
    var scope = unwrap(params.modules) || [];

    self.t = i18n.t;
    self.RESOLVERS = RESOLVERS; self.FALLBACKS = FALLBACKS;
    self.COMMENTS = COMMENTS; self.QUORUMS = QUORUMS; self.KINDS = KINDS;

    self.loading  = ko.observable(true);
    self.busy     = ko.observable(false);
    self.err      = ko.observable(null);
    self.note     = ko.observable(null);

    self.processes = ko.observableArray([]);
    self.selected  = ko.observable(null);      // the picked process (list row)
    self.design    = ko.observable(null);      // the loaded version definition
    self.outcomeSets = ko.observableArray([]);
    self.schemaFields = ko.observableArray([]);

    self.editable = ko.pureComputed(function () {
      var d = self.design(); return !!(d && d.editable === 'Y');
    });
    self.outcomeSetCodes = ko.pureComputed(function () {
      return self.outcomeSets().map(function (s) { return s.setCode; });
    });
    self.conditionKeys = ko.pureComputed(function () {
      var d = self.design();
      return [''].concat(((d && d.conditions) || []).map(function (c) { return c.conditionKey; }));
    });

    /* ── list vs. graphical (flowchart) view of the chain ───────────────── */
    self.viewMode = ko.observable('list');   // 'list' | 'diagram'
    self.diagramNodes = ko.pureComputed(function () {
      var d = self.design(); if (!d) return [];
      var conds = {};
      (d.conditions || []).forEach(function (c) { conds[c.conditionKey] = c.expr; });
      return (d.steps || []).slice()
        .sort(function (a, b) { return (a.stepSeq || 0) - (b.stepSeq || 0); })
        .map(function (s) {
          var who = (s.participants || []).map(function (p) { return self.partSummary(p); }).join(', ');
          return {
            key: s.stepKey,
            title: s.nameEn || s.stepKey,
            titleAr: s.nameAr || s.nameEn || s.stepKey,
            condition: s.conditionKey ? (conds[s.conditionKey] || s.conditionKey) : null,
            outcomeSet: s.outcomeSetCode || null,
            who: who || null,
            isFinalGate: s.isFinalGate === 'Y',
            parallelGroup: s.parallelGroup || null,
            state: null, meta: null
          };
        });
    });

    /* ── formatting helpers ─────────────────────────────────────────────── */
    self.money = function (v) { return v == null ? '' : v; };
    self.outcomeSetLabel = function (code) {
      var s = self.outcomeSets().filter(function (x) { return x.setCode === code; })[0];
      return s ? (i18n.lang && i18n.lang() === 'ar' ? s.nameAr : s.nameEn) || code : code;
    };
    self.stepConditionExpr = function (step) {
      var d = self.design(); if (!step.conditionKey || !d) return null;
      var c = (d.conditions || []).filter(function (x) { return x.conditionKey === step.conditionKey; })[0];
      return c ? c.expr : null;
    };
    self.partSummary = function (p) {
      if (p.resolverType === 'ROLE' || p.resolverType === 'ROLE_SCOPED_ORG') return p.roleCode || p.resolverType;
      if (p.resolverType === 'ASSIGNED_ROLE') return (p.roleCode || '?') + '@' + (p.objectTypeCode || '?');
      if (p.resolverType === 'FACT_USER' || p.resolverType === 'FACT_LINE_MANAGER') return p.factPath || 'fact';
      if (p.resolverType === 'STATIC_USER') return '#' + (p.staticUserId || '?');
      return p.resolverType;
    };

    /* ── loading ────────────────────────────────────────────────────────── */
    self.objTypes = ko.observableArray([]);   // ASSIGNED_ROLE object-type registry
    self.typeTwoPart = function (code) {
      var t = self.objTypes().filter(function (x) { return x.code === code; })[0];
      return !!(t && t.twoPart === 'Y');
    };
    self.load = function () {
      self.loading(true); self.err(null);
      // the assignment registry is optional context (a non-WF_ADMIN designer
      // reader may 403 on it) -- never let it block the page
      wf.assignMeta().then(function (m) { self.objTypes((m && m.items) || []); })
                     .catch(function () { self.objTypes([]); });
      return Promise.all([wf.processes(), wf.outcomeSets()]).then(function (r) {
        var items = r[0] || [];
        if (scope && scope.length) {
          items = items.filter(function (i) { return scope.indexOf(i.module) >= 0; });
        }
        self.processes(items);
        self.outcomeSets(r[1] || []);
        self.loading(false);
      }).catch(function (e) { self.err(self._msg(e)); self.loading(false); });
    };

    self._msg = function (e) {
      return (e && (e.message || (e.body && e.body.error))) || 'Something went wrong.';
    };
    self._flash = function (m) { self.note(m); setTimeout(function () { self.note(null); }, 3500); };

    self.loadDesign = function (versionId) {
      if (!versionId) { self.design(null); self.schemaFields([]); return Promise.resolve(); }
      return wf.design(versionId).then(function (d) {
        self.design(d);
        if (d && d.schemaId) {
          return wf.schemaFields(d.schemaId).then(function (f) { self.schemaFields(f); });
        }
        self.schemaFields([]);
      });
    };

    self.selectProcess = function (p) {
      self.selected(p); self.err(null);
      // load the PUBLISHED version read-only; "Edit chain" reveals/creates the draft
      return self.loadDesign(p.versionId);
    };

    self.isSelected = function (p) {
      var s = self.selected(); return s && s.processCode === p.processCode;
    };

    /* ── draft lifecycle ────────────────────────────────────────────────── */
    self.editChain = function () {
      var p = self.selected(); if (!p) return;
      self.busy(true); self.err(null);
      wf.cloneDraft(p.processCode).then(function (r) {
        return self.loadDesign(r.versionId);
      }).then(function () {
        self.busy(false); self._flash(i18n.t('wf.dz.draftReady'));
      }).catch(function (e) { self.busy(false); self.err(self._msg(e)); });
    };

    self.discard = function () {
      var d = self.design(); if (!d || !self.editable()) return;
      if (!window.confirm(i18n.t('wf.dz.confirmDiscard'))) return;
      self.busy(true);
      wf.discardDraft(d.versionId).then(function () {
        self.busy(false);
        return self.selectProcess(self.selected());   // back to published
      }).then(function () { self.load(); })
        .catch(function (e) { self.busy(false); self.err(self._msg(e)); });
    };

    self.validate = function () {
      var d = self.design(); if (!d) return;
      self.busy(true); self.err(null);
      wf.validateVersion(d.versionId).then(function (r) {
        self.busy(false);
        self._flash(r.clean ? i18n.t('wf.dz.validClean') : (i18n.t('wf.dz.problems') + ' ' + r.problems));
      }).catch(function (e) { self.busy(false); self.err(self._msg(e)); });
    };

    self.publish = function () {
      var d = self.design(); if (!d || !self.editable()) return;
      self.busy(true); self.err(null);
      wf.validateVersion(d.versionId).then(function (r) {
        if (!r.clean) { self.busy(false); self.err(i18n.t('wf.dz.cannotPublish') + ' ' + r.problems); return null; }
        if (!window.confirm(i18n.t('wf.dz.confirmPublish'))) { self.busy(false); return null; }
        return wf.publishVersion(d.versionId).then(function () {
          self.busy(false); self._flash(i18n.t('wf.dz.published'));
          return self.load().then(function () {
            // re-point selection at the now-published version
            var p = self.processes().filter(function (x) { return x.processCode === self.selected().processCode; })[0];
            if (p) { self.selected(p); return self.loadDesign(p.versionId); }
          });
        });
      }).catch(function (e) { self.busy(false); self.err(self._msg(e)); });
    };

    /* ── step editor (modal) ────────────────────────────────────────────── */
    self.stepOpen  = ko.observable(false);
    self.stepIsNew = ko.observable(false);
    self.fmStepKey   = ko.observable('');
    self.fmNameEn    = ko.observable('');
    self.fmNameAr    = ko.observable('');
    self.fmKind      = ko.observable('HUMAN');
    self.fmOutcome   = ko.observable('');
    self.fmCondition = ko.observable('');
    self.fmSla       = ko.observable('');
    self.fmComment   = ko.observable('ON_NEGATIVE');
    self.fmFinalGate = ko.observable(false);
    self.fmQuorum    = ko.observable('ALL');
    // timers: reminders BEFORE due ('48,24,4'), escalation + auto-action AFTER
    // due -- all executed by the 15-min engine sweep, all plain step data
    self.fmReminders   = ko.observable('');
    self.fmEscRole     = ko.observable('');
    self.fmEscHours    = ko.observable('');
    self.fmAutoOutcome = ko.observable('');
    self.fmAutoHours   = ko.observable('');
    self.fmParts     = ko.observableArray([]);
    self._origParts  = [];

    self.newStep = function () {
      self.stepIsNew(true);
      self.fmStepKey(''); self.fmNameEn(''); self.fmNameAr(''); self.fmKind('HUMAN');
      self.fmOutcome(self.outcomeSetCodes()[0] || ''); self.fmCondition('');
      self.fmSla(''); self.fmComment('ON_NEGATIVE'); self.fmFinalGate(false); self.fmQuorum('ALL');
      self.fmReminders(''); self.fmEscRole(''); self.fmEscHours('');
      self.fmAutoOutcome(''); self.fmAutoHours('');
      self.fmParts([]); self._origParts = [];
      self.stepOpen(true);
    };

    self.editStep = function (step) {
      self.stepIsNew(false);
      self.fmStepKey(step.stepKey); self.fmNameEn(step.nameEn || ''); self.fmNameAr(step.nameAr || '');
      self.fmKind(step.stepKind || 'HUMAN'); self.fmOutcome(step.outcomeSetCode || '');
      self.fmCondition(step.conditionKey || ''); self.fmSla(step.slaHours == null ? '' : step.slaHours);
      self.fmComment(step.commentRequired || 'ON_NEGATIVE');
      self.fmFinalGate(step.isFinalGate === 'Y'); self.fmQuorum(step.quorumType || 'ALL');
      self.fmReminders(step.reminderOffsets || '');
      self.fmEscRole(step.escalateRoleCode || '');
      self.fmEscHours(step.escalateAfterHours == null ? '' : step.escalateAfterHours);
      self.fmAutoOutcome(step.autoActionOutcome || '');
      self.fmAutoHours(step.autoActionAfterHours == null ? '' : step.autoActionAfterHours);
      var parts = (step.participants || []).map(function (p) {
        return {
          ruleId: p.ruleId,
          resolverType: ko.observable(p.resolverType),
          roleCode: ko.observable(p.roleCode || ''),
          factPath: ko.observable(p.factPath || ''),
          staticUserId: ko.observable(p.staticUserId || ''),
          levelsUp: ko.observable(p.levelsUp == null ? 0 : p.levelsUp),
          objectTypeCode: ko.observable(p.objectTypeCode || ''),
          key2FactPath: ko.observable(p.key2FactPath || ''),
          fallbackRule: ko.observable(p.fallbackRule || 'ANY_ROLE_HOLDER'),
          excludeInitiator: ko.observable(p.excludeInitiator === 'Y')
        };
      });
      self.fmParts(parts);
      self._origParts = (step.participants || []).map(function (p) { return p.ruleId; });
      self.stepOpen(true);
    };

    self.addPart = function () {
      self.fmParts.push({
        ruleId: null, resolverType: ko.observable('ROLE'), roleCode: ko.observable(''),
        factPath: ko.observable(''), staticUserId: ko.observable(''), levelsUp: ko.observable(0),
        objectTypeCode: ko.observable(''), key2FactPath: ko.observable(''),
        fallbackRule: ko.observable('ANY_ROLE_HOLDER'), excludeInitiator: ko.observable(true)
      });
    };
    self.removePart = function (p) { self.fmParts.remove(p); };

    self.saveStep = function () {
      var d = self.design(); if (!d) return;
      var key = (self.fmStepKey() || '').trim().toUpperCase().replace(/[^A-Z0-9_]/g, '_');
      if (!key) { self.err(i18n.t('wf.dz.needStepKey')); return; }
      self.busy(true); self.err(null);
      var stepBody = {
        stepKey: key, nameEn: self.fmNameEn(), nameAr: self.fmNameAr(), stepKind: self.fmKind(),
        outcomeSetCode: self.fmOutcome() || null,
        conditionKey: self.fmCondition() || null,
        slaHours: self.fmSla() === '' ? null : Number(self.fmSla()),
        commentRequired: self.fmComment(), isFinalGate: self.fmFinalGate() ? 'Y' : 'N',
        quorumType: self.fmQuorum(),
        reminderOffsets: self.fmReminders() || null,
        escalateRoleCode: (self.fmEscRole() || '').trim().toUpperCase() || null,
        escalateAfterHours: self.fmEscHours() === '' ? null : Number(self.fmEscHours()),
        autoActionOutcome: (self.fmAutoOutcome() || '').trim().toUpperCase() || null,
        autoActionAfterHours: self.fmAutoHours() === '' ? null : Number(self.fmAutoHours())
      };
      var vid = d.versionId;
      wf.saveStep(vid, stepBody).then(function () {
        // reconcile participants: upsert current, delete removed
        var cur = self.fmParts();
        var keptIds = cur.map(function (p) { return p.ruleId; }).filter(Boolean);
        var toDelete = self._origParts.filter(function (id) { return keptIds.indexOf(id) < 0; });
        var jobs = cur.map(function (p) {
          return wf.saveParticipant(vid, {
            ruleId: p.ruleId, stepKey: key, participantType: 'POTENTIAL_OWNER',
            resolverType: p.resolverType(), roleCode: p.roleCode() || null,
            factPath: p.factPath() || null,
            staticUserId: p.staticUserId() === '' ? null : Number(p.staticUserId()),
            levelsUp: (p.levelsUp() === '' || p.levelsUp() == null) ? 0 : Number(p.levelsUp()),
            objectTypeCode: p.objectTypeCode() || null,
            key2FactPath: p.key2FactPath() || null,
            fallbackRule: p.fallbackRule(), excludeInitiator: p.excludeInitiator() ? 'Y' : 'N'
          });
        }).concat(toDelete.map(function (id) { return wf.deleteParticipant(vid, id); }));
        return Promise.all(jobs);
      }).then(function () {
        self.stepOpen(false); self.busy(false);
        return self.loadDesign(vid);
      }).catch(function (e) { self.busy(false); self.err(self._msg(e)); });
    };

    self.removeStep = function (step) {
      var d = self.design(); if (!d) return;
      if (!window.confirm(i18n.t('wf.dz.confirmDelStep'))) return;
      self.busy(true);
      wf.deleteStep(d.versionId, step.stepKey).then(function () {
        self.busy(false); return self.loadDesign(d.versionId);
      }).catch(function (e) { self.busy(false); self.err(self._msg(e)); });
    };

    /* ── condition editor (modal, live-validated) ───────────────────────── */
    self.condOpen  = ko.observable(false);
    self.condIsNew = ko.observable(false);
    self.fmCondKey   = ko.observable('');
    self.fmCondNameEn = ko.observable('');
    self.fmCondNameAr = ko.observable('');
    self.fmCondExpr  = ko.observable('');
    self.condValid   = ko.observable(null);   // true | false | null(unknown)
    self.condError   = ko.observable(null);

    var condTimer = null;
    self.fmCondExpr.subscribe(function (v) {
      self.condValid(null); self.condError(null);
      if (condTimer) clearTimeout(condTimer);
      if (!v || !v.trim()) return;
      var d = self.design();
      condTimer = setTimeout(function () {
        wf.compileCondition(v, d && d.schemaId).then(function (r) {
          self.condValid(!!r.valid); self.condError(r.error || null);
        }).catch(function () { /* silent — compile errors are the expected half */ });
      }, 350);
    });

    self.newCondition = function () {
      self.condIsNew(true);
      self.fmCondKey(''); self.fmCondNameEn(''); self.fmCondNameAr('');
      self.fmCondExpr(''); self.condValid(null); self.condError(null);
      self.condOpen(true);
    };
    self.editCondition = function (c) {
      self.condIsNew(false);
      self.fmCondKey(c.conditionKey); self.fmCondNameEn(c.nameEn || ''); self.fmCondNameAr(c.nameAr || '');
      self.fmCondExpr(c.expr || ''); self.condValid(c.isValid === 'Y'); self.condError(c.error || null);
      self.condOpen(true);
    };
    self.saveCondition = function () {
      var d = self.design(); if (!d) return;
      var key = (self.fmCondKey() || '').trim().toUpperCase().replace(/[^A-Z0-9_]/g, '_');
      if (!key) { self.err(i18n.t('wf.dz.needCondKey')); return; }
      self.busy(true); self.err(null);
      wf.saveCondition(d.versionId, {
        conditionKey: key, expr: self.fmCondExpr(),
        nameEn: self.fmCondNameEn(), nameAr: self.fmCondNameAr()
      }).then(function () {
        self.condOpen(false); self.busy(false);
        return self.loadDesign(d.versionId);
      }).catch(function (e) { self.busy(false); self.err(self._msg(e)); });
    };
    self.removeCondition = function (c) {
      var d = self.design(); if (!d) return;
      if (!window.confirm(i18n.t('wf.dz.confirmDelCond'))) return;
      self.busy(true);
      wf.deleteCondition(d.versionId, c.conditionKey).then(function () {
        self.busy(false); return self.loadDesign(d.versionId);
      }).catch(function (e) { self.busy(false); self.err(self._msg(e)); });
    };

    /* ── simulate (dry run — creates nothing) ───────────────────────────── */
    self.simOpen   = ko.observable(false);
    self.simFacts  = ko.observable('{\n  "amount": 100000,\n  "roles": []\n}');
    self.simResult = ko.observable(null);
    self.simBusy   = ko.observable(false);
    self.simErr    = ko.observable(null);

    self.openSim = function () {
      self.simResult(null); self.simErr(null); self.simOpen(true);
    };
    self.runSim = function () {
      var p = self.selected(); if (!p) return;
      var facts;
      try { facts = JSON.parse(self.simFacts()); }
      catch (e) { self.simErr(i18n.t('wf.dz.badJson')); return; }
      self.simBusy(true); self.simErr(null); self.simResult(null);
      wf.simulate(p.processCode, facts).then(function (r) {
        self.simBusy(false); self.simResult(r);
      }).catch(function (e) { self.simBusy(false); self.simErr(self._msg(e)); });
    };
    self.simStepClass = function (s) {
      return s.fires === false || s.fires === 'N' ? 'wf-dz-sim--skip' : 'wf-dz-sim--fire';
    };

    self.load();
  }

  if (!ko.components.isRegistered('wf-designer')) {
    ko.components.register('wf-designer', {
      viewModel: { createViewModel: function (params) { return new DesignerVM(params); } },
      template: templateHtml
    });
  }

  return { registered: true };
});
