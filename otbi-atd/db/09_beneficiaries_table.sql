-- ===========================================================================
-- otbi-atd : 09 target table for the "Beneficiaries" OTBI analysis
-- Structure mirrors the dataset (14 cols). Full-refresh (TRUNCATE_INSERT).
-- Sized from a live profile (12086 rows, 2026-06-17). Amount columns kept as
-- VARCHAR2 (source emits formatted/grouped values). CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_beneficiaries CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE prod.atd_beneficiaries (
  supplier_name        VARCHAR2(120),     -- Supplier Name
  supplier_number      NUMBER,            -- Supplier Number
  site                 VARCHAR2(60),      -- Site
  invoice_date         DATE,              -- Invoice Date (date only)
  beneficiary_name     VARCHAR2(160),     -- AP_INVOICES_BENEFICIARY_NAME_
  invoice_description  VARCHAR2(1000),    -- Invoice Description
  invoice_number       VARCHAR2(120),     -- Invoice Number
  invoice_amount_paid  VARCHAR2(40),      -- Invoice Amount Paid
  invoice_currency     VARCHAR2(10),      -- Invoice Currency
  invoice_amount       VARCHAR2(40),      -- Invoice Amount
  approver_user_name   VARCHAR2(120),     -- Approver User Name
  approval_status      VARCHAR2(40),      -- Approval Status
  accounting_status    VARCHAR2(40),      -- Accounting Status
  cancellation_status  VARCHAR2(20),      -- Cancellation Status
  load_ts              TIMESTAMP DEFAULT SYSTIMESTAMP
);

SET ECHO OFF
PROMPT otbi-atd 09 atd_beneficiaries : done
