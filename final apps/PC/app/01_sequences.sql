-- =============================================================================
-- Petty Cash App 201 — Sequences
-- File    : 01_sequences.sql
-- Schema  : PROD
-- Run     : Before building APEX pages
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

-- PC number sequence: generates the numeric suffix for PC-YYYY-NNNNN
CREATE SEQUENCE prod.seq_pc_number
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Reimbursement number sequence
CREATE SEQUENCE prod.seq_reimb_number
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Clearing number sequence
CREATE SEQUENCE prod.seq_clr_number
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

COMMIT;

PROMPT Sequences created: seq_pc_number, seq_reimb_number, seq_clr_number
