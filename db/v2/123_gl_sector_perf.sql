-- ===========================================================================
-- i-Finance V2 -- 123: Sector Financial Performance report data layer
-- File   : db/v2/123_gl_sector_perf.sql
-- Purpose: data layer behind the new GL tab "Projects > Sector Performance"
--          and the SECTOR_PERF_BOOK / SECTOR_PERF_REGISTER report pack, whose
--          layout is docs/Reports/GL/Sector Report_October.pdf.
--
--          The pack's own arithmetic already matches the platform's:
--          budget - actual - encumbrance = funds available is byte-for-byte
--          DCT_BUDGET_UTILIZATION_V.FUND_AVAILABLE. So this script adds only
--          what is genuinely missing -- the PLAN side and REVENUE:
--
--            DCT_GL_REVENUE_CATEGORY  : the 28 revenue types of the pack
--                                       (S- sovereign / C- commercial)
--            DCT_GL_REVENUE_CAT_MAP   : natural account -> revenue category
--            DCT_GL_REVENUE_PLAN      : monthly revenue plan (year x period x
--                                       cost centre x account x plan type)
--            DCT_GL_REVENUE_FACT_V    : revenue ACTUAL per period, from the AR
--                                       distribution extract, with sector and
--                                       category attached
--            DCT_SECTOR_PLAN_V        : expenditure plan at the butil grain
--                                       (project x task x expenditure type),
--                                       BUTIL_END aware, from the EXISTING
--                                       DCT_PROJECT_CASHFLOW (db/v2/111)
--            DCT_SECTOR_PLAN_ORPHAN_V : plan rows with no matching budget line
--                                       (surfaced, never silently dropped)
--            DCT_SECTOR_PERF_V        : the report fact -- butil + plan +
--                                       expenditure kind (Opex/Capex/...)
--            DCT_GL_PLAN_SAMPLE_PKG   : generates and PURGES demonstration
--                                       plan data while the real plan files
--                                       do not exist
--
-- Reconciliation contract: DCT_SECTOR_PERF_V is built ON TOP of
--          DCT_BUDGET_UTILIZATION_V (never re-deriving facts), so budget /
--          actual / encumbrance / funds available tie to /gl/butil for the
--          same scope by construction. PLAN is an additive column only.
--
-- Deploy : sql -name prod_mcp @123_gl_sector_perf.sql   (idempotent)
--          Arabic literals are UNISTR escapes -- no encoding flag needed.
-- Depends: db/v2/37 (butil view), db/v2/111 (cashflow tables), GL/db/03
--          (dct_gl_class_pkg BUTIL_END context), db/v2/32 (GL_BALANCES_CC)
-- ===========================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 123.1 lookup vocabulary GL_REVENUE_STREAM ===
DECLARE
    l_cat NUMBER;
    PROCEDURE ensure_cat (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2) IS
    BEGIN
        SELECT category_id INTO l_cat FROM prod.dct_lookup_categories
        WHERE  category_code = p_code;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO prod.dct_lookup_categories
               (category_code, category_name_en, category_name_ar, is_system, is_active, created_by)
        VALUES (p_code, p_en, p_ar, 'N', 'Y', 'SYSTEM')
        RETURNING category_id INTO l_cat;
    END;
    PROCEDURE val (p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_ord NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_lookup_values
        WHERE  category_id = l_cat AND value_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_lookup_values
                   (category_id, value_code, value_name_en, value_name_ar,
                    display_order, is_active, created_by)
            VALUES (l_cat, p_code, p_en, p_ar, p_ord, 'Y', 'SYSTEM');
        END IF;
    END;
BEGIN
    ensure_cat('GL_REVENUE_STREAM', 'Revenue Stream',
               UNISTR('\0645\0635\062F\0631 \0627\0644\0625\064A\0631\0627\062F'));
    val('SOVEREIGN',  'Sovereign',  UNISTR('\0633\064A\0627\062F\064A'),  10);
    val('COMMERCIAL', 'Commercial', UNISTR('\062A\062C\0627\0631\064A'), 20);
    val('OTHER',      'Other',      UNISTR('\0623\062E\0631\0649'),      30);
    COMMIT;
END;
/

PROMPT === 123.2 table DCT_GL_REVENUE_CATEGORY ===
DECLARE
    l_n NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_n FROM all_tables
    WHERE owner = 'PROD' AND table_name = 'DCT_GL_REVENUE_CATEGORY';
    IF l_n = 0 THEN
        EXECUTE IMMEDIATE q'!
            CREATE TABLE prod.dct_gl_revenue_category (
                category_code  VARCHAR2(40)  PRIMARY KEY,
                stream_code    VARCHAR2(20)  NOT NULL,
                name_en        VARCHAR2(200) NOT NULL,
                name_ar        VARCHAR2(200),
                display_order  NUMBER DEFAULT 1000 NOT NULL,
                is_active      VARCHAR2(1) DEFAULT 'Y' NOT NULL,
                created_by     VARCHAR2(100),
                created_at     TIMESTAMP DEFAULT SYSTIMESTAMP,
                updated_by     VARCHAR2(100),
                updated_at     TIMESTAMP
            )!';
    END IF;
END;
/

PROMPT === 123.3 table DCT_GL_REVENUE_CAT_MAP ===
DECLARE
    l_n NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_n FROM all_tables
    WHERE owner = 'PROD' AND table_name = 'DCT_GL_REVENUE_CAT_MAP';
    IF l_n = 0 THEN
        EXECUTE IMMEDIATE q'!
            CREATE TABLE prod.dct_gl_revenue_cat_map (
                map_id           NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
                account_code     VARCHAR2(6)  NOT NULL,
                cost_center_code VARCHAR2(7),
                category_code    VARCHAR2(40) NOT NULL,
                is_active        VARCHAR2(1) DEFAULT 'Y' NOT NULL,
                source_tag       VARCHAR2(200),
                loaded_by        VARCHAR2(100),
                loaded_at        TIMESTAMP DEFAULT SYSTIMESTAMP,
                CONSTRAINT fk_glrevmap_cat FOREIGN KEY (category_code)
                    REFERENCES prod.dct_gl_revenue_category (category_code)
            )!';
        EXECUTE IMMEDIATE q'!
            CREATE UNIQUE INDEX prod.uq_glrevmap ON prod.dct_gl_revenue_cat_map
                (account_code, NVL(cost_center_code, CHR(45)))!';
    END IF;
END;
/

PROMPT === 123.4 table DCT_GL_REVENUE_PLAN ===
DECLARE
    l_n NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_n FROM all_tables
    WHERE owner = 'PROD' AND table_name = 'DCT_GL_REVENUE_PLAN';
    IF l_n = 0 THEN
        EXECUTE IMMEDIATE q'!
            CREATE TABLE prod.dct_gl_revenue_plan (
                plan_id           NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
                budget_year       NUMBER        NOT NULL,
                accounting_period VARCHAR2(20)  NOT NULL,
                period_date       DATE,
                cost_center_code  VARCHAR2(7)   NOT NULL,
                account_code      VARCHAR2(6)   NOT NULL,
                plan_type         VARCHAR2(30)  NOT NULL,
                plan_amount       NUMBER DEFAULT 0 NOT NULL,
                source_file       VARCHAR2(200),
                loaded_by         VARCHAR2(100),
                loaded_at         TIMESTAMP DEFAULT SYSTIMESTAMP,
                CONSTRAINT uq_glrevplan UNIQUE
                    (budget_year, accounting_period, cost_center_code,
                     account_code, plan_type)
            )!';
        EXECUTE IMMEDIATE
            'CREATE INDEX prod.ix_glrevplan_year ON prod.dct_gl_revenue_plan (budget_year, plan_type)';
    END IF;
END;
/

PROMPT === 123.5 seed the 28 revenue categories of the source pack ===
DECLARE
    PROCEDURE cat (p_code VARCHAR2, p_stream VARCHAR2, p_en VARCHAR2,
                   p_ar VARCHAR2, p_ord NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_gl_revenue_category
        WHERE  category_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_gl_revenue_category
                   (category_code, stream_code, name_en, name_ar,
                    display_order, is_active, created_by)
            VALUES (p_code, p_stream, p_en, p_ar, p_ord, 'Y', 'SEED');
        END IF;
    END;
BEGIN
    cat('TOURISM_FEES', 'SOVEREIGN', 'S-Tourism Fees', UNISTR('\0631\0633\0648\0645 \0627\0644\0633\064A\0627\062D\0629'), 10);
    cat('OTHER_REVENUE', 'COMMERCIAL', 'C-Other Revenue', UNISTR('\0625\064A\0631\0627\062F\0627\062A \0623\062E\0631\0649'), 20);
    cat('ADMISSION_TICKETING', 'COMMERCIAL', 'C-Admission / Ticketing', UNISTR('\0631\0633\0648\0645 \0627\0644\062F\062E\0648\0644 \0648\0627\0644\062A\0630\0627\0643\0631'), 30);
    cat('OTHER_ACCRUED', 'COMMERCIAL', 'C-Other accrued expense', UNISTR('\0645\0635\0631\0648\0641\0627\062A \0645\0633\062A\062D\0642\0629 \0623\062E\0631\0649'), 40);
    cat('MUSEUM_CHARGE', 'COMMERCIAL', 'C-Museum Charge', UNISTR('\0631\0633\0648\0645 \0627\0644\0645\062A\0627\062D\0641'), 50);
    cat('SPACE_RENT_C', 'COMMERCIAL', 'C-Space Rent / Venue Hire', UNISTR('\062A\0623\062C\064A\0631 \0627\0644\0645\0633\0627\062D\0627\062A \0648\0627\0644\0642\0627\0639\0627\062A'), 60);
    cat('ALCOHOL_FEES', 'SOVEREIGN', 'S-Alcohol Fees', UNISTR('\0631\0633\0648\0645 \0627\0644\0645\0634\0631\0648\0628\0627\062A \0627\0644\0643\062D\0648\0644\064A\0629'), 70);
    cat('EVENTS_LICENSING', 'SOVEREIGN', 'S-Events Licensing', UNISTR('\062A\0631\0627\062E\064A\0635 \0627\0644\0641\0639\0627\0644\064A\0627\062A'), 80);
    cat('SPONSORSHIP', 'COMMERCIAL', 'C-Sponsorship', UNISTR('\0627\0644\0631\0639\0627\064A\0629'), 90);
    cat('OPERATOR_RENT', 'COMMERCIAL', 'C-Operators rent & revenue share', UNISTR('\0625\064A\062C\0627\0631 \0627\0644\0645\0634\063A\0644\064A\0646 \0648\062D\0635\0629 \0627\0644\0625\064A\0631\0627\062F\0627\062A'), 100);
    cat('HOLIDAY_HOMES', 'SOVEREIGN', 'S-Holiday Homes', UNISTR('\0645\0646\0627\0632\0644 \0627\0644\0639\0637\0644\0627\062A'), 110);
    cat('SUNDRY_RECEIPTS', 'COMMERCIAL', 'C-Sundry Receipts', UNISTR('\0645\062A\062D\0635\0644\0627\062A \0645\062A\0646\0648\0639\0629'), 120);
    cat('RETAIL', 'COMMERCIAL', 'C-Retail', UNISTR('\0627\0644\0628\064A\0639 \0628\0627\0644\062A\062C\0632\0626\0629'), 130);
    cat('VENUE_HIRE', 'COMMERCIAL', 'C-Venue Hire', UNISTR('\062A\0623\062C\064A\0631 \0627\0644\0642\0627\0639\0627\062A'), 140);
    cat('CLASSES_TRAINING', 'COMMERCIAL', 'C-Classes & Training Fees', UNISTR('\0631\0633\0648\0645 \0627\0644\062F\0648\0631\0627\062A \0648\0627\0644\062A\062F\0631\064A\0628'), 150);
    cat('BOOKS_SALES', 'COMMERCIAL', 'C-Books sales', UNISTR('\0645\0628\064A\0639\0627\062A \0627\0644\0643\062A\0628'), 160);
    cat('MEMBERSHIP_FEE', 'COMMERCIAL', 'C-Membership fee', UNISTR('\0631\0633\0648\0645 \0627\0644\0639\0636\0648\064A\0629'), 170);
    cat('BOOKS_PUBLICATION', 'COMMERCIAL', 'C-Books and Publication', UNISTR('\0627\0644\0643\062A\0628 \0648\0627\0644\0645\0646\0634\0648\0631\0627\062A'), 180);
    cat('GUIDED_TOURS', 'COMMERCIAL', 'C-Guided Tours', UNISTR('\0627\0644\062C\0648\0644\0627\062A \0627\0644\0625\0631\0634\0627\062F\064A\0629'), 190);
    cat('TOURIST_GUIDE', 'SOVEREIGN', 'S-Tourist Guide', UNISTR('\0627\0644\0645\0631\0634\062F \0627\0644\0633\064A\0627\062D\064A'), 200);
    cat('MMG', 'COMMERCIAL', 'C-MMG', UNISTR('\0625\0645 \0625\0645 \062C\064A'), 210);
    cat('ROYALTY', 'COMMERCIAL', 'C-Royalty', UNISTR('\0627\0644\0625\062A\0627\0648\0627\062A'), 220);
    cat('WORKSHOPS', 'COMMERCIAL', 'C-Work shops', UNISTR('\0648\0631\0634 \0627\0644\0639\0645\0644'), 230);
    cat('PARKING_MGMT', 'COMMERCIAL', 'C-Parking Management', UNISTR('\0625\062F\0627\0631\0629 \0627\0644\0645\0648\0627\0642\0641'), 240);
    cat('EXT_GUIDED_CERT', 'COMMERCIAL', 'C-External guided certificates', UNISTR('\0634\0647\0627\062F\0627\062A \0627\0644\0625\0631\0634\0627\062F \0627\0644\062E\0627\0631\062C\064A\0629'), 250);
    cat('CULTURE_PROGRAMMING', 'COMMERCIAL', 'C-Culture programming', UNISTR('\0627\0644\0628\0631\0627\0645\062C \0627\0644\062B\0642\0627\0641\064A\0629'), 260);
    cat('SPACE_RENT_S', 'SOVEREIGN', 'S-Space Rent / Venue Hire', UNISTR('\062A\0623\062C\064A\0631 \0627\0644\0645\0633\0627\062D\0627\062A \0648\0627\0644\0642\0627\0639\0627\062A - \0633\064A\0627\062F\064A'), 270);
    cat('DOCUMENTARY_FILMING', 'COMMERCIAL', 'C-Documentary & Filming', UNISTR('\0627\0644\062A\0648\062B\064A\0642 \0648\0627\0644\062A\0635\0648\064A\0631'), 280);
    cat('UNCATEGORISED', 'OTHER', 'Uncategorised', UNISTR('\063A\064A\0631 \0645\0635\0646\0641'), 999);
    COMMIT;
END;
/

PROMPT === 123.6 view DCT_GL_REVENUE_FACT_V (revenue actual per period) ===
-- Revenue ACTUAL comes from the AR distribution extract, not from
-- GL_BALANCES_CC: that view is Fusion budgetary control and carries no
-- revenue actual (verified live -- every revenue row has a budget and a NULL
-- expenditure). Amounts arrive already signed positive for the Revenue
-- accounting class, so nothing is sign-flipped here.
-- The category is resolved account+cost-centre first, then account only, then
-- UNCATEGORISED -- an unmapped account is SHOWN as its own bucket, never
-- dropped (same rule as the pending page's unmatched leg).
CREATE OR REPLACE VIEW prod.dct_gl_revenue_fact_v AS
WITH cc_dim AS (
  SELECT cost_center_code, MAX(cost_center_desc) AS cost_center_desc
  FROM prod.dct_gl_coa_snap WHERE cost_center_code IS NOT NULL
  GROUP BY cost_center_code
),
sec_map AS (
  SELECT cost_center_code, MAX(sector_name) AS sector_name
  FROM prod.dct_gl_coa_snap WHERE sector_name IS NOT NULL
  GROUP BY cost_center_code
),
acc_dim AS (
  SELECT account_code, MAX(account_desc) AS account_desc
  FROM prod.dct_gl_coa_snap WHERE account_code IS NOT NULL
  GROUP BY account_code
),
d AS (
  SELECT EXTRACT(YEAR FROM accounting_date)                        AS budget_year,
         TO_CHAR(accounting_date, 'MM-YYYY')                       AS accounting_period,
         TRUNC(accounting_date, 'MM')                              AS period_date,
         EXTRACT(YEAR FROM accounting_date) * 100
           + EXTRACT(MONTH FROM accounting_date)                   AS period_num,
         LPAD(TO_CHAR(distribution_cost_center_c), 7, '0')         AS cost_center_code,
         LPAD(TO_CHAR(distribution_natural_accou_2), 6, '0')       AS account_code,
         SUM(NVL(distribution_accounted_amo, 0))                   AS actual_amount,
         COUNT(DISTINCT transaction_number)                        AS doc_count
  FROM prod.atd_ar_invoice_distribution
  WHERE accounting_class = 'Revenue'
    AND accounting_date IS NOT NULL
  GROUP BY EXTRACT(YEAR FROM accounting_date),
           TO_CHAR(accounting_date, 'MM-YYYY'),
           TRUNC(accounting_date, 'MM'),
           EXTRACT(YEAR FROM accounting_date) * 100 + EXTRACT(MONTH FROM accounting_date),
           LPAD(TO_CHAR(distribution_cost_center_c), 7, '0'),
           LPAD(TO_CHAR(distribution_natural_accou_2), 6, '0')
)
SELECT d.budget_year,
       d.accounting_period,
       d.period_date,
       d.period_num,
       d.cost_center_code,
       cd.cost_center_desc                                AS department,
       sm.sector_name                                     AS sector,
       d.account_code,
       ad.account_desc,
       COALESCE(m1.category_code, m2.category_code, 'UNCATEGORISED') AS category_code,
       d.actual_amount,
       d.doc_count
FROM d
LEFT JOIN cc_dim cd ON cd.cost_center_code = d.cost_center_code
LEFT JOIN sec_map sm ON sm.cost_center_code = d.cost_center_code
LEFT JOIN acc_dim ad ON ad.account_code = d.account_code
LEFT JOIN prod.dct_gl_revenue_cat_map m1
       ON m1.account_code = d.account_code
      AND m1.cost_center_code = d.cost_center_code
      AND m1.is_active = 'Y'
LEFT JOIN prod.dct_gl_revenue_cat_map m2
       ON m2.account_code = d.account_code
      AND m2.cost_center_code IS NULL
      AND m2.is_active = 'Y';

PROMPT === 123.7 view DCT_SECTOR_PLAN_V (expenditure plan at the butil grain) ===
-- The plan is aggregated in its OWN stream, keyed on the butil line
-- (project x task x expenditure type), BEFORE anything joins to it. This is
-- the db/v2/37 lesson: the Fusion budget is un-phased, so a plan row at a
-- period the budget has no row for MUST NOT be reached by joining from the
-- budget table -- it would be silently dropped. Aggregating first makes the
-- period dimension disappear before the join.
-- YTD honours the same GL_CTX.BUTIL_END cut-off as every butil fact, so plan,
-- actual and encumbrance can never be cut at different months.
CREATE OR REPLACE VIEW prod.dct_sector_plan_v AS
WITH cut AS (
  SELECT TO_DATE(SYS_CONTEXT('GL_CTX','BUTIL_END')
                 DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD') AS end_date
  FROM dual
),
c AS (
  SELECT p.budget_year,
         TO_CHAR(p.project_number)  AS project_number,
         p.task_number,
         p.expenditure_type,
         p.cf_type,
         p.cf_amount,
         NVL(p.period_date,
             TO_DATE('01-' || p.accounting_period
                     DEFAULT NULL ON CONVERSION ERROR, 'DD-MM-YYYY')) AS pd
  FROM prod.dct_project_cashflow p
)
SELECT c.budget_year,
       c.project_number,
       c.task_number,
       c.expenditure_type,
       SUM(CASE WHEN c.cf_type = 'APPROVED' THEN c.cf_amount ELSE 0 END) AS plan_annual,
       SUM(CASE WHEN c.cf_type = 'APPROVED'
                 AND (cut.end_date IS NULL OR c.pd IS NULL OR c.pd <= cut.end_date)
                THEN c.cf_amount ELSE 0 END)                             AS plan_ytd,
       SUM(CASE WHEN c.cf_type = 'REVISED' THEN c.cf_amount ELSE 0 END)  AS plan_rev_annual,
       SUM(CASE WHEN c.cf_type = 'REVISED'
                 AND (cut.end_date IS NULL OR c.pd IS NULL OR c.pd <= cut.end_date)
                THEN c.cf_amount ELSE 0 END)                             AS plan_rev_ytd
FROM c CROSS JOIN cut
GROUP BY c.budget_year, c.project_number, c.task_number, c.expenditure_type;

PROMPT === 123.8 view DCT_SECTOR_PLAN_ORPHAN_V (plan with no budget line) ===
-- A plan row whose budget line no longer exists is a data-quality finding, not
-- something to hide. The report shows the count and value of these rows rather
-- than letting them vanish inside a join.
CREATE OR REPLACE VIEW prod.dct_sector_plan_orphan_v AS
SELECT p.budget_year,
       p.project_number,
       p.task_number,
       p.expenditure_type,
       p.plan_annual,
       p.plan_ytd
FROM prod.dct_sector_plan_v p
WHERE NOT EXISTS (
        SELECT 1 FROM prod.dct_butil_scope_v s
        WHERE  s.budget_year      = p.budget_year
          AND  s.project_number   = p.project_number
          AND  s.task_number      = p.task_number
          AND  s.expenditure_type = p.expenditure_type);

PROMPT === 123.9 view DCT_SECTOR_PERF_V (the report fact) ===
-- Built ON TOP of DCT_BUDGET_UTILIZATION_V, never re-deriving a fact, so
-- budget / actual / encumbrance / funds available tie to /gl/butil for the
-- same scope BY CONSTRUCTION. PLAN and EXPENDITURE_KIND are additive.
-- EXPENDITURE_KIND is the chapter's alternate name (Chapter 2 = Opex,
-- Chapter 3 = Capex, Chapter 1 = Payroll, 4 = Subsidy, 5 = Aids & Grants) --
-- the source pack's Opex / Capex split, which is a chapter classification and
-- not a project-type one.
CREATE OR REPLACE VIEW prod.dct_sector_perf_v AS
SELECT b.budget_year,
       b.project_type,
       b.business_unit,
       b.sector,
       b.department,
       b.cost_centre,
       b.chapter,
       NVL(cv.alt_name1, 'Unclassified')                 AS expenditure_kind,
       b.appropriation,
       b.program,
       b.gl_account,
       b.project_number,
       b.project_name,
       b.task_number,
       b.task_organization,
       b.expenditure_type,
       b.budget_combination,
       NVL(b.budget_annual, 0)                           AS budget_annual,
       NVL(b.budget, 0)                                  AS budget_ytd,
       NVL(b.actual_ap, 0)                               AS actual_ap,
       NVL(b.actual_grn, 0)                              AS actual_grn,
       NVL(b.actual_ap, 0) + NVL(b.actual_grn, 0)        AS actual_ytd,
       NVL(b.commitment_pr, 0)                           AS commitment_pr,
       NVL(b.obligation_po, 0)                           AS obligation_po,
       NVL(b.commitment_pr, 0) + NVL(b.obligation_po, 0) AS encumbrance,
       b.fund_available,
       NVL(p.plan_annual, 0)                             AS plan_annual,
       NVL(p.plan_ytd, 0)                                AS plan_ytd,
       NVL(p.plan_rev_annual, 0)                         AS plan_rev_annual,
       NVL(p.plan_rev_ytd, 0)                            AS plan_rev_ytd,
       NVL(b.actual_ap, 0) + NVL(b.actual_grn, 0)
         - NVL(p.plan_ytd, 0)                            AS actual_vs_plan_amount
FROM prod.dct_budget_utilization_v b
LEFT JOIN prod.dct_gl_class_value cv
       ON cv.class_type_code = 'CHAPTER'
      AND cv.name_en = b.chapter
LEFT JOIN prod.dct_sector_plan_v p
       ON p.budget_year      = b.budget_year
      AND p.project_number   = b.project_number
      AND p.task_number      = b.task_number
      AND p.expenditure_type = b.expenditure_type;

PROMPT === 123.10 view DCT_SECTOR_ACTUAL_MONTH_V (actual by month, line grain) ===
-- Page 1 of the pack plots a CUMULATIVE monthly actual, which the butil view
-- cannot give (it is cut at one BUTIL_END). This view carries the same AP and
-- GRN facts at the same line grain, grouped by accounting month and with NO
-- period cut-off, so the consumer cuts it itself. The predicates are a
-- verbatim copy of the db/v2/37 f_ap / f_grn CTEs (minus the BUTIL_END bound),
-- which is what makes the identity hold:
--     SUM(months <= cut-off) == the butil actual at that same cut-off.
-- Attributes (sector / department / chapter) are deliberately NOT repeated
-- here -- the consumer joins prod.dct_butil_scope_v so the attribution logic
-- has exactly ONE definition and can never drift.
CREATE OR REPLACE VIEW prod.dct_sector_actual_month_v AS
WITH proj AS (
  SELECT project_id, project_number FROM prod.projects
  GROUP BY project_id, project_number
),
tsk AS (
  SELECT task_id, MAX(task_number) AS task_number FROM prod.tasks GROUP BY task_id
),
po_dist AS (
  SELECT po_distribution_id,
         prod.dct_cc_canon(MAX(charge_account)) AS charge_account
  FROM prod.po_distributions
  GROUP BY po_distribution_id
),
m_ap AS (
  SELECT EXTRACT(YEAR FROM d.accounting_date) AS budget_year,
         EXTRACT(YEAR FROM d.accounting_date) * 100
           + EXTRACT(MONTH FROM d.accounting_date) AS period_num,
         COALESCE(TO_CHAR(pj.project_number), '#' || TO_CHAR(d.project_id)) AS project_number,
         COALESCE(tk.task_number,
                  CASE WHEN d.task_id IS NOT NULL THEN '#' || TO_CHAR(d.task_id) END) AS task_number,
         d.expenditure_type,
         SUM(NVL(d.distribution_amount_functi, d.distribution_amount)) AS actual_ap,
         TO_NUMBER(NULL) AS actual_grn
  FROM prod.ap_invoice_distributions d
  JOIN prod.ap_invoices i ON i.invoice_id = d.invoice_id
  -- this join is a FILTER, not a lookup: db/v2/37's f_ap inner-joins the COA
  -- snapshot on cc_id, so an AP distribution whose combination is not in the
  -- snapshot never reaches the butil actual. Omitting it here put 20,000 AED
  -- of extra actual into the monthly series and broke the identity below.
  JOIN prod.dct_gl_coa_snap cid ON cid.cc_id = d.cc_id
  LEFT JOIN proj pj ON pj.project_id = d.project_id
  LEFT JOIN tsk  tk ON tk.task_id    = d.task_id
  WHERE d.po_number IS NULL
    AND NVL(d.reversal_indicator, 'N') <> 'Y'
    AND d.project_id IS NOT NULL
    AND i.validation_status IN ('Validated', 'Unpaid', 'Available')
  GROUP BY EXTRACT(YEAR FROM d.accounting_date),
           EXTRACT(YEAR FROM d.accounting_date) * 100 + EXTRACT(MONTH FROM d.accounting_date),
           COALESCE(TO_CHAR(pj.project_number), '#' || TO_CHAR(d.project_id)),
           COALESCE(tk.task_number,
                    CASE WHEN d.task_id IS NOT NULL THEN '#' || TO_CHAR(d.task_id) END),
           d.expenditure_type
),
m_grn AS (
  SELECT EXTRACT(YEAR FROM NVL(g.accounted_date, g.transaction_date)) AS budget_year,
         EXTRACT(YEAR FROM NVL(g.accounted_date, g.transaction_date)) * 100
           + EXTRACT(MONTH FROM NVL(g.accounted_date, g.transaction_date)) AS period_num,
         COALESCE(TO_CHAR(pj.project_number), '#' || TO_CHAR(g.project_id)) AS project_number,
         COALESCE(tk.task_number,
                  CASE WHEN g.task_id IS NOT NULL THEN '#' || TO_CHAR(g.task_id) END) AS task_number,
         g.expenditure_type,
         TO_NUMBER(NULL) AS actual_ap,
         SUM(g.ledger_amount) AS actual_grn
  FROM prod.grn_all_v2 g
  JOIN po_dist pod ON pod.po_distribution_id = g.po_distribution_id
  LEFT JOIN proj pj ON pj.project_id = g.project_id
  LEFT JOIN tsk  tk ON tk.task_id    = g.task_id
  WHERE g.project_id IS NOT NULL
    AND pod.charge_account IS NOT NULL
  GROUP BY EXTRACT(YEAR FROM NVL(g.accounted_date, g.transaction_date)),
           EXTRACT(YEAR FROM NVL(g.accounted_date, g.transaction_date)) * 100
             + EXTRACT(MONTH FROM NVL(g.accounted_date, g.transaction_date)),
           COALESCE(TO_CHAR(pj.project_number), '#' || TO_CHAR(g.project_id)),
           COALESCE(tk.task_number,
                    CASE WHEN g.task_id IS NOT NULL THEN '#' || TO_CHAR(g.task_id) END),
           g.expenditure_type
),
u AS (
  SELECT * FROM m_ap
  UNION ALL
  SELECT * FROM m_grn
)
SELECT budget_year,
       period_num,
       TO_CHAR(MOD(period_num, 100), 'FM00') || '-' || TO_CHAR(TRUNC(period_num / 100)) AS accounting_period,
       project_number,
       task_number,
       expenditure_type,
       SUM(NVL(actual_ap, 0))  AS actual_ap,
       SUM(NVL(actual_grn, 0)) AS actual_grn,
       SUM(NVL(actual_ap, 0)) + SUM(NVL(actual_grn, 0)) AS actual_amount
FROM u
WHERE project_number NOT LIKE '#%'
  AND task_number NOT LIKE '#_%'
GROUP BY budget_year, period_num, project_number, task_number, expenditure_type;

PROMPT === 123.11 package DCT_GL_PLAN_SAMPLE_PKG (spec) ===
CREATE OR REPLACE PACKAGE prod.dct_gl_plan_sample_pkg AS
    -- -------------------------------------------------------------------
    -- Demonstration PLAN data for the Sector Performance report, and the
    -- one call that removes it again.
    --
    -- Finance has no monthly plan loaded yet (DCT_PROJECT_CASHFLOW is empty
    -- and there is no revenue plan table history), so the report cannot be
    -- demonstrated or tested without one. Everything this package writes is
    -- removable by purge(), guaranteed by three independent locks:
    --
    --   1. TAGGING     every generated row carries loaded_by = 'SAMPLE' and
    --                  source_file = 'SAMPLE:<batch>'. purge() deletes
    --                  strictly WHERE loaded_by = 'SAMPLE', so a row loaded
    --                  by Finance (real filename, real username) is
    --                  UNREACHABLE by the purge.
    --   2. REFUSAL     generate_* raises -20001 when the target year already
    --                  holds a row that is NOT tagged SAMPLE. Sample data can
    --                  never overwrite a real plan, and the generator locks
    --                  itself out the moment the real file is uploaded.
    --   3. VISIBILITY  is_sample_active() drives the amber banner on the page,
    --                  the watermark on the report cover and the note in the
    --                  workbook, so a sample run can never be mistaken for an
    --                  issued pack.
    --
    -- The figures are DETERMINISTIC (seeded from a hash of the line key),
    -- never random -- a re-run reproduces identical numbers, so a screenshot
    -- taken today still matches tomorrow.
    -- -------------------------------------------------------------------
    c_tag CONSTANT VARCHAR2(30) := 'SAMPLE';

    FUNCTION is_sample_active (p_year IN NUMBER DEFAULT NULL) RETURN VARCHAR2;
    FUNCTION sample_batches   (p_year IN NUMBER DEFAULT NULL) RETURN VARCHAR2;

    PROCEDURE generate_expenditure_plan (p_year    IN  NUMBER,
                                         p_batch   IN  VARCHAR2 DEFAULT NULL,
                                         p_cf_type IN  VARCHAR2 DEFAULT 'APPROVED',
                                         p_rows    OUT NUMBER);

    PROCEDURE generate_revenue_cat_map  (p_batch IN  VARCHAR2 DEFAULT NULL,
                                         p_rows  OUT NUMBER);

    PROCEDURE generate_revenue_plan     (p_year      IN  NUMBER,
                                         p_batch     IN  VARCHAR2 DEFAULT NULL,
                                         p_plan_type IN  VARCHAR2 DEFAULT 'APPROVED',
                                         p_rows      OUT NUMBER);

    PROCEDURE generate_all (p_year IN NUMBER, p_batch IN VARCHAR2 DEFAULT NULL);

    PROCEDURE purge (p_year     IN  NUMBER   DEFAULT NULL,
                     p_batch    IN  VARCHAR2 DEFAULT NULL,
                     p_exp_rows OUT NUMBER,
                     p_rev_rows OUT NUMBER,
                     p_map_rows OUT NUMBER);

    PROCEDURE purge (p_year  IN NUMBER   DEFAULT NULL,
                     p_batch IN VARCHAR2 DEFAULT NULL);
END dct_gl_plan_sample_pkg;
/

PROMPT === 123.12 package DCT_GL_PLAN_SAMPLE_PKG (body) ===
CREATE OR REPLACE PACKAGE BODY prod.dct_gl_plan_sample_pkg AS

    TYPE t_w IS VARRAY(12) OF NUMBER;

    -- Monthly weights, each summing to 1.000. The cumulative value at October
    -- is the calibration point: the source pack (October-2025) reports
    -- Target [YTD Plan / FY Plan] of 69.2% Opex, 46.4% Capex, 65.3% Revenue,
    -- so the curves below reach exactly those cumulative shares at month 10.
    -- Government spend really is this back-loaded; the Nov/Dec weights are
    -- the arithmetic consequence, not padding.
    c_w_opex    CONSTANT t_w := t_w(0.052, 0.056, 0.062, 0.066, 0.070,
                                    0.072, 0.074, 0.078, 0.080, 0.082,
                                    0.140, 0.168);
    c_w_capex   CONSTANT t_w := t_w(0.014, 0.020, 0.026, 0.032, 0.040,
                                    0.048, 0.056, 0.066, 0.076, 0.086,
                                    0.230, 0.306);
    c_w_payroll CONSTANT t_w := t_w(0.083, 0.083, 0.083, 0.083, 0.083,
                                    0.083, 0.083, 0.083, 0.083, 0.083,
                                    0.083, 0.087);
    c_w_rev     CONSTANT t_w := t_w(0.062, 0.060, 0.066, 0.072, 0.068,
                                    0.058, 0.056, 0.066, 0.072, 0.073,
                                    0.160, 0.187);

    -- FY plan as a share of FY budget, likewise reverse-engineered from the
    -- source pack (Opex FY plan 3,856.5M on a 3,935.6M budget = 0.98; Capex
    -- 1,073.1M on 1,029.2M = 1.04 -- a capex plan ABOVE budget is what the
    -- pack actually shows, not an error here).
    c_r_opex    CONSTANT NUMBER := 0.98;
    c_r_capex   CONSTANT NUMBER := 1.04;
    c_r_payroll CONSTANT NUMBER := 1.00;
    c_r_other   CONSTANT NUMBER := 0.98;
    c_r_rev     CONSTANT NUMBER := 1.00;

    FUNCTION weight_of (p_kind IN VARCHAR2, p_month IN PLS_INTEGER) RETURN NUMBER IS
    BEGIN
        CASE
            WHEN p_kind = 'Capex'   THEN RETURN c_w_capex(p_month);
            WHEN p_kind = 'Payroll' THEN RETURN c_w_payroll(p_month);
            WHEN p_kind = 'Revenue' THEN RETURN c_w_rev(p_month);
            ELSE RETURN c_w_opex(p_month);
        END CASE;
    END weight_of;

    FUNCTION ratio_of (p_kind IN VARCHAR2) RETURN NUMBER IS
    BEGIN
        CASE
            WHEN p_kind = 'Capex'   THEN RETURN c_r_capex;
            WHEN p_kind = 'Payroll' THEN RETURN c_r_payroll;
            WHEN p_kind = 'Revenue' THEN RETURN c_r_rev;
            ELSE RETURN c_r_other;
        END CASE;
    END ratio_of;

    -- deterministic +/- 6% per line, so departments land on BOTH sides of plan
    -- and the Actual-vs-Plan page carries real signal instead of a flat line
    FUNCTION jitter_of (p_key IN VARCHAR2) RETURN NUMBER IS
    BEGIN
        -- ORA_HASH is SQL-only (PLS-00201 in PL/SQL); get_hash_value is the
        -- PL/SQL-callable equivalent and is equally deterministic.
        RETURN 1 + (MOD(DBMS_UTILITY.get_hash_value(p_key, 0, 1073741824), 121) - 60) / 1000;
    END jitter_of;

    FUNCTION batch_of (p_batch IN VARCHAR2, p_year IN NUMBER) RETURN VARCHAR2 IS
    BEGIN
        RETURN NVL(p_batch, TO_CHAR(NVL(p_year, 0)) || '-PLAN-01');
    END batch_of;

    FUNCTION is_sample_active (p_year IN NUMBER DEFAULT NULL) RETURN VARCHAR2 IS
        l_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO l_n FROM (
            SELECT 1 FROM prod.dct_project_cashflow
            WHERE  loaded_by = c_tag AND (p_year IS NULL OR budget_year = p_year)
              AND  ROWNUM = 1
            UNION ALL
            SELECT 1 FROM prod.dct_gl_revenue_plan
            WHERE  loaded_by = c_tag AND (p_year IS NULL OR budget_year = p_year)
              AND  ROWNUM = 1);
        RETURN CASE WHEN l_n > 0 THEN 'Y' ELSE 'N' END;
    END is_sample_active;

    FUNCTION sample_batches (p_year IN NUMBER DEFAULT NULL) RETURN VARCHAR2 IS
        l_out VARCHAR2(4000);
    BEGIN
        SELECT LISTAGG(b, ', ') WITHIN GROUP (ORDER BY b) INTO l_out
        FROM ( SELECT DISTINCT source_file AS b FROM prod.dct_project_cashflow
               WHERE loaded_by = c_tag AND (p_year IS NULL OR budget_year = p_year)
               UNION
               SELECT DISTINCT source_file FROM prod.dct_gl_revenue_plan
               WHERE loaded_by = c_tag AND (p_year IS NULL OR budget_year = p_year) );
        RETURN l_out;
    END sample_batches;

    -- LOCK 2: never overwrite a plan somebody actually loaded
    PROCEDURE assert_no_real_expenditure (p_year IN NUMBER) IS
        l_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO l_n FROM prod.dct_project_cashflow
        WHERE  budget_year = p_year AND NVL(loaded_by, 'x') <> c_tag AND ROWNUM = 1;
        IF l_n > 0 THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Real (non-sample) expenditure plan rows already exist for ' ||
                p_year || ' -- sample generation refused.');
        END IF;
    END assert_no_real_expenditure;

    PROCEDURE assert_no_real_revenue (p_year IN NUMBER) IS
        l_n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO l_n FROM prod.dct_gl_revenue_plan
        WHERE  budget_year = p_year AND NVL(loaded_by, 'x') <> c_tag AND ROWNUM = 1;
        IF l_n > 0 THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Real (non-sample) revenue plan rows already exist for ' ||
                p_year || ' -- sample generation refused.');
        END IF;
    END assert_no_real_revenue;

    PROCEDURE generate_expenditure_plan (p_year    IN  NUMBER,
                                         p_batch   IN  VARCHAR2 DEFAULT NULL,
                                         p_cf_type IN  VARCHAR2 DEFAULT 'APPROVED',
                                         p_rows    OUT NUMBER) IS
        l_batch  VARCHAR2(200) := 'SAMPLE:' || batch_of(p_batch, p_year);
        l_annual NUMBER;
        l_run    NUMBER;
        l_amt    NUMBER;
        l_n      NUMBER := 0;
    BEGIN
        assert_no_real_expenditure(p_year);
        -- annual figures only: a stale YTD cut-off would phase a partial year
        prod.dct_gl_class_pkg.clear_butil_end;
        DELETE FROM prod.dct_project_cashflow
        WHERE  budget_year = p_year AND loaded_by = c_tag AND cf_type = p_cf_type;
        FOR r IN (
            SELECT b.project_number,
                   b.task_number,
                   b.expenditure_type,
                   NVL(b.budget_annual, 0)  AS budget_annual,
                   NVL(cv.alt_name1, 'Opex') AS kind
            FROM   prod.dct_budget_utilization_v b
            LEFT JOIN prod.dct_gl_class_value cv
                   ON cv.class_type_code = 'CHAPTER'
                  AND cv.name_en = b.chapter
            WHERE  b.budget_year = p_year
              AND  NVL(b.budget_annual, 0) > 0
              AND  b.task_number IS NOT NULL
              AND  b.expenditure_type IS NOT NULL )
        LOOP
            l_annual := ROUND(r.budget_annual * ratio_of(r.kind)
                              * jitter_of(r.project_number || '|' || r.task_number
                                          || '|' || r.expenditure_type), 2);
            l_run := 0;
            FOR m IN 1 .. 12 LOOP
                IF m < 12 THEN
                    l_amt := ROUND(l_annual * weight_of(r.kind, m), 2);
                    l_run := l_run + l_amt;
                ELSE
                    -- residual on the last month so the 12 rows sum EXACTLY to
                    -- the annual figure (rounding must never leak into a total)
                    l_amt := l_annual - l_run;
                END IF;
                INSERT INTO prod.dct_project_cashflow
                       (project_number, task_number, expenditure_type, budget_year,
                        accounting_period, period_date, cf_type, cf_amount,
                        source_file, loaded_by)
                VALUES (r.project_number, r.task_number, r.expenditure_type, p_year,
                        TO_CHAR(m, 'FM00') || '-' || TO_CHAR(p_year),
                        TO_DATE(TO_CHAR(p_year) || '-' || TO_CHAR(m, 'FM00') || '-01',
                                'YYYY-MM-DD'),
                        p_cf_type, l_amt, l_batch, c_tag);
                l_n := l_n + 1;
            END LOOP;
        END LOOP;
        COMMIT;
        p_rows := l_n;
    END generate_expenditure_plan;

    PROCEDURE generate_revenue_cat_map (p_batch IN  VARCHAR2 DEFAULT NULL,
                                        p_rows  OUT NUMBER) IS
        l_batch VARCHAR2(200) := 'SAMPLE:' || NVL(p_batch, 'REVCAT-01');
        l_n     NUMBER;
    BEGIN
        DELETE FROM prod.dct_gl_revenue_cat_map WHERE loaded_by = c_tag;
        -- Keyword classification over the account descriptions. The account
        -- list is the union of every account that has posted revenue and every
        -- account the chart types as Revenue, so an account that has never
        -- posted still gets a home. Order matters: the narrower keyword wins.
        INSERT INTO prod.dct_gl_revenue_cat_map
               (account_code, cost_center_code, category_code, is_active,
                source_tag, loaded_by)
        WITH ar_acct AS (
            -- MATERIALIZE, and never an OR / IN correlated back into the
            -- 460k-row AR distribution table: that form is FILTER-evaluated per
            -- chart-of-accounts row and takes many minutes (the same shape that
            -- bit the AP facet engine). Built once, hash-joined after.
            SELECT /*+ MATERIALIZE */ DISTINCT
                   LPAD(TO_CHAR(distribution_natural_accou_2), 6, '0') AS account_code
            FROM   prod.atd_ar_invoice_distribution
            WHERE  accounting_class = 'Revenue'
              AND  distribution_natural_accou_2 IS NOT NULL
        ),
        rev_acct AS (
            SELECT DISTINCT account_code
            FROM   prod.dct_gl_coa_snap
            WHERE  account_type = 'Revenue' AND account_code IS NOT NULL
        ),
        wanted AS (
            SELECT account_code FROM ar_acct
            UNION
            SELECT account_code FROM rev_acct
        ),
        a AS (
            SELECT w.account_code, MAX(c.account_desc) AS account_desc
            FROM   wanted w
            LEFT JOIN prod.dct_gl_coa_snap c ON c.account_code = w.account_code
            GROUP BY w.account_code
        )
        SELECT a.account_code,
               NULL,
               CASE
                 WHEN UPPER(a.account_desc) LIKE '%TOURIST GUIDE%'   THEN 'TOURIST_GUIDE'
                 WHEN UPPER(a.account_desc) LIKE '%GUIDED TOUR%'     THEN 'GUIDED_TOURS'
                 WHEN UPPER(a.account_desc) LIKE '%CERTIFICATE%'     THEN 'EXT_GUIDED_CERT'
                 WHEN UPPER(a.account_desc) LIKE '%ALCOHOL%'         THEN 'ALCOHOL_FEES'
                 WHEN UPPER(a.account_desc) LIKE '%HOLIDAY HOME%'    THEN 'HOLIDAY_HOMES'
                 WHEN UPPER(a.account_desc) LIKE '%TICKET%'
                   OR UPPER(a.account_desc) LIKE '%ADMISSION%'       THEN 'ADMISSION_TICKETING'
                 WHEN UPPER(a.account_desc) LIKE '%TOURISM%'         THEN 'TOURISM_FEES'
                 WHEN UPPER(a.account_desc) LIKE '%SPONSOR%'         THEN 'SPONSORSHIP'
                 WHEN UPPER(a.account_desc) LIKE '%MEMBERSHIP%'      THEN 'MEMBERSHIP_FEE'
                 WHEN UPPER(a.account_desc) LIKE '%ROYALT%'          THEN 'ROYALTY'
                 WHEN UPPER(a.account_desc) LIKE '%PARKING%'         THEN 'PARKING_MGMT'
                 WHEN UPPER(a.account_desc) LIKE '%WORKSHOP%'
                   OR UPPER(a.account_desc) LIKE '%WORK SHOP%'       THEN 'WORKSHOPS'
                 WHEN UPPER(a.account_desc) LIKE '%TRAINING%'
                   OR UPPER(a.account_desc) LIKE '%CLASSES%'
                   OR UPPER(a.account_desc) LIKE '%COURSE%'          THEN 'CLASSES_TRAINING'
                 WHEN UPPER(a.account_desc) LIKE '%PUBLICAT%'        THEN 'BOOKS_PUBLICATION'
                 WHEN UPPER(a.account_desc) LIKE '%BOOK%'            THEN 'BOOKS_SALES'
                 WHEN UPPER(a.account_desc) LIKE '%FILM%'
                   OR UPPER(a.account_desc) LIKE '%DOCUMENTAR%'      THEN 'DOCUMENTARY_FILMING'
                 WHEN UPPER(a.account_desc) LIKE '%MUSEUM%'          THEN 'MUSEUM_CHARGE'
                 WHEN UPPER(a.account_desc) LIKE '%VENUE%'
                   OR UPPER(a.account_desc) LIKE '%SPACE RENT%'      THEN 'SPACE_RENT_C'
                 WHEN UPPER(a.account_desc) LIKE '%LICEN%'           THEN 'EVENTS_LICENSING'
                 WHEN UPPER(a.account_desc) LIKE '%RENT%'            THEN 'OPERATOR_RENT'
                 WHEN UPPER(a.account_desc) LIKE '%RETAIL%'          THEN 'RETAIL'
                 WHEN UPPER(a.account_desc) LIKE '%SUNDRY%'
                   OR UPPER(a.account_desc) LIKE '%DISPOSAL%'        THEN 'SUNDRY_RECEIPTS'
                 WHEN UPPER(a.account_desc) LIKE '%ACCRU%'           THEN 'OTHER_ACCRUED'
                 WHEN UPPER(a.account_desc) LIKE '%CULTUR%'
                   OR UPPER(a.account_desc) LIKE '%EXHIBITION%'
                   OR UPPER(a.account_desc) LIKE '%CONFERENCE%'
                   OR UPPER(a.account_desc) LIKE '%SEMINAR%'         THEN 'CULTURE_PROGRAMMING'
                 ELSE 'OTHER_REVENUE'
               END,
               'Y', l_batch, c_tag
        FROM a;
        l_n := SQL%ROWCOUNT;
        COMMIT;
        p_rows := l_n;
    END generate_revenue_cat_map;

    PROCEDURE generate_revenue_plan (p_year      IN  NUMBER,
                                     p_batch     IN  VARCHAR2 DEFAULT NULL,
                                     p_plan_type IN  VARCHAR2 DEFAULT 'APPROVED',
                                     p_rows      OUT NUMBER) IS
        l_batch  VARCHAR2(200) := 'SAMPLE:' || batch_of(p_batch, p_year);
        l_budget NUMBER := 0;
        l_mix    NUMBER := 0;
        l_annual NUMBER;
        l_run    NUMBER;
        l_amt    NUMBER;
        l_n      NUMBER := 0;
    BEGIN
        assert_no_real_revenue(p_year);
        DELETE FROM prod.dct_gl_revenue_plan
        WHERE  budget_year = p_year AND loaded_by = c_tag AND plan_type = p_plan_type;

        -- Basis = the FY revenue BUDGET held in Fusion budgetary control.
        SELECT NVL(SUM(b.total_budget), 0) INTO l_budget
        FROM   prod.gl_balances_cc b
        JOIN   prod.dct_gl_coa_snap c ON c.cc_string = b.cc_string
        WHERE  c.account_type = 'Revenue'
          AND  b.period_name LIKE '%-' || TO_CHAR(p_year);

        IF l_budget <= 0 THEN
            p_rows := 0;
            RETURN;
        END IF;

        -- Shape = the observed ACTUAL mix across cost centres and accounts.
        -- The Fusion revenue budget sits on a SINGLE cost centre, so phasing
        -- the budget alone would put every sector's revenue in one place; the
        -- actual mix is the only sector-bearing signal available. This is
        -- illustrative sample data, not a forecast, and is stamped as such.
        SELECT NVL(SUM(GREATEST(actual_amount, 0)), 0) INTO l_mix
        FROM   prod.dct_gl_revenue_fact_v
        WHERE  budget_year = p_year;

        FOR r IN (
            SELECT cost_center_code, account_code, pct_share
            FROM (
              SELECT f.cost_center_code, f.account_code,
                     SUM(GREATEST(f.actual_amount, 0)) / NULLIF(l_mix, 0) AS pct_share
              FROM   prod.dct_gl_revenue_fact_v f
              WHERE  f.budget_year = p_year AND l_mix > 0
              GROUP  BY f.cost_center_code, f.account_code
              UNION ALL
              -- no actual anywhere yet: fall back to the budget's own split
              SELECT c.cost_center_code, c.account_code,
                     SUM(b.total_budget) / NULLIF(l_budget, 0)
              FROM   prod.gl_balances_cc b
              JOIN   prod.dct_gl_coa_snap c ON c.cc_string = b.cc_string
              WHERE  c.account_type = 'Revenue'
                AND  b.period_name LIKE '%-' || TO_CHAR(p_year)
                AND  l_mix <= 0
              GROUP  BY c.cost_center_code, c.account_code )
            WHERE pct_share > 0 )
        LOOP
            l_annual := ROUND(l_budget * r.pct_share * ratio_of('Revenue')
                              * jitter_of(r.cost_center_code || '|' || r.account_code), 2);
            l_run := 0;
            FOR m IN 1 .. 12 LOOP
                IF m < 12 THEN
                    l_amt := ROUND(l_annual * weight_of('Revenue', m), 2);
                    l_run := l_run + l_amt;
                ELSE
                    l_amt := l_annual - l_run;
                END IF;
                INSERT INTO prod.dct_gl_revenue_plan
                       (budget_year, accounting_period, period_date, cost_center_code,
                        account_code, plan_type, plan_amount, source_file, loaded_by)
                VALUES (p_year,
                        TO_CHAR(m, 'FM00') || '-' || TO_CHAR(p_year),
                        TO_DATE(TO_CHAR(p_year) || '-' || TO_CHAR(m, 'FM00') || '-01',
                                'YYYY-MM-DD'),
                        r.cost_center_code, r.account_code, p_plan_type, l_amt,
                        l_batch, c_tag);
                l_n := l_n + 1;
            END LOOP;
        END LOOP;
        COMMIT;
        p_rows := l_n;
    END generate_revenue_plan;

    PROCEDURE generate_all (p_year IN NUMBER, p_batch IN VARCHAR2 DEFAULT NULL) IS
        l_e NUMBER; l_m NUMBER; l_r NUMBER;
    BEGIN
        generate_revenue_cat_map(p_batch, l_m);
        generate_expenditure_plan(p_year, p_batch, 'APPROVED', l_e);
        generate_revenue_plan(p_year, p_batch, 'APPROVED', l_r);
        DBMS_OUTPUT.put_line('sample plan generated for ' || p_year ||
                             ' -- expenditure ' || l_e || ' rows, revenue ' || l_r ||
                             ' rows, category map ' || l_m || ' rows.');
    END generate_all;

    PROCEDURE purge (p_year     IN  NUMBER   DEFAULT NULL,
                     p_batch    IN  VARCHAR2 DEFAULT NULL,
                     p_exp_rows OUT NUMBER,
                     p_rev_rows OUT NUMBER,
                     p_map_rows OUT NUMBER) IS
        l_like VARCHAR2(200) := CASE WHEN p_batch IS NULL THEN NULL
                                     ELSE 'SAMPLE:' || p_batch END;
    BEGIN
        -- LOCK 1: the ONLY predicate that matters is loaded_by = 'SAMPLE'.
        -- A row Finance uploaded carries its real filename and username and is
        -- therefore unreachable from here, whatever year or batch is passed.
        DELETE FROM prod.dct_project_cashflow
        WHERE  loaded_by = c_tag
          AND (p_year IS NULL OR budget_year = p_year)
          AND (l_like IS NULL OR source_file = l_like);
        p_exp_rows := SQL%ROWCOUNT;

        DELETE FROM prod.dct_gl_revenue_plan
        WHERE  loaded_by = c_tag
          AND (p_year IS NULL OR budget_year = p_year)
          AND (l_like IS NULL OR source_file = l_like);
        p_rev_rows := SQL%ROWCOUNT;

        -- the category map is year-less: only a full purge removes it
        IF p_year IS NULL THEN
            DELETE FROM prod.dct_gl_revenue_cat_map WHERE loaded_by = c_tag;
            p_map_rows := SQL%ROWCOUNT;
        ELSE
            p_map_rows := 0;
        END IF;
        COMMIT;
    END purge;

    PROCEDURE purge (p_year IN NUMBER DEFAULT NULL, p_batch IN VARCHAR2 DEFAULT NULL) IS
        l_e NUMBER; l_r NUMBER; l_m NUMBER;
    BEGIN
        purge(p_year, p_batch, l_e, l_r, l_m);
        DBMS_OUTPUT.put_line('sample plan purged -- expenditure ' || l_e ||
                             ' rows, revenue ' || l_r || ' rows, category map ' ||
                             l_m || ' rows.');
    END purge;

END dct_gl_plan_sample_pkg;
/

PROMPT === 123.13 setting FEATURE_PLAN_SAMPLE_DATA (ships N) ===
INSERT INTO prod.dct_system_settings (setting_key, setting_value, value_type, category, description_en, is_system, created_by)
SELECT 'FEATURE_PLAN_SAMPLE_DATA', 'N', 'BOOLEAN', 'GENERAL',
       'Allow demonstration PLAN data on the Sector Performance report. Y shows the amber sample banner when sample rows exist; N hides the report''s plan columns unless a real plan is loaded.', 'Y', 'SYSTEM'
FROM dual WHERE NOT EXISTS
  (SELECT 1 FROM prod.dct_system_settings WHERE setting_key = 'FEATURE_PLAN_SAMPLE_DATA');

COMMIT;

PROMPT === 123.14 privileges ===
DECLARE
    l_gl NUMBER;
    PROCEDURE ins_priv (p_code VARCHAR2, p_name VARCHAR2, p_ar VARCHAR2,
                        p_action VARCHAR2, p_mid NUMBER) IS
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM prod.dct_permissions WHERE permission_code = p_code;
        IF v = 0 THEN
            INSERT INTO prod.dct_permissions
                (permission_code, permission_name, permission_name_ar,
                 module_id, action_type, verb, created_by)
            VALUES (p_code, p_name, p_ar, p_mid, p_action,
                 UPPER(REGEXP_SUBSTR(p_name, '^\S+')), 'SEED');
        END IF;
    END;
BEGIN
    SELECT MAX(module_id) INTO l_gl FROM prod.dct_modules WHERE module_code = 'GL';
    ins_priv('GL_VIEW_SECTOR_PERFORMANCE', 'View Sector Performance Report',
             UNISTR('\0639\0631\0636 \062A\0642\0631\064A\0631 \0623\062F\0627\0621 \0627\0644\0642\0637\0627\0639'), 'VIEW', l_gl);
    ins_priv('GL_MANAGE_REVENUE_PLAN', 'Manage Revenue Plan',
             UNISTR('\0625\062F\0627\0631\0629 \062E\0637\0629 \0627\0644\0625\064A\0631\0627\062F\0627\062A'), 'CONFIGURE', l_gl);
    ins_priv('GL_MANAGE_PLAN_SAMPLE', 'Manage Sample Plan Data',
             UNISTR('\0625\062F\0627\0631\0629 \0628\064A\0627\0646\0627\062A \0627\0644\062E\0637\0629 \0627\0644\062A\062C\0631\064A\0628\064A\0629'), 'CONFIGURE', l_gl);
    COMMIT;
END;
/

PROMPT === 123.15 recompile sweep ===
-- Adding objects invalidates dependents; a deploy must finish at 0 INVALID as
-- it started (same rule as db/v2/60).
DECLARE
    l_n NUMBER := 0;
BEGIN
    FOR r IN (SELECT object_name, object_type FROM all_objects
              WHERE owner = 'PROD' AND status = 'INVALID'
                AND object_type IN ('VIEW','PACKAGE','PACKAGE BODY','FUNCTION','PROCEDURE','TRIGGER')
              ORDER BY DECODE(object_type,'VIEW',1,'PACKAGE',2,'PACKAGE BODY',3,4))
    LOOP
        BEGIN
            IF r.object_type = 'PACKAGE BODY' THEN
                EXECUTE IMMEDIATE 'ALTER PACKAGE prod."' || r.object_name || '" COMPILE BODY';
            ELSE
                EXECUTE IMMEDIATE 'ALTER ' || r.object_type || ' prod."' || r.object_name || '" COMPILE';
            END IF;
            l_n := l_n + 1;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;
    DBMS_OUTPUT.put_line('recompile attempted on ' || l_n || ' objects.');
END;
/

PROMPT === 123.16 verify ===
SET LINESIZE 200
SELECT (SELECT COUNT(*) FROM all_tables WHERE owner = 'PROD'
         AND table_name IN ('DCT_GL_REVENUE_CATEGORY','DCT_GL_REVENUE_CAT_MAP',
                            'DCT_GL_REVENUE_PLAN'))                        AS new_tables,
       (SELECT COUNT(*) FROM all_views WHERE owner = 'PROD'
         AND view_name IN ('DCT_GL_REVENUE_FACT_V','DCT_SECTOR_PLAN_V',
                           'DCT_SECTOR_PLAN_ORPHAN_V','DCT_SECTOR_PERF_V',
                           'DCT_SECTOR_ACTUAL_MONTH_V'))                   AS new_views,
       (SELECT COUNT(*) FROM prod.dct_gl_revenue_category)                 AS categories,
       (SELECT COUNT(*) FROM prod.dct_permissions
         WHERE permission_code IN ('GL_VIEW_SECTOR_PERFORMANCE',
                                   'GL_MANAGE_REVENUE_PLAN',
                                   'GL_MANAGE_PLAN_SAMPLE'))               AS new_privs,
       (SELECT COUNT(*) FROM all_objects WHERE owner = 'PROD' AND status = 'INVALID') AS invalid
FROM dual;

PROMPT ============================================================
PROMPT  123_gl_sector_perf.sql complete.
PROMPT  Sample plan data is NOT generated by this script. To seed it:
PROMPT    EXEC prod.dct_gl_plan_sample_pkg.generate_all(2026);
PROMPT  and to remove every trace of it again:
PROMPT    EXEC prod.dct_gl_plan_sample_pkg.purge(2026);
PROMPT ============================================================
