-- =============================================================================
-- Freelancers Module (App 203) — DDL
-- File    : 01_fl_ddl.sql
-- Schema  : PROD
-- Run     : After db/v2/install.sql
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- NOTE: DCT_NATIONALITY is owned by the V2 Admin module (db/v2/01_dct_ddl.sql).
--       It is seeded in db/v2/04_dct_seed.sql (section 11).
--       Drop it there only if doing a full platform reinstall.

-- =============================================================================
-- 1. DCT_FL_REGISTRATIONS — Pre-approval registration request
-- =============================================================================
CREATE TABLE prod.dct_fl_registrations (
    registration_id     NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    registration_number VARCHAR2(50)    NOT NULL,
    first_name_en       VARCHAR2(100)   NOT NULL,
    last_name_en        VARCHAR2(100)   NOT NULL,
    first_name_ar       VARCHAR2(100),
    last_name_ar        VARCHAR2(100),
    date_of_birth       DATE            NOT NULL,
    nationality_code    VARCHAR2(3)     NOT NULL,
    national_id         VARCHAR2(50),
    passport_number     VARCHAR2(50),
    email               VARCHAR2(200)   NOT NULL,
    mobile              VARCHAR2(20),
    specialization      VARCHAR2(200),
    photo_mime_type     VARCHAR2(100),
    photo_filename      VARCHAR2(200),
    photo_blob          BLOB,
    first_deal_with_dct VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    submitted_by        VARCHAR2(10)    DEFAULT 'SELF' NOT NULL,
    submitted_by_user_id NUMBER,
    status              VARCHAR2(20)    DEFAULT 'DRAFT' NOT NULL,
    approval_instance_id NUMBER,
    notes               VARCHAR2(4000),
    created_by          NUMBER,
    created_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by          NUMBER,
    updated_at          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_fl_reg_number  UNIQUE (registration_number),
    CONSTRAINT chk_dct_fl_reg_status CHECK (status IN ('DRAFT','SUBMITTED','APPROVED','REJECTED','RETURNED')),
    CONSTRAINT chk_dct_fl_reg_subby  CHECK (submitted_by IN ('SELF','STAFF')),
    CONSTRAINT chk_dct_fl_reg_deal   CHECK (first_deal_with_dct IN ('Y','N')),
    CONSTRAINT fk_dct_fl_reg_nat     FOREIGN KEY (nationality_code) REFERENCES prod.dct_nationality(nationality_code),
    CONSTRAINT fk_dct_fl_reg_subuser FOREIGN KEY (submitted_by_user_id) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dct_fl_reg_cby     FOREIGN KEY (created_by) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dct_fl_reg_uby     FOREIGN KEY (updated_by) REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE  prod.dct_fl_registrations IS 'Freelancer registration request — created before profile is approved';
COMMENT ON COLUMN prod.dct_fl_registrations.national_id IS 'Required when nationality_code = AE (validated in PL/SQL)';

CREATE INDEX ix_dct_fl_reg_status  ON prod.dct_fl_registrations(status);
CREATE INDEX ix_dct_fl_reg_email   ON prod.dct_fl_registrations(email);
CREATE INDEX ix_dct_fl_reg_natcode ON prod.dct_fl_registrations(nationality_code);

-- =============================================================================
-- 2. DCT_FL_FREELANCERS — Approved freelancer profile
-- =============================================================================
CREATE TABLE prod.dct_fl_freelancers (
    freelancer_id     NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    registration_id   NUMBER          NOT NULL,
    vendor_number     VARCHAR2(50),
    first_name_en     VARCHAR2(100)   NOT NULL,
    last_name_en      VARCHAR2(100)   NOT NULL,
    first_name_ar     VARCHAR2(100),
    last_name_ar      VARCHAR2(100),
    date_of_birth     DATE,
    nationality_code  VARCHAR2(3),
    national_id       VARCHAR2(50),
    passport_number   VARCHAR2(50),
    email             VARCHAR2(200)   NOT NULL,
    mobile            VARCHAR2(20),
    specialization    VARCHAR2(200),
    photo_mime_type   VARCHAR2(100),
    photo_filename    VARCHAR2(200),
    photo_blob        BLOB,
    status            VARCHAR2(20)    DEFAULT 'ACTIVE' NOT NULL,
    blacklist_reason  VARCHAR2(1000),
    notes             VARCHAR2(4000),
    created_by        NUMBER,
    created_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by        NUMBER,
    updated_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_fl_frl_email   UNIQUE (email),
    CONSTRAINT uq_dct_fl_vendor_num  UNIQUE (vendor_number),
    CONSTRAINT chk_dct_fl_frl_status CHECK (status IN ('ACTIVE','INACTIVE','BLACKLISTED')),
    CONSTRAINT chk_dct_fl_frl_nat    CHECK (nationality_code IS NULL OR LENGTH(nationality_code) BETWEEN 2 AND 3),
    CONSTRAINT fk_dct_fl_frl_reg     FOREIGN KEY (registration_id) REFERENCES prod.dct_fl_registrations(registration_id),
    CONSTRAINT fk_dct_fl_frl_nat     FOREIGN KEY (nationality_code) REFERENCES prod.dct_nationality(nationality_code),
    CONSTRAINT fk_dct_fl_frl_cby     FOREIGN KEY (created_by) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dct_fl_frl_uby     FOREIGN KEY (updated_by) REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE  prod.dct_fl_freelancers IS 'Approved freelancer profile — auto-created on registration approval';
COMMENT ON COLUMN prod.dct_fl_freelancers.email IS 'Used for self-service portal login';

CREATE INDEX ix_dct_fl_frl_status ON prod.dct_fl_freelancers(status);
-- ix_dct_fl_frl_email omitted: uq_dct_fl_frl_email unique constraint already indexes email

-- =============================================================================
-- 3. DCT_FL_BANK_ACCOUNTS
-- =============================================================================
CREATE TABLE prod.dct_fl_bank_accounts (
    bank_account_id   NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    freelancer_id     NUMBER          NOT NULL,
    bank_name         VARCHAR2(100)   NOT NULL,
    account_number    VARCHAR2(50)    NOT NULL,
    iban              VARCHAR2(34),
    account_name      VARCHAR2(200)   NOT NULL,
    currency_code     VARCHAR2(3)     DEFAULT 'AED' NOT NULL,
    is_primary        VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    is_active         VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    notes             VARCHAR2(1000),
    created_by        NUMBER,
    created_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by        NUMBER,
    updated_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_fl_ba_primary CHECK (is_primary IN ('Y','N')),
    CONSTRAINT chk_dct_fl_ba_active  CHECK (is_active IN ('Y','N')),
    CONSTRAINT fk_dct_fl_ba_frl      FOREIGN KEY (freelancer_id) REFERENCES prod.dct_fl_freelancers(freelancer_id),
    CONSTRAINT fk_dct_fl_ba_cby      FOREIGN KEY (created_by) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dct_fl_ba_uby      FOREIGN KEY (updated_by) REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE prod.dct_fl_bank_accounts IS 'Freelancer bank accounts — one primary per freelancer';

CREATE INDEX ix_dct_fl_ba_frl ON prod.dct_fl_bank_accounts(freelancer_id, is_active);

-- =============================================================================
-- 4. DCT_FL_DOCUMENTS — Unified document store for all FL functions
-- =============================================================================
CREATE TABLE prod.dct_fl_documents (
    document_id       NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    freelancer_id     NUMBER,
    source_type       VARCHAR2(20)    NOT NULL,
    source_id         NUMBER          NOT NULL,
    document_type_id  NUMBER          NOT NULL,
    document_name     VARCHAR2(200)   NOT NULL,
    file_mime_type    VARCHAR2(100),
    file_size         NUMBER,
    file_blob         BLOB,
    expiry_date       DATE,
    alert_days_before NUMBER,
    is_required       VARCHAR2(1)     DEFAULT 'N' NOT NULL,
    status            VARCHAR2(20)    DEFAULT 'ACTIVE' NOT NULL,
    notes             VARCHAR2(1000),
    created_by        NUMBER,
    created_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by        NUMBER,
    updated_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_fl_doc_srctype CHECK (source_type IN ('REGISTRATION','FREELANCER','CONTRACT','DELIVERABLE','VOUCHER')),
    CONSTRAINT chk_dct_fl_doc_req     CHECK (is_required IN ('Y','N')),
    CONSTRAINT chk_dct_fl_doc_status  CHECK (status IN ('ACTIVE','SUPERSEDED')),
    CONSTRAINT fk_dct_fl_doc_frl      FOREIGN KEY (freelancer_id) REFERENCES prod.dct_fl_freelancers(freelancer_id),
    CONSTRAINT fk_dct_fl_doc_cby      FOREIGN KEY (created_by) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dct_fl_doc_uby      FOREIGN KEY (updated_by) REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE  prod.dct_fl_documents IS 'Unified document store — source_type + source_id identifies parent record';
COMMENT ON COLUMN prod.dct_fl_documents.alert_days_before IS 'Set from DOC_EXPIRY_ALERT_DAYS module setting on insert';

CREATE INDEX ix_dct_fl_doc_src    ON prod.dct_fl_documents(source_type, source_id);
CREATE INDEX ix_dct_fl_doc_frl    ON prod.dct_fl_documents(freelancer_id);
CREATE INDEX ix_dct_fl_doc_expiry ON prod.dct_fl_documents(expiry_date);

-- =============================================================================
-- 5. DCT_FL_CONTRACTS
-- =============================================================================
CREATE TABLE prod.dct_fl_contracts (
    contract_id               NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    contract_number           VARCHAR2(50)    NOT NULL,
    version_number            NUMBER          DEFAULT 1 NOT NULL,
    freelancer_id             NUMBER          NOT NULL,
    renewed_from_contract_id  NUMBER,
    title                     VARCHAR2(200)   NOT NULL,
    start_date                DATE            NOT NULL,
    end_date                  DATE,
    total_amount              NUMBER(15,2)    NOT NULL,
    currency_code             VARCHAR2(3)     DEFAULT 'AED' NOT NULL,
    billing_method            VARCHAR2(20)    NOT NULL,
    billing_unit_id           NUMBER,
    billing_unit_amount       NUMBER(15,2),
    org_id                    NUMBER          NOT NULL,
    coding_type               VARCHAR2(10)    NOT NULL,
    cc_id_gl                  NUMBER,
    project_number            VARCHAR2(50),
    task_number               VARCHAR2(50),
    expenditure_type          VARCHAR2(100),
    status                    VARCHAR2(20)    DEFAULT 'DRAFT' NOT NULL,
    approval_instance_id      NUMBER,
    notes                     VARCHAR2(4000),
    created_by                NUMBER,
    created_at                TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by                NUMBER,
    updated_at                TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_fl_con_number  UNIQUE (contract_number),
    CONSTRAINT chk_dct_fl_con_bill   CHECK (billing_method IN ('WEEKLY','MONTHLY','PER_COUNT')),
    CONSTRAINT chk_dct_fl_con_coding CHECK (coding_type IN ('GL','PROJECT')),
    CONSTRAINT chk_dct_fl_con_status CHECK (status IN ('DRAFT','SUBMITTED','APPROVED','ACTIVE','COMPLETED','CANCELLED')),
    CONSTRAINT chk_dct_fl_con_dates  CHECK (end_date IS NULL OR end_date > start_date),
    CONSTRAINT fk_dct_fl_con_frl     FOREIGN KEY (freelancer_id) REFERENCES prod.dct_fl_freelancers(freelancer_id),
    CONSTRAINT fk_dct_fl_con_parent  FOREIGN KEY (renewed_from_contract_id) REFERENCES prod.dct_fl_contracts(contract_id),
    CONSTRAINT fk_dct_fl_con_org     FOREIGN KEY (org_id) REFERENCES prod.dct_organizations(org_id),
    CONSTRAINT fk_dct_fl_con_cby     FOREIGN KEY (created_by) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dct_fl_con_uby     FOREIGN KEY (updated_by) REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE  prod.dct_fl_contracts IS 'Freelancer contracts — versioned; payment schedule auto-generated on approval';
COMMENT ON COLUMN prod.dct_fl_contracts.version_number IS 'Increments on each direct edit when ALLOW_DIRECT_CONTRACT_EDIT = Y';
COMMENT ON COLUMN prod.dct_fl_contracts.renewed_from_contract_id IS 'NULL for original contracts; populated when created via renewal';

CREATE INDEX ix_dct_fl_con_frl    ON prod.dct_fl_contracts(freelancer_id);
CREATE INDEX ix_dct_fl_con_status ON prod.dct_fl_contracts(status);
CREATE INDEX ix_dct_fl_con_org    ON prod.dct_fl_contracts(org_id);

-- =============================================================================
-- 6. DCT_FL_CONTRACT_AMENDMENTS
-- =============================================================================
CREATE TABLE prod.dct_fl_contract_amendments (
    amendment_id         NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    contract_id          NUMBER          NOT NULL,
    amendment_number     NUMBER          NOT NULL,
    reason               VARCHAR2(1000)  NOT NULL,
    change_summary       VARCHAR2(4000),
    new_total_amount     NUMBER(15,2),
    new_start_date       DATE,
    new_end_date         DATE,
    new_billing_method   VARCHAR2(20),
    status               VARCHAR2(20)    DEFAULT 'DRAFT' NOT NULL,
    approval_instance_id NUMBER,
    created_by           NUMBER,
    created_at           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by           NUMBER,
    updated_at           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_fl_amend_num   UNIQUE (contract_id, amendment_number),
    CONSTRAINT chk_dct_fl_amend_stat CHECK (status IN ('DRAFT','SUBMITTED','APPROVED','REJECTED','CANCELLED')),
    CONSTRAINT fk_dct_fl_amend_con   FOREIGN KEY (contract_id) REFERENCES prod.dct_fl_contracts(contract_id),
    CONSTRAINT fk_dct_fl_amend_cby   FOREIGN KEY (created_by) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dct_fl_amend_uby   FOREIGN KEY (updated_by) REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE prod.dct_fl_contract_amendments IS 'Formal amendment requests — used when ALLOW_DIRECT_CONTRACT_EDIT = N';

CREATE INDEX ix_dct_fl_amend_con ON prod.dct_fl_contract_amendments(contract_id, status);

-- =============================================================================
-- 7. DCT_FL_PAYMENT_SCHEDULE — Created before DCT_FL_PAYMENT_VOUCHERS
--    voucher_id FK added via ALTER TABLE after vouchers table is created
-- =============================================================================
CREATE TABLE prod.dct_fl_payment_schedule (
    schedule_id   NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    contract_id   NUMBER          NOT NULL,
    period_label  VARCHAR2(100)   NOT NULL,
    due_date      DATE            NOT NULL,
    amount        NUMBER(15,2)    NOT NULL,
    voucher_id    NUMBER,
    status        VARCHAR2(20)    DEFAULT 'PENDING' NOT NULL,
    created_at    TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at    TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_fl_sched_stat CHECK (status IN ('PENDING','VOUCHER_GENERATED','PAID','SKIPPED')),
    CONSTRAINT fk_dct_fl_sched_con   FOREIGN KEY (contract_id) REFERENCES prod.dct_fl_contracts(contract_id)
);

COMMENT ON TABLE prod.dct_fl_payment_schedule IS 'Auto-generated payment schedule rows per contract billing period';

CREATE INDEX ix_dct_fl_sched_con    ON prod.dct_fl_payment_schedule(contract_id);
CREATE INDEX ix_dct_fl_sched_status ON prod.dct_fl_payment_schedule(status);
CREATE INDEX ix_dct_fl_sched_due    ON prod.dct_fl_payment_schedule(due_date);

-- =============================================================================
-- 8. DCT_FL_PAYMENT_VOUCHERS
-- =============================================================================
CREATE TABLE prod.dct_fl_payment_vouchers (
    voucher_id           NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    voucher_number       VARCHAR2(50)    NOT NULL,
    contract_id          NUMBER          NOT NULL,
    freelancer_id        NUMBER          NOT NULL,
    schedule_id          NUMBER,
    period_label         VARCHAR2(100),
    due_date             DATE,
    amount               NUMBER(15,2)    NOT NULL,
    invoice_number       VARCHAR2(100),
    invoice_date         DATE,
    payment_method       VARCHAR2(50)    NOT NULL,
    pay_group            VARCHAR2(50)    NOT NULL,
    description          VARCHAR2(1000),
    coding_type          VARCHAR2(10)    NOT NULL,
    cc_id_gl             NUMBER,
    project_number       VARCHAR2(50),
    task_number          VARCHAR2(50),
    expenditure_type     VARCHAR2(100),
    post_to_fusion       VARCHAR2(1)     DEFAULT 'Y' NOT NULL,
    status               VARCHAR2(20)    DEFAULT 'DRAFT' NOT NULL,
    payment_status       VARCHAR2(20)    DEFAULT 'PENDING' NOT NULL,
    payment_date         DATE,
    payment_reference    VARCHAR2(100),
    approval_instance_id NUMBER,
    notes                VARCHAR2(4000),
    created_by           NUMBER,
    created_at           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by           NUMBER,
    updated_at           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_fl_vchr_number  UNIQUE (voucher_number),
    CONSTRAINT chk_dct_fl_vchr_status CHECK (status IN ('DRAFT','SUBMITTED','APPROVED','REJECTED','CANCELLED')),
    CONSTRAINT chk_dct_fl_vchr_pstat  CHECK (payment_status IN ('PENDING','PAID','CANCELLED')),
    CONSTRAINT chk_dct_fl_vchr_fusion CHECK (post_to_fusion IN ('Y','N')),
    CONSTRAINT chk_dct_fl_vchr_coding CHECK (coding_type IN ('GL','PROJECT')),
    CONSTRAINT fk_dct_fl_vchr_con     FOREIGN KEY (contract_id) REFERENCES prod.dct_fl_contracts(contract_id),
    CONSTRAINT fk_dct_fl_vchr_frl     FOREIGN KEY (freelancer_id) REFERENCES prod.dct_fl_freelancers(freelancer_id),
    CONSTRAINT fk_dct_fl_vchr_sched   FOREIGN KEY (schedule_id) REFERENCES prod.dct_fl_payment_schedule(schedule_id),
    CONSTRAINT fk_dct_fl_vchr_cby     FOREIGN KEY (created_by) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dct_fl_vchr_uby     FOREIGN KEY (updated_by) REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE  prod.dct_fl_payment_vouchers IS 'Payment vouchers generated from payment schedule rows';
COMMENT ON COLUMN prod.dct_fl_payment_vouchers.status IS 'Workflow status — stops at APPROVED; payment_status tracks actual payment';
COMMENT ON COLUMN prod.dct_fl_payment_vouchers.payment_status IS 'PENDING until Fusion callback or manual admin confirmation';

CREATE INDEX ix_dct_fl_vchr_con    ON prod.dct_fl_payment_vouchers(contract_id);
CREATE INDEX ix_dct_fl_vchr_frl    ON prod.dct_fl_payment_vouchers(freelancer_id);
CREATE INDEX ix_dct_fl_vchr_sched  ON prod.dct_fl_payment_vouchers(schedule_id);
CREATE INDEX ix_dct_fl_vchr_status ON prod.dct_fl_payment_vouchers(status, payment_status);

-- Add FK from payment schedule back to vouchers
ALTER TABLE prod.dct_fl_payment_schedule
    ADD CONSTRAINT fk_dct_fl_sched_vchr
    FOREIGN KEY (voucher_id) REFERENCES prod.dct_fl_payment_vouchers(voucher_id);

-- =============================================================================
-- 9. DCT_FL_DELIVERABLES
-- =============================================================================
CREATE TABLE prod.dct_fl_deliverables (
    deliverable_id    NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    contract_id       NUMBER          NOT NULL,
    schedule_id       NUMBER,
    title             VARCHAR2(200)   NOT NULL,
    description       VARCHAR2(4000),
    deliverable_date  DATE            NOT NULL,
    quantity          NUMBER(10,2)    DEFAULT 1 NOT NULL,
    unit_id           NUMBER,
    accepted_by       NUMBER,
    accepted_date     DATE,
    status            VARCHAR2(20)    DEFAULT 'SUBMITTED' NOT NULL,
    rejection_reason  VARCHAR2(1000),
    notes             VARCHAR2(4000),
    created_by        NUMBER,
    created_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by        NUMBER,
    updated_at        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_fl_deliv_stat CHECK (status IN ('SUBMITTED','ACCEPTED','REJECTED')),
    CONSTRAINT chk_dct_fl_deliv_qty  CHECK (quantity > 0),
    CONSTRAINT fk_dct_fl_deliv_con   FOREIGN KEY (contract_id) REFERENCES prod.dct_fl_contracts(contract_id),
    CONSTRAINT fk_dct_fl_deliv_sched FOREIGN KEY (schedule_id) REFERENCES prod.dct_fl_payment_schedule(schedule_id),
    CONSTRAINT fk_dct_fl_deliv_acc   FOREIGN KEY (accepted_by) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dct_fl_deliv_cby   FOREIGN KEY (created_by) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dct_fl_deliv_uby   FOREIGN KEY (updated_by) REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE prod.dct_fl_deliverables IS 'Deliverable / milestone records — accepted deliverables gate voucher submission';

CREATE INDEX ix_dct_fl_deliv_con   ON prod.dct_fl_deliverables(contract_id);
CREATE INDEX ix_dct_fl_deliv_sched ON prod.dct_fl_deliverables(schedule_id);
CREATE INDEX ix_dct_fl_deliv_stat  ON prod.dct_fl_deliverables(status);

-- =============================================================================
-- 10. DCT_FL_DOC_EXPIRY_ALERTS
-- =============================================================================
CREATE TABLE prod.dct_fl_doc_expiry_alerts (
    alert_id          NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    document_id       NUMBER          NOT NULL,
    freelancer_id     NUMBER          NOT NULL,
    alert_type        VARCHAR2(20)    NOT NULL,
    days_remaining    NUMBER,
    notified_user_id  NUMBER,
    sent_at           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_fl_alert_type CHECK (alert_type IN ('EXPIRING_SOON','EXPIRED')),
    CONSTRAINT fk_dct_fl_alert_doc   FOREIGN KEY (document_id) REFERENCES prod.dct_fl_documents(document_id),
    CONSTRAINT fk_dct_fl_alert_frl   FOREIGN KEY (freelancer_id) REFERENCES prod.dct_fl_freelancers(freelancer_id),
    CONSTRAINT fk_dct_fl_alert_usr   FOREIGN KEY (notified_user_id) REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE prod.dct_fl_doc_expiry_alerts IS 'Tracks sent expiry notifications to prevent duplicates';

CREATE INDEX ix_dct_fl_alert_doc  ON prod.dct_fl_doc_expiry_alerts(document_id, sent_at);
CREATE INDEX ix_dct_fl_alert_frl  ON prod.dct_fl_doc_expiry_alerts(freelancer_id);

-- =============================================================================
-- 11. DCT_FL_CONTRACT_RENEWALS
-- =============================================================================
CREATE TABLE prod.dct_fl_contract_renewals (
    renewal_id              NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    original_contract_id    NUMBER          NOT NULL,
    new_contract_id         NUMBER,
    renewal_number          VARCHAR2(50)    NOT NULL,
    new_start_date          DATE            NOT NULL,
    new_end_date            DATE,
    new_total_amount        NUMBER(15,2)    NOT NULL,
    new_billing_method      VARCHAR2(20),
    new_billing_unit_id     NUMBER,
    new_billing_unit_amount NUMBER(15,2),
    coding_type             VARCHAR2(10)    NOT NULL,
    cc_id_gl                NUMBER,
    project_number          VARCHAR2(50),
    task_number             VARCHAR2(50),
    expenditure_type        VARCHAR2(100),
    reason                  VARCHAR2(1000)  NOT NULL,
    status                  VARCHAR2(20)    DEFAULT 'DRAFT' NOT NULL,
    approval_instance_id    NUMBER,
    created_by              NUMBER,
    created_at              TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by              NUMBER,
    updated_at              TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT uq_dct_fl_rnl_number  UNIQUE (renewal_number),
    CONSTRAINT chk_dct_fl_rnl_stat   CHECK (status IN ('DRAFT','SUBMITTED','APPROVED','REJECTED','CANCELLED')),
    CONSTRAINT chk_dct_fl_rnl_coding CHECK (coding_type IN ('GL','PROJECT')),
    CONSTRAINT chk_dct_fl_rnl_bill   CHECK (new_billing_method IS NULL OR new_billing_method IN ('WEEKLY','MONTHLY','PER_COUNT')),
    CONSTRAINT fk_dct_fl_rnl_orig    FOREIGN KEY (original_contract_id) REFERENCES prod.dct_fl_contracts(contract_id),
    CONSTRAINT fk_dct_fl_rnl_new     FOREIGN KEY (new_contract_id) REFERENCES prod.dct_fl_contracts(contract_id),
    CONSTRAINT fk_dct_fl_rnl_cby     FOREIGN KEY (created_by) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dct_fl_rnl_uby     FOREIGN KEY (updated_by) REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE prod.dct_fl_contract_renewals IS 'Contract renewal requests — on approval creates new contract linked to original';

CREATE INDEX ix_dct_fl_rnl_orig ON prod.dct_fl_contract_renewals(original_contract_id);
CREATE INDEX ix_dct_fl_rnl_stat ON prod.dct_fl_contract_renewals(status);

-- =============================================================================
-- 12. DCT_FL_PROFILE_CHANGE_REQUESTS
-- =============================================================================
CREATE TABLE prod.dct_fl_profile_change_requests (
    change_request_id    NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    freelancer_id        NUMBER          NOT NULL,
    change_type          VARCHAR2(30)    NOT NULL,
    current_value        VARCHAR2(1000),
    requested_value      VARCHAR2(1000),
    reason               VARCHAR2(1000),
    status               VARCHAR2(20)    DEFAULT 'DRAFT' NOT NULL,
    approval_instance_id NUMBER,
    created_by           NUMBER,
    created_at           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by           NUMBER,
    updated_at           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    --
    CONSTRAINT chk_dct_fl_pcr_type   CHECK (change_type IN ('BANK_ACCOUNT','EMAIL','PHONE','OTHER')),
    CONSTRAINT chk_dct_fl_pcr_status CHECK (status IN ('DRAFT','SUBMITTED','APPROVED','REJECTED')),
    CONSTRAINT fk_dct_fl_pcr_frl     FOREIGN KEY (freelancer_id) REFERENCES prod.dct_fl_freelancers(freelancer_id),
    CONSTRAINT fk_dct_fl_pcr_cby     FOREIGN KEY (created_by) REFERENCES prod.dct_users(user_id),
    CONSTRAINT fk_dct_fl_pcr_uby     FOREIGN KEY (updated_by) REFERENCES prod.dct_users(user_id)
);

COMMENT ON TABLE prod.dct_fl_profile_change_requests IS 'Freelancer-initiated profile update requests — requires FL_ADMIN approval';

CREATE INDEX ix_dct_fl_pcr_frl  ON prod.dct_fl_profile_change_requests(freelancer_id);
CREATE INDEX ix_dct_fl_pcr_stat ON prod.dct_fl_profile_change_requests(status);

-- =============================================================================
-- 14. UPDATED_AT TRIGGERS
-- =============================================================================
CREATE OR REPLACE TRIGGER prod.trg_dct_nat_upd
    BEFORE UPDATE ON prod.dct_nationality
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_fl_reg_upd
    BEFORE UPDATE ON prod.dct_fl_registrations
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_fl_frl_upd
    BEFORE UPDATE ON prod.dct_fl_freelancers
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_fl_ba_upd
    BEFORE UPDATE ON prod.dct_fl_bank_accounts
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_fl_doc_upd
    BEFORE UPDATE ON prod.dct_fl_documents
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_fl_con_upd
    BEFORE UPDATE ON prod.dct_fl_contracts
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_fl_amend_upd
    BEFORE UPDATE ON prod.dct_fl_contract_amendments
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_fl_sched_upd
    BEFORE UPDATE ON prod.dct_fl_payment_schedule
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_fl_vchr_upd
    BEFORE UPDATE ON prod.dct_fl_payment_vouchers
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_fl_deliv_upd
    BEFORE UPDATE ON prod.dct_fl_deliverables
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_fl_rnl_upd
    BEFORE UPDATE ON prod.dct_fl_contract_renewals
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

CREATE OR REPLACE TRIGGER prod.trg_dct_fl_pcr_upd
    BEFORE UPDATE ON prod.dct_fl_profile_change_requests
    FOR EACH ROW
BEGIN :NEW.updated_at := SYSTIMESTAMP; END;
/

COMMIT;

PROMPT
PROMPT === 01_fl_ddl.sql complete ===
PROMPT Tables created: DCT_FL_REGISTRATIONS, DCT_FL_FREELANCERS,
PROMPT                 DCT_FL_BANK_ACCOUNTS, DCT_FL_DOCUMENTS, DCT_FL_CONTRACTS,
PROMPT                 DCT_FL_CONTRACT_AMENDMENTS, DCT_FL_PAYMENT_SCHEDULE,
PROMPT                 DCT_FL_PAYMENT_VOUCHERS, DCT_FL_DELIVERABLES,
PROMPT                 DCT_FL_DOC_EXPIRY_ALERTS, DCT_FL_CONTRACT_RENEWALS,
PROMPT                 DCT_FL_PROFILE_CHANGE_REQUESTS
PROMPT Triggers created: 12 updated_at triggers
