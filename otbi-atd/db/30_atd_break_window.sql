-- ===========================================================================
-- otbi-atd : 30 Break / blackout window (configurable off-hours pause for ALL jobs)
--   * prod.atd_in_break -> 'Y'/'N' whether NOW (Asia/Dubai) is inside the configured
--     quiet window; handles the midnight wrap (e.g. 20:00 -> 06:00). Single source of
--     truth used by enqueue (db/12) AND the worker idle loop (runner.py).
--   * config ATD_BREAK_ENABLED / ATD_BREAK_START / ATD_BREAK_END (UI-editable on
--     Runner Settings). Seeded DISABLED with a 20:00-06:00 default window so enabling
--     is a deliberate one-click toggle (the user asked for it to be "configurable").
-- Rerunnable. Schema-qualified PROD. CRLF / UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

CREATE OR REPLACE FUNCTION prod.atd_in_break RETURN VARCHAR2 IS
  v_enabled VARCHAR2(20);
  v_start   VARCHAR2(5);
  v_end     VARCHAR2(5);
  v_now     VARCHAR2(5);
  FUNCTION cfg(p_key VARCHAR2, p_def VARCHAR2) RETURN VARCHAR2 IS
    r VARCHAR2(400);
  BEGIN
    SELECT config_value INTO r FROM prod.atd_runner_config WHERE config_key = p_key;
    RETURN NVL(r, p_def);
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN p_def;
  END;
BEGIN
  v_enabled := cfg('ATD_BREAK_ENABLED', 'N');
  IF UPPER(NVL(v_enabled,'N')) NOT IN ('Y','1','TRUE','ON') THEN
    RETURN 'N';
  END IF;
  v_start := SUBSTR(cfg('ATD_BREAK_START', '20:00'), 1, 5);
  v_end   := SUBSTR(cfg('ATD_BREAK_END',   '06:00'), 1, 5);
  v_now   := TO_CHAR(prod.dct_to_local(CAST(SYSTIMESTAMP AS TIMESTAMP)), 'HH24:MI');
  -- zero-padded HH24:MI compares lexicographically
  IF v_start <= v_end THEN                 -- same-day window
    RETURN CASE WHEN v_now >= v_start AND v_now < v_end THEN 'Y' ELSE 'N' END;
  ELSE                                     -- wraps past midnight (e.g. 20:00 -> 06:00)
    RETURN CASE WHEN v_now >= v_start OR v_now < v_end THEN 'Y' ELSE 'N' END;
  END IF;
END atd_in_break;
/

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_BREAK_ENABLED' AS config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_BREAK_ENABLED', 'N', 'ENUM', 'Y,N',
          'Break window: when Y, ALL jobs pause during the ATD_BREAK_START..END window (Asia/Dubai). In-flight jobs finish; nothing new is queued.',
          220);

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_BREAK_START' AS config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_BREAK_START', '20:00', 'STRING', NULL,
          'Break window start time HH:MI (24h, Asia/Dubai).', 221);

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_BREAK_END' AS config_key FROM dual) s ON (t.config_key = s.config_key)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, enum_values, description, display_order)
  VALUES ('ATD_BREAK_END', '06:00', 'STRING', NULL,
          'Break window end time HH:MI (24h, Asia/Dubai). A value <= start means the window wraps past midnight.', 222);

COMMIT;

SET ECHO OFF
PROMPT otbi-atd 30 break window : done
