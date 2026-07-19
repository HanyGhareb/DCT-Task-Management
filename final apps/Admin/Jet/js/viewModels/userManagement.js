define(['knockout', 'services/secService', 'services/userService'],
function (ko, secService, userService) {
  'use strict';

  function UserManagementViewModel() {
    var self = this;

    // ── master list ─────────────────────────────────────────────────────
    self.users      = ko.observableArray([]);
    self.listLoading = ko.observable(true);
    self.searchTerm = ko.observable('');
    self.page       = ko.observable(0);
    self.pageSize   = 15;
    self.total      = ko.observable(0);

    // ── detail ──────────────────────────────────────────────────────────
    self.selected     = ko.observable(null);   // user row from the list
    self.detailTab    = ko.observable('profile');
    self.detailLoading = ko.observable(false);
    self.errorMsg     = ko.observable('');
    self.okMsg        = ko.observable('');

    // profile form
    self.isNew        = ko.observable(false);
    self.fUsername    = ko.observable('');
    self.fDisplayName = ko.observable('');
    self.fDisplayNameAr = ko.observable('');
    self.fEmail       = ko.observable('');
    self.fPhone       = ko.observable('');
    self.fOrgId       = ko.observable(null);
    self.fActive      = ko.observable(true);
    self.fPassword    = ko.observable('');
    self.orgOptions   = ko.observableArray([]);
    self.saving       = ko.observable(false);

    // security data
    self.roleRows   = ko.observableArray([]);
    self.profileRows = ko.observableArray([]);
    self.exclusionRows = ko.observableArray([]);
    self.effectiveRows = ko.observableArray([]);

    // catalogs
    self.assignableRoles = ko.observableArray([]);  // ABSTRACT + JOB
    self.allProfiles     = ko.observableArray([]);
    self.allPrivs        = ko.observableArray([]);

    // adders
    self.newRoleId    = ko.observable(null);
    self.newRoleStart = ko.observable('');
    self.newRoleEnd   = ko.observable('');
    self.newProfileId = ko.observable(null);
    self.newExclPrivId = ko.observable(null);
    self.newExclReason = ko.observable('');

    self.pageCount = ko.computed(function () {
      return Math.max(1, Math.ceil(self.total() / self.pageSize));
    });

    self.effectiveGroups = ko.computed(function () {
      var groups = {};
      self.effectiveRows().forEach(function (r) {
        var k = r.viaRoot;
        if (!groups[k]) groups[k] = { role: r.viaRoot, roleName: r.viaRootName, privs: [] };
        groups[k].privs.push(r);
      });
      return Object.keys(groups).sort().map(function (k) { return groups[k]; });
    });

    function flash(msg) { self.okMsg(msg); setTimeout(function () { self.okMsg(''); }, 2500); }

    function loadList() {
      self.listLoading(true);
      userService.getPage({
        limit: self.pageSize, offset: self.page() * self.pageSize,
        search: self.searchTerm().trim()
      }).then(function (r) {
        var items = r.items || r.users || [];
        self.users(items);
        self.total(r.total || items.length);
      }).catch(function (e) { self.errorMsg(e.message || 'Load failed'); })
        .then(function () { self.listLoading(false); });
    }
    self.reloadList = loadList;
    self.search = function () { self.page(0); loadList(); };
    self.prevPage = function () { if (self.page() > 0) { self.page(self.page() - 1); loadList(); } };
    self.nextPage = function () { if (self.page() + 1 < self.pageCount()) { self.page(self.page() + 1); loadList(); } };

    function userId() {
      var u = self.selected();
      return u ? (u.userId || u.id) : null;
    }
    self.selectedId = userId;

    function loadSecurity() {
      var id = userId();
      if (!id) return;
      self.detailLoading(true);
      Promise.all([
        secService.getUserSecurity(id),
        secService.getUserEffective(id)
      ]).then(function (res) {
        self.roleRows(res[0].roles || []);
        self.profileRows(res[0].profiles || []);
        self.exclusionRows(res[0].exclusions || []);
        self.effectiveRows(res[1].items || []);
      }).catch(function (e) { self.errorMsg(e.message || 'Load failed'); })
        .then(function () { self.detailLoading(false); });
    }

    self.selectUser = function (u) {
      self.selected(u);
      self.isNew(false);
      self.errorMsg('');
      self.detailTab('profile');
      var id = u.userId || u.id;
      userService.getById(id).then(function (d) {
        self.fUsername(d.username || '');
        self.fDisplayName(d.displayName || '');
        self.fDisplayNameAr(d.displayNameAr || '');
        self.fEmail(d.email || '');
        self.fPhone(d.phone || d.mobile || '');
        self.fOrgId(d.orgId || null);
        self.fActive((d.isActive || 'Y') === 'Y');
        self.fPassword('');
      }).catch(function () {});
      loadSecurity();
    };

    self.newUser = function () {
      self.selected({ displayName: 'New user' });
      self.isNew(true);
      self.detailTab('profile');
      self.fUsername(''); self.fDisplayName(''); self.fDisplayNameAr('');
      self.fEmail(''); self.fPhone(''); self.fOrgId(null);
      self.fActive(true); self.fPassword('');
      self.roleRows([]); self.profileRows([]); self.exclusionRows([]); self.effectiveRows([]);
      self.errorMsg('');
    };

    self.setTab = function (t) { self.detailTab(t); };

    self.saveProfile = function () {
      if (!(self.fDisplayName() || '').trim() || !(self.fEmail() || '').trim()
          || (self.isNew() && !(self.fUsername() || '').trim())) {
        self.errorMsg('Username, display name and email are required'); return;
      }
      var body = {
        displayName: self.fDisplayName().trim(),
        displayNameAr: self.fDisplayNameAr() || null,
        email: self.fEmail().trim(),
        phone: self.fPhone() || null,
        orgId: self.fOrgId() || null,
        isActive: self.fActive() ? 'Y' : 'N'
      };
      self.saving(true); self.errorMsg('');
      var p;
      if (self.isNew()) {
        body.username = self.fUsername().trim();
        body.roles = [];
        if (self.fPassword()) body.password = self.fPassword();
        p = userService.create(body).then(function (r) {
          var id = r.userId || r.id;
          self.selected({ userId: id, displayName: body.displayName, email: body.email });
          self.isNew(false);
          loadList();
          loadSecurity();
        });
      } else {
        if (self.fPassword()) body.password = self.fPassword();
        p = userService.update(userId(), body).then(function () { loadList(); });
      }
      p.then(function () { flash('User saved'); })
       .catch(function (e) { self.errorMsg(e.message || 'Save failed'); })
       .then(function () { self.saving(false); });
    };

    // ── role assignments ───────────────────────────────────────────────
    self.assignRole = function () {
      if (!self.newRoleId()) return;
      secService.assignUserRole(userId(), {
        roleId: self.newRoleId(),
        startDate: self.newRoleStart() || null,
        endDate: self.newRoleEnd() || null
      }).then(function () {
        self.newRoleId(null); self.newRoleStart(''); self.newRoleEnd('');
        flash('Role assigned'); loadSecurity();
      }).catch(function (e) { self.errorMsg(e.message || 'Assign failed'); });
    };
    self.endRole = function (row) {
      secService.endUserRole(userId(), row.urId)
        .then(function () { flash('Assignment ended'); loadSecurity(); })
        .catch(function (e) { self.errorMsg(e.message || 'End failed'); });
    };

    // ── security profiles ──────────────────────────────────────────────
    self.assignProfile = function () {
      if (!self.newProfileId()) return;
      secService.assignUserProfile(userId(), { profileId: self.newProfileId() })
        .then(function () { self.newProfileId(null); flash('Profile assigned'); loadSecurity(); })
        .catch(function (e) { self.errorMsg(e.message || 'Assign failed'); });
    };
    self.endProfile = function (row) {
      secService.endUserProfile(userId(), row.upId)
        .then(function () { flash('Profile ended'); loadSecurity(); })
        .catch(function (e) { self.errorMsg(e.message || 'End failed'); });
    };

    // ── exclusions ─────────────────────────────────────────────────────
    self.addExclusion = function () {
      if (!self.newExclPrivId()) return;
      secService.addUserExclusion(userId(), {
        permissionId: self.newExclPrivId(), reason: self.newExclReason() || null
      }).then(function () {
        self.newExclPrivId(null); self.newExclReason('');
        flash('Privilege excluded'); loadSecurity();
      }).catch(function (e) { self.errorMsg(e.message || 'Exclude failed'); });
    };
    self.endExclusion = function (row) {
      secService.endUserExclusion(userId(), row.id)
        .then(function () { flash('Exclusion removed'); loadSecurity(); })
        .catch(function (e) { self.errorMsg(e.message || 'Remove failed'); });
    };

    self.initials = function (u) {
      var n = (u && (u.displayName || u.username)) || '?';
      return n.split(/\s+/).slice(0, 2).map(function (w) { return w.charAt(0); }).join('').toUpperCase();
    };

    // ── boot ────────────────────────────────────────────────────────────
    secService.getRoles({}).then(function (r) {
      self.assignableRoles((r.items || []).filter(function (x) {
        return x.category !== 'DUTY' && x.isActive === 'Y';
      }));
    }).catch(function () {});
    secService.getProfiles({}).then(function (r) { self.allProfiles(r.items || []); }).catch(function () {});
    secService.getMeta().then(function (m) { self.allPrivs(m.privileges || []); }).catch(function () {});
    userService.getOrgOptions().then(function (o) { self.orgOptions(o || []); }).catch(function () {});
    loadList();
  }

  return UserManagementViewModel;
});
