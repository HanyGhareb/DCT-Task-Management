define(['knockout', 'services/apService', 'services/api', 'services/authService', 'shared/i18n', 'shared/toast', 'shared/chartLoader',
        'shared/fusionLinks', 'shared/components/interactiveReport'],
function (ko, ap, api, authService, i18n, toast, charts, fusion) {
  'use strict';

  // Aging ramp — single-hue ordinal steps (validated light->dark, brand hue)
  var RAMP  = ['#D293AC', '#BE7392', '#A85578', '#8E3B5C', '#742B48', '#5A1F37'];
  var BRAND = '#8E3B5C', BRAND_MID = '#A85578';
  var AG_ORDER = ['CURRENT', 'D1_30', 'D31_60', 'D61_90', 'D91_180', 'D180P'];
  var AG_KEYS  = ['ag.current', 'ag.b1', 'ag.b2', 'ag.b3', 'ag.b4', 'ag.b5'];
  var PAY_COLORS = { 'Paid': '#0ca30c', 'Unpaid': '#fab219' };

  // Register column catalog per level. hide = off by default (the chooser can
  // re-enable); badge renders status pills; clip = ellipsis + hover title;
  // titleKey = companion field shown as the cell tooltip; sort = server key.
  var COLS = {
    header: [
      { key: 'invoiceNumber',    labelKey: 'tbl.invoiceNo' },
      { key: 'invoiceDate',      labelKey: 'tbl.date', sort: 'date' },
      { key: 'supplier',         labelKey: 'tbl.supplier', sort: 'supplier', clip: true },
      { key: 'isBeneficiary',    labelKey: 'tbl.isBenef' },
      { key: 'description',      labelKey: 'tbl.description', clip: true },
      { key: 'invoiceType',      labelKey: 'tbl.invType', hide: true },
      { key: 'currency',         labelKey: 'tbl.currency' },
      { key: 'amount',           labelKey: 'tbl.amount', amt: true, hide: true },
      { key: 'amountAed',        labelKey: 'tbl.amountAed', amt: true, sort: 'amount' },
      { key: 'amountPaid',       labelKey: 'tbl.paidAmt', amt: true, hide: true },
      { key: 'balanceAed',       labelKey: 'tbl.balance', amt: true, sort: 'balance' },
      { key: 'daysPastDue',      labelKey: 'tbl.dpd' },
      { key: 'validationStatus', labelKey: 'tbl.validation', badge: 'val' },
      { key: 'accountingStatus', labelKey: 'tbl.accounting', badge: 'acc' },
      { key: 'paymentStatus',    labelKey: 'tbl.payStatus', badge: 'pay' },
      { key: 'approvalStatus',   labelKey: 'f.appr', badge: 'appr', hide: true },
      { key: 'fundsStatus',      labelKey: 'tbl.funds', hide: true },
      { key: 'invoiceStatus',    labelKey: 'tbl.status', hide: true },
      { key: 'termsDate',        labelKey: 'tbl.terms', hide: true },
      { key: 'paymentTerms',     labelKey: 'dr.payTerms', hide: true },
      { key: 'payGroup',         labelKey: 'tbl.payGroup' },
      { key: 'paymentMethod',    labelKey: 'tbl.method', hide: true },
      { key: 'poNumbers',        labelKey: 'tbl.po', clip: true },
      { key: 'prNumbers',        labelKey: 'tbl.pr', hide: true, clip: true },
      { key: 'voucherNum',       labelKey: 'tbl.voucher', hide: true },
      { key: 'source',           labelKey: 'dr.source', hide: true },
    ],
    line: [
      { key: 'invoiceNumber',    labelKey: 'tbl.invoiceNo' },
      { key: 'invoiceDate',      labelKey: 'tbl.date', sort: 'date' },
      { key: 'supplier',         labelKey: 'tbl.supplier', clip: true },
      { key: 'isBeneficiary',    labelKey: 'tbl.isBenef', hide: true },
      { key: 'lineNumber',       labelKey: 'tbl.line' },
      { key: 'lineType',         labelKey: 'tbl.lineType' },
      { key: 'description',      labelKey: 'tbl.description', clip: true },
      { key: 'currency',         labelKey: 'tbl.currency', hide: true },
      { key: 'amount',           labelKey: 'tbl.amount', amt: true, hide: true },
      { key: 'amountAed',        labelKey: 'tbl.amountAed', amt: true, sort: 'amount' },
      { key: 'activeHolds',      labelKey: 'tbl.holds', hide: true },
      { key: 'fundStatus',       labelKey: 'tbl.funds', hide: true },
      { key: 'poNumber',         labelKey: 'tbl.po' },
      { key: 'poLine',           labelKey: 'tbl.poLine', hide: true },
      { key: 'receiptNumber',    labelKey: 'tbl.receipt' },
      { key: 'projectNumber',    labelKey: 'tbl.project', titleKey: 'projectName' },
      { key: 'taskNumber',       labelKey: 'tbl.task', titleKey: 'taskName' },
      { key: 'expType',          labelKey: 'tbl.etype', clip: true },
      { key: 'department',       labelKey: 'tbl.dept', clip: true },
      { key: 'period',           labelKey: 'tbl.period', hide: true },
      { key: 'validationStatus', labelKey: 'tbl.validation', badge: 'val', hide: true },
      { key: 'accountingStatus', labelKey: 'tbl.accounting', badge: 'acc', hide: true },
      { key: 'paymentStatus',    labelKey: 'tbl.payStatus', badge: 'pay', hide: true },
    ],
    dist: [
      { key: 'invoiceNumber',     labelKey: 'tbl.invoiceNo' },
      { key: 'invoiceDate',       labelKey: 'tbl.date', sort: 'date' },
      { key: 'supplier',          labelKey: 'tbl.supplier', clip: true },
      { key: 'isBeneficiary',     labelKey: 'tbl.isBenef', hide: true },
      { key: 'lineNumber',        labelKey: 'tbl.line' },
      { key: 'distNumber',        labelKey: 'tbl.dist' },
      { key: 'distType',          labelKey: 'tbl.distType', hide: true },
      { key: 'currency',          labelKey: 'tbl.currency', hide: true },
      { key: 'amount',            labelKey: 'tbl.amount', amt: true, hide: true },
      { key: 'amountAed',         labelKey: 'tbl.amountAed', amt: true, sort: 'amount' },
      { key: 'glCombination',     labelKey: 'tbl.glComb', clip: true },
      { key: 'chargeSource',      labelKey: 'tbl.chargeSrc' },
      { key: 'poChargeAccount',   labelKey: 'tbl.poCharge', hide: true, clip: true },
      { key: 'chargeAccount',     labelKey: 'tbl.chargeAcct', hide: true, clip: true },
      { key: 'accountCode',       labelKey: 'tbl.account', titleKey: 'accountDesc' },
      { key: 'costCenterCode',    labelKey: 'tbl.cc', titleKey: 'costCenterDesc' },
      { key: 'sector',            labelKey: 'tbl.sector', clip: true },
      { key: 'chapter',           labelKey: 'tbl.chapter', hide: true },
      { key: 'program',           labelKey: 'tbl.program', hide: true },
      { key: 'appropriationCode', labelKey: 'tbl.approp', hide: true, titleKey: 'appropriationDesc' },
      { key: 'projectNumber',     labelKey: 'tbl.project', titleKey: 'projectName' },
      { key: 'taskNumber',        labelKey: 'tbl.task' },
      { key: 'expType',           labelKey: 'tbl.etype', hide: true, clip: true },
      { key: 'poNumber',          labelKey: 'tbl.po' },
      { key: 'prNumber',          labelKey: 'tbl.pr' },
      { key: 'requestor',         labelKey: 'tbl.requestor', clip: true },
      { key: 'distDescription',   labelKey: 'tbl.distDesc', hide: true, clip: true },
      { key: 'invoiceDescription', labelKey: 'tbl.invDesc', hide: true, clip: true },
      { key: 'invoiceType',       labelKey: 'tbl.invType', hide: true },
      { key: 'payGroup',          labelKey: 'tbl.payGroup', hide: true },
      { key: 'paymentMethod',     labelKey: 'tbl.method', hide: true },
      { key: 'termsDate',         labelKey: 'tbl.terms', hide: true },
      { key: 'invFundsStatus',    labelKey: 'tbl.funds', hide: true },
      { key: 'voucherNum',        labelKey: 'tbl.voucher', hide: true },
      { key: 'distStatus',        labelKey: 'tbl.status', hide: true },
      { key: 'postingStatus',     labelKey: 'tbl.posting', hide: true },
      { key: 'accountingDate',    labelKey: 'tbl.acctDate', hide: true },
      { key: 'period',            labelKey: 'tbl.period', hide: true },
      { key: 'validationStatus',  labelKey: 'tbl.validation', badge: 'val', hide: true },
      { key: 'accountingStatus',  labelKey: 'tbl.accounting', badge: 'acc', hide: true },
      { key: 'paymentStatus',     labelKey: 'tbl.payStatus', badge: 'pay', hide: true },
    ]
  };

  // facet groups: counted = checkbox list w/ counts, searchable = mini filter,
  // coded = {code,name} pairs (value=code, label=code — name)
  var GROUP_DEFS = [
    { key: 'paid',      labelKey: 'f.paid',      src: 'paymentStatus',    counted: true, open: true },
    { key: 'val',       labelKey: 'f.val',       src: 'validationStatus', counted: true, open: true },
    { key: 'acc',       labelKey: 'f.acc',       src: 'accountingStatus', counted: true },
    { key: 'appr',      labelKey: 'f.appr',      src: 'approvalStatus',   counted: true },
    { key: 'inv',       labelKey: 'f.inv',       src: 'invoiceStatus',    counted: true },
    { key: 'itype',     labelKey: 'f.itype',     src: 'invoiceType',      counted: true },
    { key: 'curr',      labelKey: 'f.curr',      src: 'currency',         counted: true },
    { key: 'paygroup',  labelKey: 'f.paygroup',  src: 'payGroup',         counted: true, searchable: true },
    { key: 'paymethod', labelKey: 'f.paymethod', src: 'paymentMethod',    counted: true },
    { key: 'sector',    labelKey: 'f.sector',    src: 'sectors',          counted: true },
    { key: 'supplier',  labelKey: 'f.supplier',  src: 'suppliers',        searchable: true },
    { key: 'dept',      labelKey: 'f.dept',      src: 'departments',      searchable: true },
    { key: 'cc',        labelKey: 'f.cc',        src: 'costCenters',      searchable: true, coded: true },
    { key: 'project',   labelKey: 'f.project',   src: 'projects',         searchable: true, coded: true },
    { key: 'etype',     labelKey: 'f.etype',     src: 'expTypes',         searchable: true },
    { key: 'account',   labelKey: 'f.account',   src: 'accounts',         searchable: true, coded: true },
    { key: 'approp',    labelKey: 'f.approp',    src: 'appropriations',   searchable: true, coded: true },
    { key: 'req',       labelKey: 'f.req',       src: 'requestors',       searchable: true },
  ];

  function DashboardViewModel() {
    var self = this;
    self.t = i18n.t;

    // ── state ───────────────────────────────────────────────────────────
    self.level   = ko.observable('header');            // header | line | dist
    self.groups  = ko.observableArray([]);
    self.datefrom = ko.observable('');
    self.dateto   = ko.observable('');
    self.gldatefrom = ko.observable('');
    self.gldateto   = ko.observable('');
    self.inclCancelled = ko.observable(false);         // include cancelled invoices? (default OFF)
    self.po   = ko.observable('');
    self.pr   = ko.observable('');
    self.task = ko.observable('');
    self.search = ko.observable('');

    self.loadingFilters = ko.observable(true);
    self.loadingSummary = ko.observable(true);
    self.loadingRows    = ko.observable(true);

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
    self.drillTab  = ko.observable('header');

    self._charts = {};
    self._lastSummary = null;

    // ── register columns: show/hide per user (BI-viewer style) ──────────
    var COLS_PREF = 'ap.dash.cols';                 // server pref (follows the user)
    var COLS_LS   = 'ifinance.ap.cols';             // instant local autosave
    function hiddenDefaults(level) {
      return COLS[level].filter(function (c) { return c.hide; }).map(function (c) { return c.key; });
    }
    self._hidden = {
      header: ko.observableArray(hiddenDefaults('header')),
      line:   ko.observableArray(hiddenDefaults('line')),
      dist:   ko.observableArray(hiddenDefaults('dist')),
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
      ['header', 'line', 'dist'].forEach(function (lvl) {
        if (obj && Array.isArray(obj[lvl])) self._hidden[lvl](obj[lvl]);
      });
    }
    var colsSaveTimer = null;
    function persistCols() {
      var obj = { header: self._hidden.header(), line: self._hidden.line(), dist: self._hidden.dist() };
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
        if (self.visibleCols().length <= 1) return;      // never hide the last column
        hidden.push(col.key);
      } else {
        hidden.splice(i, 1);
      }
      persistCols();
    };
    self.showAllCols = function () { self._hidden[self.level()]([]); persistCols(); };
    self.resetCols = function () { self._hidden[self.level()](hiddenDefaults(self.level())); persistCols(); };
    self.badgeCls = function (type, val) {
      if (type === 'val') return self.valBadge(val);
      if (type === 'acc') return self.accBadge(val);
      if (type === 'appr') return self.apprBadge(val);
      return self.payBadge(val);
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
    // Fusion deep-links (shared/fusionLinks) — always open in a new tab
    self.fusionUrl   = fusion.invoice;
    self.fusionPoUrl = fusion.purchaseOrder;
    self.fusionPrUrl = fusion.requisition;
    // register/drawer cells: {href, text} when this column deep-links out
    self.cellLink = function (row, col) {
      if (col.key === 'invoiceNumber' && row.id)    return { href: fusion.invoice(row.id), text: row.invoiceNumber };
      if (col.key === 'poNumber' && row.poHeaderId) return { href: fusion.purchaseOrder(row.poHeaderId), text: row.poNumber };
      if (col.key === 'prNumber' && row.prHeaderId) return { href: fusion.requisition(row.prHeaderId), text: row.prNumber };
      return null;
    };
    // local autosave first (instant), then the server pref wins (roams w/ user)
    try { applyColPrefs(JSON.parse(localStorage.getItem(COLS_LS) || 'null')); } catch (e) {}
    api.get('/prefs/', { base: 'auth', silent: true }).then(function (d) {
      var hit = ((d && d.items) || []).filter(function (p) { return p.key === COLS_PREF; })[0];
      if (hit && hit.value) { try { applyColPrefs(JSON.parse(hit.value)); } catch (e) {} }
    }).catch(function () {});

    // ── formatting helpers ──────────────────────────────────────────────
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

    self.payBadge = function (s) { return s === 'Paid' ? 'badge badge--success' : 'badge badge--warn'; };
    self.valBadge = function (s) {
      if (s === 'Validated') return 'badge badge--success';
      if (s === 'Canceled' || s === 'Cancelled') return 'badge badge--danger';
      return 'badge badge--warn';
    };
    self.accBadge = function (s) { return s === 'Accounted' ? 'badge badge--success' : 'badge badge--warn'; };
    self.apprBadge = function (s) {
      if (s === 'Workflow Approved') return 'badge badge--success';
      if (s === 'Rejected' || s === 'Stopped') return 'badge badge--danger';
      if (s === 'Not Required') return 'badge badge--idle';
      return 'badge badge--warn';                      // Required / Initiated
    };

    // ── facet groups ────────────────────────────────────────────────────
    function makeGroup(def, raw) {
      var items = (raw || []).map(function (r) {
        if (def.coded)   return { value: r.code, label: r.code + ' — ' + (r.name || ''), count: null, checked: ko.observable(false) };
        if (def.counted) return { value: r.name, label: r.name || '(None)', count: r.count, checked: ko.observable(false) };
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
      if (self.datefrom())        p.datefrom = self.datefrom();
      if (self.dateto())          p.dateto   = self.dateto();
      if (self.gldatefrom())      p.glfrom   = self.gldatefrom();
      if (self.gldateto())        p.glto     = self.gldateto();
      if (!self.inclCancelled())  p.inclcxl  = 'N';
      if ((self.po() || '').trim())     p.po     = self.po().trim();
      if ((self.pr() || '').trim())     p.pr     = self.pr().trim();
      if ((self.task() || '').trim())   p.task   = self.task().trim();
      if ((self.search() || '').trim()) p.search = self.search().trim();
      return p;
    }
    self.buildParams = buildParams;
    self.toggleInclCxl = function () { self.inclCancelled(!self.inclCancelled()); };

    self.chips = ko.computed(function () {
      var out = [];
      self.groups().forEach(function (g) {
        g.items().forEach(function (i) {
          if (i.checked()) {
            out.push({ label: i18n.t(g.labelKey), value: trunc(i.label, 34),
                       clear: function () { i.checked(false); scheduleReload(); } });
          }
        });
      });
      function add(obs, key) {
        if ((obs() || '').trim && (obs() || '').trim() !== '' || (obs() && !obs().trim)) {
          out.push({ label: i18n.t(key), value: obs(),
                     clear: function () { obs(''); scheduleReload(); } });
        }
      }
      add(self.datefrom, 'f.datefrom'); add(self.dateto, 'f.dateto');
      add(self.gldatefrom, 'f.glfrom'); add(self.gldateto, 'f.glto');
      // cancelled invoices are EXCLUDED by default — chip marks the deviation
      if (self.inclCancelled()) {
        out.push({ label: i18n.t('f.inclCxl'), value: i18n.t('f.yes'),
                   clear: function () { self.inclCancelled(false); } });
      }
      add(self.po, 'f.po'); add(self.pr, 'f.pr'); add(self.task, 'f.task');
      add(self.search, 'f.search');
      return out;
    });

    self.resetFilters = function () {
      self.groups().forEach(function (g) {
        g.items().forEach(function (i) { i.checked(false); });
        g.filter('');
      });
      self.datefrom(''); self.dateto('');
      self.gldatefrom(''); self.gldateto(''); self.inclCancelled(false);
      self.po(''); self.pr(''); self.task(''); self.search('');
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
      ap.getSummary(buildParams()).then(function (d) {
        self._lastSummary = d;
        self.kpis(d.kpis || null);
        self.loadingSummary(false);
        setTimeout(function () { renderCharts(d); }, 0);
      }).catch(function () { self.loadingSummary(false); toast.error(i18n.t('msg.error')); });
    }

    function sortParam() { return self.sortKey() + '_' + self.sortDir(); }

    // ── interactive-report mode (shared <interactive-report> component) ──
    // One-shot capped fetch of the whole filtered set; rename / calculated
    // columns / aggregates / control breaks / highlights come from the
    // shared component. layoutsApi null = localStorage-autosaved layouts.
    var IR_MAX = 10000;
    var IR_DATE_KEYS = { invoiceDate: 1, termsDate: 1, accountingDate: 1 };
    var IR_NUM_KEYS  = { daysPastDue: 1, lineNumber: 1, distNumber: 1, activeHolds: 1,
                         poNumber: 1, poLine: 1, prNumber: 1, receiptNumber: 1,
                         voucherNum: 1, lineCount: 1, distCount: 1 };
    self.viewMode = ko.observable('standard');          // standard | ir
    self.irData   = ko.observable(null);
    function irType(c) {
      if (c.amt) return 'money';
      if (IR_DATE_KEYS[c.key]) return 'date';
      if (IR_NUM_KEYS[c.key]) return 'num';
      return 'text';
    }
    function irEnvelope(d) {
      var items = d.items || [];
      return {
        columns: COLS[self.level()].map(function (c) {
          return { key: c.key, label: i18n.t(c.labelKey), type: irType(c) };
        }),
        items: items,
        total: d.total || items.length,
        truncated: (d.total || 0) > items.length,
        maxRows: IR_MAX,
        section: self.level(),          // scopes the component's autosave per level
      };
    }
    self.toggleViewMode = function () {
      self.viewMode(self.viewMode() === 'standard' ? 'ir' : 'standard');
      self.offset(0);
      loadRows();
    };

    function loadRows() {
      self.loadingRows(true);
      if (self.viewMode() === 'ir') {
        var pi = Object.assign({}, buildParams(), { limit: IR_MAX, offset: 0, sort: sortParam() });
        ap.getRows(self.level(), pi).then(function (d) {
          self.total(d.total || 0);
          self.rowTotals(d.totals || null);
          self.irData(irEnvelope(d));
          self.loadingRows(false);
        }).catch(function () { self.loadingRows(false); toast.error(i18n.t('msg.error')); });
        return;
      }
      var p = Object.assign({}, buildParams(),
        { limit: self.limit(), offset: self.offset(), sort: sortParam() });
      ap.getRows(self.level(), p).then(function (d) {
        self.rows(d.items || []);
        self.total(d.total || 0);
        self.rowTotals(d.totals || null);
        self.loadingRows(false);
      }).catch(function () { self.loadingRows(false); toast.error(i18n.t('msg.error')); });
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
        self.sortDir(key === 'supplier' ? 'asc' : 'desc');
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

    // Chart.js onClick adapter: clicked element index -> its data row
    function pickIdx(rows, onPick) {
      if (!onPick) return undefined;
      return function (evt, els) {
        if (els && els.length && rows[els[0].index] !== undefined) onPick(rows[els[0].index], els[0].index);
      };
    }

    function hbar(id, rows, color, onPick) {
      rows = rows || [];
      mk(id, {
        type: 'bar',
        data: {
          labels: rows.map(function (r) { return trunc(r.name || '(None)', 26); }),
          datasets: [{ data: rows.map(function (r) { return r.amount; }),
                       backgroundColor: color, borderRadius: 4, maxBarThickness: 16 }]
        },
        options: {
          indexAxis: 'y',
          onClick: pickIdx(rows, onPick),
          plugins: {
            legend: { display: false },
            tooltip: { callbacks: {
              title: function (items) { return (rows[items[0].dataIndex] || {}).name || ''; },
              label: function (ctx) {
                var r = rows[ctx.dataIndex] || {};
                return self.fmtAmt(r.amount) + ' AED · ' + self.fmtInt(r.count) + ' ' + i18n.t('tbl.rows');
              } } }
          },
          scales: compactTicks('x')
        }
      });
    }

    function renderCharts(d) {
      if (!d || self.chartsCollapsed()) return;
      destroyCharts();

      // AP aging — ordinal single-hue ramp over the ordered buckets
      var byB = {}; (d.aging || []).forEach(function (a) { byB[a.bucket] = a; });
      mk('apChartAging', {
        type: 'bar',
        data: {
          labels: AG_KEYS.map(function (k) { return i18n.t(k); }),
          datasets: [{ data: AG_ORDER.map(function (b) { return byB[b] ? byB[b].amount : 0; }),
                       backgroundColor: RAMP, borderRadius: 4, maxBarThickness: 48 }]
        },
        options: {
          onClick: pickIdx(AG_ORDER, function (bucket, i) {
            openChartDrill('ch.aging', i18n.t(AG_KEYS[i]), { aging: bucket }, 'balance_desc');
          }),
          plugins: {
            legend: { display: false },
            tooltip: { callbacks: { label: function (ctx) {
              var b = byB[AG_ORDER[ctx.dataIndex]] || { count: 0 };
              return self.fmtAmt(ctx.parsed.y) + ' AED · ' + self.fmtInt(b.count) + ' ' + i18n.t('kpi.invoices');
            } } }
          },
          scales: compactTicks('y')
        }
      });

      // Paid vs unpaid — status colors, labelled legend
      var pay = d.paymentStatus || [];
      mk('apChartPay', {
        type: 'doughnut',
        data: {
          labels: pay.map(function (r) { return r.name; }),
          datasets: [{ data: pay.map(function (r) { return r.count; }),
                       backgroundColor: pay.map(function (r) { return PAY_COLORS[r.name] || '#9aa3b0'; }),
                       borderColor: '#fff', borderWidth: 2 }]
        },
        options: {
          cutout: '62%',
          onClick: pickIdx(pay, function (r) {
            openChartDrill('ch.payment', r.name, { paid: r.name });
          }),
          plugins: {
            legend: { position: 'bottom' },
            tooltip: { callbacks: { label: function (ctx) {
              var r = pay[ctx.dataIndex] || {};
              return ' ' + r.name + ': ' + self.fmtInt(r.count) + ' · ' + self.fmtAmt(r.amount) + ' AED';
            } } }
          }
        }
      });

      // Monthly trend — single series (count shown in tooltip, no dual axis)
      var tr = d.trend || [];
      mk('apChartTrend', {
        type: 'line',
        data: {
          labels: tr.map(function (r) { return r.month; }),
          datasets: [{ data: tr.map(function (r) { return r.amount; }),
                       borderColor: BRAND, backgroundColor: charts.alpha(BRAND, 0.10),
                       fill: true, tension: 0.3, pointRadius: 2.5, borderWidth: 2 }]
        },
        options: {
          onClick: pickIdx(tr, function (r) {
            // month bar -> invoices whose Received Date falls in that month
            var p = (r.month || '').split('-');
            if (p.length !== 2) return;
            var last = new Date(Date.UTC(+p[0], +p[1], 0)).getUTCDate();
            openChartDrill('ch.trend', r.month,
              { rcvfrom: r.month + '-01', rcvto: r.month + '-' + ('0' + last).slice(-2) });
          }),
          plugins: {
            legend: { display: false },
            tooltip: { callbacks: { label: function (ctx) {
              var r = tr[ctx.dataIndex] || {};
              return self.fmtAmt(r.amount) + ' AED · ' + self.fmtInt(r.count) + ' ' + i18n.t('kpi.invoices');
            } } }
          },
          scales: compactTicks('y')
        }
      });

      hbar('apChartVal', d.validationStatus, BRAND,
        function (r) { openChartDrill('ch.validation', r.name, { val: r.name }); });
      hbar('apChartAcc', d.accountingStatus, BRAND_MID,
        function (r) { openChartDrill('ch.accounting', r.name, { acc: r.name }); });
      hbar('apChartSup', d.topSuppliers, BRAND,
        function (r) { openChartDrill('ch.topSuppliers', r.name, { esupplier: r.name }); });
      hbar('apChartSector', d.bySector, BRAND_MID,
        function (r) { openChartDrill('ch.bySector', r.name, { sector: r.name }); });
      hbar('apChartPg', d.byPayGroup, BRAND,
        function (r) { openChartDrill('ch.byPayGroup', r.name, { paygroup: r.name }); });
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
      toast.info(i18n.t('msg.exportStarted'));
      ap.getExportBlobUrl(self.level(), buildParams()).then(function (url) {
        downloadBlobUrl(url, 'ap-' + self.level() + '-' + today() + '.csv');
      }).catch(function () { toast.error(i18n.t('msg.error')); });
    };

    self.exportXlsx = function () {
      toast.info(i18n.t('msg.exportStarted'));
      ap.getExportCsvText(self.level(), buildParams()).then(function (csv) {
        require(['xlsx'], function (X) {
          var wb = X.read(csv, { type: 'string' });
          X.writeFile(wb, 'ap-' + self.level() + '-' + today() + '.xlsx');
        });
      }).catch(function () { toast.error(i18n.t('msg.error')); });
    };

    self.exportSummaryCsv = function () {
      var d = self._lastSummary;
      if (!d) return;
      var L = ['﻿AP Analytics — ' + today()];
      var k = d.kpis || {};
      L.push('');
      L.push('KPI,Value');
      ['invoices', 'suppliers', 'totalAed', 'paidAed', 'outstandingAed', 'overdueAed', 'cancelled']
        .forEach(function (key) { L.push(key + ',' + (k[key] != null ? k[key] : '')); });
      function section(title, rows, nameKey) {
        L.push(''); L.push(title + ',Count,Amount AED');
        (rows || []).forEach(function (r) {
          L.push('"' + String(r[nameKey || 'name'] || '').replace(/"/g, '""') + '",' + (r.count || 0) + ',' + (r.amount || 0));
        });
      }
      L.push(''); L.push('Aging bucket,Count,Amount AED');
      (d.aging || []).forEach(function (r) { L.push(r.bucket + ',' + r.count + ',' + r.amount); });
      section('Validation status', d.validationStatus);
      section('Accounting status', d.accountingStatus);
      section('Payment status', d.paymentStatus);
      L.push(''); L.push('Month,Count,Amount AED');
      (d.trend || []).forEach(function (r) { L.push(r.month + ',' + r.count + ',' + r.amount); });
      section('Top suppliers', d.topSuppliers);
      section('Sector', d.bySector);
      section('Pay group', d.byPayGroup);
      var blob = new Blob([L.join('\r\n')], { type: 'text/csv;charset=utf-8' });
      downloadBlobUrl(URL.createObjectURL(blob), 'ap-analytics-' + today() + '.csv');
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
        downloadBlobUrl(URL.createObjectURL(b), 'ap-charts-' + today() + '.png');
      });
    };

    // ── drill (invoice window: master header + summary card + detail tabs) ──
    self.invMax = ko.observable(false);
    self.toggleInvMax = function () { self.invMax(!self.invMax()); };
    self.invAuditOpen = ko.observable(false);          // Audit info — collapsed by default
    self.toggleInvAudit = function () { self.invAuditOpen(!self.invAuditOpen()); };
    self.openDrill = function (row) {
      if (!row || !row.id) return;
      ap.getInvoice(row.id).then(function (d) {
        // hoist the referenced-document deep-link arrays onto the header
        // (the master region binds `with: header`)
        if (d && d.header) {
          d.header.poRefs = d.poRefs || [];
          d.header.prRefs = d.prRefs || [];
        }
        self.drill(d);
        self.drillTab('lines');            // header lives in the master region now
        self.invMax(false);
        self.invAuditOpen(false);
        self.showDrill(true);
      }).catch(function () { toast.error(i18n.t('msg.error')); });
    };

    // ── GL-Actuals-style COA segment popover (Distributions tab hover) ──
    var SEG_DEFS = [
      ['seg.entity',        'entityCode',         'entityDesc'],
      ['seg.program',       'programCode',        'programDesc'],
      ['seg.cc',            'costCenterCode',     'costCenterDesc'],
      ['seg.budgetGroup',   'budgetGroupCode',    'budgetGroupDesc'],
      ['seg.account',       'accountCode',        'accountDesc'],
      ['seg.entitySpecific','entitySpecificCode', 'entitySpecificDesc'],
      ['seg.appropriation', 'appropriationCode',  'appropriationDesc'],
      ['seg.intercompany',  'intercompanyCode',   'intercompanyDesc'],
      ['seg.future1',       'future1Code',        'future1Desc'],
      ['seg.future2',       'future2Code',        'future2Desc'],
    ];
    self.tipRows = ko.observableArray([]);
    self.tipShow = ko.observable(false);
    self.tipX = ko.observable(0); self.tipY = ko.observable(0);
    function placeTip(e) {
      var w = 470, x = e.clientX + 16, y = e.clientY + 14;
      if (x + w > window.innerWidth) x = e.clientX - w - 16;
      if (y + 360 > window.innerHeight) y = Math.max(12, window.innerHeight - 370);
      self.tipX(x); self.tipY(y);
    }
    self.ccHover = function (r, e) {
      if (!r || !r.chargeAccount) return true;
      self.tipRows(SEG_DEFS.map(function (s) {
        return { label: i18n.t(s[0]), code: r[s[1]] || '', desc: r[s[2]] || '' };
      }));
      placeTip(e); self.tipShow(true); return true;
    };
    self.ccMove = function (r, e) { placeTip(e); return true; };
    self.ccOut  = function () { self.tipShow(false); return true; };
    self.closeDrill = function () { self.showDrill(false); self.drill(null); self.invMax(false); };
    self.setDrillTab = function (tab) { self.drillTab(tab); };

    // ── chart drill-down drawer (GL Budget Utilization pattern: right-edge
    //    slide-in, wide by default + ⤢ full-screen toggle, Esc restores then
    //    closes, CSV export, reconciling total). Every chart segment drills
    //    to the related invoices = current facets + the clicked segment. ──
    var DW_LIMIT = 500;
    var DW_COLS = [
      { key: 'invoiceNumber',    labelKey: 'tbl.invoiceNo' },
      { key: 'invoiceDate',      labelKey: 'tbl.date' },
      { key: 'supplier',         labelKey: 'tbl.supplier', clip: true },
      { key: 'description',      labelKey: 'tbl.description', clip: true },
      { key: 'currency',         labelKey: 'tbl.currency' },
      { key: 'amountAed',        labelKey: 'tbl.amountAed', amt: true },
      { key: 'balanceAed',       labelKey: 'tbl.balance', amt: true },
      { key: 'paymentStatus',    labelKey: 'tbl.payStatus', badge: 'pay' },
      { key: 'validationStatus', labelKey: 'tbl.validation', badge: 'val' },
      { key: 'daysPastDue',      labelKey: 'tbl.dpd' },
    ];
    self.dwCols    = DW_COLS;
    self.dwOpen    = ko.observable(false);
    self.dwMax     = ko.observable(false);
    self.dwLoading = ko.observable(false);
    self.dwTitle   = ko.observable('');
    self.dwEyebrow = ko.observable('');
    self.dwCtx     = ko.observable('');
    self.dwRows    = ko.observableArray([]);
    self.dwTotal   = ko.observable(0);     // matching invoices (server count)
    self.dwAmount  = ko.observable(0);     // AED total over ALL matches (reconciles to the chart figure)
    self.dwCapNote = ko.computed(function () {
      var t = self.dwTotal(), n = self.dwRows().length;
      return t > n
        ? i18n.t('dw.showing').replace('{n}', self.fmtInt(n)).replace('{c}', self.fmtInt(t)) : '';
    });
    function openChartDrill(chartKey, segment, extra, sort) {
      self.dwTitle(segment);
      self.dwEyebrow(i18n.t(chartKey));
      self.dwCtx(self.chips().map(function (c) { return c.label + ': ' + c.value; }).join('   ·   '));
      self.dwRows([]); self.dwTotal(0); self.dwAmount(0);
      self.dwOpen(true); self.dwLoading(true);
      var p = Object.assign({}, buildParams(), extra,
        { limit: DW_LIMIT, offset: 0, sort: sort || 'amount_desc' });
      ap.getRows('header', p).then(function (d) {
        self.dwRows(d.items || []);
        self.dwTotal(d.total || 0);
        self.dwAmount((d.totals || {}).amountAed || 0);
        self.dwLoading(false);
      }).catch(function () {
        self.dwLoading(false); self.dwOpen(false); toast.error(i18n.t('msg.error'));
      });
    }
    self.closeDw    = function () { self.dwOpen(false); self.dwMax(false); };
    self.toggleDwMax = function () { self.dwMax(!self.dwMax()); };
    // one document-level Esc handler; replace any previous mount's listener
    // (the module router recreates the VM on every navigation)
    if (window.__apDashEsc) document.removeEventListener('keydown', window.__apDashEsc);
    window.__apDashEsc = function (e) {
      if (e.key !== 'Escape') return;
      if (self.showDrill()) {                                    // invoice window is topmost
        if (self.invMax()) { self.invMax(false); } else { self.closeDrill(); }
        return;
      }
      if (self.dwMax())      { self.dwMax(false); return; }     // restore maximized drawer first
      if (self.dwOpen())     { self.closeDw(); return; }
      if (self.chartsMax())  { self.toggleChartsMax(); return; }
      if (self.tableMax())   { self.toggleTableMax(); }
    };
    document.addEventListener('keydown', window.__apDashEsc);
    // CSV of the loaded drill rows + reconciliation total footer (UTF-8 BOM)
    self.dwExportCsv = function () {
      var rows = self.dwRows();
      if (!rows.length) return;
      var esc2 = function (v) { return '"' + ('' + (v == null ? '' : v)).replace(/"/g, '""') + '"'; };
      var L = [DW_COLS.map(function (c) { return esc2(i18n.t(c.labelKey)); }).join(',')];
      rows.forEach(function (r) {
        L.push(DW_COLS.map(function (c) { return esc2(r[c.key]); }).join(','));
      });
      L.push(DW_COLS.map(function (c, i) {
        return esc2(i === 0 ? i18n.t('dw.total') : (c.key === 'amountAed' ? self.dwAmount() : ''));
      }).join(','));
      var name = (self.dwEyebrow() + '_' + self.dwTitle())
        .replace(/[^\w\u0600-\u06FF]+/g, '_').replace(/^_+|_+$/g, '').toLowerCase() || 'drill';
      var blob = new Blob(['\uFEFF' + L.join('\r\n')], { type: 'text/csv;charset=utf-8' });
      downloadBlobUrl(URL.createObjectURL(blob), 'ap-drill-' + name + '-' + today() + '.csv');
    };

    // ── print (pixel report window, same criteria) ──────────────────────
    function esc(s) {
      return String(s == null ? '' : s)
        .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    function buildPrintHtml(rowsData) {
      var t = i18n.t, rtl = i18n.lang() === 'ar';
      var user = authService.getCurrentUser() || {};
      var k = self.kpis() || {};
      var chipList = self.chips();
      var lvl = self.level();
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
      h.push('.crit{background:#f7f2f4;border:1px solid #e3d3da;border-radius:8px;padding:8px 12px;margin-bottom:12px}');
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

      h.push('<div class="hd"><div><h1>' + esc(t('pr.title')) + '</h1><div style="font-size:11px;color:#5b6573">i-Finance · ' + esc(t('mod.ap')) + ' · APP 212</div></div>');
      h.push('<div class="meta">' + esc(t('pr.generated')) + ': ' + esc(new Date().toLocaleString('en-AE')) +
             '<br>' + esc(t('pr.by')) + ': ' + esc(user.displayName || user.username || '') +
             '<br>' + esc(t('pr.level')) + ': ' + esc(t(lvl === 'header' ? 'dash.levelHeader' : lvl === 'line' ? 'dash.levelLine' : 'dash.levelDist')) + '</div></div>');

      h.push('<div class="crit"><b>' + esc(t('pr.criteria')) + ':</b> ');
      if (!chipList.length) h.push('<span>' + esc(t('pr.all')) + '</span>');
      chipList.forEach(function (c) { h.push('<span>' + esc(c.label) + ': <b>' + esc(c.value) + '</b></span>'); });
      h.push('</div>');

      h.push('<div class="kpis">');
      [['invoices', 'kpi.invoices', 'int'], ['suppliers', 'kpi.suppliers', 'int'],
       ['totalAed', 'kpi.totalAed', 'amt'], ['paidAed', 'kpi.paidAed', 'amt'],
       ['outstandingAed', 'kpi.outstandingAed', 'amt'], ['overdueAed', 'kpi.overdueAed', 'amt'],
       ['cancelled', 'kpi.cancelled', 'int']].forEach(function (def) {
        var v = k[def[0]];
        h.push('<div class="kpi"><b>' + (def[2] === 'amt' ? self.fmtAmt(v) : self.fmtInt(v)) + '</b><span>' + esc(t(def[1])) + '</span></div>');
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
      ap.getRows(self.level(), p).then(function (rowsData) {
        var win = window.open('', '_blank');
        if (!win) { toast.error(i18n.t('msg.printPopup')); return; }
        win.document.write(buildPrintHtml(rowsData));
        win.document.close();
        setTimeout(function () { try { win.focus(); win.print(); } catch (e) {} }, 500);
      }).catch(function () { toast.error(i18n.t('msg.error')); });
    };

    // ── boot ────────────────────────────────────────────────────────────
    [self.datefrom, self.dateto, self.gldatefrom, self.gldateto, self.inclCancelled,
     self.po, self.pr, self.task, self.search]
      .forEach(function (obs) { obs.subscribe(scheduleReload); });

    // Facet LOVs + counts follow the include-cancelled setting; a re-fetch
    // keeps the user's selections and which groups are open.
    function loadFilters() {
      self.loadingFilters(true);
      var p = self.inclCancelled() ? { inclcxl: 'Y' } : { inclcxl: 'N' };
      ap.getFilters(p).then(function (f) {
        var sel = {}, openSt = {};
        self.groups().forEach(function (g) {
          sel[g.key] = g.items().filter(function (i) { return i.checked(); })
                                .map(function (i) { return i.value; });
          openSt[g.key] = g.open();
        });
        self.groups(GROUP_DEFS.map(function (def) {
          var g = makeGroup(def, f[def.src]);
          if (def.key in openSt) g.open(openSt[def.key]);
          (sel[def.key] || []).forEach(function (v) {
            var hit = g.items().filter(function (i) { return i.value === v; })[0];
            if (hit) hit.checked(true);
          });
          return g;
        }));
        self.loadingFilters(false);
      }).catch(function () { self.loadingFilters(false); toast.error(i18n.t('msg.error')); });
    }
    self.inclCancelled.subscribe(loadFilters);
    loadFilters();

    loadSummary();
    loadRows();
  }

  return DashboardViewModel;
});
