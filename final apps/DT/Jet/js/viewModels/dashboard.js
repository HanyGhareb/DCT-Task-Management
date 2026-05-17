define(['knockout', 'services/authService', 'services/dtService', 'services/settingService'],
function (ko, authService, dtService, settingService) {
  'use strict';

  function DashboardViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.user = user;

    self.greeting = ko.computed(function () {
      var h = new Date().getHours();
      return h < 12 ? 'Good morning' : h < 17 ? 'Good afternoon' : 'Good evening';
    });
    self.todayDate = new Date().toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });

    self.stats = {
      activeRequests: ko.observable(0),
      draftRequests:  ko.observable(0),
      needSettlement: ko.observable(0),
      totalAdvance:   ko.observable('0.00'),
    };

    self.recentRequests = ko.observableArray([]);
    self.loading        = ko.observable(true);

    self.isApprover  = authService.isApprover();
    self.isDtFinance = authService.isDtFinance();
    self.isDtAdmin   = authService.isDtAdmin();

    self.newRequest    = function () { if (window._dtApp) window._dtApp.navigate('requestForm'); };
    self.viewRequests  = function () { if (window._dtApp) window._dtApp.navigate('myRequests'); };
    self.viewApprovals = function () { if (window._dtApp) window._dtApp.navigate('approvals'); };
    self.viewDisburse  = function () { if (window._dtApp) window._dtApp.navigate('disbursementQueue'); };

    self.openRequest = function (req) {
      if (window._dtApp) window._dtApp.navigate('requestDetail', { reqId: req.reqId });
    };

    function _load() {
      dtService.getDashboardStats(user.userId).then(function (stats) {
        self.stats.activeRequests(stats.activeRequests);
        self.stats.draftRequests(stats.draftRequests);
        self.stats.needSettlement(stats.needSettlement);
        self.stats.totalAdvance(parseFloat(stats.totalAdvance || 0).toFixed(2));
        self.recentRequests(stats.recentRequests || []);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    _load();
  }

  return DashboardViewModel;
});
