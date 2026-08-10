define(['knockout', 'services/payService', 'services/authService', 'shared/i18n'],
function (ko, payService, authService, i18n) {
  'use strict';

  function PayRunsViewModel() {
    var self = this;
    self.t = i18n.t;

    self.canRun   = ko.observable(authService.hasRole('PAY_ADMIN') || authService.hasRole('SYS_ADMIN'));
    self.canSetup = ko.observable(authService.hasRole('PAY_ADMIN') || authService.hasRole('SYS_ADMIN'));

    self.money = function (v) {
      if (v === null || v === undefined || v === '') return '—';
      return Number(v).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    };
    self.num = function (v) {
      if (v === null || v === undefined || v === '') return '—';
      return Number(v).toLocaleString('en-US');
    };

    // ── Criteria ────────────────────────────────────────────────────────
    self.payrolls   = ko.observableArray([]);
    self.selPayroll = ko.observable('');
    self.periods    = ko.observableArray([]);
    self.selPeriod  = ko.observable('');
    self.booting    = ko.observable(true);
    self.busy       = ko.observable(false);
    self.error      = ko.observable('');

    // ── Run detail ──────────────────────────────────────────────────────
    self.run        = ko.observable(null);
    self.runLoading = ko.observable(false);

    // register
    self.emps    = ko.observableArray([]);
    self.total   = ko.observable(0);
    self.limit   = ko.observable(50);
    self.offset  = ko.observable(0);
    self.search  = ko.observable('');
    self.fStatus = ko.observable('');
    self.fGrp    = ko.observable('');
    self.empsLoading = ko.observable(false);

    // lines drawer
    self.dwOpen   = ko.observable(false);
    self.dwEmp    = ko.observable(null);
    self.dwLines  = ko.observableArray([]);
    self.dwGrpSel = ko.observable('');
    self.dwGrpBusy = ko.observable(false);
    self.closeDw  = function () { self.dwOpen(false); };

    // Pay Admin may move the employee to another invoice group while the
    // run is loaded / validated / calculated; the move re-prices charges
    self.canMoveGroup = ko.computed(function () {
      var r = self.run();
      return !!r && self.canSetup()
        && ['LOADED', 'VALIDATED', 'CALCULATED'].indexOf(r.status) >= 0;
    });

    self.applyGroup = function () {
      var r = self.run(), e = self.dwEmp();
      if (!r || !e || self.dwGrpSel() === '' || Number(self.dwGrpSel()) === e.group) return;
      self.dwGrpBusy(true); self.error('');
      payService.setRunEmpGroup(r.runId, e.runEmpId, Number(self.dwGrpSel()))
        .then(function () { self.dwOpen(false); return self.loadRun(r.runId); })
        .catch(function (err) { self.error(err.message || String(err)); })
        .finally(function () { self.dwGrpBusy(false); });
    };

    self.statusClass = function (s) {
      return 'pr-pill pr-pill--' + String(s || '').toLowerCase();
    };

    payService.paysetupBoot().then(function (d) {
      self.canRun(d.canRun === 'Y');
      self.canSetup(d.canSetup === 'Y');
      self.payrolls((d.payrolls || []).filter(function (p) { return p.isActive === 'Y'; }));
      self.booting(false);
      if (self.payrolls().length) { self.selPayroll(self.payrolls()[0].payrollId); }
    }).catch(function (e) { self.error(e.message || String(e)); self.booting(false); });

    self.selPayroll.subscribe(function (pid) {
      self.run(null); self.emps([]); self.periods([]); self.selPeriod('');
      if (!pid) return;
      payService.getPeriods(pid).then(function (d) {
        self.periods(d.items || []);
        var withRun = (d.items || []).filter(function (x) { return x.runId; });
        self.selPeriod(withRun.length ? withRun[0].period
                                      : (d.items && d.items.length ? d.items[0].period : ''));
      });
    });

    // change-register readiness chip (Phase 3.1): capture + dual sign-off
    // is the pre-run gate, so the console shows where the period stands
    self.chgInfo = ko.observable(null);

    self.selPeriod.subscribe(function (per) {
      self.run(null); self.emps([]); self.chgInfo(null);
      if (!per) return;
      var row = self.periods().filter(function (x) { return x.period === per; })[0];
      if (row && row.runId) { self.loadRun(row.runId); }
      if (row && row.periodId) {
        payService.chgStatus(self.selPayroll(), row.periodId)
          .then(self.chgInfo).catch(function () { self.chgInfo(null); });
      }
    });

    self.chgChipClass = function () {
      var c = self.chgInfo();
      if (!c || c.exists !== 'Y') return 'chg-chip chg-chip--none';
      return 'chg-chip chg-chip--' + String(c.status || '').toLowerCase();
    };
    self.chgChipText = function () {
      var c = self.chgInfo();
      if (!c || c.exists !== 'Y') return i18n.t('chg.chipNone');
      if (c.status === 'CONFIRMED') return i18n.t('chg.chipConfirmed');
      if (c.status === 'BASELINE') return i18n.t('chg.chipBaseline');
      var pend = (c.pendHr || 0) + (c.pendPay || 0);
      return i18n.t('chg.chipPending').replace('{n}', pend);
    };
    self.goChanges = function () {
      window._jetApp.navigate('payChanges', {
        chgPayroll: self.selPayroll(), chgPeriod: self.selPeriod()
      });
    };

    self.periodRow = function () {
      return self.periods().filter(function (x) { return x.period === self.selPeriod(); })[0] || null;
    };

    self.openRun = function () {
      var row = self.periodRow();
      if (!row) return;
      self.error('');
      if (row.runId) { self.loadRun(row.runId); return; }
      self.busy(true);
      payService.createRun({ payrollId: self.selPayroll(), period: row.period })
        .then(function (d) {
          row.runId = d.runId;
          return self.loadRun(d.runId);
        })
        .catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.busy(false); });
    };

    self.loadRun = function (id) {
      self.runLoading(true);
      return payService.getRun(id).then(function (d) {
        self.run(d);
        self.offset(0);
        return self.loadEmps();
      }).catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.runLoading(false); });
    };

    self.loadEmps = function () {
      var r = self.run();
      if (!r) return Promise.resolve();
      self.empsLoading(true);
      return payService.getRunEmps(r.runId, {
        limit: self.limit(), offset: self.offset(),
        search: self.search(), status: self.fStatus(), grp: self.fGrp()
      }).then(function (d) {
        self.total(d.total || 0);
        self.emps(d.items || []);
      }).finally(function () { self.empsLoading(false); });
    };

    self.onPage = function (newOffset) { self.offset(newOffset); self.loadEmps(); };

    var searchTimer = null;
    self.search.subscribe(function () {
      if (searchTimer) clearTimeout(searchTimer);
      searchTimer = setTimeout(function () { self.offset(0); self.loadEmps(); }, 350);
    });
    self.fStatus.subscribe(function () { self.offset(0); self.loadEmps(); });
    self.fGrp.subscribe(function () { self.offset(0); self.loadEmps(); });

    // ── Stage actions ───────────────────────────────────────────────────
    self.can = function (action) {
      var r = self.run();
      if (!r || !self.canRun()) return false;
      var s = r.status;
      if (action === 'LOAD')      return s !== 'REVIEWED';
      if (action === 'VALIDATE')  return ['LOADED', 'VALIDATED', 'CALCULATED'].indexOf(s) >= 0;
      if (action === 'CALCULATE') return ['LOADED', 'VALIDATED', 'CALCULATED'].indexOf(s) >= 0;
      if (action === 'REVIEW')    return s === 'CALCULATED';
      if (action === 'REOPEN')    return s !== 'OPEN';
      return false;
    };

    self.doAction = function (action) {
      var r = self.run();
      if (!r) return;
      if (action === 'REOPEN' && !window.confirm(self.t('pr.confirmReopen'))) return;
      self.busy(true); self.error('');
      payService.runAction(r.runId, action)
        .then(function () { return self.loadRun(r.runId); })
        .catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.busy(false); });
    };

    self.exportCsv = function () {
      var r = self.run();
      if (!r) return;
      payService.runExportUrl(r.runId).then(function (url) {
        var a = document.createElement('a');
        a.href = url;
        a.download = 'payroll-register-' + r.payroll + '-' + r.period + '.csv';
        document.body.appendChild(a); a.click(); a.remove();
      });
    };

    self.openLines = function (row) {
      var r = self.run();
      if (!r) return;
      self.dwEmp(row); self.dwLines([]); self.dwGrpSel(row.group); self.dwOpen(true);
      payService.getRunEmpLines(r.runId, row.runEmpId).then(function (d) {
        self.dwLines(d.lines || []);
      });
    };
  }

  return PayRunsViewModel;
});
