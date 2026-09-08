/**
 * config.js — API configuration for Finance KPIs V2 (App 213).
 * V2 rides the SAME live backend as v1: /ords/admin/kpi + /dct auth.
 */
define([], function () {
  'use strict';

  var ADB = 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin';

  return {
    apiBase:  ADB + '/kpi',          // KPI ORDS module  — real DB
    authBase: ADB + '/dct',          // Admin ORDS module — login / session

    // shared api.js: where to send the browser when the session dies
    adminPortalUrl: '/dct/index.html',
  };
});
