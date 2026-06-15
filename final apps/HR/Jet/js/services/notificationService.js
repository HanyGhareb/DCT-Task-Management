/**
 * notificationService.js — HR module notifications (mock + ORDS).
 *
 * Notifications are platform-wide (DCT_NOTIFY) and served by the Admin (/dct)
 * module — hr.rest defines no notification handlers — so live calls target the
 * auth base (`/dct`), not the HR module base. dct exposes only
 * GET /notifications/ and PUT /notifications/:id/read (no mark-all-read), so
 * markAllRead PUTs each unread item.
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  var AUTH = { base: 'auth' };
  var NOTIF_KEY = 'ifinance_hr_notifs';

  function loadNotifs() {
    try {
      var raw = localStorage.getItem(NOTIF_KEY);
      return raw ? JSON.parse(raw) : JSON.parse(JSON.stringify(mockData.NOTIFICATIONS));
    } catch (e) { return JSON.parse(JSON.stringify(mockData.NOTIFICATIONS)); }
  }
  function saveNotifs(list) { localStorage.setItem(NOTIF_KEY, JSON.stringify(list)); }

  return {

    getAll: function (userId) {
      if (config.apiBase) return api.get('/notifications/', AUTH).then(function (d) { return d.items || []; });
      var list = loadNotifs().filter(function (n) { return n.targetUserId === userId; });
      return Promise.resolve(list.sort(function (a, b) { return b.notifId - a.notifId; }));
    },

    getUnreadCount: function (userId) {
      if (config.apiBase) return 0; // refreshed async separately
      return loadNotifs().filter(function (n) { return n.targetUserId === userId && n.isRead === 'N'; }).length;
    },

    markRead: function (notifId) {
      if (config.apiBase) return api.put('/notifications/' + notifId + '/read', {}, AUTH);
      var list = loadNotifs();
      var n = list.find(function (x) { return x.notifId === notifId; });
      if (n) { n.isRead = 'Y'; saveNotifs(list); }
      return Promise.resolve();
    },

    markAllRead: function (userId) {
      if (config.apiBase) {
        return api.get('/notifications/', AUTH).then(function (d) {
          var unread = (d.items || []).filter(function (n) { return n.isRead === 'N'; });
          if (!unread.length) return Promise.resolve();
          return Promise.all(unread.map(function (n) {
            return api.put('/notifications/' + (n.notifId || n.notif_id) + '/read', {}, AUTH);
          }));
        });
      }
      var list = loadNotifs();
      list.filter(function (n) { return n.targetUserId === userId; }).forEach(function (n) { n.isRead = 'Y'; });
      saveNotifs(list);
      return Promise.resolve();
    },

    // Returns count of documents expiring within 30 days (for nav badge)
    getExpiringDocCount: function () {
      if (config.apiBase) {
        return api.get('/reports/expiry-alerts/?days=30').then(function (d) { return (d.items || []).length; });
      }
      var docs = mockData.DOCUMENTS.filter(function (d) { return d.daysUntilExpiry <= 30; });
      return Promise.resolve(docs.length);
    },

    reset: function () { localStorage.removeItem(NOTIF_KEY); },
  };
});
