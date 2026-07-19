define(['knockout', 'services/secService'], function (ko, secService) {
  'use strict';

  function PrivilegeGroupsViewModel() {
    var self = this;

    self.items      = ko.observableArray([]);
    self.loading    = ko.observable(true);
    self.searchTerm = ko.observable('');
    self.modules    = ko.observableArray([]);
    self.allPrivs   = ko.observableArray([]);   // {id, code, name, module}
    self.errorMsg   = ko.observable('');
    self.okMsg      = ko.observable('');

    // editor
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

    self.deleteTarget      = ko.observable(null);
    self.showDeleteConfirm = ko.observable(false);

    self.filteredItems = ko.computed(function () {
      var q = self.searchTerm().toLowerCase().trim();
      if (!q) return self.items();
      return self.items().filter(function (g) {
        return g.code.toLowerCase().indexOf(q) >= 0 || g.name.toLowerCase().indexOf(q) >= 0;
      });
    });

    self.filteredPrivs = ko.computed(function () {
      var q = self.privSearch().toLowerCase().trim();
      if (!q) return self.allPrivs();
      return self.allPrivs().filter(function (p) {
        return p.code.toLowerCase().indexOf(q) >= 0 || p.name.toLowerCase().indexOf(q) >= 0;
      });
    });

    function flash(msg) { self.okMsg(msg); setTimeout(function () { self.okMsg(''); }, 2500); }

    function load() {
      self.loading(true);
      secService.getGroups({ search: '' })
        .then(function (r) { self.items(r.items || []); })
        .catch(function (e) { self.errorMsg(e.message || 'Load failed'); })
        .then(function () { self.loading(false); });
    }
    self.reload = load;

    self.togglePriv = function (p) {
      var i = self.selected.indexOf(p.id);
      if (i >= 0) self.selected.splice(i, 1); else self.selected.push(p.id);
      return true;
    };
    self.isSelected = function (p) { return self.selected.indexOf(p.id) >= 0; };

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

    self.cancelEdit = function () { self.showEdit(false); };

    self.saveEdit = function () {
      if (!(self.fName() || '').trim() || (!self.editId() && !(self.fCode() || '').trim())) {
        self.errorMsg('Code and name are required'); return;
      }
      var body = {
        name: self.fName().trim(), nameAr: self.fNameAr() || null,
        module: self.fModule() || null, description: self.fDesc() || null,
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

    self.confirmDelete = function (g) { self.deleteTarget(g); self.showDeleteConfirm(true); };
    self.cancelDelete  = function () { self.showDeleteConfirm(false); self.deleteTarget(null); };
    self.doDelete = function () {
      var t = self.deleteTarget();
      self.cancelDelete();
      if (t) {
        secService.deleteGroup(t.id)
          .then(function () { flash('Group deactivated'); load(); })
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
