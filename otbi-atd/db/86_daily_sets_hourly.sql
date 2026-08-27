-- =============================================================================
-- otbi-atd (App 208) -- raise three daily job-set schedules to hourly
-- File    : 86_daily_sets_hourly.sql
-- Run     : sql -name prod_mcp @86_daily_sets_hourly.sql
-- Purpose : GL_GRN_DAILY / PAYABLES_DAILY / PROCUREMENT_DAILY currently fire
--           ONCE a day inside a narrow ~1h window (a leftover of the 2026-08-06
--           incident fix, see this app's deployment-notes.md same date). GRN in
--           particular has no incremental counterpart -- its rows lack a stable
--           natural key (verified 2026-08-26: even a 5-column combination of
--           receipt/line/PO-distribution/shipment-line/routing-code still left
--           duplicate rows -- true originals-plus-reversals on the same
--           receipt line), so a Fusion-side receipt correction stayed invisible
--           on the Budget Utilization page until the next morning's window, or
--           a manual "Refresh data" click.
--
-- User decision 2026-08-26: raise all three to the SAME cadence TXN_INCREMENTAL
-- and PROJECTS_DATA already use -- frequency 60 minutes, NO daily window (the
-- nightly worker-fleet break, 21:00-08:00 Dubai, is the only remaining gate --
-- see atd_queue_pkg.enqueue / atd_set_gate_ok, db/40+12). Each full reload is
-- cheap (GRN ~5,600 rows/~1 min observed; AP/PO/PR already refresh sub-hourly
-- via TXN_INCREMENTAL, so their extra full passes are a defense-in-depth catch
-- for the one thing a delta-based incremental cannot see -- a true source-row
-- deletion -- not a freshness fix on their own).
--
-- Data-only change (a plain revision of prod.atd_job_set rows) -- no ORDS
-- involved, so it needs no re-run of any handler script. Idempotent: re-running
-- just re-applies the same values.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

UPDATE prod.atd_job_set
   SET frequency_minutes = 60,
       interval_preset   = 'HOURLY',
       daily_start       = NULL,
       daily_end         = NULL,
       name_en           = 'GL Balances and GRN Hourly Full',
       comments          = 'Hourly refresh of GL balances and goods-received data (raised from once/day 2026-08-26 -- GRN has no incremental counterpart, see otbi-atd/db/86).',
       updated_at        = SYSTIMESTAMP,
       updated_by        = 'CLAUDE'
 WHERE set_code = 'GL_GRN_DAILY';

UPDATE prod.atd_job_set
   SET frequency_minutes = 60,
       interval_preset   = 'HOURLY',
       daily_start       = NULL,
       daily_end         = NULL,
       name_en           = 'Payables Hourly Full',
       comments          = 'Hourly full refresh of AP invoices, invoice lines and distributions (raised from once/day 2026-08-26, defense-in-depth alongside TXN_INCREMENTAL, see otbi-atd/db/86).',
       updated_at        = SYSTIMESTAMP,
       updated_by        = 'CLAUDE'
 WHERE set_code = 'PAYABLES_DAILY';

UPDATE prod.atd_job_set
   SET frequency_minutes = 60,
       interval_preset   = 'HOURLY',
       daily_start       = NULL,
       daily_end         = NULL,
       name_en           = 'Procurement Hourly Full',
       comments          = 'Hourly full refresh of requisition and purchase-order headers, lines, schedules and distributions (raised from once/day 2026-08-26, defense-in-depth alongside TXN_INCREMENTAL, see otbi-atd/db/86).',
       updated_at        = SYSTIMESTAMP,
       updated_by        = 'CLAUDE'
 WHERE set_code = 'PROCUREMENT_DAILY';

COMMIT;

PROMPT === verification ===
SELECT set_code, name_en, interval_preset, frequency_minutes, daily_start, daily_end, active, paused
  FROM prod.atd_job_set
 WHERE set_code IN ('GL_GRN_DAILY','PAYABLES_DAILY','PROCUREMENT_DAILY')
 ORDER BY set_code;
