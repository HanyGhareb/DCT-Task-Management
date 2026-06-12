define(['knockout', 'services/flService'], function (ko, flService) {
  'use strict';

  function DocumentsViewModel() {
    var self = this;

    self.loading      = ko.observable(true);
    self.loadError    = ko.observable(false);
    self.items        = ko.observableArray([]);
    self.expiryFilter = ko.observable('');
    self.offset       = ko.observable(0);
    self.limit        = ko.observable(50);
    self.total        = ko.observable(0);

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      flService.getDocuments({
        limit: self.limit(), offset: self.offset(),
        expiryStatus: self.expiryFilter() || null
      }).then(function (r) {
        self.items(r.items || []);
        self.total(r.total || 0);
        self.loading(false);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };
    self.reload();
    self.expiryFilter.subscribe(function () { self.offset(0); self.reload(); });

    self.openFreelancer = function (item) {
      sessionStorage.setItem('flFreelancerId', String(item.freelancerId));
      if (window._jetApp) window._jetApp.navigate('freelancerDetail');
    };

    self.expChip = function (s) {
      return { VALID: 'exp-chip--valid', EXPIRING_SOON: 'exp-chip--soon', EXPIRED: 'exp-chip--expired' }[s] || 'exp-chip--valid';
    };
  }

  return DocumentsViewModel;
});
