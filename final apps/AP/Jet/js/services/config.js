/**
 * config.js — API configuration for the Accounts Payable module (App 212)
 * apiBase  = '/ords/admin/ap'  → AP analytics ORDS module
 * authBase = '/ords/admin/dct' → Admin ORDS module (login / session / boot)
 */
define([], function () {
  'use strict';

  var ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin';

  return {
    apiBase:  ADB + '/ap',           // AP ORDS module — real DB
    authBase: ADB + '/dct',          // Admin ORDS module — login / session

    // shared api.js: where to send the browser when the session dies
    adminPortalUrl: '/Admin/Jet/index.html',

    // Fusion deep-links moved to the shared module: shared/js/fusionLinks.js
  };
});
