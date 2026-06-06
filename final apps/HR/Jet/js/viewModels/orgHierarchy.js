define(['knockout', 'services/hrService'],
function (ko, hrService) {
  'use strict';

  function OrgHierarchyViewModel() {
    var self = this;

    self.orgNodes   = ko.observableArray([]);
    self.selected   = ko.observable(null);
    self.loading    = ko.observable(true);
    self.error      = ko.observable('');
    self.filterText = ko.observable('');

    // Build tree structure from flat list
    function buildTree(nodes) {
      var map = {};
      nodes.forEach(function (n) {
        n.children = ko.observableArray([]);
        n.expanded = ko.observable(n.levelNo <= 1);
        map[n.orgId] = n;
      });
      var roots = [];
      nodes.forEach(function (n) {
        if (n.parentOrgId && map[n.parentOrgId]) {
          map[n.parentOrgId].children.push(n);
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
