-- =============================================================================
-- Reporting Platform -- MSS_BUTIL_REGISTER (MSS - Projects Budget Utilization)
-- File    : 46_rpt_mss_butil_register.sql
-- Run     : python-oracledb as ADMIN (or sql -name prod_mcp)
-- Purpose : a distribution copy of BUDGET_UTIL_REGISTER (reporting/db/25) for
--           the MSS audience, per the marked-up sample
--           docs/Reports/FMR/MSS Budget_Utilization_Register_2026.xlsx
--           (red fill = drop, green fill = new column):
--           sheet 1 = FIXED 26-column layout (Task Number KEPT + Task Name
--           added after it; Appropriation Code/Name, Dct Program Code/Name,
--           Ytd Budget, Budget Status and all 8 plan columns dropped; EBS
--           account, the vs-Budget pct/variance pair, Utilization Pct and the
--           Fund Movement pair kept). Sheets 2-6 gain a Requester column
--           (user decisions 2026-09-08): sheet 2 = the requester of the
--           invoice's MATCHED PO LINE (line-grain PO rule -- variance rows
--           resolve, genuinely direct rows stay blank; the Fusion AP header
--           requester is empty in practice, 1 of 11,900 in 2026); sheet 3/4 =
--           the PO distribution requestor (99.7 pct filled 2026); sheet 5 =
--           the PR requester (100 pct filled); sheet 6 = per pending doc
--           (PR line requester / PO line requestor). Sheets 4+5 also gain a
--           Task Name column (green). Surgery is done per SECTION -- each
--           section's SQL is pulled out with JSON_VALUE, patched with
--           asserted REPLACEs (a missing pattern RAISES, so db/25 drift fails
--           loudly, never silently drops a column) and written back with
--           JSON_TRANSFORM -- so the layout is baked into the DEFINITION and
--           holds on EVERY entry point. RE-RUN this script after any 25
--           re-run to refresh the copy. XLSX only. Launched from the GL
--           Budget Utilization page's Generate Report menu (bridge GL/db/53).
-- Idempotent: refreshes the copied columns on every run, then re-patches.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  l_n    NUMBER;
  l_sql  CLOB;
  l_desc VARCHAR2(1000);
  l_subj VARCHAR2(400);
  l_tnm  VARCHAR2(400);
  l_key  VARCHAR2(100);

  -- JSON path expressions must be literals -- one static SELECT per index
  FUNCTION getsql(p_idx PLS_INTEGER) RETURN CLOB IS
    l_c CLOB;
  BEGIN
    SELECT CASE p_idx
             WHEN 0 THEN JSON_VALUE(source_ref, '$.sections[0].sql' RETURNING CLOB)
             WHEN 1 THEN JSON_VALUE(source_ref, '$.sections[1].sql' RETURNING CLOB)
             WHEN 2 THEN JSON_VALUE(source_ref, '$.sections[2].sql' RETURNING CLOB)
             WHEN 3 THEN JSON_VALUE(source_ref, '$.sections[3].sql' RETURNING CLOB)
             WHEN 4 THEN JSON_VALUE(source_ref, '$.sections[4].sql' RETURNING CLOB)
             WHEN 5 THEN JSON_VALUE(source_ref, '$.sections[5].sql' RETURNING CLOB)
             WHEN 6 THEN JSON_VALUE(source_ref, '$.sections[6].sql' RETURNING CLOB)
             WHEN 7 THEN JSON_VALUE(source_ref, '$.sections[7].sql' RETURNING CLOB)
           END
      INTO l_c
      FROM prod.dct_rpt_definition
     WHERE report_code = 'MSS_BUTIL_REGISTER';
    RETURN l_c;
  END;

  FUNCTION keyof(p_idx PLS_INTEGER) RETURN VARCHAR2 IS
    l_k VARCHAR2(100);
  BEGIN
    SELECT CASE p_idx
             WHEN 0 THEN JSON_VALUE(source_ref, '$.sections[0].key')
             WHEN 1 THEN JSON_VALUE(source_ref, '$.sections[1].key')
             WHEN 2 THEN JSON_VALUE(source_ref, '$.sections[2].key')
             WHEN 3 THEN JSON_VALUE(source_ref, '$.sections[3].key')
             WHEN 4 THEN JSON_VALUE(source_ref, '$.sections[4].key')
             WHEN 5 THEN JSON_VALUE(source_ref, '$.sections[5].key')
             WHEN 6 THEN JSON_VALUE(source_ref, '$.sections[6].key')
             WHEN 7 THEN JSON_VALUE(source_ref, '$.sections[7].key')
           END
      INTO l_k
      FROM prod.dct_rpt_definition
     WHERE report_code = 'MSS_BUTIL_REGISTER';
    RETURN l_k;
  END;

  -- asserted patch: the pattern MUST be present exactly once conceptually --
  -- a miss means db/25 changed shape and this surgery needs a rework
  PROCEDURE rep(p_sql IN OUT NOCOPY CLOB, p_old VARCHAR2, p_new VARCHAR2, p_tag VARCHAR2) IS
    l_old VARCHAR2(32767) := REPLACE(p_old, '[COLON]', CHR(58));
    l_new VARCHAR2(32767) := REPLACE(p_new, '[COLON]', CHR(58));
  BEGIN
    IF INSTR(p_sql, l_old) = 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'MSS surgery pattern missing: ' || p_tag);
    END IF;
    p_sql := REPLACE(p_sql, l_old, l_new);
  END;

BEGIN
  l_desc := 'MSS - Projects Budget Utilization -- the Budget Utilization Register (Excel) re-issued for the MSS distribution: sheet 1 = FIXED 26-column layout (Task Number kept + Task Name added; appropriation/program, YTD budget, budget status and all plan columns dropped; EBS account, vs-Budget pct/variance, utilization pct and fund movement kept); sheets 2-6 gain a Requester column (AP = the matched PO line''s requester via the line-grain PO rule, GRN/PO = the PO distribution requestor, PR = the requisition requester, Pending = per document) and every sheet with a Task Number carries a Task Name beside it. Layout is baked into the definition -- re-run reporting/db/46 after any db/25 re-run to refresh the copy. XLSX only; run from the GL Budget Utilization page (Generate Report menu, bridge GL/db/53) or the BI catalog. Parameters mirror the GL Budget Utilization page filters (year required, rest optional).';
  l_subj := 'MSS - Projects Budget Utilization - {{ params.year }}{% if params.sector %} - {{ params.sector }}{% endif %}';
  l_tnm  := 'tnm AS (SELECT p.project_number AS tp, t.task_number AS tt, MAX(t.task_name) AS task_name FROM prod.atd_tasks t JOIN prod.atd_projects p ON p.project_id = t.project_id GROUP BY p.project_number, t.task_number), ';

  SELECT COUNT(*) INTO l_n
    FROM prod.dct_rpt_definition
   WHERE report_code = 'MSS_BUTIL_REGISTER';

  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_definition
      (report_code, name_en, name_ar, description, category,
       source_type, source_ref, engine, default_formats,
       email_subject_tpl, email_body_tpl,
       params_json, param_spec_json, enabled, created_by, updated_by)
    SELECT 'MSS_BUTIL_REGISTER',
           'MSS - Projects Budget Utilization',
           UNISTR('MSS - \0627\0633\062A\063A\0644\0627\0644 \0645\064A\0632\0627\0646\064A\0629 \0627\0644\0645\0634\0627\0631\064A\0639'),
           l_desc, category, source_type, source_ref, engine, 'XLSX',
           l_subj,
           REPLACE(email_body_tpl, 'Budget Utilization Register', 'MSS - Projects Budget Utilization report'),
           params_json, param_spec_json, 'Y', 'SEED', 'SEED'
      FROM prod.dct_rpt_definition
     WHERE report_code = 'BUDGET_UTIL_REGISTER';
  ELSE
    UPDATE prod.dct_rpt_definition
       SET (source_ref, params_json, param_spec_json, category, source_type, engine) =
           (SELECT source_ref, params_json, param_spec_json, category, source_type, engine
              FROM prod.dct_rpt_definition
             WHERE report_code = 'BUDGET_UTIL_REGISTER'),
           name_en           = 'MSS - Projects Budget Utilization',
           name_ar           = UNISTR('MSS - \0627\0633\062A\063A\0644\0627\0644 \0645\064A\0632\0627\0646\064A\0629 \0627\0644\0645\0634\0627\0631\064A\0639'),
           description       = l_desc,
           email_subject_tpl = l_subj,
           email_body_tpl    = (SELECT REPLACE(email_body_tpl, 'Budget Utilization Register', 'MSS - Projects Budget Utilization report')
                                  FROM prod.dct_rpt_definition
                                 WHERE report_code = 'BUDGET_UTIL_REGISTER'),
           default_formats   = 'XLSX',
           enabled           = 'Y',
           updated_by        = 'SEED',
           updated_at        = SYSTIMESTAMP
     WHERE report_code = 'MSS_BUTIL_REGISTER';
  END IF;

  FOR i IN 0 .. 7 LOOP
    l_key := keyof(i);
    IF l_key <> CASE i WHEN 0 THEN 'bu_lines' WHEN 1 THEN 'ap_lines'
                       WHEN 2 THEN 'grn_lines' WHEN 3 THEN 'open_po'
                       WHEN 4 THEN 'open_pr' WHEN 5 THEN 'pending'
                       WHEN 6 THEN 'comments' ELSE 'budget_trx' END THEN
      RAISE_APPLICATION_ERROR(-20001, 'MSS copy: sections[' || i || '] is ' || l_key);
    END IF;
  END LOOP;

  -- sheet 1: fixed 26-column projection over the copied bu_lines SQL (Task
  -- Number kept + Task Name; fund_movement_amount__pn keeps the sign tint)
  l_sql := getsql(0);
  IF INSTR(l_sql, 'MSS_FIXED_COLS') = 0 THEN
    l_sql := TO_CLOB('SELECT /* MSS_FIXED_COLS */ budget_combination, sector, department, cost_centre, project_number, project_name, task_number, task_name, account_number, ebs_account, chapter, expenditure_type, annual_budget, budget_utilization_pct, budget_variance, actual_ap, actual_grn, actual_total, commitment_pr, obligation_po, open_encumbrance, fund_available, utilization_pct, fund_movement_count, fund_movement_amount__pn, comments FROM (')
          || l_sql || TO_CLOB(')');
    UPDATE prod.dct_rpt_definition
       SET source_ref = JSON_TRANSFORM(source_ref, SET '$.sections[0].sql' = l_sql RETURNING CLOB)
     WHERE report_code = 'MSS_BUTIL_REGISTER';
  END IF;

  -- sheet 2 (ap_lines): Requester = the matched PO line's requestor via the
  -- LINE-GRAIN PO RULE (COALESCE(line po refs, dist po refs) -- the pk map is
  -- db/25's own linkage verbatim); cost-adjustment leg = NULL requester
  l_sql := getsql(1);
  IF INSTR(l_sql, 'MSS_ADD rqmap') = 0 THEN
    rep(l_sql,
        q'!WITH scope AS (SELECT /*+ MATERIALIZE */!',
        q'!WITH /* MSS_ADD rqmap */ rqmap AS (SELECT /*+ MATERIALIZE */ inv.invoice_number AS rq_inv, inv.invoice_date AS rq_date, LISTAGG(DISTINCT pod.requestor_name, ', ' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY pod.requestor_name) AS requester FROM prod.ap_invoice_distributions d JOIN (SELECT invoice_id, MAX(invoice_number) AS invoice_number, MAX(invoice_date) AS invoice_date FROM prod.ap_invoices GROUP BY invoice_id) inv ON inv.invoice_id = d.invoice_id LEFT JOIN (SELECT invoice_id, invoice_line_number, MAX(po_number) AS po_number, MAX(po_line_number) AS po_line_number, MAX(po_distribution) AS po_distribution FROM prod.ap_invoice_lines WHERE po_number IS NOT NULL GROUP BY invoice_id, invoice_line_number) lp ON lp.invoice_id = d.invoice_id AND lp.invoice_line_number = d.line_number JOIN (SELECT ph2.order_number AS po_number, pl2.line AS po_line, pod0.distribution_number AS po_dist_line, MAX(pod0.po_distribution_id) AS po_distribution_id FROM prod.po_distributions pod0 JOIN prod.po_lines pl2 ON pl2.po_header_id = pod0.po_header_id AND pl2.po_line_id = pod0.po_line_id JOIN prod.po_headers ph2 ON ph2.po_header_id = pod0.po_header_id GROUP BY ph2.order_number, pl2.line, pod0.distribution_number) pk ON pk.po_number = COALESCE(lp.po_number, d.po_number) AND pk.po_line = COALESCE(lp.po_line_number, d.po_line) AND pk.po_dist_line = COALESCE(lp.po_distribution, d.po_distribution_line) JOIN (SELECT po_distribution_id, MAX(requestor_name) AS requestor_name FROM prod.po_distributions GROUP BY po_distribution_id) pod ON pod.po_distribution_id = pk.po_distribution_id WHERE NVL(d.reversal_indicator,'N') <> 'Y' AND EXTRACT(YEAR FROM d.accounting_date) = [COLON]year AND pod.requestor_name IS NOT NULL GROUP BY inv.invoice_number, inv.invoice_date), !' || l_tnm || q'!scope AS (SELECT /*+ MATERIALIZE */!',
        'ap CTE');
    rep(l_sql,
        q'!sc.organization, x.project_number, x.project_name, x.task_number, x.expenditure_type, CASE WHEN ABS(NVL(x.matched_var_aed!',
        q'!sc.organization, rq.requester, x.project_number, x.project_name, x.task_number, tnm.task_name AS task_name, x.expenditure_type, CASE WHEN ABS(NVL(x.matched_var_aed!',
        'ap leg1 select');
    rep(l_sql,
        q'!FROM prod.dct_unpaid_invoices_v x!',
        q'!FROM prod.dct_unpaid_invoices_v x LEFT JOIN rqmap rq ON rq.rq_inv = x.invoice_number AND rq.rq_date = x.invoice_date LEFT JOIN tnm ON tnm.tp = x.project_number AND tnm.tt = x.task_number!',
        'ap leg1 join');
    rep(l_sql,
        q'!sc.organization, x.project_number, sc.project_name!',
        q'!sc.organization, NULL AS requester, x.project_number, sc.project_name!',
        'ap leg2 select');
    rep(l_sql,
        q'!sc.project_name, x.task_number, x.expenditure_type, 'Cost Adjustment' AS line_type!',
        q'!sc.project_name, x.task_number, tnm.task_name AS task_name, x.expenditure_type, 'Cost Adjustment' AS line_type!',
        'ap leg2 taskname');
    rep(l_sql,
        q'!) se ON se.invoice_id = x.invoice_id!',
        q'!) se ON se.invoice_id = x.invoice_id LEFT JOIN tnm ON tnm.tp = x.project_number AND tnm.tt = x.task_number!',
        'ap leg2 tnm join');
    UPDATE prod.dct_rpt_definition
       SET source_ref = JSON_TRANSFORM(source_ref, SET '$.sections[1].sql' = l_sql RETURNING CLOB)
     WHERE report_code = 'MSS_BUTIL_REGISTER';
  END IF;

  -- sheet 3 (grn_lines): Requester = the receipt's PO distribution requestor
  -- (the existing b map extended -- no new join)
  l_sql := getsql(2);
  IF INSTR(l_sql, 'MSS_ADD grnrq') = 0 THEN
    rep(l_sql,
        q'!WITH scope AS (SELECT /*+ MATERIALIZE */!',
        q'!WITH !' || l_tnm || q'!scope AS (SELECT /*+ MATERIALIZE */!',
        'grn tnm CTE');
    rep(l_sql,
        q'!,'~') WHERE x.project_number NOT LIKE '#%'!',
        q'!,'~') LEFT JOIN tnm ON tnm.tp = x.project_number AND tnm.tt = x.task_number WHERE x.project_number NOT LIKE '#%'!',
        'grn tnm join');
    rep(l_sql,
        q'!MAX(charge_account) AS charge_account FROM prod.po_distributions GROUP BY po_distribution_id) b!',
        q'!MAX(charge_account) AS charge_account, MAX(requestor_name) AS requestor_name /* MSS_ADD grnrq */ FROM prod.po_distributions GROUP BY po_distribution_id) b!',
        'grn b map');
    rep(l_sql,
        q'!TO_CHAR(pl.line) AS po_line, h.supplier_name!',
        q'!TO_CHAR(pl.line) AS po_line, b.requestor_name AS requester, h.supplier_name!',
        'grn inner expose');
    rep(l_sql,
        q'!sc.organization, x.project_number, x.project_name, x.task_number, x.expenditure_type, x.po_number!',
        q'!sc.organization, x.requester, x.project_number, x.project_name, x.task_number, tnm.task_name AS task_name, x.expenditure_type, x.po_number!',
        'grn outer select');
    UPDATE prod.dct_rpt_definition
       SET source_ref = JSON_TRANSFORM(source_ref, SET '$.sections[2].sql' = l_sql RETURNING CLOB)
     WHERE report_code = 'MSS_BUTIL_REGISTER';
  END IF;

  -- sheet 4 (open_po): Requester per (PO number, line) + Task Name
  l_sql := getsql(3);
  IF INSTR(l_sql, 'MSS_ADD porq') = 0 THEN
    rep(l_sql,
        q'!WITH scope AS (SELECT /*+ MATERIALIZE */!',
        q'!WITH /* MSS_ADD porq */ porq AS (SELECT /*+ MATERIALIZE */ TO_CHAR(ph.order_number) AS po_no, TO_CHAR(pl.line) AS po_ln, LISTAGG(DISTINCT pod.requestor_name, ', ' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY pod.requestor_name) AS requester FROM prod.po_distributions pod JOIN prod.po_lines pl ON pl.po_header_id = pod.po_header_id AND pl.po_line_id = pod.po_line_id JOIN prod.po_headers ph ON ph.po_header_id = pod.po_header_id WHERE pod.requestor_name IS NOT NULL GROUP BY ph.order_number, pl.line), !' || l_tnm || q'!scope AS (SELECT /*+ MATERIALIZE */!',
        'po CTE');
    rep(l_sql,
        q'!FROM prod.dct_open_po_lines_v x!',
        q'!FROM prod.dct_open_po_lines_v x LEFT JOIN porq rq ON rq.po_no = TO_CHAR(x.po_number) AND rq.po_ln = TO_CHAR(x.po_line) LEFT JOIN tnm ON tnm.tp = x.project_number AND tnm.tt = x.task_number!',
        'po joins');
    rep(l_sql,
        q'!sc.organization, x.project_number, x.project_name, x.task_number, x.expenditure_type, TO_CHAR(x.po_number) AS po_number!',
        q'!sc.organization, rq.requester, x.project_number, x.project_name, x.task_number, tnm.task_name AS task_name, x.expenditure_type, TO_CHAR(x.po_number) AS po_number!',
        'po select');
    UPDATE prod.dct_rpt_definition
       SET source_ref = JSON_TRANSFORM(source_ref, SET '$.sections[3].sql' = l_sql RETURNING CLOB)
     WHERE report_code = 'MSS_BUTIL_REGISTER';
  END IF;

  -- sheet 5 (open_pr): Requester per requisition (pr_distributions.requester,
  -- 100 pct filled) + Task Name
  l_sql := getsql(4);
  IF INSTR(l_sql, 'MSS_ADD prrq') = 0 THEN
    rep(l_sql,
        q'!WITH scope AS (SELECT /*+ MATERIALIZE */!',
        q'!WITH /* MSS_ADD prrq */ prrq AS (SELECT /*+ MATERIALIZE */ TO_CHAR(requisition) AS rq_no, LISTAGG(DISTINCT requester, ', ' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY requester) AS requester FROM prod.pr_distributions WHERE requester IS NOT NULL GROUP BY requisition), !' || l_tnm || q'!scope AS (SELECT /*+ MATERIALIZE */!',
        'pr CTE');
    rep(l_sql,
        q'!FROM prod.dct_reserved_pr_lines_v x!',
        q'!FROM prod.dct_reserved_pr_lines_v x LEFT JOIN prrq rq ON rq.rq_no = TO_CHAR(x.pr_number) LEFT JOIN tnm ON tnm.tp = x.project_number AND tnm.tt = x.task_number!',
        'pr joins');
    rep(l_sql,
        q'!sc.organization, x.project_number, x.project_name, x.task_number, x.expenditure_type, TO_CHAR(x.pr_number) AS pr_number!',
        q'!sc.organization, rq.requester, x.project_number, x.project_name, x.task_number, tnm.task_name AS task_name, x.expenditure_type, TO_CHAR(x.pr_number) AS pr_number!',
        'pr select');
    UPDATE prod.dct_rpt_definition
       SET source_ref = JSON_TRANSFORM(source_ref, SET '$.sections[4].sql' = l_sql RETURNING CLOB)
     WHERE report_code = 'MSS_BUTIL_REGISTER';
  END IF;

  -- sheet 6 (pend): Requester per pending document -- PR = the requisition
  -- line's requester (pr_lines), PO = the PO line's requestor (distributions)
  l_sql := getsql(5);
  IF INSTR(l_sql, 'MSS_ADD pendrq') = 0 THEN
    rep(l_sql,
        q'!WITH scope AS (SELECT /*+ MATERIALIZE */!',
        q'!WITH /* MSS_ADD pendrq */ pendrq AS (SELECT /*+ MATERIALIZE */ 'PR' AS src, TO_CHAR(requisition) AS doc_no, TO_CHAR(pr_line) AS doc_ln, MAX(requester_name) AS requester FROM prod.pr_lines WHERE requester_name IS NOT NULL GROUP BY requisition, pr_line UNION ALL SELECT 'PO', TO_CHAR(ph.order_number), TO_CHAR(pl.line), LISTAGG(DISTINCT pod.requestor_name, ', ' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY pod.requestor_name) FROM prod.po_distributions pod JOIN prod.po_lines pl ON pl.po_header_id = pod.po_header_id AND pl.po_line_id = pod.po_line_id JOIN prod.po_headers ph ON ph.po_header_id = pod.po_header_id WHERE pod.requestor_name IS NOT NULL GROUP BY ph.order_number, pl.line), !' || l_tnm || q'!scope AS (SELECT /*+ MATERIALIZE */!',
        'pend CTE');
    rep(l_sql,
        q'!LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = x.cc_string WHERE!',
        q'!LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = x.cc_string LEFT JOIN pendrq rq ON rq.src = x.source AND rq.doc_no = TO_CHAR(x.doc_number) AND rq.doc_ln = TO_CHAR(x.doc_line) LEFT JOIN tnm ON tnm.tp = x.project_number AND tnm.tt = x.task_number WHERE!',
        'pend join');
    rep(l_sql,
        q'!x.preparer_buyer, x.submitted_date!',
        q'!x.preparer_buyer, rq.requester, x.submitted_date!',
        'pend select');
    rep(l_sql,
        q'!x.project_number, x.project_name, x.task_number, x.expenditure_type, coa.sector_name!',
        q'!x.project_number, x.project_name, x.task_number, tnm.task_name AS task_name, x.expenditure_type, coa.sector_name!',
        'pend taskname');
    UPDATE prod.dct_rpt_definition
       SET source_ref = JSON_TRANSFORM(source_ref, SET '$.sections[5].sql' = l_sql RETURNING CLOB)
     WHERE report_code = 'MSS_BUTIL_REGISTER';
  END IF;

  -- sheet 7 (comments): Task Name after Task Number (comment rows at levels
  -- without a task simply carry NULL)
  l_sql := getsql(6);
  IF INSTR(l_sql, 'MSS_ADD cmttn') = 0 THEN
    rep(l_sql,
        q'!c.project_number, c.task_number, c.expenditure_type!',
        q'!c.project_number, c.task_number, tnm.task_name /* MSS_ADD cmttn */ AS task_name, c.expenditure_type!',
        'cmt taskname');
    rep(l_sql,
        q'!FROM prod.dct_gl_butil_comment c WHERE!',
        q'!FROM prod.dct_gl_butil_comment c LEFT JOIN (SELECT p.project_number AS tp, t.task_number AS tt, MAX(t.task_name) AS task_name FROM prod.atd_tasks t JOIN prod.atd_projects p ON p.project_id = t.project_id GROUP BY p.project_number, t.task_number) tnm ON tnm.tp = c.project_number AND tnm.tt = c.task_number WHERE!',
        'cmt tnm join');
    UPDATE prod.dct_rpt_definition
       SET source_ref = JSON_TRANSFORM(source_ref, SET '$.sections[6].sql' = l_sql RETURNING CLOB)
     WHERE report_code = 'MSS_BUTIL_REGISTER';
  END IF;

  -- sheet 8 (budget_trx): Task Name after Task Number -- the PBT line carries
  -- its OWN task_name (kept in the inner query since 2026-08-30); just expose
  l_sql := getsql(7);
  IF INSTR(l_sql, 'MSS_ADD bttn') = 0 THEN
    rep(l_sql,
        q'!x.project_number, x.project_name, x.task_number, x.expenditure_type, x.code_combination!',
        q'!x.project_number, x.project_name, x.task_number, x.task_name /* MSS_ADD bttn */, x.expenditure_type, x.code_combination!',
        'bt taskname');
    UPDATE prod.dct_rpt_definition
       SET source_ref = JSON_TRANSFORM(source_ref, SET '$.sections[7].sql' = l_sql RETURNING CLOB)
     WHERE report_code = 'MSS_BUTIL_REGISTER';
  END IF;

  -- SELF e-mail recipient, same as the register
  SELECT COUNT(*) INTO l_n
    FROM prod.dct_rpt_recipient
   WHERE report_code = 'MSS_BUTIL_REGISTER' AND recipient_type = 'SELF';
  IF l_n = 0 THEN
    INSERT INTO prod.dct_rpt_recipient
      (report_code, recipient_type, recipient_ref, channel, enabled, created_by, updated_by)
    VALUES
      ('MSS_BUTIL_REGISTER', 'SELF', NULL, 'EMAIL', 'Y', 'SEED', 'SEED');
  END IF;

  COMMIT;
  DBMS_OUTPUT.put_line('MSS_BUTIL_REGISTER upserted.');
END;
/

PROMPT === verify ===
SELECT report_code, name_en, source_type, engine, default_formats,
       CASE WHEN source_ref IS JSON THEN 'SRC OK' ELSE 'SRC BAD' END AS src_ok,
       DBMS_LOB.GETLENGTH(source_ref) AS src_len, enabled
  FROM prod.dct_rpt_definition
 WHERE report_code IN ('MSS_BUTIL_REGISTER', 'BUDGET_UTIL_REGISTER')
 ORDER BY report_code;

SELECT CASE WHEN INSTR(source_ref, 'MSS_FIXED_COLS') > 0 THEN 'S1 OK' ELSE 'S1 MISSING' END AS s1,
       CASE WHEN INSTR(source_ref, 'MSS_ADD rqmap') > 0 THEN 'S2 OK' ELSE 'S2 MISSING' END AS s2,
       CASE WHEN INSTR(source_ref, 'MSS_ADD grnrq') > 0 THEN 'S3 OK' ELSE 'S3 MISSING' END AS s3,
       CASE WHEN INSTR(source_ref, 'MSS_ADD porq') > 0 THEN 'S4 OK' ELSE 'S4 MISSING' END AS s4,
       CASE WHEN INSTR(source_ref, 'MSS_ADD prrq') > 0 THEN 'S5 OK' ELSE 'S5 MISSING' END AS s5,
       CASE WHEN INSTR(source_ref, 'MSS_ADD pendrq') > 0 THEN 'S6 OK' ELSE 'S6 MISSING' END AS s6,
       CASE WHEN INSTR(source_ref, 'MSS_ADD cmttn') > 0 THEN 'S7 OK' ELSE 'S7 MISSING' END AS s7,
       CASE WHEN INSTR(source_ref, 'MSS_ADD bttn') > 0 THEN 'S8 OK' ELSE 'S8 MISSING' END AS s8
  FROM prod.dct_rpt_definition
 WHERE report_code = 'MSS_BUTIL_REGISTER';

PROMPT MSS_BUTIL_REGISTER definition seeded (copy of BUDGET_UTIL_REGISTER, MSS layout + Requester columns).
