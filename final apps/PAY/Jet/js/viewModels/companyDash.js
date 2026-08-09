define(['knockout', 'services/payService', 'shared/i18n', 'shared/components/interactiveReport'],
function (ko, payService, i18n) {
  'use strict';

  function CompanyDashViewModel() {
    var self = this;
    self.t = i18n.t;

    self.loading = ko.observable(true);
    self.error   = ko.observable('');
    self.d       = ko.observable(null);

    self.money = function (v) {
      if (v === null || v === undefined || v === '') return '—';
      return Number(v).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    };
    self.num = function (v) {
      if (v === null || v === undefined || v === '') return '—';
      return Number(v).toLocaleString('en-US');
    };

    self.back = function () { if (window._jetApp) window._jetApp.navigate('companies'); };
    self.goEmployees = function () { if (window._jetApp) window._jetApp.navigate('employees'); };
    self.goRuns = function () { if (window._jetApp) window._jetApp.navigate('payRuns'); };

    var state = (window._jetApp && window._jetApp.getState && window._jetApp.getState()) || {};
    var cid = state.dashCompanyId;
    delete state.dashCompanyId;
    if (!cid) { self.back(); return; }

    // ── region maximize ─────────────────────────────────────────────────
    self.regMax = ko.observable('');
    self.toggleReg = function (k) { self.regMax(self.regMax() === k ? '' : k); };
    self.regCls = function (k) { return { 'ap-region--max': self.regMax() === k }; };

    // ── interactive-report envelopes (shared component) ─────────────────
    self.irRuns      = ko.observable(null);
    self.irContracts = ko.observable(null);
    self.irInvoices  = ko.observable(null);
    self.irCostCc    = ko.observable(null);
    self.irEmps      = ko.observable(null);

    function irEnv(section, cols, items) {
      items = items || [];
      return {
        columns: cols.map(function (c) { return { key: c.k, label: i18n.t(c.l), type: c.t || 'text' }; }),
        items: items,
        total: items.length,
        truncated: false,
        maxRows: Math.max(items.length, 1),
        section: section
      };
    }

    function buildIrs(d) {
      self.irRuns(irEnv('runs', [
        { k: 'period', l: 'cd.period' }, { k: 'payroll', l: 'cd.payroll' },
        { k: 'status', l: 'cd.status' }, { k: 'empCount', l: 'cd.kHeadcount', t: 'num' },
        { k: 'exceptions', l: 'pr.kExceptions', t: 'num' },
        { k: 'gross', l: 'cd.gross', t: 'money' }, { k: 'charges', l: 'cd.kCharges', t: 'money' }
      ], d.runs));
      self.irContracts(irEnv('contracts', [
        { k: 'contractNo', l: 'cd.contractNo' }, { k: 'title', l: 'cd.title2' },
        { k: 'status', l: 'cd.status' }, { k: 'versionNo', l: 'cd.version', t: 'num' },
        { k: 'dateFrom', l: 'emp.from', t: 'date' }, { k: 'dateTo', l: 'emp.to', t: 'date' },
        { k: 'daysLeft', l: 'cd.daysLeft', t: 'num' },
        { k: 'contractValue', l: 'cd.value', t: 'money' },
        { k: 'annualValue', l: 'cd.annualValue', t: 'money' },
        { k: 'approvedHeadcount', l: 'cd.approvedHc', t: 'num' },
        { k: 'marginRules', l: 'cd.marginRules', t: 'num' }, { k: 'vatRate', l: 'cd.vat', t: 'num' }
      ], d.contracts));
      self.irInvoices(irEnv('invoices', [
        { k: 'invoiceNumber', l: 'cd.invoiceNo' }, { k: 'invoiceDate', l: 'cd.date', t: 'date' },
        { k: 'type', l: 'cd.type' }, { k: 'validation', l: 'cd.validation' },
        { k: 'paymentStatus', l: 'cd.paymentStatus' },
        { k: 'amount', l: 'cd.amountAed', t: 'money' }, { k: 'paid', l: 'cd.paidAed', t: 'money' }
      ], d.invoices));
      self.irCostCc(irEnv('costcc', [
        { k: 'costCenter', l: 'cd.costCenter' }, { k: 'label', l: 'cd.sector' },
        { k: 'headcount', l: 'cd.kHeadcount', t: 'num' }, { k: 'gross', l: 'cd.gross', t: 'money' }
      ], d.costByCc));
      self.irEmps(irEnv('emps', [
        { k: 'employeeNumber', l: 'cd.empNo' }, { k: 'name', l: 'cd.name' },
        { k: 'jobTitle', l: 'cd.jobTitle' }, { k: 'sector', l: 'cd.sector' },
        { k: 'costCenter', l: 'cd.costCenter' }, { k: 'gradeCode', l: 'cd.grade' },
        { k: 'gross', l: 'cd.gross', t: 'money' }
      ], d.employees));
    }

    // ── drill drawer (GL Budget-Utilization pattern) ─────────────────────
    var DR = {
      emps: { title: 'cd.dEmps', cols: [
        { k: 'employeeNumber', l: 'cd.empNo' }, { k: 'name', l: 'cd.name' },
        { k: 'jobTitle', l: 'cd.jobTitle' }, { k: 'sector', l: 'cd.sector' },
        { k: 'costCenter', l: 'cd.costCenter' }, { k: 'gradeCode', l: 'cd.grade' },
        { k: 'gross', l: 'cd.gross', t: 'money' }] },
      contracts: { title: 'cd.dContracts', cols: [
        { k: 'contractNo', l: 'cd.contractNo' }, { k: 'title', l: 'cd.title2' },
        { k: 'status', l: 'cd.status' }, { k: 'dateFrom', l: 'emp.from' }, { k: 'dateTo', l: 'emp.to' },
        { k: 'daysLeft', l: 'cd.daysLeft' }, { k: 'contractValue', l: 'cd.value', t: 'money' },
        { k: 'annualValue', l: 'cd.annualValue', t: 'money' }, { k: 'marginRules', l: 'cd.marginRules' }] },
      run: { title: 'cd.dRun', cols: [
        { k: 'employeeNumber', l: 'cd.empNo' }, { k: 'name', l: 'cd.name' },
        { k: 'sector', l: 'cd.sector' }, { k: 'costCenter', l: 'cd.costCenter' },
        { k: 'groupShort', l: 'pr.group' }, { k: 'factor', l: 'pr.factor' },
        { k: 'gross', l: 'cd.gross', t: 'money' }, { k: 'deductions', l: 'pr.kDeductions', t: 'money' },
        { k: 'net', l: 'cd.net', t: 'money' }, { k: 'employerCost', l: 'pr.kEmployerCost', t: 'money' }] },
      charges: { title: 'cd.dCharges', cols: [
        { k: 'groupShort', l: 'pr.group' }, { k: 'chargeType', l: 'pr.chargeType' },
        { k: 'description', l: 'pr.description' }, { k: 'empCount', l: 'cd.kHeadcount' },
        { k: 'amount', l: 'pr.amount', t: 'money' }] },
      inv: { title: 'cd.dInv', cols: [
        { k: 'invoiceNumber', l: 'cd.invoiceNo' }, { k: 'invoiceDate', l: 'cd.date' },
        { k: 'type', l: 'cd.type' }, { k: 'validation', l: 'cd.validation' },
        { k: 'paymentStatus', l: 'cd.paymentStatus' },
        { k: 'amount', l: 'cd.amountAed', t: 'money' }, { k: 'paid', l: 'cd.paidAed', t: 'money' },
        { k: 'outstanding', l: 'cd.outstandingCol', t: 'money' }] },
      paidcc: { title: 'cd.dPaidCc', cols: [
        { k: 'invoiceNumber', l: 'cd.invoiceNo' }, { k: 'invoiceDate', l: 'cd.date' },
        { k: 'line', l: 'cd.line' }, { k: 'distType', l: 'cd.distType' },
        { k: 'expenditureType', l: 'cd.etype' },
        { k: 'amount', l: 'cd.amountAed', t: 'money' }, { k: 'paid', l: 'cd.paidAed', t: 'money' }] }
    };

    self.drOpen  = ko.observable(false);
    self.drMax   = ko.observable(false);
    self.drBusy  = ko.observable(false);
    self.drTitle = ko.observable('');
    self.drCols  = ko.observableArray([]);
    self.drRows  = ko.observableArray([]);
    self.drShown = ko.observable(0);
    self.drTotal = ko.observable(0);
    self.drTrunc = ko.observable(false);
    self.drSums  = ko.observable({});
    self.closeDr = function () { self.drOpen(false); self.drMax(false); };
    self.toggleDrMax = function () { self.drMax(!self.drMax()); };

    self.cellTxt = function (row, col) {
      var v = row[col.k];
      if (col.t === 'money') return self.money(v);
      return (v === null || v === undefined || v === '') ? '—' : v;
    };

    self.drill = function (metric, key, subtitle) {
      var m = DR[metric];
      if (!m) return;
      self.drBusy(true); self.drOpen(true); self.drMax(false);
      self.drTitle(i18n.t(m.title) + (subtitle ? ' · ' + subtitle : ''));
      self.drCols(m.cols.map(function (c) { return { k: c.k, t: c.t || 'text', label: i18n.t(c.l) }; }));
      self.drRows([]); self.drSums({});
      payService.companyDashDrill(cid, metric, key).then(function (d) {
        var rows = d.items || [];
        self.drRows(rows);
        self.drShown(d.shown || rows.length);
        self.drTotal(d.total || rows.length);
        self.drTrunc(d.truncated === 'Y');
        var sums = {};
        m.cols.forEach(function (c) {
          if (c.t === 'money') {
            sums[c.k] = rows.reduce(function (a, r) { return a + (Number(r[c.k]) || 0); }, 0);
          }
        });
        self.drSums(sums);
      }).catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.drBusy(false); });
    };

    self.drCsv = function () {
      var cols = self.drCols(), rows = self.drRows(), sums = self.drSums();
      var esc = function (v) { return '"' + String(v === null || v === undefined ? '' : v).replace(/"/g, '""') + '"'; };
      var lines = [cols.map(function (c) { return esc(c.label); }).join(',')];
      rows.forEach(function (r) {
        lines.push(cols.map(function (c) { return esc(r[c.k]); }).join(','));
      });
      lines.push(cols.map(function (c, i) {
        return i === 0 ? esc(i18n.t('cd.total')) : (sums[c.k] !== undefined ? sums[c.k].toFixed(2) : '');
      }).join(','));
      var blob = new Blob(['﻿' + lines.join('\r\n')], { type: 'text/csv;charset=utf-8' });
      var a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = 'company-dash-drill.csv';
      document.body.appendChild(a); a.click(); a.remove();
    };

    // ── charts (click = drill) ──────────────────────────────────────────
    self._charts = [];
    self._renderCharts = function (d) {
      require(['shared/chartLoader'], function (cl) {
        self._charts.forEach(function (c) { try { c.destroy(); } catch (e) {} });
        self._charts = [];
        var mk = function (id, cfg) {
          var el = document.getElementById(id);
          if (el) { self._charts.push(cl.makeChart(el, cfg)); }
        };
        var pcc = d.paidByCc || [];
        mk('cdPaidCc', {
          type: 'bar',
          data: {
            labels: pcc.map(function (x) { return x.costCenter + ((x.label || '') ? ' · ' + x.label : ''); }),
            datasets: [{ label: i18n.t('cd.paidAed'), data: pcc.map(function (x) { return x.paid; }),
                         backgroundColor: 'rgba(20,104,47,0.55)' }]
          },
          options: { indexAxis: 'y', plugins: { legend: { display: false } },
                     onClick: function (evt, els) {
                       if (els && els.length) { self.drill('paidcc', pcc[els[0].index].costCenter, pcc[els[0].index].costCenter); }
                     },
                     scales: { x: { ticks: { callback: function (v) { return Number(v).toLocaleString('en-US'); } } } } }
        });
        var trend = d.apTrend || [];
        mk('cdTrend', {
          type: 'line',
          data: {
            labels: trend.map(function (x) { return x.month; }),
            datasets: [
              { label: i18n.t('cd.invoiced'), data: trend.map(function (x) { return x.invoiced; }),
                borderColor: '#14682F', backgroundColor: 'rgba(20,104,47,0.12)', fill: true, tension: 0.3 },
              { label: i18n.t('cd.paid'), data: trend.map(function (x) { return x.paid; }),
                borderColor: '#B0721E', backgroundColor: 'rgba(176,114,30,0.10)', fill: true, tension: 0.3 }
            ]
          },
          options: { onClick: function (evt, els) {
                       if (els && els.length) { self.drill('inv', trend[els[0].index].month, trend[els[0].index].month); }
                     },
                     scales: { y: { ticks: { callback: function (v) { return Number(v).toLocaleString('en-US'); } } } } }
        });
        var sec = d.bySector || [];
        mk('cdSector', {
          type: 'doughnut',
          data: {
            labels: sec.map(function (x) { return x.sector; }),
            datasets: [{ data: sec.map(function (x) { return x.headcount; }),
                         backgroundColor: ['#14682F', '#B0721E', '#3A4FB0', '#8C6D1F', '#7D3243',
                                           '#0E8A8A', '#6C4AB6', '#1F6F8B', '#3F6F5F', '#888888'] }]
          },
          options: { plugins: { legend: { position: 'right' } },
                     onClick: function (evt, els) {
                       if (els && els.length) { self.drill('emps', sec[els[0].index].sector, sec[els[0].index].sector); }
                     } }
        });
      });
    };

    self.load = function () {
      self.loading(true); self.error('');
      payService.getCompanyDash(cid).then(function (d) {
        self.d(d);
        buildIrs(d);
        setTimeout(function () { self._renderCharts(d); }, 60);
      }).catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.loading(false); });
    };
    self.load();

    self.dispose = function () {
      self._charts.forEach(function (c) { try { c.destroy(); } catch (e) {} });
    };
  }

  return CompanyDashViewModel;
});
