-- =============================================================================
-- General Ledger (App 210) -- Budget Transactions page (ADDITIVE)
-- File    : 20_gl_budget_trx_ords.sql
-- Adds to : gl.rest (does NOT delete/redefine the module)
-- Run     : sql -name prod_mcp @20_gl_budget_trx_ords.sql  (fresh session)
-- IMPORTANT: 05_gl_ords.sql DELETE_MODULEs gl.rest -- whenever 05 is re-run,
--            re-run 07..19 + THIS script right after it.
--
-- Purpose : serves the new "Budget Transactions" tab (Projects group) from the
--           PA_BUDGET_TRX_* tables that the ATD PBT extract loads
--           (otbi-atd/db/77). Mirrors the source VBCS screen: search criteria
--           -> header grid -> details of the selected header -> approval trail.
--
--           The ATD app already exposes /atd/pbt/* for the same tables, but it
--           is SYS_ADMIN-gated and lives behind the ATD module-access gate, so
--           a Finance user of the GL app would get a 403. These are the GL-side
--           read routes, gated on the GL privilege set.
--
-- Endpoints:
--   GET /gl/budgettrx/filters            -> LOV values for the criteria region
--   GET /gl/budgettrx/lov                -> the four big type-ahead lists
--   GET /gl/budgettrx                    -> header grid (paged, all criteria)
--   GET /gl/budgettrx/:num               -> one header + its lines + approvals
--
-- **Budget Type and Transaction Year are MANDATORY on GET budgettrx** (user
-- decision 2026-08-17, for performance -- the same call the Budget Utilization
-- page makes with its required Budget Year). Missing either = clean 400, so a
-- direct curl cannot ask for the whole table either. Because type is always
-- present, both line CTEs also scope to `trx_type = l_type`, which cuts the
-- 18,544-row union to just that type's table. `budgettrx/lov` takes the same
-- two so the type-ahead lists only offer values inside the page's scope.
--
-- Criteria parity with the Budget Utilization page (2026-08-17): the page now
-- carries the same filter set. The header-level ones (budget type, BU, project
-- type, status, year, approver, transaction/decree no., date range) filter
-- PA_BUDGET_TRX_HEADERS directly; the nine LINE-level ones (Sector, Chapter,
-- DCT Program, Appropriation, Cost Centre, Project, Task, Expenditure Type,
-- Accounting Period) go through V_PA_BUDGET_TRX_LINE (otbi-atd/db/80) as ONE
-- subquery -- so a transaction matches when ONE OF ITS LINES satisfies ALL of
-- them, which is what "show me transactions in this sector for this project"
-- means.
--
-- **That subquery is behind an l_lineflt guard and only applied when at least
-- one line criterion is set.** Applying it unconditionally would silently drop
-- the 110 headers that legitimately have no lines yet (Entered / Rejected /
-- Baselining-Failed) from the unfiltered grid.
--
-- **PERF -- the line subqueries MUST be `WITH ... /*+ MATERIALIZE */` CTEs.**
-- Every other shape lets the optimizer choose VIEW PUSHED PREDICATE: it pushes
-- h.transaction_num INTO V_PA_BUDGET_TRX_LINE and rebuilds the whole view --
-- a 3-table UNION ALL joined to FOUR GROUP BYs over the 9,447-row COA snapshot
-- -- once per header row. Measured: 3.5M buffer gets, 39s per execution, and a
-- sector-filtered page that never returned through ORDS (>120s timeout).
--
-- A plain correlated EXISTS always got that plan. Rewriting it as an
-- uncorrelated `(num,type) IN (SELECT /*+ UNNEST */ ...)` was NOT enough: the
-- SAME sql_id then had three children, one hash-join plan at 0.2s and one
-- pushed-predicate plan at 39s, and ORDS kept landing on the slow one. The
-- fast plan was luck, not structure. MATERIALIZE removes the choice -- the key
-- set is built exactly once into a temp table and the EXISTS probes that.
--
-- The bind guards inside each CTE (`l_lineflt='Y'`, `l_srch IS NOT NULL`) are
-- start-up filters, so an unused CTE costs nothing: the unfiltered grid, which
-- is what the page loads with, measures 0.01s.
--
-- Synonyms: the ADMIN synonyms for PA_BUDGET_TRX_* already exist (otbi-atd
-- db/78 created them) -- ORDS handlers run as ADMIN, so they resolve here too.
-- No new synonyms are needed and none are created (a CREATE SYNONYM in this
-- file would also break the fresh-session rule for a re-run under PROD).
-- [COLON] -> ':' at define time (SQLcl bind-scan guard).
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON

CREATE OR REPLACE PROCEDURE setup_gl_btrx_ords_tmp AS

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

    -- =========================================================================
    -- GET budgettrx/filters -- everything the criteria region needs, one call
    -- =========================================================================
    def_template('budgettrx/filters');
    def_handler('budgettrx/filters', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  -- optional here (they are what you PICK the scope with), but when supplied
  -- the line-derived lists below only offer values that exist inside that
  -- scope -- otherwise the page offers a Chapter that returns nothing
  l_type VARCHAR2(40)  := TRIM([COLON]type);
  l_year VARCHAR2(8)   := TRIM([COLON]year);
  -- Business Unit and Project Type narrow the lists too: they are part of the
  -- page's DEFAULT scope, so without them the criteria offer a Sector that
  -- returns nothing under the scope the page actually opened with
  l_bu   VARCHAR2(240) := TRIM([COLON]bu);
  l_pt   VARCHAR2(120) := TRIM([COLON]projecttype);
  l_hs   VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  l_hs := CASE WHEN l_year IS NULL AND l_bu IS NULL AND l_pt IS NULL THEN 'N' ELSE 'Y' END;
  dct_rest.json_header;
  APEX_JSON.open_object;

  APEX_JSON.open_array('types');
  FOR r IN (SELECT v.value_code c, v.value_name_en n
              FROM dct_lookup_values v JOIN dct_lookup_categories g
                ON g.category_id = v.category_id
             WHERE g.category_code = 'PA_BUDGET_TRX_TYPE' AND v.is_active = 'Y'
             ORDER BY v.display_order) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.c); APEX_JSON.write('name', r.n);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('businessUnits');
  FOR r IN (SELECT DISTINCT business_unit b FROM pa_budget_trx_headers
             WHERE business_unit IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.write(r.b);
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('projectTypes');
  FOR r IN (SELECT DISTINCT project_type p FROM pa_budget_trx_headers
             WHERE project_type IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.write(r.p);
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('statuses');
  FOR r IN (SELECT status s, COUNT(*) n FROM pa_budget_trx_headers
             WHERE status IS NOT NULL GROUP BY status ORDER BY 2 DESC) LOOP
    APEX_JSON.write(r.s);
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('years');
  FOR r IN (SELECT DISTINCT trx_year y FROM pa_budget_trx_headers
             WHERE trx_year IS NOT NULL ORDER BY 1 DESC) LOOP
    APEX_JSON.write(r.y);
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('approvers');
  FOR r IN (SELECT DISTINCT dept_1st_level_approver a FROM pa_budget_trx_headers
             WHERE dept_1st_level_approver IS NOT NULL ORDER BY 1
             FETCH FIRST 500 ROWS ONLY) LOOP
    APEX_JSON.write(r.a);
  END LOOP;
  APEX_JSON.close_array;

  -- the GL classification dimensions, resolved from the LINES of the loaded
  -- transactions (so the list only ever offers values that can return rows)
  APEX_JSON.open_array('sectors');
  FOR r IN (SELECT sector_code c, MAX(sector_name) n FROM v_pa_budget_trx_line
             WHERE sector_code IS NOT NULL
               AND (l_type IS NULL OR trx_type = l_type)
               AND (l_hs = 'N' OR transaction_num IN (
                     SELECT h.transaction_num FROM pa_budget_trx_headers h
                      WHERE (l_year IS NULL OR h.trx_year      = l_year)
                        AND (l_bu   IS NULL OR h.business_unit = l_bu)
                        AND (l_pt   IS NULL OR h.project_type  = l_pt)))
             GROUP BY sector_code ORDER BY 2) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.c); APEX_JSON.write('name', NVL(r.n, r.c));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('chapters');
  FOR r IN (SELECT chapter_code c, MAX(chapter_name) n FROM v_pa_budget_trx_line
             WHERE chapter_code IS NOT NULL
               AND (l_type IS NULL OR trx_type = l_type)
               AND (l_hs = 'N' OR transaction_num IN (
                     SELECT h.transaction_num FROM pa_budget_trx_headers h
                      WHERE (l_year IS NULL OR h.trx_year      = l_year)
                        AND (l_bu   IS NULL OR h.business_unit = l_bu)
                        AND (l_pt   IS NULL OR h.project_type  = l_pt)))
             GROUP BY chapter_code ORDER BY 1) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.c); APEX_JSON.write('name', NVL(r.n, r.c));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('programs');
  FOR r IN (SELECT program_code c, MAX(NVL(program_name, program_desc)) n
              FROM v_pa_budget_trx_line
             WHERE program_code IS NOT NULL
               AND (l_type IS NULL OR trx_type = l_type)
               AND (l_hs = 'N' OR transaction_num IN (
                     SELECT h.transaction_num FROM pa_budget_trx_headers h
                      WHERE (l_year IS NULL OR h.trx_year      = l_year)
                        AND (l_bu   IS NULL OR h.business_unit = l_bu)
                        AND (l_pt   IS NULL OR h.project_type  = l_pt)))
             GROUP BY program_code ORDER BY 1) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.c); APEX_JSON.write('name', NVL(r.n, r.c));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('appropriations');
  FOR r IN (SELECT appropriation_code c, MAX(appropriation_name) n
              FROM v_pa_budget_trx_line
             WHERE appropriation_code IS NOT NULL
               AND (l_type IS NULL OR trx_type = l_type)
               AND (l_hs = 'N' OR transaction_num IN (
                     SELECT h.transaction_num FROM pa_budget_trx_headers h
                      WHERE (l_year IS NULL OR h.trx_year      = l_year)
                        AND (l_bu   IS NULL OR h.business_unit = l_bu)
                        AND (l_pt   IS NULL OR h.project_type  = l_pt)))
             GROUP BY appropriation_code ORDER BY 1) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('code', r.c); APEX_JSON.write('name', NVL(r.n, r.c));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  -- accounting periods: MM-YYYY sorts wrong lexically, so order on the view's
  -- numeric YYYYMM and emit the label
  APEX_JSON.open_array('periods');
  FOR r IN (SELECT period_from p, MAX(period_from_num) k FROM v_pa_budget_trx_line
             WHERE period_from IS NOT NULL
               AND (l_type IS NULL OR trx_type = l_type)
               AND (l_hs = 'N' OR transaction_num IN (
                     SELECT h.transaction_num FROM pa_budget_trx_headers h
                      WHERE (l_year IS NULL OR h.trx_year      = l_year)
                        AND (l_bu   IS NULL OR h.business_unit = l_bu)
                        AND (l_pt   IS NULL OR h.project_type  = l_pt)))
             GROUP BY period_from ORDER BY 2 DESC) LOOP
    APEX_JSON.write(r.p);
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GET budgettrx/lov?type= -- the four big type-ahead lists, one call
    -- Kept OUT of /filters (886 projects + 1,825 tasks + 184 expenditure types
    -- + 115 cost centres) exactly like the Budget Utilization page's
    -- /butil/lov: the small selects load with the page, these feed <datalist>.
    -- =========================================================================
    def_template('budgettrx/lov');
    def_handler('budgettrx/lov', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_type VARCHAR2(40)  := TRIM([COLON]type);
  l_year VARCHAR2(8)   := TRIM([COLON]year);
  -- Business Unit and Project Type narrow the lists too: they are part of the
  -- page's DEFAULT scope, so without them the criteria offer a Sector that
  -- returns nothing under the scope the page actually opened with
  l_bu   VARCHAR2(240) := TRIM([COLON]bu);
  l_pt   VARCHAR2(120) := TRIM([COLON]projecttype);
  l_hs   VARCHAR2(1);
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  l_hs := CASE WHEN l_year IS NULL AND l_bu IS NULL AND l_pt IS NULL THEN 'N' ELSE 'Y' END;
  dct_rest.json_header;
  APEX_JSON.open_object;

  APEX_JSON.open_array('projects');
  FOR r IN (SELECT project_num p, MAX(project_name) n FROM v_pa_budget_trx_line
             WHERE project_num IS NOT NULL
               AND (l_type IS NULL OR trx_type = l_type)
               AND (l_hs = 'N' OR transaction_num IN (
                     SELECT h.transaction_num FROM pa_budget_trx_headers h
                      WHERE (l_year IS NULL OR h.trx_year      = l_year)
                        AND (l_bu   IS NULL OR h.business_unit = l_bu)
                        AND (l_pt   IS NULL OR h.project_type  = l_pt)))
             GROUP BY project_num ORDER BY 1) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('p', r.p); APEX_JSON.write('n', NVL(r.n,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('tasks');
  FOR r IN (SELECT task_num t, MAX(task_name) n FROM v_pa_budget_trx_line
             WHERE task_num IS NOT NULL
               AND (l_type IS NULL OR trx_type = l_type)
               AND (l_hs = 'N' OR transaction_num IN (
                     SELECT h.transaction_num FROM pa_budget_trx_headers h
                      WHERE (l_year IS NULL OR h.trx_year      = l_year)
                        AND (l_bu   IS NULL OR h.business_unit = l_bu)
                        AND (l_pt   IS NULL OR h.project_type  = l_pt)))
             GROUP BY task_num ORDER BY 1) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('t', r.t); APEX_JSON.write('n', NVL(r.n,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('etypes');
  FOR r IN (SELECT DISTINCT expenditure_type e FROM v_pa_budget_trx_line
             WHERE expenditure_type IS NOT NULL
               AND (l_type IS NULL OR trx_type = l_type)
               AND (l_hs = 'N' OR transaction_num IN (
                     SELECT h.transaction_num FROM pa_budget_trx_headers h
                      WHERE (l_year IS NULL OR h.trx_year      = l_year)
                        AND (l_bu   IS NULL OR h.business_unit = l_bu)
                        AND (l_pt   IS NULL OR h.project_type  = l_pt)))
             ORDER BY 1) LOOP
    APEX_JSON.write(r.e);
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.open_array('costCenters');
  FOR r IN (SELECT DISTINCT cost_center c FROM v_pa_budget_trx_line
             WHERE cost_center IS NOT NULL
               AND (l_type IS NULL OR trx_type = l_type)
               AND (l_hs = 'N' OR transaction_num IN (
                     SELECT h.transaction_num FROM pa_budget_trx_headers h
                      WHERE (l_year IS NULL OR h.trx_year      = l_year)
                        AND (l_bu   IS NULL OR h.business_unit = l_bu)
                        AND (l_pt   IS NULL OR h.project_type  = l_pt)))
             ORDER BY 1) LOOP
    APEX_JSON.write(r.c);
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GET budgettrx -- the header grid. Every criterion on the source screen.
    -- =========================================================================
    def_template('budgettrx');
    def_handler('budgettrx', 'GET', q'!
DECLARE
  l_user  VARCHAR2(100) := dct_rest.validate_session;
  l_type  VARCHAR2(40)  := TRIM([COLON]type);
  l_bu    VARCHAR2(240) := TRIM([COLON]bu);
  l_ptype VARCHAR2(120) := TRIM([COLON]projecttype);
  l_stat  VARCHAR2(60)  := TRIM([COLON]status);
  l_year  VARCHAR2(8)   := TRIM([COLON]year);
  l_appr  VARCHAR2(240) := TRIM([COLON]approver);
  l_num   VARCHAR2(60)  := TRIM([COLON]trxnum);
  l_decree VARCHAR2(120):= TRIM([COLON]decree);
  l_srch  VARCHAR2(200) := LOWER(TRIM([COLON]search));
  -- line-level criteria (Budget Utilization parity) -- see the header comment:
  -- ONE EXISTS over V_PA_BUDGET_TRX_LINE, applied ONLY when one is set
  l_sect  VARCHAR2(80)  := TRIM([COLON]sector);
  l_chap  VARCHAR2(40)  := TRIM([COLON]chapter);
  l_prog  VARCHAR2(40)  := TRIM([COLON]program);
  l_appc  VARCHAR2(40)  := TRIM([COLON]appropriation);
  l_cc    VARCHAR2(240) := LOWER(TRIM([COLON]costcenter));
  l_proj  VARCHAR2(240) := LOWER(TRIM([COLON]project));
  l_task  VARCHAR2(240) := LOWER(TRIM([COLON]task));
  l_etype VARCHAR2(240) := LOWER(TRIM([COLON]etype));
  l_per   VARCHAR2(10)  := TRIM([COLON]period);
  l_pernum NUMBER;
  l_lineflt VARCHAR2(1) := 'N';
  l_from  DATE;
  l_to    DATE;
  l_pg    NUMBER := GREATEST(NVL(TO_NUMBER(REGEXP_SUBSTR([COLON]page,'^\d+$')),1),1);
  l_sz    NUMBER := LEAST(NVL(TO_NUMBER(REGEXP_SUBSTR([COLON]size,'^\d+$')),100),5000);
  l_tot   NUMBER := 0;
  l_n     NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  -- FX-exact masks: a lenient TO_DATE reads '26-08' as year 0026
  BEGIN
    IF [COLON]from IS NOT NULL THEN l_from := TO_DATE([COLON]from,'YYYY-MM-DD'); END IF;
    IF [COLON]to   IS NOT NULL THEN l_to   := TO_DATE([COLON]to,'YYYY-MM-DD');   END IF;
  EXCEPTION WHEN OTHERS THEN
    dct_rest.err(400,'from/to must be YYYY-MM-DD'); RETURN;
  END;
  IF l_from IS NOT NULL AND l_to IS NOT NULL AND l_to < l_from THEN
    dct_rest.err(400,'to date cannot precede from date'); RETURN;
  END IF;
  -- Budget Type and Transaction Year are MANDATORY (user decision 2026-08-17,
  -- for performance): they scope every scan on this page, exactly like the
  -- Budget Utilization page's required Budget Year. Decided BEFORE json_header
  -- -- once the header is written the status line cannot be changed.
  IF l_type IS NULL OR l_year IS NULL THEN
    dct_rest.err(400,'type and year are required'); RETURN;
  END IF;
  IF l_per IS NOT NULL THEN
    IF NOT REGEXP_LIKE(l_per,'^[0-9]{2}-[0-9]{4}$') THEN
      dct_rest.err(400,'period must be MM-YYYY'); RETURN;
    END IF;
    l_pernum := TO_NUMBER(SUBSTR(l_per,4,4)||SUBSTR(l_per,1,2));
  END IF;
  IF l_sect IS NOT NULL OR l_chap IS NOT NULL OR l_prog IS NOT NULL
     OR l_appc IS NOT NULL OR l_cc IS NOT NULL OR l_proj IS NOT NULL
     OR l_task IS NOT NULL OR l_etype IS NOT NULL OR l_pernum IS NOT NULL THEN
    l_lineflt := 'Y';
  END IF;

  WITH lf AS (   -- MATERIALIZE: see the header note. Without it the optimizer
                 -- pushes h.transaction_num INTO the view and rebuilds it per row.
    SELECT /*+ MATERIALIZE */ DISTINCT l.transaction_num tn, l.trx_type tt
      FROM v_pa_budget_trx_line l
     WHERE l_lineflt = 'Y'
       AND l.trx_type = l_type          -- type is mandatory: scope the scan
       AND (l_sect  IS NULL OR l.sector_code        = l_sect)
       AND (l_chap  IS NULL OR l.chapter_code       = l_chap)
       AND (l_prog  IS NULL OR l.program_code       = l_prog)
       AND (l_appc  IS NULL OR l.appropriation_code = l_appc)
       AND (l_cc    IS NULL OR LOWER(l.cost_center) LIKE '%'||l_cc||'%')
       AND (l_proj  IS NULL OR LOWER(NVL(l.project_num,''))  LIKE '%'||l_proj||'%'
                            OR LOWER(NVL(l.project_name,'')) LIKE '%'||l_proj||'%')
       AND (l_task  IS NULL OR LOWER(NVL(l.task_num,''))  LIKE '%'||l_task||'%'
                            OR LOWER(NVL(l.task_name,'')) LIKE '%'||l_task||'%')
       AND (l_etype IS NULL OR LOWER(NVL(l.expenditure_type,'')) LIKE '%'||l_etype||'%')
       AND (l_pernum IS NULL OR (l.period_from_num <= l_pernum
                                 AND NVL(l.period_to_num, l.period_from_num) >= l_pernum))
  ), sf AS (
    SELECT /*+ MATERIALIZE */ DISTINCT s.transaction_num tn, s.trx_type tt
      FROM v_pa_budget_trx_line s
     WHERE l_srch IS NOT NULL
       AND s.trx_type = l_type
       AND (LOWER(NVL(s.project_num,''))      LIKE '%'||l_srch||'%'
         OR LOWER(NVL(s.project_name,''))     LIKE '%'||l_srch||'%'
         OR LOWER(NVL(s.task_num,''))         LIKE '%'||l_srch||'%'
         OR LOWER(NVL(s.task_name,''))        LIKE '%'||l_srch||'%'
         OR LOWER(NVL(s.expenditure_type,'')) LIKE '%'||l_srch||'%')
  )
  SELECT COUNT(*) INTO l_tot FROM pa_budget_trx_headers h
   WHERE (l_type   IS NULL OR h.transaction_type = l_type)
     AND (l_bu     IS NULL OR h.business_unit    = l_bu)
     AND (l_ptype  IS NULL OR h.project_type     = l_ptype)
     AND (l_stat   IS NULL OR h.status           = l_stat)
     AND (l_year   IS NULL OR h.trx_year         = l_year)
     AND (l_appr   IS NULL OR h.dept_1st_level_approver = l_appr)
     AND (l_num    IS NULL OR h.transaction_num  = l_num)
     AND (l_decree IS NULL OR LOWER(NVL(h.decree_no,'')) LIKE '%'||LOWER(l_decree)||'%')
     AND (l_from   IS NULL OR h.transaction_date >= l_from)
     AND (l_to     IS NULL OR h.transaction_date <= l_to)
     AND (l_srch   IS NULL OR LOWER(h.transaction_num) LIKE '%'||l_srch||'%'
          OR LOWER(NVL(h.decree_no,''))    LIKE '%'||l_srch||'%'
          OR LOWER(NVL(h.organization,'')) LIKE '%'||l_srch||'%'
          OR LOWER(NVL(h.dept_1st_level_approver,'')) LIKE '%'||l_srch||'%'
          OR EXISTS (SELECT 1 FROM sf
                      WHERE sf.tn = h.transaction_num AND sf.tt = h.transaction_type))
     AND (l_lineflt = 'N' OR EXISTS (SELECT 1 FROM lf
                       WHERE lf.tn = h.transaction_num AND lf.tt = h.transaction_type));

  dct_rest.json_header;
  APEX_JSON.open_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    WITH lf AS (   -- MATERIALIZE: see the header note. Without it the optimizer
                   -- pushes h.transaction_num INTO the view and rebuilds it per row.
      SELECT /*+ MATERIALIZE */ DISTINCT l.transaction_num tn, l.trx_type tt
        FROM v_pa_budget_trx_line l
       WHERE l_lineflt = 'Y'
         AND l.trx_type = l_type          -- type is mandatory: scope the scan
         AND (l_sect  IS NULL OR l.sector_code        = l_sect)
         AND (l_chap  IS NULL OR l.chapter_code       = l_chap)
         AND (l_prog  IS NULL OR l.program_code       = l_prog)
         AND (l_appc  IS NULL OR l.appropriation_code = l_appc)
         AND (l_cc    IS NULL OR LOWER(l.cost_center) LIKE '%'||l_cc||'%')
         AND (l_proj  IS NULL OR LOWER(NVL(l.project_num,''))  LIKE '%'||l_proj||'%'
                              OR LOWER(NVL(l.project_name,'')) LIKE '%'||l_proj||'%')
         AND (l_task  IS NULL OR LOWER(NVL(l.task_num,''))  LIKE '%'||l_task||'%'
                              OR LOWER(NVL(l.task_name,'')) LIKE '%'||l_task||'%')
         AND (l_etype IS NULL OR LOWER(NVL(l.expenditure_type,'')) LIKE '%'||l_etype||'%')
         AND (l_pernum IS NULL OR (l.period_from_num <= l_pernum
                                   AND NVL(l.period_to_num, l.period_from_num) >= l_pernum))
    ), sf AS (
      SELECT /*+ MATERIALIZE */ DISTINCT s.transaction_num tn, s.trx_type tt
        FROM v_pa_budget_trx_line s
       WHERE l_srch IS NOT NULL
         AND s.trx_type = l_type
         AND (LOWER(NVL(s.project_num,''))      LIKE '%'||l_srch||'%'
           OR LOWER(NVL(s.project_name,''))     LIKE '%'||l_srch||'%'
           OR LOWER(NVL(s.task_num,''))         LIKE '%'||l_srch||'%'
           OR LOWER(NVL(s.task_name,''))        LIKE '%'||l_srch||'%'
           OR LOWER(NVL(s.expenditure_type,'')) LIKE '%'||l_srch||'%')
    )
    SELECT h.*,
           TO_CHAR(h.transaction_date,'YYYY-MM-DD') td,
           TO_CHAR(h.creation_date,'YYYY-MM-DD')    cd,
           (SELECT COUNT(*) FROM pa_budget_trx_approvals a
             WHERE a.transaction_num = h.transaction_num
               AND a.trx_type = h.transaction_type) appr_n,
           CASE h.transaction_type
             WHEN 'Additional' THEN
               (SELECT COUNT(*) FROM pa_additional_fund_lines l
                 WHERE l.transaction_num = h.transaction_num)
             WHEN 'Estimated-Cost' THEN
               (SELECT COUNT(*) FROM pa_estimated_cost_lines l
                 WHERE l.transaction_num = h.transaction_num)
             ELSE
               (SELECT COUNT(*) FROM pa_annual_budget_lines l
                 WHERE l.transaction_num = h.transaction_num)
           END line_n
      FROM pa_budget_trx_headers h
     WHERE (l_type   IS NULL OR h.transaction_type = l_type)
       AND (l_bu     IS NULL OR h.business_unit    = l_bu)
       AND (l_ptype  IS NULL OR h.project_type     = l_ptype)
       AND (l_stat   IS NULL OR h.status           = l_stat)
       AND (l_year   IS NULL OR h.trx_year         = l_year)
       AND (l_appr   IS NULL OR h.dept_1st_level_approver = l_appr)
       AND (l_num    IS NULL OR h.transaction_num  = l_num)
       AND (l_decree IS NULL OR LOWER(NVL(h.decree_no,'')) LIKE '%'||LOWER(l_decree)||'%')
       AND (l_from   IS NULL OR h.transaction_date >= l_from)
       AND (l_to     IS NULL OR h.transaction_date <= l_to)
       AND (l_srch   IS NULL OR LOWER(h.transaction_num) LIKE '%'||l_srch||'%'
            OR LOWER(NVL(h.decree_no,''))    LIKE '%'||l_srch||'%'
            OR LOWER(NVL(h.organization,'')) LIKE '%'||l_srch||'%'
            OR LOWER(NVL(h.dept_1st_level_approver,'')) LIKE '%'||l_srch||'%'
            OR EXISTS (SELECT 1 FROM sf
                        WHERE sf.tn = h.transaction_num AND sf.tt = h.transaction_type))
       AND (l_lineflt = 'N' OR EXISTS (SELECT 1 FROM lf
                         WHERE lf.tn = h.transaction_num AND lf.tt = h.transaction_type))
     ORDER BY h.transaction_date DESC, h.transaction_num DESC
     OFFSET (l_pg-1)*l_sz ROWS FETCH NEXT l_sz ROWS ONLY)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('transactionNum',  r.transaction_num);
    APEX_JSON.write('transactionType', r.transaction_type);
    APEX_JSON.write('businessUnit',    NVL(r.business_unit,''));
    APEX_JSON.write('projectType',     NVL(r.project_type,''));
    APEX_JSON.write('decreeNo',        NVL(r.decree_no,''));
    APEX_JSON.write('transactionDate', NVL(r.td,''));
    APEX_JSON.write('trxYear',         NVL(r.trx_year,''));
    APEX_JSON.write('approver',        NVL(r.dept_1st_level_approver,''));
    APEX_JSON.write('status',          NVL(r.status,''));
    APEX_JSON.write('organization',    NVL(r.organization,''));
    APEX_JSON.write('creationDate',    NVL(r.cd,''));
    APEX_JSON.write('lines',           r.line_n);
    APEX_JSON.write('approvals',       r.appr_n);
    APEX_JSON.close_object;
    l_n := l_n + 1;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.write('count', l_n);
  APEX_JSON.write('total', l_tot);
  APEX_JSON.write('page',  l_pg);
  APEX_JSON.write('size',  l_sz);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    -- =========================================================================
    -- GET budgettrx/:num?type= -- header + lines + approval trail
    -- Line shapes differ per budget type (34 / 21 / 38 source fields), so each
    -- branch emits its own column set; the page renders whatever it is given.
    -- =========================================================================
    def_template('budgettrx/[COLON]num');
    def_handler('budgettrx/[COLON]num', 'GET', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_num  VARCHAR2(60)  := TRIM([COLON]num);
  l_type VARCHAR2(40)  := TRIM([COLON]type);
  l_cnt  NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  IF prod.dct_sec.has_priv_or_role(l_user, 'GL_VIEW_BUDGET_UTILIZATION', NULL, 'GL') = FALSE THEN
    dct_rest.err(403,'GL_VIEW_BUDGET_UTILIZATION required'); RETURN;
  END IF;
  IF l_num IS NULL THEN dct_rest.err(400,'num is required'); RETURN; END IF;
  SELECT COUNT(*) INTO l_cnt FROM pa_budget_trx_headers
   WHERE transaction_num = l_num AND (l_type IS NULL OR transaction_type = l_type);
  -- 404 must be decided BEFORE json_header (the header wins otherwise)
  IF l_cnt = 0 THEN dct_rest.err(404,'Transaction not found'); RETURN; END IF;

  dct_rest.json_header;
  APEX_JSON.open_object;

  FOR h IN (SELECT * FROM pa_budget_trx_headers
             WHERE transaction_num = l_num
               AND (l_type IS NULL OR transaction_type = l_type)
             FETCH FIRST 1 ROWS ONLY) LOOP
    l_type := h.transaction_type;
    APEX_JSON.open_object('header');
    APEX_JSON.write('transactionNum',  h.transaction_num);
    APEX_JSON.write('transactionType', h.transaction_type);
    APEX_JSON.write('businessUnit',    NVL(h.business_unit,''));
    APEX_JSON.write('projectType',     NVL(h.project_type,''));
    APEX_JSON.write('decreeNo',        NVL(h.decree_no,''));
    APEX_JSON.write('transactionDate', NVL(TO_CHAR(h.transaction_date,'YYYY-MM-DD'),''));
    APEX_JSON.write('trxYear',         NVL(h.trx_year,''));
    APEX_JSON.write('approver',        NVL(h.dept_1st_level_approver,''));
    APEX_JSON.write('status',          NVL(h.status,''));
    APEX_JSON.write('organization',    NVL(h.organization,''));
    APEX_JSON.write('creationDate',    NVL(TO_CHAR(h.creation_date,'YYYY-MM-DD'),''));
    APEX_JSON.write('projectApprovedCost',  NVL(h.project_approved_cost,0));
    APEX_JSON.write('projectEstimatedCost', NVL(h.project_estimated_cost,0));
    APEX_JSON.write('projectTotalCost',     NVL(h.project_total_cost,0));
    APEX_JSON.close_object;
  END LOOP;

  APEX_JSON.open_array('lines');
  IF l_type = 'Additional' THEN
    FOR r IN (SELECT * FROM pa_additional_fund_lines
               WHERE transaction_num = l_num ORDER BY identifier) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('projectNum',       NVL(r.project_num,''));
      APEX_JSON.write('projectName',      NVL(r.project_name,''));
      APEX_JSON.write('taskNum',          NVL(r.task_num,''));
      APEX_JSON.write('taskName',         NVL(r.task_name,''));
      APEX_JSON.write('organization',     NVL(r.cost_center,''));
      APEX_JSON.write('expenditureType',  NVL(r.expenditure_type,''));
      APEX_JSON.write('codeCombination',  NVL(r.code_combination,''));
      APEX_JSON.write('commitment',       NVL(r.commitments,0));
      APEX_JSON.write('approvedTotalBudget', NVL(r.approved_annual_budget,0));
      APEX_JSON.write('totalProjectCost', NVL(r.revised_project_cost,0));
      APEX_JSON.write('currentAnnual',    NVL(r.current_annual_budget,0));
      APEX_JSON.write('previousYearActual', NVL(r.previous_year_actual,0));
      APEX_JSON.write('currentYearActual',  NVL(r.current_year_actual,0));
      APEX_JSON.write('totalActual',      NVL(r.total_actual,0));
      APEX_JSON.write('glFundAvailable',  NVL(r.gl_funds_available,0));
      APEX_JSON.write('projectFundAvailable', NVL(r.fund_available,0));
      APEX_JSON.write('additionalAmount', NVL(r.additional_amount,0));
      APEX_JSON.write('totalAnnualBudget',NVL(r.total_annual_budget,0));
      APEX_JSON.write('accAnnualBudget',  NVL(r.acc_annual_budget,0));
      APEX_JSON.write('periodFrom',       NVL(r.period_from,''));
      APEX_JSON.write('periodTo',         NVL(r.period_to,''));
      APEX_JSON.write('validationStatus', NVL(r.validation_status,''));
      APEX_JSON.write('baselineStatus',   NVL(r.baseline_status,''));
      APEX_JSON.write('journalStatus',    NVL(r.jv_status,''));
      APEX_JSON.write('lineStatus',       NVL(r.line_status,''));
      APEX_JSON.write('notes',            NVL(r.notes,''));
      APEX_JSON.close_object;
    END LOOP;
  ELSIF l_type = 'Estimated-Cost' THEN
    FOR r IN (SELECT * FROM pa_estimated_cost_lines
               WHERE transaction_num = l_num ORDER BY identifier) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('projectNum',      NVL(r.project_num,''));
      APEX_JSON.write('projectName',     NVL(r.project_name,''));
      APEX_JSON.write('taskNum',         NVL(r.task_num,''));
      APEX_JSON.write('taskName',        NVL(r.task_name,''));
      APEX_JSON.write('organization',    NVL(r.cost_center,''));
      APEX_JSON.write('expenditureType', NVL(r.expenditure_type,''));
      APEX_JSON.write('codeCombination', NVL(r.code_combination,''));
      APEX_JSON.write('estimatedCost',   NVL(r.estimated_cost,0));
      APEX_JSON.write('currentYearBudget', NVL(r.current_year_budget,0));
      APEX_JSON.write('glFundAvailable', NVL(r.gl_funds_available,0));
      APEX_JSON.write('baselineStatus',  NVL(r.baseline_status,''));
      APEX_JSON.write('lineStatus',      NVL(r.line_status,''));
      APEX_JSON.write('notes',           NVL(r.notes,''));
      APEX_JSON.close_object;
    END LOOP;
  ELSE
    FOR r IN (SELECT * FROM pa_annual_budget_lines
               WHERE transaction_num = l_num ORDER BY identifier) LOOP
      APEX_JSON.open_object;
      APEX_JSON.write('projectNum',      NVL(r.project_num,''));
      APEX_JSON.write('projectName',     NVL(r.project_name,''));
      APEX_JSON.write('taskNum',         NVL(r.task_num,''));
      APEX_JSON.write('taskName',        NVL(r.task_name,''));
      APEX_JSON.write('organization',    NVL(r.cost_center,''));
      APEX_JSON.write('expenditureType', NVL(r.expenditure_type,''));
      APEX_JSON.write('codeCombination', NVL(r.code_combination,''));
      APEX_JSON.write('revisedProjectCost',   NVL(r.revised_project_cost,0));
      APEX_JSON.write('approvedAnnualBudget', NVL(r.approved_annual_budget,0));
      APEX_JSON.write('estimatedTaskCost',    NVL(r.estimated_task_cost,0));
      APEX_JSON.write('variationTaskCost',    NVL(r.variation_task_cost,0));
      APEX_JSON.write('approvedTaskCost',     NVL(r.approved_task_cost,0));
      APEX_JSON.write('previousYearBudget',   NVL(r.previous_year_budget,0));
      APEX_JSON.write('currentYearBudget',    NVL(r.current_year_budget,0));
      APEX_JSON.write('previousYearActual',   NVL(r.previous_year_actual,0));
      APEX_JSON.write('currentYearActual',    NVL(r.current_year_actual,0));
      APEX_JSON.write('totalActual',          NVL(r.total_actual,0));
      APEX_JSON.write('approvedBudget',       NVL(r.approved_budget,0));
      APEX_JSON.write('proposedBudget',       NVL(r.proposed_budget,0));
      APEX_JSON.write('availableProjectCost', NVL(r.available_project_cost,0));
      APEX_JSON.write('glFundAvailable',      NVL(r.gl_funds_available,0));
      APEX_JSON.write('baselineStatus',       NVL(r.baseline_status,''));
      APEX_JSON.write('journalStatus',        NVL(r.jv_status,''));
      APEX_JSON.write('notes',                NVL(r.notes,''));
      APEX_JSON.close_object;
    END LOOP;
  END IF;
  APEX_JSON.close_array;

  APEX_JSON.open_array('approvals');
  FOR r IN (SELECT * FROM pa_budget_trx_approvals
             WHERE transaction_num = l_num AND trx_type = l_type
             ORDER BY seq_no) LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('seq',       r.seq_no);
    APEX_JSON.write('submitter', NVL(r.submitter_name,''));
    APEX_JSON.write('assignee',  NVL(r.assignee_username,''));
    APEX_JSON.write('state',     NVL(r.assignment_state,''));
    APEX_JSON.write('createdAt',
      NVL(TO_CHAR(dct_to_local(r.creation_date),'YYYY-MM-DD HH[COLON]MI AM'),''));
    APEX_JSON.write('firstLevelFlag', NVL(r.dept_1st_level_approval_flag,''));
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;

  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

END setup_gl_btrx_ords_tmp;
/

BEGIN
  setup_gl_btrx_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE setup_gl_btrx_ords_tmp;

PROMPT GL 20 Budget Transactions ORDS : done
