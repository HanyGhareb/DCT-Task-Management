define(['knockout', 'services/authService', 'services/notificationService'],
function (ko, authService, notifService) {
  'use strict';

  function NotificationsViewModel() {
    var self = this;

    var user = authService.getCurrentUser();
    self.notifs   = ko.observableArray([]);
    self.loading  = ko.observable(true);

    self.fmtDate = function (d) {
      return d ? new Date(d).toLocaleDateString('en-GB', { day:'2-digit', month:'short', year:'numeric', hour:'2-digit', minute:'2-digit' }) : '';
    };

    self.typeIcon = function (t) { return notifService.TYPE_ICON[t] || '&#128276;'; };

    self.markRead = function (n) {
      if (n.isRead === 'Y') return;
      notifService.markRead(n.notifId).then(function () {
        n.isRead = 'Y';
        self.notifs.valueHasMutated();
      });
    };

    self.markAllRead = function () {
      notifService.markAllRead(user.userId).then(function () { _load(); });
    };

    function _load() {
      notifService.getForUser(user.userId).then(function (list) {
        self.notifs(list);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    }

    _load();
  }

  return NotificationsViewModel;
});
