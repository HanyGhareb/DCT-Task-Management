-- =============================================================================
-- Finance KPI Management Module (App 213) -- Core Package
-- File    : 04_kpi_pkg.sql
-- Schema  : PROD
-- Run     : sql -name prod_mcp @04_kpi_pkg.sql   (after 01 + 02 + 03)
-- Notes   : ZERO dynamic SQL. The auto-figure logic per source_code is static
--           SQL in suggest_value (a suggestion engine -- any gap or error
--           returns NULL and the figure is entered manually).
--           Workflow hooks use the DWP 4-argument registry signature.
--           Error codes: -20401 auth, -20403 forbidden, -20404 not found,
--           -20001 validation, -20090 lookup (raised by DCT_LOOKUP_PKG).
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

CREATE OR REPLACE PACKAGE prod.dct_kpi_pkg AS

    c_module CONSTANT VARCHAR2(10) := 'KPI_MGMT';
    c_srctyp CONSTANT VARCHAR2(30) := 'KPI_RESULT';

    FUNCTION  is_admin (p_user_id NUMBER) RETURN BOOLEAN;
    FUNCTION  uname (p_user_id NUMBER) RETURN VARCHAR2;

    -- measurement calendar
    PROCEDURE ensure_periods (p_year NUMBER);

    -- scoring engine (published for unit tests)
    FUNCTION  score_of (p_kpi_id NUMBER, p_value NUMBER) RETURN NUMBER;

    -- named-source suggestion engine (static SQL only; NULL = enter manually)
    FUNCTION  suggest_value (p_source_code VARCHAR2, p_period_id NUMBER) RETURN NUMBER;

    -- result lifecycle
    FUNCTION  init_result  (p_kpi_id NUMBER, p_period_id NUMBER, p_user_id NUMBER) RETURN NUMBER;
    PROCEDURE compute_result (p_result_id NUMBER);
    PROCEDURE save_result  (p_result_id NUMBER, p_user_id NUMBER,
                            p_figure_a NUMBER, p_figure_b NUMBER, p_notes VARCHAR2);
    PROCEDURE save_result_criterion (p_result_id NUMBER, p_criterion_id NUMBER, p_user_id NUMBER,
                                     p_level_no NUMBER, p_achieved_pct NUMBER, p_justification VARCHAR2);
    PROCEDURE refresh_suggestions (p_result_id NUMBER, p_user_id NUMBER);
    PROCEDURE submit_result (p_result_id NUMBER, p_user_id NUMBER);

    -- evidence documents (shared DCT_DOCUMENTS, doc type KPI_EVIDENCE)
    FUNCTION  add_evidence (p_result_id NUMBER, p_user_id NUMBER,
                            p_file_name VARCHAR2, p_mime VARCHAR2, p_blob BLOB) RETURN NUMBER;
    PROCEDURE delete_evidence (p_doc_id NUMBER, p_user_id NUMBER);

    -- workflow platform hooks (registry signature: instance, module, record, user)
    PROCEDURE wf_on_complete (p_instance_id NUMBER, p_source_module VARCHAR2,
                              p_source_record_id NUMBER, p_user_id NUMBER);
    PROCEDURE wf_on_reject   (p_instance_id NUMBER, p_source_module VARCHAR2,
                              p_source_record_id NUMBER, p_user_id NUMBER);

    -- admin configuration (KPI_ADMIN gated)
    PROCEDURE save_kpi (p_user_id NUMBER, p_kpi_id IN OUT NUMBER,
                        p_kpi_code VARCHAR2, p_name_en VARCHAR2, p_name_ar VARCHAR2,
                        p_description_en VARCHAR2, p_description_ar VARCHAR2,
                        p_kpi_type VARCHAR2, p_polarity VARCHAR2,
                        p_unit_en VARCHAR2, p_unit_ar VARCHAR2,
                        p_frequency VARCHAR2, p_calc_method VARCHAR2,
                        p_calc_desc_en VARCHAR2, p_calc_desc_ar VARCHAR2,
                        p_source_of_data_en VARCHAR2, p_source_of_data_ar VARCHAR2,
                        p_kpi_owner_en VARCHAR2, p_kpi_owner_ar VARCHAR2,
                        p_note_en VARCHAR2, p_note_ar VARCHAR2,
                        p_source_code_a VARCHAR2, p_source_code_b VARCHAR2,
                        p_figure_a_label_en VARCHAR2, p_figure_a_label_ar VARCHAR2,
                        p_figure_b_label_en VARCHAR2, p_figure_b_label_ar VARCHAR2,
                        p_scorecard_weight_pct NUMBER, p_requires_evidence VARCHAR2,
                        p_display_order NUMBER, p_is_active VARCHAR2);
    PROCEDURE set_band (p_user_id NUMBER, p_kpi_id NUMBER, p_band_score NUMBER,
                        p_operator VARCHAR2, p_threshold_1 NUMBER, p_threshold_2 NUMBER,
                        p_label_en VARCHAR2, p_label_ar VARCHAR2);
    PROCEDURE save_criterion (p_user_id NUMBER, p_kpi_id NUMBER, p_criterion_id IN OUT NUMBER,
                              p_criterion_code VARCHAR2, p_name_en VARCHAR2, p_name_ar VARCHAR2,
                              p_description_en VARCHAR2, p_description_ar VARCHAR2,
                              p_weight_pct NUMBER, p_entry_type VARCHAR2,
                              p_fnote_en VARCHAR2, p_fnote_ar VARCHAR2,
                              p_display_order NUMBER, p_is_active VARCHAR2);
    PROCEDURE save_level (p_user_id NUMBER, p_criterion_id NUMBER, p_level_no NUMBER,
                          p_title_en VARCHAR2, p_title_ar VARCHAR2,
                          p_description_en VARCHAR2, p_description_ar VARCHAR2);
    PROCEDURE set_target (p_user_id NUMBER, p_kpi_id NUMBER, p_target_year NUMBER,
                          p_target_value NUMBER, p_label_en VARCHAR2, p_label_ar VARCHAR2);
    PROCEDURE delete_target (p_user_id NUMBER, p_kpi_id NUMBER, p_target_year NUMBER);
    PROCEDURE validate_criteria (p_kpi_id NUMBER);

    -- scheduler entry point
    PROCEDURE remind_missing (p_year NUMBER DEFAULT NULL);

END dct_kpi_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_kpi_pkg AS

    -- ---------------------------------------------------------------- helpers
    FUNCTION uname (p_user_id NUMBER) RETURN VARCHAR2 IS
        v VARCHAR2(100);
    BEGIN
        SELECT username INTO v FROM prod.dct_users WHERE user_id = p_user_id;
        RETURN v;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END;

    FUNCTION is_admin (p_user_id NUMBER) RETURN BOOLEAN IS
        v_un VARCHAR2(100) := uname(p_user_id);
    BEGIN
        IF v_un IS NULL THEN RETURN FALSE; END IF;
        RETURN prod.dct_auth.has_role(v_un, 'KPI_ADMIN')
            OR prod.dct_auth.has_role(v_un, 'SYS_ADMIN');
    END;

    PROCEDURE require_admin (p_user_id NUMBER) IS
    BEGIN
        IF NOT is_admin(p_user_id) THEN
            RAISE_APPLICATION_ERROR(-20403, 'KPI administrator role required');
        END IF;
    END;

    PROCEDURE add_history (p_result_id NUMBER, p_old VARCHAR2, p_new VARCHAR2,
                           p_user_id NUMBER, p_comments VARCHAR2 DEFAULT NULL) IS
    BEGIN
        INSERT INTO prod.dct_request_status_history
               (source_module, source_type, source_id, old_status, new_status,
                changed_by, changed_at, comments)
        VALUES (c_module, c_srctyp, p_result_id, p_old, p_new,
                p_user_id, SYSTIMESTAMP, p_comments);
    END;

    FUNCTION get_result (p_result_id NUMBER) RETURN prod.dct_kpi_results%ROWTYPE IS
        v prod.dct_kpi_results%ROWTYPE;
    BEGIN
        SELECT * INTO v FROM prod.dct_kpi_results WHERE result_id = p_result_id;
        RETURN v;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20404, 'KPI result not found: ' || p_result_id);
    END;

    PROCEDURE require_editable (p_res prod.dct_kpi_results%ROWTYPE, p_user_id NUMBER) IS
    BEGIN
        IF p_res.status NOT IN ('DRAFT', 'RETURNED') THEN
            RAISE_APPLICATION_ERROR(-20001, 'Result is ' || p_res.status || ' and can no longer be edited');
        END IF;
        IF p_res.prepared_by != p_user_id AND NOT is_admin(p_user_id) THEN
            RAISE_APPLICATION_ERROR(-20403, 'Only the preparer or a KPI administrator may edit this result');
        END IF;
    END;

    -- ------------------------------------------------------------- calendar
    PROCEDURE ensure_periods (p_year NUMBER) IS
        PROCEDURE up_period (p_type VARCHAR2, p_no NUMBER, p_from DATE, p_to DATE) IS
            v_n NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_n FROM prod.dct_kpi_periods
             WHERE period_year = p_year AND period_type = p_type
               AND NVL(period_no, 0) = NVL(p_no, 0);
            IF v_n = 0 THEN
                INSERT INTO prod.dct_kpi_periods (period_year, period_type, period_no, start_date, end_date)
                VALUES (p_year, p_type, p_no, p_from, p_to);
            END IF;
        END;
    BEGIN
        IF p_year IS NULL OR p_year < 2000 OR p_year > 2100 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid year');
        END IF;
        up_period('ANNUAL', NULL,
                  TO_DATE(p_year || '-01-01', 'YYYY-MM-DD'),
                  TO_DATE(p_year || '-12-31', 'YYYY-MM-DD'));
        FOR q IN 1 .. 4 LOOP
            up_period('QUARTER', q,
                      ADD_MONTHS(TO_DATE(p_year || '-01-01', 'YYYY-MM-DD'), (q - 1) * 3),
                      ADD_MONTHS(TO_DATE(p_year || '-01-01', 'YYYY-MM-DD'), q * 3) - 1);
        END LOOP;
    END;

    -- -------------------------------------------------------------- scoring
    FUNCTION score_of (p_kpi_id NUMBER, p_value NUMBER) RETURN NUMBER IS
        v_val NUMBER := ROUND(p_value, 1);
        v_hit BOOLEAN;
    BEGIN
        IF p_value IS NULL THEN RETURN NULL; END IF;
        FOR b IN (SELECT operator, threshold_1, threshold_2, band_score
                    FROM prod.dct_kpi_score_bands
                   WHERE kpi_id = p_kpi_id
                   ORDER BY band_score DESC)
        LOOP
            v_hit := CASE b.operator
                       WHEN 'LT'      THEN v_val <  b.threshold_1
                       WHEN 'LE'      THEN v_val <= b.threshold_1
                       WHEN 'EQ'      THEN v_val =  b.threshold_1
                       WHEN 'GE'      THEN v_val >= b.threshold_1
                       WHEN 'GT'      THEN v_val >  b.threshold_1
                       WHEN 'BETWEEN' THEN v_val BETWEEN b.threshold_1 AND b.threshold_2
                       ELSE FALSE
                     END;
            IF v_hit THEN RETURN b.band_score; END IF;
        END LOOP;
        RETURN NULL;
    END;

    -- ---------------------------------------------------- suggestion engine
    FUNCTION suggest_value (p_source_code VARCHAR2, p_period_id NUMBER) RETURN NUMBER IS
        v_src prod.dct_kpi_sources%ROWTYPE;
        v_per prod.dct_kpi_periods%ROWTYPE;
        v_val NUMBER;
        v_yr  NUMBER;
    BEGIN
        IF p_source_code IS NULL THEN RETURN NULL; END IF;
        BEGIN
            SELECT * INTO v_src FROM prod.dct_kpi_sources
             WHERE source_code = p_source_code AND is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
        END;
        BEGIN
            SELECT * INTO v_per FROM prod.dct_kpi_periods WHERE period_id = p_period_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
        END;

        IF p_source_code IN ('GL_REVENUE_ACTUAL_YEAR', 'GL_REVENUE_ACTUAL_PRIOR_YEAR') THEN
            v_yr := v_per.period_year -
                    CASE p_source_code WHEN 'GL_REVENUE_ACTUAL_PRIOR_YEAR' THEN 1 ELSE 0 END;
            SELECT ABS(NVL(SUM(b.expenditures), 0)) INTO v_val
              FROM prod.gl_balances_cc b
              JOIN prod.dct_gl_coa_snap c ON c.cc_string = b.cc_string
             WHERE c.account_type = 'Revenue'
               AND SUBSTR(b.period_name, -4) = TO_CHAR(v_yr)
               AND (v_src.account_from IS NULL OR c.account_code >= v_src.account_from)
               AND (v_src.account_to   IS NULL OR c.account_code <= v_src.account_to);
            RETURN CASE WHEN v_val = 0 THEN NULL ELSE ROUND(v_val, 2) END;

        ELSIF p_source_code = 'FUSION_ACTUAL_QTR' THEN
            IF v_per.period_type != 'QUARTER' THEN RETURN NULL; END IF;
            SELECT NVL(SUM(a.amount_aed), 0) INTO v_val
              FROM prod.dct_actual_v a
             WHERE a.txn_source IN ('AP', 'GRN')
               AND a.txn_date BETWEEN v_per.start_date AND v_per.end_date;
            RETURN CASE WHEN v_val = 0 THEN NULL ELSE ROUND(v_val, 2) END;
        END IF;

        RETURN NULL;
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;   -- a suggestion engine never blocks manual entry
    END;

    -- ------------------------------------------------------- result lifecycle
    PROCEDURE compute_result (p_result_id NUMBER) IS
        v_res  prod.dct_kpi_results%ROWTYPE := get_result(p_result_id);
        v_def  prod.dct_kpi_definitions%ROWTYPE;
        v_pct  NUMBER;
        v_sc   NUMBER;
        v_missing NUMBER := 0;
    BEGIN
        SELECT * INTO v_def FROM prod.dct_kpi_definitions WHERE kpi_id = v_res.kpi_id;

        IF v_def.calc_method = 'RATIO_A_OVER_B' THEN
            IF v_res.figure_a IS NOT NULL AND NVL(v_res.figure_b, 0) != 0 THEN
                v_pct := ROUND(v_res.figure_a / v_res.figure_b * 100, 1);
            END IF;

        ELSIF v_def.calc_method = 'ABS_VARIANCE' THEN
            IF v_res.figure_a IS NOT NULL AND NVL(v_res.figure_b, 0) != 0 THEN
                v_pct := ROUND(ABS(1 - v_res.figure_a / v_res.figure_b) * 100, 1);
            END IF;

        ELSIF v_def.calc_method = 'WEIGHTED_CRITERIA' THEN
            v_pct := 0;
            FOR c IN (SELECT c.criterion_id, c.weight_pct, c.entry_type,
                             rc.result_crit_id, rc.level_no, rc.achieved_pct
                        FROM prod.dct_kpi_criteria c
                        LEFT JOIN prod.dct_kpi_result_criteria rc
                               ON rc.criterion_id = c.criterion_id AND rc.result_id = p_result_id
                       WHERE c.kpi_id = v_res.kpi_id AND c.is_active = 'Y')
            LOOP
                IF (c.entry_type = 'MATURITY_1_5' AND c.level_no IS NOT NULL) THEN
                    v_pct := v_pct + c.weight_pct * c.level_no / 5;
                    UPDATE prod.dct_kpi_result_criteria
                       SET crit_score = ROUND(c.weight_pct * c.level_no / 5, 2)
                     WHERE result_crit_id = c.result_crit_id;
                ELSIF (c.entry_type = 'PERCENT_0_100' AND c.achieved_pct IS NOT NULL) THEN
                    v_pct := v_pct + c.weight_pct * c.achieved_pct / 100;
                    UPDATE prod.dct_kpi_result_criteria
                       SET crit_score = ROUND(c.weight_pct * c.achieved_pct / 100, 2)
                     WHERE result_crit_id = c.result_crit_id;
                ELSE
                    v_missing := v_missing + 1;
                END IF;
            END LOOP;
            v_pct := ROUND(v_pct, 1);
            IF v_missing > 0 AND v_pct = 0 THEN
                v_pct := NULL;   -- nothing entered yet
            END IF;
        END IF;

        -- score only when the figure set is complete
        IF v_pct IS NOT NULL AND v_missing = 0 THEN
            v_sc := score_of(v_res.kpi_id, v_pct);
        END IF;

        UPDATE prod.dct_kpi_results
           SET result_pct = v_pct, score = v_sc, updated_at = SYSDATE
         WHERE result_id = p_result_id;
    END;

    FUNCTION init_result (p_kpi_id NUMBER, p_period_id NUMBER, p_user_id NUMBER) RETURN NUMBER IS
        v_def prod.dct_kpi_definitions%ROWTYPE;
        v_per prod.dct_kpi_periods%ROWTYPE;
        v_id  NUMBER;
        v_sug_a NUMBER;
        v_sug_b NUMBER;
        v_tgt NUMBER;
    BEGIN
        BEGIN
            SELECT * INTO v_def FROM prod.dct_kpi_definitions
             WHERE kpi_id = p_kpi_id AND is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'KPI not found or inactive');
        END;
        BEGIN
            SELECT * INTO v_per FROM prod.dct_kpi_periods WHERE period_id = p_period_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'Period not found');
        END;
        IF v_per.status != 'OPEN' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Measurement period is closed');
        END IF;
        IF (v_def.frequency = 'ANNUAL'    AND v_per.period_type != 'ANNUAL')
        OR (v_def.frequency = 'QUARTERLY' AND v_per.period_type != 'QUARTER') THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Period type ' || v_per.period_type || ' does not match KPI frequency ' || v_def.frequency);
        END IF;

        BEGIN
            SELECT result_id INTO v_id FROM prod.dct_kpi_results
             WHERE kpi_id = p_kpi_id AND period_id = p_period_id;
            RETURN v_id;   -- idempotent open of the existing measurement
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;

        v_sug_a := suggest_value(v_def.source_code_a, p_period_id);
        v_sug_b := suggest_value(v_def.source_code_b, p_period_id);
        BEGIN
            SELECT target_value INTO v_tgt FROM prod.dct_kpi_targets
             WHERE kpi_id = p_kpi_id AND target_year = v_per.period_year;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_tgt := NULL;
        END;

        INSERT INTO prod.dct_kpi_results
               (kpi_id, period_id, figure_a, figure_b, suggested_a, suggested_b,
                figure_a_source, figure_b_source, target_value, status,
                prepared_by, created_by)
        VALUES (p_kpi_id, p_period_id, v_sug_a, v_sug_b, v_sug_a, v_sug_b,
                CASE WHEN v_sug_a IS NULL THEN 'MANUAL' ELSE 'AUTO' END,
                CASE WHEN v_sug_b IS NULL THEN 'MANUAL' ELSE 'AUTO' END,
                v_tgt, 'DRAFT', p_user_id, uname(p_user_id))
        RETURNING result_id INTO v_id;

        INSERT INTO prod.dct_kpi_result_criteria (result_id, criterion_id, updated_by)
        SELECT v_id, c.criterion_id, uname(p_user_id)
          FROM prod.dct_kpi_criteria c
         WHERE c.kpi_id = p_kpi_id AND c.is_active = 'Y';

        add_history(v_id, NULL, 'DRAFT', p_user_id, 'Measurement initialised');
        RETURN v_id;
    END;

    PROCEDURE save_result (p_result_id NUMBER, p_user_id NUMBER,
                           p_figure_a NUMBER, p_figure_b NUMBER, p_notes VARCHAR2) IS
        v_res prod.dct_kpi_results%ROWTYPE := get_result(p_result_id);
    BEGIN
        require_editable(v_res, p_user_id);
        UPDATE prod.dct_kpi_results
           SET figure_a = p_figure_a,
               figure_b = p_figure_b,
               figure_a_source = CASE
                   WHEN suggested_a IS NOT NULL AND p_figure_a = suggested_a THEN 'AUTO'
                   ELSE 'MANUAL' END,
               figure_b_source = CASE
                   WHEN suggested_b IS NOT NULL AND p_figure_b = suggested_b THEN 'AUTO'
                   ELSE 'MANUAL' END,
               notes = p_notes,
               updated_by = uname(p_user_id), updated_at = SYSDATE
         WHERE result_id = p_result_id;
        compute_result(p_result_id);
    END;

    PROCEDURE save_result_criterion (p_result_id NUMBER, p_criterion_id NUMBER, p_user_id NUMBER,
                                     p_level_no NUMBER, p_achieved_pct NUMBER, p_justification VARCHAR2) IS
        v_res prod.dct_kpi_results%ROWTYPE := get_result(p_result_id);
        v_entry VARCHAR2(30);
    BEGIN
        require_editable(v_res, p_user_id);
        BEGIN
            SELECT entry_type INTO v_entry FROM prod.dct_kpi_criteria
             WHERE criterion_id = p_criterion_id AND kpi_id = v_res.kpi_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'Criterion does not belong to this KPI');
        END;
        IF v_entry = 'MATURITY_1_5' AND p_level_no IS NOT NULL
           AND p_level_no NOT BETWEEN 1 AND 5 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Maturity level must be between 1 and 5');
        END IF;
        IF v_entry = 'PERCENT_0_100' AND p_achieved_pct IS NOT NULL
           AND p_achieved_pct NOT BETWEEN 0 AND 100 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Achievement must be between 0 and 100');
        END IF;

        UPDATE prod.dct_kpi_result_criteria
           SET level_no      = CASE WHEN v_entry = 'MATURITY_1_5'  THEN p_level_no ELSE NULL END,
               achieved_pct  = CASE WHEN v_entry = 'PERCENT_0_100' THEN p_achieved_pct ELSE NULL END,
               justification = p_justification,
               updated_by = uname(p_user_id), updated_at = SYSDATE
         WHERE result_id = p_result_id AND criterion_id = p_criterion_id;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_kpi_result_criteria
                   (result_id, criterion_id, level_no, achieved_pct, justification, updated_by)
            VALUES (p_result_id, p_criterion_id,
                    CASE WHEN v_entry = 'MATURITY_1_5'  THEN p_level_no ELSE NULL END,
                    CASE WHEN v_entry = 'PERCENT_0_100' THEN p_achieved_pct ELSE NULL END,
                    p_justification, uname(p_user_id));
        END IF;
        compute_result(p_result_id);
    END;

    PROCEDURE refresh_suggestions (p_result_id NUMBER, p_user_id NUMBER) IS
        v_res prod.dct_kpi_results%ROWTYPE := get_result(p_result_id);
        v_def prod.dct_kpi_definitions%ROWTYPE;
        v_sug_a NUMBER;
        v_sug_b NUMBER;
    BEGIN
        require_editable(v_res, p_user_id);
        SELECT * INTO v_def FROM prod.dct_kpi_definitions WHERE kpi_id = v_res.kpi_id;
        v_sug_a := suggest_value(v_def.source_code_a, v_res.period_id);
        v_sug_b := suggest_value(v_def.source_code_b, v_res.period_id);
        UPDATE prod.dct_kpi_results
           SET suggested_a = v_sug_a, suggested_b = v_sug_b,
               updated_by = uname(p_user_id), updated_at = SYSDATE
         WHERE result_id = p_result_id;
    END;

    PROCEDURE validate_criteria (p_kpi_id NUMBER) IS
        v_sum NUMBER;
        v_cnt NUMBER;
    BEGIN
        SELECT NVL(SUM(weight_pct), 0), COUNT(*) INTO v_sum, v_cnt
          FROM prod.dct_kpi_criteria
         WHERE kpi_id = p_kpi_id AND is_active = 'Y';
        IF v_cnt > 0 AND v_sum != 100 THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Active criteria weights must sum to 100 (currently ' || v_sum || ')');
        END IF;
    END;

    PROCEDURE submit_result (p_result_id NUMBER, p_user_id NUMBER) IS
        v_res prod.dct_kpi_results%ROWTYPE := get_result(p_result_id);
        v_def prod.dct_kpi_definitions%ROWTYPE;
        v_per prod.dct_kpi_periods%ROWTYPE;
        v_n   NUMBER;
        v_old VARCHAR2(30);
        v_inst NUMBER;
        v_ref  VARCHAR2(120);
    BEGIN
        require_editable(v_res, p_user_id);
        v_old := v_res.status;
        SELECT * INTO v_def FROM prod.dct_kpi_definitions WHERE kpi_id = v_res.kpi_id;
        SELECT * INTO v_per FROM prod.dct_kpi_periods WHERE period_id = v_res.period_id;

        IF v_def.calc_method IN ('RATIO_A_OVER_B', 'ABS_VARIANCE') THEN
            IF v_res.figure_a IS NULL OR v_res.figure_b IS NULL THEN
                RAISE_APPLICATION_ERROR(-20001, 'Both figures are required before submission');
            END IF;
            IF v_res.figure_b = 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'The denominator figure cannot be zero');
            END IF;
            -- a manual override of a system suggestion needs a stated reason
            IF ((v_res.figure_a_source = 'MANUAL' AND v_res.suggested_a IS NOT NULL
                 AND v_res.figure_a != v_res.suggested_a)
             OR (v_res.figure_b_source = 'MANUAL' AND v_res.suggested_b IS NOT NULL
                 AND v_res.figure_b != v_res.suggested_b))
               AND TRIM(v_res.notes) IS NULL THEN
                RAISE_APPLICATION_ERROR(-20001,
                    'Notes must explain why the entered figure differs from the system suggestion');
            END IF;
        ELSE
            validate_criteria(v_res.kpi_id);
            SELECT COUNT(*) INTO v_n
              FROM prod.dct_kpi_criteria c
              LEFT JOIN prod.dct_kpi_result_criteria rc
                     ON rc.criterion_id = c.criterion_id AND rc.result_id = p_result_id
             WHERE c.kpi_id = v_res.kpi_id AND c.is_active = 'Y'
               AND ((c.entry_type = 'MATURITY_1_5'  AND rc.level_no IS NULL)
                 OR (c.entry_type = 'PERCENT_0_100' AND rc.achieved_pct IS NULL));
            IF v_n > 0 THEN
                RAISE_APPLICATION_ERROR(-20001, v_n || ' criteria still need an assessment before submission');
            END IF;
        END IF;

        IF v_def.requires_evidence = 'Y' THEN
            SELECT COUNT(*) INTO v_n FROM prod.dct_documents
             WHERE source_module = c_module AND source_type = c_srctyp
               AND source_id = p_result_id AND is_active = 'Y';
            IF v_n = 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'At least one evidence document is required before submission');
            END IF;
        END IF;

        compute_result(p_result_id);
        v_res := get_result(p_result_id);
        IF v_res.score IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'The result could not be scored; check the entered figures');
        END IF;

        v_ref := v_def.kpi_code || ' ' ||
                 CASE v_per.period_type WHEN 'ANNUAL' THEN TO_CHAR(v_per.period_year)
                      ELSE v_per.period_year || '-Q' || v_per.period_no END;

        UPDATE prod.dct_kpi_results
           SET status = 'SUBMITTED',
               submitted_by = p_user_id, submitted_at = SYSTIMESTAMP,
               updated_by = uname(p_user_id), updated_at = SYSDATE
         WHERE result_id = p_result_id;
        add_history(p_result_id, v_old, 'SUBMITTED', p_user_id, 'Submitted for approval: ' || v_ref);

        v_inst := prod.dct_wf_engine.start_process(
                      p_process_code      => 'KPI_RESULT_APPROVAL',
                      p_source_record_id  => p_result_id,
                      p_initiator_user_id => p_user_id,
                      p_source_record_ref => v_ref);
        UPDATE prod.dct_kpi_results
           SET wf_instance_id = v_inst
         WHERE result_id = p_result_id;
    END;

    -- ------------------------------------------------------------- evidence
    FUNCTION add_evidence (p_result_id NUMBER, p_user_id NUMBER,
                           p_file_name VARCHAR2, p_mime VARCHAR2, p_blob BLOB) RETURN NUMBER IS
        v_res  prod.dct_kpi_results%ROWTYPE := get_result(p_result_id);
        v_type NUMBER;
        v_id   NUMBER;
    BEGIN
        require_editable(v_res, p_user_id);
        IF p_file_name IS NULL OR p_blob IS NULL OR DBMS_LOB.GETLENGTH(p_blob) = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'File name and file bytes are required');
        END IF;
        SELECT doc_type_id INTO v_type FROM prod.dct_document_types
         WHERE doc_type_code = 'KPI_EVIDENCE';
        INSERT INTO prod.dct_documents
               (source_module, source_type, source_id, doc_type_id,
                file_name, mime_type, file_size_bytes, file_blob, created_by, created_at)
        VALUES (c_module, c_srctyp, p_result_id, v_type,
                p_file_name, p_mime, DBMS_LOB.GETLENGTH(p_blob), p_blob, p_user_id, SYSTIMESTAMP)
        RETURNING doc_id INTO v_id;
        RETURN v_id;
    END;

    PROCEDURE delete_evidence (p_doc_id NUMBER, p_user_id NUMBER) IS
        v_rid NUMBER;
        v_res prod.dct_kpi_results%ROWTYPE;
    BEGIN
        BEGIN
            SELECT source_id INTO v_rid FROM prod.dct_documents
             WHERE doc_id = p_doc_id AND source_module = c_module
               AND source_type = c_srctyp AND is_active = 'Y';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20404, 'Evidence document not found');
        END;
        v_res := get_result(v_rid);
        require_editable(v_res, p_user_id);
        UPDATE prod.dct_documents
           SET is_active = 'N', updated_by = p_user_id, updated_at = SYSTIMESTAMP
         WHERE doc_id = p_doc_id;
    END;

    -- --------------------------------------------------------- workflow hooks
    PROCEDURE wf_on_complete (p_instance_id NUMBER, p_source_module VARCHAR2,
                              p_source_record_id NUMBER, p_user_id NUMBER) IS
        v_res prod.dct_kpi_results%ROWTYPE;
    BEGIN
        v_res := get_result(p_source_record_id);
        IF v_res.status != 'SUBMITTED' THEN RETURN; END IF;
        UPDATE prod.dct_kpi_results
           SET status = 'APPROVED', approved_at = SYSTIMESTAMP, updated_at = SYSDATE
         WHERE result_id = p_source_record_id;
        add_history(p_source_record_id, 'SUBMITTED', 'APPROVED', p_user_id, 'Approval chain completed');
        IF v_res.prepared_by IS NOT NULL THEN
            prod.dct_notify.send(
                p_recipient_user_id => v_res.prepared_by,
                p_notification_type => 'KPI_APPROVED',
                p_title_en          => 'KPI result approved',
                p_body_en           => 'Your KPI measurement #' || p_source_record_id || ' has been approved.',
                p_title_ar          => 'تم اعتماد نتيجة المؤشر',
                p_module_code       => c_module,
                p_link_url          => '#results');
        END IF;
    END;

    PROCEDURE wf_on_reject (p_instance_id NUMBER, p_source_module VARCHAR2,
                            p_source_record_id NUMBER, p_user_id NUMBER) IS
        v_res prod.dct_kpi_results%ROWTYPE;
    BEGIN
        v_res := get_result(p_source_record_id);
        IF v_res.status != 'SUBMITTED' THEN RETURN; END IF;
        UPDATE prod.dct_kpi_results
           SET status = 'RETURNED', updated_at = SYSDATE
         WHERE result_id = p_source_record_id;
        add_history(p_source_record_id, 'SUBMITTED', 'RETURNED', p_user_id, 'Returned by the approval chain');
        IF v_res.prepared_by IS NOT NULL THEN
            prod.dct_notify.send(
                p_recipient_user_id => v_res.prepared_by,
                p_notification_type => 'KPI_RETURNED',
                p_title_en          => 'KPI result returned',
                p_body_en           => 'Your KPI measurement #' || p_source_record_id || ' was returned for rework.',
                p_title_ar          => 'أعيدت نتيجة المؤشر للتعديل',
                p_module_code       => c_module,
                p_link_url          => '#results');
        END IF;
    END;

    -- ------------------------------------------------------------ admin CRUD
    PROCEDURE save_kpi (p_user_id NUMBER, p_kpi_id IN OUT NUMBER,
                        p_kpi_code VARCHAR2, p_name_en VARCHAR2, p_name_ar VARCHAR2,
                        p_description_en VARCHAR2, p_description_ar VARCHAR2,
                        p_kpi_type VARCHAR2, p_polarity VARCHAR2,
                        p_unit_en VARCHAR2, p_unit_ar VARCHAR2,
                        p_frequency VARCHAR2, p_calc_method VARCHAR2,
                        p_calc_desc_en VARCHAR2, p_calc_desc_ar VARCHAR2,
                        p_source_of_data_en VARCHAR2, p_source_of_data_ar VARCHAR2,
                        p_kpi_owner_en VARCHAR2, p_kpi_owner_ar VARCHAR2,
                        p_note_en VARCHAR2, p_note_ar VARCHAR2,
                        p_source_code_a VARCHAR2, p_source_code_b VARCHAR2,
                        p_figure_a_label_en VARCHAR2, p_figure_a_label_ar VARCHAR2,
                        p_figure_b_label_en VARCHAR2, p_figure_b_label_ar VARCHAR2,
                        p_scorecard_weight_pct NUMBER, p_requires_evidence VARCHAR2,
                        p_display_order NUMBER, p_is_active VARCHAR2) IS
        v_un VARCHAR2(100) := uname(p_user_id);
    BEGIN
        require_admin(p_user_id);
        prod.dct_lookup_pkg.validate_lookup('KPI_TYPE',        p_kpi_type);
        prod.dct_lookup_pkg.validate_lookup('KPI_POLARITY',    p_polarity);
        prod.dct_lookup_pkg.validate_lookup('KPI_FREQUENCY',   p_frequency);
        prod.dct_lookup_pkg.validate_lookup('KPI_CALC_METHOD', p_calc_method);
        IF p_requires_evidence NOT IN ('Y', 'N') THEN
            RAISE_APPLICATION_ERROR(-20001, 'requires_evidence must be Y or N');
        END IF;

        IF p_kpi_id IS NULL THEN
            BEGIN
                INSERT INTO prod.dct_kpi_definitions
                       (kpi_code, name_en, name_ar, description_en, description_ar,
                        kpi_type, polarity, unit_en, unit_ar, frequency, calc_method,
                        calc_desc_en, calc_desc_ar, source_of_data_en, source_of_data_ar,
                        kpi_owner_en, kpi_owner_ar, note_en, note_ar,
                        source_code_a, source_code_b,
                        figure_a_label_en, figure_a_label_ar, figure_b_label_en, figure_b_label_ar,
                        scorecard_weight_pct, requires_evidence, display_order, is_active, created_by)
                VALUES (UPPER(p_kpi_code), p_name_en, p_name_ar, p_description_en, p_description_ar,
                        p_kpi_type, p_polarity, p_unit_en, p_unit_ar, p_frequency, p_calc_method,
                        p_calc_desc_en, p_calc_desc_ar, p_source_of_data_en, p_source_of_data_ar,
                        p_kpi_owner_en, p_kpi_owner_ar, p_note_en, p_note_ar,
                        p_source_code_a, p_source_code_b,
                        p_figure_a_label_en, p_figure_a_label_ar, p_figure_b_label_en, p_figure_b_label_ar,
                        NVL(p_scorecard_weight_pct, 25), p_requires_evidence,
                        NVL(p_display_order, 100), NVL(p_is_active, 'Y'), v_un)
                RETURNING kpi_id INTO p_kpi_id;
            EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
                RAISE_APPLICATION_ERROR(-20001, 'KPI code already exists: ' || UPPER(p_kpi_code));
            END;
        ELSE
            UPDATE prod.dct_kpi_definitions
               SET name_en = p_name_en, name_ar = p_name_ar,
                   description_en = p_description_en, description_ar = p_description_ar,
                   kpi_type = p_kpi_type, polarity = p_polarity,
                   unit_en = p_unit_en, unit_ar = p_unit_ar,
                   frequency = p_frequency, calc_method = p_calc_method,
                   calc_desc_en = p_calc_desc_en, calc_desc_ar = p_calc_desc_ar,
                   source_of_data_en = p_source_of_data_en, source_of_data_ar = p_source_of_data_ar,
                   kpi_owner_en = p_kpi_owner_en, kpi_owner_ar = p_kpi_owner_ar,
                   note_en = p_note_en, note_ar = p_note_ar,
                   source_code_a = p_source_code_a, source_code_b = p_source_code_b,
                   figure_a_label_en = p_figure_a_label_en, figure_a_label_ar = p_figure_a_label_ar,
                   figure_b_label_en = p_figure_b_label_en, figure_b_label_ar = p_figure_b_label_ar,
                   scorecard_weight_pct = NVL(p_scorecard_weight_pct, scorecard_weight_pct),
                   requires_evidence = p_requires_evidence,
                   display_order = NVL(p_display_order, display_order),
                   is_active = NVL(p_is_active, is_active),
                   updated_by = v_un, updated_at = SYSDATE
             WHERE kpi_id = p_kpi_id;
            IF SQL%ROWCOUNT = 0 THEN
                RAISE_APPLICATION_ERROR(-20404, 'KPI not found: ' || p_kpi_id);
            END IF;
        END IF;
    END;

    PROCEDURE set_band (p_user_id NUMBER, p_kpi_id NUMBER, p_band_score NUMBER,
                        p_operator VARCHAR2, p_threshold_1 NUMBER, p_threshold_2 NUMBER,
                        p_label_en VARCHAR2, p_label_ar VARCHAR2) IS
    BEGIN
        require_admin(p_user_id);
        prod.dct_lookup_pkg.validate_lookup('KPI_BAND_OP', p_operator);
        IF p_band_score NOT BETWEEN 1 AND 5 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Band score must be between 1 and 5');
        END IF;
        IF p_operator = 'BETWEEN' AND p_threshold_2 IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'BETWEEN bands need both thresholds');
        END IF;
        UPDATE prod.dct_kpi_score_bands
           SET operator = p_operator, threshold_1 = p_threshold_1, threshold_2 = p_threshold_2,
               label_en = p_label_en, label_ar = p_label_ar
         WHERE kpi_id = p_kpi_id AND band_score = p_band_score;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_kpi_score_bands
                   (kpi_id, band_score, operator, threshold_1, threshold_2, label_en, label_ar, created_by)
            VALUES (p_kpi_id, p_band_score, p_operator, p_threshold_1, p_threshold_2,
                    p_label_en, p_label_ar, uname(p_user_id));
        END IF;
    END;

    PROCEDURE save_criterion (p_user_id NUMBER, p_kpi_id NUMBER, p_criterion_id IN OUT NUMBER,
                              p_criterion_code VARCHAR2, p_name_en VARCHAR2, p_name_ar VARCHAR2,
                              p_description_en VARCHAR2, p_description_ar VARCHAR2,
                              p_weight_pct NUMBER, p_entry_type VARCHAR2,
                              p_fnote_en VARCHAR2, p_fnote_ar VARCHAR2,
                              p_display_order NUMBER, p_is_active VARCHAR2) IS
        v_un VARCHAR2(100) := uname(p_user_id);
    BEGIN
        require_admin(p_user_id);
        prod.dct_lookup_pkg.validate_lookup('KPI_CRIT_ENTRY', p_entry_type);
        IF p_weight_pct NOT BETWEEN 0 AND 100 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Weight must be between 0 and 100');
        END IF;
        IF p_criterion_id IS NULL THEN
            INSERT INTO prod.dct_kpi_criteria
                   (kpi_id, criterion_code, name_en, name_ar, description_en, description_ar,
                    weight_pct, entry_type, frequency_note_en, frequency_note_ar,
                    display_order, is_active, created_by)
            VALUES (p_kpi_id, UPPER(p_criterion_code), p_name_en, p_name_ar,
                    p_description_en, p_description_ar,
                    p_weight_pct, p_entry_type, p_fnote_en, p_fnote_ar,
                    NVL(p_display_order, 100), NVL(p_is_active, 'Y'), v_un)
            RETURNING criterion_id INTO p_criterion_id;
        ELSE
            UPDATE prod.dct_kpi_criteria
               SET name_en = p_name_en, name_ar = p_name_ar,
                   description_en = p_description_en, description_ar = p_description_ar,
                   weight_pct = p_weight_pct, entry_type = p_entry_type,
                   frequency_note_en = p_fnote_en, frequency_note_ar = p_fnote_ar,
                   display_order = NVL(p_display_order, display_order),
                   is_active = NVL(p_is_active, is_active),
                   updated_by = v_un, updated_at = SYSDATE
             WHERE criterion_id = p_criterion_id AND kpi_id = p_kpi_id;
            IF SQL%ROWCOUNT = 0 THEN
                RAISE_APPLICATION_ERROR(-20404, 'Criterion not found: ' || p_criterion_id);
            END IF;
        END IF;
    END;

    PROCEDURE save_level (p_user_id NUMBER, p_criterion_id NUMBER, p_level_no NUMBER,
                          p_title_en VARCHAR2, p_title_ar VARCHAR2,
                          p_description_en VARCHAR2, p_description_ar VARCHAR2) IS
    BEGIN
        require_admin(p_user_id);
        IF p_level_no NOT BETWEEN 1 AND 5 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Level must be between 1 and 5');
        END IF;
        UPDATE prod.dct_kpi_criteria_levels
           SET title_en = p_title_en, title_ar = p_title_ar,
               description_en = p_description_en, description_ar = p_description_ar
         WHERE criterion_id = p_criterion_id AND level_no = p_level_no;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_kpi_criteria_levels
                   (criterion_id, level_no, title_en, title_ar, description_en, description_ar)
            VALUES (p_criterion_id, p_level_no, p_title_en, p_title_ar,
                    p_description_en, p_description_ar);
        END IF;
    END;

    PROCEDURE set_target (p_user_id NUMBER, p_kpi_id NUMBER, p_target_year NUMBER,
                          p_target_value NUMBER, p_label_en VARCHAR2, p_label_ar VARCHAR2) IS
    BEGIN
        require_admin(p_user_id);
        UPDATE prod.dct_kpi_targets
           SET target_value = p_target_value, label_en = p_label_en, label_ar = p_label_ar
         WHERE kpi_id = p_kpi_id AND target_year = p_target_year;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO prod.dct_kpi_targets
                   (kpi_id, target_year, target_value, label_en, label_ar, created_by)
            VALUES (p_kpi_id, p_target_year, p_target_value, p_label_en, p_label_ar, uname(p_user_id));
        END IF;
    END;

    PROCEDURE delete_target (p_user_id NUMBER, p_kpi_id NUMBER, p_target_year NUMBER) IS
    BEGIN
        require_admin(p_user_id);
        DELETE FROM prod.dct_kpi_targets
         WHERE kpi_id = p_kpi_id AND target_year = p_target_year;
    END;

    -- ------------------------------------------------------------- reminders
    PROCEDURE remind_missing (p_year NUMBER DEFAULT NULL) IS
        v_year NUMBER := NVL(p_year, EXTRACT(YEAR FROM SYSDATE));
        v_msg  VARCHAR2(1000);
        v_cnt  NUMBER := 0;
    BEGIN
        FOR gap IN (
            SELECT d.kpi_code, d.name_en,
                   CASE p.period_type WHEN 'ANNUAL' THEN TO_CHAR(p.period_year)
                        ELSE p.period_year || '-Q' || p.period_no END AS period_label
              FROM prod.dct_kpi_definitions d
              JOIN prod.dct_kpi_periods p
                ON p.period_year = v_year
               AND ((d.frequency = 'ANNUAL'    AND p.period_type = 'ANNUAL')
                 OR (d.frequency = 'QUARTERLY' AND p.period_type = 'QUARTER')
                 OR (d.frequency = 'MIXED'     AND p.period_type = 'ANNUAL'))
             WHERE d.is_active = 'Y'
               AND p.end_date < SYSDATE
               AND p.status = 'OPEN'
               AND NOT EXISTS (SELECT 1 FROM prod.dct_kpi_results r
                                WHERE r.kpi_id = d.kpi_id AND r.period_id = p.period_id
                                  AND r.status IN ('SUBMITTED', 'APPROVED'))
             ORDER BY d.display_order)
        LOOP
            v_cnt := v_cnt + 1;
            v_msg := SUBSTR(NVL(v_msg || ', ', '') || gap.kpi_code || ' ' || gap.period_label, 1, 900);
        END LOOP;

        IF v_cnt > 0 THEN
            FOR adm IN (SELECT DISTINCT ur.user_id
                          FROM prod.dct_user_roles ur
                          JOIN prod.dct_roles r ON r.role_id = ur.role_id
                         WHERE r.role_code = 'KPI_ADMIN'
                           AND ur.start_date <= SYSDATE
                           AND (ur.end_date IS NULL OR ur.end_date >= SYSDATE))
            LOOP
                prod.dct_notify.send(
                    p_recipient_user_id => adm.user_id,
                    p_notification_type => 'KPI_REMINDER',
                    p_title_en          => v_cnt || ' KPI measurement(s) pending submission',
                    p_body_en           => 'Elapsed periods without an approved or submitted result: ' || v_msg,
                    p_module_code       => c_module,
                    p_link_url          => '#results');
            END LOOP;
        END IF;
    END;

END dct_kpi_pkg;
/

PROMPT === 04_kpi_pkg.sql complete: DCT_KPI_PKG created ===
