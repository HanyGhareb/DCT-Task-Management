-- =============================================================================
-- Finance KPI Management Module (App 213) -- Read Views
-- File    : 02_kpi_views.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @02_kpi_views.sql   (after 01_kpi_ddl.sql)
-- Notes   : Display datetimes go through prod.dct_to_local (UTC storage,
--           Asia/Dubai display) with the platform 12-hour format.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- 1. DCT_KPI_DEFINITION_V -- registry with content counts
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_kpi_definition_v AS
SELECT d.kpi_id, d.kpi_code, d.name_en, d.name_ar,
       d.description_en, d.description_ar,
       d.kpi_type, d.polarity, d.unit_en, d.unit_ar,
       d.frequency, d.calc_method, d.calc_desc_en, d.calc_desc_ar,
       d.source_of_data_en, d.source_of_data_ar,
       d.kpi_owner_en, d.kpi_owner_ar, d.note_en, d.note_ar,
       d.source_code_a, d.source_code_b,
       d.figure_a_label_en, d.figure_a_label_ar,
       d.figure_b_label_en, d.figure_b_label_ar,
       d.scorecard_weight_pct, d.requires_evidence,
       d.display_order, d.is_active,
       (SELECT COUNT(*) FROM prod.dct_kpi_score_bands b WHERE b.kpi_id = d.kpi_id)                     AS band_count,
       (SELECT COUNT(*) FROM prod.dct_kpi_criteria c WHERE c.kpi_id = d.kpi_id AND c.is_active = 'Y')  AS criteria_count,
       (SELECT NVL(SUM(c.weight_pct),0) FROM prod.dct_kpi_criteria c
         WHERE c.kpi_id = d.kpi_id AND c.is_active = 'Y')                                              AS criteria_weight_sum,
       (SELECT t.target_value FROM prod.dct_kpi_targets t
         WHERE t.kpi_id = d.kpi_id AND t.target_year = EXTRACT(YEAR FROM SYSDATE))                     AS current_year_target,
       (SELECT t.label_en FROM prod.dct_kpi_targets t
         WHERE t.kpi_id = d.kpi_id AND t.target_year = EXTRACT(YEAR FROM SYSDATE))                     AS current_year_target_label,
       d.created_by, TO_CHAR(d.created_at, 'YYYY-MM-DD') AS created_on,
       d.updated_by, TO_CHAR(d.updated_at, 'YYYY-MM-DD') AS updated_on
  FROM prod.dct_kpi_definitions d;

-- =============================================================================
-- 2. DCT_KPI_RESULT_V -- results with KPI + period context
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_kpi_result_v AS
SELECT r.result_id, r.kpi_id, d.kpi_code, d.name_en AS kpi_name_en, d.name_ar AS kpi_name_ar,
       d.polarity, d.frequency, d.calc_method, d.requires_evidence,
       d.figure_a_label_en, d.figure_a_label_ar, d.figure_b_label_en, d.figure_b_label_ar,
       d.unit_en, d.unit_ar,
       r.period_id, p.period_year, p.period_type, p.period_no,
       CASE p.period_type WHEN 'ANNUAL' THEN TO_CHAR(p.period_year)
            ELSE p.period_year || '-Q' || p.period_no END                     AS period_label,
       p.status AS period_status,
       r.figure_a, r.figure_b, r.suggested_a, r.suggested_b,
       r.figure_a_source, r.figure_b_source,
       r.result_pct, r.score, r.target_value, r.status,
       r.wf_instance_id, r.notes,
       r.prepared_by,
       (SELECT u.display_name FROM prod.dct_users u WHERE u.user_id = r.prepared_by)  AS prepared_by_name,
       r.submitted_by,
       (SELECT u.display_name FROM prod.dct_users u WHERE u.user_id = r.submitted_by) AS submitted_by_name,
       TO_CHAR(prod.dct_to_local(r.submitted_at), 'YYYY-MM-DD HH:MI AM')      AS submitted_at_disp,
       TO_CHAR(prod.dct_to_local(r.approved_at),  'YYYY-MM-DD HH:MI AM')      AS approved_at_disp,
       (SELECT COUNT(*) FROM prod.dct_documents dc
         WHERE dc.source_module = 'KPI_MGMT' AND dc.source_type = 'KPI_RESULT'
           AND dc.source_id = r.result_id AND dc.is_active = 'Y')             AS doc_count,
       r.created_by, r.updated_by,
       TO_CHAR(r.updated_at, 'YYYY-MM-DD')                                    AS updated_on
  FROM prod.dct_kpi_results r
  JOIN prod.dct_kpi_definitions d ON d.kpi_id = r.kpi_id
  JOIN prod.dct_kpi_periods p     ON p.period_id = r.period_id;

-- =============================================================================
-- 3. DCT_KPI_RESULT_CRIT_V -- per-criterion entries with criterion context
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_kpi_result_crit_v AS
SELECT rc.result_crit_id, rc.result_id, rc.criterion_id,
       c.kpi_id, c.criterion_code, c.name_en, c.name_ar,
       c.description_en, c.description_ar,
       c.weight_pct, c.entry_type,
       c.frequency_note_en, c.frequency_note_ar, c.display_order,
       rc.level_no, rc.achieved_pct, rc.crit_score, rc.justification,
       (SELECT l.title_en FROM prod.dct_kpi_criteria_levels l
         WHERE l.criterion_id = rc.criterion_id AND l.level_no = rc.level_no) AS level_title_en,
       (SELECT l.title_ar FROM prod.dct_kpi_criteria_levels l
         WHERE l.criterion_id = rc.criterion_id AND l.level_no = rc.level_no) AS level_title_ar
  FROM prod.dct_kpi_result_criteria rc
  JOIN prod.dct_kpi_criteria c ON c.criterion_id = rc.criterion_id;

-- =============================================================================
-- 4. DCT_KPI_SCORECARD_V -- per KPI x year rollup over APPROVED results
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_kpi_scorecard_v AS
SELECT d.kpi_id, d.kpi_code, d.name_en, d.name_ar,
       d.frequency, d.polarity, d.scorecard_weight_pct, d.display_order,
       p.period_year,
       COUNT(r.result_id)                                        AS results_count,
       COUNT(CASE WHEN r.status = 'APPROVED' THEN 1 END)         AS approved_count,
       ROUND(AVG(CASE WHEN r.status = 'APPROVED' THEN r.score END), 2)      AS avg_score,
       ROUND(AVG(CASE WHEN r.status = 'APPROVED' THEN r.result_pct END), 1) AS avg_result_pct,
       MAX(CASE WHEN r.status = 'APPROVED' THEN r.result_pct END)
           KEEP (DENSE_RANK LAST ORDER BY p.start_date)          AS latest_result_pct,
       MAX(CASE WHEN r.status = 'APPROVED' THEN r.score END)
           KEEP (DENSE_RANK LAST ORDER BY p.start_date)          AS latest_score,
       MAX(t.target_value)                                       AS target_value,
       MAX(t.label_en)                                           AS target_label_en
  FROM prod.dct_kpi_definitions d
  JOIN prod.dct_kpi_results r  ON r.kpi_id = d.kpi_id
  JOIN prod.dct_kpi_periods p  ON p.period_id = r.period_id
  LEFT JOIN prod.dct_kpi_targets t ON t.kpi_id = d.kpi_id AND t.target_year = p.period_year
 WHERE d.is_active = 'Y'
 GROUP BY d.kpi_id, d.kpi_code, d.name_en, d.name_ar,
          d.frequency, d.polarity, d.scorecard_weight_pct, d.display_order, p.period_year;

-- =============================================================================
-- 5. DCT_KPI_WF_FACT_V -- Workflow Platform fact source (key RESULT_ID)
-- =============================================================================
CREATE OR REPLACE VIEW prod.dct_kpi_wf_fact_v AS
SELECT r.result_id,
       d.kpi_code,
       d.name_en    AS kpi_name,
       r.score,
       r.result_pct,
       p.period_type,
       p.period_year,
       CASE p.period_type WHEN 'ANNUAL' THEN TO_CHAR(p.period_year)
            ELSE p.period_year || '-Q' || p.period_no END AS period_label,
       d.frequency,
       d.requires_evidence
  FROM prod.dct_kpi_results r
  JOIN prod.dct_kpi_definitions d ON d.kpi_id = r.kpi_id
  JOIN prod.dct_kpi_periods p     ON p.period_id = r.period_id;

PROMPT === 02_kpi_views.sql complete: 5 DCT_KPI_* views created ===
