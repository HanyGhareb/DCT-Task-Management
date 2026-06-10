-- Applied/superseded [PROD] — archived for reference only. Historical split-run artifact — use install.sql
-- =============================================================================
-- HR Module — Continuation Script (run 2)
-- Job families + jobs already committed. Runs pkg + ORDS only.
-- =============================================================================

ALTER SESSION SET CURRENT_SCHEMA = PROD;
SET DEFINE OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT [5/6] DCT_HR PL/SQL package ...
@@05_hr_pkg.sql

PROMPT [6/6] ORDS endpoints ...
@@06_hr_ords.sql

PROMPT
PROMPT ============================================================
PROMPT  HR Module continuation COMPLETE — pkg + ORDS done.
PROMPT ============================================================
