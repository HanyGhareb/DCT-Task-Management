-- ===========================================================================
-- otbi-atd db/75 : fleet worker AUTO-RECOVERY settings (proactive plan)
--
-- User request 2026-08-16 ("be proactive: if any DOWN initiate new session
-- immediately"): when a peer detects a silent worker (no heartbeat > 5 min),
-- the peer that atomically flips the row to DOWN now SSH's into the silent VM
-- (root ssh key mesh installed across vm180-182 the same day) and restarts
-- its atd-worker service on the spot. Success = quiet unless
-- ATD_WORKER_SILENT_ALERT=Y; a FAILED restart (VM frozen/unreachable) ALWAYS
-- sends the Telegram escalation regardless of that setting - it needs a
-- human/ESXi reset. Settings seeded here:
--   ATD_WORKER_RECOVER  Y/N  - master switch for the auto-restart (default Y)
--   ATD_WORKER_HOSTS    text - optional 'worker_id=ip,worker_id=ip' overrides;
--                              blank = derive atd-vm<N> -> 192.168.1.<N>
-- Rerunnable: count-then-insert, never overwrites managed values.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM prod.atd_runner_config
   WHERE config_key = 'ATD_WORKER_RECOVER';
  IF l_n = 0 THEN
    INSERT INTO prod.atd_runner_config
      (config_key, config_value, value_type, enum_values, description, display_order)
    VALUES
      ('ATD_WORKER_RECOVER', 'Y', 'ENUM', 'Y,N',
       'Auto-restart a silent worker: the detecting peer SSHes into the VM and ' ||
       'restarts atd-worker. A failed restart always sends a Telegram escalation.',
       246);
  END IF;
  SELECT COUNT(*) INTO l_n FROM prod.atd_runner_config
   WHERE config_key = 'ATD_WORKER_HOSTS';
  IF l_n = 0 THEN
    INSERT INTO prod.atd_runner_config
      (config_key, config_value, value_type, description, display_order)
    VALUES
      ('ATD_WORKER_HOSTS', NULL, 'STRING',
       'Optional worker_id=ip overrides for auto-recovery (comma separated). ' ||
       'Blank = atd-vm<N> maps to 192.168.1.<N>.',
       247);
  END IF;
END;
/

COMMIT;

SELECT config_key, config_value FROM prod.atd_runner_config
 WHERE config_key IN ('ATD_WORKER_RECOVER', 'ATD_WORKER_HOSTS', 'ATD_WORKER_SILENT_ALERT')
 ORDER BY config_key;
