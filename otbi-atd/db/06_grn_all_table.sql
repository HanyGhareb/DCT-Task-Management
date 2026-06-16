-- ===========================================================================
-- otbi-atd : 06 target table for the "GRN All" OTBI analysis
-- Structure mirrors the analysis dataset output (16 columns). Loaded full-
-- refresh (TRUNCATE_INSERT) each run by the Track B runner / Track A package.
-- Sizing derived from a profile of the live extract (1527 rows, 2026-06-17).
-- CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_grn_all CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE prod.atd_grn_all (
  receipt_number       NUMBER,            -- Receipt Number
  receipt_line_number  NUMBER,            -- Receipt Line Number
  transaction_date     DATE,              -- Transaction Date  (YYYY-MM-DD HH24:MI:SS)
  transaction_type     VARCHAR2(100),     -- Transaction Type
  usd_conversion_rate  NUMBER,            -- US Dollar Conversion Rate
  posted_flag          VARCHAR2(1),       -- Posted Flag
  transaction_amount   NUMBER,            -- Transaction Amount
  rate                 NUMBER,            -- Rate
  currency_code        VARCHAR2(10),      -- Currency Code
  order_number         VARCHAR2(40),      -- Order
  line_num             NUMBER,            -- Line
  project_name         VARCHAR2(200),     -- Project Name
  project_number       VARCHAR2(40),      -- Project Number
  task_number          VARCHAR2(100),     -- Task Number
  task_name            VARCHAR2(200),     -- Task Name
  expenditure_type     VARCHAR2(240),     -- Expenditure Type
  load_ts              TIMESTAMP DEFAULT SYSTIMESTAMP
);

SET ECHO OFF
PROMPT otbi-atd 06 atd_grn_all : done
