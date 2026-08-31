define(['knockout', 'services/secService'], function (ko, secService) {
  'use strict';

  function SecProfilesViewModel() {
    var self = this;

    self.items       = ko.observableArray([]);
    self.loading     = ko.observable(true);
    self.objectTypes = ko.observableArray([]);  // {code, nameEn, hierarchy}
    self.errorMsg    = ko.observable('');
    self.okMsg       = ko.observable('');

    // interactive report
    self.irData = ko.observable(null);
    var byCode = {};

    // editor drawer
    self.showEdit = ko.observable(false);
    self.editId   = ko.observable(null);
    self.fCode    = ko.observable('');
    self.fName    = ko.observable('');
    self.fNameAr  = ko.observable('');
    self.fDesc    = ko.observable('');
    self.scopes   = ko.observableArray([]);  // {objectType, typeName, objectKey, label, includeChildren}
    self.saving   = ko.observable(false);
    self.drawerTitle = ko.computed(function () {
      return self.editId() ? 'Edit Security Profile' : 'New Security Profile';
    });

    // scope adder
    self.newDim      = ko.observable('');
    self.lovSearch   = ko.observable('');
    self.lovItems    = ko.observableArray([]);
    self.lovLoading  = ko.observable(false);
    self.newChildren = ko.observable(false);

    self.deleteTarget      = ko.observable(null);
    self.showDeleteConfirm = ko.observable(false);

    self.newDimMeta = ko.computed(function () {
      var code = self.newDim();
      return self.objectTypes().find(function (t) { return t.code === code; }) || null;
    });

    function flash(msg) { self.okMsg(msg); setTimeout(function () { self.okMsg(''); }, 2500); }

    var IR_COLS = [
      { key: 'name',        label: 'Profile',     type: 'text' },
      { key: 'code',        label: 'Code',        type: 'text' },
      { key: 'description', label: 'Description', type: 'text' },
      { key: 'scopeCount',  label: 'Scope Rows',  type: 'num'  },
      { key: 'userCount',   label: 'Users',       type: 'num'  },
      { key: 'status',      label: 'Status',      type: 'text' },
      { key: 'createdBy',   label: 'Created By',  type: 'text' },
      { key: 'createdAt',   label: 'Created On',  type: 'text' },
      { key: 'updatedBy',   label: 'Updated By',  type: 'text' },
      { key: 'updatedAt',   label: 'Updated On',  type: 'text' }
    ];

    function buildIr(list) {
      byCode = {};
      var rows = list.map(function (p) {
        byCode[p.code] = p;
        return {
          name: p.name, code: p.code, description: p.description || '',
          scopeCount: p.scopeCount, userCount: p.userCount,
          status: p.isActive === 'Y' ? 'Active' : 'Inactive',
          createdBy: p.createdBy || '', createdAt: p.createdAt || '',
          updatedBy: p.updatedBy || '', updatedAt: p.updatedAt || ''
        };
      });
      self.irData({ columns: IR_COLS, items: rows, total: rows.length,
                    truncated: false, maxRows: rows.length });
    }

    function load() {
      self.loading(true);
      secService.getProfiles({})
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
      if (row) self.editProfile(row);
      return true;
    };

    var lovTimer = null;
    function refreshLov() {
      var dim = self.newDim();
      if (!dim) { self.lovItems([]); return; }
      self.lovLoading(true);
      secService.getLov(dim, self.lovSearch())
        .then(function (r) { self.lovItems(r.items || []); })
        .catch(function () { self.lovItems([]); })
        .then(function () { self.lovLoading(false); });
    }
    self.newDim.subscribe(function () { self.lovSearch(''); refreshLov(); });
    self.lovSearch.subscribe(function () {
      clearTimeout(lovTimer);
      lovTimer = setTimeout(refreshLov, 300);
    });

    self.addScope = function (lovRow) {
      var meta = self.newDimMeta();
      if (!meta) return;
      var dup = self.scopes().some(function (s) {
        return s.objectType === meta.code && s.objectKey === lovRow.key;
      });
      if (dup) return;
      self.scopes.push({
        objectType: meta.code, typeName: meta.nameEn,
        objectKey: lovRow.key, label: lovRow.label,
        includeChildren: (self.newChildren() && meta.hierarchy !== 'NONE') ? 'Y' : 'N'
      });
    };
    self.removeScope = function (s) { self.scopes.remove(s); };
    self.toggleChildren = function () { self.newChildren(!self.newChildren()); return true; };

    self.addProfile = function () {
      self.editId(null);
      self.fCode(''); self.fName(''); self.fNameAr(''); self.fDesc('');
      self.scopes([]); self.newDim(''); self.lovItems([]); self.newChildren(false);
      self.errorMsg(''); self.showEdit(true);
    };

    self.editProfile = function (p) {
      secService.getProfile(p.id).then(function (d) {
        self.editId(d.id);
        self.fCode(d.code); self.fName(d.name); self.fNameAr(d.nameAr || '');
        self.fDesc(d.description || '');
        self.scopes((d.scopes || []).map(function (s) {
          return { objectType: s.objectType, typeName: s.typeName,
                   objectKey: s.objectKey, label: s.label || s.objectKey,
                   includeChildren: s.includeChildren };
        }));
        self.newDim(''); self.lovItems([]); self.newChildren(false);
        self.errorMsg(''); self.showEdit(true);
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
        description: self.fDesc().trim(),
        scopes: self.scopes().map(function (s) {
          return { objectType: s.objectType, objectKey: s.objectKey,
                   label: s.label, includeChildren: s.includeChildren };
        })
      };
      self.saving(true); self.errorMsg('');
      var p = self.editId()
        ? secService.updateProfile(self.editId(), body)
        : secService.createProfile(Object.assign({ code: self.fCode().trim() }, body));
      p.then(function () {
        self.showEdit(false);
        flash(self.editId() ? 'Profile updated' : 'Profile created');
        load();
      }).catch(function (e) { self.errorMsg(e.message || 'Save failed'); })
        .then(function () { self.saving(false); });
    };

    self.askDeactivate = function () {
      var id = self.editId();
      if (!id) return;
      var row = self.items().find(function (p) { return p.id === id; });
      self.deleteTarget(row || { id: id, name: self.fName() });
      self.showDeleteConfirm(true);
    };
    self.cancelDelete = function () { self.showDeleteConfirm(false); self.deleteTarget(null); };
    self.doDelete = function () {
      var t = self.deleteTarget();
      self.cancelDelete();
      if (t) {
        secService.deleteProfile(t.id)
          .then(function () { self.showEdit(false); flash('Profile deactivated'); load(); })
          .catch(function (e) { self.errorMsg(e.message || 'Delete failed'); });
      }
    };

    secService.getMeta().then(function (m) {
      self.objectTypes(m.objectTypes || []);
    }).catch(function () {});
    load();
  }

  return SecProfilesViewModel;
});
