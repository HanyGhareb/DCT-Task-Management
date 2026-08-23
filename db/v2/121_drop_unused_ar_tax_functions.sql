-- =============================================================================
-- i-Finance — remove unused invalid legacy AR tax functions
-- PROD verification on 2026-08-22 found no static dependencies or source calls.
-- The invalid functions contained incomplete PL/SQL and were dropped by user
-- decision.  This script records that PROD change and is safe to rerun.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

BEGIN
  FOR r IN (
    SELECT object_name
      FROM dba_objects
     WHERE owner='PROD'
       AND object_type='FUNCTION'
       AND object_name IN ('AR_TAX_CALC','AR_TAX_CALC_LINE')
  ) LOOP
    EXECUTE IMMEDIATE 'DROP FUNCTION prod.'||DBMS_ASSERT.simple_sql_name(r.object_name);
    DBMS_OUTPUT.put_line('Dropped PROD.'||r.object_name);
  END LOOP;
END;
/

SELECT COUNT(*) remaining_functions
  FROM dba_objects
 WHERE owner='PROD'
   AND object_type='FUNCTION'
   AND object_name IN ('AR_TAX_CALC','AR_TAX_CALC_LINE');

SELECT COUNT(*) invalid_prod_objects
  FROM dba_objects
 WHERE owner='PROD' AND status='INVALID';
EXIT
