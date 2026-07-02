/**
 * interactiveReport.js — <interactive-report> Knockout component (App 211).
 *
 * APEX-Interactive-Report-like grid over a one-shot capped server fetch.
 * Everything after the fetch is client-side: global search, per-column filter
 * chips, multi-sort, column show/hide + reorder, calculated columns (safe
 * irExpr engine — no eval), aggregates row, CSV/XLSX export, server-saved
 * named layouts + localStorage last-state autosave.
 *
 * Usage:
 *   <interactive-report params="reportCode: irCode, section: irSection,
 *                               data: irData, isAdmin: isAdmin,
 *                               layoutsApi: layoutsApi"></interactive-report>
 * Params:
 *   reportCode  string|observable  persistence scope (required)
 *   section     string|observable  MULTI section key ('' when N/A)
 *   data        ko.observable      REQUIRED — envelope {columns:[{key,label,type}],
 *                                  items:[], total, truncated, maxRows} or null
 *   isAdmin     bool               enables layout sharing controls
 *   layoutsApi  object|null        {list(code), create(data), update(id,data),
 *                                  remove(id)} — all Promise; null hides layouts
 *
 * Perf contract: master/filtered rows live in PLAIN arrays; only the current
 * page enters an observableArray. Rows are normalized on ingest (APEX_JSON
 * omits NULL keys — missing keys become null so bindings never break).
 */
define(['knockout', 'shared/i18n', 'shared/toast', 'components/irExpr',
        'text!components/interactiveReport.html'],
function (ko, i18n, toast, irExpr, templateHtml) {
  'use strict';

  var OPS = {
    text: ['contains', 'eq', 'neq', 'starts', 'null', 'notnull'],
    num:  ['eq', 'neq', 'gt', 'gte', 'lt', 'lte', 'between', 'null', 'notnull'],
    date: ['on', 'before', 'after', 'between', 'null', 'notnull']
  };
  var AGG_CHOICES = ['', 'sum', 'avg', 'min', 'max', 'count'];
  var PAGE_SIZES = [25, 50, 100, 200];

  function isNil(v) { return v === null || v === undefined || v === ''; }
  function famOf(type) {
    if (type === 'money' || type === 'num') return 'num';
    if (type === 'date') return 'date';
    return 'text';
  }

  function IrVM(params) {
    var self = this;
    self.t          = i18n.t;
    self.reportCode = params.reportCode;
    self.section    = params.section || ko.observable('');
    self.dataObs    = params.data;
    self.isAdmin    = !!ko.unwrap(params.isAdmin);
    self.layoutsApi = params.layoutsApi || null;
    self.pageSizes  = PAGE_SIZES;
    self.aggChoices = AGG_CHOICES;

    var subs = [];
    var suspend = false;          // guards recompute storms while (re)building state

    // ── data model ────────────────────────────────────────────────────────
    self.baseCols   = [];                      // [{key,label,type}] from the envelope
    self.masterRows = [];                      // normalized plain rows
    self._filtered  = [];                      // post search+filter+sort, plain
    self.calcCols   = ko.observableArray([]);  // [{key,label,expr,type}]
    self._calcFns   = {};                      // key -> compiled eval(row)
    self.colState   = ko.observableArray([]);  // [{key, visible:obs, agg:obs}] display order
    self.colByKey   = {};                      // key -> {key,label,type,isCalc}

    self.hasData       = ko.observable(false);
    self.truncated     = ko.observable(false);
    self.maxRows       = ko.observable(0);
    self.filteredCount = ko.observable(0);
    self.filteredRev   = ko.observable(0);
    self.pageRows      = ko.observableArray([]);
    self.pageIndex     = ko.observable(0);
    self.pageSize      = ko.observable(50);
    self.search        = ko.observable('');
    self.searchLive    = ko.computed(function () { return self.search(); })
                           .extend({ rateLimit: { timeout: 250, method: 'notifyWhenChangesStop' } });
    self.filters       = ko.observableArray([]);   // [{col,op,val,val2}]
    self.sorts         = ko.observableArray([]);   // [{col,dir}]
    self.openPanel     = ko.observable(null);      // 'cols'|'filter'|'layouts'|null

    // effective column = base meta + the user's header-label override (renameable)
    function effCol(e) {
      var c = self.colByKey[e.key];
      if (!c) return null;
      var lbl = e.label();
      return lbl ? { key: c.key, type: c.type, isCalc: c.isCalc, label: lbl } : c;
    }
    self.visibleColumns = ko.computed(function () {
      return self.colState().filter(function (e) { return e.visible(); })
        .map(effCol)
        .filter(Boolean);
    });

    // ── ingest ────────────────────────────────────────────────────────────
    var stateKey = null;

    function normalizeRows(items, cols) {
      var keys = cols.map(function (c) { return c.key; });
      return (items || []).map(function (r) {
        var o = {}, i;
        for (i = 0; i < keys.length; i++) {
          o[keys[i]] = (r[keys[i]] === undefined ? null : r[keys[i]]);
        }
        return o;
      });
    }

    function rebuildColIndex() {
      self.colByKey = {};
      self.baseCols.forEach(function (c) {
        self.colByKey[c.key] = { key: c.key, label: c.label, type: c.type, isCalc: false };
      });
      self.calcCols().forEach(function (c) {
        self.colByKey[c.key] = { key: c.key, label: c.label, type: c.type, isCalc: true };
      });
    }

    function entryFor(key, visible) {
      return { key: key, visible: ko.observable(visible !== false),
               agg: ko.observable(''), label: ko.observable(null) };
    }

    function resetColState() {
      var entries = self.baseCols.map(function (c) { return entryFor(c.key, true); });
      self.calcCols().forEach(function (c) { entries.push(entryFor(c.key, true)); });
      self.colState(entries);
    }

    function onData(env) {
      if (!env) { self.hasData(false); self.pageRows([]); return; }
      suspend = true;
      self.baseCols = env.columns || [];
      var key = ko.unwrap(self.reportCode) + '::' + (env.section || '');
      var newContext = (key !== stateKey);
      stateKey = key;
      if (newContext) {
        self.calcCols([]); self._calcFns = {};
        self.filters([]); self.sorts([]); self.search('');
        rebuildColIndex();
        resetColState();
        self.appliedLayout(null);
      } else {
        rebuildColIndex();
        reconcileColState();
      }
      self.masterRows = normalizeRows(env.items, self.baseCols);
      self.truncated(env.truncated === true);
      self.maxRows(env.maxRows || 0);
      self.hasData(true);
      self.pageIndex(0);
      if (newContext) {
        var restored = restoreAutosave();
        wantDefault = !restored;
        if (wantDefault) { applyDefaultLayout(); }
      }
      suspend = false;
      recompute();
    }

    // keep known entries (order/visibility/agg), append new columns, drop gone ones
    function reconcileColState() {
      var known = {};
      var entries = self.colState().filter(function (e) {
        known[e.key] = true;
        return !!self.colByKey[e.key];
      });
      Object.keys(self.colByKey).forEach(function (k) {
        if (!known[k]) entries.push(entryFor(k, true));
      });
      self.colState(entries);
    }

    subs.push(self.dataObs.subscribe(onData));

    // ── pipeline ──────────────────────────────────────────────────────────
    function applyCalc(rows) {
      var calcs = self.calcCols();
      if (!calcs.length) return rows;
      return rows.map(function (r) {
        var o = {}, k;
        for (k in r) { if (Object.prototype.hasOwnProperty.call(r, k)) o[k] = r[k]; }
        calcs.forEach(function (c) {
          var fn = self._calcFns[c.key];
          o[c.key] = fn ? fn.eval(o) : null;
        });
        return o;
      });
    }

    function passesFilter(row, f) {
      var col = self.colByKey[f.col];
      if (!col) return true;
      var v = row[f.col];
      if (f.op === 'null')    return isNil(v);
      if (f.op === 'notnull') return !isNil(v);
      if (isNil(v)) return false;
      var fam = famOf(col.type);
      if (fam === 'num') {
        var n = Number(v), a = Number(f.val), b = Number(f.val2);
        if (isNaN(n)) return false;
        switch (f.op) {
          case 'eq':  return n === a;
          case 'neq': return n !== a;
          case 'gt':  return n > a;
          case 'gte': return n >= a;
          case 'lt':  return n < a;
          case 'lte': return n <= a;
          case 'between': return n >= a && n <= b;
        }
        return true;
      }
      if (fam === 'date') {
        var d = String(v).substring(0, 10);
        switch (f.op) {
          case 'on':      return d === f.val;
          case 'before':  return d < f.val;
          case 'after':   return d > f.val;
          case 'between': return d >= f.val && d <= String(f.val2);
        }
        return true;
      }
      var s = String(v).toLowerCase(), q = String(f.val).toLowerCase();
      switch (f.op) {
        case 'contains': return s.indexOf(q) !== -1;
        case 'eq':       return s === q;
        case 'neq':      return s !== q;
        case 'starts':   return s.lastIndexOf(q, 0) === 0;
      }
      return true;
    }

    function comparator(sorts) {
      var metas = sorts.map(function (s) {
        var col = self.colByKey[s.col];
        return { key: s.col, dir: s.dir === 'desc' ? -1 : 1, fam: famOf(col ? col.type : 'text') };
      });
      return function (a, b) {
        for (var i = 0; i < metas.length; i++) {
          var m = metas[i], x = a[m.key], y = b[m.key];
          var xn = isNil(x), yn = isNil(y);
          if (xn && yn) continue;
          if (xn) return 1;               // nulls last regardless of direction
          if (yn) return -1;
          var c = 0;
          if (m.fam === 'num') { c = Number(x) - Number(y); }
          else if (m.fam === 'date') { c = String(x) < String(y) ? -1 : (String(x) > String(y) ? 1 : 0); }
          else {
            var xs = String(x).toLowerCase(), ys = String(y).toLowerCase();
            c = xs < ys ? -1 : (xs > ys ? 1 : 0);
          }
          if (c !== 0) return c * m.dir;
        }
        return 0;
      };
    }

    function recompute() {
      if (suspend || !self.hasData()) return;
      var rows = applyCalc(self.masterRows);
      var q = (self.search() || '').trim().toLowerCase();
      if (q) {
        var keys = self.visibleColumns().map(function (c) { return c.key; });
        rows = rows.filter(function (r) {
          for (var i = 0; i < keys.length; i++) {
            var v = r[keys[i]];
            if (!isNil(v) && String(v).toLowerCase().indexOf(q) !== -1) return true;
          }
          return false;
        });
      }
      var flts = self.filters();
      if (flts.length) {
        rows = rows.filter(function (r) {
          for (var i = 0; i < flts.length; i++) {
            if (!passesFilter(r, flts[i])) return false;
          }
          return true;
        });
      }
      var srt = self.sorts();
      if (srt.length) { rows = rows.slice().sort(comparator(srt)); }
      self._filtered = rows;
      self.filteredCount(rows.length);
      self.filteredRev(self.filteredRev() + 1);
      repage();
    }
    self.recompute = recompute;

    function repage() {
      var size = self.pageSize();
      var pages = Math.max(1, Math.ceil(self._filtered.length / size));
      if (self.pageIndex() >= pages) self.pageIndex(pages - 1);
      var off = self.pageIndex() * size;
      self.pageRows(self._filtered.slice(off, off + size));
    }

    subs.push(self.searchLive.subscribe(function () { self.pageIndex(0); recompute(); }));
    subs.push(self.pageSize.subscribe(function () { self.pageIndex(0); repage(); }));
    subs.push(self.pageIndex.subscribe(repage));
    subs.push(self.visibleColumns.subscribe(function () {
      if ((self.search() || '').trim()) recompute();
    }));

    // ── paging UI ─────────────────────────────────────────────────────────
    self.pageInfo = ko.computed(function () {
      self.filteredRev();
      var tot = self.filteredCount();
      if (!tot) return self.t('ir.page.none');
      var from = self.pageIndex() * self.pageSize() + 1;
      var to = Math.min(from + self.pageSize() - 1, tot);
      return self.t('ir.page.range', [from, to, tot]);
    });
    self.pageSizeSel = ko.pureComputed({
      read:  function () { return String(self.pageSize()); },
      write: function (v) { self.pageSize(parseInt(v, 10) || 50); }
    });
    self.prevDisabled = ko.computed(function () { self.filteredRev(); return self.pageIndex() <= 0; });
    self.nextDisabled = ko.computed(function () {
      self.filteredRev();
      return (self.pageIndex() + 1) * self.pageSize() >= self.filteredCount();
    });
    self.prevPage = function () { if (!self.prevDisabled()) self.pageIndex(self.pageIndex() - 1); };
    self.nextPage = function () { if (!self.nextDisabled()) self.pageIndex(self.pageIndex() + 1); };

    // ── sorting ───────────────────────────────────────────────────────────
    self.onHeaderClick = function (col, event) {
      var list = self.sorts().slice();
      var idx = -1, i;
      for (i = 0; i < list.length; i++) { if (list[i].col === col.key) { idx = i; break; } }
      if (event && event.shiftKey) {
        if (idx === -1) list.push({ col: col.key, dir: 'asc' });
        else if (list[idx].dir === 'asc') list[idx] = { col: col.key, dir: 'desc' };
        else list.splice(idx, 1);
      } else {
        if (idx === -1) list = [{ col: col.key, dir: 'asc' }];
        else if (list[idx].dir === 'asc') list = [{ col: col.key, dir: 'desc' }];
        else list = [];
      }
      self.sorts(list);
      recompute();
      return true;
    };
    self.sortBadge = function (key) {
      var list = self.sorts();
      for (var i = 0; i < list.length; i++) {
        if (list[i].col === key) {
          var arrow = list[i].dir === 'asc' ? '▲' : '▼';
          return list.length > 1 ? arrow + (i + 1) : arrow;
        }
      }
      return '';
    };

    // ── panels ────────────────────────────────────────────────────────────
    self.togglePanel = function (name) {
      self.openPanel(self.openPanel() === name ? null : name);
    };
    self.closePanel = function () { self.openPanel(null); };

    // ── column manager ────────────────────────────────────────────────────
    self.colLabel = function (key) {
      var list = self.colState();
      for (var i = 0; i < list.length; i++) {
        if (list[i].key === key && list[i].label()) return list[i].label();
      }
      var c = self.colByKey[key];
      return c ? c.label : key;
    };
    self.colIsCalc = function (key) {
      var c = self.colByKey[key];
      return !!(c && c.isCalc);
    };
    self.colIsNum = function (key) {
      var c = self.colByKey[key];
      return !!(c && famOf(c.type) === 'num');
    };
    self.toggleCol = function (entry) {
      entry.visible(!entry.visible());
      return true;
    };
    self.moveCol = function (entry, delta) {
      var list = self.colState().slice();
      var i = list.indexOf(entry);
      var j = i + delta;
      if (i < 0 || j < 0 || j >= list.length) return;
      list.splice(i, 1);
      list.splice(j, 0, entry);
      self.colState(list);
    };
    self.moveUp   = function (entry) { self.moveCol(entry, -1); };
    self.moveDown = function (entry) { self.moveCol(entry, 1); };
    self.showAllCols = function () {
      self.colState().forEach(function (e) { e.visible(true); });
    };
    self.onAggChange = function () { self.filteredRev(self.filteredRev() + 1); return true; };

    // header-label rename (persists in layouts/autosave via entry.label)
    self.renameColKey  = ko.observable(null);
    self.renameColText = ko.observable('');
    self.startRenameCol = function (entry) {
      self.renameColKey(entry.key);
      self.renameColText(entry.label() || (self.colByKey[entry.key] || {}).label || '');
    };
    self.applyRenameCol = function (entry) {
      var v = String(self.renameColText() || '').trim();
      var base = (self.colByKey[entry.key] || {}).label;
      entry.label(v && v !== base ? v : null);   // empty or unchanged = back to default
      self.renameColKey(null);
    };
    self.cancelRenameCol = function () { self.renameColKey(null); };

    // ── maximize (fullscreen overlay) ─────────────────────────────────────
    self.maximized = ko.observable(false);
    self.toggleMax = function () {
      self.maximized(!self.maximized());
      document.body.style.overflow = self.maximized() ? 'hidden' : '';
    };
    function onKeyDown(e) {
      if (e.key !== 'Escape') return;
      if (self.calcOpen()) { self.calcOpen(false); }
      else if (self.openPanel()) { self.closePanel(); }
      else if (self.maximized()) { self.toggleMax(); }
    }
    document.addEventListener('keydown', onKeyDown);

    // ── aggregates ────────────────────────────────────────────────────────
    self.hasAggs = ko.computed(function () {
      return self.colState().some(function (e) { return e.visible() && e.agg(); });
    });
    self.aggFor = function (col) {
      self.filteredRev();
      var entry = null;
      self.colState().forEach(function (e) { if (e.key === col.key) entry = e; });
      if (!entry || !entry.agg()) return '';
      var kind = entry.agg();
      var rows = self._filtered, n = 0, sum = 0, min = null, max = null, i, v;
      for (i = 0; i < rows.length; i++) {
        v = rows[i][col.key];
        if (isNil(v)) continue;
        v = Number(v);
        if (isNaN(v)) continue;
        n++; sum += v;
        if (min === null || v < min) min = v;
        if (max === null || v > max) max = v;
      }
      var out;
      switch (kind) {
        case 'count': out = n; return self.t('ir.agg.count') + ': ' + i18n.fmtNum(out, 0);
        case 'sum':   out = sum; break;
        case 'avg':   out = n ? sum / n : null; break;
        case 'min':   out = min; break;
        case 'max':   out = max; break;
        default: return '';
      }
      if (out === null) return '';
      return self.t('ir.agg.' + kind) + ': ' + i18n.fmtNum(out, col.type === 'money' ? 2 : (out % 1 === 0 ? 0 : 2));
    };

    // ── filters ───────────────────────────────────────────────────────────
    self.fltCol   = ko.observable('');
    self.fltOp    = ko.observable('contains');
    self.fltVal   = ko.observable('');
    self.fltVal2  = ko.observable('');
    self.fltEditIndex = ko.observable(-1);

    self.allColumnOptions = ko.computed(function () {
      self.calcCols();
      return self.colState().map(effCol).filter(Boolean);
    });
    self.fltColFam = ko.computed(function () {
      var c = self.colByKey[self.fltCol()];
      return famOf(c ? c.type : 'text');
    });
    self.fltOps = ko.computed(function () { return OPS[self.fltColFam()]; });
    self.fltNeedsVal = ko.computed(function () {
      return self.fltOp() !== 'null' && self.fltOp() !== 'notnull';
    });
    self.fltNeedsVal2 = ko.computed(function () { return self.fltOp() === 'between'; });
    self.fltInputType = ko.computed(function () {
      var fam = self.fltColFam();
      return fam === 'num' ? 'number' : (fam === 'date' ? 'date' : 'text');
    });
    subs.push(self.fltCol.subscribe(function () {
      if (self.fltOps().indexOf(self.fltOp()) === -1) self.fltOp(self.fltOps()[0]);
    }));

    self.openFilterNew = function () {
      self.fltEditIndex(-1);
      if (!self.fltCol() && self.allColumnOptions().length) self.fltCol(self.allColumnOptions()[0].key);
      self.openPanel('filter');
    };
    self.editFilter = function (f) {
      var idx = self.filters().indexOf(f);
      self.fltEditIndex(idx);
      self.fltCol(f.col); self.fltOp(f.op);
      self.fltVal(f.val === null || f.val === undefined ? '' : f.val);
      self.fltVal2(f.val2 === null || f.val2 === undefined ? '' : f.val2);
      self.openPanel('filter');
    };
    self.applyFilter = function () {
      if (!self.fltCol()) return;
      if (self.fltNeedsVal() && String(self.fltVal()).trim() === '') {
        toast.warn(self.t('ir.filter.needValue')); return;
      }
      if (self.fltNeedsVal2() && String(self.fltVal2()).trim() === '') {
        toast.warn(self.t('ir.filter.needValue')); return;
      }
      var f = { col: self.fltCol(), op: self.fltOp(),
                val: self.fltNeedsVal() ? self.fltVal() : null,
                val2: self.fltNeedsVal2() ? self.fltVal2() : null };
      var list = self.filters().slice();
      if (self.fltEditIndex() >= 0) list[self.fltEditIndex()] = f; else list.push(f);
      self.filters(list);
      self.fltVal(''); self.fltVal2(''); self.fltEditIndex(-1);
      self.closePanel();
      self.pageIndex(0);
      recompute();
    };
    self.removeFilter = function (f) {
      self.filters.remove(f);
      self.pageIndex(0);
      recompute();
    };
    self.clearFilters = function () {
      self.filters([]);
      self.pageIndex(0);
      recompute();
    };
    self.chipText = function (f) {
      var lbl = self.colLabel(f.col);
      var op = self.t('ir.op.' + f.op);
      if (f.op === 'null' || f.op === 'notnull') return lbl + ' ' + op;
      if (f.op === 'between') return lbl + ' ' + op + ' ' + f.val + ' – ' + f.val2;
      return lbl + ' ' + op + ' ' + f.val;
    };

    // ── calculated columns ────────────────────────────────────────────────
    self.calcOpen    = ko.observable(false);
    self.calcName    = ko.observable('');
    self.calcExpr    = ko.observable('');
    self.calcError   = ko.observable('');
    self.calcPreview = ko.observable('');
    self.calcEditKey = ko.observable(null);

    function calcColumnsUniverse() {
      var cols = self.baseCols.slice();
      self.calcCols().forEach(function (c) {
        if (c.key !== self.calcEditKey()) cols.push({ key: c.key, type: c.type });
      });
      return cols;
    }
    self.calcExprLive = ko.computed(function () { return self.calcExpr(); })
                          .extend({ rateLimit: { timeout: 300, method: 'notifyWhenChangesStop' } });
    subs.push(self.calcExprLive.subscribe(function (txt) {
      if (!self.calcOpen()) return;
      if (!String(txt || '').trim()) { self.calcError(''); self.calcPreview(''); return; }
      try {
        var fn = irExpr.compile(txt, calcColumnsUniverse());
        self.calcError('');
        var sample = self._filtered[0] || applyCalc(self.masterRows.slice(0, 1))[0];
        if (sample) {
          var v = fn.eval(sample);
          self.calcPreview(isNil(v) ? '(null)' : String(v));
        } else { self.calcPreview(''); }
      } catch (e) {
        self.calcError(e.message || String(e));
        self.calcPreview('');
      }
    }));

    self.openCalcNew = function () {
      self.calcEditKey(null); self.calcName(''); self.calcExpr('');
      self.calcError(''); self.calcPreview('');
      self.calcOpen(true);
    };
    self.editCalc = function (key) {
      var c = null;
      self.calcCols().forEach(function (x) { if (x.key === key) c = x; });
      if (!c) return;
      self.calcEditKey(c.key); self.calcName(c.label); self.calcExpr(c.expr);
      self.calcError(''); self.calcPreview('');
      self.calcOpen(true);
    };
    self.closeCalc = function () { self.calcOpen(false); };

    function nextCalcKey() {
      var max = 0;
      self.calcCols().forEach(function (c) {
        var m = /^_CALC_(\d+)$/.exec(c.key);
        if (m) max = Math.max(max, parseInt(m[1], 10));
      });
      return '_CALC_' + (max + 1);
    }
    self.saveCalc = function () {
      var name = String(self.calcName() || '').trim();
      var expr = String(self.calcExpr() || '').trim();
      if (!name) { self.calcError(self.t('ir.calc.needName')); return; }
      if (!expr) { self.calcError(self.t('ir.calc.needExpr')); return; }
      var fn;
      try { fn = irExpr.compile(expr, calcColumnsUniverse()); }
      catch (e) { self.calcError(e.message || String(e)); return; }
      var key = self.calcEditKey() || nextCalcKey();
      var col = { key: key, label: name, expr: expr, type: fn.type === 'num' ? 'num' : 'text' };
      self._calcFns[key] = fn;
      var list = self.calcCols().slice();
      var replaced = false;
      for (var i = 0; i < list.length; i++) {
        if (list[i].key === key) { list[i] = col; replaced = true; break; }
      }
      if (!replaced) list.push(col);
      self.calcCols(list);
      rebuildColIndex();
      reconcileColState();
      self.calcOpen(false);
      recompute();
    };
    self.removeCalc = function (key) {
      self.calcCols(self.calcCols().filter(function (c) { return c.key !== key; }));
      delete self._calcFns[key];
      self.filters(self.filters().filter(function (f) { return f.col !== key; }));
      self.sorts(self.sorts().filter(function (s) { return s.col !== key; }));
      rebuildColIndex();
      self.colState(self.colState().filter(function (e) { return e.key !== key; }));
      recompute();
    };

    // rebuild compiled fns from persisted expressions (layout/autosave restore)
    function recompileCalcs(calcDefs) {
      var out = [];
      self._calcFns = {};
      (calcDefs || []).forEach(function (c) {
        try {
          var cols = self.baseCols.slice();
          out.forEach(function (p) { cols.push({ key: p.key, type: p.type }); });
          var fn = irExpr.compile(c.expr, cols);
          self._calcFns[c.key] = fn;
          out.push({ key: c.key, label: c.label, expr: c.expr, type: fn.type === 'num' ? 'num' : 'text' });
        } catch (e) { /* stale expression (column gone) — drop silently */ }
      });
      self.calcCols(out);
    }

    // ── state (layouts + autosave) ────────────────────────────────────────
    self.appliedLayout = ko.observable(null);   // {id, name, json}

    function currentState() {
      return {
        v: 1,
        section: ko.unwrap(self.section) || '',
        columns: self.colState().map(function (e) {
          return { key: e.key, visible: e.visible(), label: e.label() || undefined };
        }),
        filters: self.filters().map(function (f) { return { col: f.col, op: f.op, val: f.val, val2: f.val2 }; }),
        sorts:   self.sorts().map(function (s) { return { col: s.col, dir: s.dir }; }),
        calc:    self.calcCols().map(function (c) { return { key: c.key, label: c.label, expr: c.expr }; }),
        aggs:    self.colState().filter(function (e) { return !!e.agg(); })
                     .map(function (e) { return { key: e.key, agg: e.agg() }; }),
        search:  self.search(),
        pageSize: self.pageSize()
      };
    }
    self.stateJson = ko.computed(function () {
      self.filteredRev();
      return JSON.stringify(currentState());
    }).extend({ rateLimit: { timeout: 400, method: 'notifyWhenChangesStop' } });

    self.layoutDirty = ko.computed(function () {
      var app = self.appliedLayout();
      return !!(app && self.stateJson() !== app.json);
    });

    function applyState(st) {
      if (!st || typeof st !== 'object') return;
      suspend = true;
      recompileCalcs(st.calc);
      rebuildColIndex();
      var entries = [];
      var seen = {};
      (st.columns || []).forEach(function (c) {
        if (self.colByKey[c.key] && !seen[c.key]) {
          seen[c.key] = true;
          var en = entryFor(c.key, c.visible !== false);
          if (c.label) en.label(String(c.label));
          entries.push(en);
        }
      });
      Object.keys(self.colByKey).forEach(function (k) {
        if (!seen[k]) entries.push(entryFor(k, true));
      });
      (st.aggs || []).forEach(function (a) {
        entries.forEach(function (e) { if (e.key === a.key) e.agg(a.agg); });
      });
      self.colState(entries);
      self.filters((st.filters || []).filter(function (f) { return !!self.colByKey[f.col]; }));
      self.sorts((st.sorts || []).filter(function (s) { return !!self.colByKey[s.col]; }));
      self.search(st.search || '');
      if (PAGE_SIZES.indexOf(st.pageSize) !== -1) self.pageSize(st.pageSize);
      self.pageIndex(0);
      suspend = false;
      recompute();
    }
    self.resetState = function () {
      suspend = true;
      self.calcCols([]); self._calcFns = {};
      rebuildColIndex();
      resetColState();
      self.filters([]); self.sorts([]); self.search('');
      self.appliedLayout(null);
      self.pageIndex(0);
      suspend = false;
      recompute();
      try { localStorage.removeItem(lsKey()); } catch (e) { /* ignore */ }
    };

    // autosave (browser last-state; separate from named layouts)
    function lsKey() { return 'bi.ir.' + stateKey; }
    subs.push(self.stateJson.subscribe(function (json) {
      if (!self.hasData() || !stateKey) return;
      try { localStorage.setItem(lsKey(), json); } catch (e) { /* storage full — ignore */ }
    }));
    function restoreAutosave() {
      try {
        var raw = localStorage.getItem(lsKey());
        if (!raw) return false;
        applyState(JSON.parse(raw));
        return true;
      } catch (e) { return false; }
    }

    // ── layouts (server-saved, named) ─────────────────────────────────────
    self.layouts       = ko.observableArray([]);
    self.layoutsBusy   = ko.observable(false);
    self.saveAsName    = ko.observable('');
    self.renameId      = ko.observable(null);
    self.renameText    = ko.observable('');
    var wantDefault    = false;   // default layout still owed (layouts load async)

    function loadLayouts() {
      if (!self.layoutsApi) return Promise.resolve();
      var code = ko.unwrap(self.reportCode);
      if (!code) return Promise.resolve();
      self.layoutsBusy(true);
      return self.layoutsApi.list(code).then(function (r) {
        self.layouts(r.items || []);
        if (wantDefault && self.hasData()) applyDefaultLayout();
      }).catch(function () {}).then(function () { self.layoutsBusy(false); });
    }
    self.loadLayouts = loadLayouts;
    loadLayouts();

    function applyDefaultLayout() {
      var mine = self.layouts().filter(function (l) {
        return l.isMine === 'Y' && l.isDefault === 'Y';
      });
      if (mine.length) {
        wantDefault = false;
        self.applyLayout(mine[0]);
      }
    }

    self.applyLayout = function (l) {
      try {
        applyState(JSON.parse(l.layoutJson));
        self.appliedLayout({ id: l.layoutId, name: l.layoutName,
                             mine: l.isMine === 'Y', json: JSON.stringify(currentState()) });
        self.closePanel();
      } catch (e) { toast.error(self.t('ir.layout.badJson')); }
    };
    self.saveLayout = function () {
      var app = self.appliedLayout();
      if (!app || !app.mine) { return; }
      var json = JSON.stringify(currentState());
      self.layoutsApi.update(app.id, { layoutJson: json }).then(function () {
        self.appliedLayout({ id: app.id, name: app.name, mine: true, json: json });
        toast.success(self.t('ir.layout.saved'));
        loadLayouts();
      }).catch(function () {});
    };
    self.saveLayoutAs = function () {
      var name = String(self.saveAsName() || '').trim();
      if (!name) { toast.warn(self.t('ir.layout.needName')); return; }
      var json = JSON.stringify(currentState());
      self.layoutsApi.create({
        reportCode: ko.unwrap(self.reportCode),
        layoutName: name,
        isShared: 'N',
        isDefault: 'N',
        layoutJson: json
      }).then(function (r) {
        self.saveAsName('');
        self.appliedLayout({ id: r.layoutId, name: name, mine: true, json: json });
        toast.success(self.t('ir.layout.saved'));
        loadLayouts();
      }).catch(function () {});
    };
    self.deleteLayout = function (l) {
      if (!window.confirm(self.t('ir.layout.confirmDelete', [l.layoutName]))) return;
      self.layoutsApi.remove(l.layoutId).then(function () {
        var app = self.appliedLayout();
        if (app && app.id === l.layoutId) self.appliedLayout(null);
        loadLayouts();
      }).catch(function () {});
    };
    self.setDefaultLayout = function (l) {
      self.layoutsApi.update(l.layoutId, { isDefault: l.isDefault === 'Y' ? 'N' : 'Y' })
        .then(loadLayouts).catch(function () {});
    };
    self.toggleShareLayout = function (l) {
      self.layoutsApi.update(l.layoutId, { isShared: l.isShared === 'Y' ? 'N' : 'Y' })
        .then(loadLayouts).catch(function () {});
    };
    self.startRename = function (l) {
      self.renameId(l.layoutId);
      self.renameText(l.layoutName);
    };
    self.applyRename = function (l) {
      var name = String(self.renameText() || '').trim();
      if (!name) return;
      self.layoutsApi.update(l.layoutId, { layoutName: name }).then(function () {
        var app = self.appliedLayout();
        if (app && app.id === l.layoutId) {
          self.appliedLayout({ id: app.id, name: name, mine: app.mine, json: app.json });
        }
        self.renameId(null);
        loadLayouts();
      }).catch(function () {});
    };
    self.cancelRename = function () { self.renameId(null); };

    // ── export ────────────────────────────────────────────────────────────
    function exportValue(row, col, forXlsx) {
      var v = row[col.key];
      if (isNil(v)) return forXlsx ? null : '';
      if (col.type === 'date') return String(v).substring(0, 10);
      if (col.type === 'num' || col.type === 'money') {
        var n = Number(v);
        return isNaN(n) ? String(v) : n;
      }
      return String(v);
    }
    function exportFileBase() {
      var code = ko.unwrap(self.reportCode) || 'report';
      var sec = ko.unwrap(self.section);
      var d = new Date();
      var stamp = d.getFullYear() + ('0' + (d.getMonth() + 1)).slice(-2) + ('0' + d.getDate()).slice(-2);
      return (code + (sec ? '_' + sec : '') + '_' + stamp).replace(/[^A-Za-z0-9_.-]/g, '_');
    }
    self.exportCsv = function () {
      var cols = self.visibleColumns();
      var lines = [cols.map(function (c) {
        return '"' + String(c.label).replace(/"/g, '""') + '"';
      }).join(',')];
      self._filtered.forEach(function (r) {
        lines.push(cols.map(function (c) {
          return '"' + String(exportValue(r, c, false)).replace(/"/g, '""') + '"';
        }).join(','));
      });
      var blob = new Blob(['\ufeff' + lines.join('\r\n')], { type: 'text/csv;charset=utf-8' });
      var url = URL.createObjectURL(blob);
      var a = document.createElement('a');
      a.href = url; a.download = exportFileBase() + '.csv';
      document.body.appendChild(a); a.click(); document.body.removeChild(a);
      setTimeout(function () { URL.revokeObjectURL(url); }, 5000);
    };
    self.exportXlsx = function () {
      require(['xlsx'], function (XLSX) {
        var cols = self.visibleColumns();
        var aoa = [cols.map(function (c) { return c.label; })];
        self._filtered.forEach(function (r) {
          aoa.push(cols.map(function (c) { return exportValue(r, c, true); }));
        });
        var ws = XLSX.utils.aoa_to_sheet(aoa);
        var wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, 'Data');
        XLSX.writeFile(wb, exportFileBase() + '.xlsx');
      }, function () { toast.error(self.t('ir.export.xlsxFail')); });
    };

    // ── cell rendering ────────────────────────────────────────────────────
    self.cellText = function (row, col) {
      var v = row[col.key];
      if (isNil(v)) return '';
      if (col.type === 'money') return i18n.fmtNum(v, 2);
      if (col.type === 'num') {
        var n = Number(v);
        if (isNaN(n)) return String(v);
        return i18n.fmtNum(n, n % 1 === 0 ? 0 : 2);
      }
      if (col.type === 'date') {
        var s = String(v);
        return s.length >= 10 ? s.substring(0, 10) : s;
      }
      return String(v);
    };
    self.cellClass = function (col) {
      return famOf(col.type) === 'num' ? 'ir-num' : '';
    };

    // consume the envelope that may already be present
    if (self.dataObs()) onData(self.dataObs());

    self.dispose = function () {
      subs.forEach(function (s) { try { s.dispose(); } catch (e) { /* ignore */ } });
      document.removeEventListener('keydown', onKeyDown);
      if (self.maximized()) { document.body.style.overflow = ''; }
    };
  }

  if (!ko.components.isRegistered('interactive-report')) {
    ko.components.register('interactive-report', {
      viewModel: { createViewModel: function (params) { return new IrVM(params); } },
      template: templateHtml
    });
  }

  return { registered: true };
});
