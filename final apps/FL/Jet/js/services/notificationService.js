/**
 * notificationService.js — Freelancers module notifications (ORDS).
 */
define(['services/api'],
function (api) {
  'use strict';

  return {

    getAll: function () {
      return api.get('/notifications/').then(function (d) { return d.items || []; });
    },

    markRead: function (notifId) {
      return api.post('/notifications/' + notifId + '/read');
    },

    markAllRead: function () {
      return api.post('/notifications/mark-all-read');
    },
  };
});
