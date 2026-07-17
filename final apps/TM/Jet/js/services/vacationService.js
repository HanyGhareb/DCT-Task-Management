/**
 * vacationService.js — Team vacation plans (App 207). DRAFT.
 *
 * getVacations() tries the future tm.rest endpoint GET /vacations first.
 * Until that endpoint ships, the call 404s and the service falls back to a
 * DETERMINISTIC sample overlay draped over the team's REAL member roster,
 * so the draft page renders believable data. Delete the fallback (and the
 * canned roster) when /tm/vacations goes live — the page needs no change.
 */
define(['services/api'], function (api) {
  'use strict';

  function qs(params) {
    var p = [];
    Object.keys(params || {}).forEach(function (k) {
      var v = params[k];
      if (v !== null && v !== undefined && v !== '') p.push(k + '=' + encodeURIComponent(v));
    });
    return p.length ? '?' + p.join('&') : '';
  }
  function pad(n) { return (n < 10 ? '0' : '') + n; }
  function iso(dt) { return dt.getFullYear() + '-' + pad(dt.getMonth() + 1) + '-' + pad(dt.getDate()); }

  // Deterministic PRNG — same member + same month always yields the same plan,
  // so navigating months back and forth never reshuffles the sample.
  function rng(seed) {
    var s = seed >>> 0;
    return function () { s = (s * 1664525 + 1013904223) >>> 0; return s / 4294967296; };
  }

  // Fallback roster used only when the selected team has no members yet.
  var ROSTER = [
    { userId: 9001, name: 'Ahmed Al Mansoori' },
    { userId: 9002, name: 'Fatima Al Zaabi' },
    { userId: 9003, name: 'Mohammed Al Hammadi' },
    { userId: 9004, name: 'Mariam Al Shamsi' },
    { userId: 9005, name: 'Khalid Al Suwaidi' },
    { userId: 9006, name: 'Noora Al Ketbi' },
    { userId: 9007, name: 'Saeed Al Marri' },
    { userId: 9008, name: 'Alia Al Nuaimi' }
  ];

  var LEN = { ANNUAL: [3, 10], SICK: [1, 3], MISSION: [2, 5], TRAINING: [1, 3], OTHER: [1, 2] };

  // Sample vacations STARTING inside calendar month (y, m). ~60% of members
  // have a plan in any given month; annual leave dominates the mix.
  function sampleFor(roster, y, m) {
    var out = [];
    roster.forEach(function (mem) {
      var r = rng((mem.userId || 1) * 100003 + y * 12 + m);
      var count = r() < 0.62 ? (r() < 0.25 ? 2 : 1) : 0;
      for (var k = 0; k < count; k++) {
        var roll = r();
        var type = roll < 0.50 ? 'ANNUAL' : roll < 0.65 ? 'SICK' : roll < 0.80 ? 'MISSION'
                 : roll < 0.92 ? 'TRAINING' : 'OTHER';
        var span = LEN[type];
        var len = span[0] + Math.floor(r() * (span[1] - span[0] + 1));
        var startDay = 1 + Math.floor(r() * 25) + k * 12;
        if (startDay > 28) startDay -= 15;
        var s = new Date(y, m, startDay), e = new Date(y, m, startDay + len - 1);
        out.push({
          vacId: (mem.userId || 1) * 100000 + (y * 12 + m) * 10 + k,
          userId: mem.userId, memberName: mem.name,
          type: type, status: r() < 0.7 ? 'APPROVED' : 'PENDING',
          startDate: iso(s), endDate: iso(e), notes: ''
        });
      }
    });
    return out;
  }

  return {
    /**
     * opts: { teamId, from:'YYYY-MM-DD', to:'YYYY-MM-DD', members:[{userId,name}] }
     * resolves { items:[vacation], roster:[{userId,name}], sample:boolean }
     */
    getVacations: function (opts) {
      return api.get('/vacations' + qs({ teamId: opts.teamId, from: opts.from, to: opts.to }), { silent: true })
        .then(function (r) {
          return { items: r.items || [], roster: r.roster || opts.members || [], sample: false };
        })
        .catch(function () {
          // Sample mode tops up small rosters with canned names so the draft
          // always demos a realistically busy team.
          var roster = (opts.members || []).slice();
          if (roster.length < 4) roster = roster.concat(ROSTER.slice(0, 8 - roster.length));
          var f = new Date(opts.from + 'T00:00:00'), t = new Date(opts.to + 'T00:00:00');
          // Generate for every month whose spans could reach the window
          var items = [];
          var cur = new Date(f.getFullYear(), f.getMonth() - 1, 1);
          var end = new Date(t.getFullYear(), t.getMonth(), 1);
          while (cur <= end) {
            items = items.concat(sampleFor(roster, cur.getFullYear(), cur.getMonth()));
            cur = new Date(cur.getFullYear(), cur.getMonth() + 1, 1);
          }
          items = items.filter(function (v) { return v.startDate <= opts.to && v.endDate >= opts.from; });
          return { items: items, roster: roster, sample: true };
        });
    }
  };
});
