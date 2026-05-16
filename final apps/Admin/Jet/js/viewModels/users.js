define(['knockout', 'services/userService'], function (ko, userService) {
  'use strict';

  function UsersViewModel() {
    const self = this;

    self.allUsers   = ko.observableArray(userService.getAll());
    self.searchTerm = ko.observable('');
    self.filterStatus = ko.observable('ALL');  // ALL | ACTIVE | INACTIVE

    // Instant client-side filter — no server round-trip
    self.filteredUsers = ko.computed(() => {
      let data = self.allUsers();
      const q = self.searchTerm().toLowerCase().trim();
      if (q) {
        data = data.filter(u =>
          u.username.toLowerCase().includes(q) ||
          u.displayName.toLowerCase().includes(q) ||
          (u.email || '').toLowerCase().includes(q) ||
          (u.orgName || '').toLowerCase().includes(q) ||
          (u.employeeNumber || '').toLowerCase().includes(q)
        );
      }
      if (self.filterStatus() === 'ACTIVE')   data = data.filter(u => u.isActive === 'Y');
      if (self.filterStatus() === 'INACTIVE') data = data.filter(u => u.isActive !== 'Y');
      return data;
    });

    self.totalCount  = ko.computed(() => self.allUsers().length);
    self.activeCount = ko.computed(() => self.allUsers().filter(u => u.isActive === 'Y').length);

    self.editUserId = ko.observable(null);
    self.showDeleteConfirm = ko.observable(false);
    self.deleteTarget = ko.observable(null);

    // Navigate to edit form
    self.navigateToEdit = function (userId) {
      // Store in sessionStorage for the edit VM to pick up
      sessionStorage.setItem('editUserId', userId || 'new');
      // Trigger route change via app root
      if (window._jetApp) window._jetApp.navigate('userEdit');
    };

    self.addUser = function () { self.navigateToEdit('new'); };
    self.editUser = function (user) { self.navigateToEdit(user.userId); };

    self.confirmDelete = function (user) {
      self.deleteTarget(user);
      self.showDeleteConfirm(true);
    };
    self.cancelDelete = function () { self.showDeleteConfirm(false); self.deleteTarget(null); };
    self.doDelete = function () {
      const target = self.deleteTarget();
      if (target) {
        userService.remove(target.userId);
        self.allUsers(userService.getAll());
      }
      self.cancelDelete();
    };

    self.getInitials = function (name) {
      const p = (name || '').split(' ');
      return p.length >= 2 ? (p[0][0] + p[p.length - 1][0]).toUpperCase() : (p[0] || '?')[0].toUpperCase();
    };

    self.formatRoles = function (roles) {
      return (roles || []).join(', ');
    };
  }

  return UsersViewModel;
});
