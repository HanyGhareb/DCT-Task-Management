/**
 * vacations.js — Team Vacations planner (App 207). DRAFT PAGE.
 * APEX-Calendar-style month grid with multi-day leave bars (lane layout),
 * plus a per-member "team grid" matrix view. Data comes from
 * vacationService (live /tm/vacations when it ships; deterministic sample
 * overlay on the real team roster until then).
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

  var TYPES = ['ANNUAL', 'SICK', 'MISSION', 'TRAINING', 'OTHER'];
  var LANE_H = 24, BARS_TOP = 32;

  return function Vacations() {
    var self = this;
    self.t = i18n.t;
    var st = (window._jetApp && window._jetApp.getState()) || {};

    self.loading = ko.observable(true);
    self.sample  = ko.observable(false);
    self.teams   = ko.observableArray([]);
    self.teamId  = ko.observable(st.teamId || null);
    self.view    = ko.observable('cal');            // 'cal' | 'grid'
    self.anchor  = ko.observable(new Date(new Date().getFullYear(), new Date().getMonth(), 1));

    self.items  = [];        // vacations in the fetched window
    self.roster = [];        // members shown in grid + plan form
    var localAdds = [];      // draft-mode adds survive month navigation

    self.monthTitle = ko.observable('');
    self.dowNames   = ko.observableArray([]);
    self.weeks      = ko.observableArray([]);
    self.gridDays   = ko.observableArray([]);
    self.gridRows   = ko.observableArray([]);
    self.monthEmpty = ko.observable(false);
    self.kpis       = ko.observable({ today: 0, out: 0, days: 0, peak: 0, peakDate: '' });
    self.rosterOpts = ko.observableArray([]);
    self.typeOpts   = TYPES.map(function (c) { return { code: c, label: i18n.t('tm.vac.type.' + c) }; });

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

    var win = null;          // last built window {calStart, calEnd, mStart, mEnd}

    // ── build the month calendar + grid + KPIs from self.items ─────────
    function build() {
      var mStart = win.mStart, mEnd = win.mEnd;
      // resolve the locale HERE, not at construction — the language observable
      // may settle after the VM is created (Latin digits forced for Arabic)
      var fmtLoc = (i18n.lang && i18n.lang() === 'ar') ? 'ar-AE-u-nu-latn' : 'en';
      self.monthTitle(new Intl.DateTimeFormat(fmtLoc, { month: 'long', year: 'numeric' }).format(mStart));

      var vacs = self.items.map(function (v) {
        return { vac: v, s: d(v.startDate), e: d(v.endDate) };
      }).sort(function (a, b) { return (a.s - b.s) || ((b.e - b.s) - (a.e - a.s)); });

      // weekday header
      var dows = [];
      for (var i = 0; i < 7; i++) {
        dows.push(new Intl.DateTimeFormat(fmtLoc, { weekday: 'short' }).format(addDays(win.calStart, i)));
      }
      self.dowNames(dows);

      // weeks with lane-laid bars
      var todayIso = iso(new Date());
      var weeks = [];
      for (var ws = new Date(win.calStart); ws <= win.calEnd; ws = addDays(ws, 7)) {
        var we = addDays(ws, 6);
        var days = [];
        for (var k = 0; k < 7; k++) {
          var dd = addDays(ws, k);
          days.push({
            num: dd.getDate(), iso: iso(dd),
            inMonth: dd.getMonth() === mStart.getMonth(),
            we: dd.getDay() === 6 || dd.getDay() === 0,
            today: iso(dd) === todayIso
          });
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
          var cls = 'vac-bar vac--' + v.type
                  + (v.status === 'PENDING' ? ' vac-bar--pending' : '')
                  + (x.s < ws ? ' vac-bar--contL' : '') + (x.e > we ? ' vac-bar--contR' : '');
          bars.push({
            vac: v, cls: cls, label: v.memberName,
            tip: v.memberName + ' • ' + i18n.t('tm.vac.type.' + v.type) + ' • '
               + v.startDate + ' → ' + v.endDate + ' (' + i18n.t('tm.vac.status.' + v.status) + ')',
            style: 'inset-inline-start:calc(' + (s0 / 7 * 100) + '% + 2px);'
                 + 'width:calc(' + ((e0 - s0 + 1) / 7 * 100) + '% - 5px);'
                 + 'top:' + (lane * LANE_H) + 'px'
          });
        });
        weeks.push({ days: days, bars: bars,
                     minH: Math.max(96, BARS_TOP + lanes.length * LANE_H + 6) });
      }
      self.weeks(weeks);

      // team grid matrix
      var dim = mEnd.getDate();
      var gDays = [];
      for (var n = 1; n <= dim; n++) {
        var gd = new Date(mStart.getFullYear(), mStart.getMonth(), n);
        gDays.push({ n: n, we: gd.getDay() === 6 || gd.getDay() === 0 });
      }
      self.gridDays(gDays);
      self.gridRows(self.roster.map(function (mem) {
        var mine = vacs.filter(function (x) { return x.vac.userId === mem.userId; });
        var total = 0, cells = [];
        for (var n2 = 1; n2 <= dim; n2++) {
          var cd = new Date(mStart.getFullYear(), mStart.getMonth(), n2);
          var hit = null;
          for (var j = 0; j < mine.length; j++) {
            if (mine[j].s <= cd && mine[j].e >= cd) { hit = mine[j]; break; }
          }
          if (hit) total++;
          cells.push({
            we: gDays[n2 - 1].we,
            t: hit ? hit.vac.type : '', vac: hit ? hit.vac : null,
            barCls: hit ? ('vac-cellbar vac-cell--' + hit.vac.type
                    + (hit.vac.status === 'PENDING' ? ' vac-cellbar--pending' : '')
                    + (diffDays(cd, hit.s) === 0 ? ' vac-cellbar--capL' : '')
                    + (diffDays(hit.e, cd) === 0 ? ' vac-cellbar--capR' : '')) : '',
            tip: hit ? (mem.name + ' • ' + i18n.t('tm.vac.type.' + hit.vac.type)
                 + ' • ' + hit.vac.startDate + ' → ' + hit.vac.endDate) : ''
          });
        }
        var parts = (mem.name || '').split(' ');
        return { name: mem.name, cells: cells, total: total,
                 initials: (parts.length >= 2 ? parts[0][0] + parts[parts.length - 1][0]
                                              : (parts[0] || '?')[0]).toUpperCase() };
      }));

      // KPIs over the anchor month
      var inMonth = vacs.filter(function (x) { return x.s <= mEnd && x.e >= mStart; });
      var today = d(todayIso);
      var uToday = {}, uOut = {}, days = 0, peak = 0, peakD = null;
      inMonth.forEach(function (x) {
        uOut[x.vac.userId] = 1;
        if (x.s <= today && x.e >= today && x.vac.status === 'APPROVED') uToday[x.vac.userId] = 1;
        days += diffDays(x.e < mEnd ? x.e : mEnd, x.s > mStart ? x.s : mStart) + 1;
      });
      for (var dd2 = new Date(mStart); dd2 <= mEnd; dd2 = addDays(dd2, 1)) {
        var c = 0;
        inMonth.forEach(function (x) { if (x.s <= dd2 && x.e >= dd2) c++; });
        if (c > peak) { peak = c; peakD = new Date(dd2); }
      }
      self.kpis({
        today: Object.keys(uToday).length, out: Object.keys(uOut).length, days: days, peak: peak,
        peakDate: peakD ? new Intl.DateTimeFormat(fmtLoc, { day: 'numeric', month: 'short' }).format(peakD) : ''
      });
      self.monthEmpty(inMonth.length === 0);
      self.rosterOpts(self.roster);
    }

    // ── data loading ────────────────────────────────────────────────────
    self.load = function () {
      self.loading(true);
      var a = self.anchor();
      var mStart = a, mEnd = new Date(a.getFullYear(), a.getMonth() + 1, 0);
      var calStart = addDays(mStart, -monIdx(mStart));
      var calEnd = addDays(mEnd, 6 - monIdx(mEnd));
      win = { calStart: calStart, calEnd: calEnd, mStart: mStart, mEnd: mEnd };
      var mp = self.teamId()
        ? tm.listMembers(self.teamId()).then(function (r) {
            return (r.items || []).map(function (m) { return { userId: m.userId, name: m.name }; });
          }).catch(function () { return []; })
        : Promise.resolve([]);
      mp.then(function (members) {
        return vacSvc.getVacations({ teamId: self.teamId(), from: iso(calStart), to: iso(calEnd), members: members });
      }).then(function (res) {
        self.sample(res.sample);
        self.roster = res.roster || [];
        self.items = (res.items || []).concat(localAdds.filter(function (v) {
          return v.startDate <= iso(calEnd) && v.endDate >= iso(calStart);
        }));
        build();
        self.loading(false);
      });
    };

    self.prevMonth = function () { var a = self.anchor(); self.anchor(new Date(a.getFullYear(), a.getMonth() - 1, 1)); self.load(); };
    self.nextMonth = function () { var a = self.anchor(); self.anchor(new Date(a.getFullYear(), a.getMonth() + 1, 1)); self.load(); };
    self.goToday   = function () { var n = new Date(); self.anchor(new Date(n.getFullYear(), n.getMonth(), 1)); self.load(); };
    self.setView   = function (v) { self.view(v); };

    self.dayClass = function (day) {
      return 'vac-day' + (day.inMonth ? '' : ' vac-day--out') + (day.we ? ' vac-day--we' : '')
           + (day.today ? ' vac-day--today' : '');
    };
    self.cellClass = function (cell) { return 'vac-g-cell' + (cell.we ? ' vac-g-we' : ''); };

    // ── detail modal ────────────────────────────────────────────────────
    self.openVac  = function (v) { self.selVac(v); };
    self.closeVac = function () { self.selVac(null); };
    self.vacDays  = function (v) { return diffDays(d(v.endDate), d(v.startDate)) + 1; };

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
    self.openAdd  = function () { resetForm(''); self.formOpen(true); };
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
                   type: self.fmType(), status: 'PENDING',
                   startDate: f, endDate: t2, notes: self.fmNotes() };
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
