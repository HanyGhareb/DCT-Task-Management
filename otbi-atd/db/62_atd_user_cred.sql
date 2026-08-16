-- ===========================================================================
-- otbi-atd : 62 per-user OTBI credential profiles
-- Each admin can store a PERSONAL Fusion/OTBI login (username + AES-encrypted
-- password + personal Telegram chat id). Jobs / Fusion actions THEY enqueue run
-- under THEIR account on the worker fleet; scheduled/automatic runs keep using
-- the global service account (OTBI_USER runner-config row + OTBI_PWD in env.sh).
--
-- Encryption: AES-256-CBC via DBMS_CRYPTO with a random 16-byte IV prepended to
-- the ciphertext. The master key lives in PROD.ATD_CRED_KEY -- one row, generated
-- ONCE on first deploy, never regenerated on rerun (regenerating would orphan
-- every stored password). ATD_CRED_KEY has NO ADMIN synonym and is never touched
-- by any ORDS handler. NOTE the threat model: key + ciphertext live in the same
-- DB, so this is defense-in-depth against casual reads/exports of the credential
-- table and against secrets leaking into JSON/logs -- not against a full-DB
-- compromise. (Strictly stronger than the AR_WS precedent, which stores its
-- gateway password plaintext behind a masking flag.)
--
-- Also:
--   * ATD_OTBI_JOBS.REQUESTED_BY    -- who queued this cycle (NULL = scheduler)
--   * ATD_LOAD_RUN_LOG.FUSION_ACCOUNT -- audit: account that actually ran it
--   * ATD_MFA_LOCK.LOCK_NAME widened to 200 (per-account locks FUSION_MFA:<login>)
--   * runner-config seed ATD_MAX_USER_SESSIONS (warm personal sessions per worker)
--
-- Rerunnable. NO MERGE (Linux SQLcl swallows MERGE-bearing blocks -- guarded
-- INSERT ... SELECT ... WHERE NOT EXISTS instead). Schema-qualified PROD.
-- CRLF + UTF-8 no BOM. Run as ADMIN (prod_mcp), fresh session for the synonyms.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET ECHO ON

-- ---- credential profile table ----
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.atd_user_credential (
      username        VARCHAR2(100) NOT NULL,
      fusion_login    VARCHAR2(200) NOT NULL,
      fusion_pwd_enc  RAW(2000),
      tg_chat_id      VARCHAR2(40),
      is_active       VARCHAR2(1) DEFAULT 'Y' NOT NULL,
      updated_by      VARCHAR2(100),
      updated_at      TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
      created_at      TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT pk_atd_user_cred PRIMARY KEY (username),
      CONSTRAINT ck_atd_user_cred_act CHECK (is_active IN ('Y','N'))
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- ---- master key (one row; generated once, NEVER regenerated on rerun) ----
BEGIN
  EXECUTE IMMEDIATE q'[
    CREATE TABLE prod.atd_cred_key (
      key_name   VARCHAR2(30) PRIMARY KEY,
      key_raw    RAW(32) NOT NULL,
      created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
    )]';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

INSERT INTO prod.atd_cred_key (key_name, key_raw)
SELECT 'ATD_CRED_AES', DBMS_CRYPTO.RANDOMBYTES(32) FROM dual
 WHERE NOT EXISTS (SELECT 1 FROM prod.atd_cred_key WHERE key_name = 'ATD_CRED_AES');
COMMIT;

-- catalog identity (2026-08-15): the OTBI catalog personal-folder name
-- (/users/<x>/) is the Fusion APPLICATION username, which can differ from the
-- Entra sign-in UPN (e.g. sign-in c-saljaaidi@... vs folder saljaaidi@...;
-- hg2248 vs haghareb). Owner matching uses NVL(catalog_login, fusion_login).
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_user_credential ADD (catalog_login VARCHAR2(200))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

-- ---- queue / run-log / mfa-lock column changes (guarded) ----
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_otbi_jobs ADD (requested_by VARCHAR2(100))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE prod.atd_load_run_log ADD (fusion_account VARCHAR2(200))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/
-- widen the MFA lock name so per-account locks (FUSION_MFA:<fusion_login>) fit
ALTER TABLE prod.atd_mfa_lock MODIFY (lock_name VARCHAR2(200));

-- ---- credential package ----
CREATE OR REPLACE PACKAGE prod.atd_cred_pkg AS
  -- ORDS-facing surface (write / flags only -- NO decrypt here):
  -- p_password NULL or empty clears the stored password.
  PROCEDURE set_password(p_username VARCHAR2, p_password VARCHAR2);
  FUNCTION  password_set(p_username VARCHAR2) RETURN VARCHAR2;  -- 'Y'/'N'

  -- Runner-facing (called by the worker fleet's ADMIN oracledb connection ONLY;
  -- never referenced by an ORDS handler). Resolves the enqueuing i-Finance user
  -- to a usable personal credential. All OUTs NULL when there is no usable row
  -- (no profile / inactive / password not set) -> caller falls back to the
  -- global service account.
  PROCEDURE resolve_runner_cred(
      p_requested_by IN  VARCHAR2,
      o_fusion_login OUT VARCHAR2,
      o_fusion_pwd   OUT VARCHAR2,
      o_tg_chat      OUT VARCHAR2);

  -- Job identity resolution (2026-08-15): the analysis catalog path defines the
  -- PERMANENT job owner. Priority:
  --   1. the credential profile whose fusion_login matches the /users/<login>/
  --      prefix of p_source_ref (active + password set) -> the OWNER runs it,
  --      on EVERY cycle including scheduled ones;
  --   2. else p_requested_by's profile (manual enqueue by another user);
  --   3. else all OUTs NULL -> global service account.
  PROCEDURE resolve_job_cred(
      p_source_ref   IN  VARCHAR2,
      p_requested_by IN  VARCHAR2,
      o_fusion_login OUT VARCHAR2,
      o_fusion_pwd   OUT VARCHAR2,
      o_tg_chat      OUT VARCHAR2);

  -- The catalog-owner half of resolve_job_cred, published for SQL use by the
  -- ORDS jobs handlers (Owner column): returns the matched profile's
  -- fusion_login for a source_ref, or NULL when no usable profile matches.
  FUNCTION job_owner_login(p_source_ref VARCHAR2) RETURN VARCHAR2;
END atd_cred_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.atd_cred_pkg AS

  FUNCTION key_raw RETURN RAW IS
    v RAW(32);
  BEGIN
    SELECT key_raw INTO v FROM prod.atd_cred_key WHERE key_name = 'ATD_CRED_AES';
    RETURN v;
  END key_raw;

  FUNCTION encrypt_pwd(p_pwd VARCHAR2) RETURN RAW IS
    v_iv  RAW(16);
    v_enc RAW(2000);
  BEGIN
    IF p_pwd IS NULL THEN RETURN NULL; END IF;
    v_iv  := DBMS_CRYPTO.RANDOMBYTES(16);
    v_enc := DBMS_CRYPTO.ENCRYPT(
               src => UTL_I18N.STRING_TO_RAW(p_pwd, 'AL32UTF8'),
               typ => DBMS_CRYPTO.ENCRYPT_AES256
                    + DBMS_CRYPTO.CHAIN_CBC
                    + DBMS_CRYPTO.PAD_PKCS5,
               key => key_raw,
               iv  => v_iv);
    RETURN UTL_RAW.CONCAT(v_iv, v_enc);
  END encrypt_pwd;

  FUNCTION decrypt_pwd(p_enc RAW) RETURN VARCHAR2 IS
    v_iv  RAW(16);
    v_ct  RAW(2000);
    v_dec RAW(2000);
  BEGIN
    IF p_enc IS NULL THEN RETURN NULL; END IF;
    v_iv := UTL_RAW.SUBSTR(p_enc, 1, 16);
    v_ct := UTL_RAW.SUBSTR(p_enc, 17);
    v_dec := DBMS_CRYPTO.DECRYPT(
               src => v_ct,
               typ => DBMS_CRYPTO.ENCRYPT_AES256
                    + DBMS_CRYPTO.CHAIN_CBC
                    + DBMS_CRYPTO.PAD_PKCS5,
               key => key_raw,
               iv  => v_iv);
    RETURN UTL_I18N.RAW_TO_CHAR(v_dec, 'AL32UTF8');
  END decrypt_pwd;

  PROCEDURE set_password(p_username VARCHAR2, p_password VARCHAR2) IS
    v_enc RAW(2000);
  BEGIN
    -- compute BEFORE the DML: a package-private function inside SQL = PLS-00231
    v_enc := encrypt_pwd(TRIM(p_password));
    UPDATE prod.atd_user_credential
       SET fusion_pwd_enc = v_enc,
           updated_at     = SYSTIMESTAMP
     WHERE username = p_username;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20404, 'No credential profile for ' || p_username);
    END IF;
  END set_password;

  FUNCTION password_set(p_username VARCHAR2) RETURN VARCHAR2 IS
    n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO n FROM prod.atd_user_credential
     WHERE username = p_username AND fusion_pwd_enc IS NOT NULL;
    RETURN CASE WHEN n > 0 THEN 'Y' ELSE 'N' END;
  END password_set;

  PROCEDURE resolve_runner_cred(
      p_requested_by IN  VARCHAR2,
      o_fusion_login OUT VARCHAR2,
      o_fusion_pwd   OUT VARCHAR2,
      o_tg_chat      OUT VARCHAR2) IS
    r prod.atd_user_credential%ROWTYPE;
  BEGIN
    o_fusion_login := NULL; o_fusion_pwd := NULL; o_tg_chat := NULL;
    IF p_requested_by IS NULL THEN RETURN; END IF;
    BEGIN
      SELECT * INTO r FROM prod.atd_user_credential
       WHERE username = p_requested_by;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN;
    END;
    IF r.is_active <> 'Y' OR r.fusion_pwd_enc IS NULL THEN RETURN; END IF;
    o_fusion_login := r.fusion_login;
    o_fusion_pwd   := decrypt_pwd(r.fusion_pwd_enc);
    o_tg_chat      := r.tg_chat_id;
  END resolve_runner_cred;

  FUNCTION job_owner_login(p_source_ref VARCHAR2) RETURN VARCHAR2 IS
    l_path_login VARCHAR2(200);
    l_login      VARCHAR2(200);
  BEGIN
    -- the catalog personal-folder prefix: /users/<catalog username>/...
    -- (the folder is the Fusion APPLICATION username; a profile whose Entra
    -- sign-in differs sets catalog_login to the folder name)
    l_path_login := LOWER(REGEXP_SUBSTR(p_source_ref, '^/users/([^/]+)/', 1, 1, 'i', 1));
    IF l_path_login IS NULL THEN RETURN NULL; END IF;
    SELECT fusion_login INTO l_login FROM prod.atd_user_credential
     WHERE l_path_login IN (LOWER(NVL(catalog_login, fusion_login)), LOWER(fusion_login))
       AND is_active = 'Y' AND fusion_pwd_enc IS NOT NULL
       AND ROWNUM = 1;
    RETURN l_login;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
  END job_owner_login;

  PROCEDURE resolve_job_cred(
      p_source_ref   IN  VARCHAR2,
      p_requested_by IN  VARCHAR2,
      o_fusion_login OUT VARCHAR2,
      o_fusion_pwd   OUT VARCHAR2,
      o_tg_chat      OUT VARCHAR2) IS
    r prod.atd_user_credential%ROWTYPE;
    l_owner VARCHAR2(200);
  BEGIN
    o_fusion_login := NULL; o_fusion_pwd := NULL; o_tg_chat := NULL;
    l_owner := job_owner_login(p_source_ref);
    IF l_owner IS NOT NULL THEN
      SELECT * INTO r FROM prod.atd_user_credential
       WHERE LOWER(fusion_login) = LOWER(l_owner) AND ROWNUM = 1;
      o_fusion_login := r.fusion_login;
      o_fusion_pwd   := decrypt_pwd(r.fusion_pwd_enc);
      o_tg_chat      := r.tg_chat_id;
      RETURN;
    END IF;
    resolve_runner_cred(p_requested_by, o_fusion_login, o_fusion_pwd, o_tg_chat);
  END resolve_job_cred;

END atd_cred_pkg;
/

-- ---- synonyms for ORDS handlers (NONE for atd_cred_key, deliberately) ----
CREATE OR REPLACE SYNONYM atd_user_credential FOR prod.atd_user_credential;
CREATE OR REPLACE SYNONYM atd_cred_pkg FOR prod.atd_cred_pkg;

-- ---- runner-config seed (guarded insert, no MERGE) ----
INSERT INTO prod.atd_runner_config (config_key, config_value, value_type, enum_values, description, display_order)
SELECT 'ATD_MAX_USER_SESSIONS', '2', 'NUMBER', NULL,
       'Max concurrent PERSONAL Fusion sessions held warm per worker; the oldest-idle personal session is closed beyond this (the service-account session is never closed)', 26
  FROM dual
 WHERE NOT EXISTS (SELECT 1 FROM prod.atd_runner_config WHERE config_key = 'ATD_MAX_USER_SESSIONS');
COMMIT;

-- ---- verification: encryption round-trip (raises on failure) ----
DECLARE
  l_login VARCHAR2(200);
  l_pwd   VARCHAR2(200);
  l_chat  VARCHAR2(40);
  l_enc1  RAW(2000);
  l_enc2  RAW(2000);
BEGIN
  INSERT INTO prod.atd_user_credential (username, fusion_login, tg_chat_id, updated_by)
  VALUES ('__62_selftest__', 'selftest@example.com', '12345', '__62_selftest__');
  prod.atd_cred_pkg.set_password('__62_selftest__', 'S3cret!x');
  SELECT fusion_pwd_enc INTO l_enc1 FROM prod.atd_user_credential WHERE username = '__62_selftest__';
  prod.atd_cred_pkg.set_password('__62_selftest__', 'S3cret!x');
  SELECT fusion_pwd_enc INTO l_enc2 FROM prod.atd_user_credential WHERE username = '__62_selftest__';
  IF UTL_RAW.COMPARE(l_enc1, l_enc2) = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, '62 selftest: IV not random (identical ciphertext)');
  END IF;
  prod.atd_cred_pkg.resolve_runner_cred('__62_selftest__', l_login, l_pwd, l_chat);
  IF l_pwd IS NULL OR l_pwd <> 'S3cret!x' OR l_login <> 'selftest@example.com' THEN
    RAISE_APPLICATION_ERROR(-20001, '62 selftest: decrypt round-trip failed');
  END IF;
  -- catalog-path owner resolution (case-insensitive, owner beats requested_by)
  prod.atd_cred_pkg.resolve_job_cred('/users/SelfTest@Example.com/Data/X', NULL,
                                     l_login, l_pwd, l_chat);
  IF l_login <> 'selftest@example.com' OR l_pwd <> 'S3cret!x' THEN
    RAISE_APPLICATION_ERROR(-20001, '62 selftest: job path-owner resolution failed');
  END IF;
  prod.atd_cred_pkg.resolve_job_cred('/shared/Data/X', '__62_selftest__',
                                     l_login, l_pwd, l_chat);
  IF l_login <> 'selftest@example.com' THEN
    RAISE_APPLICATION_ERROR(-20001, '62 selftest: requested_by fallback failed');
  END IF;
  UPDATE prod.atd_user_credential SET is_active = 'N' WHERE username = '__62_selftest__';
  prod.atd_cred_pkg.resolve_runner_cred('__62_selftest__', l_login, l_pwd, l_chat);
  IF l_pwd IS NOT NULL THEN
    RAISE_APPLICATION_ERROR(-20001, '62 selftest: inactive row must resolve NULL');
  END IF;
  DELETE FROM prod.atd_user_credential WHERE username = '__62_selftest__';
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('62 selftest: PASS');
END;
/

SET ECHO OFF
PROMPT otbi-atd 62 per-user OTBI credentials : done
