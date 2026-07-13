-- =============================================================================
-- Effective AP supplier (beneficiary-aware) -- ONE shared resolution view
-- File   : db/v2/51_ap_supplier_eff.sql
-- Schema : PROD
-- Run    : sql -name prod_mcp @51_ap_supplier_eff.sql   (rerunnable)
-- Rule   : invoices of the generic BENEFICIARY supplier display the
--          beneficiary's NAME, never the generic supplier name. When the
--          invoice's own beneficiary_name arrives NULL from Fusion, the name
--          recorded for the SAME supplier site on any other invoice is used
--          (the site uniquely identifies the person). Falls back to the raw
--          supplier name only when the site was never named anywhere.
-- Consumers (keep in lock-step; platform rule 2026-07-14: EVERY surface that
-- displays an AP-invoice vendor resolves it through this rule):
--   * GL Budget Utilization AP drill        (GL/db/07  -> joins this view)
--   * DCT_UNPAID_INVOICES_V report view     (db/v2/39  -> joins this view)
--   * DCT_ACTUAL_V unified fact, AP branch  (db/v2/32  -> joins this view)
--   * AP module AP_*_V views embed the same rule directly (AP/db/05)
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON

CREATE OR REPLACE VIEW prod.dct_ap_supplier_eff_v AS
SELECT i.invoice_id,
       i.supplier_number,
       i.supplier_name                                        AS raw_supplier_name,
       CASE WHEN i.supplier_name = 'BENEFICIARY'
            THEN COALESCE(i.beneficiary_name, bs.beneficiary_name, i.supplier_name)
            ELSE i.supplier_name END                          AS supplier_name
FROM prod.ap_invoices i
LEFT JOIN (SELECT supplier_number, site, MAX(beneficiary_name) AS beneficiary_name
             FROM prod.ap_invoices
            WHERE supplier_name = 'BENEFICIARY' AND beneficiary_name IS NOT NULL
            GROUP BY supplier_number, site) bs
       ON bs.supplier_number = i.supplier_number
      AND bs.site = i.site;

PROMPT === verification -- expect VALID + remaining generic count (~4) ===
SELECT status FROM all_objects
 WHERE owner = 'PROD' AND object_name = 'DCT_AP_SUPPLIER_EFF_V';
SELECT COUNT(*) still_generic
  FROM prod.dct_ap_supplier_eff_v
 WHERE raw_supplier_name = 'BENEFICIARY' AND supplier_name = 'BENEFICIARY';
