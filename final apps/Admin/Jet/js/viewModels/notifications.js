define(['knockout', 'services/notificationService'], function (ko, notifService) {
  'use strict';

  function NotificationsViewModel() {
    var self = this;

    self.loading          = ko.observable(true);
    self.filter           = ko.observable('ALL');
    self.allNotifications = ko.observableArray([]);

    function loadNotifications() {
      notifService.getAll().then(function (items) {
        self.allNotifications(items);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }
    loadNotifications();

    self.filteredNotifications = ko.computed(function () {
      if (self.filter() === 'UNREAD') {
        return self.allNotifications().filter(function (n) { return n.isRead === 'N'; });
      }
      return self.allNotifications();
    });

    self.unreadCount = ko.computed(function () {
      return self.allNotifications().filter(function (n) { return n.isRead === 'N'; }).length;
    });

    self.markRead = function (notif) {
      notifService.markRead(notif.notifId).then(function () { loadNotifications(); });
    };

    self.markAllRead = function () {
      notifService.markAllRead(self.allNotifications()).then(function () { loadNotifications(); });
    };

    self.formatTime = notifService.formatTime.bind(notifService);

    self.getTypeIcon = function (type) {
      return type === 'WARNING' ? '&#9888;' : type === 'APPROVAL' ? '&#9989;' : '&#8505;';
    };
  }

  return NotificationsViewModel;
});
