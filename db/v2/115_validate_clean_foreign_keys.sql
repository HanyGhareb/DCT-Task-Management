-- =============================================================================
-- i-Finance — validate six clean legacy foreign keys
--
-- The data-integrity monitor confirmed zero orphan rows on 2026-08-04. These
-- constraints were ENABLED NOVALIDATE, so new writes were protected but Oracle
-- had not verified the pre-existing rows. Additive and rerunnable.
-- =============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

DECLARE
  PROCEDURE validate_fk(p_table_name VARCHAR2, p_constraint_name VARCHAR2) IS
    l_validated VARCHAR2(13);
  BEGIN
    SELECT validated
      INTO l_validated
      FROM dba_constraints
     WHERE owner = 'PROD'
       AND table_name = UPPER(p_table_name)
       AND constraint_name = UPPER(p_constraint_name)
       AND constraint_type = 'R';

    IF l_validated <> 'VALIDATED' THEN
      EXECUTE IMMEDIATE
        'ALTER TABLE prod.' || DBMS_ASSERT.SIMPLE_SQL_NAME(p_table_name) ||
        ' ENABLE VALIDATE CONSTRAINT ' ||
        DBMS_ASSERT.SIMPLE_SQL_NAME(p_constraint_name);
      DBMS_OUTPUT.PUT_LINE('Validated ' || p_constraint_name);
    ELSE
      DBMS_OUTPUT.PUT_LINE('Already validated: ' || p_constraint_name);
    END IF;
  END validate_fk;
BEGIN
  validate_fk('DT_COUNTRY_GROUPS',    'FK_DT_CG_COUNTRY');
  validate_fk('DT_DESTINATIONS',      'FK_DT_DEST_COUNTRY');
  validate_fk('DT_DOCUMENTS',         'FK_DT_DOC_TYPE');
  validate_fk('DT_REQUESTS',          'FK_DT_REQ_GL');
  validate_fk('DCT_FL_FREELANCERS',   'FK_DCT_FLFREELANCER_NAT');
  validate_fk('DCT_FL_REGISTRATIONS', 'FK_DCT_FLREG_NAT');
END;
/

BEGIN
  prod.dct_integrity_pkg.run_integrity_check('DEPLOY_115');
END;
/

PROMPT === Verification ===
SELECT table_name, constraint_name, status, validated
  FROM dba_constraints
 WHERE owner = 'PROD'
   AND constraint_name IN (
     'FK_DT_CG_COUNTRY', 'FK_DT_DEST_COUNTRY', 'FK_DT_DOC_TYPE',
     'FK_DT_REQ_GL', 'FK_DCT_FLFREELANCER_NAT', 'FK_DCT_FLREG_NAT'
   )
 ORDER BY table_name;

SELECT integrity_status, constraint_warnings, orphan_rows, duplicate_groups,
       checked_by, checked_at
  FROM prod.dct_integrity_state
 WHERE state_id = 1;

PROMPT db/v2/115 foreign-key validation complete.
EXIT
