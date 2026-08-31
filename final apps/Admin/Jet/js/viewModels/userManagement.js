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

    // profile form (existing user)
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

    // new-user drawer
    self.showNewUser  = ko.observable(false);
    self.nUsername    = ko.observable('');
    self.nDisplayName = ko.observable('');
    self.nDisplayNameAr = ko.observable('');
    self.nEmail       = ko.observable('');
    self.nPhone       = ko.observable('');
    self.nOrgId       = ko.observable(null);
    self.nPassword    = ko.observable('');

    // security data
    self.roleRows   = ko.observableArray([]);
    self.profileRows = ko.observableArray([]);
    self.exclusionRows = ko.observableArray([]);
    self.effectiveRows = ko.observableArray([]);

    // interactive-report envelopes for the 4 detail tabs
    self.rolesIr    = ko.observable(null);
    self.profilesIr = ko.observable(null);
    self.exclIr     = ko.observable(null);
    self.effIr      = ko.observable(null);
    self._roleMap = {}; self._profMap = {}; self._exclMap = {};

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

    function flash(msg) { self.okMsg(msg); setTimeout(function () { self.okMsg(''); }, 2500); }

    // ── tab grids (shared <interactive-report>) ─────────────────────────
    function irEnv(cols, items) { return { columns: cols, items: items, total: items.length }; }

    function buildTabGrids() {
      self._roleMap = {}; self._profMap = {}; self._exclMap = {};

      self.rolesIr(irEnv(
        [{ key: 'name', label: 'Role', type: 'text' },
         { key: 'code', label: 'Code', type: 'text' },
         { key: 'category', label: 'Category', type: 'text' },
         { key: 'module', label: 'Module', type: 'text' },
         { key: 'startDate', label: 'Start', type: 'date' },
         { key: 'endDate', label: 'End', type: 'date' },
         { key: 'status', label: 'Status', type: 'text' },
         { key: 'action', label: 'Action', type: 'text' }],
        self.roleRows().map(function (r) {
          self._roleMap[[r.code, r.startDate, r.status].join('|')] = r.urId;
          return {
            name: r.name, code: r.code, category: r.category,
            module: r.module || '', startDate: r.startDate,
            endDate: r.endDate || '', status: r.status,
            action: (r.status === 'ACTIVE' || r.status === 'FUTURE') ? 'End' : ''
          };
        })));

      self.profilesIr(irEnv(
        [{ key: 'name', label: 'Profile', type: 'text' },
         { key: 'code', label: 'Code', type: 'text' },
         { key: 'scopeCount', label: 'Scope rows', type: 'num' },
         { key: 'startDate', label: 'Start', type: 'date' },
         { key: 'endDate', label: 'End', type: 'date' },
         { key: 'status', label: 'Status', type: 'text' },
         { key: 'action', label: 'Action', type: 'text' }],
        self.profileRows().map(function (r) {
          self._profMap[[r.code, r.startDate, r.status].join('|')] = r.upId;
          return {
            name: r.name, code: r.code, scopeCount: r.scopeCount,
            startDate: r.startDate, endDate: r.endDate || '', status: r.status,
            action: (r.status === 'ACTIVE' || r.status === 'FUTURE') ? 'End' : ''
          };
        })));

      self.exclIr(irEnv(
        [{ key: 'permName', label: 'Privilege', type: 'text' },
         { key: 'permCode', label: 'Code', type: 'text' },
         { key: 'reason', label: 'Reason', type: 'text' },
         { key: 'createdAt', label: 'Since', type: 'text' },
         { key: 'action', label: 'Action', type: 'text' }],
        self.exclusionRows().map(function (r) {
          self._exclMap[r.permCode] = r.id;
          return { permName: r.permName, permCode: r.permCode,
                   reason: r.reason || '', createdAt: r.createdAt || '',
                   action: 'Remove' };
        })));

      self.effIr(irEnv(
        [{ key: 'name', label: 'Privilege', type: 'text' },
         { key: 'code', label: 'Code', type: 'text' },
         { key: 'module', label: 'Module', type: 'text' },
         { key: 'viaRootName', label: 'Granted by role', type: 'text' },
         { key: 'viaRole', label: 'Via duty', type: 'text' },
         { key: 'viaGroup', label: 'Via group', type: 'text' }],
        self.effectiveRows().map(function (r) {
          return { name: r.name, code: r.code, module: r.module || '',
                   viaRootName: r.viaRootName || r.viaRoot || '',
                   viaRole: r.viaRole || '', viaGroup: r.viaGroup || '' };
        })));
    }

    /* delegated action-cell click: the shared IR grid renders declared
       columns only, so row identity rides a side-map keyed on visible
       cell values (the GL pending-page pattern) */
    function gridAction(e, keyCols, map, fn) {
      var td = e.target && e.target.closest ? e.target.closest('td[data-key="action"]') : null;
      if (!td || !td.textContent.trim()) return true;
      var tr = td.closest('tr');
      if (!tr) return true;
      var parts = [], ok = true;
      keyCols.forEach(function (k) {
        var c = tr.querySelector('td[data-key="' + k + '"]');
        if (!c) { ok = false; } else { parts.push(c.textContent.trim()); }
      });
      if (!ok) return true;
      var id = map[parts.join('|')];
      if (id != null) fn(id);
      return true;
    }
    self.rolesGridClick = function (d, e) {
      return gridAction(e, ['code', 'startDate', 'status'], self._roleMap,
        function (id) { self.endRole({ urId: id }); });
    };
    self.profilesGridClick = function (d, e) {
      return gridAction(e, ['code', 'startDate', 'status'], self._profMap,
        function (id) { self.endProfile({ upId: id }); });
    };
    self.exclGridClick = function (d, e) {
      return gridAction(e, ['permCode'], self._exclMap,
        function (id) { self.endExclusion({ id: id }); });
    };

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
        buildTabGrids();
      }).catch(function (e) { self.errorMsg(e.message || 'Load failed'); })
        .then(function () { self.detailLoading(false); });
    }

    self.selectUser = function (u) {
      self.selected(u);
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

    // ── new user drawer ────────────────────────────────────────────────
    self.newUser = function () {
      self.nUsername(''); self.nDisplayName(''); self.nDisplayNameAr('');
      self.nEmail(''); self.nPhone(''); self.nOrgId(null); self.nPassword('');
      self.errorMsg('');
      self.showNewUser(true);
    };

    self.saveNewUser = function () {
      if (!(self.nUsername() || '').trim() || !(self.nDisplayName() || '').trim()
          || !(self.nEmail() || '').trim()) {
        self.errorMsg('Username, display name and email are required'); return;
      }
      var body = {
        username: self.nUsername().trim(),
        displayName: self.nDisplayName().trim(),
        displayNameAr: self.nDisplayNameAr() || null,
        email: self.nEmail().trim(),
        phone: self.nPhone() || null,
        orgId: self.nOrgId() || null,
        isActive: 'Y',
        roles: []
      };
      if (self.nPassword()) body.password = self.nPassword();
      self.saving(true); self.errorMsg('');
      userService.create(body).then(function (r) {
        var id = r.userId || r.id;
        self.showNewUser(false);
        flash('User created — assign their roles below');
        loadList();
        self.selectUser({ userId: id, displayName: body.displayName,
                          username: body.username, email: body.email });
        self.detailTab('roles');
      }).catch(function (e) { self.errorMsg(e.message || 'Save failed'); })
        .then(function () { self.saving(false); });
    };

    self.setTab = function (t) { self.detailTab(t); };
    self.toggleActive = function () { self.fActive(!self.fActive()); return true; };

    self.saveProfile = function () {
      if (!(self.fDisplayName() || '').trim() || !(self.fEmail() || '').trim()) {
        self.errorMsg('Display name and email are required'); return;
      }
      var body = {
        displayName: self.fDisplayName().trim(),
        displayNameAr: self.fDisplayNameAr() || null,
        email: self.fEmail().trim(),
        phone: self.fPhone() || null,
        orgId: self.fOrgId() || null,
        isActive: self.fActive() ? 'Y' : 'N'
      };
      if (self.fPassword()) body.password = self.fPassword();
      self.saving(true); self.errorMsg('');
      userService.update(userId(), body)
        .then(function () { loadList(); flash('User saved'); })
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
