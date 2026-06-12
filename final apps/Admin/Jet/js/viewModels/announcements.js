define(['knockout', 'services/announcementService', 'services/roleService', 'services/moduleService'],
function (ko, announcementService, roleService, moduleService) {
  'use strict';

  function AnnouncementsViewModel() {
    var self = this;

    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.items     = ko.observableArray([]);
    self.busy      = ko.observable(false);

    // editor modal (create + edit share it)
    self.showEditor = ko.observable(false);
    self.editId     = ko.observable(null);     // null = create
    self.roles      = ko.observableArray([]);
    self.modules    = ko.observableArray([]);
    self.edError    = ko.observable('');
    self.ed = {
      titleEn:    ko.observable(''),
      titleAr:    ko.observable(''),
      bodyEn:     ko.observable(''),
      bodyAr:     ko.observable(''),
      severity:   ko.observable('INFO'),
      audience:   ko.observable('ALL'),
      roleId:     ko.observable(''),
      moduleCode: ko.observable(''),
      expiresAt:  ko.observable(''),
      isActive:   ko.observable('Y')
    };

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      announcementService.getAll().then(function (items) {
        self.items(items);
        self.loading(false);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };
    self.reload();

    function loadRefs() {
      return Promise.all([
        roleService.getAll().catch(function () { return []; }),
        moduleService.getAll().catch(function () { return []; })
      ]).then(function (res) {
        self.roles(res[0] || []);
        self.modules(res[1] || []);
      });
    }

    function resetEditor() {
      self.editId(null);
      self.ed.titleEn(''); self.ed.titleAr(''); self.ed.bodyEn(''); self.ed.bodyAr('');
      self.ed.severity('INFO'); self.ed.audience('ALL');
      self.ed.roleId(''); self.ed.moduleCode(''); self.ed.expiresAt('');
      self.ed.isActive('Y');
      self.edError('');
    }

    self.openCreate = function () {
      resetEditor();
      loadRefs().then(function () { self.showEditor(true); });
    };

    self.openEdit = function (a) {
      resetEditor();
      self.editId(a.announcementId);
      self.ed.titleEn(a.titleEn); self.ed.titleAr(a.titleAr);
      self.ed.bodyEn(a.bodyEn);   self.ed.bodyAr(a.bodyAr);
      self.ed.severity(a.severity);
      self.ed.audience(a.audience);
      self.ed.roleId(a.roleId || '');
      self.ed.moduleCode(a.moduleCode || '');
      self.ed.expiresAt((a.expiresAt || '').replace(' ', 'T'));
      self.ed.isActive(a.isActive);
      loadRefs().then(function () { self.showEditor(true); });
    };

    self.save = function () {
      self.edError('');
      if (!self.ed.titleEn()) { self.edError('An English title is required.'); return; }
      if (self.ed.audience() === 'ROLE' && !self.ed.roleId())     { self.edError('Pick the target role.'); return; }
      if (self.ed.audience() === 'MODULE' && !self.ed.moduleCode()) { self.edError('Pick the target module.'); return; }
      var payload = {
        titleEn:    self.ed.titleEn(),
        titleAr:    self.ed.titleAr(),
        bodyEn:     self.ed.bodyEn(),
        bodyAr:     self.ed.bodyAr(),
        severity:   self.ed.severity(),
        audience:   self.ed.audience(),
        roleId:     self.ed.audience() === 'ROLE' ? Number(self.ed.roleId()) : null,
        moduleCode: self.ed.audience() === 'MODULE' ? self.ed.moduleCode() : null,
        expiresAt:  self.ed.expiresAt() || null,
        isActive:   self.ed.isActive()
      };
      self.busy(true);
      var p = self.editId()
        ? announcementService.update(self.editId(), payload)
        : announcementService.create(payload);
      p.then(function () {
        self.busy(false);
        self.showEditor(false);
        self.reload();
      }).catch(function (err) {
        self.busy(false);
        self.edError((err && err.message) || 'Save failed');
      });
    };

    self.toggleActive = function (a) {
      self.busy(true);
      announcementService.update(a.announcementId, { isActive: a.isActive === 'Y' ? 'N' : 'Y' })
        .then(function () { self.busy(false); self.reload(); })
        .catch(function () { self.busy(false); });
    };

    self.sevBadge = function (s) {
      var map = { INFO: 'badge--info', WARNING: 'badge--pending', CRITICAL: 'badge--rejected' };
      return 'badge ' + (map[s] || 'badge--idle');
    };
    self.audienceLabel = function (a) {
      if (a.audience === 'ALL')    return 'Everyone';
      if (a.audience === 'ROLE')   return 'Role: ' + (a.roleName || a.roleId);
      return 'Module: ' + (a.moduleName || a.moduleCode);
    };
  }

  return AnnouncementsViewModel;
});
