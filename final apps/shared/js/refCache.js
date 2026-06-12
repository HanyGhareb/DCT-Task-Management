/**
 * shared/js/refCache.js — TTL cache for read-mostly reference data (Wave 2).
 *
 *   refCache.get('roles', function () { return api.get('/roles/'); })
 *     → serves from memory/sessionStorage for 5 minutes, dedupes concurrent
 *       loads (one network call even if 3 views ask at once).
 *   refCache.invalidate('roles')  — call from every mutating service method.
 *   refCache.invalidate()         — drop everything (e.g. on logout).
 *
 * Values must be JSON-serialisable (they are: plain ORDS payloads).
 * sessionStorage persistence keeps the cache warm across F5 within a tab.
 */
define([], function () {
  'use strict';

  var TTL = 5 * 60 * 1000;
  var SS_PREFIX = 'ifinance_refcache:';
  var mem = {};   // key → { at, val } | { pending }

  function fromSession(key) {
    try {
      var raw = sessionStorage.getItem(SS_PREFIX + key);
      return raw ? JSON.parse(raw) : null;
    } catch (e) { return null; }
  }
  function toSession(key, entry) {
    try { sessionStorage.setItem(SS_PREFIX + key, JSON.stringify(entry)); }
    catch (e) { /* quota — memory layer still works */ }
  }

  function get(key, loader, opts) {
    var ttl = (opts && opts.ttl) || TTL;
    var now = Date.now();

    var e = mem[key];
    if (e && e.pending) return e.pending;
    if (e && (now - e.at) < ttl) return Promise.resolve(e.val);

    var ss = fromSession(key);
    if (ss && (now - ss.at) < ttl) {
      mem[key] = ss;
      return Promise.resolve(ss.val);
    }

    var p = loader().then(function (val) {
      var entry = { at: Date.now(), val: val };
      mem[key] = entry;
      toSession(key, entry);
      return val;
    }).catch(function (err) {
      delete mem[key];
      throw err;
    });
    mem[key] = { pending: p };
    return p;
  }

  function invalidate(prefix) {
    Object.keys(mem).forEach(function (k) {
      if (!prefix || k.indexOf(prefix) === 0) delete mem[k];
    });
    try {
      for (var i = sessionStorage.length - 1; i >= 0; i--) {
        var k = sessionStorage.key(i);
        if (k && k.indexOf(SS_PREFIX) === 0 &&
            (!prefix || k.indexOf(SS_PREFIX + prefix) === 0)) {
          sessionStorage.removeItem(k);
        }
      }
    } catch (e) {}
  }

  return { get: get, invalidate: invalidate };
});
