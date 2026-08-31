define(['knockout', 'services/payService', 'services/authService', 'shared/i18n'],
function (ko, payService, authService, i18n) {
  'use strict';

  function BanksViewModel() {
    var self = this;
    self.t = i18n.t;

    self.isAdmin = authService.hasRole('PAY_ADMIN') || authService.hasRole('SYS_ADMIN');

    self.loading = ko.observable(true);
    self.rows    = ko.observableArray([]);
    self.tableCollapsed = ko.observable(false);
    self.toggleTable = function () { self.tableCollapsed(!self.tableCollapsed()); };

    self.load = function () {
      self.loading(true);
      payService.getBanks().then(function (d) {
        self.rows(d.items || []);
        self.loading(false);
      }).catch(function () { self.loading(false); });
    };

    // ── Drawer ──────────────────────────────────────────────────────────
    self.dwOpen  = ko.observable(false);
    self.dwError = ko.observable('');
    self.dwOk    = ko.observable('');
    self.saving  = ko.observable(false);

    self.form = {
      bankId: ko.observable(null),
      code: ko.observable(''), nameEn: ko.observable(''), nameAr: ko.observable(''),
      accountName: ko.observable(''), accountNumber: ko.observable(''),
      iban: ko.observable(''), currency: ko.observable('AED'),
      branch: ko.observable(''), notes: ko.observable(''),
      isActive: ko.observable('Y')
    };
    self.dwTitle = ko.computed(function () {
      return self.form.bankId()
        ? (self.form.code() + ' — ' + self.form.nameEn())
        : i18n.t('bk.drawerNew');
    });
    self.toggleActive = function () {
      self.form.isActive(self.form.isActive() === 'Y' ? 'N' : 'Y');
    };

    function fillForm(d) {
      self.form.bankId(d.bankId || null);
      self.form.code(d.code || ''); self.form.nameEn(d.nameEn || ''); self.form.nameAr(d.nameAr || '');
      self.form.accountName(d.accountName || ''); self.form.accountNumber(d.accountNumber || '');
      self.form.iban(d.iban || ''); self.form.currency(d.currency || 'AED');
      self.form.branch(d.branch || ''); self.form.notes(d.notes || '');
      self.form.isActive(d.isActive || 'Y');
    }

    self.openNew  = function () { fillForm({}); self.dwError(''); self.dwOk(''); self.dwOpen(true); };
    self.openEdit = function (row) { fillForm(row); self.dwError(''); self.dwOk(''); self.dwOpen(true); };
    self.closeDw  = function () { self.dwOpen(false); };

    self.save = function () {
      self.dwError(''); self.dwOk(''); self.saving(true);
      var body = {
        code: self.form.code(), nameEn: self.form.nameEn(), nameAr: self.form.nameAr(),
        accountName: self.form.accountName(), accountNumber: self.form.accountNumber(),
        iban: self.form.iban(), currency: self.form.currency(),
        branch: self.form.branch(), notes: self.form.notes(), isActive: self.form.isActive()
      };
      var p = self.form.bankId()
        ? payService.updateBank(self.form.bankId(), body)
        : payService.createBank(body);
      p.then(function (d) {
        self.saving(false);
        if (d && d.bankId) self.form.bankId(d.bankId);
        self.dwOk(i18n.t('dr.saved'));
        self.load();
      }).catch(function (e) {
        self.saving(false);
        self.dwError((e && e.message) || i18n.t('err.save'));
      });
    };

    self.load();
  }

  return BanksViewModel;
});
