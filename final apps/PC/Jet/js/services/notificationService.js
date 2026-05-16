/**
 * notificationService.js — In-app notifications for Petty Cash.
 */
define(['services/config', 'services/api', 'mockData'],
function (config, api, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_pc_notifs';

  function loadNotifs() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return JSON.parse(JSON.stringify(mockData.NOTIFICATIONS));
  }
  function saveNotifs(list) { localStorage.setItem(STORE_KEY, JSON.stringify(list)); }

  return {

    getForUser: function (userId) {
      if (config.apiBase) return api.get('/notifications');
      var list = loadNotifs().filter(function(n){ return n.targetUserId === userId; });
      return Promise.resolve(list.sort(function(a,b){ return b.notifId - a.notifId; }));
    },

    markRead: function (notifId) {
      if (config.apiBase) return api.post('/notifications/' + notifId + '/read');
      var list = loadNotifs();
      var idx  = list.findIndex(function(n){ return n.notifId === notifId; });
      if (idx !== -1) list[idx].isRead = 'Y';
      saveNotifs(list);
      return Promise.resolve(true);
    },

    markAllRead: function (userId) {
      if (config.apiBase) return api.post('/notifications/mark-all-read');
      var list = loadNotifs();
      list.forEach(function(n){ if (n.targetUserId === userId) n.isRead = 'Y'; });
      saveNotifs(list);
      return Promise.resolve(true);
    },

    getUnreadCount: function (userId) {
      return loadNotifs().filter(function(n){ return n.targetUserId === userId && n.isRead === 'N'; }).length;
    },

    TYPE_ICON: {
      APPROVAL: '&#9989;',
      INFO:     '&#8505;',
      WARNING:  '&#9888;',
      ERROR:    '&#10060;',
    },
  };
});
