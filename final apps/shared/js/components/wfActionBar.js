/**
 * shared/js/components/wfActionBar.js — <wf-action-bar> Knockout component.
 *
 * THE POINT OF THIS COMPONENT: it contains no Approve button. It contains no
 * Reject button. It renders whatever outcomes the STEP declares, which arrive on
 * the worklist item as `outcomes[]`. A step on ENDORSE_SET renders
 * Endorse / Return for info / Reject. A legacy step renders Approve / Return /
 * Reject. A step on FYI_ACK renders a single Acknowledge that blocks nobody.
 *
 * That is requirement 2 ("customized outcome actions other than Approve/Reject")
 * expressed as a UI contract: adding a new outcome to a step is a DATA change and
 * this component picks it up with no code change in any app.
 *
 * Usage:
 *   <wf-action-bar params="task: item, onDone: reload, small: true"></wf-action-bar>
 *
 * Params:
 *   task    object|observable  a worklist item — needs .id and .outcomes[]
 *   onDone  function           called after a successful action (reload your list)
 *   small   bool               compact buttons for use inside a table row
 *
 * The comment rule is enforced HERE and again in the engine. The client copy is a
 * courtesy (instant feedback); the server copy is the one that counts.
 */
define(['knockout', 'shared/i18n', 'shared/toast', 'shared/wfService',
        'text!shared/components/wfActionBar.html'],
function (ko, i18n, toast, wf, templateHtml) {
  'use strict';

  function unwrap(v) { return ko.isObservable(v) ? v() : v; }

  function ActionBarVM(params) {
    var self = this;

    self.task     = ko.observable(unwrap(params.task) || null);
    self.isSmall  = !!unwrap(params.small);
    self.busy     = ko.observable(false);

    self.outcomes = ko.pureComputed(function () {
      var t = self.task();
      return (t && t.outcomes) || [];
    });

    // keep in step if the caller swaps the row object
    if (ko.isObservable(params.task)) {
      var sub = params.task.subscribe(function (v) { self.task(v); });
    }

    self.label = function (o) {
      return i18n.lang() === 'ar' ? (o.labelAr || o.labelEn) : o.labelEn;
    };

    self.hint = function (o) {
      // spell out what the outcome will DO — "Endorse" alone does not say that the
      // request moves on, and "Return for info" does not say where it goes back to
      var k = 'wf.sem.' + String(o.semantic || '').toLowerCase();
      var s = $rootT(k);
      return s === k ? self.label(o) : self.label(o) + ' — ' + s;
    };

    function $rootT(k) { return i18n.t(k); }

    /* ── the comment prompt ─────────────────────────────────────────────── */
    self.prompting       = ko.observable(false);
    self.pending         = ko.observable(null);
    self.comment         = ko.observable('');
    self.commentRequired = ko.observable(false);

    self.commentOk = ko.pureComputed(function () {
      if (!self.commentRequired()) return true;
      return String(self.comment() || '').trim().length > 0;
    });

    self.promptTitle = ko.pureComputed(function () {
      var o = self.pending();
      return o ? self.label(o) : '';
    });

    self.pick = function (o) {
      if (self.busy()) return true;
      self.pending(o);
      self.comment('');
      // requiresComment comes from the OUTCOME; the step may also demand one on any
      // negative outcome (comment_required = ON_NEGATIVE). The server enforces both.
      self.commentRequired(o.requiresComment === 'Y' || o.isPositive === 'N');
      self.prompting(true);
      return true;
    };

    self.cancel = function () {
      self.prompting(false);
      self.pending(null);
      return true;
    };

    self.confirm = function () {
      var o = self.pending();
      var t = self.task();
      if (!o || !t || self.busy() || !self.commentOk()) return true;

      self.busy(true);
      wf.act(t.id, o.code, self.comment())
        .then(function () {
          self.busy(false);
          self.prompting(false);
          self.pending(null);
          toast.success(i18n.t('wf.recorded').replace('{0}', self.label(o)));
          var done = unwrap(params.onDone);
          if (typeof done === 'function') done(o);
        })
        .catch(function () {
          // api.js already toasted the server's message (403 not your task, 400
          // comment required, ...). Just release the button.
          self.busy(false);
        });
      return true;
    };

    self.dispose = function () {
      if (sub) { try { sub.dispose(); } catch (e) { /* ignore */ } }
    };
  }

  if (!ko.components.isRegistered('wf-action-bar')) {
    ko.components.register('wf-action-bar', {
      viewModel: { createViewModel: function (params) { return new ActionBarVM(params); } },
      template: templateHtml
    });
  }

  return { registered: true };
});
