-- ===========================================================================
-- Projects end-user summary view (db/v2/47; first shipped as 44, renumbered
-- after a parallel-session number clash with 44_drop_ap_invoice_header)
-- ---------------------------------------------------------------------------
-- PROJECTS_V : one row per PROJECT (business key = PROJECT_NUMBER), built for
-- end users - every internal surrogate id (project_id, task_id, po_header_id,
-- invoice_id, cc_id ...) is resolved away; only business numbers, names and
-- statistics are exposed. Whole-life figures (all budget years combined).
--
-- Master attributes (prod.projects pass-through): number, name, type, status,
-- manager, business/project unit, budget group, appropriation (+ chapter via
-- the defined CHAPTER mapping), liability type, lifecycle dates.
--
-- Classification lists come from the project's tasks: distinct cost centres,
-- departments (COA cost-centre description), sectors (defined SECTOR mapping
-- first, then COA), programs (task PROGRAM + COA description).
--
-- Statistics (rules identical to the actuals / butil layer, db/v2/32..40):
--   Tasks / Etypes  : task count; distinct expenditure types across budget
--                     lines and all transaction sources.
--   Budget          : total budget (prod.projects_budget, all years) + the
--                     list of budgeted years.
--   PR              : count / AED amount of requisition distributions with
--                     funds status Reserved or Liquidated (the "real" PRs);
--                     OPEN COMMITMENT = Reserved only. AED via the
--                     DCT_CURRENCY_CODES snapshot rate (PR has no rate).
--   PO              : count / AED amount of PO distributions excluding funds
--                     status Failed / Passed (the not-reserved pipeline);
--                     OPEN OBLIGATION = Reserved / Partially Liquidated,
--                     GRN-netted per po_distribution_id, headers with STATUS
--                     'Finally Closed' excluded (final close releases the
--                     un-received remainder). PO AED = distribution_amount x
--                     NVL(rate,1).
--   GRN             : distinct receipt count, receipt-line count, received
--                     AED = SUM(ledger_amount) (already AED - never x rate),
--                     plus received-vs-AP progression per PO distribution:
--                     invoiced AED, paid AED (invoice paid ratio apportioned)
--                     and the still-uninvoiced balance.
--   AP              : distinct invoice count (cancelled excluded) split by
--                     payment status, invoiced AED (non-reversed project
--                     distributions, PO-matched AND direct), paid AED
--                     (header invoice_amount_paid apportioned to the
--                     project's share by ratio, capped at 100% per invoice -
--                     a few Fusion invoices carry paid above the invoice
--                     amount), balance due AED (can be NEGATIVE when an
--                     unapplied credit memo leaves net invoiced below cash
--                     already paid), and
--                     AP DIRECT AED (the no-PO validated subset - the same
--                     definition as the butil Actual AP figure).
--   Funds summary   : fund available = budget - AP direct - GRN - open PR -
--                     open PO (the butil formula, whole-life); utilization %.
--   Activity        : last PR / PO / receipt / invoice dates + overall last
--                     activity date.
--   Document lists  : the OPEN-item document numbers behind four figures
--                     (comma-separated, LISTAGG DISTINCT, truncated with
--                     ,... when very long): BALANCE_DUE_INVOICE_NUMBERS =
--                     not-fully-paid invoices; OPEN_PR_NUMBERS = requisitions
--                     with Reserved distributions; OPEN_PO_NUMBERS = POs with
--                     a GRN-netted open balance (Finally Closed excluded);
--                     UNINVOICED_GRN_NUMBERS = receipts on PO distributions
--                     whose received AED exceeds the AP invoiced AED.
--
-- NOTE - reconciliation: figures here are whole-life per project while
-- DCT_BUDGET_UTILIZATION_V is budget-year x task x etype scoped to budgeted
-- combinations (budget > 0), so a per-year comparison must go through that
-- view. Dates are Fusion business dates (loaded, not SYSDATE-written) -
-- exposed as-is, no dct_to_local conversion (db/v2/43 convention).
--
-- Sources: base pass-through views only (projects, tasks, projects_budget,
-- po_headers/po_lines/po_distributions, pr_distributions, grn_all_v2,
-- ap_invoices, ap_invoice_distributions, dct_gl_coa_snap + the class maps).
-- Owned by PROD; run with the prod. prefix, no ALTER SESSION. Re-run AFTER
-- db/v2/32 + 36 whenever the pass-through views are rebuilt
-- (dct_views_rebuild recompiles it automatically).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

PROMPT === PROJECTS_V ===
CREATE OR REPLACE VIEW prod.projects_v AS
WITH
pj AS (
  SELECT project_id,
         MAX(project_number)            AS project_number,
         MAX(project_name)              AS project_name,
         MAX(project_type)              AS project_type,
         MAX(project_status)            AS project_status,
         MAX(project_manager)           AS project_manager,
         MAX(business_unit_name)        AS business_unit,
         MAX(project_unit_name)         AS project_unit,
         MAX(budget_group_description)  AS budget_group,
         MAX(liability_project_type)    AS liability_project_type,
         MAX(appropriation)             AS appropriation_code,
         MAX(appropriation_description) AS appropriation_desc,
         MAX(project_start_date)        AS project_start_date,
         MAX(project_finish_date)       AS project_finish_date,
         MAX(project_closed_date)       AS project_closed_date,
         MAX(project_creation_date)     AS project_creation_date
  FROM prod.projects
  GROUP BY project_id
),
task_agg AS (
  SELECT project_id, COUNT(DISTINCT task_id) AS task_count
  FROM prod.tasks
  WHERE project_id IS NOT NULL
  GROUP BY project_id
),
-- distinct task-level classification codes per project ----------------------
tsk_dim AS (
  SELECT DISTINCT project_id,
         CASE WHEN cost_center IS NOT NULL THEN LPAD(TO_CHAR(cost_center),7,'0') END AS cost_center_code,
         CASE WHEN program IS NOT NULL THEN LPAD(TO_CHAR(program),6,'0') END AS program_code
  FROM prod.tasks
  WHERE project_id IS NOT NULL
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
program_dim AS (
  SELECT program_code, MAX(program_desc) AS program_desc
  FROM prod.dct_gl_coa_snap WHERE program_code IS NOT NULL
  GROUP BY program_code
),
attr_agg AS (
  SELECT x.project_id,
         LISTAGG(DISTINCT x.sector_name, ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY x.sector_name)      AS sectors,
         LISTAGG(DISTINCT x.department, ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY x.department)       AS departments,
         LISTAGG(DISTINCT x.cost_center_code, ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY x.cost_center_code) AS cost_centres,
         LISTAGG(DISTINCT x.program, ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY x.program)          AS programs
  FROM (
    SELECT t.project_id,
           t.cost_center_code,
           COALESCE(sm.sector_name, cd.sector_name) AS sector_name,
           cd.cost_center_desc                      AS department,
           CASE WHEN t.program_code IS NOT NULL THEN
             t.program_code ||
             CASE WHEN pd.program_desc IS NOT NULL THEN ' - ' || pd.program_desc END
           END AS program
    FROM tsk_dim t
    LEFT JOIN cc_dim      cd ON cd.cost_center_code = t.cost_center_code
    LEFT JOIN sector_map  sm ON sm.cost_center_code = t.cost_center_code
    LEFT JOIN program_dim pd ON pd.program_code     = t.program_code
  ) x
  GROUP BY x.project_id
),
bud_agg AS (
  SELECT project_id,
         SUM(budget) AS budget_aed,
         LISTAGG(DISTINCT TO_CHAR(budget_year), ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY TO_CHAR(budget_year)) AS budget_years
  FROM prod.projects_budget
  GROUP BY project_id
),
-- distinct expenditure types across budget + every transaction source -------
etype_u AS (
  SELECT project_id, expenditure_type FROM prod.projects_budget
  WHERE expenditure_type IS NOT NULL
  UNION
  SELECT project_id, expenditure_type_name FROM prod.po_distributions
  WHERE project_id IS NOT NULL AND expenditure_type_name IS NOT NULL
  UNION
  SELECT project_id, expenditure_type FROM prod.pr_distributions
  WHERE project_id IS NOT NULL AND expenditure_type IS NOT NULL
  UNION
  SELECT project_id, expenditure_type FROM prod.grn_all_v2
  WHERE project_id IS NOT NULL AND expenditure_type IS NOT NULL
  UNION
  SELECT project_id, expenditure_type FROM prod.ap_invoice_distributions
  WHERE project_id IS NOT NULL AND expenditure_type IS NOT NULL
),
etype_agg AS (
  SELECT project_id, COUNT(DISTINCT expenditure_type) AS expenditure_type_count
  FROM etype_u
  GROUP BY project_id
),
-- PO facts (dedup per distribution; charge_account not needed here) ---------
po_dist AS (
  SELECT po_distribution_id,
         MAX(po_header_id)                      AS po_header_id,
         MAX(project_id)                        AS project_id,
         MAX(budget_date)                       AS budget_date,
         MAX(distribution_amount * NVL(rate,1)) AS amt_aed,
         MAX(funds_status)                      AS funds_status
  FROM prod.po_distributions
  WHERE project_id IS NOT NULL
  GROUP BY po_distribution_id
),
po_hdr_status AS (
  SELECT po_header_id, MAX(status) AS po_status
  FROM prod.po_headers
  GROUP BY po_header_id
),
grn_recv AS (
  SELECT po_distribution_id, SUM(ledger_amount) AS received_aed
  FROM prod.grn_all_v2
  GROUP BY po_distribution_id
),
-- invoice headers, deduped, with payment ratio and status --------------------
ap_inv AS (
  SELECT invoice_id,
         MAX(invoice_number)             AS invoice_number,
         MAX(validation_status)          AS validation_status,
         MAX(cancelled_date)             AS cancelled_date,
         -- ratio capped at 1: a few Fusion invoices carry amount_paid above the
         -- invoice amount and would otherwise show project Paid > Invoiced
         CASE WHEN NVL(MAX(invoice_amount),0) = 0 THEN 0
              ELSE LEAST(MAX(NVL(invoice_amount_paid,0)) / MAX(invoice_amount), 1) END AS paid_ratio,
         CASE WHEN NVL(MAX(invoice_amount),0) = 0 THEN 'Unpaid'
              WHEN ABS(MAX(NVL(invoice_amount_paid,0))) >= ABS(MAX(invoice_amount)) - 0.005 THEN 'Paid'
              WHEN MAX(NVL(invoice_amount_paid,0)) <> 0 THEN 'Partially Paid'
              ELSE 'Unpaid' END          AS payment_status
  FROM prod.ap_invoices
  GROUP BY invoice_id
),
-- AP matched to PO distributions (order / line / distribution number keys) --
pod_key AS (
  SELECT ph.order_number AS po_number, pl.line AS po_line,
         pod.distribution_number AS po_dist_line,
         MAX(pod.po_distribution_id) AS po_distribution_id
  FROM prod.po_distributions pod
  JOIN prod.po_lines   pl ON pl.po_header_id = pod.po_header_id AND pl.po_line_id = pod.po_line_id
  JOIN prod.po_headers ph ON ph.po_header_id = pod.po_header_id
  GROUP BY ph.order_number, pl.line, pod.distribution_number
),
ap_per_dist AS (
  SELECT pk.po_distribution_id,
         SUM(NVL(d.distribution_amount_functi, d.distribution_amount))                AS invoiced_aed,
         SUM(NVL(d.distribution_amount_functi, d.distribution_amount) * i.paid_ratio) AS paid_aed
  FROM prod.ap_invoice_distributions d
  JOIN ap_inv i   ON i.invoice_id = d.invoice_id
  JOIN pod_key pk ON pk.po_number    = d.po_number
                 AND pk.po_line      = d.po_line
                 AND pk.po_dist_line = d.po_distribution_line
  WHERE NVL(d.reversal_indicator,'N') <> 'Y'
    AND i.cancelled_date IS NULL
    AND NVL(i.validation_status,'x') <> 'Canceled'
  GROUP BY pk.po_distribution_id
),
po_agg AS (
  SELECT b.project_id,
         COUNT(DISTINCT CASE WHEN NVL(b.funds_status,'~') NOT IN ('Failed','Passed')
                             THEN b.po_header_id END)                     AS po_count,
         SUM(CASE WHEN NVL(b.funds_status,'~') NOT IN ('Failed','Passed')
                  THEN b.amt_aed ELSE 0 END)                              AS po_amount_aed,
         SUM(CASE WHEN b.funds_status IN ('Reserved','Partially Liquidated')
                   AND NVL(hs.po_status,'x') <> 'Finally Closed'
                  THEN GREATEST(b.amt_aed - NVL(g.received_aed,0), 0)
                  ELSE 0 END)                                             AS open_obligation_aed,
         MAX(b.budget_date)                                               AS last_po_date
  FROM po_dist b
  LEFT JOIN grn_recv g       ON g.po_distribution_id = b.po_distribution_id
  LEFT JOIN po_hdr_status hs ON hs.po_header_id      = b.po_header_id
  GROUP BY b.project_id
),
grn_agg AS (
  SELECT project_id,
         COUNT(DISTINCT receipt_number)                 AS grn_receipt_count,
         COUNT(*)                                       AS grn_line_count,
         SUM(ledger_amount)                             AS grn_amount_aed,
         MAX(NVL(accounted_date, transaction_date))     AS last_receipt_date
  FROM prod.grn_all_v2
  WHERE project_id IS NOT NULL
  GROUP BY project_id
),
-- received-vs-invoiced-vs-paid progression per PO distribution --------------
grn_match AS (
  SELECT b.project_id,
         SUM(LEAST(g.received_aed, NVL(a.invoiced_aed,0)))             AS grn_invoiced_aed,
         SUM(LEAST(g.received_aed, GREATEST(NVL(a.paid_aed,0),0)))     AS grn_paid_aed,
         SUM(GREATEST(g.received_aed - NVL(a.invoiced_aed,0), 0))      AS grn_uninvoiced_aed
  FROM po_dist b
  JOIN grn_recv g        ON g.po_distribution_id = b.po_distribution_id
  LEFT JOIN ap_per_dist a ON a.po_distribution_id = b.po_distribution_id
  GROUP BY b.project_id
),
ap_agg AS (
  SELECT d.project_id,
         COUNT(DISTINCT d.invoice_id)                                     AS ap_invoice_count,
         COUNT(DISTINCT CASE WHEN i.payment_status = 'Paid'
                             THEN d.invoice_id END)                       AS paid_invoice_count,
         COUNT(DISTINCT CASE WHEN i.payment_status = 'Partially Paid'
                             THEN d.invoice_id END)                       AS partially_paid_invoice_count,
         COUNT(DISTINCT CASE WHEN i.payment_status = 'Unpaid'
                             THEN d.invoice_id END)                       AS unpaid_invoice_count,
         SUM(CASE WHEN NVL(d.reversal_indicator,'N') <> 'Y'
                  THEN NVL(d.distribution_amount_functi, d.distribution_amount)
                  ELSE 0 END)                                             AS ap_invoiced_aed,
         SUM(CASE WHEN NVL(d.reversal_indicator,'N') <> 'Y'
                  THEN NVL(d.distribution_amount_functi, d.distribution_amount) * i.paid_ratio
                  ELSE 0 END)                                             AS ap_paid_aed,
         SUM(CASE WHEN NVL(d.reversal_indicator,'N') <> 'Y'
                   AND d.po_number IS NULL
                   AND i.validation_status IN ('Validated','Unpaid','Available')
                  THEN NVL(d.distribution_amount_functi, d.distribution_amount)
                  ELSE 0 END)                                             AS ap_direct_aed,
         MAX(d.accounting_date)                                           AS last_invoice_date
  FROM prod.ap_invoice_distributions d
  JOIN ap_inv i ON i.invoice_id = d.invoice_id
  WHERE d.project_id IS NOT NULL
    AND i.cancelled_date IS NULL
    AND NVL(i.validation_status,'x') <> 'Canceled'
  GROUP BY d.project_id
),
pr_agg AS (
  SELECT d.project_id,
         COUNT(DISTINCT CASE WHEN d.funds_status IN ('Reserved','Liquidated')
                             THEN d.requisition END)                      AS pr_count,
         SUM(CASE WHEN d.funds_status IN ('Reserved','Liquidated')
                  THEN d.distribution_amount * NVL(cc.exchange_rate_to_aed,1)
                  ELSE 0 END)                                             AS pr_amount_aed,
         SUM(CASE WHEN d.funds_status = 'Reserved'
                  THEN d.distribution_amount * NVL(cc.exchange_rate_to_aed,1)
                  ELSE 0 END)                                             AS open_commitment_aed,
         MAX(d.budget_date)                                               AS last_pr_date
  FROM prod.pr_distributions d
  LEFT JOIN prod.dct_currency_codes cc ON cc.currency_code = d.currency_code
  WHERE d.project_id IS NOT NULL
  GROUP BY d.project_id
),
-- open-item document number lists --------------------------------------------
ap_due_nums AS (
  SELECT project_id,
         LISTAGG(invoice_number, ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY invoice_number) AS balance_due_invoice_numbers
  FROM (
    SELECT DISTINCT d.project_id, TO_CHAR(i.invoice_number) AS invoice_number
    FROM prod.ap_invoice_distributions d
    JOIN ap_inv i ON i.invoice_id = d.invoice_id
    WHERE d.project_id IS NOT NULL
      AND i.cancelled_date IS NULL
      AND NVL(i.validation_status,'x') <> 'Canceled'
      AND i.payment_status IN ('Unpaid','Partially Paid')
      AND i.invoice_number IS NOT NULL
  )
  GROUP BY project_id
),
open_pr_nums AS (
  SELECT project_id,
         LISTAGG(pr_number, ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY pr_number) AS open_pr_numbers
  FROM (
    SELECT DISTINCT d.project_id, TO_CHAR(d.requisition) AS pr_number
    FROM prod.pr_distributions d
    WHERE d.project_id IS NOT NULL
      AND d.funds_status = 'Reserved'
      AND d.requisition IS NOT NULL
  )
  GROUP BY project_id
),
open_po_nums AS (
  SELECT project_id,
         LISTAGG(po_number, ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY po_number) AS open_po_numbers
  FROM (
    SELECT DISTINCT b.project_id, TO_CHAR(ph.order_number) AS po_number
    FROM po_dist b
    LEFT JOIN grn_recv g       ON g.po_distribution_id = b.po_distribution_id
    LEFT JOIN po_hdr_status hs ON hs.po_header_id      = b.po_header_id
    JOIN prod.po_headers ph    ON ph.po_header_id      = b.po_header_id
    WHERE b.funds_status IN ('Reserved','Partially Liquidated')
      AND NVL(hs.po_status,'x') <> 'Finally Closed'
      AND GREATEST(b.amt_aed - NVL(g.received_aed,0), 0) > 0.005
      AND ph.order_number IS NOT NULL
  )
  GROUP BY project_id
),
uninv_grn_nums AS (
  SELECT project_id,
         LISTAGG(grn_number, ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY grn_number) AS uninvoiced_grn_numbers
  FROM (
    SELECT DISTINCT b.project_id, TO_CHAR(g2.receipt_number) AS grn_number
    FROM po_dist b
    JOIN grn_recv g         ON g.po_distribution_id  = b.po_distribution_id
    LEFT JOIN ap_per_dist a ON a.po_distribution_id  = b.po_distribution_id
    JOIN prod.grn_all_v2 g2 ON g2.po_distribution_id = b.po_distribution_id
    WHERE g.received_aed - NVL(a.invoiced_aed,0) > 0.005
      AND g2.receipt_number IS NOT NULL
  )
  GROUP BY project_id
)
SELECT
  -- project master -----------------------------------------------------------
  p.project_number,
  MAX(p.project_name)                                    AS project_name,
  MAX(p.project_type)                                    AS project_type,
  MAX(p.project_status)                                  AS project_status,
  MAX(p.project_manager)                                 AS project_manager,
  MAX(p.business_unit)                                   AS business_unit,
  MAX(p.project_unit)                                    AS project_unit,
  MAX(p.budget_group)                                    AS budget_group,
  MAX(p.liability_project_type)                          AS liability_project_type,
  -- classification -----------------------------------------------------------
  MAX(CASE WHEN p.appropriation_code IS NOT NULL THEN
        p.appropriation_code ||
        CASE WHEN p.appropriation_desc IS NOT NULL THEN ' - ' || p.appropriation_desc END
      END)                                               AS appropriation,
  MAX(cm.chapter_name)                                   AS chapter,
  MAX(atr.sectors)                                       AS sectors,
  MAX(atr.departments)                                   AS departments,
  MAX(atr.cost_centres)                                  AS cost_centres,
  MAX(atr.programs)                                      AS programs,
  -- lifecycle ------------------------------------------------------------------
  MAX(p.project_start_date)                              AS project_start_date,
  MAX(p.project_finish_date)                             AS project_finish_date,
  MAX(p.project_closed_date)                             AS project_closed_date,
  MAX(p.project_creation_date)                           AS project_creation_date,
  -- structure + budget ---------------------------------------------------------
  NVL(SUM(ta.task_count),0)                              AS task_count,
  NVL(SUM(et.expenditure_type_count),0)                  AS expenditure_type_count,
  MAX(bu.budget_years)                                   AS budget_years,
  ROUND(NVL(SUM(bu.budget_aed),0),2)                     AS budget_aed,
  -- purchase requisitions ------------------------------------------------------
  NVL(SUM(pr.pr_count),0)                                AS pr_count,
  ROUND(NVL(SUM(pr.pr_amount_aed),0),2)                  AS pr_amount_aed,
  ROUND(NVL(SUM(pr.open_commitment_aed),0),2)            AS open_commitment_aed,
  MAX(prn.open_pr_numbers)                               AS open_pr_numbers,
  -- purchase orders ------------------------------------------------------------
  NVL(SUM(po.po_count),0)                                AS po_count,
  ROUND(NVL(SUM(po.po_amount_aed),0),2)                  AS po_amount_aed,
  ROUND(NVL(SUM(po.open_obligation_aed),0),2)            AS open_obligation_aed,
  MAX(pon.open_po_numbers)                               AS open_po_numbers,
  -- receipts (GRN) -------------------------------------------------------------
  NVL(SUM(gr.grn_receipt_count),0)                       AS grn_receipt_count,
  NVL(SUM(gr.grn_line_count),0)                          AS grn_line_count,
  ROUND(NVL(SUM(gr.grn_amount_aed),0),2)                 AS grn_amount_aed,
  ROUND(NVL(SUM(gm.grn_invoiced_aed),0),2)               AS grn_invoiced_aed,
  ROUND(NVL(SUM(gm.grn_paid_aed),0),2)                   AS grn_paid_aed,
  ROUND(NVL(SUM(gm.grn_uninvoiced_aed),0),2)             AS grn_uninvoiced_aed,
  MAX(ugn.uninvoiced_grn_numbers)                        AS uninvoiced_grn_numbers,
  -- AP invoices ----------------------------------------------------------------
  NVL(SUM(ap.ap_invoice_count),0)                        AS ap_invoice_count,
  NVL(SUM(ap.paid_invoice_count),0)                      AS paid_invoice_count,
  NVL(SUM(ap.partially_paid_invoice_count),0)            AS partially_paid_invoice_count,
  NVL(SUM(ap.unpaid_invoice_count),0)                    AS unpaid_invoice_count,
  ROUND(NVL(SUM(ap.ap_invoiced_aed),0),2)                AS ap_invoiced_aed,
  ROUND(NVL(SUM(ap.ap_paid_aed),0),2)                    AS ap_paid_aed,
  ROUND(NVL(SUM(ap.ap_invoiced_aed),0)
      - NVL(SUM(ap.ap_paid_aed),0),2)                    AS ap_balance_due_aed,
  MAX(adn.balance_due_invoice_numbers)                   AS balance_due_invoice_numbers,
  ROUND(NVL(SUM(ap.ap_direct_aed),0),2)                  AS ap_direct_aed,
  -- funds summary (butil formula, whole-life) -----------------------------------
  ROUND(NVL(SUM(ap.ap_direct_aed),0)
      + NVL(SUM(gr.grn_amount_aed),0),2)                 AS actual_spend_aed,
  CASE WHEN NVL(SUM(bu.budget_aed),0) > 0 THEN
    ROUND(SUM(bu.budget_aed)
        - ( NVL(SUM(ap.ap_direct_aed),0) + NVL(SUM(gr.grn_amount_aed),0)
          + NVL(SUM(pr.open_commitment_aed),0) + NVL(SUM(po.open_obligation_aed),0) ),2)
  END                                                    AS fund_available_aed,
  CASE WHEN NVL(SUM(bu.budget_aed),0) > 0 THEN
    ROUND( ( NVL(SUM(ap.ap_direct_aed),0) + NVL(SUM(gr.grn_amount_aed),0)
           + NVL(SUM(pr.open_commitment_aed),0) + NVL(SUM(po.open_obligation_aed),0) )
         / SUM(bu.budget_aed) * 100, 1)
  END                                                    AS utilization_pct,
  -- activity ---------------------------------------------------------------------
  MAX(pr.last_pr_date)                                   AS last_pr_date,
  MAX(po.last_po_date)                                   AS last_po_date,
  MAX(gr.last_receipt_date)                              AS last_receipt_date,
  MAX(ap.last_invoice_date)                              AS last_invoice_date,
  NULLIF(GREATEST(NVL(MAX(pr.last_pr_date),      DATE '1900-01-01'),
                  NVL(MAX(po.last_po_date),      DATE '1900-01-01'),
                  NVL(MAX(gr.last_receipt_date), DATE '1900-01-01'),
                  NVL(MAX(ap.last_invoice_date), DATE '1900-01-01')),
         DATE '1900-01-01')                              AS last_activity_date
FROM pj p
LEFT JOIN task_agg  ta ON ta.project_id = p.project_id
LEFT JOIN attr_agg  atr ON atr.project_id = p.project_id
LEFT JOIN bud_agg   bu ON bu.project_id = p.project_id
LEFT JOIN etype_agg et ON et.project_id = p.project_id
LEFT JOIN po_agg    po ON po.project_id = p.project_id
LEFT JOIN grn_agg   gr ON gr.project_id = p.project_id
LEFT JOIN grn_match gm ON gm.project_id = p.project_id
LEFT JOIN ap_agg    ap ON ap.project_id = p.project_id
LEFT JOIN pr_agg    pr ON pr.project_id = p.project_id
LEFT JOIN ap_due_nums    adn ON adn.project_id = p.project_id
LEFT JOIN open_pr_nums   prn ON prn.project_id = p.project_id
LEFT JOIN open_po_nums   pon ON pon.project_id = p.project_id
LEFT JOIN uninv_grn_nums ugn ON ugn.project_id = p.project_id
LEFT JOIN chapter_map cm ON cm.appropriation_code = p.appropriation_code
GROUP BY p.project_number;

PROMPT ============================================================
PROMPT  47_projects_v.sql complete.
PROMPT  1 view: PROJECTS_V (one row per project, no internal ids).
PROMPT ============================================================
