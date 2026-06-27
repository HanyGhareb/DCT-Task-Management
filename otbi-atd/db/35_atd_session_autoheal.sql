-- ===========================================================================
-- otbi-atd : 35 session auto-heal tunables (Tier 1 keep-alive + Tier 2 failover)
--   * ATD_SESSION_KEEPALIVE_MIN -> idle worker pings its warm Fusion session every
--     N minutes so it never idle-expires between sparse jobs (0 = off).
--   * ATD_REQUEUE_MAX            -> on a session-expiry bounce a job is handed BACK
--     to the queue (atd_queue_pkg.release_job) for a healthy peer, up to this many
--     cross-worker attempts, before it is marked FAILED.
-- Additive + rerunnable: MERGE WHEN NOT MATCHED only -> never overwrites an operator
-- edit made on the Runner Settings page. (release_job itself ships in db/12.)
-- Schema-qualified PROD. CRLF + UTF-8 no BOM.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_SESSION_KEEPALIVE_MIN' AS k, '3' AS v, 'NUMBER' AS ty,
              'Minutes between idle keep-alive pings that keep the Fusion session warm so it does not idle-expire between jobs (0 = off)' AS d,
              55 AS ord FROM dual) s
ON (t.config_key = s.k)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, description, display_order)
  VALUES (s.k, s.v, s.ty, s.d, s.ord);

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_KEEPALIVE_STRIKES' AS k, '2' AS v, 'NUMBER' AS ty,
              'Consecutive failed keep-alive pings before a session is declared dead (guards against a transient blip triggering a needless MFA)' AS d,
              56 AS ord FROM dual) s
ON (t.config_key = s.k)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, description, display_order)
  VALUES (s.k, s.v, s.ty, s.d, s.ord);

MERGE INTO prod.atd_runner_config t
USING (SELECT 'ATD_REQUEUE_MAX' AS k, '6' AS v, 'NUMBER' AS ty,
              'On a session-expiry bounce, how many times a job is handed back to the queue for a healthy worker before it is marked FAILED' AS d,
              56 AS ord FROM dual) s
ON (t.config_key = s.k)
WHEN NOT MATCHED THEN
  INSERT (config_key, config_value, value_type, description, display_order)
  VALUES (s.k, s.v, s.ty, s.d, s.ord);

COMMIT;

SET ECHO OFF
PROMPT otbi-atd 35 session auto-heal : done
