define(['knockout', 'shared/i18n', 'services/notificationService'],
function (ko, i18n, notifService) {
  'use strict';

  function NotificationsViewModel() {
    var self = this;

    self.t       = i18n.t;
    self.lang    = i18n.lang;
    self.notifs  = ko.observableArray([]);
    self.loading = ko.observable(true);

    self.unread = ko.computed(function () {
      return self.notifs().filter(function (n) { return n.isRead === 'N'; }).length;
    });

    self.markRead = function (notif) {
      notifService.markRead(notif.notifId || notif.notif_id).then(function () {
        notif.isRead = 'Y';
        self.notifs.valueHasMutated();
      });
    };

    self.markAll = function () {
      notifService.markAllRead().then(function () {
        self.notifs().forEach(function (n) { n.isRead = 'Y'; });
        self.notifs.valueHasMutated();
      });
    };

    self.typeClass = function (t) {
      var map = { KPI_APPROVED: 'badge badge--approved', KPI_RETURNED: 'badge badge--rejected',
                  KPI_REMINDER: 'badge badge--warning' };
      return map[t] || 'badge badge--idle';
    };

    notifService.getAll().then(function (list) {
      self.notifs(list);
      self.loading(false);
    }).catch(function () { self.loading(false); });
  }

  return NotificationsViewModel;
});
