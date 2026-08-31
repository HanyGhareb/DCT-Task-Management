-- =============================================================================
-- Finance KPIs V2 (App 213) -- Phase 2 KPI master records DDL
-- File   : 03_kpi2_master_ddl.sql
-- Schema : PROD (run as ADMIN; objects prefixed prod.)
-- Tables : DCT_KPI2_DEFINITIONS  -- plan-independent KPI master (reusable in
--                                   multiple plans; weight/display order/targets
--                                   belong to the plan assignment, NOT here)
--          DCT_KPI2_DEF_SOURCE   -- multi-select Data Sources  (KPI2_DATA_SOURCE)
--          DCT_KPI2_DEF_FIGURE   -- multi-select Source Figures (KPI2_SOURCE_FIGURE)
--          DCT_KPI2_BANDS        -- per-KPI 1..5 score bands, v1 shape
--                                   (operator + thresholds, evaluated 5->1 first match)
-- Rules  : lookup-first -- NO status/enum CHECK constraints; every lookup-coded
--          column is validated by the ORDS handlers via dct_lookup_pkg.
-- Rerun  : guarded -- each table created only when missing.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

DECLARE
    PROCEDURE run_if_missing(p_table VARCHAR2, p_ddl CLOB) IS
        n NUMBER;
    BEGIN
        SELECT COUNT(*) INTO n FROM all_tables
         WHERE owner = 'PROD' AND table_name = UPPER(p_table);
        IF n = 0 THEN
            EXECUTE IMMEDIATE p_ddl;
            DBMS_OUTPUT.PUT_LINE('.. created ' || p_table);
        ELSE
            DBMS_OUTPUT.PUT_LINE('.. ' || p_table || ' already present');
        END IF;
    END;
BEGIN

    run_if_missing('DCT_KPI2_DEFINITIONS', q'[
CREATE TABLE prod.dct_kpi2_definitions (
    kpi_id            NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kpi_code          VARCHAR2(60)    NOT NULL,
    name_en           VARCHAR2(300)   NOT NULL,
    name_ar           VARCHAR2(300),
    description_en    VARCHAR2(2000),
    description_ar    VARCHAR2(2000),
    kpi_type          VARCHAR2(100)   NOT NULL,
    category          VARCHAR2(100),
    reporting_freq    VARCHAR2(100)   NOT NULL,
    updating_freq     VARCHAR2(100)   NOT NULL,
    polarity          VARCHAR2(100)   NOT NULL,
    calc_method       VARCHAR2(100)   NOT NULL,
    uom               VARCHAR2(100)   NOT NULL,
    evidence_required VARCHAR2(1)     DEFAULT 'N' NOT NULL,
    is_active         VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    created_by        VARCHAR2(100),
    created_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by        VARCHAR2(100),
    updated_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT uq_dct_kpi2def_code   UNIQUE (kpi_code),
    CONSTRAINT chk_dct_kpi2def_ev    CHECK  (evidence_required IN ('Y','N')),
    CONSTRAINT chk_dct_kpi2def_act   CHECK  (is_active IN ('Y','N'))
)]');

    run_if_missing('DCT_KPI2_DEF_SOURCE', q'[
CREATE TABLE prod.dct_kpi2_def_source (
    kpi_id       NUMBER         NOT NULL,
    source_code  VARCHAR2(100)  NOT NULL,
    created_by   VARCHAR2(100),
    created_at   TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT pk_dct_kpi2src PRIMARY KEY (kpi_id, source_code),
    CONSTRAINT fk_dct_kpi2src_kpi FOREIGN KEY (kpi_id)
        REFERENCES prod.dct_kpi2_definitions(kpi_id) ON DELETE CASCADE
)]');

    run_if_missing('DCT_KPI2_DEF_FIGURE', q'[
CREATE TABLE prod.dct_kpi2_def_figure (
    kpi_id       NUMBER         NOT NULL,
    figure_code  VARCHAR2(100)  NOT NULL,
    created_by   VARCHAR2(100),
    created_at   TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT pk_dct_kpi2fig PRIMARY KEY (kpi_id, figure_code),
    CONSTRAINT fk_dct_kpi2fig_kpi FOREIGN KEY (kpi_id)
        REFERENCES prod.dct_kpi2_definitions(kpi_id) ON DELETE CASCADE
)]');

    run_if_missing('DCT_KPI2_BANDS', q'[
CREATE TABLE prod.dct_kpi2_bands (
    band_id      NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kpi_id       NUMBER          NOT NULL,
    band_score   NUMBER(1)       NOT NULL,
    operator     VARCHAR2(10)    NOT NULL,
    threshold_1  NUMBER          NOT NULL,
    threshold_2  NUMBER,
    label_en     VARCHAR2(60),
    label_ar     VARCHAR2(60),
    created_by   VARCHAR2(100),
    created_at   TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT uq_dct_kpi2band     UNIQUE (kpi_id, band_score),
    CONSTRAINT chk_dct_kpi2band_sc CHECK  (band_score BETWEEN 1 AND 5),
    CONSTRAINT fk_dct_kpi2band_kpi FOREIGN KEY (kpi_id)
        REFERENCES prod.dct_kpi2_definitions(kpi_id) ON DELETE CASCADE
)]');

END;
/

COMMENT ON TABLE prod.dct_kpi2_definitions IS 'KPI-V2 plan-independent KPI master. Weight, display order and targets live on the plan assignment (later phase), never here.';
COMMENT ON TABLE prod.dct_kpi2_bands IS 'KPI-V2 per-KPI 1..5 score bands, same shape as v1 dct_kpi_score_bands: evaluated 5 down to 1, first match wins.';

PROMPT == ADMIN synonyms (for the kpi.rest handlers) ==
CREATE OR REPLACE SYNONYM dct_kpi2_definitions FOR prod.dct_kpi2_definitions;
CREATE OR REPLACE SYNONYM dct_kpi2_def_source  FOR prod.dct_kpi2_def_source;
CREATE OR REPLACE SYNONYM dct_kpi2_def_figure  FOR prod.dct_kpi2_def_figure;
CREATE OR REPLACE SYNONYM dct_kpi2_bands       FOR prod.dct_kpi2_bands;

PROMPT == verification ==
SELECT table_name FROM all_tables
 WHERE owner = 'PROD' AND table_name LIKE 'DCT_KPI2%' ORDER BY 1;
