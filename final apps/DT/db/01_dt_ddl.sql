-- =============================================================================
-- Duty Travel Module (App 204) — DDL
-- File    : 01_dt_ddl.sql
-- Schema  : PROD
-- Run     : After db/v2/install.sql
-- Requires: V2 shared framework (DCT_USERS, DCT_ORGANIZATIONS,
--           DCT_GL_CODE_COMBINATIONS, DCT_LOOKUP_VALUES)
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
             'DT_SETTLEMENT_LINES',
             'DT_SETTLEMENT',
             'DT_DOCUMENTS',
             'DT_DOC_REQUIREMENTS',
             'DT_DESTINATIONS',
             'DT_REQUESTS',
             'DT_COUNTRY_GROUPS',
             'DT_PER_DIEM_RATES'
           )
  ) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE prod.' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
    DBMS_OUTPUT.PUT_LINE('Dropped: ' || t.table_name);
  END LOOP;
END;
/

BEGIN
  FOR s IN (
    SELECT sequence_name FROM all_sequences
    WHERE  sequence_owner = 'PROD'
    AND    sequence_name IN ('SEQ_DT_REQUEST_NUMBER','SEQ_DT_SETTLEMENT_NUMBER')
  ) LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE prod.' || s.sequence_name;
    DBMS_OUTPUT.PUT_LINE('Dropped sequence: ' || s.sequence_name);
  END LOOP;
END;
/

-- =============================================================================
-- SEQUENCES
-- =============================================================================
CREATE SEQUENCE prod.seq_dt_request_number    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE prod.seq_dt_settlement_number START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- =============================================================================
-- 1. DT_PER_DIEM_RATES — Per diem rate master
--    rate_key meaning depends on RATE_STRUCTURE module setting:
--      PER_COUNTRY  → ISO alpha-2 country code (e.g. GB, AE)
--      TIER_BASED   → tier code (e.g. TIER1, TIER2)
--      REGION_BASED → region code (e.g. EUROPE, GCC)
-- =============================================================================
CREATE TABLE prod.dt_per_diem_rates (
    rate_id              NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rate_key             VARCHAR2(20)    NOT NULL,
    rate_key_name_en     VARCHAR2(100)   NOT NULL,
    rate_key_name_ar     VARCHAR2(100),
    grade_code           VARCHAR2(20)    NOT NULL,
    per_diem_daily_aed   NUMBER(15,2)    NOT NULL,
    effective_from       DATE            NOT NULL,
    effective_to         DATE,
    is_active            VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    notes                VARCHAR2(1000),
    created_by           VARCHAR2(100),
    created_at           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by           VARCHAR2(100),
    updated_at           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dt_rate_key    UNIQUE (rate_key, grade_code, effective_from),
    CONSTRAINT chk_dt_rate_act   CHECK (is_active IN ('Y','N')),
    CONSTRAINT chk_dt_rate_amt   CHECK (per_diem_daily_aed > 0),
    CONSTRAINT chk_dt_rate_dates CHECK (effective_to IS NULL OR effective_to >= effective_from)
);

COMMENT ON TABLE  prod.dt_per_diem_rates IS 'Per diem rate master — rate_key is country/tier/region code depending on RATE_STRUCTURE setting';
COMMENT ON COLUMN prod.dt_per_diem_rates.rate_key           IS 'ISO country code, tier code, or region code — see RATE_STRUCTURE module setting';
COMMENT ON COLUMN prod.dt_per_diem_rates.grade_code         IS 'DT_EMPLOYEE_GRADE lookup value; ALL = applies to all grades (fallback)';
COMMENT ON COLUMN prod.dt_per_diem_rates.per_diem_daily_aed IS 'All-in-one daily allowance covering meals and subsistence';

CREATE INDEX ix_dt_rate_key    ON prod.dt_per_diem_rates(rate_key, grade_code);
CREATE INDEX ix_dt_rate_active ON prod.dt_per_diem_rates(is_active, effective_from, effective_to);

-- =============================================================================
-- 2. DT_COUNTRY_GROUPS — Country to tier/region mapping
--    Used only when RATE_STRUCTURE = TIER_BASED or REGION_BASED.
-- =============================================================================
CREATE TABLE prod.dt_country_groups (
    country_code     VARCHAR2(3)     NOT NULL,
    country_name_en  VARCHAR2(100)   NOT NULL,
    country_name_ar  VARCHAR2(100),
    group_code       VARCHAR2(20)    NOT NULL,
    is_active        VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    created_by       VARCHAR2(100),
    created_at       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by       VARCHAR2(100),
    updated_at       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT pk_dt_country_groups  PRIMARY KEY (country_code),
    CONSTRAINT chk_dt_cgrp_active    CHECK (is_active IN ('Y','N'))
);

COMMENT ON TABLE  prod.dt_country_groups IS 'Maps ISO country codes to tier or region group codes — used when RATE_STRUCTURE != PER_COUNTRY';
COMMENT ON COLUMN prod.dt_country_groups.group_code IS 'Must match a rate_key in DT_PER_DIEM_RATES (validated by DCT_DT_PKG)';

CREATE INDEX ix_dt_cgrp_group ON prod.dt_country_groups(group_code, is_active);

-- =============================================================================
-- 3. DT_REQUESTS — Master travel request
-- =============================================================================
CREATE TABLE prod.dt_requests (
    request_id               NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    request_number           VARCHAR2(50)    NOT NULL,
    employee_user_id         NUMBER          NOT NULL,
    employee_grade_code      VARCHAR2(20)    NOT NULL,
    org_id                   NUMBER          NOT NULL,
    mission_type             VARCHAR2(20)    NOT NULL,
    trip_type                VARCHAR2(10)    NOT NULL,
    purpose                  VARCHAR2(1000)  NOT NULL,
    hosted_by                VARCHAR2(200),
    departure_date           DATE            NOT NULL,
    return_date              DATE            NOT NULL,
    total_days               NUMBER GENERATED ALWAYS AS (return_date - departure_date + 1) VIRTUAL,
    -- Calculated by DCT_DT_PKG.CALC_PER_DIEM — read-only to end users
    total_per_diem_aed       NUMBER(15,2)    DEFAULT 0 NOT NULL,
    total_advance_aed        NUMBER(15,2)    DEFAULT 0 NOT NULL,
    -- Optional allowance fields — shown/hidden by module settings
    ticket_amount_aed        NUMBER(15,2)    DEFAULT 0 NOT NULL,
    accommodation_amount_aed NUMBER(15,2)    DEFAULT 0 NOT NULL,
    visa_fees_aed            NUMBER(15,2)    DEFAULT 0 NOT NULL,
    local_transport_aed      NUMBER(15,2)    DEFAULT 0 NOT NULL,
    other_allowances_aed     NUMBER(15,2)    DEFAULT 0 NOT NULL,
    -- Budget coding
    budget_type              VARCHAR2(10)    NOT NULL,
    cc_id_gl                 NUMBER,
    project_number           VARCHAR2(50),
    task_number              VARCHAR2(50),
    expenditure_type         VARCHAR2(100),
    -- Lifecycle
    status                   VARCHAR2(25)    DEFAULT 'DRAFT' NOT NULL,
    approval_instance_id     NUMBER,
    finance_disbursed_yn     VARCHAR2(1)     DEFAULT 'N' NOT NULL,
    disbursed_date           DATE,
    disbursed_by_user_id     NUMBER,
    closed_date              DATE,
    closed_by_user_id        NUMBER,
    notes                    VARCHAR2(4000),
    created_by               VARCHAR2(100),
    created_at               TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by               VARCHAR2(100),
    updated_at               TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dt_req_number   UNIQUE (request_number),
    CONSTRAINT chk_dt_req_mtype   CHECK (mission_type IN ('BUSINESS_MISSION','TRAINING')),
    CONSTRAINT chk_dt_req_ttype   CHECK (trip_type IN ('INTERNAL','EXTERNAL')),
    CONSTRAINT chk_dt_req_budget  CHECK (budget_type IN ('GL','PROJECT')),
    CONSTRAINT chk_dt_req_status  CHECK (status IN (
        'DRAFT','SUBMITTED','APPROVED','ADVANCE_PAID','TRAVELLED','CLOSED',
        'REJECTED','RETURNED','CANCELLED'
    )),
    CONSTRAINT chk_dt_req_disbyn  CHECK (finance_disbursed_yn IN ('Y','N')),
    CONSTRAINT chk_dt_req_dates   CHECK (return_date >= departure_date),
    CONSTRAINT chk_dt_req_pdiem   CHECK (total_per_diem_aed >= 0),
    CONSTRAINT chk_dt_req_adv     CHECK (total_advance_aed >= 0),
    CONSTRAINT fk_dt_req_emp      FOREIGN KEY (employee_user_id)     REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dt_req_org      FOREIGN KEY (org_id)               REFERENCES prod.dct_organizations(org_id),
    CONSTRAINT fk_dt_req_gl       FOREIGN KEY (cc_id_gl)             REFERENCES prod.dct_gl_code_combinations(cc_id),
    CONSTRAINT fk_dt_req_disb     FOREIGN KEY (disbursed_by_user_id) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dt_req_closed   FOREIGN KEY (closed_by_user_id)    REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE  prod.dt_requests IS 'Master duty travel request — one per employee per trip';
COMMENT ON COLUMN prod.dt_requests.request_number       IS 'Generated by DCT_DT_PKG using REQUEST_NUMBER_PREFIX module setting';
COMMENT ON COLUMN prod.dt_requests.employee_grade_code  IS 'Snapped from employee profile at request creation — used for per diem rate lookup';
COMMENT ON COLUMN prod.dt_requests.total_per_diem_aed   IS 'Sum of per_diem_total_aed across all DT_DESTINATIONS — set by CALC_PER_DIEM';
COMMENT ON COLUMN prod.dt_requests.total_advance_aed    IS 'total_per_diem_aed + enabled allowances — set by CALC_PER_DIEM';
COMMENT ON COLUMN prod.dt_requests.ticket_amount_aed    IS 'Included only when INCLUDE_TICKET_ALLOWANCE = Y';
COMMENT ON COLUMN prod.dt_requests.accommodation_amount_aed IS 'Included only when INCLUDE_ACCOMMODATION_ALLOWANCE = Y';
COMMENT ON COLUMN prod.dt_requests.visa_fees_aed        IS 'Included only when INCLUDE_VISA_ALLOWANCE = Y';
COMMENT ON COLUMN prod.dt_requests.local_transport_aed  IS 'Included only when INCLUDE_LOCAL_TRANSPORT_ALLOWANCE = Y';

CREATE INDEX ix_dt_req_emp    ON prod.dt_requests(employee_user_id);
CREATE INDEX ix_dt_req_org    ON prod.dt_requests(org_id);
CREATE INDEX ix_dt_req_status ON prod.dt_requests(status);
CREATE INDEX ix_dt_req_dates  ON prod.dt_requests(departure_date, return_date);

-- =============================================================================
-- 4. DT_DESTINATIONS — Destination legs within a trip
-- =============================================================================
CREATE TABLE prod.dt_destinations (
    destination_id           NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    request_id               NUMBER          NOT NULL,
    seq_num                  NUMBER          NOT NULL,
    country_code             VARCHAR2(3)     NOT NULL,
    city                     VARCHAR2(100)   NOT NULL,
    arrival_date             DATE            NOT NULL,
    departure_date           DATE            NOT NULL,
    duration_days            NUMBER GENERATED ALWAYS AS (departure_date - arrival_date + 1) VIRTUAL,
    -- Rate snapshot — set by DCT_DT_PKG.CALC_PER_DIEM
    rate_id                  NUMBER,
    per_diem_daily_rate_aed  NUMBER(15,2)    DEFAULT 0 NOT NULL,
    per_diem_total_aed       NUMBER(15,2)    DEFAULT 0 NOT NULL,
    notes                    VARCHAR2(1000),
    created_at               TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at               TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dt_dest_seq     UNIQUE (request_id, seq_num),
    CONSTRAINT chk_dt_dest_dates  CHECK (departure_date >= arrival_date),
    CONSTRAINT chk_dt_dest_rate   CHECK (per_diem_daily_rate_aed >= 0),
    CONSTRAINT fk_dt_dest_req     FOREIGN KEY (request_id) REFERENCES prod.dt_requests(request_id) ON DELETE CASCADE,
    CONSTRAINT fk_dt_dest_rate    FOREIGN KEY (rate_id)    REFERENCES prod.dt_per_diem_rates(rate_id)
);

COMMENT ON TABLE  prod.dt_destinations IS 'Individual destination legs within a single travel request';
COMMENT ON COLUMN prod.dt_destinations.country_code             IS 'ISO alpha-2; AE = internal UAE destination';
COMMENT ON COLUMN prod.dt_destinations.rate_id                  IS 'FK to rate used at calc time — NULL if no matching rate found';
COMMENT ON COLUMN prod.dt_destinations.per_diem_daily_rate_aed  IS 'Rate snapped at calc time — unaffected by later rate changes';
COMMENT ON COLUMN prod.dt_destinations.per_diem_total_aed       IS 'duration_days x per_diem_daily_rate_aed, adjusted by half-day policy';

CREATE INDEX ix_dt_dest_req ON prod.dt_destinations(request_id);

-- =============================================================================
-- 5. DT_DOC_REQUIREMENTS — Required document types per mission/direction
-- =============================================================================
CREATE TABLE prod.dt_doc_requirements (
    doc_req_id           NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    mission_type         VARCHAR2(20)    NOT NULL,
    trip_type            VARCHAR2(10)    NOT NULL,
    document_type_id     NUMBER          NOT NULL,
    is_mandatory         VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    applies_to_source    VARCHAR2(20)    DEFAULT 'REQUEST' NOT NULL,
    is_active            VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    display_seq          NUMBER          DEFAULT 99 NOT NULL,
    created_by           VARCHAR2(100),
    created_at           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by           VARCHAR2(100),
    updated_at           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dt_docreq_mtype  CHECK (mission_type IN ('BUSINESS_MISSION','TRAINING','ALL')),
    CONSTRAINT chk_dt_docreq_ttype  CHECK (trip_type IN ('INTERNAL','EXTERNAL','ALL')),
    CONSTRAINT chk_dt_docreq_mand   CHECK (is_mandatory IN ('Y','N')),
    CONSTRAINT chk_dt_docreq_src    CHECK (applies_to_source IN ('REQUEST','SETTLEMENT','BOTH')),
    CONSTRAINT chk_dt_docreq_act    CHECK (is_active IN ('Y','N'))
);

COMMENT ON TABLE  prod.dt_doc_requirements IS 'Admin-configured required document types per mission type and trip direction';
COMMENT ON COLUMN prod.dt_doc_requirements.applies_to_source IS 'REQUEST = request submission; SETTLEMENT = settlement submission; BOTH = both';

CREATE INDEX ix_dt_docreq_lookup ON prod.dt_doc_requirements(mission_type, trip_direction, is_active);

-- =============================================================================
-- 6. DT_DOCUMENTS — Supporting documents (requests + settlements)
-- =============================================================================
CREATE TABLE prod.dt_documents (
    document_id          NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_type          VARCHAR2(20)    NOT NULL,
    source_id            NUMBER          NOT NULL,
    document_type_id     NUMBER          NOT NULL,
    document_name        VARCHAR2(200)   NOT NULL,
    file_mime_type       VARCHAR2(100),
    file_size            NUMBER,
    file_blob            BLOB,
    is_required          VARCHAR2(1)     DEFAULT 'N' NOT NULL,
    notes                VARCHAR2(500),
    uploaded_by          NUMBER          NOT NULL,
    uploaded_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dt_doc_srctype CHECK (source_type IN ('REQUEST','SETTLEMENT')),
    CONSTRAINT chk_dt_doc_req     CHECK (is_required IN ('Y','N')),
    CONSTRAINT fk_dt_doc_upd_by   FOREIGN KEY (uploaded_by) REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE  prod.dt_documents IS 'Unified document store — source_type + source_id identifies parent record';
COMMENT ON COLUMN prod.dt_documents.is_required IS 'Copied from DT_DOC_REQUIREMENTS at upload time';

CREATE INDEX ix_dt_doc_src ON prod.dt_documents(source_type, source_id);

-- =============================================================================
-- 7. DT_SETTLEMENT — Post-travel settlement header (one per request)
-- =============================================================================
CREATE TABLE prod.dt_settlement (
    settlement_id            NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    settlement_number        VARCHAR2(50)    NOT NULL,
    request_id               NUMBER          NOT NULL,
    employee_user_id         NUMBER          NOT NULL,
    actual_return_date       DATE            NOT NULL,
    actual_per_diem_days     NUMBER          NOT NULL,
    total_actual_aed         NUMBER(15,2)    DEFAULT 0 NOT NULL,
    advance_paid_aed         NUMBER(15,2)    NOT NULL,
    difference_aed           NUMBER(15,2)    GENERATED ALWAYS AS (total_actual_aed - advance_paid_aed) VIRTUAL,
    settlement_type          VARCHAR2(25)    GENERATED ALWAYS AS (
                               CASE
                                 WHEN total_actual_aed > advance_paid_aed THEN 'ADDITIONAL_PAYMENT'
                                 WHEN total_actual_aed < advance_paid_aed THEN 'REFUND'
                                 ELSE 'BALANCED'
                               END
                             ) VIRTUAL,
    employee_notes           VARCHAR2(4000),
    finance_notes            VARCHAR2(4000),
    status                   VARCHAR2(20)    DEFAULT 'DRAFT' NOT NULL,
    approval_instance_id     NUMBER,
    refund_collected_yn      VARCHAR2(1)     DEFAULT 'N' NOT NULL,
    refund_collected_date    DATE,
    additional_payment_ref   VARCHAR2(100),
    additional_payment_date  DATE,
    created_by               VARCHAR2(100),
    created_at               TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by               VARCHAR2(100),
    updated_at               TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dt_stl_number   UNIQUE (settlement_number),
    CONSTRAINT uq_dt_stl_request  UNIQUE (request_id),
    CONSTRAINT chk_dt_stl_status  CHECK (status IN ('DRAFT','SUBMITTED','APPROVED','REJECTED','RETURNED')),
    CONSTRAINT chk_dt_stl_refund  CHECK (refund_collected_yn IN ('Y','N')),
    CONSTRAINT chk_dt_stl_days    CHECK (actual_per_diem_days > 0),
    CONSTRAINT chk_dt_stl_actual  CHECK (total_actual_aed >= 0),
    CONSTRAINT fk_dt_stl_req      FOREIGN KEY (request_id)       REFERENCES prod.dt_requests(request_id),
    CONSTRAINT fk_dt_stl_emp      FOREIGN KEY (employee_user_id) REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE  prod.dt_settlement IS 'Post-travel settlement — at most one per request; created only when SETTLEMENT_REQUIRED = Y or voluntarily';
COMMENT ON COLUMN prod.dt_settlement.settlement_number  IS 'Generated by DCT_DT_PKG using SETTLEMENT_NUMBER_PREFIX module setting';
COMMENT ON COLUMN prod.dt_settlement.advance_paid_aed   IS 'Snapshot of request.total_advance_aed at settlement creation time';
COMMENT ON COLUMN prod.dt_settlement.difference_aed     IS 'Positive = owed to employee (additional payment); negative = refund due';

CREATE INDEX ix_dt_stl_req    ON prod.dt_settlement(request_id);
CREATE INDEX ix_dt_stl_emp    ON prod.dt_settlement(employee_user_id);
CREATE INDEX ix_dt_stl_status ON prod.dt_settlement(status);

-- =============================================================================
-- 8. DT_SETTLEMENT_LINES — Itemised actual expenses per settlement
-- =============================================================================
CREATE TABLE prod.dt_settlement_lines (
    line_id              NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    settlement_id        NUMBER          NOT NULL,
    line_num             NUMBER          NOT NULL,
    expense_category     VARCHAR2(30)    NOT NULL,
    description          VARCHAR2(500),
    amount_aed           NUMBER(15,2)    NOT NULL,
    receipt_attached     VARCHAR2(1)     DEFAULT 'N' NOT NULL,
    notes                VARCHAR2(500),
    --
    CONSTRAINT uq_dt_stll_num   UNIQUE (settlement_id, line_num),
    CONSTRAINT chk_dt_stll_cat  CHECK (expense_category IN (
        'PER_DIEM','ACCOMMODATION','TICKET','VISA','LOCAL_TRANSPORT','OTHER'
    )),
    CONSTRAINT chk_dt_stll_amt  CHECK (amount_aed >= 0),
    CONSTRAINT chk_dt_stll_rcpt CHECK (receipt_attached IN ('Y','N')),
    CONSTRAINT fk_dt_stll_stl   FOREIGN KEY (settlement_id)
                                  REFERENCES prod.dt_settlement(settlement_id)
                                  ON DELETE CASCADE
);

COMMENT ON TABLE  prod.dt_settlement_lines IS 'Itemised actual expenses within a settlement — must sum to dt_settlement.total_actual_aed';
COMMENT ON COLUMN prod.dt_settlement_lines.receipt_attached IS 'Y when a file is uploaded in DT_DOCUMENTS for this settlement';

CREATE INDEX ix_dt_stll_stl ON prod.dt_settlement_lines(settlement_id);

-- =============================================================================
-- UPDATED_AT TRIGGERS
-- =============================================================================
CREATE OR REPLACE TRIGGER prod.trg_dt_rates_upd
    BEFORE UPDATE ON prod.dt_per_diem_rates
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dt_cgrp_upd
    BEFORE UPDATE ON prod.dt_country_groups
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dt_req_upd
    BEFORE UPDATE ON prod.dt_requests
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dt_dest_upd
    BEFORE UPDATE ON prod.dt_destinations
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dt_docreq_upd
    BEFORE UPDATE ON prod.dt_doc_requirements
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dt_stl_upd
    BEFORE UPDATE ON prod.dt_settlement
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

COMMIT;

PROMPT
PROMPT === 01_dt_ddl.sql complete ===
PROMPT Sequences : SEQ_DT_REQUEST_NUMBER, SEQ_DT_SETTLEMENT_NUMBER
PROMPT Tables    : DT_PER_DIEM_RATES, DT_COUNTRY_GROUPS,
PROMPT             DT_REQUESTS, DT_DESTINATIONS,
PROMPT             DT_DOC_REQUIREMENTS, DT_DOCUMENTS,
PROMPT             DT_SETTLEMENT, DT_SETTLEMENT_LINES
PROMPT Triggers  : 6 updated_at triggers
