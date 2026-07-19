/**
 * vacations.js — Team Vacations planner (App 207). DRAFT PAGE.
 * A time-scale calendar of team leave: Day (agenda) · Week (member×7-day grid) ·
 * Month (APEX-Calendar grid, with a Team-grid layout toggle) · Year (member×12-
 * month heat matrix). Data comes from vacationService (live /tm/vacations when it
 * ships; deterministic sample overlay on the real team roster until then).
 */
define(['knockout', 'services/tmService', 'services/vacationService', 'shared/i18n'],
function (ko, tm, vacSvc, i18n) {
  'use strict';

  function pad(n) { return (n < 10 ? '0' : '') + n; }
  function iso(dt) { return dt.getFullYear() + '-' + pad(dt.getMonth() + 1) + '-' + pad(dt.getDate()); }
  function d(s) { return s ? new Date(s + 'T00:00:00') : null; }
  function addDays(dt, n) { var x = new Date(dt); x.setDate(x.getDate() + n); return x; }
  function diffDays(a, b) { return Math.round((a - b) / 864e5); }
  function monIdx(dt) { return (dt.getDay() + 6) % 7; }   // Mon=0 … Sun=6 (UAE weekend = Sat+Sun)
  function isWe(dt) { return dt.getDay() === 6 || dt.getDay() === 0; }
  function midnight(dt) { return new Date(dt.getFullYear(), dt.getMonth(), dt.getDate()); }
  function initialsOf(name) {
    var p = (name || '').split(' ').filter(Boolean);
    return (p.length >= 2 ? p[0][0] + p[p.length - 1][0] : (p[0] || '?')[0]).toUpperCase();
  }

  var TYPES = ['ANNUAL', 'SICK', 'MISSION', 'TRAINING', 'OTHER'];
  var SCALES = ['day', 'week', 'month', 'year'];
  var LANE_H = 24, BARS_TOP = 32;

  // First day of the semantic period a scale+anchor represents.
  function normalizeAnchor(scale, dt) {
    if (scale === 'day')   return midnight(dt);
    if (scale === 'week')  return addDays(midnight(dt), -monIdx(dt));
    if (scale === 'year')  return new Date(dt.getFullYear(), 0, 1);
    return new Date(dt.getFullYear(), dt.getMonth(), 1);            // month
  }

  return function Vacations() {
    var self = this;
    self.t = i18n.t;
    var st = (window._jetApp && window._jetApp.getState()) || {};

    self.loading = ko.observable(true);
    self.sample  = ko.observable(false);
    self.teams   = ko.observableArray([]);
    self.teamId  = ko.observable(st.teamId || null);
    self.scale   = ko.observable(SCALES.indexOf(st.vacScale) >= 0 ? st.vacScale : 'month');
    self.view    = ko.observable('cal');            // month layout: 'cal' | 'grid'
    self.anchor  = ko.observable(new Date());

    self.items  = [];        // vacations in the fetched window
    self.roster = [];        // members shown in grids + plan form
    self.photoBy = {};       // userId → profile-photo URL (real members only)
    var localAdds = [];      // draft-mode adds survive navigation

    self.rangeTitle = ko.observable('');
    self.rangeEmpty = ko.observable(false);
    self.kpis       = ko.observable({ today: 0, out: 0, days: 0, peak: 0, peakDate: '',
                                      awayLabel: '', daysLabel: '' });
    self.rosterOpts = ko.observableArray([]);
    self.typeOpts   = TYPES.map(function (c) { return { code: c, label: i18n.t('tm.vac.type.' + c) }; });
    self.scaleOpts  = SCALES.map(function (s) { return { code: s, label: 'tm.vac.scale.' + s }; });

    // per-scale render state
    self.dowNames = ko.observableArray([]);   // month calendar weekday header
    self.weeks    = ko.observableArray([]);   // month calendar week rows (lane bars)
    self.gridDays = ko.observableArray([]);   // month team-grid day header
    self.gridRows = ko.observableArray([]);   // month team-grid member rows
    self.monthEmpty = ko.observable(false);
    self.dayList  = ko.observableArray([]);   // day agenda
    self.weekCols = ko.observableArray([]);   // week grid day header
    self.weekRows = ko.observableArray([]);   // week grid member rows
    self.yearCols = ko.observableArray([]);   // year matrix month header
    self.yearRows = ko.observableArray([]);   // year matrix member rows
    self.yearFoot = ko.observableArray([]);   // year matrix team totals
    self.yearTotal = ko.observable(0);

    // ── modal state ─────────────────────────────────────────────────────
    self.selVac   = ko.observable(null);
    self.formOpen = ko.observable(false);
    self.editId   = ko.observable(null);
    self.fmUser   = ko.observable(null);
    self.fmType   = ko.observable('ANNUAL');
    self.fmFrom   = ko.observable('');
    self.fmTo     = ko.observable('');
    self.fmNotes  = ko.observable('');
    self.fmErr    = ko.observable('');

    var win = null;   // snapshot of the built window (scale, anchor, ranges)

    function loc() { return (i18n.lang && i18n.lang() === 'ar') ? 'ar-AE-u-nu-latn' : 'en'; }
    function fmt(dt, opts, l) { return new Intl.DateTimeFormat(l, opts).format(dt); }

    // ── a member × days matrix (shared by Week grid and Month team-grid) ──
    function matrixRows(days, vacs) {
      return self.roster.map(function (mem) {
        var mine = vacs.filter(function (x) { return x.vac.userId === mem.userId; });
        var total = 0;
        var cells = days.map(function (dd) {
          var hit = null;
          for (var j = 0; j < mine.length; j++) {
            if (mine[j].s <= dd && mine[j].e >= dd) { hit = mine[j]; break; }
          }
          if (hit) total++;
          return {
            we: isWe(dd), iso: iso(dd),
            t: hit ? hit.vac.type : '', vac: hit ? hit.vac : null,
            barCls: hit ? ('vac-cellbar vac-cell--' + hit.vac.type
                    + (hit.vac.status === 'PENDING' ? ' vac-cellbar--pending' : '')
                    + (diffDays(dd, hit.s) === 0 ? ' vac-cellbar--capL' : '')
                    + (diffDays(hit.e, dd) === 0 ? ' vac-cellbar--capR' : '')) : '',
            tip: hit ? (mem.name + ' • ' + i18n.t('tm.vac.type.' + hit.vac.type)
                 + ' • ' + hit.vac.startDate + ' → ' + hit.vac.endDate) : ''
          };
        });
        return { name: mem.name, initials: initialsOf(mem.name), photoUrl: mem.photoUrl || null, cells: cells, total: total };
      });
    }

    // ── MONTH: APEX-Calendar grid (lane bars) + team-grid matrix ──────────
    function buildMonth(vacs, l) {
      var mStart = win.mStart, mEnd = win.mEnd, todayIso = iso(new Date());
      var dows = [];
      for (var i = 0; i < 7; i++) dows.push(fmt(addDays(win.calStart, i), { weekday: 'short' }, l));
      self.dowNames(dows);

      var weeks = [];
      for (var ws = new Date(win.calStart); ws <= win.calEnd; ws = addDays(ws, 7)) {
        var we = addDays(ws, 6), days = [];
        for (var k = 0; k < 7; k++) {
          var dd = addDays(ws, k);
          days.push({ num: dd.getDate(), iso: iso(dd), inMonth: dd.getMonth() === mStart.getMonth(),
                      we: isWe(dd), today: iso(dd) === todayIso });
        }
        var lanes = [], bars = [];
        vacs.forEach(function (x) {
          if (x.s > we || x.e < ws) return;
          var s0 = x.s < ws ? 0 : diffDays(x.s, ws);
          var e0 = x.e > we ? 6 : diffDays(x.e, ws);
          var lane = 0;
          while (lane < lanes.length && lanes[lane] >= s0) lane++;
          lanes[lane] = e0;
          var v = x.vac;
          bars.push({
            vac: v, label: v.memberName,
            cls: 'vac-bar vac--' + v.type + (v.status === 'PENDING' ? ' vac-bar--pending' : '')
               + (x.s < ws ? ' vac-bar--contL' : '') + (x.e > we ? ' vac-bar--contR' : ''),
            tip: v.memberName + ' • ' + i18n.t('tm.vac.type.' + v.type) + ' • '
               + v.startDate + ' → ' + v.endDate + ' (' + i18n.t('tm.vac.status.' + v.status) + ')',
            style: 'inset-inline-start:calc(' + (s0 / 7 * 100) + '% + 2px);'
                 + 'width:calc(' + ((e0 - s0 + 1) / 7 * 100) + '% - 5px);top:' + (lane * LANE_H) + 'px'
          });
        });
        weeks.push({ days: days, bars: bars, minH: Math.max(96, BARS_TOP + lanes.length * LANE_H + 6) });
      }
      self.weeks(weeks);

      var dim = mEnd.getDate(), gDays = [], monthDates = [];
      for (var n = 1; n <= dim; n++) {
        var gd = new Date(mStart.getFullYear(), mStart.getMonth(), n);
        gDays.push({ n: n, we: isWe(gd) }); monthDates.push(gd);
      }
      self.gridDays(gDays);
      self.gridRows(matrixRows(monthDates, vacs));
      self.monthEmpty(vacs.filter(function (x) { return x.s <= mEnd && x.e >= mStart; }).length === 0);
    }

    // ── WEEK: member × 7-day grid ─────────────────────────────────────────
    function buildWeek(vacs, l) {
      var todayIso = iso(new Date()), cols = [], days = [];
      for (var k = 0; k < 7; k++) {
        var dd = addDays(win.rangeStart, k);
        cols.push({ label: fmt(dd, { weekday: 'short' }, l), num: dd.getDate(),
                    iso: iso(dd), we: isWe(dd), today: iso(dd) === todayIso });
        days.push(dd);
      }
      self.weekCols(cols);
      self.weekRows(matrixRows(days, vacs));
    }

    // ── DAY: agenda of who is out ─────────────────────────────────────────
    function buildDay(vacs, l) {
      var day = win.rangeStart;
      var out = vacs.filter(function (x) { return x.s <= day && x.e >= day; });
      self.dayList(out.map(function (x) {
        var v = x.vac;
        return { vac: v, name: v.memberName, initials: initialsOf(v.memberName), photoUrl: self.photoBy[v.userId] || null,
                 typeCls: 'vac-chip vac--' + v.type, typeLabel: i18n.t('tm.vac.type.' + v.type),
                 statusCls: 'vac-chip vac-chip--' + v.status, statusLabel: i18n.t('tm.vac.status.' + v.status),
                 range: v.startDate + ' → ' + v.endDate,
                 dayOf: (diffDays(day, x.s) + 1) + '/' + (diffDays(x.e, x.s) + 1),
                 notes: v.notes || '' };
      }));
    }

    // ── YEAR: member × 12-month leave-day heat matrix ─────────────────────
    function buildYear(vacs, l) {
      var yr = win.a.getFullYear(), now = new Date();
      var cols = [];
      for (var m = 0; m < 12; m++) {
        cols.push({ label: fmt(new Date(yr, m, 1), { month: 'short' }, l), mIdx: m,
                    isNow: now.getFullYear() === yr && now.getMonth() === m });
      }
      self.yearCols(cols);
      var foot = [], t = 0;
      for (var f = 0; f < 12; f++) foot.push(0);
      self.yearRows(self.roster.map(function (mem) {
        var mine = vacs.filter(function (x) { return x.vac.userId === mem.userId; });
        var total = 0;
        var cells = cols.map(function (c) {
          var ms = new Date(yr, c.mIdx, 1), me = new Date(yr, c.mIdx + 1, 0), cnt = 0;
          mine.forEach(function (x) {
            if (x.s <= me && x.e >= ms) cnt += diffDays(x.e < me ? x.e : me, x.s > ms ? x.s : ms) + 1;
          });
          total += cnt; foot[c.mIdx] += cnt;
          var lvl = cnt === 0 ? 0 : cnt <= 2 ? 1 : cnt <= 6 ? 2 : 3;
          return { cnt: cnt, mIdx: c.mIdx, cls: 'vac-yr vac-yr--' + lvl,
                   tip: cnt ? (mem.name + ' • ' + cnt + ' ' + i18n.t('tm.vac.daysL') + ' • ' + c.label) : '' };
        });
        return { name: mem.name, initials: initialsOf(mem.name), photoUrl: mem.photoUrl || null, cells: cells, total: total };
      }));
      foot.forEach(function (v) { t += v; });
      self.yearFoot(foot.map(function (v, i) { return { v: v, mIdx: i }; }));
      self.yearTotal(t);
    }

    function buildKpis(vacs, l) {
      var s = win.rangeStart, e = win.rangeEnd, today = midnight(new Date());
      var inRange = vacs.filter(function (x) { return x.s <= e && x.e >= s; });
      var uToday = {}, uOut = {}, days = 0, peak = 0, peakD = null;
      inRange.forEach(function (x) {
        uOut[x.vac.userId] = 1;
        if (x.s <= today && x.e >= today && x.vac.status === 'APPROVED') uToday[x.vac.userId] = 1;
        days += diffDays(x.e < e ? x.e : e, x.s > s ? x.s : s) + 1;
      });
      for (var dd = new Date(s); dd <= e; dd = addDays(dd, 1)) {
        var c = 0;
        inRange.forEach(function (x) { if (x.s <= dd && x.e >= dd) c++; });
        if (c > peak) { peak = c; peakD = new Date(dd); }
      }
      self.kpis({
        today: Object.keys(uToday).length, out: Object.keys(uOut).length, days: days, peak: peak,
        peakDate: peakD ? fmt(peakD, { day: 'numeric', month: 'short' }, l) : '',
        awayLabel: i18n.t('tm.vac.kpi.away') + ' ' + i18n.t('tm.vac.scope.' + win.scale),
        daysLabel: i18n.t('tm.vac.kpi.days') + ' (' + i18n.t('tm.vac.scopeShort.' + win.scale) + ')'
      });
      self.rangeEmpty(inRange.length === 0);
    }

    function title(l) {
      var a = win.a;
      if (win.scale === 'day')   return fmt(a, { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' }, l);
      if (win.scale === 'week')  return fmt(a, { day: 'numeric', month: 'short' }, l) + ' – '
                                      + fmt(win.rangeEnd, { day: 'numeric', month: 'short', year: 'numeric' }, l);
      if (win.scale === 'year')  return fmt(a, { year: 'numeric' }, l);
      return fmt(a, { month: 'long', year: 'numeric' }, l);
    }

    // ── build the active scale's view from self.items ─────────────────────
    function build() {
      var l = loc();
      var vacs = self.items.map(function (v) { return { vac: v, s: d(v.startDate), e: d(v.endDate) }; })
                           .sort(function (a, b) { return (a.s - b.s) || ((b.e - b.s) - (a.e - a.s)); });
      self.rangeTitle(title(l));
      buildKpis(vacs, l);
      if (win.scale === 'day')       buildDay(vacs, l);
      else if (win.scale === 'week') buildWeek(vacs, l);
      else if (win.scale === 'year') buildYear(vacs, l);
      else                           buildMonth(vacs, l);
      self.rosterOpts(self.roster);
    }

    // ── data loading ────────────────────────────────────────────────────
    self.load = function () {
      self.loading(true);
      var scale = self.scale(), a = normalizeAnchor(scale, self.anchor());
      var rangeStart, rangeEnd, fetchStart, fetchEnd, mStart, mEnd, calStart, calEnd;
      if (scale === 'month') {
        mStart = a; mEnd = new Date(a.getFullYear(), a.getMonth() + 1, 0);
        calStart = addDays(mStart, -monIdx(mStart)); calEnd = addDays(mEnd, 6 - monIdx(mEnd));
        rangeStart = mStart; rangeEnd = mEnd; fetchStart = calStart; fetchEnd = calEnd;
      } else if (scale === 'week') {
        rangeStart = a; rangeEnd = addDays(a, 6); fetchStart = a; fetchEnd = rangeEnd;
        mStart = a; mEnd = rangeEnd;
      } else if (scale === 'day') {
        rangeStart = rangeEnd = fetchStart = fetchEnd = mStart = mEnd = a;
      } else {
        rangeStart = new Date(a.getFullYear(), 0, 1); rangeEnd = new Date(a.getFullYear(), 11, 31);
        fetchStart = rangeStart; fetchEnd = rangeEnd; mStart = rangeStart; mEnd = rangeEnd;
      }
      win = { scale: scale, a: a, calStart: calStart, calEnd: calEnd, mStart: mStart, mEnd: mEnd,
              rangeStart: rangeStart, rangeEnd: rangeEnd };
      var mp = self.teamId()
        ? tm.listMembers(self.teamId()).then(function (r) {
            return (r.items || []).map(function (m) {
              // profile photo served by the shared Admin media handler (no auth
              // header needed — it's an ORDS media source); falls back to initials
              return { userId: m.userId, name: m.name,
                       photoUrl: '/ords/admin/dct/users/' + m.userId + '/photo' };
            });
          }).catch(function () { return []; })
        : Promise.resolve([]);
      mp.then(function (members) {
        return vacSvc.getVacations({ teamId: self.teamId(), from: iso(fetchStart), to: iso(fetchEnd), members: members });
      }).then(function (res) {
        self.sample(res.sample);
        self.roster = res.roster || [];
        self.photoBy = {};
        self.roster.forEach(function (m) { if (m.photoUrl) self.photoBy[m.userId] = m.photoUrl; });
        self.items = (res.items || []).concat(localAdds.filter(function (v) {
          return v.startDate <= iso(fetchEnd) && v.endDate >= iso(fetchStart);
        }));
        build();
        self.loading(false);
      });
    };

    // ── navigation ───────────────────────────────────────────────────────
    function step(dir) {
      var s = self.scale(), a = normalizeAnchor(s, self.anchor());
      if (s === 'day')       a = addDays(a, dir);
      else if (s === 'week') a = addDays(a, dir * 7);
      else if (s === 'year') a = new Date(a.getFullYear() + dir, 0, 1);
      else                   a = new Date(a.getFullYear(), a.getMonth() + dir, 1);
      self.anchor(a); self.load();
    }
    self.prev = function () { step(-1); };
    self.next = function () { step(1); };
    self.goToday = function () { self.anchor(new Date()); self.load(); };
    self.setView = function (v) { self.view(v); };
    self.setScale = function (s) {
      if (s === self.scale()) return;
      // keep context: if the period on screen contains today, land on today
      var cur = normalizeAnchor(self.scale(), self.anchor());
      var curEnd = self.scale() === 'day' ? cur
                 : self.scale() === 'week' ? addDays(cur, 6)
                 : self.scale() === 'year' ? new Date(cur.getFullYear(), 11, 31)
                 : new Date(cur.getFullYear(), cur.getMonth() + 1, 0);
      var now = midnight(new Date());
      if (now >= cur && now <= curEnd) self.anchor(now);
      st.vacScale = s; self.scale(s); self.load();
    };
    self.drillMonth = function (mIdx) {
      self.anchor(new Date(win.a.getFullYear(), mIdx, 1));
      st.vacScale = 'month'; self.scale('month'); self.load();
    };

    // ── cell / day interactions ──────────────────────────────────────────
    self.dayClass = function (day) {
      return 'vac-day' + (day.inMonth ? '' : ' vac-day--out') + (day.we ? ' vac-day--we' : '')
           + (day.today ? ' vac-day--today' : '');
    };
    self.cellClass = function (cell) { return 'vac-g-cell' + (cell.we ? ' vac-g-we' : ''); };
    self.gridCellClick = function (cell) {
      if (cell.vac) { self.openVac(cell.vac); } else if (cell.iso) { resetForm(cell.iso); self.formOpen(true); }
    };

    // ── detail modal ────────────────────────────────────────────────────
    self.openVac  = function (v) { self.selVac(v); };
    self.closeVac = function () { self.selVac(null); };
    self.vacDays  = function (v) { return diffDays(d(v.endDate), d(v.startDate)) + 1; };
    // No profile photo for this member (or a canned sample row) → drop the broken
    // <img> so the initials underneath show through.
    self.photoErr = function (data, ev) { if (ev && ev.target) { ev.target.style.display = 'none'; } return true; };
    self.selVacPhoto    = ko.computed(function () { var v = self.selVac(); return v ? (self.photoBy[v.userId] || null) : null; });
    self.selVacInitials = ko.computed(function () { var v = self.selVac(); return v ? initialsOf(v.memberName) : ''; });

    self.removeVac = function () {
      var v = self.selVac(); if (!v) return;
      if (!window.confirm(i18n.t('tm.vac.confirmRemove'))) return;
      self.items = self.items.filter(function (x) { return x.vacId !== v.vacId; });
      localAdds = localAdds.filter(function (x) { return x.vacId !== v.vacId; });
      self.selVac(null); build();
    };

    // ── plan / edit form ────────────────────────────────────────────────
    function resetForm(dateIso) {
      self.editId(null); self.fmUser(null); self.fmType('ANNUAL');
      self.fmFrom(dateIso || ''); self.fmTo(dateIso || ''); self.fmNotes(''); self.fmErr('');
    }
    self.openAdd  = function () { resetForm(win && win.scale === 'day' ? iso(win.rangeStart) : ''); self.formOpen(true); };
    self.dayClick = function (day) { if (day.inMonth) { resetForm(day.iso); self.formOpen(true); } };
    self.editVac  = function () {
      var v = self.selVac(); if (!v) return;
      self.editId(v.vacId); self.fmUser(v.userId); self.fmType(v.type);
      self.fmFrom(v.startDate); self.fmTo(v.endDate); self.fmNotes(v.notes || ''); self.fmErr('');
      self.selVac(null); self.formOpen(true);
    };
    self.closeForm = function () { self.formOpen(false); };
    self.saveForm  = function () {
      var uid = self.fmUser(), f = self.fmFrom(), t2 = self.fmTo();
      if (!uid || !f || !t2) { self.fmErr(i18n.t('tm.vac.valReq')); return; }
      if (t2 < f) { self.fmErr(i18n.t('tm.vac.valDates')); return; }
      var mem = self.roster.filter(function (m) { return m.userId === uid; })[0] || {};
      if (self.editId()) {
        self.items.forEach(function (v) {
          if (v.vacId !== self.editId()) return;
          v.userId = uid; v.memberName = mem.name || v.memberName; v.type = self.fmType();
          v.startDate = f; v.endDate = t2; v.notes = self.fmNotes();
        });
      } else {
        var nv = { vacId: 'L' + new Date().getTime(), userId: uid, memberName: mem.name || '',
                   type: self.fmType(), status: 'PENDING', startDate: f, endDate: t2, notes: self.fmNotes() };
        localAdds.push(nv); self.items.push(nv);
      }
      self.formOpen(false); build();
    };

    // ── init ────────────────────────────────────────────────────────────
    // Language switch re-evaluates t() bindings live but never re-creates the
    // VM — rebuild so Intl-formatted month/weekday names follow. Self-disposes
    // once the view is unmounted.
    var langSub = i18n.lang.subscribe(function () {
      if (!document.querySelector('.vac-page')) { langSub.dispose(); return; }
      if (win) build();
    });
    self.teamId.subscribe(function (v) { st.teamId = v; self.load(); });
    tm.listTeams({}).then(function (r) {
      var items = (r && r.items) || [];
      self.teams(items);
      if (!items.length) { self.loading(false); return; }
      var keep = self.teamId() && items.some(function (t3) { return t3.teamId === self.teamId(); });
      if (keep) { self.load(); } else { self.teamId(items[0].teamId); }   // subscribe triggers load
    }).catch(function () { self.loading(false); });
  };
});
