-- ===========================================================================
-- otbi-atd : 77 Project Budget Transactions (PBT) extract - tables + vocabulary
--
--   Source = the ADG_FIN VBCS app "Project Budget Transactions", which is a
--   thin client over a plain ORDS service. The worker reads it through the
--   VBCS proxy with its EXISTING Fusion SSO session (Route B) - see
--   docs/fusion-actions/pbt-api-spec.md and docs/PBT_EXTRACT_PLAN.md.
--
--   ONE header table for all three budget types (the source header payload is
--   byte-identical across them and carries transaction_type itself), ONE lines
--   table per type (their shapes genuinely differ: 34 / 21 / 38 fields), and
--   ONE approvals table (identical 9 fields, carries trx_type).
--
--   Keys: the source ships a stable surrogate "identifier" on headers AND on
--   lines -> that is the MERGE key, so a re-run can never duplicate. Approval
--   rows carry NO key of their own (not even the transaction) -> the caller
--   stamps transaction_num/trx_type and they are refreshed delete-then-insert.
--
-- Rerunnable (guarded CREATE + count-then-insert seeds; never drops data).
-- Schema-qualified PROD. CRLF / UTF-8 no BOM. No MERGE anywhere on purpose,
-- so Linux SQLcl cannot silently swallow a block.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON
SET SERVEROUTPUT ON

-- ---------------------------------------------------------------------------
-- Section 1 : headers - ALL budget types
-- ---------------------------------------------------------------------------
-- project_id is VARCHAR2 on purpose: it is NULL in every observed row, so its
-- true datatype is unproven and a string never fails to land.
-- row_hash is OUR column (not from the source): a digest of the 20 source
-- fields that lets the hourly shallow sync decide, without any child call,
-- whether a transaction changed. The source header has NO last_updated_date -
-- that absence is exactly why the nightly deep pass exists.
BEGIN
  EXECUTE IMMEDIATE q'[CREATE TABLE prod.pa_budget_trx_headers (
    identifier              NUMBER            NOT NULL,
    transaction_num         VARCHAR2(60)      NOT NULL,
    transaction_type        VARCHAR2(40)      NOT NULL,
    project_type            VARCHAR2(120),
    status                  VARCHAR2(60),
    transaction_date        DATE,
    trx_year                VARCHAR2(8),
    dept_1st_level_approver VARCHAR2(240),
    business_unit           VARCHAR2(240),
    decree_no               VARCHAR2(120),
    organization            VARCHAR2(400),
    project_num             VARCHAR2(60),
    project_name            VARCHAR2(400),
    project_num_1           VARCHAR2(60),
    project_id              VARCHAR2(60),
    project_approved_cost   NUMBER,
    project_estimated_cost  NUMBER,
    project_total_cost      NUMBER,
    changein_duration       VARCHAR2(40),
    creation_date           DATE,
    row_hash                VARCHAR2(64),
    load_run_id             NUMBER,
    last_seen_at            TIMESTAMP,
    load_ts                 TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_pa_bt_headers PRIMARY KEY (identifier)
  )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- ---------------------------------------------------------------------------
-- Section 2 : lines - Additional Fund (34 source fields)
-- ---------------------------------------------------------------------------
-- commitments is stored NUMBER although the source sends it as a STRING
-- ("528250") while every neighbouring money field is a JSON number.
BEGIN
  EXECUTE IMMEDIATE q'[CREATE TABLE prod.pa_additional_fund_lines (
    identifier              NUMBER            NOT NULL,
    transaction_num         VARCHAR2(60)      NOT NULL,
    project_num             VARCHAR2(60),
    project_name            VARCHAR2(400),
    task_num                VARCHAR2(120),
    task_name               VARCHAR2(240),
    total_actual            NUMBER,
    additional_amount       NUMBER,
    total_annual_budget     NUMBER,
    fund_available          NUMBER,
    previous_year_actual    NUMBER,
    current_year_actual     NUMBER,
    approved_annual_budget  NUMBER,
    revised_project_cost    NUMBER,
    current_annual_budget   NUMBER,
    commitments             NUMBER,
    notes                   VARCHAR2(4000),
    cost_center             VARCHAR2(240),
    expenditure_type        VARCHAR2(240),
    line_status             VARCHAR2(60),
    created_by              VARCHAR2(240),
    last_updated_by         VARCHAR2(240),
    creation_date           DATE,
    last_updated_date       DATE,
    gl_funds_available      NUMBER,
    code_combination        VARCHAR2(120),
    baseline_status         VARCHAR2(60),
    baseline_error          VARCHAR2(4000),
    transaction_line_error  VARCHAR2(4000),
    acc_annual_budget       NUMBER,
    period_from             VARCHAR2(20),
    period_to               VARCHAR2(20),
    validation_status       VARCHAR2(60),
    jv_status               VARCHAR2(60),
    load_run_id             NUMBER,
    last_seen_at            TIMESTAMP,
    load_ts                 TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_pa_af_lines PRIMARY KEY (identifier)
  )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- ---------------------------------------------------------------------------
-- Section 3 : lines - Estimated Cost (21 source fields)
-- ---------------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE q'[CREATE TABLE prod.pa_estimated_cost_lines (
    identifier              NUMBER            NOT NULL,
    transaction_num         VARCHAR2(60)      NOT NULL,
    project_num             VARCHAR2(60),
    project_name            VARCHAR2(400),
    task_num                VARCHAR2(120),
    task_name               VARCHAR2(240),
    estimated_cost          NUMBER,
    notes                   VARCHAR2(4000),
    cost_center             VARCHAR2(240),
    expenditure_type        VARCHAR2(240),
    line_status             VARCHAR2(60),
    created_by              VARCHAR2(240),
    last_updated_by         VARCHAR2(240),
    creation_date           DATE,
    last_updated_date       DATE,
    baseline_status         VARCHAR2(60),
    baseline_error          VARCHAR2(4000),
    transaction_line_error  VARCHAR2(4000),
    current_year_budget     NUMBER,
    gl_funds_available      NUMBER,
    code_combination        VARCHAR2(120),
    load_run_id             NUMBER,
    last_seen_at            TIMESTAMP,
    load_ts                 TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_pa_ec_lines PRIMARY KEY (identifier)
  )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- ---------------------------------------------------------------------------
-- Section 4 : lines - Annual Budget (38 source fields)
-- ---------------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE q'[CREATE TABLE prod.pa_annual_budget_lines (
    identifier              NUMBER            NOT NULL,
    transaction_num         VARCHAR2(60)      NOT NULL,
    project_num             VARCHAR2(60),
    project_phase           VARCHAR2(120),
    project_name            VARCHAR2(400),
    task_num                VARCHAR2(120),
    task_name               VARCHAR2(240),
    expenditure_type        VARCHAR2(240),
    revised_project_cost    NUMBER,
    approved_annual_budget  NUMBER,
    estimated_task_cost     NUMBER,
    variation_task_cost     NUMBER,
    approved_task_cost      NUMBER,
    previous_year_budget    NUMBER,
    current_year_budget     NUMBER,
    previous_year_actual    NUMBER,
    current_year_actual     NUMBER,
    total_actual            NUMBER,
    notes                   VARCHAR2(4000),
    approved_budget         NUMBER,
    proposed_budget         NUMBER,
    attachment              VARCHAR2(400),
    created_by              VARCHAR2(240),
    last_updated_by         VARCHAR2(240),
    creation_date           DATE,
    last_updated_date       DATE,
    cost_center             VARCHAR2(240),
    available_project_cost  NUMBER,
    gl_funds_available      NUMBER,
    code_combination        VARCHAR2(120),
    baseline_status         VARCHAR2(60),
    baseline_error          VARCHAR2(4000),
    transaction_line_error  VARCHAR2(4000),
    acc_annual_budget       NUMBER,
    period_from             VARCHAR2(20),
    period_to               VARCHAR2(20),
    validation_status       VARCHAR2(60),
    jv_status               VARCHAR2(60),
    load_run_id             NUMBER,
    last_seen_at            TIMESTAMP,
    load_ts                 TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_pa_ab_lines PRIMARY KEY (identifier)
  )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- ---------------------------------------------------------------------------
-- Section 5 : approval trail - ALL budget types
-- ---------------------------------------------------------------------------
-- The source rows carry NO identifier and NO transaction reference: the caller
-- stamps transaction_num + trx_type and numbers them in arrival order (seq_no).
-- Refresh is therefore delete-by-transaction-then-insert, never MERGE.
BEGIN
  EXECUTE IMMEDIATE q'[CREATE TABLE prod.pa_budget_trx_approvals (
    transaction_num             VARCHAR2(60)  NOT NULL,
    trx_type                    VARCHAR2(40)  NOT NULL,
    seq_no                      NUMBER        NOT NULL,
    submitter_name              VARCHAR2(240),
    assignee_username           VARCHAR2(240),
    assignment_state            VARCHAR2(60),
    creation_date               TIMESTAMP,
    change_amount               VARCHAR2(10),
    view_amount                 VARCHAR2(10),
    priority                    NUMBER,
    dept_1st_level_approval_flag VARCHAR2(10),
    load_run_id                 NUMBER,
    load_ts                     TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT pk_pa_bt_approvals PRIMARY KEY (transaction_num, trx_type, seq_no)
  )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- ---------------------------------------------------------------------------
-- Section 6 : indexes (guarded - re-runs are silent no-ops)
-- ---------------------------------------------------------------------------
DECLARE
  PROCEDURE ix(p_sql VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE p_sql;
  EXCEPTION WHEN OTHERS THEN
    IF SQLCODE NOT IN (-955, -1408) THEN RAISE; END IF;
  END;
BEGIN
  ix('CREATE INDEX prod.ix_pa_bth_num  ON prod.pa_budget_trx_headers (transaction_num)');
  ix('CREATE INDEX prod.ix_pa_bth_type ON prod.pa_budget_trx_headers (transaction_type, transaction_date)');
  ix('CREATE INDEX prod.ix_pa_bth_bu   ON prod.pa_budget_trx_headers (business_unit)');
  ix('CREATE INDEX prod.ix_pa_bth_stat ON prod.pa_budget_trx_headers (status)');
  ix('CREATE INDEX prod.ix_pa_afl_num  ON prod.pa_additional_fund_lines (transaction_num)');
  ix('CREATE INDEX prod.ix_pa_ecl_num  ON prod.pa_estimated_cost_lines (transaction_num)');
  ix('CREATE INDEX prod.ix_pa_abl_num  ON prod.pa_annual_budget_lines (transaction_num)');
END;
/

-- ---------------------------------------------------------------------------
-- Section 7 : vocabulary - the action type + the budget types
-- ---------------------------------------------------------------------------
-- Lookup-first: the budget types are DATA. Adding a 4th type upstream (a new
-- navigator page) = one row here + one lines table, no handler change.
DECLARE
  v_cat NUMBER;

  PROCEDURE ensure_category(p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, o_id OUT NUMBER) IS
    n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO n FROM prod.dct_lookup_categories WHERE category_code = p_code;
    IF n = 0 THEN
      INSERT INTO prod.dct_lookup_categories
             (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
      VALUES (p_code, p_en, p_ar, NULL, 'Y', 'Y');
    END IF;
    SELECT category_id INTO o_id FROM prod.dct_lookup_categories WHERE category_code = p_code;
  END;

  PROCEDURE ensure_value(p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2,
                         p_ord NUMBER, p_default VARCHAR2 DEFAULT 'N') IS
    n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO n FROM prod.dct_lookup_values
     WHERE category_id = p_cat AND value_code = p_code;
    IF n = 0 THEN
      INSERT INTO prod.dct_lookup_values
             (category_id, value_code, value_name_en, value_name_ar,
              display_order, is_default, is_active)
      VALUES (p_cat, p_code, p_en, p_ar, p_ord, p_default, 'Y');
    ELSE
      UPDATE prod.dct_lookup_values
         SET value_name_en = p_en, display_order = p_ord, is_active = 'Y'
       WHERE category_id = p_cat AND value_code = p_code;
    END IF;
  END;

BEGIN
  ensure_category('ATD_ACTION_TYPE', 'ATD Action Type', N'نوع إجراء الموزع', v_cat);
  ensure_value(v_cat, 'PA_BUDGET_TRX',
               'Project Budget Transactions extract', N'استخراج معاملات موازنة المشاريع', 40);

  -- the hyphenated API values are the CODES on purpose: a wrong value returns
  -- HTTP 200 with zero rows, never an error, so the code must be the literal.
  ensure_category('PA_BUDGET_TRX_TYPE', 'Project Budget Transaction Type',
                  N'نوع معاملة موازنة المشروع', v_cat);
  ensure_value(v_cat, 'Additional',     'Additional Fund', N'تمويل إضافي',      10, 'Y');
  ensure_value(v_cat, 'Estimated-Cost', 'Estimated Cost',  N'التكلفة التقديرية', 20);
  ensure_value(v_cat, 'Annual-Budget',  'Annual Budget',   N'الموازنة السنوية',  30);

  -- run modes, for the page's mode selector and the sync job
  ensure_category('PA_BUDGET_TRX_MODE', 'Project Budget Transaction Run Mode',
                  N'وضع تشغيل استخراج الموازنة', v_cat);
  ensure_value(v_cat, 'RANGE',        'Date range (on demand)', N'نطاق تاريخ (عند الطلب)', 10, 'Y');
  ensure_value(v_cat, 'SYNC_SHALLOW', 'Sync - changed only',    N'مزامنة - المتغير فقط',   20);
  ensure_value(v_cat, 'SYNC_DEEP',    'Sync - full refresh',    N'مزامنة - تحديث كامل',    30);

  COMMIT;
  DBMS_OUTPUT.put_line('PA_BUDGET_TRX vocabularies seeded');
END;
/

-- ---------------------------------------------------------------------------
-- Section 8 : sync settings (Runner Settings page reads atd_runner_config)
-- ---------------------------------------------------------------------------
-- PBT_SYNC_ENABLED ships as N deliberately: the scheduled job is switched on
-- only AFTER a manual full run reconciles against the VBCS page's own counts.
DECLARE
  PROCEDURE cfg(p_key VARCHAR2, p_val VARCHAR2, p_type VARCHAR2,
                p_desc VARCHAR2, p_ord NUMBER, p_enum VARCHAR2 DEFAULT NULL) IS
    n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO n FROM prod.atd_runner_config WHERE config_key = p_key;
    IF n = 0 THEN
      INSERT INTO prod.atd_runner_config
             (config_key, config_value, value_type, is_secret, enum_values,
              description, display_order)
      VALUES (p_key, p_val, p_type, 'N', p_enum, p_desc, p_ord);
    ELSE
      UPDATE prod.atd_runner_config
         SET description = p_desc, value_type = p_type,
             enum_values = p_enum, display_order = p_ord
       WHERE config_key = p_key;
    END IF;
  END;
BEGIN
  cfg('PBT_SYNC_ENABLED', 'N', 'BOOL',
      'Project Budget Transactions: run the scheduled sync (hourly shallow + nightly deep)', 810);
  cfg('ATD_PBT_CONC', '6', 'NUMBER',
      'Project Budget Transactions: how many detail/approval calls run at once (1 = serial; higher = faster full refresh, heavier on the source)', 809);
  cfg('PBT_SYNC_TYPES', 'Additional,Estimated-Cost,Annual-Budget', 'STRING',
      'Project Budget Transactions: budget types the scheduled sync covers (CSV of API codes)', 811);
  cfg('PBT_SYNC_BUS', 'Department of Culture and Tourism,Abrahamic Family House,Museum Shared Services', 'STRING',
      'Project Budget Transactions: business units to request (CSV)', 812);
  cfg('PBT_SYNC_APPROVALS', 'Y', 'BOOL',
      'Project Budget Transactions: also refresh the approval trail on each sync', 813);
  cfg('PBT_DEEP_HOUR', '1', 'NUMBER',
      'Project Budget Transactions: hour (0-23, Asia/Dubai) the nightly DEEP sync runs', 814);
  COMMIT;
  DBMS_OUTPUT.put_line('PA_BUDGET_TRX sync settings seeded (PBT_SYNC_ENABLED = N)');
END;
/

-- ---------------------------------------------------------------------------
-- Section 9 : request view for the ATD page register
-- ---------------------------------------------------------------------------
-- One row per PA_BUDGET_TRX request with its telemetry and the run's counts,
-- so the page's register is a plain SELECT with no per-row lookups.
CREATE OR REPLACE VIEW prod.v_pa_budget_trx_request AS
SELECT a.action_id,
       a.run_status,
       a.idem_key,
       a.source_ref,
       a.payload_json,
       JSON_VALUE(a.payload_json, '$.mode')     AS run_mode,
       JSON_VALUE(a.payload_json, '$.dateFrom') AS date_from,
       JSON_VALUE(a.payload_json, '$.dateTo')   AS date_to,
       a.attempts,
       a.last_error,
       a.worker_host,
       a.started_at,
       a.finished_at,
       ROUND((CAST(a.finished_at AS DATE) - CAST(a.started_at AS DATE)) * 86400) AS duration_secs,
       a.created_by,
       a.created_at,
       a.last_run_id,
       r.status    AS log_status,
       r.row_count AS log_row_count,
       r.message   AS log_message
  FROM prod.atd_action_request a
  LEFT JOIN prod.atd_load_run_log r ON r.run_id = a.last_run_id
 WHERE a.action_type = 'PA_BUDGET_TRX';

-- ---------------------------------------------------------------------------
-- Verify
-- ---------------------------------------------------------------------------
SELECT table_name, num_rows FROM all_tables
 WHERE owner = 'PROD'
   AND table_name IN ('PA_BUDGET_TRX_HEADERS','PA_ADDITIONAL_FUND_LINES',
                      'PA_ESTIMATED_COST_LINES','PA_ANNUAL_BUDGET_LINES',
                      'PA_BUDGET_TRX_APPROVALS')
 ORDER BY table_name;

SELECT c.category_code, v.value_code, v.value_name_en
  FROM prod.dct_lookup_values v
  JOIN prod.dct_lookup_categories c ON c.category_id = v.category_id
 WHERE c.category_code IN ('PA_BUDGET_TRX_TYPE','PA_BUDGET_TRX_MODE')
    OR (c.category_code = 'ATD_ACTION_TYPE' AND v.value_code = 'PA_BUDGET_TRX')
 ORDER BY c.category_code, v.display_order;

-- Oracle LIKE has NO [...] character class - 'PBT[_]%' matches the literal
-- text "PBT[_]..." and silently returns nothing. Escape the underscore.
SELECT config_key, config_value FROM prod.atd_runner_config
 WHERE config_key LIKE 'PBT\_%' ESCAPE '\' ORDER BY display_order;
