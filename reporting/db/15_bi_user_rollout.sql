-- =============================================================================
-- i-Finance V2 -- Reporting Platform : 15 BI_USER rollout helper
-- File   : reporting/db/15_bi_user_rollout.sql
-- Schema : PROD (dct_user_roles assignments)
-- Run as : sql -name prod_mcp
-- Purpose: grant the BI_USER role (Interactive Report viewer, App 211) to a
--          list of business users in one idempotent pass. EDIT THE LIST in
--          section 1 -- one username per SELECT line -- then run the script.
--          A user who already holds an active BI_USER assignment is skipped;
--          a user who is missing or inactive in DCT_USERS is reported and
--          skipped. Rerunnable at any time. Assignments can also be managed
--          one-by-one in Admin (App 200) -> Roles -> BI Report User.
-- CRLF + UTF-8 no BOM.
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1 + 2. grant BI_USER to the listed users (idempotent) ===
DECLARE
  TYPE t_list IS TABLE OF VARCHAR2(100);
  -- ── EDIT ME: usernames to grant BI_USER to ────────────────────────────
  l_users t_list := t_list(
    'NASER.ALKHAJA'
  );
  -- ──────────────────────────────────────────────────────────────────────
  l_role_id NUMBER;
  l_user_id NUMBER;
  l_active  VARCHAR2(1);
  l_has     NUMBER;
  l_granted PLS_INTEGER := 0;
  l_skipped PLS_INTEGER := 0;
BEGIN
  SELECT role_id INTO l_role_id FROM prod.dct_roles WHERE role_code = 'BI_USER';
  FOR i IN 1 .. l_users.COUNT LOOP
    BEGIN
      SELECT user_id, is_active INTO l_user_id, l_active
        FROM prod.dct_users WHERE UPPER(username) = UPPER(TRIM(l_users(i)));
    EXCEPTION WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('SKIP  ' || l_users(i) || ' -- no such user in DCT_USERS');
      l_skipped := l_skipped + 1;
      CONTINUE;
    END;
    IF l_active <> 'Y' THEN
      DBMS_OUTPUT.PUT_LINE('SKIP  ' || l_users(i) || ' -- user is inactive');
      l_skipped := l_skipped + 1;
      CONTINUE;
    END IF;
    SELECT COUNT(*) INTO l_has
      FROM prod.dct_user_roles
     WHERE user_id = l_user_id AND role_id = l_role_id
       AND is_active = 'Y'
       AND (end_date IS NULL OR end_date > SYSDATE);
    IF l_has > 0 THEN
      DBMS_OUTPUT.PUT_LINE('OK    ' || l_users(i) || ' -- already holds BI_USER');
      l_skipped := l_skipped + 1;
      CONTINUE;
    END IF;
    INSERT INTO prod.dct_user_roles
      (user_id, role_id, start_date, is_active, assigned_by, reason, created_by, updated_by)
    VALUES
      (l_user_id, l_role_id, SYSDATE, 'Y', 'SYSTEM',
       'BI_USER rollout -- Interactive Report viewer access (reporting/db/15)',
       'SYSTEM', 'SYSTEM');
    l_granted := l_granted + 1;
    DBMS_OUTPUT.PUT_LINE('GRANT ' || l_users(i) || ' -- BI_USER assigned');
  END LOOP;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('granted: ' || l_granted || '  skipped: ' || l_skipped);
END;
/

PROMPT === 3. current BI_USER holders ===
SELECT u.username, u.display_name,
       TO_CHAR(ur.start_date, 'YYYY-MM-DD') AS start_dt,
       NVL(TO_CHAR(ur.end_date, 'YYYY-MM-DD'), '-') AS end_dt
  FROM prod.dct_user_roles ur
  JOIN prod.dct_users u ON u.user_id = ur.user_id
  JOIN prod.dct_roles r ON r.role_id = ur.role_id
 WHERE r.role_code = 'BI_USER'
   AND ur.is_active = 'Y'
   AND (ur.end_date IS NULL OR ur.end_date > SYSDATE)
 ORDER BY u.username;

PROMPT ============================================================
PROMPT  15_bi_user_rollout.sql complete.
PROMPT ============================================================
