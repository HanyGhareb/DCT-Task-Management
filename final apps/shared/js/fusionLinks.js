/**
 * fusionLinks.js — Oracle Fusion deep-link builders (shared, all apps).
 *
 * UMD: works in BOTH app styles.
 *   JET shell apps (requirejs):  define(['shared/fusionLinks'], function (fusion) { ... })
 *   Portal-style plain-KO apps:  <script src="/shared/js/fusionLinks.js"></script>
 *                                then use the window.FusionLinks global.
 *
 *   fusion.invoice(invoiceId)      → View AP Invoice        (AP_VIEWINVOICE)
 *   fusion.purchaseOrder(poHdrId)  → View Purchase Order    (PURCHASE_ORDER)
 *   fusion.requisition(prHdrId)    → View Requisition       (PURCHASE_REQUISITION_LOBUSER)
 *   fusion.link(objType, keyName, id) → any other deeplink objType
 *
 * The ids are the FUSION internal ids (invoice_id / po_header_id /
 * pr_header_id from the loaded extracts), NOT the document numbers.
 * Render with target="_blank" rel="noopener noreferrer" — deep links always
 * open in a separate tab. All builders return '#' for a null/empty id.
 */
(function (root, factory) {
  if (typeof define === 'function' && define.amd) { define([], factory); }
  else { root.FusionLinks = factory(); }
}(typeof self !== 'undefined' ? self : this, function () {
  'use strict';

  var BASE = 'https://iaaibv.fa.ocs.oraclecloud29.com/fscmUI/faces/deeplink';

  function link(objType, keyName, id) {
    if (id === null || id === undefined || id === '') return '#';
    return BASE + '?objType=' + objType + '&objKey=' + keyName + '=' + encodeURIComponent(id) + '&action=VIEW';
  }

  return {
    base: BASE,
    link: link,
    invoice:       function (id) { return link('AP_VIEWINVOICE', 'InvoiceId', id); },
    purchaseOrder: function (id) { return link('PURCHASE_ORDER', 'poHeaderId', id); },
    requisition:   function (id) { return link('PURCHASE_REQUISITION_LOBUSER', 'requisitionHeaderId', id); },
  };
}));
