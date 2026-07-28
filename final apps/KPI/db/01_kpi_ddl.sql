-- =============================================================================
-- Finance KPI Management Module (App 213) -- DDL
-- File    : 01_kpi_ddl.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @01_kpi_ddl.sql   (connects as ADMIN)
-- Requires: V2 shared framework -- DCT_USERS, DCT_DOCUMENTS,
--           DCT_REQUEST_STATUS_HISTORY, DCT_LOOKUP_PKG already present.
-- Notes   : Lookup-first -- NO status CHECK constraints on these tables; the
--           status/type families live in DCT_LOOKUP_VALUES and are validated
--           by DCT_KPI_PKG via DCT_LOOKUP_PKG.validate_lookup.
--           Y/N flag CHECKs are kept (booleans).
--           DCT_KPI_SOURCES is a declarative registry only -- the executable
--           figure logic lives exclusively in DCT_KPI_PKG.suggest_value as
--           static SQL (zero dynamic SQL, same philosophy as DCT_WF_EXPR).
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- Cleanup of prior objects (reverse dependency order) -- safe re-run
-- =============================================================================
DECLARE
    PROCEDURE drop_table (p_name VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE prod.' || p_name || ' CASCADE CONSTRAINTS PURGE';
        DBMS_OUTPUT.PUT_LINE('Dropped: ' || p_name);
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE != -942 THEN RAISE; END IF;
    END;
BEGIN
    drop_table('DCT_KPI_RESULT_CRITERIA');
    drop_table('DCT_KPI_RESULTS');
    drop_table('DCT_KPI_PERIODS');
    drop_table('DCT_KPI_TARGETS');
    drop_table('DCT_KPI_CRITERIA_LEVELS');
    drop_table('DCT_KPI_CRITERIA');
    drop_table('DCT_KPI_SCORE_BANDS');
    drop_table('DCT_KPI_DEFINITIONS');
    drop_table('DCT_KPI_SOURCES');
END;
/

-- =============================================================================
-- 1. DCT_KPI_SOURCES -- declarative auto-figure source registry (no free SQL)
-- =============================================================================
CREATE TABLE prod.dct_kpi_sources (
  source_id        NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  source_code      VARCHAR2(40)    NOT NULL,
  name_en          VARCHAR2(200)   NOT NULL,
  name_ar          VARCHAR2(200),
  description_en   VARCHAR2(1000),
  description_ar   VARCHAR2(1000),
  account_from     VARCHAR2(20),
  account_to       VARCHAR2(20),
  scope_code       VARCHAR2(60),
  is_active        VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_kpisrc_code  UNIQUE (source_code),
  CONSTRAINT chk_dct_kpisrc_act  CHECK  (is_active IN ('Y','N'))
);
COMMENT ON TABLE  prod.dct_kpi_sources IS 'KPI auto-figure source registry (App 213). Declarative parameters only -- the executable static SQL per source_code lives in DCT_KPI_PKG.suggest_value.';
COMMENT ON COLUMN prod.dct_kpi_sources.account_from IS 'Optional GL natural-account range start used by the package logic for this source.';
COMMENT ON COLUMN prod.dct_kpi_sources.scope_code   IS 'Optional free scope discriminator consumed by the package logic (e.g. ledger name).';

-- =============================================================================
-- 2. DCT_KPI_DEFINITIONS -- the KPI registry
-- =============================================================================
CREATE TABLE prod.dct_kpi_definitions (
  kpi_id               NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  kpi_code             VARCHAR2(30)    NOT NULL,
  name_en              VARCHAR2(200)   NOT NULL,
  name_ar              VARCHAR2(200),
  description_en       VARCHAR2(2000),
  description_ar       VARCHAR2(2000),
  kpi_type             VARCHAR2(30)    DEFAULT 'STRATEGIC' NOT NULL,   -- lookup KPI_TYPE
  polarity             VARCHAR2(30)    DEFAULT 'ASCENDING' NOT NULL,   -- lookup KPI_POLARITY
  unit_en              VARCHAR2(60),
  unit_ar              VARCHAR2(60),
  frequency            VARCHAR2(30)    NOT NULL,                       -- lookup KPI_FREQUENCY
  calc_method          VARCHAR2(30)    NOT NULL,                       -- lookup KPI_CALC_METHOD
  calc_desc_en         VARCHAR2(1000),
  calc_desc_ar         VARCHAR2(1000),
  source_of_data_en    VARCHAR2(500),
  source_of_data_ar    VARCHAR2(500),
  kpi_owner_en         VARCHAR2(200),
  kpi_owner_ar         VARCHAR2(200),
  note_en              VARCHAR2(1000),
  note_ar              VARCHAR2(1000),
  source_code_a        VARCHAR2(40),                                   -- optional auto-source for figure A
  source_code_b        VARCHAR2(40),                                   -- optional auto-source for figure B
  figure_a_label_en    VARCHAR2(120),
  figure_a_label_ar    VARCHAR2(120),
  figure_b_label_en    VARCHAR2(120),
  figure_b_label_ar    VARCHAR2(120),
  scorecard_weight_pct NUMBER          DEFAULT 25 NOT NULL,
  requires_evidence    VARCHAR2(1)     DEFAULT 'N' NOT NULL,
  display_order        NUMBER          DEFAULT 100 NOT NULL,
  is_active            VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  created_by           VARCHAR2(100),
  created_at           DATE            DEFAULT SYSDATE NOT NULL,
  updated_by           VARCHAR2(100),
  updated_at           DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_kpidef_code  UNIQUE (kpi_code),
  CONSTRAINT chk_dct_kpidef_ev   CHECK  (requires_evidence IN ('Y','N')),
  CONSTRAINT chk_dct_kpidef_act  CHECK  (is_active IN ('Y','N')),
  CONSTRAINT chk_dct_kpidef_wt   CHECK  (scorecard_weight_pct BETWEEN 0 AND 100),
  CONSTRAINT fk_dct_kpidef_srca  FOREIGN KEY (source_code_a) REFERENCES prod.dct_kpi_sources(source_code),
  CONSTRAINT fk_dct_kpidef_srcb  FOREIGN KEY (source_code_b) REFERENCES prod.dct_kpi_sources(source_code)
);
CREATE INDEX prod.ix_dct_kpidef_active ON prod.dct_kpi_definitions(is_active, display_order);
COMMENT ON TABLE  prod.dct_kpi_definitions IS 'Finance KPI registry (App 213) -- generic configurable KPI framework; the DOF circular KPIs are seed content.';
COMMENT ON COLUMN prod.dct_kpi_definitions.calc_method IS 'Lookup KPI_CALC_METHOD: RATIO_A_OVER_B / ABS_VARIANCE / WEIGHTED_CRITERIA.';
COMMENT ON COLUMN prod.dct_kpi_definitions.scorecard_weight_pct IS 'Weight of this KPI in the overall entity scorecard (defaults equal weighting).';

-- =============================================================================
-- 3. DCT_KPI_SCORE_BANDS -- 1..5 score criteria bands per KPI
-- =============================================================================
CREATE TABLE prod.dct_kpi_score_bands (
  band_id          NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  kpi_id           NUMBER          NOT NULL,
  band_score       NUMBER(1)       NOT NULL,
  operator         VARCHAR2(10)    NOT NULL,          -- lookup KPI_BAND_OP: LT/LE/EQ/GE/GT/BETWEEN
  threshold_1      NUMBER          NOT NULL,
  threshold_2      NUMBER,
  label_en         VARCHAR2(60),
  label_ar         VARCHAR2(60),
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_kpiband      UNIQUE (kpi_id, band_score),
  CONSTRAINT chk_dct_kpiband_sc  CHECK  (band_score BETWEEN 1 AND 5),
  CONSTRAINT fk_dct_kpiband_kpi  FOREIGN KEY (kpi_id) REFERENCES prod.dct_kpi_definitions(kpi_id) ON DELETE CASCADE
);
COMMENT ON TABLE prod.dct_kpi_score_bands IS 'Per-KPI 1..5 score criteria. Evaluated by DCT_KPI_PKG.score_of from band 5 down to 1, first match wins (handles overlapping circular bands and descending KPIs).';

-- =============================================================================
-- 4. DCT_KPI_CRITERIA -- weighted sub-criteria (rubric rows + checklist items)
-- =============================================================================
CREATE TABLE prod.dct_kpi_criteria (
  criterion_id     NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  kpi_id           NUMBER          NOT NULL,
  criterion_code   VARCHAR2(40)    NOT NULL,
  name_en          VARCHAR2(300)   NOT NULL,
  name_ar          VARCHAR2(300),
  description_en   VARCHAR2(1000),
  description_ar   VARCHAR2(1000),
  weight_pct       NUMBER          NOT NULL,
  entry_type       VARCHAR2(30)    NOT NULL,          -- lookup KPI_CRIT_ENTRY: MATURITY_1_5 / PERCENT_0_100
  frequency_note_en VARCHAR2(200),
  frequency_note_ar VARCHAR2(200),
  display_order    NUMBER          DEFAULT 100 NOT NULL,
  is_active        VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_kpicrit      UNIQUE (kpi_id, criterion_code),
  CONSTRAINT chk_dct_kpicrit_wt  CHECK  (weight_pct BETWEEN 0 AND 100),
  CONSTRAINT chk_dct_kpicrit_act CHECK  (is_active IN ('Y','N')),
  CONSTRAINT fk_dct_kpicrit_kpi  FOREIGN KEY (kpi_id) REFERENCES prod.dct_kpi_definitions(kpi_id) ON DELETE CASCADE
);
COMMENT ON TABLE prod.dct_kpi_criteria IS 'Weighted sub-criteria for WEIGHTED_CRITERIA KPIs. entry_type MATURITY_1_5 = assessor picks a described maturity level (rubric); PERCENT_0_100 = achieved percentage (checklist item). Package validates weights sum to 100 per KPI.';

-- =============================================================================
-- 5. DCT_KPI_CRITERIA_LEVELS -- maturity level descriptions (rubric cells)
-- =============================================================================
CREATE TABLE prod.dct_kpi_criteria_levels (
  level_id         NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  criterion_id     NUMBER          NOT NULL,
  level_no         NUMBER(1)       NOT NULL,
  title_en         VARCHAR2(120),
  title_ar         VARCHAR2(120),
  description_en   VARCHAR2(2000),
  description_ar   VARCHAR2(2000),
  --
  CONSTRAINT uq_dct_kpilvl       UNIQUE (criterion_id, level_no),
  CONSTRAINT chk_dct_kpilvl_no   CHECK  (level_no BETWEEN 1 AND 5),
  CONSTRAINT fk_dct_kpilvl_crit  FOREIGN KEY (criterion_id) REFERENCES prod.dct_kpi_criteria(criterion_id) ON DELETE CASCADE
);
COMMENT ON TABLE prod.dct_kpi_criteria_levels IS 'Qualitative 1..5 maturity level descriptions shown to the assessor for MATURITY_1_5 criteria (the circular rubric cells).';

-- =============================================================================
-- 6. DCT_KPI_TARGETS -- yearly targets per KPI
-- =============================================================================
CREATE TABLE prod.dct_kpi_targets (
  target_id        NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  kpi_id           NUMBER          NOT NULL,
  target_year      NUMBER(4)       NOT NULL,
  target_value     NUMBER          NOT NULL,
  label_en         VARCHAR2(60),
  label_ar         VARCHAR2(60),
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_kpitgt       UNIQUE (kpi_id, target_year),
  CONSTRAINT fk_dct_kpitgt_kpi   FOREIGN KEY (kpi_id) REFERENCES prod.dct_kpi_definitions(kpi_id) ON DELETE CASCADE
);
COMMENT ON TABLE prod.dct_kpi_targets IS 'Per-KPI yearly target values (the circular Targets row). label carries the display form, e.g. a tolerance target.';

-- =============================================================================
-- 7. DCT_KPI_PERIODS -- measurement periods (annual + quarters)
-- =============================================================================
CREATE TABLE prod.dct_kpi_periods (
  period_id        NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  period_year      NUMBER(4)       NOT NULL,
  period_type      VARCHAR2(20)    NOT NULL,          -- lookup KPI_PERIOD_TYPE: ANNUAL / QUARTER
  period_no        NUMBER(1),                          -- NULL for ANNUAL, 1..4 for QUARTER
  start_date       DATE            NOT NULL,
  end_date         DATE            NOT NULL,
  status           VARCHAR2(20)    DEFAULT 'OPEN' NOT NULL,   -- lookup KPI_PERIOD_STATUS
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_kpiper       UNIQUE (period_year, period_type, period_no),
  CONSTRAINT chk_dct_kpiper_no   CHECK  (period_no IS NULL OR period_no BETWEEN 1 AND 4),
  CONSTRAINT chk_dct_kpiper_dts  CHECK  (end_date >= start_date)
);
COMMENT ON TABLE prod.dct_kpi_periods IS 'KPI measurement calendar rows generated idempotently by DCT_KPI_PKG.ensure_periods (one ANNUAL + four QUARTER rows per year).';

-- =============================================================================
-- 8. DCT_KPI_RESULTS -- one measurement per KPI per period
-- =============================================================================
CREATE TABLE prod.dct_kpi_results (
  result_id        NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  kpi_id           NUMBER          NOT NULL,
  period_id        NUMBER          NOT NULL,
  figure_a         NUMBER,
  figure_b         NUMBER,
  suggested_a      NUMBER,
  suggested_b      NUMBER,
  figure_a_source  VARCHAR2(10)    DEFAULT 'MANUAL' NOT NULL,  -- lookup KPI_VALUE_SOURCE
  figure_b_source  VARCHAR2(10)    DEFAULT 'MANUAL' NOT NULL,
  result_pct       NUMBER,
  score            NUMBER(1),
  target_value     NUMBER,
  status           VARCHAR2(30)    DEFAULT 'DRAFT' NOT NULL,   -- lookup KPI_RESULT_STATUS
  wf_instance_id   NUMBER,                                     -- DWP instance, nullable, no FK
  notes            VARCHAR2(2000),
  prepared_by      NUMBER,
  submitted_by     NUMBER,
  submitted_at     TIMESTAMP,
  approved_at      TIMESTAMP,
  created_by       VARCHAR2(100),
  created_at       DATE            DEFAULT SYSDATE NOT NULL,
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_kpires       UNIQUE (kpi_id, period_id),
  CONSTRAINT fk_dct_kpires_kpi   FOREIGN KEY (kpi_id)    REFERENCES prod.dct_kpi_definitions(kpi_id),
  CONSTRAINT fk_dct_kpires_per   FOREIGN KEY (period_id) REFERENCES prod.dct_kpi_periods(period_id),
  CONSTRAINT fk_dct_kpires_prep  FOREIGN KEY (prepared_by)  REFERENCES prod.dct_users(user_id),
  CONSTRAINT fk_dct_kpires_subm  FOREIGN KEY (submitted_by) REFERENCES prod.dct_users(user_id)
);
CREATE INDEX prod.ix_dct_kpires_kpi    ON prod.dct_kpi_results(kpi_id, status);
CREATE INDEX prod.ix_dct_kpires_period ON prod.dct_kpi_results(period_id);
CREATE INDEX prod.ix_dct_kpires_wf     ON prod.dct_kpi_results(wf_instance_id);
COMMENT ON TABLE  prod.dct_kpi_results IS 'KPI measurement per period. Status lifecycle DRAFT/SUBMITTED/APPROVED/RETURNED (lookup); approval chain runs on the DCT Workflow Platform (wf_instance_id).';
COMMENT ON COLUMN prod.dct_kpi_results.suggested_a IS 'System-computed suggestion retained for audit; figure_a_source flips to MANUAL when the preparer diverges.';
COMMENT ON COLUMN prod.dct_kpi_results.target_value IS 'Snapshot of the KPI year target at init time.';

-- =============================================================================
-- 9. DCT_KPI_RESULT_CRITERIA -- per-criterion entries under a result
-- =============================================================================
CREATE TABLE prod.dct_kpi_result_criteria (
  result_crit_id   NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  result_id        NUMBER          NOT NULL,
  criterion_id     NUMBER          NOT NULL,
  level_no         NUMBER(1),                          -- MATURITY_1_5 entry
  achieved_pct     NUMBER,                             -- PERCENT_0_100 entry
  crit_score       NUMBER,                             -- derived contribution
  justification    VARCHAR2(2000),
  updated_by       VARCHAR2(100),
  updated_at       DATE            DEFAULT SYSDATE NOT NULL,
  --
  CONSTRAINT uq_dct_kpirescrit      UNIQUE (result_id, criterion_id),
  CONSTRAINT chk_dct_kpirescrit_lvl CHECK  (level_no IS NULL OR level_no BETWEEN 1 AND 5),
  CONSTRAINT chk_dct_kpirescrit_pct CHECK  (achieved_pct IS NULL OR achieved_pct BETWEEN 0 AND 100),
  CONSTRAINT fk_dct_kpirescrit_res  FOREIGN KEY (result_id)    REFERENCES prod.dct_kpi_results(result_id) ON DELETE CASCADE,
  CONSTRAINT fk_dct_kpirescrit_crt  FOREIGN KEY (criterion_id) REFERENCES prod.dct_kpi_criteria(criterion_id)
);
CREATE INDEX prod.ix_dct_kpirescrit_res ON prod.dct_kpi_result_criteria(result_id);
COMMENT ON TABLE prod.dct_kpi_result_criteria IS 'Per-criterion entry rows under a WEIGHTED_CRITERIA result (skeleton rows created at init_result).';

PROMPT === 01_kpi_ddl.sql complete: 9 DCT_KPI_* tables created ===
