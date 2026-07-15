-- ===========================================================================
-- DCT PR/PO Pending Approval view (db/v2/52)
-- ---------------------------------------------------------------------------
-- PROD.DCT_PR_PO_PENDING_V -- the pending-approval companion of the GL
-- "Projects Encumbrances" line set: every distribution line of a PR / PO
-- document currently PENDING APPROVAL in Fusion (source of truth =
-- prod.atd_pr_po_pending_approval, the daily BIP snapshot loaded by the
-- 'PR PO Pending Approval' job, otbi-atd/db/47), enriched with the SAME
-- open-encumbrance detail the /gl/encumbrances endpoint exposes (project /
-- task / expenditure type via the standard fallback keys, budget date, AED
-- amounts, canonical GL combination) PLUS the approval-follow-up columns
-- from the snapshot (preparer/buyer, submitted date, pending-with approver,
-- days pending).
--
-- Three legs (UNION ALL):
--   PR  : snapshot REQUISITION docs joined to prod.pr_distributions on
--         TO_CHAR(requisition) = document_number. line_aed via the
--         DCT_CURRENCY_CODES snapshot rate (PR tables carry no rate).
--         enc_open_aed = line_aed when funds_status = 'Reserved' (the same
--         basis as the butil Open Commitment figure), else 0.
--   PO  : snapshot STANDARD docs joined to po_headers/po_distributions
--         (dedup by po_distribution_id -- ATD-loaded tables can hold
--         duplicate attribute rows). enc_open_aed = GRN-netted open amount
--         when funds_status Reserved / Partially Liquidated (the butil Open
--         Obligation basis), else 0.
--   N/A : snapshot docs with NO qualifying project line in the ATD extract
--         (extract lag / non-project documents): one row per document with
--         in_extract = 'N' and NULL budget columns, so nothing pending is
--         ever silently dropped -- consumers surface these as a coverage
--         KPI / annex instead of filtering them away.
--
-- Butil criteria parity: consumers filter (project_number, task_number,
-- expenditure_type) against DCT_BUDGET_UTILIZATION_V / DCT_BUTIL_SCOPE_V
-- exactly like /gl/encumbrances. YTD period: the view honours
-- SYS_CONTEXT('GL_CTX','BUTIL_END') on budget_date AND on the GRN netting
-- window with the SAME date bases as db/v2/37 + 39; context unset = full
-- year (consumers unaffected).
--
-- submitted_date: the snapshot stores the BIP export string (DD-MM-YYYY,
-- user decision 2026-07-16); parsed here with DEFAULT NULL ON CONVERSION
-- ERROR so a malformed export row can never break the view.
--
-- All amounts AED. Sources: base pass-through views (db/v2/32 + 36) +
-- prod.atd_pr_po_pending_approval (otbi-atd/db/47). Re-run AFTER any
-- structural ATD reload (dct_views_rebuild recompiles it). Run with the
-- prod. prefix; ADMIN synonyms are NOT needed (GL handlers use prod.*).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

PROMPT === DCT_PR_PO_PENDING_V ===
CREATE OR REPLACE VIEW prod.dct_pr_po_pending_v AS
WITH pend AS (
  SELECT CASE WHEN UPPER(document_type) LIKE '%REQ%' THEN 'PR' ELSE 'PO' END AS source,
         document_number,
         MAX(business_unit)                                   AS business_unit,
         MAX(status)                                          AS doc_status,
         MAX(preparer_buyer)                                  AS preparer_buyer,
         MAX(TO_DATE(submitted_for_approval_date DEFAULT NULL ON CONVERSION ERROR,
                     'DD-MM-YYYY'))                           AS submitted_date,
         MAX(pending_with_last_approver)                      AS pending_with,
         MAX(pending_approval_days)                           AS pending_days,
         MAX(load_ts)                                         AS load_ts
  FROM prod.atd_pr_po_pending_approval
  GROUP BY CASE WHEN UPPER(document_type) LIKE '%REQ%' THEN 'PR' ELSE 'PO' END,
           document_number
),
proj AS (
  SELECT project_id, MAX(project_number) AS project_number, MAX(project_name) AS project_name
  FROM prod.projects GROUP BY project_id
),
tsk AS (
  SELECT task_id, MAX(task_number) AS task_number FROM prod.tasks GROUP BY task_id
),
prl AS (
  SELECT pr_line_id, MAX(pr_line) AS pr_line FROM prod.pr_lines GROUP BY pr_line_id
),
prh AS (
  SELECT pr_header_id, MAX(description) AS description FROM prod.pr_headers GROUP BY pr_header_id
),
po_dist AS (
  SELECT po_distribution_id,
         prod.dct_cc_canon(MAX(charge_account))               AS charge_account,
         MAX(po_header_id)                                    AS po_header_id,
         MAX(po_line_id)                                      AS po_line_id,
         MAX(project_id)                                      AS project_id,
         MAX(task_id)                                         AS task_id,
         MAX(expenditure_type_name)                           AS expenditure_type,
         MAX(budget_date)                                     AS budget_date,
         MAX(distribution_amount * NVL(rate,1))               AS amt_aed,
         MAX(funds_status)                                    AS funds_status
  FROM prod.po_distributions
  GROUP BY po_distribution_id
),
grn_per_dist AS (
  SELECT po_distribution_id, SUM(ledger_amount) AS grn_aed
  FROM prod.grn_all_v2
  WHERE (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
         OR NVL(accounted_date, transaction_date)
            < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
  GROUP BY po_distribution_id
),
po_hdr AS (
  SELECT po_header_id, MAX(order_number) AS order_number,
         MAX(supplier_name) AS supplier_name, MAX(status) AS po_status
  FROM prod.po_headers GROUP BY po_header_id
),
po_lin AS (
  SELECT po_header_id, po_line_id, MAX(line) AS line
  FROM prod.po_lines GROUP BY po_header_id, po_line_id
)
SELECT p.source,
       p.business_unit,
       p.document_number                                      AS doc_number,
       TO_CHAR(pl.pr_line)                                    AS doc_line,
       p.doc_status,
       p.preparer_buyer,
       p.submitted_date,
       p.pending_with,
       p.pending_days,
       p.load_ts,
       h.description                                          AS descr,
       d.funds_status,
       EXTRACT(YEAR FROM d.budget_date)                       AS budget_year,
       COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id)) AS project_number,
       pj.project_name,
       COALESCE(tk.task_number,
                CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END) AS task_number,
       d.expenditure_type,
       d.budget_date,
       NVL(d.currency_code,'AED')                             AS currency,
       d.distribution_amount * NVL(cc.exchange_rate_to_aed,1) AS line_aed,
       CASE WHEN d.funds_status = 'Reserved'
            THEN d.distribution_amount * NVL(cc.exchange_rate_to_aed,1)
            ELSE 0 END                                        AS enc_open_aed,
       prod.dct_cc_canon(d.charge_account)                    AS cc_string,
       'Y'                                                    AS in_extract
FROM pend p
JOIN prod.pr_distributions d ON TO_CHAR(d.requisition) = p.document_number
LEFT JOIN prh h  ON h.pr_header_id = d.pr_header_id
LEFT JOIN prod.dct_currency_codes cc ON cc.currency_code = d.currency_code
LEFT JOIN prl pl ON pl.pr_line_id = d.pr_line_id
LEFT JOIN proj pj ON pj.project_id = d.project_id
LEFT JOIN tsk  tk ON tk.task_id    = d.task_id
WHERE p.source = 'PR'
  AND d.project_id IS NOT NULL
  AND d.charge_account IS NOT NULL
  AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
       OR d.budget_date < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
UNION ALL
SELECT p.source,
       p.business_unit,
       p.document_number,
       TO_CHAR(pl.line),
       p.doc_status,
       p.preparer_buyer,
       p.submitted_date,
       p.pending_with,
       p.pending_days,
       p.load_ts,
       h.supplier_name,
       b.funds_status,
       EXTRACT(YEAR FROM b.budget_date),
       COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(b.project_id)),
       pj.project_name,
       COALESCE(tk.task_number,
                CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END),
       b.expenditure_type,
       b.budget_date,
       'AED',
       b.amt_aed,
       CASE WHEN b.funds_status IN ('Reserved','Partially Liquidated')
            THEN GREATEST(b.amt_aed - NVL(g.grn_aed,0), 0)
            ELSE 0 END,
       b.charge_account,
       'Y'
FROM pend p
JOIN po_hdr h  ON TO_CHAR(h.order_number) = p.document_number
JOIN po_dist b ON b.po_header_id = h.po_header_id
LEFT JOIN grn_per_dist g ON g.po_distribution_id = b.po_distribution_id
LEFT JOIN po_lin pl ON pl.po_header_id = b.po_header_id AND pl.po_line_id = b.po_line_id
LEFT JOIN proj pj ON pj.project_id = b.project_id
LEFT JOIN tsk  tk ON tk.task_id    = b.task_id
WHERE p.source = 'PO'
  AND b.project_id IS NOT NULL
  AND b.charge_account IS NOT NULL
  AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
       OR b.budget_date < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
UNION ALL
SELECT p.source,
       p.business_unit,
       p.document_number,
       NULL,
       p.doc_status,
       p.preparer_buyer,
       p.submitted_date,
       p.pending_with,
       p.pending_days,
       p.load_ts,
       NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
       NULL, NULL, 0, NULL,
       'N'
FROM pend p
WHERE (p.source = 'PR' AND NOT EXISTS (
         SELECT 1 FROM prod.pr_distributions d
         WHERE TO_CHAR(d.requisition) = p.document_number
           AND d.project_id IS NOT NULL AND d.charge_account IS NOT NULL))
   OR (p.source = 'PO' AND NOT EXISTS (
         SELECT 1
         FROM po_hdr h2
         JOIN po_dist b2 ON b2.po_header_id = h2.po_header_id
         WHERE TO_CHAR(h2.order_number) = p.document_number
           AND b2.project_id IS NOT NULL AND b2.charge_account IS NOT NULL));

PROMPT === verify ===
SELECT object_name, status FROM all_objects
WHERE owner = 'PROD' AND object_name = 'DCT_PR_PO_PENDING_V';

SELECT source, in_extract, COUNT(*) AS row_cnt,
       COUNT(DISTINCT doc_number) AS doc_cnt,
       ROUND(SUM(line_aed)) AS line_aed,
       ROUND(SUM(enc_open_aed)) AS enc_open_aed
FROM prod.dct_pr_po_pending_v
GROUP BY source, in_extract
ORDER BY source, in_extract;

PROMPT ============================================================
PROMPT  52_dct_pr_po_pending.sql complete (DCT_PR_PO_PENDING_V).
PROMPT ============================================================
