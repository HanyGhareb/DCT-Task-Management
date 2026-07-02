/**
 * irViewer.js — Interactive Reports viewer (BI_USER + SYS_ADMIN).
 * Catalog of runnable definitions → parameter prompt (defaults from the
 * definition's params_json; MULTI adds a section picker) → one-shot capped
 * data fetch handed to the <interactive-report> grid.
 */
define(['knockout', 'services/rptService', 'services/authService', 'shared/toast',
        'shared/i18n', 'shared/components/interactiveReport'],
function (ko, rpt, authService, toast, i18n) {
  'use strict';

  function IrViewerViewModel() {
    var self = this;
    var st = (window._jetApp && window._jetApp.getState()) || {};

    self.isAdmin = authService.isReportAdmin();

    // ── catalog ─────────────────────────────────────────────────────────
    self.catLoading  = ko.observable(true);
    self.catalog     = ko.observableArray([]);
    self.catSearch   = ko.observable('');
    self.catCategory = ko.observable('');

    self.categories = ko.computed(function () {
      var seen = {}, out = [];
      self.catalog().forEach(function (r) {
        var c = r.category || '';
        if (c && !seen[c]) { seen[c] = true; out.push(c); }
      });
      return out.sort();
    });
    self.filteredCatalog = ko.computed(function () {
      var q = (self.catSearch() || '').trim().toLowerCase();
      var cat = self.catCategory();
      return self.catalog().filter(function (r) {
        if (cat && (r.category || '') !== cat) return false;
        if (!q) return true;
        return ((r.reportCode || '') + ' ' + (r.nameEn || '') + ' ' + (r.nameAr || '') + ' ' +
                (r.description || '')).toLowerCase().indexOf(q) !== -1;
      });
    });

    // ── selection + run surface ─────────────────────────────────────────
    self.selected   = ko.observable(null);      // catalog item
    self.runParams  = ko.observableArray([]);   // [{key, required, value: ko.observable}]
    self.sections   = ko.observableArray([]);   // [{key,title}] for MULTI
    self.sectionSel = ko.observable('');
    self.irLoading  = ko.observable(false);
    self.irData     = ko.observable(null);      // envelope for <interactive-report>
    self.irCode     = ko.observable('');
    self.irSection  = ko.observable('');

    self.layoutsApi = {
      list:   rpt.getIrLayouts,
      create: rpt.createIrLayout,
      update: rpt.updateIrLayout,
      remove: rpt.deleteIrLayout
    };

    function defaultsOf(item) {
      try {
        var obj = JSON.parse(item.paramsJson || '');
        return (obj && typeof obj === 'object' && !Array.isArray(obj)) ? obj : {};
      } catch (e) { return {}; }
    }

    self.select = function (item) {
      self.selected(item);
      self.irData(null);
      var defaults = defaultsOf(item);
      var required = {};
      (item.requiredParams || []).forEach(function (k) { required[String(k).toLowerCase()] = true; });
      function rowOf(key, spec) {
        var d = defaults.hasOwnProperty(key) ? defaults[key] : defaults[String(key).toLowerCase()];
        spec = spec || {};
        return {
          key: key,
          label: spec.label || key,
          labelAr: spec.labelAr || '',
          hint: spec.hint || '',
          hintAr: spec.hintAr || '',
          required: spec.required === true || !!required[String(key).toLowerCase()],
          hasLov: spec.hasLov === true,
          options: ko.observableArray([]),
          value: ko.observable(d === null || d === undefined ? '' : String(d))
        };
      }
      var rows;
      if ((item.params || []).length) {
        // spec-driven (catalog params[] carries labels/hints/required/hasLov)
        rows = item.params.map(function (p) { return rowOf(p.name, p); });
        var have = rows.map(function (r) { return String(r.key).toLowerCase(); });
        (item.requiredParams || []).forEach(function (k) {
          if (have.indexOf(String(k).toLowerCase()) === -1) rows.push(rowOf(k, { required: true }));
        });
      } else {
        // legacy fallback: derive from defaults + MULTI required[]
        var lov = {};
        (item.lovParams || []).forEach(function (k) { lov[String(k).toLowerCase()] = true; });
        var keys = Object.keys(defaults);
        (item.requiredParams || []).forEach(function (k) {
          if (keys.indexOf(k) === -1 && keys.indexOf(String(k).toLowerCase()) === -1) keys.push(k);
        });
        rows = keys.map(function (k) {
          return rowOf(k, { hasLov: !!lov[String(k).toLowerCase()] });
        });
      }
      self.runParams(rows);
      // populate the dropdowns (params declared in the definition's LOV map)
      self.runParams().forEach(function (p) {
        if (!p.hasLov) return;
        rpt.getIrLov(item.reportCode, p.key).then(function (r) {
          p.options(r.items || []);
        }).catch(function () { p.options([]); });
      });
      self.sections(item.sections || []);
      self.sectionSel(self.sections().length ? self.sections()[0].key : '');
      // auto-run when the report needs no input at all
      if (!self.runParams().length && !self.sections().length) { self.run(); }
    };

    self.backToCatalog = function () {
      self.selected(null);
      self.irData(null);
    };

    self.run = function () {
      if (self.irLoading()) return;
      var item = self.selected();
      if (!item) return;
      var params = {}, missing = [];
      self.runParams().forEach(function (p) {
        var v = String(p.value() === null || p.value() === undefined ? '' : p.value()).trim();
        if (v === '') {
          if (p.required) {
            missing.push((i18n.lang() === 'ar' && p.labelAr) ? p.labelAr : (p.label || p.key));
          }
          return;
        }
        params[p.key] = /^-?\d+(\.\d+)?$/.test(v) ? Number(v) : v;
      });
      if (missing.length) {
        toast.warn(i18n.t('ir.viewer.missing', [missing.join(', ')]));
        return;
      }
      var body = { params: params };
      if (self.sections().length) body.section = self.sectionSel();
      self.irCode(item.reportCode);
      self.irSection(body.section || '');
      self.irLoading(true);
      rpt.getIrData(item.reportCode, body).then(function (env) {
        self.irData(env);
      }).catch(function () {}).then(function () { self.irLoading(false); });
    };

    // ── boot ────────────────────────────────────────────────────────────
    rpt.getIrCatalog().then(function (r) {
      self.catalog(r.items || []);
      // deep-link: navigate('irViewer', { reportCode, section? })
      if (st.reportCode) {
        var hit = self.catalog().filter(function (x) { return x.reportCode === st.reportCode; });
        st.reportCode = null;
        if (hit.length) {
          self.select(hit[0]);
          if (st.section) { self.sectionSel(st.section); st.section = null; }
        }
      }
    }).catch(function () {}).then(function () { self.catLoading(false); });
  }

  return IrViewerViewModel;
});
