-- =============================================================================
-- i-Finance V2 -- AR Transactions dashboard -- facet engine + ORDS endpoints
-- File    : 12_ar_trx_ords.sql
-- Run as  : ADMIN schema (sql -name prod_mcp) -- FRESH SESSION
--           (never after ALTER SESSION SET CURRENT_SCHEMA = PROD -> ORA-01471)
-- Depends : 05_ar_ords.sql (module ar.rest),
--           prod.ar_transaction_aging_v  (transaction grain, amounts + aging),
--           prod.ar_transaction_details_v (line grain, revenue coding)
-- NOTE    : 05 rebuilds ar.rest with DELETE_MODULE -- the AR post-05 re-run
--           list is now 10, 11, 12. Templates here are NEW patterns only, so
--           running 12 never disturbs the handlers defined in 05/10/11.
-- =============================================================================
-- Read-only analytics over the two Fusion-loaded AR transaction views (the AP
-- dashboard pattern, AP/db/02+03): one facet engine prod.dct_ar_trx_pkg turns
-- the dashboard facet parameters into the matching transaction-id set, and
-- every handler reuses it so KPIs, charts, register and export always agree.
-- Multi-value facet params arrive pipe-delimited (a|b|c). Dates in the views
-- are VARCHAR2 'DD/MM/YYYY' strings -- ddate() parses them (0 bad rows live).
-- Amounts are AED (ledger currency; the details view is 100 percent AED).
--
-- Endpoints (base /ords/admin/ar/), all GET, any valid session:
--   trx/filters          facet LOVs + counts + min/max date
--   trx/summary          executive KPIs + 8 chart datasets for the facet set
--   trx/list             paged transaction register {items,total,totals}
--   trx/lines            paged line register (details grain, own-grain facets)
--   trx/list/export      CSV of the filtered transaction register (10k cap)
--   trx/lines/export     CSV of the filtered line register (10k cap)
--   trx/detail/[id]      one transaction: header + lines (drill window);
--                        third-segment meta pattern so it can never collide
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. Facet engine package (PROD schema, schema-qualified)
-- =============================================================================

CREATE OR REPLACE PACKAGE prod.dct_ar_trx_pkg AS

    -- 1 when p_val is one of the pipe-delimited entries in p_list
    FUNCTION in_list(p_list VARCHAR2, p_val VARCHAR2) RETURN NUMBER DETERMINISTIC;

    -- the AR views store every date as a 'DD/MM/YYYY' string -- parse or NULL
    FUNCTION ddate(p VARCHAR2) RETURN DATE DETERMINISTIC;

    -- settlement code from the remaining balance:
    -- OPEN (> 0.005) / CREDIT (< -0.005, over-applied) / SETTLED
    FUNCTION stat(p_remaining NUMBER) RETURN VARCHAR2 DETERMINISTIC;

    -- aging bucket code for an OPEN balance (NULL when settled):
    -- CUR (not yet due) / L1M / M1_3 / M3_6 / M6P -- mapped from the view's
    -- aging_category literals so the buckets match the view exactly
    FUNCTION bucket(p_remaining NUMBER, p_delay NUMBER, p_cat VARCHAR2)
        RETURN VARCHAR2 DETERMINISTIC;

    -- ids of the transactions matching every supplied facet (NULL = no filter)
    FUNCTION filtered_ids(
        p_datefrom VARCHAR2 DEFAULT NULL,   -- YYYY-MM-DD, on transaction date
        p_dateto   VARCHAR2 DEFAULT NULL,
        p_duefrom  VARCHAR2 DEFAULT NULL,   -- YYYY-MM-DD, on due date
        p_dueto    VARCHAR2 DEFAULT NULL,
        p_customer VARCHAR2 DEFAULT NULL,   -- multi, bill_to_customer_name
        p_ctype    VARCHAR2 DEFAULT NULL,   -- multi, line customer type
        p_type     VARCHAR2 DEFAULT NULL,   -- multi, transaction_type_name
        p_source   VARCHAR2 DEFAULT NULL,   -- multi, transaction_source
        p_bu       VARCHAR2 DEFAULT NULL,   -- multi, business_unit_name
        p_complete VARCHAR2 DEFAULT NULL,   -- multi, Yes|No
        p_status   VARCHAR2 DEFAULT NULL,   -- multi, OPEN|SETTLED|CREDIT
        p_aging    VARCHAR2 DEFAULT NULL,   -- multi, CUR|L1M|M1_3|M3_6|M6P
        p_terms    VARCHAR2 DEFAULT NULL,   -- multi, payment terms, (None)=blank
        p_project  VARCHAR2 DEFAULT NULL,   -- multi, line project number
        p_cc       VARCHAR2 DEFAULT NULL,   -- multi, line cost center code
        p_account  VARCHAR2 DEFAULT NULL,   -- multi, line account code
        p_memo     VARCHAR2 DEFAULT NULL,   -- multi, line memo line name
        p_glfrom   VARCHAR2 DEFAULT NULL,   -- YYYY-MM-DD, on line GL date
        p_glto     VARCHAR2 DEFAULT NULL,
        p_search   VARCHAR2 DEFAULT NULL    -- free text: number/customer/type
    ) RETURN apex_t_number;

END dct_ar_trx_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_ar_trx_pkg AS

    FUNCTION in_list(p_list VARCHAR2, p_val VARCHAR2) RETURN NUMBER DETERMINISTIC IS
    BEGIN
        RETURN CASE WHEN INSTR('|' || p_list || '|', '|' || p_val || '|') > 0
                    THEN 1 ELSE 0 END;
    END in_list;

    FUNCTION ddate(p VARCHAR2) RETURN DATE DETERMINISTIC IS
    BEGIN
        RETURN TO_DATE(p DEFAULT NULL ON CONVERSION ERROR, 'DD/MM/YYYY');
    END ddate;

    FUNCTION stat(p_remaining NUMBER) RETURN VARCHAR2 DETERMINISTIC IS
    BEGIN
        RETURN CASE WHEN NVL(p_remaining, 0) >  0.005 THEN 'OPEN'
                    WHEN NVL(p_remaining, 0) < -0.005 THEN 'CREDIT'
                    ELSE 'SETTLED' END;
    END stat;

    FUNCTION bucket(p_remaining NUMBER, p_delay NUMBER, p_cat VARCHAR2)
        RETURN VARCHAR2 DETERMINISTIC IS
    BEGIN
        IF stat(p_remaining) = 'SETTLED' THEN RETURN NULL; END IF;
        RETURN CASE WHEN p_cat = 'NOT DUE' OR NVL(p_delay, 0) <= 0 THEN 'CUR'
                    WHEN p_cat = 'LESS THAN 1 MONTH'              THEN 'L1M'
                    WHEN p_cat = '1 - 3 MONTHS'                   THEN 'M1_3'
                    WHEN p_cat = '3 - 6 MONTHS'                   THEN 'M3_6'
                    ELSE 'M6P' END;
    END bucket;

    FUNCTION filtered_ids(
        p_datefrom VARCHAR2 DEFAULT NULL,
        p_dateto   VARCHAR2 DEFAULT NULL,
        p_duefrom  VARCHAR2 DEFAULT NULL,
        p_dueto    VARCHAR2 DEFAULT NULL,
        p_customer VARCHAR2 DEFAULT NULL,
        p_ctype    VARCHAR2 DEFAULT NULL,
        p_type     VARCHAR2 DEFAULT NULL,
        p_source   VARCHAR2 DEFAULT NULL,
        p_bu       VARCHAR2 DEFAULT NULL,
        p_complete VARCHAR2 DEFAULT NULL,
        p_status   VARCHAR2 DEFAULT NULL,
        p_aging    VARCHAR2 DEFAULT NULL,
        p_terms    VARCHAR2 DEFAULT NULL,
        p_project  VARCHAR2 DEFAULT NULL,
        p_cc       VARCHAR2 DEFAULT NULL,
        p_account  VARCHAR2 DEFAULT NULL,
        p_memo     VARCHAR2 DEFAULT NULL,
        p_glfrom   VARCHAR2 DEFAULT NULL,
        p_glto     VARCHAR2 DEFAULT NULL,
        p_search   VARCHAR2 DEFAULT NULL
    ) RETURN apex_t_number IS
        -- performance note (AP lesson): one scan of each view into an id-set
        -- intersected in memory; never correlated EXISTS across the views.
        l_ids     apex_t_number;
        l_tmp     apex_t_number;
        l_from    DATE := TO_DATE(p_datefrom DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
        l_to      DATE := TO_DATE(p_dateto   DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
        l_duefrom DATE := TO_DATE(p_duefrom  DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
        l_dueto   DATE := TO_DATE(p_dueto    DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
        l_glfrom  DATE := TO_DATE(p_glfrom   DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
        l_glto    DATE := TO_DATE(p_glto     DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD');
    BEGIN
        SELECT a.transaction_id BULK COLLECT INTO l_ids
          FROM prod.ar_transaction_aging_v a
         WHERE (l_from    IS NULL OR ddate(a.transaction_date) >= l_from)
           AND (l_to      IS NULL OR ddate(a.transaction_date) <  l_to + 1)
           AND (l_duefrom IS NULL OR ddate(a.due_date) >= l_duefrom)
           AND (l_dueto   IS NULL OR ddate(a.due_date) <  l_dueto + 1)
           AND (p_customer IS NULL OR in_list(p_customer, a.bill_to_customer_name) = 1)
           AND (p_type     IS NULL OR in_list(p_type,     a.transaction_type_name) = 1)
           AND (p_source   IS NULL OR in_list(p_source,   a.transaction_source) = 1)
           AND (p_bu       IS NULL OR in_list(p_bu,       a.business_unit_name) = 1)
           AND (p_complete IS NULL OR in_list(p_complete, a.transaction_complete) = 1)
           AND (p_status   IS NULL OR in_list(p_status,   stat(a.remaining_amount)) = 1)
           AND (p_aging    IS NULL OR in_list(p_aging,
                    NVL(bucket(a.remaining_amount, a.delay_days, a.aging_category), '~')) = 1)
           AND (p_terms    IS NULL OR in_list(p_terms, NVL(a.payment_terms_name, '(None)')) = 1)
           AND (p_search IS NULL OR
                UPPER(a.transaction_number || ' ' || a.bill_to_customer_name || ' ' ||
                      a.transaction_type_name) LIKE '%' || UPPER(p_search) || '%');

        -- line-grain facets: ONE scan of the details view, all line criteria
        -- ANDed on the row (the line register re-applies the same predicates,
        -- so a line drill always reconciles with the header count)
        IF p_ctype IS NOT NULL OR p_project IS NOT NULL OR p_cc IS NOT NULL
           OR p_account IS NOT NULL OR p_memo IS NOT NULL
           OR l_glfrom IS NOT NULL OR l_glto IS NOT NULL THEN
            SELECT DISTINCT d.transaction_id BULK COLLECT INTO l_tmp
              FROM prod.ar_transaction_details_v d
             WHERE (p_ctype   IS NULL OR in_list(p_ctype, NVL(d.bill_to_customer_type, '(None)')) = 1)
               AND (p_project IS NULL OR in_list(p_project, TO_CHAR(d.project)) = 1)
               AND (p_cc      IS NULL OR in_list(p_cc, TO_CHAR(d.cost_center)) = 1)
               AND (p_account IS NULL OR in_list(p_account, TO_CHAR(d.account_code)) = 1)
               AND (p_memo    IS NULL OR in_list(p_memo, NVL(d.memo_line_name, '(None)')) = 1)
               AND (l_glfrom  IS NULL OR ddate(d.gl_date) >= l_glfrom)
               AND (l_glto    IS NULL OR ddate(d.gl_date) <  l_glto + 1);
            l_ids := l_ids MULTISET INTERSECT DISTINCT l_tmp;
        END IF;

        RETURN l_ids;
    END filtered_ids;

END dct_ar_trx_pkg;
/

SHOW ERRORS

-- =============================================================================
-- 2. Templates + handlers (additive on ar.rest)
-- =============================================================================

CREATE OR REPLACE PROCEDURE setup_ar_trx_ords_a AS
    c_mod CONSTANT VARCHAR2(30) := 'ar.rest';
    PROCEDURE def_tpl(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_h(p_pattern VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => 'GET',
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    def_tpl('trx/filters');
    def_h('trx/filters', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_min VARCHAR2(10); l_max VARCHAR2(10);
  PROCEDURE nc(p_n VARCHAR2, p_c NUMBER) IS
  BEGIN
    APEX_JSON.open_object; APEX_JSON.write('name', p_n);
    APEX_JSON.write('count', p_c); APEX_JSON.close_object;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT TO_CHAR(MIN(prod.dct_ar_trx_pkg.ddate(transaction_date)),'YYYY-MM-DD'),
         TO_CHAR(MAX(prod.dct_ar_trx_pkg.ddate(transaction_date)),'YYYY-MM-DD')
    INTO l_min, l_max FROM prod.ar_transaction_aging_v;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('minDate', l_min); APEX_JSON.write('maxDate', l_max);
  APEX_JSON.open_array('businessUnits');
  FOR r IN (SELECT business_unit_name v, COUNT(*) c FROM prod.ar_transaction_aging_v WHERE business_unit_name IS NOT NULL GROUP BY business_unit_name ORDER BY 2 DESC) LOOP nc(r.v, r.c); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('status');
  FOR r IN (SELECT prod.dct_ar_trx_pkg.stat(remaining_amount) v, COUNT(*) c FROM prod.ar_transaction_aging_v GROUP BY prod.dct_ar_trx_pkg.stat(remaining_amount) ORDER BY 2 DESC) LOOP nc(r.v, r.c); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('aging');
  FOR r IN (SELECT b v, COUNT(*) c FROM (SELECT prod.dct_ar_trx_pkg.bucket(remaining_amount, delay_days, aging_category) b FROM prod.ar_transaction_aging_v) WHERE b IS NOT NULL GROUP BY b ORDER BY 2 DESC) LOOP nc(r.v, r.c); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('sources');
  FOR r IN (SELECT transaction_source v, COUNT(*) c FROM prod.ar_transaction_aging_v WHERE transaction_source IS NOT NULL GROUP BY transaction_source ORDER BY 2 DESC) LOOP nc(r.v, r.c); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('types');
  FOR r IN (SELECT transaction_type_name v, COUNT(*) c FROM prod.ar_transaction_aging_v WHERE transaction_type_name IS NOT NULL GROUP BY transaction_type_name ORDER BY 2 DESC) LOOP nc(r.v, r.c); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('complete');
  FOR r IN (SELECT transaction_complete v, COUNT(*) c FROM prod.ar_transaction_aging_v WHERE transaction_complete IS NOT NULL GROUP BY transaction_complete ORDER BY 2 DESC) LOOP nc(r.v, r.c); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('terms');
  FOR r IN (SELECT NVL(payment_terms_name,'(None)') v, COUNT(*) c FROM prod.ar_transaction_aging_v GROUP BY NVL(payment_terms_name,'(None)') ORDER BY 2 DESC) LOOP nc(r.v, r.c); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('custTypes');
  FOR r IN (SELECT NVL(bill_to_customer_type,'(None)') v, COUNT(DISTINCT transaction_id) c FROM prod.ar_transaction_details_v GROUP BY NVL(bill_to_customer_type,'(None)') ORDER BY 2 DESC) LOOP nc(r.v, r.c); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('customers');
  FOR r IN (SELECT DISTINCT bill_to_customer_name v FROM prod.ar_transaction_aging_v WHERE bill_to_customer_name IS NOT NULL ORDER BY 1) LOOP APEX_JSON.write(r.v); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('memoLines');
  FOR r IN (SELECT DISTINCT memo_line_name v FROM prod.ar_transaction_details_v WHERE memo_line_name IS NOT NULL ORDER BY 1) LOOP APEX_JSON.write(r.v); END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('projects');
  FOR r IN (SELECT DISTINCT TO_CHAR(project) cd, project_name nm FROM prod.ar_transaction_details_v WHERE project IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.cd); APEX_JSON.write('name', r.nm); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('costCenters');
  FOR r IN (SELECT DISTINCT TO_CHAR(cost_center) cd, cost_center_discription nm FROM prod.ar_transaction_details_v WHERE cost_center IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.cd); APEX_JSON.write('name', r.nm); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.open_array('accounts');
  FOR r IN (SELECT DISTINCT TO_CHAR(account_code) cd, account_discription nm FROM prod.ar_transaction_details_v WHERE account_code IS NOT NULL ORDER BY 1) LOOP
    APEX_JSON.open_object; APEX_JSON.write('code', r.cd); APEX_JSON.write('name', r.nm); APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_ar_trx_ords_a;
/

BEGIN setup_ar_trx_ords_a; END;
/
DROP PROCEDURE setup_ar_trx_ords_a;

PROMPT part A done (trx/filters)

CREATE OR REPLACE PROCEDURE setup_ar_trx_ords_b AS
    c_mod CONSTANT VARCHAR2(30) := 'ar.rest';
    PROCEDURE def_tpl(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_h(p_pattern VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => 'GET',
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    def_tpl('trx/summary');
    def_h('trx/summary', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_ids  apex_t_number;
  k_cnt NUMBER; k_cust NUMBER; k_inv NUMBER; k_app NUMBER; k_cradj NUMBER;
  k_out NUMBER; k_over NUMBER; k_open NUMBER; k_settled NUMBER; k_credit NUMBER; k_avgdel NUMBER;
  l_floor DATE := CASE WHEN [COLON]datefrom IS NULL AND [COLON]dateto IS NULL
                        AND [COLON]glfrom IS NULL AND [COLON]glto IS NULL
                        AND [COLON]duefrom IS NULL AND [COLON]dueto IS NULL
                       THEN TRUNC(SYSDATE,'YYYY') END;
  PROCEDURE nco(p_n VARCHAR2, p_c NUMBER, p_a NUMBER) IS
  BEGIN
    APEX_JSON.open_object; APEX_JSON.write('name', p_n);
    APEX_JSON.write('count', p_c); APEX_JSON.write('amount', ROUND(p_a, 2));
    APEX_JSON.close_object;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_ids := prod.dct_ar_trx_pkg.filtered_ids(
    p_datefrom => [COLON]datefrom, p_dateto => [COLON]dateto,
    p_duefrom => [COLON]duefrom, p_dueto => [COLON]dueto,
    p_customer => [COLON]customer, p_ctype => [COLON]ctype, p_type => [COLON]ttype,
    p_source => [COLON]source, p_bu => [COLON]bu, p_complete => [COLON]complete,
    p_status => [COLON]status, p_aging => [COLON]aging, p_terms => [COLON]terms,
    p_project => [COLON]project, p_cc => [COLON]cc, p_account => [COLON]account,
    p_memo => [COLON]memo, p_glfrom => [COLON]glfrom, p_glto => [COLON]glto,
    p_search => [COLON]search);
  SELECT COUNT(*), COUNT(DISTINCT a.bill_to_customer_name),
         NVL(SUM(a.transaction_entered_amount),0),
         NVL(SUM(a.applied_amount),0),
         NVL(SUM(a.credit_amount),0) + NVL(SUM(a.adj_amount),0),
         NVL(SUM(a.remaining_amount),0),
         NVL(SUM(CASE WHEN a.remaining_amount > 0 AND a.delay_days > 0 THEN a.remaining_amount END),0),
         COUNT(CASE WHEN prod.dct_ar_trx_pkg.stat(a.remaining_amount) = 'OPEN' THEN 1 END),
         COUNT(CASE WHEN prod.dct_ar_trx_pkg.stat(a.remaining_amount) = 'SETTLED' THEN 1 END),
         COUNT(CASE WHEN prod.dct_ar_trx_pkg.stat(a.remaining_amount) = 'CREDIT' THEN 1 END),
         NVL(ROUND(AVG(CASE WHEN a.remaining_amount > 0 AND a.delay_days > 0 THEN a.delay_days END)),0)
    INTO k_cnt, k_cust, k_inv, k_app, k_cradj, k_out, k_over, k_open, k_settled, k_credit, k_avgdel
    FROM prod.ar_transaction_aging_v a
   WHERE a.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.open_object('kpis');
  APEX_JSON.write('transactions', k_cnt); APEX_JSON.write('customers', k_cust);
  APEX_JSON.write('invoicedAed', ROUND(k_inv,2)); APEX_JSON.write('appliedAed', ROUND(k_app,2));
  APEX_JSON.write('creditAdjAed', ROUND(k_cradj,2)); APEX_JSON.write('outstandingAed', ROUND(k_out,2));
  APEX_JSON.write('overdueAed', ROUND(k_over,2));
  APEX_JSON.write('openCount', k_open); APEX_JSON.write('settledCount', k_settled);
  APEX_JSON.write('creditCount', k_credit); APEX_JSON.write('avgDelayDays', k_avgdel);
  APEX_JSON.write('collectionRate', CASE WHEN k_inv <> 0 THEN ROUND(100 * k_app / k_inv, 1) ELSE 0 END);
  APEX_JSON.close_object;
  APEX_JSON.open_array('aging');
  FOR r IN (SELECT b, COUNT(*) c, NVL(SUM(rem),0) amt FROM (
              SELECT prod.dct_ar_trx_pkg.bucket(a.remaining_amount, a.delay_days, a.aging_category) b,
                     a.remaining_amount rem
                FROM prod.ar_transaction_aging_v a
               WHERE a.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t))
             WHERE b IS NOT NULL GROUP BY b) LOOP
    APEX_JSON.open_object; APEX_JSON.write('bucket', r.b);
    APEX_JSON.write('count', r.c); APEX_JSON.write('amount', ROUND(r.amt,2));
    APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('settlement');
  FOR r IN (SELECT prod.dct_ar_trx_pkg.stat(a.remaining_amount) v, COUNT(*) c,
                   NVL(SUM(a.transaction_entered_amount),0) amt
              FROM prod.ar_transaction_aging_v a
             WHERE a.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
             GROUP BY prod.dct_ar_trx_pkg.stat(a.remaining_amount) ORDER BY 2 DESC) LOOP
    nco(r.v, r.c, r.amt);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('trend');
  FOR r IN (SELECT m, c, a FROM (
              SELECT TO_CHAR(prod.dct_ar_trx_pkg.ddate(x.transaction_date),'YYYY-MM') m,
                     COUNT(*) c, NVL(SUM(x.transaction_entered_amount),0) a
                FROM prod.ar_transaction_aging_v x
               WHERE x.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
                 AND (l_floor IS NULL OR prod.dct_ar_trx_pkg.ddate(x.transaction_date) >= l_floor)
               GROUP BY TO_CHAR(prod.dct_ar_trx_pkg.ddate(x.transaction_date),'YYYY-MM')
               ORDER BY m DESC FETCH FIRST 60 ROWS ONLY) WHERE m IS NOT NULL ORDER BY m) LOOP
    APEX_JSON.open_object; APEX_JSON.write('month', r.m);
    APEX_JSON.write('count', r.c); APEX_JSON.write('amount', ROUND(r.a,2));
    APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('topCustomers');
  FOR r IN (SELECT a.bill_to_customer_name v, COUNT(*) c, NVL(SUM(a.remaining_amount),0) amt,
                   NVL(SUM(a.transaction_entered_amount),0) inv
              FROM prod.ar_transaction_aging_v a
             WHERE a.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
             GROUP BY a.bill_to_customer_name
             ORDER BY 3 DESC FETCH FIRST 10 ROWS ONLY) LOOP
    APEX_JSON.open_object; APEX_JSON.write('name', r.v); APEX_JSON.write('count', r.c);
    APEX_JSON.write('amount', ROUND(r.amt,2)); APEX_JSON.write('invoiced', ROUND(r.inv,2));
    APEX_JSON.close_object;
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('byType');
  FOR r IN (SELECT a.transaction_type_name v, COUNT(*) c, NVL(SUM(a.transaction_entered_amount),0) amt
              FROM prod.ar_transaction_aging_v a
             WHERE a.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
             GROUP BY a.transaction_type_name ORDER BY 3 DESC FETCH FIRST 12 ROWS ONLY) LOOP
    nco(r.v, r.c, r.amt);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('bySource');
  FOR r IN (SELECT a.transaction_source v, COUNT(*) c, NVL(SUM(a.transaction_entered_amount),0) amt
              FROM prod.ar_transaction_aging_v a
             WHERE a.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
             GROUP BY a.transaction_source ORDER BY 3 DESC) LOOP
    nco(r.v, r.c, r.amt);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('byBu');
  FOR r IN (SELECT a.business_unit_name v, COUNT(*) c, NVL(SUM(a.transaction_entered_amount),0) amt
              FROM prod.ar_transaction_aging_v a
             WHERE a.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
             GROUP BY a.business_unit_name ORDER BY 3 DESC) LOOP
    nco(r.v, r.c, r.amt);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.open_array('byCostCenter');
  FOR r IN (SELECT NVL(d.cost_center_discription, NVL(TO_CHAR(d.cost_center), '(None)')) v,
                   COUNT(DISTINCT d.transaction_id) c, NVL(SUM(d.revenue_amount),0) amt
              FROM prod.ar_transaction_details_v d
             WHERE d.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
             GROUP BY NVL(d.cost_center_discription, NVL(TO_CHAR(d.cost_center), '(None)'))
             ORDER BY 3 DESC FETCH FIRST 10 ROWS ONLY) LOOP
    nco(r.v, r.c, r.amt);
  END LOOP; APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_ar_trx_ords_b;
/

BEGIN setup_ar_trx_ords_b; END;
/
DROP PROCEDURE setup_ar_trx_ords_b;

PROMPT part B done (trx/summary)

CREATE OR REPLACE PROCEDURE setup_ar_trx_ords_c AS
    c_mod CONSTANT VARCHAR2(30) := 'ar.rest';
    PROCEDURE def_tpl(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_h(p_pattern VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => 'GET',
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    def_tpl('trx/list');
    def_h('trx/list', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_ids    apex_t_number;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 25), 10000);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_sort   VARCHAR2(30) := LOWER([COLON]sort);
  l_inv NUMBER; l_app NUMBER; l_rem NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_ids := prod.dct_ar_trx_pkg.filtered_ids(
    p_datefrom => [COLON]datefrom, p_dateto => [COLON]dateto,
    p_duefrom => [COLON]duefrom, p_dueto => [COLON]dueto,
    p_customer => [COLON]customer, p_ctype => [COLON]ctype, p_type => [COLON]ttype,
    p_source => [COLON]source, p_bu => [COLON]bu, p_complete => [COLON]complete,
    p_status => [COLON]status, p_aging => [COLON]aging, p_terms => [COLON]terms,
    p_project => [COLON]project, p_cc => [COLON]cc, p_account => [COLON]account,
    p_memo => [COLON]memo, p_glfrom => [COLON]glfrom, p_glto => [COLON]glto,
    p_search => [COLON]search);
  SELECT NVL(SUM(a.transaction_entered_amount),0), NVL(SUM(a.applied_amount),0), NVL(SUM(a.remaining_amount),0)
    INTO l_inv, l_app, l_rem
    FROM prod.ar_transaction_aging_v a
   WHERE a.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_ids.COUNT); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_object('totals');
  APEX_JSON.write('invoicedAed', ROUND(l_inv,2)); APEX_JSON.write('appliedAed', ROUND(l_app,2));
  APEX_JSON.write('remainingAed', ROUND(l_rem,2));
  APEX_JSON.close_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT a.transaction_id, a.transaction_number,
           TO_CHAR(prod.dct_ar_trx_pkg.ddate(a.transaction_date),'YYYY-MM-DD') trx_dt,
           TO_CHAR(prod.dct_ar_trx_pkg.ddate(a.due_date),'YYYY-MM-DD') due_dt,
           a.bill_to_customer_name, a.business_unit_name, a.transaction_complete,
           a.payment_terms_name, a.transaction_type_name, a.transaction_source,
           a.created_by_user_name, a.transaction_entered_amount, a.applied_amount,
           a.adj_amount, a.credit_amount, a.remaining_amount,
           prod.dct_ar_trx_pkg.stat(a.remaining_amount) st,
           prod.dct_ar_trx_pkg.bucket(a.remaining_amount, a.delay_days, a.aging_category) bk,
           CASE WHEN a.remaining_amount > 0 THEN GREATEST(a.delay_days, 0) END delay_d
      FROM prod.ar_transaction_aging_v a
     WHERE a.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
     ORDER BY CASE WHEN l_sort = 'date_asc'      THEN prod.dct_ar_trx_pkg.ddate(a.transaction_date) END ASC,
              CASE WHEN l_sort = 'amount_desc'   THEN a.transaction_entered_amount END DESC,
              CASE WHEN l_sort = 'amount_asc'    THEN a.transaction_entered_amount END ASC,
              CASE WHEN l_sort = 'balance_desc'  THEN a.remaining_amount END DESC,
              CASE WHEN l_sort = 'delay_desc'    THEN CASE WHEN a.remaining_amount > 0 THEN a.delay_days END END DESC NULLS LAST,
              CASE WHEN l_sort = 'customer_asc'  THEN a.bill_to_customer_name END ASC,
              CASE WHEN l_sort = 'customer_desc' THEN a.bill_to_customer_name END DESC,
              prod.dct_ar_trx_pkg.ddate(a.transaction_date) DESC NULLS LAST, a.transaction_id DESC
     OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.transaction_id);
    APEX_JSON.write('trxNumber', r.transaction_number);
    APEX_JSON.write('trxDate', r.trx_dt);
    APEX_JSON.write('dueDate', r.due_dt);
    APEX_JSON.write('customer', r.bill_to_customer_name);
    APEX_JSON.write('businessUnit', r.business_unit_name);
    APEX_JSON.write('trxType', r.transaction_type_name);
    APEX_JSON.write('source', r.transaction_source);
    APEX_JSON.write('complete', r.transaction_complete);
    APEX_JSON.write('terms', r.payment_terms_name);
    APEX_JSON.write('createdBy', r.created_by_user_name);
    APEX_JSON.write('enteredAed', r.transaction_entered_amount);
    APEX_JSON.write('appliedAed', r.applied_amount);
    APEX_JSON.write('adjAed', r.adj_amount);
    APEX_JSON.write('creditAed', r.credit_amount);
    APEX_JSON.write('remainingAed', r.remaining_amount);
    APEX_JSON.write('status', r.st);
    IF r.bk IS NOT NULL THEN APEX_JSON.write('aging', r.bk); END IF;
    IF r.delay_d IS NOT NULL THEN APEX_JSON.write('delayDays', r.delay_d); END IF;
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_ar_trx_ords_c;
/

BEGIN setup_ar_trx_ords_c; END;
/
DROP PROCEDURE setup_ar_trx_ords_c;

PROMPT part C done (trx/list)

CREATE OR REPLACE PROCEDURE setup_ar_trx_ords_d AS
    c_mod CONSTANT VARCHAR2(30) := 'ar.rest';
    PROCEDURE def_tpl(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_h(p_pattern VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => 'GET',
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    def_tpl('trx/lines');
    def_h('trx/lines', q'!
DECLARE
  l_user   VARCHAR2(100) := dct_rest.validate_session;
  l_ids    apex_t_number;
  l_limit  NUMBER := LEAST(NVL(TO_NUMBER([COLON]limit  DEFAULT NULL ON CONVERSION ERROR), 25), 10000);
  l_offset NUMBER := GREATEST(NVL(TO_NUMBER([COLON]offset DEFAULT NULL ON CONVERSION ERROR), 0), 0);
  l_sort   VARCHAR2(30) := LOWER([COLON]sort);
  l_glf    DATE := TO_DATE([COLON]glfrom DEFAULT NULL ON CONVERSION ERROR,'YYYY-MM-DD');
  l_glt    DATE := TO_DATE([COLON]glto   DEFAULT NULL ON CONVERSION ERROR,'YYYY-MM-DD');
  l_rev NUMBER; l_tax NUMBER; l_cnt NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_ids := prod.dct_ar_trx_pkg.filtered_ids(
    p_datefrom => [COLON]datefrom, p_dateto => [COLON]dateto,
    p_duefrom => [COLON]duefrom, p_dueto => [COLON]dueto,
    p_customer => [COLON]customer, p_ctype => [COLON]ctype, p_type => [COLON]ttype,
    p_source => [COLON]source, p_bu => [COLON]bu, p_complete => [COLON]complete,
    p_status => [COLON]status, p_aging => [COLON]aging, p_terms => [COLON]terms,
    p_project => [COLON]project, p_cc => [COLON]cc, p_account => [COLON]account,
    p_memo => [COLON]memo, p_glfrom => [COLON]glfrom, p_glto => [COLON]glto,
    p_search => [COLON]search);
  SELECT COUNT(*), NVL(SUM(d.revenue_amount),0), NVL(SUM(d.tax_amount),0)
    INTO l_cnt, l_rev, l_tax
    FROM prod.ar_transaction_details_v d
   WHERE d.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
     AND ([COLON]ctype   IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]ctype, NVL(d.bill_to_customer_type,'(None)')) = 1)
     AND ([COLON]project IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]project, TO_CHAR(d.project)) = 1)
     AND ([COLON]cc      IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]cc, TO_CHAR(d.cost_center)) = 1)
     AND ([COLON]account IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]account, TO_CHAR(d.account_code)) = 1)
     AND ([COLON]memo    IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]memo, NVL(d.memo_line_name,'(None)')) = 1)
     AND (l_glf IS NULL OR prod.dct_ar_trx_pkg.ddate(d.gl_date) >= l_glf)
     AND (l_glt IS NULL OR prod.dct_ar_trx_pkg.ddate(d.gl_date) <  l_glt + 1);
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  APEX_JSON.write('total', l_cnt); APEX_JSON.write('limit', l_limit); APEX_JSON.write('offset', l_offset);
  APEX_JSON.open_object('totals');
  APEX_JSON.write('revenueAed', ROUND(l_rev,2)); APEX_JSON.write('taxAed', ROUND(l_tax,2));
  APEX_JSON.close_object;
  APEX_JSON.open_array('items');
  FOR r IN (
    SELECT d.transaction_id, d.transaction_number, d.transaction_line_number,
           TO_CHAR(prod.dct_ar_trx_pkg.ddate(d.transaction_date),'YYYY-MM-DD') trx_dt,
           TO_CHAR(prod.dct_ar_trx_pkg.ddate(d.gl_date),'YYYY-MM-DD') gl_dt,
           d.bill_to_customer_name, d.bill_to_customer_number, d.bill_to_customer_type,
           d.business_unit_name, d.transaction_type_name, d.transaction_source,
           d.transaction_complete, d.memo_line_name, d.memo_line_description,
           d.transaction_line_descripti line_desc, d.service_description_2,
           TO_CHAR(d.project) project_no, d.project_name, d.task, d.task_number,
           d.revenue_amount, d.tax_amount, d.ledger_currency,
           d.revenue_gl_account, d.receivables_concatenated,
           TO_CHAR(d.cost_center) cc_code, d.cost_center_discription cc_desc,
           TO_CHAR(d.account_code) acct_code, d.account_discription acct_desc,
           d.tax_classification_code, d.created_by_user_name
      FROM prod.ar_transaction_details_v d
     WHERE d.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
       AND ([COLON]ctype   IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]ctype, NVL(d.bill_to_customer_type,'(None)')) = 1)
       AND ([COLON]project IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]project, TO_CHAR(d.project)) = 1)
       AND ([COLON]cc      IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]cc, TO_CHAR(d.cost_center)) = 1)
       AND ([COLON]account IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]account, TO_CHAR(d.account_code)) = 1)
       AND ([COLON]memo    IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]memo, NVL(d.memo_line_name,'(None)')) = 1)
       AND (l_glf IS NULL OR prod.dct_ar_trx_pkg.ddate(d.gl_date) >= l_glf)
       AND (l_glt IS NULL OR prod.dct_ar_trx_pkg.ddate(d.gl_date) <  l_glt + 1)
     ORDER BY CASE WHEN l_sort = 'date_asc'     THEN prod.dct_ar_trx_pkg.ddate(d.transaction_date) END ASC,
              CASE WHEN l_sort = 'gldate_desc'  THEN prod.dct_ar_trx_pkg.ddate(d.gl_date) END DESC NULLS LAST,
              CASE WHEN l_sort = 'gldate_asc'   THEN prod.dct_ar_trx_pkg.ddate(d.gl_date) END ASC,
              CASE WHEN l_sort = 'amount_desc'  THEN d.revenue_amount END DESC,
              CASE WHEN l_sort = 'amount_asc'   THEN d.revenue_amount END ASC,
              CASE WHEN l_sort = 'customer_asc' THEN d.bill_to_customer_name END ASC,
              prod.dct_ar_trx_pkg.ddate(d.transaction_date) DESC NULLS LAST,
              d.transaction_id DESC, d.transaction_line_number ASC
     OFFSET l_offset ROWS FETCH NEXT l_limit ROWS ONLY)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('id', r.transaction_id);
    APEX_JSON.write('trxNumber', r.transaction_number);
    APEX_JSON.write('lineNumber', r.transaction_line_number);
    APEX_JSON.write('trxDate', r.trx_dt);
    APEX_JSON.write('glDate', r.gl_dt);
    APEX_JSON.write('customer', r.bill_to_customer_name);
    APEX_JSON.write('customerNumber', r.bill_to_customer_number);
    APEX_JSON.write('customerType', r.bill_to_customer_type);
    APEX_JSON.write('businessUnit', r.business_unit_name);
    APEX_JSON.write('trxType', r.transaction_type_name);
    APEX_JSON.write('source', r.transaction_source);
    APEX_JSON.write('complete', r.transaction_complete);
    APEX_JSON.write('memoLine', r.memo_line_name);
    APEX_JSON.write('memoDesc', r.memo_line_description);
    APEX_JSON.write('description', NVL(r.line_desc, r.service_description_2));
    APEX_JSON.write('projectNumber', r.project_no);
    APEX_JSON.write('projectName', r.project_name);
    APEX_JSON.write('taskName', r.task);
    APEX_JSON.write('taskNumber', r.task_number);
    APEX_JSON.write('revenueAed', r.revenue_amount);
    APEX_JSON.write('taxAed', r.tax_amount);
    APEX_JSON.write('currency', r.ledger_currency);
    APEX_JSON.write('glAccount', r.revenue_gl_account);
    APEX_JSON.write('receivablesAccount', r.receivables_concatenated);
    APEX_JSON.write('costCenterCode', r.cc_code);
    APEX_JSON.write('costCenterDesc', r.cc_desc);
    APEX_JSON.write('accountCode', r.acct_code);
    APEX_JSON.write('accountDesc', r.acct_desc);
    APEX_JSON.write('taxClass', r.tax_classification_code);
    APEX_JSON.write('createdBy', r.created_by_user_name);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_ar_trx_ords_d;
/

BEGIN setup_ar_trx_ords_d; END;
/
DROP PROCEDURE setup_ar_trx_ords_d;

PROMPT part D done (trx/lines)

CREATE OR REPLACE PROCEDURE setup_ar_trx_ords_e AS
    c_mod CONSTANT VARCHAR2(30) := 'ar.rest';
    PROCEDURE def_tpl(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_h(p_pattern VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => 'GET',
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    def_tpl('trx/list/export');
    def_h('trx/list/export', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_ids  apex_t_number;
  FUNCTION esc(p VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF p IS NULL THEN RETURN NULL; END IF;
    IF INSTR(p,'"') > 0 OR INSTR(p,',') > 0 OR INSTR(p,CHR(10)) > 0 THEN
      RETURN '"' || REPLACE(p,'"','""') || '"';
    END IF;
    RETURN p;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_ids := prod.dct_ar_trx_pkg.filtered_ids(
    p_datefrom => [COLON]datefrom, p_dateto => [COLON]dateto,
    p_duefrom => [COLON]duefrom, p_dueto => [COLON]dueto,
    p_customer => [COLON]customer, p_ctype => [COLON]ctype, p_type => [COLON]ttype,
    p_source => [COLON]source, p_bu => [COLON]bu, p_complete => [COLON]complete,
    p_status => [COLON]status, p_aging => [COLON]aging, p_terms => [COLON]terms,
    p_project => [COLON]project, p_cc => [COLON]cc, p_account => [COLON]account,
    p_memo => [COLON]memo, p_glfrom => [COLON]glfrom, p_glto => [COLON]glto,
    p_search => [COLON]search);
  OWA_UTIL.mime_header('text/csv', FALSE, 'UTF-8');
  HTP.p('Content-Disposition: attachment; filename="ar-transactions-' || TO_CHAR(SYSDATE,'YYYY-MM-DD') || '.csv"');
  OWA_UTIL.http_header_close;
  HTP.prn(UNISTR('\FEFF'));
  HTP.p('Transaction No,Date,Due Date,Customer,Business Unit,Type,Source,Complete,Payment Terms,Invoiced AED,Applied AED,Adjustments AED,Credits AED,Remaining AED,Status,Aging,Days Overdue');
  FOR r IN (
    SELECT a.transaction_number, TO_CHAR(prod.dct_ar_trx_pkg.ddate(a.transaction_date),'YYYY-MM-DD') trx_dt,
           TO_CHAR(prod.dct_ar_trx_pkg.ddate(a.due_date),'YYYY-MM-DD') due_dt,
           a.bill_to_customer_name, a.business_unit_name, a.transaction_type_name,
           a.transaction_source, a.transaction_complete, a.payment_terms_name,
           a.transaction_entered_amount, a.applied_amount, a.adj_amount, a.credit_amount,
           a.remaining_amount,
           prod.dct_ar_trx_pkg.stat(a.remaining_amount) st,
           prod.dct_ar_trx_pkg.bucket(a.remaining_amount, a.delay_days, a.aging_category) bk,
           CASE WHEN a.remaining_amount > 0 THEN GREATEST(a.delay_days,0) END delay_d
      FROM prod.ar_transaction_aging_v a
     WHERE a.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
     ORDER BY prod.dct_ar_trx_pkg.ddate(a.transaction_date) DESC NULLS LAST, a.transaction_id DESC
     FETCH FIRST 10000 ROWS ONLY)
  LOOP
    HTP.p(esc(r.transaction_number) || ',' || r.trx_dt || ',' || r.due_dt || ',' ||
          esc(r.bill_to_customer_name) || ',' || esc(r.business_unit_name) || ',' ||
          esc(r.transaction_type_name) || ',' || esc(r.transaction_source) || ',' ||
          r.transaction_complete || ',' || esc(r.payment_terms_name) || ',' ||
          r.transaction_entered_amount || ',' || r.applied_amount || ',' ||
          r.adj_amount || ',' || r.credit_amount || ',' || r.remaining_amount || ',' ||
          r.st || ',' || r.bk || ',' || r.delay_d);
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    def_tpl('trx/lines/export');
    def_h('trx/lines/export', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_ids  apex_t_number;
  l_glf  DATE := TO_DATE([COLON]glfrom DEFAULT NULL ON CONVERSION ERROR,'YYYY-MM-DD');
  l_glt  DATE := TO_DATE([COLON]glto   DEFAULT NULL ON CONVERSION ERROR,'YYYY-MM-DD');
  FUNCTION esc(p VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF p IS NULL THEN RETURN NULL; END IF;
    IF INSTR(p,'"') > 0 OR INSTR(p,',') > 0 OR INSTR(p,CHR(10)) > 0 THEN
      RETURN '"' || REPLACE(p,'"','""') || '"';
    END IF;
    RETURN p;
  END;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_ids := prod.dct_ar_trx_pkg.filtered_ids(
    p_datefrom => [COLON]datefrom, p_dateto => [COLON]dateto,
    p_duefrom => [COLON]duefrom, p_dueto => [COLON]dueto,
    p_customer => [COLON]customer, p_ctype => [COLON]ctype, p_type => [COLON]ttype,
    p_source => [COLON]source, p_bu => [COLON]bu, p_complete => [COLON]complete,
    p_status => [COLON]status, p_aging => [COLON]aging, p_terms => [COLON]terms,
    p_project => [COLON]project, p_cc => [COLON]cc, p_account => [COLON]account,
    p_memo => [COLON]memo, p_glfrom => [COLON]glfrom, p_glto => [COLON]glto,
    p_search => [COLON]search);
  OWA_UTIL.mime_header('text/csv', FALSE, 'UTF-8');
  HTP.p('Content-Disposition: attachment; filename="ar-transaction-lines-' || TO_CHAR(SYSDATE,'YYYY-MM-DD') || '.csv"');
  OWA_UTIL.http_header_close;
  HTP.prn(UNISTR('\FEFF'));
  HTP.p('Transaction No,Line,Date,GL Date,Customer,Customer Type,Business Unit,Type,Source,Memo Line,Description,Project,Project Name,Task,Revenue AED,Tax AED,Revenue GL Account,Cost Center,Cost Center Name,Account,Account Name');
  FOR r IN (
    SELECT d.transaction_number, d.transaction_line_number,
           TO_CHAR(prod.dct_ar_trx_pkg.ddate(d.transaction_date),'YYYY-MM-DD') trx_dt,
           TO_CHAR(prod.dct_ar_trx_pkg.ddate(d.gl_date),'YYYY-MM-DD') gl_dt,
           d.bill_to_customer_name, d.bill_to_customer_type, d.business_unit_name,
           d.transaction_type_name, d.transaction_source, d.memo_line_name,
           NVL(d.transaction_line_descripti, d.service_description_2) descr,
           TO_CHAR(d.project) project_no, d.project_name, d.task_number,
           d.revenue_amount, d.tax_amount, d.revenue_gl_account,
           TO_CHAR(d.cost_center) cc_code, d.cost_center_discription cc_desc,
           TO_CHAR(d.account_code) acct_code, d.account_discription acct_desc
      FROM prod.ar_transaction_details_v d
     WHERE d.transaction_id IN (SELECT t.column_value FROM TABLE(l_ids) t)
       AND ([COLON]ctype   IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]ctype, NVL(d.bill_to_customer_type,'(None)')) = 1)
       AND ([COLON]project IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]project, TO_CHAR(d.project)) = 1)
       AND ([COLON]cc      IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]cc, TO_CHAR(d.cost_center)) = 1)
       AND ([COLON]account IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]account, TO_CHAR(d.account_code)) = 1)
       AND ([COLON]memo    IS NULL OR prod.dct_ar_trx_pkg.in_list([COLON]memo, NVL(d.memo_line_name,'(None)')) = 1)
       AND (l_glf IS NULL OR prod.dct_ar_trx_pkg.ddate(d.gl_date) >= l_glf)
       AND (l_glt IS NULL OR prod.dct_ar_trx_pkg.ddate(d.gl_date) <  l_glt + 1)
     ORDER BY prod.dct_ar_trx_pkg.ddate(d.transaction_date) DESC NULLS LAST,
              d.transaction_id DESC, d.transaction_line_number ASC
     FETCH FIRST 10000 ROWS ONLY)
  LOOP
    HTP.p(esc(r.transaction_number) || ',' || r.transaction_line_number || ',' ||
          r.trx_dt || ',' || r.gl_dt || ',' || esc(r.bill_to_customer_name) || ',' ||
          r.bill_to_customer_type || ',' || esc(r.business_unit_name) || ',' ||
          esc(r.transaction_type_name) || ',' || esc(r.transaction_source) || ',' ||
          esc(r.memo_line_name) || ',' || esc(r.descr) || ',' || r.project_no || ',' ||
          esc(r.project_name) || ',' || esc(r.task_number) || ',' ||
          r.revenue_amount || ',' || r.tax_amount || ',' || esc(r.revenue_gl_account) || ',' ||
          r.cc_code || ',' || esc(r.cc_desc) || ',' || r.acct_code || ',' || esc(r.acct_desc));
  END LOOP;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_ar_trx_ords_e;
/

BEGIN setup_ar_trx_ords_e; END;
/
DROP PROCEDURE setup_ar_trx_ords_e;

PROMPT part E done (exports)

CREATE OR REPLACE PROCEDURE setup_ar_trx_ords_f AS
    c_mod CONSTANT VARCHAR2(30) := 'ar.rest';
    PROCEDURE def_tpl(p_pattern VARCHAR2) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(p_module_name => c_mod,
            p_pattern => REPLACE(p_pattern, '[COLON]', CHR(58)));
    END;
    PROCEDURE def_h(p_pattern VARCHAR2, p_source CLOB) IS
    BEGIN
        ORDS.DEFINE_HANDLER(
            p_module_name => c_mod,
            p_pattern     => REPLACE(p_pattern, '[COLON]', CHR(58)),
            p_method      => 'GET',
            p_source_type => ORDS.source_type_plsql,
            p_source      => REPLACE(p_source, '[COLON]', CHR(58)));
    END;
BEGIN

    def_tpl('trx/detail/[COLON]id');
    def_h('trx/detail/[COLON]id', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_found NUMBER := 0;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  SELECT COUNT(*) INTO l_found FROM prod.ar_transaction_aging_v
   WHERE transaction_id = TO_NUMBER([COLON]id DEFAULT NULL ON CONVERSION ERROR);
  IF l_found = 0 THEN dct_rest.err(404,'Transaction not found'); RETURN; END IF;
  dct_rest.json_header; APEX_JSON.initialize_output; APEX_JSON.open_object;
  FOR r IN (
    SELECT a.transaction_id, a.transaction_number,
           TO_CHAR(prod.dct_ar_trx_pkg.ddate(a.transaction_date),'YYYY-MM-DD') trx_dt,
           TO_CHAR(prod.dct_ar_trx_pkg.ddate(a.due_date),'YYYY-MM-DD') due_dt,
           a.bill_to_customer_name, a.business_unit_name, a.transaction_complete,
           a.payment_terms_name, a.transaction_type_name, a.transaction_source,
           a.created_by_user_name, a.transaction_entered_amount, a.applied_amount,
           a.adj_amount, a.credit_amount, a.remaining_amount,
           prod.dct_ar_trx_pkg.stat(a.remaining_amount) st,
           prod.dct_ar_trx_pkg.bucket(a.remaining_amount, a.delay_days, a.aging_category) bk,
           CASE WHEN a.remaining_amount > 0 THEN GREATEST(a.delay_days,0) END delay_d
      FROM prod.ar_transaction_aging_v a
     WHERE a.transaction_id = TO_NUMBER([COLON]id))
  LOOP
    APEX_JSON.open_object('header');
    APEX_JSON.write('id', r.transaction_id);
    APEX_JSON.write('trxNumber', r.transaction_number);
    APEX_JSON.write('trxDate', r.trx_dt);
    APEX_JSON.write('dueDate', r.due_dt);
    APEX_JSON.write('customer', r.bill_to_customer_name);
    APEX_JSON.write('businessUnit', r.business_unit_name);
    APEX_JSON.write('trxType', r.transaction_type_name);
    APEX_JSON.write('source', r.transaction_source);
    APEX_JSON.write('complete', r.transaction_complete);
    APEX_JSON.write('terms', r.payment_terms_name);
    APEX_JSON.write('createdBy', r.created_by_user_name);
    APEX_JSON.write('enteredAed', r.transaction_entered_amount);
    APEX_JSON.write('appliedAed', r.applied_amount);
    APEX_JSON.write('adjAed', r.adj_amount);
    APEX_JSON.write('creditAed', r.credit_amount);
    APEX_JSON.write('remainingAed', r.remaining_amount);
    APEX_JSON.write('status', r.st);
    IF r.bk IS NOT NULL THEN APEX_JSON.write('aging', r.bk); END IF;
    IF r.delay_d IS NOT NULL THEN APEX_JSON.write('delayDays', r.delay_d); END IF;
    APEX_JSON.close_object;
  END LOOP;
  FOR x IN (
    SELECT MAX(d.bill_to_customer_number) cust_no, MAX(d.bill_to_customer_type) cust_type,
           MAX(d.ledger_currency) cur
      FROM prod.ar_transaction_details_v d
     WHERE d.transaction_id = TO_NUMBER([COLON]id))
  LOOP
    APEX_JSON.write('customerNumber', x.cust_no);
    APEX_JSON.write('customerType', x.cust_type);
    APEX_JSON.write('currency', x.cur);
  END LOOP;
  APEX_JSON.open_array('lines');
  FOR r IN (
    SELECT d.transaction_line_number,
           TO_CHAR(prod.dct_ar_trx_pkg.ddate(d.gl_date),'YYYY-MM-DD') gl_dt,
           d.memo_line_name, d.memo_line_description,
           NVL(d.transaction_line_descripti, d.service_description_2) descr,
           TO_CHAR(d.project) project_no, d.project_name, d.task, d.task_number,
           d.revenue_amount, d.tax_amount, d.revenue_gl_account, d.receivables_concatenated,
           TO_CHAR(d.cost_center) cc_code, d.cost_center_discription cc_desc,
           TO_CHAR(d.account_code) acct_code, d.account_discription acct_desc,
           d.tax_classification_code
      FROM prod.ar_transaction_details_v d
     WHERE d.transaction_id = TO_NUMBER([COLON]id)
     ORDER BY d.transaction_line_number)
  LOOP
    APEX_JSON.open_object;
    APEX_JSON.write('lineNumber', r.transaction_line_number);
    APEX_JSON.write('glDate', r.gl_dt);
    APEX_JSON.write('memoLine', r.memo_line_name);
    APEX_JSON.write('memoDesc', r.memo_line_description);
    APEX_JSON.write('description', r.descr);
    APEX_JSON.write('projectNumber', r.project_no);
    APEX_JSON.write('projectName', r.project_name);
    APEX_JSON.write('taskName', r.task);
    APEX_JSON.write('taskNumber', r.task_number);
    APEX_JSON.write('revenueAed', r.revenue_amount);
    APEX_JSON.write('taxAed', r.tax_amount);
    APEX_JSON.write('glAccount', r.revenue_gl_account);
    APEX_JSON.write('receivablesAccount', r.receivables_concatenated);
    APEX_JSON.write('costCenterCode', r.cc_code);
    APEX_JSON.write('costCenterDesc', r.cc_desc);
    APEX_JSON.write('accountCode', r.acct_code);
    APEX_JSON.write('accountDesc', r.acct_desc);
    APEX_JSON.write('taxClass', r.tax_classification_code);
    APEX_JSON.close_object;
  END LOOP;
  APEX_JSON.close_array;
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

    COMMIT;
END setup_ar_trx_ords_f;
/

BEGIN setup_ar_trx_ords_f; END;
/
DROP PROCEDURE setup_ar_trx_ords_f;

PROMPT part F done (trx/detail)

PROMPT === verification ===
SELECT object_name, object_type, status FROM all_objects
 WHERE owner = 'PROD' AND object_name = 'DCT_AR_TRX_PKG' ORDER BY object_type;

SELECT uh.id, ut.uri_template, uh.method, LENGTH(uh.source) src_len
  FROM user_ords_handlers uh
  JOIN user_ords_templates ut ON ut.id = uh.template_id
  JOIN user_ords_modules um ON um.id = ut.module_id
 WHERE um.name = 'ar.rest' AND ut.uri_template LIKE 'trx/%'
 ORDER BY ut.uri_template;
