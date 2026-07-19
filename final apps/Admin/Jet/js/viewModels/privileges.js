define(['knockout', 'services/secService'], function (ko, secService) {
  'use strict';

  function PrivilegesViewModel() {
    var self = this;

    self.items      = ko.observableArray([]);
    self.total      = ko.observable(0);
    self.loading    = ko.observable(true);
    self.searchTerm = ko.observable('');
    self.moduleFilter = ko.observable('');
    self.modules    = ko.observableArray([]);
    self.verbs      = ko.observableArray([]);
    self.page       = ko.observable(0);
    self.pageSize   = 25;
    self.errorMsg   = ko.observable('');
    self.okMsg      = ko.observable('');

    // editor modal
    self.showEdit  = ko.observable(false);
    self.editId    = ko.observable(null);
    self.fCode     = ko.observable('');
    self.fName     = ko.observable('');
    self.fNameAr   = ko.observable('');
    self.fModule   = ko.observable('');
    self.fAction   = ko.observable('VIEW');
    self.fDesc     = ko.observable('');
    self.saving    = ko.observable(false);

    self.deleteTarget      = ko.observable(null);
    self.showDeleteConfirm = ko.observable(false);

    self.pageCount = ko.computed(function () {
      return Math.max(1, Math.ceil(self.total() / self.pageSize));
    });

    function flash(msg) {
      self.okMsg(msg);
      setTimeout(function () { self.okMsg(''); }, 2500);
    }

    function load() {
      self.loading(true);
      secService.getPrivileges({
        search: self.searchTerm().trim(), module: self.moduleFilter(),
        limit: self.pageSize, offset: self.page() * self.pageSize
      }).then(function (r) {
        self.items(r.items || []);
        self.total(r.total || 0);
      }).catch(function (e) { self.errorMsg(e.message || 'Load failed'); })
        .then(function () { self.loading(false); });
    }
    self.reload = load;

    self.search = function () { self.page(0); load(); };
    self.prevPage = function () { if (self.page() > 0) { self.page(self.page() - 1); load(); } };
    self.nextPage = function () { if (self.page() + 1 < self.pageCount()) { self.page(self.page() + 1); load(); } };

    self.addPrivilege = function () {
      self.editId(null);
      self.fCode(''); self.fName(''); self.fNameAr('');
      self.fModule(self.moduleFilter() || ''); self.fAction('VIEW'); self.fDesc('');
      self.errorMsg(''); self.showEdit(true);
    };

    self.editPrivilege = function (row) {
      self.editId(row.id);
      self.fCode(row.code); self.fName(row.name); self.fNameAr(row.nameAr || '');
      self.fModule(row.module || ''); self.fAction(row.actionType || 'VIEW');
      self.fDesc(row.description || '');
      self.errorMsg(''); self.showEdit(true);
    };

    self.cancelEdit = function () { self.showEdit(false); };

    self.saveEdit = function () {
      var name = (self.fName() || '').trim();
      var verb = (name.split(/\s+/)[0] || '').toUpperCase();
      if (!name || (!self.editId() && !(self.fCode() || '').trim())) {
        self.errorMsg('Code and name are required'); return;
      }
      if (self.verbs().length && self.verbs().indexOf(verb) < 0) {
        self.errorMsg('The name must start with a verb: ' + self.verbs().join(', ')); return;
      }
      var body = {
        name: name, nameAr: self.fNameAr() || null, module: self.fModule() || null,
        actionType: self.fAction(), description: self.fDesc() || null
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

    self.confirmDelete = function (row) { self.deleteTarget(row); self.showDeleteConfirm(true); };
    self.cancelDelete  = function () { self.showDeleteConfirm(false); self.deleteTarget(null); };
    self.doDelete = function () {
      var t = self.deleteTarget();
      self.cancelDelete();
      if (t) {
        secService.deletePrivilege(t.id)
          .then(function () { flash('Privilege deactivated'); load(); })
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
