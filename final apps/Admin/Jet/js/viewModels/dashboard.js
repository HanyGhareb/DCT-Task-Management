define(['knockout', 'services/authService', 'services/moduleService', 'services/auditService'],
function (ko, authService, moduleService, auditService) {
  'use strict';

  function DashboardViewModel() {
    var self = this;

    var user  = authService.getCurrentUser();
    self.user = user;

    self.greeting = ko.computed(function () {
      var h = new Date().getHours();
      return h < 12 ? 'Good morning' : h < 17 ? 'Good afternoon' : 'Good evening';
    });
    self.todayDate = new Date().toLocaleDateString('en-GB', {
      weekday: 'long', day: 'numeric', month: 'long', year: 'numeric',
    });

    /* Platform stats — loaded async */
    self.stats = ko.observable({
      totalUsers: 0, activeUsers: 0, totalRoles: 0,
      activeModules: 0, pendingApprovals: 0, activeSessions: 0,
    });
    auditService.getPlatformStats()
      .then(function (s) { self.stats(s); })
      .catch(function () {});

    /* Module cards — loaded async */
    self.categoryGroups = ko.observableArray([]);
    var categories = moduleService.getCategories();
    moduleService.getAccessibleForUser().then(function (allMods) {
      var groups = categories
        .map(function (cat) {
          return {
            id: cat.id, label: cat.label, icon: cat.icon,
            modules: allMods.filter(function (m) { return m.category === cat.id; }),
          };
        })
        .filter(function (g) { return g.modules.length > 0; });
      self.categoryGroups(groups);
    }).catch(function () {});

    self.announcement = {
      show:  true,
      type:  'warning',
      title: 'Scheduled Maintenance',
      body:  'System maintenance on Saturday 18 May at 02:00 AM GST. All applications will be unavailable for approximately 2 hours.',
    };

    self.resetMsg = ko.observable('');
    self.resetUsersToDefault = function () {
      alert('User reset is not available in live ORDS mode. Manage users via the Users page or APEX Admin.');
    };
  }

  return DashboardViewModel;
});
