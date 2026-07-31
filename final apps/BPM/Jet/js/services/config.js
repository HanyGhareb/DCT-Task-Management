/**
 * config.js — API configuration for Fusion BPM — Workflow Management (App 214).
 *
 * BPM deliberately owns NO ORDS module of its own: it is a console over the
 * two existing cross-module APIs —
 *   /ords/admin/wf/   the DCT Workflow Platform API (worklist, designer,
 *                     role assignments; gate-EXEMPT in db/v2/50)
 *   /ords/admin/dct/  the shared Admin module (legacy approvals, delegations,
 *                     users, notifications; 'dct' segment is gate-exempt too)
 *
 * apiBase therefore points at /dct (so every page lifted from Admin works
 * verbatim), and shared/api.js derives the wf base from it by swapping the
 * trailing segment (see resolveBase — '/dct' → '/wf').
 */
define([], function () {
  'use strict';

  var ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin';

  return {
    apiBase:  ADB + '/dct',          // shared Admin module — legacy approvals/delegations/users
    authBase: ADB + '/dct',          // login / session (established by App 200)

    // shared api.js: where to send the browser when the session dies
    adminPortalUrl: '/Admin/Jet/index.html',
  };
});
