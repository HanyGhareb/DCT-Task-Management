/**
 * config.js — API configuration for the Analytics Loader module (App 208)
 *
 * apiBase  = '/ords/admin/atd'  → ATD control-plane ORDS module (real DB)
 * authBase = '/ords/admin/dct'  → Admin ORDS module (login / session / theme)
 */
define([], function () {
  'use strict';

  var ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin';

  return {
    apiBase:  ADB + '/atd',          // ATD ORDS module — real DB
    authBase: ADB + '/dct',          // Admin ORDS module — login / session

    // shared api.js: where to send the browser when the session dies
    adminPortalUrl: '/Admin/Jet/index.html',
  };
});
