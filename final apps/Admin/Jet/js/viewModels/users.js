define(['knockout', 'services/userService'], function (ko, userService) {
  'use strict';

  function UsersViewModel() {
    var self = this;

    self.loading      = ko.observable(true);
    self.allUsers     = ko.observableArray([]);
    self.searchTerm   = ko.observable('');
    self.filterStatus = ko.observable('ALL');

    self.filteredUsers = ko.computed(function () {
      var data = self.allUsers();
      var q = self.searchTerm().toLowerCase().trim();
      if (q) {
        data = data.filter(function (u) {
          return u.username.toLowerCase().includes(q) ||
                 u.displayName.toLowerCase().includes(q) ||
                 (u.email || '').toLowerCase().includes(q) ||
                 (u.orgName || '').toLowerCase().includes(q) ||
                 (u.employeeNumber || '').toLowerCase().includes(q);
        });
      }
      if (self.filterStatus() === 'ACTIVE')   data = data.filter(function (u) { return u.isActive === 'Y'; });
      if (self.filterStatus() === 'INACTIVE') data = data.filter(function (u) { return u.isActive !== 'Y'; });
      return data;
    });

    self.totalCount  = ko.computed(function () { return self.allUsers().length; });
    self.activeCount = ko.computed(function () {
      return self.allUsers().filter(function (u) { return u.isActive === 'Y'; }).length;
    });

    self.showDeleteConfirm = ko.observable(false);
    self.deleteTarget      = ko.observable(null);

    self.navigateToEdit = function (userId) {
      sessionStorage.setItem('editUserId', userId || 'new');
      if (window._jetApp) window._jetApp.navigate('userEdit');
    };

    self.addUser  = function ()     { self.navigateToEdit('new'); };
    self.editUser = function (user) { self.navigateToEdit(user.userId); };

    self.confirmDelete = function (user) {
      self.deleteTarget(user);
      self.showDeleteConfirm(true);
    };
    self.cancelDelete = function () { self.showDeleteConfirm(false); self.deleteTarget(null); };
    self.doDelete = function () {
      var target = self.deleteTarget();
      if (target) {
        userService.remove(target.userId).then(function () {
          self.allUsers(self.allUsers().filter(function (u) { return u.userId !== target.userId; }));
        });
      }
      self.cancelDelete();
    };

    self.getInitials = function (name) {
      var p = (name || '').split(' ');
      return p.length >= 2 ? (p[0][0] + p[p.length - 1][0]).toUpperCase() : (p[0] || '?')[0].toUpperCase();
    };

    self.formatRoles = function (roles) {
      return (roles || []).join(', ');
    };

    // Load data
    userService.getAll().then(function (data) {
      self.allUsers(data);
      self.loading(false);
    }).catch(function () {
      self.loading(false);
    });
  }

  return UsersViewModel;
});
