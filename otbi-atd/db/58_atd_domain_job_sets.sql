-- Domain-based schedules for every enabled job not already assigned to PRPO_PENDING.
-- Rerunnable: preserves an existing set's operator-edited schedule and never moves a
-- job that has subsequently been assigned to another set.
SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
ALTER SESSION DISABLE PARALLEL DML;

DECLARE
  PROCEDURE add_set(
    p_code VARCHAR2, p_name VARCHAR2, p_comments VARCHAR2,
    p_preset VARCHAR2, p_freq NUMBER, p_start VARCHAR2, p_end VARCHAR2
  ) IS
  BEGIN
    INSERT INTO prod.atd_job_set
      (set_code, name_en, comments, active, paused, interval_preset,
       frequency_minutes, daily_start, daily_end, notify_on_failure,
       created_at, created_by)
    SELECT p_code, p_name, p_comments, 'Y', 'N', p_preset,
           p_freq, p_start, p_end, 'Y', SYSTIMESTAMP, 'CODEX'
      FROM dual
     WHERE NOT EXISTS (SELECT 1 FROM prod.atd_job_set WHERE set_code = p_code);
  END;

  PROCEDURE add_member(
    p_set VARCHAR2, p_job VARCHAR2, p_order NUMBER
  ) IS
    l_enabled prod.atd_otbi_jobs.enabled%TYPE;
    l_existing prod.atd_job_set_member.set_code%TYPE;
  BEGIN
    SELECT enabled INTO l_enabled
      FROM prod.atd_otbi_jobs
     WHERE job_name = p_job;
    IF l_enabled <> 'Y' THEN
      raise_application_error(-20010, 'Refusing disabled job: ' || p_job);
    END IF;

    BEGIN
      SELECT set_code INTO l_existing
        FROM prod.atd_job_set_member
       WHERE job_name = p_job;
      IF l_existing <> p_set THEN
        raise_application_error(-20011,
          p_job || ' already belongs to ' || l_existing || ', not ' || p_set);
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        INSERT INTO prod.atd_job_set_member
          (job_name, set_code, enabled_in_set, member_order, added_at, added_by)
        VALUES (p_job, p_set, 'Y', p_order, SYSTIMESTAMP, 'CODEX');
    END;
  END;
BEGIN
  add_set('TXN_INCREMENTAL', 'Hourly Transaction Incrementals',
    'Hourly MERGE refreshes for PR, PO, AP and project-budget changes.',
    'HOURLY', 60, NULL, NULL);
  add_set('GL_COA_DAILY', 'GL and COA Daily Full',
    'Daily refresh of the chart-of-accounts combinations and segment reference lists.',
    'DAILY', 1440, '00:30', '02:30');
  add_set('HR_DAILY', 'HR Reference Data Daily Full',
    'Daily refresh of persons, phones and grades.',
    'DAILY', 1440, '01:30', '03:30');
  add_set('PROJECTS_DAILY', 'Projects Daily Full',
    'Daily refresh of projects, tasks and project-budget periods.',
    'DAILY', 1440, '02:30', '04:30');
  add_set('PROCUREMENT_DAILY', 'Procurement Daily Full',
    'Daily full refresh of requisition and purchase-order headers, lines, schedules and distributions.',
    'DAILY', 1440, '03:30', '05:30');
  add_set('PAYABLES_DAILY', 'Payables Daily Full',
    'Daily full refresh of AP invoices, invoice lines and distributions.',
    'DAILY', 1440, '04:30', '06:30');
  add_set('GL_GRN_DAILY', 'GL Balances and GRN Daily Full',
    'Daily refresh of GL balances and goods-received data.',
    'DAILY', 1440, '05:30', '07:30');

  add_member('TXN_INCREMENTAL', 'PR Headers Incremental', 10);
  add_member('TXN_INCREMENTAL', 'PR Lines Incremental', 20);
  add_member('TXN_INCREMENTAL', 'PO Headers Incremental', 30);
  add_member('TXN_INCREMENTAL', 'AP Invoices Incremental', 40);
  add_member('TXN_INCREMENTAL', 'AP Invoice Lines Incremental', 50);
  add_member('TXN_INCREMENTAL', 'AP Distributions Incremental', 60);
  add_member('TXN_INCREMENTAL', 'Projects Budget Incremental', 70);

  add_member('GL_COA_DAILY', 'GL_ACCOUNTS_COMBINATIONS', 10);
  add_member('GL_COA_DAILY', 'GL_ACCOUNT_LIST', 20);
  add_member('GL_COA_DAILY', 'GL_APPROPRIATION_LIST', 30);
  add_member('GL_COA_DAILY', 'GL_BUDGET_GROUP_LIST', 40);
  add_member('GL_COA_DAILY', 'GL_COST_CENTERS_LIST', 50);
  add_member('GL_COA_DAILY', 'GL_COST_ENTITY_SPECIFIC_LI', 60);
  add_member('GL_COA_DAILY', 'GL_ENTITY_CODES_LIST', 70);
  add_member('GL_COA_DAILY', 'GL_FUTURE1_LIST', 80);
  add_member('GL_COA_DAILY', 'GL_FUTURE2_LIST', 90);
  add_member('GL_COA_DAILY', 'GL_INTERCOMPANY_LIST', 100);
  add_member('GL_COA_DAILY', 'GL_PROGRAM_LIST', 110);

  add_member('HR_DAILY', 'Persons', 10);
  add_member('HR_DAILY', 'Person Phones', 20);
  add_member('HR_DAILY', 'HR Grades', 30);

  add_member('PROJECTS_DAILY', 'Projects Full', 10);
  add_member('PROJECTS_DAILY', 'Tasks Full', 20);
  add_member('PROJECTS_DAILY', 'Projects Budget Full', 30);

  add_member('PROCUREMENT_DAILY', 'PR Headers Full', 10);
  add_member('PROCUREMENT_DAILY', 'PR Lines All', 20);
  add_member('PROCUREMENT_DAILY', 'PR Distributions Full', 30);
  add_member('PROCUREMENT_DAILY', 'PO Headers Full', 40);
  add_member('PROCUREMENT_DAILY', 'PO Lines Full', 50);
  add_member('PROCUREMENT_DAILY', 'PO Schedules Full', 60);
  add_member('PROCUREMENT_DAILY', 'PO Distributions Full', 70);

  add_member('PAYABLES_DAILY', 'AP Invoices Full', 10);
  add_member('PAYABLES_DAILY', 'AP Invoice Lines Full', 20);
  add_member('PAYABLES_DAILY', 'AP Distributions Full', 30);

  add_member('GL_GRN_DAILY', 'GL Balances', 10);
  add_member('GL_GRN_DAILY', 'GRN Temporary Job', 20);

  COMMIT;
  dbms_output.put_line('Created/verified seven domain job sets with 36 members.');
END;
/

SELECT s.set_code, s.name_en, s.frequency_minutes, s.daily_start, s.daily_end,
       COUNT(m.job_name) members
  FROM prod.atd_job_set s
  LEFT JOIN prod.atd_job_set_member m ON m.set_code = s.set_code
 GROUP BY s.set_code, s.name_en, s.frequency_minutes, s.daily_start, s.daily_end
 ORDER BY s.daily_start NULLS FIRST, s.set_code;

EXIT
