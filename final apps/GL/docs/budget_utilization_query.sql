-- ===========================================================================
-- Budget Utilization report (project-grain) -- FINAL query v5 (2026-07-02)
-- ---------------------------------------------------------------------------
-- One row per PROJECT x TASK x EXPENDITURE TYPE (only lines with budget > 0).
--   Budget          : prod.projects_budget (ATD_PROJECTS_BUDGET), counted once.
--   Actual AP       : no-PO invoice distributions (PO_NUMBER IS NULL), invoice
--                     validation_status IN (Validated, Unpaid, Available),
--                     non-reversed, project/task/etype at distribution level.
--   Actual GRN      : receipts (charge account via PO distribution).
--   Commitment (PR) : OPEN commitment = PR distributions FUNDS_STATUS='Reserved'.
--   Obligation (PO) : OPEN obligation = Reserved/Partially Liquidated PO
--                     distributions, GRN-netted per po_distribution_id.
--   Fund Available  = Budget - AP - GRN - Open PR - Open PO.
-- Display attributes: sector/department/cost centre resolved from the row's
-- own transactions -> the project's transactions -> the task's organization
-- (prod.tasks.task_organization; name-matched to COA cost centres where
-- possible). GL account derived from the expenditure-type code prefix for
-- budget-only lines; appropriation/chapter fall back to the project master.
-- GL_COMBINATION = distinct full combinations behind the row ('|'-separated).
-- All amounts AED. Requires prod.dct_gl_coa_snap (db/v2/33) + base views
-- (db/v2/32 + 36). Verified live 2026-07-02: 5,313 rows, budget 24,064.4M.
-- ===========================================================================
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
tsk_org AS (  -- task cost centre (organization) per task number
  SELECT task_number, MAX(task_organization) AS task_organization
  FROM prod.tasks GROUP BY task_number
),
ccmap AS (    -- normalized cost-centre-desc -> code + sector (for org-name matching)
  SELECT UPPER(REGEXP_REPLACE(cost_center_desc,'[^A-Za-z0-9]','')) AS norm,
         MAX(cost_center_code) AS cost_center_code,
         MAX(cost_center_desc) AS cost_center_desc,
         MAX(sector_name)      AS sector_name
  FROM prod.dct_gl_coa_snap WHERE cost_center_desc IS NOT NULL
  GROUP BY UPPER(REGEXP_REPLACE(cost_center_desc,'[^A-Za-z0-9]',''))
),
acct AS (
  SELECT account_code, MAX(account_desc) AS account_desc
  FROM prod.dct_gl_coa_snap GROUP BY account_code
),
approp_chap AS (
  SELECT appropriation_code, MAX(chapter_name) AS chapter_name
  FROM prod.dct_gl_coa_snap GROUP BY appropriation_code
),
pb AS (
  SELECT COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(b.project_id)) AS project_key,
         COALESCE(tk.task_number, '#'||TO_CHAR(b.task_id))                AS task_key,
         b.expenditure_type,
         SUM(b.budget) AS budget
  FROM prod.projects_budget b
  LEFT JOIN proj pj ON pj.project_id = b.project_id
  LEFT JOIN tsk  tk ON tk.task_id    = b.task_id
  GROUP BY COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(b.project_id)),
           COALESCE(tk.task_number, '#'||TO_CHAR(b.task_id)),
           b.expenditure_type
),
po_dist AS (
  SELECT po_distribution_id,
         MAX(charge_account)                    AS charge_account,
         MAX(project_id)                        AS project_id,
         MAX(task_id)                           AS task_id,
         MAX(expenditure_type_name)             AS expenditure_type,
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
  SELECT cid.cc_string,
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
  GROUP BY cid.cc_string,
           COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id)),
           COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END),
           d.expenditure_type
),
f_grn AS (
  SELECT pod.charge_account AS cc_string,
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
  GROUP BY pod.charge_account,
           COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(g.project_id)),
           COALESCE(tk.task_number, CASE WHEN g.task_id IS NOT NULL THEN '#'||TO_CHAR(g.task_id) END),
           g.expenditure_type
),
f_pr AS (
  SELECT d.charge_account AS cc_string,
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
  GROUP BY d.charge_account,
           COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(d.project_id)),
           COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END),
           d.expenditure_type
),
f_po AS (
  SELECT b.charge_account AS cc_string,
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
  GROUP BY b.charge_account,
           COALESCE(TO_CHAR(pj.project_number), '#'||TO_CHAR(b.project_id)),
           COALESCE(tk.task_number, CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END),
           b.expenditure_type
),
fact_keys AS (
  SELECT cc_string, project_key, task_key, expenditure_type FROM f_ap
  UNION SELECT cc_string, project_key, task_key, expenditure_type FROM f_grn
  UNION SELECT cc_string, project_key, task_key, expenditure_type FROM f_pr
  UNION SELECT cc_string, project_key, task_key, expenditure_type FROM f_po
),
keys AS (
  SELECT cc_string, project_key, task_key, expenditure_type FROM fact_keys
  UNION ALL
  SELECT NULL, project_key, task_key, expenditure_type FROM (
    SELECT project_key, task_key, expenditure_type FROM pb
    MINUS
    SELECT project_key, task_key, expenditure_type FROM fact_keys
  )
),
SELECT
  NVL(MAX(pj.project_type),'(not in projects master)') AS project_type,
  COALESCE(MAX(coa.sector_name),
           MAX(MAX(coa.sector_name)) OVER (PARTITION BY k.project_key),
           MAX(cm.sector_name))                            AS sector,
  COALESCE(MAX(coa.cost_center_desc),
           MAX(MAX(coa.cost_center_desc)) OVER (PARTITION BY k.project_key),
           MAX(torg.task_organization))                    AS department,
  COALESCE(MAX(coa.cost_center_code),
           MAX(MAX(coa.cost_center_code)) OVER (PARTITION BY k.project_key),
           MAX(cm.cost_center_code))                       AS cost_centre,
  k.project_key             AS project_number,
  MAX(pj.project_name)      AS project_name,
  k.task_key                AS tasks,
  COALESCE(MAX(CASE WHEN coa.account_code IS NOT NULL THEN coa.account_code || ' - ' || coa.account_desc END),
           MAX(CASE WHEN ac.account_code  IS NOT NULL THEN ac.account_code  || ' - ' || ac.account_desc  END)) AS gl_account,
  COALESCE(MAX(CASE WHEN coa.appropriation_code IS NOT NULL THEN coa.appropriation_code || ' - ' || coa.appropriation_desc END),
           MAX(CASE WHEN pj.appropriation IS NOT NULL THEN pj.appropriation || ' - ' || pj.appropriation_desc END)) AS appropriation,
  COALESCE(MAX(coa.chapter_name), MAX(apc.chapter_name))   AS chapter,
  k.expenditure_type,
  LISTAGG(DISTINCT k.cc_string, ' | ') WITHIN GROUP (ORDER BY k.cc_string) AS gl_combination,
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
LEFT JOIN pb b  ON b.project_key = k.project_key
               AND NVL(b.task_key,'~')         = NVL(k.task_key,'~')
               AND NVL(b.expenditure_type,'~') = NVL(k.expenditure_type,'~')
LEFT JOIN proj pj ON TO_CHAR(pj.project_number) = k.project_key
LEFT JOIN tsk_org torg ON torg.task_number = k.task_key
LEFT JOIN ccmap cm ON cm.norm = UPPER(REGEXP_REPLACE(torg.task_organization,'[^A-Za-z0-9]',''))
LEFT JOIN acct ac ON ac.account_code = REGEXP_SUBSTR(k.expenditure_type,'^\d+')
LEFT JOIN approp_chap apc ON apc.appropriation_code = pj.appropriation
LEFT JOIN f_ap ap ON NVL(ap.cc_string,'~') = NVL(k.cc_string,'~')
                 AND ap.project_key = k.project_key
                 AND NVL(ap.task_key,'~')         = NVL(k.task_key,'~')
                 AND NVL(ap.expenditure_type,'~') = NVL(k.expenditure_type,'~')
LEFT JOIN f_grn grn ON NVL(grn.cc_string,'~') = NVL(k.cc_string,'~')
                 AND grn.project_key = k.project_key
                 AND NVL(grn.task_key,'~')         = NVL(k.task_key,'~')
                 AND NVL(grn.expenditure_type,'~') = NVL(k.expenditure_type,'~')
LEFT JOIN f_pr pr ON NVL(pr.cc_string,'~') = NVL(k.cc_string,'~')
                 AND pr.project_key = k.project_key
                 AND NVL(pr.task_key,'~')         = NVL(k.task_key,'~')
                 AND NVL(pr.expenditure_type,'~') = NVL(k.expenditure_type,'~')
LEFT JOIN f_po po ON NVL(po.cc_string,'~') = NVL(k.cc_string,'~')
                 AND po.project_key = k.project_key
                 AND NVL(po.task_key,'~')         = NVL(k.task_key,'~')
                 AND NVL(po.expenditure_type,'~') = NVL(k.expenditure_type,'~')
GROUP BY k.project_key, k.task_key, k.expenditure_type
HAVING MAX(NVL(b.budget,0)) > 0
ORDER BY 1, k.project_key, k.task_key, k.expenditure_type;
