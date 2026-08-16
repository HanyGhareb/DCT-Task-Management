-- ===========================================================================
-- otbi-atd db/76 : LEVEL-2 recovery settings -- ESXi power reset
--
-- Extends db/75's proactive plan (user request 2026-08-16: "ESXi access is
-- available, so the required actions can be done by the VM itself"). When the
-- ssh service-restart of a silent worker fails (VM frozen - the vmxnet3-panic
-- class), the detecting peer now hard power-resets the VM through the ESXi
-- host (vim-cmd vmsvc/power.reset; power.on when the VM is off), then waits
-- up to 3 min for the worker to boot back (service auto-starts at boot).
-- Only if THAT fails does the always-on escalation Telegram fire - and it now
-- carries the 5-step manual runbook (ESXi UI -> VM -> Power -> Reset ...).
-- ESXi ssh is password-auth via OpenSSH SSH_ASKPASS (runner/esxi_askpass.sh)
-- - no sshpass and no key install on the ESXi host.
--   ATD_ESXI_HOST   ESXi host/IP        (192.168.1.190, standalone ESXi 6.5)
--   ATD_ESXI_USER   ssh user            (root)
--   ATD_ESXI_PWD    SECRET password     (seeded CHANGE_ME here - set the real
--                                        value in ATD -> Runner Settings; the
--                                        reset path refuses to run on CHANGE_ME)
--   ATD_ESXI_VMIDS  worker_id=vmid map  (atd-vm180=52,atd-vm181=53,atd-vm182=54
--                                        from vim-cmd vmsvc/getallvms)
-- Rerunnable: count-then-insert, never overwrites managed values.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON

DECLARE
  l_n NUMBER;
  PROCEDURE seed(p_key VARCHAR2, p_val VARCHAR2, p_type VARCHAR2,
                 p_secret CHAR, p_desc VARCHAR2, p_ord NUMBER) IS
    l_c NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_c FROM prod.atd_runner_config WHERE config_key = p_key;
    IF l_c = 0 THEN
      INSERT INTO prod.atd_runner_config
        (config_key, config_value, value_type, is_secret, description, display_order)
      VALUES (p_key, p_val, p_type, p_secret, p_desc, p_ord);
    END IF;
  END;
BEGIN
  seed('ATD_ESXI_HOST', '192.168.1.190', 'STRING', 'N',
       'ESXi host for level-2 worker recovery (hard power reset of a frozen VM).', 248);
  seed('ATD_ESXI_USER', 'root', 'STRING', 'N',
       'ESXi ssh user for the power-reset recovery.', 249);
  seed('ATD_ESXI_PWD', 'CHANGE_ME', 'STRING', 'Y',
       'ESXi ssh password (secret). CHANGE_ME disables the ESXi reset path.', 250);
  seed('ATD_ESXI_VMIDS', 'atd-vm180=52,atd-vm181=53,atd-vm182=54', 'STRING', 'N',
       'worker_id=vmid map on the ESXi host (vim-cmd vmsvc/getallvms).', 251);
  l_n := 0;
END;
/

COMMIT;

SELECT config_key,
       CASE WHEN is_secret = 'Y' THEN '(secret)' ELSE config_value END v
  FROM prod.atd_runner_config
 WHERE config_key LIKE 'ATD_ESXI%' ORDER BY display_order;
