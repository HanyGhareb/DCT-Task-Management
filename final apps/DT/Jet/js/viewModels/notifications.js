define(['knockout', 'services/authService', 'services/notificationService'],
function (ko, authService, notificationService) {
  'use strict';

  function NotificationsViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.notifs  = ko.observableArray([]);
    self.loading = ko.observable(true);

    self.typeIcon = function (type) { return notificationService.TYPE_ICON[type] || '&#8505;'; };

    self.markRead = function (notif) {
      if (notif.isRead === 'Y') return;
      notificationService.markRead(notif.notifId).then(function () {
        notif.isRead = 'Y';
        self.notifs.valueHasMutated();
      });
    };

    self.markAllRead = function () {
      notificationService.markAllRead(user.userId).then(function () {
        self.notifs().forEach(function(n){ n.isRead = 'Y'; });
        self.notifs.valueHasMutated();
      });
    };

    self.hasUnread = ko.computed(function () {
      return self.notifs().some(function(n){ return n.isRead === 'N'; });
    });

    self.timeAgo = function (dateStr) {
      var diff = Date.now() - new Date(dateStr).getTime();
      var mins = Math.floor(diff / 60000);
      if (mins < 60) return mins + ' min ago';
      var hrs = Math.floor(mins / 60);
      if (hrs < 24) return hrs + ' hr ago';
      return Math.floor(hrs / 24) + ' days ago';
    };

    notificationService.getForUser(user.userId).then(function (list) {
      self.notifs(list);
      self.loading(false);
    }).catch(function () { self.loading(false); });
  }

  return NotificationsViewModel;
});
