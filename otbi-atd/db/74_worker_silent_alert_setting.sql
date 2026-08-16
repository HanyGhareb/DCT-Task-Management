-- ===========================================================================
-- otbi-atd db/74 : ATD_WORKER_SILENT_ALERT -- Runner Settings toggle
--
-- User request 2026-08-16: stop the "otbi-atd: worker <vm> is silent (no
-- heartbeat > 5m)" Telegram messages. New Y/N setting on the Runner Settings
-- page gates ONLY the notification in runner.py _alert_stale_workers; the
-- worker is still flagged DOWN in atd_worker_heartbeat either way, so the
-- Workers dashboard stays truthful and the alert re-arms if turned back on.
-- Seeded 'N' (off) per the request; flip to 'Y' in ATD -> Runner Settings to
-- re-enable. Chronic job-failure alerts (ATD_FAIL_ALERT_*) are unaffected.
-- Rerunnable: count-then-insert, never overwrites a managed value.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM prod.atd_runner_config
   WHERE config_key = 'ATD_WORKER_SILENT_ALERT';
  IF l_n = 0 THEN
    INSERT INTO prod.atd_runner_config
      (config_key, config_value, value_type, enum_values, description, display_order)
    VALUES
      ('ATD_WORKER_SILENT_ALERT', 'N', 'ENUM', 'Y,N',
       'Send a Telegram alert when a worker VM goes silent (no heartbeat > 5 min). ' ||
       'The worker is still marked DOWN on the Workers dashboard either way.',
       245);
  END IF;
END;
/

COMMIT;

SELECT config_key, config_value, value_type, enum_values
  FROM prod.atd_runner_config
 WHERE config_key = 'ATD_WORKER_SILENT_ALERT';
