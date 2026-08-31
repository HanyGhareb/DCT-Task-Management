-- =============================================================================
-- i-Finance V2 -- Mobile push infrastructure
-- File    : 28_push_tokens.sql
-- Schema  : PROD (objects), ADMIN (synonyms + ORDS on the dct.admin module)
-- Run as  : sql -name prod_mcp   (FRESH session -- must NOT follow any
--           ALTER SESSION SET CURRENT_SCHEMA=PROD, or the synonyms self-ref)
-- Purpose : device-token store + push outbox + /dct/devices ORDS handlers, so
--           the i-Finance mobile app (ifinance-mobile/) can receive approval
--           and notification pushes. v1 sender = Expo Push (exp.host); the
--           outbox is shaped so a direct FCM/APNs sender can replace it later
--           with no schema change.
-- Idempotent: safe to re-run.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================
-- 1. DCT_DEVICE_TOKENS -- one row per (user, device). Token is unique.
-- =============================================================================
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM all_tables
   WHERE owner = 'PROD' AND table_name = 'DCT_DEVICE_TOKENS';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_device_tokens (
        token_id     NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        user_id      NUMBER         NOT NULL,
        platform     VARCHAR2(10)   NOT NULL,
        push_token   VARCHAR2(400)  NOT NULL,
        app_version  VARCHAR2(40),
        is_active    VARCHAR2(1)    DEFAULT 'Y' NOT NULL,
        last_seen_at TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
        created_at   TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
        CONSTRAINT chk_dct_devtok_platform CHECK (platform IN ('IOS','ANDROID')),
        CONSTRAINT chk_dct_devtok_active   CHECK (is_active IN ('Y','N')),
        CONSTRAINT fk_dct_devtok_user      FOREIGN KEY (user_id) REFERENCES prod.dct_users(user_id)
      )]';
    EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX prod.uq_dct_devtok_token ON prod.dct_device_tokens(push_token)';
    EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_devtok_user ON prod.dct_device_tokens(user_id, is_active)';
  END IF;
END;
/

-- =============================================================================
-- 2. DCT_PUSH_OUTBOX -- queued push messages. A sweep job drains it.
-- =============================================================================
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM all_tables
   WHERE owner = 'PROD' AND table_name = 'DCT_PUSH_OUTBOX';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_push_outbox (
        outbox_id       NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        notification_id NUMBER,
        user_id         NUMBER         NOT NULL,
        push_token      VARCHAR2(400)  NOT NULL,
        title           VARCHAR2(500)  NOT NULL,
        body            VARCHAR2(4000),
        data_json       VARCHAR2(2000),
        status          VARCHAR2(10)   DEFAULT 'PENDING' NOT NULL,
        attempts        NUMBER         DEFAULT 0 NOT NULL,
        error_msg       VARCHAR2(2000),
        receipt_id     VARCHAR2(100),
        created_at      TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
        sent_at         TIMESTAMP,
        CONSTRAINT chk_dct_pushob_status CHECK (status IN ('PENDING','SENT','FAILED'))
      )]';
    EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_pushob_status ON prod.dct_push_outbox(status, created_at)';
  END IF;
END;
/

-- Added after initial deployment: store Expo ticket id for later receipt checks.
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM dba_tab_columns
   WHERE owner='PROD' AND table_name='DCT_PUSH_OUTBOX' AND column_name='RECEIPT_ID';
  IF n=0 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE prod.dct_push_outbox ADD receipt_id VARCHAR2(100)';
  END IF;
END;
/

-- Push failures must never block the notification, but they must be visible.
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM dba_tables
   WHERE owner='PROD' AND table_name='DCT_PUSH_ERROR_LOG';
  IF n=0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE prod.dct_push_error_log (
        error_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        notification_id NUMBER,
        user_id         NUMBER,
        push_token      VARCHAR2(400),
        error_stage     VARCHAR2(30) NOT NULL,
        error_message   VARCHAR2(2000) NOT NULL,
        created_at      TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
      )]';
    EXECUTE IMMEDIATE
      'CREATE INDEX prod.ix_dct_pusherr_created ON prod.dct_push_error_log(created_at)';
  END IF;
END;
/

CREATE OR REPLACE PROCEDURE prod.dct_push_log_error (
  p_notification_id IN NUMBER,
  p_user_id         IN NUMBER,
  p_push_token      IN VARCHAR2,
  p_error_stage     IN VARCHAR2,
  p_error_message   IN VARCHAR2
) AUTHID DEFINER AS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO prod.dct_push_error_log
    (notification_id,user_id,push_token,error_stage,error_message)
  VALUES
    (p_notification_id,p_user_id,SUBSTR(p_push_token,1,400),
     SUBSTR(p_error_stage,1,30),SUBSTR(p_error_message,1,2000));
  COMMIT;
EXCEPTION WHEN OTHERS THEN NULL;
END dct_push_log_error;
/

-- =============================================================================
-- 3. Trigger -- fan a new notification out to the recipient active devices.
--    Keeps DCT_NOTIFY untouched; deep-link payload carries module + link.
-- =============================================================================
CREATE OR REPLACE TRIGGER prod.trg_dct_notif_push
AFTER INSERT ON prod.dct_notifications
FOR EACH ROW
DECLARE
  l_data VARCHAR2(2000);
BEGIN
  l_data := '{"module":"' || REPLACE(NVL(:NEW.module_code,''),'"','\"')
         || '","type":"'  || REPLACE(NVL(:NEW.notification_type,''),'"','\"')
         || '","link":"'  || REPLACE(NVL(:NEW.link_url,''),'"','\"')
         || '","notifId":' || :NEW.notification_id || '}';
  FOR d IN (
    SELECT push_token FROM prod.dct_device_tokens
     WHERE user_id = :NEW.recipient_user_id AND is_active = 'Y'
  ) LOOP
    BEGIN
      INSERT INTO prod.dct_push_outbox (notification_id, user_id, push_token, title, body, data_json)
      VALUES (:NEW.notification_id, :NEW.recipient_user_id, d.push_token,
              :NEW.title_en, :NEW.body_en, l_data);
    EXCEPTION WHEN OTHERS THEN
      prod.dct_push_log_error(:NEW.notification_id,:NEW.recipient_user_id,
                              d.push_token,'ENQUEUE',SQLERRM);
    END;
  END LOOP;
EXCEPTION WHEN OTHERS THEN
  prod.dct_push_log_error(:NEW.notification_id,:NEW.recipient_user_id,
                          NULL,'TRIGGER',SQLERRM);
END;
/

-- =============================================================================
-- 4. DCT_PUSH_PKG -- registration helpers + Expo-push outbox drain.
-- =============================================================================
CREATE OR REPLACE PACKAGE prod.dct_push_pkg AS
  -- Upsert a device token for a user (called by POST /dct/devices/register).
  PROCEDURE register(p_user_id IN NUMBER, p_platform IN VARCHAR2,
                     p_token IN VARCHAR2, p_app_version IN VARCHAR2 DEFAULT NULL);
  -- Deactivate a token (called by DELETE /dct/devices/:token, or on 410 from Expo).
  PROCEDURE unregister(p_token IN VARCHAR2);
  -- Drain PENDING outbox rows to Expo Push (sweep job calls this every minute).
  PROCEDURE send_pending(p_limit IN NUMBER DEFAULT 100);
END dct_push_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_push_pkg AS

  PROCEDURE register(p_user_id IN NUMBER, p_platform IN VARCHAR2,
                     p_token IN VARCHAR2, p_app_version IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    UPDATE prod.dct_device_tokens
       SET user_id = p_user_id, platform = p_platform, app_version = p_app_version,
           is_active = 'Y', last_seen_at = SYSTIMESTAMP
     WHERE push_token = p_token;
    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO prod.dct_device_tokens (user_id, platform, push_token, app_version)
      VALUES (p_user_id, p_platform, p_token, p_app_version);
    END IF;
    COMMIT;
  END register;

  PROCEDURE unregister(p_token IN VARCHAR2) IS
  BEGIN
    UPDATE prod.dct_device_tokens SET is_active = 'N' WHERE push_token = p_token;
    COMMIT;
  END unregister;

  PROCEDURE send_pending(p_limit IN NUMBER DEFAULT 100) IS
    TYPE t_id_list IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    TYPE t_token_list IS TABLE OF VARCHAR2(400) INDEX BY PLS_INTEGER;
    l_body  CLOB;
    l_res   CLOB;
    l_first BOOLEAN := TRUE;
    l_err   VARCHAR2(2000);
    l_ids   t_id_list;
    l_tokens t_token_list;
    l_count PLS_INTEGER;
    l_status VARCHAR2(20);
    l_code VARCHAR2(100);
    l_message VARCHAR2(2000);
  BEGIN
    -- Build a single Expo push batch from PENDING rows (one JSON array).
    l_body := '[';
    FOR r IN (
      SELECT outbox_id, push_token, title, body, data_json
      FROM   prod.dct_push_outbox
      WHERE  status = 'PENDING' AND attempts < 5
      ORDER  BY created_at
      FETCH FIRST p_limit ROWS ONLY
    ) LOOP
      l_ids(l_ids.COUNT + 1) := r.outbox_id;
      l_tokens(l_tokens.COUNT + 1) := r.push_token;
      IF NOT l_first THEN l_body := l_body || ','; END IF;
      l_first := FALSE;
      l_body := l_body
        || '{"to":"' || r.push_token || '"'
        || ',"title":' || APEX_JSON.stringify(r.title)
        || ',"body":'  || APEX_JSON.stringify(NVL(r.body,' '))
        || ',"sound":"default","priority":"high"'
        || ',"data":' || NVL(r.data_json,'{}') || '}';
      UPDATE prod.dct_push_outbox
         SET attempts = attempts + 1, status = 'SENT', sent_at = SYSTIMESTAMP
       WHERE outbox_id = r.outbox_id;
    END LOOP;
    l_body := l_body || ']';

    IF l_body = '[]' THEN RETURN; END IF;

    -- POST the batch to Expo Push. Requires a network ACL for exp.host:443
    -- (see section 7). On any HTTP failure, the rows are rolled back to PENDING.
    BEGIN
      APEX_WEB_SERVICE.g_request_headers.DELETE;
      APEX_WEB_SERVICE.g_request_headers(1).name  := 'Content-Type';
      APEX_WEB_SERVICE.g_request_headers(1).value := 'application/json';
      l_res := APEX_WEB_SERVICE.make_rest_request(
                 p_url         => 'https://exp.host/--/api/v2/push/send',
                 p_http_method => 'POST',
                 p_body        => l_body);
      IF APEX_WEB_SERVICE.g_status_code != 200 THEN
        RAISE_APPLICATION_ERROR(-20028,'Expo HTTP status '||APEX_WEB_SERVICE.g_status_code);
      END IF;
      APEX_JSON.parse(l_res);
      l_count := APEX_JSON.get_count('data');
      IF l_count != l_ids.COUNT THEN
        RAISE_APPLICATION_ERROR(-20029,'Expo ticket count does not match submitted batch');
      END IF;
      FOR i IN 1 .. l_ids.COUNT LOOP
        l_status := APEX_JSON.get_varchar2('data['||i||'].status');
        IF l_status='ok' THEN
          UPDATE prod.dct_push_outbox
             SET status='SENT',sent_at=SYSTIMESTAMP,error_msg=NULL,
                 receipt_id=APEX_JSON.get_varchar2('data['||i||'].id')
           WHERE outbox_id=l_ids(i);
        ELSE
          l_code:=APEX_JSON.get_varchar2('data['||i||'].details.error');
          l_message:=SUBSTR(APEX_JSON.get_varchar2('data['||i||'].message'),1,2000);
          UPDATE prod.dct_push_outbox
             SET status='FAILED',sent_at=NULL,receipt_id=NULL,
                 error_msg=SUBSTR(NVL(l_code,'ExpoError')||': '||l_message,1,2000)
           WHERE outbox_id=l_ids(i);
          IF l_code='DeviceNotRegistered' THEN
            UPDATE prod.dct_device_tokens SET is_active='N'
             WHERE push_token=l_tokens(i);
          END IF;
        END IF;
      END LOOP;
      COMMIT;
    EXCEPTION WHEN OTHERS THEN
      l_err := SUBSTR(SQLERRM,1,2000);  -- capture before ROLLBACK; SQLERRM is not valid inside SQL DML
      ROLLBACK;
      IF l_ids.COUNT > 0 THEN
        FORALL i IN 1 .. l_ids.COUNT
          UPDATE prod.dct_push_outbox
             SET attempts = attempts + 1,
                 status = CASE WHEN attempts + 1 >= 5 THEN 'FAILED' ELSE 'PENDING' END,
                 error_msg = l_err
           WHERE outbox_id = l_ids(i)
             AND status = 'PENDING';
      END IF;
      COMMIT;
    END;
  END send_pending;

END dct_push_pkg;
/

-- =============================================================================
-- 5. Sweep job -- drain the outbox once a minute.
-- =============================================================================
BEGIN
  BEGIN DBMS_SCHEDULER.DROP_JOB('PROD.DCT_PUSH_SWEEP', TRUE); EXCEPTION WHEN OTHERS THEN NULL; END;
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'PROD.DCT_PUSH_SWEEP',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN prod.dct_push_pkg.send_pending; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY;INTERVAL=1',
    enabled         => TRUE,
    comments        => 'Drain DCT_PUSH_OUTBOX to Expo Push every minute');
END;
/

-- =============================================================================
-- 6. ADMIN synonyms -- ORDS handlers execute as ADMIN.
-- =============================================================================
CREATE OR REPLACE SYNONYM admin.dct_device_tokens FOR prod.dct_device_tokens;
CREATE OR REPLACE SYNONYM admin.dct_push_outbox   FOR prod.dct_push_outbox;
CREATE OR REPLACE SYNONYM admin.dct_push_pkg      FOR prod.dct_push_pkg;

-- =============================================================================
-- 7. ORDS handlers on the existing dct.admin module (additive -- no re-define).
--    Wrapped in a temp procedure so SQLcl does not bind-scan the colon tokens.
-- =============================================================================
CREATE OR REPLACE PROCEDURE admin.setup_dct_devices_ords_tmp AS
  c_mod CONSTANT VARCHAR2(30) := 'dct.admin';
  PROCEDURE def_template(p_pattern VARCHAR2) IS
  BEGIN
    ORDS.DEFINE_TEMPLATE(p_module_name => c_mod, p_pattern => REPLACE(p_pattern,'[COLON]',CHR(58)));
  END;
  PROCEDURE def_handler(p_pattern VARCHAR2, p_method VARCHAR2, p_source CLOB) IS
  BEGIN
    ORDS.DEFINE_HANDLER(
      p_module_name => c_mod,
      p_pattern     => REPLACE(p_pattern,'[COLON]',CHR(58)),
      p_method      => p_method,
      p_source_type => ORDS.source_type_plsql,
      p_source      => REPLACE(p_source,'[COLON]',CHR(58)));
  END;
BEGIN
  def_template('devices/register');
  def_handler('devices/register', 'POST', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
  l_uid  NUMBER;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  l_uid := dct_auth.get_user_id(l_user);
  dct_rest.parse_body([COLON]body);
  dct_push_pkg.register(
    p_user_id     => l_uid,
    p_platform    => UPPER(APEX_JSON.get_varchar2(p_path => 'platform')),
    p_token       => APEX_JSON.get_varchar2(p_path => 'token'),
    p_app_version => APEX_JSON.get_varchar2(p_path => 'appVersion'));
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');

  def_template('devices/[COLON]token');
  def_handler('devices/[COLON]token', 'DELETE', q'!
DECLARE
  l_user VARCHAR2(100) := dct_rest.validate_session;
BEGIN
  IF l_user IS NULL THEN dct_rest.err(401,'Unauthorized'); RETURN; END IF;
  dct_push_pkg.unregister([COLON]token);
  dct_rest.json_header;
  APEX_JSON.initialize_output;
  APEX_JSON.open_object;
  APEX_JSON.write('ok', TRUE);
  APEX_JSON.close_object;
EXCEPTION WHEN OTHERS THEN dct_rest.err(500, SQLERRM);
END;
!');
END;
/

BEGIN
  admin.setup_dct_devices_ords_tmp;
  COMMIT;
END;
/
DROP PROCEDURE admin.setup_dct_devices_ords_tmp;

-- =============================================================================
-- 8. ONE-TIME network ACL (run by ADMIN if not already granted). Lets the
--    sweep job reach Expo Push. Uncomment + run once; safe to leave commented
--    if the ACL already exists.
-- =============================================================================
-- BEGIN
--   DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
--     host => 'exp.host',
--     ace  => xs$ace_type(privilege_list => xs$name_list('http'),
--                         principal_name => 'PROD',
--                         principal_type => xs_acl.ptype_db));
-- END;
-- /

PROMPT === 28_push_tokens.sql complete ===
