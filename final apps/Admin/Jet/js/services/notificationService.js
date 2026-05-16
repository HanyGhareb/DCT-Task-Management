/**
 * notificationService.js
 * Production: GET /ords/prod/dct/notifications/
 */
define(['mockData'], function (mockData) {
  'use strict';

  let notifications = JSON.parse(JSON.stringify(mockData.NOTIFICATIONS));

  return {
    getAll: function () { return notifications.slice().sort((a, b) => b.notifId - a.notifId); },
    getUnread: function () { return notifications.filter(n => n.isRead === 'N'); },
    getUnreadCount: function () { return notifications.filter(n => n.isRead === 'N').length; },

    markRead: function (notifId) {
      const n = notifications.find(n => n.notifId === Number(notifId));
      if (n) n.isRead = 'Y';
    },
    markAllRead: function () { notifications.forEach(n => { n.isRead = 'Y'; }); },

    formatTime: function (isoStr) {
      const d = new Date(isoStr);
      const now = new Date();
      const diffMs = now - d;
      const diffHours = diffMs / 3600000;
      if (diffHours < 1)  return Math.round(diffMs / 60000) + ' min ago';
      if (diffHours < 24) return Math.round(diffHours) + ' hours ago';
      const diffDays = Math.floor(diffHours / 24);
      if (diffDays < 7)   return diffDays + ' days ago';
      return d.toLocaleDateString('en-GB');
    },
  };
});
