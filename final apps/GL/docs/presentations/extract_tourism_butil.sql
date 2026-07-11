SET DEFINE OFF
SET SQLBLANKLINES ON
SET PAGESIZE 50000
SET LINESIZE 500
SET FEEDBACK OFF
SET SQLFORMAT csv

SPOOL c:\tmp\ppt_sector_check.csv
SELECT sector, COUNT(*) AS rows_n, ROUND(SUM(budget)/1e6,2) AS budget_m
FROM prod.dct_budget_utilization_v WHERE budget_year=2026 GROUP BY sector ORDER BY 3 DESC;
SPOOL OFF

SPOOL c:\tmp\ppt_totals.csv
SELECT COUNT(*) AS lines_n,
       COUNT(DISTINCT project_number) AS projects_n,
       COUNT(DISTINCT cost_centre)    AS cc_n,
       ROUND(SUM(budget),2)        AS budget,
       ROUND(SUM(actual_ap),2)     AS actual_ap,
       ROUND(SUM(actual_grn),2)    AS actual_grn,
       ROUND(SUM(commitment_pr),2) AS open_pr,
       ROUND(SUM(obligation_po),2) AS open_po,
       ROUND(SUM(fund_available),2) AS fund_available
FROM prod.dct_budget_utilization_v
WHERE budget_year=2026 AND sector='Tourism';
SPOOL OFF


SPOOL c:\tmp\ppt_mom_ap.csv
WITH kys AS (
  SELECT v.project_number pk, NVL(v.task_number,'~') tk, NVL(v.expenditure_type,'~') et,
         v.cost_centre cc
  FROM prod.dct_budget_utilization_v v
  WHERE v.budget_year = 2026 AND v.sector = 'Tourism'
),
proj AS (SELECT project_id, MAX(project_number) project_number FROM prod.projects GROUP BY project_id),
tsk  AS (SELECT task_id, MAX(task_number) task_number FROM prod.tasks GROUP BY task_id)
SELECT TO_CHAR(d.accounting_date,'YYYY-MM') AS mth, k.cc,
       ROUND(SUM(NVL(d.distribution_amount_functi, d.distribution_amount)),2) AS ap_aed
FROM prod.ap_invoice_distributions d
JOIN prod.ap_invoices i ON i.invoice_id = d.invoice_id
LEFT JOIN proj pj ON pj.project_id = d.project_id
LEFT JOIN tsk  tk ON tk.task_id    = d.task_id
JOIN kys k ON k.pk = COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(d.project_id))
          AND k.tk = NVL(COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END),'~')
          AND k.et = NVL(d.expenditure_type,'~')
WHERE d.po_number IS NULL AND NVL(d.reversal_indicator,'N') <> 'Y' AND d.project_id IS NOT NULL
  AND i.validation_status IN ('Validated','Unpaid','Available')
  AND EXTRACT(YEAR FROM d.accounting_date) = 2026
GROUP BY TO_CHAR(d.accounting_date,'YYYY-MM'), k.cc
ORDER BY 1, 2;
SPOOL OFF

SPOOL c:\tmp\ppt_mom_grn.csv
WITH kys AS (
  SELECT v.project_number pk, NVL(v.task_number,'~') tk, NVL(v.expenditure_type,'~') et,
         v.cost_centre cc
  FROM prod.dct_budget_utilization_v v
  WHERE v.budget_year = 2026 AND v.sector = 'Tourism'
),
proj AS (SELECT project_id, MAX(project_number) project_number FROM prod.projects GROUP BY project_id),
tsk  AS (SELECT task_id, MAX(task_number) task_number FROM prod.tasks GROUP BY task_id),
po_dist AS (SELECT po_distribution_id, MAX(charge_account) charge_account FROM prod.po_distributions GROUP BY po_distribution_id)
SELECT TO_CHAR(g.transaction_date,'YYYY-MM') AS mth, k.cc,
       ROUND(SUM(g.ledger_amount),2) AS grn_aed
FROM prod.grn_all_v2 g
JOIN po_dist pod ON pod.po_distribution_id = g.po_distribution_id
LEFT JOIN proj pj ON pj.project_id = g.project_id
LEFT JOIN tsk  tk ON tk.task_id    = g.task_id
JOIN kys k ON k.pk = COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(g.project_id))
          AND k.tk = NVL(COALESCE(tk.task_number, CASE WHEN g.task_id IS NOT NULL THEN '#'||TO_CHAR(g.task_id) END),'~')
          AND k.et = NVL(g.expenditure_type,'~')
WHERE g.project_id IS NOT NULL AND pod.charge_account IS NOT NULL
  AND EXTRACT(YEAR FROM g.transaction_date) = 2026
GROUP BY TO_CHAR(g.transaction_date,'YYYY-MM'), k.cc
ORDER BY 1, 2;
SPOOL OFF

SPOOL c:\tmp\ppt_top_projects.csv
SELECT * FROM (
  SELECT cost_centre, project_number, MAX(project_name) AS project_name,
         ROUND(SUM(budget),2) AS budget,
         ROUND(SUM(actual_ap)+SUM(actual_grn),2) AS actual,
         ROUND(SUM(commitment_pr)+SUM(obligation_po),2) AS committed,
         ROUND(SUM(fund_available),2) AS fund_available,
         ROW_NUMBER() OVER (PARTITION BY cost_centre ORDER BY SUM(budget) DESC) AS rn
  FROM prod.dct_budget_utilization_v
  WHERE budget_year=2026 AND sector='Tourism'
  GROUP BY cost_centre, project_number
) WHERE rn <= 5
ORDER BY cost_centre, rn;
SPOOL OFF

EXIT

-- per-CC summary (MATERIALIZE needed: grouping the view merged raises ORA-00935)
SPOOL c:\tmp\ppt_by_cc.csv
WITH t AS (
  SELECT /*+ MATERIALIZE */ cost_centre, department, project_number, budget,
         actual_ap, actual_grn, commitment_pr, obligation_po, fund_available
  FROM prod.dct_budget_utilization_v
  WHERE budget_year=2026 AND sector='Tourism'
)
SELECT cost_centre, MAX(department) AS department,
       COUNT(DISTINCT project_number) AS projects_n,
       ROUND(SUM(budget),2)        AS budget,
       ROUND(SUM(actual_ap),2)     AS actual_ap,
       ROUND(SUM(actual_grn),2)    AS actual_grn,
       ROUND(SUM(commitment_pr),2) AS open_pr,
       ROUND(SUM(obligation_po),2) AS open_po,
       ROUND(SUM(fund_available),2) AS fund_available
FROM t
GROUP BY cost_centre
ORDER BY 4 DESC;
SPOOL OFF
