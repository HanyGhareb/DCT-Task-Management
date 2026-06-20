define(['knockout', 'services/tmService', 'shared/i18n', 'shared/toast'],
function (ko, tm, i18n, toast) {
  'use strict';
  var ARTIFACTS = ['TEAM','MEMBER','ROLE','OBJECTIVE','TASK','DELIVERABLE','MILESTONE',
                   'LOG_ITEM','MEETING','DOCUMENT','CYCLE','PERIOD','SUBMISSION'];
  return function TeamRoles() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.roles = ko.observableArray([]);
    self.role = ko.observable('');           // selected role_code
    self.perms = ko.observableArray([]);
    self.saving = ko.observable(false);

    self.selectedRole = ko.computed(function () {
      var c = self.role(); return self.roles().filter(function (r) { return r.code === c; })[0] || {};
    });

    self.loadPerms = function () {
      if (!self.role()) return;
      tm.getPerms('', self.role()).then(function (r) { self.perms(r.items || []); }).catch(function () {});
    };
    self.role.subscribe(function () { self.loadPerms(); });

    self.refresh = function () {
      tm.boot().then(function (b) {
        self.roles(b.roles || []);
        if (!self.role() && b.roles && b.roles.length) self.role(b.roles[0].code);
        else self.loadPerms();
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };

    self.yn = function (v) { return v === 'Y' ? '✓' : '·'; };

    // ---- toggle a template-default permission cell ----
    self.toggle = function (perm, field) {
      var cur = perm[field] === 'Y' ? 'N' : 'Y';
      tm.saveRoleTemplatePerm({
        roleCode: self.role(), artifact: perm.artifact,
        canCreate: field === 'canCreate' ? cur : perm.canCreate,
        canRead:   field === 'canRead'   ? cur : perm.canRead,
        canUpdate: field === 'canUpdate' ? cur : perm.canUpdate,
        canDelete: field === 'canDelete' ? cur : perm.canDelete
      }).then(function () { toast.success('✓'); self.loadPerms(); }).catch(function () {});
    };

    // ---- role editor (create / edit) ----
    self.editing = ko.observable(false);
    self.f = { tmRoleId: ko.observable(null), code: ko.observable(''), nameEn: ko.observable(''),
               nameAr: ko.observable(''), descriptionEn: ko.observable(''), isLeader: ko.observable('N'),
               isSystem: ko.observable('N') };
    self.newRole = function () {
      self.f.tmRoleId(null); self.f.code(''); self.f.nameEn(''); self.f.nameAr('');
      self.f.descriptionEn(''); self.f.isLeader('N'); self.f.isSystem('N'); self.editing(true);
    };
    self.editRole = function () {
      var r = self.selectedRole();
      self.f.tmRoleId(r.tmRoleId); self.f.code(r.code); self.f.nameEn(r.nameEn); self.f.nameAr(r.nameAr);
      self.f.descriptionEn(r.descriptionEn); self.f.isLeader(r.isLeader); self.f.isSystem(r.isSystem); self.editing(true);
    };
    self.cancel = function () { self.editing(false); };
    self.saveRole = function () {
      self.saving(true);
      tm.saveRole({
        roleCode: self.f.code(), nameEn: self.f.nameEn(), nameAr: self.f.nameAr(),
        descriptionEn: self.f.descriptionEn(), isLeader: self.f.isLeader()
      }).then(function () {
        toast.success(self.t('tm.role.saved')); self.saving(false); self.editing(false);
        self.role(self.f.code().toUpperCase()); self.refresh();
      }).catch(function () { self.saving(false); });
    };
    self.retire = function () {
      var r = self.selectedRole();
      if (r.isSystem === 'Y') { toast.error(self.t('tm.role.system')); return; }
      if (!window.confirm(self.t('tm.role.retireConfirm'))) return;
      tm.retireRole(r.tmRoleId).then(function () { toast.success('✓'); self.role(''); self.refresh(); }).catch(function () {});
    };

    self.refresh();
  };
});
