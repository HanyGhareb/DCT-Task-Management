/**
 * sessionService.js — active platform sessions (enh-2 round, SYS_ADMIN only)
 * ORDS: GET  /sessions/        — active sessions within the inactivity window
 *       POST /sessions/revoke  — { username } → close ALL that user's sessions
 *
 * session_id is the bearer token, so the server only ever returns sidTail
 * (last 6 chars) — enough to highlight "this device", useless to an attacker.
 */
define(['services/api'], function (api) {
  'use strict';

  return {
    getSessions: function () {
      return api.get('/sessions/').then(function (r) {
        return {
          timeoutMins: r.timeoutMins,
          items: (r.items || []).map(function (s) {
            return {
              sidTail:      s.sidTail,
              username:     s.username,
              displayName:  s.displayName || s.username,
              loginAt:      s.loginAt,
              lastActivity: s.lastActivity,
              ip:           s.ip || '',
              userAgent:    s.userAgent || '',
              authMethod:   s.authMethod || '',
            };
          }),
        };
      });
    },

    revokeUser: function (username) {
      return api.post('/sessions/revoke', { username: username });
    },
  };
});
