define(['knockout', 'services/apService', 'services/authService', 'shared/i18n', 'shared/toast', 'shared/chartLoader'],
function (ko, ap, authService, i18n, toast, charts) {
  'use strict';

  // Aging ramp — single-hue ordinal steps (validated light->dark, brand hue)
  var RAMP  = ['#D293AC', '#BE7392', '#A85578', '#8E3B5C', '#742B48', '#5A1F37'];
  var BRAND = '#8E3B5C', BRAND_MID = '#A85578';
  var AG_ORDER = ['CURRENT', 'D1_30', 'D31_60', 'D61_90', 'D91_180', 'D180P'];
  var AG_KEYS  = ['ag.current', 'ag.b1', 'ag.b2', 'ag.b3', 'ag.b4', 'ag.b5'];
  var PAY_COLORS = { 'Paid': '#0ca30c', 'Unpaid': '#fab219' };

  // facet groups: counted = checkbox list w/ counts, searchable = mini filter,
  // coded = {code,name} pairs (value=code, label=code — name)
  var GROUP_DEFS = [
    { key: 'paid',      labelKey: 'f.paid',      src: 'paymentStatus',    counted: true, open: true },
    { key: 'val',       labelKey: 'f.val',       src: 'validationStatus', counted: true, open: true },
    { key: 'acc',       labelKey: 'f.acc',       src: 'accountingStatus', counted: true },
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
      if ((self.po() || '').trim())     p.po     = self.po().trim();
      if ((self.pr() || '').trim())     p.pr     = self.pr().trim();
      if ((self.task() || '').trim())   p.task   = self.task().trim();
      if ((self.search() || '').trim()) p.search = self.search().trim();
      return p;
    }
    self.buildParams = buildParams;

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

    function loadRows() {
      self.loadingRows(true);
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

    function hbar(id, rows, color) {
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

      hbar('apChartVal', d.validationStatus, BRAND);
      hbar('apChartAcc', d.accountingStatus, BRAND_MID);
      hbar('apChartSup', d.topSuppliers, BRAND);
      hbar('apChartSector', d.bySector, BRAND_MID);
      hbar('apChartPg', d.byPayGroup, BRAND);
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

    // ── drill ───────────────────────────────────────────────────────────
    self.openDrill = function (row) {
      if (!row || !row.id) return;
      ap.getInvoice(row.id).then(function (d) {
        self.drill(d);
        self.drillTab('header');
        self.showDrill(true);
      }).catch(function () { toast.error(i18n.t('msg.error')); });
    };
    self.closeDrill = function () { self.showDrill(false); self.drill(null); };
    self.setDrillTab = function (tab) { self.drillTab(tab); };

    // ── print (pixel report window, same criteria) ──────────────────────
    function esc(s) {
      return String(s == null ? '' : s)
        .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    var PRINT_COLS = {
      header: [
        ['invoiceNumber', 'tbl.invoiceNo'], ['invoiceDate', 'tbl.date'], ['supplier', 'tbl.supplier'],
        ['description', 'tbl.description'], ['currency', 'tbl.currency'], ['amountAed', 'tbl.amountAed', 'amt'],
        ['balanceAed', 'tbl.balance', 'amt'], ['daysPastDue', 'tbl.dpd'], ['validationStatus', 'tbl.validation'],
        ['accountingStatus', 'tbl.accounting'], ['paymentStatus', 'tbl.payStatus'],
        ['payGroup', 'tbl.payGroup'], ['poNumbers', 'tbl.po']],
      line: [
        ['invoiceNumber', 'tbl.invoiceNo'], ['invoiceDate', 'tbl.date'], ['supplier', 'tbl.supplier'],
        ['lineNumber', 'tbl.line'], ['lineType', 'tbl.lineType'], ['description', 'tbl.description'],
        ['amountAed', 'tbl.amountAed', 'amt'], ['poNumber', 'tbl.po'], ['projectNumber', 'tbl.project'],
        ['taskNumber', 'tbl.task'], ['expType', 'tbl.etype'], ['department', 'tbl.dept']],
      dist: [
        ['invoiceNumber', 'tbl.invoiceNo'], ['invoiceDate', 'tbl.date'], ['supplier', 'tbl.supplier'],
        ['lineNumber', 'tbl.line'], ['distNumber', 'tbl.dist'], ['amountAed', 'tbl.amountAed', 'amt'],
        ['accountCode', 'tbl.account'], ['costCenterCode', 'tbl.cc'], ['sector', 'tbl.sector'],
        ['projectNumber', 'tbl.project'], ['taskNumber', 'tbl.task'], ['poNumber', 'tbl.po'],
        ['prNumber', 'tbl.pr'], ['requestor', 'tbl.requestor']]
    };

    function buildPrintHtml(rowsData) {
      var t = i18n.t, rtl = i18n.lang() === 'ar';
      var user = authService.getCurrentUser() || {};
      var k = self.kpis() || {};
      var chipList = self.chips();
      var lvl = self.level();
      var cols = PRINT_COLS[lvl];
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
      cols.forEach(function (c) { h.push('<th class="' + (c[2] || '') + '">' + esc(t(c[1])) + '</th>'); });
      h.push('</tr></thead><tbody>');
      rows.forEach(function (r) {
        h.push('<tr>');
        cols.forEach(function (c) {
          var v = r[c[0]];
          h.push('<td class="' + (c[2] || '') + '">' + (c[2] === 'amt' ? self.fmtAmt(v) : esc(v)) + '</td>');
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
    [self.datefrom, self.dateto, self.po, self.pr, self.task, self.search]
      .forEach(function (obs) { obs.subscribe(scheduleReload); });

    ap.getFilters().then(function (f) {
      self.groups(GROUP_DEFS.map(function (def) { return makeGroup(def, f[def.src]); }));
      self.loadingFilters(false);
    }).catch(function () { self.loadingFilters(false); toast.error(i18n.t('msg.error')); });

    loadSummary();
    loadRows();
  }

  return DashboardViewModel;
});
