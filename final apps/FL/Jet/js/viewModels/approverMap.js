/**
 * approverMap.js — Contract Approver Assignments (FL Contract Phase 2, D2).
 * FL_ADMIN page over /fl/approver-map/: who endorses per role per org unit.
 * Resolution at submit: department (cost center) → sector → any role holder.
 */
define(['knockout', 'services/flService'], function (ko, flService) {
  'use strict';

  function ApproverMapViewModel() {
    var self = this;

    self.loading    = ko.observable(true);
    self.items      = ko.observableArray([]);
    self.roles      = ko.observableArray([]);
    self.orgOptions = ko.observableArray([]);
    self.successMsg = ko.observable('');
    self.errorMsg   = ko.observable('');

    function flash(m) { self.successMsg(m); setTimeout(function () { self.successMsg(''); }, 3000); }
    function fail(err, def) { self.errorMsg((err && err.message) || def); }

    self.reload = function () {
      self.errorMsg('');
      flService.getApproverMap().then(function (r) {
        self.items(r.items || []);
        self.roles(r.roles || []);
        // indent children under their parents for a readable picker
        var orgs = r.orgs || [];
        var byParent = {};
        orgs.forEach(function (o) {
          var k = o.parentOrgId || 'root';
          (byParent[k] = byParent[k] || []).push(o);
        });
        var flat = [];
        (function walk(parentKey, depth) {
          (byParent[parentKey] || []).forEach(function (o) {
            flat.push({ orgId: o.orgId,
                        label: new Array(depth + 1).join(' ') + o.orgName
                               + (o.orgType ? ' (' + o.orgType + ')' : '') });
            walk(o.orgId, depth + 1);
          });
        })('root', 0);
        self.orgOptions(flat.length ? flat : orgs.map(function (o) {
          return { orgId: o.orgId, label: o.orgName };
        }));
        self.loading(false);
      }).catch(function (err) { self.loading(false); fail(err, 'Load failed'); });
    };
    self.reload();

    /* add modal */
    self.showAdd = ko.observable(false);
    self.form = {
      roleCode: ko.observable(''),
      orgId:    ko.observable(null),
      email:    ko.observable(''),
      userId:   ko.observable(null),
      hint:     ko.observable('Enter the approver’s work email'),
      notes:    ko.observable(''),
      error:    ko.observable('')
    };
    self.openAdd = function () {
      self.form.roleCode((self.roles()[0] || {}).roleCode || '');
      self.form.orgId(null);
      self.form.email(''); self.form.userId(null);
      self.form.hint('Enter the approver’s work email');
      self.form.notes('');
      self.form.error('');
      self.showAdd(true);
    };
    self.lookupApprover = function () {
      var em = (self.form.email() || '').trim();
      self.form.userId(null);
      self.form.error('');
      if (!em) { self.form.hint('Enter the approver’s work email'); return; }
      flService.lookupUser(em).then(function (r) {
        if (r && r.found) {
          self.form.userId(r.userId);
          self.form.hint('✓ ' + r.name);
        } else {
          self.form.hint('⚠ No active i-Finance user has this email — the approver must be an existing user (Admin → Users)');
        }
      }).catch(function () { self.form.hint('⚠ Lookup failed'); });
    };
    self.saveAdd = function () {
      self.form.error('');
      if (!self.form.roleCode()) { self.form.error('Select a role.'); return; }
      if (!self.form.orgId())    { self.form.error('Select the org unit (department or sector).'); return; }
      if (!self.form.userId()) {
        self.form.error((self.form.email() || '').trim()
          ? 'The approver email did not match an active i-Finance user. The approver must be an existing user — check the address, or create the user in Admin → Users first.'
          : 'Enter the approver’s email — it must belong to an existing i-Finance user.');
        return;
      }
      flService.createApproverAssignment({
        roleCode: self.form.roleCode(),
        orgId:    self.form.orgId(),
        userId:   self.form.userId(),
        notes:    self.form.notes().trim() || null
      }).then(function () {
        self.showAdd(false);
        flash('Assignment added.');
        self.reload();
      }).catch(function (err) { self.form.error((err && err.message) || 'Save failed'); });
    };

    self.toggleActive = function (row) {
      flService.updateApproverAssignment(row.mapId, {
        isActive: row.isActive === 'Y' ? 'N' : 'Y'
      }).then(function () { self.reload(); })
        .catch(function (err) { fail(err, 'Update failed'); });
    };

    self.remove = function (row) {
      if (!window.confirm('Remove the ' + row.roleName + ' assignment for ' + row.orgName + '?')) return;
      flService.deleteApproverAssignment(row.mapId).then(function () {
        flash('Assignment removed.');
        self.reload();
      }).catch(function (err) { fail(err, 'Delete failed'); });
    };
  }

  return ApproverMapViewModel;
});
