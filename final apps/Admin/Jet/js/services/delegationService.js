/**
 * delegationService.js — /dct/delegations endpoints (Phase 4).
 * All methods return Promises; api.js injects the Bearer token.
 */
define(['services/api'], function (api) {
  'use strict';

  return {
    // mine=true → only delegations where I am delegator or delegate
    getAll: function (mine) {
      return api.get('/delegations/' + (mine ? '?mine=Y' : ''))
        .then(function (r) { return r.items || []; });
    },

    // { delegateId, scope, roleId?, moduleCode?, startDate, endDate, reason }
    create: function (data) { return api.post('/delegations/', data); },

    cancel: function (id) { return api.post('/delegations/' + id + '/cancel', {}); },
  };
});
