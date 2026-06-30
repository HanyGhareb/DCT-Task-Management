/**
 * config.js — API configuration for the BI - Reporting module (App 211)
 * apiBase = '/ords/admin/rpt'  → Reporting Platform ORDS module
 * authBase = '/ords/admin/dct' → Admin ORDS module (login / session / boot)
 */
define([], function () {
  'use strict';

  var ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin';

  return {
    apiBase:  ADB + '/rpt',          // Reporting ORDS module — real DB
    authBase: ADB + '/dct',          // Admin ORDS module — login / session

    // shared api.js: where to send the browser when the session dies
    adminPortalUrl: '/Admin/Jet/index.html',
  };
});
