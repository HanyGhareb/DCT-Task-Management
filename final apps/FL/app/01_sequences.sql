-- =============================================================================
-- Freelancers Module (App 203) — Sequences
-- File    : 01_sequences.sql
-- Schema  : PROD
-- Run     : Before building APEX App 203
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- Registration number: FL-REG-000001
CREATE SEQUENCE prod.seq_fl_reg_number
    START WITH 1 INCREMENT BY 1
    NOCACHE NOCYCLE;

-- Vendor number: FL-VND-000001
CREATE SEQUENCE prod.seq_fl_vendor_number
    START WITH 1 INCREMENT BY 1
    NOCACHE NOCYCLE;

-- Contract number: FL-CON-000001
CREATE SEQUENCE prod.seq_fl_contract_number
    START WITH 1 INCREMENT BY 1
    NOCACHE NOCYCLE;

-- Renewal number: FL-RNW-000001
CREATE SEQUENCE prod.seq_fl_renewal_number
    START WITH 1 INCREMENT BY 1
    NOCACHE NOCYCLE;

-- Voucher number: FL-VCH-000001
CREATE SEQUENCE prod.seq_fl_voucher_number
    START WITH 1 INCREMENT BY 1
    NOCACHE NOCYCLE;

COMMIT;

PROMPT
PROMPT === 01_sequences.sql complete ===
PROMPT Sequences: seq_fl_reg_number, seq_fl_vendor_number, seq_fl_contract_number,
PROMPT            seq_fl_renewal_number, seq_fl_voucher_number
