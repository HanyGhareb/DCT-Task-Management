define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function OrgHierarchyViewModel() {
    var self = this;
    window._hrOrgVM = self; // needed by recursive KO named template — $root there is appController, not this VM

    self.isAdmin  = authService.isHrAdmin();
    self.isMgr    = authService.isHrManager();
    self.orgNodes = ko.observableArray([]);
    self.selected   = ko.observable(null);
    self.loading    = ko.observable(true);
    self.error      = ko.observable('');
    self.filterText = ko.observable('');
    self.savedMsg   = ko.observable('');

    // Org modal state
    self.showOrgModal  = ko.observable(false);
    self.editingOrgId  = ko.observable(null);
    self.orgSaving     = ko.observable(false);
    self.orgFormError  = ko.observable('');
    self.orgForm = {
      org_code:          ko.observable(''),
      org_name_en:       ko.observable(''),
      org_name_ar:       ko.observable(''),
      org_type:          ko.observable(''),
      parent_org_id:     ko.observable(''),
      headcount_ceiling: ko.observable(''),
      cost_center_code:  ko.observable(''),
      is_active:         ko.observable('Y'),
    };

    self.expandAll = function () {
      self.orgNodes().forEach(function (n) { if (n.children && n.children().length > 0) n.expanded(true); });
    };

    self.collapseAll = function () {
      self.orgNodes().forEach(function (n) { if (n.expanded) n.expanded(false); });
    };

    function _openModal(parentOrgId) {
      Object.keys(self.orgForm).forEach(function (k) { self.orgForm[k](k === 'is_active' ? 'Y' : ''); });
      self.orgForm.parent_org_id(parentOrgId != null ? String(parentOrgId) : '');
      self.editingOrgId(null);
      self.orgFormError('');
      self.showOrgModal(true);
    }

    self.openAdd = function () { _openModal(null); };

    self.addSibling = function () {
      if (!self.selected()) return;
      _openModal(self.selected().parentOrgId || null);
    };

    self.addChild = function () {
      if (!self.selected()) return;
      _openModal(self.selected().orgId);
    };

    self.openEdit = function (node) {
      if (!node) return;
      self.editingOrgId(node.orgId);
      self.orgForm.org_code(node.orgCode || '');
      self.orgForm.org_name_en(node.orgNameEn || '');
      self.orgForm.org_name_ar(node.orgNameAr || '');
      self.orgForm.org_type(node.orgType || '');
      self.orgForm.parent_org_id(node.parentOrgId ? String(node.parentOrgId) : '');
      self.orgForm.headcount_ceiling(node.headcountCeiling || '');
      self.orgForm.cost_center_code(node.costCenterCode || '');
      self.orgForm.is_active(node.isActive || 'Y');
      self.orgFormError('');
      self.showOrgModal(true);
    };

    self.closeOrgModal = function () {
      if (!self.orgSaving()) self.showOrgModal(false);
    };

    self.saveOrg = function () {
      var code = self.orgForm.org_code().trim();
      var name = self.orgForm.org_name_en().trim();
      if (!code) { self.orgFormError('Org Code is required.'); return; }
      if (!name) { self.orgFormError('Name (EN) is required.'); return; }

      var data = {
        org_code:          code,
        org_name_en:       name,
        org_name_ar:       self.orgForm.org_name_ar(),
        org_type:          self.orgForm.org_type(),
        parent_org_id:     self.orgForm.parent_org_id() || null,
        headcount_ceiling: self.orgForm.headcount_ceiling() || null,
        cost_center_code:  self.orgForm.cost_center_code(),
        is_active:         self.orgForm.is_active(),
      };

      self.orgSaving(true);
      var op = self.editingOrgId()
        ? hrService.updateOrg(self.editingOrgId(), data)
        : hrService.createOrg(data);

      op.then(function () {
        self.orgSaving(false);
        self.showOrgModal(false);
        self.savedMsg(self.editingOrgId() ? 'Org unit updated.' : 'Org unit added.');
        setTimeout(function () { self.savedMsg(''); }, 4000);
        _load();
      }).catch(function (err) {
        self.orgSaving(false);
        self.orgFormError((err && err.message) || 'Save failed.');
      });
    };

    // Build tree structure from flat list
    function buildTree(nodes) {
      var map = {};
      nodes.forEach(function (n) {
        n.children = ko.observableArray([]);
        n.expanded = ko.observable((n.levelNo || 1) <= 2);
        map[String(n.orgId)] = n;
      });
      var roots = [];
      nodes.forEach(function (n) {
        var parentKey = n.parentOrgId != null ? String(n.parentOrgId) : null;
        if (parentKey && map[parentKey]) {
          map[parentKey].children.push(n);
        } else {
          roots.push(n);
        }
      });
      return roots;
    }

    self.roots = ko.observableArray([]);

    self.filtered = ko.computed(function () {
      var q = (self.filterText() || '').toUpperCase();
      if (!q) return self.roots();
      // Flatten and filter for search
      var all = self.orgNodes();
      return all.filter(function (n) {
        return (n.orgNameEn || '').toUpperCase().includes(q) ||
               (n.orgCode   || '').toUpperCase().includes(q);
      });
    });

    self.isSearching = ko.computed(function () { return !!(self.filterText() || '').trim(); });

    self.select = function (node) { self.selected(node); };

    self.toggle = function (node) { node.expanded(!node.expanded()); };

    self.typeClass = function (orgType) {
      var map = { DIVISION: 'badge--blue', DEPARTMENT: 'badge--info', SECTION: 'badge--approved', UNIT: 'badge--pending', TEAM: 'badge--settled', AUTHORITY: 'badge--advance_paid' };
      return 'badge ' + (map[orgType] || 'badge--idle');
    };

    function _load() {
      hrService.getOrgTree().then(function (nodes) {
        self.orgNodes(nodes);
        self.roots(buildTree(nodes));
        if (nodes.length) self.selected(nodes[0]);
        self.loading(false);
      }).catch(function (err) {
        self.error((err && err.message) || 'Failed to load org hierarchy.');
        self.loading(false);
      });
    }

    _load();
  }

  return OrgHierarchyViewModel;
});
