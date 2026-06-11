/**
 * config.js — API configuration for HR module (App 205)
 *
 * apiBase = null              → mock mode (localStorage, no network)
 * apiBase = '/ords/admin/hr'  → real ORDS endpoint (same host)
 * apiBase = 'https://...'    → real ORDS endpoint (cross-origin dev)
 */
define([], function () {
  'use strict';

  var ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin';

  return {
    // apiBase: null,                 // mock mode (localStorage)
    apiBase:  ADB + '/hr',           // HR ORDS module  — real DB
    authBase: ADB + '/dct',          // Admin ORDS module — login / session

    // Phase 3 shared api.js: where to send the browser when the session dies
    adminPortalUrl: '/Admin/Jet/index.html',
  };
});
