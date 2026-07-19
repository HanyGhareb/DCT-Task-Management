define(['knockout', 'services/secService'], function (ko, secService) {
  'use strict';

  function SecProfilesViewModel() {
    var self = this;

    self.items      = ko.observableArray([]);
    self.loading    = ko.observable(true);
    self.searchTerm = ko.observable('');
    self.objectTypes = ko.observableArray([]);  // {code, nameEn, hierarchy}
    self.errorMsg   = ko.observable('');
    self.okMsg      = ko.observable('');

    // editor
    self.showEdit = ko.observable(false);
    self.editId   = ko.observable(null);
    self.fCode    = ko.observable('');
    self.fName    = ko.observable('');
    self.fNameAr  = ko.observable('');
    self.fDesc    = ko.observable('');
    self.scopes   = ko.observableArray([]);  // {objectType, typeName, objectKey, label, includeChildren}
    self.saving   = ko.observable(false);

    // scope adder
    self.newDim      = ko.observable('');
    self.lovSearch   = ko.observable('');
    self.lovItems    = ko.observableArray([]);
    self.lovLoading  = ko.observable(false);
    self.newChildren = ko.observable(false);

    self.deleteTarget      = ko.observable(null);
    self.showDeleteConfirm = ko.observable(false);

    self.filteredItems = ko.computed(function () {
      var q = self.searchTerm().toLowerCase().trim();
      if (!q) return self.items();
      return self.items().filter(function (p) {
        return p.code.toLowerCase().indexOf(q) >= 0 || p.name.toLowerCase().indexOf(q) >= 0;
      });
    });

    self.newDimMeta = ko.computed(function () {
      var code = self.newDim();
      return self.objectTypes().find(function (t) { return t.code === code; }) || null;
    });

    function flash(msg) { self.okMsg(msg); setTimeout(function () { self.okMsg(''); }, 2500); }

    function load() {
      self.loading(true);
      secService.getProfiles({})
        .then(function (r) { self.items(r.items || []); })
        .catch(function (e) { self.errorMsg(e.message || 'Load failed'); })
        .then(function () { self.loading(false); });
    }
    self.reload = load;

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

    self.cancelEdit = function () { self.showEdit(false); };

    self.saveEdit = function () {
      if (!(self.fName() || '').trim() || (!self.editId() && !(self.fCode() || '').trim())) {
        self.errorMsg('Code and name are required'); return;
      }
      var body = {
        name: self.fName().trim(), nameAr: self.fNameAr() || null,
        description: self.fDesc() || null,
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

    self.confirmDelete = function (p) { self.deleteTarget(p); self.showDeleteConfirm(true); };
    self.cancelDelete  = function () { self.showDeleteConfirm(false); self.deleteTarget(null); };
    self.doDelete = function () {
      var t = self.deleteTarget();
      self.cancelDelete();
      if (t) {
        secService.deleteProfile(t.id)
          .then(function () { flash('Profile deactivated'); load(); })
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
