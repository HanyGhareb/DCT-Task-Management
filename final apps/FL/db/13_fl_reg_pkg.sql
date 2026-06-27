-- =============================================================================
-- Freelancers Module (App 203) -- Phase 1 -- Registration helper package
-- File    : 13_fl_reg_pkg.sql
-- Schema  : PROD
-- Run     : After 12_fl_ai_pkg.sql. Own SQLcl session.
-- Purpose : DCT_FL_REG_PKG -- duplicate detection + admin override for the
--           revamped registration flow.
--             find_duplicates(reg_id)      -> JSON {hasExact, exact[], fuzzy[]}
--             add_duplicate_override(reg,u) -> FL_ADMIN clears a fuzzy flag
--           Duplicate keys: Emirates ID / passport / email / bank IBAN (EXACT);
--           same normalised name + date of birth (FUZZY). Scans both the
--           pending registrations and the approved freelancers master.
-- =============================================================================

SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON

CREATE OR REPLACE PACKAGE prod.dct_fl_reg_pkg AS
    -- JSON: {"hasExact":bool,"exact":[{type,id,ref,name,matchedOn}],"fuzzy":[...]}
    FUNCTION find_duplicates (p_registration_id IN NUMBER) RETURN CLOB;

    -- FL_ADMIN override of a fuzzy duplicate flag (sets dup_status OVERRIDDEN).
    PROCEDURE add_duplicate_override (p_registration_id IN NUMBER, p_user_id IN NUMBER);

    -- ---- Public self-registration email OTP ---------------------------------
    -- Generate + email a 6-digit code for the address (rate-limited). When the
    -- gated DEV switch REG_OTP_DEV_ECHO='Y' (default N), the plaintext code is
    -- returned in p_dev_code so testing can proceed without a live SMTP relay.
    -- p_dev_code is ALWAYS NULL unless that switch is on -> safe in production.
    PROCEDURE start_public_registration (p_email     IN  VARCHAR2,
                                         p_dev_code  OUT VARCHAR2);
    -- Validate the code; on success returns a 64-hex intake token (else raises).
    FUNCTION  verify_public_otp (p_email IN VARCHAR2, p_code IN VARCHAR2) RETURN VARCHAR2;
    -- Token helpers used by the unauthenticated /reg/public/:token handlers.
    FUNCTION  public_email (p_token IN VARCHAR2) RETURN VARCHAR2;            -- NULL if invalid/expired
    FUNCTION  public_registration_id (p_token IN VARCHAR2) RETURN NUMBER;
    PROCEDURE set_public_registration (p_token IN VARCHAR2, p_registration_id IN NUMBER);
END dct_fl_reg_pkg;
/

CREATE OR REPLACE PACKAGE BODY prod.dct_fl_reg_pkg AS

    FUNCTION nname (p_in IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN REGEXP_REPLACE(UPPER(NVL(p_in,' ')), '[^A-Z0-9]', '');
    END nname;

    PROCEDURE jrow (p_arr IN OUT NOCOPY CLOB, p_first IN OUT BOOLEAN,
                    p_type VARCHAR2, p_id NUMBER, p_ref VARCHAR2,
                    p_name VARCHAR2, p_on VARCHAR2) IS
        v VARCHAR2(2000);
    BEGIN
        v := CASE WHEN p_first THEN '' ELSE ',' END
          || '{"type":'    || APEX_JSON.STRINGIFY(p_type)
          || ',"id":'      || NVL(TO_CHAR(p_id),'null')
          || ',"ref":'     || APEX_JSON.STRINGIFY(p_ref)
          || ',"name":'    || APEX_JSON.STRINGIFY(p_name)
          || ',"matchedOn":' || APEX_JSON.STRINGIFY(p_on) || '}';
        DBMS_LOB.WRITEAPPEND(p_arr, LENGTH(v), v);
        p_first := FALSE;
    END jrow;

    FUNCTION find_duplicates (p_registration_id IN NUMBER) RETURN CLOB IS
        v_reg    prod.dct_fl_registrations%ROWTYPE;
        v_exact  CLOB;
        v_fuzzy  CLOB;
        v_out    CLOB;
        v_ef     BOOLEAN := TRUE;   -- first exact
        v_ff     BOOLEAN := TRUE;   -- first fuzzy
        v_nid    VARCHAR2(50);
        v_pp     VARCHAR2(50);
        v_em     VARCHAR2(200);
        v_iban   VARCHAR2(34);
        v_name   VARCHAR2(400);
    BEGIN
        SELECT * INTO v_reg FROM prod.dct_fl_registrations
        WHERE registration_id = p_registration_id;

        v_nid  := NULLIF(REGEXP_REPLACE(v_reg.national_id,'[^0-9]',''), '');
        v_pp   := NULLIF(UPPER(v_reg.passport_number), '');
        v_em   := LOWER(v_reg.email);
        v_iban := NULLIF(UPPER(REGEXP_REPLACE(v_reg.bank_iban,'[^A-Z0-9]','')), '');
        v_name := nname(v_reg.first_name_en || v_reg.last_name_en);

        DBMS_LOB.CREATETEMPORARY(v_exact, TRUE);
        DBMS_LOB.CREATETEMPORARY(v_fuzzy, TRUE);

        -- ---- EXACT: approved freelancers --------------------------------------
        FOR r IN (
            SELECT f.freelancer_id, f.vendor_number, f.email,
                   f.first_name_en, f.last_name_en, f.national_id, f.passport_number,
                   CASE WHEN v_nid IS NOT NULL AND REGEXP_REPLACE(f.national_id,'[^0-9]','') = v_nid THEN 'Emirates ID'
                        WHEN v_pp  IS NOT NULL AND UPPER(f.passport_number) = v_pp           THEN 'Passport'
                        WHEN LOWER(f.email) = v_em                                            THEN 'Email'
                        WHEN v_iban IS NOT NULL AND EXISTS (
                             SELECT 1 FROM prod.dct_fl_bank_accounts b
                             WHERE b.freelancer_id = f.freelancer_id
                             AND UPPER(REGEXP_REPLACE(b.iban,'[^A-Z0-9]','')) = v_iban) THEN 'Bank IBAN'
                   END AS matched_on
            FROM   prod.dct_fl_freelancers f
            WHERE  f.status != 'BLACKLISTED'
            AND (  (v_nid IS NOT NULL AND REGEXP_REPLACE(f.national_id,'[^0-9]','') = v_nid)
                OR (v_pp  IS NOT NULL AND UPPER(f.passport_number) = v_pp)
                OR (LOWER(f.email) = v_em)
                OR (v_iban IS NOT NULL AND EXISTS (
                       SELECT 1 FROM prod.dct_fl_bank_accounts b
                       WHERE b.freelancer_id = f.freelancer_id
                       AND UPPER(REGEXP_REPLACE(b.iban,'[^A-Z0-9]','')) = v_iban)) )
        ) LOOP
            jrow(v_exact, v_ef, 'FREELANCER', r.freelancer_id,
                 NVL(r.vendor_number,'(no vendor #)'),
                 r.first_name_en||' '||r.last_name_en, r.matched_on);
        END LOOP;

        -- ---- EXACT: other pending registrations -------------------------------
        FOR r IN (
            SELECT g.registration_id, g.registration_number, g.email,
                   g.first_name_en, g.last_name_en,
                   CASE WHEN v_nid IS NOT NULL AND REGEXP_REPLACE(g.national_id,'[^0-9]','') = v_nid THEN 'Emirates ID'
                        WHEN v_pp  IS NOT NULL AND UPPER(g.passport_number) = v_pp           THEN 'Passport'
                        WHEN LOWER(g.email) = v_em                                            THEN 'Email'
                        WHEN v_iban IS NOT NULL AND UPPER(REGEXP_REPLACE(g.bank_iban,'[^A-Z0-9]','')) = v_iban THEN 'Bank IBAN'
                   END AS matched_on
            FROM   prod.dct_fl_registrations g
            WHERE  g.registration_id != p_registration_id
            AND    g.status NOT IN ('REJECTED')
            AND (  (v_nid IS NOT NULL AND REGEXP_REPLACE(g.national_id,'[^0-9]','') = v_nid)
                OR (v_pp  IS NOT NULL AND UPPER(g.passport_number) = v_pp)
                OR (LOWER(g.email) = v_em)
                OR (v_iban IS NOT NULL AND UPPER(REGEXP_REPLACE(g.bank_iban,'[^A-Z0-9]','')) = v_iban) )
        ) LOOP
            jrow(v_exact, v_ef, 'REGISTRATION', r.registration_id, r.registration_number,
                 r.first_name_en||' '||r.last_name_en, r.matched_on);
        END LOOP;

        -- ---- FUZZY: same normalised name + DOB, no exact id match -------------
        FOR r IN (
            SELECT f.freelancer_id AS id, f.vendor_number AS ref,
                   f.first_name_en, f.last_name_en
            FROM   prod.dct_fl_freelancers f
            WHERE  f.status != 'BLACKLISTED'
            AND    f.date_of_birth = v_reg.date_of_birth
            AND    REGEXP_REPLACE(UPPER(f.first_name_en||f.last_name_en),'[^A-Z0-9]','') = v_name
            AND    NOT (v_nid IS NOT NULL AND REGEXP_REPLACE(f.national_id,'[^0-9]','') = v_nid)
            AND    NOT (v_pp  IS NOT NULL AND UPPER(f.passport_number) = v_pp)
            AND    LOWER(f.email) != v_em
        ) LOOP
            jrow(v_fuzzy, v_ff, 'FREELANCER', r.id, NVL(r.ref,'(no vendor #)'),
                 r.first_name_en||' '||r.last_name_en, 'Same name + date of birth');
        END LOOP;

        -- ---- assemble envelope ------------------------------------------------
        DBMS_LOB.CREATETEMPORARY(v_out, TRUE);
        DECLARE
            v_has VARCHAR2(5) := CASE WHEN v_ef THEN 'false' ELSE 'true' END;
            v_h   VARCHAR2(200);
        BEGIN
            v_h := '{"hasExact":'||v_has||',"exact":[';
            DBMS_LOB.WRITEAPPEND(v_out, LENGTH(v_h), v_h);
            IF DBMS_LOB.GETLENGTH(v_exact) > 0 THEN DBMS_LOB.APPEND(v_out, v_exact); END IF;
            DBMS_LOB.WRITEAPPEND(v_out, 11, '],"fuzzy":[');
            IF DBMS_LOB.GETLENGTH(v_fuzzy) > 0 THEN DBMS_LOB.APPEND(v_out, v_fuzzy); END IF;
            DBMS_LOB.WRITEAPPEND(v_out, 2, ']}');
        END;
        RETURN v_out;
    END find_duplicates;

    PROCEDURE add_duplicate_override (p_registration_id IN NUMBER, p_user_id IN NUMBER) IS
    BEGIN
        UPDATE prod.dct_fl_registrations
        SET    dup_status        = 'OVERRIDDEN',
               dup_overridden_by = p_user_id,
               dup_overridden_at = SYSTIMESTAMP,
               updated_at        = SYSTIMESTAMP
        WHERE  registration_id = p_registration_id;
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20404, 'Registration not found.');
        END IF;
        BEGIN
            prod.dct_audit.log(
                p_action      => 'FL_DUP_OVERRIDE',
                p_object_type => 'DCT_FL_REGISTRATIONS',
                p_object_id   => TO_CHAR(p_registration_id),
                p_module_code => 'FREELANCERS');
        EXCEPTION WHEN OTHERS THEN NULL; END;
        COMMIT;
    END add_duplicate_override;

    -- ---- Public self-registration email OTP ---------------------------------
    FUNCTION setting (p_key VARCHAR2, p_def VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN NVL(prod.dct_fl_pkg.get_setting(p_key), p_def);
    END setting;

    FUNCTION hash_code (p_email VARCHAR2, p_code VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN RAWTOHEX(DBMS_CRYPTO.HASH(
            UTL_I18N.STRING_TO_RAW(LOWER(p_email) || ':' || p_code, 'AL32UTF8'),
            DBMS_CRYPTO.HASH_SH256));
    END hash_code;

    FUNCTION rnd_token RETURN VARCHAR2 IS
    BEGIN
        RETURN RAWTOHEX(DBMS_CRYPTO.RANDOMBYTES(32));
    END rnd_token;

    PROCEDURE send_otp_email (p_email VARCHAR2, p_code VARCHAR2) IS
    BEGIN
        -- Best-effort delivery via APEX_MAIL. Requires the instance email (SMTP)
        -- settings to be configured; if unavailable the code is still stored and
        -- delivery can be wired to any provider later.
        APEX_MAIL.SEND(
            p_to   => p_email,
            p_from => NVL(setting('PORTAL_FROM_EMAIL','no-reply@dct.gov.ae'), 'no-reply@dct.gov.ae'),
            p_subj => 'Your freelancer registration verification code',
            p_body => 'Your verification code is: ' || p_code || CHR(10)
                   || 'It expires in ' || setting('REG_OTP_EXPIRY_MIN','15') || ' minutes.');
        APEX_MAIL.PUSH_QUEUE;
    EXCEPTION WHEN OTHERS THEN NULL;
    END send_otp_email;

    PROCEDURE start_public_registration (p_email     IN  VARCHAR2,
                                         p_dev_code  OUT VARCHAR2) IS
        v_recent NUMBER;
        v_code   VARCHAR2(6);
        v_hash   VARCHAR2(128);
        v_exp    NUMBER := TO_NUMBER(setting('REG_OTP_EXPIRY_MIN','15'));
    BEGIN
        p_dev_code := NULL;
        IF p_email IS NULL
           OR NOT REGEXP_LIKE(p_email, '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$') THEN
            RAISE_APPLICATION_ERROR(-20001, 'A valid email address is required.');
        END IF;

        -- Rate limit: max 3 codes per email in the last 10 minutes.
        -- DB is UTC; use SYSDATE (no TZ) to avoid TIMESTAMP-vs-TZ session skew.
        SELECT COUNT(*) INTO v_recent FROM prod.dct_fl_reg_otp
        WHERE  LOWER(email) = LOWER(p_email)
        AND    created_at > SYSDATE - (10/1440);
        IF v_recent >= 3 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Too many verification requests. Try again later.');
        END IF;

        -- Invalidate previous pending codes for this email.
        UPDATE prod.dct_fl_reg_otp SET status = 'EXPIRED'
        WHERE  LOWER(email) = LOWER(p_email) AND status = 'PENDING';

        v_code := LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(0, 1000000))), 6, '0');
        v_hash := hash_code(p_email, v_code);
        INSERT INTO prod.dct_fl_reg_otp (email, code_hash, status, attempts, expires_at)
        VALUES (LOWER(p_email), v_hash, 'PENDING', 0, SYSDATE + (v_exp/1440));
        COMMIT;

        send_otp_email(p_email, v_code);

        -- DEV-only: echo the plaintext code back to the caller (gated, default N).
        IF NVL(setting('REG_OTP_DEV_ECHO','N'),'N') = 'Y' THEN
            p_dev_code := v_code;
        END IF;
    END start_public_registration;

    FUNCTION verify_public_otp (p_email IN VARCHAR2, p_code IN VARCHAR2) RETURN VARCHAR2 IS
        v_id    NUMBER;
        v_hash  VARCHAR2(128);
        v_att   NUMBER;
        v_max   NUMBER := TO_NUMBER(setting('REG_OTP_MAX_ATTEMPTS','5'));
        v_token VARCHAR2(64);
    BEGIN
        BEGIN
            SELECT otp_id, code_hash, attempts INTO v_id, v_hash, v_att
            FROM   prod.dct_fl_reg_otp
            WHERE  LOWER(email) = LOWER(p_email) AND status = 'PENDING'
            AND    expires_at > SYSDATE
            ORDER BY otp_id DESC FETCH FIRST 1 ROW ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No valid verification code. Request a new one.');
        END;

        IF v_att >= v_max THEN
            UPDATE prod.dct_fl_reg_otp SET status = 'LOCKED' WHERE otp_id = v_id;
            COMMIT;
            RAISE_APPLICATION_ERROR(-20001, 'Too many attempts. Request a new code.');
        END IF;

        IF v_hash != hash_code(p_email, p_code) THEN
            UPDATE prod.dct_fl_reg_otp SET attempts = attempts + 1 WHERE otp_id = v_id;
            COMMIT;
            RAISE_APPLICATION_ERROR(-20001, 'Incorrect verification code.');
        END IF;

        v_token := rnd_token;
        UPDATE prod.dct_fl_reg_otp
        SET    status = 'VERIFIED', verified_at = SYSTIMESTAMP, intake_token = v_token
        WHERE  otp_id = v_id;
        COMMIT;
        RETURN v_token;
    END verify_public_otp;

    -- Verified token stays valid for 24h after verification.
    FUNCTION public_email (p_token IN VARCHAR2) RETURN VARCHAR2 IS
        v_email VARCHAR2(200);
    BEGIN
        IF p_token IS NULL THEN RETURN NULL; END IF;
        SELECT email INTO v_email FROM prod.dct_fl_reg_otp
        WHERE  intake_token = p_token AND status = 'VERIFIED'
        AND    verified_at > SYSDATE - 1;
        RETURN v_email;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END public_email;

    FUNCTION public_registration_id (p_token IN VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT registration_id INTO v_id FROM prod.dct_fl_reg_otp
        WHERE  intake_token = p_token AND status = 'VERIFIED';
        RETURN v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END public_registration_id;

    PROCEDURE set_public_registration (p_token IN VARCHAR2, p_registration_id IN NUMBER) IS
    BEGIN
        UPDATE prod.dct_fl_reg_otp SET registration_id = p_registration_id
        WHERE  intake_token = p_token AND status = 'VERIFIED';
    END set_public_registration;

END dct_fl_reg_pkg;
/

SHOW ERRORS PACKAGE prod.dct_fl_reg_pkg
SHOW ERRORS PACKAGE BODY prod.dct_fl_reg_pkg

PROMPT === 13_fl_reg_pkg.sql complete ===
