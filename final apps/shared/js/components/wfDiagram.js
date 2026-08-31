/**
 * shared/js/components/wfDiagram.js — <wf-diagram> Knockout component.
 *
 * A READ-ONLY graphical (flowchart) view of an approval chain — used two ways:
 *   • DESIGN preview  — the current version's steps as a top-down flow
 *   • RUNTIME tracker — one request coloured by where it actually is
 *
 * It renders the SAME metadata the list views already use; it NEVER edits
 * (authoring stays the vertical list — a boxes-and-arrows editor is a 3x build
 * approval chains don't need). Connectors are pure CSS (no SVG coordinate math),
 * so the flow mirrors cleanly in RTL with logical properties only.
 *
 * Two ways to feed it:
 *   design  : <wf-diagram params="nodes: <array|observable>"></wf-diagram>
 *             the host passes pre-normalised nodes (from the design JSON).
 *   runtime : <wf-diagram params="module: 'FL_CONTRACT', record: id"></wf-diagram>
 *             the component fetches DCT_WF_CHAIN_V via /wf/chain and colours by state.
 *
 * Normalised node shape:
 *   { key, title, titleAr, condition, outcomeSet, who, isFinalGate,
 *     parallelGroup, state, meta }
 *   state: 'done' | 'active' | 'pending' | 'skipped' | 'rejected' | null(design)
 */
define(['knockout', 'shared/i18n', 'shared/wfService',
        'text!shared/components/wfDiagram.html'],
function (ko, i18n, wf, templateHtml) {
  'use strict';

  function unwrap(v) { return ko.isObservable(v) ? v() : v; }

  // DCT_WF_CHAIN_V status -> diagram state
  function stateOfStatus(st) {
    st = String(st || '').toUpperCase();
    if (st === 'PENDING')                       return 'active';
    if (st === 'WAITING' || st === '-' || !st)  return 'pending';
    if (st === 'SKIPPED')                        return 'skipped';
    if (st === 'REJECTED' || st === 'DISAGREE')  return 'rejected';
    return 'done'; // APPROVED / ENDORSE / AGREE / ... = a recorded positive outcome
  }

  function DiagramVM(params) {
    var self = this;
    params = params || {};

    self.loading   = ko.observable(false);
    self.error     = ko.observable(null);
    self.nodes     = ko.observableArray([]);
    self.isRuntime = !!(params.module || params.record);

    // group consecutive nodes that share a parallel_group into one row (a lane)
    self.rows = ko.pureComputed(function () {
      var out = [], cur = null;
      self.nodes().forEach(function (n) {
        if (n.parallelGroup && cur && cur.group === n.parallelGroup) {
          cur.nodes.push(n);
        } else {
          cur = { group: n.parallelGroup || null, nodes: [n] };
          out.push(cur);
        }
      });
      return out;
    });

    self.title = function (n) {
      return (i18n.lang() === 'ar' && n.titleAr) ? n.titleAr : n.title;
    };
    self.nodeClass = function (n) { return 'wf-dg--' + (n.state || 'plan'); };

    self.stateLabel = function (n) {
      if (!n.state) return '';
      var key = { active: 'pending', pending: 'waiting', done: 'approved',
                  skipped: 'skipped', rejected: 'rejected' }[n.state] || n.state;
      var t = i18n.t('wf.st.' + key);
      return t.indexOf('wf.') === 0 ? n.state : t;
    };

    function loadRuntime() {
      var m = unwrap(params.module), r = unwrap(params.record);
      if (!m || !r) { self.nodes([]); return; }
      self.loading(true); self.error(null);
      wf.chain(m, r).then(function (steps) {
        self.nodes((steps || []).map(function (s) {
          var meta = [];
          if (s.actionedBy) meta.push(s.actionedBy);
          if (s.actionedAt) meta.push(s.actionedAt);
          return {
            key: s.stepKey || String(s.stepSeq),
            title: s.stepName, titleAr: s.stepName,
            condition: null, outcomeSet: null,
            who: s.approver || null,
            isFinalGate: false,
            parallelGroup: null,
            state: stateOfStatus(s.status),
            meta: meta.join(' · '),
            comment: s.comments || null
          };
        }));
        self.loading(false);
      }).catch(function () {
        self.error(i18n.t('wf.dg.loadErr')); self.loading(false);
      });
    }

    if (self.isRuntime) {
      loadRuntime();
      ['module', 'record'].forEach(function (p) {
        if (ko.isObservable(params[p])) params[p].subscribe(loadRuntime);
      });
    } else {
      var apply = function () { self.nodes(unwrap(params.nodes) || []); };
      apply();
      if (ko.isObservable(params.nodes)) params.nodes.subscribe(apply);
    }
  }

  if (!ko.components.isRegistered('wf-diagram')) {
    ko.components.register('wf-diagram', {
      viewModel: { createViewModel: function (p) { return new DiagramVM(p); } },
      template: templateHtml
    });
  }

  return { registered: true };
});
