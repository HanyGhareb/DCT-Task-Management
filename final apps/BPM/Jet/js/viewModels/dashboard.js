/**
 * dashboard.js — Fusion BPM home.
 *
 * A landing surface over the two workflow stacks:
 *   - DWP worklist (/wf/worklist) — my open engine tasks
 *   - legacy inbox (/dct/approvals/pending) — my pending legacy approvals
 *   - my active delegations (/dct/delegations?mine=Y)
 *   - processes count (/wf/processes) — WF_ADMIN only
 * plus quick links into the workspace / design pages.
 */
define(['knockout', 'services/authService', 'services/auditService',
        'services/delegationService', 'shared/wfService', 'shared/i18n'],
function (ko, authService, auditService, delegationService, wf, i18n) {
  'use strict';

  function DashboardViewModel() {
    var self = this;
    self.t = i18n.t;

    self.isWfAdmin = authService.isWfAdmin();

    self.worklistCount    = ko.observable('—');
    self.pendingCount     = ko.observable('—');
    self.delegationCount  = ko.observable('—');
    self.processCount     = ko.observable('—');

    wf.worklist().then(function (items) {
      self.worklistCount(items.length);
    }).catch(function () { self.worklistCount('0'); });

    auditService.getPendingApprovals().then(function (items) {
      self.pendingCount(items.length);
    }).catch(function () { self.pendingCount('0'); });

    delegationService.getAll(true).then(function (items) {
      var today = new Date().toISOString().slice(0, 10);
      self.delegationCount(items.filter(function (d) {
        return (d.status || 'ACTIVE') === 'ACTIVE' && (!d.endDate || d.endDate >= today);
      }).length);
    }).catch(function () { self.delegationCount('0'); });

    if (self.isWfAdmin) {
      wf.processes().then(function (r) {
        var items = (r && r.items) || r || [];
        self.processCount(items.length);
      }).catch(function () { self.processCount('0'); });
    }

    self.go = function (route) { if (window._jetApp) window._jetApp.navigate(route); };

    self.quickLinks = [
      { route: 'myWorklist',       icon: '📋', key: 'dash.qkWorklist' },     // 📋
      { route: 'pendingApprovals', icon: '✅',       key: 'dash.qkPending' },      // ✅
      { route: 'myDelegations',    icon: '🏖', key: 'dash.qkDelegations' },  // 🏖
    ].concat(self.isWfAdmin ? [
      { route: 'processes',       icon: '🛠', key: 'dash.qkProcesses' },     // 🛠
      { route: 'roleAssignments', icon: '👥', key: 'dash.qkRoleAssign' },    // 👥
      { route: 'approvalMonitor', icon: '👁', key: 'dash.qkMonitor' },       // 👁
    ] : []);
  }

  return DashboardViewModel;
});
