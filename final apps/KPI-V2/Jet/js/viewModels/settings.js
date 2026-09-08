/**
 * settings.js — Settings page (Phases 1–3).
 * Sub-tabs: Manage Lookups (P1) · Manage KPIs (P2) · Manage Security (P3).
 * Backend = additive kpi.rest v2 routes (KPI-V2/db/02 + 04):
 *   lookups:  GET/POST /v2/lookups · PUT /v2/lookups/:id
 *             GET/POST /v2/lookups/:id/values · PUT /v2/lookup-values/:id
 *   KPIs:     GET /v2/kpi-lovs · GET/POST /v2/kpis · GET/PUT /v2/kpis/:id
 * Security tab = at-a-glance KPI security model (seeded by KPI-V2/db/05,
 * enforcement OFF) + deep links into the Admin Security Console.
 * Drawer-body gotcha: bodies rebind to THIS VM; use bare t(...) at the top
 * level and $parent.* inside drawer foreach loops (never $vm / $root there).
 */
define(['knockout', 'services/api', 'shared/i18n', 'shared/toast'],
function (ko, api, i18n, toast) {
  'use strict';

  function SettingsViewModel() {
    var self = this;

    self.t = i18n.t;

    // ── sub-tab navigation ──────────────────────────────────────────
    self.nav = ko.observable('lookups');

    // ════════════════════════════════════════════════════════════════
    // Sub-tab 1 — Manage Lookups (Phase 1)
    // ════════════════════════════════════════════════════════════════
    self.lookups        = ko.observableArray([]);
    self.lookupsLoading = ko.observable(true);
    self.selected       = ko.observable(null);
    self.values         = ko.observableArray([]);
    self.valuesLoading  = ko.observable(false);

    // APEX_JSON omits NULL keys — normalise every nullable field.
    function normLk(r) {
      return {
        id: r.id, code: r.code,
        nameEn: r.nameEn || '', nameAr: r.nameAr || '',
        isActive: r.isActive || 'Y',
        valueCount: r.valueCount || 0, effectiveCount: r.effectiveCount || 0,
        updatedAt: r.updatedAt || '', updatedBy: r.updatedBy || ''
      };
    }
    function normVal(r) {
      return {
        id: r.id, code: r.code,
        nameEn: r.nameEn || '', nameAr: r.nameAr || '',
        descriptionEn: r.descriptionEn || '', descriptionAr: r.descriptionAr || '',
        startDate: r.startDate || '', endDate: r.endDate || '',
        displayOrder: r.displayOrder || 0,
        isDefault: r.isDefault || 'N', isActive: r.isActive || 'Y',
        effectiveStatus: r.effectiveStatus || 'ACTIVE',
        updatedAt: r.updatedAt || '', updatedBy: r.updatedBy || ''
      };
    }

    self.ln = function (it) {
      return (i18n.lang() === 'ar' && it.nameAr) ? it.nameAr : it.nameEn;
    };
    self.ldesc = function (it) {
      return (i18n.lang() === 'ar' && it.descriptionAr) ? it.descriptionAr : it.descriptionEn;
    };
    self.stCls = function (s) {
      return { ACTIVE: 'ok', INACTIVE: 'muted', EXPIRED: 'warn', PENDING: 'gold' }[s] || 'muted';
    };
    self.stTxt = function (s) {
      return i18n.t('set.st.' + String(s || '').toLowerCase());
    };

    self.loadLookups = function (keepSelection) {
      self.lookupsLoading(true);
      return api.get('/v2/lookups').then(function (d) {
        var items = (d.items || []).map(normLk);
        self.lookups(items);
        if (keepSelection && self.selected()) {
          var id = self.selected().id, cur = null;
          for (var i = 0; i < items.length; i++) if (items[i].id === id) { cur = items[i]; break; }
          self.selected(cur);
        }
        self.lookupsLoading(false);
      }).catch(function () { self.lookupsLoading(false); });
    };

    self.loadValues = function () {
      if (!self.selected()) { self.values([]); return; }
      self.valuesLoading(true);
      return api.get('/v2/lookups/' + self.selected().id + '/values').then(function (d) {
        self.values((d.items || []).map(normVal));
        self.valuesLoading(false);
      }).catch(function () { self.valuesLoading(false); });
    };

    self.selectLookup = function (l) {
      self.selected(l);
      self.loadValues();
      return true;
    };

    // lookup (master) drawer
    self.showLkDrawer = ko.observable(false);
    self.lkEditing    = ko.observable(false);
    self.lkSaving     = ko.observable(false);
    self.lkErr        = ko.observable('');
    self.lkForm = {
      code:     ko.observable(''),
      nameEn:   ko.observable(''),
      nameAr:   ko.observable(''),
      isActive: ko.observable(true)
    };
    self.lkDrawerTitle = ko.computed(function () {
      return i18n.t(self.lkEditing() ? 'set.lk.editLookup' : 'set.lk.newLookup');
    });

    self.openNewLookup = function () {
      self.lkEditing(false); self.lkErr('');
      self.lkForm.code(''); self.lkForm.nameEn(''); self.lkForm.nameAr('');
      self.lkForm.isActive(true);
      self.showLkDrawer(true);
    };
    self.openEditLookup = function () {
      var l = self.selected(); if (!l) return;
      self.lkEditing(true); self.lkErr('');
      self.lkForm.code(l.code); self.lkForm.nameEn(l.nameEn); self.lkForm.nameAr(l.nameAr);
      self.lkForm.isActive(l.isActive === 'Y');
      self.showLkDrawer(true);
    };
    self.saveLookup = function () {
      if (self.lkSaving()) return;
      var code = (self.lkForm.code() || '').trim().toUpperCase();
      var nameEn = (self.lkForm.nameEn() || '').trim();
      if (!code || !nameEn) { self.lkErr(i18n.t('set.msg.reqd')); return; }
      self.lkErr(''); self.lkSaving(true);
      var body = {
        code: code, nameEn: nameEn,
        nameAr: (self.lkForm.nameAr() || '').trim(),
        isActive: self.lkForm.isActive() ? 'Y' : 'N'
      };
      var p = self.lkEditing()
        ? api.put('/v2/lookups/' + self.selected().id, body)
        : api.post('/v2/lookups', body);
      p.then(function () {
        self.lkSaving(false); self.showLkDrawer(false);
        toast.success(i18n.t('set.msg.saved'));
        self.loadLookups(true);
      }).catch(function (e) {
        self.lkSaving(false);
        self.lkErr((e && e.message) || i18n.t('set.msg.failed'));
      });
    };

    // value drawer
    self.showValDrawer = ko.observable(false);
    self.valEditing    = ko.observable(false);
    self.valSaving     = ko.observable(false);
    self.valErr        = ko.observable('');
    self.valId         = null;
    self.valForm = {
      code:          ko.observable(''),
      nameEn:        ko.observable(''),
      nameAr:        ko.observable(''),
      descriptionEn: ko.observable(''),
      descriptionAr: ko.observable(''),
      startDate:     ko.observable(''),
      endDate:       ko.observable(''),
      displayOrder:  ko.observable(0),
      isDefault:     ko.observable(false),
      isActive:      ko.observable(true)
    };
    self.valDrawerTitle = ko.computed(function () {
      return i18n.t(self.valEditing() ? 'set.lk.editValue' : 'set.lk.newValue');
    });
    self.valDrawerSub = ko.computed(function () {
      var l = self.selected();
      return l ? (l.code + ' · ' + self.ln(l)) : '';
    });

    self.openNewValue = function () {
      if (!self.selected()) return;
      self.valEditing(false); self.valErr(''); self.valId = null;
      self.valForm.code(''); self.valForm.nameEn(''); self.valForm.nameAr('');
      self.valForm.descriptionEn(''); self.valForm.descriptionAr('');
      self.valForm.startDate(''); self.valForm.endDate('');
      var next = 10;
      self.values().forEach(function (v) { if (v.displayOrder >= next) next = v.displayOrder + 10; });
      self.valForm.displayOrder(next);
      self.valForm.isDefault(false); self.valForm.isActive(true);
      self.showValDrawer(true);
    };
    self.openEditValue = function (v) {
      self.valEditing(true); self.valErr(''); self.valId = v.id;
      self.valForm.code(v.code); self.valForm.nameEn(v.nameEn); self.valForm.nameAr(v.nameAr);
      self.valForm.descriptionEn(v.descriptionEn); self.valForm.descriptionAr(v.descriptionAr);
      self.valForm.startDate(v.startDate); self.valForm.endDate(v.endDate);
      self.valForm.displayOrder(v.displayOrder);
      self.valForm.isDefault(v.isDefault === 'Y'); self.valForm.isActive(v.isActive === 'Y');
      self.showValDrawer(true);
      return true;
    };
    self.saveValue = function () {
      if (self.valSaving()) return;
      var code = (self.valForm.code() || '').trim().toUpperCase();
      var nameEn = (self.valForm.nameEn() || '').trim();
      if (!code || !nameEn) { self.valErr(i18n.t('set.msg.reqd')); return; }
      var sd = self.valForm.startDate() || '', ed = self.valForm.endDate() || '';
      if (sd && ed && ed < sd) { self.valErr(i18n.t('set.msg.dates')); return; }
      self.valErr(''); self.valSaving(true);
      var body = {
        code: code, nameEn: nameEn,
        nameAr: (self.valForm.nameAr() || '').trim(),
        descriptionEn: (self.valForm.descriptionEn() || '').trim(),
        descriptionAr: (self.valForm.descriptionAr() || '').trim(),
        startDate: sd, endDate: ed,
        displayOrder: parseInt(self.valForm.displayOrder(), 10) || 0,
        isDefault: self.valForm.isDefault() ? 'Y' : 'N',
        isActive: self.valForm.isActive() ? 'Y' : 'N'
      };
      var p = self.valEditing()
        ? api.put('/v2/lookup-values/' + self.valId, body)
        : api.post('/v2/lookups/' + self.selected().id + '/values', body);
      p.then(function () {
        self.valSaving(false); self.showValDrawer(false);
        toast.success(i18n.t('set.msg.saved'));
        self.loadValues();
        self.loadLookups(true);
      }).catch(function (e) {
        self.valSaving(false);
        self.valErr((e && e.message) || i18n.t('set.msg.failed'));
      });
    };

    // ── CSV export helper (UTF-8 BOM) ───────────────────────────────
    function csvEsc(v) {
      v = (v === null || v === undefined) ? '' : String(v);
      return /[",\n]/.test(v) ? '"' + v.replace(/"/g, '""') + '"' : v;
    }
    function downloadCsv(name, header, rows) {
      var lines = [header.join(',')];
      rows.forEach(function (r) { lines.push(r.map(csvEsc).join(',')); });
      var blob = new Blob(['\ufeff' + lines.join('\r\n')], { type: 'text/csv;charset=utf-8' });
      var a = document.createElement('a');
      a.href = URL.createObjectURL(blob); a.download = name;
      document.body.appendChild(a); a.click();
      setTimeout(function () { URL.revokeObjectURL(a.href); a.remove(); }, 400);
    }
    self.exportLookupsCsv = function () {
      downloadCsv('kpi-lookups.csv',
        ['Code', 'Name (EN)', 'Name (AR)', 'Values', 'Effective Values', 'Active', 'Updated By', 'Updated At'],
        self.lookups().map(function (l) {
          return [l.code, l.nameEn, l.nameAr, l.valueCount, l.effectiveCount, l.isActive, l.updatedBy, l.updatedAt];
        }));
    };
    self.exportValuesCsv = function () {
      var l = self.selected(); if (!l) return;
      downloadCsv('kpi-lookup-' + l.code.toLowerCase() + '.csv',
        ['Code', 'Name (EN)', 'Name (AR)', 'Description (EN)', 'Description (AR)',
         'Start Date', 'End Date', 'Order', 'Default', 'Active', 'Status', 'Updated By', 'Updated At'],
        self.values().map(function (v) {
          return [v.code, v.nameEn, v.nameAr, v.descriptionEn, v.descriptionAr,
                  v.startDate, v.endDate, v.displayOrder, v.isDefault, v.isActive,
                  v.effectiveStatus, v.updatedBy, v.updatedAt];
        }));
    };

    // ════════════════════════════════════════════════════════════════
    // Sub-tab 2 — Manage KPIs (Phase 2)
    // ════════════════════════════════════════════════════════════════
    self.kpis        = ko.observableArray([]);
    self.kpisLoading = ko.observable(false);
    self.lovItems    = ko.observableArray([]);   // all KPI2_* + KPI_BAND_OP values
    var lovsLoaded = false, kpisLoaded = false;

    function normKpi(r) {
      return {
        id: r.id, code: r.code,
        nameEn: r.nameEn || '', nameAr: r.nameAr || '',
        type: r.type || '', category: r.category || '',
        reportingFreq: r.reportingFreq || '', updatingFreq: r.updatingFreq || '',
        polarity: r.polarity || '', calcMethod: r.calcMethod || '', uom: r.uom || '',
        evidenceRequired: r.evidenceRequired || 'N', isActive: r.isActive || 'Y',
        sourceCount: r.sourceCount || 0, figureCount: r.figureCount || 0,
        bandCount: r.bandCount || 0,
        updatedAt: r.updatedAt || '', updatedBy: r.updatedBy || ''
      };
    }

    self.loadLovs = function () {
      return api.get('/v2/kpi-lovs').then(function (d) {
        self.lovItems(d.items || []);
        lovsLoaded = true;
      }).catch(function () {});
    };
    self.loadKpis = function () {
      self.kpisLoading(true);
      return api.get('/v2/kpis').then(function (d) {
        self.kpis((d.items || []).map(normKpi));
        kpisLoaded = true;
        self.kpisLoading(false);
      }).catch(function () { self.kpisLoading(false); });
    };
    self.goKpis = function () {
      self.nav('kpis');
      if (!lovsLoaded) self.loadLovs();
      if (!kpisLoaded) self.loadKpis();
    };

    /* Effective values of a category for selects/chips; re-injects the current
       stored code when it is no longer effective (KO options rule: a value
       absent from its list is silently blanked). */
    self.lovOpts = function (cat, curObs) {
      var all = self.lovItems();
      var out = all.filter(function (i) { return i.category === cat && i.eff === 'Y'; });
      var cur = (curObs && ko.isObservable(curObs)) ? curObs() : null;
      if (cur && !out.some(function (i) { return i.code === cur; })) {
        var found = null;
        all.forEach(function (i) { if (i.category === cat && i.code === cur) found = i; });
        out = out.concat([found || { category: cat, code: cur, nameEn: cur, nameAr: cur, eff: 'N' }]);
      }
      return out;
    };
    self.lovLabel = function (i) {
      return (i18n.lang() === 'ar' && i.nameAr) ? i.nameAr : i.nameEn;
    };
    self.lovName = function (cat, code) {
      if (!code) return '';
      var all = self.lovItems(), hit = null;
      all.forEach(function (i) { if (i.category === cat && i.code === code) hit = i; });
      return hit ? self.lovLabel(hit) : code;
    };

    // search criteria (client-side over the loaded register)
    self.kSearch  = ko.observable('');
    self.kFType   = ko.observable('');
    self.kFFreq   = ko.observable('');
    self.kFStatus = ko.observable('');
    self.resetKpiFilters = function () {
      self.kSearch(''); self.kFType(''); self.kFFreq(''); self.kFStatus('');
    };
    self.filteredKpis = ko.computed(function () {
      var s = (self.kSearch() || '').toLowerCase();
      var ft = self.kFType() || '', ff = self.kFFreq() || '', fs = self.kFStatus() || '';
      return self.kpis().filter(function (k) {
        if (s && k.code.toLowerCase().indexOf(s) < 0
              && k.nameEn.toLowerCase().indexOf(s) < 0
              && (k.nameAr || '').indexOf(self.kSearch()) < 0) return false;
        if (ft && k.type !== ft) return false;
        if (ff && k.reportingFreq !== ff) return false;
        if (fs && k.isActive !== fs) return false;
        return true;
      });
    });

    // ── KPI drawer ──────────────────────────────────────────────────
    self.showKpiDrawer = ko.observable(false);
    self.kpiEditing    = ko.observable(false);
    self.kpiSaving     = ko.observable(false);
    self.kpiErr        = ko.observable('');
    self.kpiId         = null;
    self.kForm = {
      code:             ko.observable(''),
      nameEn:           ko.observable(''),
      nameAr:           ko.observable(''),
      descriptionEn:    ko.observable(''),
      descriptionAr:    ko.observable(''),
      type:             ko.observable(''),
      category:         ko.observable(''),
      reportingFreq:    ko.observable(''),
      updatingFreq:     ko.observable(''),
      polarity:         ko.observable(''),
      calcMethod:       ko.observable(''),
      uom:              ko.observable(''),
      evidenceRequired: ko.observable(false),
      isActive:         ko.observable(true)
    };
    self.selectedSources = ko.observableArray([]);
    self.selectedFigures = ko.observableArray([]);
    self.bandRows = [5, 4, 3, 2, 1].map(function (s) {
      return {
        score: s,
        operator: ko.observable(''),
        t1: ko.observable(''), t2: ko.observable(''),
        labelEn: ko.observable(''), labelAr: ko.observable('')
      };
    });
    self.kpiDrawerTitle = ko.computed(function () {
      return i18n.t(self.kpiEditing() ? 'set.k.editKpi' : 'set.k.newKpi');
    });
    self.kpiDrawerSub = ko.computed(function () {
      return self.kpiEditing() ? (self.kForm.code() || '') : '';
    });

    self.isSourcePicked = function (code) { return self.selectedSources.indexOf(code) >= 0; };
    self.toggleSource = function (code) {
      var i = self.selectedSources.indexOf(code);
      if (i >= 0) self.selectedSources.splice(i, 1); else self.selectedSources.push(code);
    };
    self.isFigurePicked = function (code) { return self.selectedFigures.indexOf(code) >= 0; };
    self.toggleFigure = function (code) {
      var i = self.selectedFigures.indexOf(code);
      if (i >= 0) self.selectedFigures.splice(i, 1); else self.selectedFigures.push(code);
    };

    function resetKpiForm() {
      self.kForm.code(''); self.kForm.nameEn(''); self.kForm.nameAr('');
      self.kForm.descriptionEn(''); self.kForm.descriptionAr('');
      self.kForm.type(''); self.kForm.category('');
      self.kForm.reportingFreq(''); self.kForm.updatingFreq('');
      self.kForm.polarity(''); self.kForm.calcMethod(''); self.kForm.uom('');
      self.kForm.evidenceRequired(false); self.kForm.isActive(true);
      self.selectedSources([]); self.selectedFigures([]);
      self.bandRows.forEach(function (b) {
        b.operator(''); b.t1(''); b.t2(''); b.labelEn(''); b.labelAr('');
      });
    }

    self.openNewKpi = function () {
      self.kpiEditing(false); self.kpiErr(''); self.kpiId = null;
      resetKpiForm();
      self.showKpiDrawer(true);
    };
    self.openEditKpi = function (row) {
      self.kpiEditing(true); self.kpiErr(''); self.kpiId = row.id;
      resetKpiForm();
      self.showKpiDrawer(true);
      api.get('/v2/kpis/' + row.id).then(function (d) {
        self.kForm.code(d.code || '');
        self.kForm.nameEn(d.nameEn || ''); self.kForm.nameAr(d.nameAr || '');
        self.kForm.descriptionEn(d.descriptionEn || ''); self.kForm.descriptionAr(d.descriptionAr || '');
        self.kForm.type(d.type || ''); self.kForm.category(d.category || '');
        self.kForm.reportingFreq(d.reportingFreq || ''); self.kForm.updatingFreq(d.updatingFreq || '');
        self.kForm.polarity(d.polarity || ''); self.kForm.calcMethod(d.calcMethod || '');
        self.kForm.uom(d.uom || '');
        self.kForm.evidenceRequired(d.evidenceRequired === 'Y');
        self.kForm.isActive(d.isActive !== 'N');
        self.selectedSources(d.sources || []);
        self.selectedFigures(d.figures || []);
        (d.bands || []).forEach(function (b) {
          self.bandRows.forEach(function (row) {
            if (row.score === b.score) {
              row.operator(b.operator || '');
              row.t1(b.threshold1 !== undefined && b.threshold1 !== null ? String(b.threshold1) : '');
              row.t2(b.threshold2 !== undefined && b.threshold2 !== null ? String(b.threshold2) : '');
              row.labelEn(b.labelEn || ''); row.labelAr(b.labelAr || '');
            }
          });
        });
      });
      return true;
    };

    self.saveKpi = function () {
      if (self.kpiSaving()) return;
      var code = (self.kForm.code() || '').trim().toUpperCase();
      var nameEn = (self.kForm.nameEn() || '').trim();
      if (!code || !nameEn || !self.kForm.type() || !self.kForm.reportingFreq()
          || !self.kForm.updatingFreq() || !self.kForm.polarity()
          || !self.kForm.calcMethod() || !self.kForm.uom()) {
        self.kpiErr(i18n.t('set.k.reqd')); return;
      }
      var bands = [], bandErr = '';
      self.bandRows.forEach(function (b) {
        if (!b.operator()) return;
        var t1 = parseFloat(b.t1());
        if (isNaN(t1)) { bandErr = i18n.t('set.k.bandT1Reqd').replace('{0}', b.score); return; }
        var row = { score: b.score, operator: b.operator(), threshold1: t1,
                    labelEn: (b.labelEn() || '').trim(), labelAr: (b.labelAr() || '').trim() };
        if (b.operator() === 'BETWEEN') {
          var t2 = parseFloat(b.t2());
          if (isNaN(t2)) { bandErr = i18n.t('set.k.bandT2Reqd').replace('{0}', b.score); return; }
          row.threshold2 = t2;
        }
        bands.push(row);
      });
      if (bandErr) { self.kpiErr(bandErr); return; }
      self.kpiErr(''); self.kpiSaving(true);
      var body = {
        code: code, nameEn: nameEn,
        nameAr: (self.kForm.nameAr() || '').trim(),
        descriptionEn: (self.kForm.descriptionEn() || '').trim(),
        descriptionAr: (self.kForm.descriptionAr() || '').trim(),
        type: self.kForm.type(), category: self.kForm.category() || '',
        reportingFreq: self.kForm.reportingFreq(), updatingFreq: self.kForm.updatingFreq(),
        polarity: self.kForm.polarity(), calcMethod: self.kForm.calcMethod(),
        uom: self.kForm.uom(),
        evidenceRequired: self.kForm.evidenceRequired() ? 'Y' : 'N',
        isActive: self.kForm.isActive() ? 'Y' : 'N',
        sources: self.selectedSources().slice(),
        figures: self.selectedFigures().slice(),
        bands: bands
      };
      var p = self.kpiEditing()
        ? api.put('/v2/kpis/' + self.kpiId, body)
        : api.post('/v2/kpis', body);
      p.then(function () {
        self.kpiSaving(false); self.showKpiDrawer(false);
        toast.success(i18n.t('set.msg.saved'));
        self.loadKpis();
      }).catch(function (e) {
        self.kpiSaving(false);
        self.kpiErr((e && e.message) || i18n.t('set.msg.failed'));
      });
    };

    self.exportKpisCsv = function () {
      downloadCsv('kpi-definitions.csv',
        ['Code', 'Name (EN)', 'Name (AR)', 'Type', 'Category', 'Reporting Frequency',
         'Updating Frequency', 'Polarity', 'Calculation Method', 'UOM',
         'Evidence Required', 'Data Sources', 'Source Figures', 'Bands', 'Active',
         'Updated By', 'Updated At'],
        self.filteredKpis().map(function (k) {
          return [k.code, k.nameEn, k.nameAr,
                  self.lovName('KPI2_KPI_TYPE', k.type),
                  self.lovName('KPI2_CATEGORY', k.category),
                  self.lovName('KPI2_REPORTING_FREQ', k.reportingFreq),
                  self.lovName('KPI2_UPDATING_FREQ', k.updatingFreq),
                  self.lovName('KPI2_POLARITY', k.polarity),
                  self.lovName('KPI2_CALC_METHOD', k.calcMethod),
                  self.lovName('KPI2_UOM', k.uom),
                  k.evidenceRequired, k.sourceCount, k.figureCount, k.bandCount,
                  k.isActive, k.updatedBy, k.updatedAt];
        }));
    };

    // ════════════════════════════════════════════════════════════════
    // Sub-tab 3 — Manage Security (Phase 3, forwards to the Admin console)
    // Content mirrors the KPI-V2/db/05 seed; edit security ONLY in Admin.
    // ════════════════════════════════════════════════════════════════
    self.secJobRoles = [
      { code: 'KPI_ADMIN',        key: 'set.sec.jrAdmin' },
      { code: 'KPI_USER',         key: 'set.sec.jrUser' },
      { code: 'KPI_FIN_DIRECTOR', key: 'set.sec.jrFinDir' }
    ];
    self.secDutyRoles = [
      { code: 'KPI_DUTY_SETTINGS',       key: 'set.sec.duSettings' },
      { code: 'KPI_DUTY_WORKSPACE',      key: 'set.sec.duWorkspace' },
      { code: 'KPI_DUTY_ADMINISTRATION', key: 'set.sec.duAdmin' }
    ];
    self.secPrivileges = [
      { code: 'KPI_VIEW_WORKSPACE',      verb: 'VIEW' },
      { code: 'KPI_VIEW_ADMIN',          verb: 'VIEW' },
      { code: 'KPI_VIEW_CONFIGURATIONS', verb: 'VIEW' },
      { code: 'KPI_VIEW_SETTINGS',       verb: 'VIEW' },
      { code: 'KPI_MANAGE_LOOKUPS',      verb: 'MANAGE' },
      { code: 'KPI_MANAGE_DEFINITIONS',  verb: 'MANAGE' },
      { code: 'KPI_EXPORT_REGISTERS',    verb: 'EXPORT' }
    ];
    self.openAdminSec = function (route) {
      window.open('/dct/index.html#' + route, '_blank');
    };

    // ── boot ────────────────────────────────────────────────────────
    self.loadLookups();
    self.loadLovs();   // cheap; also serves the KPI search filters
  }

  return SettingsViewModel;
});
