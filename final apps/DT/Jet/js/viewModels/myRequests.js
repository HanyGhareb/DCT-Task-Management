define(['knockout', 'services/authService', 'services/dtService'],
function (ko, authService, dtService) {
  'use strict';

  function MyRequestsViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.requests    = ko.observableArray([]);
    self.loading     = ko.observable(true);
    self.searchText  = ko.observable('');
    self.statusFilter = ko.observable('');

    self.filtered = ko.computed(function () {
      var q = self.searchText().toLowerCase();
      var sf = self.statusFilter();
      return self.requests().filter(function (r) {
        var matchQ  = !q || r.reqNumber.toLowerCase().includes(q) || (r.travelPurpose||'').toLowerCase().includes(q);
        var matchSt = !sf || r.status === sf;
        return matchQ && matchSt;
      });
    });

    self.openDetail = function (req) {
      if (window._dtApp) window._dtApp.navigate('requestDetail', { reqId: req.reqId });
    };

    self.newRequest = function () {
      if (window._dtApp) window._dtApp.navigate('requestForm');
    };

    dtService.getMyRequests(user.userId).then(function (list) {
      self.requests(list);
      self.loading(false);
    }).catch(function () { self.loading(false); });
  }

  return MyRequestsViewModel;
});
