/**
 * shared/js/components/wfWorklist.js — <wf-worklist> Knockout component.
 *
 * Requirement 4: ONE view for the whole worklist. Every module, both engines,
 * one list — because the server already unified it (PROD.DCT_WF_INBOX_V). The
 * client does not merge anything; it renders one array.
 *
 * A module app passes `modules` to scope it to its own requests; the Admin app
 * passes nothing and gets everything the user can act on, platform-wide.
 *
 * Usage:
 *   <wf-worklist params="modules: ['FL_CONTRACT','FL_REGISTRATION'],
 *                        onOpen: goToRequest"></wf-worklist>
 *
 * Params:
 *   modules  array|observable|null  source_module filter; null/empty = everything
 *   onOpen   function(item)         row click — navigate to your own detail page
 *   heading  string                 optional region title override
 *
 * Requires: shared/skeleton (<list-skeleton>) and shared/components/wfActionBar.
 */
define(['knockout', 'shared/i18n', 'shared/wfService', 'shared/skeleton',
        'shared/components/wfActionBar',
        'text!shared/components/wfWorklist.html'],
function (ko, i18n, wf, skeletonReg, actionBarReg, templateHtml) {
  'use strict';

  var ALL = '__all__';

  function unwrap(v) { return ko.isObservable(v) ? v() : v; }

  function WorklistVM(params) {
    var self = this;
    params = params || {};

    var scope = unwrap(params.modules) || [];

    self.loading = ko.observable(true);
    self.items   = ko.observableArray([]);
    self.filter  = ko.observable(ALL);

    self.heading = ko.pureComputed(function () {
      return unwrap(params.heading) || i18n.t('wf.worklist');
    });

    /* Distinct modules actually present, so the filter never offers an empty bucket. */
    self.modules = ko.pureComputed(function () {
      var seen = {}, out = [ALL];
      self.items().forEach(function (i) {
        if (!seen[i.module]) { seen[i.module] = 1; out.push(i.module); }
      });
      return out;
    });

    self.moduleLabel = function (m) {
      if (m === ALL) return i18n.t('wf.allModules');
      var k = i18n.t('wf.mod.' + m);
      return k === 'wf.mod.' + m ? m.replace(/_/g, ' ') : k;
    };

    /* The engine badge is scaffolding for OUR migration, not information a user
       wants. Show it only while both engines actually have work in this list —
       the day the last legacy request drains, it disappears on its own. */
    self.showEngine = ko.pureComputed(function () {
      var e = {};
      self.items().forEach(function (i) { e[i.engine] = 1; });
      return Object.keys(e).length > 1;
    });

    self.rows = ko.pureComputed(function () {
      var f = self.filter();
      return self.items().filter(function (i) {
        return f === ALL || i.module === f;
      });
    });

    self.money = function (v, ccy) {
      if (v === null || v === undefined || v === 0) return '–';
      // Latin digits everywhere, including AR (platform rule)
      return (ccy || 'AED') + ' ' + Number(v).toLocaleString('en-US',
        { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    };

    self.load = function () {
      self.loading(true);
      return wf.worklist()
        .then(function (items) {
          if (scope && scope.length) {
            items = items.filter(function (i) { return scope.indexOf(i.module) >= 0; });
          }
          self.items(items);
          self.loading(false);
        })
        .catch(function () { self.loading(false); });
    };

    self.open = function (item) {
      var fn = unwrap(params.onOpen);
      if (typeof fn === 'function') fn(item);
      return false;   // it is an <a href="#">
    };

    /* After an action the row is gone (or the request moved on), so re-read the
       list from the server rather than mutating it locally — the next step's
       approver, due date and outcome set are all server-decided. */
    self.afterAction = function () { self.load(); };

    self.load();
  }

  if (!ko.components.isRegistered('wf-worklist')) {
    ko.components.register('wf-worklist', {
      viewModel: { createViewModel: function (params) { return new WorklistVM(params); } },
      template: templateHtml
    });
  }

  return { registered: true };
});
