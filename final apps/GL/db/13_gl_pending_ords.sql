-- =============================================================================
-- General Ledger (App 210) -- Encumbrances Pending Approval (ADDITIVE)
-- File    : 13_gl_pending_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @13_gl_pending_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07 + 08 + 09 + 10 + 11 + 12 + THIS script right after it.
-- Purpose : "Encumbrances - Pending Approval" page -- every distribution line
--           of a PR / PO document currently PENDING APPROVAL in Fusion (daily
--           BIP snapshot, otbi-atd/db/47), with the full open-encumbrance
--           detail (project / task / etype, canonical GL combination, AED
--           amounts) PLUS the approval-follow-up columns (preparer, submitted
--           date, pending-with approver, days pending) and monitoring KPIs.
-- Scope   : IDENTICAL to the GL Budget Utilization page -- the key-set CTE is
--           lifted verbatim from /gl/encumbrances / /gl/butil/lines. The YTD
--           period sets GL_CTX.BUTIL_END (the view is context-aware) and is
--           ALWAYS cleared, like /gl/butil. ZERO-VALUE lines are EXCLUDED
--           (ABS(line_aed) > 0.005 -- user rule 2026-07-16: the page follows
--           budget utilization, a zero line never reserves funds); the
--           reserved / not-reserved split stays visible on the page (the book
--           and Excel register additionally keep RESERVED lines only).
-- Data    : prod.dct_pr_po_pending_v (db/v2/52) + prod.dct_gl_coa_snap.
-- Endpoints:
--   GET  /gl/pending?year(req)=&period=&projecttype=&sector=&chapter=
--                    &costcenter=&project=&task=&etype=&search=&source=&bu=&limit=
--        (source = PR | PO; empty = both. bu = pipe-delimited EXACT any-of
--         list of Business Units (Fusion BU names) — scopes the register,
--         ALL aggregates AND the unmatched coverage KPI; only the BIP
--         snapshot is cross-BU today, the OTBI extracts are DCT-scoped.
--         items carry fusionHeaderId — the FUSION internal pr/po header id
--         for the shared deep-link builders)
--        -> { year, period?, asOf, businessUnits[], kpis{}, aging[],
--             approvers[], unmatched{}, columns[], items[], count,
--             truncated, maxRows, totals{} }
--        KPIs / aging / approvers aggregate over the FULL filtered set in the
--        same single scan that streams the register rows (the cap only limits
--        the rows echoed back, never the aggregates).
--   POST /gl/pending/book         -- the FULL butil filter set -> {runId};
--        enqueues ENC_PENDING_BOOK (Reporting Platform, reporting/db/23)
--   GET  /gl/pending/book/[COLON]id     -> {runId, status, rowCount, error, hasPdf}
--   GET  /gl/pending/book/[COLON]id/pdf -> authed PDF download of a finished run
--   POST /gl/pending/xlsx         -- the same filter set + source -> {runId};
--        enqueues ENC_PENDING_REGISTER (Excel register, reporting/db/24)
--   GET  /gl/pending/xlsx/[COLON]id      -> {runId, status, rowCount, error, hasFile}
--   GET  /gl/pending/xlsx/[COLON]id/file -> authed XLSX download of a finished run
--   POST /gl/pending/ppt          -- the FULL butil filter set -> {runId};
--        enqueues ENC_PENDING_BOOK with formats='PPTX' (executive PowerPoint
--        deck; runner/render_pptx.py builds the pending-approval deck from the
--        same MULTI sections as the Briefing Book PDF)
--   GET  /gl/pending/ppt/[COLON]id      -> {runId, status, rowCount, error, hasFile}
--   GET  /gl/pending/ppt/[COLON]id/file -> authed PPTX download of a finished run
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_pending_ords_tmp AS

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

    def_template('pending');
    def_handler('pending', 'GET', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year    NUMBER        := TO_NUMBER([COLON]year DEFAULT NULL ON CONVERSION ERROR);
  l_ptype   VARCHAR2(100) := [COLON]projecttype;
  l_sector  VARCHAR2(200) := [COLON]sector;
  l_chapter VARCHAR2(2000) := [COLON]chapter;
  l_cc      VARCHAR2(2000) := [COLON]costcenter;
  l_proj    VARCHAR2(2000) := [COLON]project;
  l_task    VARCHAR2(200) := [COLON]task;
  l_etype   VARCHAR2(255) := [COLON]etype;
  l_search  VARCHAR2(200) := [COLON]search;
  l_period  VARCHAR2(10)  := [COLON]period;
  l_source  VARCHAR2(10)  := UPPER([COLON]source);
  l_bu      VARCHAR2(2000) := [COLON]bu;
  l_end     DATE;
  l_limit   NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit DEFAULT NULL ON CONVERSION ERROR), 10000), 10000);
  l_rows    NUMBER := 0;
  l_shown   NUMBER := 0;
  l_full_amt  NUMBER := 0;
  l_full_open NUMBER := 0;
  l_docs_pr NUMBER := 0;  l_docs_po NUMBER := 0;
  l_amt_pr  NUMBER := 0;  l_amt_po  NUMBER := 0;
  l_res_amt NUMBER := 0;  l_unres_amt NUMBER := 0;  l_enc_open NUMBER := 0;
  l_days_sum NUMBER := 0; l_max_days NUMBER := 0;
  l_over30_docs NUMBER := 0; l_over30_amt NUMBER := 0;
  l_bdoc1 NUMBER := 0; l_bdoc2 NUMBER := 0; l_bdoc3 NUMBER := 0; l_bdoc4 NUMBER := 0;
  l_bamt1 NUMBER := 0; l_bamt2 NUMBER := 0; l_bamt3 NUMBER := 0; l_bamt4 NUMBER := 0;
  l_um_pr NUMBER := 0; l_um_po NUMBER := 0;
  l_asof  VARCHAR2(40);
  l_days  NUMBER;
  l_bk    PLS_INTEGER;
  l_key   VARCHAR2(120);
  l_app   VARCHAR2(420);
  TYPE t_flag IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(120);
  l_seen  t_flag;
  TYPE t_map IS TABLE OF NUMBER INDEX BY VARCHAR2(420);
  l_ap_amt t_map; l_ap_docs t_map; l_ap_maxd t_map;
  TYPE t_used IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(420);
  l_used  t_used;
  l_k     VARCHAR2(420);
  l_best  VARCHAR2(420);
  l_bestv NUMBER;
  PROCEDURE col(p_key VARCHAR2, p_label VARCHAR2, p_type VARCHAR2) IS
  BEGIN
    APEX_JSON.open_object; APEX_JSON.write('key',p_key); APEX_JSON.write('label',p_label); APEX_JSON.write('type',p_type); APEX_JSON.close_object;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_PENDING_APPROVALS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_PENDING_APPROVALS required'); RETURN;
  END IF;
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  IF l_ptype   = '' THEN l_ptype   := NULL; END IF;
  IF l_sector  = '' THEN l_sector  := NULL; END IF;
  IF l_chapter = '' THEN l_chapter := NULL; END IF;
  IF l_cc      = '' THEN l_cc      := NULL; END IF;
  IF l_proj    = '' THEN l_proj    := NULL; END IF;
  IF l_task    = '' THEN l_task    := NULL; END IF;
  IF l_etype   = '' THEN l_etype   := NULL; END IF;
  IF l_search  = '' THEN l_search  := NULL; END IF;
  IF l_period  = '' THEN l_period  := NULL; END IF;
  IF l_source  = '' THEN l_source  := NULL; END IF;
  IF l_bu      = '' THEN l_bu      := NULL; END IF;
  IF l_source IS NOT NULL AND l_source NOT IN ('PR','PO') THEN
    dct_rest.err(400,'source must be PR or PO'); RETURN;
  END IF;
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
    l_end := LAST_DAY(TO_DATE('01-'||l_period, 'DD-MM-YYYY'));
  END IF;
  -- the view is GL_CTX.BUTIL_END-aware (budget_date window + GRN netting);
  -- set it for the YTD period exactly like /gl/butil and ALWAYS clear it
  IF l_end IS NOT NULL THEN dct_gl_class_pkg.set_butil_end(l_end);
  ELSE dct_gl_class_pkg.clear_butil_end; END IF;

  BEGIN
    SELECT TO_CHAR(dct_to_local(MAX(load_ts)),'YYYY-MM-DD HH[COLON]MI AM')
      INTO l_asof FROM prod.atd_pr_po_pending_approval;
  EXCEPTION WHEN OTHERS THEN l_asof := NULL; END;

  SELECT NVL(SUM(CASE WHEN source = 'PR' THEN 1 ELSE 0 END),0),
         NVL(SUM(CASE WHEN source = 'PO' THEN 1 ELSE 0 END),0)
    INTO l_um_pr, l_um_po
  FROM prod.dct_pr_po_pending_v
  WHERE in_extract = 'N'
    AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||business_unit||'|') > 0);

  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  APEX_JSON.write('asOf', NVL(l_asof,''));

  -- Business-unit LOV: every BU present in the snapshot (NOT scoped by the
  -- current picks, so the multi-select options stay stable). Only the BIP
  -- snapshot is cross-BU today -- the OTBI extracts are DCT-scoped.
  APEX_JSON.open_array('businessUnits');
  FOR b IN (SELECT DISTINCT business_unit bu
              FROM prod.atd_pr_po_pending_approval
             WHERE business_unit IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.write(b.bu);
  END LOOP;
  APEX_JSON.close_array;

  -- server-defined column set (the IR grid renders exactly these, in THIS
  -- order): approval follow-up first (the page's purpose), then amounts,
  -- then the budget identification, then the GL combination + segments.
  APEX_JSON.open_array('columns');
  col('source','Source','text');
  col('docNumber','Document #','text');
  col('docLine','Line','text');
  col('description','Description / Vendor','text');
  col('preparerBuyer','Preparer / Buyer','text');
  col('submittedDate','Submitted','date');
  col('pendingDays','Days pending','num');
  col('pendingWith','Pending with','text');
  col('businessUnit','Business unit','text');
  col('fundsStatus','Funds status','text');
  col('currency','Cur','text');
  col('lineAmount','Line amount (AED)','money');
  col('encOpenAmount','In open encumbrance (AED)','money');
  col('sector','Sector','text');
  col('chapter','Chapter','text');
  col('projectName','Project name','text');
  col('projectNumber','Project #','text');
  col('task','Task','text');
  col('expenditureType','Expenditure type','text');
  col('budgetDate','Budget date','date');
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
        AND (l_cc      IS NULL OR (INSTR(l_cc,'|') = 0 AND v.cost_centre LIKE '%'||l_cc||'%')
                               OR INSTR('|'||l_cc||'|', '|'||v.cost_centre||'|') > 0)
        AND (l_proj    IS NULL OR (INSTR(l_proj,'|') = 0 AND UPPER(v.project_number||' '||v.project_name) LIKE '%'||UPPER(l_proj)||'%')
                               OR INSTR('|'||l_proj||'|', '|'||v.project_number||'|') > 0)
        AND (l_task    IS NULL OR UPPER(v.task_number) LIKE '%'||UPPER(l_task)||'%')
        AND (l_etype   IS NULL OR UPPER(v.expenditure_type) LIKE '%'||UPPER(l_etype)||'%')
        AND (l_search  IS NULL OR UPPER(v.project_number||' '||v.project_name||' '||v.task_number||' '||v.department||' '||v.cost_centre||' '||v.expenditure_type) LIKE '%'||UPPER(l_search)||'%')
    )
    SELECT p.source, p.business_unit, p.doc_number, p.doc_line, p.descr,
           p.preparer_buyer, TO_CHAR(p.submitted_date,'YYYY-MM-DD') submitted_date,
           p.pending_days, p.pending_with, p.funds_status,
           p.project_number, p.project_name, p.task_number, p.expenditure_type,
           TO_CHAR(p.budget_date,'YYYY-MM-DD') budget_date, p.currency,
           p.line_aed, p.enc_open_aed, p.cc_string, p.fusion_header_id,
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
           COUNT(*) OVER () full_n,
           SUM(p.line_aed) OVER () full_amt,
           SUM(p.enc_open_aed) OVER () full_open
    FROM prod.dct_pr_po_pending_v p
    LEFT JOIN prod.dct_gl_coa_snap coa ON coa.cc_string = p.cc_string
    WHERE p.in_extract = 'Y'
      AND ABS(NVL(p.line_aed,0)) > 0.005
      AND p.budget_year = l_year
      AND (l_source IS NULL OR p.source = l_source)
      AND (l_bu IS NULL OR INSTR('|'||l_bu||'|', '|'||p.business_unit||'|') > 0)
      AND (p.project_number, NVL(p.task_number,'~'), NVL(p.expenditure_type,'~'))
          IN (SELECT pk, tk, et FROM kys)
    ORDER BY p.pending_days DESC NULLS LAST, p.line_aed DESC NULLS LAST
  ) LOOP
    l_rows := r.full_n; l_full_amt := r.full_amt; l_full_open := r.full_open;
    l_days := NVL(r.pending_days, 0);
    l_bk := CASE WHEN l_days <= 7 THEN 1 WHEN l_days <= 15 THEN 2 WHEN l_days <= 30 THEN 3 ELSE 4 END;
    l_app := NVL(SUBSTR(r.pending_with,1,400),'(Unassigned)');
    l_key := r.source||'|'||SUBSTR(r.doc_number,1,100);
    IF NOT l_seen.EXISTS(l_key) THEN
      l_seen(l_key) := 1;
      IF r.source = 'PR' THEN l_docs_pr := l_docs_pr + 1; ELSE l_docs_po := l_docs_po + 1; END IF;
      l_days_sum := l_days_sum + l_days;
      IF l_days > l_max_days THEN l_max_days := l_days; END IF;
      IF l_days > 30 THEN l_over30_docs := l_over30_docs + 1; END IF;
      CASE l_bk WHEN 1 THEN l_bdoc1 := l_bdoc1 + 1; WHEN 2 THEN l_bdoc2 := l_bdoc2 + 1;
                WHEN 3 THEN l_bdoc3 := l_bdoc3 + 1; ELSE l_bdoc4 := l_bdoc4 + 1; END CASE;
      IF l_ap_docs.EXISTS(l_app) THEN l_ap_docs(l_app) := l_ap_docs(l_app) + 1;
      ELSE l_ap_docs(l_app) := 1; END IF;
      IF NOT l_ap_maxd.EXISTS(l_app) OR l_days > l_ap_maxd(l_app) THEN l_ap_maxd(l_app) := l_days; END IF;
    END IF;
    IF r.source = 'PR' THEN l_amt_pr := l_amt_pr + NVL(r.line_aed,0);
    ELSE l_amt_po := l_amt_po + NVL(r.line_aed,0); END IF;
    IF r.funds_status IN ('Reserved','Partially Liquidated') THEN l_res_amt := l_res_amt + NVL(r.line_aed,0);
    ELSE l_unres_amt := l_unres_amt + NVL(r.line_aed,0); END IF;
    l_enc_open := l_enc_open + NVL(r.enc_open_aed,0);
    IF l_days > 30 THEN l_over30_amt := l_over30_amt + NVL(r.line_aed,0); END IF;
    CASE l_bk WHEN 1 THEN l_bamt1 := l_bamt1 + NVL(r.line_aed,0); WHEN 2 THEN l_bamt2 := l_bamt2 + NVL(r.line_aed,0);
              WHEN 3 THEN l_bamt3 := l_bamt3 + NVL(r.line_aed,0); ELSE l_bamt4 := l_bamt4 + NVL(r.line_aed,0); END CASE;
    IF l_ap_amt.EXISTS(l_app) THEN l_ap_amt(l_app) := l_ap_amt(l_app) + NVL(r.line_aed,0);
    ELSE l_ap_amt(l_app) := NVL(r.line_aed,0); END IF;
    IF l_shown < l_limit THEN
      l_shown := l_shown + 1;
      APEX_JSON.open_object;
      APEX_JSON.write('source', r.source);
      APEX_JSON.write('docNumber', NVL(r.doc_number,''));
      APEX_JSON.write('docLine', NVL(r.doc_line,''));
      APEX_JSON.write('description', NVL(r.descr,''));
      APEX_JSON.write('preparerBuyer', NVL(r.preparer_buyer,''));
      APEX_JSON.write('submittedDate', NVL(r.submitted_date,''));
      APEX_JSON.write('pendingDays', NVL(r.pending_days,0));
      APEX_JSON.write('pendingWith', NVL(r.pending_with,''));
      APEX_JSON.write('businessUnit', NVL(r.business_unit,''));
      APEX_JSON.write('fundsStatus', NVL(r.funds_status,''));
      APEX_JSON.write('currency', NVL(r.currency,'AED'));
      APEX_JSON.write('lineAmount', r.line_aed);
      APEX_JSON.write('encOpenAmount', r.enc_open_aed);
      APEX_JSON.write('fusionHeaderId', r.fusion_header_id);
      APEX_JSON.write('sector', NVL(r.sector_name,''));
      APEX_JSON.write('chapter', NVL(r.chapter_name,''));
      APEX_JSON.write('projectName', NVL(r.project_name,''));
      APEX_JSON.write('projectNumber', NVL(r.project_number,''));
      APEX_JSON.write('task', NVL(r.task_number,''));
      APEX_JSON.write('expenditureType', NVL(r.expenditure_type,''));
      APEX_JSON.write('budgetDate', NVL(r.budget_date,''));
      APEX_JSON.write('combination', NVL(r.cc_string,''));
      APEX_JSON.write('programCode', NVL(r.program_code,''));          APEX_JSON.write('programName', NVL(r.program_desc,''));
      APEX_JSON.write('costCenterCode', NVL(r.cost_center_code,''));   APEX_JSON.write('costCenterName', NVL(r.cost_center_desc,''));
      APEX_JSON.write('accountCode', NVL(r.account_code,''));          APEX_JSON.write('accountName', NVL(r.account_desc,''));
      APEX_JSON.write('appropriationCode', NVL(r.appropriation_code,''));    APEX_JSON.write('appropriationName', NVL(r.appropriation_desc,''));
      APEX_JSON.write('entityCode', NVL(r.entity_code,''));            APEX_JSON.write('entityName', NVL(r.entity_desc,''));
      APEX_JSON.write('budgetGroupCode', NVL(r.budget_group_code,'')); APEX_JSON.write('budgetGroupName', NVL(r.budget_group_desc,''));
      APEX_JSON.write('entitySpecificCode', NVL(r.entity_specific_code,'')); APEX_JSON.write('entitySpecificName', NVL(r.entity_specific_desc,''));
      APEX_JSON.write('intercompanyCode', NVL(r.intercompany_code,''));      APEX_JSON.write('intercompanyName', NVL(r.intercompany_desc,''));
      APEX_JSON.write('future1Code', NVL(r.future1_code,''));          APEX_JSON.write('future1Name', NVL(r.future1_desc,''));
      APEX_JSON.write('future2Code', NVL(r.future2_code,''));          APEX_JSON.write('future2Name', NVL(r.future2_desc,''));
      APEX_JSON.close_object;
    END IF;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_object('kpis');
  APEX_JSON.write('docs', l_docs_pr + l_docs_po);
  APEX_JSON.write('docsPr', l_docs_pr);
  APEX_JSON.write('docsPo', l_docs_po);
  APEX_JSON.write('lines', l_rows);
  APEX_JSON.write('amtTotal', l_amt_pr + l_amt_po);
  APEX_JSON.write('amtPr', l_amt_pr);
  APEX_JSON.write('amtPo', l_amt_po);
  APEX_JSON.write('reservedAmt', l_res_amt);
  APEX_JSON.write('unreservedAmt', l_unres_amt);
  APEX_JSON.write('encOpenAmt', l_enc_open);
  APEX_JSON.write('avgDays', CASE WHEN l_docs_pr + l_docs_po > 0
                                  THEN ROUND(l_days_sum / (l_docs_pr + l_docs_po), 1) ELSE 0 END);
  APEX_JSON.write('maxDays', l_max_days);
  APEX_JSON.write('over30Docs', l_over30_docs);
  APEX_JSON.write('over30Amt', l_over30_amt);
  APEX_JSON.close_object;

  APEX_JSON.open_array('aging');
  APEX_JSON.open_object; APEX_JSON.write('bucket','0-7');   APEX_JSON.write('docs',l_bdoc1); APEX_JSON.write('amt',l_bamt1); APEX_JSON.close_object;
  APEX_JSON.open_object; APEX_JSON.write('bucket','8-15');  APEX_JSON.write('docs',l_bdoc2); APEX_JSON.write('amt',l_bamt2); APEX_JSON.close_object;
  APEX_JSON.open_object; APEX_JSON.write('bucket','16-30'); APEX_JSON.write('docs',l_bdoc3); APEX_JSON.write('amt',l_bamt3); APEX_JSON.close_object;
  APEX_JSON.open_object; APEX_JSON.write('bucket','31+');   APEX_JSON.write('docs',l_bdoc4); APEX_JSON.write('amt',l_bamt4); APEX_JSON.close_object;
  APEX_JSON.close_array;

  APEX_JSON.open_array('approvers');
  FOR i IN 1 .. 8 LOOP
    l_best := NULL; l_bestv := NULL;
    l_k := l_ap_amt.FIRST;
    WHILE l_k IS NOT NULL LOOP
      IF NOT l_used.EXISTS(l_k) AND (l_bestv IS NULL OR l_ap_amt(l_k) > l_bestv) THEN
        l_best := l_k; l_bestv := l_ap_amt(l_k);
      END IF;
      l_k := l_ap_amt.NEXT(l_k);
    END LOOP;
    EXIT WHEN l_best IS NULL;
    l_used(l_best) := 1;
    APEX_JSON.open_object;
    APEX_JSON.write('name', l_best);
    APEX_JSON.write('docs', NVL(l_ap_docs(l_best),0));
    APEX_JSON.write('amt', l_bestv);
    APEX_JSON.write('maxDays', NVL(l_ap_maxd(l_best),0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_object('unmatched');
  APEX_JSON.write('docs', l_um_pr + l_um_po);
  APEX_JSON.write('prDocs', l_um_pr);
  APEX_JSON.write('poDocs', l_um_po);
  APEX_JSON.close_object;

  APEX_JSON.write('count', l_rows);
  APEX_JSON.write('truncated', (l_rows > l_limit));
  APEX_JSON.write('maxRows', l_limit);
  APEX_JSON.open_object('totals');
  APEX_JSON.write('lineAed', NVL(l_full_amt,0));
  APEX_JSON.write('encOpenAed', NVL(l_full_open,0));
  APEX_JSON.close_object;
  APEX_JSON.close_object;
  dct_gl_class_pkg.clear_butil_end;
EXCEPTION WHEN OTHERS THEN dct_gl_class_pkg.clear_butil_end; dct_rest.err(500, SQLERRM);
END;
!');

    def_template('pending/book');
    def_handler('pending/book', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year   NUMBER;
  l_period VARCHAR2(10);
  l_params CLOB;
  l_run    NUMBER;
  PROCEDURE put(p_key VARCHAR2) IS
    l_val VARCHAR2(2000) := APEX_JSON.get_varchar2(p_path => p_key);
  BEGIN
    IF l_val IS NOT NULL THEN APEX_JSON.write(p_key, l_val); END IF;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_PENDING_APPROVALS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_PENDING_APPROVALS required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_year := APEX_JSON.get_number(p_path=>'year');
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  l_period := APEX_JSON.get_varchar2(p_path=>'period');
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
  END IF;
  APEX_JSON.initialize_clob_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  put('sector'); put('chapter'); put('projecttype'); put('costcenter');
  put('project'); put('task'); put('etype'); put('search'); put('bu');
  APEX_JSON.close_object;
  l_params := APEX_JSON.get_clob_output;
  APEX_JSON.free_output;
  l_run := dct_rpt_pkg.enqueue(p_report_code  => 'ENC_PENDING_BOOK',
                               p_params       => l_params,
                               p_trigger      => 'ONDEMAND',
                               p_requested_by => l_user,
                               p_formats      => 'PDF');
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('runId', l_run);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('pending/book/[COLON]id');
    def_handler('pending/book/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_pdf  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_PENDING_APPROVALS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_PENDING_APPROVALS required'); RETURN;
  END IF;
  FOR c IN (SELECT run_id, status, row_count, error_msg, started_at, finished_at
              FROM dct_rpt_run
             WHERE run_id = [COLON]id AND report_code = 'ENC_PENDING_BOOK') LOOP
    SELECT COUNT(*) INTO l_pdf
      FROM dct_rpt_output WHERE run_id = c.run_id AND format = 'PDF';
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('rowCount', c.row_count);
    APEX_JSON.write('error', NVL(DBMS_LOB.SUBSTR(c.error_msg, 500, 1), ''));
    APEX_JSON.write('startedAt', NVL(TO_CHAR(dct_to_local(c.started_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('finishedAt', NVL(TO_CHAR(dct_to_local(c.finished_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('hasPdf', l_pdf > 0);
    APEX_JSON.close_object;
    RETURN;
  END LOOP;
  dct_rest.err(404,'Run not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('pending/book/[COLON]id/pdf');
    def_handler('pending/book/[COLON]id/pdf', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_blob BLOB; l_name VARCHAR2(260);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_PENDING_APPROVALS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_PENDING_APPROVALS required'); RETURN;
  END IF;
  BEGIN
    SELECT o.file_blob, o.file_name INTO l_blob, l_name FROM (
      SELECT o.file_blob, o.file_name
        FROM dct_rpt_output o
        JOIN dct_rpt_run r ON r.run_id = o.run_id
       WHERE o.run_id = [COLON]id AND o.format = 'PDF'
         AND r.report_code = 'ENC_PENDING_BOOK'
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'PDF not found'); RETURN; END;
  OWA_UTIL.mime_header('application/pdf', FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="'||NVL(l_name,'enc_pending_book.pdf')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('pending/xlsx');
    def_handler('pending/xlsx', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year   NUMBER;
  l_period VARCHAR2(10);
  l_source VARCHAR2(10);
  l_params CLOB;
  l_run    NUMBER;
  PROCEDURE put(p_key VARCHAR2) IS
    l_val VARCHAR2(2000) := APEX_JSON.get_varchar2(p_path => p_key);
  BEGIN
    IF l_val IS NOT NULL THEN APEX_JSON.write(p_key, l_val); END IF;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_PENDING_APPROVALS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_PENDING_APPROVALS required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_year := APEX_JSON.get_number(p_path=>'year');
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  l_period := APEX_JSON.get_varchar2(p_path=>'period');
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
  END IF;
  l_source := UPPER(APEX_JSON.get_varchar2(p_path=>'source'));
  IF l_source IS NOT NULL AND l_source NOT IN ('PR','PO') THEN
    dct_rest.err(400,'source must be PR or PO'); RETURN;
  END IF;
  APEX_JSON.initialize_clob_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  IF l_source IS NOT NULL THEN APEX_JSON.write('source', l_source); END IF;
  put('sector'); put('chapter'); put('projecttype'); put('costcenter');
  put('project'); put('task'); put('etype'); put('search'); put('bu');
  APEX_JSON.close_object;
  l_params := APEX_JSON.get_clob_output;
  APEX_JSON.free_output;
  l_run := dct_rpt_pkg.enqueue(p_report_code  => 'ENC_PENDING_REGISTER',
                               p_params       => l_params,
                               p_trigger      => 'ONDEMAND',
                               p_requested_by => l_user,
                               p_formats      => 'XLSX');
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('runId', l_run);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('pending/xlsx/[COLON]id');
    def_handler('pending/xlsx/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_xls  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_PENDING_APPROVALS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_PENDING_APPROVALS required'); RETURN;
  END IF;
  FOR c IN (SELECT run_id, status, row_count, error_msg, started_at, finished_at
              FROM dct_rpt_run
             WHERE run_id = [COLON]id AND report_code = 'ENC_PENDING_REGISTER') LOOP
    SELECT COUNT(*) INTO l_xls
      FROM dct_rpt_output WHERE run_id = c.run_id AND format = 'XLSX';
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('rowCount', c.row_count);
    APEX_JSON.write('error', NVL(DBMS_LOB.SUBSTR(c.error_msg, 500, 1), ''));
    APEX_JSON.write('startedAt', NVL(TO_CHAR(dct_to_local(c.started_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('finishedAt', NVL(TO_CHAR(dct_to_local(c.finished_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('hasFile', l_xls > 0);
    APEX_JSON.close_object;
    RETURN;
  END LOOP;
  dct_rest.err(404,'Run not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('pending/xlsx/[COLON]id/file');
    def_handler('pending/xlsx/[COLON]id/file', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_blob BLOB; l_name VARCHAR2(260); l_mime VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_PENDING_APPROVALS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_PENDING_APPROVALS required'); RETURN;
  END IF;
  BEGIN
    SELECT o.file_blob, o.file_name, o.mime_type INTO l_blob, l_name, l_mime FROM (
      SELECT o.file_blob, o.file_name, o.mime_type
        FROM dct_rpt_output o
        JOIN dct_rpt_run r ON r.run_id = o.run_id
       WHERE o.run_id = [COLON]id AND o.format = 'XLSX'
         AND r.report_code = 'ENC_PENDING_REGISTER'
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'File not found'); RETURN; END;
  OWA_UTIL.mime_header(NVL(l_mime,'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'), FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="'||NVL(l_name,'enc_pending_register.xlsx')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- executive PowerPoint deck: SAME ENC_PENDING_BOOK definition/sections as
    -- the Briefing Book PDF, enqueued with formats='PPTX' so the runner's PPTX
    -- branch (render_pptx.build_deck) produces the pending-approval deck.
    def_template('pending/ppt');
    def_handler('pending/ppt', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_year   NUMBER;
  l_period VARCHAR2(10);
  l_params CLOB;
  l_run    NUMBER;
  PROCEDURE put(p_key VARCHAR2) IS
    l_val VARCHAR2(2000) := APEX_JSON.get_varchar2(p_path => p_key);
  BEGIN
    IF l_val IS NOT NULL THEN APEX_JSON.write(p_key, l_val); END IF;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_PENDING_APPROVALS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_PENDING_APPROVALS required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  l_year := APEX_JSON.get_number(p_path=>'year');
  IF l_year IS NULL THEN dct_rest.err(400,'year is required'); RETURN; END IF;
  l_period := APEX_JSON.get_varchar2(p_path=>'period');
  IF l_period IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_period, '^(0[1-9]|1[0-2])-[0-9]{4}$')
       OR TO_NUMBER(SUBSTR(l_period, 4)) <> l_year THEN
      dct_rest.err(400,'period must be MM-YYYY within the selected year'); RETURN;
    END IF;
  END IF;
  APEX_JSON.initialize_clob_output;
  APEX_JSON.open_object;
  APEX_JSON.write('year', l_year);
  IF l_period IS NOT NULL THEN APEX_JSON.write('period', l_period); END IF;
  put('sector'); put('chapter'); put('projecttype'); put('costcenter');
  put('project'); put('task'); put('etype'); put('search'); put('bu');
  APEX_JSON.close_object;
  l_params := APEX_JSON.get_clob_output;
  APEX_JSON.free_output;
  l_run := dct_rpt_pkg.enqueue(p_report_code  => 'ENC_PENDING_BOOK',
                               p_params       => l_params,
                               p_trigger      => 'ONDEMAND',
                               p_requested_by => l_user,
                               p_formats      => 'PPTX');
  COMMIT;
  dct_rest.json_header; APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('runId', l_run);
  APEX_JSON.close_object;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    IF SQLCODE = -20404 THEN dct_rest.err(404, SQLERRM);
    ELSE dct_rest.err(500, SQLERRM); END IF;
END;
!');

    def_template('pending/ppt/[COLON]id');
    def_handler('pending/ppt/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_ppt  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_PENDING_APPROVALS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_PENDING_APPROVALS required'); RETURN;
  END IF;
  FOR c IN (SELECT run_id, status, row_count, error_msg, started_at, finished_at
              FROM dct_rpt_run
             WHERE run_id = [COLON]id AND report_code = 'ENC_PENDING_BOOK') LOOP
    SELECT COUNT(*) INTO l_ppt
      FROM dct_rpt_output WHERE run_id = c.run_id AND format = 'PPTX';
    dct_rest.json_header; APEX_JSON.initialize_output;
    APEX_JSON.open_object;
    APEX_JSON.write('runId', c.run_id);
    APEX_JSON.write('status', c.status);
    APEX_JSON.write('rowCount', c.row_count);
    APEX_JSON.write('error', NVL(DBMS_LOB.SUBSTR(c.error_msg, 500, 1), ''));
    APEX_JSON.write('startedAt', NVL(TO_CHAR(dct_to_local(c.started_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('finishedAt', NVL(TO_CHAR(dct_to_local(c.finished_at),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('hasFile', l_ppt > 0);
    APEX_JSON.close_object;
    RETURN;
  END LOOP;
  dct_rest.err(404,'Run not found');
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('pending/ppt/[COLON]id/file');
    def_handler('pending/ppt/[COLON]id/file', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid NUMBER := dct_auth.get_user_id(l_user);
  l_secok NUMBER := prod.dct_sec_data.is_unrestricted(l_uid, 'SECTOR');
  l_blob BLOB; l_name VARCHAR2(260); l_mime VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_PENDING_APPROVALS', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_PENDING_APPROVALS required'); RETURN;
  END IF;
  BEGIN
    SELECT o.file_blob, o.file_name, o.mime_type INTO l_blob, l_name, l_mime FROM (
      SELECT o.file_blob, o.file_name, o.mime_type
        FROM dct_rpt_output o
        JOIN dct_rpt_run r ON r.run_id = o.run_id
       WHERE o.run_id = [COLON]id AND o.format = 'PPTX'
         AND r.report_code = 'ENC_PENDING_BOOK'
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'File not found'); RETURN; END;
  OWA_UTIL.mime_header(NVL(l_mime,'application/vnd.openxmlformats-officedocument.presentationml.presentation'), FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="'||NVL(l_name,'enc_pending_book.pptx')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END;
/

BEGIN
    setup_gl_pending_ords_tmp;
    COMMIT;
END;
/
DROP PROCEDURE setup_gl_pending_ords_tmp;

PROMPT === verify ===
SELECT t.uri_template, h.method
FROM user_ords_handlers h
JOIN user_ords_templates t ON t.id = h.template_id
JOIN user_ords_modules m  ON m.id = t.module_id
WHERE m.name = 'gl.rest' AND t.uri_template LIKE 'pending%'
ORDER BY t.uri_template, h.method;

PROMPT gl.rest Encumbrances Pending Approval endpoints published (/gl/pending + book bridge).
