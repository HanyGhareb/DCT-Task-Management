-- ===========================================================================
-- Project Tasks inquiry view (db/v2/45)
-- ---------------------------------------------------------------------------
-- TASKS_V : one row per PROJECT x TASK, end-user friendly - business numbers,
-- names and descriptions only, NO surrogate ids - the task-grain sibling of
-- PROJECTS_V (db/v2/44): same fact rules, same column vocabulary, so a
-- project row and its task rows read as one family. All amounts AED,
-- rounded to 2 decimals.
--
--   Master      : prod.tasks + prod.projects (base pass-through views,
--                 db/v2/32). Verified unique per (project, task number);
--                 grouped anyway so reload duplicates never fan out.
--   Classification (task-first, resolution order of db/v2/37):
--                 task COST_CENTER -> COA snap description + DEFINED SECTOR
--                 map (as of today); APPROPRIATION = task code (COA desc),
--                 else the project's; CHAPTER = DEFINED CHAPTER map on the
--                 task appropriation, else on the project's; task PROGRAM
--                 -> COA description. Master attributes only - no
--                 transaction-level fallbacks.
--   Budget      : prod.projects_budget summed across ALL budget years (the
--                 budget is annual; this view is whole-life) + the year list.
--   Expenditure : EXPENDITURE_TYPE_COUNT / _TYPES = distinct expenditure
--                 types the task uses anywhere in budget, PR, PO, AP or GRN.
--   PR          : model of db/v2/36 - PR_AMOUNT_AED = funds status Reserved
--                 + Liquidated, OPEN_COMMITMENT_AED = Reserved only,
--                 PR_COUNT = distinct requisitions behind PR_AMOUNT. AED via
--                 the DCT_CURRENCY_CODES snapshot rate (PR carries no rate).
--                 OPEN_PR_NUMBERS = the distinct requisition numbers behind
--                 the open commitment (non-zero Reserved lines only).
--   PO          : PO_AMOUNT_AED = distribution amount x own rate for every
--                 funds status except Failed / Passed (the never-reserved
--                 pipeline; NULL statuses stay IN the totals);
--                 OPEN_OBLIGATION_AED = Reserved / Partially Liquidated,
--                 GRN-netted per distribution, header status Finally Closed
--                 excluded (db/v2/37 figure). OPEN_PO_NUMBERS = the distinct
--                 PO numbers still contributing to the open obligation
--                 (distributions whose GRN-netted remainder > 0).
--   GRN         : LEDGER_AMOUNT only (already AED - never x conversion_rate,
--                 2026-07-10). GRN_RECEIPT_COUNT = distinct receipt numbers,
--                 GRN_LINE_COUNT = receipt transaction lines.
--                 GRN_INVOICED / GRN_PAID / GRN_UNINVOICED decompose the
--                 received amount per PO distribution against matched AP
--                 (order + line + distribution join of db/v2/39; paid =
--                 invoice-header paid ratio prorated, capped at received),
--                 so per row GRN_INVOICED + GRN_UNINVOICED = GRN_AMOUNT.
--   AP          : non-cancelled invoices costed to the task - PO-matched AND
--                 direct. Counts split by derived payment status (the
--                 db/v2/39 + 43 convention); invoiced / paid AED over
--                 non-reversed distributions, AED = NVL(FUNCTI, amount);
--                 AP_PAID_AED prorates each invoice header paid amount over
--                 its distributions (ratio capped at 1 - a few Fusion
--                 invoices carry paid above amount). Credit memos with no
--                 recorded payment application count as UNPAID, so
--                 AP_BALANCE_DUE_AED can go NEGATIVE = outstanding supplier
--                 credit (verified live: 2 tasks, both open credit notes).
--                 AP_DIRECT_AED = the no-PO validated subset (the
--                 utilization Actual AP figure).
--   Funds       : ACTUAL_SPEND_AED = AP direct + GRN; FUND_AVAILABLE_AED =
--                 BUDGET - AP_DIRECT - GRN - OPEN PR - OPEN PO and
--                 UTILIZATION_PCT - both only when the task has budget
--                 (formula of db/v2/37, whole-life instead of per year).
--   Activity    : last PR / PO / receipt / invoice dates + overall
--                 LAST_ACTIVITY_DATE.
--
-- Tasks referenced by transactions but absent from the task master are not
-- shown (DCT_BUDGET_UTILIZATION_V covers those with #id fallbacks); facts
-- carrying a project but NO task appear only in PROJECTS_V, so a project
-- row can legitimately exceed the sum of its task rows. Dates are Fusion
-- business dates - exposed as-is, no dct_to_local conversion. Sources are
-- the base pass-through views: re-run AFTER db/v2/32 + 36 whenever those
-- are rebuilt (dct_views_rebuild recompiles this automatically). Owned by
-- PROD; run with the prod. prefix, no ALTER SESSION, fresh SQLcl session.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

CREATE OR REPLACE VIEW prod.tasks_v AS
WITH
proj AS (
  SELECT project_id,
         MAX(TO_CHAR(project_number))    AS project_number,
         MAX(project_name)               AS project_name,
         MAX(project_type)               AS project_type,
         MAX(project_status)             AS project_status,
         MAX(project_manager)            AS project_manager,
         MAX(business_unit_name)         AS business_unit,
         MAX(appropriation)              AS appropriation_code,
         MAX(appropriation_description)  AS appropriation_desc
  FROM prod.projects
  GROUP BY project_id
),
tsk AS (
  SELECT task_id,
         MAX(project_id)            AS project_id,
         MAX(task_number)           AS task_number,
         MAX(task_name)             AS task_name,
         MAX(task_description)      AS task_description,
         MAX(work_type)             AS work_type,
         MAX(service_type)          AS service_type,
         MAX(element_type)          AS element_type,
         MAX(task_organization)     AS task_organization,
         MAX(chargeable_task)       AS chargeable_task,
         MAX(planned_start_date)    AS planned_start_date,
         MAX(planned_finish_date)   AS planned_finish_date,
         MAX(actual_start_date)     AS actual_start_date,
         MAX(actual_finish_date)    AS actual_finish_date,
         MAX(creation_date)         AS task_created_date,
         MAX(last_update_date)      AS task_last_updated,
         MAX(CASE WHEN cost_center   IS NOT NULL THEN LPAD(TO_CHAR(cost_center),7,'0')   END) AS cost_center_code,
         MAX(CASE WHEN appropriation IS NOT NULL THEN LPAD(TO_CHAR(appropriation),6,'0') END) AS task_appropriation_code,
         MAX(CASE WHEN program IS NOT NULL THEN LPAD(TO_CHAR(program),6,'0') END) AS program_code
  FROM prod.tasks
  GROUP BY task_id
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
bud_agg AS (
  SELECT task_id,
         SUM(budget) AS budget_aed,
         LISTAGG(DISTINCT TO_CHAR(budget_year), ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY TO_CHAR(budget_year)) AS budget_years
  FROM prod.projects_budget
  WHERE task_id IS NOT NULL
  GROUP BY task_id
),
etype_agg AS (
  SELECT e.task_id,
         COUNT(DISTINCT e.expenditure_type) AS expenditure_type_count,
         LISTAGG(DISTINCT e.expenditure_type, ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY e.expenditure_type) AS expenditure_types
  FROM (
    SELECT task_id, expenditure_type FROM prod.projects_budget WHERE expenditure_type IS NOT NULL
    UNION SELECT task_id, expenditure_type_name FROM prod.po_distributions WHERE expenditure_type_name IS NOT NULL
    UNION SELECT task_id, expenditure_type FROM prod.pr_distributions WHERE expenditure_type IS NOT NULL
    UNION SELECT task_id, expenditure_type FROM prod.ap_invoice_distributions WHERE expenditure_type IS NOT NULL
    UNION SELECT task_id, expenditure_type FROM prod.grn_all_v2 WHERE expenditure_type IS NOT NULL
  ) e
  WHERE e.task_id IS NOT NULL
  GROUP BY e.task_id
),
po_dist AS (
  SELECT po_distribution_id,
         MAX(po_header_id)                      AS po_header_id,
         MAX(task_id)                           AS task_id,
         MAX(budget_date)                       AS budget_date,
         MAX(distribution_amount * NVL(rate,1)) AS amt_aed,
         MAX(funds_status)                      AS funds_status
  FROM prod.po_distributions
  GROUP BY po_distribution_id
),
po_hdr_status AS (
  SELECT po_header_id,
         MAX(status)                AS po_status,
         MAX(TO_CHAR(order_number)) AS po_number
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
         MAX(validation_status)          AS validation_status,
         MAX(cancelled_date)             AS cancelled_date,
         -- ratio capped at 1: a few Fusion invoices carry amount_paid above the
         -- invoice amount and would otherwise show task Paid > Invoiced
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
  SELECT b.task_id,
         COUNT(DISTINCT CASE WHEN NVL(b.funds_status,'~') NOT IN ('Failed','Passed')
                             THEN b.po_header_id END)                     AS po_count,
         SUM(CASE WHEN NVL(b.funds_status,'~') NOT IN ('Failed','Passed')
                  THEN b.amt_aed ELSE 0 END)                              AS po_amount_aed,
         SUM(CASE WHEN b.funds_status IN ('Reserved','Partially Liquidated')
                   AND NVL(hs.po_status,'x') <> 'Finally Closed'
                  THEN GREATEST(b.amt_aed - NVL(g.received_aed,0), 0)
                  ELSE 0 END)                                             AS open_obligation_aed,
         LISTAGG(DISTINCT CASE WHEN b.funds_status IN ('Reserved','Partially Liquidated')
                                AND NVL(hs.po_status,'x') <> 'Finally Closed'
                                AND b.amt_aed - NVL(g.received_aed,0) > 0.005
                               THEN hs.po_number END, ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY CASE WHEN b.funds_status IN ('Reserved','Partially Liquidated')
                                        AND NVL(hs.po_status,'x') <> 'Finally Closed'
                                        AND b.amt_aed - NVL(g.received_aed,0) > 0.005
                                       THEN hs.po_number END)             AS open_po_numbers,
         MAX(b.budget_date)                                               AS last_po_date
  FROM po_dist b
  LEFT JOIN grn_recv g       ON g.po_distribution_id = b.po_distribution_id
  LEFT JOIN po_hdr_status hs ON hs.po_header_id      = b.po_header_id
  WHERE b.task_id IS NOT NULL
  GROUP BY b.task_id
),
grn_agg AS (
  SELECT task_id,
         COUNT(DISTINCT receipt_number)                 AS grn_receipt_count,
         COUNT(*)                                       AS grn_line_count,
         SUM(ledger_amount)                             AS grn_amount_aed,
         MAX(NVL(accounted_date, transaction_date))     AS last_receipt_date
  FROM prod.grn_all_v2
  WHERE task_id IS NOT NULL
  GROUP BY task_id
),
-- received-vs-invoiced-vs-paid progression per PO distribution --------------
grn_match AS (
  SELECT b.task_id,
         SUM(LEAST(g.received_aed, NVL(a.invoiced_aed,0)))             AS grn_invoiced_aed,
         SUM(LEAST(g.received_aed, GREATEST(NVL(a.paid_aed,0),0)))     AS grn_paid_aed,
         SUM(GREATEST(g.received_aed - NVL(a.invoiced_aed,0), 0))      AS grn_uninvoiced_aed
  FROM po_dist b
  JOIN grn_recv g         ON g.po_distribution_id = b.po_distribution_id
  LEFT JOIN ap_per_dist a ON a.po_distribution_id = b.po_distribution_id
  WHERE b.task_id IS NOT NULL
  GROUP BY b.task_id
),
ap_agg AS (
  SELECT d.task_id,
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
  WHERE d.task_id IS NOT NULL
    AND i.cancelled_date IS NULL
    AND NVL(i.validation_status,'x') <> 'Canceled'
  GROUP BY d.task_id
),
pr_agg AS (
  SELECT d.task_id,
         COUNT(DISTINCT CASE WHEN d.funds_status IN ('Reserved','Liquidated')
                             THEN d.requisition END)                      AS pr_count,
         SUM(CASE WHEN d.funds_status IN ('Reserved','Liquidated')
                  THEN d.distribution_amount * NVL(cc.exchange_rate_to_aed,1)
                  ELSE 0 END)                                             AS pr_amount_aed,
         SUM(CASE WHEN d.funds_status = 'Reserved'
                  THEN d.distribution_amount * NVL(cc.exchange_rate_to_aed,1)
                  ELSE 0 END)                                             AS open_commitment_aed,
         LISTAGG(DISTINCT CASE WHEN d.funds_status = 'Reserved'
                                AND d.distribution_amount <> 0
                               THEN TO_CHAR(d.requisition) END, ', ' ON OVERFLOW TRUNCATE)
           WITHIN GROUP (ORDER BY CASE WHEN d.funds_status = 'Reserved'
                                        AND d.distribution_amount <> 0
                                       THEN TO_CHAR(d.requisition) END)   AS open_pr_numbers,
         MAX(d.budget_date)                                               AS last_pr_date
  FROM prod.pr_distributions d
  LEFT JOIN prod.dct_currency_codes cc ON cc.currency_code = d.currency_code
  WHERE d.task_id IS NOT NULL
  GROUP BY d.task_id
)
SELECT
  -- project ------------------------------------------------------------------
  MAX(p.project_number)                                  AS project_number,
  MAX(p.project_name)                                    AS project_name,
  MAX(p.project_type)                                    AS project_type,
  MAX(p.project_status)                                  AS project_status,
  MAX(p.project_manager)                                 AS project_manager,
  MAX(p.business_unit)                                   AS business_unit,
  -- task ---------------------------------------------------------------------
  t.task_number,
  MAX(t.task_name)                                       AS task_name,
  MAX(t.task_description)                                AS task_description,
  MAX(t.work_type)                                       AS work_type,
  MAX(t.service_type)                                    AS service_type,
  MAX(t.element_type)                                    AS element_type,
  MAX(t.chargeable_task)                                 AS chargeable_task,
  MAX(t.task_organization)                               AS task_organization,
  -- classification (task-first) -------------------------------------------------
  MAX(CASE WHEN t.cost_center_code IS NOT NULL THEN
        t.cost_center_code ||
        CASE WHEN cd.cost_center_desc IS NOT NULL THEN ' - ' || cd.cost_center_desc END
      END)                                               AS cost_center,
  MAX(COALESCE(cd.cost_center_desc, t.task_organization)) AS department,
  MAX(COALESCE(sm.sector_name, cd.sector_name))          AS sector,
  COALESCE(
    MAX(CASE WHEN t.task_appropriation_code IS NOT NULL THEN
          t.task_appropriation_code ||
          CASE WHEN ad.appropriation_desc IS NOT NULL THEN ' - ' || ad.appropriation_desc END
        END),
    MAX(CASE WHEN p.appropriation_code IS NOT NULL THEN
          p.appropriation_code ||
          CASE WHEN p.appropriation_desc IS NOT NULL THEN ' - ' || p.appropriation_desc END
        END))                                            AS appropriation,
  COALESCE(MAX(cm.chapter_name), MAX(cmp.chapter_name))  AS chapter,
  MAX(CASE WHEN t.program_code IS NOT NULL THEN
        t.program_code ||
        CASE WHEN pgd.program_desc IS NOT NULL THEN ' - ' || pgd.program_desc END
      END)                                               AS program,
  -- lifecycle ------------------------------------------------------------------
  MAX(t.planned_start_date)                              AS planned_start_date,
  MAX(t.planned_finish_date)                             AS planned_finish_date,
  MAX(t.actual_start_date)                               AS actual_start_date,
  MAX(t.actual_finish_date)                              AS actual_finish_date,
  MAX(t.task_created_date)                               AS task_created_date,
  MAX(t.task_last_updated)                               AS task_last_updated,
  -- budget + expenditure ----------------------------------------------------------
  MAX(bu.budget_years)                                   AS budget_years,
  ROUND(NVL(SUM(bu.budget_aed),0),2)                     AS budget_aed,
  NVL(SUM(et.expenditure_type_count),0)                  AS expenditure_type_count,
  MAX(et.expenditure_types)                              AS expenditure_types,
  -- purchase requisitions ------------------------------------------------------
  NVL(SUM(pr.pr_count),0)                                AS pr_count,
  ROUND(NVL(SUM(pr.pr_amount_aed),0),2)                  AS pr_amount_aed,
  ROUND(NVL(SUM(pr.open_commitment_aed),0),2)            AS open_commitment_aed,
  MAX(pr.open_pr_numbers)                                AS open_pr_numbers,
  -- purchase orders ------------------------------------------------------------
  NVL(SUM(po.po_count),0)                                AS po_count,
  ROUND(NVL(SUM(po.po_amount_aed),0),2)                  AS po_amount_aed,
  ROUND(NVL(SUM(po.open_obligation_aed),0),2)            AS open_obligation_aed,
  MAX(po.open_po_numbers)                                AS open_po_numbers,
  -- receipts (GRN) -------------------------------------------------------------
  NVL(SUM(gr.grn_receipt_count),0)                       AS grn_receipt_count,
  NVL(SUM(gr.grn_line_count),0)                          AS grn_line_count,
  ROUND(NVL(SUM(gr.grn_amount_aed),0),2)                 AS grn_amount_aed,
  ROUND(NVL(SUM(gm.grn_invoiced_aed),0),2)               AS grn_invoiced_aed,
  ROUND(NVL(SUM(gm.grn_paid_aed),0),2)                   AS grn_paid_aed,
  ROUND(NVL(SUM(gm.grn_uninvoiced_aed),0),2)             AS grn_uninvoiced_aed,
  -- AP invoices ----------------------------------------------------------------
  NVL(SUM(ap.ap_invoice_count),0)                        AS ap_invoice_count,
  NVL(SUM(ap.paid_invoice_count),0)                      AS paid_invoice_count,
  NVL(SUM(ap.partially_paid_invoice_count),0)            AS partially_paid_invoice_count,
  NVL(SUM(ap.unpaid_invoice_count),0)                    AS unpaid_invoice_count,
  ROUND(NVL(SUM(ap.ap_invoiced_aed),0),2)                AS ap_invoiced_aed,
  ROUND(NVL(SUM(ap.ap_paid_aed),0),2)                    AS ap_paid_aed,
  ROUND(NVL(SUM(ap.ap_invoiced_aed),0)
      - NVL(SUM(ap.ap_paid_aed),0),2)                    AS ap_balance_due_aed,
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
FROM tsk t
LEFT JOIN proj p          ON p.project_id = t.project_id
LEFT JOIN cc_dim cd       ON cd.cost_center_code = t.cost_center_code
LEFT JOIN sector_map sm   ON sm.cost_center_code = t.cost_center_code
LEFT JOIN approp_dim ad   ON ad.appropriation_code = t.task_appropriation_code
LEFT JOIN chapter_map cm  ON cm.appropriation_code = t.task_appropriation_code
LEFT JOIN chapter_map cmp ON cmp.appropriation_code = p.appropriation_code
LEFT JOIN program_dim pgd ON pgd.program_code = t.program_code
LEFT JOIN bud_agg   bu ON bu.task_id = t.task_id
LEFT JOIN etype_agg et ON et.task_id = t.task_id
LEFT JOIN po_agg    po ON po.task_id = t.task_id
LEFT JOIN grn_agg   gr ON gr.task_id = t.task_id
LEFT JOIN grn_match gm ON gm.task_id = t.task_id
LEFT JOIN ap_agg    ap ON ap.task_id = t.task_id
LEFT JOIN pr_agg    pr ON pr.task_id = t.task_id
GROUP BY t.project_id, t.task_number;

PROMPT ============================================================
PROMPT  45_tasks_v.sql complete.
PROMPT  1 view: TASKS_V (one row per project x task, no internal ids).
PROMPT ============================================================
