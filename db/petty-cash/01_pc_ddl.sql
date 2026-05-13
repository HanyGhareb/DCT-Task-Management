-- =============================================================================
-- Petty Cash Module — DDL
-- File    : 01_pc_ddl.sql
-- Schema  : PROD
-- DB      : Oracle 23ai
-- Module  : PETTY_CASH (f101)
-- Depends : db/v2/01_dct_ddl.sql (shared framework must be installed first)
-- =============================================================================
-- Run order: 01_pc_ddl → 02_pc_views → 03_pc_seed
-- To reinstall clean: uncomment the DROP section below and run first.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

-- -----------------------------------------------------------------------------
-- CLEAN REINSTALL (uncomment to drop all objects before re-creating)
-- -----------------------------------------------------------------------------
/*
DROP TABLE dct_pc_attachments        CASCADE CONSTRAINTS PURGE;
DROP TABLE dct_pc_clear_budget_lines CASCADE CONSTRAINTS PURGE;
DROP TABLE dct_pc_clearing           CASCADE CONSTRAINTS PURGE;
DROP TABLE dct_pc_reimb_budget_lines CASCADE CONSTRAINTS PURGE;
DROP TABLE dct_pc_reimbursements     CASCADE CONSTRAINTS PURGE;
DROP TABLE dct_pc_budget_lines       CASCADE CONSTRAINTS PURGE;
DROP TABLE dct_petty_cash            CASCADE CONSTRAINTS PURGE;
DROP TABLE dct_gl_code_combinations  CASCADE CONSTRAINTS PURGE;
*/

-- =============================================================================
-- 1. DCT_GL_CODE_COMBINATIONS
--    Master reference table for all valid GL chart-of-accounts combinations.
--    Segments cascade in this order:
--    Entity Code → Appropriation → Cost Center → Entity Specific →
--    Budget Group Code → Account → IC → Future1 → Future2
-- =============================================================================
CREATE TABLE dct_gl_code_combinations (
    cc_id              NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    entity_code        VARCHAR2(30)   NOT NULL,
    appropriation      VARCHAR2(30),
    cost_center        VARCHAR2(30),
    entity_specific    VARCHAR2(30),
    budget_group_code  VARCHAR2(30),
    account            VARCHAR2(30),
    ic                 VARCHAR2(30),
    future1            VARCHAR2(30),
    future2            VARCHAR2(30),
    is_active          VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
    start_date         DATE           DEFAULT SYSDATE NOT NULL,
    end_date           DATE,
    created_by         VARCHAR2(100),
    created_at         TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by         VARCHAR2(100),
    updated_at         TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_glcc_active CHECK (is_active IN ('Y','N')),
    CONSTRAINT chk_dct_glcc_dates  CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE INDEX ix_dct_glcc_entity   ON dct_gl_code_combinations(entity_code, is_active);
CREATE INDEX ix_dct_glcc_approp   ON dct_gl_code_combinations(entity_code, appropriation);
CREATE INDEX ix_dct_glcc_cc       ON dct_gl_code_combinations(appropriation, cost_center);
CREATE INDEX ix_dct_glcc_account  ON dct_gl_code_combinations(budget_group_code, account);
CREATE INDEX ix_dct_glcc_active   ON dct_gl_code_combinations(is_active, start_date, end_date);

-- =============================================================================
-- 2. DCT_PETTY_CASH
--    One record per employee advance. Each employee may hold at most
--    MAX_PC_PER_EMPLOYEE active petty cash records (controlled by module setting).
-- =============================================================================
CREATE TABLE dct_petty_cash (
    pc_id                NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pc_number            VARCHAR2(20)   NOT NULL,          -- System-generated e.g. PC-2026-00001
    pc_type              VARCHAR2(20)   NOT NULL,          -- TEMPORARY | PERMANENT
    user_id              NUMBER         NOT NULL,
    employee_num         VARCHAR2(50),                     -- HR employee number
    org_id               NUMBER,
    amount               NUMBER(15,2)   NOT NULL,
    purpose              VARCHAR2(1000),
    coding_type          VARCHAR2(10)   NOT NULL,          -- GL | PROJECT
    status               VARCHAR2(20)   DEFAULT 'DRAFT' NOT NULL,
    fiscal_year          NUMBER(4)      NOT NULL,
    due_date             DATE,
    disbursed_date       DATE,
    closed_date          DATE,
    approval_instance_id NUMBER,
    submitted_at         TIMESTAMP,
    created_by           VARCHAR2(100),
    created_at           TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by           VARCHAR2(100),
    updated_at           TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_pc_number     UNIQUE (pc_number),
    CONSTRAINT chk_dct_pc_type      CHECK  (pc_type     IN ('TEMPORARY','PERMANENT')),
    CONSTRAINT chk_dct_pc_coding    CHECK  (coding_type IN ('GL','PROJECT')),
    CONSTRAINT chk_dct_pc_status    CHECK  (status IN
                                           ('DRAFT','SUBMITTED','PENDING_APPROVAL',
                                            'ACTIVE','CLOSED','REJECTED','CANCELLED')),
    CONSTRAINT chk_dct_pc_amount    CHECK  (amount > 0),
    CONSTRAINT fk_dct_pc_user       FOREIGN KEY (user_id)              REFERENCES dct_users(user_id),
    CONSTRAINT fk_dct_pc_org        FOREIGN KEY (org_id)               REFERENCES dct_organizations(org_id),
    CONSTRAINT fk_dct_pc_inst       FOREIGN KEY (approval_instance_id) REFERENCES dct_approval_instances(instance_id)
);

CREATE INDEX ix_dct_pc_user      ON dct_petty_cash(user_id, status);
CREATE INDEX ix_dct_pc_empno     ON dct_petty_cash(employee_num);
CREATE INDEX ix_dct_pc_status    ON dct_petty_cash(status, fiscal_year);
CREATE INDEX ix_dct_pc_org       ON dct_petty_cash(org_id, status);
CREATE INDEX ix_dct_pc_inst      ON dct_petty_cash(approval_instance_id);

-- =============================================================================
-- 3. DCT_PC_BUDGET_LINES
--    Budget coding lines for the petty cash advance request.
--    All lines must be of the same coding type as the parent DCT_PETTY_CASH row.
--    SUM(amount) must equal DCT_PETTY_CASH.amount (enforced in application layer).
-- =============================================================================
CREATE TABLE dct_pc_budget_lines (
    line_id           NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pc_id             NUMBER         NOT NULL,
    line_num          NUMBER         NOT NULL,             -- 1-based sequence within the request
    amount            NUMBER(15,2)   NOT NULL,
    -- GL coding fields (populated when parent coding_type = 'GL')
    cc_id             NUMBER,
    -- Project coding fields (populated when parent coding_type = 'PROJECT')
    project_number    VARCHAR2(50),
    task_number       VARCHAR2(50),
    expenditure_type  VARCHAR2(100),
    description       VARCHAR2(500),
    created_by        VARCHAR2(100),
    created_at        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by        VARCHAR2(100),
    updated_at        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_pcbl_line    UNIQUE      (pc_id, line_num),
    CONSTRAINT chk_dct_pcbl_amount CHECK       (amount > 0),
    CONSTRAINT fk_dct_pcbl_pc      FOREIGN KEY (pc_id)  REFERENCES dct_petty_cash(pc_id)           ON DELETE CASCADE,
    CONSTRAINT fk_dct_pcbl_cc      FOREIGN KEY (cc_id)  REFERENCES dct_gl_code_combinations(cc_id)
);

CREATE INDEX ix_dct_pcbl_pc ON dct_pc_budget_lines(pc_id);

-- =============================================================================
-- 4. DCT_PC_REIMBURSEMENTS
--    Each reimbursement request is linked to one active petty cash advance.
--    Employee may raise many reimbursements against the same petty cash.
-- =============================================================================
CREATE TABLE dct_pc_reimbursements (
    reimb_id             NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reimb_number         VARCHAR2(20)   NOT NULL,          -- e.g. RMB-2026-00001
    pc_id                NUMBER         NOT NULL,
    amount               NUMBER(15,2)   NOT NULL,
    purpose              VARCHAR2(1000),
    coding_type          VARCHAR2(10)   NOT NULL,          -- GL | PROJECT
    status               VARCHAR2(20)   DEFAULT 'DRAFT' NOT NULL,
    approval_instance_id NUMBER,
    submitted_at         TIMESTAMP,
    created_by           VARCHAR2(100),
    created_at           TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by           VARCHAR2(100),
    updated_at           TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_reimb_number   UNIQUE (reimb_number),
    CONSTRAINT chk_dct_reimb_coding  CHECK  (coding_type IN ('GL','PROJECT')),
    CONSTRAINT chk_dct_reimb_status  CHECK  (status IN
                                            ('DRAFT','SUBMITTED','PENDING_APPROVAL',
                                             'APPROVED','REJECTED','CANCELLED')),
    CONSTRAINT chk_dct_reimb_amount  CHECK  (amount > 0),
    CONSTRAINT fk_dct_reimb_pc       FOREIGN KEY (pc_id)               REFERENCES dct_petty_cash(pc_id),
    CONSTRAINT fk_dct_reimb_inst     FOREIGN KEY (approval_instance_id) REFERENCES dct_approval_instances(instance_id)
);

CREATE INDEX ix_dct_reimb_pc     ON dct_pc_reimbursements(pc_id, status);
CREATE INDEX ix_dct_reimb_status ON dct_pc_reimbursements(status);
CREATE INDEX ix_dct_reimb_inst   ON dct_pc_reimbursements(approval_instance_id);

-- =============================================================================
-- 5. DCT_PC_REIMB_BUDGET_LINES
--    Budget coding lines per reimbursement request.
--    SUM(amount) must equal DCT_PC_REIMBURSEMENTS.amount.
-- =============================================================================
CREATE TABLE dct_pc_reimb_budget_lines (
    line_id           NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reimb_id          NUMBER         NOT NULL,
    line_num          NUMBER         NOT NULL,
    amount            NUMBER(15,2)   NOT NULL,
    cc_id             NUMBER,
    project_number    VARCHAR2(50),
    task_number       VARCHAR2(50),
    expenditure_type  VARCHAR2(100),
    description       VARCHAR2(500),
    created_by        VARCHAR2(100),
    created_at        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by        VARCHAR2(100),
    updated_at        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_rbl_line    UNIQUE      (reimb_id, line_num),
    CONSTRAINT chk_dct_rbl_amount CHECK       (amount > 0),
    CONSTRAINT fk_dct_rbl_reimb   FOREIGN KEY (reimb_id) REFERENCES dct_pc_reimbursements(reimb_id) ON DELETE CASCADE,
    CONSTRAINT fk_dct_rbl_cc      FOREIGN KEY (cc_id)    REFERENCES dct_gl_code_combinations(cc_id)
);

CREATE INDEX ix_dct_rbl_reimb ON dct_pc_reimb_budget_lines(reimb_id);

-- =============================================================================
-- 6. DCT_PC_CLEARING
--    One clearing request per petty cash advance (closes the advance).
--    amount_spent    = total of budget lines (expense proof)
--    amount_refunded = declared unspent cash returned to company
--    Enforced: amount_spent + amount_refunded = parent DCT_PETTY_CASH.amount
--              (application-layer validation)
-- =============================================================================
CREATE TABLE dct_pc_clearing (
    clearing_id          NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    clearing_number      VARCHAR2(20)   NOT NULL,          -- e.g. CLR-2026-00001
    pc_id                NUMBER         NOT NULL,
    amount_spent         NUMBER(15,2)   NOT NULL,          -- Total of expense budget lines
    amount_refunded      NUMBER(15,2)   DEFAULT 0 NOT NULL, -- Unspent cash declared as returned
    coding_type          VARCHAR2(10)   NOT NULL,          -- GL | PROJECT
    status               VARCHAR2(20)   DEFAULT 'DRAFT' NOT NULL,
    approval_instance_id NUMBER,
    submitted_at         TIMESTAMP,
    created_by           VARCHAR2(100),
    created_at           TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by           VARCHAR2(100),
    updated_at           TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_clr_number      UNIQUE (clearing_number),
    CONSTRAINT chk_dct_clr_coding     CHECK  (coding_type IN ('GL','PROJECT')),
    CONSTRAINT chk_dct_clr_status     CHECK  (status IN
                                             ('DRAFT','SUBMITTED','PENDING_APPROVAL',
                                              'APPROVED','REJECTED','CANCELLED')),
    CONSTRAINT chk_dct_clr_spent      CHECK  (amount_spent    >= 0),
    CONSTRAINT chk_dct_clr_refunded   CHECK  (amount_refunded >= 0),
    CONSTRAINT fk_dct_clr_pc          FOREIGN KEY (pc_id)               REFERENCES dct_petty_cash(pc_id),
    CONSTRAINT fk_dct_clr_inst        FOREIGN KEY (approval_instance_id) REFERENCES dct_approval_instances(instance_id)
);

CREATE INDEX ix_dct_clr_pc     ON dct_pc_clearing(pc_id, status);
CREATE INDEX ix_dct_clr_status ON dct_pc_clearing(status);
CREATE INDEX ix_dct_clr_inst   ON dct_pc_clearing(approval_instance_id);

-- =============================================================================
-- 7. DCT_PC_CLEAR_BUDGET_LINES
--    Budget coding lines per clearing request (expense proof lines).
--    SUM(amount) must equal DCT_PC_CLEARING.amount_spent.
-- =============================================================================
CREATE TABLE dct_pc_clear_budget_lines (
    line_id           NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    clearing_id       NUMBER         NOT NULL,
    line_num          NUMBER         NOT NULL,
    amount            NUMBER(15,2)   NOT NULL,
    cc_id             NUMBER,
    project_number    VARCHAR2(50),
    task_number       VARCHAR2(50),
    expenditure_type  VARCHAR2(100),
    description       VARCHAR2(500),
    created_by        VARCHAR2(100),
    created_at        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by        VARCHAR2(100),
    updated_at        TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_cbl_line    UNIQUE      (clearing_id, line_num),
    CONSTRAINT chk_dct_cbl_amount CHECK       (amount > 0),
    CONSTRAINT fk_dct_cbl_clr    FOREIGN KEY (clearing_id) REFERENCES dct_pc_clearing(clearing_id) ON DELETE CASCADE,
    CONSTRAINT fk_dct_cbl_cc     FOREIGN KEY (cc_id)       REFERENCES dct_gl_code_combinations(cc_id)
);

CREATE INDEX ix_dct_cbl_clr ON dct_pc_clear_budget_lines(clearing_id);

-- =============================================================================
-- 8. DCT_PC_ATTACHMENTS
--    Documents attached to any petty cash request type.
--    request_type discriminates: PC = advance | REIMB = reimbursement | CLEAR = clearing
-- =============================================================================
CREATE TABLE dct_pc_attachments (
    attach_id         NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    request_type      VARCHAR2(5)    NOT NULL,             -- PC | REIMB | CLEAR
    request_id        NUMBER         NOT NULL,             -- PK of the parent request
    file_name         VARCHAR2(500)  NOT NULL,
    mime_type         VARCHAR2(200),
    file_size         NUMBER,                              -- bytes
    file_blob         BLOB,
    description       VARCHAR2(500),
    uploaded_by       VARCHAR2(100),
    uploaded_at       TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_att_type CHECK (request_type IN ('PC','REIMB','CLEAR'))
);

CREATE INDEX ix_dct_att_request ON dct_pc_attachments(request_type, request_id);

-- =============================================================================
-- TRIGGERS — Auto-maintain updated_at / updated_by
-- =============================================================================
CREATE OR REPLACE TRIGGER trg_dct_glcc_upd
    BEFORE UPDATE ON dct_gl_code_combinations FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
CREATE OR REPLACE TRIGGER trg_dct_pc_upd
    BEFORE UPDATE ON dct_petty_cash FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
CREATE OR REPLACE TRIGGER trg_dct_pcbl_upd
    BEFORE UPDATE ON dct_pc_budget_lines FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
CREATE OR REPLACE TRIGGER trg_dct_reimb_upd
    BEFORE UPDATE ON dct_pc_reimbursements FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
CREATE OR REPLACE TRIGGER trg_dct_rbl_upd
    BEFORE UPDATE ON dct_pc_reimb_budget_lines FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
CREATE OR REPLACE TRIGGER trg_dct_clr_upd
    BEFORE UPDATE ON dct_pc_clearing FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/
CREATE OR REPLACE TRIGGER trg_dct_cbl_upd
    BEFORE UPDATE ON dct_pc_clear_budget_lines FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
    :NEW.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), SYS_CONTEXT('USERENV','SESSION_USER'));
END;
/

-- =============================================================================
-- COMMENTS
-- =============================================================================
COMMENT ON TABLE  dct_gl_code_combinations IS 'Petty Cash: Valid GL chart-of-accounts combinations. Segments cascade: Entity Code → Appropriation → Cost Center → Entity Specific → Budget Group Code → Account → IC → Future1 → Future2.';
COMMENT ON TABLE  dct_petty_cash           IS 'Petty Cash: One record per employee advance. Type=TEMPORARY must be cleared within the same fiscal year; PERMANENT spans multiple years.';
COMMENT ON COLUMN dct_petty_cash.coding_type IS 'GL=segments from DCT_GL_CODE_COMBINATIONS | PROJECT=project/task/expenditure from external projects tables';
COMMENT ON COLUMN dct_petty_cash.status      IS 'DRAFT→SUBMITTED→PENDING_APPROVAL→ACTIVE(disbursed)→CLOSED | REJECTED | CANCELLED';
COMMENT ON TABLE  dct_pc_budget_lines      IS 'Petty Cash: Budget coding lines for the advance request. SUM(amount) must equal parent DCT_PETTY_CASH.amount.';
COMMENT ON TABLE  dct_pc_reimbursements    IS 'Petty Cash: Reimbursement requests against an active petty cash. Approved reimbursements restore the employee float.';
COMMENT ON TABLE  dct_pc_reimb_budget_lines IS 'Petty Cash: Budget coding lines per reimbursement. SUM(amount) must equal parent DCT_PC_REIMBURSEMENTS.amount.';
COMMENT ON TABLE  dct_pc_clearing          IS 'Petty Cash: Clearing request — settles and closes the advance. amount_spent + amount_refunded must equal parent advance amount.';
COMMENT ON COLUMN dct_pc_clearing.amount_refunded IS 'Declared unspent cash returned to company. No separate transaction record — declared field only.';
COMMENT ON TABLE  dct_pc_clear_budget_lines IS 'Petty Cash: Budget coding lines per clearing (expense proof). SUM(amount) must equal parent DCT_PC_CLEARING.amount_spent.';
COMMENT ON TABLE  dct_pc_attachments       IS 'Petty Cash: Documents for any request type. request_type=PC|REIMB|CLEAR with request_id pointing to the parent record PK.';

COMMIT;
-- End of 01_pc_ddl.sql
