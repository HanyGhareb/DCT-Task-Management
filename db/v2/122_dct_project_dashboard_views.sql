-- ===========================================================================
-- Executive Project Dashboard views (db/v2/122)
-- ---------------------------------------------------------------------------
-- Feeds the GL app Project Portfolio + Project 360 pages (final apps/GL/db/22).
-- Everything here is BUDGET-YEAR SCOPED so every money figure reconciles to
-- DCT_BUDGET_UTILIZATION_V (db/v2/37) and therefore to the Budget Utilization
-- page. All amounts AED. All views inherit GL_CTX.BUTIL_END / GL_CTX.BUTIL_OVR
-- awareness from their sources.
--
--   DCT_PROJECT_PORTFOLIO_V : butil rolled up, DIMENSIONS PRESERVED
--   DCT_PROJECT_SPEND_V     : all project spend, budgeted or not
--   DCT_PROJECT_AP_PAID_V   : derived paid, capped invoice ratio
--   DCT_PROJECT_AR_REV_V    : billed revenue, project grain
--   DCT_PROJECT_AR_LINES_V  : billed revenue, line grain
--   DCT_PROJECT_SCHEDULE_V  : planned-date facts
--   DCT_PROJECT_PENDING_V   : approval backlog rollup
--   DCT_PROJECT_HEALTH_V    : the advisory score
--
-- WHY DCT_BUDGET_UTILIZATION_V IS NOT MODIFIED
--   That view ends with HAVING on the Fusion annual budget, so a project with
--   spend and no budget line is invisible in it. It is tempting to relax the
--   HAVING. Do not. Its select list uses MAX(MAX(x)) OVER (PARTITION BY
--   budget_year, project_key) for sector, cost centre, chapter, program,
--   entity specific and the combination builder. A window function is
--   evaluated AFTER the HAVING, so admitting the currently hidden rows
--   enlarges every one of those partitions and can change the attributes of
--   rows that are already published, plus every cache and report downstream.
--   DCT_PROJECT_SPEND_V carries the unbudgeted leg separately instead.
--
-- Owned by PROD. Run in a FRESH session with the prod. prefix, never after
-- ALTER SESSION SET CURRENT_SCHEMA. Re-run after db/v2/32, 36, 37, 39, 45, 47,
-- 52 and final apps/AP/db/05. dct_views_rebuild recompiles these generically.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 122.1 DCT_PROJECT_PORTFOLIO_V ===
-- Grain: budget_year x project x the nine filterable dimensions.
-- The dimensions stay IN the grain on purpose. Rolling straight to
-- budget_year x project_number would make a sector or cost centre filter
-- change the figures of a multi sector project and break parity with the
-- Budget Utilization page. Because every filterable column survives this
-- grouping and SUM is associative, filtering this view and re aggregating by
-- project is byte identical to filtering DCT_BUDGET_UTILIZATION_V the same
-- way. Measured size: 798 rows for 2026.
-- Column names deliberately MATCH DCT_BUDGET_UTILIZATION_V so the ORDS
-- predicate block copies over verbatim.
-- Never add COUNT(DISTINCT task_number) here: a distinct count is not
-- re aggregatable by SUM across the dimension groups.
CREATE OR REPLACE VIEW prod.dct_project_portfolio_v AS
SELECT budget_year,
       project_number,
       MAX(project_name)                 AS project_name,
       project_type,
       business_unit,
       sector,
       chapter,
       department,
       cost_centre,
       appropriation,
       program,
       COUNT(*)                          AS budget_lines,
       SUM(budget_annual)                AS budget_annual,
       SUM(budget)                       AS budget,
       SUM(actual_ap)                    AS actual_ap,
       SUM(actual_grn)                   AS actual_grn,
       SUM(commitment_pr)                AS commitment_pr,
       SUM(obligation_po)                AS obligation_po,
       SUM(fund_available)               AS fund_available,
       SUM(override_budget_annual)       AS override_budget_annual,
       SUM(override_budget)              AS override_budget,
       SUM(override_lines)               AS override_lines,
       COUNT(CASE WHEN cost_centre IS NULL AND NVL(budget_annual,0) <> 0 THEN 1 END) AS missing_cc_lines,
       SUM(CASE WHEN cost_centre IS NULL AND NVL(budget_annual,0) <> 0 THEN budget_annual END) AS missing_cc_budget
FROM prod.dct_budget_utilization_v
GROUP BY budget_year, project_number, project_type, business_unit, sector,
         chapter, department, cost_centre, appropriation, program;

PROMPT === 122.2 DCT_PROJECT_SPEND_V ===
-- Every project that CONSUMED money in a budget year, whether or not it has a
-- budget line. The four fact CTEs are lifted VERBATIM from db/v2/37 (identical
-- predicates, identical date bases, identical BUTIL_END windows, identical GRN
-- netting, identical Finally Closed exclusion) with cc_string, task and
-- expenditure type dropped from the grain and the budget join and HAVING
-- omitted. Consumers derive the unbudgeted slice as
--   spend_total - (portfolio ap + grn + pr + po)
-- which is exact because both sides use the same fact text.
CREATE OR REPLACE VIEW prod.dct_project_spend_v AS
WITH
proj AS (
  SELECT project_id, project_number, MAX(project_name) AS project_name,
         MAX(project_type) AS project_type,
         MAX(business_unit_name) AS business_unit,
         MAX(appropriation) AS appropriation, MAX(appropriation_description) AS appropriation_desc
  FROM prod.projects GROUP BY project_id, project_number
),
tsk AS (
  SELECT task_id, MAX(task_number) AS task_number, MAX(task_name) AS task_name
  FROM prod.tasks GROUP BY task_id
),
tsk_seg AS (
  SELECT TO_CHAR(pj.project_number) AS project_key, t.task_number AS task_key,
         MAX(CASE WHEN t.cost_center   IS NOT NULL THEN LPAD(TO_CHAR(t.cost_center),7,'0')   END) AS cost_center_code,
         MAX(CASE WHEN t.appropriation IS NOT NULL THEN LPAD(TO_CHAR(t.appropriation),6,'0') END) AS appropriation_code,
         MAX(CASE WHEN t.program IS NOT NULL THEN LPAD(TO_CHAR(t.program),6,'0') END) AS program_code
  FROM prod.tasks t
  JOIN proj pj ON pj.project_id = t.project_id
  GROUP BY TO_CHAR(pj.project_number), t.task_number
),
proj_seg AS (
  SELECT project_key,
         MAX(cost_center_code)   AS cost_center_code,
         MAX(appropriation_code) AS appropriation_code,
         MAX(program_code)       AS program_code
  FROM tsk_seg GROUP BY project_key
),
cc_dim AS (
  SELECT cost_center_code, MAX(cost_center_desc) AS cost_center_desc,
         MAX(sector_name) AS sector_name
  FROM prod.dct_gl_coa_snap WHERE cost_center_code IS NOT NULL
  GROUP BY cost_center_code
),
sector_map AS (
  SELECT m.segment_value AS cost_center_code, MAX(v.name_en) AS sector_name
  FROM prod.dct_gl_seg_class_map m
  JOIN prod.dct_gl_class_value v ON v.class_value_id = m.class_value_id
  WHERE m.class_type_code = 'SECTOR'
    AND TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '9999-12-31')
  GROUP BY m.segment_value
),
chapter_map AS (
  SELECT m.segment_value AS appropriation_code, MAX(v.name_en) AS chapter_name
  FROM prod.dct_gl_seg_class_map m
  JOIN prod.dct_gl_class_value v ON v.class_value_id = m.class_value_id
  WHERE m.class_type_code = 'CHAPTER'
    AND TRUNC(SYSDATE) BETWEEN m.start_date AND NVL(m.end_date, DATE '9999-12-31')
  GROUP BY m.segment_value
),
approp_dim AS (
  SELECT appropriation_code, MAX(appropriation_desc) AS appropriation_desc
  FROM prod.dct_gl_coa_snap WHERE appropriation_code IS NOT NULL
  GROUP BY appropriation_code
),
program_dim AS (
  SELECT program_code, MAX(program_desc) AS program_desc
  FROM prod.dct_gl_coa_snap WHERE program_code IS NOT NULL
  GROUP BY program_code
),
po_dist AS (
  SELECT po_distribution_id,
         prod.dct_cc_canon(MAX(charge_account)) AS charge_account,
         MAX(po_header_id)                      AS po_header_id,
         MAX(project_id)                        AS project_id,
         MAX(task_id)                           AS task_id,
         MAX(expenditure_type_name)             AS expenditure_type,
         MAX(budget_date)                       AS budget_date,
         MAX(distribution_amount * NVL(rate,1)) AS amt_aed,
         MAX(funds_status)                      AS funds_status
  FROM prod.po_distributions
  GROUP BY po_distribution_id
),
po_hdr_status AS (
  SELECT po_header_id, MAX(status) AS po_status
  FROM prod.po_headers
  GROUP BY po_header_id
),
grn_per_dist AS (
  SELECT po_distribution_id,
         SUM(ledger_amount) AS grn_aed
  FROM prod.grn_all_v2
  WHERE (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
         OR NVL(accounted_date, transaction_date)
            < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
  GROUP BY po_distribution_id
),
f_ap AS (
  SELECT EXTRACT(YEAR FROM d.accounting_date) AS budget_year,
         COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id)) AS project_key,
         SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS actual_ap,
         COUNT(DISTINCT d.invoice_id) AS ap_invoice_count,
         MAX(d.accounting_date) AS last_ap_date
  FROM prod.ap_invoice_distributions d
  JOIN prod.ap_invoices i ON i.invoice_id = d.invoice_id
  JOIN prod.dct_gl_coa_snap cid ON cid.cc_id = d.cc_id
  LEFT JOIN proj pj ON pj.project_id = d.project_id
  WHERE (d.po_number IS NULL
         -- TRV rule (2026-09-02, user): a PO-matched "Tax rate variance"
         -- distribution is a REAL project cost the GRN leg never carries --
         -- the receipt is valued at PO price and the tax-rate delta exists
         -- only AP-side -- so it joins the AP actual. Other PO-matched types
         -- (Accrual / Item) stay excluded: the GRN accrual already counts
         -- them and admitting them here would double-count.
         -- Widened 2026-09-02 (user): the sibling PO-matched variance types
         -- count too, but ONLY when the distribution's charge account IS the
         -- line's expense account (the expenditure type's 6-digit prefix).
         -- Live 2026 data: IPV posts on the expense account (counts);
         -- Conversion-rate posts to 360620 FX and Retainage to 230210
         -- liability (excluded by the account test, not by name).
         OR (d.distribution_type IN ('Tax rate variance','Invoice price variance',
                                     'Conversion rate variance','Retainage')
             AND cid.account_code = REGEXP_SUBSTR(d.expenditure_type, '^[0-9]{6}')))
    AND NVL(d.reversal_indicator,'N') <> 'Y'
    AND d.project_id IS NOT NULL
    AND i.validation_status IN ('Validated','Unpaid','Available')
    AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
         OR d.accounting_date < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
  GROUP BY EXTRACT(YEAR FROM d.accounting_date),
           COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id))
),
f_grn AS (
  SELECT EXTRACT(YEAR FROM NVL(g.accounted_date, g.transaction_date)) AS budget_year,
         COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(g.project_id)) AS project_key,
         SUM(g.ledger_amount) AS actual_grn,
         COUNT(DISTINCT g.receipt_number) AS grn_receipt_count,
         MAX(NVL(g.accounted_date, g.transaction_date)) AS last_grn_date
  FROM prod.grn_all_v2 g
  JOIN po_dist pod ON pod.po_distribution_id = g.po_distribution_id
  LEFT JOIN proj pj ON pj.project_id = g.project_id
  WHERE g.project_id IS NOT NULL
    AND pod.charge_account IS NOT NULL
    AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
         OR NVL(g.accounted_date, g.transaction_date)
            < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
  GROUP BY EXTRACT(YEAR FROM NVL(g.accounted_date, g.transaction_date)),
           COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(g.project_id))
),
f_pr AS (
  SELECT EXTRACT(YEAR FROM d.budget_date) AS budget_year,
         COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id)) AS project_key,
         SUM(d.distribution_amount * NVL(cc.exchange_rate_to_aed,1)) AS open_commitment_pr,
         COUNT(DISTINCT d.requisition) AS pr_count,
         MAX(d.budget_date) AS last_pr_date
  FROM prod.pr_distributions d
  LEFT JOIN prod.dct_currency_codes cc ON cc.currency_code = d.currency_code
  LEFT JOIN proj pj ON pj.project_id = d.project_id
  WHERE d.funds_status = 'Reserved'
    AND d.project_id IS NOT NULL
    AND d.charge_account IS NOT NULL
    AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
         OR d.budget_date < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
  GROUP BY EXTRACT(YEAR FROM d.budget_date),
           COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id))
),
f_po AS (
  SELECT EXTRACT(YEAR FROM b.budget_date) AS budget_year,
         COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(b.project_id)) AS project_key,
         SUM(GREATEST(b.amt_aed - NVL(g.grn_aed,0), 0)) AS open_obligation_po,
         COUNT(DISTINCT b.po_header_id) AS po_count,
         MAX(b.budget_date) AS last_po_date
  FROM po_dist b
  LEFT JOIN grn_per_dist g ON g.po_distribution_id = b.po_distribution_id
  LEFT JOIN po_hdr_status hs ON hs.po_header_id = b.po_header_id
  LEFT JOIN proj pj ON pj.project_id = b.project_id
  WHERE b.funds_status IN ('Reserved','Partially Liquidated')
    AND NVL(hs.po_status,'x') <> 'Finally Closed'
    AND b.project_id IS NOT NULL
    AND b.charge_account IS NOT NULL
    AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
         OR b.budget_date < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
  GROUP BY EXTRACT(YEAR FROM b.budget_date),
           COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(b.project_id))
),
k AS (
  SELECT budget_year, project_key FROM f_ap
  UNION SELECT budget_year, project_key FROM f_grn
  UNION SELECT budget_year, project_key FROM f_pr
  UNION SELECT budget_year, project_key FROM f_po
)
SELECT k.budget_year,
       k.project_key                         AS project_number,
       MAX(pj.project_name)                  AS project_name,
       MAX(pj.project_type)                  AS project_type,
       MAX(pj.business_unit)                 AS business_unit,
       COALESCE(MAX(sm.sector_name), MAX(cd.sector_name))  AS sector,
       MAX(cm.chapter_name)                  AS chapter,
       MAX(cd.cost_center_desc)              AS department,
       MAX(ps.cost_center_code)              AS cost_centre,
       MAX(CASE WHEN ps.appropriation_code IS NOT NULL
                THEN ps.appropriation_code ||
                     CASE WHEN ad.appropriation_desc IS NOT NULL
                          THEN ' - ' || ad.appropriation_desc END END) AS appropriation,
       MAX(CASE WHEN ps.program_code IS NOT NULL
                THEN ps.program_code ||
                     CASE WHEN pd.program_desc IS NOT NULL
                          THEN ' - ' || pd.program_desc END END)       AS program,
       NVL(MAX(ap.actual_ap),0)              AS actual_ap,
       NVL(MAX(grn.actual_grn),0)            AS actual_grn,
       NVL(MAX(pr.open_commitment_pr),0)     AS commitment_pr,
       NVL(MAX(po.open_obligation_po),0)     AS obligation_po,
       NVL(MAX(ap.actual_ap),0) + NVL(MAX(grn.actual_grn),0)
         + NVL(MAX(pr.open_commitment_pr),0) + NVL(MAX(po.open_obligation_po),0) AS spend_total,
       NVL(MAX(ap.ap_invoice_count),0)       AS ap_invoice_count,
       NVL(MAX(grn.grn_receipt_count),0)     AS grn_receipt_count,
       NVL(MAX(pr.pr_count),0)               AS pr_count,
       NVL(MAX(po.po_count),0)               AS po_count,
       MAX(ap.last_ap_date)                  AS last_ap_date,
       MAX(grn.last_grn_date)                AS last_grn_date,
       MAX(pr.last_pr_date)                  AS last_pr_date,
       MAX(po.last_po_date)                  AS last_po_date,
       GREATEST(NVL(MAX(ap.last_ap_date),  DATE '1900-01-01'),
                NVL(MAX(grn.last_grn_date), DATE '1900-01-01'),
                NVL(MAX(pr.last_pr_date),  DATE '1900-01-01'),
                NVL(MAX(po.last_po_date),  DATE '1900-01-01'))          AS last_activity_raw
FROM k
LEFT JOIN f_ap  ap  ON ap.budget_year  = k.budget_year AND ap.project_key  = k.project_key
LEFT JOIN f_grn grn ON grn.budget_year = k.budget_year AND grn.project_key = k.project_key
LEFT JOIN f_pr  pr  ON pr.budget_year  = k.budget_year AND pr.project_key  = k.project_key
LEFT JOIN f_po  po  ON po.budget_year  = k.budget_year AND po.project_key  = k.project_key
LEFT JOIN proj pj ON TO_CHAR(pj.project_number) = k.project_key
LEFT JOIN proj_seg ps ON ps.project_key = k.project_key
LEFT JOIN cc_dim cd ON cd.cost_center_code = ps.cost_center_code
LEFT JOIN sector_map sm ON sm.cost_center_code = ps.cost_center_code
LEFT JOIN chapter_map cm ON cm.appropriation_code = ps.appropriation_code
LEFT JOIN approp_dim ad ON ad.appropriation_code = ps.appropriation_code
LEFT JOIN program_dim pd ON pd.program_code = ps.program_code
WHERE k.project_key NOT LIKE '#%'
GROUP BY k.budget_year, k.project_key;

PROMPT === 122 part 1 done ===

PROMPT === 122.3 DCT_PROJECT_AP_PAID_V ===
-- Derived paid, because ATD_PAYMENTS is check grain and carries NO invoice id
-- and no project, so payments cannot be joined to a project at all.
-- The ratio is entered currency over entered currency and is applied to the
-- AED distribution amount: that is what makes it currency safe. Never multiply
-- an entered currency paid amount by anything and call the result AED.
-- The LEAST cap is REQUIRED: 20 live invoices carry paid above the invoice
-- amount, and without the cap a project shows Paid greater than Invoiced.
-- Two legs on purpose:
--   ap_direct_aed  = the butil ACTUAL_AP definition, ties to the budget page
--   ap_invoiced_aed = ALL non tax project distributions, the real AP exposure
CREATE OR REPLACE VIEW prod.dct_project_ap_paid_v AS
WITH proj AS (
  SELECT project_id, project_number FROM prod.projects GROUP BY project_id, project_number
),
d AS (
  SELECT EXTRACT(YEAR FROM d.accounting_date) AS budget_year,
         TO_CHAR(pj.project_number)           AS project_number,
         d.invoice_id,
         NVL(d.distribution_amount_functi, d.distribution_amount) AS amt_aed,
         CASE WHEN d.po_number IS NULL
               AND i.validation_status IN ('Validated','Unpaid','Available')
              THEN NVL(d.distribution_amount_functi, d.distribution_amount) END AS direct_aed,
         CASE WHEN NVL(i.invoice_amount,0) = 0 THEN 0
              ELSE LEAST(NVL(i.invoice_amount_paid,0) / i.invoice_amount, 1) END AS paid_ratio,
         CASE WHEN NVL(i.invoice_amount,0) = 0 THEN 'Unpaid'
              WHEN ABS(NVL(i.invoice_amount_paid,0)) >= ABS(NVL(i.invoice_amount,0)) - 0.005 THEN 'Paid'
              WHEN NVL(i.invoice_amount_paid,0) <> 0 THEN 'Partially Paid'
              ELSE 'Unpaid' END                       AS payment_status
  FROM prod.ap_invoice_distributions d
  JOIN prod.ap_invoices i ON i.invoice_id = d.invoice_id
  JOIN proj pj ON pj.project_id = d.project_id
  WHERE d.project_id IS NOT NULL
    AND NVL(d.reversal_indicator,'N') <> 'Y'
    AND i.cancelled_date IS NULL
    AND NVL(i.validation_status,'x') <> 'Canceled'
    AND d.distribution_type NOT IN ('Recoverable tax','Nonrecoverable tax')
    AND (SYS_CONTEXT('GL_CTX','BUTIL_END') IS NULL
         OR d.accounting_date < TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD') + 1)
)
SELECT budget_year,
       project_number,
       COUNT(DISTINCT invoice_id)                          AS ap_invoice_count,
       ROUND(SUM(amt_aed),2)                               AS ap_invoiced_aed,
       ROUND(SUM(amt_aed * paid_ratio),2)                  AS ap_paid_aed,
       ROUND(SUM(amt_aed) - SUM(amt_aed * paid_ratio),2)   AS ap_balance_aed,
       ROUND(NVL(SUM(direct_aed),0),2)                     AS ap_direct_aed,
       ROUND(NVL(SUM(direct_aed * paid_ratio),0),2)        AS ap_direct_paid_aed,
       COUNT(DISTINCT CASE WHEN payment_status = 'Paid' THEN invoice_id END)            AS paid_invoice_count,
       COUNT(DISTINCT CASE WHEN payment_status = 'Partially Paid' THEN invoice_id END)  AS part_paid_invoice_count,
       COUNT(DISTINCT CASE WHEN NVL(payment_status,'Unpaid') NOT IN ('Paid','Partially Paid')
                           THEN invoice_id END)                                         AS unpaid_invoice_count
FROM d
WHERE project_number NOT LIKE '#%'
GROUP BY budget_year, project_number;

PROMPT === 122.4 DCT_PROJECT_AR_LINES_V ===
-- Billed revenue, line grain. Two traps handled:
--  1 the join key: atd_ar_invoice_lines.PROJECT is typed NUMBER but is the
--    project NUMBER (the extract sources RA_CUSTOMER_TRX_LINES_PROJECT_NUMBER_v).
--    All 988 project bearing lines resolve cleanly against the master.
--  2 the amount: line amounts are ENTERED currency, only the header carries the
--    AED ledger figure, so each line takes its share of the header accounted
--    amount by ratio. A plain SUM of line_amount would mix currencies.
-- Coverage is small and that is the data, not a defect: 988 of 123,572 lines
-- carry a project, covering 51 projects.
CREATE OR REPLACE VIEW prod.dct_project_ar_lines_v AS
SELECT EXTRACT(YEAR FROM h.transaction_date)      AS budget_year,
       TO_CHAR(l.project)                         AS project_number,
       p.project_name,
       l.task                                     AS task_raw,
       h.transaction_id,
       h.transaction_number,
       h.transaction_source,
       h.transaction_type_name,
       h.transaction_date,
       h.due_date,
       h.status,
       h.transaction_complete,
       h.bill_to_customer_number,
       h.bill_to_customer_name,
       h.business_unit_name,
       h.receipt_method,
       l.transaction_line_number,
       l.transaction_line_type,
       l.transaction_line_descripti                AS line_description,
       l.memo_line_name,
       l.line_amount,
       CASE WHEN NVL(h.transaction_accounted_amou,0) <> 0
             AND NVL(SUM(l.line_amount) OVER (PARTITION BY l.transaction_id),0) <> 0
            THEN ROUND(h.transaction_accounted_amou * l.line_amount
                 / SUM(l.line_amount) OVER (PARTITION BY l.transaction_id), 2)
            ELSE l.line_amount END                AS line_amount_aed,
       CASE WHEN NVL(h.transaction_accounted_amou,0) <> 0
             AND NVL(SUM(l.line_amount) OVER (PARTITION BY l.transaction_id),0) <> 0
            THEN 'ACCOUNTED' ELSE 'ENTERED' END   AS fx_basis
FROM prod.atd_ar_invoice_lines l
JOIN prod.atd_ar_invoice_header_details h ON h.transaction_id = l.transaction_id
JOIN (SELECT project_number, MAX(project_name) AS project_name
        FROM prod.projects GROUP BY project_number) p
  ON p.project_number = TO_CHAR(l.project)
WHERE l.project IS NOT NULL;

PROMPT === 122.5 DCT_PROJECT_AR_REV_V ===
CREATE OR REPLACE VIEW prod.dct_project_ar_rev_v AS
SELECT budget_year,
       project_number,
       MAX(project_name)                             AS project_name,
       COUNT(DISTINCT transaction_id)                AS transaction_count,
       COUNT(*)                                      AS line_count,
       ROUND(SUM(line_amount_aed),2)                 AS billed_revenue_aed,
       ROUND(SUM(line_amount),2)                     AS billed_revenue_entered,
       COUNT(DISTINCT bill_to_customer_number)       AS customer_count,
       MIN(transaction_date)                         AS first_transaction_date,
       MAX(transaction_date)                         AS last_transaction_date,
       SUM(CASE WHEN fx_basis = 'ENTERED' THEN 1 ELSE 0 END) AS fx_entered_lines
FROM prod.dct_project_ar_lines_v
GROUP BY budget_year, project_number;

PROMPT === 122.6 DCT_PROJECT_SCHEDULE_V ===
-- Planned date facts ONLY.
-- ATD_TASKS.ACTUAL_START_DATE and ACTUAL_FINISH_DATE are entirely empty in the
-- source: 0 of 6,059 rows. Slippage (actual finish vs planned finish) is
-- therefore NOT computable, and "task not finished" is true of every task in
-- the system regardless of reality. This view exposes only what the data
-- supports, and tasks_no_actual_dates is emitted so consumers can say so.
-- Do NOT score project health on these columns until actual dates load.
CREATE OR REPLACE VIEW prod.dct_project_schedule_v AS
SELECT TO_CHAR(pj.project_number)                    AS project_number,
       MAX(pj.project_name)                          AS project_name,
       MAX(pj.project_status)                        AS project_status,
       MAX(pj.project_manager)                       AS project_manager,
       MAX(pj.project_start_date)                    AS project_start_date,
       MAX(pj.project_finish_date)                   AS project_finish_date,
       MAX(pj.project_closed_date)                   AS project_closed_date,
       COUNT(t.task_id)                              AS task_count,
       COUNT(CASE WHEN UPPER(NVL(t.chargeable_task,'N')) IN ('Y','YES','TRUE') THEN 1 END) AS chargeable_task_count,
       COUNT(t.planned_start_date)                   AS tasks_with_planned_start,
       COUNT(t.planned_finish_date)                  AS tasks_with_planned_finish,
       COUNT(t.actual_start_date)                    AS tasks_with_actual_start,
       COUNT(t.actual_finish_date)                   AS tasks_with_actual_finish,
       COUNT(CASE WHEN t.planned_finish_date IS NULL THEN 1 END) AS tasks_no_plan,
       COUNT(CASE WHEN t.actual_start_date IS NULL AND t.actual_finish_date IS NULL THEN 1 END) AS tasks_no_actual_dates,
       COUNT(CASE WHEN t.planned_finish_date < TRUNC(SYSDATE) THEN 1 END) AS tasks_planned_finish_past,
       MIN(t.planned_start_date)                     AS planned_start_min,
       MAX(t.planned_finish_date)                    AS planned_finish_max,
       CASE WHEN MAX(pj.project_finish_date) < TRUNC(SYSDATE)
             AND MAX(pj.project_closed_date) IS NULL
            THEN TRUNC(SYSDATE) - MAX(pj.project_finish_date) END AS project_overdue_days,
       CASE WHEN MAX(pj.project_finish_date) > MAX(pj.project_start_date)
            THEN LEAST(100, GREATEST(0, ROUND((TRUNC(SYSDATE) - MAX(pj.project_start_date)) * 100
                 / NULLIF(MAX(pj.project_finish_date) - MAX(pj.project_start_date),0), 1))) END AS schedule_elapsed_pct
FROM prod.projects pj
LEFT JOIN prod.tasks t ON t.project_id = pj.project_id
GROUP BY TO_CHAR(pj.project_number);

PROMPT === 122.7 DCT_PROJECT_PENDING_V ===
CREATE OR REPLACE VIEW prod.dct_project_pending_v AS
SELECT budget_year,
       project_number,
       COUNT(DISTINCT doc_number)                                              AS pending_docs,
       COUNT(DISTINCT CASE WHEN source = 'PR' THEN doc_number END)             AS pending_pr_docs,
       COUNT(DISTINCT CASE WHEN source = 'PO' THEN doc_number END)             AS pending_po_docs,
       ROUND(SUM(NVL(line_aed,0)),2)                                           AS pending_aed,
       ROUND(SUM(NVL(enc_open_aed,0)),2)                                       AS pending_open_aed,
       MAX(pending_days)                                                       AS max_pending_days,
       ROUND(AVG(pending_days),1)                                              AS avg_pending_days,
       COUNT(DISTINCT CASE WHEN pending_days > 30 THEN doc_number END)         AS docs_over_30d,
       COUNT(DISTINCT CASE WHEN pending_days > 60 THEN doc_number END)         AS docs_over_60d,
       ROUND(SUM(CASE WHEN pending_days > 30 THEN NVL(line_aed,0) ELSE 0 END),2) AS pending_over_30_aed,
       MIN(submitted_date)                                                     AS oldest_submitted_date
FROM prod.dct_pr_po_pending_v
WHERE project_number IS NOT NULL
  AND project_number NOT LIKE '#%'
  AND ABS(NVL(line_aed,0)) > 0.005
GROUP BY budget_year, project_number;

PROMPT === 122 part 2 done ===

PROMPT === 122.8 DCT_PROJECT_HEALTH_V ===
-- ADVISORY ONLY. No workflow, approval or budget decision may key off this
-- score. Every component score AND every raw input is exposed so the weighting
-- is auditable and a reviewer can see WHY a project is flagged.
--
-- FOUR components, not five. A schedule component was designed and then
-- DROPPED: ATD_TASKS.ACTUAL_START_DATE and ACTUAL_FINISH_DATE are entirely
-- empty in the source (0 of 6,059 rows), so slippage is not computable and
-- "task not finished" is true of every task in the system. Scoring on
-- uniformly missing data would manufacture a portfolio wide red flag out of a
-- loading gap. Planned finish dates ARE fully populated and are surfaced as an
-- informational flag only. Reinstate a scored schedule component when actual
-- dates load.
--
-- Weights: burn 40, funds 20, approvals 20, activity 20. A component that
-- cannot be scored is NULL and its weight is renormalised away, so a project
-- is never punished for data it does not have.
CREATE OR REPLACE VIEW prod.dct_project_health_v AS
WITH pf AS (
  SELECT budget_year, project_number,
         SUM(budget_annual)  AS budget_annual,
         SUM(budget)         AS budget_ytd,
         SUM(actual_ap)      AS actual_ap,
         SUM(actual_grn)     AS actual_grn,
         SUM(commitment_pr)  AS commitment_pr,
         SUM(obligation_po)  AS obligation_po,
         SUM(fund_available) AS fund_available
    FROM prod.dct_project_portfolio_v
   GROUP BY budget_year, project_number
),
yr AS (
  SELECT budget_year,
         LEAST(100, GREATEST(0, ROUND(
           (NVL(TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD'), TRUNC(SYSDATE))
            - TO_DATE('01-01-'||TO_CHAR(budget_year),'DD-MM-YYYY') + 1) * 100
           / (TO_DATE('31-12-'||TO_CHAR(budget_year),'DD-MM-YYYY')
              - TO_DATE('01-01-'||TO_CHAR(budget_year),'DD-MM-YYYY') + 1), 1))) AS elapsed_pct
    FROM (SELECT DISTINCT budget_year FROM prod.dct_project_portfolio_v
          UNION SELECT DISTINCT budget_year FROM prod.dct_project_spend_v)
),
base AS (
  SELECT COALESCE(pf.budget_year, sp.budget_year)       AS budget_year,
         COALESCE(pf.project_number, sp.project_number) AS project_number,
         NVL(pf.budget_annual,0)  AS budget_annual,
         NVL(pf.budget_ytd,0)     AS budget_ytd,
         NVL(pf.actual_ap,0) + NVL(pf.actual_grn,0)         AS actual,
         NVL(pf.commitment_pr,0) + NVL(pf.obligation_po,0)  AS committed,
         pf.fund_available,
         CASE WHEN pf.project_number IS NULL THEN 'N' ELSE 'Y' END AS has_budget,
         NVL(sp.spend_total,0)    AS spend_total,
         CASE WHEN sp.last_activity_raw > DATE '1900-01-01' THEN sp.last_activity_raw END AS last_activity_date,
         NVL(pn.pending_docs,0)   AS pending_docs,
         NVL(pn.docs_over_30d,0)  AS docs_over_30d,
         NVL(pn.max_pending_days,0) AS max_pending_days,
         NVL(pn.pending_aed,0)    AS pending_aed
    FROM pf
    FULL OUTER JOIN prod.dct_project_spend_v sp
      ON sp.budget_year = pf.budget_year AND sp.project_number = pf.project_number
    LEFT JOIN prod.dct_project_pending_v pn
      ON pn.budget_year = COALESCE(pf.budget_year, sp.budget_year)
     AND pn.project_number = COALESCE(pf.project_number, sp.project_number)
),
calc AS (
  SELECT b.*,
         y.elapsed_pct,
         CASE WHEN b.budget_annual <> 0
              THEN ROUND((b.actual + b.committed) * 100 / b.budget_annual, 1) END AS utilization_pct,
         CASE WHEN b.budget_annual <> 0
              THEN ROUND(b.fund_available * 100 / b.budget_annual, 1) END        AS fund_available_pct,
         CASE WHEN b.last_activity_date IS NOT NULL
              THEN TRUNC(NVL(TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END'),'YYYY-MM-DD'), SYSDATE))
                   - TRUNC(b.last_activity_date) END                             AS days_since_activity
    FROM base b JOIN yr y ON y.budget_year = b.budget_year
),
sc AS (
  SELECT c.*,
         CASE WHEN c.budget_annual <> 0
              THEN GREATEST(0, 100 - LEAST(ABS(c.utilization_pct - c.elapsed_pct), 100)) END AS score_burn,
         CASE WHEN c.budget_annual <> 0 THEN
                CASE WHEN c.fund_available < 0 THEN 0
                     WHEN c.fund_available_pct < 5 THEN 40
                     ELSE LEAST(100, 40 + c.fund_available_pct * 3) END END                  AS score_funds,
         CASE WHEN c.pending_docs = 0 THEN 100
              ELSE GREATEST(0, 100 - LEAST(c.max_pending_days, 60)
                                   - LEAST(c.pending_docs, 10) * 2) END                      AS score_approval,
         CASE WHEN c.days_since_activity IS NULL THEN NULL
              WHEN c.days_since_activity <= 30  THEN 100
              WHEN c.days_since_activity <= 60  THEN 80
              WHEN c.days_since_activity <= 90  THEN 60
              WHEN c.days_since_activity <= 180 THEN 30
              ELSE 0 END                                                                     AS score_activity
    FROM calc c
),
w AS (
  SELECT s.*,
         (CASE WHEN score_burn     IS NULL THEN 0 ELSE 40 END
        + CASE WHEN score_funds    IS NULL THEN 0 ELSE 20 END
        + CASE WHEN score_approval IS NULL THEN 0 ELSE 20 END
        + CASE WHEN score_activity IS NULL THEN 0 ELSE 20 END)                AS wsum,
         (NVL(score_burn,0)*40 + NVL(score_funds,0)*20
        + NVL(score_approval,0)*20 + NVL(score_activity,0)*20)                AS wnum,
         (CASE WHEN score_burn IS NULL THEN 0 ELSE 1 END
        + CASE WHEN score_funds IS NULL THEN 0 ELSE 1 END
        + CASE WHEN score_approval IS NULL THEN 0 ELSE 1 END
        + CASE WHEN score_activity IS NULL THEN 0 ELSE 1 END)                 AS scored_components
    FROM sc s
)
SELECT budget_year, project_number, has_budget,
       budget_annual, budget_ytd, actual, committed, fund_available, spend_total,
       elapsed_pct, utilization_pct, fund_available_pct,
       last_activity_date, days_since_activity,
       pending_docs, docs_over_30d, max_pending_days, pending_aed,
       score_burn, score_funds, score_approval, score_activity, scored_components,
       CASE WHEN wsum > 0 THEN ROUND(wnum / wsum) END                          AS health_score,
       -- hard flags, emitted separately so the UI can say WHY
       CASE WHEN fund_available < 0 THEN 'Y' ELSE 'N' END                      AS flag_over_budget,
       CASE WHEN has_budget = 'N' AND spend_total <> 0 THEN 'Y' ELSE 'N' END   AS flag_no_budget,
       CASE WHEN days_since_activity > 90 AND budget_ytd > 0
                 AND NVL(utilization_pct,0) < 90 THEN 'Y' ELSE 'N' END         AS flag_stalled,
       CASE WHEN docs_over_30d > 0 THEN 'Y' ELSE 'N' END                       AS flag_pending_backlog,
       CASE WHEN budget_ytd > 0 AND actual = 0 THEN 'Y' ELSE 'N' END           AS flag_no_spend,
       CASE WHEN has_budget = 'N' AND spend_total <> 0 THEN 'GREY'
            WHEN fund_available < 0 THEN 'RED'
            WHEN wsum = 0 THEN 'GREY'
            WHEN ROUND(wnum / wsum) >= 75 THEN 'GREEN'
            WHEN ROUND(wnum / wsum) >= 50 THEN 'AMBER'
            ELSE 'RED' END                                                     AS health_band
FROM w;

PROMPT === 122 part 3 done ===

PROMPT === 122.9 grants to ADMIN ===
-- ORDS handlers execute as ADMIN and reference these with the prod. prefix, so
-- a SELECT grant is all that is needed. Deliberately NO synonyms here: this
-- script stays re-runnable under PROD, and a CREATE SYNONYM in a session that
-- has set CURRENT_SCHEMA to PROD self references (ORA-01471).
DECLARE
    TYPE t_names IS TABLE OF VARCHAR2(60);
    l_v t_names := t_names('DCT_PROJECT_PORTFOLIO_V','DCT_PROJECT_SPEND_V',
                           'DCT_PROJECT_AP_PAID_V','DCT_PROJECT_AR_LINES_V',
                           'DCT_PROJECT_AR_REV_V','DCT_PROJECT_SCHEDULE_V',
                           'DCT_PROJECT_PENDING_V','DCT_PROJECT_HEALTH_V');
BEGIN
    FOR i IN 1 .. l_v.COUNT LOOP
        BEGIN
            EXECUTE IMMEDIATE 'GRANT SELECT ON prod.' || l_v(i) || ' TO admin';
        EXCEPTION
            -- ORA-01749 when this script is run FROM the ADMIN connection
            -- (prod_mcp): a user cannot grant to itself, and on ADB ADMIN can
            -- already read PROD objects, so the grant is simply not needed.
            -- It IS needed when the script is run as PROD. Tolerate both.
            WHEN OTHERS THEN
                IF SQLCODE != -1749 THEN RAISE; END IF;
        END;
    END LOOP;
END;
/

PROMPT === 122 verification ===
SELECT object_name, status FROM all_objects
 WHERE owner = 'PROD' AND object_name LIKE 'DCT_PROJECT%_V'
 ORDER BY object_name;

PROMPT === 122 done ===
