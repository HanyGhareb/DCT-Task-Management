-- =============================================================================
-- Reporting Platform -- KPI_BRIEFING_BOOK definition (Finance KPIs, App 213)
-- File    : reporting/db/29_rpt_kpi_book.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @29_rpt_kpi_book.sql
-- Report  : MULTI / PYTHON, 6 sections over the DCT_KPI_* views; param year
--           (required). PDF via DB template kpi_briefing_book.html.j2
--           (uploaded via /rpt/templates or runner/upload_template.py).
--           Enqueued by the module bridge POST /kpi/reports/book.
-- Safe    : idempotent update-first upsert; no merge statements.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

DECLARE
    l_src  CLOB;
    l_ps   CLOB;
    l_n    NUMBER;

    PROCEDURE app (p VARCHAR2) IS
    BEGIN
        DBMS_LOB.WRITEAPPEND(l_src, LENGTH(p), p);
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(l_src, TRUE);

    app('{"orientation":"portrait","required":["year"],"sections":[');

    app('{"key":"overview","title":"Executive Scorecard","layout":"table","sql":"');
    app('SELECT d.kpi_code, d.name_en AS kpi, d.frequency, d.scorecard_weight_pct AS weight_pct, ');
    app('NVL(s.approved_count,0) AS approved_results, s.avg_score, s.latest_result_pct, t.label_en AS target ');
    app('FROM prod.dct_kpi_definitions d ');
    app('LEFT JOIN prod.dct_kpi_scorecard_v s ON s.kpi_id = d.kpi_id AND s.period_year = :year ');
    app('LEFT JOIN prod.dct_kpi_targets t ON t.kpi_id = d.kpi_id AND t.target_year = :year ');
    app('WHERE d.is_active = ''Y'' ORDER BY d.display_order"},');

    app('{"key":"results","title":"Measurement Register","layout":"table","sql":"');
    app('SELECT r.kpi_code, r.period_label AS period, r.figure_a, r.figure_a_source AS src_a, ');
    app('r.figure_b, r.figure_b_source AS src_b, r.result_pct, r.score, r.target_value, r.status, ');
    app('r.prepared_by_name AS prepared_by, r.submitted_at_disp AS submitted_at, r.approved_at_disp AS approved_at ');
    app('FROM prod.dct_kpi_result_v r WHERE r.period_year = :year ');
    app('ORDER BY r.kpi_code, r.period_type, r.period_no"},');

    app('{"key":"criteria","title":"Assessment Criteria Breakdown","layout":"table","sql":"');
    app('SELECT r.kpi_code, r.period_label AS period, c.name_en AS criterion, c.weight_pct AS weight, ');
    app('c.level_no AS maturity_level, c.level_title_en AS level_title, c.achieved_pct, ');
    app('c.crit_score AS contribution, c.justification ');
    app('FROM prod.dct_kpi_result_crit_v c JOIN prod.dct_kpi_result_v r ON r.result_id = c.result_id ');
    app('WHERE r.period_year = :year ORDER BY r.kpi_code, r.period_type, r.period_no, c.display_order"},');

    app('{"key":"evidence","title":"Evidence Register","layout":"table","sql":"');
    app('SELECT r.kpi_code, r.period_label AS period, d.file_name, ');
    app('ROUND(d.file_size_bytes/1024) AS size_kb, u.display_name AS uploaded_by, ');
    app('TO_CHAR(prod.dct_to_local(d.created_at), ''YYYY-MM-DD'') AS uploaded_on ');
    app('FROM prod.dct_documents d JOIN prod.dct_kpi_result_v r ON r.result_id = d.source_id ');
    app('LEFT JOIN prod.dct_users u ON u.user_id = d.created_by ');
    app('WHERE d.source_module = ''KPI_MGMT'' AND d.source_type = ''KPI_RESULT'' ');
    app('AND d.is_active = ''Y'' AND r.period_year = :year ORDER BY r.kpi_code, d.created_at"},');

    app('{"key":"approvals","title":"Approval Trail","layout":"table","sql":"');
    app('SELECT r.kpi_code, r.period_label AS period, ch.step_seq, ch.step_name, ch.approver, ');
    app('ch.status, ch.actioned_by, TO_CHAR(prod.dct_to_local(ch.actioned_at), ''YYYY-MM-DD HH'' || CHR(58) || ''MI AM'') AS actioned_at ');
    app('FROM prod.dct_wf_chain_v ch JOIN prod.dct_kpi_result_v r ON r.result_id = ch.source_record_id ');
    app('WHERE ch.source_module = ''KPI_MGMT'' AND r.period_year = :year ');
    app('ORDER BY r.kpi_code, r.period_type, r.period_no, ch.step_seq"},');

    app('{"key":"methodology","title":"Methodology Annex - Score Bands","layout":"table","sql":"');
    app('SELECT d.kpi_code, d.name_en AS kpi, b.band_score AS score, b.label_en AS band, ');
    app('d.calc_desc_en AS calculation ');
    app('FROM prod.dct_kpi_definitions d JOIN prod.dct_kpi_score_bands b ON b.kpi_id = d.kpi_id ');
    app('WHERE d.is_active = ''Y'' ORDER BY d.display_order, b.band_score DESC"}');

    app(']}');

    l_ps := '{"year":{"label":"Measurement Year","label_ar":' ||
            '"' || UNISTR('\0633\0646\0629 \0627\0644\0642\064a\0627\0633') || '",' ||
            '"hint":"Required. The year the KPI briefing book covers (e.g. 2026).",' ||
            '"hint_ar":"' || UNISTR('\0625\0644\0632\0627\0645\064a - \0627\0644\0633\0646\0629 \0627\0644\062a\064a \064a\063a\0637\064a\0647\0627 \0627\0644\0643\062a\0627\0628') || '",' ||
            '"required":true,' ||
            '"lov_sql":"SELECT DISTINCT TO_CHAR(period_year) FROM prod.dct_kpi_periods ORDER BY 1 DESC"}}';

    UPDATE prod.dct_rpt_definition
       SET name_en = 'KPI Briefing Book',
           name_ar = UNISTR('\0627\0644\0643\062a\0627\0628 \0627\0644\062a\0646\0641\064a\0630\064a \0644\0645\0624\0634\0631\0627\062a \0627\0644\0623\062f\0627\0621'),
           description = 'Executive briefing book for the DOF unified financial KPIs: scorecard, measurement register with figure provenance, criteria breakdown, evidence register, approval trail and methodology annex.',
           category = 'KPI',
           source_type = 'MULTI',
           source_ref = l_src,
           engine = 'PYTHON',
           default_formats = 'PDF',
           pdf_template = 'kpi_briefing_book.html.j2',
           params_json = '{"year":null}',
           param_spec_json = l_ps,
           enabled = 'Y',
           updated_by = 'SEED', updated_at = SYSTIMESTAMP
     WHERE report_code = 'KPI_BRIEFING_BOOK';
    l_n := SQL%ROWCOUNT;
    IF l_n = 0 THEN
        INSERT INTO prod.dct_rpt_definition
               (report_code, name_en, name_ar, description, category,
                source_type, source_ref, engine, default_formats, pdf_template,
                params_json, param_spec_json, enabled, created_by)
        VALUES ('KPI_BRIEFING_BOOK', 'KPI Briefing Book',
                UNISTR('\0627\0644\0643\062a\0627\0628 \0627\0644\062a\0646\0641\064a\0630\064a \0644\0645\0624\0634\0631\0627\062a \0627\0644\0623\062f\0627\0621'),
                'Executive briefing book for the DOF unified financial KPIs: scorecard, measurement register with figure provenance, criteria breakdown, evidence register, approval trail and methodology annex.',
                'KPI', 'MULTI', l_src, 'PYTHON', 'PDF', 'kpi_briefing_book.html.j2',
                '{"year":null}', l_ps, 'Y', 'SEED');
    END IF;

    DBMS_LOB.FREETEMPORARY(l_src);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('KPI_BRIEFING_BOOK definition seeded (' ||
                         CASE WHEN l_n = 0 THEN 'inserted' ELSE 'updated' END || ')');
END;
/

PROMPT === 29_rpt_kpi_book.sql complete ===
