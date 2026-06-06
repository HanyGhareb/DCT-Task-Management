define(['knockout', 'services/authService', 'services/hrService'],
function (ko, authService, hrService) {
  'use strict';

  function DashboardViewModel() {
    var self = this;

    self.user     = authService.getCurrentUser();
    self.isAdmin  = authService.isHrAdmin();
    self.isMgr    = authService.isHrManager();

    self.greeting = ko.computed(function () {
      var h = new Date().getHours();
      return h < 12 ? 'Good morning' : h < 17 ? 'Good afternoon' : 'Good evening';
    });
    self.todayDate = new Date().toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });

    self.stats = {
      totalEmployees:  ko.observable(0),
      totalPositions:  ko.observable(0),
      filledPositions: ko.observable(0),
      vacancies:       ko.observable(0),
      expiringDocs:    ko.observable(0),
    };
    self.fillRate = ko.computed(function () {
      var total = self.stats.totalPositions();
      if (!total) return 0;
      return Math.round((self.stats.filledPositions() / total) * 100);
    });

    self.headcountByOrg = ko.observableArray([]);
    self.loading        = ko.observable(true);

    self.goEmployees  = function () { if (window._hrApp) window._hrApp.navigate('employees'); };
    self.goPositions  = function () { if (window._hrApp) window._hrApp.navigate('positions'); };
    self.goDocuments  = function () { if (window._hrApp) window._hrApp.navigate('documents'); };
    self.goOrgChart   = function () { if (window._hrApp) window._hrApp.navigate('orgHierarchy'); };

    function _load() {
      Promise.all([
        hrService.getDashboardStats(),
        hrService.getHeadcountSummary(),
      ]).then(function (results) {
        var stats = results[0];
        self.stats.totalEmployees(stats.totalEmployees || 0);
        self.stats.totalPositions(stats.totalPositions || 0);
        self.stats.filledPositions(stats.filledPositions || 0);
        self.stats.vacancies(stats.vacancies || 0);
        self.stats.expiringDocs(stats.expiringDocs || 0);
        self.headcountByOrg(results[1] || []);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    _load();
  }

  return DashboardViewModel;
});
