define(['knockout', 'services/authService', 'services/dtService'],
function (ko, authService, dtService) {
  'use strict';

  function AllRequestsViewModel() {
    var self = this;

    self.requests     = ko.observableArray([]);
    self.loading      = ko.observable(true);
    self.searchText   = ko.observable('');
    self.statusFilter = ko.observable('');

    self.filtered = ko.computed(function () {
      var q  = self.searchText().toLowerCase();
      var sf = self.statusFilter();
      return self.requests().filter(function (r) {
        var matchQ  = !q || r.reqNumber.toLowerCase().includes(q) || r.employeeName.toLowerCase().includes(q) || (r.travelPurpose||'').toLowerCase().includes(q);
        var matchSt = !sf || r.status === sf;
        return matchQ && matchSt;
      });
    });

    self.openDetail = function (req) {
      if (window._dtApp) window._dtApp.navigate('requestDetail', { reqId: req.reqId });
    };

    self.fmt = function (n) { return parseFloat(n || 0).toLocaleString('en-AE', { minimumFractionDigits: 2 }); };

    dtService.getAllRequests({}).then(function (list) {
      self.requests(list);
      self.loading(false);
    }).catch(function () { self.loading(false); });
  }

  return AllRequestsViewModel;
});
