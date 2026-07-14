define(['knockout', 'services/arCustomerService', 'services/soapuiGen', 'shared/i18n', 'shared/toast', 'shared/docUpload'],
function (ko, custService, soapuiGen, i18n, toast, docUpload) {
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

    /* ── SoapUI project generator (Excel -> importable project XML) ── */
    self.genOpen      = ko.observable(false);
    self.genEnv       = ko.observable('stage');       // stage | prod
    self.genChunk     = ko.observable('50');
    self.genPassword  = ko.observable('');            // Basic-auth override
    self.genFileName  = ko.observable('');
    self.genCustomers = ko.observableArray([]);
    self.genErrors    = ko.observableArray([]);
    self.genBusy      = ko.observable(false);
    var genConfig = null;                              // soapui-config payload

    self.openGenerator = function () {
      self.genFileName(''); self.genCustomers([]); self.genErrors([]);
      self.genPassword('');
      self.genOpen(true);
      if (!genConfig) {
        custService.soapuiConfig().then(function (cfg) {
          genConfig = cfg;
        }).catch(function (err) {
          self.genOpen(false);
          toast.error((err && err.status === 403)
            ? self.t('cust.genForbidden')
            : ((err && err.message) || self.t('empty.loadFailed')));
        });
      }
    };
    self.closeGenerator = function () { self.genOpen(false); };

    self.genTemplate = function () {
      require(['xlsx'], function (XLSX) {
        soapuiGen.downloadTemplate(XLSX);
      }, function () { toast.error(self.t('cust.genLibFail')); });
    };

    self.genChooseFile = function () {
      docUpload.choose({ accept: '.xlsx,.xls', maxMb: 10 }).then(function (file) {
        if (!file) { return; }
        file.arrayBuffer().then(function (buf) {
          require(['xlsx'], function (XLSX) {
            try {
              var res = soapuiGen.parseWorkbook(XLSX, buf);
              self.genFileName(file.name);
              self.genCustomers(res.customers);
              self.genErrors(res.errors);
              if (!res.errors.length && res.customers.length) {
                toast.success(self.t('cust.genParsed', [res.customers.length]));
              }
            } catch (e) { toast.error(e.message || String(e)); }
          }, function () { toast.error(self.t('cust.genLibFail')); });
        });
      });
    };

    self.genReady = ko.computed(function () {
      return self.genCustomers().length > 0 && self.genErrors().length === 0 && !self.genBusy();
    });

    self.genDownload = function () {
      if (!self.genReady()) { return; }
      if (!genConfig) { toast.error(self.t('empty.loadFailed')); return; }
      var envName = self.genEnv() === 'prod' ? 'PROD' : 'STAGE';
      var env = genConfig[self.genEnv()] || {};
      var pwd = self.genPassword() || env.password || '';
      if (!env.endpoint || !env.apikey) { toast.error(self.t('cust.genNoConfig')); return; }
      if (!pwd || pwd === 'CHANGE_ME') { toast.error(self.t('cust.genNoPwd')); return; }
      self.genBusy(true);
      try {
        var xml = soapuiGen.buildProject(self.genCustomers(), {
          envName:  envName,
          endpoint: env.endpoint,
          apikey:   env.apikey,
          username: genConfig.username,
          password: pwd,
          chunk:    parseInt(self.genChunk(), 10) || 50,
        });
        var blob = new Blob([xml], { type: 'application/xml' });
        var a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = 'DCT-CreateCustomers-' + envName + '-soapui-project.xml';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        setTimeout(function () { URL.revokeObjectURL(a.href); }, 5000);
        toast.success(self.t('cust.genDone'));
      } catch (e) {
        toast.error(e.message || String(e));
      }
      self.genBusy(false);
    };

    self.reload();
  }

  return ArCustomersViewModel;
});
