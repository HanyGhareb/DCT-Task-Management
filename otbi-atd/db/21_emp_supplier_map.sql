-- ===========================================================================
-- otbi-atd : 21 employee -> Fusion supplier mapping (for write-back actions)
-- Resolves, per (source_module, party_key), the Fusion AP identity an action
-- must use: Supplier number / site, Business Unit, payment method, etc.
-- The mapping is per-APP because the same person can be a different supplier in
-- Petty Cash vs Freelancers (party_key = employee_num for PC, freelancer_id for FL).
-- Consumed by DCT_PC_FUSION_PKG.build_ap_invoice_payload (and future module payloads).
-- Rerunnable. Schema-qualified PROD. CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE prod.dct_emp_supplier_map CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE prod.dct_emp_supplier_map (
  map_id          NUMBER GENERATED ALWAYS AS IDENTITY,
  source_module   VARCHAR2(20)  NOT NULL,            -- PC | FL | ...
  party_key       VARCHAR2(100) NOT NULL,            -- employee_num (PC) / freelancer_id (FL)
  supplier_number VARCHAR2(60),
  supplier_name   VARCHAR2(240),
  supplier_site   VARCHAR2(60),
  business_unit   VARCHAR2(240),
  payment_method  VARCHAR2(60),                      -- e.g. EFT | CHECK | WIRE
  pay_group       VARCHAR2(60),
  payment_terms   VARCHAR2(60),
  currency_code   VARCHAR2(10),
  is_active       CHAR(1)       DEFAULT 'Y' NOT NULL,
  notes           VARCHAR2(400),
  created_by      VARCHAR2(120),
  created_at      TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  updated_by      VARCHAR2(120),
  updated_at      TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT pk_dct_emp_supplier_map PRIMARY KEY (map_id),
  CONSTRAINT uq_dct_emp_supplier_map UNIQUE (source_module, party_key),
  CONSTRAINT ck_dct_emp_sup_active   CHECK (is_active IN ('Y','N'))
);

CREATE INDEX prod.ix_dct_emp_sup_lookup ON prod.dct_emp_supplier_map (source_module, party_key, is_active);

-- ADMIN -> PROD synonym (ORDS / runner execute as ADMIN). No ALTER SESSION here.
CREATE OR REPLACE SYNONYM dct_emp_supplier_map FOR prod.dct_emp_supplier_map;

SET ECHO OFF
PROMPT otbi-atd 21 emp->supplier map : done
