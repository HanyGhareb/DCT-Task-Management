/**
 * config.js — API configuration for the Credit Cards module (App 202)
 *
 * apiBase = '/ords/admin/cc'  → real ORDS endpoint (same host / dev-proxy)
 */
define([], function () {
  'use strict';

  var ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin';

  return {
    apiBase:  ADB + '/cc',           // CC ORDS module  — real DB
    authBase: ADB + '/dct',          // Admin ORDS module — login / session

    // shared api.js: where to send the browser when the session dies
    adminPortalUrl: '/Admin/Jet/index.html',
  };
});
