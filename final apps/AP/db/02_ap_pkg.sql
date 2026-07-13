-- =============================================================================
-- Accounts Payable (App 212) -- shared facet filter engine
-- File    : 02_ap_pkg.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @02_ap_pkg.sql
-- Notes   : one place that turns the AP-dashboard facet parameters into the
--           set of matching invoice ids; every ap.rest handler reuses it so
--           the charts, KPIs, register and export always agree.
--           Multi-value facet params arrive pipe-delimited, e.g. a|b|c.
--           Reads the Fusion-loaded views ap_invoices_header_v,
--           ap_invoice_lines_v, ap_invoice_distributions_v (read-only).
--           RULE (2026-07-13): every distribution-grain facet considers ITEM
--           distributions only (distribution_type = 'Item') -- tax/freight
--           rows carry unmapped cost centers and were dragging classified
--           invoices into Unclassified, so facet counts missed the KPIs.
--           /filters LOVs + the bySector dataset apply the same rule.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON

CREATE OR REPLACE PACKAGE prod.dct_ap_pkg AS

    -- 1 when p_val is one of the pipe-delimited entries in p_list
    FUNCTION in_list(p_list VARCHAR2, p_val VARCHAR2) RETURN NUMBER DETERMINISTIC;

    -- ids of the invoices matching every supplied facet (NULL facet = no filter)
    FUNCTION filtered_ids(
        p_datefrom  VARCHAR2 DEFAULT NULL,   -- YYYY-MM-DD, on invoice_date
        p_dateto    VARCHAR2 DEFAULT NULL,
        p_supplier  VARCHAR2 DEFAULT NULL,   -- multi
        p_paid      VARCHAR2 DEFAULT NULL,   -- multi, payment_status
        p_val       VARCHAR2 DEFAULT NULL,   -- multi, validation_status
        p_acc       VARCHAR2 DEFAULT NULL,   -- multi, accounting_status
        p_inv       VARCHAR2 DEFAULT NULL,   -- multi, invoice_status
        p_itype     VARCHAR2 DEFAULT NULL,   -- multi, invoice_type
        p_curr      VARCHAR2 DEFAULT NULL,   -- multi, invoice_currency
        p_paygroup  VARCHAR2 DEFAULT NULL,   -- multi, (None) = blank
        p_paymethod VARCHAR2 DEFAULT NULL,   -- multi
        p_sector    VARCHAR2 DEFAULT NULL,   -- multi, dists; Unclassified = blank
        p_dept      VARCHAR2 DEFAULT NULL,   -- multi, lines expenditure_organization
        p_cc        VARCHAR2 DEFAULT NULL,   -- multi, dists cost_center_code
        p_project   VARCHAR2 DEFAULT NULL,   -- multi, dists project_number
        p_task      VARCHAR2 DEFAULT NULL,   -- single, dists task_number
        p_etype     VARCHAR2 DEFAULT NULL,   -- multi, dists expenditure_type
        p_account   VARCHAR2 DEFAULT NULL,   -- multi, dists account_code
        p_approp    VARCHAR2 DEFAULT NULL,   -- multi, dists appropriation_code
        p_po        VARCHAR2 DEFAULT NULL,   -- single, dists po_number
        p_pr        VARCHAR2 DEFAULT NULL,   -- single, dists pr_number
        p_req       VARCHAR2 DEFAULT NULL,   -- multi, dists pr_preparer
        p_search    VARCHAR2 DEFAULT NULL,   -- free text on number/supplier/description/po list
        -- enhancement round 2026-07-13: chart drills + new criteria ---------
        p_gldatefrom VARCHAR2 DEFAULT NULL,  -- YYYY-MM-DD, on gl_date
        p_gldateto   VARCHAR2 DEFAULT NULL,
        p_rcvfrom    VARCHAR2 DEFAULT NULL,  -- YYYY-MM-DD, on COALESCE(invoice_received_date, created_date, invoice_date)
        p_rcvto      VARCHAR2 DEFAULT NULL,
        p_esupplier  VARCHAR2 DEFAULT NULL,  -- multi, EFFECTIVE supplier (beneficiary-aware; top-suppliers drill)
        p_aging      VARCHAR2 DEFAULT NULL,  -- single aging bucket CURRENT|D1_30|D31_60|D61_90|D91_180|D180P
        p_inclcxl    VARCHAR2 DEFAULT 'Y'    -- 'N' = exclude cancelled invoices
    ) RETURN apex_t_number;

END dct_ap_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_ap_pkg AS

    FUNCTION in_list(p_list VARCHAR2, p_val VARCHAR2) RETURN NUMBER DETERMINISTIC IS
    BEGIN
        RETURN CASE WHEN INSTR('|' || p_list || '|', '|' || p_val || '|') > 0
                    THEN 1 ELSE 0 END;
    END in_list;

    FUNCTION filtered_ids(
        p_datefrom  VARCHAR2 DEFAULT NULL,
        p_dateto    VARCHAR2 DEFAULT NULL,
        p_supplier  VARCHAR2 DEFAULT NULL,
        p_paid      VARCHAR2 DEFAULT NULL,
        p_val       VARCHAR2 DEFAULT NULL,
        p_acc       VARCHAR2 DEFAULT NULL,
        p_inv       VARCHAR2 DEFAULT NULL,
        p_itype     VARCHAR2 DEFAULT NULL,
        p_curr      VARCHAR2 DEFAULT NULL,
        p_paygroup  VARCHAR2 DEFAULT NULL,
        p_paymethod VARCHAR2 DEFAULT NULL,
        p_sector    VARCHAR2 DEFAULT NULL,
        p_dept      VARCHAR2 DEFAULT NULL,
        p_cc        VARCHAR2 DEFAULT NULL,
        p_project   VARCHAR2 DEFAULT NULL,
        p_task      VARCHAR2 DEFAULT NULL,
        p_etype     VARCHAR2 DEFAULT NULL,
        p_account   VARCHAR2 DEFAULT NULL,
        p_approp    VARCHAR2 DEFAULT NULL,
        p_po        VARCHAR2 DEFAULT NULL,
        p_pr        VARCHAR2 DEFAULT NULL,
        p_req       VARCHAR2 DEFAULT NULL,
        p_search    VARCHAR2 DEFAULT NULL,
        p_gldatefrom VARCHAR2 DEFAULT NULL,
        p_gldateto   VARCHAR2 DEFAULT NULL,
        p_rcvfrom    VARCHAR2 DEFAULT NULL,
        p_rcvto      VARCHAR2 DEFAULT NULL,
        p_esupplier  VARCHAR2 DEFAULT NULL,
        p_aging      VARCHAR2 DEFAULT NULL,
        p_inclcxl    VARCHAR2 DEFAULT 'Y'
    ) RETURN apex_t_number IS
        -- performance note: the dist/line facets each run ONE scan of their
        -- view into an id-set which is intersected in memory; correlated
        -- EXISTS against the un-indexed ATD-loaded views is minutes-slow.
        l_ids  apex_t_number;
        l_tmp  apex_t_number;
        l_from DATE := TO_DATE(p_datefrom DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
        l_to   DATE := TO_DATE(p_dateto   DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
        l_glfrom  DATE := TO_DATE(p_gldatefrom DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
        l_glto    DATE := TO_DATE(p_gldateto   DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
        l_rcvfrom DATE := TO_DATE(p_rcvfrom    DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
        l_rcvto   DATE := TO_DATE(p_rcvto      DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
    BEGIN
        SELECT h.invoice_id BULK COLLECT INTO l_ids
          FROM prod.ap_invoices_header_v h
         WHERE (l_from IS NULL OR h.invoice_date >= l_from)
           AND (l_to   IS NULL OR h.invoice_date <  l_to + 1)
           AND (l_glfrom IS NULL OR h.gl_date >= l_glfrom)
           AND (l_glto   IS NULL OR h.gl_date <  l_glto + 1)
           AND (l_rcvfrom IS NULL OR COALESCE(h.invoice_received_date, h.created_date, h.invoice_date) >= l_rcvfrom)
           AND (l_rcvto   IS NULL OR COALESCE(h.invoice_received_date, h.created_date, h.invoice_date) <  l_rcvto + 1)
           AND (NVL(p_inclcxl,'Y') = 'Y' OR h.invoice_status <> 'Cancelled')
           AND (p_esupplier IS NULL OR dct_ap_pkg.in_list(p_esupplier,
                    CASE WHEN h.supplier_name = 'BENEFICIARY' AND h.beneficiary_name IS NOT NULL
                         THEN h.beneficiary_name ELSE h.supplier_name END) = 1)
           AND (p_aging IS NULL OR (
                    h.payment_status = 'Unpaid' AND NVL(h.balance_due,0) <> 0 AND
                    CASE WHEN TRUNC(NVL(h.terms_date, h.invoice_date)) >= TRUNC(SYSDATE) THEN 'CURRENT'
                         WHEN TRUNC(SYSDATE) - TRUNC(NVL(h.terms_date, h.invoice_date)) <= 30 THEN 'D1_30'
                         WHEN TRUNC(SYSDATE) - TRUNC(NVL(h.terms_date, h.invoice_date)) <= 60 THEN 'D31_60'
                         WHEN TRUNC(SYSDATE) - TRUNC(NVL(h.terms_date, h.invoice_date)) <= 90 THEN 'D61_90'
                         WHEN TRUNC(SYSDATE) - TRUNC(NVL(h.terms_date, h.invoice_date)) <= 180 THEN 'D91_180'
                         ELSE 'D180P' END = UPPER(TRIM(p_aging))))
           AND (p_supplier  IS NULL OR dct_ap_pkg.in_list(p_supplier,  h.supplier_name)      = 1)
           AND (p_paid      IS NULL OR dct_ap_pkg.in_list(p_paid,      h.payment_status)     = 1)
           AND (p_val       IS NULL OR dct_ap_pkg.in_list(p_val,       h.validation_status)  = 1)
           AND (p_acc       IS NULL OR dct_ap_pkg.in_list(p_acc,       h.accounting_status)  = 1)
           AND (p_inv       IS NULL OR dct_ap_pkg.in_list(p_inv,       h.invoice_status)     = 1)
           AND (p_itype     IS NULL OR dct_ap_pkg.in_list(p_itype,     h.invoice_type)       = 1)
           AND (p_curr      IS NULL OR dct_ap_pkg.in_list(p_curr,      h.invoice_currency)   = 1)
           AND (p_paygroup  IS NULL OR dct_ap_pkg.in_list(p_paygroup,  NVL(h.pay_group, '(None)')) = 1)
           AND (p_paymethod IS NULL OR dct_ap_pkg.in_list(p_paymethod, h.payment_method)     = 1)
           AND (p_search IS NULL OR
                UPPER(h.invoice_number || ' ' || h.supplier_name || ' ' ||
                      h.beneficiary_name || ' ' ||
                      h.invoice_description || ' ' || h.po_numbers)
                LIKE '%' || UPPER(p_search) || '%');

        IF p_sector IS NOT NULL THEN
            SELECT DISTINCT d.invoice_id BULK COLLECT INTO l_tmp
              FROM prod.ap_invoice_distributions_v d
             WHERE d.distribution_type = 'Item'
               AND dct_ap_pkg.in_list(p_sector, NVL(d.sector_name, 'Unclassified')) = 1;
            l_ids := l_ids MULTISET INTERSECT DISTINCT l_tmp;
        END IF;
        IF p_cc IS NOT NULL THEN
            SELECT DISTINCT d.invoice_id BULK COLLECT INTO l_tmp
              FROM prod.ap_invoice_distributions_v d
             WHERE d.distribution_type = 'Item'
               AND dct_ap_pkg.in_list(p_cc, d.cost_center_code) = 1;
            l_ids := l_ids MULTISET INTERSECT DISTINCT l_tmp;
        END IF;
        IF p_project IS NOT NULL THEN
            SELECT DISTINCT d.invoice_id BULK COLLECT INTO l_tmp
              FROM prod.ap_invoice_distributions_v d
             WHERE d.distribution_type = 'Item'
               AND dct_ap_pkg.in_list(p_project, d.project_number) = 1;
            l_ids := l_ids MULTISET INTERSECT DISTINCT l_tmp;
        END IF;
        IF p_task IS NOT NULL THEN
            SELECT DISTINCT d.invoice_id BULK COLLECT INTO l_tmp
              FROM prod.ap_invoice_distributions_v d
             WHERE d.distribution_type = 'Item'
               AND UPPER(d.task_number) = UPPER(TRIM(p_task));
            l_ids := l_ids MULTISET INTERSECT DISTINCT l_tmp;
        END IF;
        IF p_etype IS NOT NULL THEN
            SELECT DISTINCT d.invoice_id BULK COLLECT INTO l_tmp
              FROM prod.ap_invoice_distributions_v d
             WHERE d.distribution_type = 'Item'
               AND dct_ap_pkg.in_list(p_etype, d.expenditure_type) = 1;
            l_ids := l_ids MULTISET INTERSECT DISTINCT l_tmp;
        END IF;
        IF p_account IS NOT NULL THEN
            SELECT DISTINCT d.invoice_id BULK COLLECT INTO l_tmp
              FROM prod.ap_invoice_distributions_v d
             WHERE d.distribution_type = 'Item'
               AND dct_ap_pkg.in_list(p_account, d.account_code) = 1;
            l_ids := l_ids MULTISET INTERSECT DISTINCT l_tmp;
        END IF;
        IF p_approp IS NOT NULL THEN
            SELECT DISTINCT d.invoice_id BULK COLLECT INTO l_tmp
              FROM prod.ap_invoice_distributions_v d
             WHERE d.distribution_type = 'Item'
               AND dct_ap_pkg.in_list(p_approp, d.appropriation_code) = 1;
            l_ids := l_ids MULTISET INTERSECT DISTINCT l_tmp;
        END IF;
        IF p_po IS NOT NULL THEN
            SELECT DISTINCT d.invoice_id BULK COLLECT INTO l_tmp
              FROM prod.ap_invoice_distributions_v d
             WHERE d.distribution_type = 'Item'
               AND TO_CHAR(d.po_number) = TRIM(p_po);
            l_ids := l_ids MULTISET INTERSECT DISTINCT l_tmp;
        END IF;
        IF p_pr IS NOT NULL THEN
            SELECT DISTINCT d.invoice_id BULK COLLECT INTO l_tmp
              FROM prod.ap_invoice_distributions_v d
             WHERE d.distribution_type = 'Item'
               AND TO_CHAR(d.pr_number) = TRIM(p_pr);
            l_ids := l_ids MULTISET INTERSECT DISTINCT l_tmp;
        END IF;
        IF p_req IS NOT NULL THEN
            SELECT DISTINCT d.invoice_id BULK COLLECT INTO l_tmp
              FROM prod.ap_invoice_distributions_v d
             WHERE d.distribution_type = 'Item'
               AND dct_ap_pkg.in_list(p_req, d.pr_preparer) = 1;
            l_ids := l_ids MULTISET INTERSECT DISTINCT l_tmp;
        END IF;
        IF p_dept IS NOT NULL THEN
            SELECT DISTINCT ln.invoice_id BULK COLLECT INTO l_tmp
              FROM prod.ap_invoice_lines_v ln
             WHERE dct_ap_pkg.in_list(p_dept, ln.expenditure_organization) = 1;
            l_ids := l_ids MULTISET INTERSECT DISTINCT l_tmp;
        END IF;

        RETURN l_ids;
    END filtered_ids;

END dct_ap_pkg;
/

SHOW ERRORS

PROMPT === verification -- expect VALID ===
SELECT object_name, object_type, status FROM all_objects
 WHERE owner = 'PROD' AND object_name = 'DCT_AP_PKG' ORDER BY object_type;
