define(['knockout', 'services/authService', 'services/settlementService'],
function (ko, authService, settlementService) {
  'use strict';

  function MySettlementsViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.settlements  = ko.observableArray([]);
    self.loading      = ko.observable(true);
    self.searchText   = ko.observable('');
    self.statusFilter = ko.observable('');

    self.filtered = ko.computed(function () {
      var q  = self.searchText().toLowerCase();
      var sf = self.statusFilter();
      return self.settlements().filter(function (s) {
        var matchQ  = !q || s.settleNumber.toLowerCase().includes(q);
        var matchSt = !sf || s.status === sf;
        return matchQ && matchSt;
      });
    });

    self.openDetail = function (settle) {
      if (window._dtApp) window._dtApp.navigate('settlementForm', { settleId: settle.settleId });
    };

    self.fmt = function (n) { return parseFloat(n || 0).toLocaleString('en-AE', { minimumFractionDigits: 2 }); };

    settlementService.getMySettlements(user.userId).then(function (list) {
      self.settlements(list);
      self.loading(false);
    }).catch(function () { self.loading(false); });
  }

  return MySettlementsViewModel;
});
