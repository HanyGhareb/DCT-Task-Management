define(['knockout', 'services/secService'], function (ko, secService) {
  'use strict';

  function PrivilegesViewModel() {
    var self = this;

    self.items    = ko.observableArray([]);
    self.total    = ko.observable(0);
    self.loading  = ko.observable(true);
    self.modules  = ko.observableArray([]);
    self.verbs    = ko.observableArray([]);
    self.errorMsg = ko.observable('');
    self.okMsg    = ko.observable('');

    // interactive report
    self.irData = ko.observable(null);
    var byCode = {};

    // editor drawer
    self.showEdit  = ko.observable(false);
    self.editId    = ko.observable(null);
    self.fCode     = ko.observable('');
    self.fName     = ko.observable('');
    self.fNameAr   = ko.observable('');
    self.fModule   = ko.observable('');
    self.fAction   = ko.observable('VIEW');
    self.fDesc     = ko.observable('');
    self.saving    = ko.observable(false);
    self.drawerTitle = ko.computed(function () {
      return self.editId() ? 'Edit Privilege' : 'New Privilege';
    });

    self.deleteTarget      = ko.observable(null);
    self.showDeleteConfirm = ko.observable(false);

    function flash(msg) {
      self.okMsg(msg);
      setTimeout(function () { self.okMsg(''); }, 2500);
    }

    var IR_COLS = [
      { key: 'name',        label: 'Privilege',   type: 'text' },
      { key: 'code',        label: 'Code',        type: 'text' },
      { key: 'module',      label: 'Module',      type: 'text' },
      { key: 'actionType',  label: 'Action',      type: 'text' },
      { key: 'description', label: 'Description', type: 'text' },
      { key: 'groupCount',  label: 'Groups',      type: 'num'  },
      { key: 'roleCount',   label: 'Roles',       type: 'num'  },
      { key: 'status',      label: 'Status',      type: 'text' },
      { key: 'createdBy',   label: 'Created By',  type: 'text' },
      { key: 'createdAt',   label: 'Created On',  type: 'text' },
      { key: 'updatedBy',   label: 'Updated By',  type: 'text' },
      { key: 'updatedAt',   label: 'Updated On',  type: 'text' }
    ];

    function buildIr(list) {
      byCode = {};
      var rows = list.map(function (r) {
        byCode[r.code] = r;
        return {
          name: r.name, code: r.code, module: r.module || 'Platform',
          actionType: r.actionType || '', description: r.description || '',
          groupCount: r.groupCount, roleCount: r.roleCount,
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
      var all = [];
      function page(offset) {
        return secService.getPrivileges({ limit: 500, offset: offset }).then(function (r) {
          all = all.concat(r.items || []);
          if ((r.total || 0) > all.length && offset < 4500) return page(offset + 500);
          return { items: all, total: r.total || all.length };
        });
      }
      page(0).then(function (r) {
        self.items(r.items);
        self.total(r.total);
        buildIr(r.items);
      }).catch(function (e) { self.errorMsg(e.message || 'Load failed'); })
        .then(function () { self.loading(false); });
    }
    self.reload = load;

    /* delegated click on the IR grid: any data row opens its editor */
    self.gridClick = function (vm, e) {
      var td = e.target.closest ? e.target.closest('.ir-table tbody td[data-key]') : null;
      if (!td) return true;
      var tr = td.closest('tr');
      var cell = tr && tr.querySelector('td[data-key="code"]');
      var row = cell && byCode[(cell.textContent || '').trim()];
      if (row) self.editPrivilege(row);
      return true;
    };

    self.addPrivilege = function () {
      self.editId(null);
      self.fCode(''); self.fName(''); self.fNameAr('');
      self.fModule(''); self.fAction('VIEW'); self.fDesc('');
      self.errorMsg(''); self.showEdit(true);
    };

    self.editPrivilege = function (row) {
      self.editId(row.id);
      self.fCode(row.code); self.fName(row.name); self.fNameAr(row.nameAr || '');
      self.fModule(row.module || ''); self.fAction(row.actionType || 'VIEW');
      self.fDesc(row.description || '');
      self.errorMsg(''); self.showEdit(true);
    };

    self.saveEdit = function () {
      var name = (self.fName() || '').trim();
      var verb = (name.split(/\s+/)[0] || '').toUpperCase();
      if (!name || (!self.editId() && !(self.fCode() || '').trim())) {
        self.errorMsg('Code and name are required'); return;
      }
      if (self.verbs().length && self.verbs().indexOf(verb) < 0) {
        self.errorMsg('The name must start with a verb: ' + self.verbs().join(', ')); return;
      }
      if (!(self.fDesc() || '').trim()) {
        self.errorMsg('Description is required — explain the purpose for end users'); return;
      }
      var body = {
        name: name, nameAr: self.fNameAr() || null, module: self.fModule() || null,
        actionType: self.fAction(), description: self.fDesc().trim()
      };
      self.saving(true); self.errorMsg('');
      var p = self.editId()
        ? secService.updatePrivilege(self.editId(), body)
        : secService.createPrivilege(Object.assign({ code: self.fCode().trim() }, body));
      p.then(function () {
        self.showEdit(false);
        flash(self.editId() ? 'Privilege updated' : 'Privilege created');
        load();
      }).catch(function (e) { self.errorMsg(e.message || 'Save failed'); })
        .then(function () { self.saving(false); });
    };

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
        secService.deletePrivilege(t.id)
          .then(function () { self.showEdit(false); flash('Privilege deactivated'); load(); })
          .catch(function (e) { self.errorMsg(e.message || 'Delete failed'); });
      }
    };

    secService.getMeta().then(function (m) {
      self.modules((m.modules || []).map(function (x) { return x.code; }));
      self.verbs(m.verbs || []);
    }).catch(function () {});
    load();
  }

  return PrivilegesViewModel;
});
