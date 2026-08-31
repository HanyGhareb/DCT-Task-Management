define(['knockout', 'services/delegationService'],
function (ko, delegationService) {
  'use strict';

  function DelegationsViewModel() {
    var self = this;

    self.loading      = ko.observable(true);
    self.loadError    = ko.observable(false);
    self.items        = ko.observableArray([]);
    self.statusFilter = ko.observable('');
    self.busy         = ko.observable(false);

    self.filtered = ko.computed(function () {
      var st = self.statusFilter();
      return self.items().filter(function (d) { return !st || d.status === st; });
    });

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      delegationService.getAll(false).then(function (items) {
        self.items(items);
        self.loading(false);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };
    self.reload();

    self.cancel = function (d) {
      self.busy(true);
      delegationService.cancel(d.delegationId).then(function () {
        self.busy(false);
        self.reload();
      }).catch(function () { self.busy(false); });
    };

    self.scopeLabel = function (d) {
      if (d.scope === 'ALL_ROLES') return 'All roles';
      if (d.scope === 'MODULE')    return 'Module: ' + (d.moduleName || d.moduleCode);
      return 'Role: ' + (d.roleName || d.roleCode);
    };
    self.statusBadge = function (s) {
      var map = { ACTIVE: 'badge--approved', CANCELLED: 'badge--idle', EXPIRED: 'badge--idle' };
      return 'badge ' + (map[s] || 'badge--pending');
    };
  }

  return DelegationsViewModel;
});
