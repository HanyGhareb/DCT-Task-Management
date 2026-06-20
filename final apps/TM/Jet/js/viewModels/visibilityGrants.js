define(['knockout', 'services/tmService', 'shared/i18n', 'shared/toast'],
function (ko, tm, i18n, toast) {
  'use strict';
  return function VisibilityGrants() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.rows = ko.observableArray([]);
    self.users = ko.observableArray([]);
    self.teams = ko.observableArray([]);
    self.orgs  = ko.observableArray([]);

    // ---- create form ----
    self.editing = ko.observable(false);
    self.saving  = ko.observable(false);
    self.f = {
      granteeUserId: ko.observable(null), scope: ko.observable('TEAM'),
      teamId: ko.observable(null), orgId: ko.observable(null),
      accessLevel: ko.observable('VIEWER'), endDate: ko.observable(''), reason: ko.observable('')
    };
    self.needTeam = ko.computed(function () { return ['TEAM', 'TEAM_TREE'].indexOf(self.f.scope()) >= 0; });
    self.needOrg  = ko.computed(function () { return self.f.scope() === 'ORG'; });

    self.load = function () {
      self.loading(true);
      tm.listGrants({}).then(function (r) { self.rows(r.items || []); self.loading(false); })
        .catch(function () { self.loading(false); });
      tm.listUsers('').then(function (r) { self.users(r.items || []); }).catch(function () {});
      tm.listTeams({ limit: 200 }).then(function (r) {
        var ts = r.items || []; self.teams(ts);
        var seen = {}, orgs = [];
        ts.forEach(function (t) { if (t.orgId && !seen[t.orgId]) { seen[t.orgId] = 1; orgs.push({ orgId: t.orgId, orgName: t.orgName }); } });
        self.orgs(orgs);
      }).catch(function () {});
    };

    self.newGrant = function () {
      self.f.granteeUserId(null); self.f.scope('TEAM'); self.f.teamId(null); self.f.orgId(null);
      self.f.accessLevel('VIEWER'); self.f.endDate(''); self.f.reason('');
      self.editing(true);
    };
    self.cancel = function () { self.editing(false); };

    self.save = function () {
      if (!self.f.granteeUserId()) { toast.error(self.t('tm.vis.grantee')); return; }
      self.saving(true);
      tm.createGrant({
        granteeUserId: self.f.granteeUserId(), scope: self.f.scope(),
        teamId: self.needTeam() ? self.f.teamId() : null,
        orgId: self.needOrg() ? self.f.orgId() : null,
        accessLevel: self.f.accessLevel(), endDate: self.f.endDate() || null, reason: self.f.reason()
      }).then(function () {
        toast.success(self.t('tm.vis.created')); self.saving(false); self.editing(false); self.load();
      }).catch(function () { self.saving(false); });
    };

    self.revoke = function (g) {
      if (!window.confirm(self.t('tm.vis.revokeConfirm'))) return;
      tm.revokeGrant(g.grantId).then(function () { toast.success('✓'); self.load(); }).catch(function () {});
    };

    self.load();
  };
});
