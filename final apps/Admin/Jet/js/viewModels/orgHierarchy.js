define(['knockout', 'services/orgService', 'shared/i18n', 'shared/toast', 'shared/formGuard'],
function (ko, orgService, i18n, toast, formGuard) {
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

    /* Breadcrumb path of a unit (root → … → parent) shown in the modal so
       the admin always knows WHERE in the tree they are editing/adding. */
    self.modalPath = ko.observable('');
    function pathOf(parentId) {
      var names = [], guard = 0;
      var id = parentId;
      while (id && guard++ < 20) {
        var p = self.flatList().find(function (o) { return o.orgId === id; });
        if (!p) break;
        names.unshift(p.nameEn);
        id = p.parentOrgId;
      }
      return names.join(' › ');
    }

    self.openAdd = function () {
      self.auditTarget(null);
      self.editingId(null);
      self.modalTitle('Add Organisation Unit');
      self.fNameEn(''); self.fNameAr(''); self.fOrgCode('');
      self.fOrgType('SECTION'); self.fParentId(null); self.fIsActive(true);
      self.modalPath('');
      self.modalError('');
      self.showModal(true);
    };

    /* UAT ORG-03: per-node "add child" — pre-targets the parent */
    self.addChild = function (org) {
      self.openAdd();
      self.fParentId(org.orgId);
      self.fOrgType(org.orgType === 'DIVISION' ? 'SECTION' : 'DEPARTMENT');
      self.modalTitle('Add Unit under: ' + (org.nameEn || ''));
      self.modalPath(pathOf(org.orgId));
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
      self.modalPath(pathOf(org.parentOrgId));
      self.modalError('');
      self.showModal(true);
    };

    /* UAT ORG-03: one-click deactivate/reactivate on the node, undo-able */
    self.toggleActive = function (org) {
      var deactivating = org.isActive !== 'N';
      orgService.update(org.orgId, { isActive: deactivating ? 'N' : 'Y' }).then(function () {
        load();
        if (deactivating) {
          toast.undo(
            (org.nameEn || '') + ' ' + i18n.t('status.inactive').toLowerCase(),
            function () {
              orgService.update(org.orgId, { isActive: 'Y' }).then(load);
            },
            i18n.t('common.undo'));
        }
      });
    };

    self.closeModal = function () { self.showModal(false); };

    // Wave 2: dirty guard over the modal fields — re-baselined on open/close
    self._guard = formGuard.track([
      self.fNameEn, self.fNameAr, self.fOrgCode, self.fOrgType,
      self.fParentId, self.fIsActive
    ]);
    self.showModal.subscribe(function () { self._guard.reset(); });

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
