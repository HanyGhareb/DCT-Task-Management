-- ============================================================================
-- DRAFT — NOT DEPLOYED — assessment-3 proposal only. Do NOT run against PROD.
-- Unified budget-coding line table replacing:
--   dct_pc_budget_lines, dct_pc_reimb_budget_lines, dct_pc_clear_budget_lines,
--   dct_cc_reimb_lines, and inline coding columns on dt_requests /
--   dt_settlement_lines / dct_fl_contracts.
-- See assessment-3/03-database/02-proposed-model.md §3
-- ============================================================================
SET DEFINE OFF

CREATE TABLE prod.dct_budget_coding_lines (
  line_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  source_module    VARCHAR2(10)  NOT NULL
                   CHECK (source_module IN ('PC','DT','FL','CC')),
  source_type      VARCHAR2(30)  NOT NULL,
                   -- PC | PC_REIMB | PC_CLEAR | CC_REPL | DT_REQ | DT_STL | FL_CONTRACT
  source_id        NUMBER        NOT NULL,
  line_num         NUMBER        NOT NULL,
  coding_type      VARCHAR2(10)  NOT NULL CHECK (coding_type IN ('GL','PROJECT')),

  -- GL branch: 9-segment combination master (cc_code is virtual there)
  cc_id            NUMBER REFERENCES prod.dct_gl_code_combinations (cc_id),

  -- PROJECT branch: ID-based FKs replacing the free-text
  -- project_number / task_number / expenditure_type columns
  project_id       NUMBER REFERENCES prod.dct_projects (project_id),
  task_id          NUMBER REFERENCES prod.dct_project_tasks (task_id),
  exp_type_id      NUMBER REFERENCES prod.dct_expenditure_types (exp_type_id),

  amount           NUMBER(15,2)  NOT NULL,
  currency_code    VARCHAR2(3)   DEFAULT 'AED'
                   REFERENCES prod.dct_currency_codes (currency_code),
  description      VARCHAR2(500),

  -- CC-only extension columns (nullable for all other modules)
  merchant_name    VARCHAR2(200),
  receipt_attached VARCHAR2(1) CHECK (receipt_attached IN ('Y','N')),

  created_by       NUMBER NOT NULL,
  created_at       TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
  updated_by       NUMBER,
  updated_at       TIMESTAMP,

  CONSTRAINT uq_dct_bcl UNIQUE (source_module, source_type, source_id, line_num),

  -- GL/PROJECT exclusivity enforced ONCE in the schema
  -- (today re-implemented in each module package)
  CONSTRAINT ck_dct_bcl_coding CHECK (
       (coding_type = 'GL'      AND cc_id IS NOT NULL AND project_id IS NULL
                                AND task_id IS NULL   AND exp_type_id IS NULL)
    OR (coding_type = 'PROJECT' AND project_id IS NOT NULL AND cc_id IS NULL)
  )
);

CREATE INDEX prod.idx_dct_bcl_source ON prod.dct_budget_coding_lines
  (source_module, source_type, source_id);
CREATE INDEX prod.idx_dct_bcl_cc      ON prod.dct_budget_coding_lines (cc_id);
CREATE INDEX prod.idx_dct_bcl_project ON prod.dct_budget_coding_lines (project_id);

COMMENT ON TABLE prod.dct_budget_coding_lines IS
  'Unified GL/PROJECT coding lines for all spend modules. One read path for cross-module spend reporting.';

-- Cross-module spend reporting becomes one query, e.g.:
--   SELECT source_module, cc.cc_code, SUM(l.amount)
--   FROM   dct_budget_coding_lines l
--   JOIN   dct_gl_code_combinations cc ON cc.cc_id = l.cc_id
--   WHERE  l.coding_type = 'GL'
--   GROUP  BY source_module, cc.cc_code;

-- ADMIN synonym for ORDS handlers:
--   CREATE OR REPLACE SYNONYM dct_budget_coding_lines FOR prod.dct_budget_coding_lines;
