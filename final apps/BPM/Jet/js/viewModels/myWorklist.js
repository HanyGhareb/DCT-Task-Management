/**
 * Admin — My Worklist.
 *
 * Deliberately almost empty. The cross-module worklist, the action bar and the
 * timeline are all SHARED components over the /wf/ API, so this page has no
 * approval logic of its own — which is the entire point of the platform. Any app
 * gets the same page with the same four lines.
 */
define(['knockout', 'shared/i18n'], function (ko, i18n) {
  'use strict';

  function MyWorklistViewModel() {
    const self = this;

    self.t = i18n.t;
    self.selected = ko.observable(null);

    // the timeline is keyed by the BUSINESS record, not an engine instance id,
    // so it keeps working when a module migrates engines
    self.selectedModule   = ko.pureComputed(function () {
      const s = self.selected(); return s ? s.module : null;
    });
    self.selectedRecord   = ko.pureComputed(function () {
      const s = self.selected(); return s ? s.sourceRecordId : null;
    });
    self.selectedInstance = ko.pureComputed(function () {
      const s = self.selected(); return s ? s.instanceId : null;
    });

    self.openRequest  = function (item) { self.selected(item); };
    self.closeRequest = function () { self.selected(null); };
  }

  return MyWorklistViewModel;
});
