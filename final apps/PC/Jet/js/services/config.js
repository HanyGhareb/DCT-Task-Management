/**
 * config.js — API configuration for Petty Cash module
 *
 * apiBase = null              → mock mode (localStorage, no network)
 * apiBase = '/ords/prod/pc'  → real ORDS endpoint (same host)
 * apiBase = 'https://...'    → real ORDS endpoint (cross-origin dev)
 */
define([], function () {
  'use strict';
  return {
    apiBase: null,
    // apiBase: '/ords/admin/pc',
    // apiBase: 'https://gd5cec2eaeb21e3-prod.adb.me-abudhabi-1.oraclecloudapps.com/ords/admin/pc',
  };
});
