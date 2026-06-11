/**
 * config.js — API configuration for Petty Cash module (App 201)
 *
 * apiBase = null              → mock mode (localStorage, no network)
 * apiBase = '/ords/admin/pc'  → real ORDS endpoint (same host / dev-proxy)
 * apiBase = 'https://...'    → real ORDS endpoint (cross-origin dev)
 */
define([], function () {
  'use strict';

  var ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin';

  return {
    // apiBase: null,              // mock mode (localStorage)
    apiBase:  ADB + '/pc',         // PC ORDS module   — real DB
    authBase: ADB + '/dct',        // Admin ORDS module — login / session

    // Phase 3 shared api.js: where to send the browser when the session dies
    adminPortalUrl: '../Admin/Jet/index.html',
  };
});
