define(['knockout', 'services/authService', 'services/notificationService'],
function (ko, authService, notifService) {
  'use strict';

  function NotificationsViewModel() {
    var self = this;

    var user     = authService.getCurrentUser();
    self.notifs  = ko.observableArray([]);
    self.loading = ko.observable(true);
    self.error   = ko.observable('');

    self.unread = ko.computed(function () { return self.notifs().filter(function (n) { return n.isRead === 'N'; }).length; });

    self.markRead = function (notif) {
      notifService.markRead(notif.notifId || notif.notif_id).then(function () {
        notif.isRead = 'Y';
        self.notifs.valueHasMutated();
      });
    };

    self.markAll = function () {
      notifService.markAllRead(user && user.userId).then(function () {
        self.notifs().forEach(function (n) { n.isRead = 'Y'; });
        self.notifs.valueHasMutated();
      });
    };

    self.typeClass = function (t) {
      var map = { DOC_EXPIRY: 'badge--warning', CONTRACT: 'badge--info', ASSIGNMENT: 'badge--approved', ALERT: 'badge--rejected' };
      return 'badge ' + (map[t] || 'badge--idle');
    };

    function _load() {
      notifService.getAll(user && user.userId).then(function (list) {
        self.notifs(list);
        self.loading(false);
      }).catch(function (err) {
        self.error((err && err.message) || 'Failed to load notifications.');
        self.loading(false);
      });
    }

    _load();
  }

  return NotificationsViewModel;
});
