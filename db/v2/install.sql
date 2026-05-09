-- =============================================================================
-- i-Finance V2 — Master Install Script
-- File    : install.sql
-- Sprint  : 1 — Foundation
-- =============================================================================
-- Run this from SQL*Plus or SQLcl as the PROD schema owner:
--
--   cd db/v2
--   sqlplus prod/<password>@<db_service> @install.sql
--
-- Prerequisites:
--   GRANT EXECUTE ON DBMS_CRYPTO TO PROD;
--   GRANT CREATE TABLE TO PROD;
--   GRANT CREATE VIEW TO PROD;
--   GRANT CREATE TRIGGER TO PROD;
--   GRANT CREATE PROCEDURE TO PROD;
-- =============================================================================

SET ECHO ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT ============================================================
PROMPT  Step 1/4 — DDL: Tables, indexes, triggers
PROMPT ============================================================
@@01_ifw_ddl.sql

PROMPT ============================================================
PROMPT  Step 2/4 — Views: Utility + compatibility views
PROMPT ============================================================
@@02_ifw_views.sql

PROMPT ============================================================
PROMPT  Step 3/4 — Package: IFW_AUTH
PROMPT ============================================================
@@03_ifw_auth_pkg.sql

PROMPT ============================================================
PROMPT  Step 4/4 — Seed data: roles, modules, settings, admin user
PROMPT ============================================================
@@04_ifw_seed.sql

PROMPT ============================================================
PROMPT  Sprint 1 install complete.
PROMPT  Next: configure APEX App 200 authentication scheme.
PROMPT  See db/v2/APEX_SETUP.md for APEX configuration steps.
PROMPT ============================================================

EXIT 0
