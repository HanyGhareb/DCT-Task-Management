define(['knockout', 'services/flService'], function (ko, flService) {
  'use strict';

  function RegistrationsViewModel() {
    var self = this;

    self.loading      = ko.observable(true);
    self.loadError    = ko.observable(false);
    self.items        = ko.observableArray([]);
    self.searchBy     = ko.observable('');
    self.statusFilter = ko.observable('');
    self.offset       = ko.observable(0);
    self.limit        = ko.observable(50);
    self.total        = ko.observable(0);

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      flService.getRegistrations({
        limit: self.limit(), offset: self.offset(),
        search: self.searchBy().trim() || null,
        status: self.statusFilter() || null
      }).then(function (r) {
        self.items(r.items || []);
        self.total(r.total || 0);
        self.loading(false);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };
    self.reload();

    self.searchBy.extend({ rateLimit: { timeout: 300, method: 'notifyWhenChangesStop' } });
    self.searchBy.subscribe(function () { self.offset(0); self.reload(); });
    self.statusFilter.subscribe(function () { self.offset(0); self.reload(); });

    self.openNew  = function () {
      sessionStorage.setItem('flEditRegId', 'new');
      if (window._jetApp) window._jetApp.navigate('registrationEdit');
    };
    self.openItem = function (item) {
      sessionStorage.setItem('flEditRegId', String(item.registrationId));
      if (window._jetApp) window._jetApp.navigate('registrationEdit');
    };

    self.badgeFor = function (s) {
      return { DRAFT: 'badge--draft', SUBMITTED: 'badge--submitted', APPROVED: 'badge--approved',
               REJECTED: 'badge--rejected', RETURNED: 'badge--returned' }[s] || 'badge--draft';
    };
  }

  return RegistrationsViewModel;
});
