-- =============================================================================
-- Budget Utilization -- cost-adjustment DRILL rows (ADDITIVE)
-- File    : 29_gl_costadj_drill_ords.sql   App 210 / GL        2026-08-26
-- Adds to : gl.rest -- ONE new template butil/lines/costadj (3 segments, so it
--           can never collide with butil/lines)
-- Run     : sql -name prod_mcp @29_gl_costadj_drill_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql rebuilds gl.rest from scratch -- the GL post-05
--            re-run list is now 07..29.
--
-- WHY: /gl/butil ships figures ALREADY ADJUSTED by the approved Projects
-- Costing Adjustments (GL/db/25, costadj=Y default): Actual +Σamount_aed,
-- Budget +Σbudget_override. The /butil/lines drill shows only the REAL
-- AP/budget rows, so a drilled line with an adjustment did not reconcile to
-- the on-screen figure (user report 2026-08-26, sample project 4511000981:
-- PCA-00018 +2,368,623 on Actual was invisible in the AP drill).
--
-- WHAT: GET /gl/butil/lines/costadj -- the APPROVED adjustment rows for the
-- same scope the drill was opened with, shaped to append STRAIGHT into the
-- corresponding drill table (the frontend merges rows + adds the total):
--   metric=ap            -> amount_aed rows. Since 2026-08-27 the row shows
--                           the REFERENCED invoice distribution EXACTLY as
--                           the plain drill would (number w/ Fusion deep-link
--                           via invoiceId, line, invoice date, vendor,
--                           currency, header amount, real validation/payment
--                           statuses, the distribution's own description via
--                           AP_INVOICE_DISTRIBUTIONS_V); the amount column
--                           keeps the ADJUSTMENT figure and fromAdj='Y' +
--                           adjRef drive the client's (**) source marker.
--                           No invoice reference -> PCA-shaped row.
--   metric=budget        -> budget_override rows, YTD period rule
--   metric=budgetannual  -> budget_override rows, no period cut
-- Period rule mirrors DCT_PA_COST_ADJ_BUTIL_V exactly: a NULL accounting
-- period ALWAYS counts; MM-YYYY counts when on/before the YTD end month.
-- Row mode (project given) and aggregate mode (kys CTE over the butil key
-- cache incl. the SECTOR data scope) are copied verbatim from butil/lines so
-- the two requests always cover the same key set.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_cadrill_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';

BEGIN

    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => 'butil/lines/costadj');
    ORDS.DEFINE_HANDLER(
        p_module_name => c_mod,
        p_pattern     => 'butil/lines/costadj',
        p_method      => 'GET',
        p_source_type => ORDS.source_type_plsql,
        p_source      => REPLACE(q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_uid     NUMBER := dct_auth.get_user_id(l_user);
  l_secok   NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year    NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_metric  VARCHAR2(20)  := LOWER(NVL([COLON]metric,'ap'));
  l_project VARCHAR2(120) := [COLON]project;
  l_task    VARCHAR2(120) := [COLON]task;
  l_etype   VARCHAR2(255) := [COLON]etype;
  l_ptype   VARCHAR2(1000) := [COLON]projecttype;
  l_sector  VARCHAR2(200) := [COLON]sector;
  l_chapter VARCHAR2(2000) := [COLON]chapter;
  l_bu      VARCHAR2(2000) := [COLON]bu;
  l_approp  VARCHAR2(2000) := [COLON]appropriation;
  l_program VARCHAR2(2000) := [COLON]program;
  l_cc      VARCHAR2(2000) := [COLON]costcenter;
  l_fproj   VARCHAR2(2000) := [COLON]fproject;
  l_ftask   VARCHAR2(200) := [COLON]ftask;
  l_fetype  VARCHAR2(255) := [COLON]fetype;
  l_search  VARCHAR2(200) := [COLON]search;
  l_period  VARCHAR2(10)  := [COLON]period;
  l_end     DATE;
  l_total   NUMBER := 0;
  l_count   NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_metric NOT IN ('ap','budget','budgetannual') THEN
    dct_rest.err(400,'metric must be ap, budget or budgetannual'); RETURN;
  END IF;
  IF l_project = '' THEN l_project := NULL; END IF;
  IF l_task    = '' THEN l_task    := NULL; END IF;
  IF l_etype   = '' THEN l_etype   := NULL; END IF;
  IF l_ptype   = '' THEN l_ptype   := NULL; END IF;
  IF l_sector  = '' THEN l_sector  := NULL; END IF;
  IF l_chapter = '' THEN l_chapter := NULL; END IF;
  IF l_bu      = '' THEN l_bu      := NULL; END IF;
  IF l_approp  = '' THEN l_approp  := NULL; END IF;
  IF l_program = '' THEN l_program := NULL; END IF;
  IF l_cc      = '' THEN l_cc      := NULL; END IF;
  IF l_fproj   = '' THEN l_fproj   := NULL; END IF;
  IF l_ftask   = '' THEN l_ftask   := NULL; END IF;
  IF l_fetype  = '' THEN l_fetype  := NULL; END IF;
  IF l_search  = '' THEN l_search  := NULL; END IF;
  IF l_period  = '' THEN l_period  := NULL; END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
  END IF;
  -- the annual-budget drill ignores the period window, like butil/lines
  IF l_metric = 'budgetannual' THEN l_end := NULL; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('metric', l_metric);
  APEX_JSON.open_array('rows');
  FOR r IN (
    WITH kys AS (
           SELECT CAST(l_project AS VARCHAR2(120)) pk, NVL(l_task,'~') tk, NVL(l_etype,'~') et FROM dual WHERE l_project IS NOT NULL
           UNION ALL
           SELECT v.project_number, NVL(v.task_number,'~'), NVL(v.expenditure_type,'~') FROM prod.dct_butil_key_cache v
           WHERE l_project IS NULL AND v.budget_year = l_year
             AND (l_ptype  IS NULL OR INSTR('|'||l_ptype||'|', '|'||v.project_type||'|') > 0)
             AND (l_sector IS NULL OR v.sector = l_sector)
   AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
             AND (l_chapter IS NULL OR INSTR('|'||l_chapter||'|', '|'||v.chapter||'|') > 0)
             AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||v.business_unit||'|') > 0)
             AND (l_approp  IS NULL OR INSTR('|'||l_approp||'|', '|'||v.appropriation||'|') > 0)
             AND (l_program IS NULL OR INSTR('|'||l_program||'|', '|'||v.program||'|') > 0)
             AND (l_cc     IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                                   OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
             AND (l_fproj  IS NULL OR (INSTR(l_fproj,'|') = 0 AND UPPER(v.project_number||' '||v.project_name) LIKE '%'||UPPER(l_fproj)||'%')
                                   OR INSTR('|'||l_fproj||'|', '|'||v.project_number||'|') > 0)
             AND (l_ftask  IS NULL OR UPPER(v.task_number) LIKE '%'||UPPER(l_ftask)||'%')
             AND (l_fetype IS NULL OR UPPER(v.expenditure_type) LIKE '%'||UPPER(l_fetype)||'%')
             AND (l_search IS NULL OR UPPER(v.project_number||' '||v.project_name||' '||v.task_number||' '||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%'))
    SELECT a.adj_ref, a.project_number, a.task_number, a.expenditure_type,
           a.accounting_period, a.invoice_number, a.invoice_line_number,
           a.supplier_name, a.classification, a.reason, a.invoice_id,
           i.invoice_number AS ref_inv_number,
           TO_CHAR(i.invoice_date,'YYYY-MM-DD') AS ref_inv_date,
           NVL(i.invoice_currency,'AED') AS ref_cur,
           i.invoice_amount AS ref_inv_amt,
           i.validation_status AS ref_val,
           CASE WHEN NVL(i.invoice_amount,0) = 0 THEN NULL
                WHEN ABS(NVL(i.invoice_amount_paid,0)) >= ABS(NVL(i.invoice_amount,0)) - 0.005 THEN 'Paid'
                WHEN NVL(i.invoice_amount_paid,0) <> 0 THEN 'Partially Paid'
                ELSE 'Unpaid' END AS ref_pay,
           se.supplier_name AS ref_vendor,
           dv.dv_date, dv.dv_cur, dv.dv_val, dv.dv_pay, dv.dv_vendor, dv.dv_descr,
           NVL(a.approved_by, a.updated_by) actor,
           TO_CHAR(dct_to_local(NVL(a.approved_at, a.updated_at)),'YYYY-MM-DD') actioned,
           CASE WHEN l_metric = 'ap' THEN a.amount_aed ELSE NVL(a.budget_override,0) END amt,
           COUNT(*) OVER () full_n,
           SUM(CASE WHEN l_metric = 'ap' THEN a.amount_aed ELSE NVL(a.budget_override,0) END) OVER () full_tot
    FROM prod.dct_pa_cost_adj a
    LEFT JOIN prod.ap_invoices i             ON i.invoice_id = a.invoice_id
    LEFT JOIN prod.dct_ap_supplier_eff_v se  ON se.invoice_id = a.invoice_id
    LEFT JOIN (SELECT invoice_id, invoice_line_number, distribution_line_number,
                      TO_CHAR(invoice_date,'YYYY-MM-DD') AS dv_date,
                      invoice_currency AS dv_cur,
                      validation_status AS dv_val,
                      payment_status AS dv_pay,
                      COALESCE(beneficiary_name, supplier_name) AS dv_vendor,
                      distribution_description AS dv_descr,
                      ROW_NUMBER() OVER (PARTITION BY invoice_id, invoice_line_number
                                         ORDER BY distribution_line_number) AS rn
                 FROM prod.ap_invoice_distributions_v) dv
           ON dv.invoice_id = a.invoice_id
          AND dv.invoice_line_number = a.invoice_line_number
          AND (dv.distribution_line_number = a.dist_line_number
               OR (a.dist_line_number IS NULL AND dv.rn = 1))
    WHERE a.status = 'APPROVED'
      AND a.budget_year = l_year
      AND (a.project_number, NVL(a.task_number,'~'), NVL(a.expenditure_type,'~'))
          IN (SELECT pk, tk, et FROM kys)
      AND (l_end IS NULL OR a.accounting_period IS NULL
           OR TO_DATE('01-'||a.accounting_period, 'DD-MM-YYYY') <= l_end)
      AND CASE WHEN l_metric = 'ap' THEN a.amount_aed ELSE NVL(a.budget_override,0) END <> 0
    ORDER BY ABS(CASE WHEN l_metric = 'ap' THEN a.amount_aed ELSE NVL(a.budget_override,0) END) DESC
    FETCH FIRST 1000 ROWS ONLY
  ) LOOP
    l_count := r.full_n; l_total := r.full_tot;
    APEX_JSON.open_object;
    -- aggregate-mode identity columns (ignored by the row drill's column set)
    APEX_JSON.write('project', NVL(r.project_number,''));
    APEX_JSON.write('task', NVL(r.task_number,''));
    APEX_JSON.write('etype', NVL(r.expenditure_type,''));
    IF l_metric = 'ap' THEN
      -- AP-drill column shape. The row shows the REFERENCED INVOICE
      -- DISTRIBUTION exactly as the plain drill would (number w/ Fusion
      -- deep-link, line, invoice date, vendor, currency, header amount, REAL
      -- validation / payment statuses, the distribution's own description --
      -- user feedback 2026-08-27); the Distribution (AED) column keeps the
      -- ADJUSTMENT amount so the drawer total still reconciles, and
      -- fromAdj='Y' + adjRef let the client render the (**) source marker.
      -- An adjustment with no invoice reference keeps the PCA-shaped row.
      APEX_JSON.write('invoice', COALESCE(r.ref_inv_number, r.invoice_number, r.adj_ref));
      APEX_JSON.write('invoiceId', r.invoice_id);
      APEX_JSON.write('line', NVL(TO_CHAR(r.invoice_line_number),''));
      APEX_JSON.write('date', COALESCE(r.dv_date, r.ref_inv_date, r.accounting_period, ''));
      APEX_JSON.write('vendor', COALESCE(r.dv_vendor, r.ref_vendor, r.supplier_name, ''));
      APEX_JSON.write('currency', COALESCE(r.dv_cur, r.ref_cur, 'AED'));
      APEX_JSON.write('invAmount', r.ref_inv_amt);
      APEX_JSON.write('amount', r.amt);
      APEX_JSON.write('validation', COALESCE(r.dv_val, r.ref_val, 'Cost Adjustment'));
      APEX_JSON.write('payment', COALESCE(r.dv_pay, r.ref_pay,
                                          INITCAP(REPLACE(NVL(r.classification,''), '_', ' '))));
      APEX_JSON.write('description', COALESCE(r.dv_descr, r.reason, ''));
      APEX_JSON.write('fromAdj', 'Y');
      APEX_JSON.write('adjRef', r.adj_ref);
    ELSE
      -- budget-drill column shape: the PCA reference in the period cell marks
      -- the row; the signed override rides the Budget (amount) column so the
      -- visible column sum ties to the adjusted YTD/annual budget figure
      APEX_JSON.write('period', r.adj_ref
        || CASE WHEN r.accounting_period IS NOT NULL THEN ' - ' || r.accounting_period END);
      APEX_JSON.write('amount', r.amt);
      APEX_JSON.write('override', '');
      APEX_JSON.write('updatedBy', NVL(r.actor,''));
      APEX_JSON.write('updated', NVL(r.actioned,''));
    END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('total', l_total);
  APEX_JSON.write('count', l_count);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!', '[COLON]', CHR(58)));

END;
/

BEGIN
    setup_gl_cadrill_ords_tmp;
    COMMIT;
END;
/
DROP PROCEDURE setup_gl_cadrill_ords_tmp;

PROMPT === verify ===
SELECT t.uri_template, h.method, LENGTH(h.source) src_len
FROM user_ords_handlers h
JOIN user_ords_templates t ON t.id = h.template_id
JOIN user_ords_modules m  ON m.id = t.module_id
WHERE m.name = 'gl.rest' AND t.uri_template = 'butil/lines/costadj';

PROMPT gl.rest butil/lines/costadj published (cost-adjustment drill rows).
