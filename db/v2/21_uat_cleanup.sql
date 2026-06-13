-- =============================================================================
-- UAT artifact housekeeping (enh-8) -- rerunnable, run after UAT rounds
-- File : 21_uat_cleanup.sql
-- Run  : sql -name prod_mcp @21_uat_cleanup.sql
-- What it does (safe by construction -- deactivates, never deletes users):
--   1. Park stray FL-runner users (uat.auto.<ts>@example.com) inactive
--   2. Park the canonical disposables (UAT.AUTOTEST1/PWDTEST/INACTIVE1)
--   3. Close any still-open sessions of those users
--   4. Drop UAT_WAVE_FLOW archived versions + their steps (engines match
--      exact code, the archives exist only because each WAV pass activates)
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON

-- 23ai auto-parallel can deadlock its own PX servers on small-table DML
ALTER SESSION DISABLE PARALLEL DML;
ALTER SESSION DISABLE PARALLEL QUERY;

DECLARE
  l_n NUMBER;
BEGIN
  UPDATE prod.dct_users
  SET    is_active = 'N', deactivated_at = SYSTIMESTAMP, updated_by = 'UAT_CLEANUP'
  WHERE (LOWER(username) LIKE 'uat.auto.%' OR LOWER(email) LIKE 'uat.auto.%@example.com'
         OR UPPER(username) IN ('UAT.AUTOTEST1','UAT.PWDTEST','UAT.INACTIVE1'))
    AND  is_active = 'Y';
  l_n := SQL%ROWCOUNT;
  DBMS_OUTPUT.put_line('users parked inactive ......... ' || l_n);

  UPDATE prod.dct_sessions
  SET    is_active = 'N', logout_at = SYSTIMESTAMP
  WHERE  is_active = 'Y'
    AND (LOWER(username) LIKE 'uat.auto.%'
         OR UPPER(username) IN ('UAT.AUTOTEST1','UAT.PWDTEST','UAT.INACTIVE1'));
  DBMS_OUTPUT.put_line('uat sessions closed ........... ' || SQL%ROWCOUNT);

  COMMIT;   -- park/close progress sticks even if the deletes hit a snag

  DELETE FROM prod.dct_approval_steps
  WHERE  template_id IN (SELECT template_id FROM prod.dct_approval_templates
                         WHERE template_code LIKE 'UAT_WAVE_FLOW~V%');
  DBMS_OUTPUT.put_line('archived UAT_WAVE steps gone .. ' || SQL%ROWCOUNT);

  DELETE FROM prod.dct_approval_templates
  WHERE  template_code LIKE 'UAT_WAVE_FLOW~V%';
  DBMS_OUTPUT.put_line('archived UAT_WAVE versions .... ' || SQL%ROWCOUNT);

  COMMIT;
END;
/

PROMPT remaining UAT_WAVE_FLOW rows (live + optional draft are expected):
SELECT template_id, template_code, is_active, version_no
FROM   prod.dct_approval_templates
WHERE  template_code LIKE 'UAT_WAVE_FLOW%'
ORDER  BY template_id;
