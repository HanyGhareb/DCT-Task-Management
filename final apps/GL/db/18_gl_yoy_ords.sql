-- =============================================================================
-- General Ledger (App 210) -- GL Balance Year-over-Year comparison (ADDITIVE)
-- File    : 18_gl_yoy_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp (fresh session; gl.rest lives under ADMIN)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07..17 + THIS script (post-05 list = 07..18).
-- Purpose : compare YTD GL balances across years on the FUSION account basis
--           (user decision 2026-08-02): EBS years (<=2025) are translated
--           forward through the ACCOUNT map and read the STORED YTD measures
--           (Budget/Encumbrance/Actual YTD carry opening balances -- never
--           derive YTD from PTD); Fusion years (>=2026) read
--           DCT_GL_DOF_FACT_V summed over periods <= the cutoff month
--           (encumbrance = commitments + obligations + other_encumbrances).
--           EBS YTD-at-cutoff = the 'MM-YYYY' period SLICE (the export ships
--           every combination in every period); Full Year = the '13-YYYY'
--           adjustment slice when the year has one, else '12-YYYY'.
-- Endpoints:
--   GET  /gl/ebs-balances/yoy?years=2026|2025|2024&month=0&search=&atype=&chapter=
--        -> { years[], asOf, rows[{account, accountName, accountType, year,
--             actual, budget, encumbrance}] }  (long format; frontend pivots)
--        month=0 (default) = Full Year; 1-12 = YTD cutoff month. Max 6 years.
--        All-zero account-years are suppressed.
--   POST /gl/ebs-balances/yoy/xlsx     enqueue EBS_GL_YOY_REGISTER (same params)
--   GET  /gl/ebs-balances/yoy/xlsx/[COLON]id       poll status
--   GET  /gl/ebs-balances/yoy/xlsx/[COLON]id/file  download workbook
-- Gates   : reads GL_VIEW_EBS_MAPPING (NULL legacy = any valid session).
-- 2026-09-06: BOTH legs scoped to expense accounts (4xxxxx) -- PLATFORM RULE
--           'budget = expense side only' (funding-side 3270xx + revenue never budget).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_yoy_ords_tmp AS

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

    def_template('ebs-balances/yoy');
    def_handler('ebs-balances/yoy', 'GET', q'!
DECLARE
  l_user    VARCHAR2(100) := dct_rest.validate_session;
  l_years   VARCHAR2(200) := SUBSTR(TRIM([COLON]years), 1, 200);
  l_month   NUMBER        := NVL(TO_NUMBER([COLON]month DEFAULT NULL ON CONVERSION ERROR), 0);
  l_search  VARCHAR2(100) := SUBSTR(TRIM([COLON]search), 1, 100);
  l_atype   VARCHAR2(60)  := SUBSTR(TRIM([COLON]atype), 1, 60);
  l_chapter VARCHAR2(120) := SUBSTR(TRIM([COLON]chapter), 1, 120);
  -- PLATFORM RULE 2026-08-02: Budget Group defaults to '1' (Current
  -- operations); optionally a pipe list adding 2/8 (EBS legs only -- the
  -- Fusion fact view is hard-scoped to bg 1).
  l_bg      VARCHAR2(30)  := NVL(SUBSTR(TRIM([COLON]bg), 1, 30), '1');
  l_y1 NUMBER; l_y2 NUMBER; l_y3 NUMBER; l_y4 NUMBER; l_y5 NUMBER; l_y6 NUMBER;
  l_cnt NUMBER := 0; l_cur NUMBER;
  l_tok VARCHAR2(10); l_pos NUMBER := 1; l_next NUMBER;
  PROCEDURE take(p NUMBER) IS
  BEGIN
    l_cnt := l_cnt + 1;
    IF    l_cnt = 1 THEN l_y1 := p; ELSIF l_cnt = 2 THEN l_y2 := p;
    ELSIF l_cnt = 3 THEN l_y3 := p; ELSIF l_cnt = 4 THEN l_y4 := p;
    ELSIF l_cnt = 5 THEN l_y5 := p; ELSIF l_cnt = 6 THEN l_y6 := p;
    END IF;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_EBS_MAPPING', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_EBS_MAPPING required'); RETURN;
  END IF;
  IF l_month NOT BETWEEN 0 AND 12 THEN
    dct_rest.err(400,'month must be 0 (full year) or 1-12'); RETURN;
  END IF;
  IF NOT REGEXP_LIKE(l_bg, '^[0-9](\|[0-9])*$') THEN
    dct_rest.err(400,'bg must be a pipe list of budget group codes, e.g. 1 or 1|2|8'); RETURN;
  END IF;
  l_cur := EXTRACT(YEAR FROM SYSDATE);
  IF l_years IS NULL THEN
    l_years := l_cur || '|' || (l_cur - 1) || '|' || (l_cur - 2);
  END IF;
  LOOP
    l_next := INSTR(l_years, '|', l_pos);
    l_tok  := TRIM(CASE WHEN l_next = 0 THEN SUBSTR(l_years, l_pos)
                        ELSE SUBSTR(l_years, l_pos, l_next - l_pos) END);
    IF l_tok IS NOT NULL AND REGEXP_LIKE(l_tok, '^[0-9]{4}$') AND l_cnt < 6 THEN
      take(TO_NUMBER(l_tok));
    END IF;
    EXIT WHEN l_next = 0;
    l_pos := l_next + 1;
  END LOOP;
  IF l_cnt = 0 THEN dct_rest.err(400,'years must be a pipe list of 4-digit years'); RETURN; END IF;

  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_array('years');
  FOR c IN (SELECT COLUMN_VALUE AS yr FROM TABLE(apex_t_number(l_y1,l_y2,l_y3,l_y4,l_y5,l_y6))
            WHERE COLUMN_VALUE IS NOT NULL ORDER BY 1 DESC) LOOP
    APEX_JSON.write(c.yr);
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('asOf', CASE WHEN l_month = 0 THEN 'FY' ELSE 'YTD-' || LPAD(l_month,2,'0') END);
  APEX_JSON.write('budgetGroups', l_bg);

  APEX_JSON.open_array('rows');
  FOR r IN (
    -- PERF NOTES (found live 2026-08-02): a JOIN to TABLE(apex_t_number(..))
    -- for the year list wrecked the plan against the mapped view (41s vs
    -- 1.7s) -> scalar IN-list of the (max 6) year binds. A correlated EXISTS
    -- for the '13' adjustment-slice check cost ~90s -> the fy CTE computes
    -- it once. The union is consumed ONCE with analytic account attributes
    -- (a second reference re-executed both slices).
    WITH fy AS (
      SELECT period_year,
             MAX(CASE WHEN SUBSTR(accounting_period,1,2) = '13' THEN '13' END) AS m13
      FROM prod.dct_ebs_gl_balance
      GROUP BY period_year
    ),
    ebs_slice AS (
      SELECT e.period_year AS yr, e.fusion_account AS account_code,
             MAX(e.fusion_account_desc) AS account_desc,
             MAX(e.account_type) AS account_type,
             SUM(e.actual_ytd) AS act, SUM(e.budget_ytd) AS bgt,
             SUM(e.encumbrance_ytd) AS enc
      FROM prod.dct_ebs_balance_mapped_v e
      JOIN fy ON fy.period_year = e.period_year
      WHERE e.account_mapped = 'Y'
        -- PLATFORM RULE 2026-09-06 (user): budget = EXPENSE accounts (4xxxxx) only;
        -- the funding side (3270xx Treasury contributions, dropped at the base
        -- views) and revenue budgets are never a budget figure. Both legs scoped.
        AND e.fusion_account LIKE '4%'
        AND e.period_year <= 2025
        AND e.period_year IN (NVL(l_y1,-1), NVL(l_y2,-1), NVL(l_y3,-1),
                              NVL(l_y4,-1), NVL(l_y5,-1), NVL(l_y6,-1))
        AND SUBSTR(e.accounting_period,1,2) =
              CASE WHEN l_month = 0 THEN NVL(fy.m13, '12')
                   ELSE LPAD(l_month,2,'0') END
        AND INSTR('|' || l_bg || '|', '|' || e.budget_code || '|') > 0
        AND (l_chapter IS NULL OR e.chapter = l_chapter)
      GROUP BY e.period_year, e.fusion_account
      HAVING SUM(ABS(e.actual_ytd)) + SUM(ABS(e.budget_ytd))
           + SUM(ABS(e.encumbrance_ytd)) > 0.005
    ),
    fus_slice AS (
      SELECT f.period_year AS yr, f.account_code,
             MAX(f.account_desc) AS account_desc,
             MAX(f.account_type) AS account_type,
             SUM(f.expenditures) AS act, SUM(f.total_budget) AS bgt,
             SUM(f.encumbrance) AS enc
      FROM prod.dct_gl_dof_fact_v f
      WHERE f.period_year >= 2026
        AND f.account_code LIKE '4%'   -- PLATFORM RULE 2026-09-06: expense accounts only
        AND f.period_year IN (NVL(l_y1,-1), NVL(l_y2,-1), NVL(l_y3,-1),
                              NVL(l_y4,-1), NVL(l_y5,-1), NVL(l_y6,-1))
        AND (l_month = 0 OR f.period_month <= l_month)
        AND (l_chapter IS NULL OR f.chapter_name = l_chapter)
      GROUP BY f.period_year, f.account_code
      HAVING SUM(ABS(f.expenditures)) + SUM(ABS(f.total_budget))
           + SUM(ABS(f.encumbrance)) > 0.005
    )
    SELECT account_code, px_desc AS account_desc, px_type AS account_type,
           yr, act, bgt, enc
    FROM (
      SELECT u.*,
             MAX(u.account_desc) OVER (PARTITION BY u.account_code) AS px_desc,
             MAX(u.account_type) OVER (PARTITION BY u.account_code) AS px_type,
             MAX(ABS(u.act)) KEEP (DENSE_RANK FIRST ORDER BY u.yr DESC)
                 OVER (PARTITION BY u.account_code) AS sort_amt
      FROM (SELECT * FROM ebs_slice UNION ALL SELECT * FROM fus_slice) u
    )
    WHERE (l_search IS NULL OR
           UPPER(account_code || ' ' || NVL(px_desc,' ')) LIKE '%'||UPPER(l_search)||'%')
      AND (l_atype IS NULL OR px_type = l_atype)
    ORDER BY NVL(sort_amt,0) DESC, account_code, yr DESC
  ) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('account',     r.account_code);
    APEX_JSON.write('accountName', NVL(r.account_desc,''));
    APEX_JSON.write('accountType', NVL(r.account_type,''));
    APEX_JSON.write('year',        r.yr);
    APEX_JSON.write('actual',      NVL(r.act,0));
    APEX_JSON.write('budget',      NVL(r.bgt,0));
    APEX_JSON.write('encumbrance', NVL(r.enc,0));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_template('ebs-balances/yoy/xlsx');
    def_handler('ebs-balances/yoy/xlsx', 'POST', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_params CLOB;
  l_run    NUMBER;
  l_cur    NUMBER := EXTRACT(YEAR FROM SYSDATE);
  PROCEDURE put(p_key VARCHAR2) IS
    l_val VARCHAR2(2000) := APEX_JSON.get_varchar2(p_path => p_key);
  BEGIN
    IF l_val IS NOT NULL THEN APEX_JSON.write(p_key, l_val); END IF;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_EBS_MAPPING', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_EBS_MAPPING required'); RETURN;
  END IF;
  dct_rest.parse_body([COLON]body);
  APEX_JSON.initialize_clob_output;
  APEX_JSON.open_object;
  APEX_JSON.write('years', NVL(APEX_JSON.get_varchar2(p_path=>'years'),
                               l_cur || '|' || (l_cur-1) || '|' || (l_cur-2)));
  APEX_JSON.write('month', NVL(TO_CHAR(APEX_JSON.get_number(p_path=>'month')), '0'));
  APEX_JSON.write('bg', NVL(APEX_JSON.get_varchar2(p_path=>'bg'), '1'));
  put('search'); put('atype'); put('chapter');
  APEX_JSON.close_object;
  l_params := APEX_JSON.get_clob_output;
  APEX_JSON.free_output;
  l_run := dct_rpt_pkg.enqueue(p_report_code  => 'EBS_GL_YOY_REGISTER',
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

    def_template('ebs-balances/yoy/xlsx/[COLON]id');
    def_handler('ebs-balances/yoy/xlsx/[COLON]id', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_xls  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_EBS_MAPPING', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_EBS_MAPPING required'); RETURN;
  END IF;
  FOR c IN (SELECT run_id, status, row_count, error_msg, started_at, finished_at
              FROM dct_rpt_run
             WHERE run_id = [COLON]id AND report_code = 'EBS_GL_YOY_REGISTER') LOOP
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

    def_template('ebs-balances/yoy/xlsx/[COLON]id/file');
    def_handler('ebs-balances/yoy/xlsx/[COLON]id/file', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_blob BLOB; l_name VARCHAR2(260); l_mime VARCHAR2(200);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_EBS_MAPPING', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_EBS_MAPPING required'); RETURN;
  END IF;
  BEGIN
    SELECT o.file_blob, o.file_name, o.mime_type INTO l_blob, l_name, l_mime FROM (
      SELECT o.file_blob, o.file_name, o.mime_type
        FROM dct_rpt_output o
        JOIN dct_rpt_run r ON r.run_id = o.run_id
       WHERE o.run_id = [COLON]id AND o.format = 'XLSX'
         AND r.report_code = 'EBS_GL_YOY_REGISTER'
       ORDER BY o.output_id DESC) o WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN dct_rest.err(404,'File not found'); RETURN; END;
  OWA_UTIL.mime_header(NVL(l_mime,'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'), FALSE);
  HTP.p('Content-Disposition[COLON] attachment; filename="'||NVL(l_name,'ebs_gl_yoy_register.xlsx')||'"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_gl_yoy_ords_tmp;
/

SHOW ERRORS

EXECUTE setup_gl_yoy_ords_tmp
DROP PROCEDURE setup_gl_yoy_ords_tmp;

PROMPT gl.rest YoY comparison endpoints published (/gl/ebs-balances/yoy*).
