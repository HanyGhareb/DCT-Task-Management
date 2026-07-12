define(['knockout', 'services/arCustomerService', 'shared/i18n', 'shared/toast'],
function (ko, custService, i18n, toast) {
  'use strict';

  function ArCustomersViewModel() {
    var self = this;
    self.t = i18n.t;

    self.loading   = ko.observable(true);
    self.loadError = ko.observable(false);
    self.items     = ko.observableArray([]);

    self.total  = ko.observable(0);
    self.limit  = ko.observable(25);
    self.offset = ko.observable(0);

    self.searchText   = ko.observable('');
    self.statusFilter = ko.observable('');
    self.statuses     = ko.observableArray([]);

    self.wsLive = ko.observable(true);
    self.wsEnv  = ko.observable('');

    self.busyId = ko.observable(null);   // row currently submitting/syncing

    self.statusClass = function (s) {
      var map = {
        DRAFT: 'badge badge--neutral', SENT: 'badge badge--warning',
        PROCESSED: 'badge badge--success', ERROR: 'badge badge--danger',
      };
      return map[s] || 'badge badge--neutral';
    };

    custService.lovs().then(function (lv) {
      self.statuses(lv.lookups.AR_CUST_WS_STATUS || []);
      self.wsLive(!!lv.wsLive);
      self.wsEnv(lv.wsEnv || '');
    }).catch(function () {});

    self.reload = function () {
      self.loading(true);
      self.loadError(false);
      custService.list({
        search: self.searchText() || null,
        status: self.statusFilter() || null,
        limit:  self.limit(),
        offset: self.offset(),
      }).then(function (res) {
        self.total(res.total || 0);
        self.items(res.items || []);
        self.loading(false);
      }).catch(function () {
        self.loading(false);
        self.loadError(true);
      });
    };

    var _t = null;
    self.searchText.subscribe(function () {
      clearTimeout(_t);
      _t = setTimeout(function () { self.offset(0); self.reload(); }, 350);
    });
    self.statusFilter.subscribe(function () { self.offset(0); self.reload(); });

    /* ── row actions ──────────────────────────────────────────────── */
    self.newCustomer = function () {
      window._arApp.navigate('arCustomerForm', { customerId: null });
    };
    self.openCustomer = function (row) {
      window._arApp.navigate('arCustomerForm', { customerId: row.id });
    };

    self.canEdit   = function (row) { return row.status === 'DRAFT' || row.status === 'ERROR'; };
    self.canSubmit = function (row) { return row.status === 'DRAFT' || row.status === 'ERROR'; };
    self.canSync   = function (row) { return row.status === 'SENT'; };
    self.canDelete = function (row) { return row.status === 'DRAFT'; };

    self.submitRow = function (row) {
      self.busyId(row.id);
      custService.submit(row.id).then(function (res) {
        if (res.ok) { toast.success(self.t('cust.toastSent')); }
        else { toast.error(res.errorMessage || self.t('cust.toastSendFailed')); }
        self.busyId(null);
        self.reload();
      }).catch(function (err) {
        self.busyId(null);
        toast.error((err && err.message) || self.t('cust.toastSendFailed'));
        self.reload();
      });
    };

    self.syncRow = function (row) {
      self.busyId(row.id);
      custService.sync(row.id).then(function (res) {
        self.busyId(null);
        if (res.processed) {
          toast.success(self.t('cust.toastProcessed') + ' ' + (res.fusionCode || ''));
        } else {
          toast.info ? toast.info(self.t('cust.toastNotYet')) : toast.success(self.t('cust.toastNotYet'));
        }
        self.reload();
      }).catch(function (err) {
        self.busyId(null);
        toast.error((err && err.message) || self.t('cust.toastSyncFailed'));
      });
    };

    self.deleteRow = function (row) {
      if (!window.confirm(self.t('cust.confirmDelete'))) { return; }
      custService.remove(row.id).then(function () {
        toast.success(self.t('cust.toastDeleted'));
        self.reload();
      }).catch(function (err) {
        toast.error((err && err.message) || self.t('cust.toastDeleteFailed'));
      });
    };

    /* ── Fusion lookup modal (getEntityCustomerDtls) ──────────────── */
    self.lookupOpen    = ko.observable(false);
    self.lookupBusy    = ko.observable(false);
    self.lookupName    = ko.observable('');
    self.lookupCode    = ko.observable('');
    self.lookupVat     = ko.observable('');
    self.lookupRows    = ko.observableArray([]);
    self.lookupRan     = ko.observable(false);

    self.openLookup  = function () {
      self.lookupRows([]); self.lookupRan(false); self.lookupOpen(true);
    };
    self.closeLookup = function () { self.lookupOpen(false); };

    self.runLookup = function () {
      if (!self.lookupName() && !self.lookupCode() && !self.lookupVat()) {
        toast.error(self.t('cust.lookupNeedFilter')); return;
      }
      self.lookupBusy(true);
      custService.wsSearch({
        name: self.lookupName() || null,
        code: self.lookupCode() || null,
        vat:  self.lookupVat()  || null,
      }).then(function (res) {
        self.lookupBusy(false);
        self.lookupRan(true);
        self.lookupRows(res.rows || []);
      }).catch(function (err) {
        self.lookupBusy(false);
        self.lookupRan(true);
        self.lookupRows([]);
        toast.error((err && err.message) || self.t('cust.lookupFailed'));
      });
    };

    // stable key/value pairs for rendering arbitrary Fusion row shapes
    self.rowPairs = function (row) {
      return Object.keys(row).map(function (k) { return { k: k, v: row[k] }; });
    };

    self.reload();
  }

  return ArCustomersViewModel;
});
