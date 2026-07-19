define(['knockout', 'services/secService'], function (ko, secService) {
  'use strict';

  function PrivilegeGroupsViewModel() {
    var self = this;

    self.items    = ko.observableArray([]);
    self.loading  = ko.observable(true);
    self.modules  = ko.observableArray([]);
    self.allPrivs = ko.observableArray([]);   // {id, code, name, module}
    self.errorMsg = ko.observable('');
    self.okMsg    = ko.observable('');

    // interactive report
    self.irData = ko.observable(null);
    var byCode = {};

    // editor drawer
    self.showEdit   = ko.observable(false);
    self.editId     = ko.observable(null);
    self.fCode      = ko.observable('');
    self.fName      = ko.observable('');
    self.fNameAr    = ko.observable('');
    self.fModule    = ko.observable('');
    self.fDesc      = ko.observable('');
    self.selected   = ko.observableArray([]);   // permission ids
    self.privSearch = ko.observable('');
    self.saving     = ko.observable(false);
    self.drawerTitle = ko.computed(function () {
      return self.editId() ? 'Edit Privilege Group' : 'New Privilege Group';
    });

    self.deleteTarget      = ko.observable(null);
    self.showDeleteConfirm = ko.observable(false);

    self.filteredPrivs = ko.computed(function () {
      var q = self.privSearch().toLowerCase().trim();
      if (!q) return self.allPrivs();
      return self.allPrivs().filter(function (p) {
        return p.code.toLowerCase().indexOf(q) >= 0 || p.name.toLowerCase().indexOf(q) >= 0;
      });
    });

    function flash(msg) { self.okMsg(msg); setTimeout(function () { self.okMsg(''); }, 2500); }

    var IR_COLS = [
      { key: 'name',        label: 'Group',        type: 'text' },
      { key: 'code',        label: 'Code',         type: 'text' },
      { key: 'module',      label: 'Module',       type: 'text' },
      { key: 'description', label: 'Description',  type: 'text' },
      { key: 'privCount',   label: 'Privileges',   type: 'num'  },
      { key: 'roleCount',   label: 'Used By Roles', type: 'num' },
      { key: 'status',      label: 'Status',       type: 'text' },
      { key: 'createdBy',   label: 'Created By',   type: 'text' },
      { key: 'createdAt',   label: 'Created On',   type: 'text' },
      { key: 'updatedBy',   label: 'Updated By',   type: 'text' },
      { key: 'updatedAt',   label: 'Updated On',   type: 'text' }
    ];

    function buildIr(list) {
      byCode = {};
      var rows = list.map(function (g) {
        byCode[g.code] = g;
        return {
          name: g.name, code: g.code, module: g.module || 'Platform',
          description: g.description || '',
          privCount: g.privCount, roleCount: g.roleCount,
          status: g.isActive === 'Y' ? 'Active' : 'Inactive',
          createdBy: g.createdBy || '', createdAt: g.createdAt || '',
          updatedBy: g.updatedBy || '', updatedAt: g.updatedAt || ''
        };
      });
      self.irData({ columns: IR_COLS, items: rows, total: rows.length,
                    truncated: false, maxRows: rows.length });
    }

    function load() {
      self.loading(true);
      secService.getGroups({ search: '' })
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
      if (row) self.editGroup(row);
      return true;
    };

    self.togglePriv = function (p) {
      var i = self.selected.indexOf(p.id);
      if (i >= 0) self.selected.splice(i, 1); else self.selected.push(p.id);
      return true;
    };

    self.addGroup = function () {
      self.editId(null);
      self.fCode(''); self.fName(''); self.fNameAr(''); self.fModule(''); self.fDesc('');
      self.selected([]); self.privSearch(''); self.errorMsg('');
      self.showEdit(true);
    };

    self.editGroup = function (g) {
      secService.getGroup(g.id).then(function (d) {
        self.editId(d.id);
        self.fCode(d.code); self.fName(d.name); self.fNameAr(d.nameAr || '');
        self.fModule(d.module || ''); self.fDesc(d.description || '');
        self.selected((d.items || []).map(function (p) { return p.id; }));
        self.privSearch(''); self.errorMsg('');
        self.showEdit(true);
      }).catch(function (e) { self.errorMsg(e.message || 'Load failed'); });
    };

    self.saveEdit = function () {
      if (!(self.fName() || '').trim() || (!self.editId() && !(self.fCode() || '').trim())) {
        self.errorMsg('Code and name are required'); return;
      }
      if (!(self.fDesc() || '').trim()) {
        self.errorMsg('Description is required — explain the purpose for end users'); return;
      }
      var body = {
        name: self.fName().trim(), nameAr: self.fNameAr() || null,
        module: self.fModule() || null, description: self.fDesc().trim(),
        permIds: self.selected()
      };
      self.saving(true); self.errorMsg('');
      var p = self.editId()
        ? secService.updateGroup(self.editId(), body)
        : secService.createGroup(Object.assign({ code: self.fCode().trim() }, body));
      p.then(function () {
        self.showEdit(false);
        flash(self.editId() ? 'Group updated' : 'Group created');
        load();
      }).catch(function (e) { self.errorMsg(e.message || 'Save failed'); })
        .then(function () { self.saving(false); });
    };

    self.askDeactivate = function () {
      var id = self.editId();
      if (!id) return;
      var row = self.items().find(function (g) { return g.id === id; });
      self.deleteTarget(row || { id: id, name: self.fName() });
      self.showDeleteConfirm(true);
    };
    self.cancelDelete = function () { self.showDeleteConfirm(false); self.deleteTarget(null); };
    self.doDelete = function () {
      var t = self.deleteTarget();
      self.cancelDelete();
      if (t) {
        secService.deleteGroup(t.id)
          .then(function () { self.showEdit(false); flash('Group deactivated'); load(); })
          .catch(function (e) { self.errorMsg(e.message || 'Delete failed'); });
      }
    };

    secService.getMeta().then(function (m) {
      self.modules((m.modules || []).map(function (x) { return x.code; }));
      self.allPrivs(m.privileges || []);
    }).catch(function () {});
    load();
  }

  return PrivilegeGroupsViewModel;
});
