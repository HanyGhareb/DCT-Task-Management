-- =============================================================================
-- General Ledger (App 210) -- Projects Encumbrances follow-up (ADDITIVE)
-- File    : 12_gl_encumbrances_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @12_gl_encumbrances_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07 + 08 + 09 + 10 + 11 + THIS script right after it.
-- Purpose : "Open Projects Encumbrance Follow-up" report -- every OPEN
--           encumbrance line (Open Commitment PR + Open Obligation PO) for the
--           budget lines matching the Budget Utilization page filters, exploded
--           to the FULL GL combination (all 10 segments, code + description).
--           Feeds the GL app's "Projects Encumbrances" tab, which mounts the
--           SHARED <interactive-report> component over a one-shot capped fetch.
-- Scope   : IDENTICAL to the GL Budget Utilization page -- the key-set CTE is
--           lifted verbatim from /gl/butil/lines (aggregate mode). Amounts are
--           OPEN/GRN-netted (PR reserved, PO GRN-netted open) so SUM(openAed)
--           reconciles to the page's Total Encumbrance (Commitment PR +
--           Obligation PO). Zero-amount lines excluded.
-- Endpoint:
--   GET /gl/encumbrances?year(req)=&period=&projecttype=&sector=&chapter=
--                        &costcenter=&project=&task=&etype=&search=&limit=
--       -> { total, count, totals{openAed}, columns[{key,label,type}], items[] }
--          items carry: source PO/PR, doc #/line, vendor/description, project/
--          task/etype, budget date, currency, line & open AED, the canonical
--          GL combination + all 10 segment codes & names + sector/chapter names.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_enc_ords_tmp AS

    c_mod CONSTANT VARCHAR2(30) := 'gl.rest';

    PROCEDURE def_template(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;

    PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => p_method,
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;

BEGIN

    def_template('encumbrances');
    def_handler('encumbrances', 'GET', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year    NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_ptype   VARCHAR2(100) := [COLON]projecttype;
  l_sector  VARCHAR2(200) := [COLON]sector;
  l_chapter VARCHAR2(2000) := [COLON]chapter;
  l_bu      VARCHAR2(2000) := [COLON]bu;
  l_cc      VARCHAR2(2000) := [COLON]costcenter;
  l_proj    VARCHAR2(2000) := [COLON]project;
  l_task    VARCHAR2(200) := [COLON]task;
  l_etype   VARCHAR2(255) := [COLON]etype;
  l_search  VARCHAR2(200) := [COLON]search;
  l_period  VARCHAR2(10)  := [COLON]period;
  l_end     DATE;
  l_limit   NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 10000), 10000);
  l_total   NUMBER := 0;
  l_count   NUMBER := 0;
  PROCEDURE col(p_key VARCHAR2, p_label VARCHAR2, p_type VARCHAR2) IS
  BEGIN
    APEX_JSON.open_object; APEX_JSON.write('key',p_key); APEX_JSON.write('label',p_label); APEX_JSON.write('type',p_type); APEX_JSON.close_object;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_ENCUMBRANCES', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_ENCUMBRANCES required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_ptype   = '' THEN l_ptype   := NULL; END IF;
  IF l_sector  = '' THEN l_sector  := NULL; END IF;
  IF l_chapter = '' THEN l_chapter := NULL; END IF;
  IF l_bu = '' THEN l_bu := NULL; END IF;
  IF l_cc      = '' THEN l_cc      := NULL; END IF;
  IF l_proj    = '' THEN l_proj    := NULL; END IF;
  IF l_task    = '' THEN l_task    := NULL; END IF;
  IF l_etype   = '' THEN l_etype   := NULL; END IF;
  IF l_search  = '' THEN l_search  := NULL; END IF;
  IF l_period  = '' THEN l_period  := NULL; END IF;
  -- YTD period end (MM-YYYY within the year), same window the butil page uses
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
  END IF;

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;

  -- server-defined column set (the IR grid renders exactly these, in THIS order;
  -- a returning user's saved localStorage layout overrides it -> Reset re-applies).
  -- Order (2026-07-15, user-confirmed layout): identification (sector/chapter/
  -- project/task/etype) -> document + amounts -> GL combination -> the four
  -- meaningful segments (program/cost centre/account/appropriation, code+name)
  -- -> the remaining segments (entity/budget group/entity specific/intercompany/
  -- future 1/future 2).
  APEX_JSON.open_array('columns');
  col('sector','Sector','text');
  col('chapter','Chapter','text');
  col('projectName','Project name','text');
  col('projectNumber','Project #','text');
  col('task','Task','text');
  col('expenditureType','Expenditure type','text');
  col('source','Source','text');
  col('docNumber','Document #','text');
  col('docLine','Line','text');
  col('description','Description / Vendor','text');
  col('budgetDate','Budget date','date');
  col('currency','Cur','text');
  col('lineAmount','Line amount (AED)','money');
  col('openAmount','Open / Reserved (AED)','money');
  col('combination','GL combination','text');
  col('programCode','Program','text');          col('programName','Program name','text');
  col('costCenterCode','Cost centre','text');   col('costCenterName','Cost centre name','text');
  col('accountCode','Account','text');          col('accountName','Account name','text');
  col('appropriationCode','Appropriation','text');    col('appropriationName','Appropriation name','text');
  col('entityCode','Entity','text');            col('entityName','Entity name','text');
  col('budgetGroupCode','Budget group','text'); col('budgetGroupName','Budget group name','text');
  col('entitySpecificCode','Entity specific','text'); col('entitySpecificName','Entity specific name','text');
  col('intercompanyCode','Intercompany','text');      col('intercompanyName','Intercompany name','text');
  col('future1Code','Future 1','text');         col('future1Name','Future 1 name','text');
  col('future2Code','Future 2','text');         col('future2Name','Future 2 name','text');
  APEX_JSON.close_array;

  APEX_JSON.open_array('items');
  FOR r IN (
    WITH kys AS (
      SELECT v.project_number pk, NVL(v.task_number,'~') tk, NVL(v.expenditure_type,'~') et
      FROM prod.dct_budget_utilization_v v
      WHERE v.budget_year = l_year
        AND (l_ptype   IS NULL OR v.project_type = l_ptype)
        AND (l_sector  IS NULL OR v.sector = l_sector)
     AND (l_secok = 1 OR v.sector IN (SELECT cv.name_en FROM prod.dct_gl_class_value cv JOIN prod.v_dct_sec_user_scope sc ON sc.object_key = cv.value_code AND sc.object_type_code = 'SECTOR' AND sc.user_id = l_uid WHERE cv.class_type_code = 'SECTOR'))
        AND (l_chapter IS NULL OR INSTR('|'||l_chapter||'|', '|'||v.chapter||'|') > 0)
        AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||v.business_unit||'|') > 0)
        AND (l_cc      IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                               OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
        AND (l_proj    IS NULL OR (INSTR(l_proj,'|') = 0 AND UPPER(v.project_number||' '||v.project_name) LIKE '%'||UPPER(l_proj)||'%')
                               OR INSTR('|'||l_proj||'|', '|'||v.project_number||'|') > 0)
        AND (l_task    IS NULL OR UPPER(v.task_number) LIKE '%'||UPPER(l_task)||'%')
        AND (l_etype   IS NULL OR UPPER(v.expenditure_type) LIKE '%'||UPPER(l_etype)||'%')
        AND (l_search  IS NULL OR UPPER(v.project_number||' '||v.project_name||' '||v.task_number||' '||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%')
    ),
    proj AS (SELECT project_id, MAX(project_number) project_number, MAX(project_name) project_name FROM prod.projects GROUP BY project_id),
    tsk  AS (SELECT task_id, MAX(task_number) task_number FROM prod.tasks GROUP BY task_id),
    prl  AS (SELECT pr_line_id, MAX(pr_line) pr_line FROM prod.pr_lines GROUP BY pr_line_id),
    po_dist AS (
      SELECT po_distribution_id, prod.dct_cc_canon(MAX(charge_account)) charge_account,
             MAX(po_header_id) po_header_id, MAX(po_line_id) po_line_id,
             MAX(project_id) project_id, MAX(task_id) task_id,
             MAX(expenditure_type_name) expenditure_type, MAX(budget_date) budget_date,
             MAX(distribution_amount * NVL(rate,1)) amt_aed, MAX(funds_status) funds_status
      FROM prod.po_distributions GROUP BY po_distribution_id),
    grn_per_dist AS (
      SELECT po_distribution_id, SUM(ledger_amount) grn_aed FROM prod.grn_all_v2
      WHERE (l_end IS NULL OR NVL(accounted_date, transaction_date) < l_end + 1)
      GROUP BY po_distribution_id),
    po_hdr AS (SELECT po_header_id, MAX(order_number) order_number, MAX(supplier_name) supplier_name, MAX(status) po_status FROM prod.po_headers GROUP BY po_header_id),
    po_lin AS (SELECT po_header_id, po_line_id, MAX(line) line FROM prod.po_lines GROUP BY po_header_id, po_line_id),
    enc AS (
      -- Open Commitment -- reserved PR distributions
      SELECT 'PR' source,
             TO_CHAR(d.requisition) doc_number, TO_CHAR(pl.pr_line) doc_line,
             h.description descr,
             COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(d.project_id)) project_number,
             pj.project_name,
             COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END) task_number,
             d.expenditure_type,
             d.budget_date, NVL(d.currency_code,'AED') currency,
             d.distribution_amount * NVL(cc.exchange_rate_to_aed,1) line_aed,
             d.distribution_amount * NVL(cc.exchange_rate_to_aed,1) open_aed,
             prod.dct_cc_canon(d.charge_account) cc_string
      FROM prod.pr_distributions d
      LEFT JOIN (SELECT pr_header_id, MAX(description) description FROM prod.pr_headers GROUP BY pr_header_id) h ON h.pr_header_id = d.pr_header_id
      LEFT JOIN prod.dct_currency_codes cc ON cc.currency_code = d.currency_code
      LEFT JOIN prl pl ON pl.pr_line_id = d.pr_line_id
      LEFT JOIN proj pj ON pj.project_id = d.project_id
      LEFT JOIN tsk  tk ON tk.task_id    = d.task_id
      WHERE d.funds_status = 'Reserved' AND d.project_id IS NOT NULL AND d.charge_account IS NOT NULL
        AND NVL(d.distribution_amount * NVL(cc.exchange_rate_to_aed,1),0) <> 0
        AND EXTRACT(YEAR FROM d.budget_date) = l_year
        AND (l_end IS NULL OR d.budget_date < l_end + 1)
        AND (COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(d.project_id)),
             NVL(COALESCE(tk.task_number, CASE WHEN d.task_id IS NOT NULL THEN '#'||TO_CHAR(d.task_id) END),'~'),
             NVL(d.expenditure_type,'~')) IN (SELECT pk,tk,et FROM kys)
      UNION ALL
      -- Open Obligation -- reserved PO distributions, GRN-netted
      SELECT 'PO' source,
             TO_CHAR(h.order_number) doc_number, TO_CHAR(pl.line) doc_line,
             h.supplier_name descr,
             COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(b.project_id)) project_number,
             pj.project_name,
             COALESCE(tk.task_number, CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END) task_number,
             b.expenditure_type,
             b.budget_date, 'AED' currency,
             b.amt_aed line_aed,
             GREATEST(b.amt_aed - NVL(g.grn_aed,0),0) open_aed,
             b.charge_account cc_string
      FROM po_dist b
      LEFT JOIN grn_per_dist g ON g.po_distribution_id = b.po_distribution_id
      LEFT JOIN po_hdr h ON h.po_header_id = b.po_header_id
      LEFT JOIN po_lin pl ON pl.po_header_id = b.po_header_id AND pl.po_line_id = b.po_line_id
      LEFT JOIN proj pj ON pj.project_id = b.project_id
      LEFT JOIN tsk  tk ON tk.task_id    = b.task_id
      WHERE b.funds_status IN ('Reserved','Partially Liquidated')
        AND NVL(h.po_status,'x') <> 'Finally Closed'
        AND b.project_id IS NOT NULL AND b.charge_account IS NOT NULL
        AND GREATEST(b.amt_aed - NVL(g.grn_aed,0),0) > 0.005
        AND EXTRACT(YEAR FROM b.budget_date) = l_year
        AND (l_end IS NULL OR b.budget_date < l_end + 1)
        AND (COALESCE(TO_CHAR(pj.project_number),'#'||TO_CHAR(b.project_id)),
             NVL(COALESCE(tk.task_number, CASE WHEN b.task_id IS NOT NULL THEN '#'||TO_CHAR(b.task_id) END),'~'),
             NVL(b.expenditure_type,'~')) IN (SELECT pk,tk,et FROM kys)
    )
    SELECT e.source, e.doc_number, e.doc_line, e.descr,
           e.project_number, e.project_name, e.task_number, e.expenditure_type,
           TO_CHAR(e.budget_date,'YYYY-MM-DD') budget_date, e.currency,
           e.line_aed, e.open_aed, e.cc_string,
           coa.entity_code, coa.entity_desc,
           coa.program_code, coa.program_desc,
           coa.cost_center_code, coa.cost_center_desc,
           coa.budget_group_code, coa.budget_group_desc,
           coa.account_code, coa.account_desc,
           coa.entity_specific_code, coa.entity_specific_desc,
           coa.appropriation_code, coa.appropriation_desc,
           coa.intercompany_code, coa.intercompany_desc,
           coa.future1_code, coa.future1_desc,
           coa.future2_code, coa.future2_desc,
           coa.sector_name, coa.chapter_name,
           COUNT(*) OVER () full_n, SUM(e.open_aed) OVER () full_tot
    FROM enc e
    LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = e.cc_string
    ORDER BY e.open_aed DESC NULLS LAST
    FETCH FIRST l_limit ROWS ONLY
  ) LOOP
    l_count := r.full_n; l_total := r.full_tot;
    APEX_JSON.open_object;
    APEX_JSON.write('source', r.source);
    APEX_JSON.write('docNumber', NVL(r.doc_number,''));
    APEX_JSON.write('docLine', NVL(r.doc_line,''));
    APEX_JSON.write('description', NVL(r.descr,''));
    APEX_JSON.write('projectNumber', NVL(r.project_number,''));
    APEX_JSON.write('projectName', NVL(r.project_name,''));
    APEX_JSON.write('task', NVL(r.task_number,''));
    APEX_JSON.write('expenditureType', NVL(r.expenditure_type,''));
    APEX_JSON.write('budgetDate', NVL(r.budget_date,''));
    APEX_JSON.write('currency', NVL(r.currency,'AED'));
    APEX_JSON.write('lineAmount', r.line_aed);
    APEX_JSON.write('openAmount', r.open_aed);
    APEX_JSON.write('combination', NVL(r.cc_string,''));
    APEX_JSON.write('entityCode', NVL(r.entity_code,''));            APEX_JSON.write('entityName', NVL(r.entity_desc,''));
    APEX_JSON.write('programCode', NVL(r.program_code,''));          APEX_JSON.write('programName', NVL(r.program_desc,''));
    APEX_JSON.write('costCenterCode', NVL(r.cost_center_code,''));   APEX_JSON.write('costCenterName', NVL(r.cost_center_desc,''));
    APEX_JSON.write('budgetGroupCode', NVL(r.budget_group_code,'')); APEX_JSON.write('budgetGroupName', NVL(r.budget_group_desc,''));
    APEX_JSON.write('accountCode', NVL(r.account_code,''));          APEX_JSON.write('accountName', NVL(r.account_desc,''));
    APEX_JSON.write('entitySpecificCode', NVL(r.entity_specific_code,'')); APEX_JSON.write('entitySpecificName', NVL(r.entity_specific_desc,''));
    APEX_JSON.write('appropriationCode', NVL(r.appropriation_code,''));    APEX_JSON.write('appropriationName', NVL(r.appropriation_desc,''));
    APEX_JSON.write('intercompanyCode', NVL(r.intercompany_code,''));      APEX_JSON.write('intercompanyName', NVL(r.intercompany_desc,''));
    APEX_JSON.write('future1Code', NVL(r.future1_code,''));          APEX_JSON.write('future1Name', NVL(r.future1_desc,''));
    APEX_JSON.write('future2Code', NVL(r.future2_code,''));          APEX_JSON.write('future2Name', NVL(r.future2_desc,''));
    APEX_JSON.write('sector', NVL(r.sector_name,''));
    APEX_JSON.write('chapter', NVL(r.chapter_name,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.write('count', l_count);
  APEX_JSON.write('total', l_count);
  APEX_JSON.write('truncated', (l_count > l_limit));
  APEX_JSON.write('maxRows', l_limit);
  APEX_JSON.open_object('totals');
  APEX_JSON.write('openAed', NVL(l_total,0));
  APEX_JSON.close_object;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END;
/

BEGIN
    setup_gl_enc_ords_tmp;
    COMMIT;
END;
/
DROP PROCEDURE setup_gl_enc_ords_tmp;

PROMPT === verify ===
SELECT t.uri_template, h.method
FROM user_ords_handlers h
JOIN user_ords_templates t ON t.id = h.template_id
JOIN user_ords_modules m  ON m.id = t.module_id
WHERE m.name = 'gl.rest' AND t.uri_template = 'encumbrances'
ORDER BY t.uri_template, h.method;

PROMPT gl.rest Projects Encumbrances endpoint published (/gl/encumbrances).
