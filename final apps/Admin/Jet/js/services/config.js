/**
 * config.js — API configuration
 *
 * apiBase = null          → mock mode  (localStorage, no network calls)
 * apiBase = '/ords/prod/dct' → real DB mode (ORDS REST endpoints)
 *
 * To switch to real DB: change null to the ORDS base URL and reload.
 */
define([], function () {
  'use strict';
  return {
    apiBase: null,
    // apiBase: '/ords/prod/dct',
  };
});
