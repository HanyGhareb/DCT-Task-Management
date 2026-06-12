define(['knockout', 'services/orgService'], function (ko, orgService) {
  'use strict';

  function OrgHierarchyViewModel() {
    var self = this;

    self.loading    = ko.observable(true);
    self.tree       = ko.observableArray([]);
    self.flatList   = ko.observableArray([]);
    self.searchTerm = ko.observable('');
    self.errorMsg   = ko.observable('');
    self.successMsg = ko.observable('');

    function load() {
      self.loading(true);
      Promise.all([orgService.getAll(), orgService.getTree()]).then(function (results) {
        self.flatList(results[0]);
        self.tree(results[1]);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }
    load();

    self.filteredList = ko.computed(function () {
      var q = self.searchTerm().toLowerCase();
      if (!q) return self.flatList();
      return self.flatList().filter(function (o) {
        return (o.nameEn  || '').toLowerCase().includes(q) ||
               (o.orgCode || '').toLowerCase().includes(q);
      });
    });

    self.getParentName = function (parentId) {
      if (!parentId) return '—';
      var p = self.flatList().find(function (o) { return o.orgId === parentId; });
      return p ? p.nameEn : '—';
    };

    self.getTypeLabel = function (t) {
      return { DIVISION: 'Division', SECTION: 'Section', DEPARTMENT: 'Department' }[t] || (t || '');
    };

    /* ── Add / Edit modal ──────────────────────────────────────────────── */
    self.showModal   = ko.observable(false);
    self.editingId   = ko.observable(null);
    self.modalTitle  = ko.observable('');
    self.fNameEn     = ko.observable('');
    self.fNameAr     = ko.observable('');
    self.fOrgCode    = ko.observable('');
    self.fOrgType    = ko.observable('SECTION');
    self.fParentId   = ko.observable(null);
    self.fIsActive   = ko.observable(true);
    self.modalError  = ko.observable('');
    self.savingUnit  = ko.observable(false);
    self.auditTarget = ko.observable(null);   // createdBy/At, updatedBy/At of the edited unit

    self.typeOptions   = ['DIVISION', 'SECTION', 'DEPARTMENT'];
    self.parentOptions = ko.computed(function () {
      var editing = self.editingId();
      return [{ value: null, label: '— (top level)' }].concat(
        self.flatList()
          .filter(function (o) { return o.orgId !== editing; })
          .map(function (o) { return { value: o.orgId, label: o.nameEn }; })
      );
    });

    self.openAdd = function () {
      self.auditTarget(null);
      self.editingId(null);
      self.modalTitle('Add Organisation Unit');
      self.fNameEn(''); self.fNameAr(''); self.fOrgCode('');
      self.fOrgType('SECTION'); self.fParentId(null); self.fIsActive(true);
      self.modalError('');
      self.showModal(true);
    };

    self.openEdit = function (org) {
      self.auditTarget(org);
      self.editingId(org.orgId);
      self.modalTitle('Edit: ' + (org.nameEn || ''));
      self.fNameEn(org.nameEn || '');
      self.fNameAr(org.nameAr || '');
      self.fOrgCode(org.orgCode || '');
      self.fOrgType(org.orgType || 'SECTION');
      self.fParentId(org.parentOrgId || null);
      self.fIsActive(org.isActive !== 'N');
      self.modalError('');
      self.showModal(true);
    };

    self.closeModal = function () { self.showModal(false); };

    self.saveUnit = function () {
      if (!self.fNameEn().trim()) { self.modalError('English name is required'); return; }
      if (!self.fOrgCode().trim() && !self.editingId()) { self.modalError('Code is required'); return; }
      self.savingUnit(true);
      self.modalError('');
      var payload = {
        nameEn:      self.fNameEn().trim(),
        nameAr:      self.fNameAr().trim(),
        orgCode:     self.fOrgCode().trim().toUpperCase(),
        orgType:     self.fOrgType(),
        parentOrgId: self.fParentId(),
        isActive:    self.fIsActive() ? 'Y' : 'N',
      };
      var op = self.editingId()
        ? orgService.update(self.editingId(), payload)
        : orgService.create(payload);
      op.then(function () {
        self.savingUnit(false);
        self.showModal(false);
        self.successMsg(self.editingId() ? 'Unit updated.' : 'Unit created.');
        setTimeout(function () { self.successMsg(''); }, 3000);
        load();
      }).catch(function (err) {
        self.savingUnit(false);
        self.modalError((err && err.message) || 'Save failed');
      });
    };
  }

  return OrgHierarchyViewModel;
});
