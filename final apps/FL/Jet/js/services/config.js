/**
 * config.js — API configuration for the Freelancers module (App 203)
 *
 * apiBase = '/ords/admin/fl'  → real ORDS endpoint (same host / dev-proxy)
 */
define([], function () {
  'use strict';

  var ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin';

  return {
    apiBase:  ADB + '/fl',           // FL ORDS module  — real DB
    authBase: ADB + '/dct',          // Admin ORDS module — login / session

    // shared api.js: where to send the browser when the session dies
    adminPortalUrl: '/Admin/Jet/index.html',
  };
});
