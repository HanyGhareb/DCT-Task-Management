-- ===========================================================================
-- DCT Budget Utilization view (db/v2/37)
-- ---------------------------------------------------------------------------
-- DCT_BUDGET_UTILIZATION_V : project-costing budget-vs-actual, ONE row per
-- BUDGET_YEAR x PROJECT x TASK x EXPENDITURE TYPE (only lines with budget > 0).
--
--   Budget          : prod.projects_budget (ATD_PROJECTS_BUDGET, BUDGET_YEAR
--                     dimension), counted once per line.
--   Actual AP       : no-PO invoice distributions (PO_NUMBER IS NULL), invoice
--                     validation_status IN (Validated, Unpaid, Available),
--                     non-reversed, project/task/etype at distribution level,
--                     year = accounting_date.
--   Actual GRN      : receipts (charge account via PO distribution),
--                     year = transaction_date.
--   Commitment (PR) : OPEN commitment = PR distributions FUNDS_STATUS='Reserved',
--                     year = budget_date.
--   Obligation (PO) : OPEN obligation = Reserved / Partially Liquidated PO
--                     distributions, GRN-netted per po_distribution_id,
--                     year = budget_date.
--   Fund Available  = Budget - AP - GRN - Open PR - Open PO.
--
-- Display attributes resolved task-first, then transactions, then project:
--   Sector       : task COST_CENTER -> DEFINED SECTOR map (dct_gl_seg_class_map,
--                  as of today) -> COA snap -> row/project transactions.
--   Cost centre / Department: task COST_CENTER -> row txns -> project txns
--                  -> raw task_organization name (department only).
--   Appropriation: task APPROPRIATION (desc from COA) -> row txns -> project.
--   Chapter      : appropriation -> DEFINED CHAPTER map -> COA -> project.
--   Program      : task PROGRAM (LPAD 6, desc from COA) -> row txns.
--   GL account   : row txns -> derived from the expenditure-type code prefix.
--
-- All amounts AED. Requires prod.dct_gl_coa_snap (db/v2/33) + base views
-- (db/v2/32 + 36). DEPLOY ORDER: re-run 32 first after any ATD reload so the
-- SELECT * base views expose current columns (BUDGET_YEAR, task COST_CENTER).
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

CREATE OR REPLACE VIEW prod.dct_budget_utilization_v AS
WITH
proj AS (
  SELECT project_id, project_number, MAX(project_name) AS project_name,
         MAX(project_type) AS project_type,
         MAX(appropriation) AS appropriation, MAX(appropriation_description) AS appropriation_desc
  FROM prod.projects GROUP BY project_id, project_number
),
tsk AS (
  SELECT task_id, MAX(task_number) AS task_number, MAX(task_name) AS task_name
  FROM prod.tasks GROUP BY task_id
),
tsk_org AS (
  SELECT task_number, MAX(task_organization) AS task_organization
  FROM prod.tasks GROUP BY task_number
),
tsk_seg AS (
  SELECT TO_CHAR(pj.project_number) AS project_key, t.task_number AS task_key,
         MAX(TO_CHAR(t.cost_center))   AS cost_center_code,
         MAX(TO_CHAR(t.appropriation)) AS appropriation_code,
         MAX(CASE WHEN t.program IS NOT NULL THEN LPAD(TO_CHAR(t.program),6,'0') END) AS program_code
  FROM prod.tasks t
  JOIN proj pj ON pj.project_id = t.project_id
  GROUP BY TO_CHAR(pj.project_number), t.task_number
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
acct AS (
  SELECT account_code, MAX(account_desc) AS account_desc
  FROM prod.dct_gl_coa_snap GROUP BY account_code
),
pb AS (
  SELECT b.budget_year,
         COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(b.project_id)) AS project_key,
         COALESCE(tk.task_number, '#'||TO_CHAR(b.task_id))                AS task_key,
         b.expenditure_type,
         SUM(b.budget) AS budget
  FROM prod.projects_budget b
  LEFT JOIN proj pj ON pj.project_id = b.project_id
  LEFT JOIN tsk  tk ON tk.task_id    = b.task_id
  GROUP BY b.budget_year,
           COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(b.project_id)),
           COALESCE(tk.task_number, '#'||TO_CHAR(b.task_id)),
           b.expenditure_type
),
po_dist AS (
  -- charge_account canonicalized via prod.dct_cc_canon (db/v2/40, re-ordered feed)
  SELECT po_distribution_id,
         prod.dct_cc_canon(MAX(charge_account)) AS charge_account,
         MAX(project_id)                        AS project_id,
         MAX(task_id)                           AS task_id,
         MAX(expenditure_type_name)             AS expenditure_type,
         MAX(budget_date)                       AS budget_date,
         MAX(distribution_amount * NVL(rate,1)) AS amt_aed,
         MAX(funds_status)                      AS funds_status
  FROM prod.po_distributions
  GROUP BY po_distribution_id
),
grn_per_dist AS (
  SELECT po_distribution_id,
         SUM(transaction_amount * NVL(conversion_rate,1)) AS grn_aed
  FROM prod.grn_all_v2
  GROUP BY po_distribution_id
),
f_ap AS (
  SELECT EXTRACT(YEAR FROM d.accounting_date) AS budget_year,
         cid.cc_string,
         COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id)) AS project_key,
         COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END) AS task_key,
         d.expenditure_type,
         SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS actual_ap
  FROM prod.ap_invoice_distributions d
  JOIN prod.ap_invoices i ON i.invoice_id = d.invoice_id
  JOIN prod.dct_gl_coa_snap cid ON cid.cc_id = d.cc_id
  LEFT JOIN proj pj ON pj.project_id = d.project_id
  LEFT JOIN tsk  tk ON tk.task_id    = d.task_id
  WHERE d.po_number IS NULL
    AND NVL(d.reversal_indicator,'N') <> 'Y'
    AND d.project_id IS NOT NULL
    AND i.validation_status IN ('Validated','Unpaid','Available')
  GROUP BY EXTRACT(YEAR FROM d.accounting_date), cid.cc_string,
           COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id)),
           COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END),
           d.expenditure_type
),
f_grn AS (
  SELECT EXTRACT(YEAR FROM g.transaction_date) AS budget_year,
         pod.charge_account AS cc_string,
         COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(g.project_id)) AS project_key,
         COALESCE(tk.task_number, CASE WHEN g.task_id IS NOT NULL THEN '#'||TO_CHAR(g.task_id) END) AS task_key,
         g.expenditure_type,
         SUM(g.transaction_amount * NVL(g.conversion_rate,1)) AS actual_grn
  FROM prod.grn_all_v2 g
  JOIN po_dist pod ON pod.po_distribution_id = g.po_distribution_id
  LEFT JOIN proj pj ON pj.project_id = g.project_id
  LEFT JOIN tsk  tk ON tk.task_id    = g.task_id
  WHERE g.project_id IS NOT NULL
    AND pod.charge_account IS NOT NULL
  GROUP BY EXTRACT(YEAR FROM g.transaction_date), pod.charge_account,
           COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(g.project_id)),
           COALESCE(tk.task_number, CASE WHEN g.task_id IS NOT NULL THEN '#'||TO_CHAR(g.task_id) END),
           g.expenditure_type
),
f_pr AS (
  SELECT EXTRACT(YEAR FROM d.budget_date) AS budget_year,
         prod.dct_cc_canon(d.charge_account) AS cc_string,
         COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id)) AS project_key,
         COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END) AS task_key,
         d.expenditure_type,
         SUM(d.distribution_amount * NVL(cc.exchange_rate_to_aed,1)) AS open_commitment_pr
  FROM prod.pr_distributions d
  LEFT JOIN prod.dct_currency_codes cc ON cc.currency_code = d.currency_code
  LEFT JOIN proj pj ON pj.project_id = d.project_id
  LEFT JOIN tsk  tk ON tk.task_id    = d.task_id
  WHERE d.funds_status = 'Reserved'
    AND d.project_id IS NOT NULL
    AND d.charge_account IS NOT NULL
  GROUP BY EXTRACT(YEAR FROM d.budget_date), prod.dct_cc_canon(d.charge_account),
           COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id)),
           COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END),
           d.expenditure_type
),
f_po AS (
  SELECT EXTRACT(YEAR FROM b.budget_date) AS budget_year,
         b.charge_account AS cc_string,
         COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(b.project_id)) AS project_key,
         COALESCE(tk.task_number, CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END) AS task_key,
         b.expenditure_type,
         SUM(GREATEST(b.amt_aed - NVL(g.grn_aed,0), 0)) AS open_obligation_po
  FROM po_dist b
  LEFT JOIN grn_per_dist g ON g.po_distribution_id = b.po_distribution_id
  LEFT JOIN proj pj ON pj.project_id = b.project_id
  LEFT JOIN tsk  tk ON tk.task_id    = b.task_id
  WHERE b.funds_status IN ('Reserved','Partially Liquidated')
    AND b.project_id IS NOT NULL
    AND b.charge_account IS NOT NULL
  GROUP BY EXTRACT(YEAR FROM b.budget_date), b.charge_account,
           COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(b.project_id)),
           COALESCE(tk.task_number, CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END),
           b.expenditure_type
),
fact_keys AS (
  SELECT budget_year, cc_string, project_key, task_key, expenditure_type FROM f_ap
  UNION SELECT budget_year, cc_string, project_key, task_key, expenditure_type FROM f_grn
  UNION SELECT budget_year, cc_string, project_key, task_key, expenditure_type FROM f_pr
  UNION SELECT budget_year, cc_string, project_key, task_key, expenditure_type FROM f_po
),
keys AS (
  SELECT budget_year, cc_string, project_key, task_key, expenditure_type FROM fact_keys
  UNION ALL
  SELECT budget_year, NULL, project_key, task_key, expenditure_type FROM (
    SELECT budget_year, project_key, task_key, expenditure_type FROM pb
    MINUS
    SELECT budget_year, project_key, task_key, expenditure_type FROM fact_keys
  )
)
SELECT
  k.budget_year,
  NVL(MAX(pj.project_type),'(not in projects master)') AS project_type,
  COALESCE(MAX(sm.sector_name),
           MAX(tcd.sector_name),
           MAX(coa.sector_name),
           MAX(MAX(coa.sector_name)) OVER (PARTITION BY k.budget_year, k.project_key),
           MAX(MAX(sm.sector_name)) OVER (PARTITION BY k.budget_year, k.project_key))        AS sector,
  COALESCE(MAX(tcd.cost_center_desc),
           MAX(coa.cost_center_desc),
           MAX(MAX(coa.cost_center_desc)) OVER (PARTITION BY k.budget_year, k.project_key),
           MAX(MAX(tcd.cost_center_desc)) OVER (PARTITION BY k.budget_year, k.project_key),
           MAX(torg.task_organization))                                                      AS department,
  COALESCE(MAX(tcc.cost_center_code),
           MAX(coa.cost_center_code),
           MAX(MAX(coa.cost_center_code)) OVER (PARTITION BY k.budget_year, k.project_key),
           MAX(MAX(tcc.cost_center_code)) OVER (PARTITION BY k.budget_year, k.project_key))  AS cost_centre,
  k.project_key             AS project_number,
  MAX(pj.project_name)      AS project_name,
  k.task_key                AS task_number,
  COALESCE(MAX(CASE WHEN coa.account_code IS NOT NULL THEN coa.account_code || ' - ' || coa.account_desc END),
           MAX(CASE WHEN ac.account_code  IS NOT NULL THEN ac.account_code  || ' - ' || ac.account_desc  END)) AS gl_account,
  COALESCE(MAX(CASE WHEN tcc.appropriation_code IS NOT NULL
                    THEN tcc.appropriation_code ||
                         CASE WHEN ad.appropriation_desc IS NOT NULL THEN ' - ' || ad.appropriation_desc END END),
           MAX(CASE WHEN coa.appropriation_code IS NOT NULL THEN coa.appropriation_code || ' - ' || coa.appropriation_desc END),
           MAX(CASE WHEN pj.appropriation IS NOT NULL THEN pj.appropriation || ' - ' || pj.appropriation_desc END)) AS appropriation,
  COALESCE(MAX(cmap.chapter_name),
           MAX(coa.chapter_name),
           MAX(cmap_pj.chapter_name),
           MAX(MAX(coa.chapter_name)) OVER (PARTITION BY k.budget_year, k.project_key))      AS chapter,
  COALESCE(MAX(CASE WHEN tcc.program_code IS NOT NULL
                    THEN tcc.program_code ||
                         CASE WHEN pgd.program_desc IS NOT NULL THEN ' - ' || pgd.program_desc END END),
           MAX(CASE WHEN coa.program_code IS NOT NULL THEN coa.program_code || ' - ' || coa.program_desc END)) AS program,
  k.expenditure_type,
  MAX(NVL(b.budget,0))              AS budget,
  SUM(NVL(ap.actual_ap,0))          AS actual_ap,
  SUM(NVL(grn.actual_grn,0))        AS actual_grn,
  SUM(NVL(pr.open_commitment_pr,0)) AS commitment_pr,
  SUM(NVL(po.open_obligation_po,0)) AS obligation_po,
  CASE WHEN MAX(b.project_key) IS NOT NULL THEN
    MAX(NVL(b.budget,0))
      - SUM( NVL(ap.actual_ap,0) + NVL(grn.actual_grn,0)
           + NVL(pr.open_commitment_pr,0) + NVL(po.open_obligation_po,0) )
  END AS fund_available
FROM keys k
LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = k.cc_string
LEFT JOIN pb b  ON b.budget_year = k.budget_year
               AND b.project_key = k.project_key
               AND NVL(b.task_key,'~')         = NVL(k.task_key,'~')
               AND NVL(b.expenditure_type,'~') = NVL(k.expenditure_type,'~')
LEFT JOIN proj pj ON TO_CHAR(pj.project_number) = k.project_key
LEFT JOIN tsk_org torg ON torg.task_number = k.task_key
LEFT JOIN tsk_seg tcc ON tcc.project_key = k.project_key AND tcc.task_key = k.task_key
LEFT JOIN cc_dim tcd ON tcd.cost_center_code = tcc.cost_center_code
LEFT JOIN sector_map sm ON sm.cost_center_code = tcc.cost_center_code
LEFT JOIN approp_dim ad ON ad.appropriation_code = tcc.appropriation_code
LEFT JOIN chapter_map cmap ON cmap.appropriation_code = tcc.appropriation_code
LEFT JOIN chapter_map cmap_pj ON cmap_pj.appropriation_code = pj.appropriation
LEFT JOIN program_dim pgd ON pgd.program_code = tcc.program_code
LEFT JOIN acct ac ON ac.account_code = REGEXP_SUBSTR(k.expenditure_type,'^\d+')
LEFT JOIN f_ap ap ON ap.budget_year = k.budget_year
                 AND NVL(ap.cc_string,'~') = NVL(k.cc_string,'~')
                 AND ap.project_key = k.project_key
                 AND NVL(ap.task_key,'~')         = NVL(k.task_key,'~')
                 AND NVL(ap.expenditure_type,'~') = NVL(k.expenditure_type,'~')
LEFT JOIN f_grn grn ON grn.budget_year = k.budget_year
                 AND NVL(grn.cc_string,'~') = NVL(k.cc_string,'~')
                 AND grn.project_key = k.project_key
                 AND NVL(grn.task_key,'~')         = NVL(k.task_key,'~')
                 AND NVL(grn.expenditure_type,'~') = NVL(k.expenditure_type,'~')
LEFT JOIN f_pr pr ON pr.budget_year = k.budget_year
                 AND NVL(pr.cc_string,'~') = NVL(k.cc_string,'~')
                 AND pr.project_key = k.project_key
                 AND NVL(pr.task_key,'~')         = NVL(k.task_key,'~')
                 AND NVL(pr.expenditure_type,'~') = NVL(k.expenditure_type,'~')
LEFT JOIN f_po po ON po.budget_year = k.budget_year
                 AND NVL(po.cc_string,'~') = NVL(k.cc_string,'~')
                 AND po.project_key = k.project_key
                 AND NVL(po.task_key,'~')         = NVL(k.task_key,'~')
                 AND NVL(po.expenditure_type,'~') = NVL(k.expenditure_type,'~')
GROUP BY k.budget_year, k.project_key, k.task_key, k.expenditure_type
HAVING MAX(NVL(b.budget,0)) > 0;

PROMPT DCT_BUDGET_UTILIZATION_V created (budget-year x project x task x expenditure type).
