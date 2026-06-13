-- =============================================================================
-- 09_fl_portal.sql - Freelancer Self-Service Portal, Phase 1 (DB layer)
-- Schema  : PROD (run as ADMIN via SQLcl: sql -name prod_mcp)
-- Rerunnable. Run in its own fresh session (creates an ADMIN synonym at the end).
-- =============================================================================
-- Portal identity is DELIBERATELY separate from DCT_USERS: staff ORDS handlers
-- across all modules authorise on "any valid staff session", so external
-- freelancers must never hold one. Portal credentials live on the freelancer
-- row; portal sessions live in DCT_FL_PORTAL_SESSIONS and are only honoured
-- by /fl/portal/* handlers.
-- =============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE

-- -----------------------------------------------------------------------------
-- 1. Freelancer columns: portal credential + lifecycle
-- -----------------------------------------------------------------------------
DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM dba_tab_cols
  WHERE owner = 'PROD' AND table_name = 'DCT_FL_FREELANCERS' AND column_name = 'PORTAL_PASSWORD_HASH';
  IF l_n = 0 THEN
    EXECUTE IMMEDIATE q'!ALTER TABLE prod.dct_fl_freelancers ADD (
      portal_password_hash VARCHAR2(200),
      portal_status        VARCHAR2(20) DEFAULT 'NOT_INVITED' NOT NULL
    )!';
    DBMS_OUTPUT.put_line('dct_fl_freelancers: portal columns added');
  ELSE
    DBMS_OUTPUT.put_line('dct_fl_freelancers: portal columns already present');
  END IF;
END;
/

COMMENT ON COLUMN prod.dct_fl_freelancers.portal_status IS
  'Portal lifecycle - lookup FL_PORTAL_STATUS (NOT_INVITED/INVITED/ACTIVE/DISABLED). Lookup-first: no CHECK constraint.';

-- -----------------------------------------------------------------------------
-- 2. Portal invites + sessions
-- -----------------------------------------------------------------------------
DECLARE
  l_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_n FROM dba_tables WHERE owner = 'PROD' AND table_name = 'DCT_FL_PORTAL_INVITES';
  IF l_n = 0 THEN
    EXECUTE IMMEDIATE q'!CREATE TABLE prod.dct_fl_portal_invites (
      invite_id     NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      freelancer_id NUMBER        NOT NULL,
      token         VARCHAR2(64)  NOT NULL,
      expires_at    TIMESTAMP     NOT NULL,
      used_at       TIMESTAMP,
      created_by    VARCHAR2(100) NOT NULL,
      created_at    TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      CONSTRAINT uq_dct_flpi_token UNIQUE (token),
      CONSTRAINT fk_dct_flpi_frl FOREIGN KEY (freelancer_id)
        REFERENCES prod.dct_fl_freelancers(freelancer_id)
    )!';
    DBMS_OUTPUT.put_line('dct_fl_portal_invites created');
  END IF;

  SELECT COUNT(*) INTO l_n FROM dba_tables WHERE owner = 'PROD' AND table_name = 'DCT_FL_PORTAL_SESSIONS';
  IF l_n = 0 THEN
    EXECUTE IMMEDIATE q'!CREATE TABLE prod.dct_fl_portal_sessions (
      session_id       VARCHAR2(64)  PRIMARY KEY,
      freelancer_id    NUMBER        NOT NULL,
      created_at       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      last_activity_at TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
      expires_at       TIMESTAMP     NOT NULL,
      is_active        VARCHAR2(1)   DEFAULT 'Y' NOT NULL,
      CONSTRAINT chk_dct_flps_act CHECK (is_active IN ('Y','N')),
      CONSTRAINT fk_dct_flps_frl FOREIGN KEY (freelancer_id)
        REFERENCES prod.dct_fl_freelancers(freelancer_id)
    )!';
    EXECUTE IMMEDIATE 'CREATE INDEX prod.ix_dct_flps_frl ON prod.dct_fl_portal_sessions(freelancer_id)';
    DBMS_OUTPUT.put_line('dct_fl_portal_sessions created');
  END IF;
END;
/

-- -----------------------------------------------------------------------------
-- 3. Lookup category FL_PORTAL_STATUS (lookup-first rule)
-- -----------------------------------------------------------------------------
DECLARE
  v_module_id NUMBER;
  v_cat       NUMBER;
  PROCEDURE upsert_value (p_cat NUMBER, p_code VARCHAR2, p_en VARCHAR2, p_ar VARCHAR2, p_ord NUMBER) IS
  BEGIN
    MERGE INTO prod.dct_lookup_values tgt
    USING (SELECT p_cat AS category_id, p_code AS value_code FROM dual) src
    ON (tgt.category_id = src.category_id AND tgt.value_code = src.value_code)
    WHEN NOT MATCHED THEN
      INSERT (category_id, value_code, value_name_en, value_name_ar, display_order, is_active)
      VALUES (p_cat, p_code, p_en, p_ar, p_ord, 'Y');
  END;
BEGIN
  SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'FREELANCERS';

  MERGE INTO prod.dct_lookup_categories tgt
  USING (SELECT 'FL_PORTAL_STATUS' AS category_code FROM dual) src
  ON (tgt.category_code = src.category_code)
  WHEN NOT MATCHED THEN
    INSERT (category_code, category_name_en, category_name_ar, module_id, is_system, is_active)
    VALUES ('FL_PORTAL_STATUS', 'Freelancer Portal Status', 'حالة بوابة المستقل', v_module_id, 'N', 'Y');
  SELECT category_id INTO v_cat FROM prod.dct_lookup_categories WHERE category_code = 'FL_PORTAL_STATUS';

  upsert_value(v_cat, 'NOT_INVITED', 'Not Invited', 'لم تتم الدعوة', 1);
  upsert_value(v_cat, 'INVITED',     'Invited',     'مدعو',          2);
  upsert_value(v_cat, 'ACTIVE',      'Active',      'نشط',           3);
  upsert_value(v_cat, 'DISABLED',    'Disabled',    'معطل',          4);
  COMMIT;
  DBMS_OUTPUT.put_line('FL_PORTAL_STATUS lookup seeded');
END;
/

-- -----------------------------------------------------------------------------
-- 4. Module settings (Function 7 / portal)
-- -----------------------------------------------------------------------------
DECLARE
  v_module_id NUMBER;
  PROCEDURE upsert_setting (p_key VARCHAR2, p_val VARCHAR2, p_label VARCHAR2,
                            p_desc VARCHAR2, p_type VARCHAR2, p_allow VARCHAR2, p_def VARCHAR2) IS
  BEGIN
    MERGE INTO prod.dct_module_settings s
    USING (SELECT v_module_id AS module_id, p_key AS setting_key FROM dual) src
    ON (s.module_id = src.module_id AND s.setting_key = src.setting_key)
    WHEN NOT MATCHED THEN
      INSERT (module_id, setting_key, setting_value, setting_label,
              setting_description, value_type, allowed_values, default_value, effective_date)
      VALUES (v_module_id, p_key, p_val, p_label, p_desc, p_type, p_allow, p_def, SYSDATE);
  END;
BEGIN
  SELECT module_id INTO v_module_id FROM prod.dct_modules WHERE module_code = 'FREELANCERS';
  upsert_setting('FEATURE_FL_PORTAL', 'N',
    'Freelancer Portal Enabled',
    'Y = the external freelancer self-service portal accepts logins. Kill switch for /fl/portal/*.',
    'BOOLEAN', 'Y|N', 'N');
  upsert_setting('PORTAL_SESSION_HOURS', '12',
    'Portal Session Lifetime (hours)',
    'Portal sessions expire this many hours after login.',
    'NUMBER', NULL, '12');
  upsert_setting('PORTAL_INVITE_EXPIRY_HOURS', '72',
    'Portal Invite Expiry (hours)',
    'Set-password invitation links expire after this many hours.',
    'NUMBER', NULL, '72');
  COMMIT;
  DBMS_OUTPUT.put_line('Portal settings seeded');
END;
/

-- -----------------------------------------------------------------------------
-- 5. DCT_FL_PORTAL_PKG - portal auth + scoping
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE prod.dct_fl_portal_pkg AS

  -- Staff side: invalidates previous unused invites, returns a fresh token.
  FUNCTION create_invite (p_freelancer_id IN NUMBER,
                          p_created_by    IN VARCHAR2) RETURN VARCHAR2;

  -- Public: consume an invite token, set the password, activate the portal account.
  PROCEDURE set_password (p_token IN VARCHAR2, p_password IN VARCHAR2);

  -- Public: e-mail + password -> session token (NULL on any failure).
  FUNCTION login (p_email IN VARCHAR2, p_password IN VARCHAR2) RETURN VARCHAR2;

  -- Handlers: session token -> freelancer_id (NULL if invalid/expired/disabled).
  FUNCTION validate (p_token IN VARCHAR2) RETURN NUMBER;

  -- Handlers: read the Bearer token from the request and validate it.
  FUNCTION validate_bearer RETURN NUMBER;

  PROCEDURE logout (p_token IN VARCHAR2);

END dct_fl_portal_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_fl_portal_pkg AS

  FUNCTION hash_password (p_plain IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    -- platform convention (dct_auth): SHA-512 hex
    RETURN RAWTOHEX(DBMS_CRYPTO.HASH(
             UTL_I18N.STRING_TO_RAW(p_plain, 'AL32UTF8'), DBMS_CRYPTO.HASH_SH512));
  END;

  FUNCTION new_token RETURN VARCHAR2 IS
  BEGIN
    RETURN LOWER(RAWTOHEX(DBMS_CRYPTO.RANDOMBYTES(32)));
  END;

  FUNCTION setting_num (p_key IN VARCHAR2, p_default IN NUMBER) RETURN NUMBER IS
    l_v VARCHAR2(100);
  BEGIN
    l_v := prod.dct_fl_pkg.get_setting(p_key);
    RETURN NVL(TO_NUMBER(l_v DEFAULT NULL ON CONVERSION ERROR), p_default);
  END;

  FUNCTION create_invite (p_freelancer_id IN NUMBER,
                          p_created_by    IN VARCHAR2) RETURN VARCHAR2 IS
    l_email  prod.dct_fl_freelancers.email%TYPE;
    l_status prod.dct_fl_freelancers.status%TYPE;
    l_token  VARCHAR2(64) := new_token;
    l_exp    TIMESTAMP;
  BEGIN
    -- body-only functions may not appear inside SQL (PLS-00231) - precompute
    l_exp := SYSTIMESTAMP + NUMTODSINTERVAL(setting_num('PORTAL_INVITE_EXPIRY_HOURS', 72), 'HOUR');
    SELECT email, status INTO l_email, l_status
    FROM prod.dct_fl_freelancers WHERE freelancer_id = p_freelancer_id;
    IF l_status != 'ACTIVE' THEN
      RAISE_APPLICATION_ERROR(-20081, 'Freelancer must be ACTIVE to be invited to the portal');
    END IF;
    IF l_email IS NULL THEN
      RAISE_APPLICATION_ERROR(-20082, 'Freelancer has no e-mail address on file');
    END IF;

    UPDATE prod.dct_fl_portal_invites
    SET expires_at = SYSTIMESTAMP
    WHERE freelancer_id = p_freelancer_id AND used_at IS NULL AND expires_at > SYSTIMESTAMP;

    INSERT INTO prod.dct_fl_portal_invites (freelancer_id, token, expires_at, created_by)
    VALUES (p_freelancer_id, l_token, l_exp, p_created_by);

    UPDATE prod.dct_fl_freelancers
    SET portal_status = CASE WHEN portal_status = 'ACTIVE' THEN 'ACTIVE' ELSE 'INVITED' END
    WHERE freelancer_id = p_freelancer_id;
    RETURN l_token;
  END create_invite;

  PROCEDURE set_password (p_token IN VARCHAR2, p_password IN VARCHAR2) IS
    l_frl  NUMBER;
    l_hash VARCHAR2(200);
  BEGIN
    IF p_password IS NULL OR LENGTH(p_password) < 8 THEN
      RAISE_APPLICATION_ERROR(-20083, 'Password must be at least 8 characters');
    END IF;
    l_hash := hash_password(p_password);
    BEGIN
      SELECT freelancer_id INTO l_frl
      FROM prod.dct_fl_portal_invites
      WHERE token = p_token AND used_at IS NULL AND expires_at > SYSTIMESTAMP;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20084, 'This invitation link is invalid or has expired');
    END;
    UPDATE prod.dct_fl_portal_invites SET used_at = SYSTIMESTAMP WHERE token = p_token;
    UPDATE prod.dct_fl_freelancers
    SET portal_password_hash = l_hash, portal_status = 'ACTIVE'
    WHERE freelancer_id = l_frl;
    -- a password reset invalidates every open session for the account
    UPDATE prod.dct_fl_portal_sessions SET is_active = 'N' WHERE freelancer_id = l_frl;
  END set_password;

  FUNCTION login (p_email IN VARCHAR2, p_password IN VARCHAR2) RETURN VARCHAR2 IS
    l_frl   NUMBER;
    l_token VARCHAR2(64);
    l_hash  VARCHAR2(200);
    l_exp   TIMESTAMP;
  BEGIN
    l_hash := hash_password(p_password);
    l_exp  := SYSTIMESTAMP + NUMTODSINTERVAL(setting_num('PORTAL_SESSION_HOURS', 12), 'HOUR');
    SELECT freelancer_id INTO l_frl
    FROM prod.dct_fl_freelancers
    WHERE LOWER(email) = LOWER(TRIM(p_email))
      AND status = 'ACTIVE'
      AND portal_status = 'ACTIVE'
      AND portal_password_hash = l_hash
      AND ROWNUM = 1;
    l_token := new_token;
    INSERT INTO prod.dct_fl_portal_sessions (session_id, freelancer_id, expires_at)
    VALUES (l_token, l_frl, l_exp);
    RETURN l_token;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  END login;

  FUNCTION validate (p_token IN VARCHAR2) RETURN NUMBER IS
    l_frl NUMBER;
  BEGIN
    IF p_token IS NULL THEN RETURN NULL; END IF;
    SELECT s.freelancer_id INTO l_frl
    FROM prod.dct_fl_portal_sessions s
    JOIN prod.dct_fl_freelancers f ON f.freelancer_id = s.freelancer_id
    WHERE s.session_id = p_token
      AND s.is_active = 'Y'
      AND s.expires_at > SYSTIMESTAMP
      AND f.status = 'ACTIVE'
      AND f.portal_status = 'ACTIVE';
    UPDATE prod.dct_fl_portal_sessions
    SET last_activity_at = SYSTIMESTAMP WHERE session_id = p_token;
    RETURN l_frl;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  END validate;

  FUNCTION validate_bearer RETURN NUMBER IS
    l_hdr VARCHAR2(4000);
  BEGIN
    -- ADB managed ORDS passes the header as 'AUTHORIZATION' (no HTTP_ prefix)
    l_hdr := OWA_UTIL.get_cgi_env('AUTHORIZATION');
    IF l_hdr IS NULL THEN
      l_hdr := OWA_UTIL.get_cgi_env('HTTP_AUTHORIZATION');
    END IF;
    IF l_hdr LIKE 'Bearer %' THEN
      RETURN validate(TRIM(SUBSTR(l_hdr, 8)));
    END IF;
    RETURN NULL;
  EXCEPTION WHEN OTHERS THEN RETURN NULL;
  END validate_bearer;

  PROCEDURE logout (p_token IN VARCHAR2) IS
  BEGIN
    UPDATE prod.dct_fl_portal_sessions SET is_active = 'N' WHERE session_id = p_token;
  END logout;

END dct_fl_portal_pkg;
/

SHOW ERRORS

-- -----------------------------------------------------------------------------
-- 6. ADMIN synonym for the ORDS handlers (this script must NOT have switched
--    CURRENT_SCHEMA earlier in the session - ORA-01471 gotcha)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE SYNONYM dct_fl_portal_pkg FOR prod.dct_fl_portal_pkg;

PROMPT 09_fl_portal.sql complete.
SELECT object_name, status FROM dba_objects
WHERE owner = 'PROD' AND object_name = 'DCT_FL_PORTAL_PKG';
