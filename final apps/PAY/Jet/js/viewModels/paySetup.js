define(['knockout', 'services/payService', 'services/authService', 'shared/i18n'],
function (ko, payService, authService, i18n) {
  'use strict';

  function PaySetupViewModel() {
    var self = this;
    self.t = i18n.t;

    self.canSetup = ko.observable(authService.hasRole('PAY_ADMIN') || authService.hasRole('SYS_ADMIN'));
    self.loading  = ko.observable(true);
    self.error    = ko.observable('');

    self.payrolls      = ko.observableArray([]);
    self.elements      = ko.observableArray([]);
    self.rateTables    = ko.observableArray([]);
    self.invoiceGroups = ko.observableArray([]);
    self.lookups       = ko.observable({});

    self.lk = function (cat) {
      var l = (self.lookups() || {})[cat] || [];
      return l.map(function (x) {
        return { code: x.code, name: i18n.lang() === 'ar' && x.nameAr ? x.nameAr : x.nameEn };
      });
    };

    self.refresh = function () {
      self.loading(true);
      return payService.paysetupBoot().then(function (d) {
        self.canSetup(d.canSetup === 'Y');
        self.payrolls(d.payrolls || []);
        self.elements(d.elements || []);
        self.rateTables(d.rateTables || []);
        self.invoiceGroups(d.invoiceGroups || []);
        self.lookups(d.lookups || {});
      }).catch(function (e) { self.error(e.message || String(e)); })
        .finally(function () { self.loading(false); });
    };
    self.refresh();

    // ── Payroll drawer ──────────────────────────────────────────────────
    self.pdOpen  = ko.observable(false);
    self.pdError = ko.observable('');
    self.pdBusy  = ko.observable(false);
    self.pd = {
      payrollId: ko.observable(null), code: ko.observable(''), nameEn: ko.observable(''),
      nameAr: ko.observable(''), prorationBasis: ko.observable('FIXED_30'),
      prorationDivisor: ko.observable(30), pensionBase: ko.observable('GROSS'),
      cutoffDay: ko.observable(20), payDay: ko.observable(28),
      isActive: ko.observable('Y'), notes: ko.observable(''), company: ko.observable(''),
      genYear: ko.observable(new Date().getFullYear() + 1)
    };
    self.pdTitle = ko.observable('');

    self.pdEdit = function (row) {
      self.pdError('');
      self.pd.payrollId(row.payrollId); self.pd.code(row.code);
      self.pd.nameEn(row.nameEn); self.pd.nameAr(row.nameAr || '');
      self.pd.prorationBasis(row.prorationBasis); self.pd.prorationDivisor(row.prorationDivisor);
      self.pd.pensionBase(row.pensionBase || 'GROSS');
      self.pd.cutoffDay(row.cutoffDay); self.pd.payDay(row.payDay);
      self.pd.isActive(row.isActive); self.pd.company(row.company);
      self.pdTitle(row.code);
      self.pdOpen(true);
    };
    self.pdClose = function () { self.pdOpen(false); };

    self.pdSave = function () {
      self.pdBusy(true); self.pdError('');
      payService.updatePayroll(self.pd.payrollId(), {
        nameEn: self.pd.nameEn(), nameAr: self.pd.nameAr(),
        prorationBasis: self.pd.prorationBasis(),
        prorationDivisor: Number(self.pd.prorationDivisor()) || null,
        pensionBase: self.pd.pensionBase(),
        cutoffDay: Number(self.pd.cutoffDay()) || null,
        payDay: Number(self.pd.payDay()) || null,
        isActive: self.pd.isActive(), notes: self.pd.notes() || null
      }).then(function () { self.pdOpen(false); return self.refresh(); })
        .catch(function (e) { self.pdError(e.message || String(e)); })
        .finally(function () { self.pdBusy(false); });
    };

    self.pdGenPeriods = function () {
      var y = Number(self.pd.genYear());
      if (!y) return;
      self.pdBusy(true); self.pdError('');
      payService.genPeriods(self.pd.payrollId(), y)
        .then(function () { self.pdOpen(false); return self.refresh(); })
        .catch(function (e) { self.pdError(e.message || String(e)); })
        .finally(function () { self.pdBusy(false); });
    };

    // ── Element drawer ──────────────────────────────────────────────────
    self.edOpen  = ko.observable(false);
    self.edError = ko.observable('');
    self.edBusy  = ko.observable(false);
    self.edIsNew = ko.observable(false);
    self.ed = {
      elementId: ko.observable(null), code: ko.observable(''), nameEn: ko.observable(''),
      nameAr: ko.observable(''), elementClass: ko.observable('EARNING'),
      calcRule: ko.observable('FLAT'), calcBase: ko.observable(''),
      percent: ko.observable(''), rateTableId: ko.observable(''),
      priority: ko.observable(100), prorate: ko.observable('Y'),
      recurring: ko.observable('Y'), payslipVisible: ko.observable('Y'),
      isActive: ko.observable('Y'), links: ko.observableArray([]),
      linkType: ko.observable('PAYROLL'), linkValue: ko.observable('')
    };
    self.edTitle = ko.observable('');

    self.edNew = function () {
      self.edError(''); self.edIsNew(true);
      self.ed.elementId(null); self.ed.code(''); self.ed.nameEn(''); self.ed.nameAr('');
      self.ed.elementClass('EARNING'); self.ed.calcRule('FLAT'); self.ed.calcBase('');
      self.ed.percent(''); self.ed.rateTableId(''); self.ed.priority(100);
      self.ed.prorate('Y'); self.ed.recurring('Y'); self.ed.payslipVisible('Y');
      self.ed.isActive('Y'); self.ed.links([]);
      self.edTitle(self.t('ps.newElement'));
      self.edOpen(true);
    };

    self.edEdit = function (row) {
      self.edError(''); self.edIsNew(false);
      self.ed.elementId(row.elementId); self.ed.code(row.code);
      self.ed.nameEn(row.nameEn); self.ed.nameAr(row.nameAr || '');
      self.ed.elementClass(row.elementClass); self.ed.calcRule(row.calcRule);
      self.ed.calcBase(row.calcBase || ''); self.ed.percent(row.percent == null ? '' : row.percent);
      self.ed.rateTableId(row.rateTableId || ''); self.ed.priority(row.priority);
      self.ed.prorate(row.prorate); self.ed.recurring(row.recurring);
      self.ed.payslipVisible(row.payslipVisible); self.ed.isActive(row.isActive);
      self.ed.links(row.links || []);
      self.edTitle(row.code);
      self.edOpen(true);
    };
    self.edClose = function () { self.edOpen(false); };

    self.edSave = function () {
      self.edBusy(true); self.edError('');
      var body = {
        nameEn: self.ed.nameEn(), nameAr: self.ed.nameAr() || null,
        elementClass: self.ed.elementClass(), calcRule: self.ed.calcRule(),
        calcBase: self.ed.calcBase() || null,
        percent: self.ed.percent() === '' ? null : Number(self.ed.percent()),
        rateTableId: self.ed.rateTableId() === '' ? null : Number(self.ed.rateTableId()),
        priority: Number(self.ed.priority()) || 100,
        prorate: self.ed.prorate(), recurring: self.ed.recurring(),
        payslipVisible: self.ed.payslipVisible(), isActive: self.ed.isActive()
      };
      var p;
      if (self.edIsNew()) {
        body.code = self.ed.code();
        p = payService.createElement(body);
      } else {
        p = payService.updateElement(self.ed.elementId(), body);
      }
      p.then(function () { self.edOpen(false); return self.refresh(); })
        .catch(function (e) { self.edError(e.message || String(e)); })
        .finally(function () { self.edBusy(false); });
    };

    self.edAddLink = function () {
      if (!self.ed.linkValue()) return;
      self.edBusy(true); self.edError('');
      payService.addElementLink(self.ed.elementId(), {
        linkType: self.ed.linkType(), linkValue: self.ed.linkValue()
      }).then(function () {
        self.ed.linkValue('');
        return self.refresh().then(function () {
          var row = self.elements().filter(function (x) { return x.elementId === self.ed.elementId(); })[0];
          if (row) self.ed.links(row.links || []);
        });
      }).catch(function (e) { self.edError(e.message || String(e)); })
        .finally(function () { self.edBusy(false); });
    };

    self.edToggleLink = function (k) {
      self.edBusy(true);
      payService.updateLink(k.linkId, { isActive: k.isActive === 'Y' ? 'N' : 'Y' })
        .then(function () {
          return self.refresh().then(function () {
            var row = self.elements().filter(function (x) { return x.elementId === self.ed.elementId(); })[0];
            if (row) self.ed.links(row.links || []);
          });
        }).catch(function (e) { self.edError(e.message || String(e)); })
        .finally(function () { self.edBusy(false); });
    };

    // ── Rate rows drawer ────────────────────────────────────────────────
    self.rdOpen  = ko.observable(false);
    self.rdError = ko.observable('');
    self.rdBusy  = ko.observable(false);
    self.rdTable = ko.observable(null);
    self.rd = { keyValue: ko.observable(''), eeRate: ko.observable(''), erRate: ko.observable('') };

    self.rdEdit = function (tbl) {
      self.rdError(''); self.rdTable(tbl);
      self.rd.keyValue(''); self.rd.eeRate(''); self.rd.erRate('');
      self.rdOpen(true);
    };
    self.rdClose = function () { self.rdOpen(false); };

    self.rdAdd = function () {
      if (!self.rd.keyValue()) return;
      self.rdBusy(true); self.rdError('');
      payService.addRateRow({
        rateTableId: self.rdTable().rateTableId, keyValue: self.rd.keyValue(),
        eeRate: self.rd.eeRate() === '' ? null : Number(self.rd.eeRate()),
        erRate: self.rd.erRate() === '' ? null : Number(self.rd.erRate())
      }).then(function () { return self._rdReload(); })
        .catch(function (e) { self.rdError(e.message || String(e)); })
        .finally(function () { self.rdBusy(false); });
    };

    self.rdUpdate = function (row) {
      var ee = window.prompt(self.t('ps.eeRatePrompt') + ' (' + row.keyValue + ')', row.eeRate == null ? '' : row.eeRate);
      if (ee === null) return;
      var er = window.prompt(self.t('ps.erRatePrompt') + ' (' + row.keyValue + ')', row.erRate == null ? '' : row.erRate);
      if (er === null) return;
      self.rdBusy(true); self.rdError('');
      payService.updateRateRow(row.rowId, {
        eeRate: ee === '' ? null : Number(ee),
        erRate: er === '' ? null : Number(er)
      }).then(function () { return self._rdReload(); })
        .catch(function (e) { self.rdError(e.message || String(e)); })
        .finally(function () { self.rdBusy(false); });
    };

    self._rdReload = function () {
      var id = self.rdTable().rateTableId;
      self.rd.keyValue(''); self.rd.eeRate(''); self.rd.erRate('');
      return self.refresh().then(function () {
        var t = self.rateTables().filter(function (x) { return x.rateTableId === id; })[0];
        if (t) self.rdTable(t);
      });
    };

    // ── Invoice group drawer ────────────────────────────────────────────
    self.gdOpen  = ko.observable(false);
    self.gdError = ko.observable('');
    self.gdBusy  = ko.observable(false);
    self.gd = {
      groupId: ko.observable(null), code: ko.observable(''), company: ko.observable(''),
      nameEn: ko.observable(''), nameAr: ko.observable(''), displayOrder: ko.observable(10),
      isDefault: ko.observable('N'), isActive: ko.observable('Y'), sectors: ko.observable('')
    };

    self.gdEdit = function (row) {
      self.gdError('');
      self.gd.groupId(row.groupId); self.gd.code(row.code); self.gd.company(row.company);
      self.gd.nameEn(row.nameEn); self.gd.nameAr(row.nameAr || '');
      self.gd.displayOrder(row.displayOrder); self.gd.isDefault(row.isDefault);
      self.gd.isActive(row.isActive);
      self.gd.sectors((row.sectors || []).join('\n'));
      self.gdOpen(true);
    };
    self.gdClose = function () { self.gdOpen(false); };

    self.gdSave = function () {
      self.gdBusy(true); self.gdError('');
      var sectors = self.gd.sectors().split('\n')
        .map(function (s) { return s.trim(); })
        .filter(function (s) { return s; })
        .join('|');
      payService.updateInvGroup(self.gd.groupId(), {
        nameEn: self.gd.nameEn(), nameAr: self.gd.nameAr() || null,
        displayOrder: Number(self.gd.displayOrder()) || 10,
        isDefault: self.gd.isDefault(), isActive: self.gd.isActive(),
        sectors: sectors || null
      }).then(function () { self.gdOpen(false); return self.refresh(); })
        .catch(function (e) { self.gdError(e.message || String(e)); })
        .finally(function () { self.gdBusy(false); });
    };
  }

  return PaySetupViewModel;
});
