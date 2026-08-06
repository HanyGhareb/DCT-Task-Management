define(['knockout', 'services/payService', 'shared/i18n'],
function (ko, payService, i18n) {
  'use strict';

  function DashboardViewModel() {
    var self = this;
    self.t = i18n.t;

    self.loading = ko.observable(true);
    self.stats   = ko.observable({ companies: 0, supplierRefs: 0, activeContracts: 0,
                                   draftContracts: 0, expiringContracts: 0, banks: 0, expiring: [] });

    self.regionCollapsed = ko.observable(false);
    self.regionMax       = ko.observable(false);
    self.toggleRegion    = function () { self.regionCollapsed(!self.regionCollapsed()); };
    self.toggleRegionMax = function () { self.regionMax(!self.regionMax()); };

    self.refresh = function () {
      self.loading(true);
      payService.stats().then(function (d) {
        d.expiring = d.expiring || [];
        self.stats(d);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };

    self.go = function (route) { if (window._jetApp) window._jetApp.navigate(route); };
    self.openContract = function (row) {
      if (window._jetApp) window._jetApp.navigate('contracts', { openContractId: row.contractId });
    };

    self.refresh();
  }

  return DashboardViewModel;
});
