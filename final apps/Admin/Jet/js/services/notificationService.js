/**
 * notificationService.js
 * ORDS: GET /notifications/          — list for current user
 *       PUT /notifications/:id/read  — mark one notification read
 *
 * All methods return Promises.
 */
define(['services/api'], function (api) {
  'use strict';

  return {

    getAll: function () {
      return api.get('/notifications/').then(function (r) {
        return (r.items || []).sort(function (a, b) {
          return new Date(b.createdAt) - new Date(a.createdAt);
        });
      });
    },

    getUnread: function () {
      return this.getAll().then(function (items) {
        return items.filter(function (n) { return n.isRead === 'N'; });
      });
    },

    getUnreadCount: function () {
      return this.getAll().then(function (items) {
        return items.filter(function (n) { return n.isRead === 'N'; }).length;
      });
    },

    markRead: function (notifId) {
      return api.put('/notifications/' + notifId + '/read', {});
    },

    /* Pass the current items array so we know which IDs to mark */
    markAllRead: function (items) {
      var unread = (items || []).filter(function (n) { return n.isRead === 'N'; });
      if (!unread.length) return Promise.resolve();
      return Promise.all(unread.map(function (n) {
        return api.put('/notifications/' + n.notifId + '/read', {});
      }));
    },

    formatTime: function (isoStr) {
      var d = new Date(isoStr);
      var now = new Date();
      var diffMs = now - d;
      var diffHours = diffMs / 3600000;
      if (diffHours < 1)  return Math.round(diffMs / 60000) + ' min ago';
      if (diffHours < 24) return Math.round(diffHours) + ' hours ago';
      var diffDays = Math.floor(diffHours / 24);
      if (diffDays < 7)   return diffDays + ' days ago';
      return d.toLocaleDateString('en-GB');
    },
  };
});
