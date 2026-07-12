define(['knockout', 'services/arCustomerService', 'shared/i18n', 'shared/toast'],
function (ko, custService, i18n, toast) {
  'use strict';

  // Field catalog — mirrors the DoF Receivables postCustomerData spec
  // (final apps/AR/docs/ws/receivables-customer-ws.md § 4).
  // type: text | date | select | yn ; lov: AR_* lookup code or 'countries'
  var SECTIONS = [
    { key: 'identity', fields: [
      { key: 'TRX_OPER',                  type: 'select', lov: 'AR_CUST_TRX_OPER',     req: true },
      { key: 'CUSTOMER_TYPE',             type: 'select', lov: 'AR_CUST_TYPE',         req: true },
      { key: 'CUSTOMER_NAME',             type: 'text',                                req: true },
      { key: 'CUSTOMER_NAME_AR',          type: 'text',                                req: true },
      { key: 'CUSTOMER_CATEGORY_NAME',    type: 'select', lov: 'AR_CUST_CATEGORY',     req: true },
      { key: 'CUSTOMER_CLASS_NAME',       type: 'select', lov: 'AR_CUST_CLASS',        req: true },
      { key: 'CUSTOMER_PROFILE',          type: 'select', lov: 'AR_CUST_PROFILE' },
    ]},
    { key: 'address', fields: [
      { key: 'COUNTRY_CODE',              type: 'select', lov: 'countries',            req: true },
      { key: 'EMIRATE',                   type: 'select', lov: 'AR_EMIRATE',           req: true },
      { key: 'CITY',                      type: 'text',                                req: true },
      { key: 'ADDRESS1',                  type: 'text',                                req: true },
      { key: 'ADDRESS2',                  type: 'text' },
      { key: 'ADDRESS3',                  type: 'text' },
      { key: 'ADDRESS4',                  type: 'text' },
      { key: 'POSTAL_CODE',               type: 'text' },
      { key: 'PO_BOX_NUMBER',             type: 'text' },
      { key: 'AREA',                      type: 'text' },
      { key: 'SITE_NAME',                 type: 'text',                                req: true },
      { key: 'SITE_CODE',                 type: 'text',                                req: true },
      { key: 'SITE_NUMBER',               type: 'text' },
      { key: 'SITE_END_DATE',             type: 'date' },
      { key: 'CUST_SITE_PURPOSE',         type: 'select', lov: 'AR_CUST_SITE_PURPOSE', req: true },
    ]},
    { key: 'refs', fields: [
      { key: 'LEGACY_CUSTOMER_NUMBER',      type: 'text', req: true },
      { key: 'LEGACY_CUSTOMER_SITE_NUMBER', type: 'text', req: true },
      { key: 'TRADE_LICENSE_NUM',           type: 'text' },
    ]},
    { key: 'contact', fields: [
      { key: 'CONTACT_PERSON',            type: 'text',                                req: true },
      { key: 'CONTACT_NUMBER',            type: 'text' },
      { key: 'EMAIL_ADDRESS',             type: 'text' },
      { key: 'PREF_CONTACT_METHOD',       type: 'select', lov: 'AR_DELIVERY_METHOD' },
      { key: 'PREF_DELIVERY_METHOD',      type: 'select', lov: 'AR_DELIVERY_METHOD' },
      { key: 'ACCT_CONTACT_RESP_TYPE',    type: 'select', lov: 'AR_ACCT_RESP_TYPE' },
      { key: 'PERSON_IDEN_TYPE',          type: 'select', lov: 'AR_PERSON_IDEN_TYPE' },
      { key: 'PERSON_IDENTIFIER',         type: 'text' },
    ]},
    { key: 'tax', fields: [
      { key: 'VAT_REGISTERATION_TYPE',    type: 'select', lov: 'AR_VAT_REG_TYPE',      req: true },
      { key: 'TAX_REGIME_CODE',           type: 'select', lov: 'AR_TAX_REGIME',        req: true },
      { key: 'VAT_NUMBER',                type: 'text' },
      { key: 'VAT_REG_START_DATE',        type: 'date' },
      { key: 'VAT_REG_END_DATE',          type: 'date' },
      { key: 'TAX_REG_NUM_FLAG',          type: 'yn' },
      { key: 'TAX_REG_NUM_REASON',        type: 'select', lov: 'AR_TAX_REG_REASON' },
    ]},
    { key: 'financial', fields: [
      { key: 'PAYMENT_TERMS',             type: 'select', lov: 'AR_CUST_PAYMENT_TERMS' },
      { key: 'COLLECTOR_NAME',            type: 'select', lov: 'AR_COLLECTOR',         req: true },
      { key: 'GENERATE_BILL_FLAG',        type: 'yn' },
      { key: 'SEND_STATEMENT',            type: 'yn' },
      { key: 'STATEMENT_CYCLE',           type: 'select', lov: 'AR_STATEMENT_CYCLE' },
      { key: 'STATEMENT_PREF_DELIVERY_METHOD', type: 'select', lov: 'AR_DELIVERY_METHOD' },
      { key: 'SEND_CREDIT_BALANCE',       type: 'yn' },
      { key: 'SEND_DUNNING_LETTERS',      type: 'yn' },
      { key: 'ACCT_ESTD_DATE',            type: 'date' },
      { key: 'ATTRIBUTE10',               type: 'yn' },
    ]},
    { key: 'bank', fields: [
      { key: 'BANK_ACCT_NAME',            type: 'text' },
      { key: 'ACCT_PRIMARY_IND',          type: 'yn' },
      { key: 'BANK_FROM_DATE',            type: 'date' },
      { key: 'BANK_ACCT_NUMBER',          type: 'text' },
      { key: 'BANK_ACCT_CURRENCY',        type: 'text' },
      { key: 'BANK_NAME',                 type: 'text' },
      { key: 'BRANCH_NAME',               type: 'text' },
      { key: 'BANK_HOME_COUNTRY_CODE',    type: 'select', lov: 'countries' },
      { key: 'BANK_ACCT_COUNTRY_CODE',    type: 'select', lov: 'countries' },
      { key: 'PRIMARY_OWNER',             type: 'text' },
      { key: 'IBAN',                      type: 'text' },
    ]},
    { key: 'relationships', fields: [
      { key: 'PARENT_CUST_ACCT_NO',       type: 'text' },
      { key: 'CHILD_CUST_ACCT_NO',        type: 'text' },
      { key: 'ACC_REL_ADDR_SET',          type: 'text' },
      { key: 'RECIPROCAL_RELATIONSHIP',   type: 'text' },
      { key: 'REL_START_DATE',            type: 'date' },
      { key: 'CONTEXT_VALUE',             type: 'text' },
    ]},
  ];

  function ArCustomerFormViewModel() {
    var self = this;
    self.t = i18n.t;

    var state      = window._arApp.getState();
    var customerId = state.customerId || null;
    self.isEdit    = !!customerId;

    self.saving   = ko.observable(false);
    self.readOnly = ko.observable(false);
    self.status   = ko.observable('DRAFT');
    self.wsEnv    = ko.observable('');
    self.fusionCode   = ko.observable('');
    self.errorMessage = ko.observable('');
    self.wsLive   = ko.observable(true);

    self.sections = SECTIONS;

    // one observable per WS attribute + per-field options holder
    self.f = {};
    SECTIONS.forEach(function (sec) {
      sec.fields.forEach(function (fld) {
        self.f[fld.key] = ko.observable('');
        if (fld.lov) { fld.options = ko.observableArray([]); }
      });
    });

    self.lovText = function (item) {
      return (i18n.lang && i18n.lang() === 'ar' && item.nameAr) ? item.nameAr : item.nameEn;
    };

    custService.lovs().then(function (lv) {
      self.wsLive(!!lv.wsLive);
      SECTIONS.forEach(function (sec) {
        sec.fields.forEach(function (fld) {
          if (!fld.lov) { return; }
          var list = fld.lov === 'countries' ? (lv.countries || [])
                                             : ((lv.lookups || {})[fld.lov] || []);
          fld.options(list);
          // apply LOV default on a fresh form
          if (!self.isEdit && !self.f[fld.key]()) {
            var def = list.filter(function (v) { return v.isDefault; })[0];
            if (def) { self.f[fld.key](def.code); }
          }
        });
      });
      if (!self.isEdit && !self.f.COUNTRY_CODE()) { self.f.COUNTRY_CODE('AE'); }
    }).catch(function () {});

    if (customerId) {
      custService.get(customerId).then(function (c) {
        self.status(c.status);
        self.wsEnv(c.wsEnv || '');
        self.fusionCode(c.fusionCode || '');
        self.errorMessage(c.errorMessage || '');
        self.readOnly(c.status !== 'DRAFT' && c.status !== 'ERROR');
        var payload = {};
        try { payload = JSON.parse(c.payloadJson || '{}'); } catch (e) { /* keep empty */ }
        Object.keys(self.f).forEach(function (k) {
          if (payload[k] !== undefined && payload[k] !== null) { self.f[k](String(payload[k])); }
        });
      }).catch(function (err) {
        toast.error((err && err.message) || self.t('empty.loadFailed'));
      });
    }

    self.statusClass = ko.computed(function () {
      var map = {
        DRAFT: 'badge badge--neutral', SENT: 'badge badge--warning',
        PROCESSED: 'badge badge--success', ERROR: 'badge badge--danger',
      };
      return map[self.status()] || 'badge badge--neutral';
    });

    function buildPayload() {
      var p = {};
      Object.keys(self.f).forEach(function (k) {
        var v = self.f[k]();
        if (v !== '' && v !== null && v !== undefined) { p[k] = v; }
      });
      return p;
    }

    function firstMissing() {
      var missing = null;
      SECTIONS.some(function (sec) {
        return sec.fields.some(function (fld) {
          if (fld.req && !self.f[fld.key]()) { missing = fld.key; return true; }
          return false;
        });
      });
      return missing;
    }

    function persist() {
      var payload = buildPayload();
      return customerId
        ? custService.update(customerId, payload).then(function () { return { id: customerId }; })
        : custService.create(payload);
    }

    self.back = function () { window._arApp.navigate('arCustomers'); };

    self.saveDraft = function () {
      var miss = firstMissing();
      if (miss) { toast.error(self.t('cust.required') + ': ' + self.t('cust.f.' + miss)); return; }
      self.saving(true);
      persist().then(function () {
        self.saving(false);
        toast.success(self.t('cust.toastSaved'));
        window._arApp.navigate('arCustomers');
      }).catch(function (err) {
        self.saving(false);
        toast.error((err && err.message) || self.t('cust.toastSaveFailed'));
      });
    };

    self.saveAndSubmit = function () {
      var miss = firstMissing();
      if (miss) { toast.error(self.t('cust.required') + ': ' + self.t('cust.f.' + miss)); return; }
      self.saving(true);
      persist().then(function (res) {
        return custService.submit(res.id);
      }).then(function (res) {
        self.saving(false);
        if (res.ok) { toast.success(self.t('cust.toastSent')); }
        else { toast.error(res.errorMessage || self.t('cust.toastSendFailed')); }
        window._arApp.navigate('arCustomers');
      }).catch(function (err) {
        self.saving(false);
        toast.error((err && err.message) || self.t('cust.toastSendFailed'));
      });
    };
  }

  return ArCustomerFormViewModel;
});
