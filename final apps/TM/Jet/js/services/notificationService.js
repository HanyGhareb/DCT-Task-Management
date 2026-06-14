/**
 * notificationService.js — Task Management notifications.
 * Notifications are platform-wide (DCT_NOTIFY) and served by the Admin (/dct)
 * module, so every call targets the auth base, not the TM module base.
 */
define(['services/api'],
function (api) {
  'use strict';

  var AUTH = { base: 'auth' };

  return {
    getAll: function () {
      return api.get('/notifications/', AUTH).then(function (d) { return d.items || []; });
    },
    markRead: function (notifId) {
      return api.post('/notifications/' + notifId + '/read', undefined, AUTH);
    },
    markAllRead: function () {
      return api.post('/notifications/mark-all-read', undefined, AUTH);
    }
  };
});
