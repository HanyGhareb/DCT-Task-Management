-- ===========================================================================
-- otbi-atd : 08 target table for the "Suppliers" OTBI analysis
-- Structure mirrors the dataset (15 cols). Full-refresh (TRUNCATE_INSERT).
-- Sized from a live profile (1398 rows, 2026-06-17). CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.atd_suppliers CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE prod.atd_suppliers (
  supplier_number       NUMBER,            -- Supplier Number
  supplier_name         VARCHAR2(300),     -- Supplier Name
  supplier_site_status  VARCHAR2(30),      -- Supplier Site Status
  inactive_date         DATE,              -- Inactive Date (date only)
  bank_name             VARCHAR2(150),     -- Bank Name
  bank_branch_name      VARCHAR2(200),     -- Bank Branch Name
  currency              VARCHAR2(10),      -- Currency
  account_name          VARCHAR2(200),     -- Account Name
  iban                  VARCHAR2(60),      -- IBAN
  from_assignment_date  DATE,              -- From Assignment Date (date only)
  primary_flag          VARCHAR2(3),       -- Primary Flag
  to_dt                 DATE,              -- To Date
  bank_account_number   VARCHAR2(60),      -- Bank Account Number
  last_updated          DATE,              -- Last Updated (datetime)
  site_pay_group        VARCHAR2(30),      -- Site Pay Group
  load_ts               TIMESTAMP DEFAULT SYSTIMESTAMP
);

SET ECHO OFF
PROMPT otbi-atd 08 atd_suppliers : done
