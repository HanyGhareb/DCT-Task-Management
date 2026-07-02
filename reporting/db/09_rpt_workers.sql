-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 09 worker registry (heartbeat + control)
-- File   : reporting/db/09_rpt_workers.sql
-- Run as : sql -name prod_mcp   (fresh session -- synonym inside)
-- Purpose: DCT_RPT_WORKER -- one row per Python engine worker process.
--          The runner registers on start, heartbeats every loop, reports its
--          state and counters, and polls COMMAND (PAUSE / RESUME / STOP)
--          written by the BI Workers page. The page derives health from
--          LAST_HEARTBEAT (ONLINE < 90s, STALE < 10min, else OFFLINE).
-- Idempotent (guarded creates). Zero blank lines inside statements.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1. DCT_RPT_WORKER ===
BEGIN
  EXECUTE IMMEDIATE q'!
    CREATE TABLE prod.dct_rpt_worker (
      worker_id        VARCHAR2(120) NOT NULL,
      engine           VARCHAR2(20)  DEFAULT 'PYTHON' NOT NULL,
      hostname         VARCHAR2(120),
      pid              NUMBER,
      status           VARCHAR2(20)  DEFAULT 'STARTING' NOT NULL,
      command          VARCHAR2(20),
      current_run_id   NUMBER,
      runs_done        NUMBER        DEFAULT 0 NOT NULL,
      runs_failed      NUMBER        DEFAULT 0 NOT NULL,
      started_at       TIMESTAMP,
      last_heartbeat   TIMESTAMP,
      stopped_at       TIMESTAMP,
      created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT pk_dct_rpt_worker PRIMARY KEY (worker_id)
    )!';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;
/

PROMPT === 2. ADMIN synonym ===
CREATE OR REPLACE SYNONYM dct_rpt_worker FOR prod.dct_rpt_worker;

PROMPT ============================================================
PROMPT  09_rpt_workers.sql complete (DCT_RPT_WORKER + synonym).
PROMPT ============================================================
