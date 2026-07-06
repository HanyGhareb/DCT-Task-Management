-- =============================================================================
-- sso_plsql_unit.sql  --  standalone assert harness for PROD.DCT_SSO_PKG
-- (db/v2/41). Run as ADMIN via SQLcl. Flips FEATURE_SSO_HANDOFF for the
-- duration of the run and restores the original value at the end.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    l_orig    VARCHAR2(10);
    l_code    VARCHAR2(64);
    l_code2   VARCHAR2(64);
    l_uname   VARCHAR2(100);
    l_pass    PLS_INTEGER := 0;
    l_fail    PLS_INTEGER := 0;
    l_ok      BOOLEAN;

    PROCEDURE t (p_name VARCHAR2, p_cond BOOLEAN) IS
    BEGIN
        IF p_cond THEN
            l_pass := l_pass + 1;
            DBMS_OUTPUT.PUT_LINE('PASS  ' || p_name);
        ELSE
            l_fail := l_fail + 1;
            DBMS_OUTPUT.PUT_LINE('FAIL  ' || p_name);
        END IF;
    END;

    PROCEDURE set_gate (p_val VARCHAR2) IS
    BEGIN
        UPDATE prod.dct_system_settings
        SET    setting_value = p_val
        WHERE  setting_key = 'FEATURE_SSO_HANDOFF';
        COMMIT;
    END;
BEGIN
    SELECT setting_value INTO l_orig
    FROM   prod.dct_system_settings
    WHERE  setting_key = 'FEATURE_SSO_HANDOFF';
    DBMS_OUTPUT.PUT_LINE('original gate = ' || l_orig);

    -- pre-clean leftovers from any aborted earlier run
    DELETE FROM prod.dct_sso_codes WHERE issued_session_id = 'unit-test-session';
    COMMIT;

    -- ── 1. gate OFF blocks issue and redeem ────────────────────────────────
    set_gate('N');
    BEGIN
        l_code := prod.dct_sso_pkg.issue_code('ADMIN', 'JET2APEX');
        t('gate N: issue_code raises -20403', FALSE);
    EXCEPTION WHEN OTHERS THEN
        t('gate N: issue_code raises -20403', SQLCODE = -20403);
    END;
    BEGIN
        l_uname := prod.dct_sso_pkg.redeem_code('deadbeef', 'JET2APEX');
        t('gate N: redeem_code raises -20403', FALSE);
    EXCEPTION WHEN OTHERS THEN
        t('gate N: redeem_code raises -20403', SQLCODE = -20403);
    END;

    -- ── 2. issue: shape + hashed at rest ────────────────────────────────────
    set_gate('Y');
    l_code := prod.dct_sso_pkg.issue_code('ADMIN', 'JET2APEX', 'unit-test-session');
    t('issue: 64-hex code', LENGTH(l_code) = 64 AND REGEXP_LIKE(l_code, '^[0-9A-F]{64}$'));
    DECLARE l_n NUMBER; BEGIN
        SELECT COUNT(*) INTO l_n FROM prod.dct_sso_codes WHERE code_hash = l_code;
        t('issue: clear code is NOT stored (hash at rest)', l_n = 0);
        SELECT COUNT(*) INTO l_n FROM prod.dct_sso_codes
        WHERE  username = 'ADMIN' AND direction = 'JET2APEX'
          AND  issued_session_id = 'unit-test-session' AND used_at IS NULL;
        t('issue: hashed row present', l_n = 1);
    END;

    -- ── 3. peek is non-consuming ────────────────────────────────────────────
    t('peek: resolves username', prod.dct_sso_pkg.peek_username(l_code) = 'ADMIN');
    t('peek: still valid after peek (non-consuming)',
      prod.dct_sso_pkg.peek_username(l_code) = 'ADMIN');
    t('peek: unknown code returns NULL', prod.dct_sso_pkg.peek_username('deadbeef') IS NULL);

    -- ── 4. direction binding: wrong direction does NOT consume ─────────────
    BEGIN
        l_uname := prod.dct_sso_pkg.redeem_code(l_code, 'APEX2JET');
        t('redeem: wrong direction raises -20401', FALSE);
    EXCEPTION WHEN OTHERS THEN
        t('redeem: wrong direction raises -20401', SQLCODE = -20401);
    END;
    t('redeem: wrong direction did not burn the code',
      prod.dct_sso_pkg.peek_username(l_code) = 'ADMIN');

    -- ── 5. redeem happy path + single use ───────────────────────────────────
    t('redeem: JET2APEX returns username',
      prod.dct_sso_pkg.redeem_code(l_code, 'JET2APEX') = 'ADMIN');
    BEGIN
        l_uname := prod.dct_sso_pkg.redeem_code(l_code, 'JET2APEX');
        t('redeem: second use raises -20401', FALSE);
    EXCEPTION WHEN OTHERS THEN
        t('redeem: second use raises -20401', SQLCODE = -20401);
    END;

    -- ── 6. expiry ───────────────────────────────────────────────────────────
    l_code2 := prod.dct_sso_pkg.issue_code('ADMIN', 'APEX2JET');
    UPDATE prod.dct_sso_codes
    SET    expires_at = SYSTIMESTAMP - INTERVAL '1' MINUTE
    WHERE  username = 'ADMIN' AND direction = 'APEX2JET' AND used_at IS NULL;
    COMMIT;
    BEGIN
        l_uname := prod.dct_sso_pkg.redeem_code(l_code2, 'APEX2JET');
        t('redeem: expired code raises -20401', FALSE);
    EXCEPTION WHEN OTHERS THEN
        t('redeem: expired code raises -20401', SQLCODE = -20401);
    END;

    -- ── 7. dct_auth.authenticate SSO$ sentinel (JET -> APEX path) ──────────
    l_code2 := prod.dct_sso_pkg.issue_code('ADMIN', 'JET2APEX');
    l_ok := prod.dct_auth.authenticate('ADMIN', 'SSO$' || l_code2);
    t('authenticate: SSO$<valid code> returns TRUE', l_ok);
    l_ok := prod.dct_auth.authenticate('ADMIN', 'SSO$' || l_code2);
    t('authenticate: replayed code returns FALSE', NOT l_ok);
    l_ok := prod.dct_auth.authenticate('ADMIN', 'SSO$garbage');
    t('authenticate: SSO$garbage returns FALSE', NOT l_ok);

    -- ── 8. username binding: code issued for A cannot log in B ─────────────
    l_code2 := prod.dct_sso_pkg.issue_code('ADMIN', 'JET2APEX');
    l_ok := prod.dct_auth.authenticate('NASER.ALKHAJA', 'SSO$' || l_code2);
    t('authenticate: code for ADMIN rejected for another user (and burned)', NOT l_ok);

    -- ── 9. issue for unknown user ───────────────────────────────────────────
    BEGIN
        l_code2 := prod.dct_sso_pkg.issue_code('NO_SUCH_USER_XYZ', 'JET2APEX');
        t('issue: unknown user raises -20404', FALSE);
    EXCEPTION WHEN OTHERS THEN
        t('issue: unknown user raises -20404', SQLCODE = -20404);
    END;

    -- ── 10. invalid direction rejected by lookup-first validation ──────────
    BEGIN
        l_code2 := prod.dct_sso_pkg.issue_code('ADMIN', 'SIDEWAYS');
        t('issue: invalid direction raises -20090', FALSE);
    EXCEPTION WHEN OTHERS THEN
        t('issue: invalid direction raises -20090', SQLCODE = -20090);
    END;

    -- restore + cleanup unit-test rows
    set_gate(l_orig);
    DELETE FROM prod.dct_sso_codes WHERE issued_session_id = 'unit-test-session';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('PASS=' || l_pass || '  FAIL=' || l_fail ||
                         '  (gate restored to ' || l_orig || ')');
    IF l_fail > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, l_fail || ' unit test(s) failed');
    END IF;
END;
/
