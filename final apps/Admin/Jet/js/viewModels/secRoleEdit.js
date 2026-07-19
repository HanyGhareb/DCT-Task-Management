define(['knockout', 'services/secService'], function (ko, secService) {
  'use strict';

  function SecRoleEditViewModel() {
    var self = this;

    var editId   = sessionStorage.getItem('secEditRoleId') || 'new';
    var category = sessionStorage.getItem('secEditCategory') || 'JOB';
    self.isNew    = editId === 'new';
    self.roleId   = self.isNew ? null : Number(editId);
    self.category = ko.observable(category);

    self.loading  = ko.observable(!self.isNew);
    self.saving   = ko.observable(false);
    self.errorMsg = ko.observable('');
    self.okMsg    = ko.observable('');

    self.fCode    = ko.observable('');
    self.fName    = ko.observable('');
    self.fNameAr  = ko.observable('');
    self.fModule  = ko.observable('');
    self.fDesc    = ko.observable('');
    self.fActive  = ko.observable(true);
    self.isSystem = ko.observable(false);
    self.copiedFrom = ko.observable(null);

    self.modules   = ko.observableArray([]);
    self.allPrivs  = ko.observableArray([]);
    self.allGroups = ko.observableArray([]);
    self.allDuties = ko.observableArray([]);

    self.selPrivs  = ko.observableArray([]);  // direct privilege ids
    self.selGroups = ko.observableArray([]);  // group ids
    self.selDuties = ko.observableArray([]);  // nested duty role ids
    self.selExcl   = ko.observableArray([]);  // excluded privilege ids
    self.effective = ko.observableArray([]);

    self.privSearch = ko.observable('');
    self.activeTab  = ko.observable('grants'); // grants | duties | exclusions | effective

    self.pageTitle = ko.computed(function () {
      var what = self.category() === 'ABSTRACT' ? 'Abstract Role'
               : self.category() === 'DUTY' ? 'Duty Role' : 'Job Role';
      return (self.isNew ? 'New ' : 'Edit ') + what;
    });

    self.filteredPrivs = ko.computed(function () {
      var q = self.privSearch().toLowerCase().trim();
      if (!q) return self.allPrivs();
      return self.allPrivs().filter(function (p) {
        return p.code.toLowerCase().indexOf(q) >= 0 || p.name.toLowerCase().indexOf(q) >= 0;
      });
    });

    self.dutiesAvailable = ko.computed(function () {
      return self.allDuties().filter(function (d) { return d.id !== self.roleId; });
    });

    function toggle(arr, id) {
      var i = arr.indexOf(id);
      if (i >= 0) arr.splice(i, 1); else arr.push(id);
      return true;
    }
    self.togglePriv  = function (p) { return toggle(self.selPrivs, p.id); };
    self.toggleGroup = function (g) { return toggle(self.selGroups, g.id); };
    self.toggleDuty  = function (d) { return toggle(self.selDuties, d.id); };
    self.toggleExcl  = function (p) { return toggle(self.selExcl, p.id); };

    self.backToList = function () {
      var route = self.category() === 'ABSTRACT' ? 'abstractRoles'
                : self.category() === 'DUTY' ? 'dutyRoles' : 'jobRoles';
      if (window._jetApp) window._jetApp.navigate(route);
    };

    self.setTab = function (t) { self.activeTab(t); };

    function loadRole() {
      secService.getRole(self.roleId).then(function (d) {
        self.category(d.category);
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
        self.loading(false);
      }).catch(function (e) { self.errorMsg(e.message || 'Load failed'); self.loading(false); });
    }

    self.save = function () {
      if (!(self.fName() || '').trim() || (self.isNew && !(self.fCode() || '').trim())) {
        self.errorMsg('Code and name are required'); return;
      }
      self.saving(true); self.errorMsg('');
      var grants = {
        name: self.fName().trim(), nameAr: self.fNameAr() || null,
        description: self.fDesc() || null,
        isActive: self.fActive() ? 'Y' : 'N',
        permIds: self.selPrivs(), groupIds: self.selGroups(),
        dutyIds: self.selDuties(), exclusionPermIds: self.selExcl()
      };
      var p;
      if (self.isNew) {
        p = secService.createRole({
          code: self.fCode().trim(), name: self.fName().trim(),
          nameAr: self.fNameAr() || null, category: self.category(),
          module: self.fModule() || null, description: self.fDesc() || null
        }).then(function (r) {
          self.roleId = r.id;
          return secService.updateRole(r.id, grants);
        });
      } else {
        p = secService.updateRole(self.roleId, grants);
      }
      p.then(function () { self.backToList(); })
       .catch(function (e) { self.errorMsg(e.message || 'Save failed'); })
       .then(function () { self.saving(false); });
    };

    secService.getMeta().then(function (m) {
      self.modules((m.modules || []).map(function (x) { return x.code; }));
      self.allPrivs(m.privileges || []);
      self.allGroups(m.groups || []);
      self.allDuties(m.dutyRoles || []);
      if (!self.isNew) loadRole();
    }).catch(function (e) { self.errorMsg(e.message || 'Load failed'); self.loading(false); });
  }

  return SecRoleEditViewModel;
});
