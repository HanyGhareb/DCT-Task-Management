-- ===========================================================================
-- otbi-atd db/82 : PR number columns NUMBER -> VARCHAR2(20)  (one-time)
--
-- Why: a Fusion requisition literally numbered 'TEMP' (PR_HEADER_ID
-- 300003074482275) rides in every hourly incremental window; the NUMBER
-- columns cannot store it, so the loader NULLs it and Telegrams a drift
-- warning EVERY cycle. User decision 2026-08-18: store PR numbers as text
-- (ATD_PR_LINES.REQUISITION has been VARCHAR2 all along).
--
-- Scope (assessed 2026-08-18, all repo consumers traced): every PR-number
-- column in the ATD layer flips TOGETHER -- the one bare equality join
-- (AP/db/05 prh.pr_number = d.requisition) needs both sides text, all other
-- consumers wrap TO_CHAR() or join on pr_header_id/pr_line_id surrogates.
-- Max stored value is 12 digits -> VARCHAR2(20).
--
-- Finals keep their data (add/copy/drop/rename -- Oracle cannot MODIFY a
-- populated NUMBER to VARCHAR2, ORA-01439). Stage tables are transient:
-- DELETE + MODIFY (next cycle refills them). Afterwards the SELECT *
-- pass-through views must be rebuilt: prod.dct_views_rebuild recreates them
-- and recompiles dependents (deploy must end at 0 INVALID).
--
-- Rerunnable: each block skips a column that is already VARCHAR2.
-- ===========================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

ALTER SESSION SET ddl_lock_timeout = 60;

DECLARE
  PROCEDURE flip_final(p_table VARCHAR2, p_col VARCHAR2) IS
    l_type all_tab_columns.data_type%TYPE;
  BEGIN
    SELECT data_type INTO l_type FROM all_tab_columns
     WHERE owner = 'PROD' AND table_name = p_table AND column_name = p_col;
    IF l_type = 'VARCHAR2' THEN
      dbms_output.put_line(p_table || '.' || p_col || ': already VARCHAR2 - skip');
      RETURN;
    END IF;
    EXECUTE IMMEDIATE 'alter table prod.' || p_table || ' add (' || p_col || '_TMPX varchar2(20))';
    EXECUTE IMMEDIATE 'update prod.' || p_table || ' set ' || p_col || '_TMPX = to_char(' || p_col || ')';
    dbms_output.put_line(p_table || '.' || p_col || ': ' || SQL%ROWCOUNT || ' values copied');
    EXECUTE IMMEDIATE 'alter table prod.' || p_table || ' drop column ' || p_col;
    EXECUTE IMMEDIATE 'alter table prod.' || p_table || ' rename column ' || p_col || '_TMPX to ' || p_col;
    COMMIT;
  END;

  PROCEDURE flip_stage(p_table VARCHAR2, p_col VARCHAR2) IS
    l_type all_tab_columns.data_type%TYPE;
  BEGIN
    SELECT data_type INTO l_type FROM all_tab_columns
     WHERE owner = 'PROD' AND table_name = p_table AND column_name = p_col;
    IF l_type = 'VARCHAR2' THEN
      dbms_output.put_line(p_table || '.' || p_col || ': already VARCHAR2 - skip');
      RETURN;
    END IF;
    EXECUTE IMMEDIATE 'delete from prod.' || p_table;
    EXECUTE IMMEDIATE 'alter table prod.' || p_table || ' modify (' || p_col || ' varchar2(20))';
    COMMIT;
    dbms_output.put_line(p_table || '.' || p_col || ': stage cleared + MODIFY VARCHAR2(20)');
  END;
BEGIN
  flip_final('ATD_PR_HEADERS',                 'PR_NUMBER');
  flip_final('ATD_PR_DISTRIBUTIONS',           'REQUISITION');
  flip_final('ATD_AP_INVOICE_DISTRIBUTIONS',   'REQUISITION');
  flip_final('ATD_PO_DISTRIBUTIONS',           'PR_NUMBER');
  flip_stage('ATD_PR_HEADERS_STG',             'PR_NUMBER');
  flip_stage('ATD_PR_DISTRIBUTIONS_STG',       'REQUISITION');
  flip_stage('ATD_AP_INVOICE_DISTRIBUTIONS_STG','REQUISITION');
  flip_stage('ATD_PO_DISTRIBUTIONS_STG',       'PR_NUMBER');
END;
/

-- rebuild the SELECT * pass-through views + recompile dependents
DECLARE
  l_report  VARCHAR2(4000);
  l_invalid VARCHAR2(4000);
BEGIN
  prod.dct_views_rebuild(l_report, l_invalid);
  dbms_output.put_line('rebuild: ' || SUBSTR(l_report, 1, 500));
  dbms_output.put_line('invalid: ' || NVL(SUBSTR(l_invalid, 1, 500), '(none)'));
END;
/

SELECT COUNT(*) AS invalid_objects
  FROM all_objects WHERE owner = 'PROD' AND status = 'INVALID';

SELECT table_name, column_name, data_type, data_length
  FROM all_tab_columns
 WHERE owner = 'PROD' AND column_name IN ('PR_NUMBER', 'REQUISITION')
   AND table_name LIKE 'ATD%'
 ORDER BY table_name;
