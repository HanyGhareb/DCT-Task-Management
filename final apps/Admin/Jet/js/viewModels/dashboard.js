define(['knockout', 'services/authService', 'services/moduleService', 'services/auditService', 'services/userService'],
function (ko, authService, moduleService, auditService, userService) {
  'use strict';

  function DashboardViewModel() {
    const self = this;

    const user = authService.getCurrentUser();
    self.user  = user;
    self.greeting = ko.computed(() => {
      const h = new Date().getHours();
      return h < 12 ? 'Good morning' : h < 17 ? 'Good afternoon' : 'Good evening';
    });
    self.todayDate = new Date().toLocaleDateString('en-GB', { weekday:'long', day:'numeric', month:'long', year:'numeric' });

    // Platform stats
    const stats = auditService.getPlatformStats();
    self.stats = stats;

    // Module cards by category
    const categories = moduleService.getCategories();
    const allMods    = moduleService.getAccessibleForUser(user);

    self.categoryGroups = categories
      .map(cat => ({
        id: cat.id, label: cat.label, icon: cat.icon,
        modules: allMods.filter(m => m.category === cat.id),
      }))
      .filter(g => g.modules.length > 0);

    self.announcement = {
      show: true,
      type: 'warning',
      title: 'Scheduled Maintenance',
      body:  'System maintenance on Saturday 18 May at 02:00 AM GST. All applications will be unavailable for approximately 2 hours.',
    };

    // Dev tools
    self.resetMsg = ko.observable('');

    self.resetUsersToDefault = function () {
      if (!confirm('Reset ALL users to default mock data?\n\nThis will undo any changes made to users (passwords, active status, roles, etc.) and reload the page.')) return;
      userService.reset();
      authService.logout();
      self.resetMsg('Users reset. Reloading…');
      setTimeout(function () { location.reload(); }, 800);
    };
  }

  return DashboardViewModel;
});
