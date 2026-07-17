-- ===========================================================================
-- otbi-atd : production upgrade runner
--
-- Use this file for an EXISTING OTBI Loader installation. Never call
-- 01_atd_control_tables.sql here: that file belongs to the first-time install.
-- Add each new, additive migration once, in numeric order, after it is reviewed.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT OTBI Loader production upgrade
PROMPT Applying additive migrations registered for this release.
@@48_atd_job_lease_fencing.sql

PROMPT OTBI Loader upgrade complete.
WHENEVER SQLERROR CONTINUE
