-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 08 Budget Utilization by Sector (exec)
-- File   : reporting/db/08_rpt_butil_sector.sql
-- Run as : sql -name prod_mcp   (FRESH session -- ORDS handler upgrade inside)
-- Purpose: driver for the executive report BUDGET_UTIL_SECTOR -- a 6-part
--          sector pack (PYTHON engine, PDF + XLSX, landscape):
--            1 Sector overview (master details + KPI summary)
--            2 Budget utilization rows (budget / AP / GRN / PR / PO / fund)
--            3 Unpaid + partially paid invoices by project/task/exp-type
--            4 Uninvoiced GRN (received not yet invoiced)
--            5 Open purchase orders (GRN-netted)
--            6 Reserved purchase requisitions
--          Parameters: year (budget year, REQUIRED), sector (REQUIRED),
--          projecttype (optional), costcenter (optional).
--          Data views live in db/v2/39 (+ 37).
-- Runs two children (one big statement per file; run from the WINDOWS SQLcl
-- via sql -name prod_mcp -- the Linux dev-VM SQLcl 26.1 has a script-reader
-- bug that echoes/skips these big blocks; diagnose with SET ECHO ON):
--   08a_rpt_butil_seed.sql        MULTI lookup value + definition + SELF
--                                 recipient + disabled monthly schedule
--   08b_rpt_butil_run_handler.sql params-aware POST /rpt/reports/:code/run
--                                 (JSON body = run params; {} or absent keeps
--                                 the definition defaults; bad JSON = 400)
-- Idempotent. If 04_rpt_ords.sql is ever re-run, re-run THIS script after it
-- (04 rebuilds the plain no-params run handler).
-- CRLF + UTF-8 no BOM (children are pure ASCII; Arabic via UNISTR).
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

@@08a_rpt_butil_seed.sql
@@08b_rpt_butil_run_handler.sql

PROMPT ============================================================
PROMPT  08_rpt_butil_sector.sql complete.
PROMPT  MULTI source type + BUDGET_UTIL_SECTOR + params-aware run.
PROMPT ============================================================
