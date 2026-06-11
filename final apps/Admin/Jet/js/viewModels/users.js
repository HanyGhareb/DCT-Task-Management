define(['knockout', 'services/userService', 'shared/i18n', 'shared/toast'],
function (ko, userService, i18n, toast) {
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

    // ── delete flow ──────────────────────────────────────────────────────
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
          toast.success(i18n.t('toast.deleted'));
          self.reload();
        });
      }
      self.cancelDelete();
    };

    self.getInitials = function (name) {
      var p = (name || '').split(' ');
      return p.length >= 2 ? (p[0][0] + p[p.length - 1][0]).toUpperCase() : (p[0] || '?')[0].toUpperCase();
    };

    self.reload();
  }

  return UsersViewModel;
});
