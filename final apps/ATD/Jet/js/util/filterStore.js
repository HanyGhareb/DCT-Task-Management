/* Persist a page's filter/search criteria in localStorage so they survive a browser
 * refresh (the SPA re-inits the VM on reload, which otherwise resets every filter).
 *
 *   var store = filterStore.bind('jobs', { search: self.fSearch, status: self.fStatus, ... });
 *   // call BEFORE wiring the VM's own reload subscriptions + the initial load(), so the
 *   // restored values are in place. `bind` restores saved values then persists on change.
 *   store.clear();   // Clear button: wipe the saved criteria
 */
define([], function () {
  'use strict';
  function key(page) { return 'atd.filters.' + page; }

  function restore(page, fields) {
    var saved = {};
    try { saved = JSON.parse(localStorage.getItem(key(page)) || '{}') || {}; } catch (e) { saved = {}; }
    Object.keys(fields).forEach(function (n) {
      if (saved[n] !== undefined && saved[n] !== null) {
        try { fields[n](saved[n]); } catch (e) { /* ignore */ }
      }
    });
  }

  function persist(page, fields) {
    var o = {};
    Object.keys(fields).forEach(function (n) { o[n] = fields[n](); });
    try { localStorage.setItem(key(page), JSON.stringify(o)); } catch (e) { /* quota/private mode */ }
  }

  function clear(page) { try { localStorage.removeItem(key(page)); } catch (e) { /* ignore */ } }

  function bind(page, fields) {
    restore(page, fields);
    Object.keys(fields).forEach(function (n) {
      fields[n].subscribe(function () { persist(page, fields); });
    });
    return { clear: function () { clear(page); } };
  }

  return { bind: bind, clear: clear, restore: restore, persist: persist };
});
