define(['knockout', 'services/flService'], function (ko, flService) {
  'use strict';

  function FreelancersViewModel() {
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
      flService.getFreelancers({
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

    self.openItem = function (item) {
      sessionStorage.setItem('flFreelancerId', String(item.freelancerId));
      if (window._jetApp) window._jetApp.navigate('freelancerDetail');
    };

    self.badgeFor = function (s) {
      return { ACTIVE: 'badge--approved', INACTIVE: 'badge--draft', BLACKLISTED: 'badge--blacklisted' }[s] || 'badge--draft';
    };
  }

  return FreelancersViewModel;
});
