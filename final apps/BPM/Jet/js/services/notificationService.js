/**
 * notificationService.js — Fusion BPM notifications.
 * Notifications are platform-wide (DCT_NOTIFY) and served by the Admin (/dct)
 * module, so every call targets the auth base, not the KPI module base.
 */
define(['services/api'],
function (api) {
  'use strict';

  var AUTH = { base: 'auth' };

  var svc = {
    getAll: function () {
      return api.get('/notifications/', AUTH).then(function (d) { return d.items || []; });
    },
    markRead: function (notifId) {
      return api.put('/notifications/' + notifId + '/read', {}, AUTH);
    },
    markAllRead: function () {
      return svc.getAll().then(function (items) {
        var unread = items.filter(function (n) { return n.isRead === 'N'; });
        if (!unread.length) return Promise.resolve();
        return Promise.all(unread.map(function (n) {
          return api.put('/notifications/' + (n.notifId || n.notif_id) + '/read', {}, AUTH);
        }));
      });
    }
  };
  return svc;
});
