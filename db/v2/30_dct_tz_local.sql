-- =============================================================================
-- i-Finance : local-time display helper  (DCT_TO_LOCAL)
-- File   : db/v2/30_dct_tz_local.sql
-- Schema : PROD (+ ADMIN synonym so ORDS handlers can call it unqualified)
-- Run    : sql -name prod_mcp @30_dct_tz_local.sql   (FRESH session - synonym
--          rule: must NOT follow ALTER SESSION SET CURRENT_SCHEMA=PROD)
-- -----------------------------------------------------------------------------
-- The ADB is UTC (DBTIMEZONE = +00:00); every timestamp/date column is written
-- by SYSTIMESTAMP / SYSDATE and therefore STORED in UTC. The org is UAE-only
-- (Asia/Dubai, fixed +04:00, no DST), so all ORDS handlers convert a stored UTC
-- value to local for display via:   TO_CHAR(dct_to_local(col), '<fmt>')
-- Keep STORAGE in UTC; convert only on display. Never wrap timestamp DIFFERENCES
-- or comparisons (those are TZ-agnostic) - only TO_CHAR display calls.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION prod.dct_to_local(p_ts IN TIMESTAMP)
  RETURN TIMESTAMP
  DETERMINISTIC
IS
BEGIN
  IF p_ts IS NULL THEN
    RETURN NULL;
  END IF;
  -- treat the stored value as UTC wall-clock, shift to Asia/Dubai, drop the TZ
  RETURN CAST(FROM_TZ(p_ts, 'UTC') AT TIME ZONE 'Asia/Dubai' AS TIMESTAMP);
END dct_to_local;
/
SHOW ERRORS FUNCTION prod.dct_to_local

CREATE OR REPLACE SYNONYM dct_to_local FOR prod.dct_to_local;

-- smoke test: UTC 'now' rendered local should be +4h vs SYSTIMESTAMP
PROMPT == smoke ==
SELECT TO_CHAR(SYSTIMESTAMP, 'HH24:MI')                 AS utc_now,
       TO_CHAR(prod.dct_to_local(SYSTIMESTAMP), 'HH24:MI') AS local_now
FROM dual;

EXIT
