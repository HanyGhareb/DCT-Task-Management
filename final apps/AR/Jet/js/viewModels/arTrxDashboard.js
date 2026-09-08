/**
 * arTrxDashboard.js — AR Transactions dashboard (App 206).
 * Executive analytics over the Fusion-loaded AR transaction views, modeled on
 * the AP dashboard (App 212): facet rail + KPI band + 8 Chart.js charts +
 * two-level register (transactions / lines) + drill window + chart drill
 * drawer + print report. Data layer: services/arTrxService (AR/db/12).
 * The build-bar loader (segmented progress + spinner) tracks the three page
 * loads (filters / analytics / register) while the dashboard assembles.
 */
define(['knockout', 'services/arTrxService', 'services/api', 'services/authService',
        'shared/i18n', 'shared/toast', 'shared/chartLoader'],
function (ko, svc, api, authService, i18n, toast, charts) {
  'use strict';

  var AG_ORDER = ['CUR', 'L1M', 'M1_3', 'M3_6', 'M6P'];
  var ST_COLORS = { OPEN: '#fab219', SETTLED: '#0ca30c', CREDIT: '#2C6CB0' };

  // Register column catalog per level. hide = off by default (column chooser
  // re-enables); badge renders status pills; clip = ellipsis + hover title;
  // titleKey = companion field as cell tooltip; sort = server sort key.
  var COLS = {
    trx: [
      { key: 'trxNumber',    labelKey: 'tbl.trxNo' },
      { key: 'trxDate',      labelKey: 'tbl.date', sort: 'date' },
      { key: 'dueDate',      labelKey: 'tbl.dueDate', hide: true },
      { key: 'customer',     labelKey: 'tbl.customer', sort: 'customer', clip: true },
      { key: 'businessUnit', labelKey: 'f.bu', hide: true, clip: true },
      { key: 'trxType',      labelKey: 'tbl.type', clip: true },
      { key: 'source',       labelKey: 'tbl.source', hide: true },
      { key: 'complete',     labelKey: 'tbl.complete', hide: true },
      { key: 'terms',        labelKey: 'tbl.terms', hide: true },
      { key: 'enteredAed',   labelKey: 'tbl.invoiced', amt: true, sort: 'amount' },
      { key: 'appliedAed',   labelKey: 'tbl.applied', amt: true },
      { key: 'adjAed',       labelKey: 'tbl.adj', amt: true, hide: true },
      { key: 'creditAed',    labelKey: 'tbl.credits', amt: true, hide: true },
      { key: 'remainingAed', labelKey: 'tbl.remaining', amt: true, sort: 'balance' },
      { key: 'status',       labelKey: 'tbl.status', badge: 'st' },
      { key: 'aging',        labelKey: 'tbl.aging', badge: 'ag' },
      { key: 'delayDays',    labelKey: 'tbl.dpd', sort: 'delay' },
      { key: 'createdBy',    labelKey: 'tbl.createdBy', hide: true },
    ],
    line: [
      { key: 'trxNumber',      labelKey: 'tbl.trxNo' },
      { key: 'lineNumber',     labelKey: 'tbl.line' },
      { key: 'trxDate',        labelKey: 'tbl.date', sort: 'date' },
      { key: 'glDate',         labelKey: 'tbl.glDate', sort: 'gldate', hide: true },
      { key: 'customer',       labelKey: 'tbl.customer', sort: 'customer', clip: true },
      { key: 'customerType',   labelKey: 'tbl.custType', hide: true },
      { key: 'businessUnit',   labelKey: 'f.bu', hide: true, clip: true },
      { key: 'trxType',        labelKey: 'tbl.type', hide: true, clip: true },
      { key: 'source',         labelKey: 'tbl.source', hide: true },
      { key: 'memoLine',       labelKey: 'tbl.memoLine', clip: true, titleKey: 'memoDesc' },
      { key: 'description',    labelKey: 'tbl.description', clip: true },
      { key: 'projectNumber',  labelKey: 'tbl.project', titleKey: 'projectName' },
      { key: 'taskNumber',     labelKey: 'tbl.task', hide: true, titleKey: 'taskName' },
      { key: 'revenueAed',     labelKey: 'tbl.revenue', amt: true, sort: 'amount' },
      { key: 'taxAed',         labelKey: 'tbl.tax', amt: true },
      { key: 'costCenterCode', labelKey: 'tbl.cc', titleKey: 'costCenterDesc' },
      { key: 'accountCode',    labelKey: 'tbl.account', titleKey: 'accountDesc' },
      { key: 'glAccount',      labelKey: 'tbl.glAccount', hide: true, clip: true },
      { key: 'receivablesAccount', labelKey: 'tbl.recvAccount', hide: true, clip: true },
      { key: 'taxClass',       labelKey: 'tbl.taxClass', hide: true },
      { key: 'createdBy',      labelKey: 'tbl.createdBy', hide: true },
    ]
  };

  // facet groups: counted = checkbox list w/ counts, searchable = mini filter,
  // coded = {code,name} pairs (value=code, label=code — name), i18nPrefix =
  // the LOV values are codes translated through i18n (settlement / aging).
  var GROUP_DEFS = [
    { key: 'status',   labelKey: 'f.status',   src: 'status',        counted: true, open: true, i18nPrefix: 'st.' },
    { key: 'aging',    labelKey: 'f.aging',    src: 'aging',         counted: true, open: true, i18nPrefix: 'ag.' },
    { key: 'bu',       labelKey: 'f.bu',       src: 'businessUnits', counted: true },
    { key: 'ttype',    labelKey: 'f.type',     src: 'types',         counted: true, searchable: true },
    { key: 'source',   labelKey: 'f.source',   src: 'sources',       counted: true },
    { key: 'terms',    labelKey: 'f.terms',    src: 'terms',         counted: true, searchable: true },
    { key: 'complete', labelKey: 'f.complete', src: 'complete',      counted: true },
    { key: 'ctype',    labelKey: 'f.ctype',    src: 'custTypes',     counted: true },
    { key: 'customer', labelKey: 'f.customer', src: 'customers',     searchable: true },
    { key: 'memo',     labelKey: 'f.memo',     src: 'memoLines',     searchable: true },
    { key: 'project',  labelKey: 'f.project',  src: 'projects',      searchable: true, coded: true },
    { key: 'cc',       labelKey: 'f.cc',       src: 'costCenters',   searchable: true, coded: true },
    { key: 'account',  labelKey: 'f.account',  src: 'accounts',      searchable: true, coded: true },
  ];

  function TrxDashboardViewModel() {
    var self = this;
    var _t = i18n.t;
    self.t = _t;
    var FP = 'ar-transactions-';                       // export file prefix

    // chart palette follows the LIVE brand (shell overrides --brand at boot
    // from the THEME_BRAND_COLOR module setting) — never hard-code a hue
    var cssv = getComputedStyle(document.documentElement);
    var BRAND = (cssv.getPropertyValue('--brand') || '').trim() || '#6C4AB6';
    var BRAND_MID = charts.alpha(BRAND, 0.72);
    // aging ramp — single-hue ordinal steps, light -> dark
    var RAMP = [charts.alpha(BRAND, 0.25), charts.alpha(BRAND, 0.45),
                charts.alpha(BRAND, 0.62), charts.alpha(BRAND, 0.80), BRAND];

    // ── state ───────────────────────────────────────────────────────────
    self.level   = ko.observable('trx');               // trx | line
    self.groups  = ko.observableArray([]);
    self.datefrom = ko.observable('');
    self.dateto   = ko.observable('');
    self.duefrom  = ko.observable('');
    self.dueto    = ko.observable('');
    self.gldatefrom = ko.observable('');
    self.gldateto   = ko.observable('');
    self.search = ko.observable('');

    self.loadingFilters = ko.observable(true);
    self.loadingSummary = ko.observable(true);
    self.loadingRows    = ko.observable(true);

    // build-bar loader: overlay while the dashboard assembles; the bar fills
    // one segment per finished load (filters / analytics / register)
    self.buildLoading = ko.computed(function () {
      return self.loadingFilters() || self.loadingSummary();
    });
    self.buildPct = ko.computed(function () {
      var done = (self.loadingFilters() ? 0 : 1) + (self.loadingSummary() ? 0 : 1)
               + (self.loadingRows() ? 0 : 1);
      return Math.round(100 * done / 3);
    });

    self.kpis      = ko.observable(null);
    self.rows      = ko.observableArray([]);
    self.total     = ko.observable(0);
    self.rowTotals = ko.observable(null);
    self.limit     = ko.observable(25);
    self.offset    = ko.observable(0);
    self.sortKey   = ko.observable('date');
    self.sortDir   = ko.observable('desc');

    self.chartsCollapsed = ko.observable(false);
    self.tableCollapsed  = ko.observable(false);
    self.chartsMax = ko.observable(false);
    self.tableMax  = ko.observable(false);

    self.showDrill = ko.observable(false);
    self.drill     = ko.observable(null);

    self._charts = {};
    self._lastSummary = null;

    // ── register columns: show/hide per user ────────────────────────────
    var COLS_PREF = 'ar.trxdash.cols';                 // server pref (follows the user)
    var COLS_LS   = 'ifinance.ar.trxcols';             // instant local autosave
    function hiddenDefaults(level) {
      return COLS[level].filter(function (c) { return c.hide; }).map(function (c) { return c.key; });
    }
    self._hidden = {
      trx:  ko.observableArray(hiddenDefaults('trx')),
      line: ko.observableArray(hiddenDefaults('line')),
    };
    self.colsOpen = ko.observable(false);
    self.toggleColsPanel = function () { self.colsOpen(!self.colsOpen()); };
    self.levelCols   = ko.computed(function () { return COLS[self.level()]; });
    self.visibleCols = ko.computed(function () {
      var hidden = self._hidden[self.level()]();
      return COLS[self.level()].filter(function (c) { return hidden.indexOf(c.key) === -1; });
    });
    self.isColOn = function (col) {
      return self._hidden[self.level()]().indexOf(col.key) === -1;
    };
    function applyColPrefs(obj) {
      ['trx', 'line'].forEach(function (lvl) {
        if (obj && Array.isArray(obj[lvl])) self._hidden[lvl](obj[lvl]);
      });
    }
    var colsSaveTimer = null;
    function persistCols() {
      var obj = { trx: self._hidden.trx(), line: self._hidden.line() };
      try { localStorage.setItem(COLS_LS, JSON.stringify(obj)); } catch (e) {}
      clearTimeout(colsSaveTimer);
      colsSaveTimer = setTimeout(function () {
        api.put('/prefs/' + COLS_PREF, { value: JSON.stringify(obj) }, { base: 'auth', silent: true })
          .catch(function () {});
      }, 800);
    }
    self.toggleCol = function (col) {
      var hidden = self._hidden[self.level()];
      var i = hidden.indexOf(col.key);
      if (i === -1) {
        if (self.visibleCols().length <= 1) return;    // never hide the last column
        hidden.push(col.key);
      } else {
        hidden.splice(i, 1);
      }
      persistCols();
    };
    self.showAllCols = function () { self._hidden[self.level()]([]); persistCols(); };
    self.resetCols = function () { self._hidden[self.level()](hiddenDefaults(self.level())); persistCols(); };
    // local autosave first (instant), then the server pref wins (roams w/ user)
    try { applyColPrefs(JSON.parse(localStorage.getItem(COLS_LS) || 'null')); } catch (e) {}
    api.get('/prefs/', { base: 'auth', silent: true }).then(function (d) {
      var hit = ((d && d.items) || []).filter(function (p) { return p.key === COLS_PREF; })[0];
      if (hit && hit.value) { try { applyColPrefs(JSON.parse(hit.value)); } catch (e) {} }
    }).catch(function () {});

    // ── formatting + badge helpers ──────────────────────────────────────
    self.fmtAmt = function (n) {
      if (n === null || n === undefined || n === '') return '';
      return Number(n).toLocaleString('en-AE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    };
    self.fmtInt = function (n) {
      if (n === null || n === undefined || n === '') return '';
      return Number(n).toLocaleString('en-AE', { maximumFractionDigits: 0 });
    };
    self.fmtCompact = function (n) {
      return new Intl.NumberFormat('en-AE', { notation: 'compact', maximumFractionDigits: 2 }).format(n || 0);
    };
    function trunc(s, n) { s = s || ''; return s.length > n ? s.slice(0, n - 1) + '…' : s; }

    // status / aging come from the server as CODES — translate via i18n
    self.badgeText = function (type, val) {
      if (!val) return '';
      return _t((type === 'st' ? 'st.' : 'ag.') + val);
    };
    self.badgeCls = function (type, val) {
      if (!val) return 'badge badge--idle';
      if (type === 'st') {
        if (val === 'SETTLED') return 'badge badge--success';
        if (val === 'CREDIT') return 'badge badge--info';
        return 'badge badge--warn';                    // OPEN
      }
      if (val === 'CUR' || val === 'L1M') return 'badge badge--warn';
      return 'badge badge--danger';                    // 1m+
    };
    self.cellVal = function (row, col) {
      var v = row[col.key];
      if (v === null || v === undefined) return '';
      return col.amt ? self.fmtAmt(v) : v;
    };
    self.cellTitle = function (row, col) {
      if (col.titleKey) return row[col.titleKey] || '';
      if (col.clip) return row[col.key] || '';
      return '';
    };

    // ── facet groups ────────────────────────────────────────────────────
    function makeGroup(def, raw) {
      var items = (raw || []).map(function (r) {
        if (def.coded)   return { value: r.code, label: r.code + ' — ' + (r.name || ''), count: null, checked: ko.observable(false) };
        if (def.counted) {
          var lab = def.i18nPrefix ? _t(def.i18nPrefix + r.name) : (r.name || '(None)');
          return { value: r.name, label: lab, count: r.count, checked: ko.observable(false) };
        }
        return { value: r, label: r, count: null, checked: ko.observable(false) };
      });
      var g = {
        key: def.key, labelKey: def.labelKey, searchable: !!def.searchable,
        items: ko.observableArray(items),
        filter: ko.observable(''),
        open: ko.observable(!!def.open),
      };
      g.visible = ko.computed(function () {
        var f = (g.filter() || '').toLowerCase();
        var arr = g.items();
        if (f) arr = arr.filter(function (i) { return (i.label || '').toLowerCase().indexOf(f) >= 0; });
        var sel = arr.filter(function (i) { return i.checked(); });
        var rest = arr.filter(function (i) { return !i.checked(); });
        return sel.concat(rest).slice(0, 100);
      });
      g.selCount = ko.computed(function () {
        return g.items().filter(function (i) { return i.checked(); }).length;
      });
      return g;
    }

    self.toggleGroup = function (g) { g.open(!g.open()); };
    self.toggleItem = function (g, item) { item.checked(!item.checked()); scheduleReload(); };

    // ── params + chips ──────────────────────────────────────────────────
    function buildParams() {
      var p = {};
      self.groups().forEach(function (g) {
        var sel = g.items().filter(function (i) { return i.checked(); })
                           .map(function (i) { return i.value; });
        if (sel.length) p[g.key] = sel.join('|');
      });
      if (self.datefrom())   p.datefrom = self.datefrom();
      if (self.dateto())     p.dateto   = self.dateto();
      if (self.duefrom())    p.duefrom  = self.duefrom();
      if (self.dueto())      p.dueto    = self.dueto();
      if (self.gldatefrom()) p.glfrom   = self.gldatefrom();
      if (self.gldateto())   p.glto     = self.gldateto();
      if ((self.search() || '').trim()) p.search = self.search().trim();
      return p;
    }
    self.buildParams = buildParams;

    self.chips = ko.computed(function () {
      var out = [];
      self.groups().forEach(function (g) {
        g.items().forEach(function (i) {
          if (i.checked()) {
            out.push({ label: _t(g.labelKey), value: trunc(i.label, 34),
                       clear: function () { i.checked(false); scheduleReload(); } });
          }
        });
      });
      function add(obs, key) {
        if ((obs() || '') !== '') {
          out.push({ label: _t(key), value: obs(),
                     clear: function () { obs(''); scheduleReload(); } });
        }
      }
      add(self.datefrom, 'f.datefrom'); add(self.dateto, 'f.dateto');
      add(self.duefrom, 'f.duefrom'); add(self.dueto, 'f.dueto');
      add(self.gldatefrom, 'f.glfrom'); add(self.gldateto, 'f.glto');
      add(self.search, 'f.searchLbl');
      return out;
    });

    self.resetFilters = function () {
      self.groups().forEach(function (g) {
        g.items().forEach(function (i) { i.checked(false); });
        g.filter('');
      });
      self.datefrom(''); self.dateto('');
      self.duefrom(''); self.dueto('');
      self.gldatefrom(''); self.gldateto('');
      self.search('');
      scheduleReload();
    };

    // ── loading ─────────────────────────────────────────────────────────
    var reloadTimer = null;
    function scheduleReload() {
      clearTimeout(reloadTimer);
      reloadTimer = setTimeout(function () {
        self.offset(0);
        loadSummary(); loadRows();
      }, 400);
    }

    function loadSummary() {
      self.loadingSummary(true);
      svc.getSummary(buildParams()).then(function (d) {
        self._lastSummary = d;
        self.kpis(d.kpis || null);
        self.loadingSummary(false);
        setTimeout(function () { renderCharts(d); }, 0);
      }).catch(function () { self.loadingSummary(false); toast.error(_t('msg.error')); });
    }

    function sortParam() { return self.sortKey() + '_' + self.sortDir(); }

    function loadRows() {
      self.loadingRows(true);
      var p = Object.assign({}, buildParams(),
        { limit: self.limit(), offset: self.offset(), sort: sortParam() });
      svc.getRows(self.level(), p).then(function (d) {
        self.rows(d.items || []);
        self.total(d.total || 0);
        self.rowTotals(d.totals || null);
        self.loadingRows(false);
      }).catch(function () { self.loadingRows(false); toast.error(_t('msg.error')); });
    }
    self.reloadRows = loadRows;

    self.refresh = function () { loadSummary(); loadRows(); };

    self.setLevel = function (lvl) {
      if (self.level() === lvl) return;
      self.level(lvl);
      self.offset(0);
      self.sortKey('date'); self.sortDir('desc');
      loadRows();
    };

    self.sortBy = function (key) {
      if (self.sortKey() === key) {
        self.sortDir(self.sortDir() === 'desc' ? 'asc' : 'desc');
      } else {
        self.sortKey(key);
        self.sortDir(key === 'customer' ? 'asc' : 'desc');
      }
      self.offset(0);
      loadRows();
    };
    self.sortArrow = function (key) {
      if (self.sortKey() !== key) return '';
      return self.sortDir() === 'desc' ? '▼' : '▲';
    };

    // ── charts ──────────────────────────────────────────────────────────
    function destroyCharts() {
      Object.keys(self._charts).forEach(function (k) {
        try { self._charts[k].destroy(); } catch (e) {}
      });
      self._charts = {};
    }

    function mk(id, cfg) {
      var c = document.getElementById(id);
      if (c) self._charts[id] = charts.makeChart(c, cfg);
    }

    function compactTicks(axis) {
      var o = {}; o[axis] = { ticks: { callback: function (v) { return self.fmtCompact(v); } } };
      return o;
    }

    function pickIdx(rows, onPick) {
      if (!onPick) return undefined;
      return function (evt, els) {
        if (els && els.length && rows[els[0].index] !== undefined) onPick(rows[els[0].index], els[0].index);
      };
    }

    function pctOf(part, whole) {
      if (!whole || !isFinite(part / whole)) return '';
      return (100 * part / whole).toLocaleString('en-AE', { maximumFractionDigits: 1 }) + '%';
    }

    // branded Chart.js data tooltip: white card, brand border/title, labeled rows
    function tipOpts(cbs) {
      return Object.assign({
        backgroundColor: '#ffffff',
        titleColor: BRAND,
        bodyColor: '#3a4553',
        footerColor: '#8a93a3',
        borderColor: BRAND,
        borderWidth: 1.2,
        cornerRadius: 10,
        padding: 12,
        caretSize: 7,
        displayColors: false,
        titleFont: { weight: 'bold', size: 12.5 },
        bodyFont: { size: 12 },
        footerFont: { size: 10.5, style: 'italic' },
        titleMarginBottom: 8,
        footerMarginTop: 8,
        bodySpacing: 5,
      }, { callbacks: cbs });
    }
    function tipFooter() { return _t('ht.clickList'); }

    function hbar(id, rows, color, amtKey, onPick) {
      rows = rows || [];
      mk(id, {
        type: 'bar',
        data: {
          labels: rows.map(function (r) { return trunc(r.name || '(None)', 26); }),
          datasets: [{ data: rows.map(function (r) { return r[amtKey || 'amount']; }),
                       backgroundColor: color, borderRadius: 4, maxBarThickness: 16 }]
        },
        options: {
          indexAxis: 'y',
          onClick: pickIdx(rows, onPick),
          plugins: {
            legend: { display: false },
            tooltip: tipOpts({
              title: function (items) { return (rows[items[0].dataIndex] || {}).name || '(None)'; },
              label: function (ctx) {
                var r = rows[ctx.dataIndex] || {};
                var k = self.kpis() || {};
                return [
                  _t('ht.amount') + ':  ' + self.fmtAmt(r[amtKey || 'amount']),
                  _t('kpi.transactions') + ':  ' + self.fmtInt(r.count),
                  _t('ht.share') + ':  ' + (pctOf(r[amtKey || 'amount'], amtKey === 'amount' && id === 'arChartCust' ? k.outstandingAed : k.invoicedAed) || '0%')
                ];
              },
              footer: onPick ? tipFooter : undefined
            })
          },
          scales: compactTicks('x')
        }
      });
    }

    function renderCharts(d) {
      if (!d || self.chartsCollapsed()) return;
      destroyCharts();

      // Outstanding by aging — ordinal single-hue ramp over the ordered buckets
      var byB = {}, agTot = 0;
      (d.aging || []).forEach(function (a) { byB[a.bucket] = a; agTot += a.amount || 0; });
      mk('arChartAging', {
        type: 'bar',
        data: {
          labels: AG_ORDER.map(function (b) { return _t('ag.' + b); }),
          datasets: [{ data: AG_ORDER.map(function (b) { return byB[b] ? byB[b].amount : 0; }),
                       backgroundColor: RAMP, borderRadius: 4, maxBarThickness: 48 }]
        },
        options: {
          onClick: pickIdx(AG_ORDER, function (bucket) {
            openChartDrill('ch.aging', _t('ag.' + bucket), { aging: bucket }, 'balance_desc');
          }),
          plugins: {
            legend: { display: false },
            tooltip: tipOpts({
              title: function (items) { return _t('ag.' + AG_ORDER[items[0].dataIndex]); },
              label: function (ctx) {
                var b = byB[AG_ORDER[ctx.dataIndex]] || { count: 0, amount: 0 };
                return [
                  _t('tbl.remaining') + ':  ' + self.fmtAmt(b.amount || 0),
                  _t('kpi.transactions') + ':  ' + self.fmtInt(b.count),
                  _t('ht.share') + ':  ' + (pctOf(b.amount || 0, agTot) || '0%')
                ];
              },
              footer: tipFooter
            })
          },
          scales: compactTicks('y')
        }
      });

      // Settlement — status colors, labelled legend
      var st = d.settlement || [];
      mk('arChartSettle', {
        type: 'doughnut',
        data: {
          labels: st.map(function (r) { return _t('st.' + r.name); }),
          datasets: [{ data: st.map(function (r) { return r.count; }),
                       backgroundColor: st.map(function (r) { return ST_COLORS[r.name] || '#9aa3b0'; }),
                       borderColor: '#fff', borderWidth: 2 }]
        },
        options: {
          cutout: '62%',
          onClick: pickIdx(st, function (r) {
            openChartDrill('ch.settlement', _t('st.' + r.name), { status: r.name });
          }),
          plugins: {
            legend: { position: 'bottom' },
            tooltip: tipOpts({
              title: function (items) { return _t('st.' + ((st[items[0].dataIndex] || {}).name || '')); },
              label: function (ctx) {
                var r = st[ctx.dataIndex] || {};
                var totC = st.reduce(function (a, x) { return a + (x.count || 0); }, 0);
                return [
                  _t('kpi.transactions') + ':  ' + self.fmtInt(r.count),
                  _t('tbl.invoiced') + ':  ' + self.fmtAmt(r.amount),
                  _t('ht.share') + ':  ' + (pctOf(r.count, totC) || '0%')
                ];
              },
              footer: tipFooter
            })
          }
        }
      });

      // Monthly invoiced trend — single series
      var tr2 = d.trend || [];
      mk('arChartTrend', {
        type: 'line',
        data: {
          labels: tr2.map(function (r) { return r.month; }),
          datasets: [{ data: tr2.map(function (r) { return r.amount; }),
                       borderColor: BRAND, backgroundColor: charts.alpha(BRAND, 0.10),
                       fill: true, tension: 0.3, pointRadius: 2.5, borderWidth: 2 }]
        },
        options: {
          onClick: pickIdx(tr2, function (r) {
            var p = (r.month || '').split('-');
            if (p.length !== 2) return;
            var last = new Date(Date.UTC(+p[0], +p[1], 0)).getUTCDate();
            openChartDrill('ch.trend', r.month,
              { datefrom: r.month + '-01', dateto: r.month + '-' + ('0' + last).slice(-2) });
          }),
          plugins: {
            legend: { display: false },
            tooltip: tipOpts({
              label: function (ctx) {
                var r = tr2[ctx.dataIndex] || {};
                return [
                  _t('tbl.invoiced') + ':  ' + self.fmtAmt(r.amount),
                  _t('kpi.transactions') + ':  ' + self.fmtInt(r.count)
                ];
              },
              footer: tipFooter
            })
          },
          scales: compactTicks('y')
        }
      });

      hbar('arChartCust', d.topCustomers, BRAND, 'amount',
        function (r) { openChartDrill('ch.topCustomers', r.name, { customer: r.name }, 'balance_desc'); });
      hbar('arChartType', d.byType, BRAND_MID, 'amount',
        function (r) { openChartDrill('ch.byType', r.name, { ttype: r.name }); });
      hbar('arChartSource', d.bySource, BRAND, 'amount',
        function (r) { openChartDrill('ch.bySource', r.name, { source: r.name }); });
      hbar('arChartBu', d.byBu, BRAND_MID, 'amount',
        function (r) { openChartDrill('ch.byBu', r.name, { bu: r.name }); });
      // revenue by cost center is line-grain — informational, no drill
      hbar('arChartCc', d.byCostCenter, BRAND, 'amount', null);
    }

    // ── region controls ─────────────────────────────────────────────────
    self.toggleCharts = function () {
      var next = !self.chartsCollapsed();
      self.chartsCollapsed(next);
      if (!next) setTimeout(function () { renderCharts(self._lastSummary); }, 0);
    };
    self.toggleTable = function () { self.tableCollapsed(!self.tableCollapsed()); };
    self.toggleChartsMax = function () {
      self.chartsMax(!self.chartsMax());
      setTimeout(function () { Object.keys(self._charts).forEach(function (k) { try { self._charts[k].resize(); } catch (e) {} }); }, 60);
    };
    self.toggleTableMax = function () { self.tableMax(!self.tableMax()); };

    // ── exports ─────────────────────────────────────────────────────────
    function today() { return new Date().toISOString().slice(0, 10); }
    function downloadBlobUrl(url, name) {
      var a = document.createElement('a');
      a.href = url; a.download = name;
      document.body.appendChild(a); a.click(); a.remove();
      setTimeout(function () { try { URL.revokeObjectURL(url); } catch (e) {} }, 20000);
    }

    self.exportCsv = function () {
      toast.info(_t('msg.exportStarted'));
      svc.getExportBlobUrl(self.level(), buildParams()).then(function (url) {
        downloadBlobUrl(url, FP + self.level() + '-' + today() + '.csv');
      }).catch(function () { toast.error(_t('msg.error')); });
    };

    self.exportXlsx = function () {
      toast.info(_t('msg.exportStarted'));
      svc.getExportCsvText(self.level(), buildParams()).then(function (csv) {
        require(['xlsx'], function (X) {
          var wb = X.read(csv, { type: 'string' });
          X.writeFile(wb, FP + self.level() + '-' + today() + '.xlsx');
        });
      }).catch(function () { toast.error(_t('msg.error')); });
    };

    self.exportSummaryCsv = function () {
      var d = self._lastSummary;
      if (!d) return;
      var L = ['﻿AR Transactions Analytics — ' + today()];
      var k = d.kpis || {};
      L.push('');
      L.push('KPI,Value');
      ['transactions', 'customers', 'invoicedAed', 'appliedAed', 'creditAdjAed',
       'outstandingAed', 'overdueAed', 'collectionRate', 'avgDelayDays']
        .forEach(function (key) { L.push(key + ',' + (k[key] != null ? k[key] : '')); });
      function section(title, rows, amtKey) {
        L.push(''); L.push(title + ',Count,Amount AED');
        (rows || []).forEach(function (r) {
          L.push('"' + String(r.name || '').replace(/"/g, '""') + '",' + (r.count || 0) + ',' + (r[amtKey || 'amount'] || 0));
        });
      }
      L.push(''); L.push('Aging bucket,Count,Remaining AED');
      (d.aging || []).forEach(function (r) { L.push(r.bucket + ',' + r.count + ',' + r.amount); });
      section('Settlement', d.settlement);
      L.push(''); L.push('Month,Count,Invoiced AED');
      (d.trend || []).forEach(function (r) { L.push(r.month + ',' + r.count + ',' + r.amount); });
      section('Top customers (outstanding)', d.topCustomers);
      section('Transaction type', d.byType);
      section('Source', d.bySource);
      section('Business unit', d.byBu);
      section('Cost center (revenue)', d.byCostCenter);
      var blob = new Blob([L.join('\r\n')], { type: 'text/csv;charset=utf-8' });
      downloadBlobUrl(URL.createObjectURL(blob), FP + 'analytics-' + today() + '.csv');
    };

    self.exportChartsPng = function () {
      var ids = Object.keys(self._charts);
      if (!ids.length) return;
      var W = 1000, pad = 24, y = pad;
      var parts = ids.map(function (id) {
        var c = self._charts[id].canvas;
        var h = Math.round((W - pad * 2) * c.height / c.width);
        return { c: c, h: h };
      });
      var H = parts.reduce(function (a, p) { return a + p.h + pad; }, pad);
      var cvs = document.createElement('canvas');
      cvs.width = W; cvs.height = H;
      var ctx = cvs.getContext('2d');
      ctx.fillStyle = '#ffffff'; ctx.fillRect(0, 0, W, H);
      parts.forEach(function (p) {
        ctx.drawImage(p.c, pad, y, W - pad * 2, p.h);
        y += p.h + pad;
      });
      cvs.toBlob(function (b) {
        downloadBlobUrl(URL.createObjectURL(b), FP + 'charts-' + today() + '.png');
      });
    };

    // ── drill (transaction window: master + summary card + lines) ───────
    self.invMax = ko.observable(false);
    self.toggleInvMax = function () { self.invMax(!self.invMax()); };
    // extra header fields (customerNumber / customerType / currency) sit at
    // the envelope root, not under header — helper for the master grid
    self.drillX = function (key) {
      var d = self.drill();
      return (d && d[key]) || '';
    };
    self.openDrill = function (row) {
      if (!row || !row.id) return;
      svc.getDetail(row.id).then(function (d) {
        if (!d || !d.header) return;
        d.lines = d.lines || [];
        self.drill(d);
        self.invMax(false);
        self.showDrill(true);
      }).catch(function () { toast.error(_t('msg.error')); });
    };
    self.closeDrill = function () { self.showDrill(false); self.drill(null); self.invMax(false); };

    // ── rich hint popover (ⓘ on charts + regions) ───────────────────────
    var HINT_DEFS = {
      aging:      { t: 'ch.aging',        d: 'ch.aging.hint' },
      settlement: { t: 'ch.settlement',   d: 'ch.settlement.hint' },
      trend:      { t: 'ch.trend',        d: 'ch.trend.hint' },
      customers:  { t: 'ch.topCustomers', d: 'ch.topCustomers.hint' },
      type:       { t: 'ch.byType',       d: 'ch.byType.hint' },
      source:     { t: 'ch.bySource',     d: 'ch.bySource.hint' },
      bu:         { t: 'ch.byBu',         d: 'ch.byBu.hint' },
      cc:         { t: 'ch.byCc',         d: 'ch.byCc.hint' },
      analytics:  { t: 'rg.analytics',    d: 'rg.analytics.hint' },
      register:   { t: 'rg.register',     d: 'rg.register.hint' },
    };
    self.hintShow  = ko.observable(false);
    self.hintX     = ko.observable(0);
    self.hintY     = ko.observable(0);
    self.hintTitle = ko.observable('');
    self.hintDesc  = ko.observable('');
    self.hintRows  = ko.observableArray([]);
    function placeHint(e) {
      var w = 380, x = e.clientX + 16, y = e.clientY + 14;
      if (x + w > window.innerWidth) x = Math.max(12, e.clientX - w - 16);
      if (y + 340 > window.innerHeight) y = Math.max(12, window.innerHeight - 350);
      self.hintX(x); self.hintY(y);
    }
    function maxBy(rows, key) {
      return (rows || []).reduce(function (m, r) {
        return (!m || (r[key] || 0) > (m[key] || 0)) ? r : m;
      }, null);
    }
    function sumBy(rows, key) {
      return (rows || []).reduce(function (a, r) { return a + (r[key] || 0); }, 0);
    }
    function hintStats(key) {
      var d = self._lastSummary || {};
      var k = self.kpis() || {};
      var R = [];
      function add(l, v) { if (v !== '' && v !== null && v !== undefined) R.push({ l: l, v: '' + v }); }
      function nameAmt(r, n) { return trunc(r.name || '(None)', n || 28) + ' — ' + self.fmtAmt(r.amount); }
      if (key === 'aging') {
        var ag = d.aging || [];
        var mx = maxBy(ag, 'amount');
        add(_t('kpi.outstandingAed'), self.fmtAmt(k.outstandingAed));
        add(_t('kpi.overdueAed'), self.fmtAmt(k.overdueAed));
        add(_t('ht.openCnt'), self.fmtInt(k.openCount));
        if (mx) add(_t('ht.largest'), _t('ag.' + mx.bucket) + ' — ' + self.fmtAmt(mx.amount));
      } else if (key === 'settlement') {
        (d.settlement || []).forEach(function (r) {
          add(_t('st.' + r.name) + ' (' + self.fmtInt(r.count) + ')', self.fmtAmt(r.amount));
        });
        add(_t('kpi.collectionRate'), (k.collectionRate || 0) + '%');
      } else if (key === 'trend') {
        var tr2 = d.trend || [];
        var pk = maxBy(tr2, 'amount'), lastM = tr2[tr2.length - 1];
        add(_t('ht.months'), self.fmtInt(tr2.length));
        add(_t('kpi.invoicedAed'), self.fmtAmt(sumBy(tr2, 'amount')));
        if (pk) add(_t('ht.peak'), pk.month + ' — ' + self.fmtAmt(pk.amount));
        if (lastM) add(_t('ht.latest'), lastM.month + ' — ' + self.fmtAmt(lastM.amount));
      } else if (key === 'customers') {
        var tops = d.topCustomers || [];
        add(_t('kpi.customers'), self.fmtInt(k.customers));
        if (tops[0]) add(_t('ht.top'), nameAmt(tops[0]));
        add(_t('ht.topShare'), (pctOf(sumBy(tops, 'amount'), k.outstandingAed) || '0%'));
      } else if (key === 'type' || key === 'source' || key === 'bu' || key === 'cc') {
        var rows2 = key === 'type' ? d.byType : key === 'source' ? d.bySource
                  : key === 'bu' ? d.byBu : d.byCostCenter;
        add(_t('ht.groups'), self.fmtInt((rows2 || []).length));
        if (rows2 && rows2[0]) add(_t('ht.top'), nameAmt(rows2[0], 24));
      } else if (key === 'analytics') {
        add(_t('kpi.transactions'), self.fmtInt(k.transactions));
        add(_t('kpi.customers'), self.fmtInt(k.customers));
        add(_t('kpi.invoicedAed'), self.fmtAmt(k.invoicedAed));
        add(_t('kpi.outstandingAed'), self.fmtAmt(k.outstandingAed));
        add(_t('ht.filters'), self.fmtInt(self.chips().length));
      } else if (key === 'register') {
        add(_t('ht.level'), _t(self.level() === 'trx' ? 'dash.levelTrx' : 'dash.levelLine'));
        add(_t('ht.rows'), self.fmtInt(self.total()));
        add(_t('ht.filters'), self.fmtInt(self.chips().length));
      }
      return R;
    }
    self.hintOver = function (key, e) {
      var def = HINT_DEFS[key];
      if (!def) return true;
      self.hintTitle(_t(def.t));
      self.hintDesc(_t(def.d));
      self.hintRows(hintStats(key));
      placeHint(e); self.hintShow(true); return true;
    };
    self.hintMove = function (key, e) { placeHint(e); return true; };
    self.hintOut  = function () { self.hintShow(false); return true; };

    // ── chart drill-down drawer (right-edge slide-in, AP/GL pattern) ────
    var DW_LIMIT = 500;
    self.dwCols = [
      { key: 'trxNumber',    labelKey: 'tbl.trxNo' },
      { key: 'trxDate',      labelKey: 'tbl.date' },
      { key: 'customer',     labelKey: 'tbl.customer', clip: true },
      { key: 'trxType',      labelKey: 'tbl.type', clip: true },
      { key: 'enteredAed',   labelKey: 'tbl.invoiced', amt: true },
      { key: 'appliedAed',   labelKey: 'tbl.applied', amt: true },
      { key: 'remainingAed', labelKey: 'tbl.remaining', amt: true },
      { key: 'status',       labelKey: 'tbl.status', badge: 'st' },
      { key: 'aging',        labelKey: 'tbl.aging', badge: 'ag' },
      { key: 'delayDays',    labelKey: 'tbl.dpd' },
    ];
    self.dwOpen    = ko.observable(false);
    self.dwMax     = ko.observable(false);
    self.dwLoading = ko.observable(false);
    self.dwTitle   = ko.observable('');
    self.dwEyebrow = ko.observable('');
    self.dwCtx     = ko.observable('');
    self.dwRows    = ko.observableArray([]);
    self.dwTotal   = ko.observable(0);
    self.dwInvoiced  = ko.observable(0);   // AED totals over ALL matches — reconcile
    self.dwRemaining = ko.observable(0);   // to the clicked chart figure
    self.dwCapNote = ko.computed(function () {
      var t = self.dwTotal(), n = self.dwRows().length;
      return t > n
        ? _t('dw.showing').replace('{n}', self.fmtInt(n)).replace('{c}', self.fmtInt(t)) : '';
    });
    function openChartDrill(chartKey, segment, extra, sort) {
      self.dwTitle(segment);
      self.dwEyebrow(_t(chartKey));
      self.dwCtx(self.chips().map(function (c) { return c.label + ': ' + c.value; }).join('   ·   '));
      self.dwRows([]); self.dwTotal(0); self.dwInvoiced(0); self.dwRemaining(0);
      self.dwOpen(true); self.dwLoading(true);
      var p = Object.assign({}, buildParams(), extra,
        { limit: DW_LIMIT, offset: 0, sort: sort || 'amount_desc' });
      svc.getRows('trx', p).then(function (d) {
        self.dwRows(d.items || []);
        self.dwTotal(d.total || 0);
        self.dwInvoiced((d.totals || {}).invoicedAed || 0);
        self.dwRemaining((d.totals || {}).remainingAed || 0);
        self.dwLoading(false);
      }).catch(function () {
        self.dwLoading(false); self.dwOpen(false); toast.error(_t('msg.error'));
      });
    }
    self.closeDw    = function () { self.dwOpen(false); self.dwMax(false); };
    self.toggleDwMax = function () { self.dwMax(!self.dwMax()); };
    // one document-level Esc handler; replace any previous mount's listener
    if (window.__arTrxEsc) document.removeEventListener('keydown', window.__arTrxEsc);
    window.__arTrxEsc = function (e) {
      if (e.key !== 'Escape') return;
      if (self.showDrill()) {
        if (self.invMax()) { self.invMax(false); } else { self.closeDrill(); }
        return;
      }
      if (self.dwMax())     { self.dwMax(false); return; }
      if (self.dwOpen())    { self.closeDw(); return; }
      if (self.chartsMax()) { self.toggleChartsMax(); return; }
      if (self.tableMax())  { self.toggleTableMax(); }
    };
    document.addEventListener('keydown', window.__arTrxEsc);
    // CSV of the loaded drill rows + reconciliation totals footer (UTF-8 BOM)
    self.dwExportCsv = function () {
      var rows = self.dwRows();
      if (!rows.length) return;
      var esc2 = function (v) { return '"' + ('' + (v == null ? '' : v)).replace(/"/g, '""') + '"'; };
      var L = [self.dwCols.map(function (c) { return esc2(_t(c.labelKey)); }).join(',')];
      rows.forEach(function (r) {
        L.push(self.dwCols.map(function (c) { return esc2(r[c.key]); }).join(','));
      });
      L.push(self.dwCols.map(function (c, i) {
        return esc2(i === 0 ? _t('dw.total')
          : c.key === 'enteredAed' ? self.dwInvoiced()
          : c.key === 'remainingAed' ? self.dwRemaining() : '');
      }).join(','));
      var name = (self.dwEyebrow() + '_' + self.dwTitle())
        .replace(/[^\w؀-ۿ]+/g, '_').replace(/^_+|_+$/g, '').toLowerCase() || 'drill';
      var blob = new Blob(['﻿' + L.join('\r\n')], { type: 'text/csv;charset=utf-8' });
      downloadBlobUrl(URL.createObjectURL(blob), FP + 'drill-' + name + '-' + today() + '.csv');
    };

    // ── print (pixel report window, same criteria) ──────────────────────
    function esc(s) {
      return String(s == null ? '' : s)
        .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    function buildPrintHtml(rowsData) {
      var t = _t, rtl = i18n.lang() === 'ar';
      var user = authService.getCurrentUser() || {};
      var k = self.kpis() || {};
      var chipList = self.chips();
      var cols = self.visibleCols();      // the print report mirrors the user's column view
      var rows = rowsData.items || [];
      var total = rowsData.total || 0;

      var h = [];
      h.push('<!DOCTYPE html><html lang="' + (rtl ? 'ar' : 'en') + '" dir="' + (rtl ? 'rtl' : 'ltr') + '"><head><meta charset="utf-8">');
      h.push('<title>' + esc(t('pr.title')) + '</title><style>');
      h.push('@page{size:A4 landscape;margin:12mm}');
      h.push('body{font-family:"Outfit","IBM Plex Sans Arabic",Arial,sans-serif;color:#1f2733;margin:0;font-size:11px}');
      h.push('.hd{border-bottom:4px solid ' + BRAND + ';padding-bottom:10px;margin-bottom:14px;display:flex;justify-content:space-between;align-items:flex-end}');
      h.push('.hd h1{font-size:20px;margin:0;color:' + BRAND + '}.hd .meta{font-size:10.5px;color:#5b6573;text-align:end}');
      h.push('.crit{background:#f4f1fa;border:1px solid #ddd3ee;border-radius:8px;padding:8px 12px;margin-bottom:12px}');
      h.push('.crit b{color:' + BRAND + '}.crit span{display:inline-block;margin-inline-end:14px}');
      h.push('.kpis{display:flex;gap:10px;margin-bottom:14px}.kpi{flex:1;border:1px solid #ddd;border-radius:8px;padding:8px;text-align:center}');
      h.push('.kpi b{display:block;font-size:15px;color:' + BRAND + '}.kpi span{font-size:9px;text-transform:uppercase;color:#5b6573}');
      h.push('.charts{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:14px}.charts img{width:100%;border:1px solid #eee;border-radius:8px}');
      h.push('h2{font-size:13px;color:' + BRAND + ';margin:14px 0 6px;page-break-after:avoid}');
      h.push('table{width:100%;border-collapse:collapse;font-size:9.5px}th{background:' + BRAND + ';color:#fff;padding:4px 6px;text-align:start}');
      h.push('td{border-bottom:1px solid #e6e6e6;padding:3px 6px;vertical-align:top}tr{page-break-inside:avoid}');
      h.push('td.amt,th.amt{text-align:end;font-variant-numeric:tabular-nums;white-space:nowrap}');
      h.push('.note{font-size:9.5px;color:#5b6573;margin-top:6px}');
      h.push('</style></head><body>');

      h.push('<div class="hd"><div><h1>' + esc(t('pr.title')) + '</h1><div style="font-size:11px;color:#5b6573">i-Finance · ' + esc(t('mod.ar')) + ' · APP 206</div></div>');
      h.push('<div class="meta">' + esc(t('pr.generated')) + ': ' + esc(new Date().toLocaleString('en-AE')) +
             '<br>' + esc(t('pr.by')) + ': ' + esc(user.displayName || user.username || '') +
             '<br>' + esc(t('pr.level')) + ': ' + esc(t(self.level() === 'trx' ? 'dash.levelTrx' : 'dash.levelLine')) + '</div></div>');

      h.push('<div class="crit"><b>' + esc(t('pr.criteria')) + ':</b> ');
      if (!chipList.length) h.push('<span>' + esc(t('pr.all')) + '</span>');
      chipList.forEach(function (c) { h.push('<span>' + esc(c.label) + ': <b>' + esc(c.value) + '</b></span>'); });
      h.push('</div>');

      h.push('<div class="kpis">');
      [['transactions', 'kpi.transactions', 'int'], ['customers', 'kpi.customers', 'int'],
       ['invoicedAed', 'kpi.invoicedAed', 'amt'], ['appliedAed', 'kpi.appliedAed', 'amt'],
       ['outstandingAed', 'kpi.outstandingAed', 'amt'], ['overdueAed', 'kpi.overdueAed', 'amt'],
       ['collectionRate', 'kpi.collectionRate', 'pct']].forEach(function (def) {
        var v = k[def[0]];
        var txt = def[2] === 'amt' ? self.fmtAmt(v) : def[2] === 'pct' ? ((v || 0) + '%') : self.fmtInt(v);
        h.push('<div class="kpi"><b>' + txt + '</b><span>' + esc(t(def[1])) + '</span></div>');
      });
      h.push('</div>');

      var chartIds = Object.keys(self._charts);
      if (chartIds.length) {
        h.push('<h2>' + esc(t('pr.charts')) + '</h2><div class="charts">');
        chartIds.forEach(function (id) {
          try { h.push('<img src="' + self._charts[id].toBase64Image() + '">'); } catch (e) {}
        });
        h.push('</div>');
      }

      h.push('<h2>' + esc(t('pr.register')) + '</h2><table><thead><tr>');
      cols.forEach(function (c) { h.push('<th class="' + (c.amt ? 'amt' : '') + '">' + esc(t(c.labelKey)) + '</th>'); });
      h.push('</tr></thead><tbody>');
      rows.forEach(function (r) {
        h.push('<tr>');
        cols.forEach(function (c) {
          var v = r[c.key];
          if (c.badge) v = self.badgeText(c.badge, v);
          h.push('<td class="' + (c.amt ? 'amt' : '') + '">' + (c.amt ? self.fmtAmt(v) : esc(v)) + '</td>');
        });
        h.push('</tr>');
      });
      h.push('</tbody></table>');
      if (total > rows.length) {
        h.push('<div class="note">' + esc(t('pr.showing', [rows.length, self.fmtInt(total)])) + '</div>');
      }
      h.push('</body></html>');
      return h.join('');
    }

    self.printReport = function () {
      var p = Object.assign({}, buildParams(), { limit: 200, offset: 0, sort: sortParam() });
      svc.getRows(self.level(), p).then(function (rowsData) {
        var win = window.open('', '_blank');
        if (!win) { toast.error(_t('msg.printPopup')); return; }
        win.document.write(buildPrintHtml(rowsData));
        win.document.close();
        setTimeout(function () { try { win.focus(); win.print(); } catch (e) {} }, 500);
      }).catch(function () { toast.error(_t('msg.error')); });
    };

    // ── boot ────────────────────────────────────────────────────────────
    [self.datefrom, self.dateto, self.duefrom, self.dueto,
     self.gldatefrom, self.gldateto, self.search]
      .forEach(function (obs) { obs.subscribe(scheduleReload); });

    // Load the facet LOVs once, then the summary + register (the build-bar
    // overlay tracks all three; the initial data load starts immediately —
    // the LOVs and figures are independent server calls)
    function loadFilters() {
      self.loadingFilters(true);
      svc.getFilters().then(function (f) {
        self.groups(GROUP_DEFS.map(function (def) { return makeGroup(def, f[def.src]); }));
        self.loadingFilters(false);
      }).catch(function () {
        self.loadingFilters(false); toast.error(_t('msg.error'));
      });
    }
    loadFilters();
    loadSummary();
    loadRows();
  }

  return TrxDashboardViewModel;
});
