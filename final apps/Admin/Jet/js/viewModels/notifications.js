define(['knockout', 'services/notificationService'], function (ko, notifService) {
  'use strict';

  function NotificationsViewModel() {
    const self = this;

    self.filter = ko.observable('ALL');
    self.allNotifications = ko.observableArray(notifService.getAll());

    self.filteredNotifications = ko.computed(() => {
      const f = self.filter();
      if (f === 'UNREAD') return self.allNotifications().filter(n => n.isRead === 'N');
      return self.allNotifications();
    });

    self.unreadCount = ko.computed(() => self.allNotifications().filter(n => n.isRead === 'N').length);

    self.markRead = function (notif) {
      notifService.markRead(notif.notifId);
      self.allNotifications(notifService.getAll());
    };

    self.markAllRead = function () {
      notifService.markAllRead();
      self.allNotifications(notifService.getAll());
    };

    self.formatTime = notifService.formatTime.bind(notifService);

    self.getTypeIcon = function (type) {
      return type === 'WARNING' ? '&#9888;' : type === 'APPROVAL' ? '&#9989;' : '&#8505;';
    };
  }

  return NotificationsViewModel;
});
