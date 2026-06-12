define(['knockout', 'services/userService', 'services/roleService', 'shared/i18n', 'shared/toast'],
function (ko, userService, roleService, i18n, toast) {
  'use strict';

  function UsersViewModel() {
    var self = this;
    self.t = i18n.t;

    // ── tri-state list (Phase 3): loading / data / empty / error ────────
    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.users     = ko.observableArray([]);

    // ── server-side query state ──────────────────────────────────────────
    self.searchTerm   = ko.observable('');
    self.filterStatus = ko.observable('ALL');          // ALL | ACTIVE | INACTIVE
    self.offset       = ko.observable(0);
    self.limit        = ko.observable(50);
    self.total        = ko.observable(0);
    self.activeShown  = ko.pureComputed(function () {
      return self.users().filter(function (u) { return u.isActive === 'Y'; }).length;
    });

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      userService.getPage({
        limit:  self.limit(),
        offset: self.offset(),
        search: self.searchTerm().trim() || null,
        status: self.filterStatus() === 'ACTIVE' ? 'Y'
              : self.filterStatus() === 'INACTIVE' ? 'N' : null
      }).then(function (r) {
        self.users(r.items);
        self.total(r.total || r.items.length);
        self.loading(false);
      }).catch(function (err) {
        console.error('[users] load failed:', err && err.message, err);
        self.loading(false);
        self.loadError(true);
      });
    };

    // debounced search → server query (300ms, fires when typing stops)
    self.searchTerm.extend({ rateLimit: { timeout: 300, method: 'notifyWhenChangesStop' } });
    self.searchTerm.subscribe(function () { self.offset(0); self.reload(); });
    self.setStatus = function (s) {
      if (self.filterStatus() === s) return;
      self.filterStatus(s);
      self.offset(0);
      self.reload();
    };

    // ── deactivate flow (Wave 1): immediate + undo toast, no blocking
    // confirm. DELETE /users/:id is a soft deactivate (is_active='N'), so
    // undo is a plain PUT { isActive: 'Y' } — safe under the partial-PUT
    // guard (only sent keys are touched).
    self.navigateToEdit = function (userId) {
      sessionStorage.setItem('editUserId', userId || 'new');
      if (window._jetApp) window._jetApp.navigate('userEdit');
    };
    self.addUser  = function ()     { self.navigateToEdit('new'); };
    self.editUser = function (user) { self.navigateToEdit(user.userId); };

    self.confirmDelete = function (user) {
      userService.remove(user.userId).then(function () {
        self.reload();
        toast.undo(
          i18n.t('users.deactivatedToast', [user.displayName]),
          function () {
            userService.update(user.userId, { isActive: 'Y' }).then(function () {
              toast.success(i18n.t('users.reactivatedToast', [user.displayName]));
              self.reload();
            });
          },
          i18n.t('common.undo'));
      });
    };

    self.getInitials = function (name) {
      var p = (name || '').split(' ');
      return p.length >= 2 ? (p[0][0] + p[p.length - 1][0]).toUpperCase() : (p[0] || '?')[0].toUpperCase();
    };

    // ── bulk actions (Wave 3): multi-select + activate / deactivate /
    //    assign-role, applied via the existing per-user endpoints ─────────
    self.selectedIds = ko.observableArray([]);
    self.isSelected  = function (u) { return self.selectedIds.indexOf(u.userId) >= 0; };
    self.toggleSelect = function (u) {
      if (self.isSelected(u)) self.selectedIds.remove(u.userId);
      else self.selectedIds.push(u.userId);
      return true;
    };
    self.allPageSelected = ko.pureComputed(function () {
      var users = self.users();
      return users.length > 0 && users.every(function (u) {
        return self.selectedIds.indexOf(u.userId) >= 0;
      });
    });
    self.toggleSelectAll = function () {
      if (self.allPageSelected()) self.selectedIds.removeAll();
      else self.selectedIds(self.users().map(function (u) { return u.userId; }));
      return true;
    };
    self.clearSelection = function () { self.selectedIds.removeAll(); };
    self.selectedUsers = ko.pureComputed(function () {
      return self.users().filter(self.isSelected);
    });

    // confirm modal: action = 'ACTIVATE' | 'DEACTIVATE' | 'ASSIGN_ROLE'
    self.bulkAction   = ko.observable(null);
    self.bulkBusy     = ko.observable(false);
    self.bulkRole     = ko.observable('');
    self.roleOptions  = ko.observableArray([]);

    self.openBulk = function (action) {
      self.bulkRole('');
      if (action === 'ASSIGN_ROLE' && !self.roleOptions().length) {
        userService.getRoleOptions().then(self.roleOptions);
      }
      self.bulkAction(action);
    };
    self.closeBulk = function () { self.bulkAction(null); };

    self.runBulk = function () {
      var action = self.bulkAction();
      var users  = self.selectedUsers();
      if (!users.length) { self.closeBulk(); return; }
      if (action === 'ASSIGN_ROLE' && !self.bulkRole()) return;
      self.bulkBusy(true);

      var ops = users.map(function (u) {
        if (action === 'DEACTIVATE') return userService.remove(u.userId);
        if (action === 'ACTIVATE')   return userService.update(u.userId, { isActive: 'Y' });
        // ASSIGN_ROLE: merge into the user's existing role set — the PUT
        // replaces roles wholesale, so read-modify-write per user
        return userService.getById(u.userId).then(function (full) {
          var roles = (full.roles || []).slice();
          if (roles.indexOf(self.bulkRole()) < 0) roles.push(self.bulkRole());
          return userService.update(u.userId, { roles: roles });
        });
      });

      Promise.all(ops).then(function () {
        self.bulkBusy(false);
        self.closeBulk();
        self.clearSelection();
        toast.success(i18n.t('bulk.done', [users.length]));
        self.reload();
      }).catch(function () {
        self.bulkBusy(false);
        self.closeBulk();
        self.reload();   // partial failures: list shows the true state
      });
    };

    self.reload();
  }

  return UsersViewModel;
});
