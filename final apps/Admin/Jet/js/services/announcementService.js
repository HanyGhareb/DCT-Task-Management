/**
 * announcementService.js — /dct/announcements endpoints (Phase 4).
 * All methods return Promises; api.js injects the Bearer token.
 */
define(['services/api'], function (api) {
  'use strict';

  return {
    getAll: function () {
      return api.get('/announcements/').then(function (r) { return r.items || []; });
    },

    getActive: function (moduleCode) {
      return api.get('/announcements/active' + (moduleCode ? '?module=' + moduleCode : ''),
                     { silent: true })
        .then(function (r) { return r.items || []; });
    },

    // { titleEn, titleAr, bodyEn, bodyAr, severity, audience, roleId?, moduleCode?,
    //   publishedAt?, expiresAt?, isActive }
    create: function (data)     { return api.post('/announcements/', data); },
    update: function (id, data) { return api.put('/announcements/' + id, data); },
  };
});
