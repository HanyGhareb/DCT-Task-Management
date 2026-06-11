/**
 * config.js — API configuration
 *
 * apiBase = null                  → mock mode (localStorage, no network calls)
 * apiBase = '/ords/prod/dct'      → real DB, served from same APEX/ORDS host
 * apiBase = 'https://...'         → real DB, cross-origin (local dev)
 *
 * ADB ORDS base: https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/dct
 *
 * ORDS module 'dct.admin' is published. Switch apiBase below to enable real DB.
 */
define([], function () {
  'use strict';
  return {
    // apiBase: null,                                                             // mock mode
    apiBase: '/ords/admin/dct',                                                  // dev-proxy.py (local dev)
    // apiBase: 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/dct', // direct (APEX deploy)

    // Phase 3 shared api.js: Admin IS the identity provider — on 401 it routes
    // to its own login view instead of redirecting to a portal URL.
    adminPortalUrl: null,
  };
});
