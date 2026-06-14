/**
 * config.js — API configuration for the Task Management module (App 207)
 *
 * apiBase = '/ords/admin/tm'  → real ORDS endpoint (same host / dev-proxy)
 */
define([], function () {
  'use strict';

  var ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin';

  return {
    apiBase:  ADB + '/tm',           // TM ORDS module  — real DB
    authBase: ADB + '/dct',          // Admin ORDS module — login / session

    // shared api.js: where to send the browser when the session dies
    adminPortalUrl: '/Admin/Jet/index.html',
  };
});
