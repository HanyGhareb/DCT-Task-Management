/**
 * Shared implementation behind the Abstract / Duty / Job role catalog pages.
 * Each thin route VM passes its category; the view markup is identical.
 */
define(['knockout', 'services/secService'], function (ko, secService) {
  'use strict';

  var META = {
    ABSTRACT: {
      title: 'Abstract Roles',
      blurb: 'How a person relates to the system — Employee, Manager, Supplier, Freelancer',
      hint: 'Assigned directly to users. Grant only broad, relationship-level access here.'
    },
    DUTY: {
      title: 'Duty Roles',
      blurb: 'Small sets of related tasks. Never assigned to a user — always nested inside a job or abstract role',
      hint: 'A duty is the reusable building block: "Manage Freelancer Registration Finance" vs "… HR".'
    },
    JOB: {
      title: 'Job Roles',
      blurb: 'Job functions like Payroll Accountant — duty roles + privilege groups + privileges',
      hint: 'Users inherit every privilege inside the job roles assigned to them.'
    }
  };

  function SecRolesBase(category) {
    var self = this;
    var meta = META[category];

    self.category   = category;
    self.pageTitle  = meta.title;
    self.pageBlurb  = meta.blurb;
    self.pageHint   = meta.hint;

    self.items      = ko.observableArray([]);
    self.loading    = ko.observable(true);
    self.searchTerm = ko.observable('');
    self.errorMsg   = ko.observable('');
    self.okMsg      = ko.observable('');

    self.deleteTarget      = ko.observable(null);
    self.showDeleteConfirm = ko.observable(false);

    // copy modal
    self.copySource = ko.observable(null);
    self.showCopy   = ko.observable(false);
    self.cpCode     = ko.observable('');
    self.cpName     = ko.observable('');
    self.saving     = ko.observable(false);

    self.filteredItems = ko.computed(function () {
      var q = self.searchTerm().toLowerCase().trim();
      if (!q) return self.items();
      return self.items().filter(function (r) {
        return r.code.toLowerCase().indexOf(q) >= 0 || r.name.toLowerCase().indexOf(q) >= 0;
      });
    });

    function flash(msg) { self.okMsg(msg); setTimeout(function () { self.okMsg(''); }, 2500); }

    function load() {
      self.loading(true);
      secService.getRoles({ category: category })
        .then(function (r) { self.items(r.items || []); })
        .catch(function (e) { self.errorMsg(e.message || 'Load failed'); })
        .then(function () { self.loading(false); });
    }
    self.reload = load;

    self.openEditor = function (roleId) {
      sessionStorage.setItem('secEditRoleId', roleId || 'new');
      sessionStorage.setItem('secEditCategory', category);
      if (window._jetApp) window._jetApp.navigate('secRoleEdit');
    };
    self.addRole  = function () { self.openEditor('new'); };
    self.editRole = function (r) { self.openEditor(r.id); };

    self.startCopy = function (r) {
      self.copySource(r);
      self.cpCode(r.code + '_COPY');
      self.cpName('Copy of ' + r.name);
      self.errorMsg('');
      self.showCopy(true);
    };
    self.cancelCopy = function () { self.showCopy(false); self.copySource(null); };
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

    self.confirmDelete = function (r) { self.deleteTarget(r); self.showDeleteConfirm(true); };
    self.cancelDelete  = function () { self.showDeleteConfirm(false); self.deleteTarget(null); };
    self.doDelete = function () {
      var t = self.deleteTarget();
      self.cancelDelete();
      if (t) {
        secService.deleteRole(t.id)
          .then(function () { flash('Role deactivated'); load(); })
          .catch(function (e) { self.errorMsg(e.message || 'Delete failed'); });
      }
    };

    load();
  }

  return SecRolesBase;
});
