/**
 * Admin — Approval Processes.
 *
 * Deliberately empty: the process designer is the shared <wf-designer> component
 * over the /wf/ API, so this page has no logic of its own. Any app that wants to
 * let its own admins edit their chains gets the same page with the same one line.
 */
define(['knockout', 'shared/i18n'], function (ko, i18n) {
  'use strict';

  function ProcessesViewModel() {
    this.t = i18n.t;
  }

  return ProcessesViewModel;
});
