/**
 * Shared implementation behind the Abstract / Duty / Job role catalog pages.
 * Each thin route VM passes its category; the view markup is identical.
 * The list renders in the shared <interactive-report>; the full role editor
 * (definition + grants + nested duties + exclusions + effective preview)
 * lives in a wide <edit-drawer> — no separate editor route.
 */
define(['knockout', 'services/secService'], function (ko, secService) {
  'use strict';

  var META = {
    ABSTRACT: {
      title: 'Abstract Roles',
      blurb: 'How a person relates to the system — Employee, Manager, Supplier, Freelancer',
      what:  'Abstract Role'
    },
    DUTY: {
      title: 'Duty Roles',
      blurb: 'Small sets of related tasks. Never assigned to a user — always nested inside a job or abstract role',
      what:  'Duty Role'
    },
    JOB: {
      title: 'Job Roles',
      blurb: 'Job functions like Payroll Accountant — duty roles + privilege groups + privileges',
      what:  'Job Role'
    }
  };

  function SecRolesBase(category) {
    var self = this;
    var meta = META[category];

    self.category   = category;
    self.pageTitle  = meta.title;
    self.pageBlurb  = meta.blurb + '. Click a row to edit.';
    self.roleWhat   = meta.what;

    self.items    = ko.observableArray([]);
    self.loading  = ko.observable(true);
    self.errorMsg = ko.observable('');
    self.okMsg    = ko.observable('');

    // interactive report
    self.irData = ko.observable(null);
    var byCode = {};

    // ---- editor drawer state ------------------------------------------
    self.showEdit  = ko.observable(false);
    self.editId    = ko.observable(null);
    self.fCode     = ko.observable('');
    self.fName     = ko.observable('');
    self.fNameAr   = ko.observable('');
    self.fModule   = ko.observable('');
    self.fDesc     = ko.observable('');
    self.fActive   = ko.observable(true);
    self.isSystem  = ko.observable(false);
    self.copiedFrom = ko.observable(null);
    self.saving    = ko.observable(false);
    self.edLoading = ko.observable(false);

    self.modules   = ko.observableArray([]);
    self.allPrivs  = ko.observableArray([]);
    self.allGroups = ko.observableArray([]);
    self.allDuties = ko.observableArray([]);

    self.selPrivs  = ko.observableArray([]);
    self.selGroups = ko.observableArray([]);
    self.selDuties = ko.observableArray([]);
    self.selExcl   = ko.observableArray([]);
    self.effective = ko.observableArray([]);

    self.privSearch = ko.observable('');
    self.activeTab  = ko.observable('grants'); // grants | duties | exclusions | effective

    self.drawerTitle = ko.computed(function () {
      return (self.editId() ? 'Edit ' : 'New ') + self.roleWhat;
    });

    self.filteredPrivs = ko.computed(function () {
      var q = self.privSearch().toLowerCase().trim();
      if (!q) return self.allPrivs();
      return self.allPrivs().filter(function (p) {
        return p.code.toLowerCase().indexOf(q) >= 0 || p.name.toLowerCase().indexOf(q) >= 0;
      });
    });
    self.dutiesAvailable = ko.computed(function () {
      var id = self.editId();
      return self.allDuties().filter(function (d) { return d.id !== id; });
    });

    // copy drawer
    self.copySource = ko.observable(null);
    self.showCopy   = ko.observable(false);
    self.cpCode     = ko.observable('');
    self.cpName     = ko.observable('');

    self.deleteTarget      = ko.observable(null);
    self.showDeleteConfirm = ko.observable(false);

    function flash(msg) { self.okMsg(msg); setTimeout(function () { self.okMsg(''); }, 2500); }

    // ---- interactive report -------------------------------------------
    var IR_COLS = [
      { key: 'name',        label: 'Role',        type: 'text' },
      { key: 'code',        label: 'Code',        type: 'text' },
      { key: 'module',      label: 'Module',      type: 'text' },
      { key: 'description', label: 'Description', type: 'text' }
    ].concat(category !== 'DUTY' ? [{ key: 'memberCount', label: 'Members', type: 'num' }] : [])
     .concat([
      { key: 'dutyCount',   label: 'Duties',      type: 'num'  },
      { key: 'privCount',   label: 'Privileges',  type: 'num'  },
      { key: 'copiedFrom',  label: 'Copied From', type: 'text' },
      { key: 'status',      label: 'Status',      type: 'text' },
      { key: 'createdBy',   label: 'Created By',  type: 'text' },
      { key: 'createdAt',   label: 'Created On',  type: 'text' },
      { key: 'updatedBy',   label: 'Updated By',  type: 'text' },
      { key: 'updatedAt',   label: 'Updated On',  type: 'text' }
    ]);

    function buildIr(list) {
      byCode = {};
      var rows = list.map(function (r) {
        byCode[r.code] = r;
        return {
          name: r.name, code: r.code, module: r.module || 'Platform',
          description: r.description || '',
          memberCount: r.memberCount || 0,
          dutyCount: r.dutyCount, privCount: r.privCount,
          copiedFrom: r.copiedFrom || '',
          status: r.isActive === 'Y' ? 'Active' : 'Inactive',
          createdBy: r.createdBy || '', createdAt: r.createdAt || '',
          updatedBy: r.updatedBy || '', updatedAt: r.updatedAt || ''
        };
      });
      self.irData({ columns: IR_COLS, items: rows, total: rows.length,
                    truncated: false, maxRows: rows.length });
    }

    function load() {
      self.loading(true);
      secService.getRoles({ category: category })
        .then(function (r) { self.items(r.items || []); buildIr(r.items || []); })
        .catch(function (e) { self.errorMsg(e.message || 'Load failed'); })
        .then(function () { self.loading(false); });
    }
    self.reload = load;

    self.gridClick = function (vm, e) {
      var td = e.target.closest ? e.target.closest('.ir-table tbody td[data-key]') : null;
      if (!td) return true;
      var tr = td.closest('tr');
      var cell = tr && tr.querySelector('td[data-key="code"]');
      var row = cell && byCode[(cell.textContent || '').trim()];
      if (row) self.editRole(row);
      return true;
    };

    // ---- editor -------------------------------------------------------
    function resetEditor() {
      self.fCode(''); self.fName(''); self.fNameAr(''); self.fModule('');
      self.fDesc(''); self.fActive(true); self.isSystem(false); self.copiedFrom(null);
      self.selPrivs([]); self.selGroups([]); self.selDuties([]); self.selExcl([]);
      self.effective([]); self.privSearch(''); self.activeTab('grants');
      self.errorMsg('');
    }

    self.addRole = function () {
      self.editId(null);
      resetEditor();
      self.showEdit(true);
    };

    self.editRole = function (r) {
      resetEditor();
      self.editId(r.id);
      self.edLoading(true);
      self.showEdit(true);
      secService.getRole(r.id).then(function (d) {
        self.fCode(d.code); self.fName(d.name); self.fNameAr(d.nameAr || '');
        self.fModule(d.module || ''); self.fDesc(d.description || '');
        self.fActive(d.isActive === 'Y');
        self.isSystem(d.isSystem === 'Y');
        self.copiedFrom(d.copiedFrom || null);
        self.selPrivs(d.permIds || []);
        self.selGroups(d.groupIds || []);
        self.selDuties((d.duties || []).map(function (x) { return x.id; }));
        self.selExcl((d.exclusions || []).map(function (x) { return x.permId; }));
        self.effective(d.effective || []);
      }).catch(function (e) { self.errorMsg(e.message || 'Load failed'); })
        .then(function () { self.edLoading(false); });
    };

    function toggle(arr, id) {
      var i = arr.indexOf(id);
      if (i >= 0) arr.splice(i, 1); else arr.push(id);
      return true;
    }
    self.togglePriv  = function (p) { return toggle(self.selPrivs, p.id); };
    self.toggleGroup = function (g) { return toggle(self.selGroups, g.id); };
    self.toggleDuty  = function (d) { return toggle(self.selDuties, d.id); };
    self.toggleExcl  = function (p) { return toggle(self.selExcl, p.id); };
    self.setTab      = function (t) { self.activeTab(t); };
    self.toggleActive = function () { self.fActive(!self.fActive()); return true; };

    self.saveEdit = function () {
      if (!(self.fName() || '').trim() || (!self.editId() && !(self.fCode() || '').trim())) {
        self.errorMsg('Code and name are required'); return;
      }
      if (!(self.fDesc() || '').trim()) {
        self.errorMsg('Description is required — explain the purpose for end users'); return;
      }
      self.saving(true); self.errorMsg('');
      var grants = {
        name: self.fName().trim(), nameAr: self.fNameAr() || null,
        description: self.fDesc().trim(),
        isActive: self.fActive() ? 'Y' : 'N',
        permIds: self.selPrivs(), groupIds: self.selGroups(),
        dutyIds: self.selDuties(), exclusionPermIds: self.selExcl()
      };
      var p;
      if (!self.editId()) {
        p = secService.createRole({
          code: self.fCode().trim(), name: self.fName().trim(),
          nameAr: self.fNameAr() || null, category: category,
          module: self.fModule() || null, description: self.fDesc().trim()
        }).then(function (r) { return secService.updateRole(r.id, grants); });
      } else {
        p = secService.updateRole(self.editId(), grants);
      }
      p.then(function () {
        self.showEdit(false);
        flash(self.editId() ? 'Role updated' : 'Role created');
        load();
      }).catch(function (e) { self.errorMsg(e.message || 'Save failed'); })
        .then(function () { self.saving(false); });
    };

    // ---- copy ---------------------------------------------------------
    self.startCopy = function () {
      var id = self.editId();
      var r = self.items().find(function (x) { return x.id === id; });
      if (!r) return;
      self.copySource(r);
      self.cpCode(r.code + '_COPY');
      self.cpName('Copy of ' + r.name);
      self.errorMsg('');
      self.showEdit(false);
      self.showCopy(true);
    };
    self.doCopy = function () {
      var src = self.copySource();
      if (!src || !(self.cpCode() || '').trim() || !(self.cpName() || '').trim()) {
        self.errorMsg('Code and name are required'); return;
      }
      self.saving(true); self.errorMsg('');
      secService.copyRole(src.id, { code: self.cpCode().trim(), name: self.cpName().trim() })
        .then(function () { self.showCopy(false); flash('Role copied'); load(); })
        .catch(function (e) { self.errorMsg(e.message || 'Copy failed'); })
        .then(function () { self.saving(false); });
    };

    // ---- deactivate ---------------------------------------------------
    self.askDeactivate = function () {
      var id = self.editId();
      if (!id) return;
      var row = self.items().find(function (r) { return r.id === id; });
      self.deleteTarget(row || { id: id, name: self.fName() });
      self.showDeleteConfirm(true);
    };
    self.cancelDelete = function () { self.showDeleteConfirm(false); self.deleteTarget(null); };
    self.doDelete = function () {
      var t = self.deleteTarget();
      self.cancelDelete();
      if (t) {
        secService.deleteRole(t.id)
          .then(function () { self.showEdit(false); flash('Role deactivated'); load(); })
          .catch(function (e) { self.errorMsg(e.message || 'Delete failed'); });
      }
    };

    secService.getMeta().then(function (m) {
      self.modules((m.modules || []).map(function (x) { return x.code; }));
      self.allPrivs(m.privileges || []);
      self.allGroups(m.groups || []);
      self.allDuties(m.dutyRoles || []);
    }).catch(function () {});
    load();
  }

  return SecRolesBase;
});
