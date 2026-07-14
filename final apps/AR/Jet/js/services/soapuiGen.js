/**
 * soapuiGen.js — client-side Excel -> SoapUI-project generator for the DoF
 * Fusion Receivables CreateCustomers operation (AR Customer integration).
 *
 * Browser port of final apps/AR/tools/soapui-customers/generate_soapui_customers.py
 * (keep the two in sync). Wire spec: AR/docs/ws/receivables-customer-ws.md.
 *
 * Endpoint/API-key/password come from GET /ar/customers/soapui-config
 * (AR_ADMIN/SYS_ADMIN only) — never hard-code credentials here.
 */
define([], function () {
  'use strict';

  var ADG_NS = 'http://xmlns.oracle.com/ADGGenericSoapWrapperApplication/ADGGenericSoapWrapperProcess';

  var TAGS = [
    'TRX_OPER', 'CUSTOMER_TYPE', 'CUSTOMER_NAME', 'CUSTOMER_CATEGORY_NAME',
    'CUSTOMER_CLASS_NAME', 'COUNTRY_CODE', 'CITY', 'ADDRESS1', 'ADDRESS2', 'ADDRESS3',
    'ADDRESS4', 'POSTAL_CODE', 'SITE_NAME', 'SITE_CODE', 'PO_BOX_NUMBER', 'AREA',
    'SITE_END_DATE', 'PAYMENT_TERMS', 'TRADE_LICENSE_NUM', 'LEGACY_CUSTOMER_NUMBER',
    'LEGACY_CUSTOMER_SITE_NUMBER', 'CONTACT_PERSON', 'CONTACT_NUMBER', 'EMAIL_ADDRESS',
    'COLLECTOR_NAME', 'SOURCE_SYSTEM', 'PERSON_IDEN_TYPE', 'PERSON_IDENTIFIER',
    'VAT_NUMBER', 'VAT_REGISTERATION_TYPE', 'VAT_REG_START_DATE', 'VAT_REG_END_DATE',
    'TAX_REGIME_CODE', 'EMIRATE', 'ATTRIBUTE10', 'CUSTOMER_NAME_AR', 'CUST_SITE_PURPOSE',
    'ACCT_CONTACT_RESP_TYPE', 'PARENT_CUST_ACCT_NO', 'CHILD_CUST_ACCT_NO',
    'ACC_REL_ADDR_SET', 'RECIPROCAL_RELATIONSHIP', 'REL_START_DATE', 'CONTEXT_VALUE',
    'ORG_CODE', 'SITE_NUMBER', 'TAX_REG_NUM_FLAG', 'TAX_REG_NUM_REASON', 'ACCT_ESTD_DATE',
    'PREF_DELIVERY_METHOD', 'GENERATE_BILL_FLAG', 'BANK_ACCT_NAME', 'ACCT_PRIMARY_IND',
    'BANK_FROM_DATE', 'BANK_ACCT_NUMBER', 'BANK_ACCT_CURRENCY', 'BANK_NAME', 'BRANCH_NAME',
    'BANK_HOME_COUNTRY_CODE', 'BANK_ACCT_COUNTRY_CODE', 'PRIMARY_OWNER', 'IBAN',
    'SEND_STATEMENT', 'STATEMENT_CYCLE', 'SEND_CREDIT_BALANCE', 'SEND_DUNNING_LETTERS',
    'PREF_CONTACT_METHOD', 'STATEMENT_PREF_DELIVERY_METHOD', 'CUSTOMER_PROFILE',
  ];

  var REQUIRED = [
    'TRX_OPER', 'CUSTOMER_TYPE', 'CUSTOMER_NAME', 'CUSTOMER_NAME_AR',
    'CUSTOMER_CATEGORY_NAME', 'CUSTOMER_CLASS_NAME', 'COUNTRY_CODE', 'EMIRATE',
    'CITY', 'ADDRESS1', 'SITE_NAME', 'SITE_CODE', 'CUST_SITE_PURPOSE',
    'LEGACY_CUSTOMER_NUMBER', 'LEGACY_CUSTOMER_SITE_NUMBER', 'CONTACT_PERSON',
    'COLLECTOR_NAME', 'SOURCE_SYSTEM', 'VAT_REGISTERATION_TYPE',
    'TAX_REGIME_CODE', 'ORG_CODE',
  ];

  var DATE_TAGS = { SITE_END_DATE: 1, VAT_REG_START_DATE: 1, VAT_REG_END_DATE: 1,
                    ACCT_ESTD_DATE: 1, REL_START_DATE: 1, BANK_FROM_DATE: 1 };

  var DEFAULTS = {
    TRX_OPER: 'CREATE', CUSTOMER_TYPE: 'ORGANIZATION',
    CUSTOMER_CATEGORY_NAME: 'High Value Customer',
    COUNTRY_CODE: 'AE', EMIRATE: 'Abu Dhabi', CUST_SITE_PURPOSE: 'BOTH',
    COLLECTOR_NAME: 'Default Collector', SOURCE_SYSTEM: 'DCT_SYSTEM',
    ORG_CODE: 'DCT', VAT_REGISTERATION_TYPE: 'VAT',
    TAX_REGIME_CODE: 'VAT_REGIME_UAE', ATTRIBUTE10: 'Y',
  };

  var EXAMPLE_ROW = {
    TRX_OPER: 'CREATE', CUSTOMER_TYPE: 'ORGANIZATION',
    CUSTOMER_NAME: 'Example Trading LLC', CUSTOMER_NAME_AR: 'شركة المثال للتجارة',
    CUSTOMER_CATEGORY_NAME: 'High Value Customer', CUSTOMER_CLASS_NAME: 'Local Company',
    COUNTRY_CODE: 'AE', EMIRATE: 'Abu Dhabi', CITY: 'Abu Dhabi',
    ADDRESS1: 'Corniche Road', POSTAL_CODE: 'NA', SITE_NAME: 'Abu Dhabi',
    SITE_CODE: 'CN-1234567', TRADE_LICENSE_NUM: 'CN-1234567',
    LEGACY_CUSTOMER_NUMBER: 'CN-1234567', LEGACY_CUSTOMER_SITE_NUMBER: 'CN-1234567',
    CONTACT_PERSON: 'John Smith', CONTACT_NUMBER: '+971501234567',
    EMAIL_ADDRESS: 'john@example.ae', COLLECTOR_NAME: 'Default Collector',
    SOURCE_SYSTEM: 'DCT_SYSTEM', VAT_NUMBER: '100123456700003',
    VAT_REGISTERATION_TYPE: 'VAT', TAX_REGIME_CODE: 'VAT_REGIME_UAE',
    ATTRIBUTE10: 'Y', CUST_SITE_PURPOSE: 'BOTH', ORG_CODE: 'DCT',
    TAX_REG_NUM_FLAG: 'N', TAX_REG_NUM_REASON: 'NO TRADE LICENSE',
  };

  var LOVS = {
    TRX_OPER: ['CREATE', 'UPDATE-SITE-CUSTOMER'],
    CUSTOMER_TYPE: ['ORGANIZATION', 'PERSON'],
    CUSTOMER_CATEGORY_NAME: ['High Value Customer'],
    CUSTOMER_CLASS_NAME: ['Local Company', 'International', 'Local'],
    CUST_SITE_PURPOSE: ['BOTH', 'BILL_TO', 'SHIP_TO'],
    PERSON_IDEN_TYPE: ['ID_NUMBER', 'EMAIL'],
    VAT_REGISTERATION_TYPE: ['VAT'],
    TAX_REGIME_CODE: ['VAT_REGIME_UAE'],
    TAX_REG_NUM_FLAG: ['Y', 'N'],
    TAX_REG_NUM_REASON: ['NO TRADE LICENSE'],
    PAYMENT_TERMS: ['IMMEDIATE'],
    EMIRATE: ['Abu Dhabi', 'Dubai', 'Sharjah', 'Ajman', 'Umm Al Quwain',
              'Ras Al Khaimah', 'Fujairah'],
    COLLECTOR_NAME: ['Default Collector'],
    CUSTOMER_PROFILE: ['DEFAULT'],
    ACCT_CONTACT_RESP_TYPE: ['Statement'],
    PREF_CONTACT_METHOD: ['EMAIL', 'PRINT'],
    PREF_DELIVERY_METHOD: ['EMAIL', 'PRINT'],
    STATEMENT_PREF_DELIVERY_METHOD: ['EMAIL', 'PRINT'],
    STATEMENT_CYCLE: ['Monthly'],
    GENERATE_BILL_FLAG: ['Y', 'N'], SEND_STATEMENT: ['Y', 'N'],
    SEND_CREDIT_BALANCE: ['Y', 'N'], SEND_DUNNING_LETTERS: ['Y', 'N'],
    ACCT_PRIMARY_IND: ['Y', 'N'],
  };

  /* ── helpers ─────────────────────────────────────────────────────── */
  function xesc(v) {
    return String(v).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  }
  function pad2(n) { return n < 10 ? '0' + n : String(n); }
  function uuid() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
      var r = Math.random() * 16 | 0;
      return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
    });
  }
  function normHeader(h) {
    return String(h).trim().toUpperCase().replace(/[^A-Z0-9]+/g, '_').replace(/^_|_$/g, '');
  }
  function cellToStr(val, tag) {
    if (val === null || val === undefined) { return ''; }
    if (val instanceof Date) {
      return pad2(val.getDate()) + '-' + pad2(val.getMonth() + 1) + '-' + val.getFullYear();
    }
    if (typeof val === 'number') {
      return Number.isInteger(val) ? String(val) : String(val);
    }
    var s = String(val).trim();
    if (DATE_TAGS[tag] && /^\d{4}-\d{2}-\d{2}/.test(s)) {       // ISO -> gateway
      return s.slice(8, 10) + '-' + s.slice(5, 7) + '-' + s.slice(0, 4);
    }
    return s;
  }

  /* ── Excel (SheetJS workbook buffer) -> {customers, errors} ─────── */
  function parseWorkbook(XLSX, buf) {
    var wb = XLSX.read(buf, { type: 'array', cellDates: true });
    var ws = wb.Sheets[wb.SheetNames.indexOf('Customers') >= 0 ? 'Customers' : wb.SheetNames[0]];
    var aoa = XLSX.utils.sheet_to_json(ws, { header: 1, raw: true, defval: null });
    if (!aoa.length) { return { customers: [], errors: ['Empty sheet'] }; }

    var cols = {};                                   // colIdx -> tag
    (aoa[0] || []).forEach(function (h, i) {
      if (h === null) { return; }
      var t = normHeader(h);
      if (TAGS.indexOf(t) >= 0) { cols[i] = t; }
    });
    var haveName = Object.keys(cols).some(function (i) { return cols[i] === 'CUSTOMER_NAME'; });
    if (!haveName) {
      return { customers: [], errors: ['No CUSTOMER_NAME column found — headers must be the wire attribute names (download the template).'] };
    }

    var customers = [], errors = [];
    for (var r = 1; r < aoa.length; r++) {
      var rec = {}, any = false;
      (aoa[r] || []).forEach(function (v, i) {
        var tag = cols[i];
        if (!tag) { return; }
        var s = cellToStr(v, tag);
        if (s !== '') { rec[tag] = s; any = true; }
      });
      if (!any) { continue; }
      if (rec.CUSTOMER_NAME === 'Example Trading LLC') { continue; }   // untouched template row
      Object.keys(DEFAULTS).forEach(function (t) { if (!rec[t]) { rec[t] = DEFAULTS[t]; } });
      if (!rec.CUSTOMER_NAME_AR && rec.CUSTOMER_NAME) { rec.CUSTOMER_NAME_AR = rec.CUSTOMER_NAME; }
      var missing = REQUIRED.filter(function (t) { return !rec[t]; });
      if (missing.length) {
        errors.push('Row ' + (r + 1) + ' (' + (rec.CUSTOMER_NAME || '?') + '): missing ' + missing.join(', '));
      }
      customers.push(rec);
    }
    if (!customers.length && !errors.length) { errors.push('No data rows found.'); }
    return { customers: customers, errors: errors };
  }

  /* ── envelope + SoapUI project XML ──────────────────────────────── */
  function buildEnvelope(customers) {
    var p = ['<soapenv:Envelope xmlns:adg="' + ADG_NS + '" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">',
             '   <soapenv:Header/>', '   <soapenv:Body>',
             '      <adg:ADGRequestPayload>',
             '         <adg:OperationName>CreateCustomers</adg:OperationName>',
             '         <adg:InputPayload>', '            <CreateCustomers>', '               <arg0>'];
    customers.forEach(function (rec) {
      p.push('                  <postCustomerData>');
      TAGS.forEach(function (tag) {
        if (rec[tag] !== undefined) {
          p.push('                     <' + tag + '>' + xesc(rec[tag]) + '</' + tag + '>');
        }
      });
      p.push('                  </postCustomerData>');
    });
    p.push('               </arg0>', '            </CreateCustomers>',
           '         </adg:InputPayload>', '      </adg:ADGRequestPayload>',
           '   </soapenv:Body>', '</soapenv:Envelope>');
    return p.join('\n').replace(/\]\]>/g, ']]&gt;');
  }

  function wsdlXml(service, endpoint) {
    return '<wsdl:definitions name="ADGGenericSoapWrapperService" targetNamespace="' + ADG_NS + '"'
      + ' xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" xmlns:client="' + ADG_NS + '"'
      + ' xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/">'
      + '<wsdl:types><schema attributeFormDefault="unqualified" elementFormDefault="qualified"'
      + ' targetNamespace="' + ADG_NS + '" xmlns="http://www.w3.org/2001/XMLSchema">'
      + '<element name="ADGRequestPayload"><complexType><sequence>'
      + '<element name="OperationName" type="string"/><element name="InputPayload" type="anyType"/>'
      + '</sequence></complexType></element>'
      + '<element name="ADGResponsePayload"><complexType><sequence>'
      + '<element name="OutputPayload" type="anyType"/></sequence></complexType></element>'
      + '</schema></wsdl:types>'
      + '<wsdl:message name="ADGRequestMessage"><wsdl:part name="payload" element="client:ADGRequestPayload"></wsdl:part></wsdl:message>'
      + '<wsdl:message name="ADGResponseMessage"><wsdl:part name="payload" element="client:ADGResponsePayload"></wsdl:part></wsdl:message>'
      + '<wsdl:portType name="ADGGenericSoapWrapperProcess_ReceiveRequest_REQUEST">'
      + '<wsdl:operation name="ADGSoapWraperProcess">'
      + '<wsdl:input message="client:ADGRequestMessage"></wsdl:input>'
      + '<wsdl:output message="client:ADGResponseMessage"></wsdl:output>'
      + '</wsdl:operation></wsdl:portType>'
      + '<wsdl:binding name="ADGGenericSoapWrapperProcess_ReceiveRequest_REQUEST_binding"'
      + ' type="client:ADGGenericSoapWrapperProcess_ReceiveRequest_REQUEST">'
      + '<soap:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>'
      + '<wsdl:operation name="ADGSoapWraperProcess"><soap:operation soapAction="ADGSoapWraperProcess"/>'
      + '<wsdl:input><soap:body parts="payload" use="literal"/></wsdl:input>'
      + '<wsdl:output><soap:body parts="payload" use="literal"/></wsdl:output>'
      + '</wsdl:operation></wsdl:binding>'
      + '<wsdl:service name="' + service + '">'
      + '<wsdl:port name="ADGGenericSoapWrapperProcess_ReceiveRequest_REQUEST_pt"'
      + ' binding="client:ADGGenericSoapWrapperProcess_ReceiveRequest_REQUEST_binding">'
      + '<soap:address location="' + endpoint + '"/></wsdl:port></wsdl:service>'
      + '</wsdl:definitions>';
  }

  /**
   * cfg: { envName, endpoint, apikey, username, password, chunk }
   * returns the SoapUI 5.x project XML string
   */
  function buildProject(customers, cfg) {
    var chunk = Math.max(1, cfg.chunk || 50);
    var service = cfg.envName === 'PROD' ? 'Receivables' : 'Receivables_TEST';
    var wsdlUrl = cfg.endpoint + '?wsdl';
    var headerSetting = xesc('<entry key="x-CentraSite-APIKey" value="' + cfg.apikey +
                             '" xmlns="http://eviware.com/soapui/config"/>');
    var calls = [];
    for (var i = 0; i < customers.length; i += chunk) {
      var batch = customers.slice(i, i + chunk);
      var label = customers.length > chunk
        ? 'CreateCustomers ' + (i + 1) + '-' + (i + batch.length) + ' of ' + customers.length
        : 'CreateCustomers (' + batch.length + ' customers)';
      calls.push('<con:call id="' + uuid() + '" name="' + xesc(label) + '">'
        + '<con:settings><con:setting id="com.eviware.soapui.impl.wsdl.WsdlRequest@request-headers">'
        + headerSetting + '</con:setting></con:settings>'
        + '<con:encoding>UTF-8</con:encoding>'
        + '<con:endpoint>' + cfg.endpoint + '</con:endpoint>'
        + '<con:request><![CDATA[' + buildEnvelope(batch) + ']]></con:request>'
        + '<con:credentials><con:username>' + xesc(cfg.username) + '</con:username>'
        + '<con:password>' + xesc(cfg.password) + '</con:password>'
        + '<con:selectedAuthProfile>Basic</con:selectedAuthProfile>'
        + '<con:addedBasicAuthenticationTypes>Basic</con:addedBasicAuthenticationTypes>'
        + '<con:authType>Global HTTP Settings</con:authType></con:credentials>'
        + '<con:jmsConfig JMSDeliveryMode="PERSISTENT"/><con:jmsPropertyConfig/>'
        + '<con:wsaConfig mustUnderstand="NONE" version="200508" action="ADGSoapWraperProcess"/>'
        + '<con:wsrmConfig version="1.2"/></con:call>');
    }

    return '<?xml version="1.0" encoding="UTF-8"?>\n'
      + '<con:soapui-project id="' + uuid() + '" activeEnvironment="Default" '
      + 'name="DCT-CreateCustomers-' + cfg.envName + '" resourceRoot="" soapui-version="5.9.1" '
      + 'abortOnError="false" runType="SEQUENTIAL" xmlns:con="http://eviware.com/soapui/config">'
      + '<con:settings/>'
      + '<con:interface xsi:type="con:WsdlInterface" id="' + uuid() + '" wsaVersion="NONE" '
      + 'name="ADGGenericSoapWrapperProcess_ReceiveRequest_REQUEST_binding" type="wsdl" '
      + 'bindingName="{' + ADG_NS + '}ADGGenericSoapWrapperProcess_ReceiveRequest_REQUEST_binding" '
      + 'soapVersion="1_1" anonymous="optional" definition="' + wsdlUrl + '" '
      + 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><con:settings/>'
      + '<con:definitionCache type="TEXT" rootPart="' + wsdlUrl + '">'
      + '<con:part><con:url>' + wsdlUrl + '</con:url>'
      + '<con:content><![CDATA[' + wsdlXml(service, cfg.endpoint) + ']]></con:content>'
      + '<con:type>http://schemas.xmlsoap.org/wsdl/</con:type></con:part></con:definitionCache>'
      + '<con:endpoints><con:endpoint>' + cfg.endpoint + '</con:endpoint></con:endpoints>'
      + '<con:operation id="' + uuid() + '" isOneWay="false" action="ADGSoapWraperProcess" '
      + 'name="ADGSoapWraperProcess" bindingOperationName="ADGSoapWraperProcess" '
      + 'type="Request-Response" inputName="" receivesAttachments="false" '
      + 'sendsAttachments="false" anonymous="optional"><con:settings/>' + calls.join('')
      + '</con:operation></con:interface><con:properties/><con:wssContainer/>'
      + '<con:oAuth2ProfileContainer/><con:oAuth1ProfileContainer/>'
      + '<con:sensitiveInformation/></con:soapui-project>\n';
  }

  /* ── Excel template (SheetJS) ───────────────────────────────────── */
  function downloadTemplate(XLSX) {
    var head = TAGS.slice();
    var example = TAGS.map(function (t) { return EXAMPLE_ROW[t] || ''; });
    var ws = XLSX.utils.aoa_to_sheet([head, example]);
    ws['!cols'] = head.map(function (h) { return { wch: Math.max(14, Math.min(h.length + 4, 32)) }; });
    var lovAoa = [['Field', 'Allowed values (see AR/docs/ws spec; row 2 on sheet 1 is an EXAMPLE — replace it)'],
                  ['REQUIRED FIELDS', REQUIRED.join(' | ')]];
    Object.keys(LOVS).sort().forEach(function (t) { lovAoa.push([t, LOVS[t].join(' | ')]); });
    var lv = XLSX.utils.aoa_to_sheet(lovAoa);
    lv['!cols'] = [{ wch: 34 }, { wch: 100 }];
    var wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Customers');
    XLSX.utils.book_append_sheet(wb, lv, 'LOVs');
    XLSX.writeFile(wb, 'ar_customers_template.xlsx');
  }

  return {
    TAGS: TAGS, REQUIRED: REQUIRED, DEFAULTS: DEFAULTS, LOVS: LOVS,
    parseWorkbook: parseWorkbook,
    buildProject: buildProject,
    downloadTemplate: downloadTemplate,
  };
});
