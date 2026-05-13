-- =============================================================================
-- Credit Cards Module (App 202) — Sequences
-- File    : 01_sequences.sql
-- Schema  : PROD
-- Run     : Before building APEX pages
--           cmd /c "C:\claude\tools\sqlcl\sqlcl\bin\sql.exe -name prod_mcp < 01_sequences.sql 2>&1"
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;

-- Credit card reference number: CC-YYYY-NNNNN
CREATE SEQUENCE prod.seq_cc_number
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Card request reference number: CCR-YYYY-NNNNN
CREATE SEQUENCE prod.seq_ccr_number
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Monthly replenishment reference number: CCM-YYYY-MM-NNNNN
CREATE SEQUENCE prod.seq_ccm_number
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

COMMIT;

PROMPT Sequences created: seq_cc_number, seq_ccr_number, seq_ccm_number
