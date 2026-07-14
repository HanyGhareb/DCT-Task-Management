/**
 * shared/js/components/wfTimeline.js — <wf-timeline> Knockout component.
 *
 * The approval chain of a request, plus (optionally) its full audit trail.
 *
 * Keyed by the BUSINESS record (module + record id), never by an engine-specific
 * instance id. That is deliberate: when a module migrates from the legacy engine
 * to the workflow engine, this component keeps working with no change in any app,
 * because DCT_WF_CHAIN_V answers for both.
 *
 * It renders the REAL outcome. A step the business calls "Endorsement" shows
 * "Endorsed", not "Approved" — which is the whole reason the platform exists, and
 * something the legacy tables could not represent.
 *
 * Usage:
 *   <wf-timeline params="module: 'FL_CONTRACT', record: contractId,
 *                        instanceId: wfInstanceId, showHistory: true"></wf-timeline>
 *
 * Params:
 *   module      string|observable  source module (required for the chain)
 *   record      number|observable  source record id (required for the chain)
 *   instanceId  number|observable  optional — enables the full event history
 *   showHistory bool               show the audit trail under the chain
 */
define(['knockout', 'shared/i18n', 'shared/wfService', 'shared/skeleton',
        'text!shared/components/wfTimeline.html'],
function (ko, i18n, wf, skeletonReg, templateHtml) {
  'use strict';

  function unwrap(v) { return ko.isObservable(v) ? v() : v; }

  function TimelineVM(params) {
    var self = this;
    params = params || {};

    self.loading     = ko.observable(true);
    self.steps       = ko.observableArray([]);
    self.events      = ko.observableArray([]);
    self.showHistory = !!unwrap(params.showHistory);

    self.statusLabel = function (s) {
      var k = i18n.t('wf.st.' + String(s || '').toLowerCase());
      return k.indexOf('wf.st.') === 0 ? s : k;
    };

    self.stepClass = function (s) {
      var st = String(s.status || '').toUpperCase();
      if (st === 'PENDING')  return 'wf-chain--now';
      if (st === 'WAITING')  return 'wf-chain--wait';
      if (st === 'SKIPPED')  return 'wf-chain--skip';
      if (st === 'REJECTED') return 'wf-chain--rej';
      if (st === '-')        return 'wf-chain--wait';
      return 'wf-chain--done';
    };

    self.eventLabel = function (e) {
      // an outcome, when there is one, is more informative than the event name:
      // "Endorsed" beats "Task completed".
      if (e.outcome) {
        var ok = i18n.t('wf.oc.' + String(e.outcome).toLowerCase());
        if (ok.indexOf('wf.oc.') !== 0) return ok;
        return e.outcome;
      }
      var k = i18n.t('wf.ev.' + String(e.event || '').toLowerCase());
      return k.indexOf('wf.ev.') === 0
        ? String(e.event || '').replace(/_/g, ' ').toLowerCase()
        : k;
    };

    function load() {
      var mod = unwrap(params.module);
      var rec = unwrap(params.record);
      var iid = unwrap(params.instanceId);

      self.loading(true);

      var jobs = [];
      jobs.push(
        (mod && rec)
          ? wf.chain(mod, rec).then(function (s) { self.steps(s); })
          : Promise.resolve()
      );
      if (self.showHistory && iid) {
        jobs.push(wf.history(iid).then(function (e) { self.events(e); }));
      }

      return Promise.all(jobs)
        .then(function () { self.loading(false); })
        .catch(function () { self.loading(false); });
    }

    self.reload = load;

    // re-read when the caller swaps the record (e.g. a detail page navigating)
    var subs = [];
    ['module', 'record', 'instanceId'].forEach(function (p) {
      if (ko.isObservable(params[p])) subs.push(params[p].subscribe(load));
    });

    self.dispose = function () {
      subs.forEach(function (s) { try { s.dispose(); } catch (e) { /* ignore */ } });
    };

    load();
  }

  if (!ko.components.isRegistered('wf-timeline')) {
    ko.components.register('wf-timeline', {
      viewModel: { createViewModel: function (params) { return new TimelineVM(params); } },
      template: templateHtml
    });
  }

  return { registered: true };
});
