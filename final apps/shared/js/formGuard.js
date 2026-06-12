/**
 * shared/js/formGuard.js — unsaved-changes guard (Wave 2).
 *
 * Usage (any form VM):
 *   var guard = formGuard.track([self.nameEn, self.nameAr, self.email]);
 *   // after a successful save (or after loading data into the fields):
 *   guard.reset();
 *
 * The app shell asks formGuard.anyDirty() before an in-app route change and
 * the browser asks via beforeunload. Route swaps dispose viewModels without
 * a hook, so the shell calls clearAll() after every successful navigation —
 * guards never outlive their view.
 */
define(['knockout'], function (ko) {
  'use strict';

  var active = [];

  function snapshot(obs) {
    return JSON.stringify(obs.map(function (o) {
      return typeof o === 'function' ? o() : o;
    }));
  }

  function track(observables) {
    var g = {
      _obs:  observables || [],
      _base: snapshot(observables || []),
      isDirty: function () { return snapshot(g._obs) !== g._base; },
      reset:   function () { g._base = snapshot(g._obs); },
      release: function () {
        var i = active.indexOf(g);
        if (i >= 0) active.splice(i, 1);
      }
    };
    active.push(g);
    return g;
  }

  function anyDirty() {
    return active.some(function (g) { return g.isDirty(); });
  }

  function clearAll() { active.length = 0; }

  window.addEventListener('beforeunload', function (e) {
    if (anyDirty()) { e.preventDefault(); e.returnValue = ''; }
  });

  return { track: track, anyDirty: anyDirty, clearAll: clearAll };
});
