-- =============================================================================
-- Credit Cards Module (App 202) — DDL
-- File    : 01_cc_ddl.sql
-- Schema  : PROD
-- Run     : Via SQLcl connected as ADMIN (prod_mcp)
-- Requires: V2 shared framework installed (db/v2/install.sql)
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- =============================================================================
-- DROP (reverse dependency order) — safe re-run
-- =============================================================================
BEGIN
  FOR t IN (
    SELECT table_name FROM all_tables
    WHERE  owner = 'PROD'
    AND    table_name IN (
             'DCT_CC_CARD_LIMIT_HISTORY',
             'DCT_CC_PROXIES',
             'DCT_CC_REIMB_LINES',
             'DCT_CC_REPLENISHMENTS',
             'DCT_CC_ATTACHMENTS',
             'DCT_CC_DOC_REQUIREMENTS',
             'DCT_CC_REQUESTS',
             'DCT_CREDIT_CARDS'
           )
  ) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE prod.' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
    DBMS_OUTPUT.PUT_LINE('Dropped: ' || t.table_name);
  END LOOP;
END;
/

-- =============================================================================
-- 1. DCT_CREDIT_CARDS — Card Registry
-- =============================================================================
CREATE TABLE prod.dct_credit_cards (
  cc_id                NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cc_number            VARCHAR2(30)    NOT NULL,
  holder_user_id       NUMBER          NOT NULL,
  mother_name          VARCHAR2(200)   NOT NULL,
  nationality          VARCHAR2(100)   NOT NULL,
  credit_limit         NUMBER(15,2)    NOT NULL,
  expiry_date          DATE            NOT NULL,
  email                VARCHAR2(200)   NOT NULL,
  org_id               NUMBER          NOT NULL,
  cost_center          VARCHAR2(50),
  bank_name            VARCHAR2(100),
  bank_customer_yn     CHAR(1)         DEFAULT 'N' NOT NULL,
  bank_mobile_yn       CHAR(1)         DEFAULT 'N' NOT NULL,
  bank_email_yn        CHAR(1)         DEFAULT 'N' NOT NULL,
  status               VARCHAR2(30)    DEFAULT 'UNDER_PROCESS' NOT NULL,
  notes                VARCHAR2(1000),
  approval_instance_id NUMBER,
  created_by           VARCHAR2(100),
  created_at           DATE            DEFAULT SYSDATE NOT NULL,
  updated_by           VARCHAR2(100),
  updated_at           DATE            DEFAULT SYSDATE NOT NULL,
  -- Constraints
  CONSTRAINT uq_dct_cc_number        UNIQUE (cc_number),
  CONSTRAINT chk_dct_cc_status       CHECK (status IN (
    'ACTIVE','INACTIVE','UNDER_PROCESS',
    'REPLACEMENT_IN_PROGRESS','CLOSING_IN_PROGRESS',
    'INCREASING_IN_PROGRESS','DECREASING_IN_PROGRESS'
  )),
  CONSTRAINT chk_dct_cc_bank_cust    CHECK (bank_customer_yn IN ('Y','N')),
  CONSTRAINT chk_dct_cc_bank_mob     CHECK (bank_mobile_yn   IN ('Y','N')),
  CONSTRAINT chk_dct_cc_bank_email   CHECK (bank_email_yn    IN ('Y','N')),
  CONSTRAINT chk_dct_cc_limit        CHECK (credit_limit > 0),
  CONSTRAINT fk_dct_cc_holder        FOREIGN KEY (holder_user_id)
                                       REFERENCES prod.dct_users(user_id),
  CONSTRAINT fk_dct_cc_org           FOREIGN KEY (org_id)
                                       REFERENCES prod.dct_organizations(org_id)
);

CREATE INDEX idx_dct_cc_holder   ON prod.dct_credit_cards(holder_user_id);
CREATE INDEX idx_dct_cc_org      ON prod.dct_credit_cards(org_id);
CREATE INDEX idx_dct_cc_status   ON prod.dct_credit_cards(status);

COMMENT ON TABLE  prod.dct_credit_cards                IS 'Corporate credit card registry — one record per physical card';
COMMENT ON COLUMN prod.dct_credit_cards.cc_number      IS 'App-generated reference number: CC-YYYY-NNNNN';
COMMENT ON COLUMN prod.dct_credit_cards.mother_name    IS 'Required by bank for card issuance';
COMMENT ON COLUMN prod.dct_credit_cards.nationality    IS 'Required by bank for card issuance';
COMMENT ON COLUMN prod.dct_credit_cards.bank_customer_yn IS 'Y = employee already has an account at the issuing bank';
COMMENT ON COLUMN prod.dct_credit_cards.approval_instance_id IS 'Points to the currently active DCT_APPROVAL_INSTANCES record';

-- =============================================================================
-- 2. DCT_CC_REQUESTS — Card Change Requests
-- =============================================================================
CREATE TABLE prod.dct_cc_requests (
  request_id           NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  request_number       VARCHAR2(30)    NOT NULL,
  cc_id                NUMBER,
  request_type         VARCHAR2(20)    NOT NULL,
  requested_limit      NUMBER(15,2),
  reason               VARCHAR2(500),
  replacement_reason   VARCHAR2(100),
  status               VARCHAR2(20)    DEFAULT 'DRAFT' NOT NULL,
  approval_instance_id NUMBER,
  submitted_at         DATE,
  created_by           VARCHAR2(100),
  created_at           DATE            DEFAULT SYSDATE NOT NULL,
  updated_by           VARCHAR2(100),
  updated_at           DATE            DEFAULT SYSDATE NOT NULL,
  -- Constraints
  CONSTRAINT uq_dct_ccr_number       UNIQUE (request_number),
  CONSTRAINT chk_dct_ccr_type        CHECK (request_type IN (
    'NEW_CARD','INCREASE_LIMIT','DECREASE_LIMIT','CLOSE_CARD','REPLACEMENT'
  )),
  CONSTRAINT chk_dct_ccr_status      CHECK (status IN (
    'DRAFT','SUBMITTED','UNDER_REVIEW','RETURNED','APPROVED','REJECTED','WITHDRAWN'
  )),
  CONSTRAINT chk_dct_ccr_repl_rsn    CHECK (replacement_reason IN (
    'DAMAGED','LOST','EXPIRING','OTHER'
  ) OR replacement_reason IS NULL),
  CONSTRAINT chk_dct_ccr_limit_pos   CHECK (requested_limit IS NULL OR requested_limit > 0),
  CONSTRAINT fk_dct_ccr_cc           FOREIGN KEY (cc_id)
                                       REFERENCES prod.dct_credit_cards(cc_id)
);

CREATE INDEX idx_dct_ccr_cc_id   ON prod.dct_cc_requests(cc_id);
CREATE INDEX idx_dct_ccr_status  ON prod.dct_cc_requests(status);
CREATE INDEX idx_dct_ccr_type    ON prod.dct_cc_requests(request_type);

COMMENT ON TABLE  prod.dct_cc_requests             IS 'Card lifecycle requests: new issuance, limit changes, replacement, closure';
COMMENT ON COLUMN prod.dct_cc_requests.cc_id       IS 'NULL for NEW_CARD requests — card does not exist yet';
COMMENT ON COLUMN prod.dct_cc_requests.request_number IS 'App-generated: CCR-YYYY-NNNNN';

-- =============================================================================
-- 3. DCT_CC_DOC_REQUIREMENTS — Required Documents Per Request Type
-- =============================================================================
CREATE TABLE prod.dct_cc_doc_requirements (
  doc_req_id           NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  request_type         VARCHAR2(20)    NOT NULL,
  document_name        VARCHAR2(200)   NOT NULL,
  is_mandatory         CHAR(1)         DEFAULT 'Y' NOT NULL,
  is_active            CHAR(1)         DEFAULT 'Y' NOT NULL,
  display_seq          NUMBER          DEFAULT 10 NOT NULL,
  created_by           VARCHAR2(100),
  created_at           DATE            DEFAULT SYSDATE NOT NULL,
  updated_by           VARCHAR2(100),
  updated_at           DATE            DEFAULT SYSDATE NOT NULL,
  -- Constraints
  CONSTRAINT chk_dct_doc_req_type    CHECK (request_type IN (
    'NEW_CARD','INCREASE_LIMIT','DECREASE_LIMIT','CLOSE_CARD','REPLACEMENT'
  )),
  CONSTRAINT chk_dct_doc_req_mand    CHECK (is_mandatory IN ('Y','N')),
  CONSTRAINT chk_dct_doc_req_active  CHECK (is_active    IN ('Y','N'))
);

CREATE INDEX idx_dct_docreq_type ON prod.dct_cc_doc_requirements(request_type, is_active);

COMMENT ON TABLE prod.dct_cc_doc_requirements IS 'Admin-configured list of required documents per credit card request type';

-- =============================================================================
-- 4. DCT_CC_ATTACHMENTS — File Uploads (Requests + Replenishments)
-- =============================================================================
CREATE TABLE prod.dct_cc_attachments (
  attach_id            NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  source_type          VARCHAR2(20)    NOT NULL,
  source_id            NUMBER          NOT NULL,
  reference_id         NUMBER,
  doc_req_id           NUMBER,
  file_name            VARCHAR2(500)   NOT NULL,
  mime_type            VARCHAR2(200),
  file_size            NUMBER,
  file_blob            BLOB,
  description          VARCHAR2(500),
  uploaded_by          NUMBER          NOT NULL,
  uploaded_at          DATE            DEFAULT SYSDATE NOT NULL,
  -- Constraints
  CONSTRAINT chk_dct_cca_src_type    CHECK (source_type IN ('REQUEST','REPLENISHMENT')),
  CONSTRAINT fk_dct_cca_doc_req      FOREIGN KEY (doc_req_id)
                                       REFERENCES prod.dct_cc_doc_requirements(doc_req_id),
  CONSTRAINT fk_dct_cca_uploaded_by  FOREIGN KEY (uploaded_by)
                                       REFERENCES prod.dct_users(user_id)
);

CREATE INDEX idx_dct_cca_source  ON prod.dct_cc_attachments(source_type, source_id);
CREATE INDEX idx_dct_cca_ref     ON prod.dct_cc_attachments(reference_id);

COMMENT ON TABLE  prod.dct_cc_attachments              IS 'File uploads for both card requests and monthly replenishments';
COMMENT ON COLUMN prod.dct_cc_attachments.source_type  IS 'REQUEST = DCT_CC_REQUESTS; REPLENISHMENT = DCT_CC_REPLENISHMENTS';
COMMENT ON COLUMN prod.dct_cc_attachments.source_id    IS 'FK to request_id or replenishment_id depending on source_type';
COMMENT ON COLUMN prod.dct_cc_attachments.reference_id IS 'FK to DCT_CC_REIMB_LINES.line_id for line-level receipt uploads';

-- NOTE: Approver delegation for Credit Cards is handled by the V2 shared
-- DCT_DELEGATIONS table (scope='MODULE', module_code='CREDIT_CARDS').
-- Use the DCT_CC_DELEGATION_V view (02_cc_views.sql) for CC-scoped queries.

-- =============================================================================
-- 5. DCT_CC_REPLENISHMENTS — Monthly Expense Statement Headers
-- =============================================================================
CREATE TABLE prod.dct_cc_replenishments (
  replenishment_id     NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  reimb_number         VARCHAR2(30)    NOT NULL,
  cc_id                NUMBER          NOT NULL,
  period_month         NUMBER(2)       NOT NULL,
  period_year          NUMBER(4)       NOT NULL,
  total_amount         NUMBER(15,2)    DEFAULT 0 NOT NULL,
  submitted_by_user_id NUMBER          NOT NULL,
  on_behalf_of_user_id NUMBER          NOT NULL,
  -- Header-level budget coding (defaulted to lines)
  coding_type          VARCHAR2(10),
  cc_id_gl             NUMBER,
  project_number       VARCHAR2(50),
  task_number          VARCHAR2(50),
  expenditure_type     VARCHAR2(100),
  -- Lifecycle
  status               VARCHAR2(20)    DEFAULT 'DRAFT' NOT NULL,
  approval_instance_id NUMBER,
  submitted_at         DATE,
  created_by           VARCHAR2(100),
  created_at           DATE            DEFAULT SYSDATE NOT NULL,
  updated_by           VARCHAR2(100),
  updated_at           DATE            DEFAULT SYSDATE NOT NULL,
  -- Constraints
  CONSTRAINT uq_dct_ccreimb_period   UNIQUE (cc_id, period_month, period_year),
  CONSTRAINT uq_dct_ccreimb_number   UNIQUE (reimb_number),
  CONSTRAINT chk_dct_ccreimb_month   CHECK (period_month BETWEEN 1 AND 12),
  CONSTRAINT chk_dct_ccreimb_year    CHECK (period_year  BETWEEN 2000 AND 2099),
  CONSTRAINT chk_dct_ccreimb_status  CHECK (status IN (
    'DRAFT','SUBMITTED','UNDER_REVIEW','RETURNED','APPROVED','REJECTED'
  )),
  CONSTRAINT chk_dct_ccreimb_coding  CHECK (coding_type IN ('GL','PROJECT') OR coding_type IS NULL),
  CONSTRAINT fk_dct_ccreimb_cc       FOREIGN KEY (cc_id)
                                       REFERENCES prod.dct_credit_cards(cc_id),
  CONSTRAINT fk_dct_ccreimb_submitter FOREIGN KEY (submitted_by_user_id)
                                       REFERENCES prod.dct_users(user_id),
  CONSTRAINT fk_dct_ccreimb_owner    FOREIGN KEY (on_behalf_of_user_id)
                                       REFERENCES prod.dct_users(user_id),
  CONSTRAINT fk_dct_ccreimb_gl       FOREIGN KEY (cc_id_gl)
                                       REFERENCES prod.dct_gl_code_combinations(cc_id)
);

CREATE INDEX idx_dct_ccreimb_cc     ON prod.dct_cc_replenishments(cc_id);
CREATE INDEX idx_dct_ccreimb_period ON prod.dct_cc_replenishments(period_year, period_month);
CREATE INDEX idx_dct_ccreimb_status ON prod.dct_cc_replenishments(status);

COMMENT ON TABLE  prod.dct_cc_replenishments                IS 'Monthly credit card expense statement headers';
COMMENT ON COLUMN prod.dct_cc_replenishments.reimb_number   IS 'App-generated: CCM-YYYY-MM-NNNNN';
COMMENT ON COLUMN prod.dct_cc_replenishments.cc_id_gl       IS 'FK to DCT_GL_CODE_COMBINATIONS — header-level default GL coding';
COMMENT ON COLUMN prod.dct_cc_replenishments.coding_type    IS 'GL or PROJECT — applies to all lines unless overridden';

-- =============================================================================
-- 6. DCT_CC_REIMB_LINES — Monthly Expense Lines
-- =============================================================================
CREATE TABLE prod.dct_cc_reimb_lines (
  line_id              NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  replenishment_id     NUMBER          NOT NULL,
  line_num             NUMBER          NOT NULL,
  expense_date         DATE            NOT NULL,
  merchant_name        VARCHAR2(200)   NOT NULL,
  amount               NUMBER(15,2)    NOT NULL,
  description          VARCHAR2(500),
  -- Budget coding (defaulted from header, overridable)
  coding_type          VARCHAR2(10),
  cc_id_gl             NUMBER,
  project_number       VARCHAR2(50),
  task_number          VARCHAR2(50),
  expenditure_type     VARCHAR2(100),
  receipt_attached     CHAR(1)         DEFAULT 'N' NOT NULL,
  -- Constraints
  CONSTRAINT chk_dct_ccrl_amount      CHECK (amount > 0),
  CONSTRAINT chk_dct_ccrl_receipt     CHECK (receipt_attached IN ('Y','N')),
  CONSTRAINT chk_dct_ccrl_coding      CHECK (coding_type IN ('GL','PROJECT') OR coding_type IS NULL),
  CONSTRAINT fk_dct_ccrl_reimb        FOREIGN KEY (replenishment_id)
                                        REFERENCES prod.dct_cc_replenishments(replenishment_id)
                                        ON DELETE CASCADE,
  CONSTRAINT fk_dct_ccrl_gl          FOREIGN KEY (cc_id_gl)
                                        REFERENCES prod.dct_gl_code_combinations(cc_id)
);

CREATE INDEX idx_dct_ccrl_reimb ON prod.dct_cc_reimb_lines(replenishment_id);

COMMENT ON TABLE  prod.dct_cc_reimb_lines              IS 'Expense line items within a monthly credit card replenishment';
COMMENT ON COLUMN prod.dct_cc_reimb_lines.cc_id_gl     IS 'Defaulted from replenishment header, overridable per line';
COMMENT ON COLUMN prod.dct_cc_reimb_lines.coding_type  IS 'Defaulted from header — GL or PROJECT';
COMMENT ON COLUMN prod.dct_cc_reimb_lines.receipt_attached IS 'Y when at least one file is uploaded in DCT_CC_ATTACHMENTS for this line';

-- =============================================================================
-- 7. DCT_CC_PROXIES — Proxy Submitters for Replenishments
-- =============================================================================
CREATE TABLE prod.dct_cc_proxies (
  proxy_id             NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cc_id                NUMBER          NOT NULL,
  proxy_user_id        NUMBER          NOT NULL,
  is_active            CHAR(1)         DEFAULT 'Y' NOT NULL,
  start_date           DATE            NOT NULL,
  end_date             DATE,
  granted_by_user_id   NUMBER          NOT NULL,
  created_by           VARCHAR2(100),
  created_at           DATE            DEFAULT SYSDATE NOT NULL,
  updated_by           VARCHAR2(100),
  updated_at           DATE            DEFAULT SYSDATE NOT NULL,
  -- Constraints
  CONSTRAINT chk_dct_ccprx_active    CHECK (is_active IN ('Y','N')),
  CONSTRAINT chk_dct_ccprx_dates     CHECK (end_date IS NULL OR end_date >= start_date),
  CONSTRAINT fk_dct_ccprx_cc         FOREIGN KEY (cc_id)
                                       REFERENCES prod.dct_credit_cards(cc_id),
  CONSTRAINT fk_dct_ccprx_proxy      FOREIGN KEY (proxy_user_id)
                                       REFERENCES prod.dct_users(user_id),
  CONSTRAINT fk_dct_ccprx_granted    FOREIGN KEY (granted_by_user_id)
                                       REFERENCES prod.dct_users(user_id)
);

CREATE INDEX idx_dct_ccprx_cc    ON prod.dct_cc_proxies(cc_id, is_active);
CREATE INDEX idx_dct_ccprx_proxy ON prod.dct_cc_proxies(proxy_user_id, is_active);

COMMENT ON TABLE  prod.dct_cc_proxies                  IS 'Defines who may submit monthly replenishments on behalf of a card owner';
COMMENT ON COLUMN prod.dct_cc_proxies.end_date         IS 'NULL = no expiry — proxy is indefinite until deactivated';
COMMENT ON COLUMN prod.dct_cc_proxies.granted_by_user_id IS 'CC Admin who authorised this proxy assignment';

-- =============================================================================
-- 8. DCT_CC_CARD_LIMIT_HISTORY — Immutable audit trail of credit limit changes
-- =============================================================================
CREATE TABLE prod.dct_cc_card_limit_history (
  history_id           NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cc_id                NUMBER          NOT NULL,
  old_limit            NUMBER(15,2)    NOT NULL,
  new_limit            NUMBER(15,2)    NOT NULL,
  change_type          VARCHAR2(20)    NOT NULL,
  request_id           NUMBER,
  changed_at           DATE            DEFAULT SYSDATE NOT NULL,
  changed_by           VARCHAR2(100),
  notes                VARCHAR2(500),
  -- Constraints
  CONSTRAINT chk_dct_cclh_type        CHECK (change_type IN ('INITIAL','INCREASE','DECREASE')),
  CONSTRAINT chk_dct_cclh_old_limit   CHECK (old_limit >= 0),
  CONSTRAINT chk_dct_cclh_new_limit   CHECK (new_limit > 0),
  CONSTRAINT fk_dct_cclh_cc           FOREIGN KEY (cc_id)
                                        REFERENCES prod.dct_credit_cards(cc_id),
  CONSTRAINT fk_dct_cclh_request      FOREIGN KEY (request_id)
                                        REFERENCES prod.dct_cc_requests(request_id)
);

CREATE INDEX idx_dct_cclh_cc         ON prod.dct_cc_card_limit_history(cc_id, changed_at);
CREATE INDEX idx_dct_cclh_request    ON prod.dct_cc_card_limit_history(request_id);

COMMENT ON TABLE  prod.dct_cc_card_limit_history              IS 'Immutable audit trail of every credit limit change per card';
COMMENT ON COLUMN prod.dct_cc_card_limit_history.change_type  IS 'INITIAL = first recorded limit on card issuance; INCREASE/DECREASE = limit change request approved';
COMMENT ON COLUMN prod.dct_cc_card_limit_history.request_id   IS 'NULL for INITIAL entries; FK to DCT_CC_REQUESTS for INCREASE/DECREASE';
COMMENT ON COLUMN prod.dct_cc_card_limit_history.old_limit    IS '0 for INITIAL entries (no prior limit)';
COMMENT ON COLUMN prod.dct_cc_card_limit_history.changed_by   IS 'APEX APP_USER of the CC admin who approved/applied the change';

-- =============================================================================
-- UPDATED_AT TRIGGERS
-- =============================================================================
CREATE OR REPLACE TRIGGER prod.trg_dct_credit_cards_upd
  BEFORE UPDATE ON prod.dct_credit_cards
  FOR EACH ROW
BEGIN :NEW.updated_at := SYSDATE; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_cc_requests_upd
  BEFORE UPDATE ON prod.dct_cc_requests
  FOR EACH ROW
BEGIN :NEW.updated_at := SYSDATE; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_cc_doc_req_upd
  BEFORE UPDATE ON prod.dct_cc_doc_requirements
  FOR EACH ROW
BEGIN :NEW.updated_at := SYSDATE; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_cc_replenishments_upd
  BEFORE UPDATE ON prod.dct_cc_replenishments
  FOR EACH ROW
BEGIN :NEW.updated_at := SYSDATE; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_cc_proxies_upd
  BEFORE UPDATE ON prod.dct_cc_proxies
  FOR EACH ROW
BEGIN :NEW.updated_at := SYSDATE; END;
/

COMMIT;

PROMPT
PROMPT === 01_cc_ddl.sql complete ===
PROMPT Tables created: DCT_CREDIT_CARDS, DCT_CC_REQUESTS, DCT_CC_DOC_REQUIREMENTS,
PROMPT                  DCT_CC_ATTACHMENTS, DCT_CC_REPLENISHMENTS,
PROMPT                  DCT_CC_REIMB_LINES, DCT_CC_PROXIES, DCT_CC_CARD_LIMIT_HISTORY
PROMPT Note: Approver delegation uses shared V2 DCT_DELEGATIONS (scope=MODULE)
